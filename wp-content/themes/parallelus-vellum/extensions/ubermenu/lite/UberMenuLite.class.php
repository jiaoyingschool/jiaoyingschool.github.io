<?php

define( 'UBERMENU_VERSION', 	'2.3.0.0-LITE' );

class UberMenuLite extends UberMenu{

	function __construct(){
		
		//Determine Base URL - replace slashes for Windows compatibility
		if( !defined('UBERMENU_LITE_PATH') ) {
			$um_path = str_replace( "\\", '/', dirname( dirname( __FILE__ ) ) );
			$um_path = str_replace( str_replace( "\\", '/', get_template_directory() ), "",$um_path );
		} else {
			$um_path = UBERMENU_LITE_PATH;
		}
		$um_url = get_template_directory_uri().$um_path.'/';
		$this->editionURL = $um_url.'lite/'; 
		parent::__construct( $um_url );
		
		if( !is_admin() ){
			//Attach this to the after_setup_theme action, as the plugins_loaded hook has already run prior to this being loaded
			add_action( 'after_setup_theme' , array( $this , 'init' ) );
		}
	}


	function loadJS(){

		parent::loadJS();

		// Load Hover Intent
		if( $this->settings->op( 'wpmega-trigger' ) == 'hoverIntent' )
			wp_enqueue_script( 'hoverintent' , $this->coreURL.'js/hoverIntent.js', array( 'jquery' ), false, true );
		
	}

	function getWalker(){
		return new UberMenuWalkerCore();
	}

	function getMenuArgs( $args ){

		$args = parent::getMenuArgs( $args );

		$args['container'] 			= 'nav';
		
		$args['container_class']	.= ' megaFullWidth';

		//$args['container_class']	.= ' megaMenuHorizontal';
		$args['container_class']	.= ' megaClear';
		$args['container_class']	.= ' uberLite';

		$args['menu_id'] 			= 'megaUber';

		return $args;


	}

	function showMenuOptions( $item_id ){
		parent::showMenuOptions( $item_id );
		do_action( 'ubermenu_extended_menu_item_options' , $item_id , $this );	
	}




	function optionsMenu(){

		$sparkOps = parent::optionsMenu();

		if( !defined( 'UBERMENU_UPGRADE' ) ){
			$compare = 'comparison';
			$sparkOps->registerPanel( $compare , __( 'Images, Widgets, Shortcodes &amp; More UberMenu Features' , 'ubermenu' ) , 200 , false );
			$sparkOps->addCustomField( $compare , 'ubermenu-pro-upgrade' , 'ubermenu_pro_upgrade' );
		}
		
		return $sparkOps;
	}

	function getOptionsMenuLinks(){
		//Links
		$links = array(

			1	=>	array(
				'href'	=>	'http://goo.gl/YV7aw',
				'class'	=>	'spark-outlink-hl',
				'title'	=>	__( 'Read the Support Manual' , 'ubermenu' ),
				'text'	=>	__( 'Support Manual &rarr;' , 'ubermenu' ),		
			),

			2	=>	array(
				'href'	=>	'http://goo.gl/G8b3r',
				'class'	=>	'spark-outlink-hl',
				'title'	=>	__( 'Watch Video Tutorials' , 'ubermenu' ),
				'text'	=>	__( 'Video Tutorials &rarr;' , 'ubermenu' ),	
			),
			
			3	=>	array(
				'href'	=>	'http://j.mp/fDpVkP',
				'class'	=>	'spark-outlink',
				'title'	=>	__( 'Get even more mega menu awesomeness with the full plugin version of UberMenu' , 'ubermenu' ),
				'text'	=>	__( 'Get UberMenu Pro &rarr;' , 'ubermenu' )
			)
		);

		return $links;
	}

}