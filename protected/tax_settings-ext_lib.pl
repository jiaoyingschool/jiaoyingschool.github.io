# file ./store/protected/tax_settings-ext_lib.pl
#
# Shows how to add a choice to the main settings page on the agora 3.3j
# and higher manager.  If using on a 3.3 manager before rev j, you must
# first add the rev 3.3j shim to the custom directory to enable the 3.3j
# and higher 'ext' functions. These are extensions to the manager.
# Because the software is modularized upgrades are easier compared to
# doing a full upgrade.
#

$versions{'tax_settings-ext_lib.pl'} = "5.0.000";

{
 local ($modname) = 'freeform_logic';
 &register_extension($modname,"Tax Logic",$versions{$modname});
 &add_settings_choice("tax settings"," Tax Settings & Logic ",
  "tax_settings_screen");
 &register_menu('ChangeTaxSettings',"action_input_tax_settings",
  $modname,"Display Tax Logic");
 &register_menu('tax_settings_screen',"show_tax_settings_screen",
  $modname,"Write Tax Logic");
}
#############################################################################################
sub show_tax_settings_screen
{
print &$manager_page_header("Tax Settings","","","","");

if ($mc_tax_logic_rows < 3) {
  $mc_tax_logic_rows=3;
 }
if ($mc_tax_logic_rows >20) {
  $mc_tax_logic_rows=20;
 }
#set some defaults
if ($sc_debug_mode eq ""){
  $sc_debug_mode = "no";
 }

   $test_result = eval("use LWP::Simple; 1;");
   if ($@ eq "") {
#     use LWP::Simple;
    } else {
     $Lib_message="<FONT COLOR=RED><b>WARNING:</b> LWP library was " .
                  "not found!  Choose one of the other options.</FONT><BR>";
    }
#   $test_result = eval('require "./library/http-lib.pl"');
   if (!($http_lib_ok =~ /yes/i)) {
     $Lib_message .= "<FONT COLOR=RED>Couldn't load http-lib. " .   
                  "Choose one of the other options.</FONT><BR>";
    } 
   $test_result = eval('&get_lynx_path("0")');
   if ($test_result eq "") {
     $Lib_message .= "<FONT COLOR=RED>Lynx was not found. " .     
                  "Choose one of the other options.</FONT><BR>";
    } 

if ($sc_path_of_images_directory ne "") {
 $URL_of_images_directory = $sc_path_of_images_directory;
}

print <<ENDOFTEXT;
<CENTER>
<HR>
</CENTER>

<CENTER>
<TABLE>
<TR>
<TD>
<FONT FACE=ARIAL>Welcome to the <b>Agora.cgi</b> System Manager
Tax Settings. 
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
<FONT FACE=ARIAL SIZE=2 COLOR=RED>System settings have been 
successfully updated. </FONT>
</TD>
</TR>
</TABLE>
</CENTER>
ENDOFTEXT
}

&make_lists_of_various_options;

print <<ENDOFTEXT;

<FONT FACE=ARIAL SIZE=2>
<FORM METHOD="POST" ACTION="manager.cgi">
<CENTER>
<TABLE BORDER=0 CELLPADDING=1 CELLSPACING=0 BORDER=0>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD><FONT FACE=ARIAL SIZE=2>Customers shipping to the state selected here 
will be charged sales tax</font></TD>
<TD><FONT FACE=ARIAL SIZE=2>
<SELECT NAME=sales_tax_state>
<OPTION>$sc_sales_tax_state</OPTION>
<OPTION>None</OPTION> 
<OPTION>AL</OPTION> 
<OPTION>AK</OPTION> 
<OPTION>AZ</OPTION> 
<OPTION>AR</OPTION> 
<OPTION>CA</OPTION> 
<OPTION>CO</OPTION> 
<OPTION>CT</OPTION> 
<OPTION>DC</OPTION>
<OPTION>DE</OPTION> 
<OPTION>FL</OPTION> 
<OPTION>GA</OPTION> 
<OPTION>GU</OPTION> 
<OPTION>HI</OPTION> 
<OPTION>ID</OPTION> 
<OPTION>IL</OPTION> 
<OPTION>IN</OPTION> 
<OPTION>IA</OPTION> 
<OPTION>KS</OPTION> 
<OPTION>KY</OPTION> 
<OPTION>LA</OPTION> 
<OPTION>ME</OPTION> 
<OPTION>MD</OPTION> 
<OPTION>MA</OPTION> 
<OPTION>MI</OPTION> 
<OPTION>MN</OPTION> 
<OPTION>MS</OPTION> 
<OPTION>MO</OPTION> 
<OPTION>MT</OPTION> 
<OPTION>NE</OPTION> 
<OPTION>NV</OPTION> 
<OPTION>NH</OPTION> 
<OPTION>NJ</OPTION> 
<OPTION>NM</OPTION> 
<OPTION>NY</OPTION> 
<OPTION>NC</OPTION> 
<OPTION>ND</OPTION> 
<OPTION>OH</OPTION> 
<OPTION>OK</OPTION> 
<OPTION>OR</OPTION> 
<OPTION>PA</OPTION> 
<OPTION>PR</OPTION> 
<OPTION>RI</OPTION> 
<OPTION>SC</OPTION> 
<OPTION>SD</OPTION> 
<OPTION>TN</OPTION> 
<OPTION>TX</OPTION> 
<OPTION>UT</OPTION> 
<OPTION>VI</OPTION> 
<OPTION>VT</OPTION> 
<OPTION>VA</OPTION> 
<OPTION>WA</OPTION> 
<OPTION>WV</OPTION> 
<OPTION>WI</OPTION> 
<OPTION>WY</OPTION> 
</SELECT>
</font></TD>
</TR>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD><FONT FACE=ARIAL SIZE=2>Enter sales tax percentage here. Enter as a decimal number. <br>
Ex: "<b>.05</b>" for "5%", "<b>.06</b>" for "6%", etc.<br></font></TD>
<TD><FONT FACE=ARIAL SIZE=2><INPUT NAME="sales_tax" TYPE="TEXT" VALUE="$sc_sales_tax" 
SIZE="8" ></font></TD>
</TR>
<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<td><FONT FACE=ARIAL SIZE=2><b>Enable Non-Taxable Products?</b><br>This is an all or nothing setting, no variable tax rates are available at this time.</td>
<TD><FONT FACE=ARIAL SIZE=2>
<SELECT NAME=sc_non_taxables_enabled>
<OPTION>$sc_non_taxables_enabled</OPTION>
<OPTION>yes</OPTION> 
<OPTION>no</OPTION> 
</SELECT>
</font></TD>
</td>
</TR>
<TR>
<TD COLSPAN=2><BR></TD>
</TR>

<TR>
<td><FONT FACE=ARIAL SIZE=2><b>Which User field</b> in product database do you wish to use?<br><small>Enter "yes" (without the quotes) in the datafield of your choice within each product that you wish to designate as non-taxable.</small></td>
<TD><FONT FACE=ARIAL SIZE=2>
<SELECT NAME=sc_non_taxables_db_counter2>
<OPTION>$sc_non_taxables_db_counter2</OPTION>
<OPTION value="">None</OPTION>
<OPTION>User 2</OPTION> 
<OPTION>User 3</OPTION>
<OPTION>User 4</OPTION>
<OPTION>User 5</OPTION>
$user10_thingy
$user20_thingy
</SELECT>
</font></TD>
</td></tr>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>
<TR>
<TD><FONT FACE=ARIAL SIZE=2>Show how many rows of custom tax logic below?</TD>
<TD><FONT FACE=ARIAL SIZE=2><INPUT NAME="mc_tax_logic_rows" TYPE="TEXT" 
VALUE="$mc_tax_logic_rows" SIZE="5"></font></TD>
</TR>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR><TD COLSPAN=2><FONT FACE=ARIAL SIZE=2>
Use Extra Tax 1 Logic? <SELECT NAME='use_tax1_logic'>
<OPTION>$sc_use_tax1_logic</OPTION>
<OPTION>yes</OPTION> 
<OPTION>no</OPTION> 
</SELECT>
Display Name:<INPUT NAME='extra_tax1_name' MAXLENGTH=20 SIZE=20 
TYPE=TEXT value='$sc_extra_tax1_name'><br>
Extra Tax 1 Logic:<br>
<TEXTAREA NAME="sc_extra_tax1_logic" 
cols="68" rows=$mc_tax_logic_rows 
wrap=off>$sc_extra_tax1_logic</TEXTAREA> 
</font></TD></TR>

<TR><TD COLSPAN=2><FONT FACE=ARIAL SIZE=2>
Use Extra Tax 2 Logic? <SELECT NAME='use_tax2_logic'>
<OPTION>$sc_use_tax2_logic</OPTION>
<OPTION>yes</OPTION> 
<OPTION>no</OPTION> 
</SELECT>
Display Name:<INPUT NAME='extra_tax2_name' MAXLENGTH=20 SIZE=20 
TYPE=TEXT value='$sc_extra_tax2_name'><br>
Extra Tax 2 Logic:<br>
<TEXTAREA NAME="sc_extra_tax2_logic" 
cols="68" rows=$mc_tax_logic_rows 
wrap=off>$sc_extra_tax2_logic</TEXTAREA> 
</font></TD></TR>

<TR><TD COLSPAN=2><FONT FACE=ARIAL SIZE=2>
Use Extra Tax 3 Logic? <SELECT NAME='use_tax3_logic'>
<OPTION>$sc_use_tax3_logic</OPTION>
<OPTION>yes</OPTION> 
<OPTION>no</OPTION> 
</SELECT>
Display Name:<INPUT NAME='extra_tax3_name' MAXLENGTH=20 SIZE=20 
TYPE=TEXT value='$sc_extra_tax3_name'><br>
Extra Tax 3 Logic:<br>
<TEXTAREA NAME="sc_extra_tax3_logic" 
cols="68" rows=$mc_tax_logic_rows 
wrap=off>$sc_extra_tax3_logic</TEXTAREA> 
</font></TD></TR>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD COLSPAN=2>
<CENTER>
<INPUT TYPE="HIDDEN" NAME="system_edit_success" VALUE="yes">
<INPUT NAME="ChangeTaxSettings" TYPE="SUBMIT" VALUE="Submit">
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
#############################################################################################
sub action_input_tax_settings
{

local($admin_email, $order_email, $cookieDomain, $cookiePath);
local($other_program_settings)="";
my($myset,$temp_db_thingy)="";

&ReadParse;

$cookieDomain = $in{'sc_store_url'};
$cookiePath = $in{'sc_store_url'};

$cookieDomain =~ s/http.*:\/\///g;
$cookieDomain =~ s/\/.*//g;
$cookieDomain =~ s/\/agora.cgi//g;

$cookiePath =~ s/http.*:\/\/$cookieDomain//g;
$cookiePath =~ s/agora.cgi//g;
chop $cookiePath;

$order_email = $in{'email_address_for_orders'}; 
$order_email =~ s/\@/\\@/;

$admin_email = $in{'admin_email'};
$admin_email =~ s/\@/\\@/;


if ($in{'sc_non_taxables_db_counter2'} ne "") {
  $temp_db_thingy = $in{'sc_non_taxables_db_counter2'};
	if ($temp_db_thingy =~ /User 20/i) {
		$sc_non_taxables_db_counter = 26;
	} elsif ($temp_db_thingy =~ /User 10/i) {
		$sc_non_taxables_db_counter = 16;
	} elsif ($temp_db_thingy =~ /User 2/i) {
		$sc_non_taxables_db_counter = " 8";
	} elsif ($temp_db_thingy =~ /User 3/i) {
		$sc_non_taxables_db_counter = " 9";
	} elsif ($temp_db_thingy =~ /User 4/i) {
		$sc_non_taxables_db_counter = 10;
	} elsif ($temp_db_thingy =~ /User 5/i) {
	} else {
		$sc_non_taxables_db_counter = "";
	}
}

$myset = "";
$myset .= "\$sc_non_taxables_enabled = \"$in{'sc_non_taxables_enabled'}\";\n";
$myset .= "\$sc_non_taxables_db_counter = \"$sc_non_taxables_db_counter\";\n";
$myset .= "\$sc_non_taxables_db_counter2 = \"$in{'sc_non_taxables_db_counter2'}\";\n";
$myset .= "\$mc_tax_logic_rows = \"$in{'mc_tax_logic_rows'}\";\n";
$myset .= "\$sc_sales_tax = \"$in{'sales_tax'}\";\n";
$myset .= "\$sc_sales_tax_state = \"$in{'sales_tax_state'}\";\n";
$myset .= "\$sc_use_tax1_logic = \"$in{'use_tax1_logic'}\";\n";
$myset .= "\$sc_use_tax2_logic = \"$in{'use_tax2_logic'}\";\n";
$myset .= "\$sc_use_tax3_logic = \"$in{'use_tax3_logic'}\";\n";
$myset .= "\$sc_extra_tax1_name = \"$in{'extra_tax1_name'}\";\n";
$myset .= "\$sc_extra_tax2_name = \"$in{'extra_tax2_name'}\";\n";
$myset .= "\$sc_extra_tax3_name = \"$in{'extra_tax3_name'}\";\n";
$sc_extra_tax1_logic = &my_escape($in{'sc_extra_tax1_logic'});
$myset .= "\$sc_extra_tax1_logic = qq`$sc_extra_tax1_logic`;\n";
$sc_extra_tax2_logic = &my_escape($in{'sc_extra_tax2_logic'});
$myset .= "\$sc_extra_tax2_logic = qq`$sc_extra_tax2_logic`;\n";
$sc_extra_tax3_logic = &my_escape($in{'sc_extra_tax3_logic'});
$myset .= "\$sc_extra_tax3_logic = qq`$sc_extra_tax3_logic`;\n";

&update_store_settings('tax',$myset); # main settings
&show_tax_settings_screen;
}
#############################################################################################
1; # Library
