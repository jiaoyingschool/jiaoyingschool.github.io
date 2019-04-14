<tr><td class="ac_product_desc">
<form method="post" action="%%scriptURL%%">
%%make_hidden_fields%%
<b>%%name%%</b><br>
%%description%%<br/>
%%optionFile%%<br/></TD>
<td width="100"><span class="ac_product_price">%%price%%</span></td>
  <td width="160">
<!--BEGIN SELECT QUANTITY BUTTON-->
<table class="ac_add-quantity"><tr><td class="ac_add-quantity">%%QtyBox%%</td>
<td class="ac_add-quantity"><input type="image" name="add_to_cart_button" value="Add To Cart" src="%%ButtonSetURL%%/add_to_cart.gif">
</td></tr></table>
<!--END SELECT QUANTITY BUTTON-->
<a href="agora.cgi?dc=1&%%href_fields%%" rel="nofollow"><b>Check Out</b></a></td></form></tr>
<tr><td><hr/></td></tr>