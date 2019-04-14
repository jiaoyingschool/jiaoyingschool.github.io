<?php
if (function_exists('vc_set_as_theme')) {
	vc_set_as_theme(true);  //disables auto updater
}

#-----------------------------------------------------------------
# Visual Composer Specific Extras
#-----------------------------------------------------------------

// Set the Raw HTML element font color to something more sensible (for Jeff)
// ...............................................................
if ( is_admin() && !function_exists('theme_raw_html_element_font_color_to_something_more_sensible') ) {
	function theme_raw_html_element_font_color_to_something_more_sensible() {
		echo '<style type="text/css">.wpb_element_wrapper .textarea_raw_html,.wpb_edit_form_elements .textarea_raw_html { color: black !important }</style>';
	}
	add_action('admin_head', 'theme_raw_html_element_font_color_to_something_more_sensible');
}

// Custom Column Classes
// ...............................................................

function custom_css_classes_for_vc_row_and_vc_column($class_string, $tag) {
	if ($tag=='vc_row' || $tag=='vc_row_inner') {
		$class_string = str_replace('vc_row-fluid', 'row-fluid', $class_string);
	}
	if($tag=='vc_column' || $tag=='vc_column_inner') {
		$class_string = preg_replace('/vc_span(\d{1,2})/', 'span$1', $class_string);
	}
	return $class_string;
}
// Filter to Replace default css class for vc_row shortcode and vc_column
add_filter('vc_shortcodes_css_class', 'custom_css_classes_for_vc_row_and_vc_column', 10, 2);



# ---------------------------------------------------------------
# Modified or added options for Visual Composer default elements
# ---------------------------------------------------------------

function add_custom_theme_vc_params() {

	// Old element color structure
	// ...............................................................

		// Visual Composer color values
		$vc_colors = array(
				__("Grey", "js_composer") => "wpb_button", 
				__("Blue", "js_composer") => "btn-primary", 
				__("Turquoise", "js_composer") => "btn-info", 
				__("Green", "js_composer") => "btn-success",
				__("Orange", "js_composer") => "btn-warning", 
				__("Red", "js_composer") => "btn-danger", 
				__("Black", "js_composer") => "btn-inverse"
			);

		// Custom color values
		$theme_custom_colors = array(
			__("Theme Default", "framework") => "theme-default", 
			__("Theme Accent Color", "framework") => "accent-primary"
		);

		// Merged all colors
		$all_colors = array_merge( 
			(array) $theme_custom_colors,
			(array) $vc_colors
		);

	// Updated element color structure
	// ...............................................................

		// Visual Composer color values
		$vc_shared_colors = (function_exists('getVcShared')) ? getVcShared("colors") : array();

		// Custom color values
		$theme_custom_shared_colors = array(
			__("Theme Default", "framework") => "theme-default", 
			__("Theme Accent Color", "framework") => "accent-primary"
		);

		// Merged all colors
		$all_shared_colors = array_merge( 
			(array) $theme_custom_shared_colors,
			(array) $vc_shared_colors
		);


	// Apply updtes to default VC elements using add param function
	// ===============================================================
	
	if (function_exists('vc_add_param')) {

		// Add custom progress bar colors 
		// ===============================================================

		// Add parameters to 'vc_progress_bar'
		// ...............................................................
		$base = 'vc_progress_bar';
		$extraParams = array(
			array(
				"type" => "dropdown",
				"heading" => __("Bar color", "js_composer"),
				"param_name" => "bgcolor",
				"value" => array_merge( 
					array(__("Theme Accent Color", "js_composer") => "accent-primary"),
					(array) $vc_colors
				),
				"description" => __("Select bar background color.", "js_composer"),
				"admin_label" => true
			),
		);
		foreach ($extraParams as $params) {
			vc_add_param( $base, $params );
		}


		// Add custom button colors 
		// ===============================================================

		// Add parameters to 'vc_button' (Button)
		// ...............................................................
		$base = 'vc_button';
		$extraParams = array(
			array(
				"type" => "dropdown",
				"heading" => __("Color", "js_composer"),
				"param_name" => "color",
				"value" => $all_colors,
				"description" => __("Button color.", "js_composer"),
				"param_holder_class" => 'vc-colored-dropdown'
			)
		);
		foreach ($extraParams as $params) {
			vc_add_param( $base, $params );
		}
		// Add parameters to 'vc_button2' (Button 2)
		// ...............................................................
		/*$base = 'vc_button2';
		$extraParams = array(
			array(
				"type" => "dropdown",
				"heading" => __("Color", "js_composer"),
				"param_name" => "color",
				"value" => $all_shared_colors,
				"description" => __("Button color.", "js_composer"),
				"param_holder_class" => 'vc-colored-dropdown'
			)
		);
		foreach ($extraParams as $params) {
			vc_add_param( $base, $params );
		}*/


		// Add parameters to 'vc_cta_button' (Call to Action)
		// ...............................................................
		$base = 'vc_cta_button'; 
		$extraParams = array(
			array(
				"type" => "dropdown",
				"heading" => __("Color", "js_composer"),
				"param_name" => "color",
				"value" => $all_colors,
				"description" => __("Button color.", "js_composer"),
				"param_holder_class" => 'vc-colored-dropdown'
			)
		);
		foreach ($extraParams as $params) {
			vc_add_param( $base, $params );
		}
		// Add parameters to 'vc_cta_button2' (Call to Action 2)
		// ...............................................................
		/*$base = 'vc_cta_button2'; 
		$extraParams = array(
			array(
				"type" => "dropdown",
				"heading" => __("Color", "js_composer"),
				"param_name" => "color",
				"value" => $all_shared_colors,
				"description" => __("Button color.", "js_composer"),
				"param_holder_class" => 'vc-colored-dropdown'
			)
		);
		foreach ($extraParams as $params) {
			vc_add_param( $base, $params );
		}*/


		// Add custom row options
		// ===============================================================

		// Add parameters to 'vc_row'
		$base = 'vc_row';
		$extraParams = array(
			array(
				"type" => "checkbox",
				"param_name" => "bg_parallax",
				"value" => array(
							__('Enable parallax effect', 'framework') => 'true'
						),
				"description" => __("Make the background image have a parallax scrolling effect.", "framework")
			),
			// Inertia
			array(
				"type" => "dropdown",
				"class" => "",
				"heading" => __("Scroll Offset (inertia)", 'framework'),
				"param_name" => "inertia",
				"value" => array(
					1  => '0.1',
					2  => '0.2',
					3  => '0.3',
					4  => '0.4',
					5  => '0.5',
					6  => '0.6',
					7  => '0.7',
					8  => '0.8',
					9  => '0.9'
				),
				"description" => __("Specify the offset speed of the parallax effect. The lower the number the less the background moves relative to browser window.", 'framework')
			),
			array(
				"type" => "textfield",
				"admin_label" => true,
				"heading" => __("Google Maps Url", "framework"),
				"param_name" => "bg_maps",
				"description" => __("Instead of a background image, show a gorgeous full width google map. Parallax effect won't apply here.", "framework")
			),
			array(
				"type" => "textfield",
				"admin_label" => true,
				"heading" => __("Google Maps Height", "framework"),
				"param_name" => "bg_maps_height",
				"description" => __("Specify the height of the maps. (default 200px)", "framework")
			),
		);
		foreach ($extraParams as $params) {
			vc_add_param( $base, $params );
		}

		// Update 'vc_row' to include custom shortcode template and re-map shortcode
		$sc = vc_map_update( 'vc_row', array('html_template' => locate_template('templates/vc_templates/vc_row.php')) );
		// Remove default vc_row shortcode
		vc_remove_element('vc_row');
		// Remap shortcode, identical to original, but with custom template path
		vc_map($sc['vc_row']);

	}

}

add_action( 'wp_loaded', 'add_custom_theme_vc_params' );


# ---------------------------------------------------------------
# Custom Shortcodes Added to Visual Composer
# ---------------------------------------------------------------


// setup large separator shortcode
// ...............................................................

add_shortcode( 'large_separator', 'shortcode_large_separator' );
function shortcode_large_separator( $atts, $content = null ) {
	extract( shortcode_atts( array(
		'style'    => false
	), $atts ) );

	// Custom styles?
	$css = '';
	if ($style) {
		$css = 'style="'. $style .'"';
	}

	return '<div class="separator-large" '.$css.'></div>';
}
// Call WPBakery VC map function
if (function_exists('wpb_map')) {
	wpb_map( array(
		"name" => __("Separator (Large Divider)", 'framework'),
		"base" => "large_separator",
		"class"		=> "separator",
		"controls" => "edit_popup_delete", // not "full"
		"icon" => "icon-wpb-ui-separator",
		"show_settings_on_create" => false,
		"category" => __('Content', 'framework')
	) );
}


// Headline Block Shortcode
// ...............................................................

add_shortcode( 'headline_box', 'shortcode_headline_box' );
function shortcode_headline_box( $atts, $content = null ) {
	extract( shortcode_atts( array(
		'align'   => 'left',
		'text'    => 'Having <em>fun</em> yet?'
	), $atts ) );

	$css = '';
	if ($align) {
		$css = 'style="text-align:'. $align .'"';
	}

	return '<div class="headline-box"><div class="separator-large"></div><h1 class="headline" '.$css.'>'.$text.'</h1><div class="separator-large"></div></div>';
}
// Call WPBakery VC map function
if (function_exists('wpb_map')) {
	wpb_map( array(
		"name" => __("Headline Text Box", 'framework'),
		"base" => "headline_box",
		"class"		=> "",
		"controls" => "full", 
		"icon" => "icon-wpb-layer-shape-text",
		"category" => __('Content', 'framework'),
		"params" => array(
		  // Text
		  array(
			"type" => "textfield",
			"holder" => "div",
			"class" => "",
			"heading" => __("Text", 'framework'),
			"param_name" => "text",
			"value" => __("Having <em>fun</em> yet?", 'framework'),
			"description" => __("Enter the headline text. Use &lt;em&gt;emphasis&lt;/em&gt; to highlight words.", 'framework')
		  ),
	      // Align
		  array(
			"type" => "dropdown",
			"class" => "",
			"heading" => __("Text Align", 'framework'),
			"param_name" => "align",
			"value" => array(
				'left'   => 'Left',
				'center' => 'Center',
				'right'  => 'Right'
			),
			"description" => __("Align text left, center or right.", 'framework')
		  )
	   )
	) );
}


// Headline Block Shortcode
// ...............................................................

add_shortcode( 'headline_subtitle', 'shortcode_headline_subtitle' );
function shortcode_headline_subtitle( $atts, $content = null ) {
	extract( shortcode_atts( array(
		'title'    => '',
                'subtitle' => '',
	), $atts ) );

	return '<div class="headline-subtitle"><h1 class="headline">'.$title.'</h1><h2 class="subtitle">'.$subtitle.'</h2><div class="separator-subtitle"></div></div>';
}
// Call WPBakery VC map function
if (function_exists('wpb_map')) {
	wpb_map( array(
		"name" => __("Headline with Subtitle", 'framework'),
		"base" => "headline_subtitle",
		"class"		=> "",
		"controls" => "full", 
		"icon" => "icon-wpb-layer-shape-text",
		"category" => __('Content', 'framework'),
	   "params" => array(
	      array(
	         "type" => "textfield",
	         "holder" => "div",
	         // 'admin_label' => true,
	         "class" => "",
	         "heading" => __("Text", 'framework'),
	         "param_name" => "title",
	         "value" => __("Big Title", 'framework'),
	         "description" => __("Enter the headline text.", 'framework')
	      ),
	      array(
	         "type" => "textfield",
	         "holder" => "div",
	         // 'admin_label' => true,
	         "class" => "",
	         "heading" => __("Text", 'framework'),
	         "param_name" => "subtitle",
	         "value" => __("Subtitle", 'framework'),
	         "description" => __("Enter the subtitle text.", 'framework')
	      )
	   )
	) );
}

// Icon Box Shortcode
// ...............................................................

add_shortcode( 'icon_box', 'shortcode_icon_box' );
function shortcode_icon_box( $atts, $content = null ) {
	extract(shortcode_atts(array(
		'title' => false,
		'icon' => false,
		'custom' => false,
		'big_icon' => false,
		'show_button' => false,
		'button_link' => false,
		'button_text' => false,
		'text_color'  => false,
    ), $atts));

	$class = 'iconBox';
	$color_style = $text_color ? ' style="color: '.$text_color.';"' : '';

	if (($icon || $custom)) {
		$class .= ' icon';
		$class .= $big_icon ? " icon-big" : '';
		if ( $custom ) {
			// was the image provided as a media attachment ID?
			$src = (wp_get_attachment_url($custom)) ? wp_get_attachment_url($custom) : $custom;
			$image = '<img src="'.$src.'" alt="">';
			$icon = '<i class="custom-icon">'. $image .'</i>';			
		} else {
			$image = 'fa-'.str_replace('fa-','',strtolower($icon)); // remove "fa-" prefix (if there) then add it back (to be sure)s
			$icon = '<i class="fa '. $image .'"'.$color_style.'></i>';
		}
	}
        
	// Title
	if ($title) $title = '<h2 class="iconBoxTitle"'.$color_style.'>'.$title.'</h2>';

	// Get the content together
	$content = wpb_js_remove_wpautop($content); // fix unclosed/unwanted paragraph tags in $content
	$box  = '<div class="'.$class.'"'.$color_style.'>';
		$box .= $icon;
		$box .= '<div class="textContent">';
			$box .= $title;
			$box .= '<div class="theText">'.do_shortcode($content).'</div>';
			if ($show_button) {
				// show button
				$box .= '<a class="btn small" href="'. $button_link .'"'.$color_style.'>'. $button_text .'</a>';
			}
		$box .= '</div>';
	$box .= '</div>';
		
   return $box;
}
// Call WPBakery VC map function
if (function_exists('wpb_map')) {
	wpb_map( array(
		"name" => __("Icon Box", 'framework'),
		"base" => "icon_box",
		"class"		=> "",
		"controls" => "full", 
		"icon" => "icon-wpb-information-white",
		"category" => __('Content', 'framework'),
	   "params" => array(
	      array(
	         "type" => "textfield",
	         "holder" => "div",
	         // 'admin_label' => true,
	         "class" => "",
	         "heading" => __("Title", 'framework'),
	         "param_name" => "title",
	         "value" => __("Your Title", 'framework'),
	         "description" => __("Enter the title to use for this box.", 'framework')
	      ),
	      array(
	         "type" => "textfield",
	         // "holder" => "div",
	         // 'admin_label' => true,
	         "class" => "",
	         "heading" => __("Icon", 'framework'),
	         "param_name" => "icon",
	         "value" => __("fa-plus", 'framework'),
	         "description" => __("Enter the icon file or class. This can be any <a href='http://fontawesome.io/icons/' target='_blank'>Font Awesome</a> icon class, for example 'fa-star' or 'fa-ok'.", 'framework')
	      ),
              array(
                "type" => "checkbox",
                "param_name" => "big_icon",
                "value" => array(
                                __('Big Icon', 'framework') => 'true'
                        ),
                "description" => __("Show a big icon instead of a small one.", "framework")
              ),
              array(
                "type" => "checkbox",
                "param_name" => "show_button",
                "value" => array(
                                __('Show Button', 'framework') => 'true'
                        ),
                "description" => __("Show a button under the content.", "framework")
              ),
	      array(
	         "type" => "textfield",
	         "class" => "",
	         "heading" => __("Button Text", 'framework'),
	         "param_name" => "button_text",
	         "value" => __("Learn More", 'framework'),
	         "description" => __("Change the text on the button.", 'framework')
	      ),
	      array(
	         "type" => "textfield",
	         "class" => "",
	         "heading" => __("Button Link", 'framework'),
	         "param_name" => "button_link",
	         "value" => __("http://", 'framework'),
	         "description" => __("Enter a full URL to the page you want to link to.", 'framework')
	      ),
               
              array(
                "type" => "colorpicker",
                // "holder" => 'div',
                "admin_label" => true,
                "heading" => __("Text color", "framework"),
                "param_name" => "text_color",
                "description" => __("Apply a custom text color", "framework")
              ),
	      array(
	         "type" => "textarea_html",
	         // "holder" => "div",
	         // 'admin_label' => true,
	         "class" => "",
	         "heading" => __("Content", 'framework'),
	         "param_name" => "content",
	         "value" => __("This is the text block. Click edit to change this text.", 'framework'),
	         "description" => __("Enter your content or description.", 'framework')
	      )
	    )
	) );
}



// Blog, Portfolio and "Query" shortcodes mapped to VC
// ...............................................................

// Check if [blog] shortcode exists
// if ( array_key_exists('blog', $GLOBALS['shortcode_tags']) ) {

	// Map to WPBakery VC
	if (function_exists('wpb_map')) {
		// Item settings and options
		$settings = array(
			"name" => __("Post List", 'framework'),
			"base" => "blog",
			"class"		=> "",
			"wrapper_class" => "clearfix",
			// "controls" => "full", 
			"icon" => "icon-wpb-application-icon-large",
			"category" => __('Content', 'framework'),
			"params" => array(
				// Posts per page
				array(
					"type" => "textfield",
					// "holder" => "div",
					"class" => "",
					"heading" => __("Posts per page", 'framework'),
					"param_name" => "posts_per_page",
					"value" => '',
					"description" => __("The number of items to show per page. (optional)<br>WP_Query parameter <code>posts_per_page</code>", 'framework')
				),
				// Post types
				array(
					"type" => "posttypes",
					// "holder" => "div",
					'admin_label' => true,
					"class" => "",
					"heading" => __("Post types", 'framework'),
					"param_name" => "post_type",
					"value" => "post",
					"description" => __("Blog lists can be created from any standard or custom post type. The default is 'post'.<br>WP_Query parameter <code>post_type</code>", 'framework')
				),
				// Template Select
				array(
					"type" => "dropdown",
					// "holder" => "div",
					'admin_label' => true,
					"class" => "",
					"heading" => __("Template", 'framework'),
					"param_name" => "template",
					"value" => array(
						__("Blog - Image Top", 'framework')   => 'blog-image-top',
						__("Blog - Image Left", 'framework') => 'blog-image-left',
						__("Grid - Rows", 'framework')   => 'grid-rows',
						__("Grid - Rows with Filtering", 'framework')  => 'grid-rows-filtered',
						__("Grid - Staggered", 'framework')   => 'grid-staggered',
						__("Grid - Staggered with Filtering", 'framework')   => 'grid-staggered-filtered',
					),
					"description" => __("Select a display style. Items can be displayed as blog posts or portfolio items.", 'framework')
				),
				// Grid Columns
				array(
					"type" => "textfield",
					// "holder" => "div",
					"class" => "",
					"heading" => __("Grid Columns", 'framework'),
					"param_name" => "columns",
					"value" => '4',
					"description" => __("The number of columns in grid layouts. Only applies to Grid templates.", 'framework')
				),
				array(
					"type" => "checkbox",
					// "holder" => "div",
					"class" => "",
					// "heading" => __("Use Post Excerpts", 'framework'),
					"param_name" => "post_excerpts",
					"value" => array(
						__('Use Post Excerpts', 'framework') => 'true'
					),
					"description" => __('Use shortened content excerpts. If turned off the full post will display in post lists.','framework')
				),
				array(
					"type" => "textfield",
					// "holder" => "div",
					"class" => "",
					"heading" => __("Excerpt length", 'framework'),
					"param_name" => "excerpt_length",
					"value" => '50',
					"description" => __("The number of words in post excerpts, 250 max. Custom excerpts are not restricted by this setting. Set to -1 for no excerpt.", 'framework')
				),
				array(
					"type" => "textfield",
					// "holder" => "div",
					"class" => "",
					"heading" => __("Image width", 'framework'),
					"param_name" => "image_width",
					"value" => '',
					"description" => __("Specify a width for images in the post list view. Leave blank or set to '0' for auto. (optional)", 'framework')
				),
				array(
					"type" => "textfield",
					// "holder" => "div",
					"class" => "",
					"heading" => __("Image height", 'framework'),
					"param_name" => "image_height",
					"value" => '',
					"description" => __("Specify a height for images in the post list view. Leave blank or set to '0' for auto. (optional)", 'framework')
				),
				array(
					"type" => "checkbox",
					// "holder" => "div",
					"class" => "",
					// "heading" => __("Paging", 'framework'),
					"param_name" => "paging",
					"value" => array(
						__('Disable paging?', 'framework') => 'false'
					),
					"description" => __('Paging is enabled by default.','framework')
				),
				array(
					"type" => "textfield",
					// "holder" => "div",
					'admin_label' => true,
					"class" => "",
					"heading" => __("Categories", 'framework'),
					"param_name" => "category_name",
					"value" => '',
					"description" => __("A comma separated list of category names to restrict results within. e.g. tutorials,business,travel<br>WP_Query parameter <code>category_name</code>", 'framework')
				),

				array(
					"type" => "textfield",
					// "holder" => "div",
					'admin_label' => true,
					"class" => "",
					"heading" => __("Tags", 'framework'),
					"param_name" => "tag_slug__in",
					"value" => '',
					"description" => __("A comma separated list of tag names to restrict results within. e.g. bread,baking<br>WP_Query parameter <code>tag_slug__in</code>", 'framework')
				),
				array(
					"type" => "dropdown",
					// "holder" => "div",
					"class" => "",
					"heading" => __("Order by", 'framework'),
					"param_name" => "orderby",
					"value" => array(
						'' => '',
						__("Date", 'framework')   => 'date',
						__("Author", 'framework') => 'author',
						__("Title", 'framework')  => 'title',
						__("Slug", 'framework')   => 'name',
						__("ID", 'framework')   => 'ID',
						__("Last modified", 'framework') => 'modified',
						__("Parent", 'framework')  => 'parent',
						__("Random", 'framework')   => 'rand',
						__("Comment count", 'framework')   => 'comment_count',
						__("Menu order", 'framework') => 'menu_order',
						__("Meta value", 'framework')  => 'meta_value',
						__("Meta value number", 'framework')   => 'meta_value_num',
						__("post__in parameter", 'framework')   => 'post__in'
					),
					"description" => __("Specify sorting method.<br>WP_Query parameter <code>orderby</code>", 'framework')
				),
				array(
					"type" => "dropdown",
					// "holder" => "div",
					"class" => "",
					"heading" => __("Sort order", 'framework'),
					"param_name" => "order",
					"value" => array(
						'' => '',
						__("Descending (default)", 'framework')   => 'DESC',
						__("Ascending", 'framework')   => 'ASC'
					),
					"description" => __("Specify sorting order, ascending or descending.<br>WP_Query parameter <code>order</code>", 'framework')
				),

				array(
					"type" => "textfield",
					// "holder" => "div",
					"class" => "",
					"heading" => __("Taxonomy", 'framework'),
					"param_name" => "taxonomy_slug",
					"value" => '',
					"description" => __("The name of a custom taxonomy to query.<br>WP_Query parameter <code>tax_query->taxonomy</code>", 'framework')
				),
				array(
					"type" => "textfield",
					// "holder" => "div",
					"class" => "",
					"heading" => __("Taxonomy terms", 'framework'),
					"param_name" => "taxonomy_terms",
					"value" => '',
					"description" => __("A comma separated list of taxonomy terms, use with the taxonomy fields above.<br>WP_Query parameter <code>tax_query->terns</code>", 'framework')
				),
				array(
					"type" => "textarea",
					// "holder" => "div",
					"class" => "",
					"heading" => __("Other Parameters", 'framework'),
					"param_name" => "string",
					"value" => __("", 'framework'),
					"description" => __("Additional <a href='http://codex.wordpress.org/Class_Reference/WP_Query' target='_blank'>WP_Query</a> parameters can be entered here. Use the format <code>parameter=value&amp;parameter_2=value2</code> You should not enter any blank spaces or quotes.", 'framework')
				)
			)
		);
		// Call mapping function
		wpb_map($settings);
	}
// }



// Portfolio shortcodes mapped to VC
// ...............................................................

// Check if [blog] shortcode exists
// if ( array_key_exists('portfolio', $GLOBALS['shortcode_tags']) ) {

	// Map to WPBakery VC
	if (function_exists('wpb_map')) {
		// Item settings and options
		$settings = array(
			"name" => __("Portfolio", 'framework'),
			"base" => "portfolio",
			"class"		=> "",
			"wrapper_class" => "clearfix",
			// "controls" => "full", 
			"icon" => "icon-wpb-application-icon-large",
			"category" => __('Content', 'framework'),
			"params" => array(
				// Posts per page
				array(
					"type" => "textfield",
					// "holder" => "div",
					"class" => "",
					"heading" => __("Posts per page", 'framework'),
					"param_name" => "posts_per_page",
					"value" => '',
					"description" => __("The number of items to show per page. (optional)<br>WP_Query parameter <code>posts_per_page</code>", 'framework')
				),
				// Template Select
				array(
					"type" => "dropdown",
					// "holder" => "div",
					'admin_label' => true,
					"class" => "",
					"heading" => __("Template", 'framework'),
					"param_name" => "template",
					"value" => array(
						// __("Blog - Image Top", 'framework')   => 'blog-image-top',
						// __("Blog - Image Left", 'framework') => 'blog-image-left',
						__("Grid - Rows", 'framework')   => 'grid-rows',
						__("Grid - Rows with Filtering", 'framework')  => 'grid-rows-filtered',
						__("Grid - Staggered", 'framework')   => 'grid-staggered',
						__("Grid - Staggered with Filtering", 'framework')   => 'grid-staggered-filtered',
					),
					"description" => __("Select a display style. Items can be displayed as blog posts or portfolio items.", 'framework')
				),
				// Grid Columns
				array(
					"type" => "textfield",
					// "holder" => "div",
					"class" => "",
					"heading" => __("Grid Columns", 'framework'),
					"param_name" => "columns",
					"value" => '4',
					"description" => __("The number of columns in grid layouts. Only applies to Grid templates.", 'framework')
				),
				array(
					"type" => "checkbox",
					// "holder" => "div",
					"class" => "",
					// "heading" => __("Use Post Excerpts", 'framework'),
					"param_name" => "hide_title",
					"value" => array(
						__('Hide title', 'framework') => 'true'
					),
					"description" => __('Hide the title post.','framework')
				),
				array(
					"type" => "checkbox",
					// "holder" => "div",
					"class" => "",
					// "heading" => __("Use Post Excerpts", 'framework'),
					"param_name" => "post_excerpts",
					"value" => array(
						__('Use Excerpts', 'framework') => 'true'
					),
					"description" => __('Use shortened content excerpts. If turned off no excerpt will be displayed.','framework')
				),
				array(
					"type" => "textfield",
					// "holder" => "div",
					"class" => "",
					"heading" => __("Excerpt length", 'framework'),
					"param_name" => "excerpt_length",
					"value" => '50',
					"description" => __("The number of words in post excerpts.", 'framework')
				),
				array(
					"type" => "textfield",
					// "holder" => "div",
					"class" => "",
					"heading" => __("Image width", 'framework'),
					"param_name" => "image_width",
					"value" => '',
					"description" => __("Specify a width for images portfolio grid. Leave blank or set to '0' for auto. (optional)", 'framework')
				),
				array(
					"type" => "textfield",
					// "holder" => "div",
					"class" => "",
					"heading" => __("Image height", 'framework'),
					"param_name" => "image_height",
					"value" => '',
					"description" => __("Specify a height for images portfolio grid. Leave blank or set to '0' for auto. (optional)", 'framework')
				),
				array(
					"type" => "checkbox",
					// "holder" => "div",
					"class" => "",
					// "heading" => __("Paging", 'framework'),
					"param_name" => "paging",
					"value" => array(
						__('Disable paging?', 'framework') => 'false'
					),
					"description" => __('Paging is enabled by default.','framework')
				),
				array(
					"type" => "textfield",
					// "holder" => "div",
					'admin_label' => true,
					"class" => "",
					"heading" => __("Categories", 'framework'),
					"param_name" => "category",
					"value" => '',
					"description" => __("A comma separated list of category names to restrict results within. e.g. tutorials,business,travel", 'framework')
				),
				array(
					"type" => "dropdown",
					// "holder" => "div",
					"class" => "",
					"heading" => __("Order by", 'framework'),
					"param_name" => "orderby",
					"value" => array(
						'' => '',
						__("Date", 'framework')   => 'date',
						__("Author", 'framework') => 'author',
						__("Title", 'framework')  => 'title',
						__("Slug", 'framework')   => 'name',
						__("ID", 'framework')   => 'ID',
						__("Last modified", 'framework') => 'modified',
						__("Parent", 'framework')  => 'parent',
						__("Random", 'framework')   => 'rand',
						__("Comment count", 'framework')   => 'comment_count',
						__("Menu order", 'framework') => 'menu_order',
						__("Meta value", 'framework')  => 'meta_value',
						__("Meta value number", 'framework')   => 'meta_value_num',
						__("post__in parameter", 'framework')   => 'post__in'
					),
					"description" => __("Specify sorting method.<br>WP_Query parameter <code>orderby</code>", 'framework')
				),
				array(
					"type" => "dropdown",
					// "holder" => "div",
					"class" => "",
					"heading" => __("Sort order", 'framework'),
					"param_name" => "order",
					"value" => array(
						'' => '',
						__("Descending (default)", 'framework')   => 'DESC',
						__("Ascending", 'framework')   => 'ASC'
					),
					"description" => __("Specify sorting order, ascending or descending.<br>WP_Query parameter <code>order</code>", 'framework')
				),
				array(
					"type" => "textarea",
					// "holder" => "div",
					"class" => "",
					"heading" => __("Other Parameters", 'framework'),
					"param_name" => "string",
					"value" => __("", 'framework'),
					"description" => __("Additional <a href='http://codex.wordpress.org/Class_Reference/WP_Query' target='_blank'>WP_Query</a> parameters can be entered here. Use the format <code>parameter=value&amp;parameter_2=value2</code> You should not enter any blank spaces or quotes.", 'framework')
				)
			)
		);
		// Call mapping function
		wpb_map($settings);
	}
// }



// Content Rotator (carousel) shortcode mapped to VC
// ...............................................................

// Check if [blog] shortcode exists
// if ( array_key_exists('content_rotator', $GLOBALS['shortcode_tags']) ) {

	// Map to WPBakery VC
	if (function_exists('wpb_map')) {
		// Item settings and options
		$settings = array(
			"name" => __("Content Rotator", 'framework'),
			"base" => "content_rotator",
			"class"		=> "",
			"wrapper_class" => "clearfix",
			// "controls" => "full", 
			"icon" => "icon-wpb-application-icon-large",
			"category" => __('Content', 'framework'),
			"params" => array(
				// Title
				array(
					"type" => "textfield",
					// "holder" => "span",
					'admin_label' => true,
					"class" => "",
					"heading" => __("Title", 'framework'),
					"param_name" => "title",
					"value" => '',
					"description" => __("An optional title element for the rotator.", 'framework')
				),
				// Columns
				array(
					"type" => "dropdown",
					// "holder" => "strong ",
					'admin_label' => true,
					"class" => "",
					"heading" => __("Columns", 'framework'),
					"param_name" => "columns",
					"value" => array(
						1 => 1,
						2 => 2,
						3 => 3,
						4 => 4,
						5 => 5,
						6 => 6
					),
					// "description" => __("The number of columns.", 'framework')
				),
				// Transition
				array(
					"type" => "dropdown",
					// "holder" => "div",
					'admin_label' => true,
					"class" => "",
					"heading" => __("Transition", 'framework'),
					"param_name" => "transition",
					"value" => array(
						'' => '',
						'Slide' => 'slide',
						'Fade' => 'fade',
						'Flip' => 'flip'
					),
					"description" => __("You can choose a transition to be used for slide changing.", 'framework')
				),
				// Autoplay
				array(
					"type" => "checkbox",
					// "holder" => "div",
					// 'admin_label' => true,
					"class" => "",
					"heading" => __("Auto-play", 'framework'),
					"param_name" => "autoplay",
					"value" => array(
						__('Start transitions automatically?', 'framework') => 'true'
					),
					"description" => __('Enable auto-play and slides will transition at a specified interval.','framework')
				),
				// Interval
				array(
					"type" => "textfield",
					// "holder" => "span",
					"class" => "",
					// "heading" => __("Autoplay Interval", 'framework'),
					"param_name" => "interval",
					"value" => '',
					"description" => __("The interval time in milliseconds between slides when auto-play is enabled. e.g. 4000 for 4 seconds. 6000 for 6 seconds.", 'framework')
				),				
				// Post types
				array(
					"type" => "posttypes",
					// "holder" => "div",
					'admin_label' => true,
					"class" => "",
					"heading" => __("Post types", 'framework'),
					"param_name" => "post_type",
					"value" => "post",
					"description" => __("Select the post types to use as the content source.", 'framework')
				),
				array(
					"type" => "checkbox",
					// "holder" => "div",
					"class" => "",
					// "heading" => __("Use Post Excerpts", 'framework'),
					"param_name" => "hide_title",
					"value" => array(
						__('Hide Item Titles', 'framework') => 'true'
					),
					"description" => __('Hide item titles.','framework')
				),
				array(
					"type" => "checkbox",
					// "holder" => "div",
					"class" => "",
					// "heading" => __("Use Post Excerpts", 'framework'),
					"param_name" => "post_excerpts",
					"value" => array(
						__('Use Content Excerpts', 'framework') => 'true'
					),
					"description" => __('Show content excerpts. If turned off there will be no description text.','framework')
				),
				array(
					"type" => "textfield",
					// "holder" => "div",
					"class" => "",
					"heading" => __("Excerpt length", 'framework'),
					"param_name" => "excerpt_length",
					"value" => '30',
					"description" => __("The number of words in post excerpts, 250 max. Custom excerpts are not restricted by this setting.", 'framework')
				),
				array(
					"type" => "textfield",
					// "holder" => "div",
					'admin_label' => true,
					"class" => "",
					"heading" => __("Image size", 'framework'),
					"param_name" => "image_size",
					"value" => '',
					"description" => __("Specify the image size. Example: thumbnail, medium, full. You can also provide exact sizes in pixels: e.g. 200x100 (width x height).", 'framework')
				),
				array(
					"type" => "textfield",
					// "holder" => "div",
					'admin_label' => true,
					"class" => "",
					"heading" => __("Categories", 'framework'),
					"param_name" => "category_name",
					"value" => '',
					"description" => __("A comma separated list of category names to restrict results within. e.g. tutorials,business,travel<br>WP_Query parameter <code>category_name</code>", 'framework')
				),

				array(
					"type" => "textfield",
					// "holder" => "div",
					"class" => "",
					"heading" => __("Tags", 'framework'),
					"param_name" => "tag_slug__in",
					"value" => '',
					"description" => __("A comma separated list of tag names to restrict results within. e.g. bread,baking<br>WP_Query parameter <code>tag_slug__in</code>", 'framework')
				),
				array(
					"type" => "dropdown",
					// "holder" => "div",
					"class" => "",
					"heading" => __("Order by", 'framework'),
					"param_name" => "orderby",
					"value" => array(
						'' => '',
						__("Date", 'framework')   => 'date',
						__("Author", 'framework') => 'author',
						__("Title", 'framework')  => 'title',
						__("Slug", 'framework')   => 'name',
						__("ID", 'framework')   => 'ID',
						__("Last modified", 'framework') => 'modified',
						__("Parent", 'framework')  => 'parent',
						__("Random", 'framework')   => 'rand',
						__("Comment count", 'framework')   => 'comment_count',
						__("Menu order", 'framework') => 'menu_order',
						__("Meta value", 'framework')  => 'meta_value',
						__("Meta value number", 'framework')   => 'meta_value_num',
						__("post__in parameter", 'framework')   => 'post__in'
					),
					"description" => __("Specify sorting method.<br>WP_Query parameter <code>orderby</code>", 'framework')
				),
				array(
					"type" => "dropdown",
					// "holder" => "div",
					"class" => "",
					"heading" => __("Sort order", 'framework'),
					"param_name" => "order",
					"value" => array(
						'' => '',
						__("Descending (default)", 'framework')   => 'DESC',
						__("Ascending", 'framework')   => 'ASC'
					),
					"description" => __("Specify sorting order, ascending or descending.<br>WP_Query parameter <code>order</code>", 'framework')
				),

				array(
					"type" => "textfield",
					// "holder" => "div",
					"class" => "",
					"heading" => __("Taxonomy", 'framework'),
					"param_name" => "taxonomy_slug",
					"value" => '',
					"description" => __("The name of a custom taxonomy to query.<br>WP_Query parameter <code>tax_query->taxonomy</code>", 'framework')
				),
				array(
					"type" => "textfield",
					// "holder" => "div",
					"class" => "",
					"heading" => __("Taxonomy terms", 'framework'),
					"param_name" => "taxonomy_terms",
					"value" => '',
					"description" => __("A comma separated list of taxonomy terms, use with the taxonomy fields above.<br>WP_Query parameter <code>tax_query->terns</code>", 'framework')
				),
				array(
					"type" => "textarea",
					// "holder" => "div",
					"class" => "",
					"heading" => __("Other Parameters", 'framework'),
					"param_name" => "string",
					"value" => __("", 'framework'),
					"description" => __("Additional <a href='http://codex.wordpress.org/Class_Reference/WP_Query' target='_blank'>WP_Query</a> parameters can be entered here. Use the format <code>parameter=value&amp;parameter_2=value2</code> You should not enter any blank spaces or quotes.", 'framework')
				)
			)
		);
		// Call mapping function
		wpb_map($settings);
	}

// }

// Simple Content Shortcode
// ...............................................................

// Check if [blog] shortcode exists
// if ( array_key_exists('content_rotator', $GLOBALS['shortcode_tags']) ) {

	// Map to WPBakery VC
	if (function_exists('wpb_map')) {
		// Item settings and options
		$settings = array(
			"name" => __("Simple Content", 'framework'),
			"base" => "simple_content",
			"class"		=> "",
			"wrapper_class" => "clearfix",
			// "controls" => "full", 
			"icon" => "icon-wpb-application-icon-large",
			"category" => __('Content', 'framework'),
			"params" => array(
				// Post Id
				array(
					"type" => "textfield",
					// "holder" => "div",
					'admin_label' => true,
					"class" => "",
					"heading" => __("Post id", 'framework'),
					"param_name" => "post_id",
					"value" => "",
					"description" => __("Enter the id of the post you want to show. Can also be an ID of other post types.", 'framework')
				),
				array(
					"type" => "dropdown",
					// "holder" => "div",
					"class" => "",
					"heading" => __("Content Style", 'framework'),
					"param_name" => "image_position",
					"value" => array(
						__("Image Left", 'framework')   => 'image_left',
						__("Image Top", 'framework')   => 'image_top'
					),
					"description" => __("Decide wether the featured image of the post (if existing) should be on the left or on the top of the text", 'framework')
				),
				array(
					"type" => "checkbox",
					// "holder" => "div",
					"class" => "",
					// "heading" => __("Use Post Excerpts", 'framework'),
					"param_name" => "hide_title",
					"value" => array(
						__('Hide Item Title', 'framework') => 'true'
					),
					"description" => __('Hide item title.','framework')
				),
				array(
					"type" => "textfield",
					// "holder" => "div",
					"class" => "",
					"heading" => __("Excerpt length", 'framework'),
					"param_name" => "excerpt_length",
					"value" => '30',
					"description" => __("The number of words in post excerpts, 250 max. Custom excerpts are not restricted by this setting.", 'framework')
				),
				array(
					"type" => "textfield",
					"class" => "",
					"heading" => __("Button Text", 'framework'),
					"param_name" => "button_text",
					"value" => __("Learn More", 'framework'),
					"description" => __("Change the text on the read more button. Enter '-1' for no button", 'framework')
				)
			)
		);
		// Call mapping function
		wpb_map($settings);
	}

// }

// Icon Box Shortcode
// ...............................................................

add_shortcode( 'simple_content', 'shortcode_simple_content' );
function shortcode_simple_content( $atts, $content = null ) {
	extract(shortcode_atts(array(
		'post_id' => false,
		'hide_title' => false,
		'post_excerpt' => false,
		'excerpt_length' => false,
		'button_text' => false,
		'image_position' => 'image_top',
	), $atts));

	global $Runway_ContentRotator;

	$class = 'simpleContent';

	// get post
	if (!$post_id) {
		return __('Please enter a post id in the simple content short code.', 'framework');
	}

	$new_query = new WP_Query(array('p' => $post_id));

	if ($new_query->have_posts()) {
		$new_query->the_post();

		$title = '';
		$button = '';
		$img = '';
		if (!$hide_title) 
			$title = '<h2>'. get_the_title().'</h2>';
		if (str_replace(array("'",'"'), "", trim($button_text)) != "-1" && !empty($button_text)) {
			$button = '<a class="btn small" href="'. get_permalink(get_the_ID()) .'">'. $button_text .'</a>';
		}
		$class .= " ".$image_position;

		if(has_post_thumbnail(get_the_ID())) {
			$thumb_size = ($image_position == 'image_left') ? '228x186' : 'big';
			$image = $Runway_ContentRotator->getResizedImage(array('post_id' => $post_id, 'image_size' => $thumb_size));
			$img .= '<div class="image">';
			$img .= $image['full_image_tag'];
			$img .= '<div class="image-overlay"></div>';
			$img .= '</div>';
		}

		$content = wpb_js_remove_wpautop(get_the_content()); // fix unclosed/unwanted paragraph tags in $content
		$content = customExcerpt($content, $excerpt_length);
		$box  = '<div class="'.$class.' clear">';
		$box .= $img;
		$box .= '<div class="textContent">';
		$box .= $title;
		$box .= '<div class="theText">'.do_shortcode($content).'</div>';
		$box .= $button;

		$box .= '</div>';
		$box .= '</div>';
	}
	else {
		return sprintf(__('There is no post with the ID %d (simple content short code)', 'framework'), get_the_ID());
	}
	wp_reset_postdata();

	return $box;
}



// CSS3 Web Pricing Tables Grid
// ...............................................................
// Map to WPBakery VC
if (function_exists('css3_grid_activate') && function_exists('wpb_map')) {

	// get the grid items
	global $wpdb;
	
	$query = "SELECT option_name FROM {$wpdb->options}
	          WHERE option_name LIKE 'css3_grid_shortcode_settings%'
	          ORDER BY option_name";
	$pricing_tables_list = $wpdb->get_results($query);
	$css3GridAllShortcodeIds = array();

	if (isset($pricing_tables_list) && !empty($pricing_tables_list)) {
		foreach ($pricing_tables_list as $pricing_table) {
			$css3GridAllShortcodeIds[substr($pricing_table->option_name, 29)] = substr($pricing_table->option_name, 29);
		}
	}

	// Item settings and options
	$settings = array(
		"name" => __("CSS3 Pricing Tables", 'framework'),
		"base" => "css3_grid",
		"class"		=> "",
		"wrapper_class" => "clearfix",
		"icon" => "icon-wpb-application-icon-large",
		"category" => __('Content', 'framework'),
		"params" => array(
			array(
				"type" => "dropdown",
				"class" => "",
				'admin_label' => true,
				"heading" => __("Pring Table", 'framework'),
				"param_name" => "id",
				"value" => $css3GridAllShortcodeIds,
				"description" => __("Select the pricing table you want to display", 'framework')
			)
		)
	);

	// Call mapping function
	wpb_map($settings);
}

// CSS3 Web Pricing Tables Grid
// ...............................................................
// Map to WPBakery VC
if (class_exists('GW_GoPricing') && function_exists('wpb_map')) {
        
	// get the grid items
	global $wpdb;
	$tables = get_option(GW_GO_PREFIX . 'tables');
	$arr = array();
	
	if (isset($tables) && !empty($tables)) {
		foreach($tables as $table) {
			$arr[$table['table-name']] = $table['table-id'];
		}
	}

	// Item settings and options
	$settings = array(
		"name" => __("Go - Responsive Pricing & Compare Tables", 'framework'),
		"base" => "go_pricing",
		"class"		=> "",
		"wrapper_class" => "clearfix",
		"icon" => "icon-wpb-application-icon-large",
		"category" => __('Content', 'framework'),
		"params" => array(
			array(
				"type" => "dropdown",
				"class" => "",
				'admin_label' => true,
				"heading" => __("Pring Table", 'framework'),
				"param_name" => "id",
				"value" => $arr,
				"description" => __("Select the pricing table you want to display", 'framework')
			),
			array(
				"type" => "textfield",
				"class" => "",
				"heading" => __("Margin Bottom", 'framework'),
				"param_name" => "margin_bottom",
				"value" => "",
				"description" => __("Space below pricing table (optional). Default: 20px", 'framework')
			),
		)
	);
	// Call mapping function
	wpb_map($settings);
}
