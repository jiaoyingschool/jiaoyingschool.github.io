# file ./store/protected/store_css_design-ext_lib.pl

$versions{'store_css_design-ext_lib.pl'} = "5.2.000";
#######################################################################################
# Misc Variables 
  $stylename = "agorastyles.css";
  $templatestylename = "agoratemplate.css";
#######################################################################################
{
 local ($modname) = 'store_css_design';
 &register_extension($modname,"Store CSS File Editor",$versions{$modname});
 &add_settings_choice("store CSS file editor","Store CSS File Editor",
  "store_design_editor_screen");
 &register_menu('store_design_editor_screen',"change_store_design_editor_screen",
  $modname,"Display CSS File Editor");
 &register_menu('ChangeStoreDesign',"action_change_design_settings",
  $modname,"Write CSS File Editor");
}

&require_supporting_libraries(__FILE__,__LINE__,
  "$mgrdir/misc/mgr_css.pl");
################################################################################
sub set_css_file_2path{
  # Set the path to the style sheet
  $i=1;
  $mc_css_file_path = "";
  while($i<=$mc_levels_to_root)
  {
    $mc_css_file_path .= "../";
    $i++;
  }
}
################################################################################
sub action_change_design_settings {
  my($info);
  local($css_file_path);
  my($myset,$myset2)="";

  &ReadParse;

&require_supporting_libraries(__FILE__,__LINE__,
  "$mgrdir/misc/mgr_miscmain.pl");

  my $tempURLthingyForTemplates = "html/html-templates/templates/$sc_headerTemplateName/$templatestylename";

  #setting the path to the css file
  &set_css_file_path;


  if ($mc_template_css_at_root =~ /yes/i) {
      $tempURLthingyForTemplates = "$mc_css_file_path$templatestylename";
  }

  #manager row count display
  $myset2 .= "\$mc_css_row_count = \"$in{'mc_css_row_count'}\";\n";

  #update the CSS file  
  $new_css_file = "$in{'changed_css_file'}";
  open (NEWCSSFILE,'>', "$mc_css_file_path$stylename");
    print NEWCSSFILE $new_css_file;
  close (NEWCSSFILE);

  $new_css_file = "$in{'changed_template_css_file'}";
  open (NEWCSSFILE,'>', "$tempURLthingyForTemplates");
    print NEWCSSFILE $new_css_file;
  close (NEWCSSFILE);
  
    &update_CSS_MGR_settings("$mgrdir/misc/mgr_css.pl",$myset2); # mgr css settings
  &change_store_design_editor_screen;
 }


################################################################################
sub change_store_design_editor_screen
{
print &$manager_page_header("Store CSS Design Editor","","","","");

&set_css_file_2path;

print <<ENDOFTEXT;
<CENTER>
<HR>
</CENTER>

<FORM ACTION="manager.cgi" METHOD="POST">
<CENTER>
<TABLE>
<TR>
<TD>
<FONT FACE=ARIAL>Welcome to the <b>AgoraCart</b> System Manager
Storewide CSS Design settings.  This manager allows you to setup your 
main store CSS (cascading style sheet) by editing the files themselves.  See the <a href="manager.cgi?change_store_layout_screen=yes">Layout & Design Settings - Misc</a> Manager for other layout and design settings not covered here.</TD>
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

if ($mc_css_row_count < 4) {
  $mc_css_row_count=4;
 }
if ($mc_css_row_count >200) {
  $mc_css_row_count=200;
 }

print <<ENDOFTEXT;

<FONT FACE=ARIAL SIZE=2>
<CENTER>
<TABLE BORDER=0 CELLPADDING=1 CELLSPACING=0 BORDER=0>

<TR>
<TD COLSPAN=2><br /><HR/><br /></TD>
</TR>


<TR>
<TD COLSPAN="2" align=left>
Number of Rows to Display for Each File Below <small>(must save to update view)</small>: 
<INPUT TYPE=TEXT SIZE=5 
NAME="mc_css_row_count"
VALUE="$mc_css_row_count">
</TD>
</TR>
<TR>
<TD COLSPAN=2><br /><HR/><br /></TD>
</TR>
ENDOFTEXT
# set the path to the CSS File 
open (CSSFile, "< $mc_css_file_path$stylename");# || die ('Could not find file') ;
local $full_css_file;
   while(<CSSFile>) { 
     $full_css_file .= $_ ;
   }
close (CSSFile);
print <<ENDOFTEXT;

<TR>
<TD COLSPAN="2"><br>
Here are the current contents of the main CSS file located at: <em>$mc_css_file_path$stylename</em><br>
Feel free to do any edits using this interface, or you may download the CSS file
and make the changes manually.
<TEXTAREA NAME="changed_css_file" cols="68" 
rows="$mc_css_row_count"
wrap=off>$full_css_file</TEXTAREA> 
</TD>
</TR>

ENDOFTEXT

  my $tempURLthingyForTemplates = "html/html-templates/templates/$sc_headerTemplateName/$templatestylename";

  if (($mc_template_css_at_root =~ /yes/i) && (-e "$mc_css_file_path$templatestylename")) {
        $tempURLthingyForTemplates = "$mc_css_file_path$templatestylename";
  }
open (CSSTEMPLATEFile, "< $tempURLthingyForTemplates");# || die ('Could not find file') ;
local $full_template_css_file;
   while(<CSSTEMPLATEFile>) { 
     $full_template_css_file .= $_ ;
   }
close (CSSTEMPLATEFile);
print <<ENDOFTEXT;

<TR>
<TD COLSPAN="2"><br>
Here are the current contents of the template CSS file for your store header and footer located at:<br><em>$tempURLthingyForTemplates</em><br>
Feel free to do any edits using this interface, or you may download the CSS file
and make the changes manually.
<TEXTAREA NAME="changed_template_css_file" cols="68" 
rows="$mc_css_row_count"
wrap=off>$full_template_css_file</TEXTAREA> 
</TD>
</TR>


<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD COLSPAN=2>
<CENTER>
<INPUT TYPE="HIDDEN" NAME="system_edit_success" VALUE="yes">
<INPUT NAME="ChangeStoreDesign" TYPE="SUBMIT" VALUE="Submit">
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
################################################################################
sub update_CSS_MGR_settings {
  my($item,$stuff) = @_;
  $css_file_settings{$item} = $stuff;
local($css_settings) = "$mgrdir/misc/mgr_css.pl";
  my($item,$zitem);
  open(CSSFILE,">$css_settings") || &my_die("Can't Open $css_settings");
  foreach $zitem (sort(keys %css_file_settings)) {
    $item = $zitem;
     print (CSSFILE $css_file_settings{$zitem});
   }
  close(CSSFILE);
&require_supporting_libraries(__FILE__,__LINE__,
  "$mgrdir/misc/mgr_css.pl");
 }
#######################################################################################
1; # Library