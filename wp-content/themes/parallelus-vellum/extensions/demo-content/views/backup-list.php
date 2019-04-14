<h3><?php _e('Backups', 'framework'); ?></h3>
<hr>

<br>
<?php 

$backups = $demo_content_admin->get_backup_log() ;

if(!empty($backups)): 
	?>
	<table class="wp-list-table widefat" style="width: auto;">
		<tbody id="the-list">
			<?php 
			$count = 0;
			krsort($backups); // sort rfrom newest to oldest
			foreach ($backups as $backupID => $backupDate):
				$trClass = ($count % 2 == 0) ? 'alt' : ''; 
				?>
				<tr class="<?php echo $trClass ?>">
					<td class="column-title">
						<strong><?php _e('Saved Backup', 'framework'); ?></strong> <span style"font-size: 0.8em;">(<?php echo $backupID; ?>)</span>
					</td>
					<td class="column-date">
						<?php echo $backupDate; ?>
					</td>
					<td class="column-alias"></td>
					<td class="column-description" style="text-align:right;">
						<a class="restore-backup" href="<?php echo $this->self_url(); ?>&action=restore-backup&alias=<?php echo $backupID; ?>"><?php _e('Restore', 'framework') ?></a> | 
						<a class="delete-backup" style="color: #BC0B0B;" href="<?php echo $this->self_url(); ?>&action=delete-backup&alias=<?php echo $backupID; ?>"><?php _e('Delete', 'framework') ?></a>
					</td>
				</tr>
				<?php
				$count++; 
			endforeach; ?>
		</tbody>
	</table>
<?php else: ?>
<p><?php _e('When you apply a starter kit an automatic backup of the modified options will be saved here.', 'framework') ?></p>
<?php endif; ?>