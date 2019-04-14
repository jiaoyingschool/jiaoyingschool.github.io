<?php
/*
    Extension Name: Demo Content 
    Extension URI:
    Version: 0.1
    Description: Set theme defaults based on a pre-defined styles, import demo content, demo settings and more.
    Author: Parallelus
    Author URI: http://runwaywp.com
    Text Domain:
    Domain Path:
    Network:
    Site Wide Only:

*/

// Settings
$fields = array(
		'var' => array(),
		'array' => array()
);
$default = array();

$settings = array(
	'name' => 'Demo Content',
	'option_key' => 'demo_content',
	'fields' => $fields,
	'default' => $default,
	'parent_menu' => 'appearance',
	'menu_permissions' => 'install_themes',
	'file' => __FILE__,
	'css' => array(
		FRAMEWORK_URL.'extensions/demo-content/css/styles.css'
	),
	'js' => array(
		FRAMEWORK_URL.'extensions/demo-content/js/scripts.js'
	),
);

// Including Sidebar Generator and Sidebar Shortcodes

// Required components
include('object.php');
global $demo_content_settings, $demo_content_admin;
$demo_content_settings = new Demo_Content_Settings_Object($settings);

// Load admin components
if (is_admin()) {
	include('settings-object.php');
	$demo_content_admin = new Demo_Content_Admin_Object($settings);
}

// Helper to redirect to the Demo Content setup screen after first activating the theme
function demo_setup_after_theme_activation() {
	global $pagenow;
	if (is_admin() && $pagenow == 'themes.php' && isset($_GET['activated'])) {
		header( 'Location: '.admin_url().'themes.php?page=demo-content' ) ;
	}
}
add_action('admin_init','demo_setup_after_theme_activation');

?>