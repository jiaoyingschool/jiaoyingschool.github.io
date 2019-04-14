#######################################################################

$versions{'agora_html_lib.pl'} = "5.5.013";

#######################################################################
if ($sc_main_script_post_url eq '') { # init this, just in case
  $sc_main_script_post_url = $sc_main_script_url;
 }
#######################################################################
sub load_server_side_cookies {
  local($temp);
  &codehook("before_server_cookie_load");
  undef(%agora); 
  undef(%agora_original_values);
  $sc_server_cookies_loaded = '1';
  if (-e "$sc_server_cookie_path" && -r "$sc_server_cookie_path"){ 
   # file is there, now try to require it in a not-fatal way
    eval('require "$sc_server_cookie_path"'); 
   }
&require_supporting_libraries (__FILE__, __LINE__,
    "./admin_files/agora_userlog_lib.pl");
  if (&get_agora('LAST_VISIT_TIMESTAMP') eq '') { # new shopping session
    if ($sc_shall_i_log_accesses eq "yes") {
      &log_access_to_store;
     }
    eval q~
     use HTTP::BrowserDetect;
     my $browser = new HTTP::BrowserDetect($ENV{"HTTP_USER_AGENT"});
     if ($browser->robot()) {&set_agora("BOT",1);}else{&set_agora("BOT",'');}
     &set_agora("BROWSER",$browser->browser_string().'/'.$browser->version());
     ~;
     &set_agora("HTTP_USER_AGENT",$ENV{'HTTP_USER_AGENT'});
     if (&get_agora("BROWSER") eq '') {
       ($temp,$junk) = split(/ /,$ENV{'HTTP_USER_AGENT'},2);
       &set_agora("BROWSER",substr($temp,0,15));
      }
   }
  &set_agora('LAST_VISIT_TIMESTAMP',time());
  if (&get_agora("BOT") ne '') {
    $sc_special_page_meta_tags .= $sc_robot_meta_tags;
   } else {
    $sc_special_page_meta_tags .= $sc_browser_meta_tags;
   }
  &codehook("after_server_cookie_load");
 }
#######################################################################
sub set_agora {
  local($inx,$val) = @_;
  if ($val eq '') {
    delete($agora{$inx});
   } else {
    $agora{$inx} = $val;
   }
  return $val;
 }
#########################################################################
sub get_agora {
  local($inx) = @_;
  return $agora{$inx};
 }
#########################################################################
sub get_agora_orig {
  local($inx) = @_;
  return $agora_original_values{$inx};
 }
#########################################################################
sub chk_agora {
 # return 1 if the cookie has not changed since loading, 
 # null otherwise
  local($inx) = @_;
  if ($agora_original_values{$inx} eq $agora{$inx}) {
    return '1';
   } else {
    return '';
   }
 }
#########################################################################
sub ain_agora { # add if new to agora cookies
 # if this item is not yet stored, and it is not null, then store it
 # return 1 if stored, null otherwise
  local($inx,$val) = @_;
  if ((&get_agora($inx) eq '') && ($val ne '')) {
    &set_agora($inx,$val);
    return '1';
   } else {
    return '';
   }
 }
#########################################################################
sub agora_cookie_save {
  local($inx,$temp);
  foreach $inx (keys %form_data) {
      if ($inx !~ /Payment_/) {
         $temp .= "$inx\x01$form_data{$inx}\x01";
      }
   }
  &set_agora("PREVIOUS_FORM_VALUES",$temp);
  open(SERVCOOKIE,">$sc_server_cookie_path");
  print SERVCOOKIE "# Library of agora.cgi Server Cookies\n";
  foreach $inx (sort(keys %agora)) {
    $temp = &str_encode($agora{$inx});
    if ($temp =~ /\%/) {
      print SERVCOOKIE "\$agora{'$inx'} = &str_decode('" . 
       &str_encode($agora{$inx}) . "');\n";
     } else {
      print SERVCOOKIE "\$agora{'$inx'} = '" . 
       $agora{$inx} . "';\n";
     }
   }
  print SERVCOOKIE '{local($inx);' .
  'foreach $inx (keys %agora) {' .
  '$agora_original_values{$inx} = $agora{$inx};}' . "}\n";
  print SERVCOOKIE "#\n1;\n";
  close(SERVCOOKIE);
 }
#########################################################################
sub get_agora_names {
  return sort(keys %agora);
 }
#########################################################################
sub str_encode { # encode a string for cgi or other purposes
  local($str)=@_;
  local($mypat)='[\x00-\x1F"\x27#%/+;<>?\x7F-\xFF]';
  $str =~ s/($mypat)/sprintf("%%%02x",unpack('c',$1))/ge;
  $str =~ tr/ /+/;
  return $str;
 }
#######################################################################
sub str_decode { # decode a string for cgi or other purposes
  local($str)=@_;
  $str =~ tr/+/ /;
  $str =~ s/%(..)/pack("c",hex($1))/ge;
  return $str;
 }
#######################################################################
sub load_file_lines_to_str {# load a text file
  local ($location) = @_;
  local (@lines)=();
  open (XX_FILE, "<$location");
  @lines = <XX_FILE>;
  close (XX_FILE);
  return join("",@lines);
 }
#######################################################################
sub load_file_to_str {# load a file in binary mode
  local ($location) = @_;
  local ($content)='';
  open (XX_FILE, "<$location");
  binmode(XX_FILE);
  local $/ = undef;
  $contents = <XX_FILE>;
  close (XX_FILE);
  return $content;
 }
#######################################################################
sub load_opt_file {
  local($files_to_load) = @_;
  local($very_first_part,$stuff_after,$arg,$newpath,$myans,$tack_on);
  local($path) = "";
  local($field) = "";
  if ($files_to_load ne "") {
    $field = $files_to_load;
    $field =~ s/ //g;
    $field =~ s/,/%%\n%%Load_Option_File /g;
    $field = '%%Load_Option_File ' . $field . '%%';
    $field = &load_opt_file_engine($field);
   }
  return $field;
 }
#######################################################################
sub load_opt_file_engine { # do the actual loading of options file(s)
  local($field) = @_;
  local($very_first_part,$stuff_after,$arg,$newpath,$myans,$tack_on);
  local(%file_list);

 # DELUXE feature ... take only the part between <h3>--cut here--</h3> 
 # tokens, so if there are any "load option file" tokens we must
 # perform special maint on them ... put the stuff between the cut tags
 # where the load token is and tack the rest on at the end (so all
 # agorascript is still there someplace.)

  while ($field =~ /(%%Load_Option_File )([^%]+)(%%)/i) {
    $arg = $2;
    $arg =~ s/ //g;
    if ($arg =~ /,/) { # there is a list, break it down
      $arg =~ s/,/%%%%Load_Option_File /g;
      $myans = "%%Load_Option_File $arg%%";
     } else {
      $newpath = "$sc_options_directory_path/$arg";
      if ($file_list{$newpath} eq '') { # prevent reloads
        # added by Mister Ed September 14, 2006
        # allow tokens to be processed multiple times for efficiency in
        # larger option matrices.  By default it is not enabled.
        if ($sc_enable_multi_load_option_files =~ /yes/i) {
            $file_list{$newpath} = "";
        } else {
            $file_list{$newpath} = "1";
        }
        $myans = &load_file_lines_to_str($newpath);
       } else {
        $myans = " (reload of option $arg attempted!) ";
       }
     }
    ($very_first_part,$myans,$stuff_after) =  
  split(/<h3>--cut here--<\/h3>/i,$myans,3);
    if ($myans eq "") {
      $myans = $very_first_part;
      $tack_on = '';
     } else {
      $tack_on = $very_first_part . $stuff_after;
     }
    if ($myans eq "") {
      $myans = "(option file $arg not found)";
     }
    $field =~ s/(%%Load_Option_File )([^%]+)(%%)/$myans/i;
    if (($tack_on ne '') && (!($field =~ /<h3>--cut here--<\/h3>/i))) {
     # there exists the cut tags in loaded files but not source ...
     # need to manually add them or we could be in trouble 
      $field  = '<H3>--cut here--</H3>' . $field;
      $field .= '<H3>--cut here--</H3>';
     }
    $field .= $tack_on;
   }
  return $field;
 }
#######################################################################
sub cart_email_options {
 local($a1) = @_;
 my $a2,$jchar;
 $jchar = ' ' x $sc_opt_email_leading_spaces;
 my @xx = split(/$sc_opt_sep_marker/,$a1); 
 return join "\n".$jchar,@xx;
 }
#######################################################################
sub make_random_chars {
# name says it all
 local ($part1,$part2,$valid_chars,$chars,$inx);
 $part1 = "abcdefghijklmnopqrstuvwxyz";
 $part2 = $part1;
 $part2 =~ tr/a-z/A-Z/;
 $valid_chars= $part1 . $part2 . "0123456789_-";
 $chars="";
 for ($inx=0;($inx < 2); $inx++) {
   $chars .= substr($valid_chars,rand(length($valid_chars)),1);
  }
 $chars .= substr(rand(9),0,1);
 for ($inx=0;($inx < 2); $inx++) {
   $chars .= substr($valid_chars,rand(length($valid_chars)),1);
  }
 $chars .= substr(rand(9),0,1);
 return $chars;
}
#######################################################################
sub add_csv {
 local ($what, $str) = @_;

 if (($what =~ /\,/) || ($what =~ /\"/)) { #need to quote it
  $what =~ s/\"/\"\"/g;
  $what = '"' . $what . '"';
 }

 if ($str ne "") {
  $what = $str . "," . $what;
  }

 return $what;

}
#######################################################################
sub eval_custom_logic {

 local ($logic,$whoami,$file,$line) = @_;
 local ($err_code, $result) = "";

 if ($logic ne "") {
   $result = eval($logic);
   $err_code = $@;
   if ($err_code ne "") { #script died, error of some kind
     &update_error_log("$whoami $err_code ",$file,$line);
     $result="";
    }
  }

 return $result;

}
#######################################################################
#                    product_page_header Subroutine                   #
#######################################################################

    # product_page_header is used to display the shared
    # HTML header used for database-based product pages.  It
    # takes one argument, $page_title, which will be used to
    # fill the data between the <TITLE> and </TITLE>.
    # Typically, this value is determined by 
    # $sc_product_display_title in agora.setup.db.
    # 
    # The subroutine is called with the following syntax:
    #
    # &product_page_header("Desired Title");


sub product_page_header {
    # First, the script assigns the incoming argument to the
    # local variable $page_title

local ($page_title,$prod_message) = @_;

    # Then, it assigns the text of all of the hidden fields 
    # that may need to be passed as state information to
    # $hidden_fields using the make_hidden_fields subroutine
    # which will be discussed later.

local ($hidden_fields) = &make_hidden_fields;
local ($my_hdr);
    # Next, the HTML code is sent to the browser including the
    # page title and the hidden fields dynamically inserted.
my $temp_product_title = $form_data{'product'};
$temp_product_title =~ s/_/ /g;
$my_hdr = qq~$sc_doctype
<html>
<head>
  <title>$page_title $temp_product_title</title>
  $sc_standard_head_info
</head>
<body>~;

$my_hdr = &agorascript($my_hdr,"","sub product_page_header",__FILE,__LINE__);

&codehook("product_page_header");
print $my_hdr;

&StoreHeader;

    # Next, we will grab $sc_product_display_header which is a
    # preformatted string defined in agora_user_lib.pl (setup in the store layout manager) 
    #  and use printf to put the entire contents of
    # @sc_db_display_fields in place of the format tags (%s).
    # The function of this will be to display the header
    # categories which products will follow.
    #
    # Consider the following example from web_store.setup.db:
    # $sc_product_display_header = qq!
    #
    #  <TABLE BORDER = "0">
    #  <TR>
    #  <TH>Quantity</TH>
    #  <TH>%s</TH>
    #  <TH>%s</TH>
    #  </TR>
    #  <TR>
    #  <TD COLSPAN = "3"><HR></TD>
    #  </TR>!;
    #
    # @sc_db_display_fields = ("Image (If appropriate)",
    #                          "Description");
    #
    # In this case, the strings "Image (If appropriate)" and
    # "Description" will be substituted by the printf
    # function for the two %s's in the TABLE header defined in
    # $sc_product_display_header.

if ($prod_message ne "") {
  print "$prod_message\n";
 }
printf($sc_product_display_header, @sc_db_display_fields);

}
#######################################################################
#                    product_page_footer Subroutine                   #   
#######################################################################

    # product_page_footer is used to generate the HTML page
    # footer for database-based product pages.  It takes two
    # arguments, $db_status and $total_rows_returned and is
    # called with the following syntax:
    # 
    # &product_page_footer($status,$total_row_count);


sub product_page_footer {

local($keywords,$zmessage);
$keywords = $form_data{'keywords'};

$keywords =~ s/ /+/g;

    # $db_status gives us the status returned from the database
    # search engine and $total_rows_returned gives us the
    # actual number of rows returned.  $warn_message which
    # is first initialized, will be used to generate a warning
    # that the user should narrow their search in case
    # too many rows were returned.

local($prod_message) = @_;

$zmessage = qq~
$sc_product_display_footer

$prod_message~;

&codehook("product_page_footer_top");
print $zmessage;
&StoreFooter;


$zmessage=qq~
</body>
</html>~;

&codehook("product_page_footer_bot");
print $zmessage;

}

sub product_message {

local($keywords);
local($db_status, $rowCount, $nextHits) = @_;
local($warn_message);
local($prevHits) = $nextHits;

$keywords = $form_data{'keywords'};
$save_next= $form_data{'next'}; # we change this value here temporarily

$keywords =~ s/ /+/g;

    # $db_status gives us the status returned from the database
    # search engine and $total_rows_returned gives us the
    # actual number of rows returned.  $warn_message which
    # is first initialized, will be used to generate a warning
    # that the user should narrow their search in case
    # too many rows were returned.

    # If the database returned a status, the script checks to
    # see if it was like the string "max.*row.*exceed".  If
    # so, it lets the user know that they need to narrow their
    # search.

if ($db_status ne "") 
{

  if ($db_status =~ /max.*row.*exceed.*/i) 
  {

$warn_message = qq~<div align="center"><table class="ac_seach_results">
<tr><td class="ac_seach_results">\n~;


if ($maxCount < $rowCount) {
  $my_last = $maxCount;
 } else {
  $my_last = $rowCount;
 }
if ($minCount < 0) {
  $my_first = 1;
 } else {
  $my_first = $minCount + 1;
 }
if ($minCount < $nextHits) {
  $my_prevHits = $maxCount - $nextHits;
 } else {
  $my_prevHits = $prevHits;
 }

if ($my_first == $my_last) {
  $warn_message .= "Found $rowCount items, showing " .
  $my_last . ". &nbsp;&nbsp;";
 } else {
  $warn_message .= "Found $rowCount items, showing " .
  ($my_first) . " to " . $my_last . ". &nbsp;&nbsp;";
 }

    if($form_data{'next'} > "0")
    {
    $form_data{'next'}=$prevCount;
    $href_fields = &make_href_fields;
    $href_info = "'$sc_main_script_url?$href_fields'";
    $warn_message .= qq!
<a href=$href_info>Previous $my_prevHits Matches</a>&nbsp;&nbsp;
!;
    }

    if ($maxCount == $rowCount-1)
    {
      $nextHits = (@database_rows-$maxCount);
      if ($nextHits == 1)
      {
      $form_data{'next'}=$maxCount;
      $href_fields = &make_href_fields;
      $href_info = "'$sc_main_script_url?$href_fields'";
      $warn_message .= qq!
<a href=$href_info>Last Match</a>&nbsp;&nbsp;
!;
      }

    }

  if ($maxCount < $rowCount && $maxCount != $rowCount-1)
  {

    if ($maxCount >= $rowCount-$nextHits )
    {
    $lastCount = $rowCount-$maxCount;
    $form_data{'next'}=$maxCount;
    $href_fields = &make_href_fields;
    $href_info = "'$sc_main_script_url?$href_fields'";
    $warn_message .= qq!
<a href=$href_info>Last $lastCount Matches</a>&nbsp;&nbsp;
!;
    }
    else
    {
    $form_data{'next'}=$maxCount; 
    $href_fields = &make_href_fields;
    $href_info = "'$sc_main_script_url?$href_fields'";
    $warn_message .= qq!
<a href=$href_info>Next $nextHits Matches</a> 
!;
  }

  }

        $warn_message .= "</td></tr></table>\n";
  $warn_message .= "</div>";




  }

}

    # Then the script displays the footer information defined
    # with $sc_product_display_footer in agora.setup.db and
    # adds the final basic HTML footer.  Notice that one of the
    # submit buttons, "Return to Frontpage" is isolated into
    # the $sc_no_frames_button variable.  This is because in
    # the frames version, we do not want that option as it
    # will cause an endlessly fracturing frame system.  Thus,
    # in a frame store, you would simply set 
    # $sc_no_frames_button to "" and nothing would print here.
    # Otherwise, you may include that button in your footer
    # for ease of navigation.  The variable itself is defined
    # in agora.setup.db.  The script also will print the
    # warning message if there is a value for it.

$form_data{'next'} = $save_next;# must restore our original state!
return $warn_message;

}

#######################################################################
#                 html_search_page_footer Subroutine                  #
#######################################################################

    # html_search_page_footer is used to generate the HTML
    # footer for HTML-based product pages when the script
    # must perform a keyword search and generate a list of
    # hits. It is called with no argumnets with the following
    # syntax:
    #
    # &html_search_page_footer;
    #
    # Notice again the use of $sc_no_frames_button in place of
    # the "Return to Frontpage" button as discussed in the
    # last section.


sub html_search_page_footer {
print qq~
<div align="center">
<input type="submit" name="modify_cart_button" value="View/Modify Cart">
$sc_no_frames_button
<input type="submit" name="order_form_button" value="Checkout Stand">
</form>
</div>  
</body>
</html>~;
}
#######################################################################
#                    standard_page_header Subroutine                  #
#                                                                     #
# Syntax: &standard_page_header("TITLE");                             #
#######################################################################

sub standard_page_header {

 local($type_of_page) = @_;
 local ($hidden_fields) = &make_hidden_fields;
 local($header);

 $header = qq~$sc_doctype
<html>
<head>
$sc_special_page_meta_tags
  <title>$type_of_page</title>
  $sc_standard_head_info
</head>
<body>
~;

 &codehook("standard_page_header");
 print $header;

}
#######################################################################
#                    modify_form_footer Subroutine                    #   
#######################################################################

    # modify_form_footer is used to generate the HTML footer
    # code for the "modify quantity of items in the cart" form
    # page.  It takes no arguments and is called with the
    # following syntax:
    #
    # &modify_form_footer;
    #
    # As usual, we will admit the "Return to Frontpage" button
    # only if we are not using frames by defining it with the
    # $sc_no_frames_button in agora.setup.db.


sub modify_form_footer {
local($footer)="";
open (MODIFYFOOTER, "$sc_templates_dir/change_quantity_footer.inc") ||
&file_open_error("$sc_cart_path", "cartfooter", __FILE__, __LINE__);

while (<MODIFYFOOTER>) {
  $footer .= $_;
 }
close MODIFYFOOTER;
$footer = &script_and_substitute_footer($footer);
&codehook("modify_form_footer");
print $footer;
&StoreFooter;

}

#######################################################################
#                    delete_form_footer Subroutine                    #
#######################################################################

    # delete_form_footer is used to generate the HTML footer
    # code for the "delete items from the cart" form
    # page.  It takes no arguments and is called with the
    # following syntax:
    #
    # &delete_form_footer;
    #
    # As usual, we will admit the "Return to Frontpage" button
    # only if we are not using frames by defining it with the
    # $sc_no_frames_button in agora.setup.db.


sub delete_form_footer {
local($footer)="";
open (DELETEFOOTER, "$sc_templates_dir/delete_items_footer.inc") ||
&file_open_error("$sc_cart_path", "cartfooter", __FILE__, __LINE__);

while (<DELETEFOOTER>){
  $footer .= $_;
 }
close DELETEFOOTER;
$footer = &script_and_substitute_footer($footer);
&codehook("delete_form_footer");
print $footer;
&StoreFooter;

}
#######################################################################
#                       cart_footer Subroutine                        #
#######################################################################

    # cart_footer is used to generate the HTML footer
    # code for the "view items in the cart" form
    # page.  It takes no arguments and is called with the
    # following syntax:
    #
    # &cart_footer;
    #
    # As usual, we will admit the "Return to Frontpage" button
    # only if we are not using frames by defining it with the
    # $sc_no_frames_button in agora.setup.db.


sub cart_footer {
local($grand_total,$quantity) = @_;
local($file_title,$footer)="";

# Use the empty cart footer if it is there and qty=0
$file_title = "$sc_templates_dir/empty_cart_footer.inc";
if (($quantity > 0) || (!(-f $file_title))) {
  $file_title = "$sc_templates_dir/cart_footer.inc";
 }

open (CARTFOOTER, "$file_title") ||
&file_open_error("$sc_cart_path", "cartfooter", __FILE__, __LINE__);

while (<CARTFOOTER>) {
  $footer .= $_;
 }
close CARTFOOTER;
$footer = &script_and_substitute_footer($footer);
&codehook("cart_footer");
print $footer;
&StoreFooter;

}
#######################################################################
#
#######################################################################
sub script_and_substitute_footer {

 local ($footer) = @_;
 local($offlineSecureURL)="";

 if($sc_gateway_name eq "Offline") {
   $offlineSecureURL = qq~
</div></form>
<div align="center">
<form method=post action="$sc_order_script_url">
<input type=hidden name="cart_id" value="$cart_id">
~;

# Added by Mister Ed August 9, 2006
  } elsif ($sc_ssl_location_url2 ne "") {
   $offlineSecureURL = qq~
</div></form>
<div align="center">
<form method=post action="$sc_stepone_order_script_url">
<input type=hidden name="cart_id" value="$cart_id">
~;
  }

  $footer = &agorascript($footer,"pre","sub modify_form_footer",
  __FILE__,__LINE__);

  $footer =~ s/%%URLofImages%%/$URL_of_images_directory/g;
  $footer =~ s/%%cart_id%%/%%ZZZ%%/g;
  $footer =~ s/%%sc_order_script_url%%/$sc_order_script_url/g;
  $footer =~ s/%%StepOneURL%%/$sc_stepone_order_script_url/ig;
  $footer =~ s/%%offlineSecureURL%%/$offlineSecureURL/g;
  $footer =~ s/%%ButtonSetURL%%/$sc_buttonSetURL/ig;

  while ($footer =~ /%%ZZZ%%/) {
    $footer =~ s/%%ZZZ%%/$cart_id/;
  }

  $footer = &agorascript($footer,"post","sub modify_form_footer",
  __FILE__,__LINE__);
  $footer = &agorascript($footer,"","sub modify_form_footer",
  __FILE__,__LINE__);

  return $footer;

 }
#######################################################################
#                    bad_order_note Subroutine                        #
#######################################################################

    # bad_order_note generates an error message for the user
    # in the case that they have not submitted a valid number
    # for a quantity.  It takes no argumnets and is called
    # with the following syntax:
    # 
    # &bad_order_note;


sub bad_order_note {

local($button_to_set) = @_;
$button_to_set = "try_again" if ($button_to_set eq "");

#added by Mister Ed September 9, 2006
&codehook("bad_order_note_top");

&standard_page_header("Error");

&StoreHeader;


if ($sc_bad_order_note_alt) {
print qq!
<div align="center">
<p class="ac_error">
$sc_bad_order_note_alt
</p>
!;
} else {
print qq!
<div align="center">
<p class="ac_error">
  I'm sorry, it appears that you did not enter a valid numeric
  quantity <br>(whole numbers greater than zero).<br>Please use your 
  browser's Back button and try again. Thanks\!
</p>
!;
}
&StoreFooter;

$sc_bad_order_note_alt = '';

&call_exit;

}
#######################################################################
#                    make_hidden_fields Subroutine                    #
#######################################################################

    # make_hidden_fields is used to generate the hidden fields
    # necessary for maintaining state.  It takes no arguments
    # and is called with the following syntax:
    #
    # &make_hidden_fields;


sub make_hidden_fields {

local($hidden,$db_query_row,$temp,$db_form_field);
local($special_stuff)='';

&xss_FormData_cleaner;

    # $hidden is defined initially as containing the cart_id
    # and page hidden tags which are necessry state variables
    # on EVERY page in the cart.
    #
    # The script then goes through  checking to see which
    # optional state variables it has received as incoming
    # form data.  For each of those, it adds a hidden input
    # tag.

if ($sc_running_an_SSI_store =~ /yes/i) {

  $special_stuff.='  <input type="hidden" name="SSI" value="1">'."\n";
  $special_stuff.='  <input type="hidden" name="crtmod" value="';
  $special_stuff.= &make_random_chars . "\">\n";  

 }

$hidden = qq!$special_stuff
  <input type="hidden" name="cart_id" value="$cart_id">
  <input type="hidden" name="page" value="$form_data{'page'}">!;


if ($form_data{'keywords'} ne "") 
{
$temp = $form_data{'keywords'};
$temp =~ s/\0/ /g; #multi values should be sep. by blanks
$temp =~ s/(\s+)/ /g; #de-multi-blank it
$temp =~ s/(^\s)//g;  #remove leading blank, if there
$hidden .= qq!
<input type="hidden" name="keywords" value="$temp">!;
}

if ($form_data{'cartlink'} ne "") 
{
$hidden .= qq!
<input type="hidden" name="cartlink" value="$form_data{'cartlink'}">!;
}

if ($form_data{'next'} ne "") 
{
$hidden .= qq!
<input type="hidden" name="next" value="$form_data{'next'}">!;
}

if ($form_data{'ppinc'} ne "") 
{
$hidden .= qq!
<input type="hidden" name="ppinc" value="$form_data{'ppinc'}">!;
}

if ($form_data{'maxp'} ne "") 
{
$hidden .= qq!
<input type="hidden" name="maxp" value="$form_data{'maxp'}">!;
}

if ($form_data{'exact_match'} ne "") 
{
$hidden .= qq!
<input type="hidden" name="exact_match" value="$form_data{'exact_match'}">!;
}

if ($form_data{'case_sensitive'} ne "") 
{
$hidden .= qq!
<input type="hidden" name="case_sensitive" value="$form_data{'case_sensitive'}">!;
}

# Added by Mister Ed June 20, 2005
if ($form_data{'affiliate'} ne "") 
{
$hidden .= qq!
<input type="hidden" name="affiliate" value="$form_data{'affiliate'}">!;
}

# Added by Mister Ed June 20, 2005
if ($form_data{'member'} ne "") 
{
$hidden .= qq!
<input type="hidden" name="member" value="$form_data{'member'}">!;
}

# Added by Mister Ed June 20, 2005
if ($form_data{'pricing'} ne "") 
{
$hidden .= qq!
<input type="hidden" name="pricing" value="$form_data{'pricing'}">!;
}

foreach $db_query_row (@sc_db_query_criteria) 
{
$db_form_field = (split(/\|/, $db_query_row))[0];
if ($form_data{$db_form_field} ne "" && $db_form_field ne "keywords") 
{
$hidden .= qq!
<input type="hidden" name="$db_form_field" value="$form_data{$db_form_field}">!;
}
}

# Added to maintain custom header - added by sb Oct 08, 2008 
if ($form_data{'hdr'} ne "") 
{ 
$hidden .= qq! 
<INPUT TYPE = "hidden" NAME = "hdr" VALUE = "$form_data{'hdr'}">!; 
}


&codehook("make_hidden_fields_bot");
return ($hidden);

# End of make_hidden_fields
}

#######################################################################
#                     make_href_fields Subroutine                     #
#######################################################################

    # make_href_fields is used to generate the href fields
    # necessary for maintaining state.  It takes no arguments
    # and is called with the following syntax:
    #
    # &make_href_fields;


sub make_href_fields {

local($href) = "";
local($db_query_row, $db_form_field, $temp);

    # $hidden is defined initially as containing the cart_id
    # and page hidden tags which are necessry state variables
    # on EVERY page in the cart.
    #
    # The script then goes through  checking to see which
    # optional state variables it has received as incoming
    # form data.  For each of those, it adds a hidden input
    # tag.

&xss_FormData_cleaner;

my $temp_first_amper_count = 1;

if ($sc_global_bot_tracker ne "1") {
$href = "cart_id=" . &str_encode($cart_id);
$temp_first_amper_count++;
}

if ($form_data{'page'} ne "")
{ 
if ($temp_first_amper_count > 1) {
$href .= "&amp;page=" . &str_encode($form_data{'page'});
}
else {
$href .= "page=" . &str_encode($form_data{'page'});
$temp_first_amper_count++;
}
}

if ($form_data{'keywords'} ne "") 
{
$temp = $form_data{'keywords'};
$temp = &str_encode($temp);
if ($temp_first_amper_count > 1) {
$href .= "&amp;keywords=$temp";
}
else {
$href .= "keywords=$temp";
$temp_first_amper_count++;
}
}

if ($form_data{'next'} ne "") 
{
if ($temp_first_amper_count > 1) {
$href .= "&amp;next=$form_data{'next'}";
}
else {
$href .= "next=$form_data{'next'}";
$temp_first_amper_count++;
}
}

if ($form_data{'maxp'} ne "") 
{
if ($temp_first_amper_count > 1) {
$href .= "&amp;maxp=$form_data{'maxp'}";
}
else {
$href .= "maxp=$form_data{'maxp'}";
$temp_first_amper_count++;
}
}

if ($form_data{'ppinc'} ne "") 
{
if ($temp_first_amper_count > 1) {
$href .= "&amp;ppinc=" . &str_encode($form_data{'ppinc'});
}
else {
$href .= "ppinc=" . &str_encode($form_data{'ppinc'});
$temp_first_amper_count++;
}
}

if ($form_data{'exact_match'} ne "") 
{
if ($temp_first_amper_count > 1) {
$href .= "&amp;exact_match=$form_data{'exact_match'}";
}
else {
$href .= "exact_match=$form_data{'exact_match'}";
$temp_first_amper_count++;
}
}

if ($form_data{'case_sensitive'} ne "") 
{
if ($temp_first_amper_count > 1) {
$href .= "&amp;case_sensitive=$form_data{'case_sensitive'}";
}
else {
$href .= "case_sensitive=$form_data{'case_sensitive'}";
$temp_first_amper_count++;
}
}

# Added by Mister Ed June 20, 2005
if ($form_data{'affiliate'} ne "") 
{
if ($temp_first_amper_count > 1) {
$href .= "&amp;affiliate=$form_data{'affiliate'}";
}
else {
$href .= "affiliate=$form_data{'affiliate'}";
$temp_first_amper_count++;
}
}

# Added by Mister Ed June 20, 2005
if ($form_data{'member'} ne "") 
{
if ($temp_first_amper_count > 1) {
$href .= "&amp;member=$form_data{'member'}";
}
else {
$href .= "member=$form_data{'member'}";
$temp_first_amper_count++;
}
}

# Added by Mister Ed June 20, 2005
if ($form_data{'pricing'} ne "") 
{
if ($temp_first_amper_count > 1) {
$href .= "&amp;pricing=$form_data{'pricing'}";
}
else {
$href .= "pricing=$form_data{'pricing'}";
$temp_first_amper_count++;
}
}

# Added by Mister Ed Nov 15, 2008
if ($form_data{'hdr'} ne "") 
{
if ($temp_first_amper_count > 1) {
$href .= "&amp;hdr=$form_data{'hdr'}";
}
else {
$href .= "hdr=$form_data{'hdr'}";
$temp_first_amper_count++;
}
}

foreach $db_query_row (@sc_db_query_criteria) 
{
$db_form_field = (split(/\|/, $db_query_row))[0];
if ($form_data{$db_form_field} ne "" && $db_form_field ne "keywords") 
{
if ($temp_first_amper_count > 1) {
$href .= "&amp;$db_form_field=" . &str_encode($form_data{$db_form_field});
}
else {
$href .= "$db_form_field=" . &str_encode($form_data{$db_form_field});
$temp_first_amper_count++;
}
}

}

&codehook("make_href_fields_bot");
return ($href);

# End of make_href_fields
}


#######################################################################
#                   PrintNoHitsBodyHTML Subroutine                    #
#######################################################################

    # PrintNoHitsBodyHTML is utilized by the HTML-based store
    # search routines to produce an error message in case no
    # hits were found based on the client-defined keyords
    # It is called with no argumnets and the following syntax:
    #
    # &PrintNoHitsBodyHTML;


sub PrintNoHitsBodyHTML {

print qq~$sc_doctype
<html>

<head>
  <title>Search Found No Entries</title>
  $sc_standard_head_info
  
  $sc_special_page_meta_tags

</head>
<body>
~;

&StoreHeader;

# edited error message and moved to managers for customization. added by Mister Ed August 15, 2006
# also need a default jsut in case not set in managers
if ($sc_search_error_message eq "") {
    $sc_search_error_message = qq~I'm sorry, no matches were found. Please try your search again.~;
}
print qq!
<div align="center">
<p class="ac_search_no_results">
$sc_search_error_message
  </p>
</div>
!;
&StoreFooter;
print qq!
</body>
</html>
!;

}
#######################################################################
#                     capture_STDOUT Subroutine                       #
#######################################################################
  
  # This subroutine redirects STDOUT to a file

sub capture_STDOUT {
 $capture_STDOUT++;
 $CAPTURE_SAVE[$capture_STDOUT] = select(); #current value of STDOUT;

 open(MYSTDOUT,">$sc_capture_path$capture_STDOUT");
 select(MYSTDOUT);
 $CAPTURE_CURRENT[$capture_STDOUT] = MYSTDOUT;
} #end of sub capture_STDOUT
#######################################################################
#                    uncapture_STDOUT Subroutine                      #
#######################################################################
  
  # This subroutine un-redirects STDOUT to a file, returns that file's
  # contents in a string.

sub uncapture_STDOUT {
 local($contents)="";

 if ($capture_STDOUT < 1) { #not already doing it, nada to return 
   return "";
  }
 select($CAPTURE_SAVE[$capture_STDOUT]); #previous value of STDOUT;
 close($CAPTURE_CURRENT[$capture_STDOUT]);
{
 open(MYFILE,"$sc_capture_path$capture_STDOUT"); #now need to read it
 local $/=undef;
 $contents=<MYFILE>;
 close(MYFILE);
}
 unlink("$sc_capture_path$capture_STDOUT"); #and need to remove it
 $capture_STDOUT = $capture_STDOUT - 1;
 return "$contents";

} #end of sub uncapture_STDOUT
#######################################################################
#                       agorascript Subroutine                        #
#######################################################################
  
# This subroutine runs <!--agorascript scripts

sub agorascript {
 local ($str, $type, $zhtml, $zfile, $zline) = @_;
 local ($script_start, $script_start_short, $part1, $part1a, $part2)="";
 local ($kount,$iterations)=0;
 local ($err_code,$return_val,$ztype)="";
 local ($on_agorascript_error)="warn exit ";
 
 if ($type ne "") {
   $ztype = "-$type";
  } else {
   $ztype = "";
  } 
 $script_start_short = "agorascript$ztype";
 $script_start = "<!--agorascript$ztype";
 $script_end = "-->";

# delete any agorascript continuation markers
$str =~ s/<!--AGSC//ig;
$str =~ s/AGSC-->//ig;

$str =~ s/<!--  agorascript/<!-- agorascript/g;# so either works OK
$str =~ s/<!-- agorascript/<!--agorascript/g;# so either works OK
$str =~ s/<!--agorascript$ztype\n/<!--agorascript$ztype /g;# -->

$part1=$str;
while (($iterations < 25) && ($str =~ /${script_start_short} /)) {
 $iterations++;
 $kount=0;
 ($part1,$part2) = split(/${script_start} /,$str,2);
 while ($part2 ne "") {
  ($the_script,$part2) = split(/$script_end/,$part2,2);
# Taint mode needs to be cleared ... potential security hole here is 
# small, as we only do this routine if we read the file in from our
# own directory of files we create ourselves.
# however, the eval itself will still fail if an unsafe operation
# is attempted with a tainted variable.
  $the_script =~ /([^\xFF]*)/;# should I make this ^M???
  $the_script = $1;
# now run the script 
  if ($sc_use_agorascript =~ /yes/i) {
   $return_val = eval($the_script);
   $err_code = $@;
  }
  if ($err_code ne "") { #script died, error of some kind
    if ($on_agorascript_error =~ /warn/i) { # error log
       &update_error_log("agorascript$ztype #$iterations.$kount error" .
                         "($zhtml) $err_code ",$zfile,$zline);
      }
    if ($on_agorascript_error =~ /screen/i) { # error to STDOUT
       print "<CENTER><DIV ALIGN=LEFT><TABLE WIDTH=550><TR><TD><PRE>\n";
       print "AGORASCRIPT ERROR:\n";
       print "agorascript-$type instance #$kount\n";
       print "Filename: $zhtml\n";
       print "Error: $err_code\n";
       print "</PRE></TD></TR></TABLE></DIV></CENTER>\n"; 
      }
    if ($on_agorascript_error =~ /exit/i) { # error log
      open(ERROR, $error_page);
      while (<ERROR>) {
        print $_;
       }
      close (ERROR);
      &call_exit;
     }
    if ($on_agorascript_error =~ /discard/i) { # error log
      $return_val = ""; # discard the erroneous results
     }
   }
  $part1 .= $return_val;# got here, so add the info
  $kount++;
  ($part1a,$part2) = split(/$script_start/,$part2,2);
  $part1 .= $part1a;
 } # end of inner while
 $str = $part1;
 $str =~ s/<!--  agorascript-/<!-- agorascript-/g;# so either works OK
 $str =~ s/<!-- agorascript-/<!--agorascript-/g;# so either works OK
} # end of outter while

 return $part1;

}

#######################################################################
#                       StoreHeaderFooter Subroutine                  #
#######################################################################


sub StoreHeaderFooter {
local ($zfile,$ztitle) = @_;
local ($the_file,$very_first_part,$junk);
local ($item_ordered_message) = "";
local ($myproduct);

$myproduct = $form_data{'product'};
if ($sc_convert_product_token_underlines ne "") {
  $myproduct =~ s/\_/$sc_convert_product_token_underlines/g;
 }

open (MYFILE, "$zfile");
read(MYFILE,$the_file,204800);
close (MYFILE);

($very_first_part,$the_file,$junk) = 
  split(/<h3>--cut here--<\/h3>/i,$the_file,3);
if ($the_file eq "") {
  $the_file = $very_first_part;
 }

# debug
# if ($cart_id eq "") { print "EMPTY CART VALUE! -- $ztitle<br>\n";}

$href_fields = &make_href_fields;
$hidden_fields = &make_hidden_fields;
$cart_id_for_html = "%%ZZZ%%";

if (($form_data{'add_to_cart_button'} ne "" )&&
    ($sc_shall_i_let_client_know_item_added =~ /yes/i)) {
  $item_ordered_message = $sc_item_ordered_msg_token;
 }

$the_file = &agorascript($the_file,"pre","$ztitle",__FILE,__LINE__);

$the_file =~ s/%%item_ordered_msg%%/$item_ordered_message/g;
$the_file =~ s/%%StepOneURL%%/$sc_stepone_order_script_url/ig;
$the_file =~ s/%%ScriptURL%%/$sc_main_script_url/ig;
$the_file =~ s/%%ScriptPostURL%%/$sc_main_script_post_url/ig;
$the_file =~ s/%%gateway_username%%/$sc_gateway_username/g;
if ($sc_global_bot_tracker eq "1") {
$the_file =~ s/cart_id=%%cart_id%%/cart_id=/g;
$the_file =~ s/cart_id=//g;
$the_file =~ s/%%cart_id%%//g;
}
else {
$the_file =~ s/cart_id=%%cart_id%%/cart_id=/g;
$the_file =~ s/cart_id=/cart_id=$cart_id_for_html/g;
$the_file =~ s/%%cart_id%%/$cart_id_for_html/g;
}
$the_file =~ s/%%href_fields%%/$href_fields/g;
$the_file =~ s/%%make_hidden_fields%%/$hidden_fields/g;
$the_file =~ s/%%ppinc%%/$form_data{'ppinc'}/g;
$the_file =~ s/%%maxp%%/$form_data{'maxp'}/g;
$the_file =~ s/%%page%%/$page/g;
$the_file =~ s/%%cartlink%%/$cartlink/g;
$the_file =~ s/%%date%%/$date/g;
$the_file =~ s/%%product%%/$myproduct/g;
$the_file =~ s/%%p_id%%/$form_data{'p_id'}/g;
$the_file =~ s/%%keywords%%/$keywords/g;
$the_file =~ s/%%next%%/$form_data{'next'}/g;
$the_file =~ s/%%exact_match%%/$form_data{'exact_match'}/g;
$the_file =~ s/%%exact_case%%/$form_data{'exact_case'}/g;
$the_file =~ s/%%URLofImages%%/$URL_of_images_directory/g;
$the_file =~ s/%%agoracgi_ver%%/$versions{'agora.cgi'}/g;
$the_file =~ s/%%affiliate%%/$form_data{'affiliate'}/g;
$the_file =~ s/%%member%%/$form_data{'member'}/g;
$the_file =~ s/%%TemplateName%%/$sc_headerTemplateName/ig;
$the_file =~ s/%%sc_money_symbol%%/$sc_money_symbol/ig;
$the_file =~ s/%%ButtonSetURL%%/$sc_buttonSetURL/ig;

if ($sc_global_bot_tracker ne "1") {
while ($the_file =~ /%%ZZZ%%/) {
  $the_file =~ s/%%ZZZ%%/$cart_id/;
}
}

$the_file = &agorascript($the_file,"post","$ztitle",__FILE,__LINE__);

return $the_file;

}
#######################################################################
#                       StoreHeader Subroutine                        #
#######################################################################
sub StoreHeader {
 print &GetStoreHeader;
}
sub GetStoreHeader {
my $temp_header_thingy = "$sc_store_header_file";
# dynamic store header by category name, if exists
# otherwise use default.  Added by Mister Ed Jan 11, 2005
 if (($sc_use_category_name_as_header =~ /yes/i) && ($form_data{'order_form_button.x'} eq "") && ($form_data{'dc'} eq "")) { 
   my $myproduct = "$form_data{'product'}";
   if ($sc_convert_product_token_underlines ne "") {
    $myproduct =~ s/\_/$sc_convert_product_token_underlines/g;
   }
    if (-f "$sc_templates_dir/header-$myproduct.inc") {
       $temp_header_thingy = "$sc_templates_dir/header-$myproduct.inc";
      }
 } 
# end of dynamic header

 return &StoreHeaderFooter("$temp_header_thingy","Store Header");
}
#######################################################################
#                       StoreFooter Subroutine                        #
#######################################################################

sub StoreFooter {
 print &GetStoreFooter;
}
sub GetStoreFooter {

my $temp_footer_thingy = "$sc_store_footer_file";
# dynamic store footer by category name, if exists
# otherwise use default.  Added by Mister Ed Jan 11, 2005
 if (($sc_use_category_name_as_header =~ /yes/i) && ($form_data{'order_form_button.x'} eq "") && ($form_data{'order_form_button'} ne 1) && ($form_data{'dc'} eq "")&& ($form_data{'dc'} ne 1)) { 
   my $myproduct = "$form_data{'product'}";
   if ($sc_convert_product_token_underlines ne "") {
     $myproduct =~ s/\_/$sc_convert_product_token_underlines/g;
   }
    if (-f "$sc_templates_dir/footer-$myproduct.inc") { 
       $temp_footer_thingy = "$sc_templates_dir/footer-$myproduct.inc";
      }
 } 
# End of dynamic footer

 return &StoreHeaderFooter("$temp_footer_thingy","Store Footer");
}
#######################################################################
#                    SecureStoreHeader Subroutine                     #
#######################################################################
sub SecureStoreHeader {
 print &GetSecureStoreHeader;
}
sub GetSecureStoreHeader {
 return &StoreHeaderFooter("$sc_secure_store_header_file",
        "Secure Store Header");
}
#######################################################################
#                    SecureStoreFooter Subroutine                     #
#######################################################################
sub SecureStoreFooter {
 print &GetSecureStoreFooter;
}
sub GetSecureStoreFooter {
 return &StoreHeaderFooter("$sc_secure_store_footer_file",
        "Secure Store Footer");
}
#######################################################################
#                     load_cart_copy Subroutine                       #
#######################################################################
sub load_cart_copy {

 local(@cart_fields,$temp);
 local($kount)=100;

 open (CART, "$sc_cart_path") ||
 &file_open_error("$sc_cart_path", "load_cart_contents", 
  __FILE__, __LINE__);

 while (<CART>) {
   chop;    
   $temp = $_;
   $kount++;
   $cart_copy{$kount} = $temp;
  }
 close(CART);
 $sc_cart_copy_made = "yes";
}

#######################################################################
#                     save_cart_copy Subroutine                       #
#######################################################################

sub save_cart_copy {

 local(@cart_fields,$cart_row_number,$temp,$inx);

 open (CART, ">$sc_cart_path") ||
 &file_open_error("$sc_cart_path", "save_cart_contents", 
  __FILE__, __LINE__);

 foreach $inx (sort (keys %cart_copy)) {
   $temp = $cart_copy{$inx};
   print CART $temp,"\n";
  }
 close(CART);
}
########################################################################
sub update_special_variable_options {
  local ($var_opt_action) = @_;
  my ($inx_into_cart_copy,$inx,$inx_into_cart_copy);
  my ($cart_line,$temp,$code,$option_file,$script_type);
  my ($options_list,@temp_data,%orig_row_options,$display_option_price);
  my ($o_name,$o_price,$o_ship,$c_name,$c_price,$c_ship);
  my ($options_list,$options,$zkey,$zdata,$change,%to_do_list);
  local (@cart_row,%cart_row_options);
  local ($var_opt_used) = 'no';
  if ($sc_disable_variable_options =~ /yes/i) { return;}
  &load_cart_copy;
  foreach $inx_into_cart_copy (sort(keys %cart_copy)) {
    $cart_line = $cart_copy{$inx_into_cart_copy};
    @cart_row = split(/\|/,$cart_line);
    $options_list = $cart_row[$cart{"options_ids"}];
    @temp_data = split(/$sc_opt_sep_marker/,$options_list);
    undef(%cart_row_options);
    undef(%orig_row_options);
    foreach $inx (@temp_data) { 
      ($zkey,$zdata) = split(/\*/,$inx,2);
      $zdata =~ s/\~/\|/g;
      $cart_row_options{$zkey} = $zdata;
      $orig_row_options{$zkey} = $zdata;
     }
    $codelist = $cart_row[$cart{"user1"}];
    if ($codelist ne '') {
      $var_opt_used = 'yes';
      @code_items = split(/\;/,$codelist);
      foreach $code (@code_items) {
        ($option_file,$script_type) = split(/,/,$code,2);
        $option_file = "$sc_options_directory_path/$option_file";
        if (-f "$option_file") {
          open (ZOPTFILE, "<$option_file") ||
            &file_open_error("$option_file","Variable Options",
              __FILE__,__LINE__);
          read (ZOPTFILE,$code,204800);
          close (ZOPTFILE);
          $code = &agorascript($code,$script_type,"Variable Options",
              __FILE__,__LINE__);
         }
       }
     }
  # reconstruct the options data in the cart row based on 'current' data
  # also make adjustments to shipping and price fields
    $options_list = '';
    $options = '';
    undef(%to_do_list);
    foreach $zkey (sort(keys %cart_row_options)) {
      $to_do_list{$zkey}=1;
     }
    foreach $zkey (sort(keys %orig_row_options)) {
      $to_do_list{$zkey}=1;
     }
    foreach $zkey (sort(keys %to_do_list)) {
      $cart_option = $cart_row_options{$zkey}; 
      $orig_option = $orig_row_options{$zkey}; 
      if ($options_list ne '') { $options_list .= $sc_opt_sep_marker;}
      ($o_name,$o_price,$o_ship) = split(/\|/,$orig_option,3);
      ($c_name,$c_price,$c_ship) = split(/\|/,$cart_option,3);
      $change = $c_price - $o_price;
      $inx = $cart{'price_after_options'};
      $cart_row[$inx] = $cart_row[$inx] + $change;
      $change = $c_ship - $o_ship;
      $inx = $cart{'shipping'};
      $cart_row[$inx] = $cart_row[$inx] + $change;
      if ($cart_option ne '') {
        $temp = $cart_option;
        $temp =~ s/\|/\~/g;
        $options_list .= $zkey . '*' . $temp;
        if ((0 + $c_price) == 0) { #price zero, do not display it 
          $display_option_price = "";
         } else { # price non-zero, must format it
          $display_option_price = " " . &display_price($c_price);
         }
        if ($options ne "") { $options .= "$sc_opt_sep_marker"; }
        $options .= "$c_name$display_option_price";
       }
     }
    $cart_row[$cart{'options_ids'}] = $options_list;
    $cart_row[$cart{'options'}] = $options;
   # save the newly constructed cart row
    $cart_copy{$inx_into_cart_copy} = join('|',@cart_row);
   }
  if ($var_opt_used =~ /yes/i) {
    &save_cart_copy;
   }
 }
#######################################################################
#                  create_display_fields Subroutine                   #
#######################################################################
# fixed dynamic .inc files by category
# by Mister Ed (K-Factor Technologies, Inc) 10/16/2003

sub create_display_fields {
local (@database_fields) = @_;
local ($id_index,$display_index,$category);
local ($continue)='yes';
&codehook("create_display_fields_top");
if ($continue ne 'yes') {return;}

# create @display_fields, @item_ids, $itemID variables

    # First, however, we must format the fields correctly.
    # Initially, @display_fields is created which contains the
    # values of every field to be displayed, including a
    # formatted price field.

@display_fields = ();
@temp_fields = @database_fields;
foreach $display_index (@sc_db_index_for_display) 

{

if ($display_index == $sc_db_index_of_price)

{  
$temp_fields[$sc_db_index_of_price] =
&display_price($temp_fields[$sc_db_index_of_price]);
}

push(@display_fields, $temp_fields[$display_index]);
}

    # Then, the elements of the NAME field are created so that
    # customers will be able to specify an item to purchase.
    # We are careful to substitute double quote marks ("), and
    # greater and less than signs (>,<) for the tags ~qq~,
    # ~gt~, and ~lt~. The reason that this must be done is so
    # that any double quote, greater than, or less than
    # characters used in URL strings can be stuffed safely
    # into the cart and passed as part of the NAME argumnet in
    # the "add item" form.  Consider the following item name
    # which must include an image tag.
    #
    # <INPUT TYPE = "text" 
    #        NAME = "item-0010|Vowels|15.98|The letter A|~lt~IMG SRC = ~qq~Html/Images/a.jpg~qq~ ALIGN = ~qq~left~qq~~gt~"
    #
    # Notice that the URL must be edited. If it were not, how
    # would the browser understand how to interpret the form
    # tag?  The form tag uses the double quote, greater
    # than, and less than characters in its own processing.

@item_ids = ();

foreach $id_index (@sc_db_index_for_defining_item_id) 
{
$database_fields[$id_index] =~ s/\"/~qq~/g;
$database_fields[$id_index] =~ s/\>/~gt~/g;
$database_fields[$id_index] =~ s/\</~lt~/g;

push(@item_ids, $database_fields[$id_index]);
  
}

$itemID = join("\|",@item_ids);

# dynamic ppinc layouts by category name
$ppinc_root_name = 'productPage';
 if ($sc_use_category_name_as_ppinc_root eq "yes"  && $form_data{'ppinc'} ne "search" && $form_data{'ppinc'} ne "search2" && $form_data{'ppinc'} eq "") { 
  my $myproduct = $database_fields[$db{'product'}];
  if ($sc_convert_product_token_underlines ne "") {
    $myproduct =~ s/\_/$sc_convert_product_token_underlines/g;
   }
    if (-f "$sc_templates_dir/$myproduct.inc") {
       $ppinc_root_name = $myproduct;
      }
 } 
&codehook("create_display_fields_bot");
}
#######################################################################
sub itemID { # used to allow an alternate %%itemID%% string using a token
 # like %%itemID-a%% in a productPage.inc file 
 local ($my_modifier) = @_;
 local (@stuff) = @item_ids;
 if ($my_modifier ne '') {
   @stuff[0] .= $sc_web_pid_sep_char . $my_modifier;
  }
 return "item-" . join("\|",@stuff);
}
#######################################################################
sub prodID { # used to allow an alternate %%ProductID%% string using a 
 # token like %%prodID-a%% in a productPage.inc file 
 local ($my_modifier) = @_;
 local (@stuff) = @item_ids;
 if ($my_modifier ne '') {
   @stuff[0] .= $sc_web_pid_sep_char . $my_modifier;
  }
 return $stuff[0];
}
#######################################################################
sub QtyBox { # allow an alternate %%QtyBox%% string using a token
 # like %%QtyBox-a,1%% in a productPage.inc file 
 local ($my_modifier,$qty) = @_;
 local ($my_box) = $qty_box_html;
 local ($my_pid) = &prodID($my_modifier);
 local ($my_item_id) = &itemID($my_modifier);
 $my_box =~ s/%%itemID%%/$my_item_id/ig;
 $my_box =~ s/%%prodID%%/$my_pid/ig;
 $my_box =~ s/%%ProductID%%/$my_pid/ig;
 $my_box =~ s/%%Product_ID%%/$my_pid/ig;
 $my_box =~ s/%%Qty%%/$qty/ig;
 return $my_box;
}
#######################################################################
#                    displayProductPage Subroutine                    #
#######################################################################
sub displayProductPage {
 print &prep_displayProductPage(&get_sc_ppinc_info);
}
#######################################################################
#                 prep_displayProductPage Subroutine                  #
#######################################################################
sub prep_displayProductPage {
local ($the_whole_page) = @_;
local ($keywords, $imageURL, $hidden_fields, $href_fields, $my_ppinc);
local ($myproduct);
local ($suppress_qty_box)='';
local ($qty_box_html) = '';
local ($qty)='';
local ($arg)="";
local ($xarg,$xarg1,$xarg2);
local ($myans)="";
local ($auto_opt_no)=0;
local ($inv)=""; # inventory

if ($sc_default_qty_to_display ne '') {
  $qty = $sc_default_qty_to_display;
 }
$myproduct = $form_data{'product'};
if ($sc_convert_product_token_underlines ne "") {
  $myproduct =~ s/\_/$sc_convert_product_token_underlines/g;
 }
$keywords = $form_data{'keywords'}; # for href, not <FORM>, fields
$keywords =~ s/ /+/g;

$href_fields = &make_href_fields;
$hidden_fields = &make_hidden_fields;
$cart_id_for_html = "%%ZZZ%%";

# Need to load option file first, if it has agorascript then
# we must be able to execute it
$the_whole_page =~ s/%%optionFile%%/$display_fields[3]/ig;

while ($the_whole_page =~ /(%%Load_Option_File )([^%]+)(%%)/i) {
  local($option_location);
  local($field) = "";
  $option_location = $2;
  $option_location =~ s/ //g;

  $field = &load_opt_file($option_location);
  $field = &option_prep($field,$option_location,$item_ids[0]);
  $the_whole_page =~ s/(%%Load_Option_File )([^%]+)(%%)/$field/i;
 }

$the_whole_page = &agorascript($the_whole_page,"pre",
                  "$my_ppinc",__FILE__,__LINE__);

&codehook("before_ppinc_token_substitution");

# checks inventory levels using user defined userfield
# added by Mister Ed @ K-Factor Technologies Jan 17, 2005
# fixed by Mister Ed November 13, 2008
if (($sc_db_index_for_inventory) && ($versions{'inventory_control.pl'} ne '')) {
if ($database_fields[$db{$sc_db_index_for_inventory}] > 0)
{
$inv = "$display_fields[4]";
    if ($sc_show_inventory_status =~ /yes/i) {
        $inv .= "<br><font class=ac_product_available>$sc_inventory_status_text $database_fields[$db{$sc_db_index_for_inventory}]<\/font>";
    }
} elsif ($database_fields[$db{$sc_db_index_for_inventory}] ne "") {
$inv = "<font class=ac_product_outofstock><br>$sc_out_of_stock_message<\/font>";
  $the_whole_page =~ s/%%Qty_Box%%/&nbsp;/ig;
  $the_whole_page =~ s/%%QtyBox%%/&nbsp;/ig;
  $the_whole_page =~ s/%%zeroQtyBox%%/&nbsp;/ig;
  $the_whole_page =~ s/(%%QtyBox-)([^%]+)(%%)/&nbsp;/ig;
  $the_whole_page =~ s/add_to_cart.gif/blank.gif/;
}
} # end check inventory userfield

$imageURL = $display_fields[0];
$imageURL =~ s/%%URLofImages%%/$URL_of_images_directory/g;
if ($qty_box_html eq '') {
  $qty_box_html = $sc_default_qty_box_html;
 }
$the_whole_page =~ s/%%Qty_Box%%/%%QtyBox/ig;
if ($suppress_qty_box) {
  $the_whole_page =~ s/%%QtyBox%%/&nbsp;/ig;
  $the_whole_page =~ s/%%zeroQtyBox%%/&nbsp;/ig;
 } else {
  $the_whole_page =~ s/%%QtyBox%%/$qty_box_html/ig;
 }

while ($the_whole_page =~ /(%%QtyBox-)([^%]+)(%%)/i) {
  $arg = $2;
 # if the qty part is not specified (or not even a comma) then use default
  ($arg1,$arg2,$junk) = split(/,/,$arg . ",$qty,",3);
  $arg1 =~ s/'//g;
  $arg1 =~ s/"//g;
  $arg2 =~ s/'//g;
  $arg2 =~ s/"//g;
  $myans = &QtyBox($arg1,$arg2);
  $the_whole_page =~ s/(%%QtyBox-)([^%]+)(%%)/$myans/i;
}

while ($the_whole_page =~ /%%zeroQtyBox/i) {
  $qty = "";
  $the_whole_page =~ s/%%zeroQtyBox%%/$qty_box_html/ig;
}

while ($the_whole_page =~ /(%%itemID-)([^%]+)(%%)/i) {
  $arg = $2;
  ($arg1,$arg2) = split(/,/,$arg,2);
  $arg1 =~ s/'//g;
  $arg1 =~ s/"//g;
  $myans = &itemID($arg1);
  $the_whole_page =~ s/(%%itemID-)([^%]+)(%%)/$myans/i;
}

while ($the_whole_page =~ /(%%prodID-)([^%]+)(%%)/i) {
  $arg = $2;
  ($arg1,$arg2) = split(/,/,$arg,2);
  $arg1 =~ s/'//g;
  $arg1 =~ s/"//g;
  $myans = &prodID($arg1);
  $the_whole_page =~ s/(%%prodID-)([^%]+)(%%)/$myans/i;
}

# checks inventory levels using user defined userfield
# added by Mister Ed @ K-Factor Technologies Jan 17, 2005
if ($sc_db_index_for_inventory) {
$inv = "$display_fields[4]";
if ($database_fields[$db{$sc_db_index_for_inventory}] > 0)
{
    if ($sc_show_inventory_status =~ /yes/i) {
        $inv .= "<br><font class=ac_product_available>$sc_inventory_status_text $database_fields[$db{$sc_db_index_for_inventory}]<\/font>";
    }
} elsif ($database_fields[$db{$sc_db_index_for_inventory}] ne "") {
$inv .= "<br><br><font class=ac_product_outofstock>$sc_out_of_stock_message<\/font>";
} 
} # end check inventory userfield

$the_whole_page =~ s/%%image%%/$imageURL/ig;
$the_whole_page =~ s/%%description%%/$display_fields[2]/ig;
$the_whole_page =~ s/%%Qty%%/$qty/ig;
$the_whole_page =~ s/%%userFieldOne%%/$display_fields[6]/ig;
$the_whole_page =~ s/%%userFieldTwo%%/$display_fields[7]/ig;
$the_whole_page =~ s/%%userFieldThree%%/$display_fields[8]/ig;
$the_whole_page =~ s/%%userFieldFour%%/$display_fields[9]/ig;
$the_whole_page =~ s/%%userFieldFive%%/$display_fields[10]/ig;
$the_whole_page =~ s/%%scriptURL%%/$sc_main_script_url/ig;
$the_whole_page =~ s/%%ScriptPostURL%%/$sc_main_script_post_url/ig;
$the_whole_page =~ s/%%StepOneURL%%/$sc_stepone_order_script_url/ig;
$the_whole_page =~ s/%%gateway_username%%/$sc_gateway_username/ig;

if ($sc_global_bot_tracker eq "1") {
$the_whole_page =~ s/%%CartID%%//g;
$the_whole_page =~ s/%%cartID%%//g;
$the_whole_page =~ s/cart_id=%%cart_id%%//g;
$the_whole_page =~ s/cart_id=//g;
$the_whole_page =~ s/%%cart_id%%//g;
}
else {
$the_whole_page =~ s/%%CartID%%/%%cart_id%%/ig;
$the_whole_page =~ s/%%cartID%%/%%cart_id%%/ig;
$the_whole_page =~ s/cart_id=%%cart_id%%/cart_id=/g;
$the_whole_page =~ s/cart_id=/cart_id=$cart_id_for_html/g;
$the_whole_page =~ s/%%cart_id%%/$cart_id_for_html/g;
}

$the_whole_page =~ s/%%agoracgi_ver%%/$versions{'agora.cgi'}/ig;
$the_whole_page =~ s/%%make_hidden_fields%%/$hidden_fields/ig;
$the_whole_page =~ s/%%ppinc%%/$form_data{'ppinc'}/ig;
$the_whole_page =~ s/%%maxp%%/$form_data{'maxp'}/ig;
$the_whole_page =~ s/%%page%%/$page/ig;
$the_whole_page =~ s/%%cartlink%%/$cartlink/ig;
$the_whole_page =~ s/%%p_id%%/$form_data{'p_id'}/ig;
$the_whole_page =~ s/%%keywords%%/$keywords/ig;
$the_whole_page =~ s/%%next%%/$form_data{'next'}/ig;

# portable next/prev token inspired by Dan - CartSolutions.net - Sept 1, 2008
if ($sc_use_alt_next_display =~ /Yes/) {
    $the_whole_page =~ s/%%alt_next%%/$prod_message/ig;
}

$the_whole_page =~ s/%%exact_match%%/$form_data{'exact_match'}/ig;
$the_whole_page =~ s/%%exact_case%%/$form_data{'exact_case'}/ig;
$the_whole_page =~ s/%%form_user1%%/$form_data{'user1'}/ig;
$the_whole_page =~ s/%%form_user2%%/$form_data{'user2'}/ig;
$the_whole_page =~ s/%%form_user3%%/$form_data{'user3'}/ig;
$the_whole_page =~ s/%%form_user4%%/$form_data{'user4'}/ig;
$the_whole_page =~ s/%%form_user5%%/$form_data{'user5'}/ig;
$the_whole_page =~ s/%%href_fields%%/$href_fields/ig;
$the_whole_page =~ s/%%image%%/$imageURL/ig;
# inventory update - by Mister Ed @ K-Factor Technologies, Inc.
# fixed by Mister Ed November 13, 2008
if (($sc_db_index_for_inventory) && ($versions{'inventory_control.pl'} ne '')) {
$the_whole_page =~ s/%%price%%/$inv/ig;
} else {
$the_whole_page =~ s/%%price%%/$display_fields[4]/ig;
}
$the_whole_page =~ s/%%cost%%/$item_ids[2]/ig;
$the_whole_page =~ s/%%shippingPrice%%/$display_fields[5]/ig;
$the_whole_page =~ s/%%shipping%%/$display_fields[5]/ig;
$the_whole_page =~ s/%%shippingWeight%%/$display_fields[5]/ig;
$the_whole_page =~ s/%%itemID%%/item-$itemID/ig;
$the_whole_page =~ s/%%Product_ID%%/%%prodID%%/ig;
$the_whole_page =~ s/%%ProductID%%/%%prodID%%/ig;
$the_whole_page =~ s/%%prodID%%/$item_ids[0]/ig;
$the_whole_page =~ s/%%CategoryID%%/$item_ids[1]/ig;
$the_whole_page =~ s/%%URLofImages%%/$URL_of_images_directory/ig;
$the_whole_page =~ s/%%TemplateName%%/$sc_headerTemplateName/ig;
$the_whole_page =~ s/%%sc_money_symbol%%/$sc_money_symbol/ig;
$the_whole_page =~ s/%%ButtonSetURL%%/$sc_buttonSetURL/ig;
$the_whole_page =~ s/%%product%%/$myproduct/ig;
$the_whole_page =~ s/%%name%%/$display_fields[1]/ig;

while ($the_whole_page =~ /%%ZZZ%%/) {
  $the_whole_page =~ s/%%ZZZ%%/$cart_id/;
}

# Do this before the evals
while ($the_whole_page =~ /%%AutoOptionNo%%/i) {
  $auto_opt_no = $auto_opt_no + 1;
  if ($auto_opt_no < 100) {$auto_opt_no = "0$auto_opt_no";} 
  if ($auto_opt_no < 10) {$auto_opt_no = "0$auto_opt_no";} 
  $the_whole_page =~ s/%%AutoOptionNo%%/$auto_opt_no/i;
}

$the_whole_page = &agorascript($the_whole_page,"autoopt",
                  "$my_ppinc",__FILE__,__LINE__);

while ($the_whole_page =~ /(%%eval)([^%]+)(%%)/i) {
  $arg = $2;
  $myans = eval($arg);
  if ($@ ne ""){ $myans = "%% Eval Error on: $arg %%";}
  $the_whole_page =~ s/(%%eval)([^%]+)(%%)/$myans/i;
}

&codehook("after_ppinc_token_substitution");

$the_whole_page = &agorascript($the_whole_page,"post",
                  "$my_ppinc",__FILE__,__LINE__);

return $the_whole_page;

}
#######################################################################
#                     get_sc_ppinc_info Subroutine                    #
#######################################################################
sub get_sc_ppinc_info {
 local ($my_ppinc,$the_whole_page,$keywords,$orig_ppinc);
 local ($used_default) = 0;


 if ($sc_ppinc_info ne "") { 
  # no need to load it, already have it
   return $sc_ppinc_info;    
  }

 $my_ppinc = "$sc_templates_dir/$ppinc_root_name";
 if ($form_data{'ppinc'} ne "") {
   $form_data{'ppinc'} =~ /([\w-_]+)/;
   $name = $1;
   $test = $my_ppinc ."-" . $name . ".inc";
   if (-f $test) {# this on-the-fly change is valid, use new file
     $my_ppinc = $test;
    } else {# don't break!  Just use default file
     $my_ppinc .= ".inc";
    }
  } else {
   $my_ppinc .= ".inc";
  }

 if (!(-f "$my_ppinc")) {
   $orig_ppinc = $my_ppinc;
   $my_ppinc = "$sc_templates_dir/productPage.inc";
   $used_default = 1;
  }

 open (PAGE, "$my_ppinc") ||
   &file_open_error("$sc_cart_path", "get ppinc -- $my_ppinc", 
     __FILE__, __LINE__);

 read(PAGE,$the_whole_page,102400); # 100K max size! Should be just a few K
 close PAGE;

 ($very_first_part,$the_whole_page,$junk) = 
  split(/<h3>--cut here--<\/h3>/i,$the_whole_page,3);
 if ($the_whole_page eq "") {
   $the_whole_page = $very_first_part;
  }

 if (($sc_debug_mode =~ /yes/i) && ($used_default == 1)) {
   $the_whole_page = "<!-- Used Default, $orig_ppinc not found. -->\n" . 
    $the_whole_page;
  }

 $sc_ppinc_info = $the_whole_page; # save for next time
 $last_ppinc_name = $my_ppinc;
 return $sc_ppinc_info;

}

#############################################################################
# Virtual Fields Subroutines
#
# These routines are independent of any particular database interface
#
# $VF_HOOK{'filename'} holds the default subroutine for vitual fields
# that do not use the standard one
# $VF_DEF{'filename'} holds the %hash name
# @RECORD is the set of fields for the current record
# $ID is the id number of the current record

sub vf_get_data {
  local ($VF_file,$fname,$ID,@RECORD) = @_;
  my $field,$xans,@REC;
  @REC = @RECORD; # alias
  return &vf_eval($fname);
 }

sub vf_eval {
  local ($fname) = @_;
  my $xcmd,$hname;
 # need to get the field itself from the field name
  $xcmd = '$field = $' . $VF_DEF{$VF_file} . '{"' . $fname . '"}';
  eval($xcmd);
  return &vf_do_eval_work($field);
 }

sub vf_do_eval_work {
  local ($field) = @_;
  my $ans,$result,$temp,$a1,$a2,$a3,$a4,$a5,$a6,$a7,$a8,$a9;
  $ans='';
  if ($VF_HOOK{$VF_file} ne '') {
    eval('&' . "$VF_HOOK{$VF_file};");
   } else {
    if (substr($field,0,1) eq '*') { # V-field
      eval(substr($field,1,9999));
      $err_code = $@;
      if ($err_code ne "") {
        &update_error_log("V-field ${field}($VF_file) error: $err_code",
    __FILE__,__LINE__);
       }
     } else { # D-field
      $ans = $RECORD[$field];
     }
   }
  return $ans;
 }
############################################################################
1; # library

