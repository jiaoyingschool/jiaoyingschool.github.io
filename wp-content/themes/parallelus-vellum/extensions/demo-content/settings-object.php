<?php

class Demo_Content_Admin_Object extends Runway_Admin_Object {
	
	public $option_key, 
	       $theme_name,
	       $backup_option_key,
	       $backup_index,
	       $backup_options;

	function __construct($settings){
		parent::__construct($settings);

		$this->option_key = $settings['option_key'];
		$theme = wp_get_theme();
		$this->theme_name = sanitize_title($theme->get( 'Name' ));

		// Backup options
		$this->backup_option_key = sanitize_title(THEME_NAME) .'_backup_log';
		$this->backup_options = get_option( $this->backup_option_key );
		$this->backup_index = 'starterkit_backup';

		// Get the backups
		$this->backupLog = $this->get_backup_log();

		// Load actions
		$this->add_actions();

	}

	// Add hooks & crooks
	function add_actions() {

		// Register ajax functions
		add_action('wp_ajax_applyStarterKit', array($this, 'applyStarterKit') );
		add_action('wp_ajax_importThemeContent', array($this, 'importThemeContent') );
				
	}

	// Get the backups data
	public function get_backup_log() {

		// Retrieve the backup log
		$backupOptions = $this->backup_options; //get_option($this->backup_option_key);

		// Get the starter kit backup array, or create the array
		if (!is_array($backupOptions)) {
			$backupOptions = array();
		}
		if (!isset($backupOptions[$this->backup_index])) {
			$backupOptions[$this->backup_index] = array();		
		}

		$backupLog = $backupOptions[$this->backup_index];

		return $backupLog;
	}

	// Create a new backup
	public function create_backup( $backup_data = null ) {

		if (isset($backup_data) && !empty($backup_data)) {
			// Reference ID and timestamp for backup
			$stamp = time();
			$date  = date("F j, Y, g:i a"); // March 10, 2001, 5:16 pm
			$key   = sanitize_title(THEME_NAME)  .'_'. $this->backup_index .'_'. $stamp;
			
			// Save the backup data
			update_option($key, $backup_data);

			// update the backup log
			$backupLog = $this->backup_options;
			$backupLog[$this->backup_index][$key] = $date;

			// Save the backup log entry
			$updated = update_option($this->backup_option_key, $backupLog);

			// Update the backup_options variable
			$this->backup_options = $backupLog;

			return $updated;
		}
	}

	// Delete a backup
	public function delete_backup( $alias = '' ) {

		if (!empty($alias)) {

			$backupID = $alias;

			// get the backup log data
			$backupLog = $this->backup_options;
			
			if (!isset($backupLog[$this->backup_index][$backupID])) {
				
				return false;
			}

			// remove from the backup log
			unset($backupLog[$this->backup_index][$backupID]);
			delete_option($backupID);

			// $backupLog[$this->backup_index][$key] = $date;

			// Save the updated backup log
			$updated = update_option($this->backup_option_key, $backupLog);

			// Update the backup_options variable
			$this->backup_options = $backupLog;

			return true;
		}

		return false;
	}

	// Restore a backup
	public function restore_backup( $alias = '' ) {

		if (!empty($alias)) {

			$backupID = $alias;

			// Get the backup settings
			$backupData = get_option( $backupID );

			// Save the backup data
			if (is_array($backupData)) {
				foreach ($backupData as $option => $data) {
					update_option( $option, $data );
				}
			} else {
				return false;
			}

			// Delete the backup after restore
			$this->delete_backup( $backupID );

			return true;
		}

		return false;
	}

	// Called by AJAX function to activate a kit
	public function applyStarterKit() {
		// Apply the kit
		$apply = $this->apply_kit(); 
		
		// Success / error message
		echo ($apply) ? '1' : '2';

		die();
	}


	// Apply a kit update and demo content install
	public function apply_kit() {

		/**
		 * TODO: 
		 * 
		 * - It will probably be good to always apply the default before a new kit. This way 
		 *   any JSON files that are in one kit and not another get reset to the defaults and 
		 *   you don't get a mix of two different sets of data.
		 */

		$alias    = (isset($_REQUEST['alias']) && !empty($_REQUEST['alias'])) ? sanitize_title($_REQUEST['alias']) : 'default';
		$menuName = (isset($_REQUEST['menu']) && !empty($_REQUEST['menu'])) ? $_REQUEST['menu'] : 'Main Menu';
		$backup   = array();
			
		if($alias != '') {

			$starterkit_dir = get_template_directory() . '/data/starterkits/'.$alias.'/';

			// find kit files
			if ( file_exists( $starterkit_dir ) ) {

				// Get all the JSON files
				$files = $this->getStarterKitFiles( $starterkit_dir, 'json' );
				
				if (isset($files) && !empty($files)) {

					// Make sure the Layout Manager data is processed first
					if (isset($files['layouts_manager'])) {
						$files = array('layouts_manager' => $files['layouts_manager']) + $files;
					}

					// Get each file and apply settings
					foreach ( $files as $key => $file ) {
						$index = $this->theme_name.'_'.$key;
						$value = json_decode( file_get_contents( $file ), true );

						// If this is the Layout Manager data we need to parse it for some information
						if ($key == 'layouts_manager') {
							// find Header and Footer settings to import/backup
							$settings = $this->getLayoutHeadersAndFooters($value);
							if (!empty($settings)) {
								foreach ($settings as $setting_key => $setting_value) {
									$setting_index = $this->theme_name.'_'.$setting_key;
									// get current settings for backup
									$backup[$setting_index] = get_option($setting_index);
									// update new values in database
									update_option($setting_index, $setting_value);
								}
							}
							// Find "other options" to back up from Design Setting fields 
							// We're doing this before we update the Layout Manager field because we want the values from both, new and old.
							$current_other_options = $this->getLayoutOtherOptions(get_option($index));
							$updated_other_options = $this->getLayoutOtherOptions($value);
							$other_options = array_merge((array)$current_other_options, (array)$updated_other_options);
							foreach ($other_options as $option_key => $option_name) {
								$option_index = $this->theme_name.'_other_options_'.$option_key;
								if ( $option_data = get_option($option_index)) {
									// backup up the option
									$backup[$option_index] = $option_data;
									// delete the option (we don't want leftovers!)
									delete_option( $option_index );
								}
							}
						}

						// get current settings for backup
						$backup[$index] = get_option($index);
						// update new values in database
						update_option($index, $value);
					}

					// Save the backup 
					if ( !empty($backup) ) {
						$this->create_backup( $backup );
					}

					// Apply the "extras" like setting home page and UberMenu options
					$this->starterKitExtras( $starterkit_dir . 'demo-extras.php' );

					// Set the front page and posts pages? (filtered by demo-extras.php)
					$frontPage = apply_filters( 'starterkit_frontpage', false );
					$postsPage = apply_filters( 'starterkit_postspage', false );

					if ( (isset($frontPage) && $frontPage) || (isset($postsPage) && $postsPage) ) {

						$frontPageID = 0;
						$postsPageID = 0;

						if (isset($frontPage) && $frontPage) {
							$frontPageID = (!is_numeric($frontPage)) ? $this->get_ID_by_slug($frontPage) : $frontPage;
						}

						if (isset($postsPage) && $postsPage) {
							$postsPageID = (!is_numeric($postsPage)) ? $this->get_ID_by_slug($postsPage, 'post') : $postsPage;
						}

						update_option( 'show_on_front', 'page' );
						update_option( 'page_on_front', $frontPageID );
						update_option( 'page_for_posts', $postsPageID );
					}

					// Set menu locations for the theme
					$locations = get_theme_mod('nav_menu_locations');
					$menus     = wp_get_nav_menus();
					if(!empty($menus)) {
						foreach($menus as $menu) {
							if(is_object($menu) && $menu->name == $menuName) {
								$locations['primary'] = $menu->term_id;
								$menuTermID = $menu->term_id; // save for later
							}
						}
					}
					set_theme_mod('nav_menu_locations', $locations);

					// Setup UberMenu item meta options. (can be filtered using demo-extras.php)
					if (isset($menuTermID) && !empty($menuTermID)) {
						$menu_items = wp_get_nav_menu_items($menuTermID);

						foreach ( (array) $menu_items as $key => $menu_item ) {
							$title = $menu_item->title;
							$hasParent = $menu_item->menu_item_parent;
							if ($hasParent) {
								// a generic default
								$default_uber_options = 'a:14:{s:19:"menu-item-shortcode";s:0:"";s:18:"menu-item-sidebars";s:0:"";s:19:"menu-item-highlight";s:3:"off";s:16:"menu-item-notext";s:3:"off";s:16:"menu-item-nolink";s:3:"off";s:18:"menu-item-isheader";s:3:"off";s:26:"menu-item-verticaldivision";s:3:"off";s:16:"menu-item-newcol";s:3:"off";s:16:"menu-item-isMega";s:2:"on";s:22:"menu-item-alignSubmenu";s:6:"center";s:20:"menu-item-floatRight";s:3:"off";s:19:"menu-item-fullWidth";s:3:"off";s:17:"menu-item-numCols";s:4:"auto";s:14:"menu-item-icon";s:17:"fa fa-angle-right";}';
								// get a custom one if set (usually in the "extras" PHP file)
								$uber_meta = apply_filters( 'default_uber_options', $default_uber_options );
								// set the ubermenu meta if not already set
								add_post_meta( $menu_item->ID, '_uber_options', maybe_unserialize( $uber_meta, true ), true );
							} else {
								// a generic default for top level menu items
								$parent_uber_options = 'a:14:{s:19:"menu-item-shortcode";s:0:"";s:18:"menu-item-sidebars";s:0:"";s:19:"menu-item-highlight";s:3:"off";s:16:"menu-item-notext";s:3:"off";s:16:"menu-item-nolink";s:3:"off";s:18:"menu-item-isheader";s:3:"off";s:26:"menu-item-verticaldivision";s:3:"off";s:16:"menu-item-newcol";s:3:"off";s:16:"menu-item-isMega";s:2:"on";s:22:"menu-item-alignSubmenu";s:5:"right";s:20:"menu-item-floatRight";s:3:"off";s:19:"menu-item-fullWidth";s:3:"off";s:17:"menu-item-numCols";s:4:"auto";s:14:"menu-item-icon";s:0:"";}';
								// get a custom one if set (usually in the "extras" PHP file)
								$parent_uber_meta = apply_filters( 'parent_uber_options', $parent_uber_options );
								// set the ubermenu meta if not already set
								add_post_meta( $menu_item->ID, '_uber_options', maybe_unserialize( $parent_uber_meta, true ), true );
							}
						}
					}

					// All done.
					return true;
				}
			}
		}

		return false;
	}


	// Imports demo content with AJAX function
	public function importThemeContent() {

		if (!is_user_logged_in() || !current_user_can('import')) {
			echo '3';
			die();
		}

		// Get the specific demo content file required
		$alias = (isset($_REQUEST['alias']) && !empty($_REQUEST['alias'])) ? sanitize_title($_REQUEST['alias']) : 'default';
		$menuName = (isset($_REQUEST['menu']) && !empty($_REQUEST['menu'])) ? $_REQUEST['menu'] : 'Main Menu';
		$kitPath = get_template_directory() . '/data/starterkits/'.$alias.'/';
		$files = $this->getStarterKitFiles( $kitPath, 'xml' );

		// let's see if there is anyting to import
		if (isset($files) && !empty($files)) {
		
			// See if we have a menu included version and if it's already been imported
			if ( isset($files['demo-content-and-menu']) && !is_array(term_exists(sanitize_title($menuName),'nav_menu')) ) {
				// import the menu version so remove content only file
				unset($files['demo-content']); 
			} else if ( isset($files['demo-content']) ) {
				// don't need the menu version
				unset($files['demo-content-and-menu']);
			}

			// Include the importer
			if ( !defined('WP_LOAD_IMPORTERS') ) define('WP_LOAD_IMPORTERS', true);
			require_once('inc/wordpress-importer/wordpress-importer.php');

			// Perform the imports
			foreach ($files as $key => $file) {

				// start the importer
				$wp_import = new WP_Import();
				$wp_import->fetch_attachments = true;
				$wp_import->import($file);

			}

			// Apply the "extras" like information for setting up the home page, etc...
			$this->starterKitExtras( $kitPath . 'demo-extras.php' );

			// Success message - Useless because it comes at the end of the demo content info dump :(
			echo '1';

		} else {
			echo '2';
		}

		die();
	}

	// Get the optional custom PHP file with kit specific extra settings or functions
	public function starterKitExtras( $file = '' ) {

		if ( isset($file) && !empty($file) && file_exists($file) ) {
			
			// Include the extras file
			require_once($file);

		}
	}

	// Get the saved Header and Footer settings from the Layout Manager data to be imported 
	public function getLayoutHeadersAndFooters( $layoutsData = false ) {

		// See if we have any headers or footers
		if ( isset($layoutsData) ) {
			$allSettings = array();
			$allSettings['headers'] = (isset($layoutsData['headers']) && !empty($layoutsData['headers']) ) ? $layoutsData['headers'] : array();
			$allSettings['footers'] = (isset($layoutsData['footers']) && !empty($layoutsData['footers']) ) ? $layoutsData['footers'] : array();

			$settings = array();
			foreach ($allSettings as $values) {
				if ( !empty($values) ) {
					foreach ($values as $items) {
						if ( isset($items['custom_options']['_framework']) && !empty($items['custom_options']['_framework']) ) {
							$data = $items['custom_options']['_framework'];
							$index = $data['index'];
							// Remove unnecessary keys
							unset($data['index']);
							unset($data['ancestor_key']);
							unset($data['version_key']);
							unset($data['import_key']);
							// Add the settings to the array
							$settings[$index] = $data;
						}
					}
				}

			}

			return $settings;
		}

		return false;
	}

	// Get the Layout "other options" from the Design Settings fields of the layout
	public function getLayoutOtherOptions( $layoutsData = false ) {

		// See if we have any headers or footers
		if ( isset($layoutsData) && isset($layoutsData['layouts']) && !empty($layoutsData['layouts'])) {

			$layouts = array();
			foreach ($layoutsData['layouts'] as $id => $settings) {
					$layouts[$id] = (isset($settings['title'])) ? $settings['title'] : '';
			}

			return $layouts;
		}

		return false;
	}

	// Get the starter kit import files
	public function getStarterKitFiles( $dir = false, $ext = 'json' ) {

		if ( isset($dir) && $dir && file_exists($dir) ) {
			
			// Get all the files in the directory
			$files = array_diff( (array)scandir( $dir ), array( '.', '..' ) );
						
			// See if we have files			
			if (isset($files) && !empty($files)) {

				// Check for a specific extension
				if ( isset($ext) && !empty($ext) ) {

					$ext = '.'.$ext;     // the extension
					$theFiles = array(); // setup the new array

					foreach ( $files as $file ) {
						if (substr($file, -strlen($ext)) === $ext) {

							$key = str_replace( $ext, '', $file ); // file name as key
							$file = $dir.$file; // full file path

							if ( file_exists( $file ) ) {
								// Add the file to the return array
								$theFiles[$key] = $file;
							} 						
						}
					}

					return $theFiles; // return requested files

				} else {

					return $files; // return all if no extension specified
				}
			}
		}

		return false;
	}

	// Get the page/post ID from a slug
	function get_ID_by_slug($slug, $post_type = 'page') {
		// Find the page object (works for any post type)
		$page = get_page_by_path( $slug, 'OBJECT', $post_type );
		if ($page) {
			return $page->ID;
		} else {
			return null;
		}
	}

	// Outputs the kit preview and apply buttons
	public function displayStarterKit( $name = '', $alias = '', $menu = '', $image = '' ) {
		echo 
		'<div class="starterkit" tabindex="0">'.
			'<div class="starterkit-screenshot">'.
				'<div class="img-container">'.
					'<img src="'. $image .'" alt="">'.
				'</div>'.
				'<img src="'. FRAMEWORK_URL .'extensions/demo-content/images/starter-kit-overlay.png" alt="" class="img-overlay">'.
			'</div>'.
			'<h3 class="starterkit-name">'. $name .'</h3>'.
			'<div class="starterkit-actions">'.
				'<a class="button apply-kit" data-alias="'.$alias.'" data-menu="'.$menu.'" href="'. wp_nonce_url( $this->self_url('default', array('action'=>'apply-kit', 'alias'=>$alias)), 'starter_kit') .'">'. __('Apply', 'framework') .'</a>'.
				' &nbsp; '.
				'<a class="button button-primary apply-kit-with-content" data-alias="'.$alias.'" data-menu="'.$menu.'" href="'. wp_nonce_url( $this->self_url('default', array('action'=>'apply-kit-with-content', 'alias'=>$alias)), 'starter_kit') .'">'. __('Apply with Demo Content', 'framework') .'</a>'.
			'</div>'.
		'</div>';
	}

} 

?>