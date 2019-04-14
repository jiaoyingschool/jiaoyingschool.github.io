#
# For the 'Offline' CC and Check Processing Gateway
# Requires atleast 5.0.0 versions and above.
#
# Copyright 2000,2001 Steve Kneizys.
# Copyright 2002-present K-Factor Technologies, Inc.  All Rights Reserved.
$versions{'Offline-mgr_lib.pl'} = "5.0.000";
&add_codehook("gateway_admin_screen","Offline_mgr_check");
&add_codehook("gateway_admin_settings","Offline_settings");
$mc_gateways .= "|Offline";
##############################################################################
sub Offline_settings {
local($custom_logic);
if ($sc_gateway_name eq "Offline") {
  open (GATEWAY, "> $gateway_settings") || 
    &my_die("Can't Open $gateway_settings");
  print (GATEWAY  "\$sc_order_script_url = \"$in{'order_url'}\";\n");
  print (GATEWAY  "\$sc_Offline_CC_validation = \"$in{'CC_validation'}\";\n");
  print (GATEWAY  "\$sc_display_checkout_tos = \"$in{'sc_display_checkout_tos'}\";\n");
  print (GATEWAY  "\$sc_allow_pay_by_check = \"$in{'pay_by_check'}\";\n");
  print (GATEWAY  "\$sc_allow_pay_by_mailedcheck = \"$in{'pay_by_mailedcheck'}\";\n");
  print (GATEWAY  "\$sc_allow_pay_by_PO = \"$in{'pay_by_PO'}\";\n");
  print (GATEWAY  "\$sc_allow_pay_by_CC = \"$in{'pay_by_CC'}\";\n");
  print (GATEWAY  "\$sc_take_discover = \"$in{'sc_take_discover'}\";\n");
  print (GATEWAY  "\$sc_take_amex = \"$in{'sc_take_amex'}\";\n");
  print (GATEWAY  "\$sc_Offline_show_table = \"$in{'show_table'}\";\n");
$sc_tos_display_address_temp = &my_escape($in{'sc_tos_display_address'});
  print (GATEWAY  "\$sc_tos_display_address = qq'$sc_tos_display_address_temp';\n");
$sc_mailedfunds_address_temp = &my_escape($in{'sc_mailedfunds_address'});
  print (GATEWAY  "\$sc_mailedfunds_address = qq'$sc_mailedfunds_address_temp';\n");
$sc_offline_top_message_temp = &my_escape($in{'sc_offline_top_message'});
  print (GATEWAY  "\$sc_offline_top_message = qq'$sc_offline_top_message_temp';\n");
$sc_offline_shipping_message_temp = &my_escape($in{'sc_offline_shipping_message'});
  print (GATEWAY  "\$sc_offline_shipping_message = qq'$sc_offline_shipping_message_temp';\n");
$sc_offline_special_message_temp = &my_escape($in{'sc_offline_special_message'});
  print (GATEWAY  "\$sc_offline_special_message = qq'$sc_offline_special_message_temp';\n");
$sc_offline_verifypage_message_temp = &my_escape($in{'sc_offline_verifypage_message'});
  print (GATEWAY  "\$sc_offline_verifypage_message = qq'$sc_offline_verifypage_message_temp';\n");
  print (GATEWAY  "\$sc_Offline_mailedfunds_order_button = \"$in{'sc_Offline_mailedfunds_order_button'}\";\n");
  print (GATEWAY  "\$sc_offline_enable_cvv = \"$in{'sc_offline_enable_cvv'}\";\n");
  &codehook("manager_write_gateway_settings");
  &codehook("Offline_mgr_write_settings");
  print (GATEWAY  "1\;\n");
  close(GATEWAY);
 }
}
##############################################################################
sub Offline_mgr_check {
if ($sc_gateway_name eq "Offline") {
  &print_Offline_mgr_form;
  &call_exit;
 }
}
##############################################################################
sub print_Offline_mgr_form {

print &$manager_page_header("$sc_gateway_name Gateway","","","","");

print <<ENDOFTEXT;
<CENTER>
<TABLE WIDTH=580>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD WIDTH=580>
<FONT FACE=ARIAL>
Offline Processing
$msg</FONT>
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
<FONT FACE=ARIAL SIZE=2 COLOR=RED>Gateway settings have been successfully updated</FONT>
</TD>
</TR>
</TABLE>
</CENTER>
ENDOFTEXT
}

if ($sc_allow_pay_by_check eq '') { # default it in
  $sc_allow_pay_by_check = 'yes';
 }
if ($sc_allow_pay_by_check eq '') { # default it in
  $sc_allow_pay_by_mailedcheck = 'no';
 }
if ($sc_allow_pay_by_PO eq '') { # default it in
  $sc_allow_pay_by_PO = 'no';
 }
if ($sc_allow_pay_by_CC eq '') { # default it in
  $sc_allow_pay_by_CC = 'yes';
 }
if ($sc_Offline_show_table eq '') { # default it in
  $sc_Offline_show_table = 'yes';
 }
if ($sc_Offline_CC_validation eq '') { # default it in
  $sc_Offline_CC_validation = $sc_CC_validation;
 }
if ($sc_display_checkout_tos eq '') { # default it in
  $sc_display_checkout_tos = "yes";
 }
if ($sc_offline_verifypage_message eq '') { # default it in
  $sc_offline_verifypage_message = "$messages{'ordcnf_04'}";
 }
if ($sc_offline_enable_cvv eq '') { # do not show unless agreement to legals acknowledged
  $sc_offline_enable_cvv = "no";
 }

print <<ENDOFTEXT;

<FONT FACE=ARIAL SIZE=2>
<FORM METHOD="POST" ACTION="manager.cgi">
<CENTER>
<TABLE BORDER=0 CELLPADDING=1 CELLSPACING=0 WIDTH=580 BORDER=0>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD COLSPAN=2><TABLE WIDTH="100%"><TR>
<TD>Create a browser receipt after order completion?:</TD>
<TD>
<SELECT NAME="show_table">
<OPTION>$sc_Offline_show_table</OPTION>
<OPTION>yes</OPTION>
<OPTION>no</OPTION>
$mc_Offline_show_table_special_option
</SELECT>
</TD>
</TR></TABLE></TD>
</TR>

<TR>
<TD COLSPAN=2><HR><br></TD>
</TR>

<TR>
<TD COLSPAN=2><TABLE WIDTH="100%"><TR>
<TD>Allowed Payment Methods:<br>(<small>need aleast one selected)</small></TD>
<TD>
Credit Card:<br>
<SELECT NAME="pay_by_CC">
<OPTION>$sc_allow_pay_by_CC</OPTION>
<OPTION>yes</OPTION>
<OPTION>no</OPTION>
</SELECT>
</TD>
<TD>Check/Cheque:<br>
<SELECT NAME="pay_by_check">
<OPTION>$sc_allow_pay_by_check</OPTION>
<OPTION>yes</OPTION>
<OPTION>no</OPTION>
$mc_pay_by_check_special_option
</SELECT>
</TD>
<TD>
Mailed Check:<br>
<SELECT NAME="pay_by_mailedcheck">
<OPTION>$sc_allow_pay_by_mailedcheck</OPTION>
<OPTION>yes</OPTION>
<OPTION>no</OPTION>
$mc_pay_by_mailedcheck_special_option
</SELECT>
</TD>
<TD>Purchase Order:<BR>
<SELECT NAME="pay_by_PO">
<OPTION>$sc_allow_pay_by_PO</OPTION>
<OPTION>yes</OPTION>
<OPTION>no</OPTION>
$mc_pay_by_PO_special_option
</SELECT>
</TD>
</TR></TABLE></TD>
</TR>


<TR>
<TD COLSPAN=2><br><HR><br></TD>
</TR>

<TR>
<TD>Perform a rough validation of CC info?
Attempts to determine if the Credit Card number is a mathematically valid
number and has not expired. 
(Experimental)</TD>
<TD>
<SELECT NAME="CC_validation">
<OPTION>$sc_Offline_CC_validation</OPTION>
<OPTION>yes</OPTION>
<OPTION>no</OPTION>
</SELECT>
</TD>
</TR>

<TR>
<TD COLSPAN=2><br><HR><br></TD>
</TR>

<TR>
<TD>Visa and Master Cards are accepted by default.  Please indicate if you accept Discover and American Express</TD>
<TD><b>Discover:</b><br>
<SELECT NAME="sc_take_discover">
<OPTION>$sc_take_discover</OPTION>
<OPTION>yes</OPTION>
<OPTION>no</OPTION>
</SELECT><br><br>

<b>American Express:</b><br> 
<SELECT NAME="sc_take_amex">
<OPTION>$sc_take_amex</OPTION>
<OPTION>yes</OPTION>
<OPTION>no</OPTION>
</SELECT>
</TD>
</TR>

<TR>
<TD COLSPAN=2><HR><br></TD>
</TR>

<TR>
<TD COLSPAN=2>
Please enter the Secure URL to your AgoraCart store<br>(complete location including the agora.cgi file)<br>
<small>if you do not have SSL or shared SSL, enter the non-SSL URL to the store<br>(complete location to including agora.cgi file)</small>
</TD>
</TR>

<TR>
<TD COLSPAN=2><br>
<INPUT NAME="order_url" TYPE="TEXT" SIZE=60
VALUE="$sc_order_script_url"><br>
</TD>
</TR>

<TR>
<TD COLSPAN=2><br><HR><br></TD>
</TR>

<TR>
<TD COLSPAN=2><TABLE WIDTH="100%"><TR>
<TD>Display Terms of Service and Refund Policy checkbox and set as required?</TD>
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
Business address and phone number (contact information) for your business.  Should be legal address for the business location for full disclosure and other privacy requirements mandated by credit card companies as well as government enitities that require such notices:<br>
<TEXTAREA NAME="sc_tos_display_address" 
cols="68" rows=5 
wrap=off>$sc_tos_display_address</TEXTAREA><br>

</TD>
</TR>

<TR>
<TD COLSPAN=2><br><HR><br></TD>
</TR>

<TR><TD COLSPAN=2>
Mailing address message for Offline form.  Place the mailing address you would like checks/cheques, money orders, etc mailed to.  enter &lt;br> to start a new line.Leave blank if not needed:<br>
<TEXTAREA NAME="sc_mailedfunds_address" 
cols="68" rows=5 
wrap=off>$sc_mailedfunds_address</TEXTAREA><br><br><br>


Top message for Offline form.  Allows you to place a message above the Payment Information area and just below the cart total boxes.  HTML formatting (for text color, font, spacing, etc) is accepted.  Leave blank if not needed:<br>
<TEXTAREA NAME="sc_offline_top_message" 
cols="68" rows=8 
wrap=off>$sc_offline_top_message</TEXTAREA><br><br><br>

Shipping message for Offline form.  Allows you to place a message in the Shipping Information area of the Offline form.  HTML formatting (for text color, font, spacing, etc) is accepted.  Leave blank if not needed:<br>
<TEXTAREA NAME="sc_offline_shipping_message" 
cols="68" rows=8 
wrap=off>$sc_offline_shipping_message</TEXTAREA><br><br><br>

Message for Special Message area for Offline form.  Allows you to place a message just above the Special Message area of the Offline form.  HTML formatting (for text color, font, spacing, etc) is accepted.  Leave blank if not needed:<br>
<TEXTAREA NAME="sc_offline_special_message" 
cols="68" rows=8 
wrap=off>$sc_offline_special_message</TEXTAREA><br><br>
</TD></TR>

<TR>
<TD COLSPAN=2><HR><br></TD>
</TR>
<TR><TD COLSPAN=2>
Message for top of verify page for Offline step 2 checkout.  Allows you to place a message just above the information to verify on step 2 of the checkout process (after submitting the Offline form) - would also be located above the mailed funds address (if mailed funds option is used).  HTML formatting (for text color, font, spacing, etc) is accepted.  Leave blank if not needed:<br>
<TEXTAREA NAME="sc_offline_verifypage_message" 
cols="68" rows=8 
wrap=off>$sc_offline_verifypage_message</TEXTAREA><br><br>

</TD></TR>

<TR>
<TD>Show Submit Order Button if Mailed Funds is Selected for Payment?
<small>if customer elects to mail funds, do you wish to show the submit order button?</small></TD>
<TD>
<SELECT NAME="sc_Offline_mailedfunds_order_button">
<OPTION>$sc_Offline_mailedfunds_order_button</OPTION>
<OPTION>yes</OPTION>
<OPTION>no</OPTION>
</SELECT>
</TD>
</TR>
<TR>
<TD COLSPAN=2><br><HR><br></TD>
</TR>

<TR>
<TD COLSPAN=2><TABLE WIDTH="100%"><TR>
<TD><b>Enable CCV n Offline order for?</b> (default is no, and for very good reasons)<br><font color=red>WARNING:</font> Do not enable this unless you have good reason, or have an approved server that meets lawful security requirements (according to your credit card merchant account agreement and governing laws in your country).  It could be against the law and subject you to criminal and civil liabilities of an extreme magnitude including but not limited to jail time, full discloseure if data or server is compromised or might have been, payment of very high fines and legal fees, embarrassment, and distrust from the public.  By enabling this feature, you willingly agree to the following: that you, your company, and all concerned/affiliated agents, companies, customers, officers, et al hold AgoraCart and all affiliated divisions, agents, companies, officers, et al harmless from any and all legal action as well as protect the above from all other liabilities or punitive damages arising from your misuse of client data. Furthermore you, of your own freewill and desire, knowingly endanger your customers and their personal data, and furthermore you are also acknowledging the fact that you are purposely, and of your own freewill and desire, ignoring the outlined laws and proceedures set forth by credit card companies and the laws of the USA and all governing localities and municipalities (should you be subject to the laws of the US).</TD>
<TD>
<SELECT NAME="sc_offline_enable_cvv">
<OPTION>$sc_offline_enable_cvv</OPTION>
<OPTION>yes</OPTION>
<OPTION>no</OPTION>
</SELECT>
</TD>
</TR></TABLE></TD>
</TR>

<TR>
<TD COLSPAN=2><HR><br></TD>
</TR>

<TR>
<TD COLSPAN=2>
<TABLE WIDTH='100%' CELLPADDING=0 CELLSPACING=0>
<TR>
<TD ALIGN='LEFT' WIDTH='20%'>&nbsp;</TD>
<TD WIDTH='60%'>
<CENTER>
<INPUT TYPE="HIDDEN" NAME="system_edit_success" VALUE="yes">
<INPUT TYPE="HIDDEN" NAME="gateway" VALUE="Offline">
<INPUT NAME="GatewaySettings" TYPE="SUBMIT" VALUE="Submit">
&nbsp;&nbsp;
<INPUT TYPE="RESET" VALUE="Reset">
</CENTER>
</TD>
<TD ALIGN='LEFT' WIDTH='20%'>&nbsp;</TD>
</TR></TABLE>
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
ENDOFTEXT
print &$manager_page_footer;
	
}
##############################################################################
1; #Library
