<?php global $custom_query, $column_left, $column_right;
/**
 * Template Name: Blog - Image Top
 */

$fromShortcode = ($custom_query) ? true : false;

// no columns inside <article> for this layout
$column_left  = false;
$column_right = false; 

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