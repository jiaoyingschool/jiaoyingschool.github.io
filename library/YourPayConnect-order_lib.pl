##############################################################################
#                       Order Form Definition Variables                      #
##############################################################################
$versions{'YourPayConnect-order_lib.pl'} = "5.5.000";
$sc_use_secure_header_at_checkout = 'yes';
$sc_use_secure_footer_for_order_form = 'yes';
$sc_YourPayConnect_form_prep = 0;
&add_codehook("printSubmitPage","print_YourPayConnect_SubmitPage");
&add_codehook("set_form_required_fields","YourPayConnect_fields");
$sc_order_response_vars{"YourPayConnect"}="oid";
&add_codehook("gateway_response","check_for_YourPayConnect_response");
###############################################################################
sub YourPayConnect_check_and_load {
local($myname)="YourPayConnect";
if ($myname ne $sc_gateway_name) { # we are a secondary gateway, load settings
  &require_supporting_libraries(__FILE__,__LINE__,
     "./admin_files/$myname-user_lib.pl");
 }

}
###############################################################################
sub check_for_YourPayConnect_response {
  if ($form_data{'oid'}) {
    ($cart_id,$yp_inv) = split(/\|/,$form_data{'oid'},2);
    &set_sc_cart_path;
    &load_order_lib;
    &codehook("YourPayConnect_order");
    &process_YourPayConnect_order;
    &call_exit;
   }
 }
###############################################################################
sub YourPayConnect_order_form_prep { # load the customer info ...
  &YourPayConnect_check_and_load;
  if ($sc_YourPayConnect_form_prep == 0) {
    if (-f "$sc_verify_order_path"){
      &read_verify_file;  
     } else {
      &codehook("load_customer_info");
     }
    $sc_YourPayConnect_form_prep = 1;
   }
  return "";
 }

###############################################################################
sub YourPayConnect_fields{
local($myname)="YourPayConnect";

if (!($form_data{'gateway'} eq $myname)) { return;} 

%sc_order_form_array =(
	'Ecom_ShipTo_Postal_Name', 'Billing/Shipping Name',
	'Ecom_BillTo_Postal_Name_First', 'First Name',
	'Ecom_BillTo_Postal_Name_Last', 'Last Name',
	'Ecom_BillTo_Postal_Street_Line1', 'Billing Address Street',
	'Ecom_BillTo_Postal_City', 'Billing Address City',
	'Ecom_BillTo_Postal_StateProv', 'Billing Address State',
	'Ecom_BillTo_PostalCode', 'Billing Address Zip',
	'Ecom_BillTo_Postal_CountryCode', 'Billing Address Country',
  'Ecom_ShipTo_Method', 'Shipping Method',
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
  'Ecom_BillTo_Online_Email',
  'Ecom_ShipTo_Method',
  'Ecom_ShipTo_Postal_Name',
  'Ecom_ShipTo_Postal_Street_Line1', 
  'Ecom_ShipTo_Postal_City', 
  'Ecom_ShipTo_Postal_StateProv',
  'Ecom_ShipTo_Postal_PostalCode');

 if ($sc_display_checkout_tos =~ /yes/i) {
    push(@sc_order_form_required_fields,"Ecom_tos");
 }

# use this codehook to chage the above arrays for required fields and such
&codehook("YourPayConnect_fields_bottom");

}

###############################################################################
sub YourPayConnect_verification_table {
  local ($rslt)="";
  $rslt = "<table border=0 width=100%>\n<tr>\n";
  $rslt.= "<td width=\"50%\" align=right>Shipping Method:</td>\n";
  $rslt.= '<td width = "50%" align=left>' .
	$form_data{'Ecom_ShipTo_Method'} . "&nbsp;</td>\n";
  $rslt.= "</tr>\n";
  $rslt.= "<td width=\"50%\" align=right>Email:</td>\n";
  $rslt.= '<td width = "50%" align=left>' .
	$form_data{'Ecom_BillTo_Online_Email'} . "&nbsp;</td>\n";
  $rslt.= "</tr>\n";
  $rslt.= "<td width=\"50%\" align=right>Name:</td>\n";
  $rslt.= '<td width = "50%" align=left>' .
	$form_data{'Ecom_ShipTo_Postal_Name'} . "&nbsp;</td>\n";
  $rslt.= "</tr>\n";
  $rslt.= "<tr>\n";
  $rslt.= "<td width=\"50%\" align=right>Street:</td>\n";
  $rslt.= '<td width = "50%" align=left>' .
	$form_data{'Ecom_ShipTo_Postal_Street_Line1'} . "&nbsp;</td>\n";
  $rslt.= "</tr>\n";
  $rslt.= "<tr>\n";
  $rslt.= "<td width=\"50%\" align=right>City:</td>\n";
  $rslt.= '<td width = "50%" align=left>' .
	$form_data{'Ecom_ShipTo_Postal_City'} . "&nbsp;</td>\n";
  $rslt.= "</tr>\n";
  $rslt.= "<tr>\n";
  $rslt.= "<td width=\"50%\" align=right>State:</td>\n";
  $rslt.= '<td width = "50%" align=left>' .
	$form_data{'Ecom_ShipTo_Postal_StateProv'} . "&nbsp;</td>\n";
  $rslt.= "</tr>\n";
  $rslt.= "<tr>\n";
  $rslt.= "<td width=\"50%\" align=right>Zip:</td>\n";
  $rslt.= '<td width = "50%" align=left>' .
	$form_data{'Ecom_ShipTo_Postal_PostalCode'} . "&nbsp;</td>\n";
  $rslt.= "</tr>\n";
  $rslt.= "<tr>\n";
  $rslt.= "<td width=\"50%\" align=right>Country:</td>\n";
  $rslt.= '<td width = "50%" align=left>' .
	$form_data{'Ecom_ShipTo_Postal_CountryCode'} . "&nbsp;</td>\n";
  $rslt.= "</tr>\n";
  $rslt.= "</table>\n";

# use this to change $rslt
&codehook("YourPayConnect_verification_table_bottom");
  return $rslt;
 }
###############################################################################

sub print_YourPayConnect_SubmitPage

{
local($invoice_number, $customer_number);
local($myname)="YourPayConnect";
local($my_change,$my_submit,$my_message,$my_desc);

if (!($form_data{'gateway'} eq $myname)) { return;} 
if ($myname ne $sc_gateway_name) { # secondary gateway, load settings
  &require_supporting_libraries(__FILE__,__LINE__,
	"./admin_files/$myname-user_lib.pl");
 }

$invoice_number = $current_verify_inv_no;
$customer_number = $cart_id;
$customer_number =~ s/_/./g;
$my_submit=&script_and_substitute($sc_yourpay_submit);
$my_change=&script_and_substitute($sc_yourpay_change);
$my_message=&script_and_substitute($sc_yourpay_verify_message);
$my_desc=&script_and_substitute($sc_yourpay_order_desc);

$my_oid = $cart_id . "|" . $invoice_number;
$mytable = &YourPayConnect_verification_table;
&read_verify_file;

if ($order_ok_final_msg_tbl eq '') {
 # Default so something is there, use $messages{'ordcnf_10'} though 
 # to customize, set it in the Free Form Logic (either location.)
  $order_ok_final_msg_tbl = "<b>Order Confirmation</b><br/><br/>" . &get_date;
 }

my $temp_total_thingy = ($zsubtotal - $zfinal_discount);

if ($sc_use_alternate_YourPayConnect_submit_page ne "Yes") {
############  Start of Standard submit page - Select from this line to for copy functions ############
#### can use in custom submit page.  Custom file must be named: YourPayConnect_custom_processing_lib.pl
#### Custom function (aka sub routine) to replace the code below must be named: YourPayConnect_custom_submit_page

print <<ENDOFTEXT;

<FORM METHOD=POST ACTION="$sc_order_script_url">
<INPUT TYPE=HIDDEN NAME='mode' value="payplus">
<INPUT TYPE=HIDDEN NAME='txnorg' value="eci">
<INPUT TYPE=HIDDEN NAME='txntype' value="sale">
<INPUT TYPE=HIDDEN NAME='tax' value="$zfinal_sales_tax">
<INPUT TYPE=HIDDEN NAME='shipping' VALUE="$zfinal_shipping">
<INPUT TYPE=HIDDEN NAME='subtotal' VALUE="$temp_total_thingy">
<INPUT TYPE=HIDDEN NAME='chargetotal' VALUE="$authPrice">
<INPUT TYPE=HIDDEN NAME='username' VALUE="$sc_gateway_username">
<INPUT TYPE=HIDDEN NAME='storename' VALUE="$sc_gateway_storename">
<INPUT TYPE=HIDDEN NAME='oid' VALUE="$my_oid">
<INPUT TYPE=HIDDEN NAME='email' VALUE="$eform_Ecom_BillTo_Online_Email">
<INPUT TYPE=HIDDEN NAME='bname' VALUE="$eform_Ecom_ShipTo_Postal_Name">
<INPUT TYPE=HIDDEN NAME='baddr1' VALUE="$eform_Ecom_ShipTo_Postal_Street_Line1"> 
<INPUT TYPE=HIDDEN NAME='bcity' VALUE="$eform_Ecom_ShipTo_Postal_City"> 
<INPUT TYPE=HIDDEN NAME='bstate' VALUE="$eform_Ecom_ShipTo_Postal_StateProv">
<INPUT TYPE=HIDDEN NAME='bzip' VALUE="$eform_Ecom_ShipTo_Postal_PostalCode">

<div align="center">
  <p class="ac_checkout_top_msg">$order_ok_final_msg_tbl</p>
  <p class="ac_checkout_top_msg">$my_message</p>


<table cellpadding="0" cellspacing="0" class="ac_checkout_review">
<tr>
<th colspan="2" class="ac_checkout_review">Customer Information</th>
</tr>
ENDOFTEXT

if ($form_data{'Ecom_ShipTo_Method'} ne ""){
print <<ENDOFTEXT;
  <tr>
    <td class="ac_checkout_review_col1">Ship via:</td>
    <td class="ac_checkout_review_col2">$form_data{'Ecom_ShipTo_Method'}</td>
  </tr>
ENDOFTEXT
}
 
print <<ENDOFTEXT;
  <tr>
    <td class="ac_checkout_review_col1">Name</td>
    <td class="ac_checkout_review_col2">$form_data{'Ecom_ShipTo_Postal_Name'}&nbsp;</td>
  </tr>

  <tr>
    <td class="ac_checkout_review_col1">Street</td>
    <td class="ac_checkout_review_col2">$form_data{'Ecom_ShipTo_Postal_Street_Line1'}&nbsp;</td>
  </tr>

  <tr>
    <td class="ac_checkout_review_col1">City</td>
    <td class="ac_checkout_review_col2">$form_data{'Ecom_ShipTo_Postal_City'}&nbsp;</td>
  </tr>

  <tr>
    <td class="ac_checkout_review_col1">State</td>
    <td class="ac_checkout_review_col2">$form_data{'Ecom_ShipTo_Postal_StateProv'}
    &nbsp;</td>
  </tr>
  <tr>
    <td class="ac_checkout_review_col1">Postal Code</td>
    <td class="ac_checkout_review_col2">$form_data{'Ecom_ShipTo_Postal_PostalCode'}
    &nbsp; </td>
  </tr>
  <tr>
    <td class="ac_checkout_review_col1">Country</td>
    <td class="ac_checkout_review_col2">$form_data{'Ecom_ShipTo_Postal_CountryCode'}</td>
  </tr>
</TABLE>

<TABLE WIDTH="500" BGCOLOR="#FFFFFF" CELLPADDING="2" CELLSPACING="0" BORDER=0>
  <TR>
    <TD COLSPAN=2>
      <CENTER>
        <INPUT TYPE="IMAGE" NAME="Submit" VALUE="Submit Order For Processing"
        SRC="$my_submit" border=0>&nbsp;&nbsp;&nbsp;&nbsp;

        <a href="agora.cgi?order_form_button.x=1&cart_id=${cart_id}">
        <IMG SRC="$my_change" BORDER=0></a>
      </CENTER>
    </TD>
  </TR>
</TABLE>
</CENTER>
</FORM>

ENDOFTEXT
############  End of Submit Page Code - Select until this line for copy functions ############
}
else { # uses alternate processing file in add_ons sub directory

&codehook("YourPayConnect_custom_submit_page");

} # end of alternate submit page

}
###############################################################################

sub process_YourPayConnect_order {

local($subtotal, $total_quantity,
      $total_measured_quantity,
      $text_of_cart,
      $required_fields_filled_in, $product, $quantity, $options);
local($stevo_shipping_thing) = "";
local($stevo_shipping_names) = "";
local($ship_thing_too,$ship_instructions);
local(%orderLoggingHash);

&load_verify_file;

$orderDate = &get_date;

# NEW CODEHOOK
&codehook("process-order-routine-top");

print qq!
<Connect>
$sc_special_page_meta_tags
<HEAD>
<TITLE>$messages{'ordcnf_08'}</TITLE>
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
$sc_secure_standard_head_info</HEAD>
<BODY $sc_standard_body_info>
!;

&SecureStoreHeader;

if ($sc_use_alternate_YourPayConnect_order_processing ne "Yes") {
############  Start of Standard Processing Code - Select from this line to for copy functions ############
#### can use in custom processing file.  Custom file must be named: YourPayConnect_custom_processing_lib.pl
#### Place YourPayConnect_custom_processing_lib.pl in the library directory of your store
#### Custom function (aka sub routine)  to replace the code below must be named: YourPayConnect_custom_processing_function

$text_of_cart .= "Order Date:    $orderDate\n";
$text_of_cart .= "Gateway:       YourPayConnect\n\n";
$orderLoggingHash{'GatewayUsed'} = "YourPayConnect";

$text_of_cart .= "  --PRODUCT INFORMATION--\n\n";

open (CART, "$sc_cart_path") ||
&file_open_error("$sc_cart_path", "display_cart_contents", __FILE__, __LINE__);

while (<CART>) {
  $cartData++;
  @cart_fields = split (/\|/, $_);
  $quantity = $cart_fields[0];
  $product_price = $cart_fields[3];
  $product = $cart_fields[4];
  $weight = $cart_fields[6];
  $options = $cart_fields[$cart{"options"}];
  $options =~ s/<br>//g;
  $text_of_cart .= &cart_textinfo(*cart_fields);
  $stevo_shipping_thing .= "|quantity\*$weight";
  $stevo_shipping_names .= "|$product\($options\)";
  &codehook("process-cart-item");
 }
close(CART);

# initialize hash variables in case they are empty later
# added by Mister Ed October 2005

$orderLoggingHash{'firstName'} = "";
$orderLoggingHash{'lastName'} = "";
$orderLoggingHash{'fullName'} = "";
$orderLoggingHash{'orderFromAddress'} = "";
$orderLoggingHash{'customerAddress2'} = "";
$orderLoggingHash{'customerAddress3'} = "";
$orderLoggingHash{'orderFromCity'} = "";
$orderLoggingHash{'orderFromPostal'} = "";
$orderLoggingHash{'customerPhone'} = "";
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

&add_text_of_both('Order ID',$form_data{'oid'});
&add_text_of_cart('STATUS',$form_data{'status'});
&add_text_of_cart('APPROVAL CODE',$form_data{'approval_code'});
&add_text_of_cart('Charge Total',$form_data{'chargetotal'});
&add_text_of_cart('CC Type',$form_data{'cctype'});
&add_text_of_cart('Card #',$form_data{'cardnumber'});
&add_text_of_cart('Exp Month',$form_data{'expmonth'});
&add_text_of_cart('Exp Year',$form_data{'expyear'});

$orderLoggingHash{'customerNumber'} = "$cart_id";
$orderLoggingHash{'invoiceNumber'} = "$yp_inv";
$orderLoggingHash{'subTotal'} = &format_price($sc_verify_subtotal);

&add_text_of_both("SUBTOTAL",$sc_verify_subtotal);
$sc_verify_subtotal3 = $sc_verify_subtotal;

if (($sc_buySafe_is_enabled =~ /yes/) && ($sc_verify_buySafe > 0)) {
my $temp = &format_price($sc_verify_buySafe);
$text_of_cart .= "$sc_buySafe_bond_fee_mini_display_text       $temp\n";
$text_of_confirm_email .= "$sc_verify_buySafe_display_text       $temp\n";
$orderLoggingHash{'buySafe'} = "$temp";
}

if ($sc_verify_discount) {
  $temp = &format_price($sc_verify_discount);
  &add_text_of_both("DISCOUNT",$temp);
  $orderLoggingHash{'discounts'} = &format_price($sc_verify_discount);
  # start of adjustments for discount addon
  $text_of_cart .= "DISCOUNT CODE: $eform_Ecom_Discount\n";
  $text_of_confirm_email .= "DISCOUNT CODE: $eform_Ecom_Discount\n";
  # end of adjustments for discount addon
}

if ($sc_verify_shipping){
  &add_text_of_both("SHIPPING",$sc_verify_shipping);
$orderLoggingHash{'shippingTotal'} = &format_price($sc_verify_shipping);
 }

if ($sc_verify_tax > 0)
{
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

if ($form_data{'tax'}){
  &add_text_of_both("TOTAL TAXES",$form_data{'tax'});
  $orderLoggingHash{'salesTax'} = "$form_data{'tax'}";
 }


$text_of_cart .= "GRAND TOTAL:   $form_data{'chargetotal'}\n\n";
$text_of_confirm_email .= "GRAND TOTAL:   $form_data{'chargetotal'}\n\n";
$orderLoggingHash{'orderTotal'} = "$form_data{'chargetotal'}";

$text_of_cart .= "BILLING INFORMATION --------------\n\n";

$text_of_cart .= "NAME:          $form_data{'bname'}\n";
$orderLoggingHash{'fullName'} = "$form_data{'bname'}";

if ($form_data{'baddr1'} ne "") {
  $text_of_cart .= "ADDRESS1:      $form_data{'baddr1'}\n";
  $orderLoggingHash{'orderFromAddress'} = "$form_data{'baddr1'}";
}

if ($form_data{'baddr2'} ne "") {
  $text_of_cart .= "ADDRESS2:      $form_data{'baddr2'}\n";
  $orderLoggingHash{'customerAddress2'} = "$form_data{'baddr2'}";
}

$text_of_cart .= "CITY:          $form_data{'bcity'}\n";
$orderLoggingHash{'orderFromCity'} = "$form_data{'bcity'}";

$text_of_cart .= "STATE:         $form_data{'bstate'}\n";
$orderLoggingHash{'orderFromState'} = "$form_data{'bstate'}";

$text_of_cart .= "ZIP:           $form_data{'bzip'}\n";
$orderLoggingHash{'orderFromPostal'} = "$form_data{'bzip'}";

$text_of_cart .= "COUNTRY:       $form_data{'bcountry'}\n";
$orderLoggingHash{'orderFromCountry'} = "$form_data{'bcountry'}";

$text_of_cart .= "PHONE:         $form_data{'phone'}\n";
$orderLoggingHash{'customerPhone'} = "$form_data{'bphone'}";

$text_of_cart .= "FAX:           $form_data{'fax'}\n";

$text_of_cart .= "EMAIL:         $form_data{'email'}\n\n";
$orderLoggingHash{'emailAddress'} = "$form_data{'email'}";

$text_of_cart .= "SHIPPING INFORMATION --------------\n\n";

if ($eform_Ecom_ShipTo_Postal_Name ne "") {
  $text_of_cart .= "NAME:          $eform_Ecom_ShipTo_Postal_Name\n";
  $orderLoggingHash{'shipToName'} = "$eform_Ecom_ShipTo_Postal_Name";
} else {
  $text_of_cart .= "NAME:          $form_data{'sname'}\n";
  $orderLoggingHash{'shipToName'} = "$form_data{'sname'}";
}

if ($eform_Ecom_ShipTo_Postal_Street_Line1 ne "") {
  $text_of_cart .= "ADDRESS1:      $eform_Ecom_ShipTo_Postal_Street_Line1\n";
  $orderLoggingHash{'shipToAddress'} = "$eform_Ecom_ShipTo_Postal_Street_Line1";
} else {
  $text_of_cart .= "ADDRESS1:      $form_data{'saddr1'}\n";
  $orderLoggingHash{'shipToAddress'} = "$form_data{'saddr1'}";
}

if ($form_data{'saddr2'} ne "") {
  $text_of_cart .= "ADDRESS2:      $form_data{'saddr2'}\n";
  $orderLoggingHash{'shipToAddress2'} = "$form_data{'saddr2'}";
} elsif ($form_data{'baddr2'} ne "") {
  $text_of_cart .= "ADDRESS2:      $form_data{'baddr2'}\n";
  $orderLoggingHash{'shipToAddress2'} = "$form_data{'baddr2'}";
}

if ($eform_Ecom_ShipTo_Postal_City ne "") {
  $text_of_cart .= "CITY:          $eform_Ecom_ShipTo_Postal_City\n";
  $orderLoggingHash{'shipToCity'} = "$eform_Ecom_ShipTo_Postal_City";
} else {
  $text_of_cart .= "CITY:          $form_data{'scity'}\n";
  $orderLoggingHash{'shipToCity'} = "$form_data{'scity'}";
}

if ($eform_Ecom_ShipTo_Postal_StateProv ne "") {
  $text_of_cart .= "STATE:         $eform_Ecom_ShipTo_Postal_StateProv\n";
  $orderLoggingHash{'shipToState'} = "$eform_Ecom_ShipTo_Postal_StateProv";
} else {
  $text_of_cart .= "STATE:         $form_data{'sstate'}\n";
  $orderLoggingHash{'shipToState'} = "$form_data{'sstate'}";
}

if ($sc_verify_shipping_zip ne "") {
   $text_of_cart .= "ZIP:           $sc_verify_shipping_zip\n";
  $orderLoggingHash{'shipToPostal'} = "$sc_verify_shipping_zip";
} else {
  $text_of_cart .= "ZIP:           $form_data{'szip'}\n";
  $orderLoggingHash{'shipToPostal'} = "$form_data{'szip'}";
}

if ($vform_Ecom_ShipTo_Postal_CountryCode ne "") {
  $text_of_cart .= "COUNTRY:       $vform_Ecom_ShipTo_Postal_CountryCode\n\n";
  $orderLoggingHash{'shipToCountry'} = "$vform_Ecom_ShipTo_Postal_CountryCode";
} else {
  $text_of_cart .= "COUNTRY:       $form_data{'scountry'}\n\n";
  $orderLoggingHash{'shipToCountry'} = "$form_data{'scountry'}";
}

 $orderLoggingHash{'shipMethod'} = $eform_Ecom_ShipTo_Method;

# NEW CODEHOOK
&codehook("process-order-pre-ship-instructions");

&add_text_of_cart("SHIP VIA",$vform_Ecom_ShipTo_Method);

if ($sc_verify_discount) {
  &add_text_of_both("DISCOUNT",$sc_verify_discount);
  $orderLoggingHash{'discounts'} = "$sc_verify_discount";
 }
 
if ($ship_instructions ne "") {
  $text_of_cart .= "Shipping Instructions: \n$ship_instructions\n\n";
 }

# NEW CODEHOOK
&codehook("process-order-pre-xcomments");

$text_of_cart .= $XCOMMENTS;
$orderLoggingHash{'xcomments'} = "$XCOMMENTS";
$orderLoggingHash{'xcomments'} =~ s/\n/<br>/g;
$orderLoggingHash{'adminMessages'} =~ s/\t/ /g;
$text_of_admin_email .= $XCOMMENTS_ADMIN;
$orderLoggingHash{'adminMessages'} .= "$XCOMMENTS_ADMIN";
$orderLoggingHash{'adminMessages'} =~ s/\n/<br>/g;
$orderLoggingHash{'adminMessages'} =~ s/\t/ /g;
$text_of_confirm_email .= $XCOMMENTS;

$orderLoggingHash{'adminMessages'} .= "<br>--ORDER INFORMATION--<br>";
$orderLoggingHash{'adminMessages'} .= "Order ID:      $form_data{'oid'}<br>";
$orderLoggingHash{'adminMessages'} .= "STATUS:        $form_data{'status'}<br>";
$orderLoggingHash{'adminMessages'} .= "APPROVAL CODE: $form_data{'approval_code'}<br>";
$orderLoggingHash{'adminMessages'} .= "Charge Total:  $form_data{'chargetotal'}<br>";
$orderLoggingHash{'adminMessages'} .= "CC Type:       $form_data{'cctype'}<br>";
$orderLoggingHash{'adminMessages'} .= "Card #:        $form_data{'cardnumber'}<br>";
$orderLoggingHash{'adminMessages'} .= "Exp Month:     $form_data{'expmonth'}<br>";
$orderLoggingHash{'adminMessages'} .= "Exp Year:      $form_data{'expyear'}<br>";
$orderLoggingHash{'adminMessages'} .= "<br>---------------------<br>";

# 'Init' the emails ...
$text_of_cart = &init_shop_keep_email . $text_of_cart;
$text_of_confirm_email = &init_customer_email . $text_of_confirm_email;

# and add the rest ...
$text_of_admin_email .= &addto_shop_keep_email;
$text_of_confirm_email .= &addto_customer_email;

if ($sc_use_pgp =~ /yes/i)
{
&require_supporting_libraries(__FILE__, __LINE__, "$sc_pgp_lib_path");
$text_of_cart = &make_pgp_file($text_of_cart, "$sc_pgp_temp_file_path/$$.pgp");
$text_of_cart = "\n" . $text_of_cart . "\n";
}

# added by Mister Ed for Pro version Feb 7, 2007
my $temp_admin_email = "$sc_admin_email";
if ($sc_use_customer_email_over_admin =~ /yes/i) {
   $temp_admin_email = "form_data{'email'}";
}

if ($sc_send_order_to_email =~ /yes/i) {
  &send_mail($temp_admin_email, $sc_order_email, "AgoraCart - YourPayConnect Order - $yp_inv",$text_of_cart);
 }

# NEW CODEHOOK
&codehook("process-order-pre-logOrder");

# write order log
&log_order($text_of_cart,$yp_inv,$cart_id);

if (($cartData) && ($form_data{'email'} ne "")){
  &send_mail($sc_admin_email, $form_data{'email'}, $messages{'ordcnf_08'}, 
           "$text_of_confirm_email");
 }
$sc_affiliate_order_unique = $form_data{'oid'};
$sc_affiliate_order_total = $sc_verify_subtotal3 - $sc_verify_discount;

$sc_affiliate_image_call =~ s/AMOUNT/$sc_affiliate_order_total/g;
$sc_affiliate_image_call =~ s/UNIQUE/$sc_affiliate_order_unique/g;

# NEW CODEHOOK
&codehook("process-order-display-thankyou-page");

print <<ENDOFTEXT;
<CENTER>
<TABLE WIDTH=500>
<TR>
<TD WIDTH=500>
<BR>
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
</Connect>
!;
############  End of Standard Processing Code - Select until this line for copy functions ############
}
else { # uses alternate processing file in add_ons sub directory

 &codehook("YourPayConnect_custom_processing_function");

} # end of alternate processing
} # End of process_YourPayConnect_order

#################################################################
1; # Library
