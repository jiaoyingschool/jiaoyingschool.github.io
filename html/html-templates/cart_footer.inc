<div align="center"><table class="ac_checkout">
	<tr>
		<td><div align="center">
<!--agorascript-pre
if ($sc_qty_box_on_cart_display =~ /yes/i) {
  return '<input type="image" name="submit_change_quantity_button" 
  	value="Change Quantity" src="%%ButtonSetURL%%/edit_items.gif">';
 } else {
  return '<input type="image" name="change_quantity_button" 
  	value="Change Quantity" src="%%ButtonSetURL%%/edit_items.gif">';
 }
-->
<input type="image" name="delete_item_button" 
	value="Delete Items" src="%%ButtonSetURL%%/remove_items.gif">
<input type="image" name="continue_shopping_button" 
	value="Continue Shopping" src="%%ButtonSetURL%%/continue_shopping.gif">

<br>

<!--DO NOT DELETE THIS NEXT LINE-->
%%offlineSecureURL%%
<!--END DO NOT DELETE THIS NEXT LINE-->

<input type="image" name="order_form_button" 
	value="Complete Secure Order" src="%%ButtonSetURL%%/complete_order.gif">
</div>
		</td>
	</tr>
</table>
</div>
</form>

