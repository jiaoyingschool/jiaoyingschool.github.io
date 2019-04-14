<?php global $custom_query, $column_left, $column_right, $headerClass;
/**
 * 
 * The template for displaying posts in the Gallery post format
 *
 */

// Title (for everything except image left layout)
if (!$column_right) { 	
	theme_post_title();
}

$headerClass = ($column_left) ? 'span'.$column_left : '';

// Image size
$shortcode = ( isset($custom_query->query) ) ? $custom_query->query : false;
$size  = get_post_image_size( 'post-thumbnail', $shortcode );

// Check for specific width and height settings
$max_w = '';
$max_h = '';
$style = '';
if (is_array($size)) {
	if ($size[0] != 0) $max_w = 'max-width: '.$size[0].'px;';
	if ($size[1] != 0) $max_h = 'max-height: '.$size[0].'px;';
	$style = 'style="'.$max_w.' '.$max_h.'"';
	$size = $size[0].'x'.$size[1];
}

$rotatorParams = array(
	'columns'      => 1, 
	'type'         => 'post-gallery',
	'image_size'   => $size,
	'transition'   => 'fade', 
	'slide_paging' => 'true', 
	'autoplay'     => 'true',
	'interval'     => '3500',
	'class'        => 'slideshow'
);

$rotator = theme_content_rotator( $rotatorParams );

if ($rotator !== "<!-- Content Rotator: Nothing to show. -->") {
	?>
	<header class="post-header <?php echo $headerClass ?>">
		<div class="featured-image" <?php echo $style ?>>
			<div class="styled-image <?php echo get_post_format() ?>"><?php echo $rotator; ?></div>
		</div>
	</header>
	<?php 
}

get_template_part( 'templates/post'); 

?>