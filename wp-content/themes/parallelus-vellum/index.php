<?php global $wp_query;

get_header(); ?>

	<div id="primary" class="site-content">
		<div id="content" role="main">
			<?php 
			if ( have_posts() ) :

				// The default query for this page
				$args = $wp_query->query;

				// Get the blog template
				get_theme_blog_template( $args );

			else : 
				get_template_part( 'content', 'none' ); 
			endif; 

			?>
		</div><!-- #content -->
	</div><!-- #primary -->

<?php get_sidebar(); ?>
<?php get_footer(); ?>