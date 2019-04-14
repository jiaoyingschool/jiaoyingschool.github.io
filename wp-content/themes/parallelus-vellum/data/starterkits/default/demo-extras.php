<?php

/**
 * Starter Kit Helpers
 * ----------------------------------------------------------------------------
 * 
 * This file contains custom functions that my need to be run or settings that 
 * should be applied to the specific starter kit. These are outside the scope 
 * of the data files and demo content importing and are more "helpers" than 
 * anything else. This may include setting a default home page, modifying 
 * reading settings and other standard WordPress settings that may need to be
 * adjusted for faster setup.
 * 
 */

// Reading Settings - Home Page, Blog...
// ----------------------------------------------------------------------------
// We only need to define the settings here through a filter. The "Demo Content" 
// extension will get these values and use them is specified.
// 
// IDs can change for imported content, slugs are more likely to stay the same.

function demo_content_starterkit_frontpage() {
	return 'home-pages';  // slug
}
add_filter( 'starterkit_frontpage', 'demo_content_starterkit_frontpage' );

function demo_content_starterkit_postspage() {
	return false;  // slug
}
add_filter( 'starterkit_postspage', 'demo_content_starterkit_postspage' );


// UberMenu meta options
// ----------------------------------------------------------------------------
// Can be filtered to override defaults.

/*

function demo_default_ubermenu_meta_options( $options ) {
	return $options;
}
add_filter( 'default_uber_options', 'demo_default_ubermenu_meta_options' );

function demo_parent_ubermenu_meta_options( $options ) {
	return $options;
}
add_filter( 'parent_uber_options', 'demo_parent_ubermenu_meta_options' );

*/

?>