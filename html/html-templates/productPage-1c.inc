<tr><td class="ac_product_desc"><form method="post" action="%%scriptURL%%">
%%make_hidden_fields%%
<b>%%name%%</b><br/>Product ID: %%ProductID%%<br/>
<a href="%%scripturl%%?cart_id=%%cart_id%%&amp;p_id=%%ProductID%%&amp;product=%%product%%&amp;xm=on&ppinc=search2">Click Here for More Information</a></td>
<td width="100"><span class="ac_product_price">%%price%%</span><br/></td>
<td width="160">
<!--BEGIN SELECT QUANTITY BUTTON-->
<table class="ac_add-quantity"><tr><td class="ac_add-quantity">%%QtyBox%%</td>
<td class="ac_add-quantity"><input type="image" name="add_to_cart_button" value="Add To Cart" src="%%ButtonSetURL%%/add_to_cart.gif">
</td></tr></table>
<!--END SELECT QUANTITY BUTTON-->
<a href="%%scripturl%%?dc=1&%%href_fields%%" rel="nofollow">Check Out</a></td></form></tr>
<tr><td colspan=3><hr/></td></tr>