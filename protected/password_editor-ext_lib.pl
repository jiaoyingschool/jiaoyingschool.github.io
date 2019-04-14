# file ./store/protected/password_editor-ext_lib.pl
#########################################################################
#
# Copyright (c) 2002 to Date K-Factor Technologies, Inc.
# http://www.k-factor.net/  and  http://www.AgoraCart.com/
# All Rights Reserved.
#
# Use with permission only with AgoraCart, AgoraCartPro, AgoraSQL, AgoraCartSQL, 
# or AgoraSuite
#
# This software is a separate add-on to an ecommerce shopping cart and 
# is the confidential and proprietary information of K-Factor Technologies, Inc.  You shall
# not disclose such Confidential Information and shall use it only in
# conjunction with the AgoraCart (aka agora.cgi) shopping cart.
#
# Requires AgoraCart version 5.0.0 or above.  Just place this file in the protected directory.
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
# You may not give this script/add-on away or distribute it an any way without
# written permission from K-Factor Technologies, Inc.  K-Factor Technologies, Inc.
# reserves any and all rights to distributions, add-ons, and other works based on this
# piece of software as well as any and all rights to profit sharing and/or to charge for
# such works and/or derivatves.
#
# Hosting Companies and other software integrators are encouraged to integrate additional
# features and add-ons in their AgoraCart offerings, but must receive written permission from from
# K-Factor Technologies, Inc. in order to distribute this add-on to AgoraCart (aka Agora.cgi).
#
##########################################################################
$versions{'password_editor-ext_lib.pl'} = "5.0.000";
$sc_mgrpassfile="$mgrdir/misc/mgr_pass.pl";
{
 local ($modname) = 'password_editor';
 &register_extension($modname,"Password Manager",$versions{$modname});
 &add_settings_choice("Password Settings"," Password Settings ",
  "change_Pass_screen");
 &register_menu('PasswordSettings',"write_Pass_settings",
  $modname,"Write Password Settings");
 &register_menu('change_Pass_screen',"display_Pass_screen",
  $modname,"Display Password Manager");
}
#######################################################################################
sub write_Pass_settings {
local($myset)="";
&ReadParse;
$myset .= "\$username = \"$in{'username'}\";\n";
$myset .= "\$password = \"$in{'password'}\";\n";
$myset .= "\$mc_use_cookie_login = \"$in{'mc_use_cookie_login'}\";\n";
$myset .= "\$a_unique_name = \"$in{'a_unique_name'}\";\n";
$username = "$in{'username'}";
$password = "$in{'password'}";
$mc_use_cookie_login = "$in{'mc_use_cookie_login'}";
$a_unique_name = "$in{'a_unique_name'}";
&update_Pass_settings('$sc_mgrpassfile',$myset);
&log_out;
  &display_Pass_screen;
 }
################################################################################
sub display_Pass_screen
{
local($filename)="$mgrdir/";
print &$manager_page_header("Password Editor","","","","");
print <<ENDOFTEXT;
<CENTER>
<HR>
</CENTER>

<FORM ACTION="manager.cgi" METHOD="POST">
<CENTER>
<TABLE>
<TR>
<TD>
<FONT FACE=ARIAL size=2>Welcome to the <b>AgoraCart</b>  Store Manager Basic Password Editor.  This area allows you to edit the login information and passwords for your store manager files.  .htaccess protection is still handled separately.  If you wish to and more login users and also allow or turnoff certain management functions for each user, please purchase the multi-manager login add-on found in the AgoraCart.com store.<br><br><center><font color=red>You will be logged out automatically when you save these settings</font></center></TD>
</TR>
</TABLE>
</CENTER>

ENDOFTEXT

if($in{'system_edit_success'} ne "")
{
print <<ENDOFTEXT;
<CENTER><br>
<TABLE>
<TR>
<TD>
<FONT FACE=ARIAL SIZE=2 COLOR=RED>Password File has been 
successfully updated. </FONT>
</TD>
</TR>
</TABLE>
</CENTER>
ENDOFTEXT
}

print qq~
<br>
<FORM ACTION="manager.cgi" METHOD="POST">
   <div align="center">
   <table border="0" cellspacing="0">
<TR>
<TD><font face=arial size=2>
Select a user name.  12 characters max.&nbsp;&nbsp;</font>

</TD><TD><font face=arial size=2>
&nbsp;<INPUT NAME="username" TYPE="TEXT" SIZE=12 
MAXLENGTH="12" VALUE="$username"><br><br></font>
</TD>
</TR>
<TR>
<TD COLSPAN=2><HR></TD>
</TR>
<TR>
<TD><font face=arial size=2>
Select a password.  15 character max.&nbsp;&nbsp;</font>
</TD><TD><font face=arial size=2>
&nbsp;<INPUT NAME="password" TYPE="TEXT" SIZE=12 
MAXLENGTH="15" VALUE="$password"><br><br></font>
</TD>
</TR>
<TR>
<TD COLSPAN=2><HR></TD>
</TR>
<TR>
<TD><font face=arial size=2>
Do you wish to use manager login cookies?  Requires cookies to be allowed in browser.  Allows up to 2 store manager logins at the same exact time.&nbsp;&nbsp;</font>
</TD><TD><font face=arial size=2>
&nbsp;
<SELECT NAME=mc_use_cookie_login>
<option>$mc_use_cookie_login
<option>yes
<option>no
</SELECT><br><br></font>
</TD>
</TR>
<TR>
<TD COLSPAN=2><HR></TD>
</TR>
<TR>
<TD><font face=arial size=2>
Pick a unique name with at least 8 characters even if you are using cookies for the login.  If using the cookies then the system will automatically rotate the name used and will allow multiple logins from different locations simultaneously, but the unique name is used as a backup.</font>
</TD><TD><font face=arial size=2>
&nbsp;<INPUT NAME="a_unique_name" TYPE="TEXT" SIZE=20 
MAXLENGTH="45" VALUE="$a_unique_name"><br><br></font>
</TD>
</TR>
   </table>

   </div>
   <p align="center">&nbsp;</p>
   <p align="center"><font face="Arial"><INPUT TYPE="HIDDEN" NAME="system_edit_success" value="yes">
<INPUT NAME="PasswordSettings" TYPE="SUBMIT" value="Submit">
&nbsp;&nbsp;
<INPUT TYPE="RESET" value="Reset"></font></p>
   </form>
~;

print &$manager_page_footer;
}
#######################################################################################
sub update_Pass_settings {
  local($item,$stuff) = @_;
  $pass_file_settings{$item} = $stuff;
local($pass_settings) = "$mgrdir/misc/mgr_pass.pl";
  local($item,$zitem);
  &get_file_lock("$pass_settings.lockfile");
  open(PASSFILE,">$pass_settings") || &my_die("Can't Open $pass_settings");
  foreach $zitem (sort(keys %pass_file_settings)) {
    $item = $zitem;
     print (PASSFILE $pass_file_settings{$zitem});
   }
  close(PASSFILE);
  &release_file_lock("$pass_settings.lockfile");
&require_supporting_libraries(__FILE__,__LINE__,
  "$mgrdir/misc/mgr_pass.pl");
 }
#######################################################################################
1; # Library
