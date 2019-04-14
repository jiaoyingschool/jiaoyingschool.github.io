<?php

#-----------------------------------------------------------------
# Default Sidebars
#-----------------------------------------------------------------

function theme_default_sidebars() {
	// Default sidebar
	register_sidebar( array(
		'name' => __( 'Default Sidebar', 'framework' ),
		'id' => 'sidebar-default',
		'description' => __( 'The default sidebar.', 'framework' ),
		'before_widget' => '<aside id="%1$s" class="widget %2$s">',
		'after_widget' => '</aside>',
		'before_title' => '<h3 class="widget-title">',
		'after_title' => '</h3>',
	) );
	// Vertical Masthead (top)
	register_sidebar( array(
		'name' => __( 'Vertical Masthead (top)', 'framework' ),
		'id' => 'sidebar-masthead-top',
		'description' => __( 'Masthead widget area, on the top for vertical mastheads.', 'framework' ),
		'before_widget' => '<aside id="%1$s" class="widget %2$s">',
		'after_widget' => '</aside>',
		'before_title' => '<h3 class="widget-title">',
		'after_title' => '</h3>',
	) );
	// Vertical Masthead (bottom)
	register_sidebar( array(
		'name' => __( 'Vertical Masthead (bottom)', 'framework' ),
		'id' => 'sidebar-masthead-bottom',
		'description' => __( 'Masthead widget area, on the bottom for vertical mastheads.', 'framework' ),
		'before_widget' => '<aside id="%1$s" class="widget %2$s">',
		'after_widget' => '</aside>',
		'before_title' => '<h3 class="widget-title">',
		'after_title' => '</h3>',
	) );
	// Horizontal Masthead (top)
	register_sidebar( array(
		'name' => __( 'Horizontal Masthead (top)', 'framework' ),
		'id' => 'horizontal-masthead-top',
		'description' => __( 'Masthead widget area, on the top for horizontal mastheads.', 'framework' ),
		'before_widget' => '<aside id="%1$s" class="widget %2$s">',
		'after_widget' => '</aside>',
		'before_title' => '<h3 class="widget-title">',
		'after_title' => '</h3>',
	) );
	// Horizontal Masthead (bottom)
	register_sidebar( array(
		'name' => __( 'Horizontal Masthead (bottom)', 'framework' ),
		'id' => 'horizontal-masthead-bottom',
		'description' => __( 'Masthead widget area, on the bottom for horizontal mastheads.', 'framework' ),
		'before_widget' => '<aside id="%1$s" class="widget %2$s">',
		'after_widget' => '</aside>',
		'before_title' => '<h3 class="widget-title">',
		'after_title' => '</h3>',
	) );
	// Footer Top
	register_sidebar( array(
		'name' => __( 'Footer - Top Section', 'framework' ),
		'id' => 'sidebar-footer-top',
		'description' => __( 'The default content of the footer top section. If your footer content is not coming from this location, look for it inside the Static Content (static blocks) menu of your admin.', 'framework' ),
		'before_widget' => '<aside id="%1$s" class="widget %2$s">',
		'after_widget' => '</aside>',
		'before_title' => '<h3 class="widget-title">',
		'after_title' => '</h3>',
	) );
	// Footer Bottom
	register_sidebar( array(
		'name' => __( 'Footer - Bottom Section', 'framework' ),
		'id' => 'sidebar-footer-bottom',
		'description' => __( 'The default content of the footer bottom section. If your footer content is not coming from this location, look for it inside the Static Content (static blocks) menu of your admin.', 'framework' ),
		'before_widget' => '<aside id="%1$s" class="widget %2$s">',
		'after_widget' => '</aside>',
		'before_title' => '<h3 class="widget-title">',
		'after_title' => '</h3>',
	) );
}
add_action( 'widgets_init', 'theme_default_sidebars' );

?>