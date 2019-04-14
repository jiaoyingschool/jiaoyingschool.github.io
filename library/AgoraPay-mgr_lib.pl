#
# For the Credit Card Processing Gateway AgoraPay
#
# For more signup for AgoraPay or to become an AgoraPay authorized reseller
# Please visit AgoraPay.com for more details.
#
# Copyright K-Factor Technologies, Inc.  & AgoraScript
# All Rights Reserved.
# November 10, 2001 to Present

$versions{'AgoraPay-mgr_lib.pl'} = "5.2.000";
&add_codehook("gateway_admin_screen","AgoraPay_mgr_check");
&add_codehook("gateway_admin_settings","AgoraPay_settings");
$mc_gateways .= "|AgoraPay";
##############################################################################
sub AgoraPay_settings {
 local ($email_text);
 $email_text = &my_escape($in{'email_text'});
 if ($sc_gateway_name eq "AgoraPay") {
   open (GW,"> $gateway_settings") || &my_die("Can't Open $gateway_settings");
   print (GW "\$sc_gateway_username = \"$in{'sc_gateway_username'}\";\n");
   print (GW "\$sc_order_script_url = \"$in{'order_url'}\";\n");
   print (GW "\$mername = \"$in{'mername'}\";\n");
   print (GW "\$merchant_live_mode = \"$in{'live_mode'}\";\n");
   print (GW "\$sc_agorapay_submit = '$in{'sc_agorapay_submit'}';\n");
   print (GW "\$sc_agorapay_change = '$in{'sc_agorapay_change'}';\n");
   print (GW "\$sc_agorapay_verify_message = \"" . 
         &my_escape($in{'sc_agorapay_verify_message'}) . "\";\n");
   print (GW "\$sc_agorapay_order_desc = \"" . 
         &my_escape($in{'sc_agorapay_order_desc'}) . "\";\n");
   print (GW "\$sc_display_checkout_tos = \"$in{'sc_display_checkout_tos'}\";\n");
   $sc_tos_display_address_temp = &my_escape($in{'sc_tos_display_address'});
   print (GW "\$sc_tos_display_address = qq'$sc_tos_display_address_temp';\n");
   print (GW "\$sc_agorapay_top_message = \"" . 
         &my_escape($in{'sc_agorapay_top_message'}) . "\";\n");
   print (GW "\$AgoraPay_order_ok_final_msg_tbl = \"" . 
         &my_escape($in{'AgoraPay_order_ok_final_msg_tbl'}) . "\";\n");
   print (GW "\$AgoraPay_merch_message = \"" . 
         &my_escape($in{'AgoraPay_merch_message'}) . "\";\n");
   print (GW "\$AgoraPay_bodyback = \"" . 
         &my_escape($in{'AgoraPay_bodyback'}) . "\";\n");
   print (GW "\$AgoraPay_fontcolor = \"" . 
         &my_escape($in{'AgoraPay_fontcolor'}) . "\";\n");
   print (GW "\$AgoraPay_linkcolor = \"" . 
         &my_escape($in{'AgoraPay_linkcolor'}) . "\";\n");
   print (GW "\$AgoraPay_alinkcolor = \"" . 
         &my_escape($in{'AgoraPay_alinkcolor'}) . "\";\n");
   print (GW "\$AgoraPay_vlinkcolor = \"" . 
         &my_escape($in{'AgoraPay_vlinkcolor'}) . "\";\n");
   print (GW "\$AgoraPay_enablebodytags = \"$in{'AgoraPay_enablebodytags'}\";\n");
   print (GW "\$AgoraPay_Logo_URL = \"$in{'AgoraPay_Logo_URL'}\";\n");
   print (GW "\$AgoraPay_backimage_URL = \"$in{'AgoraPay_backimage_URL'}\";\n");
   print (GW "\$AgoraPay_disable_cards = \"$in{'AgoraPay_disable_cards'}\";\n");
   print (GW "\$AgoraPay_disable_checks = \"$in{'AgoraPay_disable_checks'}\";\n");
   print (GW "\$AgoraPay_disable_paypal = \"$in{'AgoraPay_disable_paypal'}\";\n");
   print (GW "\$acceptcards = \"$in{'acceptcards'}\";\n");
   print (GW "\$acceptchecks = \"$in{'acceptchecks'}\";\n");
   print (GW "\$accepteft = \"$in{'accepteft'}\";\n");
   print (GW "\$altaddr = \"$in{'altaddr'}\";\n");
   print (GW "\$email_text = \"$email_text\";\n");
   print (GW "#\n1\;\n");
   close(GW);
  }
 }
##############################################################################
sub AgoraPay_mgr_check {
if ($sc_gateway_name eq "AgoraPay") {
  &print_AgoraPay_mgr_form;
  &call_exit;
 }
}
##############################################################################
sub print_AgoraPay_mgr_form {
  
##
## AgoraPay
##

if ($sc_display_checkout_tos eq '') { # default it in
  $sc_display_checkout_tos = "yes";
 }

print &$manager_page_header("AgoraPay Gateway","","","","");

print <<ENDOFTEXT;
<CENTER>
<TABLE width=96%>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD COLSPAN="2">
<FONT FACE=ARIAL>
<b>AgoraPay Settings</b><br>$msg<br>

Find out more about ths gateway at: <a href="http://www.AgoraPay.com/">
http://www.AgoraPay.com</a><br><br>
<!--Don't forget that AgoraPay uses PGP signatures to validate
every transaction.  To take full advantage of this, you should
install PGP or RSA-enabled GPG on your server and set it up properly 
on the PGP/GPG page.  You will need to import the
AgoraPay public key as well, see the instructions at:<br><br>
&nbsp;&nbsp;&nbsp;&nbsp;
<a href="http://www.AgoraPay.com/support/pgp.html">
http://www.AgoraPay.com/support/pgp.html</a><br>-->
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
Gateway Username
</TD>
<TD WIDTH="350">
<INPUT NAME="sc_gateway_username" TYPE="TEXT" SIZE=30 
VALUE='$sc_gateway_username'><br>
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
<TD COLSPAN=2>
Enter the name of your business here.
</TD>
</TR>

<TR>
<TD COLSPAN=2>
<INPUT NAME="mername" TYPE="TEXT" SIZE=60 VALUE="$mername"><br>
</TD>
</TR>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD>
Are setup to accept credit cards through AgoraPay? 
Select '0' for no, '1' for yes.
</TD>
<TD>
<SELECT NAME="acceptcards">
<OPTION>$acceptcards</OPTION>
<OPTION VALUE="0">0</OPTION>
<OPTION VALUE="1">1</OPTION>
</SELECT>
</TD>
</TR>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD>
Are you setup to accept checks through AgoraPay?
Select '0' for no, '1' for yes
</TD>
<TD>
<SELECT NAME="acceptchecks">
<OPTION>$acceptchecks</OPTION>
<OPTION VALUE="0">0</OPTION>
<OPTION VALUE="1">1</OPTION>
</SELECT>
</TD>
</TR>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD>
Are you setup to accept EFT through AgoraPay?
Select '0' for no, '1' for yes.
</TD>
<TD>
<SELECT NAME="accepteft">
<OPTION>$accepteft</OPTION>
<OPTION VALUE="0">0</OPTION>
<OPTION VALUE="1">1</OPTION>
</SELECT>
</TD>
</TR>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD>
Disable Credit Cards at AgoraPay checkout for this store? 
Select '0' for no, '1' for yes.
</TD>
<TD>
<SELECT NAME="AgoraPay_disable_cards">
<OPTION>$AgoraPay_disable_cards</OPTION>
<OPTION VALUE="0">0</OPTION>
<OPTION VALUE="1">1</OPTION>
</SELECT>
</TD>
</TR>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD>
Disable Checks at AgoraPay checkout for this store? 
Select '0' for no, '1' for yes.
</TD>
<TD>
<SELECT NAME="AgoraPay_disable_checks">
<OPTION>$AgoraPay_disable_checks</OPTION>
<OPTION VALUE="0">0</OPTION>
<OPTION VALUE="1">1</OPTION>
</SELECT>
</TD>
</TR>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD>
Disable PayPal at AgoraPay checkout for this store?
Select '0' for no, '1' for yes.
</TD>
<TD>
<SELECT NAME="AgoraPay_disable_paypal">
<OPTION>$AgoraPay_disable_paypal</OPTION>
<OPTION VALUE="0">0</OPTION>
<OPTION VALUE="1">1</OPTION>
</SELECT>
</TD>
</TR>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD>
Do you want to allow customers to 
enter an alternate shipping address?
Select '0' for no, '1' for yes.
</TD>
<TD>
<SELECT NAME="altaddr">
<OPTION>$altaddr</OPTION>
<OPTION VALUE="0">0</OPTION>
<OPTION VALUE="1">1</OPTION>
</SELECT>
</TD>
</TR>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

</TABLE><TABLE BORDER=0 CELLPADDING=1 CELLSPACING=0 BORDER=0>


<TR>
<TD COLSPAN="2">
Enter the text that you'd like to appear
in the body of the confirmation e-mail
sent to the customer.
</TD>
</TR>
<TR>
<TD COLSPAN="2">
<TEXTAREA NAME="email_text" ROWS=6 COLS=60 
wrap=soft>$email_text</TEXTAREA>
</TD>
</TR>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD COLSPAN=2>
URL of 'Submit to AgoraPay' button:
<br>
<INPUT NAME="sc_agorapay_submit" TYPE="TEXT" SIZE=60 
VALUE='$sc_agorapay_submit'><br>
</TD>
</TR>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD COLSPAN=2>
URL of 'Make Changes' button:
<br>
<INPUT NAME="sc_agorapay_change" TYPE="TEXT" SIZE=60 
VALUE='$sc_agorapay_change'><br>
</TD>
</TR>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD COLSPAN=2>
Order Description:
<br>
<INPUT NAME="sc_agorapay_order_desc" TYPE="TEXT" SIZE=60 
VALUE='$sc_agorapay_order_desc'><br>
</TD>
</TR>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD COLSPAN=2>
Message at the top of the Verify Order table:
<br>
<TEXTAREA NAME="sc_agorapay_verify_message"
ROWS=4 COLS=65 wrap=soft>$sc_agorapay_verify_message</TEXTAREA>
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
<TEXTAREA NAME="sc_agorapay_top_message" 
cols="68" rows=8 
wrap=off>$sc_agorapay_top_message</TEXTAREA> <br><br>
</TD>
</TR>

<TR><TD COLSPAN=2>
Top message for confirmation page, the page just before going to the gateway.  This allows you to place a message above the Payment Information area and just below the cart total boxes.  HTML formatting (for text color, font, spacing, etc) is accepted.  Leave blank if not needed:<br>
<TEXTAREA NAME="AgoraPay_order_ok_final_msg_tbl" 
cols="68" rows=8 
wrap=off>$AgoraPay_order_ok_final_msg_tbl</TEXTAREA> <br><br>
</TD>
</TR>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD COLSPAN=2><font size=2 face =arial><br>
Complete URL to the logo you'd like to display on your payment information page at AgoraPay.
This <b>MUST</b> be a secure https URL. You can also leave this blank if you prefer.<br>
<INPUT NAME="AgoraPay_Logo_URL" TYPE="TEXT" SIZE=60 VALUE="$AgoraPay_Logo_URL"><br>
</font></TD>
</TR>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD COLSPAN=2><font size=2 face =arial><br>
Set and define the body tag attributes at the AgoraPay payment page?  Select Attributes below.  If not desired, set the enable body tags variable to "0" to disable all body tags.  Fields that you do not wish to use, leave blank or select 0.  Enter color names or RGB values (for example, enter either: red or #FF0000) for colors.
</font></TD>
</TR>

<TR>
<TD COLSPAN=2><table>
	<tr>
		<td><font size=2 face =arial>Enable Body Tags?<br><SELECT NAME="AgoraPay_enablebodytags">
<OPTION>$AgoraPay_enablebodytags</OPTION>
<OPTION VALUE="0">0</OPTION>
<OPTION VALUE="1">1</OPTION>
</SELECT></font></td>
		<td><font size=2 face =arial>Body Background Color:<br>
<INPUT NAME="AgoraPay_bodyback" TYPE="TEXT" SIZE=10 VALUE="$AgoraPay_bodyback">
</font></td>
		<td><font size=2 face =arial>Font Color:<br>
<INPUT NAME="AgoraPay_fontcolor" TYPE="TEXT" SIZE=10 VALUE="$AgoraPay_fontcolor">
</font></td>
		<td><font size=2 face =arial>Link Color:<br>
<INPUT NAME="AgoraPay_linkcolor" TYPE="TEXT" SIZE=10 VALUE="$AgoraPay_linkcolor">
</font></td>
		<td><font size=2 face =arial>aLink Color:<br>
<INPUT NAME="AgoraPay_alinkcolor" TYPE="TEXT" SIZE=10 VALUE="$AgoraPay_alinkcolor">
</font></td>
		<td><font size=2 face =arial>vLink Color:<br>
<INPUT NAME="AgoraPay_vlinkcolor" TYPE="TEXT" SIZE=10 VALUE="$AgoraPay_vlinkcolor">
</font></td>
</table>
<br>
<font size=2 face =arial><br>
Complete URL to the background image you'd like to display on your payment information page at AgoraPay.
This <b>MUST</b> be a secure https URL. You can also leave this blank if you prefer.  Body Tag attributes must be enabled above to use this featured<br>
<INPUT NAME="AgoraPay_backimage_URL" TYPE="TEXT" SIZE=60 VALUE="$AgoraPay_backimage_URL"><br>
</font>
</TD>
</TR>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD COLSPAN=2><font size=2 face =arial><br>
Enter a text message to be shown on the payment information page at AgoraPay.
This mesage will be shown in the text box immediately above the submit button. You can also leave this blank if you prefer.<br>
<TEXTAREA NAME="AgoraPay_merch_message" 
cols="68" rows=8 
wrap=off>$AgoraPay_merch_message</TEXTAREA><br>
</font></TD>
</TR>

<TR>
<TD COLSPAN=2><br><br>
<CENTER>
<INPUT TYPE="HIDDEN" NAME="system_edit_success" VALUE="yes">
<INPUT TYPE="HIDDEN" NAME="gateway" VALUE="AgoraPay">
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
