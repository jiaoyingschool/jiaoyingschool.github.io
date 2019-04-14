# file ./store/protected/buySAFE-ext_lib.pl
#########################################################################
#
# Copyright (c) 2002 to Date K-Factor Technologies, Inc.
# http://www.k-factor.net/  and  http://www.AgoraCart.com/
# All Rights Reserved.
#
# Use with permission only with AgoraCart, AgoraCartPro, AgoraSQL, AgoraCartSQL, 
# or AgoraSuite
#
# This software is a separate add-on to an ecommerce shopping cart and 
# is the confidential and proprietary information of K-Factor Technologies, Inc.  You shall
# not disclose such Confidential Information and shall use it only in
# conjunction with the AgoraCart (aka agora.cgi) shopping cart.
#
# Requires AgoraCart version 5.0.0 or above.  Just place this file in the protected directory.
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
# You may not give this script/add-on away or distribute it an any way without
# written permission from K-Factor Technologies, Inc.  K-Factor Technologies, Inc.
# reserves any and all rights to distributions, add-ons, and other works based on this
# piece of software as well as any and all rights to profit sharing and/or to charge for
# such works and/or derivatves.
#
# Hosting Companies and other software integrators are encouraged to integrate additional
# features and add-ons in their AgoraCart offerings, but must receive written permission from from
# K-Factor Technologies, Inc. in order to distribute this add-on to AgoraCart (aka Agora.cgi).
#
##########################################################################
$versions{'buySAFE-ext_lib.pl'} = "5.5.003 Gold Version";

{
 local ($modname) = 'buySAFE';
 &register_extension($modname,"buySAFE Manager",$versions{$modname});
 &add_settings_choice("buySAFE Manager"," buySAFE Manager ",
	"change_buySAFE_screen");
 &register_menu('buySAFESettings',"write_buySAFE_settings",
	$modname,"Write Best Sellers Settings");
 &register_menu('change_buySAFE_screen',"display_buySAFE_screen",
	$modname,"Display buySAFE Settings");
 &add_merchtools_settings_choice("buySAFE","buySAFE Bonding",
  "change_buySAFE_screen");
   &register_menu('buysafecanceltrigger',"select_cancel_buysafe_bond_screen",
  $modname,"buysafecanceltrigger")
   &register_menu('CancelBuySafeBond',"cancel_individual_buysafe_bond",
  $modname,"Cancel an Individual buySAFE Bond");
}
#######################################################################################
sub write_buySAFE_settings {
 my ($myset)="";

$sc_buySafe_is_enabled = "$in{'sc_buySafe_is_enabled'}";
$myset .= "\$sc_buySafe_is_enabled = qq|$in{'sc_buySafe_is_enabled'}|;\n";
$myset .= "\$sc_buysafe_VERSION = '600';\n";
$myset .= "\$sc_buysafe_USERNAME = qq|agora|;\n";
$myset .= "\$sc_buysafe_PASSWORD = qq|7F2FBE0D-4245-48BC-9F6B-7B4BEFC48B6C|;\n";
$myset .= "\$sc_buysafe_STORE_TOKEN = qq|$in{'sc_buysafe_STORE_TOKEN'}|;\n";
$myset .= "\$sc_buysafe_SEAL_DATA = qq|$in{'sc_buysafe_SEAL_DATA'}|;\n";
$myset .= "\$sc_buysafe_URL = qq|https://api.buysafe.com/buysafews/CheckoutAPI.dll|;\n";
# buysafe sandbox
#$myset .= "\$sc_buysafe_URL = qq|https://sbws.buysafe.com/BuysafeWS/CheckoutAPI.dll|;\n";

my $temp = &str_encode($in{'sc_buysafe_SEAL_DATA'});

$sc_buysafe_merchant_seal_complete_button_string = qq|
<span id="BuySafeSealSpan"><script type="text/javascript">WriteBuySafeSeal('BuySafeSealSpan', 'Small', "HASH=$temp");</script></span>
|;
$myset .= "\$sc_buysafe_merchant_seal_complete_button_string = q|$sc_buysafe_merchant_seal_complete_button_string|;\n";

# $sc_buysafe_SERVER = "api.buysafe.com";

&update_store_settings('BUYSAFE',$myset);
&display_buySAFE_screen;
 }
################################################################################
sub display_buySAFE_screen
{
print &$manager_page_header("buySAFE Settings","","","","");

if ($sc_buySafe_is_enabled eq "") {
    $sc_buySafe_is_enabled = "no";
}

print <<ENDOFTEXT;
<form action="manager.cgi" method="POST">
<center>
<hr width="580" />
<table width="580">
<tr>
<td width="580"><font face="arial,helvetica" size=2>
Welcome to the <b>AgoraCart</b> BuySAFE Manager.<br /><br />

<b>AgoraCart and buySAFE</b> - the leading trust and safety company for e-commerce transactions - recently joined forces to enable AgoraCart merchants to display the buySAFE trust solution on their websites!<br /><br />

<b>Turn More Shoppers into Buyers with buySAFE</b><br />
buySAFE provides the Internet’s only explicit third-party endorsement of a merchant’s reliability and trustworthiness backed by a willingness to back the transaction with a bond guarantee. buySAFE Merchants benefit from the increase in shopper thrust this through greater conversion of shoppers to buyers, which means more revenue – and profits.<br /><br />

<b>With buySAFE, you can expect:</b>
<ul><li>Increased website conversion rates – 6.7% average increase</li>
<li>More repeat buyers – 4.3% more likely to buy again and again</li>
<li>Greater profits – more carts started and fewer carts abandoned add up to more profits for you! </li></ul><br /><br />

<b>Best of all, buySAFE is FREE for AgoraCart merchants</b> – there are no hidden fees, no risk, and no long-term commitments!<br /><br />

<b>Learn More about buySAFE!</b> Visit <a href="http://www.AgoraCart.com/buySAFE.html" target="_blank">www.AgoraCart.com/buySAFE.html</a><br /><br />

<b>How does buySAFE work?</b><br />
Approved buySAFE merchants display the buySAFE Seal on their websites—the only seal that explicitly certifies that an online merchant is reliable and trustworthy. The buySAFE bond guarantee at checkout, provides shoppers with the option to fully guarantee their online purchase with a buySAFE bond. Together, this powerful combination makes shoppers feel safer and more confident and, therefore, more likely to buy from you. <br /><br />
<b>
Get Started Now!</b><br />
Here are the simple steps to enable buySAFE in your AgoraCart store:<br />
<blockquote><b>1.</b> visit <a href="http://www.agoracart.com/buySAFE.html" target="_blank">www.AgoraCart.com/buySAFE.html</a> to learn more about the program and apply for buysafe.<br />
<b>2.</b> from buySAFE.com, click “apply now” and complete the short application to become a buysafe merchant.<br />
<b>3.</b> login to your buySAFE merchant dashboard, and complete the store setup process.<br />
<b>4.</b> under test store, click “no” under “is the button present?” and you will see your seal authentication and store authentication data.<br />
<b>5.</b> copy and paste the seal and store authentication data into the matching fields on this page (below) and click “submit”.<br />
<b>6.</b> last, choose a prominent location for the buySAFE seal in your store using the field at the bottom of this page (we recommend above the fold!)</blockquote><br />

Once you complete these steps, you’ll be set up to start turning more shoppers into buyers with buySAFE! <a href="http://www.AgoraCart.com/buySAFE.html" target="_blank">Clicking Here - special for AgoraCart users</a>.<br /></font></td>
</tr>
</table>
<hr width="580" />
</center>

ENDOFTEXT

if($in{'system_edit_success'} ne "")
{
print <<ENDOFTEXT;
<center>
<table width="580">
<tr>
<td align="center">
<font FACE=ARIAL SIZE=2 COLOR=RED>Your buySAFE Account settings been successfully updated. <br /><br /></font>
</td>
</tr>
<tr>
<td colspan="2"><hr width="580" /></td>
</tr>
</table>
</center>
ENDOFTEXT
}

print <<ENDOFTEXT;
<font face="arial" size=2>
<form method="POST" action="manager.cgi">
<center>
<table border="0" cellpadding="1" cellspacing="0" width="580">
<tr>
<td><font size="2" face="Arial, Helvetica, sans-serif"><b>Enable buySAFE?</b>. Select "yes" to allow your customers to insure their order from you with a surety bond from buySAFE.</font></td>
<td><font size="2" face="Arial, Helvetica, sans-serif">
<select name="sc_buySafe_is_enabled">
<option>$sc_buySafe_is_enabled</option>
<option>yes</option> 
<option>no</option> 
</select>
</font></td>
</td>
</tr>
<tr>
<td colspan="2"><hr /></td>
</tr>

<tr>
<td><font size="2" face="Arial, Helvetica, sans-serif"><b>buySAFE Store Token</b>. Enter the 35-45 character store token provided to you by buySAFE when you sign up for your buySAFE account.</font></td>
<td><font size="2" face="Arial, Helvetica, sans-serif">
<input name="sc_buysafe_STORE_TOKEN" type="text" size=45 maxlength="50" value="$sc_buysafe_STORE_TOKEN">
</font></td>
</td>
</tr>
<tr>
<td colspan="2"><hr /></td>
</tr>

<tr>
<td><font size="2" face="Arial, Helvetica, sans-serif"><b>buySAFE Merchant Seal</b>. Enter the Seal Hash provided to you by buySAFE when you sign up for your buySAFE account.</font></td>
<td><font size="2" face="Arial, Helvetica, sans-serif">
<input name="sc_buysafe_SEAL_DATA" type="text" size=45 maxlength="150" value="$sc_buysafe_SEAL_DATA">
</font></td>
</td>
</tr>
<tr>
<td colspan="2"><hr /></td>
</tr>

<TR>
<TD COLSPAN=2>
<CENTER>
<INPUT TYPE="HIDDEN" NAME="system_edit_success" VALUE="yes">
<INPUT NAME="buySAFESettings" TYPE="SUBMIT" VALUE="Submit">
&nbsp;&nbsp;
<INPUT TYPE="RESET" VALUE="Reset">
</CENTER>
</TD>
</TR>

<tr>
<td colspan="2"><hr /></td>
</tr>

</table>

</center>
</form>

<br/>
<center>
For your convenience, here is the <b>buySAFE Merchant Seal</b> pre-built to place within header/footer and/or other pages within your site.<br/><br/>NOTE: If no code appears, please hit the submit button when ready and the code will be compiled from Merchant Seal Hash listed above.<br/>Advanced users may also use the variable called: <b>\$sc_buysafe_merchant_seal_complete_button_string</b> instead, within cart pages.<br/><br/><b>Cut and paste</b> the code below for use in your website and shopping cart pages:<br/>
<form>
<textarea 
name="Ecom_XCOMMENT_Special_Notes" 
cols="55" rows="9" 
wrap="soft">$sc_buysafe_merchant_seal_complete_button_string</textarea>
</form>
</center>

ENDOFTEXT

print &$manager_page_footer;
}
#######################################################################################
sub select_cancel_buysafe_bond_screen {

$in{'customerNumber'} =~ /([\w\=\+\.]+)/;
my $cust_number = "$1";

$in{'invNumber'} =~ /([\w\=\+\.]+)/;
my $inv_number = "$1";

$in{'buyMonth'} =~ /([\w]+)/;
my $buyMonth = "$1";
$in{'buyYear'} =~ /([\w]+)/;
my $buyYear = "$1";

print &$manager_page_header("Cancel buySAFE Bond on order: $inv_number","","","","");

print <<ENDOFTEXT;
<form method="POST" action="manager.cgi"><br />
<center>
<hr width="580" /><br />
<table width="580" border="0">
<TR>
<TD>
<FONT FACE=ARIAL size=2>Welcome to the <b>AgoraCart</b> buySAFE Bond Cancellation Manager.<br>This section will allow you to cancel the surety bond from buySAFE on order $cust_number.  <b>DO NOT cancel</b> surety bonds on orders where money has already changed hands from the buyer to you. This is only to be used in the event the order is cancelled prior to the customer's payment to you.
</font></TD>
</TR>
</table><br /><br />
<font face=arial size=2 color=red><b>NOTE:</b><br>Once you cancel the surety bond on this order,<br>the cancelled bond cannot be resubmitted.</font><br /><br />
<INPUT TYPE="hidden" NAME="invNumber" VALUE="$inv_number">
<INPUT TYPE="hidden" NAME="customerNumber" VALUE="$cust_number">
<INPUT TYPE="hidden" NAME="buyMonth" VALUE="$buyMonth">
<INPUT TYPE="hidden" NAME="buyYear" VALUE="$buyYear">
<INPUT NAME="CancelBuySafeBond" TYPE="SUBMIT" VALUE="Cancel buySAFE Bond for Order# $cust_number ">
<br /><br /><br /><br />
</center>
ENDOFTEXT

print &$manager_page_footer;
}
#######################################################################################
sub buysafe_sendcancelRequest($$) {


$sc_buysafe_SOAP_Header = qq{<SOAP-ENV:Header>
  <MerchantServiceProviderCredentials xmlns="http://ws.buysafe.com">
    <UserName>$sc_buysafe_USERNAME</UserName>
    <Password>$sc_buysafe_PASSWORD</Password>
  </MerchantServiceProviderCredentials>
  <BuySafeUserCredentials xmlns="http://ws.buysafe.com">
    <AuthenticationTokens>
      <string>$sc_buysafe_STORE_TOKEN</string>
    </AuthenticationTokens>
  </BuySafeUserCredentials>
  <BuySafeWSHeader xmlns="http://ws.buysafe.com">
    <Version>$sc_buysafe_VERSION</Version>
  </BuySafeWSHeader>
</SOAP-ENV:Header>};


  use LWP::UserAgent;
  my $SOAP_Method = shift || die "Missing required parameter 1, buySafe Request Type";
  my $SOAP_Body   = shift || die "Missing required parameter 2, SOAP body data";
  my $ua = LWP::UserAgent->new;
  my $req = HTTP::Request->new(POST => $sc_buysafe_URL);
  $req->content_type('text/xml');
  $req->header(SOAPAction => "http://ws.buysafe.com/$SOAP_Method");
  $req->content(qq{<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/1999/XMLSchema-instance" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/1999/XMLSchema" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
$sc_buysafe_SOAP_Header
<SOAP-ENV:Body>
$SOAP_Body
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
});

  # debug
  # print "<br><br>Request:<br>" . $req->as_string;
  # print "<br><br>Sending POST to [$sc_buysafe_URL]<br>";

  my $res = $ua->request($req);

  # debug
  # print "<br><br>Response:<br>" . $res->as_string;

  return($res->content);
}
###############################################################################
sub cancel_individual_buysafe_bond {

# &ReadParse;
 $in{'customerNumber'} =~ /([\w\=\+\.]+)/;
 my $cust_number = "$1";
 my $cust_thingy = $sc_domain_name_for_cookie . "-" . $cust_number;

 $in{'invNumber'} =~ /([\w\=\+\.]+)/;
 my $inv_number = "$1";

$in{'buyMonth'} =~ /([\w]+)/;
my $buyMonth = "$1";
$in{'buyYear'} =~ /([\w]+)/;
my $buyYear = "$1";

print &$manager_page_header("Cancelled buySAFE Bond on order: $cust_number","","","","");

 my $BodyofCancelBond .= qq{    <SetShoppingCartCancelOrder xmlns="http://ws.buysafe.com">
 <SetShoppingCartCancelOrderRQ>
 <ShoppingCartId>$cust_thingy</ShoppingCartId>
 </SetShoppingCartCancelOrderRQ>
 </SetShoppingCartCancelOrder>
}; # end of  $BodyofCancelBond

            #send her off to buySafe
            my $responseCancelBond = &buysafe_sendcancelRequest('SetShoppingCartCancelOrder', $BodyofCancelBond);

           # parse results
            use XML::Simple;
            my $xml             = XMLin($responseCancelBond);
            my $isSuccessful    = $xml->{'soap:Header'}->{TransactionStatus}->{isSuccessful};
            my $CancelRS_id     = $xml->{'soap:Header'}->{TransactionStatus}->{TransactionId};

           # debug
           # print "\$isSuccessful = $isSuccessful <br>";
           # print "\$CancelRS_id = $CancelRS_id <br>";

if ($isSuccessful eq "true") {
#################################################
    my ($cart_string,$cart_string_short,$orderLogString,$orderLogString2,$orderLogString3) = '';
    my ($logfile)= "$sc_logs_dir/$sc_order_log_name";
    my ($filename3) = "$sc_order_log_directory_path/$buyYear/$buyMonth/$buyMonth$buyYear";
    my ($filename8) = "$sc_order_log_directory_path/$buyYear/$buyMonth/$inv_number"."-"."$cust_number"."$scm_orderdata_ext";
    my ($filename11) = "$sc_order_log_directory_path/$buyYear/$buyMonth$buyYear";
    my $filename5 = "$filename11$scm_monthyearmasterlog_name";
    my $filename6 = "$sc_order_log_directory_path/$buyYear/$buyMonth/$inv_number-$cust_number-orderdata2";
    my $buyDate = &get_date;

# short monthly master log
if ($sc_write_monthly_short_order_logs =~ /yes/i) {
           $filename4 = "$filename3$scm_monthyearindexlog_name";
           open (ORDERLOG4, "$filename4");
           while (<ORDERLOG4>) {
               if ($_ =~ /$inv_number/) {
# split it out
        ($in{'year'},$in{'month'},$in{'day'},$in{'invoiceNumber'},$in{'customerNumber'},$in{'orderStatus'},$in{'firstName'},$in{'lastName'},$in{'fullName'},$in{'companyName'},$in{'emailAddress'},$in{'orderFromState'},$in{'orderFromPostal'},$in{'orderFromCountry'},$in{'shipMethod'},$in{'shippingTotal'},$in{'salesTax'},$in{'tax1'},$in{'tax2'},$in{'tax3'},$in{'discounts'},$in{'netProfit'},$in{'subTotal'},$in{'orderTotal'},$in{'affiliateTotal'},$in{'affiliateID'},$in{'affiliateMisc'},$in{'GatewayUsed'},$in{'buySafe'}) = split(/\t/,$_);

$in{'adminMessages'} .= "<br>buySAFE fees removed manually by admin: $buyDate<br>";
$in{'orderTotal'} = &format_pricemgr($in{'orderTotal'} - $in{'buySafe'});
$in{'buySafe'} = ""; # zero out buysafe fees

     $cart_string_short = "$in{'year'}\t$in{'month'}\t$in{'day'}\t$in{'invoiceNumber'}\t$in{'customerNumber'}\t$in{'orderStatus'}\t$in{'firstName'}\t$in{'lastName'}\t$in{'fullName'}\t$in{'companyName'}\t$in{'emailAddress'}\t$in{'orderFromState'}\t$in{'orderFromPostal'}\t$in{'orderFromCountry'}\t$in{'shipMethod'}\t$in{'shippingTotal'}\t$in{'salesTax'}\t$in{'tax1'}\t$in{'tax2'}\t$in{'tax3'}\t$in{'discounts'}\t$in{'netProfit'}\t$in{'subTotal'}\t$in{'orderTotal'}\t$in{'affiliateTotal'}\t$in{'affiliateID'}\t$in{'affiliateMisc'}\t$in{'GatewayUsed'}\t$in{'buySafe'}\n";
                   $orderLogString .= $cart_string_short;
               } else {
                   $orderLogString .= $_;
               }
           }
           close (ORDERLOG4);
&get_file_lock("$logfile.lockfile");
           open (ORDERLOG4, ">$filename4");
           print ORDERLOG4 $orderLogString;
           close (ORDERLOG4);
&release_file_lock("$logfile.lockfile");
}


# master log - all details for all orders each month of each year
 if ($sc_write_monthly_master_order_logs =~ /yes/i) {
           open (ORDERLOG5, "$filename5");
           while (<ORDERLOG5>) {
               if ($_ =~ /$inv_number/) {
        ($in{'year'},$in{'month'},$in{'day'},$in{'invoiceNumber'},$in{'customerNumber'},$in{'orderStatus'},$in{'shiptrackingID'},$in{'firstName'},$in{'lastName'},$in{'fullName'},$in{'companyName'},$in{'customerPhone'},$in{'faxNumber'},$in{'emailAddress'},$in{'orderFromAddress'},$in{'customerAddress2'},$in{'customerAddress3'},$in{'orderFromCity'},$in{'orderFromState'},$in{'orderFromPostal'},$in{'orderFromCountry'},$in{'shipToName'},$in{'shipToAddress'},$in{'shipToAddress2'},$in{'shipToAddress3'},$in{'shipToCity'},$in{'shipToState'},$in{'shipToPostal'},$in{'shipToCountry'},$in{'shiptoResidential'},$in{'insureShipment'},$in{'shipMethod'},$in{'shippingTotal'},$in{'salesTax'},$in{'tax1'},$in{'tax2'},$in{'tax3'},$in{'discounts'},$in{'netProfit'},$in{'subTotal'},$in{'orderTotal'},$in{'affiliateTotal'},$in{'affiliateID'},$in{'affiliateMisc'},$in{'user1'},$in{'user2'},$in{'user3'},$in{'user4'},$in{'user5'},$in{'adminMessages'},$in{'cartContents'},$in{'GatewayUsed'},$in{'shippingMessages'},$in{'xcomments'},$in{'termsOfService'},$in{'discountCode'},$in{'user6'},$in{'user7'},$in{'user8'},$in{'user9'},$in{'user10'},$in{'buySafe'},$in{'order_payment_type_user1'},$in{'order_payment_type_user2'},$in{'GiftCard_number'},$in{'GiftCard_amount_used'},$in{'internal_company_notes1'},$in{'internal_company_notes2'},$in{'internal_company_notes2'},$in{'customer_order_notes1'},$in{'customer_order_notes2'},$in{'customer_order_notes3'},$in{'customer_order_notes4'},$in{'customer_order_notes5'},$in{'mailinglist_subscribe'},$in{'wishlist_subscribe'},$in{'insurance_cost'},$in{'trade_in_allowance'},$in{'rma_number'},$in{'customer_contact_notes1'},$in{'customer_contact_notes2'},$in{'account_number'},$in{'sales_rep'},$in{'sales_rep_notes1'},$in{'sales_rep_notes2'},$in{'how_did_you_find_us'},$in{'suggestion_box'},$in{'preferrred_shipping_date'},$in{'ship_order_items_as_available'}) = split(/\t/,$stuff);

$in{'adminMessages'} .= "<br>buySAFE fees removed manually by admin: $buyDate<br>";
$in{'orderTotal'} = &format_pricemgr($in{'orderTotal'} - $in{'buySafe'});
$in{'buySafe'} = ""; # zero out buysafe fees

     $cart_string = "$in{'year'}\t$in{'month'}\t$in{'day'}\t$in{'invoiceNumber'}\t$in{'customerNumber'}\t$in{'orderStatus'}\t$in{'shiptrackingID'}\t$in{'firstName'}\t$in{'lastName'}\t$in{'fullName'}\t$in{'companyName'}\t$in{'customerPhone'}\t$in{'faxNumber'}\t$in{'emailAddress'}\t$in{'orderFromAddress'}\t$in{'customerAddress2'}\t$in{'customerAddress3'}\t$in{'orderFromCity'}\t$in{'orderFromState'}\t$in{'orderFromPostal'}\t$in{'orderFromCountry'}\t$in{'shipToName'}\t$in{'shipToAddress'}\t$in{'shipToAddress2'}\t$in{'shipToAddress3'}\t$in{'shipToCity'}\t$in{'shipToState'}\t$in{'shipToPostal'}\t$in{'shipToCountry'}\t$in{'shiptoResidential'}\t$in{'insureShipment'}\t$in{'shipMethod'}\t$in{'shippingTotal'}\t$in{'salesTax'}\t$in{'tax1'}\t$in{'tax2'}\t$in{'tax3'}\t$in{'discounts'}\t$in{'netProfit'}\t$in{'subTotal'}\t$in{'orderTotal'}\t$in{'affiliateTotal'}\t$in{'affiliateID'}\t$in{'affiliateMisc'}\t$in{'user1'}\t$in{'user2'}\t$in{'user3'}\t$in{'user4'}\t$in{'user5'}\t$in{'adminMessages'}\t$cartlog_string_thingy\t$in{'GatewayUsed'}\t$in{'shippingMessages'}\t$in{'xcomments'}\t$in{'termsOfService'}\t$in{'discountCode'}\t$in{'user6'}\t$in{'user7'}\t$in{'user8'}\t$in{'user9'}\t$in{'user10'}\t$in{'buySafe'}\t$in{'order_payment_type_user1'}\t$in{'order_payment_type_user2'}\t$in{'GiftCard_number'}\t$in{'GiftCard_amount_used'}\t$in{'internal_company_notes1'}\t$in{'internal_company_notes2'}\t$in{'internal_company_notes2'}\t$in{'customer_order_notes1'}\t$in{'customer_order_notes2'}\t$in{'customer_order_notes3'}\t$in{'customer_order_notes4'}\t$in{'customer_order_notes5'}\t$in{'mailinglist_subscribe'}\t$in{'wishlist_subscribe'}\t$in{'insurance_cost'}\t$in{'trade_in_allowance'}\t$in{'rma_number'}\t$in{'customer_contact_notes1'}\t$in{'customer_contact_notes2'}\t$in{'account_number'}\t$in{'sales_rep'}\t$in{'sales_rep_notes1'}\t$in{'sales_rep_notes2'}\t$in{'how_did_you_find_us'}\t$in{'suggestion_box'}\t$in{'preferrred_shipping_date'}\t$in{'ship_order_items_as_available'}";

                   $orderLogString2 .= $cart_string;
               } else {
                   $orderLogString2 .= $_;
               }
           }
           close (ORDERLOG5);
&get_file_lock("$logfile.lockfile");
           open (ORDERLOG5, ">$filename5");
           print ORDERLOG5 $orderLogString2;
           close (ORDERLOG5);
&release_file_lock("$logfile.lockfile");

}

if ($sc_write_individual_order_logs =~ /yes/i) {

           open (ORDERLOG6, "$filename6");
               my $stuff = <ORDERLOG6>;
           close (ORDERLOG6);

        ($in{'year'},$in{'month'},$in{'day'},$in{'invoiceNumber'},$in{'customerNumber'},$in{'orderStatus'},$in{'shiptrackingID'},$in{'firstName'},$in{'lastName'},$in{'fullName'},$in{'companyName'},$in{'customerPhone'},$in{'faxNumber'},$in{'emailAddress'},$in{'orderFromAddress'},$in{'customerAddress2'},$in{'customerAddress3'},$in{'orderFromCity'},$in{'orderFromState'},$in{'orderFromPostal'},$in{'orderFromCountry'},$in{'shipToName'},$in{'shipToAddress'},$in{'shipToAddress2'},$in{'shipToAddress3'},$in{'shipToCity'},$in{'shipToState'},$in{'shipToPostal'},$in{'shipToCountry'},$in{'shiptoResidential'},$in{'insureShipment'},$in{'shipMethod'},$in{'shippingTotal'},$in{'salesTax'},$in{'tax1'},$in{'tax2'},$in{'tax3'},$in{'discounts'},$in{'netProfit'},$in{'subTotal'},$in{'orderTotal'},$in{'affiliateTotal'},$in{'affiliateID'},$in{'affiliateMisc'},$in{'user1'},$in{'user2'},$in{'user3'},$in{'user4'},$in{'user5'},$in{'adminMessages'},$in{'cartContents'},$in{'GatewayUsed'},$in{'shippingMessages'},$in{'xcomments'},$in{'termsOfService'},$in{'discountCode'},$in{'user6'},$in{'user7'},$in{'user8'},$in{'user9'},$in{'user10'},$in{'buySafe'},$in{'order_payment_type_user1'},$in{'order_payment_type_user2'},$in{'GiftCard_number'},$in{'GiftCard_amount_used'},$in{'internal_company_notes1'},$in{'internal_company_notes2'},$in{'internal_company_notes2'},$in{'customer_order_notes1'},$in{'customer_order_notes2'},$in{'customer_order_notes3'},$in{'customer_order_notes4'},$in{'customer_order_notes5'},$in{'mailinglist_subscribe'},$in{'wishlist_subscribe'},$in{'insurance_cost'},$in{'trade_in_allowance'},$in{'rma_number'},$in{'customer_contact_notes1'},$in{'customer_contact_notes2'},$in{'account_number'},$in{'sales_rep'},$in{'sales_rep_notes1'},$in{'sales_rep_notes2'},$in{'how_did_you_find_us'},$in{'suggestion_box'},$in{'preferrred_shipping_date'},$in{'ship_order_items_as_available'}) = split(/\t/,$stuff);

$in{'adminMessages'} .= "<br>buySAFE fees removed manually by admin: $buyDate<br>";
$in{'orderTotal'} = &format_pricemgr($in{'orderTotal'} - $in{'buySafe'});
$in{'buySafe'} = ""; # zero out buysafe fees

     $cart_string = "$in{'year'}\t$in{'month'}\t$in{'day'}\t$in{'invoiceNumber'}\t$in{'customerNumber'}\t$in{'orderStatus'}\t$in{'shiptrackingID'}\t$in{'firstName'}\t$in{'lastName'}\t$in{'fullName'}\t$in{'companyName'}\t$in{'customerPhone'}\t$in{'faxNumber'}\t$in{'emailAddress'}\t$in{'orderFromAddress'}\t$in{'customerAddress2'}\t$in{'customerAddress3'}\t$in{'orderFromCity'}\t$in{'orderFromState'}\t$in{'orderFromPostal'}\t$in{'orderFromCountry'}\t$in{'shipToName'}\t$in{'shipToAddress'}\t$in{'shipToAddress2'}\t$in{'shipToAddress3'}\t$in{'shipToCity'}\t$in{'shipToState'}\t$in{'shipToPostal'}\t$in{'shipToCountry'}\t$in{'shiptoResidential'}\t$in{'insureShipment'}\t$in{'shipMethod'}\t$in{'shippingTotal'}\t$in{'salesTax'}\t$in{'tax1'}\t$in{'tax2'}\t$in{'tax3'}\t$in{'discounts'}\t$in{'netProfit'}\t$in{'subTotal'}\t$in{'orderTotal'}\t$in{'affiliateTotal'}\t$in{'affiliateID'}\t$in{'affiliateMisc'}\t$in{'user1'}\t$in{'user2'}\t$in{'user3'}\t$in{'user4'}\t$in{'user5'}\t$in{'adminMessages'}\t$cartlog_string_thingy\t$in{'GatewayUsed'}\t$in{'shippingMessages'}\t$in{'xcomments'}\t$in{'termsOfService'}\t$in{'discountCode'}\t$in{'user6'}\t$in{'user7'}\t$in{'user8'}\t$in{'user9'}\t$in{'user10'}\t$in{'buySafe'}\t$in{'order_payment_type_user1'}\t$in{'order_payment_type_user2'}\t$in{'GiftCard_number'}\t$in{'GiftCard_amount_used'}\t$in{'internal_company_notes1'}\t$in{'internal_company_notes2'}\t$in{'internal_company_notes2'}\t$in{'customer_order_notes1'}\t$in{'customer_order_notes2'}\t$in{'customer_order_notes3'}\t$in{'customer_order_notes4'}\t$in{'customer_order_notes5'}\t$in{'mailinglist_subscribe'}\t$in{'wishlist_subscribe'}\t$in{'insurance_cost'}\t$in{'trade_in_allowance'}\t$in{'rma_number'}\t$in{'customer_contact_notes1'}\t$in{'customer_contact_notes2'}\t$in{'account_number'}\t$in{'sales_rep'}\t$in{'sales_rep_notes1'}\t$in{'sales_rep_notes2'}\t$in{'how_did_you_find_us'}\t$in{'suggestion_box'}\t$in{'preferrred_shipping_date'}\t$in{'ship_order_items_as_available'}";

   &get_file_lock("$filename6.lockfile");
   open (ORDERLOG6, ">$filename6");
   print ORDERLOG6 $cart_string;
   close (ORDERLOG6);
   &release_file_lock("$filename6.lockfile");

}


# overview log - new orders
 if ($sc_send_order_to_log =~ /yes/i) {
           open (ORDERLOG, "$logfile");
           while (<ORDERLOG>) {
               if ($_ =~ /$inv_number/) {
# split it out
        ($in{'year'},$in{'month'},$in{'day'},$in{'invoiceNumber'},$in{'customerNumber'},$in{'orderStatus'},$in{'firstName'},$in{'lastName'},$in{'fullName'},$in{'companyName'},$in{'emailAddress'},$in{'orderFromState'},$in{'orderFromPostal'},$in{'orderFromCountry'},$in{'shipMethod'},$in{'shippingTotal'},$in{'salesTax'},$in{'tax1'},$in{'tax2'},$in{'tax3'},$in{'discounts'},$in{'netProfit'},$in{'subTotal'},$in{'orderTotal'},$in{'affiliateTotal'},$in{'affiliateID'},$in{'affiliateMisc'},$in{'GatewayUsed'},$in{'buySafe'}) = split(/\t/,$_);

$in{'adminMessages'} .= "<br>buySAFE fees removed manually by admin: $buyDate<br>";
$in{'orderTotal'} = &format_pricemgr($in{'orderTotal'} - $in{'buySafe'});
$in{'buySafe'} = ""; # zero out buysafe fees

     $cart_string_short = "$in{'year'}\t$in{'month'}\t$in{'day'}\t$in{'invoiceNumber'}\t$in{'customerNumber'}\t$in{'orderStatus'}\t$in{'firstName'}\t$in{'lastName'}\t$in{'fullName'}\t$in{'companyName'}\t$in{'emailAddress'}\t$in{'orderFromState'}\t$in{'orderFromPostal'}\t$in{'orderFromCountry'}\t$in{'shipMethod'}\t$in{'shippingTotal'}\t$in{'salesTax'}\t$in{'tax1'}\t$in{'tax2'}\t$in{'tax3'}\t$in{'discounts'}\t$in{'netProfit'}\t$in{'subTotal'}\t$in{'orderTotal'}\t$in{'affiliateTotal'}\t$in{'affiliateID'}\t$in{'affiliateMisc'}\t$in{'GatewayUsed'}\t$in{'buySafe'}\n";
                   $orderLogString3 .= $cart_string_short;
               } else {
                   $orderLogString3 .= $_;
               }
           }
           close (ORDERLOG);
&get_file_lock("$logfile.lockfile");
           open (ORDERLOG, ">$logfile");
           print ORDERLOG $orderLogString3;
           close (ORDERLOG);
&release_file_lock("$logfile.lockfile");
}

#################################################
print <<ENDOFTEXT;
<center>
<table width="580">
<tr>
<td align="center"><br/>
<font face="arial" size="+1" color="red">Success!<br/></font><font face="arial" size="2" color="red">The buySAFE surety bond on Order# $cust_number has been successfully cancelled.<br/>The Cancellation ID# is:  $CancelRS_id.  Make sure to record this number for future reference<br /><br /></font>
</td>
</tr>
<tr>
<td colspan="2"><hr width="580" /></td>
</tr>
</table>
</center>
ENDOFTEXT
} 
else {
print <<ENDOFTEXT;
<center>
<table width="580">
<tr>
<td align="center"><br/>
<font face="arial" size="+1" color="red">Failure!<br/></font><font face="arial" size="2" color="red">The buySAFE surety bond on Order# $inv_number has NOT been cancelled. It either was already cancelled or did not exist as a finalized bonded order.<br /><br /></font>
</td>
</tr>
<tr>
<td colspan="2"><hr width="580" /></td>
</tr>
</table>
</center>
ENDOFTEXT
}

print <<ENDOFTEXT;
<center>
<br /><br /><br />
<a href="manager.cgi?order_log=yes"><font face="arial" size="+1">Back to New Orders Screen</font></a>
<br /><br /><br />
</center>
ENDOFTEXT

print &$manager_page_footer;
}
#######################################################################################
1; # Library
