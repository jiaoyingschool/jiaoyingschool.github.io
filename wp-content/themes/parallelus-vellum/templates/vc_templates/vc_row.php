<?php
$output = $el_class = $bg_image = $bg_color = $bg_image_repeat = $font_color = $padding = $margin_bottom = $css = $css_class = '';
$bg_styles = $inline_styles = $wrapper_class = $section_wrapper_style = $bg_layer_style = ''; // theme specific

extract(shortcode_atts(array(
    'el_class'        => '',
    'bg_image'        => '',
    'bg_color'        => '',
    'bg_image_repeat' => '',
    'font_color'      => '',
    'padding'         => '',
    'margin_bottom'   => '',
    'css' => '',
    /* theme custom */
    'bg_maps'         => '',
    'bg_maps_height'  => '',
    'bg_parallax'     => '',
    'inertia'         => '0.2',
), $atts));

wp_enqueue_style( 'js_composer_front' );
wp_enqueue_script( 'wpb_composer_front_js' );
wp_enqueue_style('js_composer_custom_css');

$el_class = $this->getExtraClass($el_class);

if (function_exists('get_row_css_class') && function_exists('vc_shortcode_custom_css_class')) {
	$css_class =  apply_filters(VC_SHORTCODE_CUSTOM_CSS_FILTER_TAG, 'wpb_row '.get_row_css_class().$el_class.vc_shortcode_custom_css_class($css, ' '), $this->settings['base']);
}

// $style = $this->buildStyle($bg_image, $bg_color, $bg_image_repeat, $font_color, $padding, $margin_bottom);
$style = $this->buildStyle('', '', '', $font_color, $padding, $margin_bottom);

// Background CSS - Parse custom styles
preg_match_all('/[*]*background[-]*[image|color|repeat|position|size]*:[^;]*;/i', $css, $background_css);
$bg_styles = (isset($background_css) && !empty($background_css)) ? str_replace("!important", "", implode('',$background_css[0])) : '';
// Margin CSS - Parse custom styles
preg_match_all('/[*]*margin[-]*[top|right|bottom|left]*:[^;]*;/i', $css, $margin_css);
$inline_styles .= (isset($margin_css) && !empty($margin_css)) ? str_replace("!important", "", implode('',$margin_css[0])) : '';
// Padding CSS - Parse custom styles
preg_match_all('/[*]*padding[-]*[top|right|bottom|left]*:[^;]*;/i', $css, $padding_css);
$inline_styles .= (isset($padding_css) && !empty($padding_css)) ? str_replace("!important", "", implode('',$padding_css[0])) : '';
// Border CSS - Parse custom styles
preg_match_all('/[*]*border[-]*[top|right|bottom|left]*:[^;]*;/i', $css, $border_css);
$inline_styles .= (isset($border_css) && !empty($border_css)) ? str_replace("!important", "", implode('',$border_css[0])) : '';

// Update default VC styles variable
if (!empty($bg_styles) || !empty($inline_styles)) {
	// Prepare the style variable	
	$style = (isset($style) && !empty($style)) ? rtrim($style, '"').' ' : 'style="'; 
	// Remove bg image styles from VC row
	if (!empty($bg_styles))	{
		$style .= 'background: none !important; background-image: none !important; background-color: inherit !important;';
	}
	// Add other inline styles
	$style .= $inline_styles .'"';
}

// Setup theme specific containers and classes
$wrapper_class = 'vc_section_wrapper';

// Parallax
if ($bg_parallax) {
	$wrapper_class .= ' parallax-section';
}

// Background images
if ($bg_color || strpos($bg_styles,'background-color:') !== false) {
	$wrapper_class  .= ' has_bg_color';
	// backwards compatibility
	if ($bg_color) { 
		$bg_layer_style .= 'background-color:'. $bg_color .';'; 
	}
}
if ($bg_image || strpos($bg_styles,'background-image:') !== false || strpos($bg_styles,'background:') !== false) {
	$wrapper_class  .= ' has_bg_img';
	// backwards compatibility
	if ($bg_image) { 
		$media = wp_get_attachment_image_src($bg_image, 'full');
		if ($bg_image_repeat == 'cover') {
			$wrapper_class  .= ' cover_all';		
		} else if ($bg_image_repeat == 'no-repeat') {
			$bg_layer_style .= 'background-repeat:no-repeat;';
		} else if ($bg_image_repeat == '') {
			$bg_layer_style .= 'background-repeat:repeat;';
		}
		$bg_layer_style .= 'background-image: url('.$media[0].');';
	}

}

// Maps
if ($bg_maps) {
	$wrapper_class .= ' wpb_map-section-full';
	$height = !$bg_maps_height ? 200 : $bg_maps_height;
	$section_wrapper_style = ' style="height: '.$height.'px"';
}

// Start the output
$output .= '<section class="'.$wrapper_class.'"'.$section_wrapper_style.'>';
if ($bg_layer_style || $bg_styles) {
	$bg_styles = $bg_styles . $bg_layer_style;
	$output .= '<div class="bg-layer" style="'. $bg_styles .'" data-inertia="'. $inertia .'"></div>';
}
// Maps output
if ($bg_maps) {
    $output .= '<div class="bg-layer cover_all" style="height: '.$height.'px;"><iframe width="100%" height="'.$height.'" frameborder="0" scrolling="no" marginheight="0" marginwidth="0" src="'.$bg_maps.'&amp;t=m&amp;z=14&amp;output=embed"></iframe></div>';
}

// VC default output
$output .= '<div class="'.$css_class.'"'.$style.'>';
$output .= wpb_js_remove_wpautop($content);
$output .= '</div>'.$this->endBlockComment('row');

// Finish output
$output .= '</section>';

// Print
echo $output;