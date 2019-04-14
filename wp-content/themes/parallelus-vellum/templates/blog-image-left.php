<?php global $custom_query, $column_left, $column_right;
/**
 * Template Name: Blog - Image Left
 */

$fromShortcode = ($custom_query) ? true : false;

// Layout variables - Set size of image and content columns (specify # of columns 1-12 , total must = 12)
$column_left  = 5;
$column_right = MAX_COLUMNS - $column_left;  // 12 - 5 = 7

if ( $fromShortcode ) {

	// For shortcode just include blog posts loop
	get_template_part( 'templates/blog' ); 

} else {

	// Setup the query 
	$params = array(
		'post_type' => 'post', 
		'paged' => $paged, 
		'post_excerpts' => get_options_data('blog-options', 'post-excerpts', 'false')
	);
	$custom_query = new WP_Query( $params );
	
	// Include full content structure
	get_header(); ?>

		<div id="primary" class="site-content">
			<div id="content" role="main">
				<?php get_template_part( 'templates/blog' ); ?>
			</div><!-- #content -->
		</div><!-- #primary -->

	<?php 
	
	get_sidebar();
	get_footer();

} ?>