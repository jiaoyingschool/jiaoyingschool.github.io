

jQuery(window).load(function() {

	// Confirm backup delete
	jQuery('.delete-backup').click( function( event ) {
		event.preventDefault;
		return confirm(jQuery('#confirm-delete-backup-text').text());
	});

	// Confirm backup restore
	jQuery('.restore-backup').click( function( event ){
		event.preventDefault;
		return confirm(jQuery('#confirm-restore-backup-text').text());
	});

	// Tracking for manual click vs. auto trigger by content import
	applyKitClick = true;

	// Import Demo Content
	var import_content_running = false;
	jQuery('.apply-kit-with-content').click(function( event ) {
		event.preventDefault;

		$this = jQuery(this);

		jQuery('#DemoImportNotice, #KitActivateNotice').removeClass('error').addClass('active updated')
			.children('p').css('display','none').end()
			.css('display','none');

		if ( ! import_content_running) {
			if (confirm(jQuery('#confirm-apply-kit-and-content-text').text())) {

				import_content_running = true;
				jQuery("html, body").animate({ scrollTop: 0 }, 450);
				
				alias = $this.data('alias');
				menu  = $this.data('menu');
				
				jQuery('.starter-kits .button').attr('disabled', 'disabled'); // disable the buttons on the page (no more clicking!)
				jQuery('#DemoImportNotice')
					.children('.loading').css('display','block').end()
					.fadeIn();

				jQuery.ajax({
					type: 'POST',
					url: ajaxurl,
					data: {
						action: 'importThemeContent',
						alias: alias,
						menu: menu
					},
					success: function(data, textStatus, XMLHttpRequest){
						
						import_content_running = false;
						jQuery('.starter-kits .button').removeAttr('disabled'); // enable the buttons again.

						// Needs folder path string updated
						if (data == '2') {
							response = jQuery('#DemoImportNotice').children('.response-'+data).text();
							jQuery('#DemoImportNotice').children('.response-'+data).text(response.replace("{folder}",alias));
						}

						// Show error message
						if (data == '2' || data == '3') {
							jQuery('#DemoImportNotice').addClass('error').removeClass('updated')
						} else {
							// We can't get a success "1" response since it's at the end of the demo info dump, 
							// but we can default to it when not getting status 2 or 3
							data = '1';
						}

						jQuery('#DemoImportNotice').removeClass('active')
							.children('p').css('display','none').end()
							.children('.response-'+data).fadeIn('slow').end();

						// Trigger the kit activation next
						applyKitClick = false;
						$this.parent().find('.apply-kit').trigger('applyKit');
						applyKitClick = true;

					},
					error: function(MLHttpRequest, textStatus, errorThrown){

					}
				});
			}
		}

		return false;
	});

	// Activate Starter Kit
	var import_kit_running = false;
	jQuery('.apply-kit').on( 'click applyKit', function( event ) {
		event.preventDefault;

		$this = jQuery(this);
			
		jQuery('#KitActivateNotice').removeClass('error').addClass('active updated')
			.children('p').css('display','none').end()
			.css('display','none');

		if ( ! import_kit_running) {
			
			// we need to confirm first if this is a direct kit application, without first importing demo content
			accept = (applyKitClick == true) ? confirm(jQuery('#confirm-apply-kit-only-text').text()) : true;
			
			if (accept) {
				
				import_kit_running = true;
				jQuery("html, body").animate({ scrollTop: 0 }, "slow");
				
				alias = $this.data('alias');
				menu  = $this.data('menu');
				
				jQuery('.starter-kits .button').attr('disabled', 'disabled'); // disable the buttons on the page (no more clicking!)
				jQuery('#KitActivateNotice')
					.children('.loading').css('display','block').end()
					.fadeIn();

				jQuery.ajax({
					type: 'POST',
					url: ajaxurl,
					data: {
						action: 'applyStarterKit',
						alias: alias,
						menu: menu
					},
					success: function(data, textStatus, XMLHttpRequest){
						
						import_kit_running = false;
						jQuery('.starter-kits .button').removeAttr('disabled'); // enable the buttons again.


						if (data == '2') {
							jQuery('#KitActivateNotice').addClass('error').removeClass('updated');
						}

						jQuery('#KitActivateNotice').removeClass('active')
							.children('p').css('display','none').end()
							.children('.response-'+data).fadeIn('slow').end();

					},
					error: function(MLHttpRequest, textStatus, errorThrown){

					}
				});
			}
		}

		return false;
	});


});
