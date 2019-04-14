$sc_gateway_username = 'your_ID_here';
$txnkey = "Your_Key_Here";
$tstamp = time;
$tstamp3 = "time";
$sc_order_script_url = "https://secure.authorize.net/gateway/transact.dll";
$sc_auth_submit = 'agora.cgi?secpicserve=submit_order.gif';
$sc_auth_change = 'agora.cgi?secpicserve=make_changes.gif';
$sc_auth_verify_message = "Please verify the information below.  When you are confident it is correct, click on the \'Submit Order For Processing\' button to go to the Authorize.Net site where you will enter your payment information.";
$sc_auth_order_desc = "Authorize.net - AgoraCart Online Order";
$sc_display_checkout_tos = "no";
$sc_tos_display_address = qq'AgoraCart<br>
123 Main<br>
Salt Lick City, UT 88888<br>
123-456-7890';
$x_logo_url = "";
$x_color_background = "#FFFFFF";
$x_color_link = "#0000FF";
$x_color_text = "#000000";
$x_description = "Online Order at www.mydomain.com";
$x_header_html_payment_form = "<!--agorascript-pre
  return \$anet_cart_table;
-->";
$x_footer_html_payment_form = "Bottom of the orderform text goes here";
$x_header_html_receipt = "Top of the receipt text goes here";
$x_footer_html_receipt = "";
$x_header_email_receipt = "top of e-mail";
$x_footer_email_receipt = "<!--agorascript-pre
 return \$anet_prod_in_cart;
-->";
$merchant_live_mode = "no";
1;
