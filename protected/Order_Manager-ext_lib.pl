# file ./store/protected/Order_Manager-ext_lib.pl
#########################################################################
#
# Created by Mister Ed 2004 - 2005
# Copyright (c) 2004 to Date by K-Factor Technologies, Inc. and AgoraScript
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
$versions{'Order_Manager-ext_lib.pl'} = "5.2.000";

# fax number added March 11, 2006 and otehr little fixes on phone nembers by Mister Ed

$scm_orderdata_ext =  "-orderdata2";
$scm_completecart_ext =  "-complete2";

$scm_monthyearmasterlog_name = "_MasterOrderLog.log2";
$scm_monthyearindexlog_name = "_indexOrderLog.log2";
$scm_productlog_name = "_productSalesLog.prd2";

{
 local ($modname) = 'order_management';
 &register_extension($modname,"Order Management",$versions{$modname});
   &register_menu('display_Order_mgr_screen',"display_Order_mgr_screen",
  $modname,"Order Management - Store Settings");
 &add_settings_choice("Order Management Settings"," Order Management Settings ",
  "display_Order_mgr_screen");
 &register_menu('OrderManagementSettings',"write_Order_mgr_settings",
  $modname,"Write Order Settings");

#not done
 &add_item_to_manager_menu("Order Management","order_management_settings_screen=yes","");
   &register_menu('select_individual_order_screen',"select_individual_order_screen",
  $modname,"View Individual Order");
   &add_ordermanage_settings_choice("View Individual Order"," View / Update Individual Order ",
  "select_individual_order_screen");
   &register_menu('select_monthly_orders_screen',"select_monthly_orders_screen",
  $modname,"View Orders within a Month");
   &add_ordermanage_settings_choice("View Orders - Select by Month"," View Orders - Select by Month ",
  "select_monthly_orders_screen");
 &register_menu('CompileMonthlyOrdersReport',"compile_Monthly_Order_information",
  $modname,"Create Order List for a Month");
   &register_menu('display_productsales_report_screen',"display_productsales_report_screen",
  $modname,"Product Sales Report - Basic");
   &add_ordermanage_settings_choice("Product Sales Report"," Product Sales Report - Basic ",
  "display_productsales_report_screen");
   &register_menu('select_delete_order_screen',"select_delete_order_screen",
  $modname,"Remove or Delete Order or log entry");
   &add_ordermanage_settings_choice("Remove or Delete Order or log entry"," Remove Order Files / Log Entry ",
  "select_delete_order_screen");
}
   &register_menu('viewertrigger',"select2_individual_order_screen",
  $modname,"viewertrigger");
   &register_menu('invoiceviewertrigger',"print_order_invoice",
  $modname,"invoiceviewertrigger");
   &register_menu('originalviewertrigger',"view_Original_order_log",
  $modname,"originalviewertrigger");
   &register_menu('packingviewertrigger',"print_order_packingslip",
  $modname,"packingviewertrigger");
   &register_menu('deleteviewertrigger',"select_delete_order_screen",
  $modname,"deleteviewertrigger");
 &register_menu('OpenIndividualOrder',"select_individual_order_screen",
  $modname,"View Order builder");
 &register_menu('UpdateIndividualOrder',"write_individual_Order_information",
  $modname,"Write Order updates");
   &register_menu('ViewProductSales',"display_productsales_report_screen",
  $modname,"Product Sales Report - Basic - New Lookup");
   &register_menu('DeleteIndividualOrder',"delete_Order_or_Order_Log",
  $modname,"Delete Order ffiles or sales logs routines");
################################################################################
sub write_Order_mgr_settings {
local($myset)="";

&ReadParse;

$myset .= "\$sc_order_log_name = \"$in{'name_of_the_log_file'}\";\n";
$myset .= "\$sc_send_order_to_log = \"$in{'log_orders_yes_no'}\";\n";
$myset .= "\$sc_write_individual_order_logs = \"$in{'sc_write_individual_order_logs'}\";\n";
$myset .= "\$sc_write_monthly_master_order_logs = \"$in{'sc_write_monthly_master_order_logs'}\";\n";
$myset .= "\$sc_write_monthly_short_order_logs = \"$in{'sc_write_monthly_short_order_logs'}\";\n";
$myset .= "\$sc_write_product_sales_logs = \"$in{'sc_write_product_sales_logs'}\";\n";
$myset .= "\$sc_defaultProductStatus = \"$in{'sc_defaultProductStatus'}\";\n";
$myset .= "\$sc_order_status_default = \"$in{'sc_order_status_default'}\";\n";
$myset .= "\$sc_item_Total_Weight = \"$in{'sc_item_Total_Weight'}\";\n";

&update_store_settings('ORDERMANAGER',$myset);
  &display_Order_mgr_screen;
 }
#######################################################################################
sub delete_Order_or_Order_Log {

&ReadParse;
#untaint a few thingies
 $in{'invoiceNumber'} =~ /([\w\=\+]+)/;
 my $invoiceNum = "$1";
 $in{'customerNumber'} =~ /([\w\-\=\+\/]+)\.(\w+)/;
 my $cust_id = "$1.$2";
 $in{'month'} =~ /([\w\=\+]+)/;
 my $month = "$1";
 $in{'year'} =~ /([\w\=\+]+)/;
 my $year = "$1";

    my ($cart_string,$cart_string_short,$orderLogString,$orderLogString2,$orderLogString3) = '';
    my ($logfile)= "$sc_logs_dir/$sc_order_log_name";
    my ($filename3) = "$sc_order_log_directory_path/$year/$month/$month$year";
    my ($filename8) = "$sc_order_log_directory_path/$year/$month/$invoiceNum"."-"."$cust_id"."$scm_orderdata_ext";
    my ($filename9) = "$sc_order_log_directory_path/$year/$month/$invoiceNum"."-"."$cust_id"."$scm_completecart_ext";
    my ($filename10) = "$sc_order_log_directory_path/$year/$month/";
    my ($filename11) = "$sc_order_log_directory_path/$year/$month$year";
    my ($filename12) = "$sc_order_log_directory_path/$year/";

if (($in{'deletionType'} =~ /individual/i) && ($in{'deleteIndividualData'} =~ /yes/i)) {
    unlink("$filename8") || print "Error: could not unlink $filename8<br>";
}

if (($in{'deletionType'} =~ /individual/i) && ($in{'deleteIndividualComplete'} =~ /yes/i)) {
    unlink("$filename9") || print "Error: could not delete $filename9<br>";
}

if (($in{'deletionType'} =~ /month/i) && ($month ne '') && ($year ne '')) {
if (-e $filename10) {
  opendir(LOGFILEDIR,"$filename10")|| print "Cannot open $filename10 Directory<br>";
  my @dirfilenames = readdir(LOGFILEDIR);
  close (LOGFILEDIR);
  foreach $dirfilenames(@dirfilenames) {
      if ($dirfilenames =~ /[\d]+/) {
         my $tempfilename = "$filename10$dirfilenames";
         $tempfilename =~ /([\w\=\+\.\-\/]+)/;
         $tempfilename = "$1";
         unlink("$tempfilename") || print "Error: could not delete $tempfilename<br>";
         }
  }
  rmdir("$filename10");
}
}
if (($in{'deletionType'} =~ /year/i) && ($year ne '')) {
  opendir(LOGFILEDIR,"$filename12")|| print "Error: Cannot open $filename12 Directory<br>";
  my @dirfilenames = readdir(LOGFILEDIR);
  close (LOGFILEDIR);
      foreach $dirfilenames(@dirfilenames) {
      if ($dirfilenames =~ /[\w]+/) {
             if (-d "$filename12$dirfilenames") {
                 opendir(MONTHLOGFILES,"$filename12$dirfilenames")|| print "Error: Cannot open $filename12$dirfilenames Directory!<br>";
                 my @permonthfilenames = readdir(MONTHLOGFILES);
                 close (MONTHLOGFILES);
                 foreach $permonthfilenames(@permonthfilenames) {
                     if ($permonthfilenames =~ /[\w]+/) {
                         my $permonthtempfilename = "$filename12$dirfilenames/$permonthfilenames";
                         $permonthtempfilename =~ /([\w\=\+\.\-\/]+)/;
                         $permonthtempfilename = "$1";
                         unlink("$permonthtempfilename");
                     }
                 }
                 $dirfilenames =~ /([\w\=\+\.\-\/]+)/;
                 $dirfilenames = "$1";
                 rmdir("$filename12$dirfilenames");
             } else {
         my $tempfilename = "$filename12$dirfilenames";
         $tempfilename =~ /([\w\=\+\.\-\/]+)/;
         $tempfilename = "$1";
         unlink("$tempfilename") || print "Error: could not unlink $tempfilename<br>";
             }
      }
      }

 rmdir("$filename12");
}

if (($sc_write_monthly_short_order_logs =~ /yes/i) && ($in{'deletionType'} =~ /individual/i) && ($in{'deleteIndividualOverviewSalesLog'} =~ /yes/i)){
           $filename4 = "$filename3$scm_monthyearindexlog_name";
           open (ORDERLOG4, "$filename4");
           while (<ORDERLOG4>) {
               if (($_ =~ /$invoiceNum/) && ($_ =~ /$cust_id/)) {
                   # dead space
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

 if (($sc_write_monthly_master_order_logs =~ /yes/i) && ($in{'deletionType'} =~ /individual/i) && ($in{'deleteIndividualMasterSalesLog'} =~ /yes/i)) {
           $filename5 = "$filename11$scm_monthyearmasterlog_name";
           open (ORDERLOG5, "$filename5");
           while (<ORDERLOG5>) {
               if (($_ =~ /$invoiceNum/) && ($_ =~ /$cust_id/)) {
                   # dead space
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

 if (($sc_send_order_to_log =~ /yes/i) && ($in{'deletionType'} =~ /individual/i) && ($in{'deleteIndividualNewOrderLog'} =~ /yes/i)) {
           open (ORDERLOG, "$logfile");
           while (<ORDERLOG>) {
               if (($_ =~ /$invoiceNum/) && ($_ =~ /$cust_id/)) {
                   # dead space
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
    %in = '';
   &select_delete_order_screen;
}
#######################################################################################
sub view_Original_order_log {
my($year,$month,$inv_number,$filename,$cust_id,$stuff,$line,$new_output);
$month = $in{'month'};
$year = $in{'year'};
$inv_number = $in{'invoiceNumber'};
$cust_id = $in{'customerNumber'};
$filename = "$sc_order_log_directory_path/$year/$month/$inv_number"."-"."$cust_id"."$scm_completecart_ext";

print &$manager_page_header("Individual Order Management - Complete Original Order Log","","","","");

print qq~
<center><br>
<a href="manager.cgi?invoiceviewertrigger=invoiceviewertrigger&invoiceNumber=$in{'invoiceNumber'}&customerNumber=$in{'customerNumber'}&year=$year&month=$month" target="_new">View Invoice</a>  |  <a href="manager.cgi?viewertrigger=viewertrigger&invoiceNumber=$in{'invoiceNumber'}&customerNumber=$in{'customerNumber'}&year=$year&month=$month">View/Update</a>  |  <a href="manager.cgi?packingviewertrigger=packingviewertrigger&invoiceNumber=$in{'invoiceNumber'}&customerNumber=$in{'customerNumber'}&year=$year&month=$month" target="_new">Packing Slip</a>
<br><br></center>
~;

    if (-e $filename) {
        open (ORDERLOGLOOK, "$filename");
        while ($stuff=<ORDERLOGLOOK>) {
            print "$stuff<br>";
        }
        close (ORDERLOGLOOK);
    }

print &$manager_page_footer;

}
#######################################################################################
sub display_productsales_report_screen {
my($year,$filename,$stuff,$item,$qty,$new_output) ='';
$year = $in{'year'};
$filename = "$sc_order_log_directory_path/$year"."$scm_productlog_name";

    if (-e $filename) {
        $new_output .= "<table border=0 cellpadding=3>";
        open (PRODUCTLOGLOOK, "$filename");
        while ($stuff=<PRODUCTLOGLOOK>) {
            ($item,$qty) = split("\t",$stuff);
            $new_output .= "<tr><td><font face=arial size=2>$item</font></td><td><font face=arial size=2>&nbsp;&nbsp;$qty</font></td></tr>";
        }
        close (PRODUCTLOGLOOK);
        $new_output .= "</table>";
    }

print &$manager_page_header("Product Sales Log","","","","");

print qq~
<CENTER>
<FORM METHOD="POST" ACTION="manager.cgi">
<TABLE width=700>
<TR>
<TD><br></TD>
</TR>
<TR>
<TD COLSPAN=2 BGCOLOR="#99CC99" align=center><font face="Arial, Helvetica, sans-serif" size=+2><b>Indvidual Product Sales for $year</b></font></TD>
</TR>
<TR>
<TD><br></TD>
</TR>
<TR>
<TD colspan=4>
<TABLE width=700>
<TR>
<TD colspan=2>
<font size="2" face="Arial, Helvetica, sans-serif">

</font></TD>
<TD colspan=2 valign=top><font size="2" face="Arial, Helvetica, sans-serif"><CENTER>
<b>Select a Product Year to View</b>: <SELECT NAME="year">
$scm_yearlinks
</SELECT>
<INPUT TYPE="HIDDEN" NAME="system_edit_success" VALUE="yes">
<INPUT NAME="ViewProductSales" TYPE="SUBMIT" VALUE="View Products Sold Report">
</CENTER>
<br>
</font>
</TD>
</TR></table>
</TD>
</TR>
$new_output
</TABLE></form></form>
</CENTER>
~;

print &$manager_page_footer;

}
#######################################################################################
sub print_order_packingslip {
my($year,$month,$inv_number,$filename,$filename2,$cust_id,$stuff,$line,$new_output);

my $cartContentsStringViewer = '';
my (@cart_contents_rows) = '';
my $cartrow_counter = "0";
%cart_contents_rowsHash;
$month = $in{'month'};
$year = $in{'year'};
$inv_number = $in{'invoiceNumber'};
$cust_id = $in{'customerNumber'};
$filename = "$sc_order_log_directory_path/$year/$month/$inv_number"."-"."$cust_id"."$scm_orderdata_ext";
$filename2 = "./admin_files/mgrpackingslipTemplate.html";

if ((($in{'invoiceNumber'} ne '') && ($in{'customerNumber'} ne '') && ($in{'year'} ne '') && ($in{'month'} ne '')) || ($in{'packingviewertrigger'} ne '')) {
    if (-e $filename) {
        open (ORDERLOGLOOK, "$filename");
        $stuff=<ORDERLOGLOOK>;
        ($in{'year'},$in{'month'},$in{'day'},$in{'invoiceNumber'},$in{'customerNumber'},$in{'orderStatus'},$in{'shiptrackingID'},$in{'firstName'},$in{'lastName'},$in{'fullName'},$in{'companyName'},$in{'customerPhone'},$in{'faxNumber'},$in{'emailAddress'},$in{'orderFromAddress'},$in{'customerAddress2'},$in{'customerAddress3'},$in{'orderFromCity'},$in{'orderFromState'},$in{'orderFromPostal'},$in{'orderFromCountry'},$in{'shipToName'},$in{'shipToAddress'},$in{'shipToAddress2'},$in{'shipToAddress3'},$in{'shipToCity'},$in{'shipToState'},$in{'shipToPostal'},$in{'shipToCountry'},$in{'shiptoResidential'},$in{'insureShipment'},$in{'shipMethod'},$in{'shippingTotal'},$in{'salesTax'},$in{'tax1'},$in{'tax2'},$in{'tax3'},$in{'discounts'},$in{'netProfit'},$in{'subTotal'},$in{'orderTotal'},$in{'affiliateTotal'},$in{'affiliateID'},$in{'affiliateMisc'},$in{'user1'},$in{'user2'},$in{'user3'},$in{'user4'},$in{'user5'},$in{'adminMessages'},$in{'cartContents'},$in{'GatewayUsed'},$in{'shippingMessages'},$in{'xcomments'},$in{'termsOfService'},$in{'discountCode'},$in{'user6'},$in{'user7'},$in{'user8'},$in{'user9'},$in{'user10'},$in{'buySafe'},$in{'order_payment_type_user1'},$in{'order_payment_type_user2'},$in{'GiftCard_number'},$in{'GiftCard_amount_used'},$in{'internal_company_notes1'},$in{'internal_company_notes2'},$in{'internal_company_notes2'},$in{'customer_order_notes1'},$in{'customer_order_notes2'},$in{'customer_order_notes3'},$in{'customer_order_notes4'},$in{'customer_order_notes5'},$in{'mailinglist_subscribe'},$in{'wishlist_subscribe'},$in{'insurance_cost'},$in{'trade_in_allowance'},$in{'rma_number'},$in{'customer_contact_notes1'},$in{'customer_contact_notes2'},$in{'account_number'},$in{'sales_rep'},$in{'sales_rep_notes1'},$in{'sales_rep_notes2'},$in{'how_did_you_find_us'},$in{'suggestion_box'},$in{'preferrred_shipping_date'},$in{'ship_order_items_as_available'}) = split(/\t/,$stuff);
        close (ORDERLOGLOOK);
        @cart_contents_rows = split(/::/,$in{'cartContents'},$in{'GatewayUsed'});
        foreach $cart_contents_rows(@cart_contents_rows) {
            $cart_contents_rowsHash{$cartrow_counter} = $cart_contents_rows;
            $cartrow_counter++;
        }

    } else {
        $in{'system_edit_success'} = "notexist";
    }

}


 my ($quantity,$product,$pid,$category,$price,$shipping,$optionids,$productStatus,$downladables,$altorigin,$nontaxable,$cartuser5,$cartuser6,$formattedoptions,$priceafteroptions,$product_options_sting,$isDownloadble) ="";
        my $Key;
        foreach $Key (sort keys(%cart_contents_rowsHash)) {
        my @cart_fields2 = split(/\|/,$cart_contents_rowsHash{$Key});
        $quantity = $cart_fields2[0];
        $pid = $cart_fields2[1];
        $category = $cart_fields2[2];
        $product = $cart_fields2[4];
        $shipping = $cart_fields2[5];
        $downladables = $cart_fields2[7];
        $altorigin = $cart_fields2[8];
        $nontaxable = $cart_fields2[9];
        $cartuser5 = $cart_fields2[10];
        $cartuser6 = $cart_fields2[11];
        $formattedoptions = $cart_fields2[12];
        $productStatus = $cart_fields2[14];

my @product_formatted_cartoptions = split(/\{/,$formattedoptions);

foreach $product_formatted_cartoptions(@product_formatted_cartoptions) {
$product_options_sting .= "$product_formatted_cartoptions &nbsp;&nbsp;&nbsp;";
}

if ($downladables ne "") {
   $isDownloadable = "&nbsp;&nbsp;&nbsp;<font color=red>This is a Downloadable Product</font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
} else {
   $isDownloadable = "&nbsp;&nbsp;&nbsp;<b>Product Status:</b> $productStatus&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
}
my $itemTotalWeight = &format_pricemgr($quantity * $shipping);
$cartContentsStringViewer .= qq~
<tr>
<td colspan=8><font face=arial size=1><hr width=99%></font>
</td></tr>
<tr>
<td><font face=arial size=1>$product  &nbsp;&nbsp;&nbsp; - &nbsp;&nbsp;&nbsp; $pid &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; $isDownloadable
<b>$sc_item_Total_Weight :</b> $itemTotalWeight
<br><b>Options:</b>&nbsp;&nbsp;$product_options_sting</font></td>
<td><font face=arial size=1>$quantity</font></td>
<td><font face=arial size=1>&nbsp;</font></td>
</tr>
~;
$product_options_sting = "";
        }

    if (($in{'fullName'} eq "") && (($in{'lastName'} ne "") && ($in{'firstName'} ne ""))) {
        $in{'fullName'} = "$in{'firstName'} $in{'lastName'}";
    }

   open (TEMPLATE, "$filename2");
   while ($line = <TEMPLATE>) {
      $line =~ s/%%year%%/$in{'year'}/g;
      $line =~ s/%%day%%/$in{'day'}/g;
      $line =~ s/%%month%%/$in{'month'}/g;
      $line =~ s/%%invoiceNumber%%/$in{'invoiceNumber'}/g;
      $line =~ s/%%customerNumber%%/$in{'customerNumber'}/g;
      $line =~ s/%%orderStatus%%/$in{'orderStatus'}/g;
      $line =~ s/%%shiptrackingID%%/$in{'shiptrackingID'}/g;
      $line =~ s/%%firstName%%/$in{'firstName'}/g;
      $line =~ s/%%lastName%%/$in{'lastName'}/g;
      $line =~ s/%%fullName%%/$in{'fullName'}/g;
      $line =~ s/%%companyName%%/$in{'companyName'}/g;
      $line =~ s/%%customerPhone%%/$in{'customerPhone'}/g;
      $line =~ s/%%faxNumber%%/$in{'faxNumber'}/g;
      $line =~ s/%%emailAddress%%/$in{'emailAddress'}/g;
      $line =~ s/%%orderFromAddress%%/$in{'orderFromAddress'}/g;
      $line =~ s/%%customerAddress2%%/$in{'customerAddress2'}/g;
      $line =~ s/%%customerAddress3%%/$in{'customerAddress3'}/g;
      $line =~ s/%%orderFromCity%%/$in{'orderFromCity'}/g;
      $line =~ s/%%orderFromState%%/$in{'orderFromState'}/g;
      $line =~ s/%%orderFromPostal%%/$in{'orderFromPostal'}/g;
      $line =~ s/%%orderFromCountry%%/$in{'orderFromCountry'}/g;
      $line =~ s/%%shipToName%%/$in{'shipToName'}/g;
      $line =~ s/%%shipToAddress%%/$in{'shipToAddress'}/g;
      $line =~ s/%%shipToAddress2%%/$in{'shipToAddress2'}/g;
      $line =~ s/%%shipToAddress3%%/$in{'shipToAddress3'}/g;
      $line =~ s/%%shipToCity%%/$in{'shipToCity'}/g;
      $line =~ s/%%shipToState%%/$in{'shipToState'}/g;
      $line =~ s/%%shipToPostal%%/$in{'shipToPostal'}/g;
      $line =~ s/%%shipToCountry%%/$in{'shipToCountry'}/g;
      $line =~ s/%%shipToResidential%%/$in{'shiptoResidential'}/g;
      $line =~ s/%%shipToInsured%%/$in{'insureShipment'}/g;
      $line =~ s/%%shipMethod%%/$in{'shipMethod'}/g;
      $line =~ s/%%user1%%/$in{'user1'}/g;
      $line =~ s/%%user2%%/$in{'user2'}/g;
      $line =~ s/%%user3%%/$in{'user3'}/g;
      $line =~ s/%%user4%%/$in{'user4'}/g;
      $line =~ s/%%user5%%/$in{'user5'}/g;
          my ($buysafetext,$buysafeamount) = split(/>/,$in{'buySafe'},2);
          $line =~ s/%%buysafecost%%/$buysafeamount/g;
      $line =~ s/%%adminMessages%%/$in{'adminMessages'}/g;
      $line =~ s/%%cartContents%%/$cartContentsStringViewer/g;
      $line =~ s/%%shippingMessages%%/$in{'shippingMessages'}/g;
      $line =~ s/%%xcomments%%/$in{'xcomments'}/g;
      $line =~ s/%%termsOfService%%/$in{'termsOfService'}/g;
      $line =~ s/%%discountCode%%/$in{'discountCode'}/g;
      $line =~ s/%%user6%%/$in{'user6'}/g;
      $line =~ s/%%user7%%/$in{'user7'}/g;
      $line =~ s/%%user8%%/$in{'user8'}/g;
      $line =~ s/%%user9%%/$in{'user9'}/g;
      $line =~ s/%%user10%%/$in{'user10'}/g;
      $line =~ s/%%order_payment_type_user1%%/$in{'order_payment_type_user1'}/g;
      $line =~ s/%%order_payment_type_user2%%/$in{'order_payment_type_user2'}/g;
      $line =~ s/%%GiftCard_number%%/$in{'GiftCard_number'}/g;
      $line =~ s/%%GiftCard_amount_used%%/$in{'GiftCard_amount_used'}/g;
      $line =~ s/%%internal_company_notes1%%/$in{'internal_company_notes1'}/g;
      $line =~ s/%%internal_company_notes2%%/$in{'internal_company_notes2'}/g;
      $line =~ s/%%internal_company_notes3%%/$in{'internal_company_notes3'}/g;
      $line =~ s/%%customer_order_notes1%%/$in{'customer_order_notes1'}/g;
      $line =~ s/%%customer_order_notes2%%/$in{'customer_order_notes2'}/g;
      $line =~ s/%%customer_order_notes3%%/$in{'customer_order_notes3'}/g;
      $line =~ s/%%customer_order_notes4%%/$in{'customer_order_notes4'}/g;
      $line =~ s/%%customer_order_notes5%%/$in{'customer_order_notes5'}/g;
      $line =~ s/%%mailinglist_subscribe%%/$in{'mailinglist_subscribe'}/g;
      $line =~ s/%%wishlist_subscribe%%/$in{'wishlist_subscribe'}/g;
      $line =~ s/%%insurance_cost%%/$in{'insurance_cost'}/g;
      $line =~ s/%%trade_in_allowance%%/$in{'trade_in_allowance'}/g;
      $line =~ s/%%rma_number%%/$in{'rma_number'}/g;
      $line =~ s/%%customer_contact_notes1%%/$in{'customer_contact_notes1'}/g;
      $line =~ s/%%customer_contact_notes2%%/$in{'customer_contact_notes2'}/g;
      $line =~ s/%%account_number%%/$in{'account_number'}/g;
      $line =~ s/%%sales_rep%%/$in{'sales_rep'}/g;
      $line =~ s/%%sales_rep_notes1%%/$in{'sales_rep_notes1'}/g;
      $line =~ s/%%sales_rep_notes2%%/$in{'sales_rep_notes2'}/g;
      $line =~ s/%%how_did_you_find_us%%/$in{'how_did_you_find_us'}/g;
      $line =~ s/%%suggestion_box%%/$in{'suggestion_box'}/g;
      $line =~ s/%%preferrred_shipping_date%%/$in{'preferrred_shipping_date'}/g;
      $line =~ s/%%ship_order_items_as_available%%/$in{'ship_order_items_as_available'}/g;
      $new_output .= $line;
   }
   close (TEMPLATE);
print "$new_output";

}

#######################################################################################
sub print_order_invoice {
my($year,$month,$inv_number,$filename,$filename2,$cust_id,$stuff,$line,$new_output);

my $cartContentsStringViewer = '';
my (@cart_contents_rows,@cart_temp_rows) = '';
my $cartrow_counter = "0";
%cart_contents_rowsHash;
$month = $in{'month'};
$year = $in{'year'};
$inv_number = $in{'invoiceNumber'};
$cust_id = $in{'customerNumber'};
$filename = "$sc_order_log_directory_path/$year/$month/$inv_number"."-"."$cust_id"."$scm_orderdata_ext";
$filename2 = "./admin_files/mgrinvoiceTemplate.html";

if ((($in{'invoiceNumber'} ne '') && ($in{'customerNumber'} ne '') && ($in{'year'} ne '') && ($in{'month'} ne '')) || ($in{'invoiceviewertrigger'} ne '')) {
    if (-e $filename) {
        open (ORDERLOGLOOK, "$filename");
        $stuff=<ORDERLOGLOOK>;
        ($in{'year'},$in{'month'},$in{'day'},$in{'invoiceNumber'},$in{'customerNumber'},$in{'orderStatus'},$in{'shiptrackingID'},$in{'firstName'},$in{'lastName'},$in{'fullName'},$in{'companyName'},$in{'customerPhone'},$in{'faxNumber'},$in{'emailAddress'},$in{'orderFromAddress'},$in{'customerAddress2'},$in{'customerAddress3'},$in{'orderFromCity'},$in{'orderFromState'},$in{'orderFromPostal'},$in{'orderFromCountry'},$in{'shipToName'},$in{'shipToAddress'},$in{'shipToAddress2'},$in{'shipToAddress3'},$in{'shipToCity'},$in{'shipToState'},$in{'shipToPostal'},$in{'shipToCountry'},$in{'shiptoResidential'},$in{'insureShipment'},$in{'shipMethod'},$in{'shippingTotal'},$in{'salesTax'},$in{'tax1'},$in{'tax2'},$in{'tax3'},$in{'discounts'},$in{'netProfit'},$in{'subTotal'},$in{'orderTotal'},$in{'affiliateTotal'},$in{'affiliateID'},$in{'affiliateMisc'},$in{'user1'},$in{'user2'},$in{'user3'},$in{'user4'},$in{'user5'},$in{'adminMessages'},$in{'cartContents'},$in{'GatewayUsed'},$in{'shippingMessages'},$in{'xcomments'},$in{'termsOfService'},$in{'discountCode'},$in{'user6'},$in{'user7'},$in{'user8'},$in{'user9'},$in{'user10'},$in{'buySafe'},$in{'order_payment_type_user1'},$in{'order_payment_type_user2'},$in{'GiftCard_number'},$in{'GiftCard_amount_used'},$in{'internal_company_notes1'},$in{'internal_company_notes2'},$in{'internal_company_notes2'},$in{'customer_order_notes1'},$in{'customer_order_notes2'},$in{'customer_order_notes3'},$in{'customer_order_notes4'},$in{'customer_order_notes5'},$in{'mailinglist_subscribe'},$in{'wishlist_subscribe'},$in{'insurance_cost'},$in{'trade_in_allowance'},$in{'rma_number'},$in{'customer_contact_notes1'},$in{'customer_contact_notes2'},$in{'account_number'},$in{'sales_rep'},$in{'sales_rep_notes1'},$in{'sales_rep_notes2'},$in{'how_did_you_find_us'},$in{'suggestion_box'},$in{'preferrred_shipping_date'},$in{'ship_order_items_as_available'}) = split(/\t/,$stuff);
        close (ORDERLOGLOOK);
        @cart_contents_rows = split(/::/,$in{'cartContents'},$in{'GatewayUsed'});
        foreach $cart_contents_rows(@cart_contents_rows) {
            $cart_contents_rowsHash{$cartrow_counter} = $cart_contents_rows;
            $cartrow_counter++;
        }
        $in{'salesTax'} = &format_pricemgr($in{'salesTax'});
        $in{'orderTotal'} = &format_pricemgr($in{'orderTotal'});
        $in{'discounts'} = &format_pricemgr($in{'discounts'});
        $in{'shippingTotal'} = &format_pricemgr($in{'shippingTotal'});
        $in{'salesTax'} = &format_pricemgr($in{'salesTax'});
        $in{'tax1'} = &format_pricemgr($in{'tax1'});
        $in{'tax2'} = &format_pricemgr($in{'tax2'});
        $in{'tax3'} = &format_pricemgr($in{'tax3'});
    } else {
        $in{'system_edit_success'} = "notexist";
    }

}
 my ($quantity,$product,$pid,$category,$price,$shipping,$optionids,$productStatus,$downladables,$altorigin,$nontaxable,$cartuser5,$cartuser6,$formattedoptions,$priceafteroptions,$product_options_sting,$isDownloadble) ="";
        my $Key;
        foreach $Key (sort keys(%cart_contents_rowsHash)) {
        my @cart_fields2 = split(/\|/,$cart_contents_rowsHash{$Key});
        $quantity = $cart_fields2[0];
        $pid = $cart_fields2[1];
        $category = $cart_fields2[2];
        $price = &format_pricemgr($cart_fields2[3]);
        $product = $cart_fields2[4];
        $shipping = $cart_fields2[5];
        $optionids = $cart_fields2[6];
        $downladables = $cart_fields2[7];
        $altorigin = $cart_fields2[8];
        $nontaxable = $cart_fields2[9];
        $cartuser5 = $cart_fields2[10];
        $cartuser6 = $cart_fields2[11];
        $formattedoptions = $cart_fields2[12];
        $priceafteroptions = &format_pricemgr($cart_fields2[13]);
        $productStatus = $cart_fields2[14];
my @product_formatted_cartoptions = split(/\{/,$formattedoptions);
foreach $product_formatted_cartoptions(@product_formatted_cartoptions) {
$product_options_sting .= "$product_formatted_cartoptions &nbsp;&nbsp;&nbsp;";
}
if ($downladables ne "") {
   $isDownloadable = "&nbsp;&nbsp;&nbsp;<font color=red>This is a Downloadable Product</font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
} else {
   $isDownloadable = "&nbsp;&nbsp;&nbsp;<b>Product Status:</b> $productStatus&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
}
my $itemTotalWeight = &format_pricemgr($quantity * $shipping);
my $itemSubTotal = &format_pricemgr($quantity * $priceafteroptions);

$cartContentsStringViewer .= qq~
<tr>
<td colspan=8><font face=arial size=1><hr width=99%></font>
</td></tr>
<tr>
<td><font face=arial size=1>$product  &nbsp;&nbsp;&nbsp; - &nbsp;&nbsp;&nbsp; $pid &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; $isDownloadable
<b>$sc_item_Total_Weight :</b> $itemTotalWeight
<br><b>Options:</b>&nbsp;&nbsp;$product_options_sting</font></td>
<td><font face=arial size=1>$quantity</font></td>
<td><font face=arial size=1>$sc_money_symbol $priceafteroptions<br><b>item Sub Total:</b> $sc_money_symbol $itemSubTotal</font></td>
</tr>
~;
$product_options_sting = "";
        }

    if (($in{'fullName'} eq "") && (($in{'lastName'} ne "") && ($in{'firstName'} ne ""))) {
        $in{'fullName'} = "$in{'firstName'} $in{'lastName'}";
    }

   open (TEMPLATE, "$filename2");
   while ($line = <TEMPLATE>) {
      $line =~ s/%%year%%/$in{'year'}/g;
      $line =~ s/%%day%%/$in{'day'}/g;
      $line =~ s/%%month%%/$in{'month'}/g;
      $line =~ s/%%invoiceNumber%%/$in{'invoiceNumber'}/g;
      $line =~ s/%%customerNumber%%/$in{'customerNumber'}/g;
      $line =~ s/%%orderStatus%%/$in{'orderStatus'}/g;
      $line =~ s/%%shiptrackingID%%/$in{'shiptrackingID'}/g;
      $line =~ s/%%firstName%%/$in{'firstName'}/g;
      $line =~ s/%%lastName%%/$in{'lastName'}/g;
      $line =~ s/%%fullName%%/$in{'fullName'}/g;
      $line =~ s/%%companyName%%/$in{'companyName'}/g;
      $line =~ s/%%customerPhone%%/$in{'customerPhone'}/g;
      $line =~ s/%%faxNumber%%/$in{'faxNumber'}/g;
      $line =~ s/%%emailAddress%%/$in{'emailAddress'}/g;
      $line =~ s/%%orderFromAddress%%/$in{'orderFromAddress'}/g;
      $line =~ s/%%customerAddress2%%/$in{'customerAddress2'}/g;
      $line =~ s/%%customerAddress3%%/$in{'customerAddress3'}/g;
      $line =~ s/%%orderFromCity%%/$in{'orderFromCity'}/g;
      $line =~ s/%%orderFromState%%/$in{'orderFromState'}/g;
      $line =~ s/%%orderFromPostal%%/$in{'orderFromPostal'}/g;
      $line =~ s/%%orderFromCountry%%/$in{'orderFromCountry'}/g;
      $line =~ s/%%shipToName%%/$in{'shipToName'}/g;
      $line =~ s/%%shipToAddress%%/$in{'shipToAddress'}/g;
      $line =~ s/%%shipToAddress2%%/$in{'shipToAddress2'}/g;
      $line =~ s/%%shipToAddress3%%/$in{'shipToAddress3'}/g;
      $line =~ s/%%shipToCity%%/$in{'shipToCity'}/g;
      $line =~ s/%%shipToState%%/$in{'shipToState'}/g;
      $line =~ s/%%shipToPostal%%/$in{'shipToPostal'}/g;
      $line =~ s/%%shipToCountry%%/$in{'shipToCountry'}/g;
      $line =~ s/%%shipToResidential%%/$in{'shiptoResidential'}/g;
      $line =~ s/%%shipToInsured%%/$in{'insureShipment'}/g;
      $line =~ s/%%shipMethod%%/$in{'shipMethod'}/g;
      $line =~ s/%%shippingTotal%%/$in{'shippingTotal'}/g;
      $line =~ s/%%salesTax%%/$in{'salesTax'}/g;
      $line =~ s/%%tax1%%/$in{'tax1'}/g;
      $line =~ s/%%tax2%%/$in{'tax2'}/g;
      $line =~ s/%%tax3%%/$in{'tax3'}/g;
      $line =~ s/%%discounts%%/$in{'discounts'}/g;
      $line =~ s/%%subTotal%%/$in{'subTotal'}/g;
      $line =~ s/%%orderTotal%%/$in{'orderTotal'}/g;
      $line =~ s/%%user1%%/$in{'user1'}/g;
      $line =~ s/%%user2%%/$in{'user2'}/g;
      $line =~ s/%%user3%%/$in{'user3'}/g;
      $line =~ s/%%user4%%/$in{'user4'}/g;
      $line =~ s/%%user5%%/$in{'user5'}/g;
          my ($buysafetext,$buysafeamount) = split(/>/,$in{'user5'},2);
          $line =~ s/%%buysafecost%%/$buysafeamount/g;
      $line =~ s/%%adminMessages%%/$in{'adminMessages'}/g;
      $line =~ s/%%GatewayUsed%%/$in{'GatewayUsed'}/g;
      $line =~ s/%%shippingMessages%%/$in{'shippingMessages'}/g;
      $line =~ s/%%cartContents%%/$cartContentsStringViewer/g;
      $line =~ s/%%money_symbol%%/$sc_money_symbol/g;
      $line =~ s/%%xcomments%%/$in{'xcomments'}/g;
      $line =~ s/%%termsOfService%%/$in{'termsOfService'}/g;
      $line =~ s/%%discountCode%%/$in{'discountCode'}/g;
      $line =~ s/%%user6%%/$in{'user6'}/g;
      $line =~ s/%%user7%%/$in{'user7'}/g;
      $line =~ s/%%user8%%/$in{'user8'}/g;
      $line =~ s/%%user9%%/$in{'user9'}/g;
      $line =~ s/%%user10%%/$in{'user10'}/g;
      $line =~ s/%%order_payment_type_user1%%/$in{'order_payment_type_user1'}/g;
      $line =~ s/%%order_payment_type_user2%%/$in{'order_payment_type_user2'}/g;
      $line =~ s/%%GiftCard_number%%/$in{'GiftCard_number'}/g;
      $line =~ s/%%GiftCard_amount_used%%/$in{'GiftCard_amount_used'}/g;
      $line =~ s/%%internal_company_notes1%%/$in{'internal_company_notes1'}/g;
      $line =~ s/%%internal_company_notes2%%/$in{'internal_company_notes2'}/g;
      $line =~ s/%%internal_company_notes3%%/$in{'internal_company_notes3'}/g;
      $line =~ s/%%customer_order_notes1%%/$in{'customer_order_notes1'}/g;
      $line =~ s/%%customer_order_notes2%%/$in{'customer_order_notes2'}/g;
      $line =~ s/%%customer_order_notes3%%/$in{'customer_order_notes3'}/g;
      $line =~ s/%%customer_order_notes4%%/$in{'customer_order_notes4'}/g;
      $line =~ s/%%customer_order_notes5%%/$in{'customer_order_notes5'}/g;
      $line =~ s/%%mailinglist_subscribe%%/$in{'mailinglist_subscribe'}/g;
      $line =~ s/%%wishlist_subscribe%%/$in{'wishlist_subscribe'}/g;
      $line =~ s/%%insurance_cost%%/$in{'insurance_cost'}/g;
      $line =~ s/%%trade_in_allowance%%/$in{'trade_in_allowance'}/g;
      $line =~ s/%%rma_number%%/$in{'rma_number'}/g;
      $line =~ s/%%customer_contact_notes1%%/$in{'customer_contact_notes1'}/g;
      $line =~ s/%%customer_contact_notes2%%/$in{'customer_contact_notes2'}/g;
      $line =~ s/%%account_number%%/$in{'account_number'}/g;
      $line =~ s/%%sales_rep%%/$in{'sales_rep'}/g;
      $line =~ s/%%sales_rep_notes1%%/$in{'sales_rep_notes1'}/g;
      $line =~ s/%%sales_rep_notes2%%/$in{'sales_rep_notes2'}/g;
      $line =~ s/%%how_did_you_find_us%%/$in{'how_did_you_find_us'}/g;
      $line =~ s/%%suggestion_box%%/$in{'suggestion_box'}/g;
      $line =~ s/%%preferrred_shipping_date%%/$in{'preferrred_shipping_date'}/g;
      $line =~ s/%%ship_order_items_as_available%%/$in{'ship_order_items_as_available'}/g;

      $new_output .= $line;
   }
   close (TEMPLATE);
print "$new_output";

}
#######################################################################################
sub write_individual_Order_information {

 my ($quantity,$product,$pid,$category,$price,$shipping,$optionids,$productStatus,$downladables,$altorigin,$nontaxable,$cartuser5,$cartuser6,$formattedoptions,$priceafteroptions,$cartrow_counter);
    &ReadParse;
#untaint a few thingies
 $in{'invoiceNumber'} =~ /([\w\=\+]+)/;
 my $invoiceNum = "$1";
 $in{'customerNumber'} =~ /([\w\-\=\+\/]+)\.(\w+)/;
 my $cust_id = "$1.$2";
 $in{'month'} =~ /([\w\=\+]+)/;
 my $month = "$1";
 $in{'year'} =~ /([\w\=\+]+)/;
 my $year = "$1";
    my ($cart_string,$cart_string_short,$orderLogString,$orderLogString2,$orderLogString3) = '';
    my ($logfile)= "$sc_logs_dir/$sc_order_log_name";
    my ($filename3) = "$sc_order_log_directory_path/$year/$month/$month$year";
    my ($filename8) = "$sc_order_log_directory_path/$year/$month/$invoiceNum"."-"."$cust_id"."$scm_orderdata_ext";
    my ($filename11) = "$sc_order_log_directory_path/$year/$month$year";

##########################################################
# recompile cart lines into a single string for order databases / logs

 $cartrow_counter = $in{'cartrow_counter'};
 my $cartrow_counter_temp = "0";
 my $cartlog_string_thingy = "";
 while ($cartrow_counter_temp <= $cartrow_counter) {
   if (($in{"quantity$cartrow_counter_temp"} ne "") || ($in{"quantity$cartrow_counter_temp"} > "0")) {
        $cartlog_string_thingy .= qq!$in{"quantity$cartrow_counter_temp"}|$in{"pid$cartrow_counter_temp"}|$in{"category$cartrow_counter_temp"}|$in{"price$cartrow_counter_temp"}|$in{"product$cartrow_counter_temp"}|$in{"shipping$cartrow_counter_temp"}|$in{"optionids$cartrow_counter_temp"}|$in{"downladables$cartrow_counter_temp"}|$in{"altorigin$cartrow_counter_temp"}|$in{"nontaxable$cartrow_counter_temp"}|$in{"cartuser5$cartrow_counter_temp"}|$in{"cartuser6$cartrow_counter_temp"}|$in{"formattedoptions$cartrow_counter_temp"}|$in{"priceafteroptions$cartrow_counter_temp"}|$in{"productStatus$cartrow_counter_temp"}!;
   }
   if ($cartrow_counter_temp < $cartrow_counter) {
        $cartlog_string_thingy .= "::";
   }
   $cartrow_counter_temp++;
}
     $cart_string = "$in{'year'}\t$in{'month'}\t$in{'day'}\t$in{'invoiceNumber'}\t$in{'customerNumber'}\t$in{'orderStatus'}\t$in{'shiptrackingID'}\t$in{'firstName'}\t$in{'lastName'}\t$in{'fullName'}\t$in{'companyName'}\t$in{'customerPhone'}\t$in{'faxNumber'}\t$in{'emailAddress'}\t$in{'orderFromAddress'}\t$in{'customerAddress2'}\t$in{'customerAddress3'}\t$in{'orderFromCity'}\t$in{'orderFromState'}\t$in{'orderFromPostal'}\t$in{'orderFromCountry'}\t$in{'shipToName'}\t$in{'shipToAddress'}\t$in{'shipToAddress2'}\t$in{'shipToAddress3'}\t$in{'shipToCity'}\t$in{'shipToState'}\t$in{'shipToPostal'}\t$in{'shipToCountry'}\t$in{'shiptoResidential'}\t$in{'insureShipment'}\t$in{'shipMethod'}\t$in{'shippingTotal'}\t$in{'salesTax'}\t$in{'tax1'}\t$in{'tax2'}\t$in{'tax3'}\t$in{'discounts'}\t$in{'netProfit'}\t$in{'subTotal'}\t$in{'orderTotal'}\t$in{'affiliateTotal'}\t$in{'affiliateID'}\t$in{'affiliateMisc'}\t$in{'user1'}\t$in{'user2'}\t$in{'user3'}\t$in{'user4'}\t$in{'user5'}\t$in{'adminMessages'}\t$cartlog_string_thingy\t$in{'GatewayUsed'}\t$in{'shippingMessages'}\t$in{'xcomments'}\t$in{'termsOfService'}\t$in{'discountCode'}\t$in{'user6'}\t$in{'user7'}\t$in{'user8'}\t$in{'user9'}\t$in{'user10'}\t$in{'buySafe'}\t$in{'order_payment_type_user1'}\t$in{'order_payment_type_user2'}\t$in{'GiftCard_number'}\t$in{'GiftCard_amount_used'}\t$in{'internal_company_notes1'}\t$in{'internal_company_notes2'}\t$in{'internal_company_notes2'}\t$in{'customer_order_notes1'}\t$in{'customer_order_notes2'}\t$in{'customer_order_notes3'}\t$in{'customer_order_notes4'}\t$in{'customer_order_notes5'}\t$in{'mailinglist_subscribe'}\t$in{'wishlist_subscribe'}\t$in{'insurance_cost'}\t$in{'trade_in_allowance'}\t$in{'rma_number'}\t$in{'customer_contact_notes1'}\t$in{'customer_contact_notes2'}\t$in{'account_number'}\t$in{'sales_rep'}\t$in{'sales_rep_notes1'}\t$in{'sales_rep_notes2'}\t$in{'how_did_you_find_us'}\t$in{'suggestion_box'}\t$in{'preferrred_shipping_date'}\t$in{'ship_order_items_as_available'}";
     $cart_string_short = "$in{'year'}\t$in{'month'}\t$in{'day'}\t$in{'invoiceNumber'}\t$in{'customerNumber'}\t$in{'orderStatus'}\t$in{'firstName'}\t$in{'lastName'}\t$in{'fullName'}\t$in{'companyName'}\t$in{'emailAddress'}\t$in{'orderFromState'}\t$in{'orderFromPostal'}\t$in{'orderFromCountry'}\t$in{'shipMethod'}\t$in{'shippingTotal'}\t$in{'salesTax'}\t$in{'tax1'}\t$in{'tax2'}\t$in{'tax3'}\t$in{'discounts'}\t$in{'netProfit'}\t$in{'subTotal'}\t$in{'orderTotal'}\t$in{'affiliateTotal'}\t$in{'affiliateID'}\t$in{'affiliateMisc'}\t$in{'GatewayUsed'}\t$in{'buySafe'}\n";

     open (ORDERLOG, ">$filename8");
     print ORDERLOG $cart_string;
     close (ORDERLOG);
if ($sc_write_monthly_short_order_logs =~ /yes/i) {
           $filename4 = "$filename3$scm_monthyearindexlog_name";
           open (ORDERLOG4, "$filename4");
           while (<ORDERLOG4>) {
               if ($_ =~ /$invoiceNum/) {
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
 if ($sc_write_monthly_master_order_logs =~ /yes/i) {
           $filename5 = "$filename11$scm_monthyearmasterlog_name";
           open (ORDERLOG5, "$filename5");
           while (<ORDERLOG5>) {
               if ($_ =~ /$invoiceNum/) {
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
 if ($sc_send_order_to_log =~ /yes/i) {
           open (ORDERLOG, "$logfile");
           while (<ORDERLOG>) {
               if ($_ =~ /$invoiceNum/) {
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
     &select_individual_order_screen;
}
#######################################################################################
sub select_individual_order_screen {
my($year,$month,$inv_number,$filename,$filename2,$cust_id,$stuff);

&ReadParse;

my $cartContentsStringViewer = '';
$month = $in{'month'};
$year = $in{'year'};
$inv_number = $in{'invoiceNumber'};
$cust_id = $in{'customerNumber'};
$filename = "$sc_order_log_directory_path/$year/$month/$inv_number"."-"."$cust_id"."$scm_orderdata_ext";
$filename2 = "$sc_order_log_directory_path/$year/$month/$inv_number"."-"."$cust_id"."$scm_completecart_ext";
my (@cart_contents_rows,@cart_temp_rows) = '';
my $cartrow_counter = "0";
%cart_contents_rowsHash;

if ((($in{'invoiceNumber'} ne '') && ($in{'customerNumber'} ne '') && ($in{'year'} ne '') && ($in{'month'} ne '')) || ($in{'viewertrigger'} ne '')) {
    if (-e $filename) {
        open (ORDERLOGLOOK, "$filename");
        $stuff=<ORDERLOGLOOK>;
        ($in{'year'},$in{'month'},$in{'day'},$in{'invoiceNumber'},$in{'customerNumber'},$in{'orderStatus'},$in{'shiptrackingID'},$in{'firstName'},$in{'lastName'},$in{'fullName'},$in{'companyName'},$in{'customerPhone'},$in{'emailAddress'},$in{'faxNumber'},$in{'orderFromAddress'},$in{'customerAddress2'},$in{'customerAddress3'},$in{'orderFromCity'},$in{'orderFromState'},$in{'orderFromPostal'},$in{'orderFromCountry'},$in{'shipToName'},$in{'shipToAddress'},$in{'shipToAddress2'},$in{'shipToAddress3'},$in{'shipToCity'},$in{'shipToState'},$in{'shipToPostal'},$in{'shipToCountry'},$in{'shiptoResidential'},$in{'insureShipment'},$in{'shipMethod'},$in{'shippingTotal'},$in{'salesTax'},$in{'tax1'},$in{'tax2'},$in{'tax3'},$in{'discounts'},$in{'netProfit'},$in{'subTotal'},$in{'orderTotal'},$in{'affiliateTotal'},$in{'affiliateID'},$in{'affiliateMisc'},$in{'user1'},$in{'user2'},$in{'user3'},$in{'user4'},$in{'user5'},$in{'adminMessages'},$in{'cartContents'},$in{'GatewayUsed'},$in{'shippingMessages'},$in{'xcomments'},$in{'termsOfService'},$in{'discountCode'},$in{'user6'},$in{'user7'},$in{'user8'},$in{'user9'},$in{'user10'},$in{'buySafe'},$in{'order_payment_type_user1'},$in{'order_payment_type_user2'},$in{'GiftCard_number'},$in{'GiftCard_amount_used'},$in{'internal_company_notes1'},$in{'internal_company_notes2'},$in{'internal_company_notes2'},$in{'customer_order_notes1'},$in{'customer_order_notes2'},$in{'customer_order_notes3'},$in{'customer_order_notes4'},$in{'customer_order_notes5'},$in{'mailinglist_subscribe'},$in{'wishlist_subscribe'},$in{'insurance_cost'},$in{'trade_in_allowance'},$in{'rma_number'},$in{'customer_contact_notes1'},$in{'customer_contact_notes2'},$in{'account_number'},$in{'sales_rep'},$in{'sales_rep_notes1'},$in{'sales_rep_notes2'},$in{'how_did_you_find_us'},$in{'suggestion_box'},$in{'preferrred_shipping_date'},$in{'ship_order_items_as_available'}) = split(/\t/,$stuff);
        close (ORDERLOGLOOK);
        @cart_contents_rows = split(/::/,$in{'cartContents'},$in{'GatewayUsed'});
        foreach $cart_contents_rows(@cart_contents_rows) {
            $cart_contents_rowsHash{$cartrow_counter} = $cart_contents_rows;
            $cartrow_counter++;
        }
    } else {
        $in{'system_edit_success'} = "notexist";
    }

} elsif ((($in{'invoiceNumber'} eq '') && ($in{'customerNumber'} eq '') && ($in{'year'} eq '') && ($in{'month'} eq '')) || ($in{'viewertrigger'} ne '')) {
        $in{'system_edit_success'} = "";
} else {
        $in{'system_edit_success'} = "notexist";
}

print &$manager_page_header("Individual Order Management","","","","");

print <<ENDOFTEXT;
<CENTER>
<HR>
</CENTER>

<CENTER>
<TABLE>
<TR>
<TD>
<FONT FACE=ARIAL size=2>Welcome to the <b>AgoraCart</b> Individual Order Viewer for your store.<br>
ENDOFTEXT

if ($versions{'Order_Management_custom'} ne "") {
print qq~
  If you need to locate the necessary order information, <a href="manager.cgi?display_custom_order_reports_screen=yes">Click Here</a> for the required information
~;
}

print <<ENDOFTEXT;
</font></TD>
</TR>
</TABLE>
</CENTER>
<br>
ENDOFTEXT


if ((($in{'system_edit_success'} ne "") && ($in{'system_edit_success'} ne "notexist"))||($in{'viewertrigger'} ne ""))
{
print <<ENDOFTEXT;
<CENTER><br>
<TABLE>
<TR>
<TD>
<FONT FACE=ARIAL SIZE=2 COLOR=RED><center>This Order ( $inv_number - $cust_id from $month $year ) has been 
successfully found and/or updated.<br>Please scroll down to view it</center></FONT><font face=arial size=2>
<center><a href="manager.cgi?invoiceviewertrigger=invoiceviewertrigger&invoiceNumber=$in{'invoiceNumber'}&customerNumber=$in{'customerNumber'}&year=$year&month=$month" target="_new">View Invoice</a>  |  <a href="manager.cgi?packingviewertrigger=packingviewertrigger&invoiceNumber=$in{'invoiceNumber'}&customerNumber=$in{'customerNumber'}&year=$year&month=$month" target="_new">Packing Slip</a>  |  <a href="manager.cgi?originalviewertrigger=originalviewertrigger&invoiceNumber=$in{'invoiceNumber'}&customerNumber=$in{'customerNumber'}&year=$year&month=$month" target="_new">Original Order</a><br><a href="manager.cgi?deleteviewertrigger=yes&invoiceNumber=$in{'invoiceNumber'}&customerNumber=$in{'customerNumber'}&year=$year&month=$month">Delete/Remove</a></center></font>
</TD>
</TR>
</TABLE>
</CENTER>
ENDOFTEXT
} elsif ($in{'system_edit_success'} eq "notexist") {
print <<ENDOFTEXT;
<CENTER><br>
<TABLE>
<TR>
<TD>
<FONT FACE=ARIAL SIZE=2 COLOR=RED><center>This Order cannot be found. Please input the correct order information.</center></FONT>
</TD>
</TR>
</TABLE>
</CENTER>
ENDOFTEXT
}

print qq~
<CENTER>
<FORM METHOD="POST" ACTION="manager.cgi">
<TABLE width=700>
<TR>
<TD><br></TD>
</TR>
<TR>
<TD COLSPAN=4 BGCOLOR="#99CC99" align=center><font face="Arial, Helvetica, sans-serif" size=+2><b>Enter Information to View an Order</b></font></TD>
</TR>
<TR>
<TD><br></TD>
</TR>
<TR>
<TD colspan=4>
<TABLE width=700>
<TR>
<TD colspan=2>
<font size="2" face="Arial, Helvetica, sans-serif">
<b>Enter the order's Invoice number,<br>customer ID, month and year</b><br>
~;

if ($versions{'Order_Management_custom'} ne "") {
print qq~
  <small>* If you do not know this,<br>you cannot look up the order.<br><a href="manager.cgi?display_custom_order_reports_screen=yes">Click Here</a> for the required information</small>
~;
}

print qq~<br><br>
Invoice Number: <INPUT NAME="invoiceNumber" TYPE="TEXT" SIZE=15 
MAXLENGTH="20" value="$in{'invoiceNumber'}"><br><br>

Customer Number: <INPUT NAME="customerNumber" TYPE="TEXT" SIZE=15 
MAXLENGTH="20" value="$in{'customerNumber'}">

</font></TD>
<TD colspan=2 valign=top><font size="2" face="Arial, Helvetica, sans-serif">
<b>Select Date of Order</b><br>
<SELECT NAME="month">
<option>$in{'month'}</option>
$scm_monthlinks
</SELECT> 
<SELECT NAME="year">
<option>$in{'year'}</option>
$scm_yearlinks
</SELECT><br>


<br><br>
<CENTER>
<INPUT TYPE="HIDDEN" NAME="system_edit_success" VALUE="yes">
<INPUT NAME="OpenIndividualOrder" TYPE="SUBMIT" VALUE="Find Order">
&nbsp;&nbsp;
<INPUT TYPE="RESET" VALUE="Reset">
</CENTER>

</font>
</TD>
</TR></table>
<br><br>
</TD>
</TR>

</TABLE></form></form>
</CENTER>
~;



# show order info below
if ((($in{'system_edit_success'} ne "") && ($in{'system_edit_success'} ne "notexist"))||($in{'viewertrigger'} ne ""))
{
print qq~
<CENTER>
<FORM METHOD="POST" ACTION="manager.cgi">
<TABLE width=700>
<TR>
<TD><br></TD>
</TR>
<TR>
<TD COLSPAN=4 BGCOLOR="#99CC99" align=center><font face="Arial, Helvetica, sans-serif" size=+2><b>Order Details / Data</b></font></TD>
</TR>
<TR>
<TD><br></TD>
</TR>
<TR>
<TD colspan=4>
<font size="2" face="Arial, Helvetica, sans-serif">
<INPUT TYPE="HIDDEN" NAME="invoiceNumber" VALUE="$in{'invoiceNumber'}">
<INPUT TYPE="HIDDEN" NAME="customerNumber" VALUE="$in{'customerNumber'}">
<INPUT TYPE="HIDDEN" NAME="month" VALUE="$in{'month'}">
<INPUT TYPE="HIDDEN" NAME="day" VALUE="$in{'day'}">
<INPUT TYPE="HIDDEN" NAME="year" VALUE="$in{'year'}">
<b>Order Date:</b> $in{'month'} $in{'day'}, $in{'year'}<br>
<b>Invoice Number:</b> $in{'invoiceNumber'}<br>
<b>Customer ID Number:</b> $in{'customerNumber'}<br><br>
<table width=600 border=0>
<tr><td align=right>Order Status: </td><td><INPUT NAME="orderStatus" type="text" size=40 value="$in{'orderStatus'}"></td></tr>
<tr><td align=right>Shipping/Tracking ID: </td><td><INPUT NAME="shiptrackingID" type="text" size=40 value="$in{'shiptrackingID'}"></td></tr>
<tr><td align=right>Agree to Sales/Terms of Service: </td><td><INPUT NAME="termsOfService" type="text" size=40 value="$in{'termsOfService'}"></td></tr>
<tr><td align=right>First Name: </td><td><INPUT NAME="firstName" type="text" size=40 value="$in{'firstName'}"></td></tr>
<tr><td align=right>Last Name: </td><td><INPUT NAME="lastName" type="text" size=40 value="$in{'lastName'}"></td></tr>
<tr><td align=right>Full Name: </td><td><INPUT NAME="fullName" type="text" size=40 value="$in{'fullName'}"></td></tr>
<tr><td align=right>Company Name: </td><td><INPUT NAME="companyName" type="text" size=40 value="$in{'companyName'}"></td></tr>
<tr><td align=right>Phone Number: </td><td><INPUT NAME="customerPhone" type="text" size=40 value="$in{'customerPhone'}"></td></tr>
<tr><td align=right>Fax Number: </td><td><INPUT NAME="faxNumber" type="text" size=40 value="$in{'faxNumber'}"></td></tr>
<tr><td align=right>email Address: </td><td><INPUT NAME="emailAddress" type="text" size=40 value="$in{'emailAddress'}"></td></tr>
<tr><td align=right>Billing Address: </td><td><INPUT NAME="orderFromAddress" type="text" size=40 value="$in{'orderFromAddress'}"></td></tr>
<tr><td align=right>Address line 2: </td><td><INPUT NAME="customerAddress2" type="text" size=40 value="$in{'customerAddress2'}"></td></tr>
<tr><td align=right>Address line 3: </td><td><INPUT NAME="customerAddress3" type="text" size=40 value="$in{'customerAddress3'}"></td></tr>
<tr><td align=right>Billing City: </td><td><INPUT NAME="orderFromCity" type="text" size=40 value="$in{'orderFromCity'}"></td></tr>
<tr><td align=right>Billing State/Province: </td><td><INPUT NAME="orderFromState" type="text" size=40 value="$in{'orderFromState'}"></td></tr>
<tr><td align=right>Billing Postal Code: </td><td><INPUT NAME="orderFromPostal" type="text" size=40 value="$in{'orderFromPostal'}"></td></tr>
<tr><td align=right>Billing Country: </td><td><INPUT NAME="orderFromCountry" type="text" size=40 value="$in{'orderFromCountry'}"></td></tr>
<tr><td align=right>Ship to Name: </td><td><INPUT NAME="shipToName" type="text" size=40 value="$in{'shipToName'}"></td></tr>
<tr><td align=right>Ship to Address: </td><td><INPUT NAME="shipToAddress" type="text" size=40 value="$in{'shipToAddress'}"></td></tr>
<tr><td align=right>Ship to Address line 2: </td><td><INPUT NAME="shipToAddress2" type="text" size=40 value="$in{'shipToAddress2'}"></td></tr>
<tr><td align=right>Ship to Address line 3: </td><td><INPUT NAME="shipToAddress3" type="text" size=40 value="$in{'shipToAddress3'}"></td></tr>
<tr><td align=right>Ship to City: </td><td><INPUT NAME="shipToCity" type="text" size=40 value="$in{'shipToCity'}"></td></tr>
<tr><td align=right>Ship to State: </td><td><INPUT NAME="shipToState" type="text" size=40 value="$in{'shipToState'}"></td></tr>
<tr><td align=right>Ship to Postal Code: </td><td><INPUT NAME="shipToPostal" type="text" size=40 value="$in{'shipToPostal'}"></td></tr>
<tr><td align=right>Ship to Country: </td><td><INPUT NAME="shipToCountry" type="text" size=40 value="$in{'shipToCountry'}"></td></tr>
<tr><td align=right>Ship to Residential Address: </td><td><INPUT NAME="shiptoResidential" type="text" size=40 value="$in{'shiptoResidential'}"></td></tr>
<tr><td align=right>Insure Shipment? </td><td><INPUT NAME="insureShipment" type="text" size=40 value="$in{'insureShipment'}"></td></tr>
<tr><td align=right>Shipping Method / Shipped by: </td><td><INPUT NAME="shipMethod" type="text" size=40 value="$in{'shipMethod'}"></td></tr>
<tr><td align=right>Shipping Total: </td><td><INPUT NAME="shippingTotal" type="text" size=40 value="$in{'shippingTotal'}"></td></tr>
<tr><td align=right>Sales Tax Collected: </td><td><INPUT NAME="salesTax" type="text" size=40 value="$in{'salesTax'}"></td></tr>
<tr><td align=right>Special Tax 1 Collected: </td><td><INPUT NAME="tax1" type="text" size=40 value="$in{'tax1'}"></td></tr>
<tr><td align=right>Special Tax 2 Collected: </td><td><INPUT NAME="tax2" type="text" size=40 value="$in{'tax2'}"></td></tr>
<tr><td align=right>Special Tax 3 Collected: </td><td><INPUT NAME="tax3" type="text" size=40 value="$in{'tax3'}"></td></tr>
<tr><td align=right>Discounts Given: </td><td><INPUT NAME="discounts" type="text" size=40 value="$in{'discounts'}"></td></tr>
<tr><td align=right>Discount Code: </td><td><INPUT NAME="discountCode" type="text" size=40 value="$in{'discountCode'}"></td></tr>
<tr><td align=right>buySAFE Fee: </td><td><INPUT NAME="buySafe" type="text" size=40 value="$in{'buySafe'}"></td></tr>
<tr><td align=right>Net Profits Generated: </td><td><INPUT NAME="netProfit" type="text" size=40 value="$in{'netProfit'}"></td></tr>
<tr><td align=right>Order Sub Total: </td><td><INPUT NAME="subTotal" type="text" size=40 value="$in{'subTotal'}"></td></tr>
<tr><td align=right>Order Grand Total: </td><td><INPUT NAME="orderTotal" type="text" size=40 value="$in{'orderTotal'}"></td></tr>
<tr><td align=right>Affiliate Commision: </td><td><INPUT NAME="affiliateTotal" type="text" size=40 value="$in{'affiliateTotal'}"></td></tr>
<tr><td align=right>Affiliate ID: </td><td><INPUT NAME="affiliateID" type="text" size=40 value="$in{'affiliateID'}"></td></tr>
<tr><td align=right>Affiliate Misc: </td><td><INPUT NAME="affiliateMisc" type="text" size=40 value="$in{'affiliateMisc'}"></td></tr>
<tr><td align=right>User 1: </td><td><INPUT NAME="user1" type="text" size=40 value="$in{'user1'}"></td></tr>
<tr><td align=right>User 2: </td><td><INPUT NAME="user2" type="text" size=40 value="$in{'user2'}"></td></tr>
<tr><td align=right>User 3: </td><td><INPUT NAME="user3" type="text" size=40 value="$in{'user3'}"></td></tr>
<tr><td align=right>User 4: </td><td><INPUT NAME="user4" type="text" size=40 value="$in{'user4'}"></td></tr>
<tr><td align=right>User 5: </td><td><INPUT NAME="user5" type="text" size=40 value="$in{'user5'}"></td></tr>
<tr><td align=right>Admin Notes / Messages: </td><td><textarea name="adminMessages" cols="40" rows="10">$in{'adminMessages'}</textarea></td></tr>
<tr><td align=right>Gateway Used: </td><td><INPUT NAME="GatewayUsed" type="text" size=40 value="$in{'GatewayUsed'}"></td></tr>
<tr><td align=right>Shipping Messages: </td><td><textarea name="shippingMessages" cols="40" rows="10">$in{'shippingMessages'}</textarea></td></tr>
<tr><td align=right>XCOMMENTS: </td><td><textarea name="xcomments" cols="30" rows="5">$in{'xcomments'}</textarea></td></tr>
<tr><td align=center colspan=2><br><b>NOTE:</b> the items below are not currently logged by the cart nor displayed on any invoices or packing slips, but you can use them for your order management needs right now.<br><br></td></tr>
<tr><td align=right>user 6: </td><td><textarea name="user6" cols="40" rows="10">$in{'user6'}</textarea></td></tr>
<tr><td align=right>user 7: </td><td><textarea name="user7" cols="40" rows="10">$in{'user7'}</textarea></td></tr>
<tr><td align=right>user 8: </td><td><textarea name="user8" cols="40" rows="10">$in{'user8'}</textarea></td></tr>
<tr><td align=right>user 9: </td><td><textarea name="user9" cols="40" rows="10">$in{'user9'}</textarea></td></tr>
<tr><td align=right>user 10: </td><td><textarea name="user10" cols="40" rows="10">$in{'user10'}</textarea></td></tr>
<tr><td align=right>Order Payment Type User 1: </td><td><INPUT NAME="order_payment_type_user1" type="text" size=40 value="$in{'order_payment_type_user1'}"></td></tr>
<tr><td align=right>Order Payment Type User 2: </td><td><INPUT NAME="order_payment_type_user2" type="text" size=40 value="$in{'order_payment_type_user2'}"></td></tr>
<tr><td align=right>GiftCard_number: </td><td><INPUT NAME="GiftCard_number" type="text" size=40 value="$in{'GiftCard_number'}"></td></tr>
<tr><td align=right>GiftCard Amount Used: </td><td><INPUT NAME="GiftCard_amount_used" type="text" size=40 value="$in{'GiftCard_amount_used'}"></td></tr>
<tr><td align=right>internal company notes 1: </td><td><textarea name="internal_company_notes1" cols="40" rows="10">$in{'internal_company_notes1'}</textarea></td></tr>
<tr><td align=right>internal company notes 2: </td><td><textarea name="internal_company_notes2" cols="40" rows="10">$in{'internal_company_notes2'}</textarea></td></tr>
<tr><td align=right>internal company notes 3: </td><td><textarea name="internal_company_notes3" cols="40" rows="10">$in{'internal_company_notes3'}</textarea></td></tr>
<tr><td align=right>customer order notes 1: </td><td><textarea name="customer_order_notes1" cols="40" rows="10">$in{'customer_order_notes1'}</textarea></td></tr>
<tr><td align=right>customer order notes 2: </td><td><textarea name="customer_order_notes2" cols="40" rows="10">$in{'customer_order_notes2'}</textarea></td></tr>
<tr><td align=right>customer order notes 3: </td><td><textarea name="customer_order_notes3" cols="40" rows="10">$in{'customer_order_notes3'}</textarea></td></tr>
<tr><td align=right>customer order notes 4: </td><td><textarea name="customer_order_notes4" cols="40" rows="10">$in{'customer_order_notes4'}</textarea></td></tr>
<tr><td align=right>customer order notes 5: </td><td><textarea name="customer_order_notes5" cols="40" rows="10">$in{'customer_order_notes5'}</textarea></td></tr>
<tr><td align=right>mailinglist subscribe: </td><td><INPUT NAME="mailinglist_subscribe" type="text" size=40 value="$in{'mailinglist_subscribe'}"></td></tr>
<tr><td align=right>wishlist subscribe: </td><td><INPUT NAME="wishlist_subscribe" type="text" size=40 value="$in{'wishlist_subscribe'}"></td></tr>
<tr><td align=right>insurance_cost: </td><td><INPUT NAME="insurance_cost" type="text" size=40 value="$in{'insurance_cost'}"></td></tr>
<tr><td align=right>trade-in allowance: </td><td><INPUT NAME="trade_in_allowance" type="text" size=40 value="$in{'trade_in_allowance'}"></td></tr>
<tr><td align=right>RMA number: </td><td><INPUT NAME="rma_number" type="text" size=40 value="$in{'rma_number'}"></td></tr>
<tr><td align=right>customer contact notes 1: </td><td><textarea name="customer_contact_notes1" cols="40" rows="10">$in{'customer_contact_notes1'}</textarea></td></tr>
<tr><td align=right>customer contact notes 2: </td><td><textarea name="customer_contact_notes2" cols="40" rows="10">$in{'customer_contact_notes2'}</textarea></td></tr>
<tr><td align=right>Account Number: </td><td><INPUT NAME="account_number'" type="text" size=40 value="$in{'account_number'}"></td></tr>
<tr><td align=right>sales_rep: </td><td><INPUT NAME="sales_rep" type="text" size=40 value="$in{'sales_rep'}"></td></tr>
<tr><td align=right>sales rep notes 1: </td><td><textarea name="sales_rep_notes1" cols="40" rows="10">$in{'sales_rep_notes1'}</textarea></td></tr>
<tr><td align=right>sales rep notes 2: </td><td><textarea name="sales_rep_notes1" cols="40" rows="10">$in{'sales_rep_notes2'}</textarea></td></tr>
<tr><td align=right>how_did_you_ ind us: </td><td><INPUT NAME="how_did_you_find_us" type="text" size=40 value="$in{'how_did_you_find_us'}"></td></tr>
<tr><td align=right>suggestion box: </td><td><textarea name="suggestion_box" cols="40" rows="10">$in{'suggestion_box'}</textarea></td></tr>
<tr><td align=right>preferrred shipping date: </td><td><INPUT NAME="preferrred_shipping_date" type="text" size=40 value="$in{'preferrred_shipping_date'}"></td></tr>
<tr><td align=right>ship order items separately as available: </td><td><INPUT NAME="ship_order_items_as_available" type="text" size=40 value="$in{'ship_order_items_as_available'}"></td></tr>
~;

 my ($quantity,$product,$pid,$category,$price,$shipping,$optionids,$productStatus,$downladables,$altorigin,$nontaxable,$cartuser5,$cartuser6,$formattedoptions,$priceafteroptions);
        my $Key;
        foreach $Key (sort keys(%cart_contents_rowsHash)) {
        my @cart_fields2 = split(/\|/,$cart_contents_rowsHash{$Key});
        $quantity = $cart_fields2[0];
        $pid = $cart_fields2[1];
        $category = $cart_fields2[2];
        $price = &format_pricemgr($cart_fields2[3]);
        $product = $cart_fields2[4];
        $shipping = $cart_fields2[5];
        $optionids = $cart_fields2[6];
        $downladables = $cart_fields2[7];
        $altorigin = $cart_fields2[8];
        $nontaxable = $cart_fields2[9];
        $cartuser5 = $cart_fields2[10];
        $cartuser6 = $cart_fields2[11];
        $formattedoptions = $cart_fields2[12];
        $priceafteroptions = &format_pricemgr($cart_fields2[13]);
        $productStatus = $cart_fields2[14];
$cartContentsStringViewer .= qq~
<INPUT TYPE="HIDDEN" NAME="downladables$Key" VALUE="$downladables">
<INPUT TYPE="HIDDEN" NAME="altorigin$Key" VALUE="$altorigin">
<INPUT TYPE="HIDDEN" NAME="nontaxable$Key" VALUE="$nontaxable">
<INPUT TYPE="HIDDEN" NAME="cartuser5$Key" VALUE="$cartuser5">
<INPUT TYPE="HIDDEN" NAME="cartuser6$Key" VALUE="$cartuser6">
<tr bgcolor=#c0c0c0>
<td>Product Status</td>
<td>Product ID</td>
<td>Quantity</td>
<td>Product</td>
<td>Category</td>
<td>Base Price</td>
<td>Shipping</td>
<td>Price after Options</td>
</tr>
<tr>
<td><INPUT NAME="productStatus$Key" TYPE="TEXT" SIZE=15 value="$productStatus"></td>
<td><INPUT NAME="pid$Key" TYPE="TEXT" SIZE=9 value="$pid"></td>
<td><INPUT NAME="quantity$Key" TYPE="TEXT" SIZE=5 value="$quantity"></td>
<td><INPUT NAME="product$Key" TYPE="TEXT" SIZE=20 value="$product"></td>
<td><INPUT NAME="category$Key" TYPE="TEXT" SIZE=10 value="$category"></td>
<td><INPUT NAME="price$Key" TYPE="TEXT" SIZE=9 value="$price"></td>
<td><INPUT NAME="shipping$Key" TYPE="TEXT" SIZE=10 value="$shipping"></td>
<td><INPUT NAME="priceafteroptions$Key" TYPE="TEXT" SIZE=9 value="$priceafteroptions"></td>
</tr>
<tr>
<td colspan=8><font face=arial size=2><br>
These portions are Options information but in cart contents form.  Each option separated by a: { character.<br>Be careful when editing this information:<br>
Option IDs: <INPUT NAME="optionids$Key" TYPE="TEXT" SIZE=60 value="$optionids"><br>
Formatted Options:  <INPUT NAME="formattedoptions$Key" TYPE="TEXT" SIZE=60 value="$formattedoptions"><br><br></font>
</td></tr>
~;
        }

print qq~
<tr><td colspan=2><INPUT TYPE="HIDDEN" NAME="cartContents" type="text" size=40 value="$in{'cartContents'}">
<table>
<TR>
<TD COLSPAN=8 BGCOLOR="#99CC99" align=center width=100%><font face="Arial, Helvetica, sans-serif" size=+2><b>Individual items in this Order</b></font></TD>
</TR>
<TR>
<TD COLSPAN=8><br><font face="Arial, Helvetica, sans-serif" size=2>If you edit any pricing, quantity, or options, make sure to reflect your adjustment in any affected field as these things will not be automagically updated without your manual intervention. Each field may contain more data than shown, if unsure, move the cursor to the left in order to scroll through each character in the box.<br><br>
<b>Items (rows) in this Order:  $cartrow_counter</b><br><br>
</font></TD>
</TR>

$cartContentsStringViewer<table></td></tr>
</table>
<br><br>
<CENTER>
<INPUT TYPE="HIDDEN" NAME="system_edit_success" VALUE="yes">
<INPUT TYPE="HIDDEN" NAME="cartrow_counter" VALUE="$cartrow_counter">
<INPUT NAME="UpdateIndividualOrder" TYPE="SUBMIT" VALUE="Update Order Data">
&nbsp;&nbsp;
<INPUT TYPE="RESET" VALUE="Reset">
</CENTER>

</font>
</TD>
</TR>

</TABLE>
</CENTER><br><br>
~;
}



print &$manager_page_footer;
}
#######################################################################################
sub select2_individual_order_screen {
my($year,$month,$inv_number,$filename,$filename2,$cust_id,$stuff);

# &ReadParse;

my $cartContentsStringViewer = '';
my (@cart_contents_rows,@cart_temp_rows) = '';
my $cartrow_counter = "0";
%cart_contents_rowsHash;
$month = $in{'month'};
$year = $in{'year'};
$inv_number = $in{'invoiceNumber'};
$cust_id = $in{'customerNumber'};
$filename = "$sc_order_log_directory_path/$year/$month/$inv_number"."-"."$cust_id"."$scm_orderdata_ext";
$filename2 = "$sc_order_log_directory_path/$year/$month/$inv_number"."-"."$cust_id"."$scm_completecart_ext";
if ((($in{'invoiceNumber'} ne '') && ($in{'customerNumber'} ne '') && ($in{'year'} ne '') && ($in{'month'} ne '')) || ($in{'viewertrigger'} ne '')) {
    if (-e $filename) {
        open (ORDERLOGLOOK, "$filename");
        $stuff=<ORDERLOGLOOK>;
        ($in{'year'},$in{'month'},$in{'day'},$in{'invoiceNumber'},$in{'customerNumber'},$in{'orderStatus'},$in{'shiptrackingID'},$in{'firstName'},$in{'lastName'},$in{'fullName'},$in{'companyName'},$in{'customerPhone'},$in{'faxNumber'},$in{'emailAddress'},$in{'orderFromAddress'},$in{'customerAddress2'},$in{'customerAddress3'},$in{'orderFromCity'},$in{'orderFromState'},$in{'orderFromPostal'},$in{'orderFromCountry'},$in{'shipToName'},$in{'shipToAddress'},$in{'shipToAddress2'},$in{'shipToAddress3'},$in{'shipToCity'},$in{'shipToState'},$in{'shipToPostal'},$in{'shipToCountry'},$in{'shiptoResidential'},$in{'insureShipment'},$in{'shipMethod'},$in{'shippingTotal'},$in{'salesTax'},$in{'tax1'},$in{'tax2'},$in{'tax3'},$in{'discounts'},$in{'netProfit'},$in{'subTotal'},$in{'orderTotal'},$in{'affiliateTotal'},$in{'affiliateID'},$in{'affiliateMisc'},$in{'user1'},$in{'user2'},$in{'user3'},$in{'user4'},$in{'user5'},$in{'adminMessages'},$in{'cartContents'},$in{'GatewayUsed'},$in{'shippingMessages'},$in{'xcomments'},$in{'termsOfService'},$in{'discountCode'},$in{'user6'},$in{'user7'},$in{'user8'},$in{'user9'},$in{'user10'},$in{'buySafe'},$in{'order_payment_type_user1'},$in{'order_payment_type_user2'},$in{'GiftCard_number'},$in{'GiftCard_amount_used'},$in{'internal_company_notes1'},$in{'internal_company_notes2'},$in{'internal_company_notes2'},$in{'customer_order_notes1'},$in{'customer_order_notes2'},$in{'customer_order_notes3'},$in{'customer_order_notes4'},$in{'customer_order_notes5'},$in{'mailinglist_subscribe'},$in{'wishlist_subscribe'},$in{'insurance_cost'},$in{'trade_in_allowance'},$in{'rma_number'},$in{'customer_contact_notes1'},$in{'customer_contact_notes2'},$in{'account_number'},$in{'sales_rep'},$in{'sales_rep_notes1'},$in{'sales_rep_notes2'},$in{'how_did_you_find_us'},$in{'suggestion_box'},$in{'preferrred_shipping_date'},$in{'ship_order_items_as_available'}) = split(/\t/,$stuff);
        close (ORDERLOGLOOK);
        @cart_contents_rows = split(/::/,$in{'cartContents'},$in{'GatewayUsed'});
        foreach $cart_contents_rows(@cart_contents_rows) {
            $cart_contents_rowsHash{$cartrow_counter} = $cart_contents_rows;
            $cartrow_counter++;
        }
    } else {
        $in{'system_edit_success'} = "notexist";
    }

} elsif ((($in{'invoiceNumber'} eq '') && ($in{'customerNumber'} eq '') && ($in{'year'} eq '') && ($in{'month'} eq '')) || ($in{'viewertrigger'} eq '')) {
        $in{'system_edit_success'} = "";
} else {
        $in{'system_edit_success'} = "notexist";
}

print &$manager_page_header("Order Management","","","","");

print <<ENDOFTEXT;
<CENTER>
<HR>
</CENTER>

<CENTER>
<TABLE>
<TR>
<TD>
<FONT FACE=ARIAL size=2>Welcome to the <b>AgoraCart</b> Individual Order Viewer for your store.<br>
ENDOFTEXT

if ($versions{'Order_Management_custom'} ne "") {
print qq~
  If you need to locate the necessary order information, <a href="manager.cgi?display_custom_order_reports_screen=yes">Click Here</a> for the required information
~;
}

print <<ENDOFTEXT;
</font></TD>
</TR>
</TABLE>
</CENTER>
<br>
ENDOFTEXT

if ((($in{'system_edit_success'} ne "") && ($in{'system_edit_success'} ne "notexist"))||($in{'viewertrigger'} ne ""))
{
print <<ENDOFTEXT;
<CENTER><br>
<TABLE>
<TR>
<TD>
<FONT FACE=ARIAL SIZE=2 COLOR=RED><center>This Order ( $inv_number - $cust_id from $month $year ) has been 
successfully found and/or updated.<br>Please scroll down to view it</center></FONT><font face=arial size=2>
<center><a href="manager.cgi?invoiceviewertrigger=invoiceviewertrigger&invoiceNumber=$in{'invoiceNumber'}&customerNumber=$in{'customerNumber'}&year=$year&month=$month" target="_new">View Invoice</a>  |  <a href="manager.cgi?packingviewertrigger=packingviewertrigger&invoiceNumber=$in{'invoiceNumber'}&customerNumber=$in{'customerNumber'}&year=$year&month=$month" target="_new">Packing Slip</a>  |  <a href="manager.cgi?originalviewertrigger=originalviewertrigger&invoiceNumber=$in{'invoiceNumber'}&customerNumber=$in{'customerNumber'}&year=$year&month=$month" target="_new">Original Order</a>  |  <a href="manager.cgi?deleteviewertrigger=yes&invoiceNumber=$in{'invoiceNumber'}&customerNumber=$in{'customerNumber'}&year=$year&month=$month">Delete/Remove</a></center></font>
</TD>
</TR>
</TABLE>
</CENTER>
ENDOFTEXT
} elsif ($in{'system_edit_success'} eq "notexist") {
print <<ENDOFTEXT;
<CENTER><br>
<TABLE>
<TR>
<TD>
<FONT FACE=ARIAL SIZE=2 COLOR=RED><center>This Order cannot be found. Please input the correct order information.</center></FONT>
</TD>
</TR>
</TABLE>
</CENTER>
ENDOFTEXT
}

print qq~
<CENTER>
<FORM METHOD="POST" ACTION="manager.cgi">
<TABLE width=700>
<TR>
<TD><br></TD>
</TR>
<TR>
<TD COLSPAN=4 BGCOLOR="#99CC99" align=center><font face="Arial, Helvetica, sans-serif" size=+2><b>Enter Information to View an Order</b></font></TD>
</TR>
<TR>
<TD><br></TD>
</TR>
<TR>
<TD colspan=4>
<TABLE width=700>
<TR>
<TD colspan=2>
<font size="2" face="Arial, Helvetica, sans-serif">
<b>Enter the order's Invoice number,<br>customer ID, month and year</b><br>
~;

if ($versions{'Order_Management_custom'} ne "") {
print qq~
  <small>* If you do not know this,<br>you cannot look up the order.<br><a href="manager.cgi?display_custom_order_reports_screen=yes">Click Here</a> for the required information</small>
~;
}

print qq~<br><br>
Invoice Number: <INPUT NAME="invoiceNumber" TYPE="TEXT" SIZE=15 
MAXLENGTH="20" value="$inv_number"><br><br>
Customer Number: <INPUT NAME="customerNumber" TYPE="TEXT" SIZE=15 
MAXLENGTH="20" value="$cust_id">

</font></TD>
<TD colspan=2 valign=top><font size="2" face="Arial, Helvetica, sans-serif">
<b>Select Date of Order</b><br>
<SELECT NAME="month">
<option>$in{'month'}</option>
$scm_monthlinks
</SELECT> 
<SELECT NAME="year">
<option>$in{'year'}</option>
$scm_yearlinks
</SELECT><br>


<br><br>
<CENTER>
<INPUT TYPE="HIDDEN" NAME="system_edit_success" VALUE="yes">
<INPUT NAME="OpenIndividualOrder" TYPE="SUBMIT" VALUE="Find Order">
&nbsp;&nbsp;
<INPUT TYPE="RESET" VALUE="Reset">
</CENTER>

</font>
</TD>
</TR></table>

</TD>
</TR>

</TABLE></form></form>
</CENTER>
~;



# show order info below
if ((($in{'system_edit_success'} ne "") && ($in{'system_edit_success'} ne "notexist"))||($in{'viewertrigger'} ne ""))
{
print qq~
<CENTER>
<FORM METHOD="POST" ACTION="manager.cgi">
<TABLE width=700>
<TR>
<TD><br></TD>
</TR>
<TR>
<TD COLSPAN=4 BGCOLOR="#99CC99" align=center><font face="Arial, Helvetica, sans-serif" size=+2><b>Order Details / Data</b></font></TD>
</TR>
<TR>
<TD><br></TD>
</TR>
<TR>
<TD colspan=4>
<font size="2" face="Arial, Helvetica, sans-serif">
<INPUT TYPE="HIDDEN" NAME="invoiceNumber" VALUE="$in{'invoiceNumber'}">
<INPUT TYPE="HIDDEN" NAME="customerNumber" VALUE="$in{'customerNumber'}">
<INPUT TYPE="HIDDEN" NAME="month" VALUE="$in{'month'}">
<INPUT TYPE="HIDDEN" NAME="day" VALUE="$in{'day'}">
<INPUT TYPE="HIDDEN" NAME="year" VALUE="$in{'year'}">
<b>Order Date:</b> $in{'month'} $in{'day'}, $in{'year'}<br>
<b>Invoice Number:</b> $in{'invoiceNumber'}<br>
<b>Customer ID Number:</b> $in{'customerNumber'}<br><br>
<table width=600 border=0>
<tr><td align=right>Order Status: </td><td><INPUT NAME="orderStatus" type="text" size=40 value="$in{'orderStatus'}"></td></tr>
<tr><td align=right>Shipping/Tracking ID: </td><td><INPUT NAME="shiptrackingID" type="text" size=40 value="$in{'shiptrackingID'}"></td></tr>
<tr><td align=right>Agree to Sales/Terms of Service: </td><td><INPUT NAME="termsOfService" type="text" size=40 value="$in{'termsOfService'}"></td></tr>
<tr><td align=right>First Name: </td><td><INPUT NAME="firstName" type="text" size=40 value="$in{'firstName'}"></td></tr>
<tr><td align=right>Last Name: </td><td><INPUT NAME="lastName" type="text" size=40 value="$in{'lastName'}"></td></tr>
<tr><td align=right>Full Name: </td><td><INPUT NAME="fullName" type="text" size=40 value="$in{'fullName'}"></td></tr>
<tr><td align=right>Company Name: </td><td><INPUT NAME="companyName" type="text" size=40 value="$in{'companyName'}"></td></tr>
<tr><td align=right>Phone Number: </td><td><INPUT NAME="customerPhone" type="text" size=40 value="$in{'customerPhone'}"></td></tr>
<tr><td align=right>Fax Number: </td><td><INPUT NAME="faxNumber" type="text" size=40 value="$in{'faxNumber'}"></td></tr>
<tr><td align=right>email Address: </td><td><INPUT NAME="emailAddress" type="text" size=40 value="$in{'emailAddress'}"></td></tr>
<tr><td align=right>Billing Address: </td><td><INPUT NAME="orderFromAddress" type="text" size=40 value="$in{'orderFromAddress'}"></td></tr>
<tr><td align=right>Address line 2: </td><td><INPUT NAME="customerAddress2" type="text" size=40 value="$in{'customerAddress2'}"></td></tr>
<tr><td align=right>Address line 3: </td><td><INPUT NAME="customerAddress3" type="text" size=40 value="$in{'customerAddress3'}"></td></tr>
<tr><td align=right>Billing City: </td><td><INPUT NAME="orderFromCity" type="text" size=40 value="$in{'orderFromCity'}"></td></tr>
<tr><td align=right>Billing State/Province: </td><td><INPUT NAME="orderFromState" type="text" size=40 value="$in{'orderFromState'}"></td></tr>
<tr><td align=right>Billing Postal Code: </td><td><INPUT NAME="orderFromPostal" type="text" size=40 value="$in{'orderFromPostal'}"></td></tr>
<tr><td align=right>Billing Country: </td><td><INPUT NAME="orderFromCountry" type="text" size=40 value="$in{'orderFromCountry'}"></td></tr>
<tr><td align=right>Ship to Name: </td><td><INPUT NAME="shipToName" type="text" size=40 value="$in{'shipToName'}"></td></tr>
<tr><td align=right>Ship to Address: </td><td><INPUT NAME="shipToAddress" type="text" size=40 value="$in{'shipToAddress'}"></td></tr>
<tr><td align=right>Ship to Address line 2: </td><td><INPUT NAME="shipToAddress2" type="text" size=40 value="$in{'shipToAddress2'}"></td></tr>
<tr><td align=right>Ship to Address line 3: </td><td><INPUT NAME="shipToAddress3" type="text" size=40 value="$in{'shipToAddress3'}"></td></tr>
<tr><td align=right>Ship to City: </td><td><INPUT NAME="shipToCity" type="text" size=40 value="$in{'shipToCity'}"></td></tr>
<tr><td align=right>Ship to State: </td><td><INPUT NAME="shipToState" type="text" size=40 value="$in{'shipToState'}"></td></tr>
<tr><td align=right>Ship to Postal Code: </td><td><INPUT NAME="shipToPostal" type="text" size=40 value="$in{'shipToPostal'}"></td></tr>
<tr><td align=right>Ship to Country: </td><td><INPUT NAME="shipToCountry" type="text" size=40 value="$in{'shipToCountry'}"></td></tr>
<tr><td align=right>Ship to Residential Address: </td><td><INPUT NAME="shiptoResidential" type="text" size=40 value="$in{'shiptoResidential'}"></td></tr>
<tr><td align=right>Insure Shipment? </td><td><INPUT NAME="insureShipment" type="text" size=40 value="$in{'insureShipment'}"></td></tr>
<tr><td align=right>Shipping Method / Shipped by: </td><td><INPUT NAME="shipMethod" type="text" size=40 value="$in{'shipMethod'}"></td></tr>
<tr><td align=right>Shipping Total: </td><td><INPUT NAME="shippingTotal" type="text" size=40 value="$in{'shippingTotal'}"></td></tr>
<tr><td align=right>Sales Tax Collected: </td><td><INPUT NAME="salesTax" type="text" size=40 value="$in{'salesTax'}"></td></tr>
<tr><td align=right>Special Tax 1 Collected: </td><td><INPUT NAME="tax1" type="text" size=40 value="$in{'tax1'}"></td></tr>
<tr><td align=right>Special Tax 2 Collected: </td><td><INPUT NAME="tax2" type="text" size=40 value="$in{'tax2'}"></td></tr>
<tr><td align=right>Special Tax 3 Collected: </td><td><INPUT NAME="tax3" type="text" size=40 value="$in{'tax3'}"></td></tr>
<tr><td align=right>Discounts Given: </td><td><INPUT NAME="discounts" type="text" size=40 value="$in{'discounts'}"></td></tr>
<tr><td align=right>Discount Code: </td><td><INPUT NAME="discountCode" type="text" size=40 value="$in{'discountCode'}"></td></tr>
<tr><td align=right>buySAFE Fee: </td><td><INPUT NAME="buySafe" type="text" size=40 value="$in{'buySafe'}"></td></tr>
<tr><td align=right>Net Profits Generated: </td><td><INPUT NAME="netProfit" type="text" size=40 value="$in{'netProfit'}"></td></tr>
<tr><td align=right>Order Sub Total: </td><td><INPUT NAME="subTotal" type="text" size=40 value="$in{'subTotal'}"></td></tr>
<tr><td align=right>Order Grand Total: </td><td><INPUT NAME="orderTotal" type="text" size=40 value="$in{'orderTotal'}"></td></tr>
<tr><td align=right>Affiliate Commision: </td><td><INPUT NAME="affiliateTotal" type="text" size=40 value="$in{'affiliateTotal'}"></td></tr>
<tr><td align=right>Affiliate ID: </td><td><INPUT NAME="affiliateID" type="text" size=40 value="$in{'affiliateID'}"></td></tr>
<tr><td align=right>Affiliate Misc: </td><td><INPUT NAME="affiliateMisc" type="text" size=40 value="$in{'affiliateMisc'}"></td></tr>
<tr><td align=right>User 1: </td><td><INPUT NAME="user1" type="text" size=40 value="$in{'user1'}"></td></tr>
<tr><td align=right>User 2: </td><td><INPUT NAME="user2" type="text" size=40 value="$in{'user2'}"></td></tr>
<tr><td align=right>User 3: </td><td><INPUT NAME="user3" type="text" size=40 value="$in{'user3'}"></td></tr>
<tr><td align=right>User 4: </td><td><INPUT NAME="user4" type="text" size=40 value="$in{'user4'}"></td></tr>
<tr><td align=right>User 5: </td><td><INPUT NAME="user5" type="text" size=40 value="$in{'user5'}"></td></tr>
<tr><td align=right>Admin Notes / Messages: </td><td><textarea name="adminMessages" cols="40" rows="10">$in{'adminMessages'}</textarea></td></tr>
<tr><td align=right>Gateway Used: </td><td><INPUT NAME="GatewayUsed" type="text" size=40 value="$in{'GatewayUsed'}"></td></tr>
<tr><td align=right>Shipping Messages: </td><td><textarea name="shippingMessages" cols="40" rows="10">$in{'shippingMessages'}</textarea></td></tr>
<tr><td align=right>XCOMMENTS: </td><td><textarea name="xcomments" cols="40" rows="10">$in{'xcomments'}</textarea></td></tr>
<tr><td align=center colspan=2><br><b>NOTE:</b> the items below are not currently logged by the cart nor displayed on any invoices or packing slips, but you can use them for your order management needs right now.<br><br></td></tr>
<tr><td align=right>user 6: </td><td><textarea name="user6" cols="40" rows="10">$in{'user6'}</textarea></td></tr>
<tr><td align=right>user 7: </td><td><textarea name="user7" cols="40" rows="10">$in{'user7'}</textarea></td></tr>
<tr><td align=right>user 8: </td><td><textarea name="user8" cols="40" rows="10">$in{'user8'}</textarea></td></tr>
<tr><td align=right>user 9: </td><td><textarea name="user9" cols="40" rows="10">$in{'user9'}</textarea></td></tr>
<tr><td align=right>user 10: </td><td><textarea name="user10" cols="40" rows="10">$in{'user10'}</textarea></td></tr>
<tr><td align=right>Order Payment Type User 1: </td><td><INPUT NAME="order_payment_type_user1" type="text" size=40 value="$in{'order_payment_type_user1'}"></td></tr>
<tr><td align=right>Order Payment Type User 2: </td><td><INPUT NAME="order_payment_type_user2" type="text" size=40 value="$in{'order_payment_type_user2'}"></td></tr>
<tr><td align=right>GiftCard_number: </td><td><INPUT NAME="GiftCard_number" type="text" size=40 value="$in{'GiftCard_number'}"></td></tr>
<tr><td align=right>GiftCard Amount Used: </td><td><INPUT NAME="GiftCard_amount_used" type="text" size=40 value="$in{'GiftCard_amount_used'}"></td></tr>
<tr><td align=right>internal company notes 1: </td><td><textarea name="internal_company_notes1" cols="40" rows="10">$in{'internal_company_notes1'}</textarea></td></tr>
<tr><td align=right>internal company notes 2: </td><td><textarea name="internal_company_notes2" cols="40" rows="10">$in{'internal_company_notes2'}</textarea></td></tr>
<tr><td align=right>internal company notes 3: </td><td><textarea name="internal_company_notes3" cols="40" rows="10">$in{'internal_company_notes3'}</textarea></td></tr>
<tr><td align=right>customer order notes 1: </td><td><textarea name="customer_order_notes1" cols="40" rows="10">$in{'customer_order_notes1'}</textarea></td></tr>
<tr><td align=right>customer order notes 2: </td><td><textarea name="customer_order_notes2" cols="40" rows="10">$in{'customer_order_notes2'}</textarea></td></tr>
<tr><td align=right>customer order notes 3: </td><td><textarea name="customer_order_notes3" cols="40" rows="10">$in{'customer_order_notes3'}</textarea></td></tr>
<tr><td align=right>customer order notes 4: </td><td><textarea name="customer_order_notes4" cols="40" rows="10">$in{'customer_order_notes4'}</textarea></td></tr>
<tr><td align=right>customer order notes 5: </td><td><textarea name="customer_order_notes5" cols="40" rows="10">$in{'customer_order_notes5'}</textarea></td></tr>
<tr><td align=right>mailinglist subscribe: </td><td><INPUT NAME="mailinglist_subscribe" type="text" size=40 value="$in{'mailinglist_subscribe'}"></td></tr>
<tr><td align=right>wishlist subscribe: </td><td><INPUT NAME="wishlist_subscribe" type="text" size=40 value="$in{'wishlist_subscribe'}"></td></tr>
<tr><td align=right>insurance_cost: </td><td><INPUT NAME="insurance_cost" type="text" size=40 value="$in{'insurance_cost'}"></td></tr>
<tr><td align=right>trade-in allowance: </td><td><INPUT NAME="trade_in_allowance" type="text" size=40 value="$in{'trade_in_allowance'}"></td></tr>
<tr><td align=right>RMA number: </td><td><INPUT NAME="rma_number" type="text" size=40 value="$in{'rma_number'}"></td></tr>
<tr><td align=right>customer contact notes 1: </td><td><textarea name="customer_contact_notes1" cols="40" rows="10">$in{'customer_contact_notes1'}</textarea></td></tr>
<tr><td align=right>customer contact notes 2: </td><td><textarea name="customer_contact_notes2" cols="40" rows="10">$in{'customer_contact_notes2'}</textarea></td></tr>
<tr><td align=right>Account Number: </td><td><INPUT NAME="account_number'" type="text" size=40 value="$in{'account_number'}"></td></tr>
<tr><td align=right>sales_rep: </td><td><INPUT NAME="sales_rep" type="text" size=40 value="$in{'sales_rep'}"></td></tr>
<tr><td align=right>sales rep notes 1: </td><td><textarea name="sales_rep_notes1" cols="40" rows="10">$in{'sales_rep_notes1'}</textarea></td></tr>
<tr><td align=right>sales rep notes 2: </td><td><textarea name="sales_rep_notes1" cols="40" rows="10">$in{'sales_rep_notes2'}</textarea></td></tr>
<tr><td align=right>how_did_you_ ind us: </td><td><INPUT NAME="how_did_you_find_us" type="text" size=40 value="$in{'how_did_you_find_us'}"></td></tr>
<tr><td align=right>suggestion box: </td><td><textarea name="suggestion_box" cols="40" rows="10">$in{'suggestion_box'}</textarea></td></tr>
<tr><td align=right>preferrred shipping date: </td><td><INPUT NAME="preferrred_shipping_date" type="text" size=40 value="$in{'preferrred_shipping_date'}"></td></tr>
<tr><td align=right>ship order items separately as available: </td><td><INPUT NAME="ship_order_items_as_available" type="text" size=40 value="$in{'ship_order_items_as_available'}"></td></tr>
~;

 my ($quantity,$product,$pid,$category,$price,$shipping,$optionids,$productStatus,$downladables,$altorigin,$nontaxable,$cartuser5,$cartuser6,$formattedoptions,$priceafteroptions);
        my $Key;
        foreach $Key (sort keys(%cart_contents_rowsHash)) {
        my @cart_fields2 = split(/\|/,$cart_contents_rowsHash{$Key});
        $quantity = $cart_fields2[0];
        $pid = $cart_fields2[1];
        $category = $cart_fields2[2];
        $price = &format_pricemgr($cart_fields2[3]);
        $product = $cart_fields2[4];
        $shipping = $cart_fields2[5];
        $optionids = $cart_fields2[6];
        $downladables = $cart_fields2[7];
        $altorigin = $cart_fields2[8];
        $nontaxable = $cart_fields2[9];
        $cartuser5 = $cart_fields2[10];
        $cartuser6 = $cart_fields2[11];
        $formattedoptions = $cart_fields2[12];
        $priceafteroptions = &format_pricemgr($cart_fields2[13]);
        $productStatus = $cart_fields2[14];
$cartContentsStringViewer .= qq~
<INPUT TYPE="HIDDEN" NAME="downladables$Key" VALUE="$downladables">
<INPUT TYPE="HIDDEN" NAME="altorigin$Key" VALUE="$altorigin">
<INPUT TYPE="HIDDEN" NAME="nontaxable$Key" VALUE="$nontaxable">
<INPUT TYPE="HIDDEN" NAME="cartuser5$Key" VALUE="$cartuser5">
<INPUT TYPE="HIDDEN" NAME="cartuser6$Key" VALUE="$cartuser6">
<tr bgcolor=#c0c0c0>
<td>Product Status</td>
<td>Product ID</td>
<td>Quantity</td>
<td>Product</td>
<td>Category</td>
<td>Base Price</td>
<td>Shipping</td>
<td>Price after Options</td>
</tr>
<tr>
<td><INPUT NAME="productStatus$Key" TYPE="TEXT" SIZE=15 value="$productStatus"></td>
<td><INPUT NAME="pid$Key" TYPE="TEXT" SIZE=9 value="$pid"></td>
<td><INPUT NAME="quantity$Key" TYPE="TEXT" SIZE=5 value="$quantity"></td>
<td><INPUT NAME="product$Key" TYPE="TEXT" SIZE=20 value="$product"></td>
<td><INPUT NAME="category$Key" TYPE="TEXT" SIZE=10 value="$category"></td>
<td><INPUT NAME="price$Key" TYPE="TEXT" SIZE=9 value="$price"></td>
<td><INPUT NAME="shipping$Key" TYPE="TEXT" SIZE=10 value="$shipping"></td>
<td><INPUT NAME="priceafteroptions$Key" TYPE="TEXT" SIZE=9 value="$priceafteroptions"></td>
</tr>
<tr>
<td colspan=8><font face=arial size=2><br>
These portions are Options information but in cart contents form.  Each option separated by a: { character.<br>Be careful when editing this information:<br>
Option IDs: <INPUT NAME="optionids$Key" TYPE="TEXT" SIZE=60 value="$optionids"><br>
Formatted Options - <small>each option separated by a: {</small> :  <INPUT NAME="formattedoptions$Key" TYPE="TEXT" SIZE=60 value="$formattedoptions"><br><br></font>
</td></tr>
~;
        }

print qq~
<tr><td colspan=2 align=center><INPUT TYPE="HIDDEN" NAME="cartContents" type="text" size=40 value="$in{'cartContents'}">
<table>
<TR>
<TD COLSPAN=8 BGCOLOR="#99CC99" align=center width=100%><font face="Arial, Helvetica, sans-serif" size=+2><b>Individual items in this Order</b></font></TD>
</TR>
<TR>
<TD COLSPAN=8><br><font face="Arial, Helvetica, sans-serif" size=2>If you edit any pricing, quantity, or options, make sure to reflect your adjustment in any affected field as these things will not be automagically updated without your manual intervention. Each field may contain more data than shown, if unsure, move the cursor to the left in order to scroll through each character in the box.<br><br>
<b>Items (rows) in this Order:  $cartrow_counter</b><br><br>
</font></TD>
</TR>
$cartContentsStringViewer<table></td></tr>
</table>
<br><br>
<CENTER>
<INPUT TYPE="HIDDEN" NAME="system_edit_success" VALUE="yes">
<INPUT TYPE="HIDDEN" NAME="cartrow_counter" VALUE="$cartrow_counter">
<INPUT NAME="UpdateIndividualOrder" TYPE="SUBMIT" VALUE="Update Order Data">
&nbsp;&nbsp;
<INPUT TYPE="RESET" VALUE="Reset">
</CENTER>

</font>
</TD>
</TR>

</TABLE>
</CENTER><br><br>
~;
}



print &$manager_page_footer;
}
#######################################################################################
sub select_delete_order_screen {
my($year,$month,$inv_number,$filename,$filename2,$cust_id,$stuff);

$scm_logdirs_loaded = "";
&set_log_years_months;
my $cartContentsStringViewer = '';
$month = $in{'month'};
$year = $in{'year'};
$inv_number = $in{'invoiceNumber'};
$cust_id = $in{'customerNumber'};

print &$manager_page_header("Order and Sales Log Deletion","","","","");

print <<ENDOFTEXT;
<CENTER>
<HR>
</CENTER>

<CENTER>
<TABLE>
<TR>
<TD>
<FONT FACE=ARIAL size=2>Welcome to the <b>AgoraCart</b> Individual Order and Order Log Deletion area for your store.<br>This section will allow you to remove the individual order logs for an order or it's entry within any of the sales logs of your choice. This is also where you would remove an order from the new orders log.
ENDOFTEXT

if ($versions{'Order_Management_custom'} ne "") {
print qq~
  If you need to locate the necessary order information, <a href="manager.cgi?display_custom_order_reports_screen=yes">Click Here</a> for the required information
~;
}

print <<ENDOFTEXT;
</font></TD>
</TR>
</TABLE>
</CENTER>
<br>
ENDOFTEXT

if ($in{system_edit_success} eq "yes") {
print <<ENDOFTEXT;
<CENTER><br>
<TABLE>
<TR>
<TD>
<FONT FACE=ARIAL SIZE=2 COLOR=RED><center>Your Deletion Request was Successful!</center></FONT>
</TD>
</TR>
</TABLE>
</CENTER>
ENDOFTEXT
}

print qq~
<CENTER>
<TABLE width=700>
<TR>
<TD><br></TD>
</TR>
<TR>
<TD COLSPAN=4 BGCOLOR="#99CC99" align=center><font face="Arial, Helvetica, sans-serif" size=+2><b>Enter an Order to Delete</b></font></TD>
</TR>
<TR>
<TD><br></TD>
</TR>
<TR>
<TD colspan=4>
<FORM METHOD="POST" ACTION="manager.cgi">
<TABLE width=700>
<TR>
<TD colspan=2>
<font size="2" face="Arial, Helvetica, sans-serif">
<b>Enter the order's Invoice number,<br>customer ID, month and year</b>.<br>
~;

if ($versions{'Order_Management_custom'} ne "") {
print qq~
  <small>* If you do not know this,<br>you cannot look up the order.<br><a href="manager.cgi?display_custom_order_reports_screen=yes">Click Here</a> for the required information</small>
~;
}

print qq~
<br><br>
Invoice Number: <INPUT NAME="invoiceNumber" TYPE="TEXT" SIZE=15 
MAXLENGTH="20" value="$inv_number"><br><br>

Customer Number: <INPUT NAME="customerNumber" TYPE="TEXT" SIZE=15 
MAXLENGTH="20" value="$cust_id"><br><br>
<input type="checkbox" name="deleteIndividualNewOrderLog" value="yes">Remove this Order from the New Orders Log<br>
<input type="checkbox" name="deleteIndividualData" value="yes">Remove this Order's Data File<br>
<input type="checkbox" name="deleteIndividualComplete" value="yes">Remove this Order's Old Style Order File<br>
<input type="checkbox" name="deleteIndividualMasterSalesLog" value="yes">Remove this Order from the Master Sales log<br>
<input type="checkbox" name="deleteIndividualOverviewSalesLog" value="yes">Remove this Order from the Overview Sales Log<br>
</font></TD>
<TD colspan=2 valign=top><font size="2" face="Arial, Helvetica, sans-serif">
<b>Select Date of Order</b><br>
<SELECT NAME="month">
<option>$in{'month'}</option>
$scm_monthlinks
</SELECT> 
<SELECT NAME="year">
<option>$in{'year'}</option>
$scm_yearlinks
</SELECT><br>


<br><br>
<CENTER>
<font face=arial size=2 color=red>NOTE:<br>Once you delete this order and/or it's log entry,<br>that portion is gone forever!</font><br><br>
<INPUT TYPE="HIDDEN" NAME="deletionType" VALUE="individual">
<INPUT TYPE="HIDDEN" NAME="system_edit_success" VALUE="yes">
<INPUT NAME="DeleteIndividualOrder" TYPE="SUBMIT" VALUE="Delete this Order">
</CENTER>

</font>
</TD>
</TR></table>
</form></form>
</TD>
</TR>
<TR>
<TD><br></TD>
</TR>
<TR>
<TD COLSPAN=4 BGCOLOR="#99CC99" align=center><font face="Arial, Helvetica, sans-serif" size=+2><b>Bulk Delete Functions</b></font></TD>
</TR>
<TR>
<TD colspan=4>
<TABLE width=700 border=1 cellpadding=9>
<TR>
<TD colspan=2 valign=top>
<font size="2" face="Arial, Helvetica, sans-serif">
This will delete a single month (the entire month) within the specified year. This only deletes the directory, not any entries in the master and/or overview sales logs<br><br>
<FORM METHOD="POST" ACTION="manager.cgi">
<b>Select Month to Delete. Indicate year as well</b><br>
<SELECT NAME="month">
<option>$in{'month'}</option>
$scm_monthlinks
</SELECT> 
<SELECT NAME="year">
<option>$in{'year'}</option>
$scm_yearlinks
</SELECT><br>
<br>
<CENTER>
<font face=arial size=2 color=red>NOTE: Once you delete this Month,<br>it is gone forever!</font><br><br>
<INPUT TYPE="HIDDEN" NAME="deletionType" VALUE="month">
<INPUT TYPE="HIDDEN" NAME="system_edit_success" VALUE="yes">
<INPUT NAME="DeleteIndividualOrder" TYPE="SUBMIT" VALUE="Delete this Order">
</CENTER>
</form>
</font></TD>
<TD colspan=2 valign=top><font size="2" face="Arial, Helvetica, sans-serif">
This will delete an Entire Year, the directory and all months and idividual order files within it<br><br>
<FORM METHOD="POST" ACTION="manager.cgi">
<b>Select Year to Delete</b><br>
<SELECT NAME="year">
$scm_yearlinks
</SELECT><br><br>
<CENTER>
<font face=arial size=2 color=red>NOTE: Once you delete this Year,<br>it and all months and orders within are gone forever!</font><br><br>
<INPUT TYPE="HIDDEN" NAME="deletionType" VALUE="year">
<INPUT TYPE="HIDDEN" NAME="system_edit_success" VALUE="yes">
<INPUT NAME="DeleteIndividualOrder" TYPE="SUBMIT" VALUE="Delete this Year's Order Logs">
</CENTER>
</form>
</TD>
</TR></table>

</TD>
</TR>
</TABLE>

</CENTER><br><br><br>
~;

print &$manager_page_footer;
}
#######################################################################################
sub display_Order_mgr_screen
{

if ($sc_item_Total_Weight eq "") {
$sc_item_Total_Weight = "item Total Weight";
}

if ($sc_defaultProductStatus eq "") {
$sc_defaultProductStatus = "in Stock";
}

print &$manager_page_header("Order Management Setups","","","","");

print <<ENDOFTEXT;
<CENTER>
<HR>
</CENTER>

<FORM ACTION="manager.cgi" METHOD="POST">
<CENTER>
<TABLE>
<TR>
<TD>
<FONT FACE=ARIAL size=2>Welcome to the <b>AgoraCart</b>  Store Manager for Order Management.  This area allows you to select which order logs you wish to use.  If you wish to to see customized report ranges based on date ranges of orders as well as total sales and other totals for the date range, please purchase the lifetime membership found at the AgoraCart.com.  By doing som, you in turn support this Open Source Software (OSS) and help keep it going.<br><br></TD>
</TR>
</TABLE>
</CENTER>

ENDOFTEXT

if($in{'system_edit_success'} ne "")
{
print <<ENDOFTEXT;
<CENTER><br>
<TABLE>
<TR>
<TD>
<FONT FACE=ARIAL SIZE=2 COLOR=RED>Your Order Management settings have been 
successfully updated. </FONT>
</TD>
</TR>
</TABLE>
</CENTER>
ENDOFTEXT
}

print qq~
<br>
<FORM ACTION="manager.cgi" METHOD="POST">
   <div align="center">
   <table border="0" cellspacing="0">
<TR>
<TD bgcolor=#99CC99 COLSPAN=2><center><font face="Arial, Helvetica, sans-serif" size=+2><b>Order Logging & Sales Reporting Setups</b></font></center></TD>
</TR>
<TR>
<TD><br></TD>
</TR>
<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD><font face="Arial, Helvetica, sans-serif" size=2>
<b>Do you wish to have the orders written to a New order log file?</b><br>This is an order log that stores NEW orders with most order details in a single file/log. Default is YES</font></td>
<td><font face="Arial, Helvetica, sans-serif" size=2><SELECT NAME="log_orders_yes_no">
<OPTION>$sc_send_order_to_log</OPTION>
<OPTION>yes</OPTION>
<OPTION>no</OPTION>
</SELECT></td></tr>
<TR>
<TD><br></TD>
</TR>
<tr><td><font face="Arial, Helvetica, sans-serif" size=2><b>Choose a unique name for your log file.</b><br> (ex: "mylog3218.log")</TD>
<TD><font face="Arial, Helvetica, sans-serif" size=2>
<INPUT NAME="name_of_the_log_file" TYPE="TEXT" VALUE="$sc_order_log_name">
</font></TD>
</TR>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD><font face="Arial, Helvetica, sans-serif" size=2>
<b>Do you wish to have the orders written to a individual order log files?</b><br>This is an order log that stores a single order.  You can use it with/or without the Master order log file.  Default is YES</font></td>
<td colspan=2><font face="Arial, Helvetica, sans-serif" size=2><SELECT NAME="sc_write_individual_order_logs">
<OPTION>$sc_write_individual_order_logs</OPTION>
<OPTION>yes</OPTION>
<OPTION>no</OPTION>
</SELECT></font></td></tr>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD><font face="Arial, Helvetica, sans-serif" size=2>
<b>Do you wish to have the orders written to a monthly overview order log file?</b><br>This is an order log that stores key data on each order within for an entire month at a time.  We recommend this be set to YES if you ever want to use the custom reports manager (a members only add-on file) or other tools used for quick order lookups & reports. Default is YES</font></td>
<td colspan=2><font face="Arial, Helvetica, sans-serif" size=2><SELECT NAME="sc_write_monthly_short_order_logs">
<OPTION>$sc_write_monthly_short_order_logs</OPTION>
<OPTION>yes</OPTION>
<OPTION>no</OPTION>
</SELECT></font></td></tr>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD><font face="Arial, Helvetica, sans-serif" size=2>
<b>Do you wish to have the orders written to a monthly master order log file?</b><br>This is an order log that stores every piece of standard data on each order within for an entire month at a time.  We recommend this be set to YES if you ever want to use the data export manager (for order management, and a members only add-on file)  for such things as exporting data for accounting purposes or other.  Individual log files contain the same information, but are not as handy if you wish to export a large number of orders to accounting and/or spreadsheet formats. NOTE: these files can be very substantial in size if you get a large number of orders, so use with care.  Default is NO</font></td>
<td colspan=2><font face="Arial, Helvetica, sans-serif" size=2><SELECT NAME="sc_write_monthly_master_order_logs">
<OPTION>$sc_write_monthly_master_order_logs</OPTION>
<OPTION>yes</OPTION>
<OPTION>no</OPTION>
</SELECT></font></td></tr>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>
<TR>
<TD><font face="Arial, Helvetica, sans-serif" size=2>
<b>Do you wish to keep track of products solds?</b><br>This is an order log that records the number of each item in your product database. Tracking is done an an annual basis.  A nice little tool to see the year to date sales of each item you offer.  Default is YES</font></td>
<td colspan=2><font face="Arial, Helvetica, sans-serif" size=2><SELECT NAME="sc_write_product_sales_logs">
<OPTION>$sc_write_product_sales_logs</OPTION>
<OPTION>yes</OPTION>
<OPTION>no</OPTION>
</SELECT></font></td></tr>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD><font face="Arial, Helvetica, sans-serif" size=2>
<b>Title for item shipping weight /cost?</b><br>This is a title for order management displays, invoices, and packing slips for the value found in each of your product's shipping weight/cost field within your product database.  Select a title appropriate to your useage of this field.  Example, if the field is used to indicate an item's weight, this is then totalled up for the total weight of each individual product sold (which is used store wide and cannot be used both ways, must be a weight, a cost or blank).  So, this will be the title for the output for the order management functions in regards to this product data field.</font></td>
<td colspan=2><font face="Arial, Helvetica, sans-serif" size=2><INPUT NAME="sc_item_Total_Weight" TYPE="TEXT" SIZE=20 
MAXLENGTH="25" VALUE="$sc_item_Total_Weight"></font></td></tr>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD><font face="Arial, Helvetica, sans-serif" size=2>
<b>Enter Default Order Status</b><br>This is the default wording used for each order (in Progress, Completed, Shipping, On Hold, etc).</font></td>
<td colspan=2><font face="Arial, Helvetica, sans-serif" size=2><INPUT NAME="sc_order_status_default" TYPE="TEXT" SIZE=20 
MAXLENGTH="25" VALUE="$sc_order_status_default"></font></td></tr>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD><font face="Arial, Helvetica, sans-serif" size=2>
<b>Enter Default Product Status</b><br>This is the default wording used for each product as it's written to the logs, unless it's downloadable (download module is a members only add-on file).</font></td>
<td colspan=2><font face="Arial, Helvetica, sans-serif" size=2><INPUT NAME="sc_defaultProductStatus" TYPE="TEXT" SIZE=20 
MAXLENGTH="25" VALUE="$sc_defaultProductStatus"></font></td></tr>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>
   </table>

   </div>
   <p align="center">&nbsp;</p>
   <p align="center"><font face="Arial"><INPUT TYPE="HIDDEN" NAME="system_edit_success" value="yes">
<INPUT NAME="OrderManagementSettings" TYPE="SUBMIT" value="Submit">
&nbsp;&nbsp;
<INPUT TYPE="RESET" value="Reset"></font></p>
   </form>
~;

print &$manager_page_footer;
}
#######################################################################################
sub select_monthly_orders_screen
{

print &$manager_page_header("Select Orders to View by Month","","","","");

print <<ENDOFTEXT;
<CENTER>
<HR>
</CENTER>


<CENTER>
<TABLE>
<TR>
<TD>
<FONT FACE=ARIAL size=2>Welcome to the <b>AgoraCart</b> Monthly Order Viewer for your store.<br>Note: You must have <i>Yearly</i> and or <i>Monthly</i> order logging enabled for this to work properly.</font></TD>
</TR>
</TABLE>
</CENTER>
<br>
ENDOFTEXT


print qq~
<CENTER>
<FORM METHOD="POST" ACTION="manager.cgi">
<TABLE>
<TR>
<TD><br></TD>
</TR>
<TR>
<TD COLSPAN=4 BGCOLOR="#99CC99" align=center><font face="Arial, Helvetica, sans-serif" size=+2><b>Create Your Custom Online Report</b></font></TD>
</TR>
<TR>
<TD><br></TD>
</TR>
<TR>
<TD colspan=4>
<TABLE>
<TR>
<TD colspan=2>
<font size="2" face="Arial, Helvetica, sans-serif">
<b>Select items to track in your<br>Report / View Orders</b><br><small>* not all items available by default.<br>Some require other add-ons and<br>customizations in order to initially save<br>the data, such as affiliate sales<br>and net profit totals</small><br><br>


</font></TD>
<TD colspan=2 valign=top><font size="2" face="Arial, Helvetica, sans-serif">
<b>Select Month to View</b><br>
<SELECT NAME="ordersmonthmonth">
$scm_monthlinks
</SELECT> 
<SELECT NAME="ordersmonthyear">
$scm_yearlinks
</SELECT><br>
<br><br><br><br><br>
<CENTER>
<INPUT TYPE="HIDDEN" NAME="system_edit_success" VALUE="yes">
<INPUT NAME="CompileMonthlyOrdersReport" TYPE="SUBMIT" VALUE="View Orders for the above Month">
&nbsp;&nbsp;
<INPUT TYPE="RESET" VALUE="Reset">
</CENTER>

</font>
</TD>
</TR></table>

</TD>
</TR>

</TABLE>
</CENTER><br><br>
~;

print &$manager_page_footer;
}
#######################################################################################
sub compile_Monthly_Order_information
{

my (%orderLoggingHash);

&ReadParse;

my $tempmonththingy = $in{'ordersmonthmonth'};
my $tempyearthingy = $in{'ordersmonthyear'};

my $filename4 = "$sc_order_log_directory_path/$tempyearthingy/$tempmonththingy/$tempmonththingy$tempyearthingy$scm_monthyearindexlog_name";

print &$manager_page_header("Display Order Log for a Month","","","");

print qq~<center><br><br>
<table width=740 border=0 cellpadding=2 cellspacing=0><tr>
<td valign=middle align=center><font face=arial size=+1><b>Orders for Overview</b></font></td>
</tr></table>
<table width=740 border=1 cellpadding=2 cellspacing=0><tr>
<td valign=middle align=center bgcolor=#99CC99><font face=arial size=2><b>Order Status</b></font></td>
<td valign=middle align=center bgcolor=#99CC99 width=85><font face=arial size=2><b>Order Date</b></font></td>
<td valign=middle align=center bgcolor=#99CC99><font face=arial size=2><b>Invoice #</b></font></td>
<td valign=middle align=center bgcolor=#99CC99><font face=arial size=2><b>Customer Name</b></font></td>
<td valign=middle align=center bgcolor=#99CC99><font face=arial size=2><b>Order Total</b></font></td>
<td bgcolor=#99CC99><font face=arial size=2>&nbsp;</font></td>
</tr>
~;

&get_file_lock("$logfile.lockfile");
open(LOGFILE, "$filename4") || print "<br>THE $tempmonththingy $tempyearthingy ORDER LOG DOES NOT EXIST\n<tr><td width=620 colspan=8 align=center><font face=arial size=2>Sorry, No Orders</font></td></tr>\n";
while (<LOGFILE>) {
# print "$_<br>";
($year,$month,$day,$orderLoggingHash{'invoiceNumber'},$orderLoggingHash{'customerNumber'},$orderLoggingHash{'orderStatus'},$orderLoggingHash{'firstName'},$orderLoggingHash{'lastName'},$orderLoggingHash{'fullName'},$orderLoggingHash{'companyName'},$orderLoggingHash{'emailAddress'},$orderLoggingHash{'orderFromState'},$orderLoggingHash{'orderFromPostal'},$orderLoggingHash{'orderFromCountry'},$orderLoggingHash{'shipMethod'},$orderLoggingHash{'shippingTotal'},$orderLoggingHash{'salesTax'},$orderLoggingHash{'tax1'},$orderLoggingHash{'tax2'},$orderLoggingHash{'tax3'},$orderLoggingHash{'discounts'},$orderLoggingHash{'netProfit'},$orderLoggingHash{'subTotal'},$orderLoggingHash{'orderTotal'},$orderLoggingHash{'affiliateTotal'},$orderLoggingHash{'affiliateID'},$orderLoggingHash{'affiliateMisc'},$orderLoggingHash{'GatewayUsed'},$orderLoggingHash{'buySafe'}) = split(/\t/,$_);

$orderLoggingHash{'orderTotal'} = &format_pricemgr($orderLoggingHash{'orderTotal'});

 if (($orderLoggingHash{'invoiceNumber'} eq "") && ($_ eq "")) {
   print "<tr><td width=620 colspan=8 align=center><font face=arial size=2>Sorry, No Orders</font></td></tr>\n";
   $sorry_thingy= "stop";
  }


if ($sorry_thingy ne "stop") {
print qq~<tr>
<td valign=middle align=center><font face=arial size=2>$orderLoggingHash{'orderStatus'}</font></td>
<td valign=middle align=center><font face=arial size=2>$month, $day, $year</font></td>
<td valign=middle align=center><font face=arial size=2>$orderLoggingHash{'invoiceNumber'}</font></td>
~;

if ($orderLoggingHash{'lastName'} ne "") {
print qq~
<td valign=middle align=center><font face=arial size=2>$orderLoggingHash{'firstName'} $orderLoggingHash{'lastName'}</font></td>
~;
} else {
print qq~
<td valign=middle align=center><font face=arial size=2>$orderLoggingHash{'fullName'}</font></td>
~;
}

$order_filename = "$scm_order_logpath/$orderLoggingHash{'invoiceNumber'}" . "-" . "$orderLoggingHash{'customerNumber'}";
print qq~
<td valign=middle align=center><font face=arial size=2>$sc_money_symbol $orderLoggingHash{'orderTotal'}</font></td>
<td valign=middle align=center><font face=arial size=2><a href="manager.cgi?invoiceviewertrigger=invoiceviewertrigger&invoiceNumber=$orderLoggingHash{'invoiceNumber'}&customerNumber=$orderLoggingHash{'customerNumber'}&year=$year&month=$month" target="_new">View Invoice</a><br><a href="manager.cgi?viewertrigger=viewertrigger&invoiceNumber=$orderLoggingHash{'invoiceNumber'}&customerNumber=$orderLoggingHash{'customerNumber'}&year=$year&month=$month">View/Update</a><br><a href="manager.cgi?packingviewertrigger=packingviewertrigger&invoiceNumber=$orderLoggingHash{'invoiceNumber'}&customerNumber=$orderLoggingHash{'customerNumber'}&year=$year&month=$month" target="_new">Packing Slip</a><br><a href="manager.cgi?originalviewertrigger=originalviewertrigger&invoiceNumber=$orderLoggingHash{'invoiceNumber'}&customerNumber=$orderLoggingHash{'customerNumber'}&year=$year&month=$month" target="_new">Original Order</a><br><a href="manager.cgi?deleteviewertrigger=yes&invoiceNumber=$orderLoggingHash{'invoiceNumber'}&customerNumber=$orderLoggingHash{'customerNumber'}&year=$year&month=$month">Delete/Remove</a><br></font></td>
</tr>
~;
}

 }# End of while LOGFILE

close(LOGFILE);
&release_file_lock("$logfile.lockfile");

print qq~<tr>
<td valign=middle align=center bgcolor=#99CC99><font face=arial size=2><b>Order Status</b></font></td>
<td valign=middle align=center bgcolor=#99CC99 width=85><font face=arial size=2><b>Order Date</b></font></td>
<td valign=middle align=center bgcolor=#99CC99><font face=arial size=2><b>Invoice #</b></font></td>
<td valign=middle align=center bgcolor=#99CC99><font face=arial size=2><b>Customer Name</b></font></td>
<td valign=middle align=center bgcolor=#99CC99><font face=arial size=2><b>Order Total</b></font></td>
<td bgcolor=#99CC99><font face=arial size=2>&nbsp;</font></td>
</tr>
</table><br></center><br>
~;
print &$manager_page_footer;

}
#######################################################################################
1; # Library
