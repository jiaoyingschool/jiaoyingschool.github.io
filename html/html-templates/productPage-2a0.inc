<!--agorascript-pre
{
local ($myans)="";
if ($rowCount == (1+$minCount)) { #first one
  $ags_row_item=0;
  $ags_tot_item=0;
  $myans .= '<tr><td colspan=3><table width="100%" border=1>'."\n";
 }
$ags_row_item++;
$ags_tot_item++;
if ($ags_row_item == 2) { # second one
  $ags_row_item=0; #reset counter
  $myans .= '<td width="50%"><table width=100%>'."\n";
 } else { #first one
  $myans .= '<tr><td width="50%"><table width=100%>'."\n";
 }
return $myans;
}
-->
<tr> 
	<td class="ac_product_opt-add">
		<form method="post" action="%%scriptURL%%">
			%%make_hidden_fields%%
			%%optionFile%%
			<!--BEGIN SELECT QUANTITY BUTTON-->
			<table class="ac_add-quantity">
				<tr>
					<td class="ac_add-quantity">
						%%QtyBox%%
					</td>
					<td class="ac_add-quantity">
						<input type="image" name="add_to_cart_button" value="Add To Cart"
							src="%%URLofImages%%/add_to_cart.gif">
					</td>
				</tr>
			</table>
			<!--END SELECT QUANTITY BUTTON-->
		</form>
	</td>
	<td class="ac_product_image">%%image%%</td>
</tr>
<tr>
	<td colspan=2>
		<h3 class="ac_product_name">%%name%%</h3>
		<p class="ac_product_desc">%%description%%</p>	
	</td>
</tr>
<tr> 
	<td colspan=2>
		<table width='100%' border=0 cellpadding=0 cellspacing=0 class="ac_product_desc">
			<tr>
				<td width='33%' align=center>
					<span class="ac_product_price">%%price%%</span>
				</td>
				<td width='33%' align=center>
					<a href="%%scripturl%%?dc=1&amp;%%href_fields%%">View Cart</a>
				</td>
				<td width = '33%' align=center>
					<a href='%%StepOneURL%%?order_form_button.x=1&amp;%%href_fields%%'>Check Out</a>
				</td>
			</tr>
		</table>
	</td>
</tr>
<!--agorascript-pre
{
local ($myans)="";
if ($ags_row_item == 1) { # first one
  $myans .= '</table></td>'."\n";
 } else { # second one
  $myans .= '</table></td></tr>'."\n";
 }
if (($rowCount == ($maxCount)) || ($rowCount == ($num_returned)))
 { # very last one
  if ($ags_row_item == 1) { # finished first one, add a blank dummy second
    $myans .= '<td>&nbsp;</td></tr>'."\n";
   }
  $myans .= '</table></td></tr>'."\n";
 }
return $myans;
}
-->
