#######################################################################
#                    Order Form Definition Variables                  #
#######################################################################

# Module Last Updated: May 2, 2006
# mashed up by PNP technical staff
# (SPK added $sc_special_page_meta_tags var on 03/12/2002)
# updated for new PNP variables Feb 2006 by Michael Lehmann from PNP
# v5 conversions by Justin Findlay from AgoraScript / K-Factor Technologies, Inc. April 2006
# Misc updates and fixes by Mister Ed from AgoraScript / K-Factor Technologies, Inc., May 3, 2006
# Major fixes by Mister Ed from AgoraScript / K-Factor Technologies, Inc., May 5, 2006

$versions{'PlugnPay-order_lib.pl'} = "5.5.000";

$sc_order_response_vars{"PlugnPay"}="FinalStatus";
$sc_use_secure_header_at_checkout = 'yes';

&add_codehook("printSubmitPage","print_PlugnPay_SubmitPage");
&add_codehook("set_form_required_fields","PlugnPay_fields");
&add_codehook("gateway_response","check_for_PlugnPay_response");
&add_codehook("special_navigation","check_for_PlugnPay_response");

###############################################################################
sub check_for_PlugnPay_response {
  if ($form_data{'FinalStatus'} eq "success") {
    $cart_id = $form_data{'customer_number'};
    &set_sc_cart_path;
    &load_order_lib;
    &codehook("PlugnPay_order");
    &process_PlugnPay_Order;
    &call_exit;
  }
}
###############################################################################
sub PlugnPay_check_and_load {
local($myname)="PlugnPay";
if ($myname ne $sc_gateway_name) { # we are a secondary gateway, load settings
  &require_supporting_libraries(__FILE__,__LINE__,
     "./admin_files/$myname-user_lib.pl");
 }

}
###############################################################################
sub PlugnPay_order_form_prep { # load the customer info ...
  &PlugnPay_check_and_load;
  if ($sc_PlugnPay_form_prep == 0) {
    if (-f "$sc_verify_order_path"){
      &read_verify_file;
    }
    else {
      &codehook("load_customer_info");
    }
    $sc_PlugnPay_form_prep = 1;
  }
  return "";
}
###############################################################################
sub PlugnPay_fields {

local($myname) = "PlugnPay";

if (!($form_data{'gateway'} eq $myname)) { return; } 

  %sc_order_form_array = (
    'Ecom_BillTo_Postal_Name_First',    'First Name',
    'Ecom_BillTo_Postal_Name_Last',     'Last Name',
    'Ecom_BillTo_Postal_Street_Line1',  'Billing Address Street',
    'Ecom_BillTo_Postal_City',          'Billing Address City',
    'Ecom_BillTo_Postal_StateProv',     'Billing Address State',
    'Ecom_BillTo_PostalCode',           'Billing Address Zip',
    'Ecom_BillTo_Postal_CountryCode',   'Billing Address Country',
    'Ecom_ShipTo_Postal_Street_Line1',  'Shipping Address Street',
    'Ecom_ShipTo_Postal_City',          'Shipping Address City',
    'Ecom_ShipTo_Postal_StateProv',     'Shipping Address State',
    'Ecom_ShipTo_Postal_PostalCode',    'Shipping Address Zip',
    'Ecom_ShipTo_Postal_CountryCode',   'Shipping Address Country',
    'Ecom_BillTo_Telecom_Phone_Number', 'Phone Number',
    'Ecom_BillTo_Online_Email',         'Email',
    'Ecom_Payment_Card_Type',           'Type of Card',
    'Ecom_Payment_Card_Number',         'Card Number',
    'Ecom_Payment_Card_ExpDate_Month',  'Card Expiration Month',
    'Ecom_Payment_Card_ExpDate_Day',    'Card Expiration Day',
    'Ecom_Payment_Card_ExpDate_Year',   'Card Expiration Year',
    'Ecom_is_Residential',              'Shipping to Residential Address',
    'Ecom_ShipTo_Insurance',            'Insure this Shipment', # not implemented yet, for the future
    'Ecom_tos',                         'Sales-Terms of Service'
  );

  @sc_order_form_required_fields = (
    "Ecom_ShipTo_Postal_StateProv",
    "Ecom_ShipTo_Postal_PostalCode"
  );

 if ($sc_display_checkout_tos =~ /yes/i) {
    push(@sc_order_form_required_fields,"Ecom_tos");
 }

# use this codehook to change the above arrays for required fields and such
&codehook("PlugnPay_fields_bottom");

}
###############################################################################
sub PlugnPay_verification_table {
  local ($rslt) = "";

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
&codehook("PlugnPay_verification_table_bottom");

  return $rslt;
}
###############################################################################
sub pnp_table_setup {

  local (@my_cart_fields,$my_cart_row_number,$result);
  local ($count,$price,$product_id,$quantity,$total_cost,$total_qty)=0;
  local ($name,$cost);

  $pnp_prod_in_cart = '';
  $pnp_cart_table = '';
  $result = '';

  open (CART, "$sc_cart_path") || &file_open_error("$sc_cart_path", "display_cart_contents_in_header", __FILE__, __LINE__);
  while (<CART>) {
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
      $result .= "<TABLE CELLPADDING=0 CELLSPACING=0 BORDER=0 WIDTH=425>\n";
      $result .= "  <TR>\n";
      $result .= "    <TD>Items Ordered:</TD>\n";
      $result .= "  </TR>\n";
      $result .= "  <TR>\n";
      $result .= "    <TD>\n";
      $result .= "      <TABLE CELLPADDING=3 CELLSPACING=0 BORDER=1 WIDTH='100%'>\n";
      $result .= "        <TR>\n";
      $result .= "          <TH>QTY</TH>\n";
      $result .= "          <TH>ID #</TH>\n";
      $result .= "          <TH>Description</TH>\n";
      $result .= "          <TH>Cost</TH>\n";
      $result .= "        </TR>\n";
      $pnp_prod_in_cart .= "  --PRODUCT INFORMATION--\n\n";
    }
    $result .= "        <TR>\n";
    $result .= "          <TD>$quantity</TD>\n";
    $result .= "          <TD>$product_id</TD>\n";
    $result .= "          <TD>$name</TD>\n";
    $result .= "          <TD>$cost</TD>\n";
    $result .= "        </TR>\n";
    $pnp_prod_in_cart .= &cart_textinfo(*my_cart_fields);
  } # End of while (<CART>)
  close (CART);
  if ($result ne '') {
    $result .= "      </TABLE>\n";
    $result .= "    </TD>\n";
    $result .= "  </TR>\n";
    $result .= "</TABLE>\n";
  }
  $pnp_cart_table = $result;
}

###############################################################################
sub print_PlugnPay_SubmitPage {

local($invoice_number, $customer_number);
local($test_mode,$mytable);
local($myname) = "PlugnPay";
local($my_change,$my_submit,$my_message,$my_desc);

my ($countthingy);

if (!($form_data{'gateway'} eq $myname)) { return; } 

if ($myname ne $sc_gateway_name) { # secondary gateway, load settings
  &require_supporting_libraries(__FILE__,__LINE__, "./admin_files/$myname-user_lib.pl");
}

&codehook("PlugnPay-SubmitPage-top");

$my_submit = &script_and_substitute($sc_plugnpay_submit);
$my_change = &script_and_substitute($sc_plugnpay_change);
$my_message = &script_and_substitute($sc_plugnpay_verify_message);
$my_desc = &script_and_substitute($sc_plugnpay_order_desc);
$mytable = &PlugnPay_verification_table;

if ($merchant_live_mode =~ /yes/i){
  $test_mode = "";
}
else {
  $test_mode .= "<!-- Prefilled Billing Info -->\n";
  $test_mode .= "<INPUT TYPE=HIDDEN NAME=card-name VALUE=\"pnptest\">\n";
  $test_mode .= "<INPUT TYPE=HIDDEN NAME=card-address1 VALUE=\"123 Test Street\">\n";
  $test_mode .= "<INPUT TYPE=HIDDEN NAME=card-address2 VALUE=\"Apt. 1A\">\n";
  $test_mode .= "<INPUT TYPE=HIDDEN NAME=card-city VALUE=\"Test City\">\n";
  $test_mode .= "<INPUT TYPE=HIDDEN NAME=card-state VALUE=\"NY\">\n";
  $test_mode .= "<INPUT TYPE=HIDDEN NAME=card-zip VALUE=\"12345\">\n";
  $test_mode .= "<INPUT TYPE=HIDDEN NAME=card-prov VALUE=\"Test\">\n";
  $test_mode .= "<INPUT TYPE=HIDDEN NAME=card-country VALUE=\"US\">\n";
  $test_mode .= "<!-- Prefilled Shipping Info -->\n";
  $test_mode .= "<INPUT TYPE=HIDDEN NAME=shipname VALUE=\"pnptest\">\n";
  $test_mode .= "<INPUT TYPE=HIDDEN NAME=address1 VALUE=\"123 Test Street\">\n";
  $test_mode .= "<INPUT TYPE=HIDDEN NAME=address2 VALUE=\"Apt. 1A\">\n";
  $test_mode .= "<INPUT TYPE=HIDDEN NAME=city VALUE=\"Test City\">\n";
  $test_mode .= "<INPUT TYPE=HIDDEN NAME=state VALUE=\"NY\">\n";
  $test_mode .= "<INPUT TYPE=HIDDEN NAME=zip VALUE=\"12345\">\n";
  $test_mode .= "<INPUT TYPE=HIDDEN NAME=province VALUE=\"Test\">\n";
  $test_mode .= "<INPUT TYPE=HIDDEN NAME=country VALUE=\"US\">\n";
  $test_mode .= "<!-- Prefilled Other Fields -->\n";
  $test_mode .= "<INPUT TYPE=HIDDEN NAME=email VALUE=\"trash\@plugnpay.com\">\n";
  $test_mode .= "<INPUT TYPE=HIDDEN NAME=phone VALUE=\"555-555-5555\">\n";
  $test_mode .= "<INPUT TYPE=HIDDEN NAME=fax VALUE=\"666-666-6666\">\n";
  $test_mode .= "<INPUT TYPE=HIDDEN NAME=card-type VALUE=\"visa\">\n";
  $test_mode .= "<INPUT TYPE=HIDDEN NAME=card-number VALUE=\"4111111111111111\">\n";
}

$invoice_number = $current_verify_inv_no;
$customer_number = $form_data{'cart_id'};

# created by PNP staff ... but taken back out as it kills the cart on return - by Mister Ed
#$customer_number =~ s/_/./g;

&pnp_table_setup;

# my $pnp_temp_price = ($authPrice - $zfinal_discount);

&codehook("PlugnPay-SubmitPage-print");

if ($sc_use_alternate_PlugnPay_submit_page ne "Yes") {
############  Start of Standard submit page - Select from this line to for copy functions ############
#### can use in custom submit page.  Custom file must be named: PlugnPay_custom_processing_lib.pl
#### Custom function (aka sub routine) to replace the code below must be named: PlugnPay_custom_submit_page

# SHOW PNP FORM FIELDS HERE
print <<ENDOFTEXT;

<FORM METHOD=POST ACTION=\"https://pay1.plugnpay.com/payment/pay.cgi\">
<!-- Required Settings -->
<INPUT TYPE=HIDDEN NAME=publisher-name VALUE=\"$sc_gateway_username\">
<INPUT TYPE=HIDDEN NAME=publisher-email VALUE=\"$sc_gateway_email\">
<INPUT TYPE=HIDDEN NAME=card-allowed VALUE=\"$sc_gateway_card_allowed\">
<INPUT TYPE=HIDDEN NAME=card-amount VALUE=\"$authPrice\">
ENDOFTEXT

print "<!-- Email Settings -->\n";

if ($sc_gateway_cc_mail ne "") {
  print "<INPUT TYPE=HIDDEN NAME=cc-mail VALUE=\"$sc_gateway_cc_mail\">\n";
}

if ($sc_gateway_subject ne "") {
  print "<INPUT TYPE=HIDDEN NAME=subject VALUE=\"$sc_gateway_subject\">\n";
}

if ($sc_gateway_message ne "") {
  print "<INPUT TYPE=HIDDEN NAME=message VALUE=\"$sc_gateway_message\">\n";
}

if ($sc_gateway_subject_email ne "") {
  print "<INPUT TYPE=HIDDEN NAME=subject-email VALUE=\"$sc_gateway_subject_email\">\n";
}

if ($sc_gateway_dontsendmail ne "yes") {
  print "<INPUT TYPE=HIDDEN NAME=dontsendmail VALUE=\"yes\">\n";
}

print "<!-- Misc Settings -->\n";

if ($sc_gateway_avs_level ne "") {
  print "<INPUT TYPE=HIDDEN NAME=app-level VALUE=\"$sc_gateway_avs_level\">\n";
}

if ($zfinal_sales_tax ne "") {
  print "<INPUT TYPE=HIDDEN NAME=tax VALUE=\"$zfinal_sales_tax\">\n";
}

if ($invoice_number ne "") {
  print "<INPUT TYPE=HIDDEN NAME=order-id VALUE=\"$invoice_number\">\n";
}

if ($customer_number ne "") {
  print "<INPUT TYPE=HIDDEN NAME=customer_number VALUE=\"$customer_number\">\n";
}

if ($sc_gateway_comments eq "yes") {
  print "<INPUT TYPE=HIDDEN NAME=comments VALUE=\" \">\n";
}

if ($sc_gateway_calculate_tax eq "yes") {
  print "<INPUT TYPE=HIDDEN NAME=taxrate VALUE=\"$sc_gateway_taxrate\">\n";
  print "<INPUT TYPE=HIDDEN NAME=taxstate VALUE=\"$sc_gateway_taxstate\">\n";
}

if ($sc_gateway_easycart ne "no") {
  print "<INPUT TYPE=HIDDEN NAME=easycart VALUE=\"1\">\n";
}
else {
  print "<INPUT TYPE=HIDDEN NAME=easycart VALUE=\"0\">\n";
}

print "<!-- Shipping Settings -->\n";

if ($sc_gateway_shipinfo ne "no") {
  print "<INPUT TYPE=HIDDEN NAME=shipinfo VALUE=\"1\">\n";
}
else {
  print "<INPUT TYPE=HIDDEN NAME=shipinfo VALUE=\"0\">\n";
}

if ($zfinal_shipping ne "") {
  print "<INPUT TYPE=HIDDEN NAME=shipping VALUE=\"$zfinal_shipping\">\n";
}

if ($sc_gateway_use_shipping_calculator eq "yes") {
  if ($sc_gateway_shipmethod ne "") {
    print "<INPUT TYPE=HIDDEN NAME=shipmethod VALUE=\"$sc_gateway_shipmethod\">\n";
  }

  if ($sc_gateway_merchant_zip ne "") {
    print "<INPUT TYPE=HIDDEN NAME=merchant-zip VALUE=\"$sc_gateway_merchant_zip\">\n";
  }

  if ($sc_gateway_usps_container ne "") {
    print "<INPUT TYPE=HIDDEN NAME=usps-container VALUE=\"$sc_gateway_usps_container\">\n";
  }

  if ($sc_gateway_usps_size ne "") {
    print "<INPUT TYPE=HIDDEN NAME=usps-size VALUE=\"$sc_gateway_usps_size\">\n";
  }

  if ($sc_gateway_ups_rate_chart ne "") {
    print "<INPUT TYPE=HIDDEN NAME=ups-rate-chart VALUE=\"$sc_gateway_ups_rate_chart\">\n";
  }

  if ($sc_gateway_mailtype ne "") {
    print "<INPUT TYPE=HIDDEN NAME=mailtype VALUE=\"$sc_gateway_mailtype\">\n";
  }

  if ($sc_gateway_machinable ne "") {
    print "<INPUT TYPE=HIDDEN NAME=machinable VALUE=\"$sc_gateway_machinable\">\n";
  }

  if ($sc_gateway_rate_chart ne "") {
    print "<INPUT TYPE=HIDDEN NAME=rate-chart VALUE=\"$sc_gateway_rate_chart\">\n";
  }

  if ($sc_gateway_method_allow ne "") {
    print "<INPUT TYPE=HIDDEN NAME=method-allow VALUE=\"$sc_gateway_method_allow\">\n";
  }
}

print "<!-- User Defined Fields -->\n";

if (($sc_gateway_userfield1_name ne "") && ($sc_gateway_userfield1_value ne "")) {
  print "<INPUT TYPE=HIDDEN NAME=$sc_gateway_userfield1_name VALUE=\"$sc_gateway_$sc_gateway_userfield1_value\">\n";
}

if (($sc_gateway_userfield2_name ne "") && ($sc_gateway_userfield2_value ne "")) {
  print "<INPUT TYPE=HIDDEN NAME=$sc_gateway_userfield2_name VALUE=\"$sc_gateway_$sc_gateway_userfield2_value\">\n";
}

if (($sc_gateway_userfield3_name ne "") && ($sc_gateway_userfield3_value ne "")) {
  print "<INPUT TYPE=HIDDEN NAME=$sc_gateway_userfield3_name VALUE=\"$sc_gateway_$sc_gateway_userfield3_value\">\n";
}

if (($sc_gateway_userfield4_name ne "") && ($sc_gateway_userfield4_value ne "")) {
  print "<INPUT TYPE=HIDDEN NAME=$sc_gateway_userfield4_name VALUE=\"$sc_gateway_$sc_gateway_userfield4_value\">\n";
}

if (($sc_gateway_userfield5_name ne "") && ($sc_gateway_userfield5_value ne "")) {
  print "<INPUT TYPE=HIDDEN NAME=$sc_gateway_userfield5_name VALUE=\"$sc_gateway_$sc_gateway_userfield5_value\">\n";
}

if (($sc_gateway_userfield6_name ne "") && ($sc_gateway_userfield6_value ne "")) {
  print "<INPUT TYPE=HIDDEN NAME=$sc_gateway_userfield6_name VALUE=\"$sc_gateway_$sc_gateway_userfield6_value\">\n";
}

if (($sc_gateway_userfield7_name ne "") && ($sc_gateway_userfield7_value ne "")) {
  print "<INPUT TYPE=HIDDEN NAME=$sc_gateway_userfield1_name VALUE=\"$sc_gateway_$sc_gateway_userfield1_value\">\n";
}

if (($sc_gateway_userfield8_name ne "") && ($sc_gateway_userfield8_value ne "")) {
  print "<INPUT TYPE=HIDDEN NAME=$sc_gateway_userfield8_name VALUE=\"$sc_gateway_$sc_gateway_userfield8_value\">\n";
}

if (($sc_gateway_userfield9_name ne "") && ($sc_gateway_userfield9_value ne "")) {
  print "<INPUT TYPE=HIDDEN NAME=$sc_gateway_userfield9_name VALUE=\"$sc_gateway_$sc_gateway_userfield9_value\">\n";
}

if (($sc_gateway_userfield10_name ne "") && ($sc_gateway_userfield10_value ne "")) {
  print "<INPUT TYPE=HIDDEN NAME=$sc_gateway_userfield10_name VALUE=\"$sc_gateway_$sc_gateway_userfield10_value\">\n";
}

if (($sc_gateway_userfield11_name ne "") && ($sc_gateway_userfield11_value ne "")) {
  print "<INPUT TYPE=HIDDEN NAME=$sc_gateway_userfield11_name VALUE=\"$sc_gateway_$sc_gateway_userfield11_value\">\n";
}

if (($sc_gateway_userfield12_name ne "") && ($sc_gateway_userfield12_value ne "")) {
  print "<INPUT TYPE=HIDDEN NAME=$sc_gateway_userfield12_name VALUE=\"$sc_gateway_$sc_gateway_userfield12_value\">\n";
}

print "<!-- URL Link Settings -->\n";

if ($sc_gateway_success_link eq "") {
  print "<INPUT TYPE=HIDDEN NAME=success-link VALUE=\"$sc_store_url\">\n";
}
else {
  print "<INPUT TYPE=HIDDEN NAME=success-link VALUE=\"$sc_gateway_success_link\">\n";
}

if ($sc_gateway_badcard_link ne "") {
  print "<INPUT TYPE=HIDDEN NAME=badcard-link VALUE=\"$sc_gateway_badcard_link\">\n";
}

if ($sc_gateway_problem_link ne "") {
  print "<INPUT TYPE=HIDDEN NAME=problem-link VALUE=\"$sc_gateway_problem_link\">\n";
}

print "<!-- Itemized Product Info --> \n";

open (CART, "$sc_cart_path") || &file_open_error("$sc_cart_path", "display_cart_contents_in_header", __FILE__, __LINE__);
while (<CART>) {
  $count++;
  chop;    
  @my_cart_fields = split (/\|/, $_);
  print "<INPUT TYPE=HIDDEN NAME=\"item$count\" VALUE=\"$my_cart_fields[1]\">\n";
  print "<INPUT TYPE=HIDDEN NAME=\"quantity$count\" VALUE=\"$my_cart_fields[0]\">\n";
  print "<INPUT TYPE=HIDDEN NAME=\"description$count\" VALUE=\"$my_cart_fields[4] $options\">\n";
  print "<INPUT TYPE=HIDDEN NAME=\"cost$count\" VALUE=\"$my_cart_fields[16]\">\n";
  if ($sc_gateway_send_weight =~ /yes/i) {
    print "<INPUT TYPE=HIDDEN NAME=\"weight$count\" VALUE=\"$my_cart_fields[6]\">\n";
  }
  $countthingy = $count;
}
close (CART);

if ($zfinal_discount) {
$countthingy++;
  print "<INPUT TYPE=HIDDEN NAME=\"item$countthingy\" VALUE=\"Discount\">\n";
  print "<INPUT TYPE=HIDDEN NAME=\"quantity$countthingy\" VALUE=\"1\">\n";
  print "<INPUT TYPE=HIDDEN NAME=\"description$countthingy\" VALUE=\"Total Discount on Order\">\n";
  print "<INPUT TYPE=HIDDEN NAME=\"cost$countthingy\" VALUE=\"-$zfinal_discount\">\n";
}

print "$test_mode";

print "<!-- Agora Cart Name/Value Pairs--> \n";

foreach $key (sort keys %form_data) {
  print "<INPUT TYPE=HIDDEN NAME=\"$key\" VALUE=\"$form_data{$key}\"> \n";
}

print "<!-- Payment Method Options --> \n";

if ($sc_gateway_paymethod ne "") {
  @pnp_payment_options = split(/\|/, $sc_gateway_paymethod);
  print "<p>Please select your method of payment: <SELECT NAME=PAYMETHOD>\n";
  for ($aaa = 0; $aaa <= $#pnp_payment_options; $aaa++) {
    if ($pnp_payment_options[$aaa] eq "onlinecheck") {
      print "<OPTION VALUE=\"onlinecheck\">Check</OPTION>\n";
    }
    elsif ($pnp_payment_options[$aaa] eq "credit") {
      print "<OPTION VALUE=\"credit\">Credit Card</OPTION>\n";
    }
    else {
      print "<OPTION VALUE=\"$pnp_payment_options[$aaa]\">$pnp_payment_options[$aaa]</OPTION>\n";
    }
  }
  print "</SELECT>\n";
}

print "<p>* <font color=\"\#ff0000\"><u>Note</u></font>: Sales Tax & Shipping fees will be recalculated at checkout and maybe differ then the fees quoted above.<p> \n";

print <<ENDOFTEXT;

<div align="center">

<p class="ac_checkout_top_msg">$my_message</p>

$mytable

<TABLE WIDTH="500" BGCOLOR="#FFFFFF" CELLPADDING="2" CELLSPACING="0" BORDER=0>
  <TR>
    <TD COLSPAN=2>
      <CENTER>
        <INPUT TYPE="IMAGE" NAME="Submit" VALUE="Submit Order For Processing" SRC="$my_submit" border=0>
        &nbsp;&nbsp;&nbsp;&nbsp;
        <a href="agora.cgi?order_form_button.x=1&cart_id=${cart_id}"><IMG SRC="$my_change" BORDER=0></a>
      </CENTER>
    </TD>
  </TR>
</TABLE>
</FORM>
</CENTER>

ENDOFTEXT

############  End of Submit Page Code - Select until this line for copy functions ############
}
else { # uses alternate processing file in add_ons sub directory

 &codehook("'PlugnPay_custom_submit_page");

} # end of alternate submit page

}
############################################################################################
sub process_PlugnPay_Order {

local($subtotal, $total_quantity,
      $total_measured_quantity,
      $text_of_cart, $weight,
      $required_fields_filled_in,
      $product, $quantity, $options);
local($stevo_shipping_thing) = "";
local($stevo_shipping_names) = "";
local($mytext) = "";
local($ship_thing_too,$ship_instructions);
local(%orderLoggingHash);
my ($temp_number);


# Note: The below comments & code is left over from the script rewrite...  Don't know if it's needed, so I left it in.

## Need to process this info someday ... 
&load_verify_file;

# NEW CODEHOOK
&codehook("process-order-routine-top");

# First, we output the header of the processing of the order

$orderDate = &get_date;

if ($sc_use_alternate_PlugnPay_order_processing ne "Yes") {
############  Start of Standard Processing Code - Select from this line to for copy functions ############
#### can use in custom processing file.  Custom file must be named: PlugnPay_custom_processing_lib.pl
#### Place PlugnPay_custom_processing_lib.pl in the library directory of your store
#### Custom function (aka sub routine)  to replace the code below must be named: PlugnPay_custom_processing_function

print "<HTML>\n";
print "$sc_special_page_meta_tags";
print "<HEAD>\n";
print "<TITLE>$messages{'ordcnf_08'}</TITLE>\n";
print "$sc_secure_standard_head_info\n";
print "</HEAD>\n";
print "<BODY $sc_standard_body_info>\n";

&SecureStoreHeader; # Don't Use standard header

if ($form_data{'FinalStatus'} ne "success") { # there is a problem ...
  if ($form_data{'FinalStatus'} eq "badcard") { # declined ... dump cart ??
    &empty_cart;
  }
  print "<CENTER>\n";
  print "<TABLE WIDTH=500>\n";
  print "  <TR>\n";
  print "    <TD WIDTH=500><FONT FACE=ARIAL>\n";
  print "      <P>&nbsp;</P>\n";
  print "      $messages{'ordcnf_05'}<br>\n";
  print "      $form_data{'MErrMsg'}<br>\n";
  print "      <P>&nbsp;</P>\n";
  print "      $messages{'ordcnf_02'}<br>\n";
  print "      </FONT>\n";
  print "    </TD>\n";
  print "  </TR>\n";
  print "</TABLE>\n";
  print "<CENTER>\n";

  &SecureStoreFooter;

  print "  </BODY>\n";
  print "  </HTML>\n";

  &call_exit;
}

# All went well at PlugnPay, proceed with processing

print $mytext;

$text_of_cart .= "$mytext";
$text_of_cart .= "Order Date:    $orderDate\n";
$text_of_cart .= "Gateway:       PlugnPay\n\n";
$orderLoggingHash{'GatewayUsed'} = "PlugnPay";

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
  $options =~ s/<br>/ /g;
  $text_of_cart .= &cart_textinfo(*cart_fields);
  $stevo_shipping_thing .="|$quantity\*$weight";
  $stevo_shipping_names .="|$product\($options\)";
  &codehook("process-cart-item");
}

close(CART);

# initialize hash variables in case they are empty later
# jfindlay 2006 May 2

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

$text_of_cart .= "CUSTID:        $eform_cart_id\n";
$text_of_confirm_email .= "CUSTID:        $eform_cart_id\n";
$orderLoggingHash{'customerNumber'} = "$eform_cart_id";

$text_of_cart .= "INVOICE:       $form_data{'order-id'}\n";
$text_of_confirm_email .= "INVOICE:       $form_data{'order-id'}\n";
$orderLoggingHash{'invoiceNumber'} = "$form_data{'order-id'}";

$temp_number = &format_price($sc_verify_subtotal);
&add_text_of_both("SUBTOTAL",$temp_number);
$orderLoggingHash{'subTotal'} = "$temp_number";
$orderLoggingHash{'shipMethod'} = "$sc_verify_shipto_method";

if (($sc_buySafe_is_enabled =~ /yes/) && ($sc_verify_buySafe > 0)) {
my $temp = &format_price($sc_verify_buySafe);
$text_of_cart .= "$sc_buySafe_bond_fee_mini_display_text       $temp\n";
$text_of_confirm_email .= "$sc_verify_buySafe_display_text       $temp\n";
$orderLoggingHash{'buySafe'} = "$temp";
}

if ($form_data{'shipping'}) {
  $text_of_cart .= "SHIPPING:      $form_data{'shipping'}\n";
  $text_of_confirm_email .= "SHIPPING:      $form_data{'shipping'}\n";
  $orderLoggingHash{'shippingTotal'} = "$form_data{'shipping'}";

  if (($sc_use_SBW =~ /yes/i) || ($form_data{'x_Freight'} > .009)) {
    $text_of_confirm_email .= "SHIP VIA:      $sc_verify_shipto_method\n";
  }
}

  if ($sc_verify_discount) {
      $temp_number = &format_price($sc_verify_discount);
      $text_of_cart .= "DISCOUNT:      $temp_number\n";
      $text_of_confirm_email .= "DISCOUNT:      $temp_number\n";
      $orderLoggingHash{'discounts'} = "$temp_number";
      $text_of_cart .= "DISCOUNT CODE: $eform_Ecom_Discount\n";
      $text_of_confirm_email .= "DISCOUNT CODE: $eform_Ecom_Discount\n";
      $orderLoggingHash{'discountCode'} = "$eform_Ecom_Discount";
  }

if ($form_data{'tax'}) {
  $text_of_cart .= "TOT SALES TAX: $form_data{'tax'}\n";
  $text_of_confirm_email .= "TOT SALES TAX: $form_data{'tax'}\n";
}

if ($sc_verify_tax > 0) {
  $temp = substr(substr("SALES TAX",0,13).":               ",0,15);
  $text_of_cart .= "$temp$sc_verify_tax\n";
  $text_of_confirm_email .= "$temp$sc_verify_tax\n";
  $orderLoggingHash{'salesTax'} = "$sc_verify_tax";
}

if ($sc_verify_etax1 > 0) {
  $temp = substr(substr($sc_extra_tax1_name,0,13).":               ",0,15);
  $text_of_cart .= "$temp$sc_verify_etax1\n";
  $text_of_confirm_email .= "$temp$sc_verify_etax1\n";
  $orderLoggingHash{'tax1'} = "$sc_verify_etax1";
}

if ($sc_verify_etax2 > 0) {
  $temp = substr(substr($sc_extra_tax2_name,0,13).":               ",0,15);
  $text_of_cart .= "$temp$sc_verify_etax2\n";
  $text_of_confirm_email .= "$temp$sc_verify_etax2\n";
  $orderLoggingHash{'tax2'} = "$sc_verify_etax2";
}

if ($sc_verify_etax3 > 0) {
  $temp = substr(substr($sc_extra_tax3_name,0,13).":               ",0,15);
  $text_of_cart .= "$temp$sc_verify_etax3\n";
  $text_of_confirm_email .= "$temp$sc_verify_etax3\n";
  $orderLoggingHash{'tax3'} = "$sc_verify_etax3";
}

$text_of_cart .= "TOTAL:         $form_data{'card-amount'}\n";
$text_of_confirm_email .= "TOTAL:         $form_data{'card-amount'}\n";
$orderLoggingHash{'orderTotal'} = "$form_data{'card-amount'}";

$text_of_cart .= "METHOD:        $form_data{'paymethod'}\n";
$text_of_cart .= "TYPE:          $form_data{'card_type'}\n";

$text_of_cart .= "RESP CODE:     $form_data{'success'}\n";
$text_of_cart .= "AUTH CODE:     $form_data{'auth-code'}\n";
$text_of_cart .= "TRANS ID:      $form_data{'orderID'}\n\n";

$text_of_cart .= "BILLING INFORMATION --------------\n\n";

$text_of_cart .= "NAME:          $form_data{'card-name'}\n";
$orderLoggingHash{'fullName'} = "$form_data{'card-name'}";

$text_of_cart .= "COMPANY:       $form_data{'card-company'}\n";
$orderLoggingHash{'companyName'} = "$form_data{'card-company'}";

$text_of_cart .= "ADDRESS:       $form_data{'card-address1'}\n";
$orderLoggingHash{'orderFromAddress'} = "$form_data{'card-address1'}";

$text_of_cart .= "ADDRESS Line 2:       $form_data{'card-address2'}\n";
$orderLoggingHash{'customerAddress2'} = "$form_data{'card-address2'}";

$text_of_cart .= "CITY:          $form_data{'card-city'}\n";
$orderLoggingHash{'orderFromCity'} = "$form_data{'card-city'}";

$text_of_cart .= "STATE:         $form_data{'card-state'}\n";
$orderLoggingHash{'orderFromState'} = "$form_data{'card-state'}";

$text_of_cart .= "ZIP:           $form_data{'card-zip'}\n";
$orderLoggingHash{'orderFromPostal'} = "$form_data{'card-zip'}";

$text_of_cart .= "COUNTRY:       $form_data{'card-country'}\n";
$orderLoggingHash{'orderFromCountry'} = "$form_data{'card-country'}";

$text_of_cart .= "PHONE:         $form_data{'phone'}\n";
$orderLoggingHash{'customerPhone'} = "$form_data{'phone'}";

$text_of_cart .= "FAX:           $form_data{'fax'}\n";
$orderLoggingHash{'faxNumber'} = "$form_data{'fax'}";

$text_of_cart .= "EMAIL:         $form_data{'email'}\n\n";
$orderLoggingHash{'emailAddress'} = "$form_data{'email'}";

$text_of_cart .= "SHIPPING INFORMATION --------------\n\n";

$text_of_cart .= "SHIP VIA:      $form_data{'Ecom_ShipTo_Method'}\n";

$text_of_cart .= "NAME:          $form_data{'shipname'}\n";
$orderLoggingHash{'shipToName'} = "$form_data{'shipname'}";

$text_of_cart .= "COMPANY:       $form_data{'company'}\n";

$text_of_cart .= "ADDRESS:       $form_data{'address1'}\n";
$orderLoggingHash{'shipToAddress'} = "$form_data{'address1'}";

$text_of_cart .= "ADDRESS Line 2:       $form_data{'address2'}\n";
$orderLoggingHash{'shipToAddress2'} = "$form_data{'address2'}";

$text_of_cart .= "CITY:          $form_data{'city'}\n";
$orderLoggingHash{'shipToCity'} = "$form_data{'city'}";

if ($eform_Ecom_ShipTo_Postal_StateProv ne "") {
  $text_of_cart .= "STATE:         $eform_Ecom_ShipTo_Postal_StateProv\n";
  $orderLoggingHash{'shipToState'} = "$eform_Ecom_ShipTo_Postal_StateProv";
} else {
  $text_of_cart .= "STATE:         $form_data{'state'}\n";
  $orderLoggingHash{'shipToState'} = "$form_data{'state'}";
}

if ($sc_verify_shipping_zip ne "") {
   $text_of_cart .= "ZIP:           $sc_verify_shipping_zip\n";
  $orderLoggingHash{'shipToPostal'} = "$sc_verify_shipping_zip";
} else {
  $text_of_cart .= "ZIP:           $form_data{'zip'}\n";
  $orderLoggingHash{'shipToPostal'} = "$form_data{'zip'}";
}

if ($vform_Ecom_ShipTo_Postal_CountryCode ne "") {
  $text_of_cart .= "COUNTRY:       $vform_Ecom_ShipTo_Postal_CountryCode\n\n";
  $orderLoggingHash{'shipToCountry'} = "$vform_Ecom_ShipTo_Postal_CountryCode";
} else {
  $text_of_cart .= "COUNTRY:       $form_data{'country'}\n\n";
  $orderLoggingHash{'shipToCountry'} = "$form_data{'country'}";
}

if ($ship_instructions ne "") {
  $text_of_cart .= "Shipping Instructions: \n";
  $text_of_cart .= "$ship_instructions\n\n";
}

$text_of_cart .= $XCOMMENTS;
$orderLoggingHash{'xcomments'} = "$XCOMMENTS";
$orderLoggingHash{'xcomments'} =~ s/\n/<br>/g;
$orderLoggingHash{'adminMessages'} =~ s/\t/ /g;
$text_of_admin_email .= $XCOMMENTS_ADMIN;
$orderLoggingHash{'adminMessages'} .= "$XCOMMENTS_ADMIN";
$orderLoggingHash{'adminMessages'} =~ s/\n/<br>/g;
$orderLoggingHash{'adminMessages'} =~ s/\t/ /g;
$text_of_confirm_email .= $XCOMMENTS;

$orderLoggingHash{'adminMessages'} .= "<br>AUTHORIZATION INFORMATION --------------<br>";
$orderLoggingHash{'adminMessages'} .= "METHOD: $form_data{'paymethod'}<br>";
$orderLoggingHash{'adminMessages'} .= "TYPE: $form_data{'card_type'}<br>";
$orderLoggingHash{'adminMessages'} .= "RESP CODE: $form_data{'success'}<br>";
$orderLoggingHash{'adminMessages'} .= "AUTH CODE: $form_data{'auth-code'}<br>";
$orderLoggingHash{'adminMessages'} .= "TRANS ID: $form_data{'orderID'}<br>";
$orderLoggingHash{'adminMessages'} .= "--------------------------------------------<br>";

# 'Init' the emails ...
$text_of_cart = &init_shop_keep_email . $text_of_cart;
$text_of_confirm_email = &init_customer_email . $text_of_confirm_email;

# and add the rest ...
$text_of_admin_email .= &addto_shop_keep_email;
$text_of_confirm_email .= &addto_customer_email;

#if ($sc_use_pgp =~ /yes/i) {
#  &require_supporting_libraries(__FILE__, __LINE__, "$sc_pgp_lib_path");
#  $text_of_cart = &make_pgp_file($text_of_cart, "$sc_pgp_temp_file_path/$$.pgp");
#  $text_of_cart = "\n" . $text_of_cart . "\n";
#}

# added by Mister Ed for Pro version Feb 7, 2007
my $temp_admin_email = "$sc_admin_email";
if ($sc_use_customer_email_over_admin =~ /yes/i) {
   $temp_admin_email = "$form_data{'email'}";
}

if ($sc_send_order_to_email =~ /yes/i) {
  &send_mail($temp_admin_email, $sc_order_email, "$sc_plugnpay_order_desc - $eform_cart_id", $text_of_cart);
}

&log_order($text_of_cart,$form_data{'order-id'},$form_data{'customer_number'});

if (($cartData) && ($form_data{'email'} ne "")) {
  &send_mail($sc_admin_email, $form_data{'email'}, "$messages{'ordcnf_08'} - $eform_cart_id", "$text_of_confirm_email");
}
$sc_affiliate_order_unique = $form_data{'order-id'};
$sc_affiliate_order_total = ($sc_verify_subtotal - $sc_verify_discount);

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
      $messages{'ordcnf_09'}

      <pre>$text_of_cart</pre>
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

&StoreFooter;

print qq!
</BODY>
</HTML>
!;
############  End of Standard Processing Code - Select until this line for copy functions ############
}
else { # uses alternate processing file in add_ons sub directory

 &codehook("'PlugnPay_custom_processing_function");

} # end of alternate processing
} # End of process_order_form

#################################################################

1; # Library
