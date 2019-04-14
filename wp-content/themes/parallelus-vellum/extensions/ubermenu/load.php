<?php
/*
    Extension Name: UberMenu Lite
    Extension URI:
    Version: 1.0
    Description: A lite version of UberMenu mega menu plugin for WordPress. You can easily upgrade to the full version by installing the plugin (v2.3.0.0 or higher).
    Author: SevenSpark
    Author URI: http://sevenspark.com/
*/

define( 'UBERMENU_LITE_PATH', '/extensions/ubermenu'); // Define local path  (optional, this helps if a symlink is used for the theme folder)

require('ubermenu.lite.php');


// Register preset Ubermenu styles for theme 
function uberMenu_register_theme_styles(){
	ubermenu_registerStylePreset( 'theme-default-styles', 'Theme Default Style', get_stylesheet_directory_uri().'/assets/css/ubermenu.lite.css' );
} 
add_action( 'uberMenu_register_styles', 'uberMenu_register_theme_styles' , 10 , 0 );

// Set theme preset styles as default 
function custom_ubermenu_preset(){
	return 'theme-default-styles';
}
add_filter( 'uberMenu_default_preset' , 'custom_ubermenu_preset' );


// Layout options to auto-apply vertical/horizontal setting for UberMenu
function theme_specific_ubermenu_options() {
	// Create class for custom Uber Menu Lite
	if( class_exists( 'UberMenuLite' ) ) {

		class CustomUberMenuLite extends UberMenuLite {

			public function __construct() {
				parent::__construct();
				$wp_mega_menu_settings = get_option( 'wp-mega-menu-settings' );
				$this->settings->settings = $wp_mega_menu_settings;
			}

			public function set_settings( $layout_style ) {
				$this->settings->settings['wpmega-orientation'] = ( $layout_style == 'boxed-left' || $layout_style == 'full-width-left' || $layout_style == 'boxed-right' || $layout_style == 'full-width-right' ) ? 'vertical' : 'horizontal';
			}

		}
	} else {

		class CustomUberMenuLite extends UberMenu {

			public function __construct() {
				parent::__construct();
				$wp_mega_menu_settings = get_option( 'wp-mega-menu-settings' );
				$this->settings->settings = $wp_mega_menu_settings;
			}

			public function set_settings( $layout_style ) {
				$this->settings->settings['wpmega-orientation'] = ( $layout_style == 'boxed-left' || $layout_style == 'full-width-left' || $layout_style == 'boxed-right' || $layout_style == 'full-width-right' ) ? 'vertical' : 'horizontal';
			}

		}

	}
}

add_action('wp_head', 'theme_specific_ubermenu_options', 200);

?>