############################################################

$versions{'agora_order_lib.pl'} = "5.2.007";
# last modified by Mister Ed from K-Factor Technologies, Inc /  AgoraCart.com
# August 17, 2006
#
# Copyright 2001 - Present by K-Factor Technologies, Inc and AgoraCart.com
# All rights reserved.

&require_supporting_libraries (__FILE__, __LINE__,
      "$sc_mail_lib_path",
      "$sc_ship_lib_path");

&codehook("order_library_init");

#
# This library contains code for displaying/modifying the cart
# as well as processing the order.  This lib is only loaded 
# upon demand. 
#

#######################################################################
sub options_error_message {
# Added by Mister Ed at BytePipe.com / AgoraCart.com 2-18-2004.
# fixed to actually display the file, May 17, 2008 by Mister Ed
my @the_file='';
&standard_page_header("Options Error");

open (CARTSECURITY, "$sc_templates_dir/cart_options_security_add_error.inc") || &file_open_error("$sc_templates_dir/cart_options_security_add_error.inc", "Invalid Product Option Error Page Failed to Open", __FILE__, __LINE__);
$the_file=<CARTSECURITY>;
close (CARTSECURITY);

&StoreHeader;

if (-e "$sc_templates_dir/cart_options_security_add_error.inc") {
    open (CARTSECURITY, "$sc_templates_dir/cart_options_security_add_error.inc");
    @the_file=<CARTSECURITY>;
    close (CARTSECURITY);

    for $the_file(@the_file) {
        print "$the_file";
    }
} else {
    print qq|\n<!--begin options add error -->\n
<div align="center">
<p class="ac_error">
I'm sorry, it appears that you tried to add an invalid option to the product.  Please contact the Store Owner to report the error. Thanks.<BR>
</p>
</div>\n
<!--end options add error -->\n\n
|;
}

&StoreFooter;
}
#######################################################################
sub add_to_the_cart {
local (@database_rows, @database_fields, @item_ids, @display_fields);
local ($qty,$line,$line_no,$cart_row_qty,$cart_row_middle);
local ($junk,$zzzitem,$temp,$web_id_number)="";
local (%item_opt_verify,@lines,@testme);
local ($need_bad_order_note,$wildcard_id_number) = '';
local ($order_count)=0;
my ($failed) = '';
&checkReferrer;  

if (!($sc_db_lib_was_loaded =~ /yes/i)) {
  &require_supporting_libraries (__FILE__, __LINE__, "$sc_db_lib_path"); 
 }
open (CART, "+>>$sc_cart_path") || &file_open_error("$sc_cart_path", "Add to Shopping Cart", __FILE__, __LINE__);
$highest_item_number = 100; 
seek (CART, 0, 0); 
while (<CART>) 
{
chomp $_;
my @row = split (/\|/, $_); 
my $item_number_info = pop (@row);
($item_number,$item_modifier) = split(/\*/,$item_number_info,2);
$highest_item_number = $item_number if ($item_number > $highest_item_number);
}
close (CART);
&update_special_variable_options('reset');
@items_ordered = sort(keys (%form_data));
foreach $item (@items_ordered)
{
if (($item =~ /^item-/i || $item =~ /^option/i) && $form_data{$item} ne "")
{
$item =~ s/^item-//i;
if ($item =~ /^option/i)
{
push (@options, $item);
}
else
{
  $form_data{"item-$item"} =~ s/ //g; 
  if ((($form_data{"item-$item"} =~ /\D/) && ($form_data{"item-$item"} =~ /.?/g) && ( !($sc_ignore_bad_qty_on_add) )) || ($form_data{"item-$item"} < 0))
  {
  if (!($sc_ignore_bad_qty_on_add)) {$need_bad_order_note = 1;}
  }
  else
  {
  $quantity = $form_data{"item-$item"};
  if ($quantity > 0) {
    if ($failed) {
      $need_bad_order_note = 1;
    } else {
        push (@items_ordered_with_options, "$quantity\|$item\|");
        $order_count++;
      }
   }
  }

}
}
}

if (($order_count == 0) or ($need_bad_order_note)) { 
  $sc_shall_i_let_client_know_item_added = 'no';
  $temp = &get_agora('TRANSACTIONS');
  @temp = split(/\n/,$temp);
  $junk=pop(@temp);
  if ($junk eq $sc_unique_cart_modifier) {
    $temp = join("\n",@temp) . "\n";
    &set_agora('TRANSACTIONS',$temp);
   }
  if ($need_bad_order_note) {
    &bad_order_note;
   } else {
    &finish_add_to_the_cart;
   }
  return;
 }
foreach $item_ordered_with_options (@items_ordered_with_options)
{
&codehook("foreach_item_ordered_top");
$options = "";
$option_subtotal = "";
$option_grand_total = "";
$item_grand_total = "";
$item_ordered_with_options =~ s/~qq~/\"/g;
$item_ordered_with_options =~ s/~gt~/\>/g;
$item_ordered_with_options =~ s/~lt~/\</g;
# >
@cart_row = split (/\|/, $item_ordered_with_options);
&codehook("foreach_item_ordered_split_cart_row");
$web_id_number = $cart_row[$sc_cart_index_of_item_id];
if ($sc_web_pid_sep_char ne '') {
  ($cart_row[$sc_cart_index_of_item_id],$junk) =
  split(/$sc_web_pid_sep_char/,$cart_row[$sc_cart_index_of_item_id],2);
  $item_id_number = $cart_row[$sc_cart_index_of_item_id];
  $wildcard_id_number = $item_id_number . $sc_web_pid_sep_char . "*";
 } else {
  $item_id_number = $cart_row[$sc_cart_index_of_item_id];
  $wildcard_id_number = '';
}
$item_quantity = $cart_row[$sc_cart_index_of_quantity];
$item_price = $cart_row[$sc_cart_index_of_price];
$item_shipping = $cart_row[$cart{"shipping"}];
$item_option_numbers = "";
$item_user1 = "";
$item_user2 = "";

#make one read on alt origin and dimensional thingies
# add in alt origin state or province  by Mister Ed May 22, 2007
if (($sc_alt_origin_enabled =~ /yes/i)||($sc_dimensional_shipping_enabled =~ /yes/i)) {
my $shipping_string = &get_prod_shipping_dimensions_in_db_row($item_id_number);
my @shippingstuff =  split(/\,/,$shipping_string);

if ($sc_alt_origin_enabled =~ /yes/i) {
$item_user3 = "$shippingstuff[6],$shippingstuff[7]";
} else {
$item_user3 = "";
}

#old alt origin version
# alt origin postal code assigns to cart user3 by Mister Ed Feb 9, 2005
# if ($sc_alt_origin_enabled =~ /yes/i) {
# my $data_field_thingy = "$sc_alt_origin_db_counter";
#$item_user3 = &check_db_with_product_id_for_info($item_id_number,$data_field_thingy,*database_fields);
#} else {
#$item_user3 = "";
#}

#  shipping dimensions. added by Mister Ed May 13, 2007
if ($sc_dimensional_shipping_enabled =~ /yes/i) {
$item_user5 = "$shippingstuff[0],$shippingstuff[1],$shippingstuff[2],$shippingstuff[3],$shippingstuff[4],$shippingstuff[5]";
} else {
$item_user5 = "";
}
undef(@shippingstuff);
} # End if alt origin OR dimensions
# taxable or non-table. added by Mister Ed Sept 13, 2005
if ($sc_non_taxables_enabled =~ /yes/i) {
my $data_field_thingy = "$sc_non_taxables_db_counter";
$item_user4 = &check_db_with_product_id_for_info($item_id_number,$data_field_thingy,*database_fields);
} else {
$item_user4 = "";
}

$item_user6 = "";
$item_agorascript = "";
undef(%item_opt_verify);
$found = &check_db_with_product_id($item_id_number,*database_fields);
&create_display_fields(@database_fields);
&codehook("cart_add_read_db_item");
foreach $zzzitem (@database_fields) {
  $field = $zzzitem;
  if ($field =~ /^%%OPTION%%/i) {
    ($empty, $option_tag, $option_location) = split (/%%/, $field);
    $field = &load_opt_file($option_location);
    $junk = &option_prep($field,$option_location,$item_id_number);
    $junk = &prep_displayProductPage($junk);
    $item_agorascript .= $field;
   }
 }
&codehook("cart_add_read_item_agorascript");
foreach $option (@options)
{
($option_marker, $option_number, $option_item_number) = split (/\|/, $option);
if (($option_item_number eq "$web_id_number") || 
    ($option_item_number eq "$wildcard_id_number"))
{
$field = &agorascript($item_agorascript,"add-to-cart-opt-" . $option_number,
    "$option_location",__FILE__,__LINE__);
($option_name,$option_price,$option_shipping)=split(/\|/,$form_data{$option});
   if ((0 + $option_price) == 0) { #price zero, do not display it 
     $display_option_price = "";
    } elsif (($sc_negative_priced_options ne "yes") && ((0 + $option_price) < "0")) {
# Added by Mister Ed at BytePipe.com / AgoraCart.com 2-18-2004.
# if negative priced options disallowed, prevent addition to cart
if ($item_user1 eq "") {
$killitemthingy = "yes";
&options_error_message;
exit; }
} else { 
     # Added by Mister Ed August 9, 2006
     # toggles display of options pricing.  now can be turned off
     $display_option_price = " " . &display_price($option_price);
     if ($sc_turn_off_option_price_display =~ /off/i) {
          $display_option_price = "";
     }
  }
if($option_name) {
# Updated by Mister Ed at BytePipe.com / AgoraCart.com Feb-18-2004.  Now works and not just dead code
  if ($sc_use_verified_opt_values =~ /yes/i) { 
my $option_name_temp = "$option_name";
$option_name_temp =~ s/\(/\\(/g;
$option_name_temp =~ s/\)/\\)/g;
if ($field =~ /$option_name\|$option_price/ || $field =~ /$option_name\|$option_price\|$option_shipping/)  {
    $temp = $form_data{$option};
     } elsif ($item_user1 ne "") {
    $temp = $form_data{$option};
     } else {
$option_name=""; 
$killitemthingy = "yes";
$sc_unique_cart_modifier_orig = '';
$sc_unique_cart_modifier = '';
$option_price = '';
&options_error_message;
exit; 
    }
   } else {
    $temp = $form_data{$option};
   }
  if($option_name) {
   $temp =~ s/\|/~/g; 
   if ($item_option_numbers eq ""){
     $item_option_numbers = "${option_number}*$temp";
    } else {
     $item_option_numbers .= $sc_opt_sep_marker . "${option_number}*$temp";
    }
   if ($options ne "") { 
     $options .= "$sc_opt_sep_marker";
    }
   $options .= "$option_name$display_option_price";
   }
}
&codehook("process_cart_options");
if ($killitemthingy ne "yes") {
$item_shipping = $item_shipping + $option_shipping;
$unformatted_option_grand_total = $option_grand_total + $option_price;
$option_grand_total = &format_price($unformatted_option_grand_total);
} 
}
}
if ($killitemthingy ne "yes") {
$item_number = ++$highest_item_number;
$unformatted_item_grand_total = $item_price + $option_grand_total;
$item_grand_total = &format_price("$unformatted_item_grand_total");
$cart_row[$cart{"shipping"}] = $item_shipping;
$cart_row[$cart{"shipping_calc_flag"}] = "";
$cart_row[$cart{"options_ids"}] = $item_option_numbers;
$field = &agorascript($item_agorascript,"add-to-cart",
    "$option_location",__FILE__,__LINE__);
&codehook("before_build_cart_row");
$cart_row[$cart{"user1"}] = $item_user1;
$cart_row[$cart{"user2"}] = $item_user2;
$cart_row[$cart{"user3"}] = $item_user3;
$cart_row[$cart{"user4"}] = $item_user4;
$cart_row[$cart{"user5"}] = $item_user5;
$cart_row[$cart{"user6"}] = $item_user6;
foreach $field (@cart_row) {
  $cart_row .= "$field\|";
 }
$cart_row .= "$options\|$item_grand_total";
($cart_row_qty,$cart_row_middle) = split(/\|/,$cart_row,2);
$cart_row .= "\|$item_number\n";
&codehook("foreach_item_ordered_end");
&add_one_row_to_cart($cart_row,$cart_row_qty,$cart_row_middle);
$cart_row = '';
}
&update_special_variable_options('calculate');
} 
&finish_add_to_the_cart;
} 
############################################################
sub add_one_row_to_cart {
 local ($cart_row,$cart_row_qty,$cart_row_middle) = @_;
 local(@lines,@newlines,@testme,$qty,$orig_line,$line);
&codehook("before_add_cart_rows");
if (-e "$sc_cart_path")
{
open (CART, "$sc_cart_path") || &file_open_error("$sc_cart_path", "Add to Shopping Cart", __FILE__, __LINE__);
@lines = (<CART>);
close (CART);
open (CART, ">$sc_cart_path") || &file_open_error("$sc_cart_path", "Add to Shopping Cart", __FILE__, __LINE__);
local(@newlines) = ();
foreach $line (@lines) {
  $orig_line = $line;
  ($qty,$line) = split(/\|/,$line,2);
  (@testme) = split(/\|/,$line); 
  $line_no = pop(@testme);
  $line = join('|',@testme);
  if ($line eq $cart_row_middle) {
    $orig_line = ($qty+$cart_row_qty) . '|' . $line . '|' . $line_no;
    $cart_row_middle = '';
   }
  push(@newlines,$orig_line);
 }
if ($cart_row_middle ne '') {
  push(@newlines,$cart_row);
 }
@newlines = (sort { &middle_of_cart($a) <=> &middle_of_cart($b) } @newlines);
foreach $line (@newlines) {
  print CART "$line";
 }
close (CART);
}
else
{
open (CART, ">$sc_cart_path") || &file_open_error("$sc_cart_path", "Add to Shopping Cart", __FILE__, __LINE__);
print CART "$cart_row";
close (CART);
}
&codehook("after_add_cart_rows");
}
############################################################
sub middle_of_cart {
  local ($line) = @_;
  local ($qty,@testme,$line_no);
  ($qty,$line) = split(/\|/,$line,2);
  (@testme) = split(/\|/,$line); 
  $line_no = pop(@testme);
  $line = join('|',@testme);
  return $line;
 }
############################################################################
sub display_order_form {
  local($line,$the_file,@lines,$temp);
  local($subtotal,$taxable_grand_total);
  local($total_quantity);
  local($total_measured_quantity);
  local($text_of_cart);
  local($stevo_shipping_thing);
  local($hidden_fields);
  local($have_form_tag) = "no";
  local($form_name)=$sc_html_order_form_path;
  local($have_terminated_form_tag) = "no";
  local($continue) = 1;
  &codehook("order_form_entry");
  if ($continue == 0) { return;}
if ($sc_allow_ofn_choice =~ /yes/i) {
  if ($form_data{'order_form'} ne "") {
    $temp = "$sc_html_dir/forms/$form_data{'order_form'}-orderform.html";
    if (-f $temp) {
         $temp =~ /([^\xFF]*)/;
         $form_name = $1;
     }
  } else { # added by Mister Ed of BytePipe.com / AgoraCart.com Aug 2003 for multiple gateways without zOffline
     $temp = "$sc_html_dir/forms/combo-orderform.html";
      if (-f $temp) {
          $temp =~ /([^\xFF]*)/; 
          $form_name = $1;
      }
  }
}
&codehook("order_form_pre_read");
open (ORDERFORM, "$form_name") || &file_open_error("$form_name", 
    "Display Order Form File Error",__FILE__,__LINE__);
{
local $/=undef;
$the_file=<ORDERFORM>;
}

$the_file = &agorascript($the_file,"orderform","Order Form Prep 1",
       __FILE__, __LINE__);
&codehook("order_form_prep");
# first, need to process the $ vars ...
$the_file =~ s/\\/\\\\/g;
$the_file =~ s/\@/\\\@/g;
$the_file =~ s/\"/\\\"/g;
$the_file =~ /([^\xFF]*)/;# untaint
eval('$the_file = "' . $1 . '";');
$the_file = &script_and_substitute($the_file,"Order Form Prep 2");
@lines = split(/\n/,$the_file);
$done=0;
foreach $myline (@lines) {
$line = $myline . "\n";
if ($line =~ /<html>/i) { 
  $line="$sc_doctype\n<html>\n"; 
 }
if ($line =~ /<\/head>/i) { 
  $line="  $sc_standard_head_info\n</head>\n"; 
 }
if ($line =~ /<body/i) { 
  $line="<body>\n"; 
 }
# >
if ($line =~ /<form/i) {
$hidden_fields = &make_hidden_fields;
if (($have_form_tag eq "yes") && ($have_terminated_form_tag eq "no")) {
  print "</form>\n\n";
  
  $have_terminated_form_tag = "yes";
 } else { # have the first tag
  $have_form_tag = "yes";
 }

if ($sc_replace_orderform_form_tags =~ /yes/i) {

# changed for buysafe updates.
#  print qq!\n<form method="post" action="$sc_order_script_url">!;
  print qq!\n<form method="post" action="$sc_stepone_order_script_url">!;
  print $hidden_fields;
 } else {
  print "\n$line\n$hidden_fields\n";
 }

$line = "";
} 

if ($line =~ /<h2>cart.*contents.*h2>/i) {
if (($have_form_tag eq "yes") && ($have_terminated_form_tag eq "no")) {
  print "</form>\n\n";
  $have_terminated_form_tag = "yes";
 } 
$have_form_tag = "yes";
($taxable_grand_total,$subtotal, 
 $total_quantity,
 $total_measured_quantity,
 $text_of_cart,
 $stevo_shipping_thing) = &display_cart_table("orderform");      
$line = "";
}
if ($line =~ /\<\/body\>/i) {# >
  $done=1;
 } elsif ($line =~ /\<\/html>/i) {
  $done=1;
 } else {
  &codehook("print_order_form_line");
  print $line;
 }
} 
if  (($sc_gateway_name eq "Offline") ||
     ($sc_use_secure_footer_for_order_form =~ /yes/i)){
  &SecureStoreFooter;
 } else {
  &StoreFooter;
 }
print qq~
</body>
</html>
~;
} 
############################################################
sub vform_check {
  local($field,$val,$returnv) = @_;
  if ($vform{$field} eq $val) {return $returnv;}
  return "";
 }
############################################################
sub print_order_totals {
local($continue) = 1;
&codehook("print_order_totals_top");
if ($continue == 0) { return;}
print qq~<div align="center">
<table class="ac_totals_table">
<tr>
<th colspan="2">$sc_totals_table_thdr_label</th>
</tr>
<tr>
<td>${sc_totals_table_itot_label}:</td>
<td>$price</td>
</tr>
~;
if (($zfinal_shipping > 0) && ($sc_show_shipping_label_box =~ /yes/i))
{
$val =  &format_price($zfinal_shipping);
print qq~<tr>
<td>$sc_totals_table_ship_label</td>
<td>$val</td>
</tr>
~;
}
if ($zfinal_discount > 0)
{
$val =  &format_price($zfinal_discount);
print qq~<tr>
<td>$sc_totals_table_disc_label</td>
<td>$val</td>
</tr>
~;
}
if ($zfinal_sales_tax > 0)
{
$val =  &format_price($zfinal_sales_tax);
print qq~<tr>
<td>$sc_totals_table_stax_label</td>
<td>$val</td>
</tr>
~;
}
if ($zfinal_extra_tax1 > 0)
{
$val =  &format_price($zfinal_extra_tax1);
print qq~<tr>
<td>$sc_extra_tax1_name</td>
<td>$val</td>
</tr>
~;
}
if ($zfinal_extra_tax2 > 0)
{
$val =  &format_price($zfinal_extra_tax2);
print qq~<tr>
<td>$sc_extra_tax2_name</td>
<td>$val</td>
</tr>
~;
}
if ($zfinal_extra_tax3 > 0)
{
$val =  &format_price($zfinal_extra_tax3);
print qq~<tr>
<td>$sc_extra_tax3_name</td>
<td>$val</td>
</tr>
~;
}

# buySafe
if (($sc_buySafe_is_enabled =~ /yes/) && ($zfinal_buySafe > 0) && ($zsubtotal > 0)) {
if ($sc_buySafe_bond_fee_mini_display_text eq '') {$sc_buySafe_bond_fee_mini_display_text = "buySafe Bond :";}
$val =  &format_price($zfinal_buySafe);
print qq~<tr>
<td>$sc_buySafe_bond_fee_mini_display_text</td>
<td>$val</td>
</tr>
~;
}

print qq~<tr>
<td colspan=2>
  <img src=\"picserve.cgi?secpicserve=line.gif\" height="2" width="46" alt="------" />
</td>
</tr>
<tr>
~;

if (($sc_show_subtotal_label_box =~ /yes/i) && ($are_we_before_or_at_process_form =~ /before/i)) {
print qq~
<td>$sc_totals_table_subtot_label</td>
<td>$grand_total</td>

~;
} else {
print qq~
<td>$sc_totals_table_gtot_label</td>
<td>$grand_total</td>
~;
}
print qq~
</tr>
</table>
~;

# buysafe bonding button display, if successful and enabled
if (($sc_buySafe_is_enabled =~ /yes/) && ($sc_processing_order ne "yes") && ($sc_buySafe_bonding_signal !~ /HASH\(/i) && ($zsubtotal > 0)) {
my @buysafearraythingy = split(/&/,$sc_buySafe_bonding_signal,6);
my ($junk,$temp_buysafe_thingy) = split(/=/,$buysafearraythingy[4]);
my $buySafe_page_url = '';

    if (&form_check('display_cart')) {
        $buySafe_page_url = '&dc=1';
    } elsif (&form_check('dc')) {
        $buySafe_page_url = '&dc=1';
    } elsif (&form_check('order_form_button')) {
        $buySafe_page_url = '&order_form_button.x=1';
    }

    if ($temp_buysafe_thingy eq '') {
        $temp_buysafe_thingy = 'False';
    }

if (($temp_buysafe_thingy eq "True") && ($sc_buySafe_customer_desires_bond ne "") && ($sc_buySafe_customer_desires_bond eq "true")) { # print buysafe bond flash button

print qq|
<input type="hidden" name="removebuysafebond" value="true">
<input type="hidden" name="buySAFE" value="true">|;
print $sc_buySafe_bonding_signal;

    if ($sc_buySafe_bond_call_success =~ /true/i) {
print qq|<br /><br />
<span class="buysafe">
<a href="$sc_buySafe_cart_details_URL">
$sc_buySafe_cart_details_text</a>
<br /></span>
|;
    }
} else { # print add new buysafe bond button
print qq|
<input type="hidden" name="addbuysafebond" value="true">
<input type="hidden" name="buySAFE" value="false">
$sc_buySafe_bonding_signal<br /><br />
|;
    if ($sc_buySafe_bond_call_success =~ /true/i) {
print qq|
<span class="buysafe">
<a href="$sc_buySafe_cart_details_URL">
$sc_buySafe_cart_details_text</a>
<br /></span>
|;
    }
} #end of if/else on
} #end of buysafe bonding signal button display

print qq~
</div>
~;
}
############################################################
sub process_order_form {
local($subtotal, $total_quantity,
      $total_measured_quantity,
      $text_of_cart,
      $required_fields_filled_in);
local($hidden_fields) = &make_hidden_fields;
local($continue) = 1;
local($taxable_grand_total);
my $we_need_to_exit = 0;
&codehook("process_order_form_top");
if ($continue == 0) { return;}
print qq~$sc_doctype
<html>
<head>
  <title>Step Two</title>
  $sc_standard_head_info
</head>
<body>
~;
($taxable_grand_total, $subtotal, 
 $total_quantity,
 $total_measured_quantity,
 $text_of_cart,
 $stevo_shipping_thing) = 
 &display_cart_table("verify");      
$required_fields_filled_in = "yes";
if ($form_data{'gateway'} eq "") {
  $form_data{'gateway'} = $sc_gateway_name;
 }
&codehook("set_form_required_fields");
# checks for prevent of Zero sub total orders.  Set in main settings manager
# Added by Mister Ed (K-Factor Technologies, Inc) 10/17/2003
if ($sc_prevent_zero_total_orders =~ /yes/i) {
$mustbegreaterthanthis = .0001;
if ($subtotal < $mustbegreaterthanthis) {
$we_need_to_exit++;
if ($we_need_to_exit eq 1)
{
  print '<div align="center">';
}
print <<ENDOFTEXT;
<p class="ac_missing_field">
  Empty Orders not accepted!.
</p>
ENDOFTEXT
}
}
# checks for minimum order amount.  Set in main settings manager
# Added by Mister Ed (K-Factor Technologies, Inc) 10/17/2003
if ($subtotal < $sc_minimum_order_amount) { 
$we_need_to_exit++;
if ($we_need_to_exit eq 1)
{
  print '<div align="center">';
}
print <<ENDOFTEXT;
<p class="ac_missing_field">
  Minimum order amount is $sc_minimum_order_amount $sc_minimum_order_text.
</p>
ENDOFTEXT
} 
foreach $required_field (@sc_order_form_required_fields) {
if ($form_data{$required_field} eq "") {
    $required_fields_filled_in = "no";
$we_need_to_exit++;
if ($we_need_to_exit eq 1)
{
  print '<div align="center">';
}
print <<ENDOFTEXT;
<p class="ac_missing_field">
  You forgot to fill in $sc_order_form_array{$required_field}.
</p>
ENDOFTEXT
  }
} 
if ($we_need_to_exit > 0)
{
    print qq~<form method="post" action="$sc_stepone_order_script_url">
  <p class="ac_missing_field">
    <input type="hidden" name="order_form_button" value="1">
    $hidden_fields
    <input type="hidden" name="HCODE" value="$sc_pass_used_to_scramble">
    <input type="hidden" name="gateway" value="$form_data{'gateway'}"> 
    <input type="hidden" name="ofn" value="$form_data{'gateway'}"> 
    <input type="image" name="Make Changes" value="Make Changes" src="picserve.cgi?secpicserve=make_changes.gif" alt="Make Changes">
  </p>
</form>
</div>~;
    &SecureStoreFooter;
    print qq!
    </body>
    </html>
    !;
    &call_exit;
}
if (($sc_paid_by_ccard =~ /yes/i) && ($sc_CC_validation =~ /yes/i)) {

  &require_supporting_libraries (__FILE__, __LINE__,
    "./library/credit_card_validation_lib.pl");

  $CC_exp_date = $form_data{'Ecom_Payment_Card_ExpDate_Month'} . '/' .
                 $form_data{'Ecom_Payment_Card_ExpDate_Day'} . '/' .
                 $form_data{'Ecom_Payment_Card_ExpDate_Year'};

  ($error_code, $error_message) = &validate_credit_card_information(
                                  $form_data{"Ecom_Payment_Card_Type"},
                                  $form_data{"Ecom_Payment_Card_Number"},
                                  $CC_exp_date);

  if($error_code != 0)
  {
    $required_fields_filled_in = "no";
    $order_error_do_not_finish = "yes";

print <<ENDOFTEXT;
<div align="center">
<p class="ac_error">
  $error_message
</p>
ENDOFTEXT
  }  

}
  if($order_error_do_not_finish =~ /yes/i)
  {
  
    print qq~
    <hr>
    <div align="center">
    <form method="post" action="$sc_stepone_order_script_url">
<input type="hidden" name="order_form_button" VALUE="1">
$hidden_fields
<input type="hidden" name="HCODE" value="$sc_pass_used_to_scramble">
<input type="hidden" name="gateway" value="$form_data{'gateway'}"> 
<input type="hidden" name="ofn" value="$form_data{'gateway'}"> 
<input type="image" name="Make Changes" value="Make Changes" 
  src="picserve.cgi?secpicserve=make_changes.gif">
</form>
</div>~;

    &SecureStoreFooter;

    print qq!
    </body>
    </html>
    !;
    &call_exit;
  }  
if ($required_fields_filled_in eq "yes") {
  foreach $form_field (sort(keys(%sc_order_form_array))) {
    $text_of_cart .= 
      &format_text_field($sc_order_form_array{$form_field})
      . "= $form_data{$form_field}\n";
  }
  $text_of_cart .= "\n";
if ($sc_use_pgp =~ /yes/i) {
    &require_supporting_libraries(__FILE__, __LINE__,
    "$sc_pgp_lib_path");
$text_of_cart = &make_pgp_file($text_of_cart,
               "$sc_pgp_temp_file_path/$$.pgp");
$text_of_cart = "\n" . $text_of_cart . "\n";
  }
if ($form_data{'gateway'} eq "") {
  $form_data{'gateway'} = $sc_gateway_name;
 }
&codehook("printSubmitPage");# used to be &printSubmitPage;
} else {
print <<ENDOFTEXT;
<div align="center">
<hr>
<p class="ac_error">
  $messages{'ordprc_01'}
</p>
<hr>
</div>
ENDOFTEXT

} 
&SecureStoreFooter;

print qq!
</body>
</html>
!;
}

############################################################
sub calculate_final_values {
  local($taxable_grand_total,$subtotal,
        $total_quantity,
        $total_measured_quantity,
        $are_we_before_or_at_process_form) = @_;
  local(@testlines,$junk1,$junk2);
  local($temp_total) = 0;
  local($grand_total) = 0;
  local($mypass,$save1,$save2,$save3,$save4,$save5,$save6,$save7,$save8);
  local($final_shipping, $shipping);
  local($final_discount, $discount);
  local($final_sales_tax, $sales_tax) = 0;
  local($final_extra_tax1, $extra_tax1) = 0;
  local($final_extra_tax2, $extra_tax2) = 0;
  local($final_extra_tax3, $extra_tax3) = 0;
  local($final_buySafe) = 0;
  local($calc_loop) = 0;
$temp_total = $subtotal;
my $temp_taxable_total = $taxable_grand_total;
$max_loops=3;
&codehook("before_final_values_loop");
for (1..$max_loops) {
$shipping = 0;
$discount = 0;
$sales_tax = 0;
$extra_tax1 = 0;
$extra_tax2 = 0;
$extra_tax3 = 0;
$calc_loop = $_;
&codehook("begin_final_values_loop_iteration");
if ($are_we_before_or_at_process_form =~ /before/i)
{
if ($sc_calculate_discount_at_display_form ==
    $calc_loop) {
    $discount = 
    &calculate_discount($temp_total,
    $total_quantity,
    $total_measured_quantity);
    if ($sc_calculate_sales_tax_at_process_form >= $calc_loop) {
        $temp_taxable_total -= $discount;
    }
    } 
if ($sc_calculate_shipping_at_display_form ==
    $calc_loop) {
  &codehook("calculate_final_values_calc_shipping_display_form_top");
    $shipping = &define_shipping_logic($total_measured_quantity,
                $stevo_shipping_thing);
    if ($sc_calculate_sales_tax_at_process_form > $calc_loop) {
        $temp_taxable_total += $shipping;
    }
  &codehook("calculate_final_values_calc_shipping_display_form_bottom");
    } 
if ($sc_calculate_sales_tax_at_display_form ==
    $calc_loop) {
    $sales_tax = 
    &calculate_sales_tax($temp_taxable_total);
   } 
if ($sc_calculate_extra_tax1_at_display_form ==
    $calc_loop) {
    $extra_tax1 = 
    &calculate_extra_tax1($temp_taxable_total);
   } 
if ($sc_calculate_extra_tax2_at_display_form ==
    $calc_loop) {
    $extra_tax2 = 
    &calculate_extra_tax2($temp_taxable_total);
   } 
if ($sc_calculate_extra_tax3_at_display_form ==
    $calc_loop) {
    $extra_tax3 = 
    &calculate_extra_tax3($temp_taxable_total);
   } 
   } else {
if ($sc_calculate_discount_at_process_form ==
    $calc_loop) {
    $discount = 
    &calculate_discount($temp_total,
    $total_quantity,
    $total_measured_quantity);
    if ($sc_calculate_sales_tax_at_process_form >= $calc_loop) {
        $temp_taxable_total -= $discount;
    }
    } 
if ($sc_calculate_shipping_at_process_form ==
    $calc_loop) {
  &codehook("calculate_final_values_calc_shipping_process_form_top");
    $shipping = &define_shipping_logic($total_measured_quantity,
                $stevo_shipping_thing);
    if ($sc_calculate_sales_tax_at_process_form > $calc_loop) {
        $temp_taxable_total += $shipping;
    }
  &codehook("calculate_final_values_calc_shipping_process_form_bottom");
   } 
if ($sc_calculate_sales_tax_at_process_form ==
    $calc_loop) {
    $sales_tax = &calculate_sales_tax($temp_taxable_total);
   } 
if ($sc_calculate_extra_tax1_at_process_form ==
    $calc_loop) {
    $extra_tax1 = 
    &calculate_extra_tax1($temp_taxable_total);
   } 
if ($sc_calculate_extra_tax2_at_process_form ==
    $calc_loop) {
    $extra_tax2 = 
    &calculate_extra_tax2($temp_taxable_total);
   } 
if ($sc_calculate_extra_tax3_at_process_form ==
    $calc_loop) {
    $extra_tax3 = 
    &calculate_extra_tax3($temp_taxable_total);
   } 

} 
if (!($total_quantity > 0)) {$shipping=0;}
&codehook("end_final_values_loop_iteration_before_calc");
$final_discount = $discount if ($discount > 0);
$final_shipping = $shipping if ($shipping > 0);
$final_sales_tax = $sales_tax if ($sales_tax > 0);
$final_extra_tax1 = $extra_tax1 if ($extra_tax1 > 0);
$final_extra_tax2 = $extra_tax2 if ($extra_tax2 > 0);
$final_extra_tax3 = $extra_tax3 if ($extra_tax3 > 0);
$temp_total = $temp_total - $discount + $shipping + $sales_tax 
               + $extra_tax1 + $extra_tax2 + $extra_tax3;
&codehook("end_final_values_loop_iteration_after_calc");
}
# add in buySafe
$final_buySafe = $sc_buySafe_bond_fee if (($sc_buySafe_bond_fee > 0) && ($subtotal > 0));
if (($sc_buySafe_is_enabled =~ /yes/) && ($subtotal > 0)) {
    $temp_total += $final_buySafe;
}
$grand_total = $temp_total;
if ($sc_verify_inv_no eq '') {
  open(MYFILE,"$sc_verify_order_path");
  @testlines = <MYFILE>;
  close(MYFILE);
  @testlines = grep(/sc_verify_inv_no/,@testlines);
  ($junk1,$sc_verify_inv_no,$junk2) = split(/\"/,@testlines[0],3);
 }
if ($sc_verify_inv_no ne '') {
  $current_verify_inv_no = $sc_verify_inv_no;
 } else {
  $current_verify_inv_no = &generate_invoice_number;
 }
$zz_shipping_thing = $sc_shipping_thing;
$zz_shipping_thing =~ s/\|/\" . \n  \"\|/g;
&codehook("calculate_final_values_calc_save_verify_file_top");
if (($sc_test_repeat == 0) &&
 (($form_data{'submit_order_form_button'} ne "") ||
   ($form_data{'submit_order_form_button.x'} ne ""))) {
  open(MYFILE,">$sc_verify_order_path") ||
                &file_open_error("$sc_verify_order_path",
                "Order Form Verify File Error",__FILE__,__LINE__);
  print MYFILE "#\n#These Values were calculated for the order:\n";
  print MYFILE "\$sc_verify_ip_addr = \"$ENV{'REMOTE_ADDR'}\";\n";
  print MYFILE "\$sc_verify_shipping = ", (0+$final_shipping),";\n";
  print MYFILE "\$sc_verify_shipping_zip = \"", 
                (0+$form_data{'Ecom_ShipTo_Postal_PostalCode'}),"\";\n";
  print MYFILE "\$sc_verify_shipping_thing = \"",
    $zz_shipping_thing,"\";\n";
  print MYFILE "\$sc_verify_shipto_postal_stateprov = \"", 
                $form_data{'Ecom_ShipTo_Postal_StateProv'},"\";\n";
  print MYFILE "\$sc_verify_shipto_method = \"", 
                $form_data{'Ecom_ShipTo_Method'},"\";\n";
  print MYFILE "\$sc_verify_discount = ",(0+$final_discount),";\n";
  print MYFILE "\$sc_verify_tax = ",(0+$final_sales_tax),";\n";
  print MYFILE "\$sc_verify_etax1 = ",(0+$final_extra_tax1),";\n";
  print MYFILE "\$sc_verify_etax2 = ",(0+$final_extra_tax2),";\n";
  print MYFILE "\$sc_verify_etax3 = ",(0+$final_extra_tax3),";\n";
  print MYFILE "\$sc_verify_subtotal = ",(0+$subtotal),";\n";
  if ($sc_buySafe_is_enabled =~ /yes/) {
      print MYFILE "\$sc_verify_buySafe = ",(0+$final_buySafe),";\n";
      print MYFILE "\$sc_verify_buySafe_display_text = \"$sc_buySafe_bond_fee_display_text\";\n";
      print MYFILE "\$sc_verify_buySafe_customer_desires_bond = \"$sc_buySafe_customer_desires_bond\";\n";
      print MYFILE "\$sc_buySafe_customer_desires_bond = \"$sc_buySafe_customer_desires_bond\";\n";
      print MYFILE "\$sc_buySafe_bond_fee_display_text = \"$sc_buySafe_bond_fee_display_text\";\n";
      print MYFILE "\$sc_buySafe_bonding_signal = qq|$sc_buySafe_bonding_signal|;\n";
      print MYFILE "\$sc_buySafe_bond_fee_mini_display_text = \"$sc_buySafe_bond_fee_mini_display_text\";\n";
  }
  print MYFILE "\$sc_verify_grand_total = ",(0+$grand_total),";\n";
  print MYFILE "\$sc_verify_boxes_max_wt = \"",$sc_verify_boxes_max_wt,"\";\n";
  print MYFILE "\$sc_verify_Origin_ZIP = \"",$sc_verify_Origin_ZIP,"\";\n";
  print MYFILE "\$sc_verify_inv_no = \"",$current_verify_inv_no,"\";\n";
  print MYFILE "\$sc_verify_paid_by_ccard = \"",$sc_paid_by_ccard,"\";\n";
  &codehook("calculate_final_values_calc_save_verify_file_section_one");
  $mypass = &make_random_chars;
  $mypass .= &make_random_chars;
  $mypass .= &make_random_chars;
  $mypass .= &make_random_chars;
  $sc_pass_used_to_scramble = $mypass;
  if ($sc_test_repeat ne 0) { 
    $form_data{'Ecom_Payment_Card_Number'} = '';
    $form_data{'Ecom_Payment_BankAcct_Number'} = '';
    $form_data{'Ecom_Payment_BankRoute_Number'} = '';
    $form_data{'Ecom_Payment_Bank_Name'} = '';
    $form_data{'Ecom_Payment_Orig_Card_Number'} = '';
   }
if ($sc_scramble_cc_info =~ /yes/i ) {
  $save1 = $form_data{'Ecom_Payment_Card_Number'};
  $form_data{'Ecom_Payment_Card_Number'} = 
  &scramble($save1,$mypass,0);
  $save2 = $form_data{'Ecom_Payment_BankAcct_Number'};
  $form_data{'Ecom_Payment_BankAcct_Number'} = 
  &scramble($save2,$mypass,0);
  $save3 = $form_data{'Ecom_Payment_BankRoute_Number'};
  $form_data{'Ecom_Payment_BankRoute_Number'} = 
  &scramble($save3,$mypass,0);
  $save4 = $form_data{'Ecom_Payment_Bank_Name'};
  $form_data{'Ecom_Payment_Bank_Name'} = 
  &scramble($save4,$mypass,0);
  $save5 = $form_data{'Ecom_Payment_Orig_Card_Number'};
  $form_data{'Ecom_Payment_Orig_Card_Number'} = 
  &scramble($save5,$mypass,0);
}
  &codehook("calculate_final_values_calc_save_verify_file_section_two");
  foreach $inx (sort(keys %form_data)) {
    $value = $form_data{$inx};
    $value =~ s/\'/\"/g;
    # added by Mister Ed April 26, 2006
    # to prevent massive text entries in xcomments and other fields
    if (length($value) > $sc_max_char_length) {
        $value = substr($value,0,$sc_max_char_length);
    }
    print MYFILE "\$vform_$inx = '$value'\;\n";
    print MYFILE "\$vform{'$inx'} = '$value'\;\n";
    $value =~ s/\"/\&quot\;/g;
    print MYFILE "\$eform_$inx = '$value'\;\n";
    print MYFILE "\$eform{'$inx'} = '$value'\;\n";
    $eform_data{$inx} = $value; 
   }
if ($sc_scramble_cc_info =~ /yes/i ) {
  $form_data{'Ecom_Payment_Card_Number'} = $save1;
  $form_data{'Ecom_Payment_BankAcct_Number'} = $save2;
  $form_data{'Ecom_Payment_BankRoute_Number'} = $save3;
  $form_data{'Ecom_Payment_Bank_Name'} = $save4;
  $form_data{'Ecom_Payment_Orig_Card_Number'} = $save5;
}
&codehook("calculate_final_values_calc_save_verify_file_bottom");

  print MYFILE "1;\n";
  close(MYFILE);
}
&codehook("end_final_values");
return ($final_shipping,
        $final_discount,
        $final_sales_tax,
        $final_extra_tax1,
        $final_extra_tax2,
        $final_extra_tax3,
        &format_price($grand_total),$final_buySafe);

} 
############################################################
sub calculate_shipping {
  local($subtotal,
        $total_quantity,
        $total_measured_quantity) = @_;
&codehook("calculate_shipping_top");
  return(&calculate_general_logic(
           $subtotal,
           $total_quantity,
           $total_measured_quantity,
           *sc_shipping_logic,
           *sc_order_form_shipping_related_fields));
} 
############################################################
sub calculate_discount {
  local($subtotal,
        $total_quantity,
        $total_measured_quantity) = @_;
  &codehook("calculate_discount_top");
  return(&calculate_general_logic(
           $subtotal,
           $total_quantity,
           $total_measured_quantity,
           *sc_discount_logic,
           *sc_order_form_discount_related_fields));
} 
############################################################
# New version of this routine is a
# Free Contribution by Mark S. (MAS), an AgoraCart Pro member.
# Updated/Contributed August 29 2004
# 
# This version will allow you to mix and match both the newer and older logic matrices for backward compatibility.
############################################################
sub calculate_general_logic {
    local($subtotal,
    $total_quantity,
    $total_measured_quantity,
    *general_logic,
    *general_related_form_fields) = @_;
    local $numFields = scalar split /\|/, @general_logic[0] ;
    local($general_value, $logic_statement, $form_field, $applyMe, $compareMe);
    local(@logic_fields, @compare_values ) ;
    foreach $logic_statement (@general_logic) {
        @logic_fields = split(/\|/, $logic_statement) ;
        FORMFIELD: foreach $form_field (@general_related_form_fields) {
            @compare_values = ("#$form_data{$form_field}#", $subtotal, $total_quantity, $total_measured_quantity,0,0,0) ;
      for (0..$numFields) {
    next if $_ == 4 || $_ > 5 ;
    $logicField = $logic_fields[$_] ;
    $logicField =    "#$logic_fields[$_]#" if  $logic_fields[$_] && ! $_ ;
    next FORMFIELD if (!(&compare_logic_values($compare_values[$_],$logicField)));
      }
      $applyMe = $logic_fields[4] ;
    if ($applyMe =~ /%/) {
        $applyMe =~ s/%// ;
        $general_value = $subtotal * $applyMe / 100 ;
    } else {
        $general_value = $applyMe ;
    } 
        } 
    } 
    return(&format_price($general_value));
}
############################################################
sub calculate_extra_tax1 {
  local($subtotal) = @_;
  local($extra_tax) = 0;
  if ($sc_use_tax1_logic =~ /yes/i) {
    $sc_extra_tax1_name = "Tax1" if $sc_extra_tax1_name eq "";
    $extra_tax = &eval_custom_logic($sc_extra_tax1_logic,
               "Extra Tax 1",__FILE__,__LINE__);
   }
  return (&format_price($extra_tax));
} 
sub calculate_extra_tax2 {
  local($subtotal) = @_;
  local($extra_tax) = 0;
  if ($sc_use_tax2_logic =~ /yes/i) {
    $sc_extra_tax2_name = "Tax2" if $sc_extra_tax2_name eq "";
    $extra_tax = &eval_custom_logic($sc_extra_tax2_logic,
               "Extra Tax 2",__FILE__,__LINE__);
   }
  return (&format_price($extra_tax));
} 
sub calculate_extra_tax3 {
  local($subtotal) = @_;
  local($extra_tax) = 0;
  if ($sc_use_tax1_logic =~ /yes/i) {
    $sc_extra_tax3_name = "Tax3" if $sc_extra_tax3_name eq "";
    $extra_tax = &eval_custom_logic($sc_extra_tax3_logic,
               "Extra Tax 3",__FILE__,__LINE__);
   }
  return (&format_price($extra_tax));
} 
############################################################
sub calculate_sales_tax {
  local($taxable_grand_total) = @_;
  local($sales_tax) = 0;
  local($tax_form_variable);
  local($continue)=1;
  &codehook("calc_sales_tax_top");
  if ($continue == 0) {
    return (&format_price($sales_tax));
   }

  $tax_form_variable = $form_data{$sc_sales_tax_form_variable};
  if ($tax_form_variable eq "") {
    $tax_form_variable = $vform{$sc_sales_tax_form_variable};
   }
  if ($sc_sales_tax_form_variable ne "") {
    foreach $value (@sc_sales_tax_form_values) {
      if (($value =~ 
          /^${tax_form_variable}$/i) &&
         (${tax_form_variable} ne ""))  {
        $sales_tax = $taxable_grand_total * $sc_sales_tax;
      }
    }
  } else {
    $sales_tax = $taxable_grand_total * $sc_sales_tax;
  }
  &codehook("calc_sales_tax_bot");
  return (&format_price($sales_tax));
} 
############################################################
# New version of this routine is a
# Free Contribution by Mark S. (MAS), an AgoraCart Pro member.
# Updated/Contributed August 29 2004
############################################################
sub compare_logic_values {
  local($input_value, $value_to_compare) = @_;
  local($lowrange, $highrange);
  local $rangeCount =  scalar ( ($lowrange, $highrange) = split(/-/, $value_to_compare) )   ;
if ($value_to_compare =~ /\//) {
  ($highrange , $lowrange) = ($lowrange, '') if $lowrange && ! $highrange && $rangeCount==1 ;
  $epochStart = date_to_epoch($lowrange || '1/1/1970','start') ;
  $epochEnd   =  date_to_epoch($highrange || '1/1/2020','end') ;
  return ( (time() >= $epochStart) && (time() <= $epochEnd )) ? 1 : 0 ;
}
if ($rangeCount > 1) {
    if ($lowrange eq "") {
      if ($input_value <= $highrange) {
        return(1);
      } else {
        return(0);
      }
    } elsif ($highrange eq "") {
      if ($input_value >= $lowrange) {
        return(1);
      } else {
        return(0);
      }
    } else {
      if (($input_value >= $lowrange) &&
         ($input_value <= $highrange)) {
        return(1);
      } else {
        return(0);
      }
    }
  } else {
    if (($input_value =~ /$value_to_compare/i) ||
        ($value_to_compare eq "")) {
      return(1);
    } else {
      return(0);
    }
  }
} 
sub date_to_epoch {
    use Time::Local ;
    local ($stringDate, $part_of_day) = @_ ;
    local @mredDate = split "/", $stringDate ;
    return timelocal(0,0,0,$mredDate[1],$mredDate[0]-1,$mredDate[2]) 
  if ($part_of_day =~ /start/ ) ;
    return timelocal(59,59,23,$mredDate[1],$mredDate[0]-1,$mredDate[2]) 
  if ($part_of_day =~ /end/ ) ;
}
############################################################
sub cart_textinfo {
 local (*cart_fields) = @_;
 local ($quantity, $product, $product_name, $options, $product_price);
 local ($inx, $result, $p_id, $title, $mydata, $display_index);
 local ($field_name, $query_result, $cart_line_id, @my_row);
 $cart_line_id  = $cart_fields[$cart{'unique_cart_line_id'}];
 $quantity  = $cart_fields[$cart{"quantity"}];
 $p_id    = $cart_fields[$cart{"product_id"}];
 $product   = $cart_fields[$cart{"product"}];
 $product_name  = $cart_fields[$cart{"name"}];
 $options   = $cart_fields[$cart{"options"}];
 $product_price = $cart_fields[$cart{"price"}];
 if (!($sc_db_lib_was_loaded =~ /yes/i)) #load the library
  {
   &require_supporting_libraries(__FILE__, __LINE__,"$sc_db_lib_path");
  }
 #read in the database row
 $query_result = &check_db_with_product_id($p_id,*my_row);
 $result = '';
 $inx=0;
 $result  = "Quantity:      $quantity\nProduct:       " . $product_name .
    ' (' . &display_price($product_price) . " ea.)\n";
 foreach $field_name (@sc_textcol_name)
  {
   $display_index = $cart{$field_name};
   $title = $sc_textcart_display_fields[$inx] . ":                   ";
   $title = substr($title,0,14) . " ";
   if ($display_index < 0) { 
     $mydata = $my_row[(0-$display_index)];
    } else { 
     $mydata = &vf_get_data("CART",$field_name,$cart_line_id,@cart_fields);
    }
   if ($sc_textcart_display_factor[$inx] =~ /yes/i) {
     $mydata = $mydata * $cart_fields[$cart{"quantity"}];
    }
   if ($sc_textcart_display_format[$inx] =~ /2-Decimal/i) {
     $mydata = &format_price($mydata);
    }
   if ($sc_textcart_display_format[$inx] =~ /2-D Price/i) {
     $mydata = &display_price($mydata);
    }
   $result .= $title . $mydata . "\n";
   $inx++;
  }
 $result .= "\n";
 return $result;
}
############################################################
sub log_order {
 local ($text_of_cart,$invoice,$customer_id) = @_;
 my ($filename,$filename7,$filename6,$filename5);
 my ($filename2, $filename3, $filename4, $overview_string, $cart_lines_for_logging,$orderLogString,$orderLogStringShort) = '';
 local (@productlog);
 local (@keys);
 local (%productsSold);
 my ($quantity,$product,$pid,$category,$price,$shipping,$optionids,$productStatus,$downladables,$altorigin,$nontaxable,$cartuser5,$cartuser6,$formattedoptions,$priceafteroptions);
 $customer_id =~ /([\w\-\=\+\/]+)\.(\w+)/;
 $customer_id = "$1.$2";
 $invoice =~ /(\w+)/;
 $invoice = "$1";
 my ($day,$month,$year) = &get_month_year;
 $filename2 = "$sc_order_log_directory_path/$year/";
 $filename3 = "$sc_order_log_directory_path/$year/$month/";
 $filename7 = "$sc_order_log_directory_path/$year" . "_productSalesLog.prd2";
if (($sc_write_product_sales_logs =~ /yes/i) && (-e $filename7))  {
             open(PRODLOG,$filename7);
             @productlog=<PRODLOG>;
             close(PRODLOG);
             foreach $productlog(@productlog) {
                 chomp($productlog);
                 my ($productName,$qty)=split("\t",$productlog);
                 $productsSold{$productName}=$qty;
             }
       }
if (($sc_write_individual_order_logs =~ /yes/i)||($sc_write_monthly_master_order_logs =~ /yes/i)) {
   open (CART, "$sc_cart_path")|| &file_open_error("$sc_cart_path", "display_cart_contents", __FILE__, __LINE__);
   while (<CART>)
   {
       if ($cart_lines_for_logging ne "") {
           $cart_lines_for_logging .= "::"; 
       }
       @cart_fields2 = split (/\|/, $_);
        $quantity = $cart_fields2[0];
        $pid = $cart_fields2[1];
        $category = $cart_fields2[2];
        $price = $cart_fields2[3];
        $product = $cart_fields2[4];
        $shipping = $cart_fields2[6];
        $optionids = $cart_fields2[8];
        $downladables = $cart_fields2[10];
        $altorigin = $cart_fields2[11];
        $nontaxable = $cart_fields2[12];
        $cartuser5 = $cart_fields2[13];
        $cartuser6 = $cart_fields2[14];
        $formattedoptions = $cart_fields2[15];
        $priceafteroptions = $cart_fields2[16];
       if ($downladables ne '') {
           $productStatus = "Downloadable";
       } else {
           $productStatus = "$sc_defaultProductStatus";
       }
       $cart_lines_for_logging .= "$quantity|$pid|$category|$price|$product|$shipping|$optionids|$downladables|$altorigin|$nontaxable|$cartuser5|$cartuser6|$formattedoptions|$priceafteroptions|$productStatus";
       if ($sc_write_product_sales_logs =~ /yes/i) {
             my $productNameThngy = "$product    ID $pid";
             $productsSold{$productNameThngy} += $quantity;
       }
   }
   close(CART);
}
   $orderLoggingHash{'cartContents'} = $cart_lines_for_logging;
   # added by Mister Ed October 2005
   # fax number added March 11, 2006
   # tos Added March 18, 2006
   # Residential & insurance added April 5, 2006
   $orderLogString = "$year\t$month\t$day\t$orderLoggingHash{'invoiceNumber'}\t$orderLoggingHash{'customerNumber'}\t$orderLoggingHash{'orderStatus'}\t$orderLoggingHash{'shiptrackingID'}\t$orderLoggingHash{'firstName'}\t$orderLoggingHash{'lastName'}\t$orderLoggingHash{'fullName'}\t$orderLoggingHash{'companyName'}\t$orderLoggingHash{'customerPhone'}\t$orderLoggingHash{'faxNumber'}\t$orderLoggingHash{'emailAddress'}\t$orderLoggingHash{'orderFromAddress'}\t$orderLoggingHash{'customerAddress2'}\t$orderLoggingHash{'customerAddress3'}\t$orderLoggingHash{'orderFromCity'}\t$orderLoggingHash{'orderFromState'}\t$orderLoggingHash{'orderFromPostal'}\t$orderLoggingHash{'orderFromCountry'}\t$orderLoggingHash{'shipToName'}\t$orderLoggingHash{'shipToAddress'}\t$orderLoggingHash{'shipToAddress2'}\t$orderLoggingHash{'shipToAddress3'}\t$orderLoggingHash{'shipToCity'}\t$orderLoggingHash{'shipToState'}\t$orderLoggingHash{'shipToPostal'}\t$orderLoggingHash{'shipToCountry'}\t$orderLoggingHash{'shiptoResidential'}\t$orderLoggingHash{'insureShipment'}\t$orderLoggingHash{'shipMethod'}\t$orderLoggingHash{'shippingTotal'}\t$orderLoggingHash{'salesTax'}\t$orderLoggingHash{'tax1'}\t$orderLoggingHash{'tax2'}\t$orderLoggingHash{'tax3'}\t$orderLoggingHash{'discounts'}\t$orderLoggingHash{'netProfit'}\t$orderLoggingHash{'subTotal'}\t$orderLoggingHash{'orderTotal'}\t$orderLoggingHash{'affiliateTotal'}\t$orderLoggingHash{'affiliateID'}\t$orderLoggingHash{'affiliateMisc'}\t$orderLoggingHash{'user1'}\t$orderLoggingHash{'user2'}\t$orderLoggingHash{'user3'}\t$orderLoggingHash{'user4'}\t$orderLoggingHash{'user5'}\t$orderLoggingHash{'adminMessages'}\t$orderLoggingHash{'cartContents'}\t$orderLoggingHash{'GatewayUsed'}\t$orderLoggingHash{'shippingMessages'}\t$orderLoggingHash{'xcomments'}\t$orderLoggingHash{'termsOfService'}\t$orderLoggingHash{'discountCode'}\t$orderLoggingHash{'user6'}\t$orderLoggingHash{'user7'}\t$orderLoggingHash{'user8'}\t$orderLoggingHash{'user9'}\t$orderLoggingHash{'user10'}\t$orderLoggingHash{'buySafe'}\t$orderLoggingHash{'order_payment_type_user1'}\t$orderLoggingHash{'order_payment_type_user2'}\t$orderLoggingHash{'GiftCard_number'}\t$orderLoggingHash{'GiftCard_amount_used'}\t$orderLoggingHash{'internal_company_notes1'}\t$orderLoggingHash{'internal_company_notes2'}\t$orderLoggingHash{'internal_company_notes2'}\t$orderLoggingHash{'customer_order_notes1'}\t$orderLoggingHash{'customer_order_notes2'}\t$orderLoggingHash{'customer_order_notes3'}\t$orderLoggingHash{'customer_order_notes4'}\t$orderLoggingHash{'customer_order_notes5'}\t$orderLoggingHash{'mailinglist_subscribe'}\t$orderLoggingHash{'wishlist_subscribe'}\t$orderLoggingHash{'insurance_cost'}\t$orderLoggingHash{'trade_in_allowance'}\t$orderLoggingHash{'rma_number'}\t$orderLoggingHash{'customer_contact_notes1'}\t$orderLoggingHash{'customer_contact_notes2'}\t$orderLoggingHash{'account_number'}\t$orderLoggingHash{'sales_rep'}\t$orderLoggingHash{'sales_rep_notes1'}\t$orderLoggingHash{'sales_rep_notes2'}\t$orderLoggingHash{'how_did_you_find_us'}\t$orderLoggingHash{'suggestion_box'}\t$orderLoggingHash{'preferrred_shipping_date'}\t$orderLoggingHash{'ship_order_items_as_available'}\n";
   $orderShortLogString = "$year\t$month\t$day\t$orderLoggingHash{'invoiceNumber'}\t$orderLoggingHash{'customerNumber'}\t$orderLoggingHash{'orderStatus'}\t$orderLoggingHash{'firstName'}\t$orderLoggingHash{'lastName'}\t$orderLoggingHash{'fullName'}\t$orderLoggingHash{'companyName'}\t$orderLoggingHash{'emailAddress'}\t$orderLoggingHash{'orderFromState'}\t$orderLoggingHash{'orderFromPostal'}\t$orderLoggingHash{'orderFromCountry'}\t$orderLoggingHash{'shipMethod'}\t$orderLoggingHash{'shippingTotal'}\t$orderLoggingHash{'salesTax'}\t$orderLoggingHash{'tax1'}\t$orderLoggingHash{'tax2'}\t$orderLoggingHash{'tax3'}\t$orderLoggingHash{'discounts'}\t$orderLoggingHash{'netProfit'}\t$orderLoggingHash{'subTotal'}\t$orderLoggingHash{'orderTotal'}\t$orderLoggingHash{'affiliateTotal'}\t$orderLoggingHash{'affiliateID'}\t$orderLoggingHash{'affiliateMisc'}\t$orderLoggingHash{'GatewayUsed'}\t$orderLoggingHash{'buySafe'}\n";
&codehook("log_order_top");
# test for year and months as directory names for logging purposes.
#added by Mister Ed October 2005
   if (!(-d $filename2)) {
       mkdir $filename2;
   }
   if (!(-d $filename3)) {
       mkdir $filename3;
   }
#added by Mister Ed October 2005
if ($sc_write_monthly_short_order_logs =~ /yes/i) {
           $filename4 = "$filename3/$month$year" . "_indexOrderLog.log2";
           &get_file_lock("$filename4.lockfile");
           open (ORDERLOG4, ">>$filename4");
           print ORDERLOG4 $orderShortLogString;
           close (ORDERLOG4);
           &release_file_lock("$filename4.lockfile");
}
#added by Mister Ed October 2005
 if ($sc_write_monthly_master_order_logs =~ /yes/i) {
           $filename5 = "$filename2/$month$year" . "_MasterOrderLog.log2";
           &get_file_lock("$filename5.lockfile");
           open (ORDERLOG, ">>$filename5");
           print ORDERLOG $orderLogString;
           close (ORDERLOG);
           &release_file_lock("$filename5.lockfile");
}
if ($sc_write_individual_order_logs =~ /yes/i) {
  ## write out individual orders.  revised by Mister Ed June 2005
   $filename4 = "$filename3/${invoice}-${customer_id}-complete2";
   $filename5 = "$filename3/${invoice}-${customer_id}-orderdata2";
   &codehook("log_order_individual_inside_top");
   &get_file_lock("$filename4.lockfile");
   open (ORDERLOG, ">$filename4");
   print ORDERLOG $text_of_cart;
   close (ORDERLOG);
   &release_file_lock("$filename4.lockfile");
   &codehook("log_order_individual_inside_middle");
   &get_file_lock("$filename5.lockfile");
   open (ORDERLOG, ">$filename5");
   print ORDERLOG $orderLogString;
   close (ORDERLOG);
   &release_file_lock("$filename5.lockfile");
   &codehook("log_order_individual_inside_bottom");
}
&codehook("log_order_middle");
   if ($sc_write_product_sales_logs =~ /yes/i) {
        {@keys=sort {$productsSold{$a} <=> $productsSold{$b}} keys(%productsSold)}
        &get_file_lock("$filename7.lockfile");
        open(PRODLOG,">$filename7");
        foreach $key(@keys) {
            print PRODLOG qq~$key\t$productsSold{$key}\n~;
        }
        close(PRODLOG);
        &release_file_lock("$filename7.lockfile");
   }
if ($sc_send_order_to_log =~ /yes/i) {
  $filename = "./log_files/$sc_order_log_name";
  &get_file_lock("$filename.lockfile");
  open (ORDERLOG, "+>>$filename");
  $overview_string = "$orderShortLogString";
  &codehook("log_order_overview_inside_bottom");
  print ORDERLOG $overview_string;
  close (ORDERLOG);
  &release_file_lock("$filename.lockfile");
 }
&codehook("log_order_bot");
}
############################################################
sub decode_verify_vars {
  local($save1,$mypass);
  if (($sc_test_repeat ne 0) || 
    (($form_data{'HCODE'} eq "") && ($sc_scramble_cc_info =~ /yes/i ))) {
    $vform_Ecom_Payment_BankAcct_Number = '';
    $vform_Ecom_Payment_BankCheck_Number = '';
    $vform_Ecom_Payment_BankRoute_Number = '';
    $vform_Ecom_Payment_Bank_Name = '';
    $vform_Ecom_Payment_Card_Number = '';
    $vform_Ecom_Payment_Orig_Card_Number = '';
   } else {
    if ($sc_scramble_cc_info =~ /yes/i ) {
      $mypass = $form_data{'HCODE'};
      $save1 = $vform_Ecom_Payment_Orig_Card_Number;
      $vform_Ecom_Payment_Orig_Card_Number = 
    &scramble($save1,$mypass,1);
      $save1 = $vform_Ecom_Payment_Card_Number;
      $vform_Ecom_Payment_Card_Number = 
  &scramble($save1,$mypass,1);
      $save1 = $vform_Ecom_Payment_BankAcct_Number;
      $vform_Ecom_Payment_BankAcct_Number = 
  &scramble($save1,$mypass,1);
      $save1 = $vform_Ecom_Payment_BankRoute_Number;
      $vform_Ecom_Payment_BankRoute_Number = 
  &scramble($save1,$mypass,1);
      $save1 = $vform_Ecom_Payment_Bank_Name;
      $vform_Ecom_Payment_Bank_Name = 
  &scramble($save1,$mypass,1);
     }
   }
  &codehook("done_verify_decode");
 }
############################################################
sub load_verify_file {
  &read_verify_file;
  &clear_verify_file;
}
############################################################
sub clear_verify_file {
  &codehook("before-clear-verify-file");
  eval("unlink  \"$sc_verify_order_path\";");
  &codehook("after-clear-verify-file");
}
############################################################
sub read_verify_file {
  local($str1,$str2,$str3);
  &codehook("before-read-verify-file");
  eval("require \"$sc_verify_order_path\";");
  &decode_verify_vars;
  &codehook("after-read-verify-file");
  $str1 = "ORDER NOTES -------------------\n\n";
  $str2 = "Order originated from IP ADDR: $sc_verify_ip_addr\n\n";
  $str3 = &format_XCOMMENTS;
  $XCOMMENTS_ADMIN = $str1 . $str2 . $str3;
  $XCOMMENTS = $str1 . $str3;
  &codehook("end-read-verify-file");
 }
############################################################
sub empty_cart {
  &codehook("before-empty-cart");
#  eval("unlink $sc_cart_path;");
  open (CART,">$sc_cart_path") || 
    &order_warn("This cart cannot be emptied --- OS permissions problem?");
  print CART "";
  close (CART);
  &codehook("after-empty-cart");
 }
############################################################
sub order_warn {
  local($str)=@_;
  print "<BR><B>$str</B><BR>\n";
 }
############################################################
sub add_text_of_cart {
 local ($name,$value) = @_;
 local ($temp);
 $temp = substr(substr($name,0,13).":               ",0,15);
 $text_of_cart .= "$temp$value\n";
}
############################################################
sub add_text_of_conf {
 local ($name,$value) = @_;
 local ($temp);
 $temp = substr(substr($name,0,13).":               ",0,15);
 $text_of_confirm_email .= "$temp$value\n";
}
############################################################
sub add_text_of_both {
 local ($name,$value) = @_;
 local ($temp);
 $temp = substr(substr($name,0,13).":               ",0,15);
 $text_of_cart .= "$temp$value\n";
 $text_of_confirm_email .= "$temp$value\n";
}
#################################################################
sub display_calculations {
local($taxable_grand_total,$subtotal,
      $are_we_before_or_at_process_form,
      $total_measured_quantity,
      $text_of_cart) = @_;
local($final_shipping,
  $final_discount,
  $final_sales_tax,
  $final_extra_tax1,
  $final_extra_tax2,
  $final_extra_tax3,
        $grand_total,$final_buySafe);
if ($sc_use_verify_values_for_display =~ /yes/i) {
  ($sc_ship_method_shortname,$junk) = 
    split(/\(/,$sc_verify_shipto_method,2);
  ($final_shipping,
  $final_discount,
  $final_sales_tax,
  $final_extra_tax1,
  $final_extra_tax2,
  $final_extra_tax3,
  $grand_total,
       $final_buySafe) =
  ($sc_verify_shipping,$sc_verify_discount,
  $sc_verify_tax,$sc_verify_etax1,
  $sc_verify_etax2,$sc_verify_etax3,
  $sc_verify_grand_total,
  $sc_verify_buySafe);
 } else {
  ($final_shipping,
  $final_discount,
  $final_sales_tax,
  $final_extra_tax1,
  $final_extra_tax2,
  $final_extra_tax3,
  $grand_total,
      $final_buySafe) =
  &calculate_final_values($taxable_grand_total,$subtotal,
  $total_quantity,
  $total_measured_quantity,
  $are_we_before_or_at_process_form);
}
$zsubtotal = $subtotal;
$zfinal_shipping = $final_shipping;
$zfinal_discount = $final_discount;
$zfinal_sales_tax = $final_sales_tax;
$zfinal_extra_tax1 = $final_extra_tax1;
$zfinal_extra_tax2 = $final_extra_tax2;
$zfinal_extra_tax3 = $final_extra_tax3;
$zfinal_buySafe = $final_buySafe;
if ($subtotal < .000000001) {
    $zfinal_buySafe = '';
}
$zgrand_total = $grand_total;

if ($final_shipping > 0)
{
$final_shipping = &format_price($final_shipping);
$final_shipping = &display_price($final_shipping);
$text_of_cart .= &format_text_field("Shipping:") . 
"= $final_shipping\n\n";
};
if ($final_discount > 0)
{
$final_discount = &format_price($final_discount);
$pass_final_discount = &format_price($final_discount);
$final_discount = &display_price($final_discount);

$text_of_cart .= &format_text_field("Discount:") . 
"= $final_discount\n\n";
}
if ($final_sales_tax > 0)
{
$final_sales_tax = &format_price($final_sales_tax);
$pass_final_sales_tax = &format_price($final_sales_tax);
$final_sales_tax = &display_price($final_sales_tax);

$text_of_cart .= &format_text_field("Sales Tax:") . 
"= $final_sales_tax\n\n";
}
# buySafe
if (($final_buySafe > 0) && ($subtotal > 0)) {
    $final_buySafe = &format_price($final_buySafe);
    $pass_final_buySafe = &format_price($final_buySafe);
    $final_buySafe = &display_price($final_buySafe);

    $text_of_cart .= &format_text_field("buySAFE Bond Fee: ") . 
      "= $final_buySafe\n\n";
} else {
   $final_buySafe = '';
}
$authPrice = $grand_total;
$grand_total = &display_price($grand_total);
&print_order_totals;
if ($are_we_before_or_at_process_form =~ /at/i) 
{
print <<ENDOFTEXT;
</form>
ENDOFTEXT
}
$text_of_cart .= &format_text_field("Grand Total:") . 
"= $grand_total\n\n";
return ($text_of_cart);
}
###############################################################################
sub explode {
 local ($what,*zdata) = @_;
 local ($temp,$ans,$command);
 &codehook("explode_top");
 $temp = $zdata{$what};
 $temp =~ /([\w\-\=\+\/]+)/;
 $temp = $1;
 $ans=$temp . " ";
 $command = '$ans .= $' . $what . '{"' . $temp . '"};'; 
 eval($command); 
 &codehook("explode_bot");
 return $ans;
}
####################################################################
sub format_XCOMMENTS {
 local ($str)="";
 local ($inx,$mykey,$val);
 &codehook("format_XCOMMENTS_top");
 foreach $mykey (sort(grep(/\_XCOMMENT\_/,(keys %vform)))) {
   if ($vform{$mykey} ne "") {
     ($junk,$val) = split(/\_XCOMMENT\_/,$mykey,2);
     $val =~ s/\_/\ /g;
     $str .= $val . ":\n" . $vform{$mykey} . "\n\n";
    }
  }
 &codehook("format_XCOMMENTS_bot");
 return $str;
}
####################################################################
# Copyright Steve Kneizys 11-FEB-2000, used by permission.
# This subroutine is not meant to be encryption ... it simply
# scrambles things a tad so it doesn't look like it used to
# so that prying eyes don't know what it is at a quick glance.
# This program can be written MUCH more simply, but ...
# "security through obscurity"!  Don't want to violate USA
# export restrictions ... otherwise we'd really encrypt things.
# Based on a "children's spy decoder ring".  An easier way to do
# this would be to translate numbers to letters :)  
####################################################################
sub scramble {
  local($what,$salt,$direction) = @_;
  local ($a1,$a2);
  if ($what eq "") {return "";}
  $what = &scramble_engine($what,$salt,$direction);
  $what = &scramble_engine(reverse($what),$salt,$direction);
  return $what;
 }
sub scramble_engine {
local ($key,$mysalt,$backout) = @_;
local ($part1)="abcdefghijklmnopqrstuvwxyz";
local ($part2,$part3,$the_code,$the_ref,$ans,$ans2,$inx);
local ($val)=0;
local ($val2)=0;
local ($val3)=0;
local ($val4)=0;
local ($scramble_variable) = 25;
local ($a1,$a2,$last_char,$this_char,$rev_last_char,$rev_this_char) = "";
$part2 = $part1;
$part2 =~ tr/a-z/A-Z/;
$the_code = " 1234567890,.<>/?;:[}]{\|=+-_)(*&^%$#@!~" . $part1 . $part2;
$the_list = $the_code;
$the_ref = reverse($the_code);
$ml = length($the_code);
$mysalt .= "*";
for ($x1=1; $x1 < length($mysalt); $x1++) {
  $inx = index($the_ref,substr($mysalt,$x1,1));
  if ($inx >0) {
     $part1 = substr($mysalt,$x1,1) . substr($the_ref,0,$inx);
     $part2 = substr($the_ref,$inx+1,999);
     $the_ref = reverse($part1 . $part2);
    }
 }
for ($x1=1; $x1 < $scramble_variable ;$x1++) { 
  $part1 = substr($the_ref,0,10);
  $part2 = substr($the_ref,10,25);
  $part3 = substr($the_ref,35,(length($the_ref)-35));
  $the_ref = reverse($part2 . reverse($part1) . $part3);
 }
$val=0;$val2=0;$val3=0;$val4=0;
$key = reverse($key);
while ($key ne "") {  
  $inx = chop($key);
  $last_char = $this_char;
  $this_char = $inx;
  if (index($the_code,$inx) >= 0) { # found in our set
    $val = index($the_code,$inx) + $val;
    $val3 = index($the_ref,$inx);
    $val2 = $val3 - $val4;
    $val4 = $val3;
    while ($val2 < 0) {
      $val2 = $val2 + length($the_ref);
     }
    while ($val >= length($the_ref)) {
      $val = $val - length($the_ref);
     }
    $ans .= substr($the_code,$val2,1);
    $ans2 .= substr($the_ref,$val,1);
   } else {
    $ans .= $inx;
    $ans2 .= $inx;
   } 
 }
 if ($backout == "1") {
   return $ans2;
  } else {
   return $ans;
  } 
}
#######################################################################
sub output_modify_quantity_form {
&standard_page_header("Change Quantity");
&display_cart_table("changequantity");
&modify_form_footer;
}
#######################################################################
sub modify_quantity_of_items_in_cart {
&checkReferrer;  
 @incoming_data = keys (%form_data);
foreach $key (@incoming_data)
{
if (($key =~ /[\d]/) && ($form_data{$key} =~ /\D/) && 
(!($form_data{$key} < 0)) && (!($form_data{$key} > 0)))
{
$form_data{$key}="";
}
unless ($key =~ /[\D]/ && $form_data{$key} =~ /[\D]/)
{
  if ($form_data{$key} ne "")
  {
  push (@modify_items, $key);
  }
}
}
open (CART, "<$sc_cart_path") || &file_open_error("$sc_cart_path", "Modify Quantity of Items in the Cart", __FILE__, __LINE__);
while (<CART>)
{
@database_row = split (/\|/, $_);
my $inventory_pid = $database_row[1];
$cart_row_number = pop (@database_row);
push (@database_row, $cart_row_number);
$old_quantity = shift (@database_row);
chop $cart_row_number;
foreach $item (@modify_items)
{
if ($item eq $cart_row_number) {
if ($form_data{$item} =~ /\-/) {
  $form_data{$item} =~ s/\-//g;
  $form_data{$item} = 0 - $form_data{$item};
 }  
if (($form_data{$item} < 0) || ($form_data{$item} =~ /\+/)) {
  &codehook("item_quantity_to_be_modified");
  $form_data{$item} =~ s/\+//g;
  $form_data{$item} = $old_quantity + $form_data{$item};
 }
$form_data{$item} = 0 + $form_data{$item};
if ($form_data{$item} le 0) {
  $shopper_row .= "\|"; 
 } else {
  $shopper_row .= "$form_data{$item}\|";
  foreach $field (@database_row)
  {
  $shopper_row .= "$field\|";
  }
 }
$quantity_modified = "yes";
&codehook("item_quantity_modified");
chop $shopper_row; 
}
}
if ($quantity_modified ne "yes")
{
$shopper_row .= $_;
}
$quantity_modified = "";
}
close (CART);
open (CART, ">$sc_cart_path") || &file_open_error("$sc_cart_path", "Modify Quantity of Items in the Cart", __FILE__, __LINE__);
print CART "$shopper_row";
close (CART);
&update_special_variable_options('calculate');
&codehook("modify_quantity_of_items_in_cart_bot");
&finish_modify_quantity_of_items_in_cart;
}
#######################################################################
sub finish_modify_quantity_of_items_in_cart {
 &codehook("finish_modify_quantity_of_items_in_cart");
 &display_cart_contents;
}
#######################################################################
sub output_delete_item_form {
&standard_page_header("Delete Item");
&display_cart_table("delete");
&delete_form_footer;
}
#######################################################################
sub delete_from_cart {
&checkReferrer; 
@incoming_data = keys (%form_data);
foreach $key (@incoming_data)
{
unless ($key =~ /[\D]/)
{
if ($form_data{$key} ne "")
{
push (@delete_items, $key);
}
}
}
open (CART, "<$sc_cart_path") || &file_open_error("$sc_cart_path", "Delete Item From Cart", __FILE__, __LINE__);
while (<CART>)
{
@database_row = split (/\|/, $_);
my $inventory_pid = $database_row[1];
$cart_row_number = pop (@database_row);
$db_id_number = pop (@database_row);
push (@database_row, $db_id_number);
push (@database_row, $cart_row_number);
chop $cart_row_number;
$old_quantity = shift (@database_row);
$delete_item = "";
foreach $item (@delete_items)
{
if ($item eq $cart_row_number)
{
$delete_item = "yes";
&codehook("mark_item_for_delete");
}
}
if ($delete_item ne "yes")
{
$shopper_row .= $_;
} 
}
close (CART);
open (CART, ">$sc_cart_path") || &file_open_error("$sc_cart_path", "Delete Item From Cart", __FILE__, __LINE__);
print CART "$shopper_row";
close (CART);
&finish_delete_from_cart;
}
#######################################################################
sub finish_delete_from_cart {
  &codehook("finish_delete_from_cart");
  &update_special_variable_options('calculate');
  &display_cart_contents;
}
#######################################################################   
sub display_cart_contents {
local ($my_gt,$my_tq,$tmq,$tc,$st) = "";
local (@cart_fields);
local ($field, $cart_id_number, $quantity, $display_number,
$unformatted_subtotal, $subtotal, $unformatted_grand_total,
$grand_total, $taxable_grand_total);
$sc_special_page_meta_tags = '  <meta http-equiv="Cache-Control" Content="no-cache">';
$sc_special_page_meta_tags .= "\n";
$sc_special_page_meta_tags .= '  <meta http-equiv="Pragma" Content="no-cache">';
&codehook("display_cart_contents_top");
&standard_page_header("View/Modify Cart"); 
($taxable_grand_total, $my_gt,$my_tq,$tmq,$tc,$st) = &display_cart_table("");
&codehook("display_cart_contents_bottom");
&cart_footer((0+$my_gt),(0+$my_tq));
&call_exit;
}
#######################################################################
sub cart_table_header {
local ($modify_type) = @_;
&codehook("cart_table_header_top");
if ($modify_type ne "") {
  $modify_type = "<th>$modify_type</th>";
  &codehook("display_cart_heading_modify_item");
 }
if (($sc_use_secure_header_at_checkout =~ /yes/i) && 
  (($reason_to_display_cart =~ /orderform/i) || 
   ($reason_to_display_cart =~ /verify/i))) {
  &SecureStoreHeader;
 } else {
  &StoreHeader;
 }
$hidden_fields = &make_hidden_fields;
&codehook("cart_table_header");
if ($special_message ne "") {
  print $special_message;
 }

# buysafe adjustment
if (($sc_use_secure_header_at_checkout =~ /yes/i) && 
  (($reason_to_display_cart =~ /orderform/i) || 
   ($reason_to_display_cart =~ /verify/i))) {
  print qq|<form method="post" action="$sc_stepone_order_script_url" id="cartForm" name="cartForm">
<input type="hidden" name="order_form_button" value="1">
|;
 } else {
  print qq|<form method="post" action="$sc_main_script_url" id="cartForm" name="cartForm">|;
 }

print qq~
$hidden_fields
<div align="center">
<table class="ac_cart_table">
<tr>
$modify_type
~;
my $temp_index = "0";
foreach $field (@sc_cart_display_fields)
{

&codehook("display_cart_heading_item");

   if (($sc_col_name[$temp_index] ne "web_options")&&($sc_col_name[$temp_index] ne "options")&&($sc_col_name[$temp_index] ne "email_options")) { 
      $cart_heading_item = "<th>$field</th>\n";
      print $cart_heading_item;
   }

$temp_index++;
}
}
#######################################################################
sub display_cart_table {
local($reason_to_display_cart) = @_;
local(@cart_fields);
local($cart_id_number,$cart_line_id,$field_name);
local($quantity);
local($unformatted_subtotal);
local($subtotal);
local($unformatted_grand_total);
local($grand_total);
local($stevo_shipping_thing,$temp) = "";
local($price);
local($test_price);
local($text_of_cart);
local($total_quantity) = 0;
local($total_measured_quantity) = 0;
local($display_index);
local($counter);
local($display_me,$found_it);
local($hidden_field_name);
local($hidden_field_value);
local($display_counter);
local($product_id, @db_row);
# taxable or non-table. added by Mister Ed Sept 13, 2005
my($isTaxable);
local($unformatted_taxable_grand_total);
local($taxable_grand_total);
&codehook("display_cart_top");
if ($sc_global_bot_tracker ne "1") { # run only if not a bot
if ($reason_to_display_cart =~ /change*quantity/i) 
{
&cart_table_header("New Quantity");
} 
elsif ($reason_to_display_cart =~ /delete/i) 
{
&cart_table_header("Delete Item");
} 
else 
{
&cart_table_header("");
}
if (!(-f "$sc_cart_path")) { 
  open (CART, ">$sc_cart_path") ||
       &file_open_error("$sc_cart_path", 
      "display_cart_contents create null file", 
      __FILE__, __LINE__);
  close(CART);
 }
open (CART, "$sc_cart_path") ||
&file_open_error("$sc_cart_path", "display_cart_contents", __FILE__, __LINE__);
while (<CART>)
{
print "</tr><tr>";
chop;    
$temp = $_;
@cart_fields = split (/\|/, $temp);
$cart_row_number = pop(@cart_fields);
push (@cart_fields, $cart_row_number);
$cart_copy{$cart_row_number} = $temp;
&codehook("display_cart_row_read");
$quantity   = $cart_fields[$cart{"quantity"}];
$product_id   = $cart_fields[$cart{"product_id"}];
# taxable or non-table. added by Mister Ed Sept 13, 2005
$isTaxable = $cart_fields[$cart{"user4"}];
if (!($sc_db_lib_was_loaded =~ /yes/i)) {
  &require_supporting_libraries (__FILE__, __LINE__, "$sc_db_lib_path");
 }
undef(@db_row);
$found_it = &check_db_with_product_id($product_id,*db_row); 
&codehook("display_cart_db_row_read");
$item_agorascript = "";
foreach $zzzitem (@db_row) {
  $field = $zzzitem;
  if ($field =~ /^%%OPTION%%/i) {
    ($empty, $option_tag, $option_location) = split (/%%/, $field);
    $field = &load_opt_file($option_location);
    $item_agorascript .= $field;
   }
 }
&codehook("display_cart_item_agorascript");
$zzfield = &agorascript($item_agorascript,"display-cart",
    "$product_id",__FILE__,__LINE__);
if (($reason_to_display_cart =~ /orderform/i) 
   && ($sc_order_check_db =~ /yes/i)) {
if (!($found_it)) 
 {
print qq~
</tr>
</table>
<div align="center">
<p class="ac_error">
  I'm sorry, Product ID: $product_id was not found in 
  the database. Your order cannot be processed without 
  this product validation. Please contact the 
  <a href=mailto:$sc_admin_email>site administrator</a>.
</p>
</div>
</body>
</html>~;
&call_exit;
 } 
else 
 {
  $test_price =  &vf_get_data("PRODUCT",
    $sc_db_price_field_name,
    $db_row[$sc_db_index_of_product_id],
    @db_row);
  if ($test_price ne $cart_fields[$sc_cart_index_of_price]) 
  {
  print qq~
</tr>
</table>
<div align="center">
<p class="ac_error">
  Price for product id:$product_id did not match
  database! Your order will NOT be processed without 
  this validation!
</p>
</div>
</body>
</html>~; 
  &call_exit;
  }
 }
}
$total_quantity += $quantity;
if ($reason_to_display_cart =~ /change*quantity/i) 
{
print qq!
<td>
  <input type="text" name="$cart_row_number" size="3">
</td>\n!;
} 
elsif ($reason_to_display_cart =~ /delete/i) 
{
print qq!<td>
  <input type="checkbox" name="$cart_row_number">
</td>\n!;
}
$display_counter = 0;
$text_of_cart .= "\n\n";

my $temp_fieldname_indicator = '';
foreach $field_name (@sc_col_name)
{ 
   if (($field_name eq "web_options")||($field_name eq "options")||($field_name eq "email_options")) {
       $temp_fieldname_indicator ="1";
   }
}

foreach $field_name (@sc_col_name)
{ 
 $display_index = $cart{$field_name};
 $cart_line_id = $cart_fields[$cart{'unique_cart_line_id'}];
if ($display_index >= 0) {
 if ($cart_fields[$display_index] eq "")
 {
  $text_of_cart .= &format_text_field(
  $sc_cart_display_fields[$display_counter]) .
  "= nothing entered\n";
  $cart_fields[$display_index] = "&nbsp;";
 }       
 $display_me = &vf_get_data("CART",$field_name,$cart_line_id,@cart_fields);
 if ($sc_cart_display_factor[$display_counter] =~ /yes/i) {
   $display_me = $display_me * $quantity;
  }
 }
$sc_display_special_request = 0;
$zzfield = &agorascript($item_agorascript,"display-cart-" . $display_index,
    "$product_id",__FILE__,__LINE__);
&codehook("cart_table_special_request_decision");
if (!($sc_display_special_request == 0)) {
  &codehook("cart_table_special_request");
 }
elsif ($field_name eq "quantity") {
  if (($reason_to_display_cart ne "") || 
     (!($sc_qty_box_on_cart_display =~ /yes/i))) {
    print qq!<td>$display_me</td>\n!;
   } else {
    print qq!
<td>
  <input type="text" name="$cart_row_number" value="$display_me" size="3">
</td>\n!;
   } 
 }
elsif ($display_index == $sc_cart_index_of_price)
{
$price = &display_price($display_me); 
print qq!<td>$price</td>\n!;
$text_of_cart .= &format_text_field(
$sc_cart_display_fields[$display_counter]) .
"= $price\n";
}

elsif ($display_index == $sc_cart_index_of_price_after_options)
{
$lineTotal = &format_price($display_me);
$lineTotal = &display_price($lineTotal);
print qq!<td>$lineTotal</td>\n!;
$text_of_cart .= &format_text_field(
$sc_cart_display_fields[$display_counter]) .
"= $lineTotal\n";
}
elsif (($field_name eq "web_options")||($field_name eq "options")||($field_name eq "email_options")) { }
elsif ($display_index < 0) 
{
$display_me = $db_row[(0-$display_index)];
if ($sc_cart_display_factor[$display_counter] =~ /yes/i) {
  $display_me = $display_me * $quantity; 
 }
if ($display_me =~ /^%%img%%/i)
{
($empty, $image_tag, $image_location) = split (/%%/, $display_me);
$display_me = '<img src="'."$URL_of_images_directory/$image_location" . 
  '" alt="' . "$image_location" . '"/>';
}
 if($display_index == "-6") {
   if ($sc_use_SBW =~ /yes/i) {
     $display_me = $display_me; 
    } else { # display total price
     $display_me = &display_price($display_me);
    }
 }
$display_me =~ s/%%URLofImages%%/$URL_of_images_directory/g;
print qq!<td>$display_me</td>\n!;
}
elsif ($display_index == $sc_cart_index_of_image)
{
$display_me = $cart_fields[$display_index];
$display_me =~ s/%%URLofImages%%/$URL_of_images_directory/g;
print qq!<td>$display_me</td>\n!;
}
elsif ($display_index == $sc_cart_index_of_measured_value)
{
if ($sc_use_SBW =~ /yes/i) { #display total pounds
  $shipping_price = $display_me; 
 } else { # display total price
  $shipping_price = &display_price($display_me); 
 }
print qq!<td>$shipping_price</td>\n!;
$text_of_cart .= &format_text_field($sc_cart_display_fields[$display_counter]) .
"= $price\n
";
}
else
{

if ($field_name eq "name") {
    if (($temp_fieldname_indicator eq "1") && ($cart_fields[15] ne '')) {
        my @ans_opts = split(/$sc_opt_sep_marker/,$cart_fields[15]); 
        my $ans2 = join "<br /> &nbsp;&nbsp;&nbsp; + &nbsp; ",@ans_opts;
        print qq!<td><div align="left">&nbsp; <b>$display_me</b> <br /> &nbsp;&nbsp;&nbsp; + &nbsp; $ans2 </div></td>\n!;
    } else {
        print qq!<td><div align="left">&nbsp; <b>$display_me</b></div></td>\n!;
    }
} else {
    print qq!<td>$display_me</td>\n!;
}

  if ($display_index != 5)
  {
  $text_of_cart .= &format_text_field(
  $sc_cart_display_fields[$display_counter]) .
  "= $cart_fields[$display_index]\n";
  }
}
$display_counter++;
}
$total_measured_quantity = $total_measured_quantity + $quantity*$cart_fields[6];  
$shipping_total = $total_measured_quantity;
# alt origin postal code adds postal code to stevo for shipping by Mister Ed Feb 9, 2005
# added alt origin state/prov by Mister Ed May 22, 2007
if ($sc_alt_origin_enabled =~ /yes/i) {
    my($zip,$stateprov,$junk) = split(/\,/,$cart_fields[11],3);
        $stevo_shipping_thing .= '|' . $quantity . '*' . $cart_fields[6] 
        . '*' . $cart_fields[$sc_cart_index_of_price_after_options] . '*' . $zip . '*' . $stateprov . '*';
} else {
        $stevo_shipping_thing .= '|' . $quantity . '*' . $cart_fields[6] 
        . '*' . $cart_fields[$sc_cart_index_of_price_after_options] . '*' . '*' . '*';
}

# dimensional shipping data added to stevo for shipping by Mister Ed May 17, 2007
if ($sc_dimensional_shipping_enabled =~ /yes/i) {
        $stevo_shipping_thing .= $cart_fields[13];
}
$unformatted_subtotal = ($cart_fields[$sc_cart_index_of_price_after_options]);
$subtotal = &format_price($quantity*$unformatted_subtotal);
$unformatted_grand_total = $grand_total + $subtotal;
$grand_total = &format_price($unformatted_grand_total);
# taxable or non-table. added by Mister Ed Sept 13, 2005
if ($isTaxable !~ /yes/i) {
    $unformatted_taxable_grand_total = $taxable_grand_total + $subtotal;
    $taxable_grand_total = &format_price($unformatted_taxable_grand_total);
}
$price = &display_price($subtotal);
$text_of_cart .= &format_text_field("Quantity") .
"= $quantity\n";
$text_of_cart .= &format_text_field("Subtotal For Item") .
"= $price\n";
}
close (CART);
$sc_shipping_thing = $shipping_total . $stevo_shipping_thing;
$sc_cart_copy_made = "yes";
$price = &display_price($grand_total);
$shipping_total = &display_price($shipping_total);
if ($reason_to_display_cart =~ /verify/i) {
print qq!<input type="hidden" name="total" value="$grand_total">!;
}
&cart_table_footer($price);
if ($reason_to_display_cart =~ /verify/i) {
&display_calculations($taxable_grand_total,$grand_total,"at",
$total_measured_quantity,$text_of_cart,$stevo_shipping_thing);
} else {
&display_calculations($taxable_grand_total,$grand_total,"before",
$total_measured_quantity,$text_of_cart,$stevo_shipping_thing);
}
$text_of_cart .= "\n\n" . &format_text_field("Subtotal:") .
"= $price\n\n";
return($taxable_grand_total, $grand_total, $total_quantity, $total_measured_quantity,
$text_of_cart, $stevo_shipping_thing);

}# end of "run only if not a bot"

}
#######################################################################
# empty cart footer message added.  Closing table cells added to closing
# table tag as well by Mister Ed (K-Factor Technologies, Inc) 10/17/2003
sub cart_table_footer {
local($price, $shipping_total) = @_;
local($footer);
if ($price == 0) {
print $sc_empty_cart_footer_msg;
}
$footer = qq~</tr>
</table>
</div>
~;
&codehook("cart_table_footer");
print $footer;
}
#######################################################################
sub generate_invoice_number {
  local ($invoice_number)='';
  &codehook("generate_invoice_number");
  if ($invoice_number eq '') {
    $invoice_number = time;
   }
  return $invoice_number;
 }
#######################################################################
sub init_shop_keep_email {
 # put whatever at the top of the var '$email'
 local ($email)='';
 &codehook("init_shop_keep_email");
 return $email;
}
#######################################################################
sub addto_shop_keep_email {
 # put whatever at the end of the var '$email'
 local ($email)='';
 &codehook("addto_shop_keep_email");
 return $email;
}
#######################################################################
sub init_customer_email {
 # put whatever at the top of the var '$email'
 local ($email)='';
 &codehook("init_customer_email");
 return $email;
}
#######################################################################
sub addto_customer_email {
 # put whatever at the end of the var '$email'
 local ($email)='';
 &codehook("addto_customer_email");
 return $email;
}
#######################################################################
1;
