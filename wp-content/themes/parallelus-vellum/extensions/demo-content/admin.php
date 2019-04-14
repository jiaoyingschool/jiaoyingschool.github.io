<?php

if( IS_CHILD && get_template() == 'runway-framework') {

	// Put a warning about the danger of doing this when developing a Runway child theme!

	require_once('views/runway-child-themes.php');

} else {

	// Standalone and regular child themes... no problem!

	global $demo_content_admin, $demo_content_settings;

	$action = isset($_REQUEST['action']) ? $_REQUEST['action'] : '';

	if($action != ''){
		switch ($action) {
			case 'apply-kit':{ 
				$alias = isset($_REQUEST['alias']) ? sanitize_title($_REQUEST['alias']) : '';

				if (isset($_GET['_wpnonce']) && wp_verify_nonce($_GET['_wpnonce'], 'starter_kit')) {
					// Set the data for this kit
					$apply   = $demo_content_admin->apply_kit();
					$message = ($apply) ? '1' : '2'; // success or error
				} 

			} break;
			
			case 'delete-backup':{ 
				$alias = isset($_REQUEST['alias']) ? sanitize_title($_REQUEST['alias']) : '';
				if (isset($alias) && !empty($alias)) {
					// Set the data for this kit
					$confrim = $demo_content_admin->delete_backup( $alias );
					// success or error
					if ($confrim) {
						$message = __('The backup has been deleted.'); 
						$message_class = 'updated';
					} else {
						__('The backup could not be deleted.'); 
						$message_class = 'error';
					}
				} 
			} break;

			case 'restore-backup':{ 
				$alias = isset($_REQUEST['alias']) ? sanitize_title($_REQUEST['alias']) : '';
				if (isset($alias) && !empty($alias)) {
					// Set the data for this kit
					$confrim = $demo_content_admin->restore_backup( $alias );
					// success or error
					if ($confrim) {
						$message = __('The backup has been restored.'); 
						$message_class = 'updated';
					} else {
						__('The backup could not be restored.'); 
						$message_class = 'error';
					}				} 
			} break;

			default:{
				// nothing to do
			} break;
		}
	}

	switch ($demo_content_admin->navigation) {
		/*
		case 'something':{
			// do something
		} break;
		*/

		default:{
			require_once('views/admin-home.php');
		}
	}  

}
?>