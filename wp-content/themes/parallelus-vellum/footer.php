				<?php 
				
				// Layout Manager - End Layout
				//................................................................
				do_action('output_layout','end'); ?>
				
			</div><!-- .main-content -->
		</div><!-- #Middle -->

		<footer id="Bottom" class="site">
			<?php 
			// Footer layout information
			//................................................................
			$footer_data = get_layout_options('footer');
			$footer = (isset($footer_data)) ? $footer_data : false;

			// Footer Top Content
			//................................................................
			$footer_type = (isset($footer['footer-top-content'])) ? get_footer_content($footer['footer-top-content']) : false;

			if ( !empty($footer_type) ) {
				?>	
				<div id="FooterTop" class="clearfix">
					<?php
					// Footer Top Content
					if ($footer_type != 'default') { ?>
						<div class="footer-content-top type_<?php echo $footer_type ?>">
							<?php show_footer_content($footer_type, $footer['footer-top-content']); ?>
						</div>
						<?php
					} else {
						// Theme Default Footer Top 
						echo '<div class="inner-wrapper"><div class="widget-area">';
						if (!function_exists('dynamic_sidebar') || !dynamic_sidebar('sidebar-footer-top')) : endif;
						echo '</div> <!-- / .widget-area --> </div>';
					} ?>
				</div><!-- #FooterTop -->
				<?php
			} // End Footer Top Content
			
			// Footer Bottom Content
			//................................................................
			$footer_type = (isset($footer['footer-bottom-content'])) ? get_footer_content($footer['footer-bottom-content']) : false;

			if ( !empty($footer_type) ) {
				?>	
				<div id="FooterBottom" class="clearfix">
					<?php
					// Footer Bottom Content
					if ($footer_type != 'default') { ?>
						<div class="footer-content-bottom type_<?php echo $footer_type ?>">
							<?php show_footer_content($footer_type, $footer['footer-bottom-content']); ?>
						</div>
						<?php
					} else {
						// Theme Default Footer Bottom 
						echo '<div class="inner-wrapper"><div class="widget-area">';
						if (!function_exists('dynamic_sidebar') || !dynamic_sidebar('sidebar-footer-bottom')) : endif;
						echo '</div> <!-- / .widget-area --> </div>';
					} ?>
				</div><!-- #FooterBottom -->
				<?php
			} // End Footer Bottom Content
			?>
		</footer><!-- #Bottom -->

	</div> <!-- #ContentWrapper -->
</div><!-- #page -->

<?php

// Login popup window 
//................................................................
// - Call with link: <a href="#LoginPopup">Login</a>  
?>
<div class="hidden">
	<div id="LoginPopup">
		<form class="loginForm" id="popupLoginForm" method="post" action="<?php echo wp_login_url(); // optional redirect: wp_login_url('/redirect/url/'); ?>">
			<div id="loginBg"><div id="loginBgGraphic"></div></div>
			<div class="loginContainer">
				<h3><?php _e( 'Sign in to your account', 'framework' ); ?></h3>
				<fieldset class="formContent">
					<legend><?php _e( 'Account Login', 'framework' ); ?></legend>
					<div class="fieldContainer">
						<label for="ModalUsername"><?php _e( 'Username', 'framework' ); ?></label>
						<input id="ModalUsername" name="log" type="text" class="textInput" />
					</div>
					<div class="fieldContainer">
						<label for="ModalPassword"><?php _e( 'Password', 'framework' ); ?></label>
						<input id="ModalPassword" name="pwd" type="password" class="textInput" />
					</div>
				</fieldset>
			</div>
			<div class="formContent">
				<button type="submit" class="btn signInButton"><span><?php _e( 'Sign in', 'framework' ); ?></span></button>
			</div>
			<div class="hr"></div>
			<div class="formContent">
				<a href="<?php echo site_url() ?>/wp-login.php?action=lostpassword" id="popupLoginForgotPswd"><?php _e( 'Forgot your password?', 'framework' ); ?></a>
			</div>
		</form>
	</div>
</div>

<?php

// Scroll to top button
//................................................................

$showBackToTop = (get_options_data('options-page', 'back-to-top', 'false') == 'true') ? true : false;
if ($showBackToTop) { 
	?>
	<div id="BackToTop"><a href="#ScrollTop"><i class="fa fa-chevron-up"></i></a></div>
	<?php
} ?>

<?php wp_footer(); ?>

</body>
</html>