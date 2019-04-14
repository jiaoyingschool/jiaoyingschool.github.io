# PayPal Processing Gateway
#
# Copyright 2000,2001 Steve Kneizys.
# Copyright 2002-Present K-Factor Technologies, Inc.  All Rights Reserved.
#
# Requires AgoraCart version 5.0.0 or above.  Just place this file in the library directory.
#
# This is NOT FREE AND/OR GPL SOFTWARE!  This library is a cost item.
# This software is a separate add-on to an ecommerce shopping cart and 
# is the confidential and proprietary information of K-Factor Technologies, Inc.  You may
# not disclose such Confidential Information and shall use it only in
# conjunction with the AgoraCart (aka agora.cgi) shopping cart.  It must be licensed for
# Each use on EACH store it is used on.  License at AgoraCartPro.com
#
# To use it you must license it from http://www.agoracart.com/ or
# http://www.agoracartpro.com/
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
# You may not give this script/add-on away or distribute it an any way outside of a copy of
# AgoraCart without written permission from K-Factor Technologies, Inc.  K-Factor Technologies, Inc.
# reserves any and all rights to distributions, add-ons, and other works based on this
# piece of software as well as any and all rights to profit sharing and/or to charge for
# such works and/or derivatves.
#
#######################################################################
#                    Order Form Definition Variables                  #
#######################################################################

$versions{'PayPal-order_lib.pl'} = "5.5.002 Pro Version";

#best to leave this option as it is, as PayPal return is NOT guaranteed!
$sc_paypal_email_before = "yes"; # set to "no" if email upon return

$sc_use_secure_header_at_checkout = 'yes';
$sc_PayPal_form_prep = 0;

&add_codehook("printSubmitPage","print_PayPal_SubmitPage");
&add_codehook("set_form_required_fields","PayPal_fields");
&add_codehook("pre_header_navigation","PayPal_pre_header_nav");
&add_codehook("gateway_response","PayPal_gateway_response");
$sc_order_response_vars{"PayPal"}="ppret";

##############################################################################
sub PayPal_URL_logic {
  local($bn,$url,$return,$mylogic,$err_code);
  if ($sc_use_custom_paypal_url_logic =~ /yes/i) {
    $mylogic = "$sc_custom_paypal_url_logic";
    eval($mylogic);
    $err_code = $@;
    if ($err_code ne "") { #script died, error of some kind
      &update_error_log("custom-paypal-url-logic $err_code ","","");
     }
   } else {
    $return = $sc_store_url;
    $return =~ s/\:/\%3A/;
    $bn = $sc_gateway_username;
    $bn =~ s/\@/\%40/; 
    $url = $sc_order_script_url . '=' . $bn .
 	         "&item_name=" . &my_paypal_order_name . &my_paypal_order_number .
           "&item_number=" . &my_paypal_order_number .
           "&amount=" . &format_price($authPrice) .
           "&currency_code=$sc_currency_id" .
           "&no_shipping=1" .
           "&address_override=$sc_paypal_address_override" .
           "&first_name=$vform_Ecom_ShipTo_Postal_Name_First" .
           "&last_name=$vform_Ecom_ShipTo_Postal_Name_Last" .
           "&address1=$vform_Ecom_ShipTo_Postal_Street_Line1" .
           "&city=$vform_Ecom_ShipTo_Postal_City" .
           "&state=$vform_Ecom_ShipTo_Postal_StateProv" .
           "&zip=$vform_Ecom_ShipTo_Postal_PostalCode" .
           "&return=$return" .
           "&bn=AgoraCart" .
           "%3Fppret%3D$cart_id";
    $url =~ s/\ /+/g;
    $url =~ s/\#/\%23/g;
  } 

# use this to change $url
&codehook("PayPal_URL_logic_bottom");

 return $url;

 }
##############################################################################
sub PayPal_order_form_prep {# load the customer info ...
  local($myname)="PayPal";
    if ($myname ne $sc_gateway_name) { # secondary gateway, load settings
      &require_supporting_libraries(__FILE__,__LINE__,
         "./admin_files/$myname-user_lib.pl");
     } 
  if ($sc_PayPal_form_prep == 0) {
    if (-f "$sc_verify_order_path"){
      &read_verify_file;
     } else {
      &codehook("load_customer_info");
     }
    $sc_PayPal_form_prep = 1;
   }
 }
##############################################################################
sub PayPal_gateway_response {
  local($myname)="PayPal";
  if ($form_data{'ppret'}) {
    if ($myname ne $sc_gateway_name) { # secondary gateway, load settings
      &require_supporting_libraries(__FILE__,__LINE__,
         "./admin_files/$myname-user_lib.pl");
     } 
    &load_order_lib;
    $cart_id = $form_data{'ppret'};
    &set_sc_cart_path;
    &codehook("PayPal_order_return");
    &process_PayPal_Order("return");
    &call_exit;
   }
 }
##############################################################################
sub PayPal_pre_header_nav {
 local($myname)="PayPal";
$sc_PayPal_form_prep = 0;
 if ($form_data{'ppsnd'}) {
   if ($myname ne $sc_gateway_name) { # secondary gateway, load settings
     &require_supporting_libraries(__FILE__,__LINE__,
        "./admin_files/$myname-user_lib.pl");
    }
   &load_order_lib;
   $cart_id = $form_data{'ppsnd'};
   &set_sc_cart_path;
   &codehook("PayPal_order_send");
   &process_PayPal_Order("send");
   &call_exit;
  }
 }
###############################################################################

sub PayPal_fields{
local($myname)="PayPal";

if (!($form_data{'gateway'} eq $myname)) { return;} 

%sc_order_form_array =(
  'Ecom_BillTo_Postal_Name_First', 'First Name',
  'Ecom_BillTo_Postal_Name_Last', 'Last Name',
  'Ecom_BillTo_Postal_Street_Line1', 'Billing Address Street',
  'Ecom_BillTo_Postal_City', 'Billing Address City',
  'Ecom_BillTo_Postal_StateProv', 'Billing Address State',
  'Ecom_BillTo_PostalCode', 'Billing Address Zip',
  'Ecom_BillTo_Postal_CountryCode', 'Billing Address Country',
  'Ecom_ShipTo_Postal_Name_First', 'First Name',
  'Ecom_ShipTo_Postal_Name_Last', 'Last Name',
  'Ecom_ShipTo_Postal_Street_Line1', 'Shipping Address Street',
  'Ecom_ShipTo_Postal_City', 'Shipping Address City',
  'Ecom_ShipTo_Postal_StateProv', 'Shipping Address State',
  'Ecom_ShipTo_Postal_PostalCode', 'Shipping Address Zip',
  'Ecom_ShipTo_Postal_CountryCode', 'Shipping Address Country',
  'Ecom_BillTo_Telecom_Phone_Number', 'Phone Number',
  'Ecom_BillTo_Online_Email', 'Email',
  'Ecom_is_Residential', 'Shipping to Residential Address',
  'Ecom_ShipTo_Insurance', 'Insure this Shipment', # not implemented yet, for the future
  'Ecom_tos', 'Sales-Terms of Service');
                        
@sc_order_form_required_fields = (
  "Ecom_BillTo_Online_Email",
  "Ecom_ShipTo_Postal_Name_First",
  "Ecom_ShipTo_Postal_Name_Last",
  "Ecom_ShipTo_Postal_Street_Line1",
  "Ecom_ShipTo_Postal_City",
	"Ecom_ShipTo_Postal_StateProv",
	"Ecom_ShipTo_Postal_PostalCode",
  "Ecom_ShipTo_Postal_CountryCode");

# lines for tos added 2006 April 18 by jfindlay
 if ($sc_display_checkout_tos =~ /yes/i) {
    push(@sc_order_form_required_fields,"Ecom_tos");
 }

# use this codehook to change the above arrays for required fields and such
&codehook("PayPal_fields_bottom");

}

###############################################################################
sub PayPal_verification_table {
  # added by Justin Findlay April 18, 2006
  local ($rslt)="";
  $rslt = <<ENDOFTEXT;
  
<div align="center">
<table cellpadding="0" cellspacing="0" class="ac_checkout_review">
<tr>
<th colspan="2" class="ac_checkout_review">Customer Information</th>
</tr>

<tr>
<td class="ac_checkout_review_col1">Customer Number</td>
<td class="ac_checkout_review_col2">$cart_id</td>
</tr>

<tr>
<td class="ac_checkout_review_col1">E-Mail</td>
<td class="ac_checkout_review_col2">$form_data{'Ecom_BillTo_Online_Email'}&nbsp;</td>
</tr>

<tr>
<th colspan="2" class="ac_checkout_review">Shipping Information</th>
</tr>

ENDOFTEXT

if ($form_data{'Ecom_ShipTo_Method'} ne ""){
$answer.= <<ENDOFTEXT;
<tr>
<td class="ac_checkout_review_col1">Ship via</td>
<td class="ac_checkout_review_col2">$form_data{'Ecom_ShipTo_Method'}&nbsp;</td>
</tr>
ENDOFTEXT
}

$rslt.= <<ENDOFTEXT;

<tr>
<td class="ac_checkout_review_col1">Street</td>
<td class="ac_checkout_review_col2">$form_data{'Ecom_ShipTo_Postal_Street_Line1'}&nbsp;</td>
</tr>

<tr>
<td class="ac_checkout_review_col1">City</td>
<td class="ac_checkout_review_col2">$form_data{'Ecom_ShipTo_Postal_City'}&nbsp;</td>
</tr>

<tr>
<td class="ac_checkout_review_col1">State/Province</td>
<td class="ac_checkout_review_col2">$form_data{'Ecom_ShipTo_Postal_StateProv'}&nbsp;</td>
</tr>

<tr>
<td class="ac_checkout_review_col1">Zip</td>
<td class="ac_checkout_review_col2">$form_data{'Ecom_ShipTo_Postal_PostalCode'}&nbsp;</td>
</tr>

<tr>
<td class="ac_checkout_review_col1">Country</td>
<td class="ac_checkout_review_col2">$form_data{'Ecom_ShipTo_Postal_CountryCode'}&nbsp;</td>
</tr>

</table>
</div>
ENDOFTEXT

# use this to change $rslt
&codehook("PayPal_verification_table_bottom");

  return $rslt;
 }
###############################################################################
sub my_paypal_order_name{
  local($temp);
  eval('$temp = "' . $sc_paypal_order_name . '";');
  return $temp;
 }
###############################################################################
sub my_paypal_order_number{
  local($temp);
  eval('$temp = "' . $sc_paypal_order_number . '";');
  return $temp;
 }
###############################################################################

sub print_PayPal_SubmitPage

{
local($invoice_number, $customer_number, $url, $return, $img, $bn);
local($myname)="PayPal";
local($my_change,$my_message,$my_desc);

if (!($form_data{'gateway'} eq $myname)) { return;} 
if ($myname ne $sc_gateway_name) { # secondary gateway, load settings
  &require_supporting_libraries(__FILE__,__LINE__,
     "./admin_files/$myname-user_lib.pl");
 }

$invoice_number = $current_verify_inv_no;
$customer_number = $cart_id;
$customer_number =~ s/_/./g;

if (($sc_paypal_email_before =~ /yes/i) &&
    ($authPrice > 0)) {
  $url = $sc_store_url . "?ppsnd=$cart_id";
 } else {
  &read_verify_file;
  $url = &PayPal_URL_logic;
  
 }

$img = "$sc_button_image_URL"; 
$img =~ s/%%URLofImages%%/$URL_of_images_directory/g;
$verification_table = &PayPal_verification_table;
$my_desc = &script_and_substitute($sc_paypal_order_desc);
$my_change = &script_and_substitute($sc_paypal_change);
$my_make_changes = $sc_stepone_order_script_url . "?" . &make_href_fields
	. "&order_form_button=1&ofn=PayPal";
$my_message = &script_and_substitute($sc_paypal_verify_message);

if ($order_ok_final_msg_tbl eq '') {
 # Default so something is there, use $messages{'ordcnf_10'} though 
 # to customize, set it in the Free Form Logic (either location.)
  $order_ok_final_msg_tbl = "<b>Order Confirmation</b><br/><br/>" . &get_date;
 }

if ($sc_use_alternate_PayPal_submit_page ne "Yes") {
############  Start of Standard submit page - Select from this line to for copy functions ############
#### can use in custom submit page.  Custom file must be named: PayPal_custom_processing_lib.pl
#### Custom function (aka sub routine) to replace the code below must be named: PayPal_custom_submit_page
 
print <<ENDOFTEXT;

<div align="center">
  <p class="ac_checkout_top_msg">$order_ok_final_msg_tbl $my_message</p>

$verification_table

<TABLE WIDTH="500" CELLPADDING="2" CELLSPACING="0" BORDER=0>
<TR>
<TD COLSPAN=2>
<CENTER>
<A HREF="$my_make_changes"><IMG SRC="$my_change" BORDER=0></a>
<br>
<!-- Begin PayPal Logo -->
<A HREF="$url" target="_top">
<IMG SRC="$img" 
BORDER="0" ALT="Make payments with PayPal - it's fast, free and secure!"></A>
<!-- End PayPal Logo -->
</CENTER>
</TD>
</TR>
</TABLE>

</CENTER>

ENDOFTEXT

############  End of Submit Page Code - Select until this line for copy functions ############
}
else { # uses alternate processing file in add_ons sub directory

 &codehook("PayPal_custom_submit_page");

} # end of alternate submit page

}
############################################################################################

sub process_PayPal_Order {

local ($mode)=@_;
local ($subtotal, $total_quantity,
       $total_measured_quantity,
       $text_of_cart,
       $required_fields_filled_in, $product, $quantity, $options);
local ($stevo_shipping_thing) = "";
local ($stevo_shipping_names) = "";
local ($ship_thing_too,$ship_instructions, $href, $return, $bn);

# NEW CODEHOOK
&codehook("process-order-routine-top");

#more complicated than required .... simplify someday!
if ((($sc_paypal_email_before =~ /yes/i) && ($mode eq "send")) ||
   ((!($sc_paypal_email_before =~ /yes/i)) && (!($mode eq "send")))){
  &send_PayPal_Email;
 }

if ($mode eq "send") { # Need to send them to PayPal
  $authPrice = $sc_verify_grand_total;
  &read_verify_file;
  $url = &PayPal_URL_logic;

  print "Location: $url\n\n";
  &call_exit;
 }

if ($sc_use_alternate_PayPal_order_processing ne "Yes") {
############  Start of Standard Confirm Page - Select from this line to for copy functions ############
#### can use in custom processing file.  Custom file must be named: PayPal_custom_processing_lib.pl
#### Place PayPal_custom_processing_lib.pl in the library directory of your store
#### Custom function (aka sub routine)  to replace the code below must be named: PayPal_custom_processing_custom_page_function
  
print qq!
<HTML>
<HEAD>
<TITLE>$messages{'ordcnf_08'}</TITLE>
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
$sc_standard_head_info</HEAD>
<BODY $sc_standard_body_info>
!;

&SecureStoreHeader;

print <<ENDOFTEXT;
<CENTER>
<TABLE WIDTH=500>
<TR>
<TD WIDTH=500>
<BR>
<FONT FACE=ARIAL>
$messages{'ordcnf_01'}
$messages{'ordcnf_02'}
</FONT>
</TD>
</TR>
</TABLE>
<CENTER>  

ENDOFTEXT

# and the footer is printed

&SecureStoreFooter;

undef(%form_data);

print qq!
</BODY>
</HTML>
!;

############  End of Standard Confirm Page - Select until this line for copy functions ############
}
else { # uses alternate processing file in add_ons sub directory
      &require_supporting_libraries(__FILE__,__LINE__,
     "./library/PayPal_custom_lib.pl");
 &PayPal_custom_processing_confirm_page_function;

} # end of alternate processing

} # End of process_order_form

#################################################################
sub send_PayPal_Email {
local($weight,$myoptions,$options,$quantity,$product,$product_price);
local(%orderLoggingHash);
#
# Need to process this info
&load_verify_file;

$orderDate = &get_date;

if ($sc_use_alternate_PayPal_order_processing ne "Yes") {
############  Start of Standard Processing Code - Select from this line to for copy functions ############
#### can use in custom processing file.  Custom file must be named: PayPal_custom_processing_lib.pl
#### Place PayPal_custom_processing_lib.pl in the library directory of your store
#### Custom function (aka sub routine)  to replace the code below must be named: PayPal_custom_processing_function

$text_of_cart .= "Gateway:       PayPal Standard\n\n";
$orderLoggingHash{'GatewayUsed'} = "PayPal standard";

$text_of_cart .= "New Order: $orderDate\n\n";

$text_of_cart .= "  --PRODUCT INFORMATION--\n\n";

open (CART, "$sc_cart_path") || &file_open_error("$sc_cart_path", 
	"PayPal_display_cart_contents", __FILE__, __LINE__);

if ($sc_opt_sep_marker eq '') {
  $sc_opt_sep_marker = '<br>';
 }
while (<CART>) {
$cartData++;
@cart_fields = split (/\|/, $_);
$quantity = $cart_fields[0];
$product_price = $cart_fields[3];
$product = $cart_fields[4];
$weight = $cart_fields[6];
$options = $cart_fields[$cart{"options"}];
$options =~ s/${sc_opt_sep_marker}$//i;
$myoptions = $options;
$options =~ s/$sc_opt_sep_marker/,/gi;
$text_of_cart .= &cart_textinfo(*cart_fields,$quantity,$product,
                                $options,$product_price);
$myoptions =~ s/<br>/,\n         /g;
if ($myoptions ne '') { $myoptions = "\n        \($myoptions\)";}
$stevo_shipping_thing .= "|$quantity\*$weight";
$stevo_shipping_names .= "|$product$myoptions";
&codehook("process-cart-item");
}
close(CART);

# initialize hash variables in case they are empty later
# added by jfindlay 2006 April 21

$orderLoggingHash{'firstName'} = "";
$orderLoggingHash{'lastName'} = "";
$orderLoggingHash{'fullName'} = "";
$orderLoggingHash{'orderFromAddress'} = "";
$orderLoggingHash{'customerAddress2'} = "";
$orderLoggingHash{'customerAddress3'} = "";
$orderLoggingHash{'orderFromCity'} = "";
$orderLoggingHash{'orderFromPostal'} = "";
$orderLoggingHash{'customerPhone'} = "";
$orderLoggingHash{'faxNumber'} = "";
$orderLoggingHash{'customerPhone'} = "$eform_Ecom_BillTo_Telecom_Phone_Number";
$orderLoggingHash{'companyName'} = "";
$orderLoggingHash{'emailAddress'} = "";

$orderLoggingHash{'shipToName'} = "";
$orderLoggingHash{'shipToAddress'} = "";
$orderLoggingHash{'shipToAddress2'} = "";
$orderLoggingHash{'shipToAddress3'} = "";
$orderLoggingHash{'shipToCity'} = "";
$orderLoggingHash{'shipToState'} = "";
$orderLoggingHash{'shipToPostal'} = "";
$orderLoggingHash{'shipToCountry'} = "";
$orderLoggingHash{'shiptoResidential'} = $eform_Ecom_is_Residential;
$orderLoggingHash{'insureShipment'} = $eform_Ecom_ShipTo_Insurance; # not implemented yet, for the future


$orderLoggingHash{'invoiceNumber'} = "";
$orderLoggingHash{'customerNumber'} = "";
$orderLoggingHash{'orderStatus'} = "$sc_order_status_default";
$orderLoggingHash{'user1'} = "";
$orderLoggingHash{'user2'} = "";
$orderLoggingHash{'user3'} = "";
$orderLoggingHash{'user4'} = "";
$orderLoggingHash{'user5'} = "";
$orderLoggingHash{'itemsordered'} = "";
$orderLoggingHash{'shiptrackingID'} = "";
$orderLoggingHash{'shipMethod'} = "";
$orderLoggingHash{'orderFromState'} = "";
$orderLoggingHash{'orderFromCountry'} = "";
$orderLoggingHash{'shippingTotal'} = "";
$orderLoggingHash{'salesTax'} = "";
$orderLoggingHash{'tax1'} = "";
$orderLoggingHash{'tax2'} = "";
$orderLoggingHash{'tax3'} = "";
$orderLoggingHash{'discounts'} = "";
$orderLoggingHash{'netProfit'} = "";
$orderLoggingHash{'affiliateTotal'} = "";
$orderLoggingHash{'affiliateID'} = "";
$orderLoggingHash{'affiliateMisc'} = "";
$orderLoggingHash{'subTotal'} = "";
$orderLoggingHash{'orderTotal'} = "";
$orderLoggingHash{'adminMessages'} = "";
$orderLoggingHash{'shippingMessages'} = "";
$orderLoggingHash{'xcomments'} = "";
$orderLoggingHash{'termsOfService'} = "$vform_Ecom_tos";
$orderLoggingHash{'faxNumber'} = "";

# new logging items added August 4, 2007 by Mister Ed
$orderLoggingHash{'discountCode'} = "";
$orderLoggingHash{'user6'} = "";
$orderLoggingHash{'user7'} = "";
$orderLoggingHash{'user8'} = "";
$orderLoggingHash{'user9'} = "";
$orderLoggingHash{'user10'} = "";
$orderLoggingHash{'buySafe'} = "";
$orderLoggingHash{'order_payment_type_user1'} = "";
$orderLoggingHash{'order_payment_type_user2'} = "";
$orderLoggingHash{'GiftCard_number'} = "";
$orderLoggingHash{'GiftCard_amount_used'} = "";
$orderLoggingHash{'internal_company_notes1'} = "";
$orderLoggingHash{'internal_company_notes2'} = "";
$orderLoggingHash{'internal_company_notes2'} = "";
$orderLoggingHash{'customer_order_notes1'} = "";
$orderLoggingHash{'customer_order_notes2'} = "";
$orderLoggingHash{'customer_order_notes3'} = "";
$orderLoggingHash{'customer_order_notes4'} = "";
$orderLoggingHash{'customer_order_notes5'} = "";
$orderLoggingHash{'mailinglist_subscribe'} = "";
$orderLoggingHash{'wishlist_subscribe'} = "";
$orderLoggingHash{'insurance_cost'} = "";
$orderLoggingHash{'trade_in_allowance'} = "";
$orderLoggingHash{'rma_number'} = "";
$orderLoggingHash{'customer_contact_notes1'} = "";
$orderLoggingHash{'customer_contact_notes2'} = "";
$orderLoggingHash{'account_number'} = "";
$orderLoggingHash{'sales_rep'} = "";
$orderLoggingHash{'sales_rep_notes1'} = "";
$orderLoggingHash{'sales_rep_notes2'} = "";
$orderLoggingHash{'how_did_you_find_us'} = "";
$orderLoggingHash{'suggestion_box'} = "";
$orderLoggingHash{'preferrred_shipping_date'} = "";
$orderLoggingHash{'ship_order_items_as_available'} = "";

# NEW CODEHOOK
&codehook("process-order-pre-ship-instructions");

$sc_orderlib_use_SBW_for_ship_ins = $sc_use_SBW;
&codehook("orderlib-ship-instructions");
if ($sc_orderlib_use_SBW_for_ship_ins =~ /yes/i) {
  ($ship_thing_too,$ship_instructions) = 
   &ship_put_in_boxes($stevo_shipping_thing,$stevo_shipping_names,
   $sc_verify_Origin_ZIP,$sc_verify_boxes_max_wt); 
 }
$orderLoggingHash{'shippingMessages'} = "$ship_instructions";
$orderLoggingHash{'shippingMessages'} =~ s/\n/<br>/g;

$text_of_confirm_email .= $messages{'ordcnf_07'};

$text_of_confirm_email .= $text_of_cart;
$text_of_confirm_email .= "\n";
$text_of_cart .= "  --ORDER INFORMATION--\n\n";

$text_of_cart .= "CUSTID:        $cart_id \n";
$text_of_confirm_email .= "CUSTID:        $cart_id \n";
$orderLoggingHash{'customerNumber'} = "$cart_id";

$text_of_cart .= "INVOICE:       $sc_verify_inv_no \n\n";
$text_of_confirm_email .= "INVOICE:       $sc_verify_inv_no \n\n";
$orderLoggingHash{'invoiceNumber'} = "$sc_verify_inv_no";

if ($sc_display_checkout_tos =~ /yes/i) {
  &add_text_of_both('SALES TERMS AND REFUND POLICY',$vform_Ecom_tos);
  $orderLoggingHash{'termsOfService'} = "$vform_Ecom_tos";
}

my $temp = &display_price($sc_verify_subtotal);
&add_text_of_both('SUBTOTAL',$temp);
$temp = &format_price($sc_verify_subtotal);
$sc_verify_subtotal_temp3 = $temp;
$orderLoggingHash{'subTotal'} = "$temp";

if (($sc_buySafe_is_enabled =~ /yes/) && ($sc_verify_buySafe > 0)) {
my $temp = &format_price($sc_verify_buySafe);
$text_of_cart .= "$sc_buySafe_bond_fee_mini_display_text       $temp\n";
$text_of_confirm_email .= "$sc_verify_buySafe_display_text       $temp\n";
$orderLoggingHash{'buySafe'} = "$temp";
}

if ($sc_verify_shipping > 0) {
    $temp = &display_price($sc_verify_shipping);
    &add_text_of_both('SHIPPING',$temp);
    $orderLoggingHash{'shippingTotal'} = &format_price($sc_verify_shipping);
}
 
if ($sc_verify_discount) {
   &add_text_of_both('DISCOUNT',&format_price($sc_verify_discount));
   $orderLoggingHash{'discounts'} = &format_price($sc_verify_discount);
   &add_text_of_both('DISCOUNT CODE:',$eform_Ecom_Discount);
   $orderLoggingHash{'discountCode'} = "$eform_Ecom_Discount";
}
 
if ($sc_verify_tax > 0) {
    my $temp = substr(substr("SALES TAX",0,13).":               ",0,15);
    $text_of_cart .= "$temp$sc_verify_tax\n";
    $text_of_confirm_email .= "$temp$sc_verify_tax\n";
    $orderLoggingHash{'salesTax'} = &format_price($sc_verify_tax);
}
if ($sc_verify_etax1) {
 &add_text_of_both($sc_extra_tax1_name,$sc_verify_etax1);
 $orderLoggingHash{'tax1'} = &format_price($sc_verify_etax1);
}
if ($sc_verify_etax2) {
 &add_text_of_both($sc_extra_tax2_name,$sc_verify_etax2);
 $orderLoggingHash{'tax2'} = &format_price($sc_verify_etax2);
}
if ($sc_verify_etax3) {
 &add_text_of_both($sc_extra_tax3_name,$sc_verify_etax3);
 $orderLoggingHash{'tax3'} = &format_price($sc_verify_etax3);
}
 
$temp = &display_price($sc_verify_grand_total);

&add_text_of_both("TOTAL",$temp);
$orderLoggingHash{'orderTotal'} = &format_price($sc_verify_grand_total);

&add_text_of_cart("Email",$vform_Ecom_BillTo_Online_Email);
$orderLoggingHash{'emailAddress'} = "$vform_Ecom_BillTo_Online_Email";

$text_of_cart .= "\nSHIPPING INFORMATION --------------\n\n";

$shipToName = $vform_Ecom_ShipTo_Postal_Name_First . ' ' . $vform_Ecom_ShipTo_Postal_Name_Last;
&add_text_of_both('NAME',$shipToName);
$orderLoggingHash{'shipToName'} = "$shipToName";
$orderLoggingHash{'fullName'} = "$shipToName";
$orderLoggingHash{'firstName'} = "$vform_Ecom_ShipTo_Postal_Name_First";
$orderLoggingHash{'lastName'} = "$vform_Ecom_ShipTo_Postal_Name_Last";

&add_text_of_both('ADDRESS',$vform_Ecom_ShipTo_Postal_Street_Line1);
$orderLoggingHash{'shipToAddress'} = "$vform_Ecom_ShipTo_Postal_Street_Line1";
$orderLoggingHash{'orderFromAddress'} = "$vform_Ecom_ShipTo_Postal_Street_Line1";

&add_text_of_both('CITY',$vform_Ecom_ShipTo_Postal_City);
$orderLoggingHash{'shipToCity'} = "$vform_Ecom_ShipTo_Postal_City";
$orderLoggingHash{'orderFromCity'} = "$vform_Ecom_ShipTo_Postal_City";

&add_text_of_both('STATE',$vform_Ecom_ShipTo_Postal_StateProv);
$orderLoggingHash{'shipToState'} = "$vform_Ecom_ShipTo_Postal_StateProv";
$orderLoggingHash{'orderFromState'} = "$vform_Ecom_ShipTo_Postal_StateProv";

&add_text_of_both('ZIP',$vform_Ecom_ShipTo_Postal_PostalCode);
$orderLoggingHash{'shipToPostal'} = "$vform_Ecom_ShipTo_Postal_PostalCode";
$orderLoggingHash{'orderFromPostal'} = "$vform_Ecom_ShipTo_Postal_PostalCode";

&add_text_of_both('COUNTRY',$vform_Ecom_ShipTo_Postal_CountryCode);
$orderLoggingHash{'shipToCountry'} = "$vform_Ecom_ShipTo_Postal_CountryCode";
$orderLoggingHash{'orderFromCountry'} = "$vform_Ecom_ShipTo_Postal_CountryCode";

$orderLoggingHash{'shipMethod'} = "$vform_Ecom_ShipTo_Method";
if (($sc_use_SBW =~ /yes/i) || ($form_data{'x_Freight'} > .009)) {
  &add_text_of_both("SHIP VIA",$vform_Ecom_ShipTo_Method);
}

if ($ship_instructions ne "") {
  $text_of_cart .= "\nShipping Instructions: \n$ship_instructions\n";
 }

# NEW CODEHOOK
&codehook("process-order-pre-xcomments");

$text_of_cart .= $XCOMMENTS_ADMIN;
$orderLoggingHash{'xcomments'} = "$XCOMMENTS";
$orderLoggingHash{'xcomments'} =~ s/\n/<br>/g;
$orderLoggingHash{'adminMessages'} =~ s/\t/ /g;
$text_of_confirm_email .= $XCOMMENTS;
$orderLoggingHash{'adminMessages'} .= "$XCOMMENTS_ADMIN";
$orderLoggingHash{'adminMessages'} =~ s/\n/<br>/g;
$orderLoggingHash{'adminMessages'} =~ s/\t/ /g;

$text_of_cart = "Go to PayPal.com to obtain Order information\n\n" .
                $text_of_cart;

if ($sc_use_pgp =~ /yes/i)
{
&require_supporting_libraries(__FILE__, __LINE__, "$sc_pgp_lib_path");
$text_of_cart = &make_pgp_file($text_of_cart, "$sc_pgp_temp_file_path/$$.pgp");
$text_of_cart = "\n" . $text_of_cart . "\n";
}

# NEW CODEHOOK
&codehook("process-order-pre-logOrder");

&log_order($text_of_cart,$sc_verify_inv_no,$cart_id);

# This empties the cart after the order is "successful"
&empty_cart;

# added by Mister Ed for Pro version Feb 7, 2007
my $temp_admin_email = "$sc_admin_email";
if ($sc_use_customer_email_over_admin =~ /yes/i) {
   $temp_admin_email = "$vform_Ecom_BillTo_Online_Email";
}

if (($sc_send_order_to_email =~ /yes/i) && 
    ($sc_verify_inv_no ne "")){
  $my_order_name = &my_paypal_order_name . &my_paypal_order_number;
  &send_mail($temp_admin_email, $sc_order_email, $my_order_name, $text_of_cart);
}

$zemail = $vform_Ecom_BillTo_Online_Email;
if (($cartData) && ($zemail ne "")) {
  &send_mail($sc_admin_email, $zemail, $messages{'ordcnf_08'}, 
           "$text_of_confirm_email");
 }

if ($sc_buySafe_is_enabled =~ /yes/) {
    undef(%agora); 
    undef(%agora_original_values);
    undef(%form_data);
    &set_agora("BUYSAFE_ORDER_COMPLETED",'yes');
}

############  End of Standard Processing Code - Select until this line for copy functions ############
}
else { # uses alternate processing file in add_ons sub directory

 &codehook("PayPal_custom_processing_function");

} # end of alternate processing

}
#################################################################

1; # Library
