jQuery(document).ready(function($) {

	// Variable test for disabling features in older IE
	// -------------------------------------------------------------------
	ltIE9 = (document.addEventListener) ? false : true; 
	if (ltIE9) { $('html').addClass('lt-ie9') }

	// Helper class for some special mobile features, only as a backup!
	// -------------------------------------------------------------------
	if (window.mobilecheck()) { $('html').addClass('isMobile'); }

	// Fade in content (requires adding class="invisible" to page element
	// -------------------------------------------------------------------
	setTimeout( function() { $('#FadeInContent').animate({'opacity':'0'}, 500, function() { $(this).css('display','none'); }); }, 350); 


	// Icons in image overlays
	// -------------------------------------------------------------------
	$('a[class*="-image"]').find('.inner-overlay').html('<i><span class="entypo entypo-doc-text"></span></i></i>');      // standard
	$('a[class*="-image"].audio').find('.inner-overlay').html('<i><span class="entypo entypo-note-beamed"></span></i>'); // audio
	$('a[class*="-image"].image').find('.inner-overlay').html('<i><span class="entypo entypo-camera"></span></i>');      // image
	$('a[class*="-image"].gallery').find('.inner-overlay').html('<i><span class="entypo entypo-picture"></span></i>');   // gallery
	$('a[class*="-image"].video').find('.inner-overlay').html('<i><span class="entypo entypo-play"></span></i>');        // video
	// Alternate symbol for "slide" effect
	$('.overlay-slide-effect .format-standard .inner-overlay .entypo-doc-text').addClass('entypo-right-open-big').removeClass('entypo-doc-text'); 


	// Smooth scrolling with custom scrollbars
	// -------------------------------------------------------------------
	if ( (theme_smoothScroll == 'custom' || theme_smoothScroll == 'custom-no-ff') && !window.mobilecheck() && !ltIE9 ) {

		if (theme_smoothScroll == 'custom-no-ff' && navigator.userAgent.toLowerCase().indexOf('firefox') > -1 ) {
			// Do nothing
		} else {
			$('html').niceScroll({ autohidemode : true, background : 'rgba(204,204,204,.6)', cursorcolor : 'rgba(0,0,0,.5)', cursorwidth : '11px', cursorborder : 0, cursorborderradius : 0, horizrailenabled : false, zindex : 9999 });
			$('.nicescroll-rails').mouseenter( function() { $(this).animate({opacity:1}, 'fast'); }); // Show on hover
		}
	}

	// Search Bar in Masthead
	// -------------------------------------------------------------------
	$navSearch = $('#NavSearchLink');
	navSearch_h = $navSearch.height();
	// Show on click
	$navSearch.on('click', function(e) {
		if( $('#NavSearchForm').is(':hidden') ) {
			$('#NavSearchForm').fadeIn('fast');
			$('#NavS').focus();	
		} else {
			$('#NavSearchForm').fadeOut('fast');
		}
		e.preventDefault();
	});
	$('body').on('mousedown', function(e) {
		// Hide on blur
		$('#NavSearchForm').fadeOut();
	});
	$('#NavSearchForm').on('mousedown', function(e) {
		// Don't hide on internal click
		e.stopPropagation();
	});

	// Ajax Search Results
	var ajax_searchTime,
		ajax_searchKeyword,
		ajax_searchUrl = data_js.ajaxurl

	// Get activity on search input.
	$('#NavSearchForm input').keyup(function(){
		// Hidden result
		$('#NavSearchForm #AjaxSearchPane').fadeOut();
		// Add expectation to search
		$('#NavSearchForm').addClass('searchLoading');
		// Content on which search
		ajax_searchKeyword = $(this).val();

		// Reset the counter
		clearTimeout(ajax_searchTime);

		// Get current timer
		ajax_searchTime = setTimeout(  function() { 
			var data = {
				action: 'live_search',
				keyword: ajax_searchKeyword
			};
			// Search posts
			$.post(ajax_searchUrl, data, function(result) {
				// Get result and delete "0"
				var result = result.slice( 0,-1 );

				if( result != '' ) {
					// Insert result to site
					$('#NavSearchForm #AjaxSearchPane').html(result);
					$('#NavSearchForm #AjaxSearchPane').fadeIn();
				}
				// Remove expectation
				$('#NavSearchForm').removeClass('searchLoading');
			});
		}, 1000 );
	});


	// Responsive video embeds
	// -------------------------------------------------------------------
	$(".entry-content, .video-container").fitVids();


	// Vertical align content
	// -------------------------------------------------------------------
	$('.columns-align-middle > .wpb_column').verticalAlignMiddle(); // all VC columns under "columns-align-middle"
	$('.align-middle').verticalAlignMiddle(); // current container

	

	// Full Screen Slideshow 
	// -------------------------------------------------------------------
	var $fullSlider   = $('.top-content-area .type_slide-show').find('.fullscreen-container'),
	    $bannerSlider = $('.fullwidthbanner-container'),
	    $bannerParent = $bannerSlider.parent(),
		$vMastheadBg  = $('.masthead-vertical-bg'),
		forcedFull    = $fullSlider.parent().hasClass('forcefullwidth_wrapper_tp_banner'),
		sliderPad     = (window.mobilecheck()) ? $(window).height()/2 : 200,
		scrollDelta   = 0,  // wheel inertia
		scrollDir     = 0,
		wpAdminbar    = ($('body.admin-bar').length) ? 32 : 0; // Offest for stupid WP adminbar

	// Start the Special Effects and Helpers

	// Fix for Auto Responsive - Forced Full Width 
	if ( $bannerSlider.length && $bannerSlider.parent().hasClass('forcefullwidth_wrapper_tp_banner')) {
		sliderOffset = $bannerParent.offset();
		$bannerSlider.css({
			left  : '-' + sliderOffset.left + 'px',
			width : $(window).width() + 'px'
		});
		$('window').resize();
	}

	if ($fullSlider.length && forcedFull) {
		
		// Forced full width slide show
		// ...................................................................
		
		sliderOffset = $fullSlider.offset();
		$fullSlider.css({
			left  : '-' + sliderOffset.left + 'px',
			width : $(window).width() + 'px'
		});
		$(window).resize();
		setTimeout( function() { $(window).resize();; }, 1000); // helps ensure fit after load 
	
	} else if ( $fullSlider.length && $(window).width() >= 768 ) {


		// Slide show in full width using "fade" sliding effect
		// ...................................................................
		$('#masthead').addClass('fullSlider hasSlideShow'); // Hide sidebar background
		$('#Top').find('.top-content-area').first().before( $( '<div id="SliderPad"><div id="AfterSlider"></div></div>' ).css('padding-top', sliderPad*2+'px') );
		if (ltIE9) { 
			$('#SliderPad').css('padding-top', $fullSlider.height()+'px'); 
			$vMastheadBg.css({'opacity': 0});
		}

		// Tablet helper (can't do smooth scroll fade on mobile)
		// ...................................................................
		if (window.mobilecheck()) {
			$vMastheadClone = $vMastheadBg.clone();
			$vMastheadClone.addClass('masthead-bg-helper').insertAfter( "#masthead" );
		}

		// Fade effect
		// ...................................................................
		$(window).scroll(function() {
			scrollPosition = $(document).scrollTop() - wpAdminbar;
			screenWidth = $(window).width(); // Only use on large screens

			if ( scrollPosition < sliderPad || screenWidth < 768 ) {
				var percent = scrollPosition/sliderPad, 
					opacity = (screenWidth < 768 || window.mobilecheck()) ? 1 : 1 - percent || 1;
				if (!ltIE9) {
					$fullSlider.css({'opacity': opacity, 'visibility':'visible', 'left':'0'});
					jQuery('window').resize()
				}
				$vMastheadBg.css({'opacity': percent});
				if (window.mobilecheck()) { $vMastheadClone.css({'display': 'block'}); }
				$('#masthead').addClass('hasSlideShow');
			} else if ( scrollPosition >= sliderPad ) { 
				if (!window.mobilecheck() && !ltIE9) {
					$fullSlider.css({'opacity': 0, 'visibility':'hidden',  'left':'-200%'});
				}
				$vMastheadBg.css({'opacity': 1});
				$vMastheadBg.css({'-ms-filter': 'progid:DXImageTransform.Microsoft.Alpha(Opacity=100)'});
				if (window.mobilecheck()) { $vMastheadClone.css({'display': 'none'}); }
				$('#masthead').removeClass('hasSlideShow');
			}
		});


		// VIDEOS - Centering of full screen video
		// ...................................................................
		var centerVideoSlide = function(ratio_w,ratio_h) {
			ratio = (ratio_w && ratio_h) ? ratio_w/ratio_h : 0;
						
			$fullSlider.find('.fullscreenvideo video').each( function() {

				// Check for dimensions saved from metadata
				r = $(this).data('dimensions');
				if (r) {
					ratio_w = r[0];
					ratio_h = r[1];
					ratio = ratio_w/ratio_h;
				}

				// ratio = (ratio) ? ratio : 0;
				var $v = $(this),
					v_w = $v.width(),
					v_h = $v.height(),
					w = (ratio) ? $(window).width() : $fullSlider.width(),
					h = (ratio) ? $(window).height() : $fullSlider.height(),
					pos_x = 0,
					pos_y = 0,
					speed = (ratio) ? 0 : 100;
					
				if (ratio) {
					// due to trouble getting video size early in loading we're assuming a default ratio to start
					if ( w/h < ratio) {
						pos_x = Math.round(w-(ratio*h));
					} else {
						// adjust height pos
						pos_y = Math.round(h-(ratio_h/ratio_w*w));
					}
				} else {
					// if we're sure the video size will return accurately, we do the default
					pos_x = w - v_w;
					pos_y = h - v_h;
				}
				$v.animate({
					'left': (pos_x < 0) ? Math.round(pos_x/2) + 'px' : '0px',
					'top': (pos_y < 0) ? Math.round(pos_y/2) + 'px' : '0px'
				}, speed)
			});
		}

		// Bind a custom event to the centering function 
		$(window).bind("centerVideoSlide", function () {
			centerVideoSlide(0,0);
		});

		// Bind the centering function to the video metadata load event (this is ensures we get valid size data)
		$fullSlider.find('.fullscreenvideo video').each( function() {
			$(this).bind("loadedmetadata", function () {
				var w = this.videoWidth;
				var h = this.videoHeight;
				$(this).data('dimensions', [w,h]);
				$(window).trigger('centerVideoSlide');
			});
		});

		// Quick scrolling to content
		// ...................................................................
		$fullSlider.data('scrolling', false);
		var autoScrollTime = 650, 
			scrollEasing = 'easeInOutQuart', 
			pos = false;

		// DOMMouseScroll = Mozilla, onmousewheel = IE, mousewheel = everything else
		$('body').on('mousewheel onmousewheel DOMMouseScroll', function(e) {
			e = e.originalEvent || window.event;                        // Get the event
			wheelData = e.detail ? -e.detail : e.wheelDelta / 40;       // Wheel data for different browsers			
			contentStart = $('#AfterSlider').offset().top - wpAdminbar; // beginning of page content
			pos = Math.round(contentStart - $(document).scrollTop());   // Distance from top padder
			screenWidth =  $(window).width(); // Only use on large screens

			if ($fullSlider.data('scrolling')) {
				return false; // disable wheel
			} else {
				if (screenWidth < 768 || window.mobilecheck())
					return true; // do nothing on small screens
				if (wheelData < 0 ) {
					//scroll down
					scrollDir = 'down';
					// Auto scroll to content
					if ( pos > 20 ) {
						$fullSlider.data('scrolling', 'down'); // mark as active
						// Scroll to position
						$.scrollTo( contentStart, autoScrollTime, { 
							easing: scrollEasing, 
							onAfter: function() { $fullSlider.data('scrolling', false); } // mark complete
						});
						return false; // disable wheel (smoother effect)
					}
				} else {
					//scroll up
					scrollDelta = (scrollDir != 'up') ? 0 : scrollDelta; // reset delta on direction change
					scrollDir = 'up';
					// Auto scroll to slideshow
					if ( pos >= -1 ) {
						$fullSlider.data('scrolling', 'up'); // mark as active
						// Scroll to position
						$.scrollTo( 0, autoScrollTime, {
							easing: scrollEasing, 
							onAfter: function() { $fullSlider.data('scrolling', false); } // mark complete
						});
						return false; // disable wheel (smoother effect)
					} 
					// Hard stop at content top
					scrollDelta = (scrollDelta < 620) ? scrollDelta + (wheelData * 45) : scrollDelta; // should be (wheelData * 40) but we're being conservative
					scrollEndPos = pos + scrollDelta;
					if ( pos < -1 && (pos > -120 || scrollEndPos > -160) ) {
						$fullSlider.data('scrolling', 'top'); // mark as active
						jQuery.scrollTo.window().stop(true);
						// Scroll to position
						$.scrollTo( contentStart, 455, {
							easing: 'easeOutBack', 
							onAfter: function() { 
								$.scrollTo( contentStart, 1); // make sure it hit the target
								setTimeout( function() { $fullSlider.data('scrolling', false); }, 135); // mark complete
							}
						});
						return false;
					}
				}
			}
		});

		// Some variables we adjust each time scrolling stops
		$(window).on('scrollstop', function(e) {   
			// Reset scroll distance after each stop 
			scrollDelta = 0;
			// fix scroll position when stopping slightly offset from top
			contentStart = $('#AfterSlider').offset().top - wpAdminbar; 
			pos = Math.round(contentStart - $(window).scrollTop()); // Distance from top padder
			if (pos < 5 && pos > -5) {
				$.scrollTo( contentStart, 50);
			}
		});
	}		



	// Lightbox (colorbox)
	// -------------------------------------------------------------------
	if( jQuery().colorbox) {

		// Defaults
		cb_opacity = 0.7;
		cb_close   = '&#xF00D'; // FontAwesome icons
		cb_next    = '&#xF054';
		cb_prev    = '&#xF053';
		
		// WP [gallery] (groups items for lightbox next/prev) 
		$(".gallery .gallery-item a").attr('rel','gallery');

		// Attach rel attribute for groups
		$("[data-lightbox]").each( function() {
			$(this).attr('rel',$(this).data('lightbox'));
		});

		// Lightbox for YouTube 
		$("a.popup[href*='youtube.co'], a.popup[href*='youtu.be']").colorbox({
			href: function() {
				var videoID = this.href.match(/(youtu\.be\/|&*v=|\/v\/|\/embed\/)+([A-Za-z0-9\-_]{5,11})/);  // get video id
				var id = videoID[2];
				url = 'http://www.youtube.com/embed/' + id;
				if (!id) url = this.href; // if no id was found return original URL
				return url;
			},
			iframe:true,
			innerWidth: function() {
				// get width from url (if entered)
				w = $.getUrlVars(this.href)['width'] || 640;
				return w;
			}, 
			innerHeight: function() {
				h = $.getUrlVars(this.href)['height'] || 390;
				return h;
			},
			opacity: cb_opacity, close: cb_close, next: cb_next, previous: cb_prev
		});

		// Vimeo
		$("a.popup[href*='http://www.vimeo.com/'], a.popup[href*='http://vimeo.com/']").colorbox({
			href: function() {
				var id = /vimeo\.com\/(\d+)/.exec(this.href);  // get video id
				url="http://player.vimeo.com/video/"+id[1];
				if (!id[1]) url = this.href; // if no id was found return original URL
				return url;
			},
			iframe:true,
			innerWidth: function() {
				// get width from url (if entered)
				w = $.getUrlVars(this.href)['width'] || 640;
				return w;
			}, 
			innerHeight: function() {
				h = $.getUrlVars(this.href)['height'] || 360;
				return h;
			},
			opacity: cb_opacity, close: cb_close, next: cb_next, previous: cb_prev
		});
		
		// generic all links to images selector
		$("a[href$='.jpg'],a[href$='.jpeg'],a[href$='.png'],a[href$='.gif'],a[href$='.tif'],a[href$='.tiff'],a[href$='.bmp']").colorbox({
			maxWidth: '90%', maxHeight: '90%', retinaImage: true, 
			opacity: cb_opacity, close: cb_close, next: cb_next, previous: cb_prev
		});

		// specific target links using "popup" class with "#TargetElement" as href, for opening inline HTML content
		$("a.popup[href$='#LoginPopup'], .popup > a[href$='#LoginPopup']").each( function() {
			// Quick fix for URL with a path before "#LoginPopup"
			this.href = this.hash;
		});
			// Extend login popup to comments forms
			$('#comments .must-log-in a').each( function() {
				this.href = '#LoginPopup';
				$(this).click( function() {
					$('#popupLoginForm').attr('action', $(this).attr('href') +'#commentform');
				});
			});
		$("a.popup[href^='#'], .popup > a[href^='#'], #comments .must-log-in a").colorbox({ 
			maxWidth: '90%', maxHeight: '90%', inline: true, href: this.href, fixed: true,
			opacity: cb_opacity, close: cb_close, next: cb_next, previous: cb_prev
		}).removeClass('popup');	// remove class to prevent duplication 
		$(".popup > a[href^='#']").parent().removeClass('popup');	// remove class (from parent for WP menu LI's) to prevent duplication 
		
		// specific target links using "popup" class or "#popup" in URL
		$(".popup").colorbox({ 
			maxWidth: '90%', maxHeight: '90%',
			opacity: cb_opacity, close: cb_close, next: cb_next, previous: cb_prev
		});
		$("a[href$='#popup']").colorbox({
			maxWidth: '90%', maxHeight: '90%',
			href: function() { if (this.href) { return this.href.replace('#popup',''); }},
			opacity: cb_opacity, close: cb_close, next: cb_next, previous: cb_prev
		});

		// specific target links using "iframe" class or "#iframe" in URL (non-ajax content)
		$(".iframe").colorbox({ width:"80%", height:"80%", iframe:true });
		$("a[href$='#iframe']").colorbox({
			width:"80%", height:"80%", iframe:true,
			href: function() { if (this.href) { return this.href.replace('#iframe',''); }},
			opacity: cb_opacity, close: cb_close, next: cb_next, previous: cb_prev
		});

	};

	// Docked Top Banner
	// -------------------------------------------------------------------
	if ( dock_topBanner ) {
		docked = false;
		targetObject = $('#masthead');
		origin = targetObject.offset().top; // original location
		headerHeight = targetObject.outerHeight();
		originBottom = headerHeight + origin;
		fixed = (dock_topBanner == 'fixed-all-devices' || dock_topBanner == 'fixed') ? true : false;

		if ( window.mobilecheck() || $(window).width() < 768 ) {
			// Make sure mobile is enabled (doesn't apply to tablets over 768px)
			if ( $(window).width() < 768 && !(dock_topBanner == 'true-all-devices' || dock_topBanner == 'fixed-all-devices') )
				return;
			// Tablets (iPad mostly, but also allows other mobile devices)
			$('body').addClass('dockedNav'); 
			dockedPlaceholder = $('<div id="DockedNavPlaceholder"></div>').css({ 'height' : targetObject.outerHeight()+'px', 'top' : targetObject.offset().top+'px' });
			targetObject.before(dockedPlaceholder);
		} else {
			// Desktops 
			dockedPlaceholder = $('<div id="DockedNavPlaceholder"></div>').css({ 'height' : headerHeight+'px', 'top' : origin+'px' });
			targetObject.before(dockedPlaceholder);

			$(window).scroll(function() {
				$banner   = $('#masthead');
				scroll    = $(window).scrollTop();
				beginDock = $('#Top').offset().top + $('#Top').height(); // bottom of "#Top" section
				topPos = parseInt($('html').css('margin-top'));

				if (beginDock < 100) { beginDock = 200; } // minimum scroll before docking
				if (beginDock > 300) { beginDock = Math.floor( beginDock * 0.88); } // helps with advanced scrolling behaviors
				if (fixed) { 
					beginDock = origin; // no scroll offset 
					$('body').addClass('fixedDockedNav');
				}

				if ( !docked &&  beginDock <= scroll ) {
					$('body').addClass('dockedNav'); 
					if (fixed) { 
						$banner.css({'top':topPos});
					} else {
						$banner.css({'opacity':0, 'visibility':'visible', 'top':-$banner.height()}).stop(true).animate({ 'opacity':1, 'top': topPos + 'px' }, 500); 
					}
					docked = true;
				} else if ( docked && scroll <= beginDock) { 
					$('body').removeClass('dockedNav');
					if (fixed) { 
						$banner.css({'top':origin});
					} else {
						$banner.stop(true).animate({ 'opacity':0, 'top':-$banner.height() }, 200, function() { $banner.css({'top':origin, 'visibility':'visible', 'opacity':1}); });
					}
					docked = false;  
				}
				// catch all - ensure navigation at top?
				if (scroll <= originBottom && !window.mobilecheck() && !fixed) { 
					$('body').removeClass('dockedNav');
					$banner.stop(true).css({'top':origin - topPos + 'px', 'visibility':'visible', 'opacity':1});
					docked = false;  
				}
			});
		}
	}

	// jPlayer class for device controled volume (mobile)
	// -------------------------------------------------------------------
	if ('undefined' !== typeof $.jPlayer) {
		$("div[id^='jquery_jplayer_']").bind($.jPlayer.event.ready, function(event) { 
			if(event.jPlayer.status.noVolume) {
				$("div[id^='jp_interface_']").addClass('no-volume');
			}
		});
	}

	// Filtered portfolio...
	// -------------------------------------------------------------------
	if ( jQuery().isotope ) {

		var $container = $('.isotope'),
			optionFilter = $('#sort-by'),
			optionFilterLinks = optionFilter.find('a'),
			loaded = false;

		// Make suer we have a filtered portfolio on the page
		if ($container.length) {
			// Setup the click filtering events
			optionFilterLinks.attr('href', '#');
			optionFilterLinks.click(function(){				
				// After initial loading we enable transitions for filtering
				$container.removeClass('no-transition'); 				
				// Get filters
				var selector = $(this).attr('data-filter');
				useTransform = (navigator.userAgent.toLowerCase().indexOf('firefox') > -1) ? false : true; // false for FF so YouTube videos work

				$container.isotope({ 
					filter : '.' + selector,
					transformsEnabled: useTransform
				});
				// Highlight active filter
				optionFilterLinks.removeClass('active');
				$(this).addClass('active');

				return false;
			});
			// Update widths for responsive (and adjust on window resize)    
			$(window).on("portfolioResize", function( event ) {
				$style = $('.isotope-item').data('style');
				useTransform = (navigator.userAgent.toLowerCase().indexOf('firefox') > -1) ? false : true; // false for FF so YouTube videos work
				// Create the grid
				$container.isotope({
					resizable: true,
					layoutMode : $style.layout, // masonry', //'fitRows',
					itemSelector : '.isotope-item',
					animationEngine : 'best-available',
					transformsEnabled: useTransform
				});
			}); //.smartresize();

			// after media loads, trigger the portfolio resize once manually
			$container.find('img').load(function() {
				$(window).trigger( "portfolioResize" );
			});

			window.setTimeout('jQuery(".isotope").isotope("reLayout")',200);
		}
	}


	// Parallax and Container Helper
	// -------------------------------------------------------------------
	$('.lt-ie9').find('.vc_section_wrapper').first().addClass('first'); // Add helper classes for older browsers

	// Adds a height to parallax image layers. This helps in full width layouts where the layer is unbound from the parent container by absolute positioning.
	$(window).on("parallaxHeight click.parallaxHeight", function( event ) {
		$('.vc_section_wrapper').each( function() {
			$(this).children('.bg-layer').first().css('height', $(this).outerHeight() + 'px');
		});
	}); 
	// Trigger once more after short delay 
	window.setTimeout('jQuery(window).trigger("parallaxHeight")',500);
	window.setTimeout('jQuery(window).trigger("parallaxHeight")',2000); // and just one more...

	// Load parallax effect on element
	$(window).on('parallaxLoad', function() {
		$(window).off('scroll.parallax resize.parallax');
		if ( ltIE9 || $(window).width() < 768 || window.mobilecheck() ) {
			$('.parallax-section .bg-layer').css('background-position','50% 0');
		} else {
			$('.parallax-section .bg-layer').each( function() {
				$(this).parallaxScroll({ inertia : parseFloat($(this).attr('data-inertia')) });
			});
		}
	});
	$(window).trigger("parallaxLoad");


	// Setup local scrolling and pre-defined anchor tags
	// -------------------------------------------------------------------
	$.localScroll.hash({ target:'body', hash:false, duration:750 }); /* scroll after page load if hashed URL */
	$("a.local[href^='#'], .local a[href^='#'], .menu-item a[href^='#']").localScroll({ target:'body', hash:false, lazy:true, duration:750 }); /* scroll all in page anchors with the calss "local" or found in main menu */
	// Jump to the end of the slide show
	$("a.afterSlider, .afterSlider a, a[href='#AfterSlider']").on("click", function( event ) {
		event.preventDefault();
		$.scrollTo( '#AfterSlider', 600, {easing: 'easeOutBack'});
	});
	// Back to the top of the page (behavior)
	$("a.scrollTop, .scrollTop a, a[href='#ScrollTop']").on("click", function( event ) {
		event.preventDefault();
		$.scrollTo( 0, 750, {easing: 'easeOutQuart'});
	});
	//Back to the top of the page (button display)
	if ($('#BackToTop').length) {
		$(window).scroll(function() {
			if ($(this).scrollTop() > 800) {
				$('#BackToTop').fadeIn('slow');
			} else {
				$('#BackToTop').fadeOut();
			}
		});
	}


	// Initialize events we want bound to the window resize event
	// -------------------------------------------------------------------
	on_resize(function() {
		$(window).trigger( "portfolioResize" );

		$(window).trigger( "parallaxHeight" );
		window.setTimeout('jQuery(window).trigger("parallaxHeight")',500); // Trigger once more after short delay
		
		$(window).trigger( "parallaxLoad" );

		$(window).trigger( "centerVideoSlide" );

	})();  // extra () to trigger once

});


/* Utilitles 
=======================================================================*/

// debulked onresize handler. This stops excessive resize triggering.
// -------------------------------------------------------------------
function on_resize(c,t){onresize=function(){clearTimeout(t);t=setTimeout(c,100)};return c};

// HTML5 input placeholders
// -------------------------------------------------------------------
/* HTML5 placeholder plugin (v1.01), Copyright (c) 2010-The End of Time, Mike Taylor, http://miketaylr.com, MIT Licensed: http://www.opensource.org/licenses/mit-license.php
 * Fixes HTML5 placeholder text for older browsers - USAGE:  $('input[placeholder]').placeholder();
 */
(function(a){var b="placeholder"in document.createElement("input"),c=a.browser.opera&&a.browser.version<10.5;a.fn.placeholder=function(d){var d=a.extend({},a.fn.placeholder.defaults,d),e=d.placeholderCSS.left;return b?this:this.each(function(){var b=a(this),f=a.trim(b.val()),g=b.width(),h=b.height(),i=this.id?this.id:"placeholder"+ +(new Date),j=b.attr("placeholder"),k=a("<label for="+i+">"+j+"</label>");d.placeholderCSS.width=g,d.placeholderCSS.height=h,d.placeholderCSS.color=d.color,d.placeholderCSS.left=!c||this.type!="email"&&this.type!="url"?e:"11%",k.css(d.placeholderCSS),b.wrap(d.inputWrapper),b.attr("id",i).after(k),f&&k.hide(),b.focus(function(){a.trim(b.val())||k.hide()}),b.blur(function(){a.trim(b.val())||k.show()})})},a.fn.placeholder.defaults={inputWrapper:'<span style="position:relative; display:block;" class="placeholder-text"></span>',placeholderCSS:{font:"1em",color:"#bababa",position:"absolute",left:"5px",top:"3px","overflow":"hidden",display:"block"}}})(jQuery);
// activate placeholders
jQuery('input[placeholder], textarea[placeholder]').placeholder();

// Get parameters from URL or string
// -------------------------------------------------------------------
// Usage: 	Get object of URL parameters:	allVars = $.getUrlVars();
// 			Getting URL var by its name:	byName = $.getUrlVar('name');
// 			Getting alternate URL var:		customURL = $.getUrlVar('name','http://mysite.com/?query=string');
// -------------------------------------------------------------------
jQuery.extend({getUrlVars:function(url){var vars=[],hash;if(!url){url=window.location.href;}var hashes=url.slice(window.location.href.indexOf("?")+1).split("&");for(var i=0;i<hashes.length;i++){hash=hashes[i].split("=");vars.push(hash[0]);vars[hash[0]]=hash[1];}return vars;},getUrlVar:function(name,url){if(!url){url=window.location.href;}return jQuery.getUrlVars(url)[name];}});

/* Vertical Align Middle */
(function(a){a.fn.verticalAlignMiddle=function(b){return this.each(function(){var d=a(this);var c=b||"margin-top";a(window).bind("resize",function(){d.css(c,(a(window).width()>=768)?((d.parent().height()-d.height())/2):0)});a(window).resize();d.find("img").load(function(){a(window).resize()})})}})(jQuery);

/* jQuery fitvids - responsive video embeds */
(function(a){"use strict";a.fn.fitVids=function(b){var c={customSelector:null},d=document.createElement("div"),e=document.getElementsByTagName("base")[0]||document.getElementsByTagName("script")[0];return d.className="fit-vids-style",d.innerHTML="&shy;<style>.fluid-width-video-wrapper {width: 100%;position: relative;padding: 0;}.fluid-width-video-wrapper iframe,.fluid-width-video-wrapper object,.fluid-width-video-wrapper embed {position: absolute;top: 0;left: 0;width: 100%;height: 100%;}</style>",e.parentNode.insertBefore(d,e),b&&a.extend(c,b),this.each(function(){var b=["iframe[src*='player.vimeo.com']","iframe[src*='youtube.com']","iframe[src*='youtube-nocookie.com']","iframe[src*='kickstarter.com']","object","embed"];c.customSelector&&b.push(c.customSelector);var d=a(this).find(b.join(","));d.each(function(){var b=a(this);if(!("embed"===this.tagName.toLowerCase()&&b.parent("object").length||b.parent(".fluid-width-video-wrapper").length)){var c="object"===this.tagName.toLowerCase()||b.attr("height")&&!isNaN(parseInt(b.attr("height"),10))?parseInt(b.attr("height"),10):b.height(),d=isNaN(parseInt(b.attr("width"),10))?b.width():parseInt(b.attr("width"),10),e=c/d;if(!b.attr("id")){var f="fitvid"+Math.floor(999999*Math.random());b.attr("id",f)}b.wrap('<div class="fluid-width-video-wrapper"></div>').parent(".fluid-width-video-wrapper").css("padding-top",100*e+"%"),b.removeAttr("height").removeAttr("width")}})})}})(jQuery);

/*! Respond.js v1.1.0: min/max-width media query polyfill. (c) Scott Jehl. MIT/GPLv2 Lic. j.mp/respondjs  */
(function(e){e.respond={};respond.update=function(){};respond.mediaQueriesSupported=e.matchMedia&&e.matchMedia("only all").matches;if(respond.mediaQueriesSupported){return}var w=e.document,s=w.documentElement,i=[],k=[],q=[],o={},h=30,f=w.getElementsByTagName("head")[0]||s,g=w.getElementsByTagName("base")[0],b=f.getElementsByTagName("link"),d=[],a=function(){var D=b,y=D.length,B=0,A,z,C,x;for(;B<y;B++){A=D[B],z=A.href,C=A.media,x=A.rel&&A.rel.toLowerCase()==="stylesheet";if(!!z&&x&&!o[z]){if(A.styleSheet&&A.styleSheet.rawCssText){m(A.styleSheet.rawCssText,z,C);o[z]=true}else{if((!/^([a-zA-Z:]*\/\/)/.test(z)&&!g)||z.replace(RegExp.$1,"").split("/")[0]===e.location.host){d.push({href:z,media:C})}}}}u()},u=function(){if(d.length){var x=d.shift();n(x.href,function(y){m(y,x.href,x.media);o[x.href]=true;u()})}},m=function(I,x,z){var G=I.match(/@media[^\{]+\{([^\{\}]*\{[^\}\{]*\})+/gi),J=G&&G.length||0,x=x.substring(0,x.lastIndexOf("/")),y=function(K){return K.replace(/(url\()['"]?([^\/\)'"][^:\)'"]+)['"]?(\))/g,"$1"+x+"$2$3")},A=!J&&z,D=0,C,E,F,B,H;if(x.length){x+="/"}if(A){J=1}for(;D<J;D++){C=0;if(A){E=z;k.push(y(I))}else{E=G[D].match(/@media *([^\{]+)\{([\S\s]+?)$/)&&RegExp.$1;k.push(RegExp.$2&&y(RegExp.$2))}B=E.split(",");H=B.length;for(;C<H;C++){F=B[C];i.push({media:F.split("(")[0].match(/(only\s+)?([a-zA-Z]+)\s?/)&&RegExp.$2||"all",rules:k.length-1,hasquery:F.indexOf("(")>-1,minw:F.match(/\(min\-width:[\s]*([\s]*[0-9\.]+)(px|em)[\s]*\)/)&&parseFloat(RegExp.$1)+(RegExp.$2||""),maxw:F.match(/\(max\-width:[\s]*([\s]*[0-9\.]+)(px|em)[\s]*\)/)&&parseFloat(RegExp.$1)+(RegExp.$2||"")})}}j()},l,r,v=function(){var z,A=w.createElement("div"),x=w.body,y=false;A.style.cssText="position:absolute;font-size:1em;width:1em";if(!x){x=y=w.createElement("body");x.style.background="none"}x.appendChild(A);s.insertBefore(x,s.firstChild);z=A.offsetWidth;if(y){s.removeChild(x)}else{x.removeChild(A)}z=p=parseFloat(z);return z},p,j=function(I){var x="clientWidth",B=s[x],H=w.compatMode==="CSS1Compat"&&B||w.body[x]||B,D={},G=b[b.length-1],z=(new Date()).getTime();if(I&&l&&z-l<h){clearTimeout(r);r=setTimeout(j,h);return}else{l=z}for(var E in i){var K=i[E],C=K.minw,J=K.maxw,A=C===null,L=J===null,y="em";if(!!C){C=parseFloat(C)*(C.indexOf(y)>-1?(p||v()):1)}if(!!J){J=parseFloat(J)*(J.indexOf(y)>-1?(p||v()):1)}if(!K.hasquery||(!A||!L)&&(A||H>=C)&&(L||H<=J)){if(!D[K.media]){D[K.media]=[]}D[K.media].push(k[K.rules])}}for(var E in q){if(q[E]&&q[E].parentNode===f){f.removeChild(q[E])}}for(var E in D){var M=w.createElement("style"),F=D[E].join("\n");M.type="text/css";M.media=E;f.insertBefore(M,G.nextSibling);if(M.styleSheet){M.styleSheet.cssText=F}else{M.appendChild(w.createTextNode(F))}q.push(M)}},n=function(x,z){var y=c();if(!y){return}y.open("GET",x,true);y.onreadystatechange=function(){if(y.readyState!=4||y.status!=200&&y.status!=304){return}z(y.responseText)};if(y.readyState==4){return}y.send(null)},c=(function(){var x=false;try{x=new XMLHttpRequest()}catch(y){x=new ActiveXObject("Microsoft.XMLHTTP")}return function(){return x}})();a();respond.update=a;function t(){j(true)}if(e.addEventListener){e.addEventListener("resize",t,false)}else{if(e.attachEvent){e.attachEvent("onresize",t)}}})(this);

/* jQuery Easing v1.3 - http://gsgd.co.uk/sandbox/jquery/easing/ */
jQuery.easing.jswing=jQuery.easing.swing;jQuery.extend(jQuery.easing,{def:"easeOutQuad",swing:function(e,f,a,h,g){return jQuery.easing[jQuery.easing.def](e,f,a,h,g)},easeInQuad:function(e,f,a,h,g){return h*(f/=g)*f+a},easeOutQuad:function(e,f,a,h,g){return -h*(f/=g)*(f-2)+a},easeInOutQuad:function(e,f,a,h,g){if((f/=g/2)<1){return h/2*f*f+a}return -h/2*((--f)*(f-2)-1)+a},easeInCubic:function(e,f,a,h,g){return h*(f/=g)*f*f+a},easeOutCubic:function(e,f,a,h,g){return h*((f=f/g-1)*f*f+1)+a},easeInOutCubic:function(e,f,a,h,g){if((f/=g/2)<1){return h/2*f*f*f+a}return h/2*((f-=2)*f*f+2)+a},easeInQuart:function(e,f,a,h,g){return h*(f/=g)*f*f*f+a},easeOutQuart:function(e,f,a,h,g){return -h*((f=f/g-1)*f*f*f-1)+a},easeInOutQuart:function(e,f,a,h,g){if((f/=g/2)<1){return h/2*f*f*f*f+a}return -h/2*((f-=2)*f*f*f-2)+a},easeInQuint:function(e,f,a,h,g){return h*(f/=g)*f*f*f*f+a},easeOutQuint:function(e,f,a,h,g){return h*((f=f/g-1)*f*f*f*f+1)+a},easeInOutQuint:function(e,f,a,h,g){if((f/=g/2)<1){return h/2*f*f*f*f*f+a}return h/2*((f-=2)*f*f*f*f+2)+a},easeInSine:function(e,f,a,h,g){return -h*Math.cos(f/g*(Math.PI/2))+h+a},easeOutSine:function(e,f,a,h,g){return h*Math.sin(f/g*(Math.PI/2))+a},easeInOutSine:function(e,f,a,h,g){return -h/2*(Math.cos(Math.PI*f/g)-1)+a},easeInExpo:function(e,f,a,h,g){return(f==0)?a:h*Math.pow(2,10*(f/g-1))+a},easeOutExpo:function(e,f,a,h,g){return(f==g)?a+h:h*(-Math.pow(2,-10*f/g)+1)+a},easeInOutExpo:function(e,f,a,h,g){if(f==0){return a}if(f==g){return a+h}if((f/=g/2)<1){return h/2*Math.pow(2,10*(f-1))+a}return h/2*(-Math.pow(2,-10*--f)+2)+a},easeInCirc:function(e,f,a,h,g){return -h*(Math.sqrt(1-(f/=g)*f)-1)+a},easeOutCirc:function(e,f,a,h,g){return h*Math.sqrt(1-(f=f/g-1)*f)+a},easeInOutCirc:function(e,f,a,h,g){if((f/=g/2)<1){return -h/2*(Math.sqrt(1-f*f)-1)+a}return h/2*(Math.sqrt(1-(f-=2)*f)+1)+a},easeInElastic:function(f,h,e,l,k){var i=1.70158;var j=0;var g=l;if(h==0){return e}if((h/=k)==1){return e+l}if(!j){j=k*0.3}if(g<Math.abs(l)){g=l;var i=j/4}else{var i=j/(2*Math.PI)*Math.asin(l/g)}return -(g*Math.pow(2,10*(h-=1))*Math.sin((h*k-i)*(2*Math.PI)/j))+e},easeOutElastic:function(f,h,e,l,k){var i=1.70158;var j=0;var g=l;if(h==0){return e}if((h/=k)==1){return e+l}if(!j){j=k*0.3}if(g<Math.abs(l)){g=l;var i=j/4}else{var i=j/(2*Math.PI)*Math.asin(l/g)}return g*Math.pow(2,-10*h)*Math.sin((h*k-i)*(2*Math.PI)/j)+l+e},easeInOutElastic:function(f,h,e,l,k){var i=1.70158;var j=0;var g=l;if(h==0){return e}if((h/=k/2)==2){return e+l}if(!j){j=k*(0.3*1.5)}if(g<Math.abs(l)){g=l;var i=j/4}else{var i=j/(2*Math.PI)*Math.asin(l/g)}if(h<1){return -0.5*(g*Math.pow(2,10*(h-=1))*Math.sin((h*k-i)*(2*Math.PI)/j))+e}return g*Math.pow(2,-10*(h-=1))*Math.sin((h*k-i)*(2*Math.PI)/j)*0.5+l+e},easeInBack:function(e,f,a,i,h,g){if(g==undefined){g=1.70158}return i*(f/=h)*f*((g+1)*f-g)+a},easeOutBack:function(e,f,a,i,h,g){if(g==undefined){g=1.70158}return i*((f=f/h-1)*f*((g+1)*f+g)+1)+a},easeInOutBack:function(e,f,a,i,h,g){if(g==undefined){g=1.70158}if((f/=h/2)<1){return i/2*(f*f*(((g*=(1.525))+1)*f-g))+a}return i/2*((f-=2)*f*(((g*=(1.525))+1)*f+g)+2)+a},easeInBounce:function(e,f,a,h,g){return h-jQuery.easing.easeOutBounce(e,g-f,0,h,g)+a},easeOutBounce:function(e,f,a,h,g){if((f/=g)<(1/2.75)){return h*(7.5625*f*f)+a}else{if(f<(2/2.75)){return h*(7.5625*(f-=(1.5/2.75))*f+0.75)+a}else{if(f<(2.5/2.75)){return h*(7.5625*(f-=(2.25/2.75))*f+0.9375)+a}else{return h*(7.5625*(f-=(2.625/2.75))*f+0.984375)+a}}}},easeInOutBounce:function(e,f,a,h,g){if(f<g/2){return jQuery.easing.easeInBounce(e,f*2,0,h,g)*0.5+a}return jQuery.easing.easeOutBounce(e,f*2-g,0,h,g)*0.5+h*0.5+a}});

/* Parallax - Custom developed by Parallelus */
(function($){$.fn.parallaxScroll=function(options){var settings={adjuster:0,inertia:0.1,type:"background",action:"bind"};if(options){$.extend(settings,options);}if(settings.type=="unbind"){$(window).off("scroll.parallax resize.parallax");}else{this.each(function(){var $this=$(this);if(settings.type=="background"){var objPos="";objPos=/[^\s]+/.exec($this.css("background-position"));if(objPos=="undefined"){objPos="50%";}var objX=(!objPos||objPos=="undefined")?"50%":objPos;}else{$this.css("position","absolute");$this.parent().css("position","relative");var objTop=Math.floor($this.position().top);var startTop=objTop;}$(window).on("scroll.parallax resize.parallax",function(){var scrollPos=$(window).scrollTop();var elementTop=($this.offset())?$this.offset().top:0;if(isScrolledIntoView($this)){if(settings.type=="background"){var x=objX;var y=Math.round((((elementTop-scrollPos)*settings.inertia))+settings.adjuster)+"px";$this.css({"background-position":x+" "+y});}else{var elementTop=($this.parent().offset())?$this.parent().offset().top:0;var newTop=Math.round(((-(elementTop-scrollPos)*settings.inertia))+settings.adjuster+(elementTop*settings.inertia)+objTop)+"px";$this.css({top:newTop});}}});$(window).trigger("scroll.parallax");});}function isScrolledIntoView(elem){var viewTop=$(window).scrollTop();var viewBottom=viewTop+$(window).height();var elemTop=$(elem).offset().top;var elemBottom=elemTop+$(elem).height();return((elemBottom>=viewTop)&&(elemTop<=viewBottom));}};})(jQuery);

/* ScrollTo - Copyright (c) 2007-2013 Ariel Flesler - aflesler<a>gmail<d>com | http://flesler.blogspot.com | Licensed under MIT @author Ariel Flesler @version 1.4.7 */
(function(d){function h(b){return"object"==typeof b?b:{top:b,left:b}}var n=d.scrollTo=function(b,c,a){return d(window).scrollTo(b,c,a)};n.defaults={axis:"xy",duration:1.3<=parseFloat(d.fn.jquery)?0:1,limit:!0};n.window=function(b){return d(window)._scrollable()};d.fn._scrollable=function(){return this.map(function(){if(this.nodeName&&-1==d.inArray(this.nodeName.toLowerCase(),["iframe","#document","html","body"]))return this;var b=(this.contentWindow||this).document||this.ownerDocument||this;return/webkit/i.test(navigator.userAgent)|| "BackCompat"==b.compatMode?b.body:b.documentElement})};d.fn.scrollTo=function(b,c,a){"object"==typeof c&&(a=c,c=0);"function"==typeof a&&(a={onAfter:a});"max"==b&&(b=9E9);a=d.extend({},n.defaults,a);c=c||a.duration;a.queue=a.queue&&1<a.axis.length;a.queue&&(c/=2);a.offset=h(a.offset);a.over=h(a.over);return this._scrollable().each(function(){function q(b){k.animate(e,c,a.easing,b&&function(){b.call(this,g,a)})}if(null!=b){var l=this,k=d(l),g=b,p,e={},s=k.is("html,body");switch(typeof g){case "number":case "string":if(/^([+-]=?)?\d+(\.\d+)?(px|%)?$/.test(g)){g= h(g);break}g=d(g,this);if(!g.length)return;case "object":if(g.is||g.style)p=(g=d(g)).offset()}d.each(a.axis.split(""),function(b,d){var c="x"==d?"Left":"Top",m=c.toLowerCase(),f="scroll"+c,h=l[f],r=n.max(l,d);p?(e[f]=p[m]+(s?0:h-k.offset()[m]),a.margin&&(e[f]-=parseInt(g.css("margin"+c))||0,e[f]-=parseInt(g.css("border"+c+"Width"))||0),e[f]+=a.offset[m]||0,a.over[m]&&(e[f]+=g["x"==d?"width":"height"]()*a.over[m])):(c=g[m],e[f]=c.slice&&"%"==c.slice(-1)?parseFloat(c)/100*r:c);a.limit&&/^\d+$/.test(e[f])&& (e[f]=0>=e[f]?0:Math.min(e[f],r));!b&&a.queue&&(h!=e[f]&&q(a.onAfterFirst),delete e[f])});q(a.onAfter)}}).end()};n.max=function(b,c){var a="x"==c?"Width":"Height",h="scroll"+a;if(!d(b).is("html,body"))return b[h]-d(b)[a.toLowerCase()]();var a="client"+a,l=b.ownerDocument.documentElement,k=b.ownerDocument.body;return Math.max(l[h],k[h])-Math.min(l[a],k[a])}})(jQuery);

/* LocalScroll - Copyright (c) 2007-2013 Ariel Flesler - aflesler<a>gmail<d>com | http://flesler.blogspot.com | Licensed under MIT @author Ariel Flesler @version 1.3.1 */
;(function($){var h=location.href.replace(/#.*/,'');var i=$.localScroll=function(a){$('body').localScroll(a)};i.defaults={duration:1000,axis:'y',event:'click',stop:true,target:window};i.hash=function(a){if(location.hash){a=$.extend({},i.defaults,a);a.hash=false;if(a.reset){var d=a.duration;delete a.duration;$(a.target).scrollTo(0,a);a.duration=d}scroll(0,location,a)}};$.fn.localScroll=function(b){b=$.extend({},i.defaults,b);return b.lazy?this.bind(b.event,function(e){var a=$([e.target,e.target.parentNode]).filter(filter)[0];if(a)scroll(e,a,b)}):this.find('a,area').filter(filter).bind(b.event,function(e){scroll(e,this,b)}).end().end();function filter(){return!!this.href&&!!this.hash&&this.href.replace(this.hash,'')==h&&(!b.filter||$(this).is(b.filter))}};function scroll(e,a,b){var c=a.hash.slice(1),elem=document.getElementById(c)||document.getElementsByName(c)[0];if(!elem)return;if(e)e.preventDefault();var d=$(b.target);if(b.lock&&d.is(':animated')||b.onBefore&&b.onBefore(e,elem,d)===false)return;if(b.stop)d._scrollable().stop(true);if(b.hash){var f=b.offset;f=f&&f.top||f||0;var g=elem.id==c?'id':'name',$a=$('<a> </a>').attr(g,c).css({position:'absolute',top:$(window).scrollTop()+f,left:$(window).scrollLeft()});elem[g]='';$('body').prepend($a);location=a.hash;$a.remove();elem[g]=c}d.scrollTo(elem,b).trigger('notify.serialScroll',[elem])}})(jQuery);

/* Special scroll events (scrollstart, scrollstop) Credits: http://james.padolsey.com/javascript/special-scroll-events-for-jquery/ */
(function(d){var a=d.event.special,c="D"+(+new Date()),b="D"+(+new Date()+1);a.scrollstart={setup:function(){var f,e=function(i){var g=this,h=arguments;if(f){clearTimeout(f);}else{i.type="scrollstart";d.event.handle.apply(g,h);}f=setTimeout(function(){f=null;},a.scrollstop.latency);};d(this).bind("scroll",e).data(c,e);},teardown:function(){d(this).unbind("scroll",d(this).data(c));}};a.scrollstop={latency:300,setup:function(){var f,e=function(i){var g=this,h=arguments;if(f){clearTimeout(f);}f=setTimeout(function(){f=null;i.type="scrollstop";d.event.dispatch.call(g,i);},a.scrollstop.latency);};d(this).bind("scroll",e).data(b,e);},teardown:function(){d(this).unbind("scroll",d(this).data(b));}};})(jQuery);

/* Mobile browser check - Source: http://stackoverflow.com/questions/11381673/javascript-solution-to-detect-mobile-browser */
// Note: Slightly modified to include iPad 
window.mobilecheck = function() {
var check = false;
(function(a){if(/(android|bb\d+|meego|ipad|playbook|silk).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino/i.test(a)||/1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.test(a.substr(0,4)))check = true})(navigator.userAgent||navigator.vendor||window.opera);
return check; };

/* jQuery Colorbox v1.4.14 - 2013-04-16 | (c) 2013 Jack Moore - jacklmoore.com/colorbox | license: http://www.opensource.org/licenses/mit-license.php */
(function(t,e,i){function o(i,o,n){var r=e.createElement(i);return o&&(r.id=te+o),n&&(r.style.cssText=n),t(r)}function n(){return i.innerHeight?i.innerHeight:t(i).height()}function r(t){var e=H.length,i=(j+t)%e;return 0>i?e+i:i}function h(t,e){return Math.round((/%/.test(t)?("x"===e?E.width():n())/100:1)*parseInt(t,10))}function l(t,e){return t.photo||t.photoRegex.test(e)}function s(t,e){return t.retinaUrl&&i.devicePixelRatio>1?e.replace(t.photoRegex,t.retinaSuffix):e}function a(t){"contains"in x[0]&&!x[0].contains(t.target)&&(t.stopPropagation(),x.focus())}function d(){var e,i=t.data(A,Z);null==i?(_=t.extend({},Y),console&&console.log&&console.log("Error: cboxElement missing settings object")):_=t.extend({},i);for(e in _)t.isFunction(_[e])&&"on"!==e.slice(0,2)&&(_[e]=_[e].call(A));_.rel=_.rel||A.rel||t(A).data("rel")||"nofollow",_.href=_.href||t(A).attr("href"),_.title=_.title||A.title,"string"==typeof _.href&&(_.href=t.trim(_.href))}function c(i,o){t(e).trigger(i),se.trigger(i),t.isFunction(o)&&o.call(A)}function u(){var t,e,i,o,n,r=te+"Slideshow_",h="click."+te;_.slideshow&&H[1]?(e=function(){clearTimeout(t)},i=function(){(_.loop||H[j+1])&&(t=setTimeout(J.next,_.slideshowSpeed))},o=function(){M.html(_.slideshowStop).unbind(h).one(h,n),se.bind(ne,i).bind(oe,e).bind(re,n),x.removeClass(r+"off").addClass(r+"on")},n=function(){e(),se.unbind(ne,i).unbind(oe,e).unbind(re,n),M.html(_.slideshowStart).unbind(h).one(h,function(){J.next(),o()}),x.removeClass(r+"on").addClass(r+"off")},_.slideshowAuto?o():n()):x.removeClass(r+"off "+r+"on")}function f(i){G||(A=i,d(),H=t(A),j=0,"nofollow"!==_.rel&&(H=t("."+ee).filter(function(){var e,i=t.data(this,Z);return i&&(e=t(this).data("rel")||i.rel||this.rel),e===_.rel}),j=H.index(A),-1===j&&(H=H.add(A),j=H.length-1)),g.css({opacity:parseFloat(_.opacity),cursor:_.overlayClose?"pointer":"auto",visibility:"visible"}).show(),V&&x.add(g).removeClass(V),_.className&&x.add(g).addClass(_.className),V=_.className,K.html(_.close).show(),$||($=q=!0,x.css({visibility:"hidden",display:"block"}),W=o(ae,"LoadedContent","width:0; height:0; overflow:hidden").appendTo(v),D=b.height()+k.height()+v.outerHeight(!0)-v.height(),B=C.width()+T.width()+v.outerWidth(!0)-v.width(),N=W.outerHeight(!0),z=W.outerWidth(!0),_.w=h(_.initialWidth,"x"),_.h=h(_.initialHeight,"y"),J.position(),u(),c(ie,_.onOpen),O.add(F).hide(),x.focus(),e.addEventListener&&(e.addEventListener("focus",a,!0),se.one(he,function(){e.removeEventListener("focus",a,!0)})),_.returnFocus&&se.one(he,function(){t(A).focus()})),w())}function p(){!x&&e.body&&(X=!1,E=t(i),x=o(ae).attr({id:Z,"class":t.support.opacity===!1?te+"IE":"",role:"dialog",tabindex:"-1"}).hide(),g=o(ae,"Overlay").hide(),S=o(ae,"LoadingOverlay").add(o(ae,"LoadingGraphic")),y=o(ae,"Wrapper"),v=o(ae,"Content").append(F=o(ae,"Title"),I=o(ae,"Current"),P=t('<button type="button"/>').attr({id:te+"Previous"}),R=t('<button type="button"/>').attr({id:te+"Next"}),M=o("button","Slideshow"),S,K=t('<button type="button"/>').attr({id:te+"Close"})),y.append(o(ae).append(o(ae,"TopLeft"),b=o(ae,"TopCenter"),o(ae,"TopRight")),o(ae,!1,"clear:left").append(C=o(ae,"MiddleLeft"),v,T=o(ae,"MiddleRight")),o(ae,!1,"clear:left").append(o(ae,"BottomLeft"),k=o(ae,"BottomCenter"),o(ae,"BottomRight"))).find("div div").css({"float":"left"}),L=o(ae,!1,"position:absolute; width:9999px; visibility:hidden; display:none"),O=R.add(P).add(I).add(M),t(e.body).append(g,x.append(y,L)))}function m(){function i(t){t.which>1||t.shiftKey||t.altKey||t.metaKey||t.control||(t.preventDefault(),f(this))}return x?(X||(X=!0,R.click(function(){J.next()}),P.click(function(){J.prev()}),K.click(function(){J.close()}),g.click(function(){_.overlayClose&&J.close()}),t(e).bind("keydown."+te,function(t){var e=t.keyCode;$&&_.escKey&&27===e&&(t.preventDefault(),J.close()),$&&_.arrowKey&&H[1]&&!t.altKey&&(37===e?(t.preventDefault(),P.click()):39===e&&(t.preventDefault(),R.click()))}),t.isFunction(t.fn.on)?t(e).on("click."+te,"."+ee,i):t("."+ee).live("click."+te,i)),!0):!1}function w(){var e,n,r,a=J.prep,u=++de;q=!0,U=!1,A=H[j],d(),c(le),c(oe,_.onLoad),_.h=_.height?h(_.height,"y")-N-D:_.innerHeight&&h(_.innerHeight,"y"),_.w=_.width?h(_.width,"x")-z-B:_.innerWidth&&h(_.innerWidth,"x"),_.mw=_.w,_.mh=_.h,_.maxWidth&&(_.mw=h(_.maxWidth,"x")-z-B,_.mw=_.w&&_.w<_.mw?_.w:_.mw),_.maxHeight&&(_.mh=h(_.maxHeight,"y")-N-D,_.mh=_.h&&_.h<_.mh?_.h:_.mh),e=_.href,Q=setTimeout(function(){S.show()},100),_.inline?(r=o(ae).hide().insertBefore(t(e)[0]),se.one(le,function(){r.replaceWith(W.children())}),a(t(e))):_.iframe?a(" "):_.html?a(_.html):l(_,e)?(e=s(_,e),t(U=new Image).addClass(te+"Photo").bind("error",function(){_.title=!1,a(o(ae,"Error").html(_.imgError))}).one("load",function(){var e;u===de&&(U.alt=t(A).attr("alt")||t(A).attr("data-alt")||"",_.retinaImage&&i.devicePixelRatio>1&&(U.height=U.height/i.devicePixelRatio,U.width=U.width/i.devicePixelRatio),_.scalePhotos&&(n=function(){U.height-=U.height*e,U.width-=U.width*e},_.mw&&U.width>_.mw&&(e=(U.width-_.mw)/U.width,n()),_.mh&&U.height>_.mh&&(e=(U.height-_.mh)/U.height,n())),_.h&&(U.style.marginTop=Math.max(_.mh-U.height,0)/2+"px"),H[1]&&(_.loop||H[j+1])&&(U.style.cursor="pointer",U.onclick=function(){J.next()}),U.style.width=U.width+"px",U.style.height=U.height+"px",setTimeout(function(){a(U)},1))}),setTimeout(function(){U.src=e},1)):e&&L.load(e,_.data,function(e,i){u===de&&a("error"===i?o(ae,"Error").html(_.xhrError):t(this).contents())})}var g,x,y,v,b,C,T,k,H,E,W,L,S,F,I,M,R,P,K,O,_,D,B,N,z,A,j,U,$,q,G,Q,J,V,X,Y={transition:"elastic",speed:300,fadeOut:300,width:!1,initialWidth:"600",innerWidth:!1,maxWidth:!1,height:!1,initialHeight:"450",innerHeight:!1,maxHeight:!1,scalePhotos:!0,scrolling:!0,inline:!1,html:!1,iframe:!1,fastIframe:!0,photo:!1,href:!1,title:!1,rel:!1,opacity:.9,preloading:!0,className:!1,retinaImage:!1,retinaUrl:!1,retinaSuffix:"@2x.$1",current:"image {current} of {total}",previous:"previous",next:"next",close:"close",xhrError:"This content failed to load.",imgError:"This image failed to load.",open:!1,returnFocus:!0,reposition:!0,loop:!0,slideshow:!1,slideshowAuto:!0,slideshowSpeed:2500,slideshowStart:"start slideshow",slideshowStop:"stop slideshow",photoRegex:/\.(gif|png|jp(e|g|eg)|bmp|ico)((#|\?).*)?$/i,onOpen:!1,onLoad:!1,onComplete:!1,onCleanup:!1,onClosed:!1,overlayClose:!0,escKey:!0,arrowKey:!0,top:!1,bottom:!1,left:!1,right:!1,fixed:!1,data:void 0},Z="colorbox",te="cbox",ee=te+"Element",ie=te+"_open",oe=te+"_load",ne=te+"_complete",re=te+"_cleanup",he=te+"_closed",le=te+"_purge",se=t("<a/>"),ae="div",de=0;t.colorbox||(t(p),J=t.fn[Z]=t[Z]=function(e,i){var o=this;if(e=e||{},p(),m()){if(t.isFunction(o))o=t("<a/>"),e.open=!0;else if(!o[0])return o;i&&(e.onComplete=i),o.each(function(){t.data(this,Z,t.extend({},t.data(this,Z)||Y,e))}).addClass(ee),(t.isFunction(e.open)&&e.open.call(o)||e.open)&&f(o[0])}return o},J.position=function(t,e){function i(t){b[0].style.width=k[0].style.width=v[0].style.width=parseInt(t.style.width,10)-B+"px",v[0].style.height=C[0].style.height=T[0].style.height=parseInt(t.style.height,10)-D+"px"}var o,r,l,s=0,a=0,d=x.offset();E.unbind("resize."+te),x.css({top:-9e4,left:-9e4}),r=E.scrollTop(),l=E.scrollLeft(),_.fixed?(d.top-=r,d.left-=l,x.css({position:"fixed"})):(s=r,a=l,x.css({position:"absolute"})),a+=_.right!==!1?Math.max(E.width()-_.w-z-B-h(_.right,"x"),0):_.left!==!1?h(_.left,"x"):Math.round(Math.max(E.width()-_.w-z-B,0)/2),s+=_.bottom!==!1?Math.max(n()-_.h-N-D-h(_.bottom,"y"),0):_.top!==!1?h(_.top,"y"):Math.round(Math.max(n()-_.h-N-D,0)/2),x.css({top:d.top,left:d.left,visibility:"visible"}),t=x.width()===_.w+z&&x.height()===_.h+N?0:t||0,y[0].style.width=y[0].style.height="9999px",o={width:_.w+z+B,height:_.h+N+D,top:s,left:a},0===t&&x.css(o),x.dequeue().animate(o,{duration:t,complete:function(){i(this),q=!1,y[0].style.width=_.w+z+B+"px",y[0].style.height=_.h+N+D+"px",_.reposition&&setTimeout(function(){E.bind("resize."+te,J.position)},1),e&&e()},step:function(){i(this)}})},J.resize=function(t){$&&(t=t||{},t.width&&(_.w=h(t.width,"x")-z-B),t.innerWidth&&(_.w=h(t.innerWidth,"x")),W.css({width:_.w}),t.height&&(_.h=h(t.height,"y")-N-D),t.innerHeight&&(_.h=h(t.innerHeight,"y")),t.innerHeight||t.height||(W.css({height:"auto"}),_.h=W.height()),W.css({height:_.h}),J.position("none"===_.transition?0:_.speed))},J.prep=function(e){function i(){return _.w=_.w||W.width(),_.w=_.mw&&_.mw<_.w?_.mw:_.w,_.w}function n(){return _.h=_.h||W.height(),_.h=_.mh&&_.mh<_.h?_.mh:_.h,_.h}if($){var h,a="none"===_.transition?0:_.speed;W.empty().remove(),W=o(ae,"LoadedContent").append(e),W.hide().appendTo(L.show()).css({width:i(),overflow:_.scrolling?"auto":"hidden"}).css({height:n()}).prependTo(v),L.hide(),t(U).css({"float":"none"}),h=function(){function e(){t.support.opacity===!1&&x[0].style.removeAttribute("filter")}var i,n,h=H.length,d="frameBorder",u="allowTransparency";$&&(n=function(){clearTimeout(Q),S.hide(),c(ne,_.onComplete)},F.html(_.title).add(W).show(),h>1?("string"==typeof _.current&&I.html(_.current.replace("{current}",j+1).replace("{total}",h)).show(),R[_.loop||h-1>j?"show":"hide"]().html(_.next),P[_.loop||j?"show":"hide"]().html(_.previous),_.slideshow&&M.show(),_.preloading&&t.each([r(-1),r(1)],function(){var e,i,o=H[this],n=t.data(o,Z);n&&n.href?(e=n.href,t.isFunction(e)&&(e=e.call(o))):e=t(o).attr("href"),e&&l(n,e)&&(e=s(n,e),i=new Image,i.src=e)})):O.hide(),_.iframe?(i=o("iframe")[0],d in i&&(i[d]=0),u in i&&(i[u]="true"),_.scrolling||(i.scrolling="no"),t(i).attr({src:_.href,name:(new Date).getTime(),"class":te+"Iframe",allowFullScreen:!0,webkitAllowFullScreen:!0,mozallowfullscreen:!0}).one("load",n).appendTo(W),se.one(le,function(){i.src="//about:blank"}),_.fastIframe&&t(i).trigger("load")):n(),"fade"===_.transition?x.fadeTo(a,1,e):e())},"fade"===_.transition?x.fadeTo(a,0,function(){J.position(0,h)}):J.position(a,h)}},J.next=function(){!q&&H[1]&&(_.loop||H[j+1])&&(j=r(1),f(H[j]))},J.prev=function(){!q&&H[1]&&(_.loop||j)&&(j=r(-1),f(H[j]))},J.close=function(){$&&!G&&(G=!0,$=!1,c(re,_.onCleanup),E.unbind("."+te),g.fadeTo(_.fadeOut||0,0),x.stop().fadeTo(_.fadeOut||0,0,function(){x.add(g).css({opacity:1,cursor:"auto"}).hide(),c(le),W.empty().remove(),setTimeout(function(){G=!1,c(he,_.onClosed)},1)}))},J.remove=function(){x&&(x.stop(),t.colorbox.close(),x.stop().remove(),g.remove(),G=!1,x=null,t("."+ee).removeData(Z).removeClass(ee),t(e).unbind("click."+te))},J.element=function(){return t(A)},J.settings=Y)})(jQuery,document,window);

/* Content Rotator */
(function(g){var k="rotator",i="."+k,j="data-transition",o=k+"-transitioning",h=k+"-wrapper",n=k+"-item",m=k+"-active",b=k+"-item-prev",d=k+"-item-next",l=k+"-in",f=k+"-out",a=k+"-nav",c=(function(){var r="t webkitT MozT OT MsT".split(" "),p=false,q;while(r.length){q=r.shift()+"ransition";if(q in document.documentElement.style!==undefined&&q in document.documentElement.style!==false){p=true;break}}return p}()),e={_create:function(){g(this).trigger("beforecreate."+k)[k]("_init")[k]("_addNextPrev").trigger("create."+k)},_init:function(){var p=g(this).attr(j);if(!p){c=false}g(this).wrap('<div class="'+h+'" />').addClass(k+" "+(p?k+"-"+p:"")+" ").children().addClass(n).first().addClass(m);g(this)[k]("_fixHeights")},_addNextPrevClasses:function(){var s=g(this).find("."+n),p=s.filter("."+m),q=p.next("."+n),r=p.prev("."+n);if(!q.length){q=s.first().not("."+m)}if(!r.length){r=s.last().not("."+m)}s.removeClass(b+" "+d);r.addClass(b);q.addClass(d)},next:function(){g(this)[k]("goTo","+1")},prev:function(){g(this)[k]("goTo","-1")},goTo:function(s){var x=g(this).find("."+k),z=x.attr(j),y=" after",t=" "+k+"-"+z+"-reverse";x.removeClass(y);g(this).find("."+n).removeClass([f,l,t,y].join(" "));var w=g(this).find("."+m),r=w.index(),p=(r<0?0:r)+1,q=typeof(s)==="number"?s:p+parseFloat(s),v=g(this).find(".rotator-item").eq(q-1),u=(typeof(s)==="string"&&!(parseFloat(s)))||q>p?"":t;if(!v.length){v=g(this).find("."+n)[u.length?"last":"first"]()}if(c){x[k]("_transitionStart",w,v,u)}else{v.addClass(m);x[k]("_transitionEnd",w,v,u)}x.trigger("goto."+k,v)},update:function(){g(this).children().not("."+a).addClass(n);return g(this).trigger("update."+k)},_fixHeights:function(){if(!g(this).hasClass("rotator-columns-1")){var r=g(this).find("."+k),s=g(this).find(".single-item"),q=g(this).find("img"),p=q.length;q.load(function(){p--;if(!p){s.css("min-height","auto");var t=s.map(function(){return g(this).outerHeight()||g(this).attr("height")}).get();s.css("min-height",Math.max.apply(Math,t)+1+"px")}}).filter(function(){return this.complete}).load()}},_on_resize:function(){var s=g(this),t=g(window),r=t.width(),p=t.height(),q;t.on("resize",function(w){var v=t.width(),u=t.height();if(r!==v||p!==u){clearTimeout(q);q=setTimeout(function(){s[k]("_fixHeights")},200);r=v;p=u}})},_transitionStart:function(q,s,p){var r=g(this);s.one(navigator.userAgent.indexOf("AppleWebKit")>-1?"webkitTransitionEnd":"transitionend otransitionend",function(){r[k]("_transitionEnd",q,s,p)});g(this).removeClass("after");g(this).addClass(p);q.addClass(f);s.addClass(l)},_transitionEnd:function(q,r,p){afterClass=(p)?"":"after";g(this).removeClass(p).addClass(afterClass);q.removeClass(f+" "+m);r.removeClass(l).addClass(m)},_bindEventListeners:function(){var p=g(this).parent().bind("click",function(r){var q=g(r.target).closest("a[href='#next'],a[href='#prev']");if(q.length){p[k](q.is("[href='#next']")?"next":"prev");r.preventDefault()}});return this},_addNextPrev:function(){return g(this).after("<nav class='"+a+"'><a href='#prev' class='prev' aria-hidden='true' title='Previous'>Prev</a><a href='#next' class='next' aria-hidden='true' title='Next'>Next</a></nav>")[k]("_bindEventListeners")},destroy:function(){}};g.fn[k]=function(r,q,p,s){return this.each(function(){if(r&&typeof(r)==="string"){return g.fn[k].prototype[r].call(this,q,p,s)}if(g(this).data(k+"data")){return g(this)}g(this).data(k+"active",true);g.fn[k].prototype._create.call(this)})};g.extend(g.fn[k].prototype,e)}(jQuery));(function(e,f){var d="rotator",b="."+d+"[data-paginate]",a=d+"-pagination",c=d+"-active-page",g={_createPagination:function(){var l=e(this).siblings("."+d+"-nav"),i=e(this).find("."+d+"-item"),m=e("<ol class='"+a+"'></ol>"),j,h,k;l.find("."+a).remove();i.each(function(n){j=n+1;h=e(this).attr("data-thumb");k=j;if(h){k="<img src='"+h+"' alt=''>"}m.append("<li><a href='#"+j+"' title='Go to slide "+j+"'>"+k+"</a>")});if(h){m.addClass(d+"-nav-thumbs")}l.addClass(d+"-nav-paginated").find("a").first().before(m)},_bindPaginationEvents:function(){e(this).parent().bind("click",function(j){var i=e(j.target);if(j.target.nodeName==="IMG"){i=i.parent()}i=i.closest("a");var h=i.attr("href");if(i.closest("."+a).length&&h){e(this)[d]("goTo",parseFloat(h.split("#")[1]));j.preventDefault()}}).bind("goto."+d,function(i,j){var h=j?e(j).index():0;e(this).find("ol."+a+" li").removeClass(c).eq(h).addClass(c)}).trigger("goto."+d)}};e.extend(e.fn[d].prototype,g);e(document).on("create."+d,b,function(){e(this)[d]("_createPagination")[d]("_bindPaginationEvents")}).on("update."+d,b,function(){e(this)[d]("_createPagination")})}(jQuery));(function(e){var d="rotator",b="."+d,a=d+"-no-transition",c=/iPhone|iPad|iPod/.test(navigator.platform)&&navigator.userAgent.indexOf("AppleWebKit")>-1,f={_dragBehavior:function(){var m=e(this),j,l={},k,h,g=function(p){var o=p.touches||p.originalEvent.touches,n=e(p.target).closest(b);if(p.type==="touchstart"){j={x:o[0].pageX,y:o[0].pageY}}if(o[0]&&o[0].pageX){l.touches=o;l.deltaX=o[0].pageX-j.x;l.deltaY=o[0].pageY-j.y;l.w=n.width();l.h=n.height();l.xPercent=l.deltaX/l.w;l.yPercent=l.deltaY/l.h;l.srcEvent=p}},i=function(n){g(n);if(l.touches.length===1){e(n.target).closest(b).trigger("drag"+n.type.split("touch")[1],l)}};e(this).bind("touchstart",function(n){e(this).addClass(a);i(n)}).bind("touchmove",function(n){g(n);i(n)}).bind("touchend",function(n){e(this).removeClass(a);i(n)})}};e.extend(e.fn[d].prototype,f);e(document).on("create."+d,b,function(){e(this)[d]("_dragBehavior")})}(jQuery));(function(e){var d="rotator",a="."+d,b=d+"-active",g=d+"-item",f=function(h){return Math.abs(h)>4},c=function(j,h){var k=j.find("."+d+"-active"),m=k.prevAll().length+1,i=h<0,o=m+(i?1:-1),n=j.find("."+g).removeClass("rotator-item-prev rotator-item-next"),l=n.eq(o-1);if(!l.length){l=j.find("."+g)[i?"first":"last"]()}return[k,l]};e(document).on("dragmove",a,function(j,i){if(!f(i.deltaX)){return}var h=c(e(this),i.deltaX);h[0].css("left",i.deltaX+"px");h[1].css("left",i.deltaX<0?i.w+i.deltaX+"px":-i.w+i.deltaX+"px")}).on("dragend",a,function(k,j){if(!f(j.deltaX)){return}var i=c(e(this),j.deltaX),h=Math.abs(j.deltaX)>45;e(this).one(navigator.userAgent.indexOf("AppleWebKit")?"webkitTransitionEnd":"transitionEnd",function(){i[0].add(i[1]).css("left","");e(this).trigger("goto."+d,i[1])});if(h){i[0].removeClass(b).css("left",j.deltaX>0?j.w+"px":-j.w+"px");i[1].addClass(b).css("left",0)}else{i[0].css("left",0);i[1].css("left",j.deltaX>0?-j.w+"px":j.w+"px")}})}(jQuery));(function(a){var e="rotator",b="."+e,g=e+"-active",i=e+"-top",h=e+"-item",d=function(j){return(j>-1&&j<0)||(j<1&&j>0)},c=function(l,j){var m=l.find("."+e+"-active"),o=m.prevAll().length+1,k=j<0,p=o+(k?1:-1),n=l.find("."+h).eq(p-1);if(!n.length){n=l.find("."+h)[k?"first":"last"]()}return[m,n]};var f=a(this).attr("data-transition");if(f==="flip"){a(document).on("dragstart",b,function(k,j){a(this).find("."+i).removeClass(i)}).on("dragmove",function(n,m){if(!d(m.xPercent)){return}var l=c(a(this),m.deltaX),k=m.xPercent*180,j=Math.abs(m.xPercent)>0.5;l[0].css("-webkit-transform","rotateY("+k+"deg)");l[1].css("-webkit-transform","rotateY("+((k>0?-180:180)+k)+"deg)");l[j?1:0].addClass(i);l[j?0:1].removeClass(i)}).on("dragend",b,function(m,l){if(!d(l.xPercent)){return}var k=c(a(this),l.deltaX),j=Math.abs(l.xPercent)>0.5;if(j){k[0].removeClass(g);k[1].addClass(g)}else{k[0].addClass(g);k[1].removeClass(g)}k[0].add(k[1]).removeClass(i).css("-webkit-transform","")})}}(jQuery));(function(f){var e="rotator",d="."+e,c="."+e+"-nav a",b,a=function(g){clearTimeout(b);b=setTimeout(function(){var h=f(g.target).parent().parent(d+"-wrapper");if(g.keyCode===39||g.keyCode===40){h[e]("next")}else{if(g.keyCode===37||g.keyCode===38){h[e]("prev")}}},200);if(37<=g.keyCode<=40){g.preventDefault()}};f(document).on("click",c,function(g){f(g.target)[0].focus()}).on("keydown",c,a)}(jQuery));(function(f){var e="rotator",c="."+e,g=e+"-item",d=e+"-active",b="data-"+e+"-slide",h=f(window),a={_assessContainers:function(){var q=f(this),m=q.find("["+b+"]"),p=m.filter("."+d).children(0),r=m.children(),o=[];if(!m.length){r=f(this).find("."+g)}else{r.appendTo(q);m.remove()}r.css("height","1px").removeClass(g+" "+d).each(function(){var i=f(this).prev();if(!i.length||f(this).offset().top!==i.offset().top){o.push([])}o[o.length-1].push(f(this))}).css("height","");for(var n=0;n<o.length;n++){var k=f("<div "+b+"></div>");for(var l=0;l<o[n].length;l++){k.append(o[n][l])}k.appendTo(q)}q[e]("update").trigger("goto."+e);q.find("."+g).eq(0).addClass(d)},_dynamicContainerEvents:function(){var l=f(this),k=h.width(),i=h.height(),j;l[e]("_assessContainers");h.on("resize",function(o){var n=h.width(),m=h.height();if(k!==n||i!==m){clearTimeout(j);j=setTimeout(function(){l[e]("_fixHeights");l[e]("_assessContainers")},200);k=n;i=m}})}};f.extend(f.fn[e].prototype,a);f(document).on("create."+e,c,function(){f(this)[e]("_dynamicContainerEvents")})}(jQuery));(function(d,f){var c="rotator",b="."+c,a=4000,e={play:function(){var i=d(this).parent(),g=d(this).attr("data-interval"),h=parseFloat(g)||a;return i.data("timer",setInterval(function(){i[c]("next")},h))},stop:function(){clearTimeout(d(this).data("timer"))},_bindStopListener:function(){return d(this).parent().bind("mousedown touchmove",function(){d(this)[c]("stop")})},_initAutoPlay:function(){var g=d(this).attr("data-autoplay");if(g==="true"||g===true){d(this)[c]("_bindStopListener")[c]("play")}}};d.extend(d.fn[c].prototype,e);d(document).on("create."+c,b,function(){d(this)[c]("_initAutoPlay")})}(jQuery));(function(a){a(function(){a(".rotator").rotator()})}(jQuery));
