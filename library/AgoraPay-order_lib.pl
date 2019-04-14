#######################################################################
#                    Order Form Definition Variables                  #
#######################################################################

$versions{'AgoraPay-order_lib.pl'} = "5.5.002";
$sc_use_secure_header_at_checkout = 'yes';
$sc_use_secure_footer_for_order_form = 'yes';

# discount mods applied June 17 2005

$sc_order_response_vars{"AgoraPay"}="AgoraPay";
$sc_use_secure_header_at_checkout = 'yes';
&add_codehook("printSubmitPage","print_AgoraPay_SubmitPage");
&add_codehook("set_form_required_fields","AgoraPay_fields");
&add_codehook("gateway_response","check_for_AgoraPay_response");
###############################################################################
sub AgoraPay_check_and_load {
local($myname)="AgoraPay";
if ($myname ne $sc_gateway_name) { # we are a secondary gateway, load settings
  &require_supporting_libraries(__FILE__,__LINE__,
     "./admin_files/$myname-user_lib.pl");
 }

}
###############################################################################
sub check_for_AgoraPay_response {
  if ($form_data{'AgoraPay'} eq 'AgoraPay') {
    $cart_id = $form_data{'p4'};
    &set_sc_cart_path;
    &load_order_lib;
    &codehook("AgoraPay_order");
    &process_AgoraPay_Order;
    &call_exit;
   }
 }
###############################################################################
sub AgoraPay_fields {
local($myname)="AgoraPay";

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
  'Ecom_Payment_Card_Number', 'Card Number',
  'Ecom_Payment_Card_ExpDate_Month', 'Card Expiration Month',
  'Ecom_Payment_Card_ExpDate_Day', 'Card Expiration Day',
  'Ecom_Payment_Card_ExpDate_Year', 'Card Expiration Year');
                        

@sc_order_form_required_fields = (
	"Ecom_ShipTo_Postal_StateProv",
	"Ecom_ShipTo_Postal_PostalCode");

# lines for tos added April 5 2006 by Mister Ed
 if ($sc_display_checkout_tos =~ /yes/i) {
    push(@sc_order_form_required_fields,"Ecom_tos");
 }

# use this codehook to change the above arrays for required fields and such
&codehook("AgoraPay_fields_bottom");

}

###############################################################################
sub AgoraPay_order_form_prep{ # load the customer info ...
&AgoraPay_check_and_load;
  if ($sc_AgoraPay_form_prep == 0) {
    if (-f "$sc_verify_order_path"){
      &read_verify_file;  
     } else {
      &codehook("load_customer_info");
     }
    $sc_AgoraPay_form_prep = 1;
   }
  return "";
 }
###############################################################################
sub AgoraPay_table_setup{
#
# To use this, put this in the email_text in the manager for HTML:
#
#	<!--agorascript-pre
#	  return $AgoraPay_cart_table;
#	-->
#
# or for text in an email:
#
#	<!--agorascript-pre
#	  return $AgoraPay_prod_in_cart;
#	-->
# 

local (@my_cart_fields,$my_cart_row_number,$result);
local ($count,$price,$product_id,$quantity,$total_cost,$total_qty)=0;
local ($name,$cost);

 $AgoraPay_prod_in_cart = '';
 $AgoraPay_cart_table = '';
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
     $AgoraPay_prod_in_cart .= "  --PRODUCT INFORMATION--\n\n";
    }
   $result .= "<TR><TD>$quantity</TD><TD>$product_id</TD>\n";
   $result .= "<TD>$name</TD><TD>$cost</TD>";
   $result .= "</TR>\n";
   $AgoraPay_prod_in_cart .= &cart_textinfo(*my_cart_fields);
  } # End of while (<CART>)
 close (CART);
 if ($result ne '') {
   $result .= "</TABLE></TD></TR></TABLE>\n";
  }

# use this to change $result
&codehook("AgoraPay_table_setup_bottom");

 $AgoraPay_cart_table = $result;
}

###############################################################################

sub print_AgoraPay_SubmitPage

{
local($invoice_number, $customer_number, $displayTotal);
local($test_mode,$zemail_text);
local($myname)="AgoraPay";
local($my_change,$my_submit,$my_message,$my_desc);
my ($tempbodytags) = '';

if (!($form_data{'gateway'} eq $myname)) { return;} 
if ($myname ne $sc_gateway_name) { # secondary gateway, load settings
  &require_supporting_libraries(__FILE__,__LINE__,
     "./admin_files/$myname-user_lib.pl");
 }

$displayTotal = &display_price($authPrice);

$invoice_number = $current_verify_inv_no;
$customer_number = $cart_id;
$customer_number =~ s/_/./g;
$my_submit=&script_and_substitute($sc_agorapay_submit);
$my_change=&script_and_substitute($sc_agorapay_change);
$my_message=&script_and_substitute($sc_agorapay_verify_message);
$my_desc=&script_and_substitute($sc_agorapay_order_desc);
&AgoraPay_table_setup;
$zemail_text = &script_and_substitute($email_text,"AgoraPay");

if ($merchant_live_mode =~ /yes/i){
  $test_mode = "";
 } else {
  $test_mode = "<INPUT TYPE=HIDDEN NAME=\"lookup\" VALUE=\"test_mode\">";
 }

if ($sc_use_alternate_AgoraPay_submit_page ne "Yes") {
############  Start of Standard submit page - Select from this line to for copy functions ############
#### can use in custom submit page.  Custom file must be named: AgoraPay_custom_processing_lib.pl
#### Custom function (aka sub routine) to replace the code below must be named: AgoraPay_custom_submit_page

if ($AgoraPay_enablebodytags eq "1"){
$tempbodytags = qq~<input type="hidden" name="bodytags" value="$AgoraPay_enablebodytags">
<INPUT type="hidden" name="background" value="$AgoraPay_backimage_URL">
<INPUT type="hidden" name="bgcolor" value="$AgoraPay_bodyback">
<INPUT type="hidden" name="fontcolor" value="$AgoraPay_fontcolor">
<INPUT type="hidden" name="link" value="$AgoraPay_linkcolor">
<INPUT type="hidden" name="alink" value="$AgoraPay_alinkcolor">
<INPUT type="hidden" name="vlink" value="$AgoraPay_vlinkcolor">
~;
}

if ($AgoraPay_Logo_URL ne ""){
$tempbodytags .= qq~
<INPUT type="hidden" name="mastimage" value="1">
<INPUT type="hidden" name="mast" value="$AgoraPay_Logo_URL">
~;
}

print <<ENDOFTEXT;
</form></form>
<FORM METHOD=POST ACTION=\"$sc_order_script_url\" AUTOCOMPLETE = 'off'>

<INPUT TYPE=\"HIDDEN\" NAME=\"vendor_id\" VALUE=\"$sc_gateway_username\">

<input type=\"hidden\" name=\"formtype\" value=\"1\">
<INPUT TYPE=\"HIDDEN\" NAME=\"home_page\" VALUE=\"$sc_store_url\">
<INPUT TYPE=\"HIDDEN\" NAME=\"ret_addr\" VALUE=\"$sc_store_url\">
<input type=\"hidden\" name=\"ret_mode\" value=\"post\">
<INPUT TYPE=\"HIDDEN\" NAME=\"email_text\" VALUE=\"$zemail_text\">

<INPUT TYPE=\"HIDDEN\" NAME=\"1-cost\" VALUE=\"$authPrice\">
<INPUT TYPE=\"HIDDEN\" NAME=\"1-desc\" VALUE=\"Online Order\">
<INPUT TYPE=\"HIDDEN\" NAME=\"1-qty\" VALUE=\"1\">

$tempbodytags
<input type="hidden" name="mertext" value="$AgoraPay_merch_message">

<INPUT type=\"HIDDEN\" name=\"passback\" value=\"p1\">
<INPUT TYPE=\"HIDDEN\" NAME=\"p1\" VALUE=\"$zfinal_shipping\">

<INPUT type=\"HIDDEN\" name=\"passback\" value=\"p2\">
<INPUT TYPE=HIDDEN NAME=\"p2\" VALUE=\"$zfinal_discount\">

<INPUT type=\"HIDDEN\" name=\"passback\" value=\"p3\">
<INPUT TYPE=HIDDEN NAME=\"p3\" VALUE=\"$zfinal_sales_tax\">

<INPUT type=\"HIDDEN\" name=\"passback\" value=\"p4\">
<INPUT TYPE=\"HIDDEN\" NAME=\"p4\" VALUE=\"$customer_number\">

<INPUT type=\"HIDDEN\" name=\"passback\" value=\"p5\">
<INPUT TYPE=\"HIDDEN\" NAME=\"p5\" VALUE=\"$invoice_number\">

<INPUT type=\"HIDDEN\" name=\"passback\" value=\"AgoraPay\">
<INPUT TYPE=\"HIDDEN\" NAME=\"AgoraPay\" VALUE=\"AgoraPay\">

<INPUT TYPE=HIDDEN NAME=\"showaddr\" VALUE=\"1\">
<INPUT TYPE=HIDDEN NAME=\"nonum\" VALUE=\"0\">

<INPUT TYPE=HIDDEN NAME=\"mername\" VALUE=\"$mername\">
<INPUT TYPE=HIDDEN NAME=\"acceptcards\" VALUE=\"$acceptcards\">
<INPUT TYPE=HIDDEN NAME=\"acceptchecks\" VALUE=\"$acceptchecks\">
<INPUT TYPE=HIDDEN NAME=\"accepteft\" VALUE=\"$accepteft\">
<INPUT TYPE=HIDDEN NAME=\"altaddr\" VALUE=\"$altaddr\">
<INPUT TYPE=HIDDEN NAME=\"disable_cards\" VALUE=\"$AgoraPay_disable_cards\">
<INPUT TYPE=HIDDEN NAME=\"disable_paypal\" VALUE=\"$AgoraPay_disable_paypal\">
<INPUT TYPE=HIDDEN NAME=\"disable_checks\" VALUE=\"$AgoraPay_disable_checks\">

<INPUT TYPE=HIDDEN NAME=\"lookup\" VALUE=\"first_name\">
<INPUT TYPE=HIDDEN NAME=\"lookup\" VALUE=\"last_name\">
<INPUT TYPE=HIDDEN NAME=\"lookup\" VALUE=\"address\">
<INPUT TYPE=HIDDEN NAME=\"lookup\" VALUE=\"city\">
<INPUT TYPE=HIDDEN NAME=\"lookup\" VALUE=\"state\">
<INPUT TYPE=HIDDEN NAME=\"lookup\" VALUE=\"zip\">
<INPUT TYPE=HIDDEN NAME=\"lookup\" VALUE=\"country\">
<INPUT TYPE=HIDDEN NAME=\"lookup\" VALUE=\"phone\">
<INPUT TYPE=HIDDEN NAME=\"lookup\" VALUE=\"email\">

<INPUT TYPE=HIDDEN NAME=\"lookup\" VALUE=\"sfname\">
<INPUT TYPE=HIDDEN NAME=\"lookup\" VALUE=\"slname\">
<INPUT TYPE=HIDDEN NAME=\"lookup\" VALUE=\"saddr\">
<INPUT TYPE=HIDDEN NAME=\"lookup\" VALUE=\"scity\">
<INPUT TYPE=HIDDEN NAME=\"lookup\" VALUE=\"sstate\">
<INPUT TYPE=HIDDEN NAME=\"lookup\" VALUE=\"szip\">
<INPUT TYPE=HIDDEN NAME=\"lookup\" VALUE=\"sctry\">

<INPUT TYPE=HIDDEN NAME=\"lookup\" VALUE=\"total\">
<INPUT TYPE=HIDDEN NAME=\"lookup\" VALUE=\"authcode\">
$test_mode
<INPUT TYPE=HIDDEN NAME=\"lookup\" VALUE=\"when\">
<INPUT TYPE=HIDDEN NAME=\"lookup\" VALUE=\"xid\">

<div align="center">

<p class="ac_checkout_top_msg">$AgoraPay_order_ok_final_msg_tbl</p>
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
    <td class="ac_checkout_review_col1">State </td>
    <td class="ac_checkout_review_col2">$form_data{'Ecom_ShipTo_Postal_StateProv'}
    &nbsp;</td>
  </tr>
  <tr>
    <td class="ac_checkout_review_col1">Postal Code </td>
    <td class="ac_checkout_review_col2">$form_data{'Ecom_ShipTo_Postal_PostalCode'}
    &nbsp; </td>
  </tr>
  <tr>
    <td class="ac_checkout_review_col1">Country</td>
    <td class="ac_checkout_review_col2">$form_data{'Ecom_ShipTo_Postal_CountryCode'}</td>
  </tr>
  <tr>
    <td class="ac_checkout_review_col1">Residential Address</td>
    <td class="ac_checkout_review_col2">$form_data{'Ecom_is_Residential'}&nbsp;</td>
  </tr>
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

&codehook("AgoraPay_custom_submit_page");

} # end of alternate submit page

}
############################################################################################
sub process_AgoraPay_Order {
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

&load_verify_file;

$mySIG= "./admin_files/sig_ver_$$.SIG";

open(SIGV,">$mySIG");
print SIGV $form_data{'signature'};
close(SIGV);

($junk,$my_str) = split(/http:\/\//,$form_data{'signature'},2);
($junk,$my_str) = split(/\?/,$my_str,2);
($my_str,$junk) = split(/\n/,$my_str,2);

@itrans = split(/[&;]/,$my_str); 

# parse the signed response, not what was on the command line ... 
# code borrowed from cgi-lib.pl

if ($form_data{'signature'}) {
foreach $i (0 .. $#itrans) {
   # Convert plus to space
   $itrans[$i] =~ s/\+/ /g;

   # Split into key and value.  
   ($key, $val) = split(/=/,$itrans[$i],2); # splits on the first =.

   # Convert %XX from hex numbers to alphanumeric
   $key =~ s/%([A-Fa-f0-9]{2})/pack("c",hex($1))/ge;
   $val =~ s/%([A-Fa-f0-9]{2})/pack("c",hex($1))/ge;

   # Associate key and value
   $itrans{$key} .= "\0" if (defined($itrans{$key})); #\0 = multiple separator
   $itrans{$key} .= $val;
 }
} elsif ($AgoraPay_disable_paypal ne "1" && $form_data{'signature'} eq '') {
  foreach $key (sort(keys(%form_data))) {
   $itrans{$key} = "$form_data{$key}";
 }
}

if ($sc_pgp_or_gpg =~ /GPG/i) { # verify with GPG
  $command =  "$sc_pgp_or_gpg_path ";
  $command .= "--home ./pgpfiles --always-trust --verify ";
  $ENV{'PATH'}="/bin:/usr/bin";
  $result = `$command $mySIG 2>&1`;
  if (($result =~ /Good Signature/i) &&
      ($result =~ /AgoraPay/i)) {
    $verification = "Passed GNU Privacy Guard signature verification.";
   } else {
    $verification = "$result\n";
# Could not verify AgoraPay signature because:\n$result\n";
   }
 }

if ($sc_pgp_or_gpg =~ /PGP/i) { # verify with Pretty Good Privacy
  $command =  "$sc_pgp_or_gpg_path";
  chop($command);
  $command .= "v "; # verification 
  $command .= "";
  $ENV{'PATH'}="/bin:/usr/bin";
  $ENV{'PGPPATH'}="./pgpfiles";
  $result = `$command $mySIG 2>&1`;
  if (($result =~ /Good Signature/i) &&
      ($result =~ /AgoraPay/i)) {
    $verification = "Passed PGP signature verification.";
   } else {
#    $verification = "\n$result\n";
   }
 }

unlink("$mySIG");

if ($cart_id ne $itrans{'p4'}) {
  $verification .= "\nWARNING! CART ID DOES NOT MATCH EXPECTED VALUE!!\n\n";
 }

# NEW CODEHOOK
&codehook("process-order-routine-top");

$orderDate = &get_date;

print qq!
<html>
$sc_special_page_meta_tags
<HEAD>
<title>$messages{'ordcnf_08'}</title>
$sc_secure_standard_head_info</head>
<body>
!;

if ($sc_use_alternate_AgoraPay_order_processing ne "Yes") {
############  Start of Standard Processing Code - Select from this line to for copy functions ############
#### can use in custom processing file.  Custom file must be named: AgoraPay_custom_processing_lib.pl
#### Place AgoraPay_custom_processing_lib.pl in the library directory of your store
#### Custom function (aka sub routine)  to replace the code below must be named: AgoraPay_custom_processing_function


&SecureStoreHeader;

$text_of_cart .= "Order Date:    $orderDate\n";
$text_of_cart .= "Gateway:       AgoraPay\n\n";
$orderLoggingHash{'GatewayUsed'} = "AgoraPay";

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
$text_of_cart .= "CUST ID:       $itrans{'p4'}\n";
$text_of_confirm_email .= "CUST ID:       $itrans{'p4'}\n";
$orderLoggingHash{'customerNumber'} = "$itrans{'p4'}";

$text_of_cart .= "ORDER ID:      $itrans{'p5'}\n";
$text_of_confirm_email .= "ORDER ID:      $itrans{'p5'}\n";
$orderLoggingHash{'invoiceNumber'} = "$itrans{'p5'}";

if ($itrans{'p1'})
{
$text_of_cart .= "SHIPPING:      " . &format_price($sc_verify_shipping) . "\n";
$text_of_confirm_email .= "SHIPPING:      " . &format_price($sc_verify_shipping) . "\n";
$orderLoggingHash{'shippingTotal'} = &format_price($sc_verify_shipping);
}

# if ($sc_use_SBW =~ /yes/i)
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
  &add_text_of_both("DISCOUNT",$tempt);
  $orderLoggingHash{'discounts'} = &format_price($sc_verify_discount);
  # start of adjustments for discount addon
  $text_of_cart .= "DISCOUNT CODE: $eform_Ecom_Discount\n";
  $text_of_confirm_email .= "DISCOUNT CODE: $eform_Ecom_Discount\n";
  # end of adjustments for discount addon
}

if ($itrans{'p3'})
{
$text_of_cart .=          "TOT. SALESTAX: $itrans{'p3'}\n";
$text_of_confirm_email .= "TOT. SALESTAX: $itrans{'p3'}\n";
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

$text_of_cart .= "TOTAL:         $itrans{'total'}\n\n";
$text_of_confirm_email .= "TOTAL:         $itrans{'total'}\n\n";
$orderLoggingHash{'orderTotal'} = "$itrans{'total'}"; #$sc_verify_grand_total";

$text_of_cart .= "AUTH CODE      $itrans{'authcode'}\n";
$text_of_cart .= "TIME:          $itrans{'when'}\n";
$text_of_cart .= "TRANS ID:      $itrans{'xid'}\n\n";
$text_of_cart .= "BILLING INFORMATION --------------\n\n";

$text_of_cart .= "NAME:          $itrans{'first_name'} $itrans{'last_name'}\n";
$orderLoggingHash{'fullName'} = "$itrans{'first_name'} $itrans{'last_name'}";
$orderLoggingHash{'firstName'} = "$itrans{'first_name'}";
$orderLoggingHash{'lastName'} = "$itrans{'last_name'}";

$text_of_cart .= "ADDRESS:       $itrans{'address'}\n";
$orderLoggingHash{'orderFromAddress'} = "$itrans{'address'}";

$text_of_cart .= "CITY:          $itrans{'city'}\n";
$orderLoggingHash{'orderFromCity'} = "$itrans{'city'}";

$text_of_cart .= "STATE:         $itrans{'state'}\n";
$orderLoggingHash{'orderFromState'} = "$itrans{'state'}";

$text_of_cart .= "ZIP:           $itrans{'zip'}\n";
$orderLoggingHash{'orderFromPostal'} = "$itrans{'zip'}";

$text_of_cart .= "COUNTRY:       $itrans{'country'}\n";
$orderLoggingHash{'orderFromCountry'} = "$itrans{'country'}";

$text_of_cart .= "PHONE:         $itrans{'phone'}\n";
$orderLoggingHash{'customerPhone'} = "$itrans{'phone'}";

$text_of_cart .= "EMAIL:         $itrans{'email'}\n\n";
$orderLoggingHash{'emailAddress'} = "$itrans{'email'}";

$text_of_cart .= "SHIPPING INFORMATION --------------\n\n";

if ($itrans{'slname'} ne'') {
$text_of_cart .= "NAME:          $itrans{'sfname'} $itrans{'slname'}\n";
$orderLoggingHash{'shipToName'} = "$itrans{'sfname'} $itrans{'slname'}";
} else {
$text_of_cart .= "NAME:          $itrans{'first_name'} $itrans{'last_name'}\n";
$orderLoggingHash{'shipToName'} = "$itrans{'first_name'} $itrans{'last_name'}";
}

if ($itrans{'saddr'} ne'') {
$text_of_cart .= "ADDRESS:       $itrans{'saddr'}\n";
$orderLoggingHash{'shipToAddress'} = "$itrans{'saddr'}";
} else {
$text_of_cart .= "ADDRESS:       $itrans{'address'}\n";
$orderLoggingHash{'shipToAddress'} = "$itrans{'address'}";
}

if ($itrans{'scity'} ne'') {
$text_of_cart .= "CITY:          $itrans{'scity'}\n";
$orderLoggingHash{'shipToCity'} = "$itrans{'scity'}";
} else {
$text_of_cart .= "CITY:          $itrans{'city'}\n";
$orderLoggingHash{'shipToCity'} = "$itrans{'city'}";
}

if ($itrans{'sstate'} ne'') {
$text_of_cart .= "STATE:         $itrans{'sstate'}\n";
$orderLoggingHash{'shipToState'} = "$itrans{'sstate'}";
} else {
$text_of_cart .= "STATE:          $eform_Ecom_ShipTo_Postal_StateProv\n";
$orderLoggingHash{'shipToState'} = "$eform_Ecom_ShipTo_Postal_StateProv";
}

if ($itrans{'szip'} ne'') {
$text_of_cart .= "ZIP:           $itrans{'szip'}\n";
$orderLoggingHash{'shipToPostal'} = "$itrans{'szip'}";
} else {
$text_of_cart .= "ZIP:           $eform_Ecom_ShipTo_Postal_PostalCode\n";
$orderLoggingHash{'shipToPostal'} = "$eform_Ecom_ShipTo_Postal_PostalCode";
}

if ($itrans{'sctry'} ne '') {
$text_of_cart .= "COUNTRY:       $itrans{'sctry'}\n\n";
$orderLoggingHash{'shipToCountry'} = "$itrans{'sctry'}";
} else {
$text_of_cart .= "COUNTRY:       $vform_Ecom_ShipTo_Postal_CountryCode\n";
$orderLoggingHash{'shipToCountry'} = "$vform_Ecom_ShipTo_Postal_CountryCode";
}

$text_of_cart .= "SHIP VIA:      $itrans{'Ecom_ShipTo_Method'}\n";

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
$orderLoggingHash{'adminMessages'} .= "<br>AUTHORIZATION INFORMATION --------------<br>AUTH CODE:  $itrans{'authcode'}<br>TIME:  $itrans{'when'}<br>TRANS ID:  $itrans{'xid'}<br>---------------------------------------------------------------<br>";
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

if ($sc_use_pgp =~ /yes/i) {
  &require_supporting_libraries(__FILE__, __LINE__, "$sc_pgp_lib_path");
  $text_of_cart = &make_pgp_file($text_of_cart,"$sc_pgp_temp_file_path/$$.pgp");
  $text_of_cart = "\n" . $text_of_cart . "\n";
 }

$sc_agorapay_order_desc .= " - " . $itrans{'p5'};

# added by Mister Ed for Pro version Feb 7, 2007
my $temp_admin_email = "$itrans{'email'}";
if ($sc_use_customer_email_over_admin =~ /yes/i) {
   $temp_admin_email = "$eform_Ecom_BillTo_Online_Email";
}

if ($sc_send_order_to_email =~ /yes/i) {
  &send_mail($temp_admin_email, $sc_order_email, $sc_agorapay_order_desc, $text_of_cart);
 }

&log_order($text_of_cart,$itrans{'p5'},$itrans{'p4'});

if (($cartData) && ($itrans{'email'} ne "")) {
  &send_mail($sc_admin_email, $itrans{'email'}, $messages{'ordcnf_08'},
           "$text_of_confirm_email");
 }
$sc_affiliate_order_unique = $itrans{'p5'};
$sc_affiliate_order_total = $itrans{'total'};

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

 &codehook("AgoraPay_custom_processing_function");

} # end of alternate processing

} # End of process_order_form

#################################################################
1; # Library
