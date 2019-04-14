#!/usr/bin/perl -T
$ENV{'PATH'}="/bin:/usr/bin"; 

#################################################################
# do not edit below this line         #
#################################################################

BEGIN { use lib "./library/additions"; push(@INC,"./library/additions"); }

$mgrdirname = "protected";
$mgrdir = "./$mgrdirname";
if ((-f "./wrap_mgr.o") && (!($ARGV[0] =~ /nowrap/i))) {
  print `./wrap_mgr.o`;
  &call_exit;
 }
$versions{'manager.cgi'}="5.2.005";
$manager_program_running = "yes";
chdir(".."); 
&setup_manager;
eval('require "./library/http-lib.pl"');
if ($@ eq "") {
  $http_lib_ok = "yes";
 } else {
  $http_lib_ok = "no";
 }
&get_required_config;
&require_supporting_libraries(__FILE__,__LINE__,
  "./library/cgi-lib.pl",
  "./library/agora.setup.db",
  "./admin_files/agora_user_lib.pl"); 
#added by Mister Ed October 2005
$scm_order_logpath = "./log_files/orders";
&require_supporting_libraries(__FILE__,__LINE__,
  "$sc_db_lib_path",
  "./library/shipping_lib.pl",
  "./library/cookie-lib.pl",
  "$mgrdir/misc/mgr_pass.pl",
  "$mgrdir/misc/mgr_miscmain.pl",
  "$mgrdir/store_admin_html.pl",
  "$mgrdir/store_admin_actions.pl");
&load_store_settings;
&load_custom("$mgrdir",'-ext_lib.pl');
&load_custom("$mgrdir",'-ext_editor_lib.pl');
&load_custom("./library",'-mgr_lib.pl');
my $result_ccbrf = "$mgrdir/custom/customizeable_category_builder_routines.pl";
if (!(-e $result_ccbrf)) {
$file = qq| # file ./store/protected/custom/customizeable_category_builder_routines.pl
#######################################################################################
#
# Use this file to customize your category and sub category links that are displayed in the headers
# or footers of the store when a customer visits your store.
#
# change only the values for the variables (they start with a \$) between the single quote marks (')
# If you are not familiar with editing of programming variables, just use the defaults.
# 
#######################################################################################
\$custom_sc_main_category_indent = '&bull;';
\$custom_sc_sub_category_indent = '&nbsp;&nbsp; ';
\$custom_sc_main_category_css_class = 'ac_left_links';
\$custom_sc_sub_category_css_class = 'ac_left_links';
\$custom_sc_main_category_end_html = '<br/>';
\$custom_sc_sub_category_end_html = '<br/>';
1;
|;
  open(UPDATEFILE,">$mgrdir/custom/customizeable_category_builder_routines.pl") || &my_die("Can't Open $mgrdir/custom/customizeable_category_builder_routines.pl");
     print (UPDATEFILE $file);
  close(UPDATEFILE);
}
&load_custom("$mgrdir/custom",'');
&setup_login_check;
if ($mc_file_upload_ok =~ /yes/) { 
  $cgi_lib::writefiles = "./shopping_carts"; 
 }
&ReadParse(\%in, \%in_name, \%in_type, \%in_server_name);
#added by Mister Ed October 2005
&set_log_years_months;
 ($scm_day,$scm_month,$scm_year) = &get_month_year;
if ($mc_file_upload_ok =~ /yes/) { 
  &handle_uploaded_files;
 }
if ($in{'picserve'} ne "") { 
  &serve_picture($in{'picserve'},"$mgrdir/images/");
  &call_exit;
 }
print "Content-type: text/html\n\n";
print qq~<meta http-equiv="P3P" content='CP="NOI CUR OUR NOR"'>\n~;

&$menu_item_init;

if ($in{'login'} ne "") 
 {
  &action_process_login;
 }
if (-M "$ip_file" > ".1")
 {
  unlink ("$ip_file");
  opendir(USER_LOGINS, "$ip_file_dir"); 
  @myfiles = grep(/\.login/,readdir(USER_LOGINS)); 
  closedir (USER_LOGINS);
  foreach $zfile (@myfiles){
    $my_path = "$ip_file_dir/$zfile";
    if (-M "$my_path" > 0.1) {
      $my_path =~ /([^\xFF]*)/;
      $my_path = $1;
      unlink("$my_path");
     }
   }
  &display_login;
  &call_exit;
 }
if (-e "$ip_file")
{
  eval('require "$ip_file";');
  if ($ok_ip ne $ENV{'REMOTE_ADDR'})
   {
    &display_login;
    &call_exit;
   } else { 
    &update_ip_ok;
   }
} 
else
{
&display_login;
&call_exit;
}
foreach $menu_item (sort(keys %menu_items)) {
  if ($in{$menu_item} ne "") {
   $menu_to_run = $menu_items{$menu_item};
   &$menu_to_run;
   &call_exit;
  }
 }

# clear out old carts
# moved from agora.cgi to speed up cart by Mister Ed September 29, 2007
&check_cart_expiry;
&delete_old_carts;

&welcome_screen;
&call_exit;
#*********************************************************************
sub setup_manager {
 $sysname = $ENV{'SERVER_NAME'};
 $mc_gateways = ""; 
 $mc_file_upload_ok = "yes"; 
 $mc_assign_final_sku_at_update = "yes"; 
 $mc_max_top_menu_items = 6;
 $commando_ok = "no"; 
 if (-f "$mgrdir/commando.ok") {
   $commando_ok = "yes"; 
  }
 $other_welcome_message = "";
 $mc_standard_body_tag = '';
 $manager_page_header = "std_manager_header_code";
 $manager_page_footer = "std_manager_footer_code";
 $manager_process_login = "std_action_process_login";
 $manager_welcome_screen = "std_welcome_screen";
 $menu_item_init = "init_convert_menu_item";
 $menu_items{'welcome_screen'} = "welcome_screen";
 $menu_items{'error_log'} = "display_error_log";
 $menu_items{'clear_error_log'} = "clear_error_log";
 $menu_items{'clear_access_log'} = "clear_access_log";
 $menu_items{'order_log'} = "display_order_log";
 $menu_items{'change_settings_screen'} = "change_settings_screen";
$menu_items{'order_management_settings_screen'} = "order_management_settings_screen";
$menu_items{'content_management_settings_screen'} = "content_management_settings_screen";
 $menu_items{'tracking_screen'} = "tracking_screen";
 $menu_items{'htaccess_screen'} = "setup_htaccess_screen";
 $menu_items{'htaccessSettings'} = "action_htaccess_settings";
 if ($commando_ok =~ /yes/i) {
   $menu_items{'commando'} = "action_commando";
  }
$menu_items{'log_out'} = "log_out";
}
#*********************************************************************
sub add_settings_choice {
  local ($sortname,$displayname,$linkname) = @_;
  local ($continue) = "";
  &codehook("add-settings-choice");
  if ($continue eq "no") { return;}
  $sortname =~ tr/A-Z/a-z/;
  $store_settings_name{$sortname}=$displayname;
  $store_settings_link{$sortname}=$linkname;
 }
#*********************************************************************
sub add_merchtools_settings_choice {
  local ($sortname,$displayname,$linkname) = @_;
  local ($continue) = "";
  &codehook("add-settings-choice");
  if ($continue eq "no") { return;}
  $sortname =~ tr/A-Z/a-z/;
  $merchtools_settings_name{$sortname}=$displayname;
  $merchtools_settings_link{$sortname}=$linkname;
 }
#*********************************************************************
sub add_ordermanage_settings_choice {
  local ($sortname,$displayname,$linkname) = @_;
  local ($continue) = "";
  &codehook("add-settings-choice");
  if ($continue eq "no") { return;}
  $sortname =~ tr/A-Z/a-z/;
  $ordermanage_settings_name{$sortname}=$displayname;
  $ordermanage_settings_link{$sortname}=$linkname;
 }
#*********************************************************************
sub require_supporting_libraries
{
local ($file, $line, @require_files) = @_;
local ($require_file);
&request_supporting_libraries("warn exit",$file, $line, @require_files);
} 
sub request_supporting_libraries
{
local ($what_to_do_on_error, $file, $line, @require_files) = @_;
local ($require_file);
foreach $require_file (@require_files)
{ 
if (-e "$require_file" && -r "$require_file") 
{ 
$result = eval('require "$require_file"'); 
if ($@ ne "") {
 if($what_to_do_on_error =~ /warn/i) {
  if ($error_header_done ne "yes") {
     $error_header_done = "yes";
     print "Content-type: text/html\n\n";
    }
   print "<div><table width=500><tr><td>\n";
   print "Error loading library $require_file:<br><br>\n  $@\n";
   print "<br><br>Please fix the error and try again.<br>\n";
   print "</td></tr></table></div>\n";
  }
 if($what_to_do_on_error =~ /exit/i) {
   &call_exit;
  }
 }
}
else
{
 if($what_to_do_on_error =~ /warn/i) {
  if ($error_header_done ne "yes") {
     $error_header_done = "yes";
     print "Content-type: text/html\n\n";
    }
print "I am sorry but I was unable to require $require_file at line
$line in $file.  <br>\nWould you please make sure that you have the
path correct and that the permissions are set so that I have
read access?  Thank you.";
  }
 if($what_to_do_on_error =~ /exit/i) {
   &call_exit;
  }
}

} 
} 
########################################################################
sub file_open_error
{
local ($bad_file, $script_section, $this_file, $line_number) = @_;
print "FILE OPEN ERROR-$bad_file", $this_file, $line_number, "<br>\n";
}
########################################################################
sub handle_uploaded_files{
  $save_umask_value = umask;
  if (($original_umask eq '') || ($save_umask_value =~ /18|63/)) { umask 0022;}
  else { umask $original_umask;}
  codehook("mgr_upload_files_prep");
  &handle_uploaded_single_file('upfile1');
  &handle_uploaded_single_file('upfile2');
  &handle_uploaded_single_file('upfile3');
  &handle_uploaded_single_file('upfile4');
  &handle_uploaded_single_file('upfile5');
  &handle_uploaded_single_file("upfile6");
  &handle_uploaded_single_file("upfile7");
  &handle_uploaded_single_file("upfile8");
  &handle_uploaded_single_file("upfile9");
  &handle_uploaded_single_file("upfile10");
  umask $save_umask_value;
 }
########################################################################
sub handle_uploaded_single_file{
local($zname)=@_;
local ($my_img_file,$junk)="";
local ($file_has_contents)=0;
if (-f $in{$zname}) { 
  open(IMGFILE, "$in{$zname}");
  $file_has_contents = read(IMGFILE,$junk,100);  
  if ($file_has_contents > 10) {
    $file_has_contents = 1;
   } else {
    $file_has_contents = 0;
   }
  close(IMGFILE);
 }
$my_img_file = $mc_images_dir . "/" . &last_part_of_filename($in_name{$zname});
if (($file_has_contents) && ($in_name{$zname} ne "")) {
  $fup_msg = `cp $in{$zname} $my_img_file 2>&1` . "<br>\b";
  $fup_msg .= `ls -al $my_img_file` . "<br>\n";
  if ($mc_chmod_uploaded_images =~ /Yes/) {
      `chmod 0644 $my_img_file`;
  }
 } else { $fup_msg="no file name for image given $in_name{$zname}" .
 "### " . $in_server_name{$zname} . " ### $zname ###" .
 " $my_img_file <br>$in{$zname} con=$file_has_contents<br>\n";}
if ($in_server_name{$zname} ne ""){
  unlink ($in_server_name{$zname});
 }
}
########################################################################
sub last_part_of_filename {
  local ($name) = @_;
  local (@my_items);
  $name =~ s/\\/\//g; 
  @my_items = split(/\//,$name);
  return $my_items[$#my_items];
}
######################################################################
sub codehook{
  local($hookname)=@_;
  local($codehook,$err_code,@hooklist);
  if ($codehooks{$hookname} ne "") {
    @hooklist = split(/\|/,$codehooks{$hookname});
    foreach $codehook (@hooklist) {
      eval("&$codehook;");
      $err_code = $@;
      if ($err_code ne "") { #script died, error of some kind
        &update_error_log("code-hook $hookname $codehook $err_code","","");
       }
     }
   }
 }
#######################################################################
sub add_codehook{
  local($hookname,$sub_name)=@_;
  local($codehook,$err_code,@hooklist);
  if ($sub_name eq "") { return;}
  if ($codehooks{$hookname} eq "") {
    $codehooks{$hookname} = $sub_name;
   } else {
    $codehooks{$hookname} .= "|" . $sub_name;
   }
 }
#
#######################################################################
sub get_required_config {
  local($str,@lines,@cfglines,$junk1);
  open(CONFIG,"./admin_files/agora_user_lib.pl");
  @cfglines = <CONFIG>;
  close(CONFIG);
  @lines = grep(/\$sc_prod_db_pad_length/,@cfglines);
  $str = $lines[0]; 
  chomp($str);
  $str =~ /([^\xFF]*)/;
  $str = $1;
  eval($str);
   @lines = grep(/\$sc_database_lib/,@cfglines);
  $str = $lines[0]; 
  chomp($str);
  $str =~ /([^\xFF]*)/; # un-taint it
  $str = $1;
  eval($str);
  if ($sc_database_lib eq "") {
    $sc_database_lib = "agora_db_lib.pl";
   }
  $mc_path_for_cookie = "";
  $mc_domain_name_for_cookie = "";
  @lines = grep(/\$mc_path_for_cookie/,@cfglines);
  $str = $lines[0];
  chomp($str);
  $str =~ /([^\xFF]*)/;
  $str = $1;
  eval($str);
  @lines = grep(/\$mc_domain_name_for_cookie/,@cfglines);
  $str = $lines[0];
  chomp($str);
  $str =~ /([^\xFF]*)/;# un-taint it
  $str = $1;
  eval($str);
 }
#######################################################################
sub load_custom{
local($zdir,$ztext)=@_;
local($zlib,@mylibs,$lib);
opendir(USER_LIBS, "$zdir");
@mylibs = sort(readdir(USER_LIBS));
closedir (USER_LIBS);
foreach $zlib (@mylibs) {
  $lib = $zlib;
  $lib =~ /([\w\-\=\+]+)(\.pl)/i;
  $zfile = "$1$2";
  if (($ztext eq "") || (($ztext ne "") && ($zfile =~ /$ztext/i))){
    if ((-f "$zdir/$lib") && ($lib eq $zfile)) {
      $lib =~ /([^\n|;]+)/;
      $lib = $1;
      &require_supporting_libraries(__FILE__,__LINE__,"$zdir/$lib");
     }
   }
 }
}
#######################################################################
sub setup_login_check {
  &codehook("setup-login-check-top");
  $ip_file_dir = "$mgrdir/files";
  if ($mc_path_for_cookie eq "") {
    $mc_path_for_cookie = $sc_path_for_cookie . "/$mgrdirname";
   }
  if ($mc_domain_name_for_cookie eq "") {
    $mc_domain_name_for_cookie = $sc_domain_name_for_cookie;
   }

  if ($mc_use_cookie_login =~ /yes/) {
    &get_cookie;
    if ($cookie{'agoramgr'} eq '') {
      $cookie{'agoramgr'} = &make_random_chars;
      &set_cookie(-1,
  $mc_domain_name_for_cookie,
  $mc_path_for_cookie,
  "");
      $mc_have_cookie = "no";
      $ip_file = "$ip_file_dir/$a_unique_name.pl";
     } else {
      $mc_have_cookie = "yes";
      $cookie{'agoramgr'} =~ /([^\xFF]*)/;
      $cookie{'agoramgr'} = $1;
      $ip_file = "$ip_file_dir/$cookie{'agoramgr'}.login";
     }
   } else {
    $ip_file = "$ip_file_dir/$a_unique_name.pl";
  }
  &codehook("setup-login-check-bot");
}
#######################################################################
sub zcode_error {
  local ($ZCODE,$at,$file,$line)=@_;
  &update_error_log("zcode compilation error:\n$at\n$ZCODE",
    $file,$line);
  &call_exit;
}
#######################################################################
sub update_error_log {
local ($type_of_error, $file_name, $line_number) = @_;
local ($log_entry, $email_body, $variable, @env_vars);
@env_vars = sort(keys(%ENV));
$date = &get_date;
if ($sc_debug_mode eq "yes")
{
if ($sc_header_printed ne 1) {
  if ($sc_browser_header eq "") {
    $sc_browser_header = "Content/type: text/html;\n\n";
   }
  print $sc_browser_header;
 }
local($browser_text) = $type_of_error;
$browser_text =~ s/\|/\<br\>\n/g;
$browser_text =~ s/\</\&lt;/g;
$browser_text =~ s/\>/\&gt;/g;
print '<DIV ALIGN=LEFT><TABLE WIDTH=500><TR><TD>' . "\n<PRE>";
print "ERROR:$browser_text<br>",
      "FILE: $file_name<br>",
      "LINE: $line_number<BR>\n";
print '</PRE></TD></TR></TABLE></DIV>' . "\n";
}
if (($sc_shall_i_log_errors =~ /yes/i) ||
    ($sc_shall_i_log_errors eq ''))
{
$log_entry = "MGR: $type_of_error\|FILE=$file_name\|LINE=$line_number\|";
$log_entry .= "DATE=$date\|";

&get_file_lock("$sc_error_log_path.lockfile");
open (ERROR_LOG, ">>$sc_error_log_path") || &CgiDie ("The Error Log could not be opened");
foreach $variable (@env_vars)
{
$log_entry .= "$variable: $ENV{$variable}\|";
}  
$log_entry =~ s/\n/<br>/g; # do not want newlines!
print ERROR_LOG "$log_entry\n";
close (ERROR_LOG);  
&release_file_lock("$sc_error_log_path.lockfile");
}
}
######################################################################
sub get_date {
local (@days, @months); 
local ($connector) = ' at ';
@days = ('Sunday','Monday','Tuesday','Wednesday','Thursday', 'Friday',
  'Saturday');
@months = ('January','February','March','April','May','June','July',
     'August','September','October','November','December');
return &get_date_engine;
}

sub get_date_short {
local (@days, @months); 
local ($connector) = ' ';
@days = ('Sun','Mon','Tue','Wed','Thu', 'Fri', 'Sat');
@months = ('Jan','Feb','Mar','Apr','May','Jun',
  'Jul','Aug','Sep','Oct','Nov','Dec');
return &get_date_engine;
}

sub get_date_engine
{
local ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst,$date);
($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
if ($hour < 10) 
{ 
$hour = "0$hour"; 
}
if ($min < 10) 
{ 
$min = "0$min"; 
}
if ($sec < 10) 
{
$sec = "0$sec"; 
}
$year += 1900;
$date = "$days[$wday], $months[$mon] $mday, $year" .
  $connector . "$hour\:$min\:$sec";
return $date;
}


sub get_month_year {
local (@days, @months); 
local ($connector) = ' at ';
@days = ('Sunday','Monday','Tuesday','Wednesday','Thursday', 'Friday',
  'Saturday');
@months = ('January','February','March','April','May','June','July',
     'August','September','October','November','December');
return &get_monthyear_engine;
}

sub get_monthyear_engine {
my ($sec,$min,$hour,$mday,$mon,$wday,$yday,$isdst);
my ($month,$year);
($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
$year += 1900;
$month = "$months[$mon]";
return ($mday,$month,$year);
}
######################################################################
sub category_list_builder_for_store {
# updated for AgoraCart 5.x by Mister Ed Jan 11, 2005
# updated to fit CSS mods by Eric Welin Feb 02, 2005
# moved from header files to manager function to speed
# up store.  By Mister Ed September 29, 2007

my($sku,$category,$subcategory,$sc_categories_with_subcats,$sc_categories_no_subcats,$sc_categories_bots_with_subcats,$sc_categories_bots_no_subcats) = '';
my ($catnumber,$catnumber2,$myset,$category,$category2,$category3)= '';
local(%db_ele,%subcatarray)= ();
if (!($sc_db_lib_was_loaded =~ /yes/i)){ 
  &require_supporting_libraries (__FILE__, __LINE__, "$sc_db_lib_path"); 
}

if ($sc_use_database_subcats =~ /yes/i) {
  &get_prod_db_element($db{"product"},*db_ele);
  foreach $sku (sort (keys %db_ele)) {
    $catnumber = "";
    $category = $db_ele{$sku};
    %subcatarray = %{$db_ele{$category}};
    $category2 = $category;
    #$category2=~s/ /_/g;
    if ($sc_count_database_cats =~ /yes/i) {
      $catnumber = "(" . $db_ele2{$category} . ")";
    }

    $sc_categories_with_subcats .= qq|\n$custom_sc_main_category_indent<a href="agora.cgi?cart_id=%%cart_id%%&amp;product=$category2&amp;xm=on" class="$custom_sc_main_category_css_class" title="$category">$category</a> $catnumber$custom_sc_main_category_end_html|;
    $sc_categories_bots_with_subcats .= qq|\n$custom_sc_main_category_indent<a href="agora.cgi?product=$category2&amp;xm=on" class="$custom_sc_main_category_css_class" title="$category">$category</a> $catnumber$custom_sc_main_category_end_html|;
    foreach $subcategoryarray (sort(keys %subcatarray)) {
      $category3 = $subcategoryarray;
     # $category3=~s/ /_/g;
      if ($sc_count_database_cats =~ /yes/i) {
        $catnumber2 = "(" . $db_ele{$category}->{$subcategoryarray} . ")";
      }
     $sc_categories_with_subcats .= qq|\n$custom_sc_sub_category_indent<a href="agora.cgi?cart_id=%%cart_id%%&amp;product=$category2&amp;$sc_subcat_index_field=$category3&amp;xm=on" class="$custom_sc_sub_category_css_class" title="$category3">$category3</a> $catnumber2$custom_sc_sub_category_end_html|;
     $sc_categories_bots_with_subcats .= qq|\n$custom_sc_sub_category_indent<a href="agora.cgi?product=$category2&amp;$sc_subcat_index_field=$category3&amp;xm=on" class="$custom_sc_sub_category_css_class" title="$category3">$category3</a> $catnumber2$custom_sc_sub_category_end_html|;
    }
  }
  $myset .= "\$sc_categories_with_subcats = qq|$sc_categories_with_subcats|;\n";
  $myset .= "\$sc_categories_bots_with_subcats = qq|$sc_categories_bots_with_subcats|;\n";

}
else { 
  &get_prod_db_element($db{"product"},*db_ele);
  foreach $sku (keys %db_ele) {
    $category = $db_ele{$sku};
    $category_list{$category}++;
  }
  foreach $category (sort(keys %category_list)) {
    $category2 = $category;
    $category2=~s/_/ /g;
    $sc_categories_no_subcats .= qq|\n$custom_sc_main_category_indent <a href="agora.cgi?cart_id=%%cart_id%%&amp;product=$category&amp;xm=on" class="$custom_sc_main_category_css_class" title="$category2">$category2</a>$custom_sc_main_category_end_html|;
    $sc_categories_bots_no_subcats .= qq|\n$custom_sc_main_category_indent <a href="agora.cgi?product=$category&amp;xm=on" class="$custom_sc_main_category_css_class" title="$category2">$category2</a>$custom_sc_main_category_end_html|;
  }
  $myset .= "\$sc_categories_no_subcats = qq|$sc_categories_no_subcats|;\n";
  $myset .= "\$sc_categories_bots_no_subcats = qq|$sc_categories_bots_no_subcats|;\n";
}

&update_store_settings('CATEGORYLIST',$myset);

}
#######################################################################
#                        Delete Old Carts.                            #
#######################################################################

    # delete_old_carts is a subroutine which is used to prune
    # the carts directory, cleaning out all the old carts
    # after some time interval defined in the setup file.  It
    # takes no argumnetes and is called with the following
    # syntax:
    #
    # &delete_old_carts;

sub check_cart_expiry {
  &check_cart_type_file_expiry("$sc_cart_path");
  &check_cart_type_file_expiry("$sc_verify_order_path");
  &check_cart_type_file_expiry("$sc_server_cookie_path");
 }

sub check_cart_type_file_expiry {
local($cart_type_file_path) = @_;
if (-M "$cart_type_file_path" > $sc_number_days_keep_old_carts)
{
if ($cart_type_file_path =~ /cart/i) {
  &codehook("delete-cart");
	if (($sc_db_index_for_inventory) && ($sc_inventory_subtract_at_add_to_cart =~ /yes/i)) {
		open (CART, "$cart_type_file_path") || &errorcode(__FILE__, __LINE__, "$sc_cart_path", "$!", "ignore", "FILE OPEN ERROR", "0");
		while (<CART>) {
			my @row = split (/\|/, $_);
		&add_inventory($row[1], $row[0]);
	}
close (CART);
}
 } else {
  &codehook("delete-non-cart");
 }
unlink("$cart_type_file_path");
}
}

sub delete_old_carts
{

    # The subroutine begins by grabbing a listing of all of
    # the client created shoppping carts in the User_carts
    # directory.
    #
    # It then opens the directory and reads the contents using
    # grep to grab every file with the extension _cart. Then
    # it closes the directory.  
    #
    # If the script has any trouble opening the directory,
    # it will output an error message using the
    # file_open_error subroutine discussed later.  To the
    # subroutine, it will pass the name of the file which had
    # trouble, as well as the current routine in the script
    # having trouble , the filename and the current line
    # number.

opendir (USER_CARTS, "$sc_user_carts_directory_path") || &file_open_error("$sc_user_carts_directory_path", "Delete Old Carts", __FILE__, __LINE__);
@carts = grep(/\.[0-9]/,readdir(USER_CARTS)); # must have . followed by digits
closedir (USER_CARTS);
      
    # Now, for every cart in the directory, delete the cart if
    # it is older than half a day.  The -M file test returns
    # the number of days since the file was last modified.
    # Since the result is in terms of days, if the value is
    # greater than the value of $sc_number_days_keep_old_carts
    # set in agora.setup.db, we'll delete the file.

foreach $cart (@carts)
{
# code below deletes carts and other files in this directory that have expired
$sc_cart_path = "$sc_user_carts_directory_path/$cart";
$sc_cart_path =~ /([\w\-\=\+\/\.]+)/;
$sc_cart_path = "$1";
$sc_cart_path = "" if ($sc_cart_path eq ".");
$sc_cart_path =~ s/^\/+//; # Get rid of any residual / prefix
&check_cart_type_file_expiry("$sc_cart_path");
}# end of foreach

}# End of sub delete_old_carts

#######################################################################
sub call_exit {
  codehook("cleanup_before_exit");
  exit;
 }
