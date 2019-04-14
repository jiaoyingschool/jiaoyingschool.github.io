# file ./store/protected/featured_product-ext_lib.pl
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
$versions{'featured_product-ext_lib.pl'} = "5.5.004 Gold Version";

$mc_featuredProductPath="$mgrdir/misc/featuredproduct.pl";

{
 local ($modname) = 'featured_product';
 &register_extension($modname,"Featured Product Manager",$versions{$modname});
# &add_settings_choice("Featured Product Manager"," Featured Product Manager ",
#	"change_featuredproduct_screen");
 &register_menu('FeaturedProductSettings',"write_featuredproduct_settings",
	$modname,"Write Featured Product Settings");
 &register_menu('change_featuredproduct_screen',"display_featuredproduct_screen",
	$modname,"Display Featured Product Settings");
 &add_merchtools_settings_choice("Featured Product","Featured Product",
  "change_featuredproduct_screen");
}
#######################################################################################
sub write_featuredproduct_settings {
 my ($myset)="";
 my $style="$in{'csstyle'}";

if (($in{'OptionA1'} ne "") && ($in{'OptionA1t'} ne "") && ($in{'OptionA1n'} ne "") &&
     ($in{'OptionA1p'} ne "") && ($in{'OptionA1d'} ne "")) {
$sc_featuredProduct = qq|<div align=center><a class=$style href="$sc_store_url?p_id=$in{'OptionA1'}&amp;name=$in{'OptionA1n'}&amp;xm=on" title="$in{'OptionA1n'}">
                         <img class="template_image_no_border" src="%%URLofImages%%/$in{'OptionA1t'}" alt="$in{'OptionA1n'}" border=0/></a><br />\n|;
$sc_featuredProduct .= qq|<a class=$style href="$sc_store_url?p_id=$in{'OptionA1'}&amp;name=$in{'OptionA1n'}&amp;xm=on" title="$in{'OptionA1n'}"><b>$in{'OptionA1n'}</b></a><br />\n|;
$p1 = $in{'OptionA1p'};
$p2 = &format_pricemgr($p1);
$sc_featuredProduct .= qq~$in{'OptionA1d'}<br />\n~;

my $temp_escaped_money_symbol = &my_escape($sc_money_symbol);

if ($sc_money_symbol_placement eq "front") {
    $sc_featuredProduct .= '<font class=ac_product_price>' . $temp_escaped_money_symbol . $sc_money_symbol_spaces . $p2 . '</font></div>\n';
} else {
    $sc_featuredProduct .= '<font class=ac_product_price>' . $p2 . $sc_money_symbol_spaces . $temp_escaped_money_symbol . '</font></div>\n';
}

my $temp_SSL = $sc_ssl_location_url2;
$temp_SSL =~ s/agora\.cgi//i;
$sc_featuredProduct_secure = qq|<div align=center><a class=$style href="$sc_store_url?cart_id=%%cart_id%%&amp;p_id=$in{'OptionA1'}&amp;name=$in{'OptionA1n'}&amp;xm=on">
     <img class="template_image_no_border" src="$temp_SSL%%URLofImages%%/$in{'OptionA1t'}" alt="$in{'OptionA1n'}" border=0/></a><br /><br />\n|;
$sc_featuredProduct_secure .= qq|<a class=$style href="$sc_store_url?cart_id=%%cart_id%%&amp;p_id=$in{'OptionA1'}&amp;name=$in{'OptionA1n'}&amp;xm=on"><b>$in{'OptionA1n'}</b></a><br />\n|;

$sc_featuredProduct_secure .= qq|$in{'OptionA1d'}<br />\n|;

if ($sc_money_symbol_placement eq "front") {
    $sc_featuredProduct_secure .= '<font class=ac_product_price>' . $temp_escaped_money_symbol . $sc_money_symbol_spaces . $p2 . '</font></div>\n';
} else {
    $sc_featuredProduct_secure .= '<font class=ac_product_price>' . $p2 . $sc_money_symbol_spaces . $temp_escaped_money_symbol . '</font></div>\n';
}

}

$myset .= "\$sc_featuredProduct = qq|$sc_featuredProduct|;\n";
$myset .= "\$sc_featuredProduct_secure = qq|$sc_featuredProduct_secure|;\n";
$myset .= "\$sc_displayFeaturedProducts = \"$in{'sc_displayFeaturedProducts'}\";\n";
$sc_displayFeaturedProducts = $in{'sc_displayFeaturedProducts'};
&update_store_settings('FEATUREDPRODUCT',$myset);

$myset = "$in{'csstyle'}|";    # css style
$myset .= "$in{'OptionA1'}|";  # p_id
$myset .= "$in{'OptionA1t'}|"; # thumbnail
$myset .= "$in{'OptionA1n'}|"; # name
$myset .= "$in{'OptionA1p'}|"; # price
$myset .= "$in{'OptionA1d'}|"; # description

&update_featuredproduct_file_settings($mc_featuredProductPath,$myset);

&display_featuredproduct_screen;
 }
################################################################################
sub display_featuredproduct_screen
{
my ($lines);
my ($csstyle,$OptionA1,$OptionA1t,$OptionA1n,$OptionA1p,$OptionA1d);
print &$manager_page_header("Featured Product","","","","");

open (DATA, "$mc_featuredProductPath");
@indata = <DATA>;
close (DATA);
foreach $lines (@indata){
	($csstyle,$OptionA1,$OptionA1t,$OptionA1n,$OptionA1p,$OptionA1d) = split(/\|/, $lines);
}

print <<ENDOFTEXT;
<CENTER>
<HR WIDTH=580>
</CENTER>

<FORM ACTION="manager.cgi" METHOD="POST">
<CENTER>
<TABLE WIDTH=580>
<TR>
<TD WIDTH=580><font face="arial,helvetica" size=2>
Welcome to the <b>AgoraCart</b> Featured Product Manager.  This area allows you select a product from your store that will be displayed as a "Featured Product" on your store pages.  Please only include a short description and a thumbnail sized image of the product as the featured product will be displayed in the store footer.  Note: if your store design does not have the appropriate code to show this feature within the headers or footers for your store, it will not be displayed until that code is added into your store's pages/files.</font></TD>
</TR>
</TABLE><br><hr width=520 size=1 noshade><br>
</CENTER>

ENDOFTEXT

if($in{'system_edit_success'} ne "")
{
print <<ENDOFTEXT;
<CENTER><br>
<TABLE>
<TR>
<TD>
<FONT FACE=ARIAL SIZE=2 COLOR=RED>Featured Product File has been successfully updated. </FONT>
</TD>
</TR>
</TABLE>
</CENTER>
ENDOFTEXT
}

print qq~
<FORM ACTION="manager.cgi" METHOD="POST">
  <div align="center"> 
    <table width="520" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td><font face="arial,helvetica" size=2><div align="center"><b>SETUP VARIABLES</b><br>
            This section should be completed with all the necessary information 
            for your store.<br>
            <br>
          </div></font></td>
      </tr>
    </table>
    <table width="520" border="0" cellspacing="0" cellpadding="0">
      <tr> 
        <td><font face="arial,helvetica" size=2><b>Style to use</b> <br>note: if you are using a standard template, enter: ac_left_links</font></td>
        <td><font face="arial,helvetica" size=2><div align="right"> 
            <input name="csstyle" type="text" id="csstyle" value="$csstyle" size="15">
          </div></font></td>
      </tr>
<TR>
<TD COLSPAN=2><HR></TD>
</TR>
<TR>
<TD>
<font face="arial,helvetica" size=2><b>Display Featured Product </b></font>
</TD><TD>
<br>
<SELECT NAME=sc_displayFeaturedProducts>
<OPTION SELECTED>$sc_displayFeaturedProducts</OPTION>
<OPTION>yes</OPTION>
<OPTION>no</OPTION>
</SELECT>
</TD>
</TR>
    </table>
    <br>
    <hr width="520">
    <table width="520" border="0" cellspacing="0">
      <center>
        <tr> 
          <td width="126"><font face="arial,helvetica" size=2><div align="left">Product ID
              <input type="text" name="OptionA1" size="5" value="$OptionA1" maxlength="25">
            </div></font></td>
          <td width="318"><font face="arial,helvetica" size=2><div align="left">Product Name:
              <input type="text" name="OptionA1n" size="30" value="$OptionA1n" maxlength="50">
            </div></font></td>
          <td width="318"><font face="arial,helvetica" size=2><div align="left">Short Description:
              <input type="text" name="OptionA1d" size="30" value="$OptionA1d" maxlength="125">
            </div></font></td>
        </tr>
        <tr> 
          <td width="318"><br><font face="arial,helvetica" size=2><div align="left">Price:<br><small>(no currency sign)</small>
              <input type="text" name="OptionA1p" size="10" value="$OptionA1p" maxlength="15">
            </div></font></td>
          <td colspan=2 width="636"><br><font face="arial,helvetica" size=2><div align="left">Thumbnail:<br><small>(image name only. must be in your images directory)</small>
              <input type="text" name="OptionA1t" size="50" value="$OptionA1t" maxlength="125">
            </div></font></td>
        </tr>
      </center>
    </table>
  </div><br><br>
   <p align="center"><font face="Arial"><INPUT TYPE="HIDDEN" NAME="system_edit_success" value="yes">
<INPUT NAME="FeaturedProductSettings" TYPE="SUBMIT" value="Submit">
&nbsp;&nbsp;
<INPUT TYPE="RESET" value="Reset"></font></p>
   </form>~;

print &$manager_page_footer;
}

#######################################################################################
sub update_featuredproduct_file_settings {
  local($item,$stuff) = @_;
  &get_file_lock("$mc_featuredProductPath.lockfile");
  open(BESTFILE,">$mc_featuredProductPath") || &my_die("Can't Open $mc_featuredProductPath");
     print (BESTFILE $stuff);
  close(BESTFILE);
  &release_file_lock("$mc_featuredProductPath.lockfile");
 }
#######################################################################################
1; # Library
