<form action="<?php echo $this->self_url('extensions'); ?>&action=install-extension" method="post"><br>
<table class="wp-list-table widefat plugins">
	<thead>
		<tr>
			<th scope="col" id="cb" class="manage-column column-cb check-column" style="width: 0px;"><input type="checkbox" name="ext_chk[]" /></th>
			<th id="name" class="manage-column column-name">Extension</th>
			<th id="description" class="manage-column column-description">Description</th>
		</tr>
	</thead>
	<tbody id="the-list">
	<?php
if ( !empty( $exts ) ):
	foreach ( $exts as $ext => $ext_info ):
		$ext_cnt = !$extm->is_activated( $ext );
?>
		<?php if($extm->is_activated( $ext )): ?>
		<tr class="inactive">
			<th class="check-column">
				<input type="checkbox" name="ext_chk[]" value="<?php echo $ext; ?>" />
			</th>
			<td class="plugin-title">
				<strong><?php echo $ext_info['Name']; ?></strong>
			</td>
			<td class="column-description desc">
				<?php
					// Item description
					$description = '<div class="plugin-description"><p>'. $ext_info['Description'] .'</p></div>';
					// Item info
					$class = ( $ext_cnt ) ? 'inactive' : 'active' ;					
					$version = ( $ext_info['Version'] ) ? 'Version: '.$ext_info['Version'] : '';
					if ( $ext_info['Author'] ) {
						$author = ' | By '. $ext_info['Author'];
						if ( $ext_info['AuthorURI'] ) {
							$author = ' | By <a href="'. $ext_info['AuthorURI'] .'" title="Visit author homepage">'. $ext_info['Author'] .'</a>';
						}
					}
					else {
						$author = ' | By Unknown';	
					}
					$plugin_link = ( $ext_info['ExtensionURI'] ) ? ' | <a href="'. $ext_info['ExtensionURI'] .'" title="Visit plugin site">Visit plugin site</a>' : '';
					$info = '<div class="'. $class .' second plugin-version-author-uri">'. $version . $author . $plugin_link .'</div>';

					// Print details
					echo $description;
					echo $info;
				?>
			</td>
		</tr>
	<?php endif; endforeach; else: ?>
		<tr calss="active">
			<td class="plugin-title">
				Extensions not found.
			</td>
			<td class="column-description desc"> </td>
		</tr>
	<?php endif; ?>
	</tbody>
</table><br>

<input class="button-primary" type="submit" value="Allow Install as Plugin">
</form>