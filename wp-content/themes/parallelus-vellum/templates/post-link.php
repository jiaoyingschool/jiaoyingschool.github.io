<?php
/**
 * The template for displaying posts in the Link post format
 */
?>

<a href="<?php echo esc_url(get_post_meta($post->ID, 'postformat_link_url', true)); ?>" title="<?php echo esc_attr(get_the_title()); ?>" target="_blank">
	<header class="post-header">
		<div class="post-symbol"><i class="fa fa-link"></i></div><span class="post-format-label"><?php _e('Link', 'framework') ?></span>
		<h1 class="entry-title">
			<?php echo get_the_title(); ?>
		</h1>
		<span class="sub-title"><?php echo get_post_meta($post->ID, 'postformat_link_url', true) ?> <i class="fa fa-external-link-square"></i></span>
	</header>
</a>
<?php 

	// Post Content
	theme_post_content();

?>