#######################################################################
#                    Order Form Definition Variables                  #
#######################################################################

$versions{'USAepay-order_lib.pl'} = "5.5.001";
$sc_use_secure_header_at_checkout = 'yes';
$sc_use_secure_footer_for_order_form = 'yes';

$sc_order_response_vars{"USAepay"}="USAepay";
$sc_use_secure_header_at_checkout = 'yes';
&add_codehook("open_for_business","USAepay_bill2ship_field_defaults");
&add_codehook("printSubmitPage","print_USAepay_SubmitPage");
&add_codehook("set_form_required_fields","USAepay_fields");
&add_codehook("gateway_response","check_for_USAepay_response");
###############################################################################
sub USAepay_check_and_load {
local($myname)="USAepay";
if ($myname ne $sc_gateway_name) { # we are a secondary gateway, load settings
  &require_supporting_libraries(__FILE__,__LINE__,
     "./admin_files/$myname-user_lib.pl");
 }

}
###############################################################################
sub check_for_USAepay_response {
  if (($form_data{'UMstatus'} eq 'Approved')||($form_data{'UMstatus'} eq 'Declined')||($form_data{'UMstatus'} eq 'Error')) {
    $cart_id = $form_data{'cart_id'};
    &set_sc_cart_path;
    &load_order_lib;
    &codehook("USAepay_order");
    &process_USAepay_Order;
    &call_exit;
   }
 }
###############################################################################
sub USAepay_bill2ship_field_defaults {
# We default the Shipto info to Billto if left blank
if ($form_data{'Ecom_ShipTo_Postal_PostalCode'} eq "") {
  if ($form_data{'Ecom_BillTo_PostalCode'} ne "") {
  $form_data{'Ecom_ShipTo_Postal_PostalCode'} = 
       $form_data{'Ecom_BillTo_PostalCode'};
   }
 }

if ($form_data{'Ecom_ShipTo_Postal_Name_Last'} eq "") {
  if ($form_data{'Ecom_BillTo_Postal_Name_Last'} ne "") {
  $form_data{'Ecom_ShipTo_Postal_Name_Last'} = 
       $form_data{'Ecom_BillTo_Postal_Name_Last'};
   }
 }

if ($form_data{'Ecom_ShipTo_Postal_Name_First'} eq "") {
  if ($form_data{'Ecom_BillTo_Postal_Name_First'} ne "") {
  $form_data{'Ecom_ShipTo_Postal_Name_First'} = 
       $form_data{'Ecom_BillTo_Postal_Name_First'};
   }
 }

if ($form_data{'Ecom_ShipTo_Postal_Street_Line1'} eq "") {
  if ($form_data{'Ecom_BillTo_Postal_Street_Line1'} ne "") {
    $form_data{'Ecom_ShipTo_Postal_Street_Line1'} = 
       $form_data{'Ecom_BillTo_Postal_Street_Line1'};
    $form_data{'Ecom_ShipTo_Postal_Street_Line2'} = 
       $form_data{'Ecom_BillTo_Postal_Street_Line2'};
    $form_data{'Ecom_ShipTo_Postal_Street_Line3'} = 
       $form_data{'Ecom_BillTo_Postal_Street_Line3'};
   }
 }

if ($form_data{'Ecom_ShipTo_Postal_City'} eq "") {
  if ($form_data{'Ecom_BillTo_Postal_City'} ne "") {
  $form_data{'Ecom_ShipTo_Postal_City'} = 
       $form_data{'Ecom_BillTo_Postal_City'};
   }
 }

if ($form_data{'Ecom_ShipTo_Postal_StateProv'} eq "") {
  if ($form_data{'Ecom_BillTo_Postal_StateProv'} ne "") {
  $form_data{'Ecom_ShipTo_Postal_StateProv'} = 
       $form_data{'Ecom_BillTo_Postal_StateProv'};
   }
 }

if ($form_data{'Ecom_ShipTo_Postal_CountryCode'} eq "") {
  if ($form_data{'Ecom_BillTo_Postal_CountryCode'} ne "") {
  $form_data{'Ecom_ShipTo_Postal_CountryCode'} = 
       $form_data{'Ecom_BillTo_Postal_CountryCode'};
   }
 }

# use this code hooks to check for more variables / default values
&codehook("USAepay_bill2ship_field_defaults_bottom");
}
###############################################################################
sub USAepay_fields {
local($myname)="USAepay";

if (!($form_data{'gateway'} eq $myname)) { return;} 

%sc_order_form_array =(
	'Ecom_BillTo_Postal_Name_First', 'First Name',
  'Ecom_BillTo_Postal_Name_Last', 'Last Name',
  'Ecom_BillTo_Postal_Street_Line1', 'Billing Address Street',
  'Ecom_BillTo_Postal_City', 'Billing Address City',
  'Ecom_BillTo_Postal_StateProv', 'Billing Address State',
  'Ecom_BillTo_PostalCode', 'Billing Address Zip',
  'Ecom_BillTo_Postal_CountryCode', 'Billing Address Country',
  'Ecom_ShipTo_Postal_Street_Line1', 'Shipping Address Street',
  'Ecom_ShipTo_Postal_City', 'Shipping Address City',
  'Ecom_ShipTo_Postal_StateProv', 'Shipping Address State',
  'Ecom_ShipTo_Postal_PostalCode', 'Shipping Address Zip',
  'Ecom_ShipTo_Postal_CountryCode', 'Shipping Address Country',
  'Ecom_BillTo_Telecom_Phone_Number', 'Phone Number',
  'Ecom_BillTo_Online_Email', 'Email',
  'Ecom_is_Residential', 'Shipping to Residential Address',
  'Ecom_ShipTo_Insurance', 'Insure this Shipment', # not implemented yet, for the future
  'Ecom_tos', 'Sales-Terms of Service',
  'Ecom_Payment_Card_Type', 'Type of Card',
  'Ecom_Payment2_Card_Number', 'Card Number',
  'Ecom_Payment_Card_ExpDate_Month', 'Card Expiration Month',
  'Ecom_Payment_Card_ExpDate_Year', 'Card Expiration Year');

                     

@sc_order_form_required_fields = ("Ecom_BillTo_Postal_Name_First",
          "Ecom_BillTo_Postal_Name_Last",
          "Ecom_BillTo_Postal_Street_Line1",
          "Ecom_BillTo_Postal_City",
          "Ecom_BillTo_Postal_StateProv",
          "Ecom_BillTo_PostalCode",
          "Ecom_BillTo_Postal_CountryCode", 
          "Ecom_BillTo_Telecom_Phone_Number",
          "Ecom_BillTo_Online_Email",
          "Ecom_Payment_Card_Type",
          "Ecom_Payment2_Card_Number",
          "Ecom_Payment_Card_ExpDate_Month",
          "Ecom_Payment_Card_ExpDate_Year");

# lines for tos added April 5 2006 by Mister Ed
 if ($sc_display_checkout_tos =~ /yes/i) {
    push(@sc_order_form_required_fields,"Ecom_tos");
 }

# use this codehook to change the above arrays for required fields and such
&codehook("USAepay_fields_bottom");

}

###############################################################################
sub USAepay_order_form_prep { # load the customer info ...
  &USAepay_check_and_load;
  if ($sc_USAepay_form_prep == 0) {
    if (-f "$sc_verify_order_path"){
      &read_verify_file;  
     } else {
      &codehook("load_customer_info");
     }
    $sc_USAepay_form_prep = 1;
   }
  return "";
 }
###############################################################################
sub USAepay_table_setup {
#
# To use this, put this in the email_text in the manager for HTML:
#
#	<!--agorascript-pre
#	  return $USAepay_cart_table;
#	-->
#
# or for text in an email:
#
#	<!--agorascript-pre
#	  return $USAepay_prod_in_cart;
#	-->
# 

local (@my_cart_fields,$my_cart_row_number,$result);
local ($count,$price,$product_id,$quantity,$total_cost,$total_qty)=0;
local ($name,$cost);

 $USAepay_prod_in_cart = '';
 $USAepay_cart_table = '';
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
     $USAepay_prod_in_cart .= "  --PRODUCT INFORMATION--\n\n";
    }
   $result .= "<TR><TD>$quantity</TD><TD>$product_id</TD>\n";
   $result .= "<TD>$name</TD><TD>$cost</TD>";
   $result .= "</TR>\n";
   $USAepay_prod_in_cart .= &cart_textinfo(*my_cart_fields);
  } # End of while (<CART>)
 close (CART);
 if ($result ne '') {
   $result .= "</TABLE></TD></TR></TABLE>\n";
  }

# use this codehook to change $result
&codehook("USAepay_table_setup_bottom");

 $USAepay_cart_table = $result;
}

###############################################################################

sub print_USAepay_SubmitPage

{
local($invoice_number, $customer_number, $displayTotal);
local($test_mode);
local($myname)="USAepay";
local($my_change,$my_submit,$my_message,$my_desc);

if (!($form_data{'gateway'} eq $myname)) { return;} 
if ($myname ne $sc_gateway_name) { # secondary gateway, load settings
  &require_supporting_libraries(__FILE__,__LINE__,
     "./admin_files/$myname-user_lib.pl");
 }

$displayTotal = &display_price($authPrice);

$customer_number = $cart_id;
$customer_number =~ s/_/./g;
$my_submit=&script_and_substitute($sc_USAepay_submit);
$my_change=&script_and_substitute($sc_USAepay_change);
$my_message=&script_and_substitute($sc_USAepay_verify_message);
$my_desc=&script_and_substitute($sc_USAepay_order_desc);
&USAepay_table_setup;

if ($merchant_live_mode =~ /yes/i){
  $test_mode = "";
 } else {
  $test_mode = qq~<input type="hidden" name="UMtestmode" value="1">~;
  $form_data{'Ecom_Payment2_Card_Number'} = "4787292258606353";
  $form_data{'Ecom_Payment_Card_Type'} = "Visa";
  $form_data{'Ecom_Payment_Card_ExpDate_Month'} = "09";
  $form_data{'Ecom_Payment_Card_ExpDate_Year'} = "09";
 }

my $fullname = "$form_data{'Ecom_BillTo_Postal_Name_Last'}" . " $form_data{'Ecom_BillTo_Postal_Name_Last'}";
my $expiredate = "$form_data{'Ecom_Payment_Card_ExpDate_Month'}" . " $form_data{'Ecom_Payment_Card_ExpDate_Year'}";

if ($sc_use_alternate_USAepay_submit_page ne "Yes") {
############  Start of Standard submit page - Select from this line to for copy functions ############
#### can use in custom submit page.  Custom file must be named: USAepay_custom_processing_lib.pl
#### Custom function (aka sub routine) to replace the code below must be named: USAepay_custom_submit_page

print <<ENDOFTEXT;

<FORM METHOD=POST ACTION=\"$sc_order_script_url\">

<form action="https://www.usaepay.com/gate.php" method="POST">
<input type="hidden" name="UMcommand" value="sale">
<input type="hidden" name="UMkey" value="$sc_gateway_userkey">
<input type="hidden" name="UMredir" value="$sc_ssl_location_url2">
<INPUT TYPE="hidden" name="USAepay" VALUE="USAepay">
<INPUT TYPE="hidden" name="cart_id" VALUE="$customer_number">
<input type="hidden" name="UMcustid" value="$customer_number">
<input type="hidden" name="UMamount" value="$authPrice">
<input type="hidden" name="UMechofields" value="1">
$test_mode
<input type="hidden" name="UMstreet" value="$form_data{'Ecom_BillTo_Postal_Street_Line1'}">
<input type="hidden" name="city" value="$form_data{'Ecom_BillTo_Postal_City'}">
<input type="hidden" name="state" value="$form_data{'Ecom_BillTo_Postal_StateProv'}">
<input type="hidden" name="UMzip" value="$form_data{'Ecom_BillTo_Postal_PostalCode'}">
<input type="hidden" name="UMbillcountry" value="$form_data{'Ecom_BillTo_Postal_CountryCode'}">
<input type="hidden" name="UMcustemail" value="$form_data{'Ecom_BillTo_Online_Email'}">
<input type="hidden" name="UMbillphone" value="$form_data{'BillTo_Telecom_Phone_Number'}">
<input type="hidden" name="cardtype" value="$form_data{'Ecom_Payment_Card_Type'}">
<input type="hidden" name="UMcard" value="$form_data{'Ecom_Payment2_Card_Number'}">
<input type="hidden" name="UMexpir" value="$expiredate">
<input type="hidden" name="UMname" value="$fullname">

ENDOFTEXT

print <<ENDOFTEXT;

<div align="center">

<p class="ac_checkout_top_msg">$USAepay_order_ok_final_msg_tbl</p>
  <p class="ac_checkout_top_msg">$my_message</p>


<table cellpadding="0" cellspacing="0" class="ac_checkout_review">
<tr>
<th colspan="2" class="ac_checkout_review">Customer Information</th>
</tr>

<tr>
<td class="ac_checkout_review_col1">Customer Number</td>
<td class="ac_checkout_review_col2">$customer_number</td>
</tr>

<tr>
<td class="ac_checkout_review_col1">Order Number</td>
<td class="ac_checkout_review_col2">$sc_verify_inv_no</td>
</tr>

<!-- begin add tos -->
<tr>
<td class="ac_checkout_review_col1">Sales Terms and Refund Policy</td>
<td class="ac_checkout_review_col2">$form_data{'Ecom_tos'}</td>
</tr>
<!-- end add tos -->

<tr>
<th colspan="2" class="ac_checkout_review">Billing Address</th>
</tr>

<tr>
<td class="ac_checkout_review_col1">Name</td>
<td class="ac_checkout_review_col2">
  $form_data{'Ecom_BillTo_Postal_Name_First'} $form_data{'Ecom_BillTo_Postal_Name_Last'}
</td>
</tr>

<tr>
<td class="ac_checkout_review_col1">Street</td>
<td class="ac_checkout_review_col2">$form_data{'Ecom_BillTo_Postal_Street_Line1'}&nbsp;</td>
</tr>

<tr>
<td class="ac_checkout_review_col1">City</td>
<td class="ac_checkout_review_col2">$form_data{'Ecom_BillTo_Postal_City'}&nbsp;</td>
</tr>

<tr>
<td class="ac_checkout_review_col1">State</td>
<td class="ac_checkout_review_col2">$form_data{'Ecom_BillTo_Postal_StateProv'}&nbsp;</td>
</tr>

<tr>
<td class="ac_checkout_review_col1">Zip</td>
<td class="ac_checkout_review_col2">$form_data{'Ecom_BillTo_PostalCode'}&nbsp;</td>
</tr>

<tr>
<td class="ac_checkout_review_col1">Country</td>
<td class="ac_checkout_review_col2">$form_data{'Ecom_BillTo_Postal_CountryCode'}&nbsp;</td>
</tr>

<tr>
<td class="ac_checkout_review_col1">Phone</td>
<td class="ac_checkout_review_col2">$form_data{'Ecom_BillTo_Telecom_Phone_Number'}&nbsp;</td>
</tr>

<tr>
<td class="ac_checkout_review_col1">E-Mail</td>
<td class="ac_checkout_review_col2">$form_data{'Ecom_BillTo_Online_Email'}&nbsp;</td>
</tr>

<!--Shipping Address-->

<tr>
<th colspan="2" class="ac_checkout_review">Shipping Information</th>
</tr>

ENDOFTEXT

if ($form_data{'Ecom_ShipTo_Method'} ne ""){
print <<ENDOFTEXT;
<tr>
<td class="ac_checkout_review_col1">Ship via</td>
<td class="ac_checkout_review_col2">$form_data{'Ecom_ShipTo_Method'}&nbsp;</td>
</tr>
ENDOFTEXT
}

print <<ENDOFTEXT;
<tr>
<td class="ac_checkout_review_col1">Name</td>
<td class="ac_checkout_review_col2">
  $form_data{'Ecom_ShipTo_Postal_Name_First'} $form_data{'Ecom_ShipTo_Postal_Name_Last'}&nbsp;
</td>
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
<!--<tr>
<th colspan="2" class="ac_checkout_review">Misc Information </th>
</tr>
<tr>
<td class="ac_checkout_review_col1" colspan="2">$XCOMMENTS</td>
</tr>-->
</TABLE>
 
<TABLE WIDTH="500" BGCOLOR="#FFFFFF" CELLPADDING="2" CELLSPACING="0" BORDER=0>
<TR>
<TD COLSPAN=2>
<CENTER>
<INPUT TYPE="IMAGE" NAME="Submit" VALUE="Submit Order For Processing"
SRC="$my_submit" border=0>
&nbsp;&nbsp;&nbsp;&nbsp;
<a href="agora.cgi?order_form_button.x=1&cart_id=${cart_id}">
<IMG SRC="$my_change" BORDER=0></a>
</FORM>
</CENTER>
</TD>
</TR>
</table>
</FONT>
</CENTER>
ENDOFTEXT

############  End of Submit Page Code - Select until this line for copy functions ############
}
else { # uses alternate processing file in add_ons sub directory

 &codehook("USAepay_custom_submit_page");

} # end of alternate submit page

}
############################################################################################
sub process_USAepay_Order {
local($subtotal, $total_quantity,
      $total_measured_quantity,
      $text_of_cart, $weight,
      $required_fields_filled_in, $product, $quantity, $options);
local($stevo_shipping_thing) = "";
local($stevo_shipping_names) = "";
local($ship_thing_too,$ship_instructions);
local(%orderLoggingHash);

#alt origination stuff added by Mister Ed Feb 17, 2005
if ($sc_alt_origin_enabled =~ /yes/i) {
	local(%zip_list);
	local(%zip_names_list);
}


if (($form_data{'UMstatus'} eq 'Declined')||($form_data{'UMstatus'} eq 'Error')) {

print qq!
<html>
$sc_special_page_meta_tags
<HEAD>
<title>$messages{'ordcnf_08'}</title>
$sc_secure_standard_head_info</head>
<body>
!;

&SecureStoreHeader;
print <<ENDOFTEXT;
<CENTER>
<TABLE WIDTH=500>
<TR>
<TD WIDTH=500>
<FONT FACE=ARIAL>
ENDOFTEXT


if ($form_data{'UMstatus'} eq 'Error') {
print <<ENDOFTEXT;
$messages{'USAepay_errror'}
ENDOFTEXT
# >
} elsif ($form_data{'UMstatus'} eq 'Declined') {
print <<ENDOFTEXT;
$messages{'USAepay_declined'}
ENDOFTEXT
# >
}

print <<ENDOFTEXT;
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

&call_exit;
}

&load_verify_file;

# NEW CODEHOOK
&codehook("process-order-routine-top");

$orderDate = &get_date;

if ($sc_use_alternate_USAepay_order_processing ne "Yes") {
############  Start of Standard Processing Code - Select from this line to for copy functions ############
#### can use in custom processing file.  Custom file must be named: USAepay_custom_processing_lib.pl
#### Place USAepay_custom_processing_lib.pl in the library directory of your store
#### Custom function (aka sub routine)  to replace the code below must be named: USAepay_custom_processing_function

print qq!
<html>
$sc_special_page_meta_tags
<HEAD>
<title>$messages{'ordcnf_08'}</title>
$sc_secure_standard_head_info</head>
<body>
!;

&SecureStoreHeader;

$text_of_cart .= "Order Date:    $orderDate\n";
$text_of_cart .= "Gateway:       USAepay\n\n";
$orderLoggingHash{'GatewayUsed'} = "USAepay";

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

# initialize hash variables in case they are empty later
# added by jfindlay 2006 February

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

$text_of_confirm_email .= "$text_of_cart\n";

$text_of_cart .= "  --ORDER INFORMATION--\n\n";

# $text_of_cart .= "VERIFICATION:  $verification\n";
$text_of_cart .= "CUST ID:       $form_data{'cart_id'}\n";
$text_of_confirm_email .= "CUST ID:       $form_data{'cart_id'}\n";
$orderLoggingHash{'customerNumber'} = "$form_data{'cart_id'}";

$text_of_cart .= "ORDER ID:      $sc_verify_inv_no\n";
$text_of_confirm_email .= "ORDER ID:      $sc_verify_inv_no\n";
$orderLoggingHash{'invoiceNumber'} = "$sc_verify_inv_no";

if ($sc_verify_shipping)
{
$text_of_cart .= "SHIPPING:      " . &format_price($sc_verify_shipping) . "\n";
$text_of_confirm_email .= "SHIPPING:      " . &format_price($sc_verify_shipping) . "\n";
$orderLoggingHash{'shippingTotal'} = &format_price($sc_verify_shipping);
}

if (($sc_use_SBW =~ /yes/i) || ($sc_verify_shipping > .009)) {
 $text_of_confirm_email .= "SHIP VIA:      $eform_Ecom_ShipTo_Method\n";
}

 $orderLoggingHash{'shipMethod'} = $eform_Ecom_ShipTo_Method;

  $temp = &format_price($sc_verify_subtotal);
  &add_text_of_both("SUBTOTAL",$temp);
  $orderLoggingHash{'subTotal'} = &format_price($sc_verify_subtotal);

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

$text_of_cart .= "TOTAL:         $sc_verify_grand_total\n\n";
$text_of_confirm_email .= "TOTAL:         $sc_verify_grand_total\n\n";
$orderLoggingHash{'orderTotal'} = "$sc_verify_grand_total";

$text_of_cart .= "TRANSACTION STATUS      $form_data{'UMstatus'}\n";
$text_of_cart .= "AUTH CODE      $form_data{'UMauthCode'}\n";
$text_of_cart .= "TRANS ID:      $form_data{'UMrefNum'}\n\n";
$text_of_cart .= "BILLING INFORMATION --------------\n\n";

$text_of_cart .= "NAME:          $eform_Ecom_BillTo_Postal_Name_First $eform_Ecom_BillTo_Postal_Name_Last\n";
$orderLoggingHash{'fullName'} = "$eform_ $eform_Ecom_BillTo_Postal_Name_Last";
$orderLoggingHash{'firstName'} = "$eform_Ecom_BillTo_Postal_Name_First";
$orderLoggingHash{'lastName'} = "$eform_Ecom_BillTo_Postal_Name_Last";

$text_of_cart .= "ADDRESS:       $eform_Ecom_BillTo_Postal_Street_Line1\n";
$orderLoggingHash{'orderFromAddress'} = "$eform_Ecom_BillTo_Postal_Street_Line1";

$text_of_cart .= "CITY:          $eform_Ecom_BillTo_Postal_City\n";
$orderLoggingHash{'orderFromCity'} = "$eform_Ecom_BillTo_Postal_City";

$text_of_cart .= "STATE:         $eform_Ecom_BillTo_Postal_StateProv\n";
$orderLoggingHash{'orderFromState'} = "$eform_Ecom_BillTo_Postal_StateProv";

$text_of_cart .= "ZIP:           $eform_Ecom_BillTo_PostalCode\n";
$orderLoggingHash{'orderFromPostal'} = "$eform_Ecom_BillTo_PostalCode";

$text_of_cart .= "COUNTRY:       $eform_Ecom_BillTo_Postal_CountryCode\n";
$orderLoggingHash{'orderFromCountry'} = "$eform_Ecom_BillTo_Postal_CountryCode";

$text_of_cart .= "PHONE:         $eform_BillTo_Telecom_Phone_Number\n";
$orderLoggingHash{'customerPhone'} = "$eform_BillTo_Telecom_Phone_Number";

$text_of_cart .= "EMAIL:         $eform_Ecom_BillTo_Online_Email\n\n";
$orderLoggingHash{'emailAddress'} = "$eform_Ecom_BillTo_Online_Email";

$text_of_cart .= "SHIPPING INFORMATION --------------\n\n";

$text_of_cart .= "NAME:          $eform_Ecom_ShipTo_Postal_Name_First $eform_Ecom_ShipTo_Postal_Name_Last\n";
$orderLoggingHash{'shipToName'} = "$eform_Ecom_ShipTo_Postal_Name_First $eform_Ecom_ShipTo_Postal_Name_Last";

$text_of_cart .= "ADDRESS:       $eform_Ecom_ShipTo_Postal_Street_Line1\n";
$orderLoggingHash{'shipToAddress'} = "$eform_Ecom_ShipTo_Postal_Street_Line1";

$text_of_cart .= "CITY:          $eform_Ecom_ShipTo_Postal_City\n";
$orderLoggingHash{'shipToCity'} = "$eform_Ecom_ShipTo_Postal_City";

$text_of_cart .= "STATE:         $eform_Ecom_ShipTo_Postal_StateProv\n";
$orderLoggingHash{'shipToState'} = "$eform_Ecom_ShipTo_Postal_StateProv";

$text_of_cart .= "ZIP:           $eform_Ecom_ShipTo_Postal_PostalCode\n";
$orderLoggingHash{'shipToPostal'} = "$eform_Ecom_ShipTo_Postal_PostalCode";

$text_of_cart .= "COUNTRY:       $vform_Ecom_ShipTo_Postal_CountryCode\n";
$orderLoggingHash{'shipToCountry'} = "$vform_Ecom_ShipTo_Postal_CountryCode";

$text_of_cart .= "SHIP VIA:      $eform_eform_Ecom_ShipTo_Method\n";

# NEW CODEHOOK
&codehook("process-order-pre-ship-instructions");

if ($ship_instructions ne "") {
  $text_of_cart .= "Shipping Instructions: \n$ship_instructions\n\n";
 }

# NEW CODEHOOK
&codehook("process-order-pre-xcomments");

$text_of_cart .= $XCOMMENTS_ADMIN;
$orderLoggingHash{'adminMessages'} = "$XCOMMENTS_ADMIN";
$orderLoggingHash{'adminMessages'} =~ s/\n/<br>/g;
$orderLoggingHash{'adminMessages'} =~ s/\t/ /g;
$orderLoggingHash{'adminMessages'} .= "<br>AUTHORIZATION INFORMATION --------------<br>TRANSACTION STATUS: $form_data{'UMstatus'}<br>AUTH CODE:  $form_data{'UMauthCode'}<br>TRANS ID:  $form_data{'UMrefNum'}<br>---------------------------------------------------------------<br>";
$text_of_confirm_email .= $XCOMMENTS;
$orderLoggingHash{'xcomments'} = "$XCOMMENTS";
$orderLoggingHash{'xcomments'} =~ s/\n/<br>/g;
$orderLoggingHash{'adminMessages'} =~ s/\t/ /g;

# 'Init' the emails ...
$text_of_cart = &init_shop_keep_email . $text_of_cart;
$text_of_confirm_email = &init_customer_email . $text_of_confirm_email;

# and add the rest ...
$text_of_admin_email .= &addto_shop_keep_email;
$text_of_confirm_email .= &addto_customer_email;

$sc_USAepay_order_desc .= " - " . $sc_verify_inv_no;

# added by Mister Ed for Pro version Feb 7, 2007
my $temp_admin_email = "$sc_admin_email";
if ($sc_use_customer_email_over_admin =~ /yes/i) {
   $temp_admin_email = "$eform_Ecom_BillTo_Online_Email";
}

if ($sc_send_order_to_email =~ /yes/i) {
  &send_mail($temp_admin_email, $sc_order_email, $sc_USAepay_order_desc, $text_of_cart);
 }

&log_order($text_of_cart,$sc_verify_inv_no,$form_data{'cart_id'});

if (($cartData) && ($eform_Ecom_BillTo_Online_Email ne "")) {
  &send_mail($sc_admin_email, $eform_Ecom_BillTo_Online_Email, $messages{'ordcnf_08'},
           "$text_of_confirm_email");
 }
$sc_affiliate_order_unique = $sc_verify_inv_no;
$sc_affiliate_order_total = $sc_verify_subtotal;

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

# and the footer is printed

&SecureStoreFooter;

print qq!
</BODY>
</HTML>
!;
############  End of Standard Processing Code - Select until this line for copy functions ############
}
else { # uses alternate processing file in add_ons sub directory

 &codehook("USAepay_custom_processing_function");

} # end of alternate processing
} # End of process_order_form

#################################################################
1; # Library
