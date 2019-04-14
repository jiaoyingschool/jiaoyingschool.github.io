<?php global $wp_query;
/**
 * The template for displaying Archive pages.
 */

get_header(); ?>

	<section id="primary" class="site-content">
		<div id="content" role="main">
			<header class="archive-header">
				<h1 class="archive-title"><?php
					if ( is_day() ) :
						printf( __( 'Archives: %s', 'framework' ), get_the_date() );
					elseif ( is_month() ) :
						printf( __( 'Archives: %s', 'framework' ), get_the_date( _x( 'F Y', 'monthly archives date format', 'framework' ) ) );
					elseif ( is_year() ) :
						printf( __( 'Archives: %s', 'framework' ), get_the_date( _x( 'Y', 'yearly archives date format', 'framework' ) ) );
					else :
						_e( 'Archives', 'framework' );
					endif;
				?></h1>
			</header><!-- .archive-header -->

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
	</section><!-- #primary -->

<?php get_sidebar(); ?>
<?php get_footer(); ?>