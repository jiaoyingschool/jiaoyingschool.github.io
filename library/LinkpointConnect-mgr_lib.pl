#
# For the CC and Check Processing Gateway Linkpoint Connect, included
# in the base package of agoracart, a GPL-ed program.
#
# Copyright 2000 to date K-Factor Technologies, Inc. 

$versions{'LinkpointConnect-mgr_lib.pl'} = "5.0.000";
&add_codehook("gateway_admin_screen","LinkpointConnect_mgr_check");
&add_codehook("gateway_admin_settings","LinkpointConnect_settings");
$mc_gateways .= "|LinkpointConnect";
##############################################################################
sub LinkpointConnect_settings {
local($custom_logic);
if ($sc_gateway_name eq "LinkpointConnect") {

 open (GATEWAY, "> $gateway_settings") || 
	&my_die("Can't Open $gateway_settings");
 print (GATEWAY  "\$sc_gateway_username = \'$in{'sc_gateway_username'}\';\n");
 print (GATEWAY  "\$sc_gateway_storename = \'$in{'sc_gateway_storename'}\';\n");
 print (GATEWAY  "\$sc_order_script_url = \"$in{'order_url'}\";\n");
 print (GATEWAY  "\$sc_linkpoint_auth_only = \"$in{'sc_linkpoint_auth_only'}\";\n");
 print (GATEWAY  "\$sc_linkpoint_submit = '$in{'sc_linkpoint_submit'}';\n");
 print (GATEWAY  "\$sc_linkpoint_change = '$in{'sc_linkpoint_change'}';\n");
 print (GATEWAY  "\$sc_linkpoint_verify_message = \"" . 
       &my_escape($in{'sc_linkpoint_verify_message'}) . "\";\n");
 print (GATEWAY  "\$sc_linkpoint_order_desc = \"" . 
       &my_escape($in{'sc_linkpoint_order_desc'}) . "\";\n");
  print (GATEWAY  "\$sc_display_checkout_tos = \"$in{'sc_display_checkout_tos'}\";\n");
$sc_tos_display_address_temp = &my_escape($in{'sc_tos_display_address'});
  print (GATEWAY  "\$sc_tos_display_address = qq'$sc_tos_display_address_temp';\n");
 print (GATEWAY  "\$sc_linkpoint_top_message = \"" . 
       &my_escape($in{'sc_linkpoint_top_message'}) . "\";\n");
 print (GATEWAY  "\$order_ok_final_msg_tbl = \"" . 
       &my_escape($in{'order_ok_final_msg_tbl'}) . "\";\n");

 print (GATEWAY  "#\n1\;\n");
 close(GATEWAY);
 }
}
##############################################################################
sub LinkpointConnect_mgr_check {
if ($sc_gateway_name eq "LinkpointConnect") {
  &print_LinkpointConnect_mgr_form;
  &call_exit;
 }
}
##############################################################################
sub print_LinkpointConnect_mgr_form {
	
#
# Linkpoint Connect Gateway
#

print &$manager_page_header("Linkpoint Gateway","","","","");

if ($sc_linkpoint_auth_only eq '') { # default value needed
     $sc_linkpoint_auth_only = "no";
}

print <<ENDOFTEXT;
<CENTER>
<TABLE WIDTH=580 CELLPADDING=0 CELLSPACING=0 BORDER=0>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD WIDTH=580>
<FONT FACE=ARIAL>
Linkpoint Connect Settings
$msg<br><br>
For more information on how to setup Linkpoint Connect, such as testing orders or logging into your linkpoint control panel, refer to the online manual at:<br><a href="http://www.agoracart.com/agorawiki/index.php?title=LinkPoint_Connect_-_the_basics">http://www.agoracart.com/agorawiki/index.php?title=LinkPoint_Connect_-_the_basics</a>
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
<FONT FACE=ARIAL SIZE=2 COLOR=RED>Gateway settings have been successfully
updated</FONT>
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
<TABLE BORDER=0 CELLPADDING=0 CELLSPACING=0 WIDTH=580 BORDER=0>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD WIDTH="55%">
User ID as registered with Linkpoint Connect.
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
<TD WIDTH="55%">
Store ID as registered with Linkpoint Connect.
</TD>
<TD WIDTH="45%">
<INPUT NAME="sc_gateway_storename" TYPE="TEXT" SIZE=30
VALUE='$sc_gateway_storename'><br>
</TD>
</TR>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD COLSPAN=2>
URL to the Linkpoint Connect server
</TD>
</TR>

<TR>
<TD COLSPAN=2>
<INPUT NAME="order_url" TYPE="TEXT" SIZE=70
VALUE="$sc_order_script_url"><br>
</TD>
</TR>

<TR>
<TD COLSPAN=2>
Send transactions as Pre-Authorize only?<br><small>set to no, unless you wish to manually approve each order at Linkpoint<small>
</TD>
</TR>

<TR>
<TD COLSPAN=2>
<SELECT NAME="sc_linkpoint_auth_only">
<OPTION>$sc_linkpoint_auth_only</OPTION>
<OPTION>yes</OPTION>
<OPTION>no</OPTION>
</SELECT><br>
</TD>
</TR>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD COLSPAN=2>
URL of 'Submit' button:
<br>
<INPUT NAME="sc_linkpoint_submit" TYPE="TEXT" SIZE=60 
VALUE='$sc_linkpoint_submit'><br>
</TD>
</TR>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD COLSPAN=2>
URL of 'Make Changes' button:
<br>
<INPUT NAME="sc_linkpoint_change" TYPE="TEXT" SIZE=60 
VALUE='$sc_linkpoint_change'><br>
</TD>
</TR>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD COLSPAN=2>
Order Description:
<br>
<INPUT NAME="sc_linkpoint_order_desc" TYPE="TEXT" SIZE=60 
VALUE='$sc_linkpoint_order_desc'><br>
</TD>
</TR>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD COLSPAN=2>
Message at the top of the Verify Order table:
<br>
<TEXTAREA NAME="sc_linkpoint_verify_message"
ROWS=4 COLS=65 wrap=soft>$sc_linkpoint_verify_message</TEXTAREA>
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
<TEXTAREA NAME="sc_linkpoint_top_message" 
cols="68" rows=8 
wrap=off>$sc_linkpoint_top_message</TEXTAREA> <br><br>
</TD>
</TR>

<TR><TD COLSPAN=2>
Top message for confirmation page, the page just before going to the gateway.  This allows you to place a message above the Payment Information area and just below the cart total boxes.  HTML formatting (for text color, font, spacing, etc) is accepted.  Note: By default one exists, message 10 in the agora.setup.db file. Leave blank if not needed:<br>
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
<INPUT TYPE="HIDDEN" NAME="gateway" VALUE="LinkpointConnect">
<INPUT NAME="GatewaySettings" TYPE="SUBMIT" VALUE="Submit">
&nbsp;&nbsp;
<INPUT TYPE="RESET" VALUE="Reset">
</CENTER>
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
