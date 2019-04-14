<?php
/**
 * UberMenu Lite
 *
 * A lite version of UberMenu containing the Core functionality of the plugin
 * Can be overridden by the full version by installing the plugin (v2.3.0.0 or higher)
 * 
 */

$uberMenu;
$uberMenu_plugin_present = false;

/*
 * Initialize UberMenu Lite
 */
global $pagenow;
if( is_admin() && $pagenow == 'plugins.php'){
	add_action( 'plugins_loaded' , 'ubermenu_lite_init' );	//on the plugins page, make sure we load later to avoid any nasty sequencing errors
}
else{
	ubermenu_lite_init();
}


/*
 * Wrapped in a function so it can be called in a hook when necessary
 */
function ubermenu_lite_init(){

	global $uberMenu; 

	if( class_exists( 'UberMenuStandard' ) ){
		$uberMenu_plugin_present = true;
	}
	else{
		
		require_once( 'core/ubermenu.core.php' );
		require_once( 'lite/UberMenuLite.class.php' );

		$uberMenu = new UberMenuLite();
	}
}


/*
 * Add Icon functionality for themes using Font Awesome
 */
function ubermenu_icon_class_option( $item_id , $um ){
	$um->showCustomMenuOption(
		'icon', 
		$item_id, 
		array(
			'level' => '0-plus', 
			'title' => __( 'To display the pencil icon, just add <em>icon-pencil</em>' , 'ubermenu' ), 
			'label' => __( 'Icon' , 'ubermenu' ), 
			'type' 	=> 'text', 
		)
	);
}
add_action( 'ubermenu_extended_menu_item_options' , 'ubermenu_icon_class_option', 10, 2 );	//Add icon option

