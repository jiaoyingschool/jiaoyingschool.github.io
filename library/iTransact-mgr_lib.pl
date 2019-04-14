#
# For the Credit Card Processing Gateway iTransact
#
# For more signup for iTransact or to become an iTransact authorized reseller
# Please visit iTransact.com for more details.
#
# Copyright K-Factor Technologies, Inc.  & AgoraScript
# All Rights Reserved.
# November 10, 2001 to Present

$versions{'iTransact-mgr_lib.pl'} = "5.2.000";
&add_codehook("gateway_admin_screen","iTransact_mgr_check");
&add_codehook("gateway_admin_settings","iTransact_settings");
$mc_gateways .= "|iTransact";
##############################################################################
sub iTransact_settings {
 local ($email_text);
 $email_text = &my_escape($in{'email_text'});
 if ($sc_gateway_name eq "iTransact") {
   open (GW,"> $gateway_settings") || &my_die("Can't Open $gateway_settings");
   print (GW "\$sc_gateway_username = \"$in{'sc_gateway_username'}\";\n");
   print (GW "\$sc_order_script_url = \"$in{'order_url'}\";\n");
   print (GW "\$mername = \"$in{'mername'}\";\n");
   print (GW "\$merchant_live_mode = \"$in{'live_mode'}\";\n");
   print (GW "\$sc_itransact_submit = '$in{'sc_itransact_submit'}';\n");
   print (GW "\$sc_itransact_change = '$in{'sc_itransact_change'}';\n");
   print (GW "\$sc_itransact_verify_message = \"" . 
         &my_escape($in{'sc_itransact_verify_message'}) . "\";\n");
   print (GW "\$sc_itransact_order_desc = \"" . 
         &my_escape($in{'sc_itransact_order_desc'}) . "\";\n");
   print (GW "\$sc_display_checkout_tos = \"$in{'sc_display_checkout_tos'}\";\n");
   $sc_tos_display_address_temp = &my_escape($in{'sc_tos_display_address'});
   print (GW "\$sc_tos_display_address = qq'$sc_tos_display_address_temp';\n");
   print (GW "\$sc_itransact_top_message = \"" . 
         &my_escape($in{'sc_itransact_top_message'}) . "\";\n");
   print (GW "\$iTransact_order_ok_final_msg_tbl = \"" . 
         &my_escape($in{'iTransact_order_ok_final_msg_tbl'}) . "\";\n");
   print (GW "\$iTransact_merch_message = \"" . 
         &my_escape($in{'iTransact_merch_message'}) . "\";\n");
   print (GW "\$iTransact_bodyback = \"" . 
         &my_escape($in{'iTransact_bodyback'}) . "\";\n");
   print (GW "\$iTransact_fontcolor = \"" . 
         &my_escape($in{'iTransact_fontcolor'}) . "\";\n");
   print (GW "\$iTransact_linkcolor = \"" . 
         &my_escape($in{'iTransact_linkcolor'}) . "\";\n");
   print (GW "\$iTransact_alinkcolor = \"" . 
         &my_escape($in{'iTransact_alinkcolor'}) . "\";\n");
   print (GW "\$iTransact_vlinkcolor = \"" . 
         &my_escape($in{'iTransact_vlinkcolor'}) . "\";\n");
   print (GW "\$iTransact_enablebodytags = \"$in{'iTransact_enablebodytags'}\";\n");
   print (GW "\$iTransact_Logo_URL = \"$in{'iTransact_Logo_URL'}\";\n");
   print (GW "\$iTransact_backimage_URL = \"$in{'iTransact_backimage_URL'}\";\n");
   print (GW "\$iTransact_disable_cards = \"$in{'iTransact_disable_cards'}\";\n");
   print (GW "\$iTransact_disable_checks = \"$in{'iTransact_disable_checks'}\";\n");
   print (GW "\$iTransact_disable_paypal = \"$in{'iTransact_disable_paypal'}\";\n");
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
sub iTransact_mgr_check {
if ($sc_gateway_name eq "iTransact") {
  &print_iTransact_mgr_form;
  &call_exit;
 }
}
##############################################################################
sub print_iTransact_mgr_form {
  
##
## iTransact
##

if ($sc_display_checkout_tos eq '') { # default it in
  $sc_display_checkout_tos = "yes";
 }

print &$manager_page_header("iTransact Gateway","","","","");

print <<ENDOFTEXT;
<CENTER>
<TABLE width=96%>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD COLSPAN="2">
<FONT FACE=ARIAL>
<b>iTransact Settings</b><br>$msg<br>

Find out more about ths gateway at: <a href="http://www.iTransact.com/">
http://www.iTransact.com</a><br><br>
<!--Don't forget that iTransact uses PGP signatures to validate
every transaction.  To take full advantage of this, you should
install PGP or RSA-enabled GPG on your server and set it up properly 
on the PGP/GPG page.  You will need to import the
iTransact public key as well, see the instructions at:<br><br>
&nbsp;&nbsp;&nbsp;&nbsp;
<a href="http://www.iTransact.com/support/pgp.html">
http://www.iTransact.com/support/pgp.html</a><br>-->
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
Are setup to accept credit cards through iTransact? 
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
Are you setup to accept checks through iTransact?
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
Are you setup to accept EFT through iTransact?
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
Disable Credit Cards at iTransact checkout for this store? 
Select '0' for no, '1' for yes.
</TD>
<TD>
<SELECT NAME="iTransact_disable_cards">
<OPTION>$iTransact_disable_cards</OPTION>
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
Disable Checks at iTransact checkout for this store? 
Select '0' for no, '1' for yes.
</TD>
<TD>
<SELECT NAME="iTransact_disable_checks">
<OPTION>$iTransact_disable_checks</OPTION>
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
Disable PayPal at iTransact checkout for this store?
Select '0' for no, '1' for yes.
</TD>
<TD>
<SELECT NAME="iTransact_disable_paypal">
<OPTION>$iTransact_disable_paypal</OPTION>
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
URL of 'Submit to iTransact' button:
<br>
<INPUT NAME="sc_itransact_submit" TYPE="TEXT" SIZE=60 
VALUE='$sc_itransact_submit'><br>
</TD>
</TR>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD COLSPAN=2>
URL of 'Make Changes' button:
<br>
<INPUT NAME="sc_itransact_change" TYPE="TEXT" SIZE=60 
VALUE='$sc_itransact_change'><br>
</TD>
</TR>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD COLSPAN=2>
Order Description:
<br>
<INPUT NAME="sc_itransact_order_desc" TYPE="TEXT" SIZE=60 
VALUE='$sc_itransact_order_desc'><br>
</TD>
</TR>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD COLSPAN=2>
Message at the top of the Verify Order table:
<br>
<TEXTAREA NAME="sc_itransact_verify_message"
ROWS=4 COLS=65 wrap=soft>$sc_itransact_verify_message</TEXTAREA>
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
<TEXTAREA NAME="sc_itransact_top_message" 
cols="68" rows=8 
wrap=off>$sc_itransact_top_message</TEXTAREA> <br><br>
</TD>
</TR>

<TR><TD COLSPAN=2>
Top message for confirmation page, the page just before going to the gateway.  This allows you to place a message above the Payment Information area and just below the cart total boxes.  HTML formatting (for text color, font, spacing, etc) is accepted.  Leave blank if not needed:<br>
<TEXTAREA NAME="iTransact_order_ok_final_msg_tbl" 
cols="68" rows=8 
wrap=off>$iTransact_order_ok_final_msg_tbl</TEXTAREA> <br><br>
</TD>
</TR>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD COLSPAN=2><font size=2 face =arial><br>
Complete URL to the logo you'd like to display on your payment information page at iTransact.
This <b>MUST</b> be a secure https URL. You can also leave this blank if you prefer.<br>
<INPUT NAME="iTransact_Logo_URL" TYPE="TEXT" SIZE=60 VALUE="$iTransact_Logo_URL"><br>
</font></TD>
</TR>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD COLSPAN=2><font size=2 face =arial><br>
Set and define the body tag attributes at the iTransact payment page?  Select Attributes below.  If not desired, set the enable body tags variable to "0" to disable all body tags.  Fields that you do not wish to use, leave blank or select 0.  Enter color names or RGB values (for example, enter either: red or #FF0000) for colors.
</font></TD>
</TR>

<TR>
<TD COLSPAN=2><table>
	<tr>
		<td><font size=2 face =arial>Enable Body Tags?<br><SELECT NAME="iTransact_enablebodytags">
<OPTION>$iTransact_enablebodytags</OPTION>
<OPTION VALUE="0">0</OPTION>
<OPTION VALUE="1">1</OPTION>
</SELECT></font></td>
		<td><font size=2 face =arial>Body Background Color:<br>
<INPUT NAME="iTransact_bodyback" TYPE="TEXT" SIZE=10 VALUE="$iTransact_bodyback">
</font></td>
		<td><font size=2 face =arial>Font Color:<br>
<INPUT NAME="iTransact_fontcolor" TYPE="TEXT" SIZE=10 VALUE="$iTransact_fontcolor">
</font></td>
		<td><font size=2 face =arial>Link Color:<br>
<INPUT NAME="iTransact_linkcolor" TYPE="TEXT" SIZE=10 VALUE="$iTransact_linkcolor">
</font></td>
		<td><font size=2 face =arial>aLink Color:<br>
<INPUT NAME="iTransact_alinkcolor" TYPE="TEXT" SIZE=10 VALUE="$iTransact_alinkcolor">
</font></td>
		<td><font size=2 face =arial>vLink Color:<br>
<INPUT NAME="iTransact_vlinkcolor" TYPE="TEXT" SIZE=10 VALUE="$iTransact_vlinkcolor">
</font></td>
</table>
<br>
<font size=2 face =arial><br>
Complete URL to the background image you'd like to display on your payment information page at iTransact.
This <b>MUST</b> be a secure https URL. You can also leave this blank if you prefer.  Body Tag attributes must be enabled above to use this featured<br>
<INPUT NAME="iTransact_backimage_URL" TYPE="TEXT" SIZE=60 VALUE="$iTransact_backimage_URL"><br>
</font>
</TD>
</TR>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD COLSPAN=2><font size=2 face =arial><br>
Enter a text message to be shown on the payment information page at iTransact.
This mesage will be shown in the text box immediately above the submit button. You can also leave this blank if you prefer.<br>
<TEXTAREA NAME="iTransact_merch_message" 
cols="68" rows=8 
wrap=off>$iTransact_merch_message</TEXTAREA><br>
</font></TD>
</TR>

<TR>
<TD COLSPAN=2><br><br>
<CENTER>
<INPUT TYPE="HIDDEN" NAME="system_edit_success" VALUE="yes">
<INPUT TYPE="HIDDEN" NAME="gateway" VALUE="iTransact">
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
