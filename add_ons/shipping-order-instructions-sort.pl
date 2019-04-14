#!perl
#######################################################################
#
# Shipping Instructions Compiled for Alternate Origins ... if enabled
#
# Author: Mister Ed for AgoraScript.com, a division of K-Factor Technologies, Inc
# Copyright 2002-Present K-Factor Technologies, Inc.  All Rights Reserved.
#
# This is NOT FREE AND/OR GPL SOFTWARE!  This library is a cost item.
# This software is a separate add-on to an ecommerce shopping cart and 
# is the confidential and proprietary information of K-Factor Technologies, Inc.  You may
# not disclose such Confidential Information and shall use it only in
# conjunction with the AgoraCart (aka agora.cgi) shopping cart.
#
# Requires AgoraCart version 5.0.0 or above.  Just place this file in the add-on directory.
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
#######################################################################

$versions{'shipping-order-instructions-sort.pl'} = "5.1.001";

&add_codehook("process-cart-item","alt_origin_ship_instructions");
&add_codehook("process-cart-item","alt_stevo_ship_thing_names");
&add_codehook("orderlib-ship-instructions","alt_origin_process_ship_instructions");
&add_codehook("orderlib-ship-instructions","alt_run_stevo_ship_thingy_names");

$stevo_shipping_names_secondary = "";

sub alt_origin_ship_instructions {
    my $product_temp = $product;
    if ($sc_ship_thingy_p_id_indicator_enabled =~ /yes/i) {
         $product_temp = "$cart_fields[1]" . " " . "$product";
    }
	if ($sc_alt_origin_enabled =~ /yes/i) {
        ($alt_origin,$alt_stateprov) = split(/\,/,$cart_fields[11],2);
		if ($alt_origin ne "") {
			if ($zip_list{$alt_origin} eq "") {
				$zip_list{$alt_origin} = "$quantity\*$weight";
				$zip_names_list{$alt_origin} = "$product_temp\($options\)";
			} else {
				$temp_zip_thingy = "$zip_list{$alt_origin}";
				$temp_zip_thingy .= "|" . "$quantity\*$weight";
				$zip_list{$alt_origin} = "$temp_zip_thingy";
				$temp_zip_thingy = "$zip_names_list{$alt_origin}";
                $temp_zip_thingy .= "|" . "$product_temp\($options\)";
				$zip_names_list{$alt_origin} = "$temp_zip_thingy";
			}
		} else {
			if ($zip_list{$sc_verify_Origin_ZIP} eq "") {
				$zip_list{$sc_verify_Origin_ZIP} = "$quantity\*$weight";
				$zip_names_list{$sc_verify_Origin_ZIP} = "$product_temp\($options\)";
			} else {
				$temp_zip_thingy = "$zip_list{$sc_verify_Origin_ZIP}";
				$temp_zip_thingy .= "|" . "$quantity\*$weight";
				$zip_list{$sc_verify_Origin_ZIP} = "$temp_zip_thingy";
				$temp_zip_thingy = "$zip_names_list{$sc_verify_Origin_ZIP}";
                $temp_zip_thingy .= "|" . "$product_temp\($options\)";
				$zip_names_list{$sc_verify_Origin_ZIP} = "$temp_zip_thingy";
			}
		}
	}
} 

sub alt_origin_process_ship_instructions {
	if ($sc_alt_origin_enabled =~ /yes/i) {
		my ($origin_product_list_form, $ship_instructions2) = "";
        $ship_instructions = "";
		foreach $origin_product_list_form (sort (keys %zip_list)) {
			$stevo_shipping_thing = "$zip_list{$origin_product_list_form}";
			$stevo_shipping_names = "$zip_names_list{$origin_product_list_form}";
 			($ship_thing_too,$ship_instructions2) = 
			&ship_put_in_boxes($stevo_shipping_thing,$stevo_shipping_names,$origin_product_list_form,$sc_verify_boxes_max_wt);
			$ship_instructions .= "$ship_instructions2";
		}
		$sc_orderlib_use_SBW_for_ship_ins = "no";
	}
}

sub alt_stevo_ship_thing_names {
    if ($sc_ship_thingy_p_id_indicator_enabled =~ /yes/i) {
        my $product_temp = "$cart_fields[1]" . " " . "$product";
        $stevo_shipping_names_secondary .="|$product_temp\($options\)";
    }
}

sub alt_run_stevo_ship_thingy_names {
	if (($sc_alt_origin_enabled =~ /no/i) && ($stevo_shipping_names_secondary ne '')) {
		$stevo_shipping_names = $stevo_shipping_names_secondary;
		($ship_thing_too,$ship_instructions) = 
		&ship_put_in_boxes($stevo_shipping_thing,$stevo_shipping_names_secondary,$sc_verify_Origin_ZIP,$sc_verify_boxes_max_wt);
		$sc_orderlib_use_SBW_for_ship_ins = "no";
	}
}
1; #we are a library