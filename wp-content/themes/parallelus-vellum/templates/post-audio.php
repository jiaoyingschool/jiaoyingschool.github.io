<?php global $custom_query, $column_left, $column_right, $max_columns;
/**
 * The template for displaying audio format posts
 */

// Title (for everything except image left layout)
if (!$column_right) { 	
	theme_post_title();
}

// Media
$headerClass = ($column_left) ? 'span'.$column_left : ''; 
$headerClass = (has_post_thumbnail()) ? $headerClass.' player-with-image': ''; ?>
<header class="post-header <?php echo $headerClass ?>">
	<?php 

	// Featured Image: Audio Player "Poster"
	if ( has_post_thumbnail() ) :

		// Image size
		$shortcode = ( isset($custom_query->query) ) ? $custom_query->query : false;
		$size  = get_post_image_size( 'post-thumbnail', $shortcode );
		if (is_single() && get_options_data('blog-options', 'single-post-image', 'false') !== 'true') {
			$media =  false;
		} else {
			if (is_array($size)) {
				$thumb = get_post_thumbnail_id($post->ID);
				$crop = (  $size[0] == 0 || $size[1] == 0 ) ? false : true;
				$image = vt_resize( $thumb, '', $size[0], $size[1], $crop );
				$media = '<img src="'. $image['url'] .'" width="'. $image['width'] .'" height="'. $image['height'] .'">';
			} else {
				$media = get_the_post_thumbnail($post->ID, $size);
			}

			$media .= '<div class="inner-overlay"></div>'; 

			// Show the image (linked if blog list) ?>
			<div class="featured-image">
			<?php if ( is_single() ) : ?>
				<div class="styled-image <?php echo get_post_format() ?>"><?php echo $media; ?></div>
			<?php else : ?>
				<a href="<?php the_permalink(); ?>" class="styled-image <?php echo get_post_format() ?>" title="<?php echo esc_attr( sprintf( __( 'Permalink to %s', 'framework' ), the_title_attribute( 'echo=0' ) ) ); ?>" rel="bookmark"><?php echo $media ?></a>
			<?php endif; // is_single() ?>
			</div>
			<?php 
		}

	endif;

	// Audio Player
	theme_audio_player($post->ID); 

	?>
</header>

<?php 
// Content
if ($column_right) : 	
	// If using columns and there is a header
	if ($headerClass) { ?>
		<div class="span<?php echo  $column_right ?>">
		<?php 
	}
	
	// Post title
	theme_post_title();
endif;

	// Post Content
	theme_post_content();


if ($column_right && $headerClass) : ?>
	</div><!-- .span# -->
	<?php 
endif; ?>