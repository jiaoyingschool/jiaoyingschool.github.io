#######################################################################
#                    Order Form Definition Variables                  #
#######################################################################

$versions{'Offline-order_lib.pl'} = "5.5.000";

$order_lib_cc_validate = "yes";
$sc_use_secure_header_at_checkout = 'yes';
$sc_offline_form_prep = 0;

&add_codehook("printSubmitPage","print_Offline_SubmitPage");
&add_codehook("set_form_required_fields","Offline_fields");
&add_codehook("gateway_response","check_for_Offline_response");
&add_codehook("open_for_business","check_for_Offline_submit");
$sc_order_response_vars{"Offline"}="process_order";
if ($sc_loading_primary_gateway =~ /yes/i) { #Hook into things ...
  &add_codehook("pre_header_navigation","Offline_pre_header_processing");
 } 
if ($offline_picserve eq '') {
  $offline_picserve = $sc_picserve_url;
 }
if ($offline_picserve eq '') {
  $offline_picserve = 'picserve.cgi';
}
###############################################################################
sub check_for_Offline_submit {
  if (&form_check('submit_order_form_button')) {
    if ($form_data{'gateway'} eq '') {
      $form_data{'gateway'} = $sc_gateway_name;
     }
    if ($form_data{'gateway'} eq 'Offline') {    
      &Offline_response_prep;
     }
   }
 }
###############################################################################
sub check_for_Offline_response {
  if ($form_data{'process_order'}) {
    $cart_id = $form_data{'cart_id'};
    &set_sc_cart_path;
    &load_order_lib;
    &codehook("Offline_order");
    &process_Offline_Order;
    &call_exit;
   }
 }
###############################################################################
sub Offline_check_and_load {
local($myname)="Offline";
#
if ($myname ne $sc_gateway_name) { # we are a secondary gateway, load settings
  &require_supporting_libraries(__FILE__,__LINE__,
     "./admin_files/$myname-user_lib.pl");
 }
if ($sc_Offline_CC_validation ne '') {
  $sc_CC_validation = $sc_Offline_CC_validation;
 }
$sc_stepone_order_script_url = $sc_order_script_url;
}
###############################################################################
sub Offline_response_prep {
&Offline_check_and_load;
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


# Need to do this here so it gets to the verify file
$sc_paid_by_ccard = "";
$form_data{"Ecom_Payment_Orig_Card_Type"} = 
    $form_data{"Ecom_Payment_Card_Type"};
$form_data{"Ecom_Payment_Orig_Card_Number"} = 
    $form_data{"Ecom_Payment_Card_Number"};
if ($form_data{"Ecom_Payment_Card_Type"} ne "" ) {
  if ((!($form_data{"Ecom_Payment_Card_Type"} =~ /check/i)) &&
    (!($form_data{"Ecom_Payment_Card_Type"} =~ /cheque/i)) &&
    (!($form_data{"Ecom_Payment_Card_Type"} =~ /Mailed/i)) &&
    (!($form_data{"Ecom_Payment_Card_Type"} =~ /PO/i))) {
  # must be a Credit Card
    $sc_paid_by_ccard = "yes";
    $form_data{"Ecom_Payment_Pay_Type"} = 'CC'; 
   } else {
    $sc_paid_by_ccard = "no";
    if (($sc_allow_pay_by_PO =~ /yes/i )  &&
    ($form_data{"Ecom_Payment_Card_Type"} =~ /PO/i)) {
      $form_data{"Ecom_Payment_Card_Type"} = "Purchase Order"; 
      $form_data{"Ecom_Payment_Card_Number"} = 
        $form_data{"Ecom_Payment_PO_Number"};
      $form_data{"Ecom_Payment_Pay_Type"} = 'PO'; 
    } elsif ($sc_allow_pay_by_check =~ /yes/i ) {
      $form_data{"Ecom_Payment_Card_Type"} .= ", Bank Name is " .
        $form_data{"Ecom_Payment_Bank_Name"};
      $form_data{"Ecom_Payment_Card_Number"} = "R: " .
        $form_data{"Ecom_Payment_BankRoute_Number"} . " A:" .  
        $form_data{"Ecom_Payment_BankAcct_Number"} . " #:" .
        $form_data{"Ecom_Payment_BankCheck_Number"};  
      $form_data{"Ecom_Payment_Pay_Type"} = 'CHECK'; 
    } elsif ($sc_allow_pay_by_mailedcheck =~ /yes/i ) {
      $form_data{"Ecom_Payment_Card_Type"} = "MailedFunds";
      $form_data{"Ecom_Payment_Card_Number"} = "Mailed Funds";
      $form_data{"Ecom_Payment_Pay_Type"} = 'MailedFunds'; 
     } 
   } 
 }

# use this codehook to check for more variables / default values or to reset others above
&codehook("Offline_response_prep_bottom");

}
###############################################################################
sub Offline_order_form_prep {
  &Offline_check_and_load;
  if ($sc_offline_form_prep == 0) {
    if (-f "$sc_verify_order_path"){
      &read_verify_file;  
     } else {
      &codehook("load_customer_info");
     }
    $sc_offline_form_prep = 1;
   }
  return "";
 }
###############################################################################
sub Offline_pre_header_processing {
# May want to change the header for no-cache under certain circumstances
   if (($form_data{'order_form_button.x'} ne "") ||
       ($form_data{'submit_order_form_button'} ne "") ||
       ($form_data{'submit_order_form_button.x'} ne "") ||
       ($form_data{'order_form_button'} ne "")) {
     $sc_browser_header = 
  "Content-type: text/html\nCache-Control: no-cache\n" .
  "Pragma: no-cache\nExpires: Wed, 4 October 2000 00:00:00 GMT\n\n";
   }
 }
###############################################################################
sub Offline_fields {
local($myname)="Offline";

if (!($form_data{'gateway'} eq $myname)) { return;} 

%sc_order_form_array =('Ecom_BillTo_Postal_Name_First', 'First Name',
           'Ecom_BillTo_Postal_Name_Last', 'Last Name',
           'Ecom_BillTo_Postal_Street_Line1', 'Billing Address Street',
           'Ecom_BillTo_Postal_City', 'Billing Address City',
           'Ecom_BillTo_Postal_StateProv', 'Billing Address State',
           'Ecom_BillTo_PostalCode', 'Billing Address Zip',
           'Ecom_BillTo_Postal_CountryCode', 'Billing Address Country',
           'Ecom_ShipTo_Postal_Name_First', 'Ship To First Name',
           'Ecom_ShipTo_Postal_Name_Last', 'Ship To Last Name',
           'Ecom_ShipTo_Postal_Street_Line1', 'Shipping Address Street',
           'Ecom_ShipTo_Postal_City', 'Shipping Address City',
           'Ecom_ShipTo_Postal_StateProv', 'Shipping Address State',
           'Ecom_ShipTo_Postal_PostalCode', 'Shipping Address Zip',
           'Ecom_ShipTo_Postal_CountryCode', 'Shipping Address Country',
           'Ecom_BillTo_Telecom_Phone_Number', 'Phone Number',
           'Ecom_BillTo_Online_Email', 'Email',
           'Ecom_Payment_Card_Number', 'Card or Check Number',
           'Ecom_Payment_Card_ExpDate_Month', 'Card Expiration Month',
           'Ecom_Payment_Card_ExpDate_Year', 'Card Expiration Year',
           'Ecom_is_Residential', 'Shipping to Residential Address',
           'Ecom_ShipTo_Insurance', 'Insure this Shipment', # not implemented yet, for the future
           'Ecom_Payment_Card_CVV', 'Card CVV Value',
           'Ecom_tos', 'Sales-Terms of Service');
     
{
  local($mytypes)='credit card';
  if ($sc_allow_pay_by_check =~ /yes/i ) {$mytypes .= "/check";}
  if ($sc_allow_pay_by_PO =~ /yes/i ) {$mytypes .= "/PO";}
  if ($sc_allow_pay_by_mailedcheck =~ /yes/i ) {$mytypes .= "/MailedFunds";}
  $sc_order_form_array{'Ecom_Payment_Card_Type'} = "Payment type ($mytypes)";
 }

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
          "Ecom_Payment_Card_Number");

if ($sc_paid_by_ccard =~ /yes/i) { 
   push(@sc_order_form_required_fields,"Ecom_Payment_Card_ExpDate_Month");
   push(@sc_order_form_required_fields,"Ecom_Payment_Card_ExpDate_Year");

    # CVV optional per Mr. Ed's request.
    # should not be used anymore. users enabling this do so at their own risk.
    if ($sc_offline_enable_cvv =~ /yes/i) {
       push(@sc_order_form_required_fields,"Ecom_Payment_Card_CVV");
    }
 }

# lines for tos added March 18 2006 by Mister Ed
 if ($sc_display_checkout_tos =~ /yes/i) {
    push(@sc_order_form_required_fields,"Ecom_tos");
 }

# use this codehook to change the above arrays for required fields and such
&codehook("Offline_fields_bottom");

}
###############################################################################
sub print_Offline_SubmitPage {

local($invoice_number, $customer_number);
local($myname)="Offline";
local($HREF_FIELDS) = &make_hidden_fields;
my $top_message = '';

if (!($form_data{'gateway'} eq $myname)) { return;} 
&Offline_check_and_load;

$invoice_number = $current_verify_inv_no;
$sc_temp_invoice_number = $invoice_number;
$customer_number = $cart_id;
$customer_number =~ s/_/./g;

print &get_Offline_confirm_middle(*form_data,$invoice_number,
  $customer_number,$offline_ver_tbldef,$top_message,
  $offline_ver_tbldef2,$authPrice,$time);

if ($sc_use_alternate_Offline_submit_page ne "Yes") {
############  Start of Standard submit page - Select from this line to for copy functions ############
#### can use in custom submit page.  Custom file must be named: Offline_custom_processing_lib.pl
#### Custom function (aka sub routine) to replace the code below must be named: Offline_custom_submit_page

print <<ENDOFTEXT;
<div align="center">
<table width="500" cellpadding="5" cellspacing="0" border="0">
<tr>
<td width="50%" align="center">
<form method="post" action="$sc_order_script_url">
<!--Order Financial Data-->
<input type="hidden" name="cart_id" value="$cart_id">
<input type="hidden" name="AMOUNT" value="$formatted_price">
<input type="hidden" name="PLAINAMOUNT" value="$authPrice">
<input type="hidden" name="SUBTOTALAMT" value="$subtotal">
<input type="hidden" name="SHIPPING" value="$zfinal_shipping">
<input type="hidden" name="DISCOUNT" value="$zfinal_discount">
<input type="hidden" name="SALESTAX" value="$zfinal_sales_tax">
<input type="hidden" name="EXTRATAX1" value="$zfinal_extra_tax1">
<input type="hidden" name="EXTRATAX2" value="$zfinal_extra_tax2">
<input type="hidden" name="EXTRATAX3" value="$zfinal_extra_tax3">
ENDOFTEXT

# CVV optional per Mr. Ed's request.
# should not be used anymore. users enabling this do so at their own risk.
if ($sc_offline_enable_cvv =~ /yes/i) {
print <<ENDOFTEXT;
<input type="hidden" name="CVV" value="$eform_data{'Ecom_Payment_Card_CVV'}">
ENDOFTEXT
}


print <<ENDOFTEXT;
<!--Customer/Order Data-->
<input type="hidden" name="CUSTID" value="$customer_number">
<input type="hidden" name="INVOICE" value="$invoice_number">
<input type="hidden" name="DESCRIPTION" value="Online Order">
<!-- tac added to customer order data -->
<INPUT TYPE=HIDDEN NAME="Sales Terms and Refund Policy" VALUE="$eform_data{'Ecom_tos'} $form_data{'Ecom_tos'}">
<!-- misc additions to customer order data -->
<INPUT TYPE=HIDDEN NAME="Ship to Residential Address" VALUE="$eform_data{'Ecom_is_Residential'} $form_data{'Ecom_is_Residential'}">
<INPUT TYPE=HIDDEN NAME="Insure Shipment" VALUE="$eform_data{'Ecom_ShipTo_Insurance'} $form_data{'Ecom_ShipTo_Insurance'}">
<!--Billing Address-->
<input type="hidden" name="NAME" value="$eform_data{'Ecom_BillTo_Postal_Name_First'} $form_data{'Ecom_BillTo_Postal_Name_Last'}">
<input type="hidden" name="ADDRESS" value="$eform_data{'Ecom_BillTo_Postal_Street_Line1'}">
<input type="hidden" name="ADDRESS2" value="$eform_data{'Ecom_BillTo_Postal_Street_Line2'}">
<input type="hidden" name="ADDRESS3" value="$eform_data{'Ecom_BillTo_Postal_Street_Line3'}">
<input type="hidden" name="CITY" value="$eform_data{'Ecom_BillTo_Postal_City'}">
<input type="hidden" name="STATE" value="$eform_data{'Ecom_BillTo_Postal_StateProv'}">
<input type="hidden" name="ZIP" value="$eform_data{'Ecom_BillTo_PostalCode'}">
<input type="hidden" name="COUNTRY" value="$eform_data{'Ecom_BillTo_Postal_CountryCode'}">
<input type="hidden" name="PHONE" value="$eform_data{'Ecom_BillTo_Telecom_Phone_Number'}">
<input type="hidden" name="EMAIL" value="$eform_data{'Ecom_BillTo_Online_Email'}">
<!--Shipping Address-->
<input type="hidden" name="HW2SHIP" value="$eform_data{'Ecom_ShipTo_Method'}">
<input type="hidden" name="SHIPNAME" value="$eform_data{'Ecom_ShipTo_Postal_Name_First'} $eform_data{'Ecom_ShipTo_Postal_Name_Last'}">
<input type="hidden" name="SHIPTOSTREET" value="$eform_data{'Ecom_ShipTo_Postal_Street_Line1'}">
<input type="hidden" name="SHIPTOSTREET2" value="$eform_data{'Ecom_ShipTo_Postal_Street_Line2'}">
<input type="hidden" name="SHIPTOSTREET3" value="$eform_data{'Ecom_ShipTo_Postal_Street_Line3'}">
<input type="hidden" name="SHIPTOCITY" value="$eform_data{'Ecom_ShipTo_Postal_City'}">
<input type="hidden" name="SHIPTOSTATE" value="$eform_data{'Ecom_ShipTo_Postal_StateProv'}">
<input type="hidden" name="SHIPTOZIP" value="$eform_data{'Ecom_ShipTo_Postal_PostalCode'}">
<input type="hidden" name="SHIPTOCOUNTRY" value="$eform_data{'Ecom_ShipTo_Postal_CountryCode'}">
<!--Billing Data-->
<input type="hidden" name="HCODE" value="$sc_pass_used_to_scramble">
ENDOFTEXT

if (($form_data{'Ecom_Payment_Pay_Type'} ne "MailedFunds") || (($form_data{'Ecom_Payment_Pay_Type'} eq "MailedFunds") && ($sc_Offline_mailedfunds_order_button eq "yes"))) {
print <<ENDOFTEXT;
<input type="hidden" name="process_order" value="yes">
<input type="image" name="Submit" value="Submit Order For Processing" 
  src="$offline_picserve?secpicserve=submit_order.gif">
ENDOFTEXT
}

print <<ENDOFTEXT;
</form>
</td>
<td width="50%" align="center">
<form method="post" action="$sc_stepone_order_script_url">
<input type="hidden" name="order_form_button" value="1">
$HREF_FIELDS
<input type="hidden" name="HCODE" VALUE="$sc_pass_used_to_scramble">
<input type="hidden" name="gateway" VALUE="Offline"> 
<input type="hidden" name="ofn" VALUE="Offline"> 
<input type="image" name="Make Changes" value="Make Changes" 
  src="$offline_picserve?secpicserve=make_changes.gif">
</form>
</td>
</tr>
</table>
</div>
ENDOFTEXT

############  End of Submit Page Code - Select until this line for copy functions ############
}
else { # uses alternate processing file in add_ons sub directory

 &codehook("Offline_custom_submit_page");

} # end of alternate submit page
}
###############################################################
sub get_Offline_confirm_middle{
local(*form_data,$invoice_number,$customer_number,
$tbldef,$top_message,$tbldef2,$authPrice,$time) = @_;

my $temp_variable_thingy_for_mailedfunds = "";

&read_verify_file;

local($my_ShipTo_Postal_Street,$my_BillTo_Postal_Street,$formatted_price);
local($answer)='';

$my_ShipTo_Postal_Street = $form_data{'Ecom_ShipTo_Postal_Street_Line1'};
if ($form_data{'Ecom_ShipTo_Postal_Street_Line2'} ne "") {
 $my_ShipTo_Postal_Street .= "<BR>$form_data{'Ecom_ShipTo_Postal_Street_Line2'}";
}
if ($form_data{'Ecom_ShipTo_Postal_Street_Line3'} ne "") {
 $my_ShipTo_Postal_Street .= "<BR>$form_data{'Ecom_ShipTo_Postal_Street_Line3'}";
}

$my_BillTo_Postal_Street = $form_data{'Ecom_BillTo_Postal_Street_Line1'};
if ($form_data{'Ecom_BillTo_Postal_Street_Line2'} ne "") {
 $my_BillTo_Postal_Street .= "<BR>$form_data{'Ecom_BillTo_Postal_Street_Line2'}";
}
if ($form_data{'Ecom_BillTo_Postal_Street_Line3'} ne "") {
 $my_BillTo_Postal_Street .= "<BR>$form_data{'Ecom_BillTo_Postal_Street_Line3'}";
}

$formatted_price = &format_price($authPrice);

my $temp_variable_thingy_for_mailedfunds =  qq~~;

if ($form_data{'Ecom_Payment_Pay_Type'} eq "MailedFunds") {
$temp_variable_thingy_for_mailedfunds =  qq~<p class="ac_checkout_top_msg">$sc_mailedfunds_address</p>~;
}

if ($top_message eq "") {
$top_message = "$sc_offline_verifypage_message";
}

$answer.= <<ENDOFTEXT;

<div align="center">
  <p class="ac_checkout_top_msg">$top_message</p>

$temp_variable_thingy_for_mailedfunds

<table cellpadding="0" cellspacing="0" class="ac_checkout_review">
<tr>
<th colspan="2" class="ac_checkout_review">Customer Information</th>
</tr>

<tr>
<td class="ac_checkout_review_col1">Customer Number</td>
<td class="ac_checkout_review_col2">$cart_id</td>
</tr>

<tr>
<td class="ac_checkout_review_col1">Order Number</td>
<td class="ac_checkout_review_col2">$sc_temp_invoice_number</td>
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
<td class="ac_checkout_review_col2">$my_BillTo_Postal_Street&nbsp;</td>
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
$answer.= <<ENDOFTEXT;
<tr>
<td class="ac_checkout_review_col1">Ship via</td>
<td class="ac_checkout_review_col2">$form_data{'Ecom_ShipTo_Method'}&nbsp;</td>
</tr>
ENDOFTEXT
}

$answer.= <<ENDOFTEXT;
<tr>
<td class="ac_checkout_review_col1">Name</td>
<td class="ac_checkout_review_col2">
  $form_data{'Ecom_ShipTo_Postal_Name_First'} $form_data{'Ecom_ShipTo_Postal_Name_Last'}&nbsp;
</td>
</tr>

<tr>
<td class="ac_checkout_review_col1">Street</td>
<td class="ac_checkout_review_col2">$my_ShipTo_Postal_Street&nbsp;</td>
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
ENDOFTEXT


if (($form_data{'Ecom_Payment_Pay_Type'} =~ /MailedFunds/) && ($XCOMMENTS ne '')) {
$XCOMMENTS =~ s/\n/\<br\>/g;
$answer.= <<ENDOFTEXT;
<tr>
<th colspan="2" class="ac_checkout_review">Misc Information </th>
</tr>
<tr>
<td class="ac_checkout_review_col1" colspan="2">$XCOMMENTS</td>
</tr>
ENDOFTEXT
}


$answer.= <<ENDOFTEXT;
</table>
</div>
ENDOFTEXT

# use this to change $answer
&codehook("get_Offline_confirm_middle_bottom");

return $answer;
}
###############################################################
# CSS Changes NOT COMPLETE
sub process_Offline_Order {
local($subtotal, $total_quantity,
      $total_measured_quantity,
      $text_of_cart, $weight,
      $required_fields_filled_in, $product, $quantity, $options,
      $text_of_confirm_email, $text_of_admin_email, $emailCCnum, $logCCnum);
local($stevo_shipping_thing) = "";
local($stevo_shipping_names) = "";
local($order_ok_final_msg,$order_ok_final_msg_tbl);
local($ship_thing_too,$ship_instructions,$TEMP,$temp,$pass); 
local(%orderLoggingHash);

# First, we output the header of
# the processing of the order
    
$orderDate = &get_date;

# NEW CODEHOOK
&codehook("process-order-routine-top");

print qq~$sc_doctype
<html>
<head>
  <title>$messages{'ordcnf_08'}</title>
~;
  $sc_ssl_location_url2 ne '' ? print $sc_secure_standard_head_info : print $sc_standard_head_info;
print qq~
  $sc_special_page_meta_tags
</head>
<body>
~;


if ($sc_use_alternate_Offline_order_processing ne "Yes") {
############  Start of Standard Processing Code - Select from this line to for copy functions ############
#### can use in custom processing file.  Custom file must be named: Offline_custom_processing_lib.pl
#### Place Offline_custom_processing_lib.pl in the library directory of your store
#### Custom function (aka sub routine)  to replace the code below must be named: Offline_custom_processing_function

$text_of_cart .= "Order Date:    $orderDate\n";
$text_of_cart .= "Gateway:       Offline\n\n";
$orderLoggingHash{'GatewayUsed'} = "Offline";

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
  $options =~ s/$sc_opt_sep_marker/, /g;
  $text_of_cart .= &cart_textinfo(*cart_fields);
  $stevo_shipping_thing .="|$quantity\*$weight";
  $stevo_shipping_names .="|$product\($options\)";
        &codehook("process-cart-item");
  }
close(CART);

# Now let's check the _VERIFY file, just to be sure ...
if (!(-f "$sc_verify_order_path")){
&SecureStoreHeader;
print <<ENDOFTEXT;
<div align="center">
  <p class="ac_error">
    $messages{'ordcnf_03'}
  </p>
  <p>$messages{'ordcnf_02'}</p>
</div>
ENDOFTEXT

# and the footer is printed

&SecureStoreFooter;

print qq!
</body>
</html>
!;

&call_exit;

 }

&load_verify_file;

if ($sc_Offline_show_table =~ /yes/i) {
  $order_ok_final_msg = $messages{'ordcnf_09'};
  if ($order_ok_final_msg eq '') {
   # Default so something is there, use $messages{'ordcnf_09'} though 
   # to customize, set it in the Free Form Logic (either location.)
    $order_ok_final_msg = $messages{'ordcnf_01'};
    $order_ok_final_msg .= "Print this page for your records.  You will ";
    $order_ok_final_msg .= "receive an email receipt shortly./n";
   }
  $order_ok_final_msg = '<br><p align="center">' . $order_ok_final_msg . "</p>\n";
  
  $special_message = $order_ok_final_msg;
  { local(%form_data) = %vform;
    local($sc_use_verify_values_for_display) = "yes";
    &display_cart_table("verify");
  }
 } else {
  &SecureStoreHeader;
 }

# All our answers are stored in the verify file now, so load them!
if ($sc_scramble_cc_info =~ /yes/i ) {
  $vform{'Ecom_Payment_Orig_Card_Number'} = 
   $vform_Ecom_Payment_Orig_Card_Number;
  $vform{'Ecom_Payment_Card_Number'} =
   $vform_Ecom_Payment_Card_Number;
  $vform{'Ecom_Payment_BankAcct_Number'} = 
   $vform_Ecom_Payment_BankAcct_Number;
  $vform{'Ecom_Payment_BankRoute_Number'} = 
   $vform_Ecom_Payment_BankRoute_Number; 
  $vform{'Ecom_Payment_Bank_Name'} = 
   $vform_Ecom_Payment_Bank_Name; 
 }
foreach $inx (keys %vform) {
  $form_data{$inx} = $vform{$inx};
 }
# and do special processing as required
&Offline_response_prep;

# re-create the old-style order confirmation form variables
$form_data{'METHOD'} = $form_data{'Ecom_Payment_Card_Type'};
$form_data{'CARDNUM'} = $form_data{'Ecom_Payment_Card_Number'};
$form_data{'CARDNUM'} =~ s/\ \ /\ /g; 
$form_data{'CARDNUM'} =~ s/\ \ /\ /g; 
$form_data{'EXPDATE'} = 
"Month: $vform_Ecom_Payment_Card_ExpDate_Month " .
"Year: $vform_Ecom_Payment_Card_ExpDate_Year";
$my_EXPDATE = $form_data{'EXPDATE'};

if ($vform_Ecom_Payment_Pay_Type eq 'PO') {
  $emailMETHOD = $form_data{'METHOD'};
  $form_data{'CARDNUM'} = $vform_Ecom_Payment_PO_Number;
  $emailCCnum = $form_data{'CARDNUM'};
  $logCCnum = $form_data{'CARDNUM'};
 } elsif ($vform_Ecom_Payment_Pay_Type eq 'MailedFunds') {
  $emailMETHOD = $form_data{'METHOD'};
  $form_data{'CARDNUM'} = $vform_Ecom_Payment_PO_Number;
  $emailCCnum = $form_data{'CARDNUM'};
  $logCCnum = $form_data{'CARDNUM'};
 } else { # Check or CC
  if ($sc_use_pgp =~ /yes/i) { #assume using secure access if using PGP
    $emailMETHOD = $form_data{'METHOD'};
    $emailCCnum = $form_data{'CARDNUM'};
    $logCCnum = $form_data{'CARDNUM'};
  } else {
    $emailMETHOD = "XXXX";
    $emailCCnum = "XXXXXXXX";
    $emailCCnum .= substr($form_data{'CARDNUM'},8,65);
    $logCCnum = substr($form_data{'CARDNUM'},0,8);
    $logCCnum .= "XXXXXXXX";
  }
}

$verify_error = "";

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
$orderLoggingHash{'shiptoResidential'} = $form_data{'Ecom_is_Residential'};
$orderLoggingHash{'insureShipment'} = $form_data{'Ecom_ShipTo_Insurance'}; # not implemented yet, for the future

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
if ($sc_orderlib_use_SBW_for_ship_ins =~ /yes/i)
{
($ship_thing_too,$ship_instructions) = 
 &ship_put_in_boxes($stevo_shipping_thing,$stevo_shipping_names,
 $sc_verify_Origin_ZIP,$sc_verify_boxes_max_wt); 
}
$orderLoggingHash{'shippingMessages'} = "$ship_instructions";
$orderLoggingHash{'shippingMessages'} =~ s/\n/<br>/g;

$test_shipping = $form_data{'SHIPPING'};
$test_shipping =~ s/[^0-9\.]//g;
if (!($sc_verify_shipping == $test_shipping)){
  $verify_error .= "  Could not verify Shipping Cost" . "\n";
 }
$test = $form_data{'DISCOUNT'};
$test =~ s/[^0-9\.]//g;
if (!($sc_verify_discount == $test)){
  $verify_error .= "  Could not verify Discount Amount\n";
 }
$test = $form_data{'SALESTAX'};
$test =~ s/[^0-9\.]//g;
if (!($sc_verify_tax == $test)){
  $verify_error .= "  Could not verify Sales Tax\n";
 }

$running_total = $form_data{'PLAINAMOUNT'};
#$running_total =~ s/[^\d\.]//g;# strip off non numeric stuff

if (!((0+$sc_verify_grand_total) == (0+$running_total))){
  $verify_error .= "  Could not verify order Total Amount\n";
  $verify_error .= "  expected: $sc_verify_grand_total\n";
  $verify_error .= "  observed: $running_total\n";
 }
if ($verify_error ne ""){
  $text_of_cart .= "** NOTE: Automatic verification not possible, this order\n" .
  "will be manually verified.  Reason automatic verification\n" . 
  "was not possible:\n" . $verify_error . "\n";
 }

# Compile confirmation emails to customer, admin and order logs
$text_of_confirm_email .= $messages{'ordcnf_07'};
$text_of_confirm_email .= $text_of_cart;
$text_of_confirm_email .= "\n";
$text_of_cart .= "  --ORDER INFORMATION--\n\n";

$text_of_cart .= "CUSTID:        $form_data{'CUSTID'}\n";
$text_of_admin_email .= "CUSTID:        $form_data{'CUSTID'}\n";
$orderLoggingHash{'customerNumber'} = "$form_data{'CUSTID'}";

$text_of_cart .= "INVOICE:       $form_data{'INVOICE'}\n";
$text_of_confirm_email .= "INVOICE:       $form_data{'INVOICE'}\n";
$sc_temp_invoice_number = $form_data{'INVOICE'};
$orderLoggingHash{'invoiceNumber'} = "$form_data{'INVOICE'}";

# lines for tos added March 18 2006 by Mister Ed
if ($sc_display_checkout_tos =~ /yes/i) {
$text_of_cart .= "SALES TERMS AND REFUND POLICY:       $form_data{'Ecom_tos'}\n";
$text_of_confirm_email .= "Sales Terms and Refund Policy:       $form_data{'Ecom_tos'}\n";
$orderLoggingHash{'termsOfService'} = "$form_data{'Ecom_tos'}";
}

$temp = &display_price($sc_verify_subtotal);
$text_of_cart .= "SUBTOTAL:      $temp\n";
$text_of_confirm_email .= "SUBTOTAL:      $temp\n";
$sc_verify_subtotal_temp3 = $temp;
$orderLoggingHash{'subTotal'} = &format_price($sc_verify_subtotal);

if (($sc_buySafe_is_enabled =~ /yes/) && ($sc_verify_buySafe > 0)) {
my $temp = &format_price($sc_verify_buySafe);
$text_of_cart .= "$sc_buySafe_bond_fee_mini_display_text       $temp\n";
$text_of_confirm_email .= "$sc_verify_buySafe_display_text       $temp\n";
$orderLoggingHash{'buySafe'} = "$temp";
}

if ($form_data{'SHIPPING'})
{
$temp = &display_price($form_data{'SHIPPING'});
$text_of_cart .= "SHIPPING:      $temp\n";
$text_of_confirm_email .= "SHIPPING:      $temp\n";
$orderLoggingHash{'shippingTotal'} = &format_price($form_data{'SHIPPING'});
}

$orderLoggingHash{'shipMethod'} = "$vform_Ecom_ShipTo_Method";
$text_of_admin_email = "SHIP VIA:      $vform_Ecom_ShipTo_Method";

if (($sc_use_SBW =~ /yes/i) || ($form_data{'x_Freight'} > .009)) {
 $text_of_confirm_email .= "SHIP VIA:      $vform_Ecom_ShipTo_Method\n";
}

if ($form_data{'DISCOUNT'})
{
  $temp = &display_price($form_data{'DISCOUNT'});
  $text_of_cart .= "DISCOUNT:      $temp\n";
  $text_of_confirm_email .= "DISCOUNT:      $temp\n";
  $orderLoggingHash{'discounts'} = &format_price($form_data{'DISCOUNT'});
}

if ($form_data{'SALESTAX'})
{
  $temp = &display_price($form_data{'SALESTAX'});
  $text_of_cart .= "SALES TAX:     $temp\n";
  $text_of_confirm_email .= "SALES TAX:     $temp\n";
  $orderLoggingHash{'salesTax'} = &format_price($form_data{'SALESTAX'});
}

if ($form_data{'EXTRATAX1'})
{
  $temp = substr(substr($sc_extra_tax1_name,0,13).":               ",0,15);
  $text_of_cart .= "$temp$form_data{'EXTRATAX1'}\n";
  $text_of_confirm_email .= "$temp$form_data{'EXTRATAX1'}\n";
  $orderLoggingHash{'tax1'} = "$temp$form_data{'EXTRATAX1'}";
}

if ($form_data{'EXTRATAX2'})
{
  $temp = substr(substr($sc_extra_tax2_name,0,13).":               ",0,15);
  $text_of_cart .= "$temp$form_data{'EXTRATAX2'}\n";
  $text_of_confirm_email .= "$temp$form_data{'EXTRATAX2'}\n";
  $orderLoggingHash{'tax2'} = "$temp$form_data{'EXTRATAX2'}";
}

if ($form_data{'EXTRATAX3'})
{
  $temp = substr(substr($sc_extra_tax3_name,0,13).":               ",0,15);
  $text_of_cart .= "$temp$form_data{'EXTRATAX3'}\n";
  $text_of_confirm_email .= "$temp$form_data{'EXTRATAX3'}\n";
  $orderLoggingHash{'tax3'} = "$temp$form_data{'EXTRATAX3'}";
}

$temp = &display_price($sc_verify_grand_total);

$text_of_cart .= "TOTAL:         $temp\n";
$text_of_confirm_email .= "TOTAL:         $temp\n\n";
$orderLoggingHash{'orderTotal'} = &format_price($sc_verify_grand_total);

$text_of_admin_email = $text_of_cart;

$text_of_cart .= "METHOD:        $form_data{'METHOD'}\n";
$text_of_admin_email .= "METHOD:        $emailMETHOD\n";

$text_of_cart .= "NUMBER:        $logCCnum\n";
$text_of_admin_email .= "NUMBER:        $emailCCnum\n";

if ($sc_verify_paid_by_ccard =~ /yes/i) {
    $text_of_cart .= "EXP:           $my_EXPDATE\n";
    $text_of_admin_email .= "EXP:           $form_data{'EXPDATE'}\n";
}

# CVV optional per Mr. Ed's request.
# should not be used anymore. users enabling this do so at their own risk.
if (($sc_offline_enable_cvv =~ /yes/i) && ($form_data{'Ecom_Payment_Card_CVV'} ne "")) {
    $text_of_cart .= "CVV2:           $form_data{'Ecom_Payment_Card_CVV'}\n";
     $text_of_admin_email .= "CVV2:           $form_data{'Ecom_Payment_Card_CVV'}\n";
}


$text_of_cart .= "DESCRIPTION:   $form_data{'DESCRIPTION'}\n\n";
$text_of_admin_email .= "DESCRIPTION:   $form_data{'DESCRIPTION'}\n\n";

$text_of_cart .= "BILLING INFORMATION --------------\n\n";
$text_of_admin_email .= "BILLING INFORMATION --------------\n\n";

$text_of_cart .= "NAME:          $form_data{'NAME'}\n";
$text_of_admin_email .= "NAME:          $form_data{'NAME'}\n";
$orderLoggingHash{'fullName'} = "$form_data{'NAME'}";

$text_of_cart .= "ADDRESS:       $form_data{'ADDRESS'}\n";
$text_of_admin_email .= "ADDRESS:       $form_data{'ADDRESS'}\n";
$orderLoggingHash{'orderFromAddress'} = "$form_data{'ADDRESS'}";

if ($form_data{'ADDRESS2'} ne "") {
  $text_of_cart .= "               $form_data{'ADDRESS2'}\n";
  $text_of_admin_email .= "               $form_data{'ADDRESS2'}\n";
$orderLoggingHash{'customerAddress2'} = "$form_data{'ADDRESS2'}";
 }

if ($form_data{'ADDRESS3'} ne "") {
  $text_of_cart .= "               $form_data{'ADDRESS3'}\n";
  $text_of_admin_email .= "               $form_data{'ADDRESS3'}\n";
$orderLoggingHash{'customerAddress3'} = "$form_data{'ADDRESS3'}";
 }

$text_of_cart .= "CITY:          $form_data{'CITY'}\n";
$text_of_admin_email .= "CITY:          $form_data{'CITY'}\n";
$orderLoggingHash{'orderFromCity'} = "$form_data{'CITY'}";

$text_of_cart .= "STATE:         $form_data{'STATE'}\n";
$text_of_admin_email .= "STATE:         $form_data{'STATE'}\n";
$orderLoggingHash{'orderFromState'} = "$form_data{'STATE'}";

$text_of_cart .= "ZIP:           $form_data{'ZIP'}\n";
$text_of_admin_email .= "ZIP:           $form_data{'ZIP'}\n";
$orderLoggingHash{'orderFromPostal'} = "$form_data{'ZIP'}";

$text_of_cart .= "COUNTRY:       $form_data{'COUNTRY'}\n";
$text_of_admin_email .= "COUNTRY:       $form_data{'COUNTRY'}\n";
$orderLoggingHash{'orderFromCountry'} = "$form_data{'COUNTRY'}";

$text_of_cart .= "PHONE:         $form_data{'PHONE'}\n";
$text_of_admin_email .= "PHONE:         $form_data{'PHONE'}\n";
$orderLoggingHash{'customerPhone'} = "$form_data{'PHONE'}";

$text_of_cart .= "EMAIL:         $form_data{'EMAIL'}\n\n";
$text_of_admin_email .= "EMAIL:         $form_data{'EMAIL'}\n\n";
$orderLoggingHash{'emailAddress'} = "$form_data{'EMAIL'}";

$text_of_cart .= "SHIPPING INFORMATION --------------\n\n";
$text_of_admin_email .= "SHIPPING INFORMATION --------------\n\n";

$text_of_cart .= "SHIP VIA:      $form_data{'HW2SHIP'}\n";
$text_of_admin_email .= "SHIP VIA:      $form_data{'HW2SHIP'}\n";

$text_of_cart .= "NAME:          $form_data{'SHIPNAME'}\n";
$text_of_admin_email .= "NAME:          $form_data{'SHIPNAME'}\n";
$orderLoggingHash{'shipToName'} = "$form_data{'SHIPNAME'}";

$text_of_cart .= "ADDRESS:       $form_data{'SHIPTOSTREET'}\n";
$text_of_admin_email .= "ADDRESS:       $form_data{'SHIPTOSTREET'}\n";
$orderLoggingHash{'shipToAddress'} = "$form_data{'SHIPTOSTREET'}";

if ($form_data{'SHIPTOSTREET2'} ne "") {
  $text_of_cart .= "               $form_data{'SHIPTOSTREET2'}\n";
  $text_of_admin_email .= "               $form_data{'SHIPTOSTREET2'}\n";
$orderLoggingHash{'shipToAddress2'} = "$form_data{'SHIPTOSTREET2'}";
 }

if ($form_data{'SHIPTOSTREET3'} ne "") {
  $text_of_cart .= "               $form_data{'SHIPTOSTREET3'}\n";
  $text_of_admin_email .= "               $form_data{'SHIPTOSTREET3'}\n";
$orderLoggingHash{'shipToAddress3'} = "$form_data{'SHIPTOSTREET3'}";
 }

$text_of_cart .= "CITY:          $form_data{'SHIPTOCITY'}\n";
$text_of_admin_email .= "CITY:          $form_data{'SHIPTOCITY'}\n";
$orderLoggingHash{'shipToCity'} = "$form_data{'SHIPTOCITY'}";

$text_of_cart .= "STATE:         $form_data{'SHIPTOSTATE'}\n";
$text_of_admin_email .= "STATE:         $form_data{'SHIPTOSTATE'}\n";
$orderLoggingHash{'shipToState'} = "$form_data{'SHIPTOSTATE'}";

$text_of_cart .= "ZIP:           $form_data{'SHIPTOZIP'}\n";
$text_of_admin_email .= "ZIP:           $form_data{'SHIPTOZIP'}\n";
$orderLoggingHash{'shipToPostal'} = "$form_data{'SHIPTOZIP'}";

$text_of_cart .= "COUNTRY:       $form_data{'SHIPTOCOUNTRY'}\n\n";
$text_of_admin_email .= "COUNTRY:       $form_data{'SHIPTOCOUNTRY'}\n\n";
$orderLoggingHash{'shipToCountry'} = "$form_data{'SHIPTOCOUNTRY'}";

# NEW CODEHOOK
&codehook("process-order-pre-ship-instructions");

if ($ship_instructions ne "") {
  $text_of_cart .= "Shipping Instructions: \n$ship_instructions\n\n"; 
  $text_of_admin_email .= "Shipping Instructions:\n$ship_instructions\n\n"; 
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

# 'Init' the emails ...
$temp = &init_shop_keep_email;
$text_of_cart = $temp . $text_of_cart;
$text_of_admin_email = $temp . $text_of_admin_email;
$text_of_confirm_email = &init_customer_email . $text_of_confirm_email;

# Add any other info ...
$temp = &addto_shop_keep_email;
$text_of_cart .= $temp;
$text_of_admin_email .= $temp;
$text_of_confirm_email .= &addto_customer_email;

if ($sc_use_pgp =~ /yes/i)
{
&require_supporting_libraries(__FILE__, __LINE__, "$sc_pgp_lib_path");
$text_of_cart = &make_pgp_file($text_of_cart, "$sc_pgp_temp_file_path/$$.pgp");
$text_of_cart = "\n" . $text_of_cart . "\n";

$text_of_admin_email = &make_pgp_file($text_of_admin_email, "$sc_pgp_temp_file_path/$$.pgp");
$text_of_admin_email = "\n" . $text_of_admin_email . "\n";
}

# added by Mister Ed for Pro version Feb 7, 2007
my $temp_admin_email = "$sc_admin_email";
if ($sc_use_customer_email_over_admin =~ /yes/i) {
   $temp_admin_email = "$form_data{'EMAIL'}";
}

# send email to admin or order email addy listed in main settings of manager
if ($sc_send_order_to_email =~ /yes/i)
{
&send_mail($temp_admin_email, $sc_order_email, "AgoraCart - Online Order - $form_data{'INVOICE'}",$text_of_admin_email);
}

# NEW CODEHOOK
&codehook("process-order-pre-logOrder");

# write order log
&log_order($text_of_cart,$form_data{'INVOICE'},$form_data{'CUSTID'});

# send confirmation email to customer if they input email address
if (($cartData) && ($form_data{'EMAIL'} ne ""))
{
&send_mail($sc_admin_email, $form_data{'EMAIL'},$messages{'ordcnf_08'},
           "$text_of_confirm_email");
}


# show order receipt page if selected in offline settings
if ($sc_Offline_show_table =~ /yes/i) {
  $order_ok_final_msg_tbl = $messages{'ordcnf_10'}; 
  if ($order_ok_final_msg_tbl eq '') {
   # Default so something is there, use $messages{'ordcnf_10'} though 
   # to customize, set it in the Free Form Logic (either location.)
    $order_ok_final_msg_tbl = "<b>Order Confirmation</b><br/><br/>" . &get_date;
   }
  $temp = 
    &get_Offline_confirm_middle(*form_data,$invoice_number,
    $customer_number,$offline_ver_tbldef,$order_ok_final_msg_tbl,
    $offline_ver_tbldef2,$authPrice,$time) . "<br>\n";
 } else {
  $temp = $messages{'ordcnf_01'};
 }

# set affiliate program variables for such things as image calls
$sc_affiliate_order_unique = $form_data{'INVOICE'};
$sc_affiliate_order_total = $sc_verify_subtotal - $sc_verify_discount;

$sc_affiliate_image_call =~ s/AMOUNT/$sc_affiliate_order_total/g;
$sc_affiliate_image_call =~ s/UNIQUE/$sc_affiliate_order_unique/g;

# NEW CODEHOOK
&codehook("process-order-display-thankyou-page");

print <<ENDOFTEXT;
<div align="center">
$temp 
<p>
  $messages{'ordcnf_02'}
</p>
<p>
  $sc_affiliate_image_call
</p>
</div>
ENDOFTEXT

# This empties the cart after the order is successful
&empty_cart;
undef(%form_data);

# and the footer is printed
&SecureStoreFooter;

print qq!
</body>
</html>
!;
############  End of Standard Processing Code - Select until this line for copy functions ############
}
else { # uses alternate processing file in add_ons sub directory

 &codehook("Offline_custom_processing_function");

} # end of alternate processing
}  # End of process_order_form

#################################################################

1; # Library
