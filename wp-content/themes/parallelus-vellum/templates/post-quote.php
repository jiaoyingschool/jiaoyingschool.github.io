<?php
/**
 * The template for displaying posts in the Quote post format
 */
?>

<header class="post-header">
	<div class="post-symbol"><i class="fa fa-quote-left"></i></div><span class="post-format-label"><?php _e('Quote', 'framework') ?></span>
	<h3 class="entry-title"><?php echo get_post_meta($post->ID, 'postformat_quote_text', true) ?></h3>
	<span class="sub-title"><?php echo get_post_meta($post->ID, 'postformat_quote_source', true) ?></span>
	<div class="post-symbol end-quote"><i class="fa fa-quote-right"></i></div>
</header>

<?php 

	// Post Content
	theme_post_content();
	
?>