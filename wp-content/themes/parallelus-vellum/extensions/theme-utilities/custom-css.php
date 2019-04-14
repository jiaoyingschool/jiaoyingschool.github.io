<?php

#-----------------------------------------------------------------
# Include Custom CSS in Theme Header
#-----------------------------------------------------------------


// Add styles to header
//-----------------------------------------------------------------
function theme_options_custom_css() {
	// Custom Styles from Theme Options
	echo '<style type="text/css">'. theme_custom_styles() .'</style>';
}
// Add hook for front-end <head></head>
add_action('wp_head', 'theme_options_custom_css', 101); // low priority to get it near the end


// Get custom styles from theme options
//-----------------------------------------------------------------
if ( ! function_exists( 'theme_custom_styles' ) ) :
function theme_custom_styles() {

	// Get header and footer information
	$header_data = get_layout_options('header');
	$header = (isset($header_data)) ? $header_data : false;

	$footer_data = get_layout_options('footer');
	$footer = (isset($footer_data)) ? $footer_data : false;

	// Get "other" layout data
	$layout_data = get_layout_options('other_options');
	$layout_options = (isset($layout_data)) ? $layout_data : false;

	// Styles variable
	$CustomStyles = '';

	#-----------------------------------------------------------------
	# Styles from Theme Options
	#-----------------------------------------------------------------

	// Accent Color - Primary
	//................................................................

	$accent_1_default = get_options_data('options-page', 'accent-color-1'); // default
	$accent_1_layout  = (isset($layout_options['accent-color-1'])) ? $layout_options['accent-color-1'] : ''; // layout specific
	$accent_1 = (!empty($accent_1_layout) && $accent_1_layout !== '#') ? $accent_1_layout : $accent_1_default; 

	if (!empty($accent_1) && $accent_1 !== '#') {
		
		$accentStyles  = '.accent-primary, article.format-quote a:hover .post-header, article.format-link a:hover .post-header, .overlay-effect-slide .inner-overlay i, .overlay-effect-accent .inner-overlay, .overlay-effect-zoom-accent .inner-overlay, .jp-play-bar, .jp-volume-bar-value, .impactBtn, .impactBtn:hover, .impactBtn:active, body a.impactBtn, body a.impactBtn:link, body a.impactBtn:visited, .wpb_call_to_action .wpb_button.wpb_accent-primary, .wpb_call_to_action .wpb_button.wpb_accent-primary:hover, .wpb_call_to_action .wpb_button.wpb_accent-primary:active, .vc_progress_bar .vc_single_bar.accent-primary .vc_bar { background-color: '. $accent_1 .'; }';
		$accentStyles .= '.accent-primary-border, .inner-overlay i, [class*="image-border-"] img, img[class*="image-border-"], .wpb_button.wpb_accent-primary, .wpb_button.wpb_accent-primary:active { border-color: '. $accent_1 .'; }';
		$accentStyles .= 'div.wpb_tour .ui-tabs .ui-tabs-nav li.ui-tabs-active a, div.wpb_tour .ui-tabs .ui-tabs-nav li.ui-tabs-active a:hover, body #megaMenu ul.megaMenu > li.menu-item.current-menu-item > a  { border-bottom-color: '. $accent_1 .'; }';
		$accentStyles .= '.accent-primary-color, h1 em, h2 em, h3 em, h4 em, h5 em, h6 em, h2.wpb_call_text em, .iconBox.icon i.fa, div.wpb_wrapper h4.wpb_toggle:hover:before, div.wpb_accordion .wpb_accordion_wrapper .ui-accordion-header:hover .ui-icon, .inner-overlay i.fa, .wpb_button.wpb_accent-primary, .wpb_button.wpb_accent-primary:active, .woocommerce ul.products li.product .price, .woocommerce-page ul.products li.product .price { color: '. $accent_1 .'; -webkit-text-stroke-color: '. $accent_1 .'; }';
	
		// Add styles to CSS variable
		$CustomStyles .= $accentStyles;
	}

	// Body background
	//................................................................

	// Layout specific setting
	$layoutBgColor    = (isset($layout_options['background-color'])) ? $layout_options['background-color'] : '';
	$layoutBgPosition = (isset($layout_options['background-position'])) ? $layout_options['background-position'] : '';
	$layoutBgRepeat   = (isset($layout_options['background-repeat'])) ? $layout_options['background-repeat'] : '';
	$layoutBgImage    = (isset($layout_options['background-image'])) ? $layout_options['background-image'] : '';
	// Theme options "default" setting
	$defaultBgColor    = get_options_data('options-page', 'background-color');
	$defaultBgPosition = get_options_data('options-page', 'background-position');
	$defaultBgRepeat   = get_options_data('options-page', 'background-repeat');
	$defaultBgImage    = get_options_data('options-page', 'background-image');
	// Select layout or default
	$bodyBgColor  = (!empty($layoutBgColor) && $layoutBgColor !== '#' ) ? $layoutBgColor : $defaultBgColor; 
	$bodyPosition = (!empty($layoutBgPosition)) ? $layoutBgPosition : $defaultBgPosition; 
	$bodyRepeat   = (!empty($layoutBgRepeat)) ? $layoutBgRepeat : $defaultBgRepeat; 
	$bodyImage    = (!empty($layoutBgImage)) ? $layoutBgImage : $defaultBgImage; 

	$bodyBg       = '';
	if ( $bodyBgColor && $bodyBgColor != '#' ) {
		$bodyBg = 'background-color: '. $bodyBgColor .'; ';
	}
	if ( $bodyImage ) {
		$bodyBg .= 'background-image: url('. $bodyImage .'); ';
		$bodyBg .= 'background-repeat: '. $bodyRepeat .'; ';
		if ( $bodyPosition == 'cover' ) {
			$bodyBg .= 'background-size: cover; ';
			$bodyBg .= 'background-attachment: fixed; ';		
			$bodyBg .= 'background-position: center; ';		
		} elseif ( $bodyPosition == 'cover-only' ) {
			$bodyBg .= 'background-size: cover; ';
		} elseif ( !empty($bodyPosition) ) {
			$bodyBg .= 'background-position: '. $bodyPosition . ' top; ';		
		}
	}
	if (isset($bodyBg)) {
		
		$bodyBgStyles = 'body, body.boxed { '. $bodyBg .'; }';

		// Add styles to CSS variable
		$CustomStyles .= $bodyBgStyles;
	}

	// Design width
	//................................................................

	$designWidth = (isset($layout_options['design-width']) && !empty($layout_options['design-width'])) ? $layout_options['design-width'] : get_options_data('options-page', 'design-width'); 
	if ( $designWidth && $designWidth != '' ) {
		$width = str_replace(' ', '', strtolower($designWidth));
		if (strpos($width,'px') === false && strpos($width,'%') === false) {
			$width = $width . 'px';
		}
		$design_MaxWidth = $width;
	}
	if (isset($design_MaxWidth)) {
		$designWidthStyles = 'body.boxed #page, body.boxed-left #page, body.boxed-right #page, #Top, #Middle, #Bottom, .full-width .masthead-row, .boxed .masthead-row { max-width: '. $design_MaxWidth .'; }';
		// Add styles to CSS variable
		$CustomStyles .= $designWidthStyles;
	}

	// Content position on page
	//................................................................

	$contentPos = (isset($layout_options['content-position']) && !empty($layout_options['content-position'])) ? $layout_options['content-position'] : get_options_data('options-page', 'content-position'); 
	if ( $contentPos == 'left' || $contentPos == 'right' ) {
		$content_position = 'margin-'. $contentPos .': 0;';
	}
	if (isset($content_position)) {
		$designContentPosition = '#Top, #Middle, #Bottom, .boxed #page, .boxed-left #page, .boxed-right #page, .full-width .masthead-row, .boxed .masthead-row { '. $content_position .' }';
		// Add styles to CSS variable
		$CustomStyles .= $designContentPosition;
	}
	
	// Links
	//................................................................

	$linkColor = (isset($layout_options['link-color']) && !empty($layout_options['link-color']) && $layout_options['link-color'] !== '#') ? $layout_options['link-color'] : get_options_data('options-page', 'link-color'); 
	if (!empty($linkColor) && $linkColor != '#') {
		$linkStyles = "a, .widget a { color: ". $linkColor ."; }";
		// Add styles to CSS variable
		$CustomStyles .= $linkStyles;
	}
	// Hover (links)
	$hoverColor = (isset($layout_options['link-hover-color']) && !empty($layout_options['link-hover-color']) && $layout_options['link-hover-color'] !== '#') ? $layout_options['link-hover-color'] : get_options_data('options-page', 'link-hover-color'); 
	if (!empty($hoverColor) && $hoverColor != '#') { 
		$linkHoverStyles = "a:hover, .entry-title a:hover, .widget a:hover, .wpb_carousel .post-title a:hover, .masthead-container .widget-area a:hover { color: ". $hoverColor ."; }";
		// Add styles to CSS variable
		$CustomStyles .= $linkHoverStyles;
	}

	// Menu 
	//................................................................

	// Color menu font
	$menu_font_color    = get_options_data('options-page', 'menu-font-color');
	$header_font_color  = (isset($header['menu-font-color'])) ? $header['menu-font-color'] : '';
	$menu_color         = ( !empty( $header_font_color ) && $header_font_color != '#' ) ? $header_font_color : $menu_font_color;
	$font_Menu          = get_options_data('options-page', 'font-menu-standard', 'default');
	$gFont_Menu         = get_options_data('options-page', 'font-menu-google');
	$menuFont           = false;
	$menuFontSize       = false;
	$menuFontStyles     = '';
	
	// Standard Font Index
	$standard_font = array(
		"arial" => "Arial,Helvetica,Garuda,sans-serif",
		"arial-black" => "'Arial Black',Gadget,sans-serif",
		"courier-new" => "'Courier New',Courier,monospace",
		"georgia" => "Georgia,'Times New Roman',Times, serif",
		"lucida-console" => "'Lucida Console',Monaco,monospace",
		"lucida-sans-unicode" => "'Lucida Sans Unicode','Lucida Grande',sans-serif",
		"palatino-linotype" => "'Palatino Linotype','Book Antiqua',Palatino,serif",
		"tahoma" => "Tahoma,Geneva,sans-serif",
		"times-new-roman" => "'Times New Roman',Times,serif",
		"trebuchet-ms" => "'Trebuchet MS',Arial,Helvetica,sans-serif",
		"verdana" => "Verdana,Geneva,sans-serif"
	);

	// Font Color
	if ( !empty( $menu_color ) && $menu_color != '#' ) {
		$menuFontStyles .= 'color:'.$menu_color.'; text-shadow: none;';
	}
	// Font Face
	if (!empty($gFont_Menu)) {
		// Get just the font name
		$menuFont = str_replace( '+', ' ', substr($gFont_Menu, 0, (strpos($gFont_Menu, ':')) ? strpos($gFont_Menu, ':') : strlen($gFont_Menu)) );
	} elseif (!empty($font_Menu) && $font_Menu != 'default') {
		$menuFont = $standard_font[$font_Menu];
	}
	if ($menuFont) { 
		// Get the styles
		$menuFontStyles .= 'font-family: '. $menuFont .';';
	}
	// Font Size
	$menuFontSize = trim(get_options_data('options-page', 'font-menu-size', 'false'));
	if ($menuFontSize !== 'false' && !empty($menuFontSize)) {
		if (!strpos($menuFontSize,'px') && !strpos($menuFontSize,'em') && !strpos($menuFontSize,'rem') ) {
			$menuFontSize .= 'px';
		}
		$menuFontStyles .= 'font-size: '.$menuFontSize.';'; 
	}
	// Add menu styles 
	if ( !empty($menuFontStyles) ) {
		$CustomStyles .= '#MainNav #megaMenu ul.megaMenu li.menu-item.ss-nav-menu-item-depth-0 > a span, #megaMenu.megaMenuHorizontal ul.megaMenu > li.menu-item.current-menu-item > a, #megaMenu.megaMenuHorizontal ul.megaMenu > li.menu-item.current-menu-item > a:visited, .navSearch a#NavSearchLink, .navSearch a#NavSearchLink:hover, .navSearch a#NavSearchLink:visited, #MainNav #megaMenu ul.megaMenu li.menu-item.ss-nav-menu-item-depth-0 > a:hover span, body #megaMenu ul.megaMenu > li.menu-item:hover > a, body #megaMenu ul.megaMenu > li.menu-item.ss-nav-menu-mega:hover > a, body #megaMenu ul.megaMenu > li.menu-item.ss-nav-menu-reg.mega-with-sub:hover > a, body #megaMenu ul.megaMenu > li.menu-item.ss-nav-menu-mega.megaHover > a, body #megaMenu ul.megaMenu > li.menu-item.ss-nav-menu-reg.mega-with-sub.megaHover > a, body #megaMenu.megaMenuHorizontal ul.megaMenu > li.menu-item.current-menu-item > a:hover { '.$menuFontStyles.' }';
	}

	// Color active menu button
	$menu_active_color   = get_options_data('options-page', 'menu-active-color');
	$header_active_color = (isset($header['menu-active-color'])) ? $header['menu-active-color'] : '';
	$active_color        = ( !empty( $header_active_color ) && $header_active_color != '#' ) ? $header_active_color : $menu_active_color;
	if( !empty( $active_color ) && $active_color != '#' ) {
		$CustomStyles .= '#MainNav #megaMenu ul.megaMenu li.current-menu-item.ss-nav-menu-item-depth-0 > a span { color:'.$active_color.' }';
	} 
	
	// Masthead background
	//................................................................

	// Default color & image
	$mastheadBg = false;
	$mastheadBgRepeat = 'no-repeat';
	$mastheadBgPosition = 'left';
	$mastheadBgColor = get_options_data('options-page', 'masthead-background-color');
	if ($mastheadBgImage = get_options_data('options-page', 'masthead-background-image')) {
		$mastheadBgRepeat = get_options_data('options-page', 'masthead-background-repeat');
		$mastheadBgPosition = get_options_data('options-page', 'masthead-background-position');
	}
	// Masthead specific color & image
	if ( !empty($header['masthead-background-color']) && $header['masthead-background-color'] !== '#' ) {
		$mastheadBgColor = $header['masthead-background-color'];	
	}
	if ( !empty($header['masthead-background-image']) ) {
		$mastheadBgImage = $header['masthead-background-image'];
		$mastheadBgImage = (strtolower($mastheadBgImage) == 'none') ? '' : $mastheadBgImage;
		if ( !empty($header['masthead-background-repeat']) ) 
			$mastheadBgRepeat = $header['masthead-background-repeat'];	
		if ( !empty($header['masthead-background-position']) )
			$mastheadBgPosition = $header['masthead-background-position'];	
	}
	// Prepare the CSS
	if ( isset($mastheadBgColor) && !empty($mastheadBgColor) && $mastheadBgColor != '#' ) {
		$mastheadBg = 'background-color: '. $mastheadBgColor .'; ';
		$CustomStyles .= '#masthead {'. $mastheadBg .'}';
	}
	if ( isset($mastheadBgImage) && !empty($mastheadBgImage) ) {
		$mastheadBg .= 'background-image: url('. $mastheadBgImage .'); ';
		$mastheadBg .= 'background-position: '. $mastheadBgPosition . ' top; '; 
		if ( $mastheadBgRepeat == 'cover' || $mastheadBgRepeat == 'contain' ) {
			$mastheadBg .= 'background-size: '. $mastheadBgRepeat .'; '; 
			$mastheadBg .= 'background-repeat: no-repeat; ';
		} else {
			$mastheadBg .= 'background-repeat: '. $mastheadBgRepeat .'; ';
		}
	}
	// Output the CSS
	if ($mastheadBg) {
		// Get the styles
		$mastheadStyles = '.boxed #masthead, .full-width #masthead, .boxed-left .masthead-vertical-bg, .full-width-left .masthead-vertical-bg, .boxed-right .masthead-vertical-bg, .full-width-right .masthead-vertical-bg { '. $mastheadBg .' }';
		// Add styles to CSS variable
		$CustomStyles .= $mastheadStyles;
	}

	// Masthead gradient overlay
	//................................................................

	// Layout specific setting
	$layoutTopGradient     = (isset($header['masthead-gradient-top-opacity'])) ? $header['masthead-gradient-top-opacity'] : '';
	$layoutBottomGradient  = (isset($header['masthead-gradient-bottom-opacity'])) ? $header['masthead-gradient-bottom-opacity'] : '';
	// Theme options "default" setting
	$defaultTopGradient     = get_options_data('options-page', 'masthead-gradient-top-opacity');
	$defaultBottomGradient  = get_options_data('options-page', 'masthead-gradient-bottom-opacity');
	// Select layout or default
	$mastheadTopGradient    = (isset($layoutTopGradient) && !empty($layoutTopGradient)) ? $layoutTopGradient : $defaultTopGradient; 
	$mastheadBottomGradient = (isset($layoutBottomGradient) && !empty($layoutBottomGradient)) ? $layoutBottomGradient : $defaultBottomGradient; 

	// Prepare the CSS
	if ( isset($mastheadTopGradient) && !empty($mastheadTopGradient) ) {
		if ($mastheadTopGradient == 'zero') { $mastheadTopGradient = 0; }
		$mastheadTopOpacity = 'opacity: '. $mastheadTopGradient .'; ';
	}
	if ( isset($mastheadBottomGradient) && !empty($mastheadBottomGradient) ) {
		if ($mastheadBottomGradient == 'zero') { $mastheadBottomGradient = 0; }
		$mastheadBottomOpacity = 'opacity: '. $mastheadBottomGradient .'; ';
	}
	// Output the CSS
	if ($mastheadTopOpacity) {
		// Add styles to CSS variable
		$CustomStyles .= '.masthead-container > .top-wrapper:before { '. $mastheadTopOpacity .'; }';
	}
	if ($mastheadBottomOpacity) {
		// Add styles to CSS variable
		$CustomStyles .= '#MastheadSidebar-2 .widget-area:before { '. $mastheadBottomOpacity .'; }';
	}

	// Header background
	//................................................................

	// Default color & image
	$headerBg = false;
	$headerBgRepeat = 'no-repeat';
	$headerBgPosition = 'left';
	$headerBgColor = get_options_data('options-page', 'header-background-color');
	if ($headerBgImage = get_options_data('options-page', 'header-background-image')) {
		$headerBgRepeat = get_options_data('options-page', 'header-background-repeat');
		$headerBgPosition = get_options_data('options-page', 'header-background-position');
	}
	// Header specific color & image
	if ( !empty($header['header-background-color']) && $header['header-background-color'] != '#'  ) {
		$headerBgColor = $header['header-background-color'];	
	}
	if ( !empty($header['header-background-image'])) {
		$headerBgImage = $header['header-background-image'];	
		if ( !empty($header['header-background-repeat']) )
			$headerBgRepeat = $header['header-background-repeat'];	
		if ( !empty($header['header-background-position']) )
			$headerBgPosition = $header['header-background-position'];	
	}
	// Prepare the CSS
	if ( isset($headerBgColor) && !empty($headerBgColor) && $headerBgColor != '#' ) {
		$headerBg = 'background-color: '. $headerBgColor .'; ';
	}
	if ( isset($headerBgImage) && !empty($headerBgImage) ) {
		$headerBg .= 'background-image: url('. $headerBgImage .'); ';
		$headerBg .= 'background-position: '. $headerBgPosition . ' top; '; 
		if ( $headerBgRepeat == 'cover' || $headerBgRepeat == 'contain' ) {
			$headerBg .= 'background-size: '. $headerBgRepeat .'; '; 
			$headerBg .= 'background-repeat: no-repeat; ';
		} else {
			$headerBg .= 'background-repeat: '. $headerBgRepeat .'; ';
		}
	}
	// Output the CSS
	if ($headerBg) {
		// Get the styles
		$headerStyles = '#TopContent_1, #TopContent_2 { '. $headerBg .' }';
		// Add styles to CSS variable
		$CustomStyles .= $headerStyles;
	}

	// Footer Top background
	//................................................................

	// Default color & image
	$footerTopBg = false;
	$footerTopBgRepeat = 'no-repeat';
	$footerTopBgPosition = 'left';
	$footerTopBgColor = get_options_data('options-page', 'footer-top-background-color');
	if ($footerTopBgImage = get_options_data('options-page', 'footer-top-background-image')) {
		$footerTopBgRepeat = get_options_data('options-page', 'footer-top-background-repeat');
		$footerTopBgPosition = get_options_data('options-page', 'footer-top-background-position');
	}
	// Header specific color & image
	if ( !empty($footer['footer-top-background-color']) && $footer['footer-top-background-color'] != '#' ) {
		$footerTopBgColor = $footer['footer-top-background-color'];	
	}
	if ( !empty($footer['footer-top-background-image']) ) {
		$footerTopBgImage = $footer['footer-top-background-image'];	
		if ( !empty($footer['footer-top-background-repeat']) )
			$footerTopBgRepeat = $footer['footer-top-background-repeat'];	
		if ( !empty($footer['footer-top-background-position']) )
			$footerTopBgPosition = $footer['footer-top-background-position'];	
	}
	// Prepare the CSS
	if ( isset($footerTopBgColor) && !empty($footerTopBgColor) && $footerTopBgColor !== '#' ) {
		$footerTopBg = 'background-color: '. $footerTopBgColor .'; ';
	}
	if ( isset($footerTopBgImage) && !empty($footerTopBgImage) ) {
		$footerTopBg .= 'background-image: url('. $footerTopBgImage .'); ';
		$footerTopBg .= 'background-repeat: '. $footerTopBgRepeat .'; ';
		$footerTopBg .= 'background-position: '. $footerTopBgPosition . ' top;'; 
	}
	// Output the CSS
	if ($footerTopBg) {
		// Get the styles
		$footerTopStyles = '#FooterTop { '. $footerTopBg .'; }';
		// Add styles to CSS variable
		$CustomStyles .= $footerTopStyles;
	}

	// Footer Bottom background
	//................................................................

	// Default color & image
	$footerBg = false;
	$footerBgRepeat = 'no-repeat';
	$footerBgPosition = 'left';
	$footerBgColor = get_options_data('options-page', 'footer-bottom-background-color');
	if ($footerBgImage = get_options_data('options-page', 'footer-bottom-background-image')) {
		$footerBgRepeat = get_options_data('options-page', 'footer-bottom-background-repeat');
		$footerBgPosition = get_options_data('options-page', 'footer-bottom-background-position');
	}
	// Footer specific color & image
	if ( !empty($footer['footer-bottom-background-color']) && $footer['footer-bottom-background-color'] != '#' ) {
		$footerBgColor = $footer['footer-bottom-background-color'];	
	}
	if ( !empty($footer['footer-bottom-background-image']) ) {
		$footerBgImage = $footer['footer-bottom-background-image'];	
		if ( !empty($footer['footer-bottom-background-repeat']) )
			$footerBgRepeat = $footer['footer-bottom-background-repeat'];	
		if ( !empty($footer['footer-bottom-background-position']) )
			$footerBgPosition = $footer['footer-bottom-background-position'];	
	}
	// Prepare the CSS
	if ( isset($footerBgColor) && !empty($footerBgColor) && $footerBgColor != '#' ) {
		$footerBg = 'background-color: '. $footerBgColor .'; ';
	}
	if ( isset($footerBgImage) && !empty($footerBgImage) ) {
		$footerBg .= 'background-image: url('. $footerBgImage .'); ';
		$footerBg .= 'background-repeat: '. $footerBgRepeat .'; ';
		$footerBg .= 'background-position: '. $footerBgPosition . ' top;'; 
	}
	// Output the CSS
	if ($footerBg) {
		// Get the styles
		$footerBottomStyles = '#FooterBottom { '. $footerBg .'; }';
		// Add styles to CSS variable
		$CustomStyles .= $footerBottomStyles;
	}

	// Fonts
	//................................................................

	$font_Heading  = get_options_data('options-page', 'font-heading-standard', 'default');
	$font_Body     = get_options_data('options-page', 'font-body-standard', 'default');
	$gFont_Heading = get_options_data('options-page', 'font-heading-google');
	$gFont_Body    = get_options_data('options-page', 'font-body-google');
	$color_Heading = get_options_data('options-page', 'font-heading-color');
	$color_Body    = get_options_data('options-page', 'font-body-color');
	$size_H        = array( 'h1', 'h2', 'h3', 'h4', 'h5', 'h6' );

	// Standard Font Index
	$standard_font = array(
		"arial" => "Arial,Helvetica,Garuda,sans-serif",
		"arial-black" => "'Arial Black',Gadget,sans-serif",
		"courier-new" => "'Courier New',Courier,monospace",
		"georgia" => "Georgia,'Times New Roman',Times, serif",
		"lucida-console" => "'Lucida Console',Monaco,monospace",
		"lucida-sans-unicode" => "'Lucida Sans Unicode','Lucida Grande',sans-serif",
		"palatino-linotype" => "'Palatino Linotype','Book Antiqua',Palatino,serif",
		"tahoma" => "Tahoma,Geneva,sans-serif",
		"times-new-roman" => "'Times New Roman',Times,serif",
		"trebuchet-ms" => "'Trebuchet MS',Arial,Helvetica,sans-serif",
		"verdana" => "Verdana,Geneva,sans-serif"
	);

	// Heading font
	//................................................................

	$headingFont = false;
	if (!empty($gFont_Heading)) {
		// Get just the font name
		$headingFont = str_replace( '+', ' ', substr($gFont_Heading, 0, (strpos($gFont_Heading, ':')) ? strpos($gFont_Heading, ':') : strlen($gFont_Heading)) );
	} elseif (!empty($font_Heading) && $font_Heading != 'default') {
		$headingFont = $standard_font[$font_Heading];
	}
	if ($headingFont) { 
		// Get the styles
		$headingFontStyles = 'h1, h2, h3, h4, h5, h6, h2.wpb_call_text, .page-title, .headline, .comments-area article header cite, .vc_text_separator div, .headline, .entry-title.headline, #page .wpb_accordion .ui-accordion .ui-accordion-header { font-family: '. $headingFont .'; }';
		// Add styles to CSS variable
		$CustomStyles .= $headingFontStyles;
	}
	if (!empty($color_Heading) && $color_Heading !== '#') {
		// Get RGB version of color
		$colorHeading_rgba = get_as_rgba($color_Heading, '.85'); // at .85 opacity
		// Get the styles
		$headingColorStyles = 'h1, h2, h3, h4, h5, h6, h2.wpb_call_text, .page-title, .headline, .comments-area article header cite, div.wpb_wrapper h4.wpb_toggle, .vc_text_separator div, #page .wpb_accordion .ui-accordion .ui-accordion-header a, #page .wpb_accordion .ui-accordion .ui-accordion-header a:hover, .site-header .site-title a, .entry-title, .entry-title a, .widget .content-rotator-heading, .wpb_carousel .post-title a, .widget-area .widget li[class*="current"] a, .iconBox.icon i.fa, .iconBox .iconBoxTitle, .rotator .entry-title a { color: '. $color_Heading .'; -webkit-text-stroke: 0.015em '.$colorHeading_rgba.'; }';
		// Add styles to CSS variable
		$CustomStyles .= $headingColorStyles;
	}
	// Headings sizes
	foreach ($size_H as $h) {
		$size = trim(get_options_data('options-page', 'font-'.$h.'-size', 'false'));
		if ($size !== 'false' && !empty($size)) {
			if (!strpos($size,'px') && !strpos($size,'em') && !strpos($size,'rem') ) {
				$size .= 'px';
			}
			$CustomStyles .= $h .' { font-size: '.$size.' }';
		}
	}

	// Body font
	//................................................................

	$bodyFont       = false;
	$bodyFontSize   = false;
	$bodyFontStyles = '';

	// Font Face
	if (!empty($gFont_Body)) {
		// Get just the font name
		$bodyFont = str_replace( '+', ' ', substr($gFont_Body, 0, strpos($gFont_Body, ':')) );
		$bodyFont = str_replace( '+', ' ', substr($gFont_Body, 0, (strpos($gFont_Body, ':')) ? strpos($gFont_Body, ':') : strlen($gFont_Body)) );
	} elseif (!empty($font_Body) && $font_Body != 'default') {
		$bodyFont = $standard_font[$font_Body];
	}
	if ( $bodyFont && !empty($bodyFont) ) { 
		$bodyFontStyles .= 'font-family: '. $bodyFont. ';' ;
	}
	// Font Color
	if ( !empty($color_Body) && $color_Body != '#' ) { 
		$bodyFontStyles .= 'color: '.$color_Body.';'; 
	}
	// Font Size
	$bodyFontSize = trim(get_options_data('options-page', 'font-body-size', 'false'));
	if ($bodyFontSize !== 'false' && !empty($bodyFontSize)) {
		if (!strpos($bodyFontSize,'px') && !strpos($bodyFontSize,'em') && !strpos($bodyFontSize,'rem') ) {
			$bodyFontSize .= 'px';
		}
		$bodyFontStyles .= 'font-size: '.$bodyFontSize.';'; 
	}
	// Add custom styles
	if ( !empty($bodyFontStyles) ) {
		$CustomStyles .= 'body { '.$bodyFontStyles.' }';
	}

	// Custom CSS (user generated)
	//................................................................

	$userStyles = stripslashes(htmlspecialchars_decode(get_options_data('options-page', 'custom-styles'),ENT_QUOTES));

	// Add styles to CSS variable
	$CustomStyles .= $userStyles;

	// all done!
	return $CustomStyles;

}

endif; ?>