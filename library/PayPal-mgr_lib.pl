# PayPal Processing Gateway
#
# Copyright 2000,2001 Steve Kneizys.
# Copyright 2002-Present K-Factor Technologies, Inc.  All Rights Reserved.
#
# Requires AgoraCart version 5.0.0 or above.  Just place this file in the library directory.
#
# This is NOT FREE AND/OR GPL SOFTWARE!  This library is a cost item.
# This software is a separate add-on to an ecommerce shopping cart and 
# is the confidential and proprietary information of K-Factor Technologies, Inc.  You may
# not disclose such Confidential Information and shall use it only in
# conjunction with the AgoraCart (aka agora.cgi) shopping cart.  It must be licensed for
# Each use on EACH store it is used on.  License at AgoraCartPro.com
#
# To use it you must license it from http://www.agoracart.com/ or
# http://www.agoracartpro.com/
#
# K-Factor Technologies, Inc. BytePipe, AgoraScript nor any of their employees and/or representatives
# MAKES NO REPRESENTATIONS OR WARRANTIES ABOUT
# THE SUITABILITY OF THE SOFTWARE, EITHER EXPRESSED OR IMPLIED,
# INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE,
# OR NON-INFRINGEMENT.
#
# K-Factor Technologies, Inc., BytePipe, AgoraScript nor any of their employees and/or representatives
# SHALL NOT BE LIABLE FOR ANY DAMAGES SUFFERED BY
# LICENSEE AS A RESULT OF USING, MODIFYING OR DISTRIBUTING THIS
# SOFTWARE OR ITS DERIVATIVES.
#
# You may not give this script/add-on away or distribute it an any way outside of a copy of
# AgoraCart without written permission from K-Factor Technologies, Inc.  K-Factor Technologies, Inc.
# reserves any and all rights to distributions, add-ons, and other works based on this
# piece of software as well as any and all rights to profit sharing and/or to charge for
# such works and/or derivatves.
#
##############################################################################
$versions{'PayPal-mgr_lib.pl'} = "5.0.001";
&add_codehook("gateway_admin_screen","PayPal_mgr_check");
&add_codehook("gateway_admin_settings","PayPal_settings");
$mc_gateways .= "|PayPal";
##############################################################################
sub PayPal_settings {
local($custom_logic);
if ($sc_gateway_name eq "PayPal") {

  $sc_paypal_top_message_temp = &my_escape($in{'sc_paypal_top_message'});
  $sc_paypal_shipping_message_temp = &my_escape($in{'sc_paypal_shipping_message'});
 	$use_custom_logic = &my_escape($in{'sc_use_custom_paypal_url_logic'});
  $custom_logic = &my_escape($in{'sc_custom_paypal_url_logic'});
  $sc_paypal_verify_message_temp = &my_escape($in{'sc_paypal_verify_message'});
  $sc_tos_display_address_temp = &my_escape($in{'sc_tos_display_address'});
  $sc_order_ok_tmp = &my_escape($in{'order_ok_final_msg_tbl'});

  open (GATEWAY, "> $gateway_settings") || 
 	&my_die("Can't Open $gateway_settings");
  print (GATEWAY  "\$sc_gateway_username = \'$in{'sc_gateway_username'}\';\n");
  print (GATEWAY  "\$sc_button_image_URL = \"$in{'button_URL'}\";\n");
  print (GATEWAY  "\$sc_paypal_change = \"$in{'sc_paypal_change'}\";\n");
  print (GATEWAY  "\$sc_order_script_url = \"$in{'order_url'}\";\n");
  print (GATEWAY  "\$sc_paypal_order_name = \'$in{'order_name'}\';\n");
  print (GATEWAY  "\$sc_paypal_order_number = \'$in{'order_number'}\';\n");
  print (GATEWAY  "\$sc_currency_id = \"$in{'sc_currency_id'}\";\n");
  print (GATEWAY  "\$sc_paypal_address_override = \'$in{'sc_paypal_address_override'}\';\n");
  print (GATEWAY  "\$sc_paypal_top_message = qq'$sc_paypal_top_message_temp';\n");
  print (GATEWAY  "\$sc_paypal_shipping_message = qq'$sc_paypal_shipping_message_temp';\n");
  print (GATEWAY  "\$sc_paypal_special_message = qq'$sc_paypal_special_message';\n");
  print (GATEWAY  "\$sc_use_custom_paypal_url_logic = qq'$use_custom_logic';\n");
  print (GATEWAY  "\$sc_custom_paypal_url_logic = qq`$custom_logic`;\n");
  print (GATEWAY  "\$sc_paypal_verify_message = qq'$sc_paypal_verify_message_temp';\n");
  print (GATEWAY  "\$sc_display_checkout_tos = \"$in{'sc_display_checkout_tos'}\";\n");
  print (GATEWAY  "\$sc_tos_display_address = qq'$sc_tos_display_address_temp';\n");
  print (GATEWAY  "\$order_ok_final_msg_tbl = qq'$sc_order_ok_tmp';\n");

  print (GATEWAY  "#\n1\;# We are a Library\n");
  close(GATEWAY);
 }
}
##############################################################################
sub PayPal_mgr_check {
if ($sc_gateway_name eq "PayPal") {
  &print_PayPal_mgr_form;
  &call_exit;
 }
}
##############################################################################
sub print_PayPal_mgr_form {
	
#
# PayPal Gateway
#

local ($my_paypal_order_name) = $sc_paypal_order_name;
local ($my_paypal_order_number) = $sc_paypal_order_number;

if ($sc_display_checkout_tos eq '') { # default it in
  $sc_display_checkout_tos = "yes";
 }

print &$manager_page_header("PayPal v2 Gateway","","","","");
print <<ENDOFTEXT;
<HTML>
<HEAD>
<TITLE>PayPal (Standard/Basic) Gateway Manager</TITLE>
</HEAD>
<BODY BGCOLOR=WHITE>
<FORM METHOD="POST" ACTION="manager.cgi">
<CENTER>
<TABLE WIDTH=95% CELLPADDING=0 CELLSPACING=0 BORDER=0>

<TR>
<TD><HR/></TD>
</TR>

<TR>
<TD WIDTH=95% align=center><br/>
<FONT FACE=ARIAL>
<b>PayPal (Standard/Basic) Settings</b>  This is a very basic PayPal payment method.  It will not confirm that payment is made, so you will need to access your paypal account to verify the payment is There. You can use the invoice numbers to confirm as that is passed to PayPal for comparison.  This method will pass over a total amount from the cart and the invoice number.  When the info is sent to PayPal, it sends you and the customer a confirmation email before payment is made, so make note of that as there could be some order confirmations sent but with no payment made should the customer fail to complete the process at PayPal.  NOTE: If you need to use PayPal Instant Payment Notification (IPN) or PayPal Pro, then you will need to upgrade to AgoraCart Pro 5.1.000 or above <small>(<a href="http://www.AgoraCart.org/proforum.htm" target="_blank">Click Here for more information on AgoraCart Pro</a>)</small><br/><br/>
$msg<br/><br/></FONT>
</TD>
</TR>
</TABLE>
</CENTER>

ENDOFTEXT

if($in{'system_edit_success'} ne "")
{
print <<ENDOFTEXT;
<CENTER>
<TABLE>
<TR>
<TD>
<FONT FACE=ARIAL SIZE=2 COLOR=RED>Gateway settings have been successfully
updated<br><br></FONT>
</TD>
</TR>
</TABLE>
</CENTER>
ENDOFTEXT
}

print <<ENDOFTEXT;

<FONT FACE=ARIAL SIZE=2><br>
<CENTER>
<TABLE BORDER=0 CELLPADDING=0 CELLSPACING=0 WIDTH=95% BORDER=0>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD WIDTH="55%">
Business Name as registered with PayPal (email address).
</TD>
<TD WIDTH="45%">
<INPUT NAME="sc_gateway_username" TYPE="TEXT" SIZE=30
VALUE='$sc_gateway_username'><br>
</TD>
</TR>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD COLSPAN=2><br>
Secure URL to your Gateway's server
</TD>
</TR>

<TR>
<TD COLSPAN=2>
<INPUT NAME="order_url" TYPE="TEXT" SIZE=70
VALUE="$sc_order_script_url"><br>
</TD>
</TR>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD COLSPAN=2><br>
The name you want for the order on the PayPal site:
</TD>
</TR>

<TR>
<TD COLSPAN=2>
<INPUT NAME="order_name" TYPE="TEXT" SIZE=70
VALUE="$my_paypal_order_name"><br>
</TD>
</TR>

<TR>
<TD COLSPAN=2><br>
The order number/identification you want to list/display at the PayPal site:
</TD>
</TR>

<TR>
<TD COLSPAN=2>
<INPUT NAME="order_number" TYPE="TEXT" SIZE=70
VALUE="$my_paypal_order_number"><br>
</TD>
</TR>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD COLSPAN=2><br>
URL to the button you'd like to display on your orderform.<br>
<small><B>Examples:</B><br>
<B>http://www.wherever.com/images/button.gif</B><br>
<B>%%URLofImages%%/paypal_button.gif</B></small></TD>
</TR>

<TR>
<TD COLSPAN=2>
<INPUT NAME="button_URL" TYPE="TEXT" SIZE=70
VALUE="$sc_button_image_URL"><br>
</TD>
</TR>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD COLSPAN=2><br>
URL of 'Make Changes' button:
<br>
<INPUT NAME="sc_paypal_change" TYPE="TEXT" SIZE=60 
VALUE='$sc_paypal_change'><br>
</TD>
</TR>

<TR>
<TD COLSPAN=2><br>Define the currency in which the monetary variables (amount, shipping, shipping2, handling, tax) are denoted.<br>
<SELECT NAME="sc_currency_id">
<OPTION>$sc_currency_id</OPTION>
<OPTION>USD</OPTION>
<OPTION>AUD</OPTION>
<OPTION>CAD</OPTION>
<OPTION>GBP</OPTION>
<OPTION>EUR</OPTION>
<OPTION>JPY</OPTION>
</SELECT>
</TD>
</TR>
<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD COLSPAN=2><br>
Select '1' to prevent the customer from selecting a different shipping address on the paypal site.<BR>
<SELECT NAME="sc_paypal_address_override">
<OPTION>$sc_paypal_address_override</OPTION>
<OPTION>1</OPTION>
<OPTION>0</OPTION>
</SELECT>
</TD>
</TR>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR><TD COLSPAN=2><br>
Top message for PayPal form.  Allows you to place a message above the Payment Information area and just below the cart total boxes.  HTML formatting (for text color, font, spacing, etc) is accepted.  Leave blank if not needed:<br>
<TEXTAREA NAME="sc_paypal_top_message" 
cols="68" rows=8 
wrap=off>$sc_paypal_top_message</TEXTAREA> <br><br>

<b>Misc area message.</b>  <small>Allows you to place a message immediately above the special messages box of the order form.  HTML formatting (text color, font, spacing, etc) is accepted.  Leave blank if not needed:</small><br>
<TEXTAREA NAME="sc_paypal_shipping_message" 
cols="68" rows=8 
wrap=off>$sc_paypal_shipping_message</TEXTAREA> <br><br>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD COLSPAN="2">
<b>Custom PayPal URL Logic:</b>
</TD>
</TR>

<TR>
<TD COLSPAN="2">
<table width="100%" cellpadding=0 cellspacing=0>
<tr>
<td>
Use the custom PayPal URL logic?  If yes, enter the custom
logic below and set this option to 'yes'.
</td>
<TD>
<SELECT NAME=sc_use_custom_paypal_url_logic>
<OPTION>$sc_use_custom_paypal_url_logic</OPTION>
<OPTION>yes</OPTION>
<OPTION>no</OPTION>
</SELECT>
</td></tr></table>
</TD>
</TR>

<TR>
<TD COLSPAN="2">
<TEXTAREA NAME="sc_custom_paypal_url_logic"
cols="68" rows=7 wrap=off>$sc_custom_paypal_url_logic</TEXTAREA>
</TD>
</TR>

<TR>
<TD COLSPAN=2><br><HR><br></TD>
</TR>

<TR>
<TD COLSPAN=2><TABLE WIDTH="100%"><TR>
<TD><b>Display Terms of Service and Refund Policy checkbox and set as required?</b></TD>
<TD>
<SELECT NAME="sc_display_checkout_tos">
<OPTION>$sc_display_checkout_tos</OPTION>
<OPTION>yes</OPTION>
<OPTION>no</OPTION>
</SELECT>
</TD>
</TR></TABLE></TD>
</TR>
<TR><TD COLSPAN=2><br>
<b>Business address and phone number (contact information) for your business.</b>  <small>Should be legal address for the business location for full disclosure and other privacy requirements mandated by credit card companies as well as government enitities that require such notices:</small><br>
<TEXTAREA NAME="sc_tos_display_address" 
cols="68" rows=5 
wrap=off>$sc_tos_display_address</TEXTAREA><br>

</TD>
</TR>

<TR><TD COLSPAN=2><br>
<b>Top message for confirmation page</b>, the page just before going to the gateway.  <small>This allows you to place a message above the Payment Information area and just below the cart total boxes.  HTML formatting (for text color, font, spacing, etc) is accepted.  Note: By default one exists, message 10 in the agora.setup.db file. Leave blank if not needed:</small><br>
<TEXTAREA NAME="order_ok_final_msg_tbl" 
cols="68" rows=8 
wrap=off>$order_ok_final_msg_tbl</TEXTAREA> <br><br>
</TD>
</TR>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD COLSPAN=2>
<CENTER>
<INPUT TYPE="HIDDEN" NAME="system_edit_success" VALUE="yes">
<INPUT TYPE="HIDDEN" NAME="gateway" VALUE="PayPal">
<INPUT NAME="GatewaySettings" TYPE="SUBMIT" VALUE="Submit">
&nbsp;&nbsp;
<INPUT TYPE="RESET" VALUE="Reset">
</CENTER>
</TD>
</TR>

<TR>
<TD COLSPAN=2>
<HR>
</TD>
</TR>

</TABLE>

</CENTER>
</FORM>

</BODY>
</HTML>

ENDOFTEXT
	
}
##############################################################################
1; #Library
