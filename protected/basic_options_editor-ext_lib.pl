# file ./store/protected/basic_options_editor-ext_lib.pl
#########################################################################
#
# Copyright (c) 2002-2004 K-Factor Technologies, Inc.
# http://www.k-factor.net/  and  http://www.AgoraCart.com/
# All Rights Reserved.
#
# This is NOT FREE SOFTWARE!  This library is a cost item,
# part of an ecommerce payment gateway solution.  To use it
# you must license it from http://www.AgoraCartPro.com/
#
# Pro Members (of AgoraCart) my use this file in one store.
# additional licenses must be purchused at:
# http://www.AgoraCartPro.com/
#
# This software is the confidential and proprietary information of
# K-Factor Technologies, Inc.  You shall
# not disclose such Confidential Information and shall use it only in
# accordance with the terms of the license agreement you entered into
# with K-Factor Technologies, Inc.
#
# K-Factor Technologies, Inc. MAKES NO REPRESENTATIONS OR WARRANTIES ABOUT
# THE SUITABILITY OF THE SOFTWARE, EITHER EXPRESSED OR IMPLIED,
# INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE,
# OR NON-INFRINGEMENT.
#
# K-Factor Technologies, Inc. SHALL NOT BE LIABLE FOR ANY DAMAGES SUFFERED BY
# LICENSEE AS A RESULT OF USING, MODIFYING OR DISTRIBUTING THIS
# SOFTWARE OR ITS DERIVATIVES.
#
# You may not give this script away or distribute it an any way without
# written permission.
#
##########################################################################
$versions{'basic_options_editor-ext_lib.pl'} = "4.99.001";


{
 local ($modname) = 'basic_options_editor';
 &register_extension($modname,"Basic Option File Manager",$versions{$modname});
 &add_merchtools_settings_choice("Basic Option Files"," Basic Option Files ",
  "change_basic_options_screen");
 &register_menu('EditOptionsFile',"display_basic_options_screen",
  $modname,"Select Option File");
 &register_menu('BasicOptionsSettings',"write_basic_options_settings",
  $modname,"Write Basic Option Files Settings");
 &register_menu('change_basic_options_screen',"display_options_screen",
  $modname,"Display Basic Option File Settings");
# &add_item_to_manager_menu("Basic Option Files","change_basic_options_screen=yes","");
}
#######################################################################################
sub write_basic_options_settings {
local($myset)="";
local($optfile)="";
$optfile2 ="";
local($optfile3)="";

&ReadParse;

      $optfile = "$in{'optionfilename'}.html";
      $optfile =~ /([\w\-\=\+\/]+)\.(\w+)/;
      $optfile = "$1.$2";
      $optfile =~ s/^\/+//;
      $optfile2 = (split (/\./, $optfile))[0];
if ($optfile2 eq "") {$optfile2 = "$optfile";}
      $optfile3 = "html";
      $optfile = "$optfile2.$optfile3";
$sc_optfile2edit = "$optfile2";

      open (NEW, ">$sc_options_directory_path/$optfile");
      $counter = 1;


      print NEW  "<table border=\"0\"><tr><td><p align=\"right\"><font size=\"2\" face=\"Arial\">\n";
      if ($in{'OptionA1'} ne "")
      {
         print NEW "<b>$in{'OptionA'}<\/b><SELECT NAME = \"option|$counter|\%\%PRODUCT_ID\%\%\">\n";
         if ($in{'OptionA1d'}){$OptionA1d = " \(\+ \$$in{'OptionA1d'}\)";}
         print NEW "<OPTION VALUE = \"$in{'OptionA1'}|$in{'OptionA1d'}\">$in{'OptionA1'}$OptionA1d\n";
         if ($in{'OptionA2'} ne "")
         {
            if ($in{'OptionA2d'}){$OptionA2d = " \(\+ \$$in{'OptionA2d'}\)";}
            print NEW "<OPTION VALUE = \"$in{'OptionA2'}|$in{'OptionA2d'}\">$in{'OptionA2'}$OptionA2d\n";
         }
         if ($in{'OptionA3'} ne "")
         {
            if ($in{'OptionA3d'}){$OptionA3d = " \(\+ \$$in{'OptionA3d'}\)";}
            print NEW "<OPTION VALUE = \"$in{'OptionA3'}|$in{'OptionA3d'}\">$in{'OptionA3'}$OptionA3d\n";
         }
         if ($in{'OptionA4'} ne "")
         {
            if ($in{'OptionA4d'}){$OptionA4d = " \(\+ \$$in{'OptionA4d'}\)";}
            print NEW "<OPTION VALUE = \"$in{'OptionA4'}|$in{'OptionA4d'}\">$in{'OptionA4'}$OptionA4d\n";
         }
         if ($in{'OptionA5'} ne "")
         {
            if ($in{'OptionA5d'}){$OptionA5d = " \(\+ \$$in{'OptionA5d'}\)";}
            print NEW "<OPTION VALUE = \"$in{'OptionA5'}|$in{'OptionA5d'}\">$in{'OptionA5'}$OptionA5d\n";
         }
         if ($in{'OptionA6'} ne "")
         {
            if ($in{'OptionA6d'}){$OptionA6d = " \(\+ \$$in{'OptionA6d'}\)";}
            print NEW "<OPTION VALUE = \"$in{'OptionA6'}|$in{'OptionA6d'}\">$in{'OptionA6'}$OptionA6d\n";
         }
         if ($in{'OptionA7'} ne "")
         {
            if ($in{'OptionA7d'}){$OptionA7d = " \(\+ \$$in{'OptionA7d'}\)";}
            print NEW "<OPTION VALUE = \"$in{'OptionA7'}|$in{'OptionA7d'}\">$in{'OptionA7'}$OptionA7d\n";
         }
         if ($in{'OptionA8'} ne "")
         {
            if ($in{'OptionA8d'}){$OptionA8d = " \(\+ \$$in{'OptionA8d'}\)";}
            print NEW "<OPTION VALUE = \"$in{'OptionA8'}|$in{'OptionA8d'}\">$in{'OptionA8'}$OptionA8d\n";
         }
         if ($in{'OptionA9'} ne "")
         {
            if ($in{'OptionA9d'}){$OptionA9d = " \(\+ \$$in{'OptionA9d'}\)";}
            print NEW "<OPTION VALUE = \"$in{'OptionA9'}|$in{'OptionA9d'}\">$in{'OptionA9'}$OptionA9d\n";
         }
      if ($in{'OptionA10'} ne "")
      {
         if ($in{'OptionA10d'}){$OptionA10d = " \(\+ \$$in{'OptionA10d'}\)";}
         print NEW "<OPTION VALUE = \"$in{'OptionA10'}|$in{'OptionA10d'}\">$in{'OptionA10'}$OptionA10d\n";
         }
      if ($in{'OptionA11'} ne "")
      {
         if ($in{'OptionA11d'}){$OptionA12d = " \(\+ \$$in{'OptionA11d'}\)";}
         print NEW "<OPTION VALUE = \"$in{'OptionA11'}|$in{'OptionA11d'}\">$in{'OptionA11'}$OptionA11d\n";
         }
      if ($in{'OptionA12'} ne "")
      {
         if ($in{'OptionA12d'}){$OptionA12d = " \(\+ \$$in{'OptionA12d'}\)";}
         print NEW "<OPTION VALUE = \"$in{'OptionA12'}|$in{'OptionA12d'}\">$in{'OptionA12'}$OptionA12d\n";
         }
      if ($in{'OptionA13'} ne "")
      {
         if ($in{'OptionA13d'}){$OptionA13d = " \(\+ \$$in{'OptionA13d'}\)";}
         print NEW "<OPTION VALUE = \"$in{'OptionA13'}|$in{'OptionA13d'}\">$in{'OptionA13'}$OptionA13d\n";
         }
      if ($in{'OptionA14'} ne "")
      {
         if ($in{'OptionA14d'}){$OptionA14d = " \(\+ \$$in{'OptionA14d'}\)";}
         print NEW "<OPTION VALUE = \"$in{'OptionA14'}|$in{'OptionA14d'}\">$in{'OptionA14'}$OptionA14d\n";
         }
      if ($in{'OptionA15'} ne "")
      {
         if ($in{'OptionA15d'}){$OptionA15d = " \(\+ \$$in{'OptionA1d'}\)";}
         print NEW "<OPTION VALUE = \"$in{'OptionA15'}|$in{'OptionA15d'}\">$in{'OptionA15'}$OptionA15d\n";
         }
         $counter++;
         print NEW "<\/SELECT><br><br>\n";
      }
      if ($in{'OptionB1'} ne "")
      {
         print NEW "<b>$in{'OptionB'}<\/b><SELECT NAME = \"option|$counter|\%\%PRODUCT_ID\%\%\">\n";
         if ($in{'OptionB1d'}){$OptionB1d = " \(\+ \$$in{'OptionB1d'}\)";}
         print NEW "<OPTION VALUE = \"$in{'OptionB1'}|$in{'OptionB1d'}\">$in{'OptionB1'}$OptionB1d\n";
         if ($in{'OptionB2'} ne "")
         {
            if ($in{'OptionB2d'}){$OptionB2d = " \(\+ \$$in{'OptionB2d'}\)";}
            print NEW "<OPTION VALUE = \"$in{'OptionB2'}|$in{'OptionB2d'}\">$in{'OptionB2'}$OptionB2d\n";
         }
         if ($in{'OptionB3'} ne "")
         {
            if ($in{'OptionB3d'}){$OptionB3d = " \(\+ \$$in{'OptionB3d'}\)";}
            print NEW "<OPTION VALUE = \"$in{'OptionB3'}|$in{'OptionB3d'}\">$in{'OptionB3'}$OptionB3d\n";
         }
         if ($in{'OptionB4'} ne "")
         {
            if ($in{'OptionB4d'}){$OptionB4d = " \(\+ \$$in{'OptionB4d'}\)";}
            print NEW "<OPTION VALUE = \"$in{'OptionB4'}|$in{'OptionB4d'}\">$in{'OptionB4'}$OptionB4d\n";
         }
         if ($in{'OptionB5'} ne "")
         {
            if ($in{'OptionB5d'}){$OptionB5d = " \(\+ \$$in{'OptionB5d'}\)";}
            print NEW "<OPTION VALUE = \"$in{'OptionB5'}|$in{'OptionB5d'}\">$in{'OptionB5'}$OptionB5d\n";
         }
         if ($in{'OptionB6'} ne "")
         {
            if ($in{'OptionB6d'}){$OptionB6d = " \(\+ \$$in{'OptionB6d'}\)";}
            print NEW "<OPTION VALUE = \"$in{'OptionB6'}|$in{'OptionB6d'}\">$in{'OptionB6'}$OptionB6d\n";
         }
         if ($in{'OptionB7'} ne "")
         {
            if ($in{'OptionB7d'}){$OptionB7d = " \(\+ \$$in{'OptionB7d'}\)";}
            print NEW "<OPTION VALUE = \"$in{'OptionB7'}|$in{'OptionB7d'}\">$in{'OptionB7'}$OptionB7d\n";
         }
         if ($in{'OptionB8'} ne "")
         {
            if ($in{'OptionB8d'}){$OptionB8d = " \(\+ \$$in{'OptionB8d'}\)";}
            print NEW "<OPTION VALUE = \"$in{'OptionB8'}|$in{'OptionB8d'}\">$in{'OptionB8'}$OptionB8d\n";
         }
         if ($in{'OptionB9'} ne "")
         {
            if ($in{'OptionB9d'}){$OptionB9d = " \(\+ \$$in{'OptionB9d'}\)";}
            print NEW "<OPTION VALUE = \"$in{'OptionB9'}|$in{'OptionB9d'}\">$in{'OptionB9'}$OptionB9d\n";
         }
         if ($in{'OptionB10'} ne "")
         {
            if ($in{'OptionB10d'}){$OptionB10d = " \(\+ \$$in{'OptionB10d'}\)";}
            print NEW "<OPTION VALUE = \"$in{'OptionB10'}|$in{'OptionB10d'}\">$in{'OptionB10'}$OptionB10d\n";
         }
         if ($in{'OptionB11'} ne "")
         {
            if ($in{'OptionB11d'}){$OptionB11d = " \(\+ \$$in{'OptionB11d'}\)";}
            print NEW "<OPTION VALUE = \"$in{'OptionB11'}|$in{'OptionB11d'}\">$in{'OptionB11'}$OptionB11d\n";
         }
         if ($in{'OptionB12'} ne "")
         {
            if ($in{'OptionB12d'}){$OptionB12d = " \(\+ \$$in{'OptionB12d'}\)";}
            print NEW "<OPTION VALUE = \"$in{'OptionB12'}|$in{'OptionB12d'}\">$in{'OptionB12'}$OptionB12d\n";
         }
         if ($in{'OptionB13'} ne "")
         {
            if ($in{'OptionB13d'}){$OptionB1d = " \(\+ \$$in{'OptionB13d'}\)";}
            print NEW "<OPTION VALUE = \"$in{'OptionB13'}|$in{'OptionB13d'}\">$in{'OptionB13'}$OptionB13d\n";
         }
         if ($in{'OptionB14'} ne "")
         {
            if ($in{'OptionB14d'}){$OptionB14d = " \(\+ \$$in{'OptionB14d'}\)";}
            print NEW "<OPTION VALUE = \"$in{'OptionB14'}|$in{'OptionB14d'}\">$in{'OptionB14'}$OptionB14d\n";
         }
         if ($in{'OptionB15'} ne "")
         {
            if ($in{'OptionB15d'}){$OptionB15d = " \(\+ \$$in{'OptionB15d'}\)";}
            print NEW "<OPTION VALUE = \"$in{'OptionB15'}|$in{'OptionB15d'}\">$in{'OptionB15'}$OptionB15d\n";
         }
         $counter++;
         print NEW "<\/SELECT><br><br>\n";
      }
      if ($in{'OptionC1'} ne "")
      {
         print NEW "<b>$in{'OptionC'}<\/b><SELECT NAME = \"option|$counter|\%\%PRODUCT_ID\%\%\">\n";
         if ($in{'OptionC1d'}){$OptionC1d = " \(\+ \$$in{'OptionC1d'}\)";}
         print NEW "<OPTION VALUE = \"$in{'OptionC1'}|$in{'OptionC1d'}\">$in{'OptionC1'}$OptionC1d\n";
         if ($in{'OptionC2'} ne "")
         {
            if ($in{'OptionC2d'}){$OptionC2d = " \(\+ \$$in{'OptionC2d'}\)";}
            print NEW "<OPTION VALUE = \"$in{'OptionC2'}|$in{'OptionC2d'}\">$in{'OptionC2'}$OptionC2d\n";
         }
         if ($in{'OptionC3'} ne "")
         {
            if ($in{'OptionC3d'}){$OptionC3d = " \(\+ \$$in{'OptionC3d'}\)";}
            print NEW "<OPTION VALUE = \"$in{'OptionC3'}|$in{'OptionC3d'}\">$in{'OptionC3'}$OptionC3d\n";
         }
         if ($in{'OptionC4'} ne "")
         {
            if ($in{'OptionC4d'}){$OptionC4d = " \(\+ \$$in{'OptionC4d'}\)";}
            print NEW "<OPTION VALUE = \"$in{'OptionC4'}|$in{'OptionC4d'}\">$in{'OptionC4'}$OptionC4d\n";
         }
         if ($in{'OptionC5'} ne "")
         {
            if ($in{'OptionC5d'}){$OptionC5d = " \(\+ \$$in{'OptionC5d'}\)";}
            print NEW "<OPTION VALUE = \"$in{'OptionC5'}|$in{'OptionC5d'}\">$in{'OptionC5'}$OptionC5d\n";
         }
         if ($in{'OptionC6'} ne "")
         {
            if ($in{'OptionC6d'}){$OptionC6d = " \(\+ \$$in{'OptionC6d'}\)";}
            print NEW "<OPTION VALUE = \"$in{'OptionC6'}|$in{'OptionC6d'}\">$in{'OptionC6'}$OptionC6d\n";
         }
         if ($in{'OptionC7'} ne "")
         {
            if ($in{'OptionC7d'}){$OptionC7d = " \(\+ \$$in{'OptionC7d'}\)";}
            print NEW "<OPTION VALUE = \"$in{'OptionC7'}|$in{'OptionC7d'}\">$in{'OptionC7'}$OptionC7d\n";
         }
         if ($in{'OptionC8'} ne "")
         {
            if ($in{'OptionC8d'}){$OptionC8d = " \(\+ \$$in{'OptionC8d'}\)";}
            print NEW "<OPTION VALUE = \"$in{'OptionC8'}|$in{'OptionC8d'}\">$in{'OptionC8'}$OptionC8d\n";
         }
         if ($in{'OptionC9'} ne "")
         {
            if ($in{'OptionC9d'}){$OptionC9d = " \(\+ \$$in{'OptionC9d'}\)";}
            print NEW "<OPTION VALUE = \"$in{'OptionC9'}|$in{'OptionC9d'}\">$in{'OptionC9'}$OptionC9d\n";
         }
         if ($in{'OptionC10'} ne "")
         {
            if ($in{'OptionC10d'}){$OptionC10d = " \(\+ \$$in{'OptionC10d'}\)";}
            print NEW "<OPTION VALUE = \"$in{'OptionC10'}|$in{'OptionC10d'}\">$in{'OptionC10'}$OptionC10d\n";
         }
         if ($in{'OptionC11'} ne "")
         {
            if ($in{'OptionC11d'}){$OptionC11d = " \(\+ \$$in{'OptionC11d'}\)";}
            print NEW "<OPTION VALUE = \"$in{'OptionC11'}|$in{'OptionC11d'}\">$in{'OptionC11'}$OptionC11d\n";
         }
         if ($in{'OptionC12'} ne "")
         {
            if ($in{'OptionC12d'}){$OptionC12d = " \(\+ \$$in{'OptionC12d'}\)";}
            print NEW "<OPTION VALUE = \"$in{'OptionC12'}|$in{'OptionC12d'}\">$in{'OptionC12'}$OptionC12d\n";
         }
         if ($in{'OptionC13'} ne "")
         {
            if ($in{'OptionC13d'}){$OptionC13d = " \(\+ \$$in{'OptionC13d'}\)";}
            print NEW "<OPTION VALUE = \"$in{'OptionC13'}|$in{'OptionC13d'}\">$in{'OptionC13'}$OptionC13d\n";
         }
         if ($in{'OptionC14'} ne "")
         {
            if ($in{'OptionC14d'}){$OptionC14d = " \(\+ \$$in{'OptionC14d'}\)";}
            print NEW "<OPTION VALUE = \"$in{'OptionC14'}|$in{'OptionC14d'}\">$in{'OptionC14'}$OptionC14d\n";
         }
         if ($in{'OptionC15'} ne "")
         {
            if ($in{'OptionC15d'}){$OptionC1d = " \(\+ \$$in{'OptionC15d'}\)";}
            print NEW "<OPTION VALUE = \"$in{'OptionC15'}|$in{'OptionC15d'}\">$in{'OptionC15'}$OptionC15d\n";
         }
         $counter++;
         print NEW "<\/SELECT><br><br>\n";
      }
   print NEW  "<\/font><\/td><\/tr><\/table>\n";
   close (NEWFILE);
$myset .= "$optfile|";
$myset .= "$in{'OptionA'}|";
$myset .= "$in{'OptionA1'}|";
$myset .= "$in{'OptionA1d'}|";
$myset .= "$in{'OptionA2'}|";
$myset .= "$in{'OptionA2d'}|";
$myset .= "$in{'OptionA3'}|";
$myset .= "$in{'OptionA3d'}|";
$myset .= "$in{'OptionA4'}|";
$myset .= "$in{'OptionA4d'}|";
$myset .= "$in{'OptionA5'}|";
$myset .= "$in{'OptionA5d'}|";
$myset .= "$in{'OptionA6'}|";
$myset .= "$in{'OptionA6d'}|";
$myset .= "$in{'OptionA7'}|";
$myset .= "$in{'OptionA7d'}|";
$myset .= "$in{'OptionA8'}|";
$myset .= "$in{'OptionA8d'}|";
$myset .= "$in{'OptionA9'}|";
$myset .= "$in{'OptionA9d'}|";
$myset .= "$in{'OptionA10'}|";
$myset .= "$in{'OptionA10d'}|";
$myset .= "$in{'OptionA11'}|";
$myset .= "$in{'OptionA11d'}|";
$myset .= "$in{'OptionA12'}|";
$myset .= "$in{'OptionA12d'}|";
$myset .= "$in{'OptionA13'}|";
$myset .= "$in{'OptionA13d'}|";
$myset .= "$in{'OptionA14'}|";
$myset .= "$in{'OptionA14d'}|";
$myset .= "$in{'OptionA15'}|";
$myset .= "$in{'OptionA15d'}|";
$myset .= "$in{'OptionB'}|";
$myset .= "$in{'OptionB1'}|";
$myset .= "$in{'OptionB1d'}|";
$myset .= "$in{'OptionB2'}|";
$myset .= "$in{'OptionB2d'}|";
$myset .= "$in{'OptionB3'}|";
$myset .= "$in{'OptionB3d'}|";
$myset .= "$in{'OptionB4'}|";
$myset .= "$in{'OptionB4d'}|";
$myset .= "$in{'OptionB5'}|";
$myset .= "$in{'OptionB5d'}|";
$myset .= "$in{'OptionB6'}|";
$myset .= "$in{'OptionB6d'}|";
$myset .= "$in{'OptionB7'}|";
$myset .= "$in{'OptionB7d'}|";
$myset .= "$in{'OptionB8'}|";
$myset .= "$in{'OptionB8d'}|";
$myset .= "$in{'OptionB9'}|";
$myset .= "$in{'OptionB9d'}|";
$myset .= "$in{'OptionB10'}|";
$myset .= "$in{'OptionB10d'}|";
$myset .= "$in{'OptionB11'}|";
$myset .= "$in{'OptionB11d'}|";
$myset .= "$in{'OptionB12'}|";
$myset .= "$in{'OptionB12d'}|";
$myset .= "$in{'OptionB13'}|";
$myset .= "$in{'OptionB13d'}|";
$myset .= "$in{'OptionB14'}|";
$myset .= "$in{'OptionB14d'}|";
$myset .= "$in{'OptionB15'}|";
$myset .= "$in{'OptionB15d'}|";
$myset .= "$in{'OptionC'}|";
$myset .= "$in{'OptionC1'}|";
$myset .= "$in{'OptionC1d'}|";
$myset .= "$in{'OptionC2'}|";
$myset .= "$in{'OptionC2d'}|";
$myset .= "$in{'OptionC3'}|";
$myset .= "$in{'OptionC3d'}|";
$myset .= "$in{'OptionC4'}|";
$myset .= "$in{'OptionC4d'}|";
$myset .= "$in{'OptionC5'}|";
$myset .= "$in{'OptionC5d'}|";
$myset .= "$in{'OptionC6'}|";
$myset .= "$in{'OptionC6d'}|";
$myset .= "$in{'OptionC7'}|";
$myset .= "$in{'OptionC7d'}|";
$myset .= "$in{'OptionC8'}|";
$myset .= "$in{'OptionC8d'}|";
$myset .= "$in{'OptionC9'}|";
$myset .= "$in{'OptionC9d'}|";
$myset .= "$in{'OptionC10'}|";
$myset .= "$in{'OptionC10d'}|";
$myset .= "$in{'OptionC11'}|";
$myset .= "$in{'OptionC11d'}|";
$myset .= "$in{'OptionC12'}|";
$myset .= "$in{'OptionC12d'}|";
$myset .= "$in{'OptionC13'}|";
$myset .= "$in{'OptionC13d'}|";
$myset .= "$in{'OptionC14'}|";
$myset .= "$in{'OptionC14d'}|";
$myset .= "$in{'OptionC15'}|";
$myset .= "$in{'OptionC15d'}|";
&update_option_file_settings('$optfile2',$myset);
  &display_basic_options_screen;
 }
################################################################################
sub display_basic_options_screen
{
local($filename)="$mgrdir/";
print &$manager_page_header("Basic Options","","","","");


if ($in{'sc_optfile2edit'} ne "") {
$sc_optfile2edit = "$in{'sc_optfile2edit'}";}
if ($sc_optfile2edit ne "") {
$optext4="pl";
$optfilename4="$mgrdir/options/$sc_optfile2edit.$optext4";
  open (DATA, "$optfilename4");
  @indata = <DATA>;
  close (DATA);
foreach $entries (@indata){
    ($optfilename,$OptionA,$OptionA1,$OptionA1d,$OptionA2,$OptionA2d,$OptionA3,$OptionA3d,$OptionA4,$OptionA4d,$OptionA5,$OptionA5d,$OptionA6,$OptionA6d,$OptionA7,$OptionA7d,$OptionA8,$OptionA8d,$OptionA9,$OptionA9d,$OptionA10,$OptionA10d,$OptionA11,$OptionA11d,$OptionA12,$OptionA12d,$OptionA13,$OptionA13d,$OptionA14,$OptionA14d,$OptionA15,$OptionA15d,$OptionB,$OptionB1,$OptionB1d,$OptionB2,$OptionB2d,$OptionB3,$OptionB3d,$OptionB4,$OptionB4d,$OptionB5,$OptionB5d,$OptionB6,$OptionB6d,$OptionB7,$OptionB7d,$OptionB8,$OptionB8d,$OptionB9,$OptionB9d,$OptionB10,$OptionB10d,$OptionB11,$OptionB11d,$OptionB12,$OptionB12d,$OptionB13,$OptionB13d,$OptionB14,$OptionB14d,$OptionB15,$OptionB15d,$OptionC,$OptionC1,$OptionC1d,$OptionC2,$OptionC2d,$OptionC3,$OptionC3d,$OptionC4,$OptionC4d,$OptionC5,$OptionC5d,$OptionC6,$OptionC6d,$OptionC7,$OptionC7d,$OptionC8,$OptionC8d,$OptionC9,$OptionC9d,$OptionC10,$OptionC10d,$OptionC11,$OptionC11d,$OptionC12,$OptionC12d,$OptionC13,$OptionC13d,$OptionC14,$OptionC14d,$OptionC15,$OptionC15d) = split(/\|/, $entries);}
}

print <<ENDOFTEXT;
<CENTER>
<HR>
</CENTER>

<FORM ACTION="manager.cgi" METHOD="POST">
<CENTER>
<TABLE>
<TR>
<TD>
<FONT FACE=ARIAL>Welcome to the <b>AgoraCart</b> Basic Option File Creator/Manager.  This area allows you to create the actual option files you use for your products.  You can create an option file that will contain up to 3 drop-down option boxes with up to 15 options per box.<br><br>An .HTML file will be created in the html/options subdirectory as well as a data file in the store manager's options directory so that you may be able to update a file you created with this manager at a later date.<br><br>
<b>Tips:</b><br>
<ul>
<li> in Option Name, for formatting, add a : and a space afterwards.
<li> In the pricing for each individual option, if there is no price or price increase, leave blank.
<li> Once the option file has been created, go to the product in the database and select the option file you created from the dropdown list and save.  Repeat for every product that needs this option file.</ul>
</TD>
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
<FONT FACE=ARIAL SIZE=2 COLOR=RED>Option File has been 
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
   <center>
   <tr>
   <td>
   <p align="right"><b><font face="Arial" size="2">File Name:</font></b></td>
   <td colspan="4"><b><font face="Arial" size="2"><input type="text" name="optionfilename" size="26" value="$optfilename">
   </font>
   </b><font color="#FF0000" size="2" face="Arial">- filename.html</font></td>
   </tr>
   <tr>
   <td colspan="6"><b><font face="Arial" size="2">&nbsp;</font></b></td>
   </tr>
   </center>
   <tr>
   <td colspan="6" bgcolor="#0000ff" align=center><font face="Arial" size="2" color=white><b>Top/First Option Box - Option 1</b></font></td>
</tr>
   <tr>
   <td colspan="6" align=center>
   <p><font face="Arial" size="2"><b>Option Name:</b></font>&nbsp;&nbsp;
 <b><font face="Arial" size="2"><input type="text" name="OptionA" size="26" value="$OptionA"></font></b>
   </td>
</tr>
   <tr>
   <td bgcolor="#E0E5FF" align=center>
   <b>
   <font face="Arial" size="2">Enter Option Name and Price</font></b></td>
   <td bgcolor="#E0E5FF" align=center></td>
   <td bgcolor="#E0E5FF" align=center>
   <b>
   <font face="Arial" size="2">Enter Option Name and Price</font></b></td>
   <td bgcolor="#E0E5FF" align=center></td>
   <td bgcolor="#E0E5FF" align=center>
   <b>
   <font face="Arial" size="2">Enter Option Name and Price</font></b></td>
   </tr>
   <tr>
   <td>
   <b>
   <font face="Arial" size="2">1.<input type="text" name="OptionA1" size="17" value="$OptionA1">\$<input type="text" name="OptionA1d" size="7" value="$OptionA1d"></font></b></td>
   <td></td>
   <td>
   <b><font face="Arial" size="2">2.<input type="text" name="OptionA2" size="17" value="$OptionA2">\$<input type="text" name="OptionA2d" size="7" value="$OptionA2d"></font></b></td>
   <td></td>
   <td>
   <b>
   <font face="Arial" size="2">3.<input type="text" name="OptionA3" size="17" value="$OptionA3">\$<input type="text" name="OptionA3d" size="7" value="$OptionA3d"></font></b></td>
   </tr>
   <tr>
   <td>
   <b>
   <font face="Arial" size="2">4.<input type="text" name="OptionA4" size="17" value="$OptionA4">\$<input type="text" name="OptionA4d" size="7"  value="$OptionA4d"></font></b></td>
   <td></td>
   <td>
   <b>
   <font face="Arial" size="2">5.<input type="text" name="OptionA5" size="17" value="$OptionA5">\$<input type="text" name="OptionA5d" size="7" value="$OptionA5d"></font></b></td>
   <td></td>
   <td>
   <b>
   <font face="Arial" size="2">6.<input type="text" name="OptionA6" size="17" value="$OptionA6">\$<input type="text" name="OptionA6d" size="7" value="$OptionA6d"></font></b>
   </td>
   </tr>
   <tr>
   <td>
   <b><font face="Arial" size="2">7.<input type="text" name="OptionA7" size="17" value="$OptionA7">\$<input type="text" name="OptionA7d" size="7" value="$OptionA7d"></font></b>
   </td>
   <td></td>
   <td>
   <b>
   <font face="Arial" size="2">8.<input type="text" name="OptionA8" size="17" value="$OptionA8">\$<input type="text" name="OptionA8d" size="7" value="$OptionA8d"></font></b>
   </td>
   <td></td>
   <td>
   <b>
   <font face="Arial" size="2">9.<input type="text" name="OptionA9" size="17" value="$OptionA9">\$<input type="text" name="OptionA9d" size="7" value="$OptionA9d"></font></b>
   </td>
   </tr>
   <tr>
   <td>
   <b><font face="Arial" size="2">10.<input type="text" name="OptionA10" size="17" value="$OptionA10">\$<input type="text" name="OptionA10d" size="7" value="$OptionA10d"></font></b>
   </td>
   <td></td>
   <td>
   <b>
   <font face="Arial" size="2">11.<input type="text" name="OptionA11" size="17" value="$OptionA11">\$<input type="text" name="OptionA11d" size="7" value="$OptionA11d"></font></b>
   </td>
   <td></td>
   <td>
   <b>
   <font face="Arial" size="2">12.<input type="text" name="OptionA12" size="17" value="$OptionA12">\$<input type="text" name="OptionA12d" size="7" value="$OptionA12d"></font></b>
   </td>
   </tr>
   <tr>
   <td>
   <b><font face="Arial" size="2">13.<input type="text" name="OptionA13" size="17" value="$OptionA13">\$<input type="text" name="OptionA13d" size="7" value="$OptionA13d"></font></b>
   </td>
   <td></td>
   <td>
   <b>
   <font face="Arial" size="2">14.<input type="text" name="OptionA14" size="17" value="$OptionA14">\$<input type="text" name="OptionA14d" size="7" value="$OptionA14d"></font></b>
   </td>
   <td></td>
   <td>
   <b>
   <font face="Arial" size="2">15.<input type="text" name="OptionA15" size="17" value="$OptionA15">\$<input type="text" name="OptionA15d" size="7" value="$OptionA15d"></font></b>
   </td>
   </tr>
  <tr>
   <td colspan="6"><b><font face="Arial" size="2">&nbsp;</font></b></td>
   </tr>
   </center>
   <tr>
   <td colspan="6" bgcolor="#0000ff" align=center><font face="Arial" size="2" color=white><b>Middle/Second Option Box - Option 2</b></font></td>
</tr>
   <tr>
   <td colspan="6" align=center>
   <p><font face="Arial" size="2"><b>Option Name:</b></font>&nbsp;&nbsp;
 <b><font face="Arial" size="2"><input type="text" name="OptionB" size="26" value="$OptionB"></font></b>
   </td>
</tr>
   <tr>
   <td bgcolor="#E0E5FF" align=center>
   <b>
   <font face="Arial" size="2">Enter Option Name and Price</font></b></td>
   <td bgcolor="#E0E5FF" align=center></td>
   <td bgcolor="#E0E5FF" align=center>
   <b>
   <font face="Arial" size="2">Enter Option Name and Price</font></b></td>
   <td bgcolor="#E0E5FF" align=center></td>
   <td bgcolor="#E0E5FF" align=center>
   <b>
   <font face="Arial" size="2">Enter Option Name and Price</font></b></td>
   </tr>
   <tr>
   <td>
   <b>
   <font face="Arial" size="2">1.<input type="text" name="OptionB1" size="17" value="$OptionB1">\$<input type="text" name="OptionB1d" size="7" value="$OptionB1d"></font></b></td>
   <td></td>
   <td>
   <b>
   <font face="Arial" size="2">2.<input type="text" name="OptionB2" size="17" value="$OptionB2">\$<input type="text" name="OptionB2d" size="7" value="$OptionB2d"></font></b></td>
   <td></td>
   <td>
   <b>
   <font face="Arial" size="2">3.<input type="text" name="OptionB3" size="17" value="$OptionB3">\$<input type="text" name="OptionB3d" size="7" value="$OptionB3d"></font></b></td>
   </tr>
   <tr>
   <td>
   <b>
   <font face="Arial" size="2">4.<input type="text" name="OptionB4" size="17" value="$OptionB4">\$<input type="text" name="OptionB4d" size="7" value="$OptionB4d"></font></b></td>
   <td></td>
   <td>
   <b>
   <font face="Arial" size="2">5.<input type="text" name="OptionB5" size="17" value="$OptionB5">\$<input type="text" name="OptionB5d" size="7" value="$OptionB5d"></font></b></td>
   <td></td>
   <td>
   <b>
   <font face="Arial" size="2">6.<input type="text" name="OptionB6" size="17" value="$OptionB6">\$<input type="text" name="OptionB6d" size="7" value="$OptionB6d"></font></b>
   </td>
   </tr>
   <tr>
   <td>
   <b><font face="Arial" size="2">7.<input type="text" name="OptionB7" size="17" value="$OptionB7">\$<input type="text" name="OptionB7d" size="7" value="$OptionB7d"></font></b>
   </td>
   <td></td>
   <td>
   <b><font face="Arial" size="2">8.<input type="text" name="OptionB8" size="17" value="$OptionB8">\$<input type="text" name="OptionB8d" size="7" value="$OptionB8d"></font></b>
   </td>
   <td></td>
   <td>
   <b><font face="Arial" size="2">9.<input type="text" name="OptionB9" size="17" value="$OptionB9">\$<input type="text" name="OptionB9d" size="7" value="$OptionB9d"></font></b>
   </td>
   </tr>
  <tr>
   <td>
   <b><font face="Arial" size="2">10.<input type="text" name="OptionB10" size="17" value="$OptionB10">\$<input type="text" name="OptionB10d" size="7" value="$OptionB10d"></font></b>
   </td>
   <td></td>
   <td>
   <b><font face="Arial" size="2">11.<input type="text" name="OptionB11" size="17" value="$OptionB11">\$<input type="text" name="OptionB11d" size="7" value="$OptionB11d"></font></b>
   </td>
   <td></td>
   <td>
   <b><font face="Arial" size="2">12.<input type="text" name="OptionB12" size="17" value="$OptionB12">\$<input type="text" name="OptionB12d" size="7" value="$OptionB12d"></font></b>
   </td>
   </tr>
  <tr>
   <td>
   <b><font face="Arial" size="2">13.<input type="text" name="OptionB13" size="17" value="$OptionB13">\$<input type="text" name="OptionB13d" size="7" value="$OptionB13d"></font></b>
   </td>
   <td></td>
   <td>
   <b><font face="Arial" size="2">14.<input type="text" name="OptionB14" size="17" value="$OptionB14">\$<input type="text" name="OptionB14d" size="7" value="$OptionB14d"></font></b>
   </td>
   <td></td>
   <td>
   <b><font face="Arial" size="2">15.<input type="text" name="OptionB15" size="17" value="$OptionB15">\$<input type="text" name="OptionB15d" size="7" value="$OptionB15d"></font></b>
   </td>
   </tr>

   <tr>
   <td colspan="6"><b><font face="Arial" size="2">&nbsp;</font></b></td>
   </tr>
   </center>
   <tr>
   <td colspan="6" bgcolor="#0000ff" align=center><font face="Arial" size="2" color=white><b>Bottom/Third Option Box - Option 3</b></font></td>
</tr>
   <tr>
   <td colspan="6" align=center>
   <p><font face="Arial" size="2"><b>Option Name:</b></font>&nbsp;&nbsp;
 <b><font face="Arial" size="2"><input type="text" name="OptionC" size="26" value="$OptionC"></font></b>
   </td>
</tr>
   <tr>
   <td bgcolor="#E0E5FF" align=center>
   <b>
   <font face="Arial" size="2">Enter Option Name and Price</font></b></td>
   <td bgcolor="#E0E5FF" align=center></td>
   <td bgcolor="#E0E5FF" align=center>
   <b>
   <font face="Arial" size="2">Enter Option Name and Price</font></b></td>
   <td bgcolor="#E0E5FF" align=center></td>
   <td bgcolor="#E0E5FF" align=center>
   <b>
   <font face="Arial" size="2">Enter Option Name and Price</font></b></td>
   </tr>
  <tr>
   <td>
   <b>
   <font face="Arial" size="2">1.<input type="text" name="OptionC1" size="17" value="$OptionC1">\$<input type="text" name="OptionC1d" size="7" value="$OptionC1d"></font></b></td>
   <td></td>
   <td>
   <b>
   <font face="Arial" size="2">2.<input type="text" name="OptionC2" size="17" value="$OptionC2">\$<input type="text" name="OptionC2d" size="7" value="$OptionC2d"></font></b></td>
   <td></td>
   <td>
   <b>
   <font face="Arial" size="2">3.<input type="text" name="OptionC3" size="17" value="$OptionC3">\$<input type="text" name="OptionC3d" size="7" value="$OptionC3d"></font></b></td>
   </tr>
   <tr>
   <td>
   <b>
   <font face="Arial" size="2">4.<input type="text" name="OptionC4" size="17" value="$OptionC4">\$<input type="text" name="OptionC4d" size="7" value="$OptionC4d"></font></b></td>
   <td></td>
   <td>
   <b>
   <font face="Arial" size="2">5.<input type="text" name="OptionC5" size="17" value="$OptionC5">\$<input type="text" name="OptionC5d" size="7" value="$OptionC5d"></font></b></td>
   <td></td>
   <td>
   <b>
   <font face="Arial" size="2">6.<input type="text" name="OptionC6" size="17" value="$OptionC6">\$<input type="text" name="OptionC6d" size="7" value="$OptionC6d"></font></b>
   </td>
   </tr>
   <tr>
   <td>
   <b><font face="Arial" size="2">7.<input type="text" name="OptionC7" size="17" value="$OptionC7">\$<input type="text" name="OptionC7d" size="7" value="$OptionC7d"></font></b>
   </td>
   <td></td>
   <td>
   <b><font face="Arial" size="2">8.<input type="text" name="OptionC8" size="17" value="$OptionC8">\$<input type="text" name="OptionC8d" size="7" value="$OptionC8d"></font></b>
   </td>
   <td></td>
   <td>
   <b><font face="Arial" size="2">9.<input type="text" name="OptionC9" size="17" value="$OptionC9">\$<input type="text" name="OptionC9d" size="7" value="$OptionC9d"></font></b>
   </td>
   </tr>
 <tr>
   <td>
   <b><font face="Arial" size="2">10.<input type="text" name="OptionC10" size="17" value="$OptionC10">\$<input type="text" name="OptionC10d" size="7" value="$OptionC10d"></font></b>
   </td>
   <td></td>
   <td>
   <b><font face="Arial" size="2">11.<input type="text" name="OptionC11" size="17" value="$OptionC11">\$<input type="text" name="OptionC11d" size="7" value="$OptionC11d"></font></b>
   </td>
   <td></td>
   <td>
   <b><font face="Arial" size="2">12.<input type="text" name="OptionC12" size="17" value="$OptionC12">\$<input type="text" name="OptionC12d" size="7" value="$OptionC12d"></font></b>
   </td>
   </tr>
 <tr>
   <td>
   <b><font face="Arial" size="2">13.<input type="text" name="OptionC13" size="17" value="$OptionC13">\$<input type="text" name="OptionC13d" size="7" value="$OptionC13d"></font></b>
   </td>
   <td></td>
   <td>
   <b><font face="Arial" size="2">14.<input type="text" name="OptionC14" size="17" value="$OptionC14">\$<input type="text" name="OptionC14d" size="7" value="$OptionC14d"></font></b>
   </td>
   <td></td>
   <td>
   <b><font face="Arial" size="2">15.<input type="text" name="OptionC15" size="17" value="$OptionC15">\$<input type="text" name="OptionC15d" size="7" value="$OptionC15d"></font></b>
   </td>
   </tr>
   </table>

   </div>
   <p align="center">&nbsp;</p>
   <p align="center"><font face="Arial"><INPUT TYPE="HIDDEN" NAME="system_edit_success" value="yes">
<INPUT NAME="BasicOptionsSettings" TYPE="SUBMIT" value="Submit">
&nbsp;&nbsp;
<INPUT TYPE="RESET" value="Reset"></font></p>
   </form>
~;

print &$manager_page_footer;
}
#######################################################################################
sub display_options_screen
{
&ReadParse;
print &$manager_page_header("Basic Options","","","","");
$sc_optfile2edit = '';
$optlist = '';
$optlist = "<OPTION VALUE=''>Create New Option File</OPTION>\n";

   opendir(OPTDIR,"$mgrdir/options")||die("Cannot open Directory!");
   @optnames2 = readdir(OPTDIR);
   for $optnames2(@optnames2)
   {
      $optname2 = (split (/\./, $optnames2))[0];
      $opt_extension2 = (split (/\./, $optnames2))[1];
       if ($opt_extension2 eq "pl")      {
  $optlist .= "<OPTION VALUE='$optname2'>$optname2</OPTION>\n";}
   }
   close (OPTDIR);

print qq~
<FORM ACTION="manager.cgi" METHOD="POST">
   <div align="center">
   <table border="0" cellspacing="0" width=500>
   <tr>
   <td>
<b><font face="Arial" size="2">Select file you wish to edit:<br>
<SELECT NAME='sc_optfile2edit'>$optlist</SELECT>
   </font>
   </b>
  <br><br>
   </td>
   </tr>
   </table>
<br>
   <p align="center"><font face="Arial">
<INPUT NAME="EditOptionsFile" TYPE="SUBMIT" value="Submit"></font></p>
   </div> </form>

~;

print &$manager_page_footer;
}
#######################################################################################
sub update_option_file_settings {
  local($item,$stuff) = @_;
  $option_file_settings{$item} = $stuff;
local($opt_settings) = "$mgrdir/options/$optfile2.pl";
  local($item,$zitem);

  &get_file_lock("$opt_settings.lockfile");
  open(OPTFILE,">$opt_settings") || &my_die("Can't Open $opt_settings");
  foreach $zitem (sort(keys %option_file_settings)) {
    $item = $zitem;
     print (OPTFILE $option_file_settings{$zitem});
   }
  close(OPTFILE);
  &release_file_lock("$opt_settings.lockfile");
 }
#######################################################################################
1; # Library
