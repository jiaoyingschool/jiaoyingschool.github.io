# file ./store/protected/upgrade_manager-ext_lib.pl
#
# Show versions of files from the manager (if logged in)
# http://.../.../manager.cgi?versions=1

# 20050829 ASY Changes:
#   * Fixed order so that *all* versions are found and displayed, not just what
#     has been registered
#   * Optimized subroutine a little here and there
#   * Added showin and showenv handlers to show %in and %ENV upon request

# 20050830 ASY Changes:
#   * Minor reformatting and code changes
#   * Factored out versions discovery to subroutine
#   * Factored out table building subroutine

# CHANGES BY MISTER ED
# 20060204 Mister Ed Changes (Feb 2006)
# add update file read routines for regular version
# add update file read routines for pro version
# pass credentials if pro version
# added in links to update individual files
# formating of layout changes
# added table for files not used from update file, excluding order libs and order managers.
# renamed to upgrade_manager-ext_lib.pl
# added get_and_update_cart_file sub routine (function)

# 20071009 Mister Ed Changes (October 2007)
# added payment gateway installer / remover.
# added in template and template skin installer/remover.
# added in button set installer / remover.
# streamlined a few redundant module calls.
# streamlined code not needed.

# Flow: (outdated)

#  Initial:
#   Update and parse current library page (hash)
#   Get current installed library versions (hash)
#   Determine which libraries have updates (hash)
#   Build table that displays library, installed version and either
#   'uptodate' or link to update that library
#   Display page with above table and link to update all libraries if
#   any libraries need update (don't display link if no libraries need update)

#  Update Single Library:
#   Get URL from current library page for library to be updated
#   Get file from URL if not already downloaded
#   Unpack file (not used yet)
#   Check md5 sum if possible (add later)
#   syntax check file - success? (add later)
#     N: Notify user and return
#     Y: Install library

#  Update Multiple Libraries:
#   Loop through single library update subroutine for each library update requested

local($modname) = "upgrade_manager-ext_lib.pl";
$versions{'upgrade_manager-ext_lib.pl'} = "5.2.001";
$updateErrorMessage = "";
$mgr_upgrade_error_message = '';
{ 
&register_extension( $modname, "Upgrade Versions", $versions{$modname} );
 &add_settings_choice("Upgrade Versions Manager","Upgrade AgoraCart Modules",
	"display_module_versions");
&register_menu("AgoraCart module manager", "Show/Update AgoraCart Module Versions", "display_module_versions");
 &register_menu('display_module_versions',"show_manager_versions",
  $modname,"Display Cart Module Versions");
 &register_menu('versions',"show_manager_versions",
	$modname,"Show Module Versions");
 &register_menu('updateCartFile',"get_and_update_cart_file",
	$modname,"Get and save-write updated cart file");
 &register_menu('displayTemplateInstaller',"display_templates_install_page",
	$modname,"Display Template Installer options");

 &register_menu('clickinstallnewtemplateset',"perform_templates_install",
	$modname,"Install Selected New Template");
 &register_menu('clickinstallnewbuttonset',"perform_buttonset_install",
	$modname,"Install Selected New Buttonset");

 &register_menu('clicktoremovetemplateset',"perform_template_skin_removal",
	$modname,"Remove Selected Template Skin");
 &register_menu('clicktoremovebuttonset',"perform_buttonset_removal",
	$modname,"Remove Selected Button Set");

 &register_menu('displayPaymentGatewayInstaller',"display_gateway_install_page",
	$modname,"Display Payment Gateway Install options");
 &register_menu('clicktoinstallpaymentgateway',"perform_payment_gateway_install",
	$modname,"Install Payment Gateway Files");
 &register_menu('clicktoremovepaymentgateway',"perform_payment_gateway_removal",
	$modname,"Remove Payment Gateway Files");
}
################################################################################
#added by Mister Ed Feb 2 2006
sub get_and_update_cart_file {
my $filename = $in{'upgradeFileName'};
my $filename2 = "$in{'fileNameToUpgrade'}";
my $file = "";
my $test = "";
$target_file = "http://www.agoracart.com/downloadupdates/$filename";
$file = get($target_file);
$filename2 =~ /^([\/-\@\w.\-]+)$/; 
$filename2 = $1;
# error conditionals added by Mister Ed March 15, 2006
if ($file ne '') {
#create backup file.  added by Mister Ed Feb 6, 2006
my $filename5 = $filename2;
$filename5 =~ s/pl$/txt/;
$filename5 =~ s/cgi$/txt/;
my $timethingy = time;
$filename5 =~ s/\./_v5_update_$timethingy\./;
use File::Copy;
copy($filename2, $filename5);
# use system command if File::Copy not there
# add in error check later?
# system("cp $filename2 $filename5");
  open(UPDATEFILE,">./$filename2") || &my_die("Can't Open $filename2");
     print (UPDATEFILE $file);
  close(UPDATEFILE);
if ($filename2 =~ /cgi$/) {
    system("chmod 755 ./$filename2");
}
# error messages and conditionals added by Mister Ed March 15, 2006
  $updateErrorMessage = "SUCCESS ... file successfully updated.  DO NOT RELOAD/REFRESH THIS PAGE!";
} elsif ($test ne '')  {
     $updateErrorMessage = $test;
} else {
  $updateErrorMessage = "ERROR: The file you requested was not reachable for updates.";
}
&show_manager_versions;
}
################################################################################
sub show_manager_versions {
  my $in = $in{ 'showin' } && $in{ 'showin' } ne '' ? build_table_from_hash( 'Incoming Variables', \%in ) : '';
  my $env = $in{ 'showenv' } && $in{ 'showenv' } ne '' ? build_table_from_hash( 'Environment Variables', \%ENV ) : '';
  %versions = installed_versions();
$versions{'Perl'} = "$]";
  $versions = build_table_from_hash( 'Core AgoraCart Files Already Installed', \%versions );
  print &$manager_page_header("$sc_gateway_name Gateway","","","","");
if($in{'system_edit_success'} ne "")
{
print <<ENDOFTEXT;
<CENTER><br>
<TABLE>
<TR>
<TD>
<FONT FACE=ARIAL SIZE=2 COLOR=RED>Updates Attempted:<br>$updateErrorMessage</FONT>
</TD>
</TR>
</TABLE>
</CENTER>
ENDOFTEXT
}
print qq~<font size="2" face="Arial, Helvetica, sans-serif"><br/><br/>For any updgrades to currently installed files, a backup will be created in the form of filename.time in case something goes wrong as well as to ensure that each backup file is unique.* If you download a NEW file (not currently installed) ending in .cgi, you will need to chmod it to 755 after download ing it; use FTP of an online file manager to do this.<br><br><div align=center>Available gateways not listed below must be manually installed.<br/>Current payment processing gateways can be found in the download sections of AgoraCart.com or AgoraCartPro.com.<br/>For more information on available gateways, please visit the <a href="http://www.AgoraCart.com/paymentgateways.htm" target="_new">Supported Gateways Page at AgoraCart.com</a></div></font>

<br><div align="center">
<table border ="0" cellspacing="0" cellpadding="6"><tr>
<td>
<form method="post" action="manager.cgi">
<input name="displayTemplateInstaller" type="submit" value="Template / Buttonset Installer">
</form>
</td>
<td>
<form method="post" action="manager.cgi">
<input name="displayPaymentGatewayInstaller" type="submit" value="Payment Gateway Installer">
</form>
</td>
</tr></table></div>
</font>
~;

  print $versions . $in . $env;

 print "<font size=\"1\" face=\"Arial, Helvetica, sans-serif\"><br/><br/>* (time = number of seconds since 1970 (EPOCH) in most cases.  Backups require the Perl File::Copy module to be installed which is already installed on most servers).</font><br/><br/>";
  print &$manager_page_footer;

  &call_exit;
}

################################################################################

# Expects a string to be used for a title and a reference to a hash
# Returns a string of an html table

sub build_table_from_hash {
  my ( $title, $hash ) = @_;
  my $temp_user_compare = "3 User";

#read files for updates added by Mister Ed Jan 2006
$target_file = "http://www.agoracart.com/upgradecart.txt";
use LWP::Simple;
my $file = get($target_file);
my @line = split(/\n/, $file);
foreach $line (@line) {
my ($upkey,$upversion,$upfilename,$upgradeStorePath,$upgradeSourcePath) = split(/\|/, $line);
chomp $upgradeSourcePath;
$updatesAvailable{$upkey} = "$upversion";
$updatesAvailableFile{$upkey} = "$upfilename";
$updatesAvailableRealFile{$upkey} = "$upgradeStorePath";
$updateSiteSourceFile{$upkey} = "$upgradeSourcePath";
}

  my $table  = "<br /><br /><font face=arial size=+1><b>${title}</b><br /></font>\n
<small>NOTE: the Official Version of your store is determined by the file versions of the agora.cgi and manager.cgi files.  All other file versions are for reference only and do not keep pace with the official store version and may have a lower or higher version number, which is normal.</small>
<br /><br />\n
<table border=\"1\" cellpadding=\"2\" cellspacing=\"2\">\n";
     for my $keys (sort keys(%$hash)) {
         if ($$hash{$keys} lt $updatesAvailable{$keys}) {
             $table .= qq~  <tr><td><font face=arial size=2>$keys</font></td><td><font face=arial size=2>$$hash{$keys}</font></td><td><font face=arial size=2>
<div align=center>update to: $updatesAvailable{$keys}
<FORM ACTION="manager.cgi" METHOD="POST">
<input type="hidden" name="upgradeFileName" value="$updatesAvailableFile{$keys}">
<input type="hidden" name="fileNameToUpgrade" value="$updatesAvailableRealFile{$keys}">
<input type="hidden" name="fileNameAndPath" value="$updateSiteSourceFile{$keys}">
<INPUT TYPE="HIDDEN" NAME="system_edit_success" value="yes">
<INPUT NAME="updateCartFile" TYPE="SUBMIT" value="Click to Update">
</form></div>
</font></td></tr>\n
~;
         } elsif ($$hash{$keys} ne '') {
             $table .= "  <tr><td><font face=arial size=2>$keys</font></td><td><font face=arial size=2>$$hash{$keys}</font></td><td><font face=arial size=1>none available</font></td></tr>\n";
         }

     }
     $table .= "</table><br>\n";

if ($mgr_upgrade_error_message ne "yes") {
  $table  .= "<br /><br /><font face=arial size=+1><b>Add-ons or Core Files Not Installed </b></font><font face=arial size=2><br>(excluded from list are payment gateways, templates and layout files).</font><br /><br /></font>\n<table border=\"1\" cellpadding=\"2\" cellspacing=\"2\" width=90%>\n";

     for my $keys (sort keys(%updatesAvailable)) {
         if (($$hash{$keys} eq "") && ($updatesAvailableRealFile{$keys} !~ /-order_lib/) && ($updatesAvailableRealFile{$keys} !~ /-mgr_lib/) && ($updatesAvailable{$keys} ne '')  && ($keys !~ /$temp_user_compare/)) {
             $table .= qq~  <tr><td width=30%><font face=arial size=2>$keys</font></td><td width=20%><font face=arial size=2>$updatesAvailable{$keys}</font></td>
~;

$table .= qq~
<td width=25%><font face=arial size=2>
<div align=center>Click to Install: $updatesAvailable{$keys}
<FORM ACTION="manager.cgi" METHOD="POST">
<input type="hidden" name="upgradeFileName" value="$updatesAvailableFile{$keys}">
<input type="hidden" name="fileNameToUpgrade" value="$updatesAvailableRealFile{$keys}">
<input type="hidden" name="fileNameAndPath" value="$updateSiteSourceFile{$keys}">
<input type="hidden" name="fileMembershipRequire" value="$memberLevels{$keys}">
<INPUT TYPE="HIDDEN" NAME="system_edit_success" value="yes">
<INPUT NAME="updateCartFile" TYPE="SUBMIT" value="Click to Install">
</form></div>
</font></td></tr>
~;
         }
     }
     $table .= "</table><br><br><br>\n";
}
  return $table;
}
################################################################################
sub installed_versions {
  return undef unless defined wantarray;
  my $versions = `grep -h "^\\\$versions{'.*'}\\ *=" $mgrdir/*.pl $mgrdir/*.cgi $mgrdir/custom/*.pl $mgrdir/*.ok ./*.cgi ./add_ons/*.pl ./library/*.pl 2> /dev/null`;
  my %installed_versions;
  for my $version ( split /\n/, $versions ) {
    my ( $key, $val ) = $version =~ /versions{'(.*?)'}\s*=\s*"(.*?)"/;
    $installed_versions{$key} = $val;
  }
  return wantarray ? %installed_versions : \%installed_versions;
}
################################################################################
sub perform_buttonset_removal {

    $in{'sc_removebuttonSetName'} =~ /([\w\-\/]+)/;
    $in{'sc_removebuttonSetName'} = "$1";
    my $filename = "$in{'sc_removebuttonSetName'}";
    my $local_buttonset = "html/images/buttonsets/$filename";

    if ($sc_buttonSetName =~ /$in{'sc_removebuttonSetName'}/i) {
        $in{'sc_removebuttonSetName'} = '';
    }

 if ($in{'sc_removebuttonSetName'} ne '') {
    if (-e "./$local_buttonset") {
        my $result = `rm -rf "./html/images/buttonsets/$filename"`;
        $updateErrorMessage .= "Button set removal is complete";
    }

 } else {
    $updateErrorMessage = "No Button Set Selected or current Button Set in use was selected. Request Cancelled.<br />";
 }

 &display_templates_install_page;
}
################################################################################
sub perform_template_skin_removal {

    $in{'sc_removeheaderTemplateName'} =~ /([\w\-\/]+)/;
    $in{'sc_removeheaderTemplateName'} = "$1";
    my $filename = "$in{'sc_removeheaderTemplateName'}";
    my $local_skin = "html/html-templates/templates/$filename";

    if ($sc_headerTemplateName =~ /$in{'sc_removeheaderTemplateName'}/i) {
        $in{'sc_removeheaderTemplateName'} = '';
    }

 if ($in{'sc_removeheaderTemplateName'} ne '') {
    if (-e "./$local_skin") {
        my $result = `rm -rf "./html/html-templates/templates/$filename"`;
        $updateErrorMessage .= "Template or skin removal is complete";
    }

 } else {
    $updateErrorMessage = "No template selected or current template in use was selected. Request Cancelled.<br />";
 }

 &display_templates_install_page;
}
################################################################################
sub perform_templates_install {

    $in{'sc_newheaderTemplateName'} =~ /([\w\-\/]+)/;
    $in{'sc_newheaderTemplateName'} = "$1";
    my $filename = "$in{'sc_newheaderTemplateName'}";
    my $local_dir = "html/html-templates/templates/$filename.tar";
    my $result = '';


 if ($in{'sc_newheaderTemplateName'} ne '') {
    if (!(-e "./$local_dir")) {
        my $target_file = "http://www.agoracart.com/downloadupdates/templates/$filename.tar";
        getstore("$target_file","./$local_dir");
    }

    if (-e "./$local_dir") {
        chdir("./html/html-templates/templates");
        my $result = `tar -xvpf "$filename.tar" 2>&1`;
        $updateErrorMessage .= "<pre>$result</pre>";
        unlink "$filename.tar";
        chdir("../../../");
    }

 } else {
    $updateErrorMessage = "No Template Selected. Request Cancelled.<br />";
 }

 &display_templates_install_page;
}
################################################################################
sub perform_buttonset_install {

    $in{'sc_newbuttonSetName'} =~ /([\w\-\/]+)/;
    $in{'sc_newbuttonSetName'} = "$1";
    my $filename = "$in{'sc_newbuttonSetName'}";
    my $local_dir = "html/images/buttonsets/$filename.tar";
    my $result = '';

 if ($in{'sc_newbuttonSetName'} ne '') {
    if (!(-e "./$local_dir")) {
        my $target_file = "http://www.agoracart.com/downloadupdates/buttonsets/$filename.tar";
        getstore("$target_file","./$local_dir");
    }

    if (-e "./$local_dir") {
        chdir("./html/images/buttonsets");
        my $result = `tar -xvpf "$filename.tar" 2>&1`;
        $updateErrorMessage .= "<pre>$result</pre>";
        unlink "$filename.tar";
        chdir("../../../");
    }

 } else {
        $updateErrorMessage = "No Button Set Selected. Request Cancelled.<br />"
    }

    &display_templates_install_page;
}
################################################################################
sub perform_payment_gateway_removal {

    $in{'sc_PaymentGatewayToremove'} =~ /([\w\-\/]+)/;
    $in{'sc_PaymentGatewayToremove'} = "$1";
    my $filename = "$in{'sc_PaymentGatewayToremove'}";
    $updateErrorMessage = '';

    if ($sc_gateway_name =~ /$filename/i) {
        $in{'sc_PaymentGatewayToremove'} = '';
        $updateErrorMessage = "You attempted to Delete your Primary Gateway. Please change your store settings before trying to remove the $filename payment gateway files.<br />";
    }

  if ($in{'sc_PaymentGatewayToremove'} ne '') {

      if ($in{'removepguserlib'}) {
         my $local_delete = "$sc_admin_dir/$filename"."-user_lib.pl";
         if (-e "$local_delete") { `rm -f $local_delete`;}
      }
      if ($in{'removepgorderform'}) {
         my $local_delete = "$sc_html_dir/forms/$filename"."-orderform.html";
         if (-e "$local_delete") { `rm -f $local_delete`;}
      }
      if ($in{'removepgorderlib'}) {
         my $local_delete = "$sc_lib_dir/$filename"."-order_lib.pl";
         if (-e "$local_delete") { `rm -f $local_delete`;}
      }
      if ($in{'removepgmgrlib'}) {
         my $local_delete = "$sc_lib_dir/$filename"."-mgr_lib.pl";
         if (-e "$local_delete") { `rm -f $local_delete`;}
      }
      if ($in{'removepgsecondorderlib'}) {
         my $local_delete = "./add_ons/$filename"."-order_lib.pl";
         if (-e "$local_delete") { `rm -f $local_delete`;}
      }

      $updateErrorMessage = "Selected Gateway Files were removed.<br />"

  } else {
        $updateErrorMessage .= "No Gateway Selected. Request Cancelled.<br />"
  }

    &display_gateway_install_page;
}
################################################################################
sub perform_payment_gateway_install {

    $in{'sc_newPaymentGatewayToinstall'} =~ /([\w\-\/]+)/;
    $in{'sc_newPaymentGatewayToinstall'} = "$1";
    my ($filename,$memberlevel) = split(/\//, $in{'sc_newPaymentGatewayToinstall'});
    my $src_location = "http://www.agoracart.com/downloadupdates/$filename";


  if ($in{'sc_newPaymentGatewayToinstall'} ne '') {

      if ($in{'installpguserlib'}) {
         my $local_save = "$sc_admin_dir/$filename"."-user_lib.pl";
         my $target_file = "$src_location"."-user_lib.txt";
         getstore("$target_file","./$local_save");
      }
      if ($in{'installpgorderform'}) {
         my $local_save = "$sc_html_dir/forms/$filename"."-orderform.html";
         my $target_file = "$src_location"."-orderform.txt";
         getstore("$target_file","./$local_save");
      }
      if ($in{'installpgorderlib'}) {
         my $local_save = "$sc_lib_dir/$filename"."-order_lib.pl";
         my $target_file = "$src_location"."-order_lib.txt";
         getstore("$target_file","./$local_save");
      }
      if ($in{'installpgmgrlib'}) {
         my $local_save = "$sc_lib_dir/$filename"."-mgr_lib.pl";
         my $target_file = "$src_location"."-mgr_lib.txt";
         getstore("$target_file","./$local_save");
      }
      if ($in{'installpgsecondorderlib'}) {
         my $local_save = "./add_ons/$filename"."-order_lib.pl";
         my $target_file = "$src_location"."-order_lib.txt";
         getstore("$target_file","./$local_save");
      }

      $updateErrorMessage = "Selected Gateway Files were installed.<br />"

  } else {
        $updateErrorMessage = "No Gateway Selected. Request Cancelled.<br />"
  }

  &display_gateway_install_page;
}
################################################################################
sub display_gateway_install_page {

  print &$manager_page_header("AgoraCart Payment Gateway Install - Remove","","","","");

  my $error1 = "Authorization Required";
  my $error2 = "This server could not verify";

  my $mylist_of_gateway_options = "";
  @gwlist = split(/\|/,$mc_gateways);
  foreach $item (@gwlist) {
    if ($item ne "") {
      $item_lc = $item;
      $item_lc =~ tr/A-Z/a-z/;
      $zlist{$item_lc} = "<OPTION>$item</OPTION>\n";
     } 
   }
  foreach $item (sort(keys %zlist)) {
    $mylist_of_gateway_options .= $zlist{$item};
   }

my $target_file = "http://www.agoracart.com/paygatesbasic.txt";
  my $file = get($target_file);
  my @line = split(/\n/, $file);
  foreach $line (@line) {
    chomp $line;
    $mylist_of_new_gateways .= qq~<option value="$line">$line</option>\n~;
  }


if($in{'system_edit_success'} ne "")
{
print <<ENDOFTEXT;
<CENTER><br>
<TABLE>
<TR>
<TD>
<FONT FACE=ARIAL SIZE=2 COLOR=RED>Updates Attempted:<br />$updateErrorMessage</FONT>
</TD>
</TR>
</TABLE>
</CENTER>
ENDOFTEXT
}

print qq~
<table border="0" cellpadding="9" cellspacing="0">
<tr>
<td colspan=3><hr /></td>
</tr>
<tr>
<td width=20%><font face=arial>
<b>Select a Payment Gateway to Install or Re-Install: </b>
</td><td><font face=arial>
<br />
<form action="manager.cgi" method="post">
<select name=sc_newPaymentGatewayToinstall>
<option></option>
$mylist_of_new_gateways
</select>
<br /><small><br />
<input type="checkbox" name="installpguserlib" value="1"> Install Blank Settings File<br />
<input type="checkbox" name="installpgorderform" value="1"> Install Default Order Form<br />
<input type="checkbox" name="installpgmgrlib" value="1"> Install Gateway Settings for Store Manager<br />
<input type="checkbox" name="installpgorderlib" value="1"> Install Order Processing Libraries<br />
<input type="checkbox" name="installpgsecondorderlib" value="1"> Install Order Processing Libraries for Secondary Gateway<br />&nbsp;&nbsp;&nbsp;&nbsp; (goes in add_ons sub-directory of your store)
</small>
</font>
</td>
<td><font face=arial>
<br />
<input type="hidden" name="system_edit_success" value="yes">
<input name="clicktoinstallpaymentgateway" type="submit" value="Click to Install as Selected">
</form>
<br />
</td>
</tr>
<tr><td></td>
<td colspan=2><font face=arial>
* <small>This section allows you to install new gateways or reinstall default files from existing gateways.  You can install any combination of the files as needed, even installing the order libs to use as a secondary payment option for your customers. If you have updated a gateway in the main upgrade manager, the secondary files in the add_ons directory of your store will not be upgraded automatically, so you will have to use this too and check only the box next to  "Install Order Processing Libraries for Secondary Gateway" box to update the secondary order lib files.  <b>NOTE:</b> if you install gateway files via this method, existing files for the selected gateway will be overwritten IF and only IF they exist already.  For example if you altered your order form previously for the Offline payment gateway and you select to install the order form option for the Offline gateway, your custom order form for the Offline gateway will be replaced with the deafult one. However, if you installed the order form for the NiftyPay gateway, your custom Offline Order form would go untouched.<br /><br />
<a href="http://www.agoracart.com/agorawiki/index.php?title=What_is_a_Payment_Gateway" target="_blank">What is a Payment Gateway</a>?  &nbsp;&nbsp; <a href="http://www.agoracart.com/agorawiki/index.php?title=Payment_Gateway_Basics_%26_x-comments">Payment Gateway Basics</a>
</small><br />
</font></td>
</tr>
<tr>
<td colspan=3><hr /></td>
</tr>
<tr>
<td width=20%><font face=arial>
<b>Select a Payment Gateway to Remove or Disable: </b>
</td><td><font face=arial>
<br />
<form action="manager.cgi" method="post">
<select name="sc_PaymentGatewayToremove">
<option></option>
$mylist_of_gateway_options
</select>
<br /><small><br />
<input type="checkbox" name="removepguserlib" value="1"> Remove Gateway Settings File<br />
<input type="checkbox" name="removepgorderform" value="1"> Remove Existing Order Form<br />
<input type="checkbox" name="removepgmgrlib" value="1"> Remove Gateway Settings Manager<br />
<input type="checkbox" name="removepgorderlib" value="1"> Remove Order Processing Libraries<br />
<input type="checkbox" name="removepgsecondorderlib" value="1"> Remove Order Processing Libraries for Secondary Gateway<br />&nbsp;&nbsp;&nbsp;&nbsp; (in add_ons sub-directory of your store)
</small>
</font>
</td>
<td><font face=arial>
<br />
<input type="hidden" name="system_edit_success" value="yes">
<input name="clicktoremovepaymentgateway" type="submit" value="Click to Remove as Selected">
</form>
<br />
</td>
</tr>
<tr><td></td>
<td colspan=2><font face=arial>
* <small>This section allows you to remove entire payment gateways or portions of existing gateways.  You can removel any combination of the files as needed, even the order libs used as a secondary payment option for your customers. Once the Manager Settings file for a gateway is removed, you can no longer remove files for that gateway, so make sure to delete all the desired gateway files before or at the same time as deleting this file.  Also, you can remove the secondary gateway libs from the add_ons sub-dir of your store, if present, using this tool, yet keep the gateway intact and functional as a primary gateway.  <b>NOTE: once you remove the file(s) for the selected gateway, it is gone forever, so make sure you select the correct gateway as there are no second chances with this tool.</b><br />
</small><br />
</font></td>
</tr>
<tr>
<td colspan=3><hr /></td>
</tr>
</table>
~;


  print &$manager_page_footer;

  &call_exit;
}
################################################################################
sub display_templates_install_page {
  print &$manager_page_header("AgoraCart Template and Skin Installer","","","","");

  $sm_templatelinks2 = qq~<option value=""></option>\n~;
  $sm_buttonsetlinks2 = qq~<option value=""></option>\n~;

    opendir (TEMPLATES, "$templates_file_dir"); 
    @myfiles = readdir(TEMPLATES); 
    closedir (TEMPLATES);
    foreach $zfile (@myfiles){
        if (!($zfile =~ /\./)) {
           $sm_templatelinks .= qq~<option value="$zfile">$zfile - Delete Entire Template</option>\n~;
           opendir (INTEMPLATES, "$templates_file_dir/$zfile"); 
           @myfiles2 = readdir(INTEMPLATES); 
           closedir (INTEMPLATES);
           foreach $zzfile (@myfiles2){
             if (!($zzfile =~ /\./)) {
                $sm_templatelinks .= qq~<option value="$zfile/$zzfile">$zzfile - This Skin Only</option>\n~;
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

if($in{'system_edit_success'} ne "")
{
print <<ENDOFTEXT;
<CENTER><br>
<TABLE>
<TR>
<TD>
<FONT FACE=ARIAL SIZE=2 COLOR=RED>Updates Attempted: $updateErrorMessage</FONT>
</TD>
</TR>
</TABLE>
</CENTER>
ENDOFTEXT
}

  my $target_file2 = "http://www.agoracart.com/templatesbasic.txt";
  use LWP::Simple;
  my $file = get($target_file2);
  @line = split(/\n/, $file);
  foreach $line (@line) {
     chomp $line;
     $sm_templatelinks2 .= qq~<option value="$line">$line</option>\n~;
  }

  my $target_file3 = "http://www.agoracart.com/buttonsbasic.txt";
  my $file2 = get($target_file3);
  @line = split(/\n/, $file2);
  foreach $line (@line) {
     chomp $line;
     $sm_buttonsetlinks2 .= qq~<option value="$line">$line</option>\n~;
  }


print qq~
<table border="0" cellpadding="9" cellspacing="0">
<tr>
<td colspan=3><hr /></td>
</tr>
<tr>
<td width=20%><font face=arial>
<b>Select a Template: </b>
</td><td>
<br />
<form action="manager.cgi" method="post">
<select name=sc_newheaderTemplateName>
<option></option>
$sm_templatelinks2
</select>
<input type="hidden" name="system_edit_success" value="yes">
<input name="clickinstallnewtemplateset" type="submit" value="Click to Install">
</form>
<br />
</td>
<td><font face=arial>
<br />
<form action="manager.cgi" method="post">
<select name=sc_removeheaderTemplateName>
<option></option>
$sm_templatelinks
</select>
<input type="hidden" name="system_edit_success" value="yes">
<input name="clicktoremovetemplateset" type="submit" value="Click to Remove">
</form>
<br />
</td>
</tr>
<tr>
<td colspan=3><font face=arial>
<div align="center"><small><a href="http://www.agoracart.com/templates.html" target="_blank">Samples: Free Templates</a><br /><br /></small></div>
* <small>These templates are the store header and footers for the main design.  Once installed, you can visit the "primary/main store settings manager" to select the newly installed template(s).  Only Templates not installed by default are shown in the install list, even if you deleted a default skin/template.  It is a comprehensive list of available <b>add-on</b> freebie templates.  Templates and skins may be installed via this interface or manually, see the various user forums and wiki for more information.  Note: if you have one of these templates installed, or a custom template with the same name, it will be overwritten and prior versions will be lost upon installation.  If your server does not support the automagic downloads, then you can manually upload the tarball (filename.tar) to the html/html-templates/templates sub-directory of your store in binary mode, then select the template name above and it will untar (aka unzip or uncompress) the template file for you. If nothing shows up, then there are NO additional add-on templates available yet.
</small><br />
</font></td>
</tr>
<tr>
<td colspan=3><hr /></td>
</tr>
<tr>
<td width=20%><font face=arial>
<b>Select a Button Set: </b></font>
</td><td>
<br />
<form action="manager.cgi" method="post">
<select name=sc_newbuttonSetName>
<option></option>
$sm_buttonsetlinks2
</select>

<input type="hidden" name="system_edit_success" value="yes">
<input name="clickinstallnewbuttonset" type="submit" value="Click to Install">
</form>
<br />
</font>
</td>
<td><font face=arial>
<br />
<form action="manager.cgi" method="post">
<select name=sc_removebuttonSetName>
<option></option>
$sm_buttonsetlinks
</select>
<input type="hidden" name="system_edit_success" value="yes">
<input name="clicktoremovebuttonset" type="submit" value="Click to Remove">
</form>
<br />
</td>
</tr>
<tr>
<td colspan=3><font face=arial>
<div align="center"><small><a href="http://www.agoracart.com/buttonsets.html" target="_blank">Samples: Free Button Sets</a><br /><br /></small></div>
* <small>These button sets are the images such as the add-to-cart buttons and similar themed images you find in your customer's shopping experience.  Once installed, you can visit the "primary/main store settings manager" to select the newly installed button set(s).  Only Button Sets not installed by default are shown on the install list, even if you previously deleted a default button set.  It is a comprehensive list of available <b>add-on</b> freebie button sets.  Button Sets may be installed via this interface or manually, see the various user forums and wiki for more information.  Note: if you have one of these button sets installed, or a custom button set with the same name, it will be overwritten and prior versions will be lost upon installation.  If your server does not support the automagic downloads, then you can manually upload the tarball (filename.tar) to the html/images/buttonsets sub-directory of your store in binary mode, then select the button set name above and it will untar (aka unzip or uncompress) the button set file for you. If nothing shows up, then there are NO additional add-on button sets available yet.</small><br />
* <small></small><br />
</font></td>
</tr>
<tr>
<td colspan=3><hr /></td>
</tr>
</table>
~;


  print &$manager_page_footer;

  &call_exit;
}
################################################################################
1; 
