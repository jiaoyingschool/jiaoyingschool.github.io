#
# For the Credit Card Processing Gateway AuthorizeNet
# SIM version
#
# Copyright 2001 Steve Kneizys.
# Copyright 2002 to Present K-Factor Technologies, Inc.  All Rights Reserved.
# March 6, 2003 SIM integration version
# discount mods applied June 17, 2005 by Eric Welin at K-Factor Technologies, Inc.
# April 2006 conversion to version 5 by Justin Findlay at K-Factor Technologies, Inc.
# May 3, 2006 Adjustments and misc edits for final v5 version by Mister Ed at K-Factor Technologies, Inc.
# May 5, 2006 final edits for final v5 version by Mister Ed at K-Factor Technologies, Inc.

$versions{'AuthorizeNet-mgr_lib.pl'} = "5.2.000";
&add_codehook("gateway_admin_screen","AuthorizeNet_mgr_check");
&add_codehook("gateway_admin_settings","AuthorizeNet_settings");
$mc_gateways .= "|AuthorizeNet";
$tstamptemp = time;
##############################################################################
sub AuthorizeNet_settings {
if ($sc_gateway_name eq "AuthorizeNet") {

  $x_description = &my_escape($in{'x_description'});
  $x_header_html_payment_form = &my_escape($in{'x_header_html_payment_form'});
  $x_footer_html_payment_form = &my_escape($in{'x_footer_html_payment_form'});
  $x_header_html_receipt = &my_escape($in{'x_header_html_receipt'});
  $x_footer_html_receipt = &my_escape($in{'x_footer_html_receipt'});
  $x_header_email_receipt = &my_escape($in{'x_header_email_receipt'});
  $x_footer_email_receipt = &my_escape($in{'x_footer_email_receipt'});
  $sc_auth_verify_message = &my_escape($in{'sc_auth_verify_message'});
  $sc_auth_order_desc = &my_escape($in{'sc_auth_order_desc'});
  $sc_tos_display_address = &my_escape($in{'sc_tos_display_address'});

  open (GW, "> $gateway_settings") || &my_die("Can't Open $gateway_settings");
  print (GW "\$sc_gateway_username = '$in{'sc_gateway_username'}';\n");
  print (GW "\$txnkey = \"$in{'txnkey'}\";\n");
  print (GW "\$sc_tstamp2 = \"$in{'sc_tstamp2'}\";\n");
  print (GW "\$sc_tstamp3 = \"$in{'sc_tstamp3'}\";\n");
  print (GW "\$sc_order_script_url = \"$in{'order_url'}\";\n");
  print (GW "\$x_logo_url = \"$in{'x_logo_url'}\";\n");
  print (GW "\$x_color_background = \"$in{'x_color_background'}\";\n");
  print (GW "\$x_color_link = \"$in{'x_color_link'}\";\n");
  print (GW "\$x_color_text = \"$in{'x_color_text'}\";\n");
  print (GW "\$x_description = \"$x_description\";\n");
  print (GW "\$x_header_html_payment_form = \"$x_header_html_payment_form\";\n");
  print (GW "\$x_footer_html_payment_form = \"$x_footer_html_payment_form\";\n");
  print (GW "\$x_header_html_receipt = \"$x_header_html_receipt\";\n");
  print (GW "\$x_footer_html_receipt = \"$x_footer_html_receipt\";\n");
  print (GW "\$x_header_email_receipt = \"$x_header_email_receipt\";\n");
  print (GW "\$x_footer_email_receipt = \"$x_footer_email_receipt\";\n");
  print (GW "\$merchant_live_mode = \"$in{'live_mode'}\";\n");
  print (GW  "\$sc_auth_submit = '$in{'sc_auth_submit'}';\n");
  print (GW  "\$sc_auth_change = '$in{'sc_auth_change'}';\n");
  print (GW  "\$sc_auth_verify_message = \"$sc_auth_verify_message\";\n");
  print (GW  "\$sc_auth_order_desc = \"$sc_auth_order_desc\";\n");
  print (GW  "\$sc_display_checkout_tos = \"$in{'sc_display_checkout_tos'}\";\n");
  print (GW  "\$sc_tos_display_address = qq'$sc_tos_display_address';\n");
  print (GW  "\$sc_authnet_sale_mode = '$in{'sc_authnet_sale_mode'}';\n");
 
  print (GW  "#\n1\;\n");
  close(GW);

 }
}
##############################################################################
sub AuthorizeNet_mgr_check {
if ($sc_gateway_name eq "AuthorizeNet") {
  &print_AuthorizeNet_mgr_form;
  &call_exit;
 }
}
##############################################################################
sub print_AuthorizeNet_mgr_form {
  
##
## AUTHORIZE.NET
##

print &$manager_page_header("AuthorizeNet Gateway","","","","");

print <<ENDOFTEXT;
<CENTER>
<TABLE>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD>
<FONT FACE=ARIAL>
<b>AuthorizeNet Settings</b><br>
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

print <<ENDOFTEXT;

<FONT FACE=ARIAL SIZE=2>
<FORM METHOD="POST" ACTION="manager.cgi">
<CENTER>
<TABLE BORDER=0 CELLPADDING=1 CELLSPACING=0 BORDER=0>

<TR>
<TD width=80%>
Are you ready to go live?  (Answer "no" to run in 
test mode.)</TD>
<TD>
<SELECT NAME="live_mode">
<OPTION>$merchant_live_mode</OPTION>
<OPTION>yes</OPTION>
<OPTION>no</OPTION>
</SELECT>
</TD>
</TR>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

</table><TABLE BORDER=0 CELLPADDING=1 CELLSPACING=0 BORDER=0>

<TR>
<TD width="80%">
<b>API Loin ID</b></td>
<TD width="20%">
<INPUT NAME="sc_gateway_username" TYPE="TEXT" SIZE=30 
VALUE='$sc_gateway_username'><br>
</TD>
</TR>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD width="80%">
<b>Transaction Key</b><br>
To get the actual 'Transaction Key' value for above go into your control panel at Authorize.net<br><br>
1) Click on settings<br>
2) Click on 'Obtain Transaction Key' under the security section.<br>
3) Enter your 'Secret Answer' and click Submit. Your secret answer should be what you used when you first set up your account.<br><br>

NOTE: Someone reported that after you generate/change the Transaction Key it may take about a half hour for this to become active.... if you experience problems at first you may want to wait a while to make sure that this is not the problem.<br><br>

</td>
<TD width="20%">
<INPUT NAME="txnkey" TYPE="TEXT" SIZE=30 
VALUE='$txnkey'><br>
</TD>
</TR>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD width="80%">
<b>Time Stamp</b><br>
if you get error 97 you may have to change your timestamp to match Authorize.net's clock, to do that Go to http://www.sluggis.com/fptest.htm , use the time to the left, it will tell you how many seconds you are off by.<br><br>Do this immediately or reload this page for an acurrate number.<br><br> If you are within say 5-10 minutes either way, don't worry about adjusting the time stamp..
</td>
<TD width="20%">
Actual <INPUT NAME="tstamptemp" TYPE="TEXT" SIZE=20 
VALUE='$tstamptemp'><br><br>
Adjust up or down
<SELECT NAME="sc_tstamp3">
<OPTION>$sc_tstamp3</OPTION>
<OPTION>add</OPTION>
<OPTION>subtract</OPTION>
</SELECT><br><br>
How many seconds:<br>
<INPUT NAME="sc_tstamp2" TYPE="TEXT" SIZE=20 
VALUE='$sc_tstamp2'><br>
</TD>
</TR>

</table><TABLE BORDER=0 CELLPADDING=1 CELLSPACING=0 BORDER=0>

<TR>
<TD COLSPAN=2><br>
Secure URL to your Gateway's server
</TD>
</TR>

<TR>
<TD COLSPAN=2>
<INPUT NAME="order_url" TYPE="TEXT" SIZE=60 
VALUE="$sc_order_script_url"><br>
</TD>
</TR>

<TD width=80%><br>
Sales Mode: <small>(Authorize Only or Normal Sales. Normal Sales is the default)</small> </TD>
<TD>
<SELECT NAME="sc_authnet_sale_mode">
<OPTION>$sc_authnet_sale_mode</OPTION>
<OPTION>Normal</OPTION>
<OPTION>Authorize Only</OPTION>
</SELECT>
</TD>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD COLSPAN=2>
Complete URL to the logo you'd like to display on your orderform.
This <b>MUST</b> be a secure https URL. You can also leave this 
blank if you prefer.
</TD>
</TR>

<TR>
<TD COLSPAN=2>
<INPUT NAME="x_logo_url" TYPE="TEXT" SIZE=60 VALUE="$x_logo_url"><br>
</TD>
</TR>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

</table><TABLE BORDER=0 CELLPADDING=1 CELLSPACING=0 BORDER=0>

<TR>
<TD width="80%">
Background color of your orderform.
</TD>
<TD width="20%">
<SELECT NAME="x_color_background">
<OPTION>$x_color_background</OPTION>
<OPTION VALUE="#00FFFF">AQUA</OPTION>
<OPTION VALUE="#000000">BLACK</OPTION>
<OPTION VALUE="#0000FF">BLUE</OPTION>
<OPTION VALUE="#FF00FF">FUCHSIA</OPTION>
<OPTION VALUE="#808080">GRAY</OPTION>
<OPTION VALUE="#008000">GREEN</OPTION>
<OPTION VALUE="#00FF00">LIME</OPTION>
<OPTION VALUE="#800000">MAROON</OPTION>
<OPTION VALUE="#000080">NAVY</OPTION>
<OPTION VALUE="#808000">OLIVE</OPTION>
<OPTION VALUE="#800080">PURPLE</OPTION>
<OPTION VALUE="#FF0000">RED</OPTION>
<OPTION VALUE="#C0C0C0">SILVER</OPTION>
<OPTION VALUE="#008080">TEAL</OPTION>
<OPTION VALUE="#FFFFFF">WHITE</OPTION>
<OPTION VALUE="#FFFF00">YELLOW</OPTION>
</SELECT>
</TD>
</TR>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD>
Text Color
</TD>
<TD>
<SELECT NAME="x_color_text">
<OPTION>$x_color_text</OPTION>
<OPTION VALUE="#00FFFF">AQUA</OPTION>
<OPTION VALUE="#000000">BLACK</OPTION>
<OPTION VALUE="#0000FF">BLUE</OPTION>
<OPTION VALUE="#FF00FF">FUCHSIA</OPTION>
<OPTION VALUE="#808080">GRAY</OPTION>
<OPTION VALUE="#008000">GREEN</OPTION>
<OPTION VALUE="#00FF00">LIME</OPTION>
<OPTION VALUE="#800000">MAROON</OPTION>
<OPTION VALUE="#000080">NAVY</OPTION>
<OPTION VALUE="#808000">OLIVE</OPTION>
<OPTION VALUE="#800080">PURPLE</OPTION>
<OPTION VALUE="#FF0000">RED</OPTION>
<OPTION VALUE="#C0C0C0">SILVER</OPTION>
<OPTION VALUE="#008080">TEAL</OPTION>
<OPTION VALUE="#FFFFFF">WHITE</OPTION>
<OPTION VALUE="#FFFF00">YELLOW</OPTION>
</SELECT>
</TD>
</TR>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD>
Link Color
</TD>
<TD>
<SELECT NAME="x_color_link">
<OPTION>$x_color_link</OPTION>
<OPTION VALUE="#00FFFF">AQUA</OPTION>
<OPTION VALUE="#000000">BLACK</OPTION>
<OPTION VALUE="#0000FF">BLUE</OPTION>
<OPTION VALUE="#FF00FF">FUCHSIA</OPTION>
<OPTION VALUE="#808080">GRAY</OPTION>
<OPTION VALUE="#008000">GREEN</OPTION>
<OPTION VALUE="#00FF00">LIME</OPTION>
<OPTION VALUE="#800000">MAROON</OPTION>
<OPTION VALUE="#000080">NAVY</OPTION>
<OPTION VALUE="#808000">OLIVE</OPTION>
<OPTION VALUE="#800080">PURPLE</OPTION>
<OPTION VALUE="#FF0000">RED</OPTION>
<OPTION VALUE="#C0C0C0">SILVER</OPTION>
<OPTION VALUE="#008080">TEAL</OPTION>
<OPTION VALUE="#FFFFFF">WHITE</OPTION>
<OPTION VALUE="#FFFF00">YELLOW</OPTION>
</SELECT>
</TD>
</TR>

</table><TABLE BORDER=0 CELLPADDING=1 CELLSPACING=0 BORDER=0>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD COLSPAN=2>
What description do you want to use for the order? (no longer used in SIM)
</TD>
</TR>

<TR>
<TD COLSPAN=2>
<INPUT NAME="x_description" TYPE="TEXT" SIZE=60 
VALUE="$x_description"><br>
</TD>
</TR>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD COLSPAN=2>
URL of 'Submit to Authorize.net' button:
<br>
<INPUT NAME="sc_auth_submit" TYPE="TEXT" SIZE=60 
VALUE='$sc_auth_submit'><br>
</TD>
</TR>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD COLSPAN=2>
URL of 'Make Changes' button:
<br>
<INPUT NAME="sc_auth_change" TYPE="TEXT" SIZE=60 
VALUE='$sc_auth_change'><br>
</TD>
</TR>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD COLSPAN=2>
Order Description:
<br>
<INPUT NAME="sc_auth_order_desc" TYPE="TEXT" SIZE=60 
VALUE='$sc_auth_order_desc'><br>
</TD>
</TR>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD COLSPAN=2>
Message at the top of the Verify Order table:
<br>
<TEXTAREA NAME="sc_auth_verify_message"
ROWS=4 COLS=65 wrap=soft>$sc_auth_verify_message</TEXTAREA>
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

</table><TABLE BORDER=0 CELLPADDING=1 CELLSPACING=0 BORDER=0>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD COLSPAN="2">
Enter the text that you'd like displayed at the <b>top
of your orderform</b>.
</TD>
</TR>
<TR>
<TD COLSPAN="2">
<TEXTAREA NAME="x_header_html_payment_form" ROWS=6 COLS=60 
wrap=soft>$x_header_html_payment_form</TEXTAREA>
</TD>
</TR>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD COLSPAN="2">
Enter the text that you'd like displayed at the <b>bottom
of your orderform</b>.
</TD>
</TR>
<TR>
<TD COLSPAN="2">
<TEXTAREA NAME="x_footer_html_payment_form" ROWS=6 COLS=60 
wrap=soft>$x_footer_html_payment_form</TEXTAREA>
</TD>
</TR>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD COLSPAN="2">
Enter the text that you'd like displayed at the <b>top
of your receipt page</b>.
</TD>
</TR>
<TR>
<TD COLSPAN="2">
<TEXTAREA NAME="x_header_html_receipt" ROWS=6 COLS=60 
wrap=soft>$x_header_html_receipt</TEXTAREA>
</TD>
</TR>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD COLSPAN="2">
Enter the text that you'd like displayed at the <b>bottom
of your receipt page</b>.
</TD>
</TR>
<TR>
<TD COLSPAN="2">
<TEXTAREA NAME="x_footer_html_receipt" ROWS=6 COLS=60 
wrap=soft>$x_footer_html_receipt</TEXTAREA>
</TD>
</TR>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD COLSPAN="2">
Enter the text that you'd like displayed at the <b>top
of your customer's e-mail receipt</b>.
</TD>
</TR>
<TR>
<TD COLSPAN="2">
<TEXTAREA NAME="x_header_email_receipt" ROWS=6 COLS=60 
wrap=soft>$x_header_email_receipt</TEXTAREA>
</TD>
</TR>

<TR>
<TD COLSPAN="2">
Enter the text that you'd like displayed at the <b>bottom
of your customer's e-mail receipt</b>.
</TD>
</TR>
<TR>
<TD COLSPAN="2">
<TEXTAREA NAME="x_footer_email_receipt" ROWS=6 COLS=60 
wrap=soft>$x_footer_email_receipt</TEXTAREA>
</TD>
</TR>

<TR>
<TD COLSPAN=2>
<CENTER>
<INPUT TYPE="HIDDEN" NAME="system_edit_success" VALUE="yes">
<INPUT TYPE="HIDDEN" NAME="gateway" VALUE="AuthorizeNet">
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
