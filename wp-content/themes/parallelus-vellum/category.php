<?php global $wp_query;
/**
 * The template for displaying Category pages.
 */

get_header(); ?>

	<section id="primary" class="site-content">
		<div id="content" role="main">

			<header class="archive-header">
				<h1 class="archive-title"><?php echo single_cat_title( '', false ); ?></h1>
			</header><!-- .archive-header -->

			<?php 

			if ( have_posts() ) :

				// The default query for this page
				$args = $wp_query->query;

				// Get the blog template
				get_theme_blog_template( $args );

			endif; 

			?>
		</div><!-- #content -->
	</section><!-- #primary -->

<?php get_sidebar(); ?>
<?php get_footer(); ?>