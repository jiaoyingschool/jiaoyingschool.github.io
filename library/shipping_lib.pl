#!/usr/local/bin/perl

# split out ups xml into userfiles and separate shipping file

# For use with AgoraCart (aka agora.cgi) only.
#
# Parts taken from Business:UPS CPAN  module and included here
# because that module if often not installed at Web hosting companies
# 
# written by Steve Kneizys Jan 9, 2000
# Modified and Maintained by Mister Ed at K-Factor Technologies, Inc / AgoraCart.com
# Copyright 2002-Present by K-Factor Technologies, Inc & AgoraScript
#
# Modified 1/21/2000 to use http-lib.pl as some folks do not 
# have LWP or lynx installed at their web hosting company
# UPDATE: lynx is being phased out, APIs tend to require POST now
#
# Modified 01/27/2000 to search for lynx and use perl taint mode 
# Modified 02/06/2000 for error-recovery if libraries/modules not found
# Modified 04/21/2000 to allow for custom logic outside this library
# Modified 06/30/2000 USPS code added (not finished yet!)
# Modified 07/02/2000 FedEx code added, added sub LWP_post
# Modified 08/08/2000 New UPS Interface installed
# Modified 08/17/2000 UPS Interface w LWP fixed
# Modified 05/06/2001 UPS Interface fixed, uses 'old' code again 
# Modified 05/11/2001 Includes 'value of items' in 'shipping thing' string
#
# Modifications by Mister Ed at K-Factor Technologies, Inc / AgoraCart.com
#
# Modified 03/07/2003 by Mister Ed  Fixed parcel machine codes - USPS.
# Modified 10/24/2003 by Mister Ed  Fixed multiple boxes for USPS.  Streamlined minor redundancy.
# 	UPS: Also added fuel tax charges of 2%.  error checking to make sure international
# 	shipping methods and Canadian are correct for method and country for UPS.
# Modified 01/26/2005 by Mister Ed  Added UPS XML and international shipping with origins as an add-on for members only.
#	above inspired by donated code from Leamsi Fontanez at http://www.bizmanweb.com but significantly revised
#	DHL shipping foundations added for future expansion into this shipping method
#	separated DHL, FedEx, and UPS XML shipping methods into separate libraries.
#	Original UPS simple shipping cost quotes remain and used if UPS XML not enabled.
# Modified 02/15/2005 by Mister Ed  Finished above changes and phased out lynx socket options
# Modified 05/19/2005 by Mister Ed  Finish Core UPS XML enhancements to work with multiple boxes
#	and multiple origins. ground work for dimensional aspects included, but needs cart contents overhaul first.
# Modified 08/16/2005  by Mister Ed  Added custom logic option to run before or after SBW real-time routines
#   also added $SBW_shipping_price variable incase real time needs to be deducted in the custom logic after
#   running real-time SBW
# Modified May 17, 2007 by Mister Ed  Added dimensional weight for UPS XML and FedEx XML.
#   user4 in cart fields filled with dimensional info for individual items, appended to stevo_shipping_thing for use in 
#   shipping instructions and courtesy rate quotes from real-time providers.
# Modified March 27, 2008 by Mister Ed  - fixed ghosting of empty boxes on items from alt locations or alt dimensions.
# Modified July 25, 2008 by Mister Ed  - fixed USPS to print specific error if 26 or more packages in rate request.

$versions{'shipping_lib.pl'} = "5.2.012";
$ENV{PERL_LWP_SSL_VERIFY_HOSTNAME}=0;
if (($sc_use_SBW =~ /yes/i) || ($sc_need_sockets =~ /yes/i)) { 
 if ($sc_use_socket eq "") { 
   $sc_use_socket = "LWP";   
  }
 if ($sc_use_socket =~ /LWP/) { 
    $test_result = eval("use LWP::Simple; 1;");
    if ($test_result ne "1") {
      print "Content-type: text/html\n\n";
      print "LWP library not installed -- choose another library type\n";
      print "in \"Program Settings\".\n";
      if ($main_program_running =~ /yes/i) {
        &call_exit;
       }
     }
  }
 if ($sc_use_socket =~ /http-lib/i) {
    local($wtd)="";
    if ($main_program_running =~ /yes/i) {
      $wtd .= "warn exit";
      }
    &request_supporting_libraries($wtd, __FILE__, __LINE__, 
		"./library/http-lib.pl");
    $http_lib_loaded = "yes";
  }
}
#********************************************************************
sub agora_http_get {
 local ($site,$path,$workString) = @_;
 local ($answer,$doworkString);
 if ($sc_use_socket =~ /lwp/i) { # use LWP library GET
   $doworkString = "http://$site$path\?${workString}";
   $answer = eval("use LWP::Simple; get\(\"$doworkString\"\);");
  }
 if ($sc_use_socket =~ /http-lib/i) { 
   $answer = &HTTPGet($path,$site,80,$workString);
  }
 return $answer;
}
#********************************************************************
# This routine should take the string of weights and descriptions,
# and decide what goes in what box.  It also returns a string of
# shipping instructions so the people packing know what to put in
# each box to get the weight correct.
#
# It is not very efficient, nor is it very smart!
#
sub ship_put_in_boxes {
 my($weight_data,$names_data, $Origin_ZIP,$max_per_box) = @_;
 my($alt_origin, $instructions, $special_instructions, $items_in_box, $weight_of_box,
       $new_wt_data, $inx1, $inx2, $zip_list, $origin_product_list, $junk, $items_this_round, $value_of_box) = "";
 my($packageType,$separatePackage,$length,$width,$height,$girth,$alt_stateprov) = '';
 my($continue)="yes";
 my($ownbox,$single_item_box_list)="";
 $instructions="";
 $special_instructions="";
 &codehook("shippinglib-put-in-boxes-top");
 if (!($continue =~ /yes/i)) { return;}
	if ($Origin_ZIP eq "") { $Origin_ZIP = "Main Location";}
 $instructions  = "Ship By Weight cost was based on the suggested ";
 $instructions .= "configuration below.  It might not be the best way!\n";
 $instructions .= "ORIGIN: $Origin_ZIP\n\n";
 $instructions .= "Box 1:\n";
 $items_in_box = 0;
 $weight_of_box = 0;
 $value_of_box = 0;
 $new_wt_data = "";

   my @ship_list = split(/\|/,$weight_data);
   @name_list = split(/\|/,$names_data);

    for ($inx1=0; $inx1 <= $#ship_list; $inx1++) {
      ($item_qty,$item_wt,$item_val,$alt_origin,$alt_stateprov,$ownbox,$junk) = split(/\*/,$ship_list[$inx1],6);
      $ztitle = $name_list[$inx1];
      $items_this_round = 0;
      for ($inx2=$item_qty; $inx2 > 0; $inx2--) {
        ($packageType,$separatePackage,$length,$width,$height,$girth) = '';
		($packageType,$separatePackage,$length,$width,$height,$girth) = split(/\,/,$ownbox);
	        if($separatePackage =~ /yes/){
	            if ($single_item_box_list ne "") {
	               $single_item_box_list .= '|';
	            }
		        $single_item_box_list .= "1*$item_wt*$item_val*$alt_origin*$alt_stateprov*$length*$width*$height*$girth*$packageType";
              #  $items_in_box = 1;
              #  $weight_of_box = $item_wt;
              #  $value_of_box = $item_val;
                $items_this_round++;
	       } else {
              if ($items_in_box == 0) {
                 $items_in_box = 1;
                 $weight_of_box = $item_wt;
                 $value_of_box = $item_val;
                 $items_this_round++;
	          } else { # add to or close/start box
	             if (($weight_of_box + $item_wt) < $max_per_box) { #add
	               $items_in_box++;
	               $weight_of_box = $weight_of_box + $item_wt;
	               $value_of_box = $value_of_box + $item_val;
	               $items_this_round++;
	             } else { # close, then start a new box
	                if ($items_this_round > 0) {
	                  $instructions .="  $items_this_round $ztitle [$item_wt]\n";
	                }
	                $instructions .= " Total Weight: $weight_of_box\n\n";
	                if ($new_wt_data ne "") {
	              	  $new_wt_data .= '|';
	                }
    	            $new_wt_data .= "1*${weight_of_box}*${value_of_box}*$alt_origin*$alt_stateprov*****";
	                $instructions .= "Next Box:\n";
	                $items_in_box = 1;
	                $weight_of_box = $item_wt;
	                $value_of_box = $item_val;
	               $items_this_round = 1;
	             } # end of: close, then start a new box
	          } # end of: else on add to or close/start box
	       } # end of: else on ... if $separatePackage
    	} # end of for statement: ($inx2=$item_qty; $inx2 > 0; $inx2--)

        if ($items_this_round > 0) {
            $instructions .="  $items_this_round $ztitle [$item_wt]\n";
        }
     }
    $instructions .= " Total Weight: $weight_of_box\n\n"; 

    if ($single_item_box_list ne "") { 
       if ($new_wt_data ne "") { 
          $new_wt_data .= '|'; 
       } 
       $new_wt_data .= "$single_item_box_list"; 
        $single_item_box_list = ''; 
    }

# commented out to fix for extra boxes being added in
# by Mister Ed March 27, 2008
#    if ($new_wt_data ne "") {
#    	$new_wt_data .= '|';
#    }
#    $new_wt_data .= "1*${weight_of_box}*${value_of_box}*$alt_origin*$alt_stateprov*****";

if ((${weight_of_box} ne '0') && (${value_of_box} ne '0')) {
    if ($new_wt_data ne "") {
    	$new_wt_data .= '|';
    }
    $new_wt_data .= "1*${weight_of_box}*${value_of_box}*$alt_origin*$alt_stateprov*****";
}

    
 if ($max_per_box == 0) {
   $instructions = "Put one item in each box.";
  }

 $final_instructions =  $special_instructions . $instructions;
 &codehook("shippinglib-put-in-boxes-bot");
 # debug
 # print "<br><br> \$new_wt_data = $new_wt_data <br><br> $final_instructions = $final_instructions";
 return ($new_wt_data,$final_instructions);
}
######################################################################
sub calc_SBW {
  my ($method, $dest, $country, $shipping_total, $weight_data) = @_;
  my ($via,$junk);
  ($via,$junk) = split(/\ /,$method,2);
   &codehook("SBW_top");
  if (($via =~ /UPS/i) && ($sc_use_UPS =~ /yes/i)) {
	# modified by Mister Ed 10/24/2003
    $sc_verify_Origin_ZIP = $sc_UPS_Origin_ZIP;
      	return &calc_ups($method, $sc_verify_Origin_ZIP, $sc_verify_Origin_Country, $dest, $country, $shipping_total, $weight_data);
  }
  if (($via =~ /USPS/i) && ($sc_use_USPS =~ /yes/i)) {
    $sc_verify_Origin_ZIP = $sc_USPS_Origin_ZIP;
    return &calc_usps($method, $sc_verify_Origin_ZIP, $dest, $country, $shipping_total, $weight_data);
   }
  &codehook("SBW_bot");
}
######################################################################
sub calc_ups {
    my ($method, $origin, $orgincountry, $dest, $destcountry, $shipping_total, $weight_data) = @_;
    my ($err_printed,$err,$temp_zip_thingy) = "";
    my ($product, $alt_origin, $alt_origin_temp, $weight, $ship_cost, $junk,
        $thezone, $errmsg, $foundit,
        $item_info, $item_wt, $item_qty, $item_cost, $box_total_value, @ship_list, $new_weight_data);
$sc_shipping_thing = "";
$ship_cost = 0; # handling charge added in define_shipping_logic
my (%zip_list);
@ship_list = split(/\|/,$weight_data);
if (($destcountry =~ /united states/i) || ($destcountry =~ /pr/)) {
  $destcountry = "US";
} elsif (($destcountry =~ /cananda/i) || ($destcountry =~ /ca/)) {
  $destcountry = "CA";
} elsif (($destcountry =~ /puerto rico/i) || ($destcountry =~ /pr/)) {
  $destcountry = "PR";
} 
#new stuff for alt origination. use even without alt origination. Added by Mister Ed @ AgoraCart.com
	foreach $ship_list (@ship_list) {
      ($item_qty,$item_wt,$item_val,$alt_origin,$junk) = split(/\*/,$ship_list,5);
		if ($alt_origin ne "") {
			if ($zip_list{$alt_origin} eq "") {
				$zip_list{$alt_origin} = $ship_list;
			} else {
				$temp_zip_thingy = "$zip_list{$alt_origin}";
				$temp_zip_thingy .= "|" . "$ship_list";
				$zip_list{$alt_origin} = "$temp_zip_thingy";
			}
		} else {
			if ($zip_list{$origin} eq "") {
				$zip_list{$origin} = $ship_list;
			} else {
				$temp_zip_thingy = "$zip_list{$origin}";
				$temp_zip_thingy .= "|" . "$ship_list";
				$zip_list{$origin} = "$temp_zip_thingy";
			}
		}
	}
# runs each origination. Added by Mister Ed @ AgoraCart.com
	foreach $origin_product_list (sort (keys %zip_list)) {
 $weight_data = $zip_list{$origin_product_list};
    ($new_weight_data,$ship_ins) = &ship_put_in_boxes($weight_data, $weight_data, $origin_product_list, $sc_UPS_max_wt);
    $sc_shipping_thing .= $new_weight_data;
    $sc_verify_boxes_max_wt = $sc_UPS_max_wt;
    $product = "GNDRES"; #default
    $foundit = "no";
    if ($foundit eq "no") { #Look for code: value ="UPS xyz (PRODUCT)"
       ($junk,$stuff) = split(/\(/,$method,2);
       ($stuff,$junk) = split(/\)/,$stuff,2);
       if ($stuff ne "") { 
          $product = $stuff;
          $foundit = "yes";
         }
      }
    @ship_list = split(/\|/,$new_weight_data);
    foreach $item_info (@ship_list) {
      ($item_qty,$item_wt,$box_total_value,$alt_origin,$junk) = split(/\*/,$item_info,5);
      if ($item_wt <= 1) { # set min value
        $item_wt = 1;
       }
	# alt origin checking by Mister Ed Feb 9, 2005
	if (($alt_origin ne "") && ($sc_alt_origin_enabled =~ /yes/i)) {
	      ($item_cost,$thezone,$errmsg) = &getUPS_simple($product, $alt_origin, $orgincountry, $dest, $destcountry, $item_wt);
	} else {
      		($item_cost,$thezone,$errmsg) = &getUPS_simple($product, $origin, $orgincountry, $dest, $destcountry, $item_wt);
	}
      if ($errmsg ne "") {
      		($item_cost,$thezone,$errmsg) = &getUPS_simple($product, $origin, $orgincountry, $dest, $destcountry, $item_wt);
       }
if ($err_printed eq "") {
# chect to make sure outside of USA and shipping method matches
# added by Mister Ed Oct- 24-2003
    if ($destcountry !~ /US/ && $destcountry !~ /united states/i && $product ne "XPR" && $product ne "XDM" && $product ne "XPD" && $product ne "STD") {
        $err_printed = "yes";
        $order_error_do_not_finish = "yes";
# for Canadian destinations
# added by Mister Ed Oct- 24-2003
if (($destcountry =~ /CA/ || $destcountry =~ /canada/i ) && $product ne "STD") {
        print "<br>If shipping to a Canada, Please<br>",
		"Select a Canadian Shipping Method.<br>\n";
      }
# for all other destination countries outside the USA.  Make sure international shipping methods are chosen.
# added by Mister Ed Oct- 24-2003
if ($destcountry ne "US" && $destcountry ne "CA" && $destcountry !~ /canada/i && $destcountry !~ /united states/i&& $product ne "XPR" && $product ne "XDM" && $product ne "XPD") {
        print "<br>If shipping to a location Outside the USA, Please<br>",
		"Select an International Shipping Method.<br>\n";
      }  
} elsif ($item_cost == 0 && $err_printed eq "") {
        $err_printed = "yes";
        $order_error_do_not_finish = "yes";
        print "UPS module error: shipping cost not determined!<br>",
		"Please use your 'Make Changes' button and correct ",
		"<br>any fields as required and try again.<br>",
        "Please contact the site administrator ASAP if error continues<br><br>",
		"$errmsg<br>\n";
       }
}
      $ship_cost += ($item_qty*$item_cost);
     }
}
	&codehook("UPS_cost_return");
    return $ship_cost;
}
############################################################################
#
# New XML United States Postal Service (USPS) interface module by Mister Ed Feb 2005
# sub calc_usps
# Use with permission only with AgoraCart, AgoraCartPro, AgoraSQL, AgoraCartSQL.
# All other uses strictly prohibited.
# Copyright 2002-present by K-Factor Technologies, Inc
# 
############################################################################
sub calc_usps {
my ($method, $origin, $dest, $destcountry, $shipping_total, $weight_data) = @_;
my ($product_temp_name,$err_printed,$err,$temp_zip_thingy) = "";
my ($product, $alt_origin, $alt_stateprov, $alt_origin_temp, $weight, $ship_cost, $junk, $thezone, $errmsg, $foundit,
	$item_info, $origin_passby, $new_weight_data, $item_wt, $item_qty, $splitanswer, $item_cost, @ship_list);
my ($pounds,$ounces,$usps_prot,$usps_site,$usps_cgi,$answer);
my ($error,$orig_ans);
my ($country, $oversized, $cod);
my (%zip_list);

$ship_cost = 0; # handling charge added in define_shipping_logic

($usps_prot,$junk,$usps_site,$usps_cgi) = split(/\//,$sc_USPS_host_URL,4);
$usps_prot .= '//';
$usps_cgi = '/' . $usps_cgi;

if (($destcountry =~ /kingdom/i) && ($destcountry =~ /united/i)) { # convert UK to England for USPS only
	$destcountry = "England";
}

($junk,$stuff) = split(/\(/,$method,2);
($stuff,$junk) = split(/\)/,$stuff,2);
if ($stuff ne "") { #assume we have a valid product code
   	$product = $stuff;
    $product_temp_name = $stuff;
   	$foundit = "yes";
}
my $productindicator = "$product";
if (($product =~ /Express Mail/i) && ($product !~ /Express Mail International/i)) {$productindicator = "EXPRESS";}
if (($product =~ /First Class/i) && ($product !~ /First Class International/i)) {$productindicator = "FIRST CLASS";}
if ($product =~ /Parcel Post/i) {$productindicator = "PARCEL";}
if (($product =~ /Priority Mail/i) && ($product !~ /Priority Mail International/i)) {$productindicator = "PRIORITY";}

if (($destcountry ne "") && ($destcountry !~ /united states/i) && ($destcountry !~ /puerto rico/i)) {
	if (($product !~ /International/i)) {
       	$err_printed = "yes";
       	$order_error_do_not_finish = "yes";
       	print "USPS shipping error: wrong shipping type for your destination country!<br>",
           	"Please use your browser's back button  or any checkout link/button and select ",
           	"<br>USPS Priority or Express Mail International options.<br><br>$err<br>\n";
		$ship_cost = 0;
		return $ship_cost;
	}
}

$dest =~ /(\w+)/;
$dest = $1;

$sc_verify_boxes_max_wt = $sc_USPS_max_wt;
my @ship_list = split(/\|/,$weight_data);
	foreach $ship_list (@ship_list) {
      ($item_qty,$item_wt,$item_val,$alt_origin,$junk) = split(/\*/,$ship_list,5);
		if ($alt_origin ne "") {
			if ($zip_list{$alt_origin} eq "") {
				$zip_list{$alt_origin} = $ship_list;
			} else {
				$temp_zip_thingy = "$zip_list{$alt_origin}";
				$temp_zip_thingy .= "|" . "$ship_list";
				$zip_list{$alt_origin} = "$temp_zip_thingy";
			}
		} else {
			if ($zip_list{$origin} eq "") {
				$zip_list{$origin} = $ship_list;
			} else {
				$temp_zip_thingy = "$zip_list{$origin}";
				$temp_zip_thingy .= "|" . "$ship_list";
				$zip_list{$origin} = "$temp_zip_thingy";
			}
		}
	}

foreach $origin_product_list (sort (keys %zip_list)) {
	my $packageID = "0";

	$weight_data = $zip_list{$origin_product_list};

	if (($destcountry eq "") || ($destcountry =~ /united states/i) || ($destcountry =~ /puerto/i)) {
    	$workString = "API=RateV3&XML=<RateV3Request "; #>
    	$workString .= "USERID=\"$sc_USPS_userid\">";
	} else {
    	$workString = "API=IntlRate&XML=<IntlRateRequest "; #>
    	$workString .= "USERID=\"$sc_USPS_userid\">";
	}

	($new_weight_data,$ship_ins) = &ship_put_in_boxes($weight_data, $weight_data, $origin_product_list, $sc_USPS_max_wt);

	$sc_shipping_thing .= $new_weight_data;

    @ship_list = split(/\|/,$new_weight_data);

    my $temp_num_packs = $#ship_list +1;
    if ($#ship_list > 24) {
       	    $err_printed = "yes";
       	    $order_error_do_not_finish = "yes";
       	    print qq|USPS shipping error:<br>Your Order is too large for US Postal Service shipments.<br>
You have $temp_num_packs packages in this shipment.  You must have 25 and under.<br>
<br>Please remove some items and then recalculate shipping at checkout.<br><br>$err<br>\n|;
		    $ship_cost = 0;
		    return $ship_cost;
    }

    foreach $item_info (@ship_list) {
        my ($length,$width,$height,$girth) = '';
    	($item_qty,$item_wt,$box_total_value,$alt_origin,$alt_stateprov,$length,$width,$height,$girth,$myBoxType,$junk) = split(/\*/,$item_info,11);

        # changed by Mister Ed Dec 17, 2006 to allow for First Class and ounces
	    ($pounds,$ounces) = split(/\./, $item_wt);
		$ounces = ("." . $ounces)*16;

		#Taint mode stuff ...
		$ounces = $ounces + 0.9999999999; # round her up!
		$ounces =~ /(\w+)/;
    	$ounces = $1;
		$pounds = $pounds + 0.9999999999; # round her up!
		$pounds =~ /(\w+)/;
    	$pounds = $1;

        if ($ounces eq 16) {
          $pounds++;
    	  $ounces = "0";
        }

	if (($product =~ /First Class/i) && ((($destcountry !~ /united states/i) && ($destcountry !~ /puerto rico/i))||(($pounds > 0)||($ounces > 13)))) {
       	$err_printed = "yes";
       	$order_error_do_not_finish = "yes";
       	print "USPS shipping error: You cannot select First Class Mail for this shipment!<br>",
           	"<br> Total weight for this shipment must be under 13oz, your shipment weight is: $pounds pounds and $ounces ounces.",
           	"Please use your browser's back button or any checkout link/button and select ",
           	"<br>a different shipping method<br><br>$err<br>\n";
		$ship_cost = 0;
		return $ship_cost;
    }

		if (($alt_origin ne "") && ($sc_alt_origin_enabled =~ /yes/i)) {
			$origin_passby = $alt_origin;
		} else {
			$origin_passby = $sc_USPS_Origin_ZIP;
		}

    	$origin_passby =~ /(\w+)/; 
    	$origin_passby = $1;
        my $package_dimensions_string = '';
		my $container = "$myBoxType";
        my $containersize = 'REGULAR';
        my $USPS_machineable = "False";
        if ($length eq '') { $length = $sc_USPS_avg_package_length;}
        if ($width eq '') { $width = $sc_USPS_avg_package_width;}
        if ($height eq '') { $height = $sc_USPS_avg_package_height;}
        if ($girth eq '') { $girth = $sc_USPS_avg_package_girth;}

        if (($USPS_PackageType !~ /flat rate/i) && (($myBoxType eq '')||($myBoxType !~ /flat rate/i))) {
		$container = "$USPS_PackageType";
        if ($product =~ /Express/i) { $container = '';}
        if (($product =~ /parcel/i) && ($pounds < 35) && ($length < 34) && ($width < 17) && ($height < 17) && ($container ne 'NONRECTANGULAR')) {
            $USPS_machineable = "True";
         }
         my $temp_large = ($length + (2*$height) + (2*$width));
         if (($girth ne '') && ($myBoxType eq "NONRECTANGULAR")) {$temp_large = $girth;}
	     if ((($product =~ /Express Mail/i) && ($temp_large > 108))||(($product =~ /Express Mail International/i) && ($temp_large > 79) && ($product !~ /flat rate/i))) {
       	    $err_printed = "yes";
       	    $order_error_do_not_finish = "yes";
       	    print qq|USPS shipping error: You cannot select Express Mail for this shipment!<br>
            	The package is too large for this shipping method.
            	Please use your browser's back button or any checkout link/button and select 
            	<br>a different shipping method<br><br>$err<br>\n|;
		    $ship_cost = 0;
		    return $ship_cost;
          }
	     if ((($product =~ /Priority Mail/i) && ($temp_large > 108))||(($product =~ /Priority Mail International/i) && ($temp_large > 79) && ($product !~ /flat rate/i))) {
       	    $err_printed = "yes";
       	    $order_error_do_not_finish = "yes";
       	    print qq|USPS shipping error: You cannot select Priority Mail for this shipment!<br>
            	 The package is too large for this shipping method.
            	Please use your browser's back button or any checkout link/button and select 
            	<br>a different shipping method<br><br>$err<br>\n|;
		    $ship_cost = 0;
		    return $ship_cost;
          }
            if (($temp_large > 84) && ($temp_large < 108.001)) {
                $containersize = 'LARGE';
                if (($pounds + $ounces) < 15) {$pounds = "15", $ounces = '';}
                if ($product =~ /Priority/i) {
                   $package_dimensions_string = qq|
<Width>$width</Width>
<Length>$length</Length>
<Height>$height</Height>
|;
                }
             } elsif (($temp_large > 108) && ($temp_large < 130.001)) {
                $containersize = 'OVERSIZE';
             } elsif ($product =~ /priority/i) { $container = '';}

        } 
	if (($destcountry eq "") || ($destcountry =~ /united states/i) || ($destcountry =~ /puerto/i)) { # USA and PR
		$workString .= "<Package ID=\"$packageID\">";
	    $workString .= "<Service>$productindicator</Service>";
	    $workString .= "<ZipOrigination>$origin_passby</ZipOrigination>";
	    $workString .= "<ZipDestination>$dest</ZipDestination>";
	    $workString .= "<Pounds>$pounds</Pounds>";
	    $workString .= "<Ounces>$ounces</Ounces>";
		$workString .= "<Container>$container</Container>";
	    $workString .= "<Size>$containersize</Size>";
        $workString .= "$package_dimensions_string";
	    $workString .= "<Machinable>$USPS_machineable</Machinable></Package>";
	} else { 
		$workString .= "<Package ID=\"$packageID\">";
	    $workString .= "<Pounds>$pounds</Pounds>";
	    $workString .= "<Ounces>$ounces</Ounces>";
    	$workString .= "<MailType>Package</MailType>";
    	$workString .= "<Country>$destcountry</Country>";
    	$workString .= "</Package>";
	}
		$packageID++;
	}

	if (($destcountry eq "") || ($destcountry =~ /united states/i) || ($destcountry =~ /puerto/i)) { 
		$workString .= "</RateV3Request>";
	} else { # international string
		$workString .= "</IntlRateRequest>";
	}
	$doworkString = "$usps_prot$usps_site$usps_cgi\?${workString}";
    # debug
    # print "<br>$doworkString <br>";

	if ($sc_use_socket =~ /lwp/i) { # use LWP library POST
	# By calling this way, no error generated if library is missing
	# when the library is first loaded up or at runtime of this routine
	$answer = eval("use LWP::UserAgent;");
		if ($@ eq "" ) {
    		$answer = LWP_post($doworkString);
		} else {
	    	print "<br><left>$@</left><br>\n";
	    	$answer = "";
	  	}
	} elsif ($sc_use_socket =~ /http-lib/i) { # use http-lib.pl library GET
		$answer = &HTTPGet($usps_cgi,$usps_site,80,$workString);
	}

	$answer =~ s/\&amp;lt;sup\&amp;gt;&amp;amp;reg;&amp;lt;\/sup\&amp;gt;//ig;
    $answer =~ s/\&amp;lt;sup\&amp;gt;&amp;amp;trade;&amp;lt;\/sup\&amp;gt;//ig;
    $answer =~ s/\&lt;sup\&gt;\&amp;trade;\&lt;\/sup\&gt;//ig;

	&codehook("USPS_XML_data_dump");
	# For now used old method to get rate from XML
   	$orig_ans = $answer;
	if (($destcountry eq "") || ($destcountry =~ /united states/i) || ($destcountry =~ /puerto/i)) { # USA and PR
		while ($answer =~ /<Rate>/ig) {
   			($junk,$answer) = split(/<Rate>/i,$answer,2);
   			($splitanswer,$answer) = split(/<\/Rate>/i,$answer,2);
			$item_cost += $splitanswer;
		}
	} else { # international string
   			($splitanswer,$answer) = split(/<\/AreasServed>/i,$answer,2);
			while ($answer =~ /<Service/ig) {
   				($splitanswer,$answer) = split(/<\/Service>/i,$answer,2);
                # debug
                # print " SPLITANSWER = $splitanswer <br><br>";
                # print "Looked For:  = $product <br><br><br><br>";
				if (($splitanswer =~ /$product/i) && ($splitanswer !~ /flat rate/i) && ($splitanswer !~ /Non\-Document/i)) {
   					($junk,$splitanswer) = split(/<Postage>/i,$splitanswer,2);
   					($splitanswer,$junk) = split(/<\/Postage>/i,$splitanswer,2);
                    # debug
                    # print "COST FOUND: $splitanswer <br><br><br><br>";
					$item_cost += $splitanswer;
				} elsif (($splitanswer =~ /$product/i) && ($product =~ /flat rate/i) && ($splitanswer =~ /flat rate/i) && ($splitanswer !~ /envelope/i)) {
   					($junk,$splitanswer) = split(/<Postage>/i,$splitanswer,2);
   					($splitanswer,$junk) = split(/<\/Postage>/i,$splitanswer,2);
                    # debug
                    # print "FLAT RATE COST FOUND: $splitanswer <br><br><br><br>";
					$item_cost += $splitanswer;
                }
			}
		}
   	if ($answer eq "") {
   		$error=$orig_ans;
   	}

	if ($item_cost == 0 && $err_printed eq "") {
       	$err_printed = "yes";
       	$order_error_do_not_finish = "yes";
       	print "USPS module error: shipping cost not determined!<br>",
           	"Please use your browser's back button or any checkout link/button and correct ",
           	"<br>any fields as required and try again.  Also, make sure your postal code is correct.<br>",
           	"You may also need to chose a different USPS shipping method for your destination<br><br>$err<br>\n";
	}
	$ship_cost += $item_cost;
	$item_cost = 0;
} # end of each origination

	&codehook("UPS_USPS_cost_return");

	return $ship_cost;
}
############################################################################
#
# Insurance aspects donated by Leamsi Fontanez at www.bizmanweb.com Feb 2005 
# insurance "yes" altered by Mister Ed for ignore case on yes.
# not used currently
# 
############################################################################
# Codes for product may be found at:
#  http://theory.uwinnipeg.ca/CPAN/data/Business-UPS/UPS.html
#  Ex: 1DA - Next Day, 2DA 2nd Day, GNDCOM Ground Commercial
#  GNDRES Ground Residential, XPR Worldwide Express

#-- START OF CODE MODIFIED FROM UPS.pm

# new lines to work string added by Mister Ed Jan 2005.  Play with it as needed.
# may or may not work on this older quoting system

sub getUPS_simple {
    my ($product, $origin, $orgincountry, $dest, $destcountry, $weight) = @_;
    my ($length, $width, $height, $oversized, $cod);
    my ($RateChart) = $sc_UPS_RateChart;
    my ($answer, $workString);
    my $ups_prot = 'http://';
    my $ups_site = 'www.ups.com';
    my $ups_cgi = '/using/services/rave/qcostcgi.cgi';
    #filter/fix RateChart for changes at UPS Jan 1, 2011 - By Mister Ed with AgoraCart.com
    $RateChart =~ s/Regular Daily Pickup/Daily Pickup/;
    my $workString = "?";
    $workString .= "accept_UPS_license_agreement=yes&";
    $workString .= "10_action=3&";
    $workString .= "13_product=" . $product . "&";
    $workString .= "14_origCountry=" . $orgincountry . "&";
    $workString .= "15_origPostal=" . $origin . "&";
    $workString .= "19_destPostal=" . $dest . "&";
#    $workString .= "20_destCity=" . $destCity . "&";
    $workString .= "23_weight=" . $weight;
#    $workString .= "&billToUPS=" . $ if $; # default is yes. set to no if not UPS account
    $workString .= "&22_destCountry=" . $destcountry if $destcountry;
#    $workString .= "&customValue=" . $ if $; #customs on international shipments
#    $workString .= "&24_value=" . $ if $; # insurance purposes
    $workString .= "&25_length=" . $length if $length;
    $workString .= "&26_width=" . $width if $width;
    $workString .= "&27_height=" . $height if $height;
    $workString .= "&29_oversized=1" if $oversized;
    $workString .= "&47_rate_chart=" . $RateChart if $RateChart;
    $workString .= "&30_cod=1" if $cod;
#    $workString .= "&39_response=" if $; #set to 0 for none, 1 for basic, and 2 for signature required
#    $workString .= "&ASD1=ADS" if $; #set to adult over 21 signature required
	$workString .= "&48_container=00";
    $doworkString = "${ups_prot}${ups_site}${ups_cgi}${workString}";
    
if ($sc_use_socket =~ /lwp/i) {
  $answer = eval("use LWP::UserAgent;  LWP_post\(\"$doworkString\"\);");
 }
if ($sc_use_socket =~ /http-lib/i) { 
  $answer = &HTTPPost($ups_cgi,$ups_site,80,$workString);
 }
    my @ret = split( '%', $answer );
   
    if (! $ret[5]) {
	return (undef,undef,$ret[1]);
    }
    else {
	my $total_shipping = $ret[10];
	my $ups_zone = $ret[6];
# adjust for old pricing and add in fuel surcharges for next day and one time pickups
# added by Mister Ed Oct- 24-2003
# edited June 30, 2006 for admin control by Mister Ed
     if ($total_shipping > 0 && $sc_ups_non_xml_adjust =~ /yes/i) {
         $total_shipping = ($total_shipping * $sc_ups_non_xml_adjust_rate);
     }
	 return ($total_shipping,$ups_zone,undef);
    }
}

sub Error {
    my $error = shift;
    print STDERR "$error\n";
    exit(1);
}
############################################################################
sub define_shipping_logic {
 # original stevo passed here.  w/ alt origination if enabled. split off shipping total
 # altered by Mister Ed @ AgoraCart.com Jan 2005
 local($shipping_total, $stevo_shipping_thing) = @_;
 local($orig_zip, $dest_zip, $ship_method, $mylogic);
 local($shipping_price)=0;
 local($ship_logic_run,$ship_logic_done)="no";
 local($continue)="yes";
 local($use_vform)="no";
 my($SBW_shipping_price)=0;
 &codehook("shippinglib-define-shipping-logic");
 if (!($continue =~ /yes/i)) { return;}
 $ship_method = $form_data{'Ecom_ShipTo_Method'};
 if ($ship_method eq "") {
   $use_vform = "yes";
   $ship_method = $vform{'Ecom_ShipTo_Method'};
  }
 ($sc_ship_method_shortname,$junk) = split(/\(/,$ship_method,2);
 if (($sc_use_custom_shipping_logic =~ /yes/i) && ($sc_location_custom_shipping_logic =~ /before/i)) {
   $mylogic = "$sc_custom_shipping_logic";
   eval($mylogic);
   $err_code = $@;
   if ($err_code ne "") { 
     &update_error_log("custom-shipping-logic $err_code ","","");
    }
   $ship_logic_run="yes";
   if (($ship_logic_done =~ /yes/i) || ($shipping_logic_done =~ /yes/i)) 
    { 
     return $shipping_price;
    }
  } 
 if ($sc_use_SBW =~ /yes/i) {
  $stevo_shipping_thing =~ s/\|//;
   $dest_zip = $form_data{'Ecom_ShipTo_Postal_PostalCode'};
   $dest_country = $form_data{'Ecom_ShipTo_Postal_CountryCode'};
   if ($dest_zip eq "") { 
     $use_vform = "yes";
     $dest_zip = $vform{'Ecom_ShipTo_Postal_PostalCode'};
    }
   if ($dest_country eq "") { 
     $use_vform = "yes";
     $dest_country = $vform{'Ecom_ShipTo_Postal_CountryCode'};
    }
   if ($dest_country eq "") { 
     $use_vform = "yes";
     $dest_country = $vform{'Ecom_BillTo_Postal_CountryCode'};
    }
   if ($dest_country eq "") { 
     $dest_country = "US";
    }
   $SBW_shipping_price = &calc_SBW($ship_method,$dest_zip,$dest_country,$shipping_total,$stevo_shipping_thing);   
   $shipping_price = $shipping_price + $SBW_shipping_price;   
   $ship_logic_run="yes";
  }
 if (($sc_use_custom_shipping_logic =~ /yes/i) && ($sc_location_custom_shipping_logic =~ /after/i)) {
   $mylogic = "$sc_custom_shipping_logic";
   eval($mylogic);
   $err_code = $@;
   if ($err_code ne "") { #script died, error of some kind
     &update_error_log("custom-shipping-logic $err_code ","","");
    }
   $ship_logic_run="yes";
   if (($ship_logic_done =~ /yes/i) || ($shipping_logic_done =~ /yes/i)) 
    { #done, may exit
     return $shipping_price;
    }
  } 

 if (!($ship_logic_run =~ /yes/i)) {# this is what is left 
   $shipping_price = $shipping_total;
  }

 if (($shipping_price > 0 ) || ($sc_add_handling_cost_if_shipping_is_zero =~ /yes/i)) {
		if ($sc_handling_charge_type =~ /percentage/i) {
			$shipping_price = $shipping_price + ($temp_total * $sc_handling_charge);
		} elsif ($sc_handling_charge_type =~ /flat/i) {
			$shipping_price = $shipping_price + $sc_handling_charge;
		} else {
			# do nothing
		}
  }
 return &format_price($shipping_price);
}
############################################################################
sub LWP_post {
local ($ua);
local ($stuff) = @_;
local ($site_url,$info_to_post);
($site_url,$info_to_post) = split(/\?/,$stuff,2);
  $ua = new LWP::UserAgent;
  $ua->agent("AgentName/0.1 " . $ua->agent);
  my $req = new HTTP::Request POST => $site_url;
  $req->content_type('application/x-www-form-urlencoded');
  $req->content($info_to_post);
  my $res = $ua->request($req);
  if ($res->is_success) {
      return $res->content;
  } else {
      return "ERROR";
  }
}
############################################################################
$shipping_lib_loaded_ok = "yes";
1;
