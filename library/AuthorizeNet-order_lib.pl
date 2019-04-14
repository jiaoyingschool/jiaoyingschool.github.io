#######################################################################
#                    Order Form Definition Variables                  #
#######################################################################

$versions{'AuthorizeNet-order_lib.pl'} = "5.5.004";

$sc_use_secure_header_at_checkout = 'yes';
$sc_use_secure_footer_for_order_form = 'yes';

# Copyright 2000-2001 Steve Kneizys.
# Copyright 2002 to Present K-Factor Technologies, Inc.  All Rights Reserved.
# 4/24/00 SPK ADDED THESE TAGS:
#<INPUT TYPE=HIDDEN NAME=x_adc_url VALUE=\"$sc_store_url\">
#<INPUT TYPE=HIDDEN NAME=x_adc_relay_response VALUE=\"true\">
# March 6, 2003 SIM integration version
# discount mods applied June 17, 2005 by Eric Welin at K-Factor Technologies, Inc.
# April 2006 conversion to version 5 by Justin Findlay at K-Factor Technologies, Inc.
# May 3, 2006 Adjustments and misc edits for final v5 version by Mister Ed at K-Factor Technologies, Inc.
# May 5, 2006 final edits for final v5 version by Mister Ed at K-Factor Technologies, Inc.


&add_codehook("printSubmitPage","print_AuthorizeNet_SubmitPage");
&add_codehook("set_form_required_fields","AuthorizeNet_fields");
$sc_order_response_vars{"AuthorizeNet"}="x_response_code";
&add_codehook("gateway_response","check_for_AuthorizeNet_response");
###############################################################################
sub AuthorizeNet_check_and_load {
local($myname)="AuthorizeNet";
if ($myname ne $sc_gateway_name) { # we are a secondary gateway, load settings
  &require_supporting_libraries(__FILE__,__LINE__,
     "./admin_files/$myname-user_lib.pl");
 }

}
###############################################################################
sub check_for_AuthorizeNet_response {
  if ($form_data{'x_response_code'}) {
    $cart_id = $form_data{'x_cust_id'};
    &set_sc_cart_path;
    &load_order_lib;
    &codehook("AuthorizeNet_order");
    &process_AuthorizeNet_Order;
    &call_exit;
   }
 }
###############################################################################
sub AuthorizeNet_order_form_prep { # load the customer info ...
  &AuthorizeNet_check_and_load;
  if ($sc_AuthorizeNet_form_prep == 0) {
    if (-f "$sc_verify_order_path"){
      &read_verify_file;  
     } else {
      &codehook("load_customer_info");
     }
    $sc_AuthorizeNet_form_prep = 1;
   }
  return "";
 }
###############################################################################
sub AuthorizeNet_fields {
local($myname)="AuthorizeNet";

if (!($form_data{'gateway'} eq $myname)) { return;} 

%sc_order_form_array =(
	'Ecom_BillTo_Postal_Name_First', 'First Name',
	'Ecom_BillTo_Postal_Name_Last', 'Last Name',
	'Ecom_BillTo_Postal_Street_Line1', 'Billing Address Street',
	'Ecom_BillTo_Postal_City', 'Billing Address City',
	'Ecom_BillTo_Postal_StateProv', 'Billing Address State',
	'Ecom_BillTo_Postal_PostalCode', 'Billing Address Zip',
	'Ecom_BillTo_Postal_CountryCode', 'Billing Address Country',
	'Ecom_ShipTo_Postal_Street_Line1', 'Shipping Address Street',
	'Ecom_ShipTo_Postal_City', 'Shipping Address City',
	'Ecom_ShipTo_Postal_StateProv', 'Shipping Address State',
	'Ecom_ShipTo_Postal_PostalCode', 'Shipping Address Zip',
	'Ecom_ShipTo_Postal_CountryCode', 'Shipping Address Country',
	'Ecom_BillTo_Telecom_Phone_Number', 'Phone Number',
	'Ecom_BillTo_Online_Email', 'Email',
	'Ecom_Payment_Card_Type', 'Type of Card',
	'Ecom_Payment_Card_Number', 'Card Number',
	'Ecom_Payment_Card_ExpDate_Month', 'Card Expiration Month',
	'Ecom_Payment_Card_ExpDate_Day', 'Card Expiration Day',
	'Ecom_Payment_Card_ExpDate_Year', 'Card Expiration Year',
	'Ecom_is_Residential', 'Shipping to Residential Address',
	'Ecom_ShipTo_Insurance', 'Insure this Shipment', # not implemented yet, for the future
	'Ecom_tos', 'Sales-Terms of Service');
                        

@sc_order_form_required_fields = (
  "Ecom_ShipTo_Postal_StateProv",
  "Ecom_ShipTo_Postal_PostalCode");

# lines for tos added 2006 April 13 jfindlay
 if ($sc_display_checkout_tos =~ /yes/i) {
    push(@sc_order_form_required_fields,"Ecom_tos");
 }

# use this codehook to change the above arrays for required fields and such
&codehook("AuthorizeNet_fields_bottom");

}
###############################################################################
sub AuthorizeNet_verification_table {
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
<th colspan="2" class="ac_checkout_review">Shipping Information</th>
</tr>

ENDOFTEXT

if ($form_data{'Ecom_ShipTo_Method'} ne ""){
$rslt .= <<ENDOFTEXT;
<tr>
<td class="ac_checkout_review_col1">Ship via</td>
<td class="ac_checkout_review_col2">$form_data{'Ecom_ShipTo_Method'}&nbsp;</td>
</tr>
ENDOFTEXT
}

$rslt .= <<ENDOFTEXT;

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
&codehook("AuthorizeNet_verification_table_bottom");

  return $rslt;
 }
###############################################################################
sub anet_table_setup{
#
# To use this, put this in the x_header_html in the manager:
#
# <!--agorascript-pre
#   return $anet_cart_table;
# -->
#
# and in the email footer you can use:
#
# <!--agorascript-pre
#   return $anet_prod_in_cart;
# -->
# 

local (@my_cart_fields,$my_cart_row_number,$result);
local ($count,$price,$product_id,$quantity,$total_cost,$total_qty)=0;
local ($name,$cost);

 $anet_prod_in_cart = '';
 $anet_cart_table = '';
 $result='';
 open (CART, "$sc_cart_path") || &file_open_error("$sc_cart_path", 
            "display_cart_contents_in_header", __FILE__, __LINE__);
 while (<CART>)
  {
   $count++;
   chop;    
   @my_cart_fields = split (/\|/, $_);
   $my_cart_row_number = pop(@my_cart_fields);
   push (@my_cart_fields, $my_cart_row_number);
   $quantity = $my_cart_fields[0];
   $product_id = $my_cart_fields[1];
   $price = $my_cart_fields[$sc_cart_index_of_price_after_options]; 
   $name = $my_cart_fields[$cart{"name"}];
   $name = substr($name,0,35);
   $cost = &format_price($quantity * $price);
   $total_cost = $total_cost + $quantity * $price;
   $total_qty = $total_qty + $quantity;
   $options = $my_cart_fields[$cart{"options"}];
   $options =~ s/<br>/ /g;
   if ($result eq '') {
     $result .= '<TABLE CELLPADDING=0 CELLSPACING=0 BORDER=0 WIDTH=425>';
     $result .= "<TR><TD>Items Ordered:</TD></TR><TR><TD>\n";
     $result .= "<TABLE CELLPADDING=3 CELLSPACING=0 BORDER=1 WIDTH='100%'>\n";
     $result .= "<TR><TH>QTY</TH><TH>ID #</TH><TH>Description</TH>";
     $result .= "<TH>Cost</TH></TR>\n";
     $anet_prod_in_cart .= "  --PRODUCT INFORMATION--\n\n";
    }
   $result .= "<TR><TD>$quantity</TD><TD>$product_id</TD>\n";
   $result .= "<TD>$name</TD><TD>$cost</TD>";
   $result .= "</TR>\n";
   $anet_prod_in_cart .= &cart_textinfo(*my_cart_fields);
  } # End of while (<CART>)
 close (CART);
 if ($result ne '') {
   $result .= "</TABLE></TD></TR></TABLE>\n";
  }

# use this to change $result
&codehook("anet_table_setup_bottom");

 $anet_cart_table = $result;
}

###############################################################################
sub print_AuthorizeNet_SubmitPage

{
local($invoice_number, $customer_number);
local($test_mode,$authnet_sale_mode,$mytable);
local($myname)="AuthorizeNet";

if (!($form_data{'gateway'} eq $myname)) { return;} 
if ($myname ne $sc_gateway_name) { # secondary gateway, load settings
  &require_supporting_libraries(__FILE__,__LINE__,
     "./admin_files/$myname-user_lib.pl");
 }

&codehook("AuthorizeNet-SubmitPage-top");

$mytable = &AuthorizeNet_verification_table;

if ($merchant_live_mode =~ /yes/i){
  $test_mode = "";
 } else {
  $test_mode = qq~<input type="hidden" name="x_test_request" value="TRUE">~;
 }

if ($sc_authnet_sale_mode =~ /authorize/i){
  $authnet_sale_mode = qq~<input type="hidden" name="x_type" value="AUTH_ONLY">~;
 } else {
  $authnet_sale_mode = "";
 }

$tstamp = time;
if ($sc_tstamp3 =~ /add/i){
  $tstamp = $tstamp + $sc_tstamp2;
 }
if ($sc_tstamp3 =~ /subtract/i){
  $tstamp = $tstamp - $sc_tstamp2;
 }
$sequence = int(rand 1000);
require "./library/MD5.pl" || die "Can't require ./library/MD5.pl";
$fp = &hmac_hex
($sc_gateway_username ."^".$sequence."^".$tstamp."^".$authPrice."^",$txnkey);

$invoice_number = $current_verify_inv_no;
#$customer_number = $form_data{'cart_id'};
$customer_number = $cart_id;
$customer_number =~ s/_/./g;

&anet_table_setup;
$xx_Header_Html_Payment_Form =
  &script_and_substitute($x_header_html_payment_form,"Anet");
$xx_Footer_Html_Payment_Form =
  &script_and_substitute($x_footer_html_payment_form,"Anet");
$xx_Header_Html_Receipt =
  &script_and_substitute($x_header_html_receipt,"Anet");
$xx_Footer_Html_Receipt =
  &script_and_substitute($x_footer_html_receipt,"Anet");
$xx_Header_Email_Receipt =
  &script_and_substitute($x_header_email_receipt,"Anet");
$xx_Footer_Email_Receipt =
  &script_and_substitute($x_footer_email_receipt,"Anet");

&codehook("AuthorizeNet-SubmitPage-print");

if ($sc_use_alternate_NiftyPay_submit_page ne "Yes") {
############  Start of Standard submit page - Select from this line to for copy functions ############
#### can use in custom submit page.  Custom file must be named: NiftyPay_custom_processing_lib.pl
#### Custom function (aka sub routine) to replace the code below must be named: NiftyPay_custom_submit_page

print <<ENDOFTEXT;
<div align="center">
<table width="500" cellpadding="5" cellspacing="0" border="0">
<tr>
<td align="center">

<form method="post" action="$sc_order_script_url">

<input type="hidden" name="x_amount" value="$authPrice">
<input type="hidden" name="x_freight" value="$zfinal_shipping">
<input type="hidden" name="ud_Discount" value="$zfinal_discount">
<input type="hidden" name="x_tax" value="$zfinal_sales_tax">

<input type="hidden" name="x_login" value="$sc_gateway_username">
<input type="hidden" name="x_invoice_num" value="$invoice_number">
<input type="hidden" name="x_description" value="$x_description">
<input type="hidden" name="x_cust_id" value="$customer_number">
<input type="hidden" name="x_show_form" value="PAYMENT_FORM">
$authnet_sale_mode

<input type="hidden" name="x_receipt_link_method" value="POST">
<input type="hidden" name="x_receipt_link_text" value="YOU MUST CLICK HERE TO FINALIZE YOUR ORDER!">
<input type="hidden" name="x_receipt_link_url" value="$sc_ssl_location_url2">
$test_mode
<input type="hidden" name="x_adc_url" value="$sc_ssl_location_url2">
<input type="hidden" name="x_adc_relay_response" value="true">
<input type="hidden" name="x_version" value="3.1">

<input type="hidden" name="x_logo_url" value="$x_logo_url">
<input type="hidden" name="x_color_background" value="$x_color_background">
<input type="hidden" name="x_color_link" value="$x_color_link">
<input type="hidden" name="x_color_text" value="$x_color_text">
<input type="hidden" name="x_header_html_payment_form" value="$xx_Header_Html_Payment_Form">
<input type="hidden" name="x_footer_html_payment_form" value="$xx_Footer_Html_Payment_Form">
<input type="hidden" name="x_header_html_receipt" value="$xx_Header_Html_Receipt">
<input type="hidden" name="x_footer_html_receipt" value="$xx_Footer_Html_Receipt">
<input type="hidden" name="x_header_email_receipt" value="$xx_Header_Email_Receipt">
<input type="hidden" name="x_footer_email_receipt" value="$xx_Footer_Email_Receipt">
<input type="hidden" name="Ecom_ShipTo_Method" value="$form_data{'Ecom_ShipTo_Method'}">
<input type="hidden" name="x_Ship_To_State" value="$form_data{'Ecom_ShipTo_Postal_StateProv'}">
<input type="hidden" name="x_Ship_To_Zip" value="$form_data{'Ecom_ShipTo_Postal_PostalCode'}">
<input type="hidden" name="x_Ship_To_Country" value="$form_data{'Ecom_ShipTo_Postal_CountryCode'}">
<input type="hidden" name="x_fp_sequence" value="$sequence">
<input type="hidden" name="x_fp_timestamp" value="$tstamp">
<input type="hidden" name="x_fp_hash" value="$fp">


$mytable
<p class="ac_checkout_top_msg">$sc_auth_verify_message</p>

<br>
<input type="submit" value="Secure Orderform">

</form>
</td>
</tr>
</table>
</div>
ENDOFTEXT

############  End of Submit Page Code - Select until this line for copy functions ############
}
else { # uses alternate processing file in add_ons sub directory

&codehook("AuthorizeNet_custom_submit_page");

} # end of alternate submit page

}
############################################################################################

sub process_AuthorizeNet_Order {
local($subtotal, $total_quantity,
      $total_measured_quantity,
      $text_of_cart, $weight,
      $required_fields_filled_in, $product, $quantity, $options);
local($stevo_shipping_thing) = "";
local($stevo_shipping_names) = "";
local($mytext) = "";
local($ship_thing_too,$ship_instructions);
local(%orderLoggingHash);

#alt origination stuff added by Mister Ed Feb 17, 2005
if ($sc_alt_origin_enabled =~ /yes/i) {
  local(%zip_list);
  local(%zip_names_list);
}

# Now let's check the _VERIFY file, just to be sure ...
# Added 2006 April 10 by jfindlay
if (!(-f "$sc_verify_order_path")){
&SecureStoreHeader;
print <<ENDOFTEXT;
<CENTER>
<TABLE WIDTH=500>
<TR>
<TD WIDTH=500>
<FONT FACE=ARIAL>
$messages{'ordcnf_03'}
$messages{'ordcnf_02'}
</FONT>
</TD>
</TR>
</TABLE>
<CENTER>
 
ENDOFTEXT
 
# and the footer is printed
 
&SecureStoreFooter;
 
print qq!
</BODY>
</HTML>
!;
 
&file_open_error("$sc_verify_order_path", 
	"Authorize.net Check for Verify file", __FILE__, __LINE__);
exit;
 
 }

#
# Need to process this info someday ...
# &load_verify_file;
#
# Now verify the order total and the shipping cost
#if ((!($sc_verify_shipping == $form_data{'x_freight'})) ||
#    (!($sc_verify_grand_total == $form_data{'x_amount'}))) {
#  $mytext =  "This order failed automatic verification, and has been \n";
#  $mytext .= "marked for manual verification.  The reason is:\n";
#if (!($sc_verify_shipping == $form_data{'x_freight'})) {
#    $mytext .= "Shipping amount: $form_data{'x_freight'}  ".
#               " (expected $sc_verify_shipping).\n";
#  }
#if (!($sc_verify_grand_total == $form_data{'x_amount'})) {
#    $mytext .= "Order Total: $form_data{'x_amount'}  ".
#               " (expected $sc_verify_grand_total).\n";
#  }
# }

                # First, we output the header of
                # the processing of the order

$orderDate = &get_date;

# NEW CODEHOOK
&codehook("process-order-routine-top");

print qq!
$sc_special_page_meta_tags
<HTML>
<HEAD>
<TITLE>$messages{'ordcnf_08'}</TITLE>
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
$sc_secure_standard_head_info</HEAD>
<BODY $sc_standard_body_info>
!;

if ($sc_use_alternate_NiftyPay_order_processing ne "Yes") {
############  Start of Standard Processing Code - Select from this line to for copy functions ############
#### can use in custom processing file.  Custom file must be named: NiftyPay_custom_processing_lib.pl
#### Place NiftyPay_custom_processing_lib.pl in the library directory of your store
#### Custom function (aka sub routine)  to replace the code below must be named: NiftyPay_custom_processing_function

&SecureStoreHeader; # Don't Use standard header

if ($form_data{'x_response_code'} > 1) { # there is a problem ...
  if ($form_data{'x_response_code'} == 2) { # declined ... dump cart ??
    &empty_cart;
   }
print <<ENDOFTEXT;
<CENTER>
<TABLE WIDTH=500>
<TR>
<TD WIDTH=500>
<FONT FACE=ARIAL>
<P>&nbsp;</P>
$messages{'ordcnf_05'}<br>
$form_data{'x_response_reason_code'} <br>
$form_data{'x_response_reason_text'} <br>
<P>&nbsp;</P>
$messages{'ordcnf_02'}<br>
</FONT>
</TD>
</TR>
</TABLE>
<CENTER>  
ENDOFTEXT
&SecureStoreFooter;
print qq!
</BODY>
</HTML>
!;
&call_exit;
 }

# All went well at AuthorizeNet, proceed with processing

&load_verify_file;

# initialize hash variables in case they are empty later
# added by jfindlay 2006 April 10

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
$orderLoggingHash{'shiptoResidential'} = $vform_Ecom_is_Residential;
$orderLoggingHash{'insureShipment'} = $vform_Ecom_ShipTo_Insurance; # not implemented yet, for the future

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

print $mytext;

$text_of_cart .= "${mytext}";
$text_of_cart .= "Order Date:    $orderDate\n";
$text_of_cart .= "Gateway:       AuthorizeNet\n\n";
$orderLoggingHash{'GatewayUsed'} = "AuthorizeNet";

$text_of_cart .= "  --PRODUCT INFORMATION--\n\n";

open (CART, "$sc_cart_path") ||
&file_open_error("$sc_cart_path", "display_cart_contents", __FILE__, __LINE__);

while (<CART>)
  {
  $cartData++;
  @cart_fields = split (/\|/, $_);
  $quantity = $cart_fields[0];
  $product_price = $cart_fields[3];
  $product = $cart_fields[4];
  $weight = $cart_fields[6];
  $options = $cart_fields[$cart{"options"}];
  $options =~ s/<br>/ /g;
        $text_of_cart .= &cart_textinfo(*cart_fields);
        $stevo_shipping_thing .="|$quantity\*$weight";
        $stevo_shipping_names .="|$product\($options\)";
        &codehook("process-cart-item");
  }
close(CART);

$sc_orderlib_use_SBW_for_ship_ins = $sc_use_SBW;
&codehook("orderlib-ship-instructions");
if ($sc_orderlib_use_SBW_for_ship_ins =~ /yes/i){
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

  $text_of_cart .= "CUSTID:        $form_data{'x_cust_id'}\n";
  $text_of_confirm_email .= "CUSTID:        $form_data{'x_cust_id'}\n";
  $orderLoggingHash{'customerNumber'} = "$form_data{'x_cust_id'}";

  $text_of_cart .= "INVOICE:       $form_data{'x_invoice_num'}\n";
  $text_of_confirm_email .= "INVOICE:       $form_data{'x_invoice_num'}\n";
  $orderLoggingHash{'invoiceNumber'} = "$form_data{'x_invoice_num'}";

	# added 2006 April 10 by jfindlay
  $temp = &display_price($sc_verify_subtotal);
  &add_text_of_both("SUBTOTAL",$temp);
  $orderLoggingHash{'subTotal'} = "$sc_verify_subtotal";

if (($sc_buySafe_is_enabled =~ /yes/) && ($sc_verify_buySafe > 0)) {
my $temp = &format_price($sc_verify_buySafe);
$text_of_cart .= "$sc_buySafe_bond_fee_mini_display_text       $temp\n";
$text_of_confirm_email .= "$sc_verify_buySafe_display_text       $temp\n";
$orderLoggingHash{'buySafe'} = "$temp";
}

  if ($form_data{'x_freight'}) {
     $text_of_cart .= "SHIPPING:      $form_data{'x_freight'}\n";
     $text_of_confirm_email .= "SHIPPING:      $form_data{'x_freight'}\n";
     $orderLoggingHash{'shippingTotal'} = &format_price($sc_verify_shipping);
          if (($sc_use_SBW =~ /yes/i) || ($form_data{'x_Freight'} > .009)) {
           $text_of_confirm_email .=  "SHIP VIA:      $vform_Ecom_ShipTo_Method\n";
          }
  }

  if ($form_data{'ud_Discount'}) {
      $text_of_cart .= "DISCOUNT:      $form_data{'ud_Discount'}\n";
      $text_of_confirm_email .= "DISCOUNT:      $form_data{'ud_Discount'}\n";
      $orderLoggingHash{'discounts'} = "$form_data{'ud_Discount'}";
      $text_of_cart .= "DISCOUNT CODE: $eform_Ecom_Discount\n";
      $text_of_confirm_email .= "DISCOUNT CODE: $eform_Ecom_Discount\n";
      $orderLoggingHash{'discountCode'} = "$eform_Ecom_Discount";
  }

  if ($form_data{'x_tax'}) {
      $text_of_cart .=          "TOT SALES TAX: $form_data{'x_tax'}\n";
      $text_of_confirm_email .= "TOT SALES TAX: $form_data{'x_tax'}\n";
	  #$orderLoggingHash{'totalSalesTax'} = $form_data{'x_tax'}; # not used
  }

if ($sc_verify_tax > 0) {
    $temp = substr(substr("SALES TAX",0,13).":               ",0,15);
    $text_of_cart .= "$temp$sc_verify_tax\n";
    $text_of_confirm_email .= "$temp$sc_verify_tax\n";
    $orderLoggingHash{'salesTax'} = "$sc_verify_tax";
}
if ($sc_verify_etax1 > 0)
{
$temp = substr(substr($sc_extra_tax1_name,0,13).":               ",0,15);
$text_of_cart .= "$temp$sc_verify_etax1\n";
$text_of_confirm_email .= "$temp$sc_verify_etax1\n";
$orderLoggingHash{'tax1'} = "$sc_verify_etax1";
}
if ($sc_verify_etax2 > 0)
{
$temp = substr(substr($sc_extra_tax2_name,0,13).":               ",0,15);
$text_of_cart .= "$temp$sc_verify_etax2\n";
$text_of_confirm_email .= "$temp$sc_verify_etax2\n";
$orderLoggingHash{'tax2'} = "$sc_verify_etax2";
}
if ($sc_verify_etax3 > 0)
{
$temp = substr(substr($sc_extra_tax3_name,0,13).":               ",0,15);
$text_of_cart .= "$temp$sc_verify_etax3\n";
$text_of_confirm_email .= "$temp$sc_verify_etax3\n";
$orderLoggingHash{'tax3'} = "$sc_verify_etax3";
}

  $text_of_cart .= "TOTAL:         $form_data{'x_amount'}\n";
  $text_of_confirm_email .= "TOTAL:         $form_data{'x_amount'}\n";
  $orderLoggingHash{'orderTotal'} = "$form_data{'x_amount'}";

  $text_of_cart .= "METHOD:        $form_data{'x_method'}\n";
  $text_of_cart .= "TYPE:          $form_data{'x_type'}\n";
  $text_of_cart .= "DESCRIPTION:   $form_data{'x_description'}\n\n";
  
  $text_of_cart .= "RESP CODE:     $form_data{'x_response_code'}\n";
  $text_of_cart .= "RESP SUBCODE:  $form_data{'x_response_subcode'}\n";
  $text_of_cart .= "REASON CODE:   $form_data{'x_response_reason_code'}\n";
  $text_of_cart .= "REASON TEXT:   $form_data{'x_response_reason_text'}\n";
  $text_of_cart .= "AUTH CODE:     $form_data{'x_auth_code'}\n";
  $text_of_cart .= "AVS CODE:      $form_data{'x_avs_code'}\n";
  $text_of_cart .= "TRANS ID:      $form_data{'x_trans_id'}\n\n";
	$orderLoggingHash{'adminMessages'} .= "<br>AUTHORIZATION INFORMATION --------------<br>RESP CODE: $form_data{'x_response_code'}<br>RESP SUBCODE: $form_data{'x_response_subcode'}<br>REASON CODE: $form_data{'x_response_reason_code'}<br>REASON TEXT: $form_data{'x_response_reason_text'}<br>AUTH CODE: $form_data{'x_auth_code'}<br>AVS CODE: $form_data{'x_avs_code'}<br>TRANS ID: $form_data{'x_trans_id'}<br>---------------------------------------------------------------<br>";
  
  $text_of_cart .= "BILLING INFORMATION --------------\n\n";

  $text_of_cart .= "NAME:          $form_data{'x_first_name'} $form_data{'x_last_name'}\n";
  $orderLoggingHash{'fullName'} = "$form_data{'x_first_name'} $form_data{'x_last_name'}";
  $orderLoggingHash{'firstName'} = "$form_data{'x_first_name'}";
  $orderLoggingHash{'lastName'} = "$form_data{'x_last_name'}";
  $orderLoggingHash{'companyName'} = "$form_data{'x_company'}";

  $text_of_cart .= "COMPANY:       $form_data{'x_company'}\n";
  $orderLoggingHash{'companyName'} = "$form_data{'x_company'}";

  $text_of_cart .= "ADDRESS:       $form_data{'x_address'}\n";
  $orderLoggingHash{'orderFromAddress'} = "$form_data{'x_address'}";

  $text_of_cart .= "CITY:          $form_data{'x_city'}\n";
  $orderLoggingHash{'orderFromCity'} = "$form_data{'x_city'}";

  $text_of_cart .= "STATE:         $form_data{'x_state'}\n";
  $orderLoggingHash{'orderFromState'} = "$form_data{'x_state'}";

  $text_of_cart .= "ZIP:           $form_data{'x_zip'}\n";
  $orderLoggingHash{'orderFromPostal'} = "$form_data{'x_zip'}";

  $text_of_cart .= "COUNTRY:       $form_data{'x_country'}\n";
  $orderLoggingHash{'orderFromCountry'} = "$form_data{'x_country'}";

  $text_of_cart .= "PHONE:         $form_data{'x_phone'}\n";
  $orderLoggingHash{'customerPhone'} = "$form_data{'x_phone'}";

  $text_of_cart .= "FAX:           $form_data{'x_fax'}\n";
  $orderLoggingHash{'faxNumber'} = "$form_data{'x_fax'}";

  $text_of_cart .= "EMAIL:         $form_data{'x_email'}\n\n";
  $orderLoggingHash{'emailAddress'} = "$form_data{'x_email'}";

  $text_of_cart .= "SHIPPING INFORMATION --------------\n\n";

  $text_of_cart .= "SHIP VIA:      $form_data{'Ecom_ShipTo_Method'}\n";
  $orderLoggingHash{'shipToName'} = "$form_data{'Ecom_ShipTo_Method'}";


if ($form_data{'x_ship_to_first_name'}) {
  $text_of_cart .= "NAME:          $form_data{'x_ship_to_first_name'} $form_data{'x_ship_to_last_name'}\n";
  $orderLoggingHash{'shipToName'} = "$form_data{'x_ship_to_first_name'} $form_data{'x_ship_to_last_name'}";
} else {
  $text_of_cart .= "NAME:          $form_data{'x_first_name'} $form_data{'x_last_name'}\n";
  $orderLoggingHash{'shipToName'} = "$form_data{'x_first_name'} $form_data{'x_last_name'}";
}

if ($form_data{'x_ship_to_company'}) {
  $text_of_cart .= "COMPANY:       $form_data{'x_ship_to_company'}\n";
	# don't overwrite billto company
	#$orderLoggingHash{'companyName'} = "$form_data{'x_ship_to_company'}"
} else {
  $text_of_cart .= "COMPANY:       $form_data{'x_company'}\n";
}

if ($form_data{'x_ship_to_address'}) {
  $text_of_cart .= "ADDRESS:       $form_data{'x_ship_to_address'}\n";
  $orderLoggingHash{'shipToAddress'} = "$form_data{'x_ship_to_address'}";
} else {
  $text_of_cart .= "ADDRESS:       $form_data{'x_address'}\n";
  $orderLoggingHash{'shipToAddress'} = "$form_data{'x_address'}";
}

if ($form_data{'x_ship_to_city'}) {
  $text_of_cart .= "CITY:          $form_data{'x_ship_to_city'}\n";
  $orderLoggingHash{'shipToCity'} = "$form_data{'x_ship_to_city'}";
} else {
  $text_of_cart .= "CITY:          $form_data{'x_city'}\n";
  $orderLoggingHash{'shipToCity'} = "$form_data{'x_city'}";
}

if ($form_data{'x_ship_to_state'}) {
  $text_of_cart .= "STATE:         $form_data{'x_ship_to_state'}\n";
  $orderLoggingHash{'shipToState'} = "$form_data{'x_ship_to_state'}";
} else {
  $text_of_cart .= "STATE:         $form_data{'x_state'}\n";
  $orderLoggingHash{'shipToState'} = "$form_data{'x_sstate'}";
}

if ($form_data{'x_ship_to_zip'}) {
  $text_of_cart .= "ZIP:           $form_data{'x_ship_to_zip'}\n";
  $orderLoggingHash{'shipToPostal'} = "$form_data{'x_ship_to_zip'}";
} else {
  $text_of_cart .= "ZIP:           $form_data{'x_zip'}\n";
  $orderLoggingHash{'shipToPostal'} = "$form_data{'x_zip'}";
}

if ($form_data{'x_ship_to_country'}) {
  $text_of_cart .= "COUNTRY:       $form_data{'x_ship_to_country'}\n\n";
  $orderLoggingHash{'shipToCountry'} = "$form_data{'x_ship_to_country'}";
} else {
  $text_of_cart .= "COUNTRY:       $form_data{'x_country'}\n\n";
  $orderLoggingHash{'shipToCountry'} = "$form_data{'x_country'}";
}

# NEW CODEHOOK
&codehook("process-order-pre-ship-instructions");
 
  if ($ship_instructions ne "") {
  $text_of_cart .= "Shipping Instructions: \n$ship_instructions\n\n";
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

# 'Init' the emails ...
$text_of_cart = &init_shop_keep_email . $text_of_cart;
$text_of_confirm_email = &init_customer_email . $text_of_confirm_email;

# and add the rest ...
$text_of_admin_email .= &addto_shop_keep_email;
$text_of_confirm_email .= &addto_customer_email;

if ($sc_use_pgp =~ /yes/i) {
   &require_supporting_libraries(__FILE__, __LINE__, "$sc_pgp_lib_path");
   $text_of_cart = &make_pgp_file($text_of_cart, "$sc_pgp_temp_file_path/$$.pgp");
   $text_of_cart = "\n" . $text_of_cart . "\n";
}

# added by Mister Ed for Pro version Feb 7, 2007
my $temp_admin_email = "$sc_admin_email";
if ($sc_use_customer_email_over_admin =~ /yes/i) {
   $temp_admin_email = "$form_data{'x_email'}";
}

if ($sc_send_order_to_email =~ /yes/i) {
   &send_mail($temp_admin_email, $sc_order_email, "$x_description - $form_data{'x_invoice_num'}", $text_of_cart);
}

&log_order($text_of_cart,$form_data{'x_invoice_num'},$form_data{'x_cust_id'});

if (($cartData) && ($form_data{'x_email'} ne "")) {
   &send_mail($sc_admin_email, $form_data{'x_email'}, $messages{'ordcnf_08'}, "$text_of_confirm_email");
}
  
$sc_affiliate_order_unique = $form_data{'x_invoice_num'};
$sc_affiliate_order_total = $form_data{'x_amount'};

$sc_affiliate_image_call =~ s/AMOUNT/$sc_affiliate_order_total/g;
$sc_affiliate_image_call =~ s/UNIQUE/$sc_affiliate_order_unique/g;

# NEW CODEHOOK
&codehook("process-order-display-thankyou-page");
  
print <<ENDOFTEXT;
<CENTER>
<TABLE WIDTH=500>
<TR>
<TD WIDTH=500>
<FONT FACE=ARIAL>
$messages{'ordcnf_01'}
$messages{'ordcnf_02'}
<br>
$sc_affiliate_image_call
</FONT>
</TD>
</TR>
</TABLE>
<CENTER>  

ENDOFTEXT

# This empties the cart after the order is successful
&empty_cart;
undef(%form_data);

# and the footer is printed

&SecureStoreFooter;

print qq!
</BODY>
</HTML>
!;

############  End of Standard Processing Code - Select until this line for copy functions ############
}
else { # uses alternate processing file in add_ons sub directory

 &codehook("AuthorizeNet_custom_processing_function");

} # end of alternate processing

} # End of process_order_form

#################################################################

1; # Library
