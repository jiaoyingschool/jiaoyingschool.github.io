<tr><td class="ac_product_opt-add">
		<form method="post" action="%%scriptURL%%">
			%%make_hidden_fields%%
			%%optionFile%%
			<!--BEGIN SELECT QUANTITY BUTTON-->
			<table class="ac_add-quantity"><tr><td class="ac_add-quantity">%%QtyBox%%
					</td><td class="ac_add-quantity">
						<input type="image" name="add_to_cart_button" value="Add To Cart" src="%%ButtonSetURL%%/add_to_cart.gif">
					</td></tr></table>
			<!--END SELECT QUANTITY BUTTON-->
		</form></td><td class="ac_product_image">%%image%%</td>
	<td><h3 class="ac_product_name">%%name%%</h3>
		<p class="ac_product_desc">%%description%%</p><br/>
			<table width='100%' border=0 cellpadding=0 cellspacing=0 class="ac_product_desc">
				<tr><td width='33%' align=center>
						<span class="ac_product_price">%%price%%</span>
					</td><td width='33%' align=center>
						<a href="%%scripturl%%?dc=1&amp;%%href_fields%%" rel="nofollow">View Cart</a>
					</td><td width = '33%' align=center>
						<a href='%%StepOneURL%%?order_form_button.x=1&amp;%%href_fields%%' rel="nofollow">Check Out</a>
					</td></tr></table></td>
</tr><tr><td colspan="3"><hr/></td></tr>