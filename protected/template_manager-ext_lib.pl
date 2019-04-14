# file ./store/protected/template_manager-ext_lib.pl
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
$versions{'template_manager-ext_lib.pl'} = "5.2.000";

{
 local ($modname) = 'template_manager';
 &register_extension($modname,"Template Manager",$versions{$modname});
 &add_settings_choice("Store Header Footer Template Editor","Store Header/Footer File Editor",
  "change_Template_screen");
 &register_menu('StoreHeaderTemplateSettings',"write_StoreHeaderTemplate_settings",
  $modname,"Write Store Header Template Settings");
 &register_menu('StoreFooterTemplateSettings',"write_StoreFooterTemplate_settings",
  $modname,"Write Store Footer Template Settings");
 &register_menu('SecureStoreHeaderTemplateSettings',"write_SecureStoreHeaderTemplate_settings",
  $modname,"Write Secure Header Template Settings");
 &register_menu('SecureStoreFooterTemplateSettings',"write_SecureStoreFooterTemplate_settings",
  $modname,"Write Secure Footer Template Settings");
 &register_menu('change_Template_screen',"display_Template_screen",
  $modname,"Display Template Manager");
 &add_merchtools_settings_choice("Store Header Footer Template Editor","Store Header/Footer File Editor",
  "change_Template_screen");
}
#######################################################################################
sub write_StoreHeaderTemplate_settings {
  my $new_store_file = "$in{'changed_store_header_file'}";
  open (NEWSTOREFILE,'>', "$sc_store_header_file");
    print NEWSTOREFILE $new_store_file;
  close (NEWSTOREFILE);
&display_Template_screen;
}
#######################################################################################
sub write_StoreFooterTemplate_settings {
  my $new_store_file = "$in{'changed_store_footer_file'}";
  open (NEWSTOREFILE,'>', "$sc_store_footer_file");
    print NEWSTOREFILE $new_store_file;
  close (NEWSTOREFILE);
&display_Template_screen;
}
#######################################################################################
sub write_SecureStoreHeaderTemplate_settings {
  my $new_store_file = "$in{'changed_secure_store_header_file'}";
  open (NEWSTOREFILE,'>', "$sc_secure_store_header_file");
    print NEWSTOREFILE $new_store_file;
  close (NEWSTOREFILE);
&display_Template_screen;
}
#######################################################################################
sub write_SecureStoreFooterTemplate_settings {
  my $new_store_file = "$in{'changed_secure_store_footer_file'}";
  open (NEWSTOREFILE,'>', "$sc_secure_store_footer_file");
    print NEWSTOREFILE $new_store_file;
  close (NEWSTOREFILE);
&display_Template_screen;
}
################################################################################
sub display_Template_screen
{
  local($filename)="$mgrdir/";
  my ($zfile,$zzfile) = '';
  my (@myfiles,@myfiles2);


  print &$manager_page_header("Template Editor","","","","");

    opendir (TEMPLATES, "$templates_file_dir"); 
    @myfiles = readdir(TEMPLATES); 
    closedir (TEMPLATES);
    foreach $zfile (@myfiles){
        if (!($zfile =~ /\./)) {
           opendir (INTEMPLATES, "$templates_file_dir/$zfile"); 
           @myfiles2 = readdir(INTEMPLATES); 
           closedir (INTEMPLATES);
           foreach $zzfile (@myfiles2){
             if (!($zzfile =~ /\./)) {
                $sm_templatelinks .= qq~<option value="$zfile/$zzfile">$zzfile</option>\n~;
             }
           }
           @myfiles2 = ""; 
        }
    }


    if ($sc_self_serve_images =~ /no/i) {
         $sc_buttonSetURLthingy = "$URL_of_images_directory/buttonsets";
    }
    opendir (BUTTONSETS, "$sc_buttonSetURLthingy"); 
    @myfiles = readdir(BUTTONSETS); 
    closedir (BUTTONSETS);
    foreach $zfile (@myfiles){
        if (!($zfile =~ /\./)) {
                $sm_buttonsetlinks .= qq~<option value="$zfile">$zfile</option>\n~;
        }
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
<font face="Arial, Helvetica, sans-serif" size=2><b>Welcome to the AgoraCart Store Default Header/Footer Template Editor</b>.  This area allows you to edit the main store header and footer template files directly that will be used by default in the design/look of your store (basically the default design applied store wide unless customized header or footer files are found).  To change main/default store headers/footers, please see the <a href="manager.cgi?change_settings_screen=yes">Your Store's Primary/Core Settings Manager</a>.  Using your own headers/footers is fairly easy, but not recommended for those without HTML editing experience. For faster setup, use a template already available<br><br> <i>NOTE: You can use your own templates if you wish, but this will require you to create your own headers and footers and upload them to the store's html/html-templates/templates/Custom sub directory and then put the .css file for your custom look in the html/html-templates/templates/Custom/CustomOne sub directory of your store (one more level down).   The Custom/CustomOne sub-directory names can be anything you like, such as CompanyName/SpringSaleTemplate, CompanyName/XmasTemplate, etc.  If you wish to use custom header and/or footer files by category name, you will need to create those files separately and place them in the html/html-templates sub directory of your store (using the formats of header-CATEGORY-NAME-HERE.inc and/or footer-CATEGORY-NAME-HERE.inc, which is auto-detected automatically if enabled in the <a href="manager.cgi?change_store_layout_screen=yes">Layout & Design Settings - Misc</a> Manager).  Make sure to upload all HTML and CSS files in ASCII mode.</i></center></TD>
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
<FONT FACE=ARIAL SIZE=2 COLOR=RED>Template Settings have been 
successfully updated. </FONT>
</TD>
</TR>
</TABLE>
</CENTER>
ENDOFTEXT
}


open (STOREHEADER, "<$sc_store_header_file");# || die ('Could not find file') ;
local $full_store_header_file;
   while(<STOREHEADER>) { 
     $full_store_header_file .= $_ ;
   }
close (STOREHEADER);

print qq~
<hr><br> 
<FORM ACTION="manager.cgi" METHOD="POST">
<TABLE>
<TR>
<TD COLSPAN="2"><b>Store Header:</b><br><font face="arial,helvetica" size=2><br>
Here are the current contents of the main Store Header file (displayed on standard pages) located at:<br><em>$sc_store_header_file</em><br>
Feel free to do any edits using this interface, or you may download the Store Header file via FTP and make the changes manually.<br>
<TEXTAREA NAME="changed_store_header_file" cols="68" rows="15" wrap=off>$full_store_header_file</TEXTAREA></font>
</TD>
</TR>
</TABLE>
</CENTER>
   </div>
   <p align="center">&nbsp;</p>
   <p align="center"><font face="Arial"><INPUT TYPE="HIDDEN" NAME="system_edit_success" value="yes">
<INPUT NAME="StoreHeaderTemplateSettings" TYPE="SUBMIT" value="Update Store Header File"></font></p>
</form><br>
~;

open (STOREFOOTER, "<$sc_store_footer_file");# || die ('Could not find file') ;
local $full_store_footer_file;
   while(<STOREFOOTER>) { 
     $full_store_footer_file .= $_ ;
   }
close (STOREFOOTER);

print qq~
<hr><br> 
<FORM ACTION="manager.cgi" METHOD="POST">
<TABLE>
<TR>
<TD COLSPAN="2"><b>Store Footer:</b><br><font face="arial,helvetica" size=2><br>
Here are the current contents of the main Store Footer file  (displayed on standard pages) located at:<br><em>$sc_store_footer_file</em><br>
Feel free to do any edits using this interface, or you may download the Store Footer file via FTP and make the changes manually.<br>
<TEXTAREA NAME="changed_store_footer_file" cols="68" rows="15" wrap=off>$full_store_footer_file</TEXTAREA></font>
</TD>
</TR>
</TABLE>
</CENTER>
   </div>
   <p align="center">&nbsp;</p>
   <p align="center"><font face="Arial"><INPUT TYPE="HIDDEN" NAME="system_edit_success" value="yes">
<INPUT NAME="StoreFooterTemplateSettings" TYPE="SUBMIT" value="Update Store Footer File"></font></p>
</form><br>
~;


open (SECURESTOREHEADER, "<$sc_secure_store_header_file");# || die ('Could not find file') ;
local $full_secure_store_header_file;
   while(<SECURESTOREHEADER>) { 
     $full_secure_store_header_file .= $_ ;
   }
close (SECURESTOREHEADER);

print qq~
<hr><br> 
<FORM ACTION="manager.cgi" METHOD="POST">
<TABLE>
<TR>
<TD COLSPAN="2"><b>Secure Store Header:</b><br><font face="arial,helvetica" size=2><br>
Here are the current contents of the main Secure Store Header file  (displayed on all SSL secure checkout pages) located at:<br><em>$sc_secure_store_header_file</em><br>
Feel free to do any edits using this interface, or you may download the Secure Store Header file via FTP and make the changes manually.<br>
<TEXTAREA NAME="changed_secure_store_header_file" cols="68" rows="10" wrap=off>$full_secure_store_header_file</TEXTAREA></font>
</TD>
</TR>
</TABLE>
</CENTER>
   </div>
   <p align="center">&nbsp;</p>
   <p align="center"><font face="Arial"><INPUT TYPE="HIDDEN" NAME="system_edit_success" value="yes">
<INPUT NAME="SecureStoreHeaderTemplateSettings" TYPE="SUBMIT" value="Update Secure Store Header File"></font></p>
</form><br>
~;

open (SECURESTOREFOOTER, "<$sc_secure_store_footer_file");# || die ('Could not find file') ;
local $full_secure_store_footer_file;
   while(<SECURESTOREFOOTER>) { 
     $full_secure_store_footer_file .= $_ ;
   }
close (SECURESTOREFOOTER);

print qq~
<hr><br> 
<FORM ACTION="manager.cgi" METHOD="POST">
<TABLE>
<TR>
<TD COLSPAN="2"><b>Secure Store Footer:</b><br><font face="arial,helvetica" size=2><br>
Here are the current contents of the main Secure Store Footer file (displayed on all SSL secure checkout pages) located at:<br><em>$sc_secure_store_footer_file</em><br>
Feel free to do any edits using this interface, or you may download the Secure Store Footer file via FTP and make the changes manually.<br>
<TEXTAREA NAME="changed_secure_store_footer_file" cols="68" rows="15" wrap=off>$full_secure_store_footer_file</TEXTAREA></font>
</TD>
</TR>
</TABLE>
</CENTER>
   </div>
   <p align="center">&nbsp;</p>
   <p align="center"><font face="Arial"><INPUT TYPE="HIDDEN" NAME="system_edit_success" value="yes">
<INPUT NAME="SecureStoreFooterTemplateSettings" TYPE="SUBMIT" value="Update Secure Store Footer File"></font></p>
</form><br><br>
~;


print &$manager_page_footer;
}
#######################################################################################
1; # Library
