
<div id="DemoImportNotice" class="updated below-h2" style="display:none">
	<p class="loading"><span class="spinner"></span><span><?php _e('Importing data... This may take a few minutes.', 'framework') ?></span></p>
	<p class="response-1"><?php _e('Import completed successfully!', 'framework'); ?></p>
	<p class="response-2"><?php _e("Sorry, we couldn't do the import. Please try the WordPress import plugin to manually import the XML file. (/data/starterkits/{folder}/demo-content.xml)", 'framework'); ?></p>
	<p class="response-3"><?php _e('Sorry, only administrators can import data.', 'framework'); ?></p>
</div>

<div id="KitActivateNotice" class="updated below-h2" style="display:none">
	<p class="loading"><span class="spinner"></span><span><?php _e('Activating kit...', 'framework') ?></span></p>
	<p class="response-1"><?php printf( __("Success! The starter kit has been applied. Start customizing your theme from the %s Theme Options %s page.", 'framework'), '<a href="'.admin_url().'themes.php?page=options-page">', '</a>'); ?></p>
	<p class="response-2"><?php _e("Hmmm... There seems to have been a problem and the starter kit couldn't be applied.", 'framework'); ?></p>
</div>

<?php
if (isset($message) && !empty($message)) {

	$message_class = (isset($message_class) && !empty($message_class)) ? $message_class : 'updated';
	?>
	<div class="<?php echo $message_class; ?> below-h2">
		<p><?php echo $message; ?></p>
	</div>
	<?php
}
?>



<p><?php _e('Applying a starter kit helps get a site running quickly. Each starter kit includes settings for theme options, layouts, sidebars, menus and site content specific to the selected design.', 'framework'); ?></9>
<br>


<h3><?php _e('Design Starter Kits', 'framework'); ?></h3>
<br>

<div class="starterkit-browser rendered starter-kits">
	<div class="starterkits">



		<?php 

		/**
		 * TODO:
		 *
		 * Future development would be much better to define this list automatically by pulling a list of the directories in the starterkit area and generating
		 * this based on that data. The details for the name and manu name and all that can be included in the "demo-extras.php" file, which could become a more
		 * appropriately named file such as "demo.php" or "setup.php" and then we can make this a lot more automated and easier to maintain.
		 * 
		 */

		// Default
		$kit = 'Default';
		$demo_content_admin->displayStarterKit( $kit, sanitize_title($kit), 'Main Menu', get_template_directory_uri().'/data/starterkits/'.sanitize_title($kit).'/screenshot.png' );

		// Business
		$kit = 'Business';
		$demo_content_admin->displayStarterKit( $kit, sanitize_title($kit), 'Main Menu', get_template_directory_uri().'/data/starterkits/'.sanitize_title($kit).'/screenshot.png' );

		// Resort
		$kit = 'Resort';
		$demo_content_admin->displayStarterKit( $kit, sanitize_title($kit), 'Home Page - Resort', get_template_directory_uri().'/data/starterkits/'.sanitize_title($kit).'/screenshot.png' );

		// Real Estate
		$kit = 'Real Estate';
		$demo_content_admin->displayStarterKit( $kit, sanitize_title($kit), 'Real Estate', get_template_directory_uri().'/data/starterkits/'.sanitize_title($kit).'/screenshot.png' );

		// Creative
		$kit = 'Creative';
		$demo_content_admin->displayStarterKit( $kit, sanitize_title($kit), 'Home Page - Portfolio', get_template_directory_uri().'/data/starterkits/'.sanitize_title($kit).'/screenshot.png' );

		// Wedding
		$kit = 'Wedding';
		$demo_content_admin->displayStarterKit( $kit, sanitize_title($kit), 'Wedding', get_template_directory_uri().'/data/starterkits/'.sanitize_title($kit).'/screenshot.png' );

		// Wine
		$kit = 'Wine';
		$demo_content_admin->displayStarterKit( $kit, sanitize_title($kit), 'Main Menu', get_template_directory_uri().'/data/starterkits/'.sanitize_title($kit).'/screenshot.png' );

		// Portfolio
		$kit = 'Portfolio';
		$demo_content_admin->displayStarterKit( $kit, sanitize_title($kit), 'Main Menu', get_template_directory_uri().'/data/starterkits/'.sanitize_title($kit).'/screenshot.png' );

		// Parallax
		$kit = 'Parallax';
		$demo_content_admin->displayStarterKit( $kit, sanitize_title($kit), 'Main Menu', get_template_directory_uri().'/data/starterkits/'.sanitize_title($kit).'/screenshot.png' );

		// Narrow Page
		$kit = 'Narrow Page';
		$demo_content_admin->displayStarterKit( $kit, sanitize_title($kit), 'Main Menu', get_template_directory_uri().'/data/starterkits/'.sanitize_title($kit).'/screenshot.png' );

		// Boxed Left
		$kit = 'Boxed Left';
		$demo_content_admin->displayStarterKit( $kit, sanitize_title($kit), 'Main Menu', get_template_directory_uri().'/data/starterkits/'.sanitize_title($kit).'/screenshot.png' );

		// Video Intro
		$kit = 'Video Intro';
		$demo_content_admin->displayStarterKit( $kit, sanitize_title($kit), 'Main Menu', get_template_directory_uri().'/data/starterkits/'.sanitize_title($kit).'/screenshot.png' );

		?>

	</div><br class="clear">
</div>

<?php 

// Backups list
require_once('backup-list.php');


// text strings used by the JS, added here for translation ?>
<span style="display:none" id="confirm-apply-kit-only-text"><?php _e('Are you sure, you want to apply this starter kit? It will overwrite all Theme Options, Sidebars and Layouts.', 'framework') ?></span>
<span style="display:none" id="confirm-apply-kit-and-content-text"><?php _e('Are you sure, you want to apply this starter kit and import the demo content? It will overwrite your Theme Options, Sidebars and Layouts.', 'framework') ?></span>
<span style="display:none" id="confirm-delete-backup-text"><?php _e('Are you sure you want to delete this backup?', 'framework') ?></span>
<span style="display:none" id="confirm-restore-backup-text"><?php _e('Are you sure you want restore this backup?', 'framework') ?></span>
