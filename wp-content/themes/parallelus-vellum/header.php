<!DOCTYPE html>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js" <?php language_attributes(); ?>> <!--<![endif]-->
<head>
	<meta charset="<?php bloginfo( 'charset' ); ?>" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<meta name="viewport" content="width=device-width">
	<title><?php wp_title( '|', true, 'right' ); ?></title>
	<link rel="profile" href="http://gmpg.org/xfn/11" />
	<link rel="pingback" href="<?php bloginfo( 'pingback_url' ); ?>" />
	<link rel="shortcut icon" href="<?php options_data('options-page', 'favorites-icon'); ?>">
	<link rel="apple-touch-icon-precomposed" href="<?php options_data('options-page', 'mobile-bookmark'); ?>">
	<?php wp_head(); ?>
</head>
<body <?php body_class(); ?>>

<div id="FadeInContent"></div>

<?php

// Header Data
//................................................................
$header_data = get_layout_options('header');
$header = (isset($header_data)) ? $header_data : false;

// Layout Data
//................................................................
$layout_data    = get_layout_options('other_options');
$layout_style   = (isset($layout_data['layout-style']) && !empty($layout_data['layout-style'])) ? $layout_data['layout-style'] : get_options_data('options-page', 'layout-style', 'boxed');

// Breadcrumbs
//................................................................
$showBreadcrumbs = get_options_data('options-page', 'show-breadcrumbs');
$showBreadcrumbs = ( !empty( $header['header-breadcrumbs'] ) ) ? $header['header-breadcrumbs'] : $showBreadcrumbs;

// Search
//................................................................
$mastheadSearch = get_options_data('options-page', 'display-masthead-search');
$mastheadSearch = ( isset($mastheadSearch) && $mastheadSearch == 'false' ) ? 'noSearch' : 'hasSearch';
$placeholderSearch = get_options_data('options-page', 'masthead-search-placeholder', '');

// Begin design
//................................................................
?>	
<div id="page" class="hfeed site">

	<header id="masthead" class="site-header" role="banner">
		<div class="masthead-vertical-bg"></div>
		<div class="masthead-container">
			<div class="top-wrapper">

				<?php 

				// Masthead Area (sidebar 1)
				//................................................................

				if ( !empty($layout_style) && ($layout_style == 'boxed' || $layout_style == 'full-width') ) { 

					// Alternate sidebar for horizontal masthead
					if ( function_exists('is_sidebar_active') && is_sidebar_active('horizontal-masthead-top') ) { ?>
						<div id="MastheadSidebar-1">
							<div class="masthead-row widget-area">
								<div class="inner-wrapper">
									<?php if (!function_exists('dynamic_sidebar') || !dynamic_sidebar('horizontal-masthead-top')) : endif; ?>
								</div>
							</div>
						</div> <!-- / #MastheadSidebar-1 -->
					<?php } 
				
				} else {

					// Sidebar for vertical masthead
					if ( function_exists('is_sidebar_active') && is_sidebar_active('sidebar-masthead-top') ) { ?>
						<div  id="MastheadSidebar-1">
							<div class="masthead-row widget-area">
								<div class="inner-wrapper">
									<?php if (!function_exists('dynamic_sidebar') || !dynamic_sidebar('sidebar-masthead-top')) : endif; ?>
								</div>
							</div>
						</div> <!-- / #MastheadSidebar-1 -->
					<?php } 

				} ?>	
				<div class="masthead-row logo-wrapper">
					<div class="inner-wrapper">
						<?php
						// Logo
						//................................................................
						$home_url = (get_options_data('options-page', 'logo-url')) ? get_options_data('options-page', 'logo-url') : home_url( '/' );
						// The logo image or text
						$logo = get_bloginfo('name');
						$logoImage  = get_options_data('options-page', 'logo-image');
						$logoMobile = get_options_data('options-page', 'logo-mobile');
						$logoWidth  = get_options_data('options-page', 'logo-width');
						$logoAlt    = get_options_data('options-page', 'logo-title');
						$logoClass  = 'logo';
						if ( isset($header['header-alternate-logo']) && !empty($header['header-alternate-logo']) ) {
							$logoImage  = $header['header-alternate-logo'];
							$logoMobile = $logoImage; // may add an option for alternate mobile logo 
							$logoWidth  = (isset($header['header-alternate-logo-width'])) ? $header['header-alternate-logo-width'] : '';
						}
						if ( !isset($logoMobile) || empty($logoMobile) ) {							
							$logoMobile = $logoImage; // may add an option for alternate mobile logo 
						}
						if ($logoImage) {
							$logoWidth   = (isset($logoWidth) && !empty($logoWidth)) ? 'style="width: '. intval($logoWidth) .'px"' : '';
							$logoAlt     = (isset($logoAlt) && !empty($logoAlt)) ? 'alt="'. $logoAlt .'"' : ''; 
							$desktopLogo = '<img src="'.$logoImage.'" '.$logoAlt.' '.$logoWidth.' class="logoDesktop hidden-phone">';
							$mobileLogo  = '<img src="'.$logoMobile.'" '.$logoAlt.' '.$logoWidth.' class="logoMobile visible-phone">';
							$logoClass  .= ' logo-image';
						}
						// IE8 Fix
						$ieLogoWidth = ( !empty($layout_style) && ($layout_style == 'boxed' || $layout_style == 'full-width') ) ? $logoWidth : '';
						?>
						<h1 class="site-title" <?php echo $ieLogoWidth ?>>
							<a href="<?php echo esc_url( $home_url ); ?>" title="<?php echo esc_attr( get_bloginfo( 'name', 'display' ) ); ?>" class="<?php echo $logoClass; ?>" rel="home"><?php echo $desktopLogo . $mobileLogo; ?></a>
						</h1>
					</div>
				</div><!-- .logo-wrapper -->
			</div><!-- .top-wrapper -->

			<div id="MainNav" class="masthead-row <?php echo $mastheadSearch ?>">
				<div class="inner-wrapper clearfix">
					<?php 

					// Navigation Extras (search, breadcrumbs, etc.)
					//................................................................ 

					// Show the search input 
					if ( $mastheadSearch !== 'noSearch' ) { 
						?>
						<div id="NavExtras">
							<div class="navSearch">
								<a href="?s=" id="NavSearchLink"><span class="entypo entypo-search"></span></a>
								<form method="get" id="NavSearchForm" action="<?php echo home_url('/') ?>">
									<div>
										<input type="text" name="s" id="NavS" value="<?php echo get_search_query() ?>" placeholder="<?php echo $placeholderSearch ?>">
										<button type="submit"><?php _e( 'Search', 'framework' ) ?></button>
										<div id="AjaxSearchPane"></div>
									</div>
								</form>
							</div>
						</div> <!-- / #NavExtras -->
						<?php
					} // End $showSearch


					// Navigation - Main Menu
					//................................................................

					// Filter primary navigation for header specific setting 
					// NOTE: Probably want to move each of these to more relevant locations in the code. Filters don't really belong in the header.
					function theme_filter_primary_nav_menu_args( $args ) {

						// Apply only to "primary" theme location
						if( 'primary' == $args['theme_location'] ) {

							// UberMenu Pro - replace menu orientation class (until a better solution is availalbe in UberMenu 3)
							$layout_data    = get_layout_options('other_options');
							$layout_style   = (isset($layout_data['layout-style']) && !empty($layout_data['layout-style'])) ? $layout_data['layout-style'] : get_options_data('options-page', 'layout-style', 'boxed');
							if( isset( $layout_style ) && !empty( $layout_style ) && !class_exists( 'UberMenuLite' ) ) {
								if (in_array( $layout_style,  array('boxed-left', 'full-width-left', 'boxed-right','full-width-right') )) {
									$args['container_class'] = str_replace( 'megaMenuHorizontal', 'megaMenuVertical', $args['container_class'] );
								} else {
									$args['container_class'] = str_replace( 'megaMenuVertical', 'megaMenuHorizontal', $args['container_class'] );
								}
							}

							// Header settings
							$header_data = get_layout_options('header');
							$header = (isset($header_data)) ? $header_data : false;
							$theme_menu = ( isset($header['wp-menus']) && !empty($header['wp-menus']) ) ? $header['wp-menus'] : false; // custom navigation menu 
							if ( $theme_menu ) {
								// Set a custom menu from layout specific setting
								$args['menu'] = $theme_menu;
							}
						}

						return $args;
					}
					add_filter( 'wp_nav_menu_args', 'theme_filter_primary_nav_menu_args', 3000 );

					// Get the menu (Uber or default)
					if ( function_exists( 'uberMenu_direct' ) ) {

						// If select layout for current page
						if( isset( $layout_style ) && !empty( $layout_style ) && class_exists( 'UberMenuLite' ) ) {

							// Call Custom Ubermenu 
							$customMenuObject = new CustomUberMenuLite;
							$customMenuObject->set_settings( $layout_style );
							$customMenuObject->directIntegration( 'primary' );

						}else {
							// Call Ubermenu 
							uberMenu_direct( 'primary' );
						}

					} else {
						// Call WP Nav Menu ?>
						<nav id="site-navigation" class="main-navigation" role="navigation">
						<?php 
							$theme_menu = ( isset($header['wp-menus']) && !empty($header['wp-menus']) ) ? $header['wp-menus'] : '';
							wp_nav_menu( array( 'theme_location' => 'primary', 'menu_class' => 'nav-menu', 'menu' => $theme_menu ) ); 
						?>
						</nav><!-- #site-navigation -->
						<?php
					} ?>
				</div>
				<div class="clear"></div>
			</div><!-- / #MainNav -->

			<div class="bottom-wrapper">
				<?php 

				// Masthead Area (sidebar 2)
				//................................................................

				if ( !empty($layout_style) && ($layout_style == 'boxed' || $layout_style == 'full-width') ) { 

					// Alternate sidebar for horizontal masthead
					if ( function_exists('is_sidebar_active') && is_sidebar_active('horizontal-masthead-bottom') ) { ?>
						<div id="MastheadSidebar-2">
							<div class="masthead-row widget-area">
								<div class="inner-wrapper">
									<?php if (!function_exists('dynamic_sidebar') || !dynamic_sidebar('horizontal-masthead-bottom')) : endif; ?>
								</div>
							</div>
						</div> <!-- / #MastheadSidebar-2 -->
					<?php } 

				} else {

					// Sidebar for vertical masthead
					if ( function_exists('is_sidebar_active') && is_sidebar_active('sidebar-masthead-bottom') ) { ?>
						<div id="MastheadSidebar-2">
							<div class="masthead-row widget-area">
								<div class="inner-wrapper">
								<?php if (!function_exists('dynamic_sidebar') || !dynamic_sidebar('sidebar-masthead-bottom')) : endif; ?>
								</div>
							</div>
						</div> <!-- / #MastheadSidebar-2 -->
					<?php }

				} ?>	

			</div><!-- / .bottom-wrapper -->

			<div class="clear"></div>

		</div><!-- .masthead-container -->
	</header><!-- #masthead -->

	<div id="ContentWrapper">
		<div id="Top">
			<?php 

			// Header Content 1 (above breadcrumbs)
			//................................................................
			$header_one_type = (isset($header['header-content'])) ? get_top_content($header['header-content']) : false;

			if ( !empty($header_one_type) && $header_one_type != 'default' ) {
				?>	
				<section id="TopContent_1" class="top-content-area">
					<?php
					// Top Content 1
					if ($header_one_type !== 'default') { ?>
						<div class="top-content-first type_<?php echo $header_one_type ?>">
							<?php show_top_content($header_one_type, $header['header-content']); ?>
						</div>
					<?php }
					?>
				</section><!-- #TopContent -->
				<?php
			} // End TopContent


			// Breadcrumbs
			//................................................................
			if ( !empty( $showBreadcrumbs ) && $showBreadcrumbs != 'false' ) {

				// Show the breadcrumbs ?>
				<div id="Breadcrumbs">
					<?php if(function_exists('breadcrumbs_display')) {
						breadcrumbs_display();
					}?>
				</div>
				<?php
			} 

			// Header Content 2 (below breadcrumbs)
			//................................................................
			$header_two_type = (isset($header['header-content-2'])) ? get_top_content($header['header-content-2']) : false;

			if ( !empty($header_two_type) && $header_two_type != 'default' ) {
				?>	
				<section id="TopContent_2" class="top-content-area">
					<?php
					// Top Content 2
					if ($header_two_type !== 'default') { ?>
						<div class="top-content-second type_<?php echo $header_two_type ?>">
							<?php show_top_content($header_two_type, $header['header-content-2']); ?>
						</div>
					<?php }
					?>
				</section><!-- #TopContent -->
				<?php
			} // End TopContent
			?>
		</div><!-- #Top -->

		<div id="Middle">
			<div class="main-content">
				<?php

				// Layout Manager - Start Layout
				//................................................................
				do_action('output_layout','start'); 

				?>