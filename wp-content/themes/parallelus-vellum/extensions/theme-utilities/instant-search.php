<?php


// Instant Search with AJAX Results
//...............................................

function theme_instant_search_results() {
	if( isset( $_POST['keyword'] ) && !empty( $_POST['keyword'] ) ) {

		$max_results = 4;
		$keyword = esc_attr($_POST['keyword']);
		$noResults = false;

		// Search post by keyword
		$args = array(
			'posts_per_page' => -1,
			'ignore_sticky_posts' => 1,
			'paged' => 1,
			's' => $keyword
		);
		$query = new WP_Query( $args );

		if ( $query->have_posts() ) {  

			// Count display post
			$count_show_post = 0;

		    while ( $query->have_posts() ) {
				$query->the_post();
		    	
		    	// Skip posts set to exclude from search
		    	if (get_post_meta(get_the_ID(), 'search_exclude', true) == 1)
		    		continue;

		    	// if there are more results still...
		    	if( $count_show_post >= $max_results ) {
					echo '<a href="'.home_url('/').'?s='.$keyword.'" class="ajax-search-link" >'.__('Show all results', 'framework').' <i class="fa fa-angle-right"></i></a>';
					break;
				}
		          
				?>
				<div class="ajax-search-result" >
					<h2 class="ajax-result-title entry-title" >
						<a href="<?php the_permalink(); ?>"><?php the_title(); ?></a>
					</h2>
					<?php
					// Excerpt
					$excerpt = get_the_excerpt();
					if (strlen($excerpt)) {
						?>
						<p class="ajax-search-excerpt"><?php echo substr($excerpt, 0, 140); ?>...</p>
						<?php
					}
					?>
				</div>
				<?php  

				$count_show_post++;
		    }  

		    if ($count_show_post === 0) {
		    	$noResults = true;
		    }
		} else {

			// If nothing found 
			$noResults = true;
		}

		if ($noResults) {
			// No results or everything's hidden from search
			?>
			<div class="ajax-search-result nothing-found"><i class="fa fa-search"></i><span><?php _e('Sorry, nothing was found.', 'framework') ?></span></div>
			<?php
		}

	}
}

add_action('wp_ajax_live_search', 'theme_instant_search_results');
add_action('wp_ajax_nopriv_live_search', 'theme_instant_search_results');

?>