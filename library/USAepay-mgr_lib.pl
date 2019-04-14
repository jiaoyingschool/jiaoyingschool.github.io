#
# For the Credit Card Processing Gateway USAepay
#
# For more signup for USAepay or to become an USAepay authorized reseller
# Please visit USAepay.com for more details.
#
# Copyright May 7, 2005 to Present K-Factor Technologies, Inc.  & AgoraScript
# All Rights Reserved.

$versions{'USAepay-mgr_lib.pl'} = "5.0.000";
&add_codehook("gateway_admin_screen","USAepay_mgr_check");
&add_codehook("gateway_admin_settings","USAepay_settings");
$mc_gateways .= "|USAepay";
##############################################################################
sub USAepay_settings {
 local ($email_text);
 $email_text = &my_escape($in{'email_text'});
 if ($sc_gateway_name eq "USAepay") {
   open (GW,"> $gateway_settings") || &my_die("Can't Open $gateway_settings");
   print (GW "\$sc_gateway_userkey = \"$in{'sc_gateway_userkey'}\";\n");
   print (GW "\$sc_order_script_url = \"$in{'order_url'}\";\n");
   print (GW "\$merchant_live_mode = \"$in{'live_mode'}\";\n");
   print (GW "\$sc_USAepay_submit = '$in{'sc_USAepay_submit'}';\n");
   print (GW "\$sc_USAepay_change = '$in{'sc_USAepay_change'}';\n");
   print (GW "\$sc_USAepay_verify_message = \"" . 
         &my_escape($in{'sc_USAepay_verify_message'}) . "\";\n");
   print (GW "\$sc_USAepay_order_desc = \"" . 
         &my_escape($in{'sc_USAepay_order_desc'}) . "\";\n");
   print (GW "\$sc_display_checkout_tos = \"$in{'sc_display_checkout_tos'}\";\n");
   $sc_tos_display_address_temp = &my_escape($in{'sc_tos_display_address'});
   print (GW "\$sc_tos_display_address = qq'$sc_tos_display_address_temp';\n");
   print (GW "\$sc_USAepay_top_message = \"" . 
         &my_escape($in{'sc_USAepay_top_message'}) . "\";\n");
   print (GW "\$USAepay_order_ok_final_msg_tbl = \"" . 
         &my_escape($in{'USAepay_order_ok_final_msg_tbl'}) . "\";\n");

   print (GW "\$messages{'USAepay_declined'} = qq~" . 
         &my_escape($in{'USAepay_declined'}) . "~;\n");
   print (GW "\$messages{'USAepay_errror'} = qq~" . 
         &my_escape($in{'USAepay_errror'}) . "~;\n");

   print (GW "\$acceptvisa = \"$in{'acceptvisa'}\";\n");
   print (GW "\$acceptmastercard = \"$in{'acceptmastercard'}\";\n");
   print (GW "\$acceptdiscover = \"$in{'acceptdiscover'}\";\n");
   print (GW "\$acceptamex = \"$in{'acceptamex'}\";\n");
   print (GW "1\;\n");
   close(GW);
  }
 }
##############################################################################
sub USAepay_mgr_check {
if ($sc_gateway_name eq "USAepay") {
  &print_USAepay_mgr_form;
  &call_exit;
 }
}
##############################################################################
sub print_USAepay_mgr_form {
  
##
## USAepay
##

if ($sc_display_checkout_tos eq '') { # default it in
  $sc_display_checkout_tos = "yes";
 }

print &$manager_page_header("USAepay Gateway","","","","");

print <<ENDOFTEXT;
<CENTER>
<TABLE width=96%>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD COLSPAN="2">
<FONT FACE=ARIAL>
<b>USA ePay Settings</b><br>$msg<br><br>
<br>
Find out more about ths gateway at: <a href="http://www.USAepay.com/">
http://www.USAepay.com</a><br><br>
</FONT>

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
<FONT FACE=ARIAL SIZE=2 COLOR=RED>Gateway settings 
have been successfully updated</FONT>
</TD>
</TR>
</TABLE>
</CENTER>
ENDOFTEXT
}

print <<ENDOFTEXT;

<FONT FACE=ARIAL SIZE=2>
<FORM METHOD="POST" ACTION="manager.cgi">
<CENTER>
<TABLE BORDER=0 CELLPADDING=1 CELLSPACING=0 BORDER=0 width=96%>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD>Are you ready to go live?  (Answer "no" to run in test mode.)</TD>
<TD>
<SELECT NAME="live_mode">
<OPTION>$merchant_live_mode</OPTION>
<OPTION>yes</OPTION>
<OPTION>no</OPTION>
</SELECT>
</TD>
</TR>

</CENTER>
</TABLE>

<TABLE BORDER=0 CELLPADDING=1 CELLSPACING=0 BORDER=0 width=96%>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD WIDTH="200">
USA ePay Gateway Key
</TD>
<TD WIDTH="350">
<INPUT NAME="sc_gateway_userkey" TYPE="TEXT" SIZE=30 
VALUE='$sc_gateway_userkey'><br>
</TD>
</TR>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD COLSPAN=2>
Secure URL to your Gateway's server
</TD>
</TR>

<TR>
<TD COLSPAN=2>
<INPUT NAME="order_url" TYPE="TEXT" SIZE=60
VALUE="$sc_order_script_url"><br>
</TD>
</TR>

</TABLE><TABLE BORDER=0 CELLPADDING=1 CELLSPACING=0 BORDER=0>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD COLSPAN=2><table>
	<tr>
		<td><font size=2 face =arial>Accept Visa?<br><SELECT NAME="acceptvisa">
<OPTION>$acceptvisa</OPTION>
<OPTION VALUE="yes">yes</OPTION>
</SELECT></font></td>
		<td><font size=2 face =arial>Accept MasterCard?<br><SELECT NAME="acceptmastercard">
<OPTION>$acceptmastercard</OPTION>
<OPTION VALUE="yes">yes</OPTION>
</SELECT></font></td>
		<td><font size=2 face =arial>Accept AMEX?<br><SELECT NAME="acceptamex">
<OPTION>$acceptamex</OPTION>
<OPTION VALUE="yes">yes</OPTION>
<OPTION VALUE="no">no</OPTION>
</SELECT></font></td>
		<td><font size=2 face =arial>Accept Discover?<br><SELECT NAME="acceptdiscover">
<OPTION>$acceptdiscover</OPTION>
<OPTION VALUE="yes">yes</OPTION>
<OPTION VALUE="no">no</OPTION>
</SELECT></font></td>
	</tr>
</table></TD>
</TR>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD COLSPAN=2>
URL of 'Submit to USAepay' button:
<br>
<INPUT NAME="sc_USAepay_submit" TYPE="TEXT" SIZE=60 
VALUE='$sc_USAepay_submit'><br>
</TD>
</TR>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD COLSPAN=2>
URL of 'Make Changes' button:
<br>
<INPUT NAME="sc_USAepay_change" TYPE="TEXT" SIZE=60 
VALUE='$sc_USAepay_change'><br>
</TD>
</TR>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD COLSPAN=2>
Order Description:
<br>
<INPUT NAME="sc_USAepay_order_desc" TYPE="TEXT" SIZE=60 
VALUE='$sc_USAepay_order_desc'><br>
</TD>
</TR>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD COLSPAN=2>
Message at the top of the Verify Order table:
<br>
<TEXTAREA NAME="sc_USAepay_verify_message"
ROWS=4 COLS=65 wrap=soft>$sc_USAepay_verify_message</TEXTAREA>
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
<TD COLSPAN=2><HR></TD>
</TR>

<TR><TD COLSPAN=2>
Top message for Order form.  Allows you to place a message above the Payment Information area and just below the cart total boxes.  HTML formatting (for text color, font, spacing, etc) is accepted.  Leave blank if not needed:<br>
<TEXTAREA NAME="sc_USAepay_top_message" 
cols="68" rows=8 
wrap=off>$sc_USAepay_top_message</TEXTAREA> <br><br>
</TD>
</TR>

<TR><TD COLSPAN=2>
Top message for confirmation page, the page just before going to the gateway.  This allows you to place a message above the Payment Information area and just below the cart total boxes.  HTML formatting (for text color, font, spacing, etc) is accepted.  Leave blank if not needed:<br>
<TEXTAREA NAME="USAepay_order_ok_final_msg_tbl" 
cols="68" rows=8 
wrap=off>$USAepay_order_ok_final_msg_tbl</TEXTAREA> <br><br>
</TD>
</TR>

<TR><TD COLSPAN=2><br>
Message displayed on return to cart for declined payments (This is a message displayed as a replacement to the thank you message):<br>
<TEXTAREA NAME="USAepay_declined" 
cols="68" rows=6 
wrap=off>$messages{'USAepay_declined'}</TEXTAREA> <br><br>
</TD>
</TR>

<TR><TD COLSPAN=2><br>
Message displayed on return to cart for misc errors in payments (This is a message displayed as a replacement to the thank you message):<br>
<TEXTAREA NAME="USAepay_errror" 
cols="68" rows=6 
wrap=off>$messages{'USAepay_errror'}</TEXTAREA> <br><br>
</TD>
</TR>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD COLSPAN=2><br><br>
<CENTER>
<INPUT TYPE="HIDDEN" NAME="system_edit_success" VALUE="yes">
<INPUT TYPE="HIDDEN" NAME="gateway" VALUE="USAepay">
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
ENDOFTEXT
print &$manager_page_footer;

}
##############################################################################
1; #Library
