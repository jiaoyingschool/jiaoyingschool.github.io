# file ./store/protected/main_settings-ext_lib.pl

$versions{'main_settings-ext_lib.pl'} = "5.2.006";
#######################################################################################
# Misc Variables
      use File::Copy;
$sc_mgrmiscmainfile = "$mgrdir/misc/mgr_miscmain.pl";
$templates_file_dir = "html/html-templates/templates";
$sm_templatelinks = '';
$sm_old_templateName = '';
$sc_buttonSetURLthingy = "./html/images/buttonsets";
  $stylename = "agorastyles.css";
  $templatestylename = "agoratemplate.css";
  $mc_meta_tags_css = qq~<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">~;
#######################################################################################

{
 local ($modname) = 'main_settings';
 if ($mc_change_main_settings_ok eq "") {
   $mc_change_main_settings_ok = "yes";
  }
 if ($mc_change_main_settings_ok =~ /yes/i) {
   &register_extension($modname,"AgoraCart Store Settings",$versions{$modname});
   &register_menu('main_settings_screen',"show_main_settings_screen",
  $modname,"Display Cart Settings");
   &register_menu('ChangeMainSettings',"action_input_main_settings",
  $modname,"Write Cart Settings");
   &register_menu('SelectGatewayScreen',"show_gateway_settings_screen",
  $modname,"Select Which Gateway to Edit");
   &register_menu('show_gateway_settings_screen',"show_gateway_settings_screen",
  $modname,"Display Gateway Settings Screen");
   &add_settings_choice("Payment Gateway"," Payment Gateway Settings ",
  "select_gateway_settings_screen");
&register_menu('select_gateway_settings_screen',"select_gateway_settings_screen",
  $modname,"Display Which Gateway to Edit choices");
   &register_menu('GatewaySettings',"write_gateway_settings",
  $modname,"Write Gateway Settings");
   &add_item_to_manager_menu("AgoraCart Management/Settings","change_settings_screen=yes",
  "");
  }
}
#######################################################################################
sub write_gateway_settings {

local($admin_email, $order_email);

&ReadParse;

if ($in{'gateway'} ne "") {
  $sc_gateway_name = $in{'gateway'};
  $sc_gateway_name =~ /([^\n]+)/; 
  $sc_gateway_name = $1;
 } else { 
  require "./admin_files/agora_user_lib.pl";
 }

$gateway_settings = "./admin_files/$sc_gateway_name-user_lib.pl";

$order_email = $in{'email_address_for_orders'}; 
$order_email =~ s/\@/\\@/g;

$admin_email = $in{'admin_email'};
$admin_email =~ s/\@/\\@/g;

&codehook("gateway_admin_settings");

&show_gateway_settings_screen;

}
################################################################################
sub select_gateway_settings_screen {

&make_lists_of_various_options;

print &$manager_page_header("Select Payment Gateway to Edit","","","","");

print <<ENDOFTEXT;
<center>
<hr />
</center>

<FORM METHOD="POST" ACTION="manager.cgi">
<center>
<TABLE BORDER=0 CELLPADDING=1 CELLSPACING=0 BORDER=0>
<tr>
<td colspan=2>
<FONT FACE=ARIAL>Welcome to the <b>AgoraCart</b> Payment Processing Gateway Settings Manager. Here you
will select the gateway you wish to change the settings (to set the primary gateway, use the main settings manager).</td>
</tr>


<tr>
<td colspan=2><font face=arial size=2><br /><br /><br />
<b>Please select the Payment Gateway settings you wish to change:</b>
<br />
<select name=gateway>
$mylist_of_gateway_options
</select> <input name="SelectGatewayScreen" TYPE="SUBMIT" value="Submit">
</font>
</td>
</tr>


</table></center><br /><br /><br /></form>
ENDOFTEXT
print &$manager_page_footer;
}
################################################################################
sub show_gateway_settings_screen {

local ($msg);

local($errs)=&html_eval_settings;

if ($in{'gateway'} ne "") {
  $sc_gateway_name = $in{'gateway'};
  $sc_gateway_name =~ /([^\n]+)/; 
  $sc_gateway_name = $1;
 }
eval("require './admin_files/$sc_gateway_name-user_lib.pl'");
if ($@ ne "") {
  $msg= "<br /><FONT COLOR=RED>GATEWAY USER LIB NOT FOUND!</FONT><br />\n";
 }

 
&codehook("gateway_admin_screen");

}
#######################################################################################
sub set_css_file_path{
  # Set the path to the style sheet
  $i=1;
  $mc_css_file_path = "";
  while($i<=$sc_levels_to_root)
  {
    $mc_css_file_path .= "../";
    $i++;
  }
}
#######################################################################################
sub action_input_main_settings{

local($admin_email, $order_email, $cookieDomain, $cookiePath);
local($temp_affiliate_call,$temp_affiliate_image_call,$temp_money_symbol,$sc_temp_affiliate_call2);
local($temp1,$temp2,$order_email5,$order_email6);
local($other_program_settings)="";
local($myset)="";
local($myset2)="";
local($myset3)="";

my $buysafe_header_string = qq|
<script src="https://sb.buysafe.com/private/rollover/rollover.js" type="text/javascript" language="javascript" charset="utf-8"></script>
<script type="text/javascript">
function buySAFEOnClick(WantsBond)
{
  document.cartForm.buySAFE.value = WantsBond;
  document.cartForm.submit();
}
</script>
|;

if ($sc_buySafe_is_enabled !~ /yes/i) {
   $buysafe_header_string = ""; 
}

&ReadParse;

$cookieDomain = $in{'sc_store_url'};
$cookiePath = $in{'sc_store_url'};

$cookieDomain =~ s/http.*:\/\///g;
$cookieDomain =~ s/\/.*//g;
$cookieDomain =~ s/\/agora.cgi//g;

$cookiePath =~ s/http.*:\/\/$cookieDomain//g;
$cookiePath =~ s/agora.cgi//g;
chop $cookiePath; # no trailing slash

$order_email = &my_escape($in{'email_address_for_orders'}); 
$admin_email = &my_escape($in{'admin_email'});
$sc_replyto_email_temp = &my_escape($in{'sc_replyto_email'});
$order_email5 = &my_escape($in{'second_email_address_for_orders'});
if ($in{'second_email_orders_yes_no'} =~ /yes/i) {
$order_email6 = "," . $order_email5;
$order_email = $order_email . $order_email6;
}

$myset = "";

if ($in{'sc_set_0077_umask'} =~ /yes/i) {
  $myset .= "\$sc_set_0077_umask = 'yes';\n";
  $myset .= "\$original_umask = umask 0077;\n";
 } else {
  $myset .= "\$sc_set_0077_umask = 'no';\n";
  $myset .= "\$original_umask = umask;\n";
 }

# moved to main settings by Mister Ed May 13, 2006
$myset .= "\$sc_number_days_keep_old_carts = \"$in{'sc_number_days_keep_old_carts'}\";\n";

$sc_gateway_name = "$in{'gateway_name'}";

$myset .= "\$sc_allow_ofn_choice = \"$in{'sc_allow_ofn_choice'}\";\n";
$myset .= "\$sc_gateway_name = \"$in{'gateway_name'}\";\n";
$myset .= "\$sc_replace_orderform_form_tags = \"$in{'sc_replace_orderform_form_tags'}\";\n";
$myset .= "\$sc_database_lib = \"$in{'database_lib'}\";\n";
$myset .= "\$sc_prod_db_pad_length = \"$in{'sc_prod_db_pad_length'}\";\n";
$myset2 .= "\$mc_first_time_user_to_agora_check2 = \"1\";\n";
$myset3 .= "\$mc_first_time_user_to_agora_check2 = \"1\";\n";
$temp1 = &my_stripout($in{'sc_minimum_order_amount'});
$temp2 = &my_stripout($in{'sc_minimum_order_text'});
$myset .= "\$sc_minimum_order_amount = \"$temp1\";\n";
$myset .= "\$sc_minimum_order_text = \"$temp2\";\n";
$myset .= "\$sc_prevent_zero_total_orders = \"$in{'sc_prevent_zero_total_orders'}\";\n";
$myset .= "\$sc_need_short_cart_id = \"$in{'sc_need_short_cart_id'}\";\n";
$myset .= "\$sc_use_international_latin_characters = \"$in{'sc_use_international_latin_characters'}\";\n";

if ($sc_use_database_subcats ne $in{'sc_use_database_subcats'}) {
    $sc_use_database_subcats = $in{'sc_use_database_subcats'};
    &category_list_builder_for_store;
}

$myset .= "\$sc_use_database_subcats = \"$in{'sc_use_database_subcats'}\";\n";
$myset .= "\$sc_subcat_index_field = \"$in{'sc_subcat_index_field'}\";\n";
$myset .= "\$sc_count_database_cats = \"$in{'sc_count_database_cats'}\";\n";


$myset .= "\$sc_http_affiliate_call = qq!$in{'sc_http_affiliate_call'}!;\n";
$sc_temp_affiliate_call2 = &my_escape($in{'sc_temp_affiliate_call'});
$myset .= "\$sc_temp_affiliate_call = \"$sc_temp_affiliate_call2\";\n";
if ($in{'sc_temp_affiliate_call'} ne "") {
$temp_affiliate_image_call = "<IMG SRC=\"" . $in{'sc_http_affiliate_call'}."://$sc_temp_affiliate_call\" border=0>";
$myset .= "\$sc_affiliate_image_call = qq|$temp_affiliate_image_call|;\n";
}
$myset .= "\$sc_send_order_to_email = \"$in{'email_orders_yes_no'}\";\n";
$myset .= "\$sc_second_send_order_to_email = \"$in{'second_email_orders_yes_no'}\";\n";

my $first_order_email = &my_escape($in{'email_address_for_orders'});
$myset .= "\$sc_order_email = \"$order_email\";\n";
$myset .= "\$sc_first_order_email = \"$first_order_email\";\n";
$myset .= "\$sc_second_order_email = \"$order_email5\";\n";
if ($in{'sc_email_content_type'}) {
    $myset .= "\$sc_email_content_type = \"$in{'sc_email_content_type'}\";\n";
} else {
    $myset .= "\$sc_email_content_type = \"text/plain\";\n";
}

$myset .= "\$sc_admin_email = \"$admin_email\";\n";

if ($sc_replyto_email_temp ne '') {
    $myset .= "\$sc_replyto_email = \"$sc_replyto_email_temp\";\n";
} else {
    $myset .= "\$sc_replyto_email = \"$admin_email\";\n";
}
$myset .= "\$sc_use_customer_email_over_admin = \"$in{'sc_use_customer_email_over_admin'}\";\n";
$myset .= "\$sc_use_dynamic_email_subjects = \"$in{'sc_use_dynamic_email_subjects'}\";\n";

$myset .= "\$sc_store_url = \"$in{'sc_store_url'}\";\n";
if ($in{'sc_ssl_location_url2'} eq '') {
   $in{'sc_ssl_location_url2'} = "$in{'sc_store_url'}";
} 
$myset .= "\$sc_ssl_location_url2 = \"$in{'sc_ssl_location_url2'}\";\n";
$myset .= "\$sc_stepone_order_script_url = \"$in{'sc_ssl_location_url2'}\";\n";
$myset .= "\$sc_domain_name_for_cookie = \"$cookieDomain\";\n";
$myset .= "\$sc_path_for_cookie = \"$cookiePath\";\n";
$myset .= "\$sc_self_serve_images = \"$in{'sc_self_serve_images'}\";\n";
if ($in{'sc_self_serve_images'} =~ /yes/i) {
  $myset .= "\$URL_of_images_directory = \"picserve.cgi?picserve=\";\n";
 } else {
  $myset .= "\$URL_of_images_directory = \"$in{'URL_of_images_directory'}\";\n";
}
$myset .= "\$sc_path_of_images_directory = \"$in{'URL_of_images_directory'}\";\n";
$myset .= "\$sc_shall_i_log_accesses = \"$in{'sc_shall_i_log_accesses'}\";\n";

$myset .= "\$sc_order_check_db = \"$in{'sc_order_check_db'}\";\n";
# security: options must match options file for database item
$myset .= "\$sc_negative_priced_options = \"$in{'sc_negative_priced_options'}\";\n";
$myset .= "\$sc_use_verified_opt_values = \"$in{'sc_use_verified_opt_values'}\";\n";
$myset .= "\$sc_disable_variable_options = \"$in{'sc_disable_variable_options'}\";\n";
$myset .= "\$sc_turn_off_option_price_display = \"$in{'sc_turn_off_option_price_display'}\";\n";
$myset .= "\$sc_enable_multi_load_option_files = \"$in{'sc_enable_multi_load_option_files'}\";\n";


$myset .= "\$sc_scramble_cc_info = \"$in{'scramble_cc_info'}\";\n";
$myset .= "\$sc_running_an_SSI_store = '$in{'running_an_SSI_store'}';\n";
$myset .= "\$sc_use_meta_cookies = '$in{'use_meta_cookies'}';\n";
$myset .= "\$sc_debug_mode = \"no\";\n";
$mc_images_dir = "$in{'mc_images_dir'}";
$myset2 .= "\$mc_images_dir = \"$in{'mc_images_dir'}\";\n";
$myset2 .= "\$mc_chmod_uploaded_images = \"$in{'mc_chmod_uploaded_images'}\";\n";

$sc_template_css_at_root = "$in{'sc_template_css_at_root'}";
$myset2 .= "\$sc_template_css_at_root = \"$sc_template_css_at_root\";\n";

#setting the path to the css file
$sm_levels_to_root = $sc_levels_to_root;
$sc_levels_to_root = "$in{'sc_levels_to_root'}";
$myset2 .= "\$sc_levels_to_root = \"$in{'sc_levels_to_root'}\";\n";
&set_css_file_path;

$myset2 .= "\$mc_css_file_path = \"$mc_css_file_path\";\n";

$sm_old_templateName = $sc_headerTemplateName;
$sc_headerTemplateName = $in{'sc_headerTemplateName'};
my $tempURLthingyForTemplates = "$templates_file_dir/$sc_headerTemplateName/$templatestylename";
my $tempURLthingyForTemplates2 =  "$templates_file_dir/$sc_headerTemplateName/$templatestylename";

my ($sc_headerTemplateRoot,$junk) = split (/\//, $sc_headerTemplateName);
$myset .= "\$sc_headerTemplateName = \"$in{'sc_headerTemplateName'}\";\n";
$myset .= "\$sc_headerTemplateRoot = \"$sc_headerTemplateRoot\";\n";

$sc_buttonSetName = $in{'sc_buttonSetName'};
$sc_buttonSetURL = "$URL_of_images_directory/buttonsets/$sc_buttonSetName";
$myset .= "\$sc_buttonSetName = \"$in{'sc_buttonSetName'}\";\n";
$myset .= "\$sc_buttonSetURL = \"$sc_buttonSetURL\";\n";
$myset .= "\$sc_displayDynamicCategories = \"$in{'sc_displayDynamicCategories'}\";\n";
$myset .= "\$sc_headerStoreTitle = \"$in{'sc_headerStoreTitle'}\";\n";
$myset .= "\$sc_headerStoreTagLine = \"$in{'sc_headerStoreTagLine'}\";\n";
$sc_store_header_file = "$sc_templates_dir/templates/$sc_headerTemplateRoot/store_header.html";
$sc_store_footer_file = "$sc_templates_dir/templates/$sc_headerTemplateRoot/store_footer.html";
$sc_secure_store_header_file = "$sc_templates_dir/templates/$sc_headerTemplateRoot/secure_store_header.html";
$sc_secure_store_footer_file = "$sc_templates_dir/templates/$sc_headerTemplateRoot/secure_store_footer.html";

$myset .= "\$sc_store_header_file = \"$sc_store_header_file\";\n";
$myset .= "\$sc_store_footer_file = \"$sc_store_footer_file\";\n";
$myset .= "\$sc_secure_store_header_file = \"$sc_secure_store_header_file\";\n";
$myset .= "\$sc_secure_store_footer_file = \"$sc_secure_store_footer_file\";\n";

if (($sc_headerTemplateName ne $sm_old_templateName) || ($sm_levels_to_root ne $sc_levels_to_root)) {

  # copy original CSS file for template change to location needed, if at alternate location
  # added by Mister Ed for 5.0.1 version fixes.
  if ($sc_template_css_at_root =~ /yes/i) {
      $tempURLthingyForTemplates2 = "$mc_css_file_path$templatestylename";
      copy($tempURLthingyForTemplates, $tempURLthingyForTemplates2);
  }
  my $temp_styles_url = "$mc_css_file_path$stylename";
  if (!(-e $temp_styles_url)  && (-e $stylename)) {
      copy($stylename, "$temp_styles_url");
  }
}

  # need to place all of that into the $sc_standard_head_info variable in the correct format
   $myset .= "\$sc_standard_head_info = qq|<link rel=\"stylesheet\" type=\"text/css\" href=\"$mc_css_file_path$stylename\" media=\"screen\">\n";
  $myset .= "<link rel=\"stylesheet\" type=\"text/css\" href=\"$tempURLthingyForTemplates2\" media=\"screen\">\n";
  $myset .= "$mc_meta_tags_css\n";
  $myset .= qq~$in{'mc_additional_head_info'}\n $buysafe_header_string\n|;\n~;

if ($sc_ssl_location_url2 ne ''){
  my $temp_SSL = $sc_ssl_location_url2;
  $temp_SSL =~ s/agora\.cgi//i;
  my $temp_SSL_CSS = $tempURLthingyForTemplates2;
  $temp_SSL_CSS =~ s/\.\.\///g;
  $myset .= "\$sc_secure_standard_head_info = qq|<link rel=\"stylesheet\" type=\"text/css\" href=\"$temp_SSL$stylename\" media=\"screen\">\n";
  $myset .= "<link rel=\"stylesheet\" type=\"text/css\" href=\"$temp_SSL$temp_SSL_CSS\" media=\"screen\">\n";
  $myset .= "$mc_meta_tags_css\n";
  $myset .= qq~$in{'mc_additional_head_info'}\n $buysafe_header_string\n|;\n~;
  $in{'mc_additional_head_info'} = &my_escape($in{'mc_additional_head_info'});
  $myset2 .= "\$mc_additional_head_info = qq|$in{'mc_additional_head_info'}|;\n";
} else {
  $myset .= "\$sc_secure_standard_head_info = qq|<link rel=\"stylesheet\" type=\"text/css\" href=\"$mc_css_file_path$stylename\" media=\"screen\">\n";
  $myset .= "<link rel=\"stylesheet\" type=\"text/css\" href=\"$tempURLthingyForTemplates2\" media=\"screen\">\n";
  $myset .= "$mc_meta_tags_css\n";
  $myset .= qq~$in{'mc_additional_head_info'}\n $buysafe_header_string \n|;\n~;
  $in{'mc_additional_head_info'} = &my_escape($in{'mc_additional_head_info'});
  $myset2 .= "\$mc_additional_head_info = qq|$in{'mc_additional_head_info'}|;\n";
}


  #DOCTYPE
  $myset .= "\$sc_doctype =  qq|$in{'sc_doctype'}|;\n";

&codehook("other_program_settings");
if ($other_program_settings ne "") {
  $myset .= "$other_program_settings\n";
 }

$myset2 .= "\$mgr_shall_i_log_accesses = \"$in{'sc_shall_i_log_accesses'}\";\n";
$myset2 .= "1;";
$myset3 .= "\$sc_shall_i_log_accesses = \"$in{'sc_shall_i_log_accesses'}\";\n";
$myset3 .= "1;";

&update_store_settings('MAIN',$myset); # main settings
&save_userlog_settings($myset3); # userlog settings
&update_mainmisc_settings('$sc_mgrmiscmainfile',$myset2);
&show_main_settings_screen;
}
#######################################################################################
sub show_main_settings_screen {

print &$manager_page_header("Main Store Settings","","","","");

&require_supporting_libraries(__FILE__,__LINE__,
  "$mgrdir/misc/mgr_miscmain.pl");

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
<center>
<hr />
</center>

<center>
<table>
<tr>
<td>
<FONT FACE=ARIAL>Welcome to the <b>AgoraCart</b> System Manager. Here you
will set the main data settings/variables specific to your store.</td>
</tr>
</table>
</center>

ENDOFTEXT

if($in{'system_edit_success'} ne "")
{
print <<ENDOFTEXT;
<center>
<table>
<tr>
<td><br />
<FONT FACE=ARIAL SIZE=2 COLOR=RED>System settings have been successfully updated.  Check/Edit your Primary Gateway Settings <a href=manager.cgi?show_gateway_settings_screen=$sc_gateway_name>here</a></FONT>
</td>
</tr>
</table>
</center>
ENDOFTEXT
}

&make_lists_of_various_options;

#set some defaults
   $test_result = eval("use LWP::Simple; 1;");
   if ($@ eq "") {
#     use LWP::Simple;
    } else {
     $Lib_message="<FONT COLOR=RED><b>WARNING:</b> LWP library was " .
                  "not found!  Choose one of the other options.</FONT><br />";
    }
#   $test_result = eval('require "./library/http-lib.pl"');
   if (!($http_lib_ok =~ /yes/i)) {
     $Lib_message .= "<FONT COLOR=RED>Couldn't load http-lib. " .   
                  "Choose one of the other options.</FONT><br />";
    } 
   $test_result = eval('&get_lynx_path("0")');
   if ($test_result eq "") {
     $Lib_message .= "<FONT COLOR=RED>Lynx was not found. " .     
                  "Choose one of the other options.</FONT><br />";
    } 

#if ($sc_path_of_images_directory ne "") {
# $URL_of_images_directory = $sc_path_of_images_directory;
#}

if ($sc_path_of_images_directory eq "") {
 $sc_path_of_images_directory =  $URL_of_images_directory;
}

if ($sc_allow_ofn_choice eq ""){
  $sc_allow_ofn_choice = "no";
 }
if ($sc_allow_ofn_choice =~ /yes/i){
  $sc_allow_ofn_choice = "yes";
  $sc_other_ofn = "no";
 } else {
  $sc_allow_ofn_choice = "no";
  $sc_other_ofn = "yes";
 }
if ($sc_debug_mode eq ""){
  $sc_debug_mode = "no";
 }
if ($sc_running_an_SSI_store eq ""){
  $sc_running_an_SSI_store = "no";
 }
if ($sc_use_meta_cookies eq ""){
  $sc_use_meta_cookies = "no";
 }
if ($sc_set_0077_umask eq ""){
  $sc_set_0077_umask = "no";
 }
if ($sc_set_0077_umask =~ /yes/i){
  $sc_set_0077_umask = "yes";
  $sc_other_0077 = "no";
 } else {
  $sc_set_0077_umask = "no";
  $sc_other_0077 = "yes";
 }
if ($sc_scramble_cc_info eq ""){
  $sc_scramble_cc_info = "no";
 }

if ($sc_doctype eq ""){
  $sc_doctype = qq~<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">~;
 }

if ($sc_use_international_latin_characters eq ""){
  $sc_use_international_latin_characters = "no";
 }
if ($sc_enable_multi_load_option_files eq ""){
  $sc_enable_multi_load_option_files = "no";
 }

print <<ENDOFTEXT;

<FONT FACE=ARIAL SIZE=2>
<FORM METHOD="POST" ACTION="manager.cgi">
<center>
<TABLE BORDER=0 CELLPADDING=1 CELLSPACING=0 BORDER=0>

<tr>
<td><br /></td>
</tr>
<tr>
<td colspan=4 bgcolor=#99CC99><center><font face="Arial, Helvetica, sans-serif" size=+2><b>Payment Gateway Section</b></font></center></td>
</tr>
<tr>
<td><br /></td>
</tr>

<tr>
<td colspan=2>
<b>Please select your Primary Payment Gateway:</b>
<br />
<small><a href="http://www.agoracart.com/agorawiki/index.php?title=What_is_a_Payment_Gateway" target="_blank">What is a Payment Gateway</a>?  &nbsp;&nbsp; <a href="http://www.agoracart.com/agorawiki/index.php?title=Payment_Gateway_Basics_%26_x-comments">Payment Gateway Basics</a></small>
<td colspan=2>
<select name=gateway_name>
$mylist_of_gateway_options
</select>
</td>
</tr>

<tr>
<td colspan=2><br /><b>Allow Multiple Gateways? </b> <small>This will automatically use the <b>combo-orderform.html</b> file so that customer can choose their preferred payment type, so you will need to edit that file for your payment types (can be 2 or more gateways).  For security reasons, it is a good idea
to delete any order forms from the "html/forms" sub-directory of your store for
gateways you are not planning to use. </small></td>
<td colspan=2><select name=sc_allow_ofn_choice>
<option selected>$sc_allow_ofn_choice</option>
<option>$sc_other_ofn</option> 
</select></td>
</tr>

<tr>
<td colspan=2><br /><b>Replace Order Form Tags?</b>  <small>This handles the submit button when displaying the order form.  Select yes to run a normal store operation.  Select "no" if having problems with multiple gateways going to the wrong gateway or back to the cart .  Default is yes.  Leave this as "yes" unless it corrects multiple gateway forms submission problems.</small></td>
<td colspan=2><select name=sc_replace_orderform_form_tags>
<option selected>$sc_replace_orderform_form_tags</option>
<option>yes</option>
<option>no</option>
</select></td>
</tr>

<tr>
<td><br /></td>
</tr>
<tr>
<td colspan=4 bgcolor=#99CC99 align=center><font face="Arial, Helvetica, sans-serif" size=+2><b>Database Section</b></font></td>
</tr>
<tr>
<td><br /></td>
</tr>

<tr>
<td colspan=4>
<b>Select your Database library and set the product database key pad length:</b>
<br />
Library: <select name=database_lib>
$mylist_of_database_libs
</select>
&nbsp;&nbsp;&nbsp;&nbsp;
Key Pad Length: <input name="sc_prod_db_pad_length" TYPE="TEXT" SIZE=1 
MAXLENGTH="2" value="$sc_prod_db_pad_length">
</td>
</tr>

<tr>
<td colspan=4><hr /></td>
</tr>

<tr>
<td colspan=4>
<b>Do you wish to use Product Sub Categories? </b> <select name=sc_use_database_subcats>
<option>$sc_use_database_subcats</option>
<option>No</option> 
<option>Yes</option> 
</select><br /><br />

<b>Select Product UserField you wish to Enter Sub Category Names in: </b><small>NOTE: when entering a product into multiple sub categories, separate sub catergory names with double colons (::) in the edit/add product manager screens. If you have subcat names of "Books" and "Used Books", they would be entered as: "Books::Used Books" in the UserField of choice.  Spaces allowed in the sub-category names. Only a single level of sub- categories available at this time (will be expanded later)</small> &nbsp;
<select name=sc_subcat_index_field>
<option>$sc_subcat_index_field
<option value="">None
<option>user2
<option>user3
<option>user4
<option>user5
$user10_thingy
$user20_thingy
</select>

<br /><br />
<b>Do you wish to use Count total products in Categories and Sub Categories? </b> <small>This will display the item counts in each category or sub category next to the title/name of the category, if using standard layouts and/or standard AgoraScript category display code.  NOTE: if you get multiples in product counts equal in proportion to the number of category lists on a page, remove the extra category lists in the headers, footers and page layouts or turn this feature off. <select name=sc_count_database_cats>
<option>$sc_count_database_cats</option>
<option>No</option> 
<option>Yes</option> 
</select><br /><br />
</td>
</tr>

<tr>
<td><br /></td>
</tr>
<tr>
<td colspan=4 bgcolor=#99CC99 align=center><font face="Arial, Helvetica, sans-serif" size=+2><b>Ordering/Checkout Controls Section</b></font></td>
</tr>
<tr>
<td><br /></td>
</tr>

<tr>
<td colspan=2><b>Minimum order:</b>  <small>If you wish to set a minimum order amount that customers must reach to complete an order, enter it here.  Otherwise, enter 0.  Do not add currency symbols as they will be stripped out in most cases.  indicate currency in the next box.</small></td>
<td colspan=2><input name="sc_minimum_order_amount" TYPE="TEXT" SIZE=10 
MAXLENGTH="10" value="$sc_minimum_order_amount"></td>
</tr>
<tr>
<td colspan=2><br /><b>Minimum order Currency Type:</b>  <small>Enter the currency type for the minimum order.  Spell it out.  Example: Euro, Dollars, Pounds, US Dollars, etc.</small></td>
<td colspan=2><input name="sc_minimum_order_text" TYPE="TEXT" SIZE=15 
MAXLENGTH="20" value="$sc_minimum_order_text"></td>
</tr>

<tr>
<td colspan=4><hr /></td>
</tr>

<tr>
<td colspan=4>
<b>Do you wish to display the prices of options? </b> <small>This allows you to turn off the display of prices for each option ordered on each product in the view cart contents screen as well as on the cart contents displayed at checkout.  Default is ON, even if nothing is selected in this setting.</small> <select name=sc_turn_off_option_price_display>
<option>$sc_turn_off_option_price_display</option>
<option>on</option> 
<option>off</option> 
</select>
</td>
</tr>

<tr>
<td colspan=4><hr /></td>
</tr>

<tr>
<td colspan=4>
<b>Do you wish to prevent Zero total orders? </b> <small>YES will prevent zero orders.  NO will allow you to take zero orders.</small> <select name=sc_prevent_zero_total_orders>
<option>$sc_prevent_zero_total_orders</option>
<option>No</option> 
<option>Yes</option> 
</select>
</td>
</tr>

<tr>
<td colspan=4><hr /></td>
</tr>

<tr>
<td colspan=4>
<b>Do you need shorter Cart ID numbers? </b> <small>NO is default, and ensures harder to guess order ID credentials (for increased security).  If your payment gateway requires shorter number for the "order ID" passed to them, then set this to YES.</small> <select name=sc_need_short_cart_id>
<option>$sc_need_short_cart_id</option>
<option>No</option> 
<option>Yes</option> 
</select>
</td>
</tr>


<tr>
<td colspan=4><hr /></td>
</tr>

<tr>
<td colspan=4>
<b>Allow International/Extended Latin Characters? </b> <small>YES will allow international latin based characters, useful when selling to countries such as those in Europe.  NO will only allow ASCII or normal English characters.  Default is NO for additional security purposes.  Additional characters allowed would be:<br />À Á Â Ã Ä Å Æ Ç Œ È É Ê Ë Ì Í Î Ï Ð Ñ Ò Ó Ô Õ Ö Ø Š Ù Ú Û Ü Ý Ÿ ß à á â ã ä å æ ç è ë ì í î ï ð ñ ò ó ô œ õ ö ø š ù ú û ü ý þ ÿ ž.</small> <br /><select name=sc_use_international_latin_characters>
<option>$sc_use_international_latin_characters</option>
<option>No</option> 
<option>Yes</option> 
</select>
</td>
</tr>

<tr>
<td><br /></td>
</tr>
<tr>
<td colspan=4 bgcolor=#99CC99 align=center><font face="Arial, Helvetica, sans-serif" size=+2><b>Image Serving Section</b></font></td>
</tr>
<tr>
<td><br /></td>
</tr>

<tr>
<td colspan=4>
<b>Please enter URL of your Store's images directory</b>.<br /><small>For example:<br />
<b>http://$ENV{'SERVER_NAME'}/store/html/images</b></small>  DO NOT include the trailing slash!!! <b>/</b>
</td>
</tr>

<tr>
<td colspan=4>
<input name="URL_of_images_directory" TYPE="TEXT" SIZE=60 
VALUE="$sc_path_of_images_directory"><br /><br /><small>
Hint: if you desire to use the \%\%URLofImages\%\% token in both
secure https and insecure http pages, then setup things so that
both use the same directory tree to access the images.  In this case, instead
of using the full URL (http://www.domain-name.com/store/html/images) just use the directory/file part, such as:<br />
<b>/store/html/images</b>(aka absolute path from your root web directory) or <b>html/images</b> (aka relative path from the agora.cgi file)<br /><br />
For faster image serving, enter the relative disk path from the location of the agora.cgi  file
(or the absolute path to the image) for your store's images directory (without the trailing slash) 
and set the next option to "yes" for self-serve of the images. If your images are stored outside your store directory, such as an graphics directory in your "root" directory for your website:<br /><b>www.domain-name.com/graphics</b><br />and your store was located in your cgi-bin like so:<br /><b>www.domain-name.com/cgi-bin/store</b><br />then you would need to go up two levels in your directory tree and then back down one.  Each level upwards is indicated by a set of: ../ , so the image location for serving your images would look like this:<br />
<b>../../graphics</b> with no trailing slash.</small><br /><br /><br />
<b>Do you want to self-serve the images?</b> &nbsp; <select name=sc_self_serve_images>
<option>$sc_self_serve_images</option>
<option>No</option> 
<option>Yes</option> 
</select> <br /><small> Say NO unless you have some good reason to use this images serving feature.&nbsp; One reason
would be that your server will not serve images from your cgi-bin directory (or where the store is currently installed at) and for some reason you do not desire to move them outside of the store directory areas.  <b>Speed Enhancement:</b> Your store will run faster with this set to no.</small>
</td>
</tr>
<tr>
<td colspan=4><hr /></td>
</tr>
<tr>
<td colspan=2><font face="Arial, Helvetica, sans-serif" size=2>
Because the store can have a disk or http directory path for images, and manager needs disk path, we set this variable here to point to be the disk path to the images directory. 
</font></td><td  colspan=2>
&nbsp;<input name="mc_images_dir" TYPE="TEXT" SIZE=12 
MAXLENGTH="30" value="$mc_images_dir"><br /><br />
</td>
</tr>

<tr>
<td><br /></td>
</tr>
<tr>
<td colspan=4 bgcolor=#99CC99 align=center><font face="Arial, Helvetica, sans-serif" size=+2><b>Store URL Section</b></font></td>
</tr>
<tr>
<td><br /></td>
</tr>

<tr>
<td colspan=4>
<b>Please enter the full URL of your store here.</b>  <small>Note: according to 
browser cookie implementation rules, you must have at least two dots in 
the name of the host for cookies to work properly for domains such as 
.com, .org, .net, etc.<br />
(ex: <b>http://www.$ENV{'SERVER_NAME'}/store52/agora.cgi</b>)</small>
</td>
</tr>

<tr>
<td colspan=4><br />
<b>Store URL</b>: <input name="sc_store_url" TYPE="TEXT" SIZE=60 
MAXLENGTH="128" value="$sc_store_url">
</td>
</tr>

<tr>
<td colspan=4><br />
<b>SSL URL</b>: <input name="sc_ssl_location_url2" TYPE="TEXT" SIZE=60 
MAXLENGTH="128" value="$sc_ssl_location_url2"><br /><small>If not using SSL, leave blank and the normal store URL will be used.<br />Shared SSL hosting, enter the SSL URL in form of: https://www.SSL-server-URL-here.com/~accountname/directory-of-store/agora.cgi.  (Make sure this URL matches what your hosting provider issued to you.)   If SSL runs under your domain name (you bought an SSL certificate), then enter the SSL URL in the form of:  https://www.yourDomanNameHere.com/directory-of-store/agora.cgi</small>
</td>
</tr>

<tr>
<td><br /></td>
</tr>
<tr>
<td colspan=4 bgcolor=#99CC99 align=center><font face="Arial, Helvetica, sans-serif" size=+2><b>Store CSS File Location Settings</b></font></td>
</tr>
<tr>
<td><br /></td>
</tr>


<tr>
<td colspan="2"><br/><b>Number of levels between agora.cgi and the CSS file.</b><br/><font face="Arial, Helvetica, sans-serif" size=2>
By default the CSS file ($stylename) is installed in the <em>store</em> dir along 
with the agora.cgi file. If you've moved the CSS file from this location please 
specify the number of levels to access it. Also if the <em>store</em> dir is 
inside of the cgi-bin you may have to move the CSS file to the root dir. To do so 
simply adjust the levels to the CSS file below to take you outside of the cgi-bin.<br/></font>
<small>Examples:<br/>
location of agora.cgi -> http://www.domain.com/cgi-bin/store/<br/>
location of css file ---> http://www.domain.com/<br/>
Number of levels would be <b>2</b>.</small><br/><br/>
<b>Number of Levels to CSS file:</b>
<select name="sc_levels_to_root">
<option>$sc_levels_to_root</option>
<option>0</option>
<option>1</option>
<option>2</option>
<option>3</option>
<option>4</option>
<option>5</option>
<option>6</option>
</select>
<br /><br />
<b>Do you need to make a copy of the template CSS file in same location as the main CSS file?</b>
<select name="sc_template_css_at_root">
<option>$sc_template_css_at_root</option>
<option>no</option>
<option>yes</option>
</select>
</td>
</tr>

<tr>
<td><br /></td>
</tr>
<tr>
<td colspan=4 bgcolor=#99CC99 align=center><font face="Arial, Helvetica, sans-serif" size=+2><b>Store Header Settings - Misc</b></font></td>
</tr>
<tr>
<td><br /></td>
</tr>

<tr>
<td colspan="2"><b>Doc Type</b><br/><font face="Arial, Helvetica, sans-serif" size=2>
This is the html doc type to be included on all your pages</font>
<br/>
Example: <b>&lt;!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"&gt;</b><br/>
<TEXTAREA name="sc_doctype" 
cols="68" rows="2">$sc_doctype</TEXTAREA></td>
</tr>

<tr>
<td colspan="2"><b>Additional items to be included inside of the &lt;head&gt; section</b><br/><font face="Arial, Helvetica, sans-serif" size=2>
This would be where you include any <b>javascript</b> or <b>meta tags</b> you wish to show up on
all pages thoughout the entire site. You can also enter additional style sheets, just 
make sure there are no confliting entries between the two.</font>
<small>DO NOT enter the full web path, instead enter it in the form ../../. 
If you include the hostname and try running in secure mode you might have issues 
with getting the padlock to show up.</small><br/>
Example: <b>&lt;script type="text/javascript" language="javascript" 
src="../../scripts/functions.js"&gt;&lt;/script&gt;</b><br/>
<TEXTAREA name="mc_additional_head_info" 
cols="68" rows="5">$mc_additional_head_info</TEXTAREA></td>
</tr>

<tr>
<td><br /></td>
</tr>
<tr>
<td colspan=4 bgcolor=#99CC99 align=center><font face="Arial, Helvetica, sans-serif" size=+2><b>Store Header/Footer/Buttons Section</b></font></td>
</tr>
<tr>
<td><br /></td>
</tr>
<tr>
<td colspan="2"><font face="Arial, Helvetica, sans-serif" size=2>
This area allows you to chose a header and footer template that will be used by default in the design/look of your store (basically the default design applied store wide unless customized pages are found).  Using your own headers/footers is fairly easy, but not recommended for those without HTML editing experience. For faster setup, use a template already available<br /><br /> <i>NOTE: You can use your own templates if you wish, but this will require you to create your own headers and footers and upload them to the store's html/html-templates/templates/Custom sub directory and then put the .css file for your custom look in the html/html-templates/templates/Custom/CustomOne sub directory of your store (one more level down).   The Custom/CustomOne sub-directory names can be anything you like, such as CompanyName/SpringSaleTemplate, CompanyName/XmasTemplate, etc.  If you wish to use custom header and/or footer files by category name, you will need to create those files separately and place them in the html/html-templates sub directory of your store (using the formats of header-CATEGORY-NAME-HERE.inc and/or footer-CATEGORY-NAME-HERE.inc, which is auto-detected automatically if enabled in the <a href="manager.cgi?change_store_layout_screen=yes">Layout & Design Settings - Misc</a> Manager).  Make sure to upload all HTML and CSS files in ASCII mode.</i></font>
</td>
</tr>
<tr>
<td>
<b>Select a Template: </b>
</td><td>
<br />
<select name=sc_headerTemplateName>
<option selected>$sc_headerTemplateName</option>
$sm_templatelinks
</select>
<br /><br />
</td>
</tr>
<tr>
<td colspan=2><hr /></td>
</tr>
<tr>
<td>
<b>Select a Button Set: </b></font>
</td><td>
<br />
<select name=sc_buttonSetName>
<option selected>$sc_buttonSetName</option>
$sm_buttonsetlinks
</select>
<br /><br />
</td>
</tr>
<tr>
<td colspan=2><hr /></td>
</tr>
<tr>
<td>
<b>Display Categories</b> (and sub categories if enabed)<b>?</b> 
</td><td>
<br />
<select name=sc_displayDynamicCategories>
<option selected>$sc_displayDynamicCategories</option>
<option>yes</option>
<option>no</option>
</select>

<br /><br />
</td>
</tr>
<tr>
<td colspan=2><hr /></td>
</tr>
<tr>
<td colspan="2">
<b>Store Name and Tag Line:</b><br />
<small>This is the store name/title diplayed to your customers in the heading of the template. Do not use special metacharacters (\$,%,&,\@ etc). 45 characters max.    The shorter the better to ensure the store template does not get distorted due to the long text line. Leave blank if you do not want this line to show.</small>:
<br />
<input type=TEXT SIZE=45 maxlength=45 name="sc_headerStoreTitle" value="$sc_headerStoreTitle">
<br /><br />
</td>
</tr>
<tr>
<td colspan=2><hr /></td>
</tr>
<tr>
<td colspan=2>
<b>Tag Line:</b><br />
<small>This is located just beneath the Store title listed above. Do not use special metacharacters (\$,%,&,\@ etc).  60 characters max.  The shorter the better to ensure the store template does not get distorted due to the long text line. Leave blank if you do not want this line to show.</small>:
<br />
<input type=TEXT SIZE=45 maxlength=60 name="sc_headerStoreTagLine" value="$sc_headerStoreTagLine">
<br /><br />
</td>
</tr>



<tr>
<td><br /></td>
</tr>

<tr>
<td colspan=4 bgcolor=#99CC99><center><font face="Arial, Helvetica, sans-serif" size=+2><b>Order Logging / Confirmation Emails Section</b></font></center></td>
</tr>
<tr>
<td><br /></td>
</tr>

<tr>
<td colspan=2><b>Do you wish to have orders e-mailed to you?</b><br /><small>NOTE: some hosting services may require that the email addresses your scripts use to be on the same domain and/or server for security and anti-spamming purposes.  Basically, this means that your store and confirmation emails might need to be on the same server and/or hosting account.  If this is the case, setup a forwarding address on your hosting account / domain name to forward order confirmations to the external email address you wish to use and then enter that "forwarder" email address here.</small></td>
<td colspan=2><select name="email_orders_yes_no">
<option>$sc_send_order_to_email</option>
<option>yes</option>
<option>no</option>
</select></td></tr>
<tr><td colspan=4>Email Address to use: <INPUT 
NAME="email_address_for_orders" TYPE="TEXT" 
VALUE="$sc_first_order_email" SIZE="70">
</td>
</tr>
<tr>
<td colspan=4><br /></td>
</tr>
<tr>
<td colspan=2><b>Do you wish to have orders e-mailed to a second email address?</b><br /><small>NOTE: see note above for primary confirmation email address.</small></td>
<td colspan=2><select name="second_email_orders_yes_no">
<option>$sc_second_send_order_to_email</option>
<option>yes</option>
<option>no</option>
</select></td></tr>
<tr><td colspan=4><b>Email Address to use:</b> <INPUT 
NAME="second_email_address_for_orders" TYPE="TEXT" 
VALUE="$sc_second_order_email" SIZE="70">
</td>
</tr>

<tr>
<td colspan=4><hr /></td>
</tr>

<tr>
<td colspan=4>
<b>Enter the e-mail address of your webmaster or administrator here</b><br /><small>NOTE: Must be on same server and/or hosting account as store resides (same domain name or a parked domain name). If one does not exist, create a forwarded admin email address for your store in your hosting account control panel.</small>
</td>
<tr>
<td colspan="2">
<input name="admin_email" TYPE="TEXT" value="$sc_admin_email" SIZE="70">
</td>
</tr>
<tr>
<td colspan=4><hr /></td>
</tr>
<tr>
<td colspan=4>
<b>Enter the e-mail address you wish to list as to use as teh Reply To email address on emails sent to customers</b><br /><small>NOTE: if left blank, the admin address listed above will be used. Used by default (by mail-lib.pl), otherwise it is ignored unless if you switch mail libraries manually in the agora.setup.db file.</small>
</td>

<tr>
<td colspan="2">
<input name="sc_replyto_email" TYPE="TEXT" value="$sc_replyto_email" SIZE="55">
</td>
</tr>



<tr>
<td colspan=4><hr /></td>
</tr>
<tr>
<td colspan=2><br /><b>Do you wish to have admin emails shown as "From" the customer?</b><br /><small>Order confirmation emails to the admin(s) will show the admin email address in the from field of an email by default. This allows you to use the customer's email address instead of the admin's email address. Applies only to emails to the admin when an order confirmation is to be emailed. Also, if you have problems receiving the emails after changing this, you might be restricted by your server and must use an admin email address that is linked to or based on your hosting account (domain names used on your hosting account). Default is no.</small></td>
<td colspan=2><br /><select name="sc_use_customer_email_over_admin">
<option>$sc_use_customer_email_over_admin</option>
<option>no</option>
<option>yes</option>
</select></td></tr>

<tr>
<td colspan=4><hr /></td>
</tr>

<tr>
<td colspan=2>
<b>Do you wish to use dynamic email subjects?</b><br /><small>Advanced Feature. Some add-ons require this to be set to YES.  Default is NO.  Test and check emails prior to going live with this feature to ensure it does what you expect.</small></td>
<td colspan=2><select name="sc_use_dynamic_email_subjects">
<option>$sc_use_dynamic_email_subjects</option>
<option>yes</option>
<option>no</option>
</select></td></tr>

<tr>
<td><br /></td>
</tr>
<tr>
<td colspan=4 bgcolor=#99CC99 align=center><font face="Arial, Helvetica, sans-serif" size=+2><b>Misc Main Settings Section</b></font></td>
</tr>
<tr>
<td><br /></td>
</tr>

<tr>
<td colspan=2><b>How long do you wish to keep pevious cart contents (and server side cookies) for non-finalized orders?</b>. <small>This is the record of what was added to the cart, as well as other info such as the cart ID, in case a payment is delayed and/or the customer wishes to come back later and resume shopping.  These files are automagically deleted once the order is completed or the time set for expiration of these customer cart files is reached.  Default is is 1 day.  If using a payment gateway that reports back pending payments at a later date/time (such as authorizations only, ACH payments, eChecks, and/or PayPal IPN), set this to a suggested time of 5 days.  Fractional days acceptable as well, such as .25 (6 hours), .5 (12hours), 1.75 (1 day and 18 hours), etc.  Warning: do not exceed 7 days if your site is very busy.</small></td>
<td colspan=2>
<input name="sc_number_days_keep_old_carts" TYPE="TEXT" 
VALUE="$sc_number_days_keep_old_carts" SIZE="10" maxlength="10"></td>
</tr>

<tr>
<td colspan=4><hr /></td>
</tr>

<tr>
<td colspan=2><b>Do you wish to log unique accesses to your store?</b>. <small>Default is yes.  Setting to "no" will disable the menu item as well.  To see the results of this setting in the manager menus at the top of each page, reload a page after saving these settings. <b>Speed Enhancement:</b> Your store will run faster with this set to no.</small></td>
<td colspan=2><select name="sc_shall_i_log_accesses">
<option>$sc_shall_i_log_accesses</option>
<option>yes</option>
<option>no</option>
</select></td>
</tr>

<tr>
<td colspan=4><hr /></td>
</tr>

<tr>
<td colspan=4>
if using an affiliate program, <b>Enter your image call info</b>:
<br /><small>in the form of: locationURLtoImage?ordertotal=AMOUNT&unique=UNIQUE&otherneededinfo .  edit as needed.  do not enter: &lt;IMG SRC="https:// or the "
BORDER=0&gt; portions of the image call as those are added automatically. For the total, AMOUNT will be substituted by the cart with the subtotal before taxes and shipping.  If you need a different amount or total, such as from the profit tracker add-on, you will need to edit the order library file for your gateway(s) directly.  For the UNIQUE portion, the invoice number will be used by the cart automatically.  Also add whatever else is needed by your affiliate program for the image call.</small><br />
<select name=sc_http_affiliate_call>
<option>$sc_http_affiliate_call</option>
<option>http</option>
<option>https</option>
</select>&nbsp;&nbsp;&nbsp;
tag info: <input name="sc_temp_affiliate_call" TYPE="TEXT" SIZE=45 
MAXLENGTH="225" value="$sc_temp_affiliate_call">
</td>
</tr>

<input type="HIDDEN" name="running_an_SSI_store" value="no">
<input type="HIDDEN" name="use_meta_cookies" value="no">

<tr>
<td><br /></td>
</tr>
<tr>
<td colspan=4 bgcolor=#99CC99 align=center><font face="Arial, Helvetica, sans-serif" size=+2><b>Security Section</b></font></td>
</tr>
<tr>
<td><br /></td>
</tr>

<tr>
<td colspan=2><b>Do you wish to verify orders with the database info?</b>  <small>Say "no" 
if running an HTML-based store without a database or adding to the cart from non-agora.cgi parsed pages. NOTE: links to cart and database still need to come from the same domain name as AgoraCart runs from</small></td>
<td colspan=2><select name="sc_order_check_db">
<option>$sc_order_check_db</option>
<option>yes</option>
<option>no</option>
</select></td>
</tr>

<tr>
<td colspan=4><hr /></td>
</tr>

<tr>
<td colspan=2><b>Use Verified Option Values?</b>  <small>For security reasons it is a good idea to say YES here.  This will check options (pricing and names) on products ordered against the values found in the actual options file that is listed with the product in the database. If you use dynamic options (those files built via dynamically with multiple files), then set this to NO.  NOTE: this feature currently does not verify the more advanced variable options.</small></td>
<td colspan=2><select name=sc_use_verified_opt_values>
<option selected>$sc_use_verified_opt_values</option>
<option>yes</option>
<option>no</option> 
</select></td>
</tr>
<tr>
<td colspan=4><br /></td>
</tr>
<tr>
<td colspan=2><b>Prevent Negative Priced Options?</b>  <small>For security reasons it is a good idea
to say YES here. This will disallow negative priced options.  If having problems with variable option discounts, set to NO</small></td>
<td colspan=2><select name=sc_negative_priced_options>
<option selected>$sc_negative_priced_options</option>
<option>yes</option>
<option>no</option> 
</select></td>
</tr>
<tr>
<td colspan=4><br /></td>
</tr>
<tr>
<td colspan=2><b>Turnoff Variable Options?</b>  <small>If you are not using Variable Options, then set to YES. This will increase the speed and security of your store if disabled (set to yes).  These are different than standard options listed above that are used by most users.   Variable options allow for discount or volume pricing, per an individual product, as well as other advanced option capabilites, but requires AgoraScript/Perl coding and manual edits/customization of the individual product option files.  Default is NO, which enables the use of variable options.</small></td>
<td colspan=2><select name=sc_disable_variable_options>
<option selected>$sc_disable_variable_options</option>
<option>yes</option>
<option>no</option> 
</select></td>
</tr>

<tr>
<td colspan=4><br /></td>
</tr>
<tr>
<td colspan=2><b>Allow more than one instance of an Option File loaded per product with %%Load_Option_file%% tokens?</b> (aka nested option loading) <small>This is an Advanced Feature. Default is NO.  If you have numerous option files that share common elements, setting this to YES will allow you to load the option file more than once per product using <b>%%Load_Option_file option-file-name.html%%</b> within the already called option files.  The error indicator will look like: <b>(reload of option graphicSelect.html attempted!)</b> where the option file would be expected to be displayed.  This error means that you are trying to load the option files inside of one another. If unsure how this works, leave at NO as it is not recommended unless absolutely necessary for more complex stores.</small></td>
<td colspan=2><select name=sc_enable_multi_load_option_files>
<option selected>$sc_enable_multi_load_option_files</option>
<option>yes</option>
<option>no</option> 
</select></td>
</tr>

<tr>
<td colspan=4><hr /></td>
</tr>

<tr>
<td colspan=2><b>Use 0077 umask?</b>  <small>(NOTE: Most installs of the cart can skip this setting and leave it at NO.)  For security reasons it is a good idea
to say yes here if the cgi scripts on your Unix host 
run under your own id.  If you are having problems with files not deleting or being read (cart files, cart cookies, order files, etc), then set to NO.  If you setup your cart via a control panel (Cpanel) or it is based on a Linux operating system, then leave at the default of NO, as your system admin may have already set your file access  "rights" correctly.</small></td>
<td colspan=2><select name=sc_set_0077_umask>
<option selected>$sc_set_0077_umask</option>
<option>$sc_other_0077</option> 
</select></td>
</tr>

<tr>
<td colspan=4><hr /></td>
</tr>

<tr>
<td colspan=2><b>Scramble CC Info?</b> <small> This option scrambles the CC info that
is stored on disk temporarily in the VERIFY files in Offline and other
gateways that take CC info on your server.  Set to YES unless you have
trouble with blank CC numbers in confirmation emails <b>and</b> you are
sure that the VERIFY files are safe from prying eyes.</small></td>
<td colspan=2><select name=scramble_cc_info>
<option>$sc_scramble_cc_info</option>
<option>yes</option> 
<option>no</option> 
</select></td>
</tr>

<tr>
<td colspan=4><hr /></td>
</tr>

<tr>
<td colspan=4>
<center>
<input type="HIDDEN" name="system_edit_success" value="yes">
<input name="ChangeMainSettings" TYPE="SUBMIT" value="Submit">
&nbsp;&nbsp;
<input type="RESET" value="Reset">
</center>
</td>
</tr>

<tr>
<td colspan=4>
<hr />
</td>
</tr>

</table>

</center>
</form>
ENDOFTEXT
print &$manager_page_footer;
}
#######################################################################################
sub update_mainmisc_settings {
  local($item,$stuff) = @_;
  $mainmisc_file_settings{$item} = $stuff;
local($mainmisc_settings) = "$mgrdir/misc/mgr_miscmain.pl";
  local($item,$zitem);

  &get_file_lock("$mainmisc_settings.lockfile");
  open(MAINFILE,">$mainmisc_settings") || &my_die("Can't Open $mainmisc_settings");
  foreach $zitem (sort(keys %mainmisc_file_settings)) {
    $item = $zitem;
     print (MAINFILE $mainmisc_file_settings{$zitem});
   }
  close(MAINFILE);
  &release_file_lock("$mainmisc_settings.lockfile");
 }
#######################################################################################
sub save_userlog_settings {
 local($item) = @_;
  local($userlog_settings) = "./admin_files/agora_userlog_lib.pl";

  &get_file_lock("$userlog_settings.lockfile");
  open(LOGSETTINGS,">$userlog_settings") || &my_die("Can't Open $userlog_settings");
    print (LOGSETTINGS $item);
  close(LOGSETTINGS);
  &release_file_lock("$userlog_settings.lockfile");
 }
#######################################################################################
1; # Library
