## This file contains the user specific variables
## necessary for AgoraCart to operate

#:#:#: start CART settings
sub init_cart_settings {
@sc_cart_index_for_display = ( 
    $cart{"quantity"} 
    ,$cart{"db_user1"} 
    ,$cart{"name"} 
    ,$cart{"options"} 
    ,$cart{"shipping"} 
    ,$cart{"price_after_options"} 
    );
$sc_cart_display_str = 'Qty|Picture|Product|Options|Shipping Wt.<br>(lbs)|Cost';
@sc_cart_display_fields = split(/\|/,$sc_cart_display_str);
$sc_cart_display_col = 'quantity|db_user1|name|options|shipping|price_after_options';
@sc_col_name = split(/\|/,$sc_cart_display_col);
$sc_cart_display_fact = 'no|no|no|no|yes|yes';
@sc_cart_display_factor = split(/\|/,$sc_cart_display_fact);
$sc_cart_display_form = 'no|no|no|no|yes|yes';
@sc_cart_display_format = split(/\|/,$sc_cart_display_form);
@sc_textcart_index_for_display = ( 
    $cart{"email_options"} 
    ,$cart{"price_after_options"} 
    ,$cart{"price_after_options"} 
    ,$cart{"shipping"} 
    ,$cart{"shipping"} 
    );
$sc_textcart_display_str = 'Options|Cost (each)|Item Subtotal|Wt. each|Total Wt.';
@sc_textcart_display_fields = split(/\|/,$sc_textcart_display_str);
$sc_textcart_display_col = 'email_options|price_after_options|price_after_options|shipping|shipping';
@sc_textcol_name = split(/\|/,$sc_textcart_display_col);
$sc_textcart_display_fact = 'no|no|yes|no|yes';
@sc_textcart_display_factor = split(/\|/,$sc_textcart_display_fact);
$sc_textcart_display_form = 'none|2-D Price|2-D Price|none|none';
@sc_textcart_display_format = split(/\|/,$sc_textcart_display_form);
}
if ($main_program_running =~ /yes/i) {
&add_codehook("after_loading_setup_db","init_cart_settings");
} else { 
&init_cart_settings;
}
#:#:#: end CART settings
#:#:#: start CATEGORYLIST settings
$sc_categories_with_subcats = qq|
&bull;<a href="agora.cgi?cart_id=%%cart_id%%&amp;product=Art&amp;xm=on" class="ac_left_links" title="Art">Art</a> <br />
&bull;<a href="agora.cgi?cart_id=%%cart_id%%&amp;product=Books&amp;xm=on" class="ac_left_links" title="Books">Books</a> <br />
&nbsp;&nbsp; <a href="agora.cgi?cart_id=%%cart_id%%&amp;product=Books&amp;user4=Adobe&amp;xm=on" class="ac_left_links" title="Adobe">Adobe</a> <br />
&nbsp;&nbsp; <a href="agora.cgi?cart_id=%%cart_id%%&amp;product=Books&amp;user4=DHTML&amp;xm=on" class="ac_left_links" title="DHTML">DHTML</a> <br />
&nbsp;&nbsp; <a href="agora.cgi?cart_id=%%cart_id%%&amp;product=Books&amp;user4=Flash&amp;xm=on" class="ac_left_links" title="Flash">Flash</a> <br />
&nbsp;&nbsp; <a href="agora.cgi?cart_id=%%cart_id%%&amp;product=Books&amp;user4=HTML&amp;xm=on" class="ac_left_links" title="HTML">HTML</a> <br />
&nbsp;&nbsp; <a href="agora.cgi?cart_id=%%cart_id%%&amp;product=Books&amp;user4=Linux&amp;xm=on" class="ac_left_links" title="Linux">Linux</a> <br />
&nbsp;&nbsp; <a href="agora.cgi?cart_id=%%cart_id%%&amp;product=Books&amp;user4=Multimedia&amp;xm=on" class="ac_left_links" title="Multimedia">Multimedia</a> <br />
&nbsp;&nbsp; <a href="agora.cgi?cart_id=%%cart_id%%&amp;product=Books&amp;user4=UNIX&amp;xm=on" class="ac_left_links" title="UNIX">UNIX</a> <br />
&bull;<a href="agora.cgi?cart_id=%%cart_id%%&amp;product=HT2ML Books&amp;xm=on" class="ac_left_links" title="HT2ML Books">HT2ML Books</a> <br />
&bull;<a href="agora.cgi?cart_id=%%cart_id%%&amp;product=Hands Free&amp;xm=on" class="ac_left_links" title="Hands Free">Hands Free</a> <br />
&bull;<a href="agora.cgi?cart_id=%%cart_id%%&amp;product=Machine Tooling&amp;xm=on" class="ac_left_links" title="Machine Tooling">Machine Tooling</a> <br />
&bull;<a href="agora.cgi?cart_id=%%cart_id%%&amp;product=Programming&amp;xm=on" class="ac_left_links" title="Programming">Programming</a> <br />|;
$sc_categories_bots_with_subcats = qq|
&bull;<a href="agora.cgi?product=Art&amp;xm=on" class="ac_left_links" title="Art">Art</a> <br />
&bull;<a href="agora.cgi?product=Books&amp;xm=on" class="ac_left_links" title="Books">Books</a> <br />
&nbsp;&nbsp; <a href="agora.cgi?product=Books&amp;user4=Adobe&amp;xm=on" class="ac_left_links" title="Adobe">Adobe</a> <br />
&nbsp;&nbsp; <a href="agora.cgi?product=Books&amp;user4=DHTML&amp;xm=on" class="ac_left_links" title="DHTML">DHTML</a> <br />
&nbsp;&nbsp; <a href="agora.cgi?product=Books&amp;user4=Flash&amp;xm=on" class="ac_left_links" title="Flash">Flash</a> <br />
&nbsp;&nbsp; <a href="agora.cgi?product=Books&amp;user4=HTML&amp;xm=on" class="ac_left_links" title="HTML">HTML</a> <br />
&nbsp;&nbsp; <a href="agora.cgi?product=Books&amp;user4=Linux&amp;xm=on" class="ac_left_links" title="Linux">Linux</a> <br />
&nbsp;&nbsp; <a href="agora.cgi?product=Books&amp;user4=Multimedia&amp;xm=on" class="ac_left_links" title="Multimedia">Multimedia</a> <br />
&nbsp;&nbsp; <a href="agora.cgi?product=Books&amp;user4=UNIX&amp;xm=on" class="ac_left_links" title="UNIX">UNIX</a> <br />
&bull;<a href="agora.cgi?product=HT2ML Books&amp;xm=on" class="ac_left_links" title="HT2ML Books">HT2ML Books</a> <br />
&bull;<a href="agora.cgi?product=Hands Free&amp;xm=on" class="ac_left_links" title="Hands Free">Hands Free</a> <br />
&bull;<a href="agora.cgi?product=Machine Tooling&amp;xm=on" class="ac_left_links" title="Machine Tooling">Machine Tooling</a> <br />
&bull;<a href="agora.cgi?product=Programming&amp;xm=on" class="ac_left_links" title="Programming">Programming</a> <br />|;
#:#:#: end CATEGORYLIST settings
#:#:#: start DISCOUNT settings
$sc_enable_discount = "no";
@sc_discount_logic = ("");
#:#:#: end DISCOUNT settings
#:#:#: start FEATUREDPRODUCT settings
$sc_featuredProduct = qq~<div align=center><a class=ac_left_links href="agora.cgi?cart_id=%%cart_id%%&amp;p_id=00001&amp;xm=on">
                         <img class="template_image_no_border" src="%%URLofImages%%/sm_0009.gif" alt="featured product" /></a><br /><br />
<a class=ac_left_links href="agora.cgi?cart_id=%%cart_id%%&amp;p_id=00001&amp;xm=on"><b>Perl for Newbies</b></a><br />
This is the short description.  In fact this description is really short.<br />
<font class=ac_product_price>%%sc_money_symbol%% 5.00</font></div>
~;
$sc_featuredProduct_secure = qq|<div align=center><a class=ac_left_links href="agora.cgi?cart_id=%%cart_id%%&amp;p_id=00001&amp;xm=on">
     <img class="template_image_no_border" src=%%URLofImages%%/sm_0009.gif" alt="featured product" /></a><br /><br />
<a class=ac_left_links href="agora.cgi?cart_id=%%cart_id%%&amp;p_id=00001&amp;xm=on"><b>Perl for Newbies</b></a><br />
This is the short description.  In fact this description is really short.<br />
<font class=ac_product_price>%%sc_money_symbol%% 5.00</font></div>
|;
$sc_displayFeaturedProducts = "yes";
#:#:#: end FEATUREDPRODUCT settings
#:#:#: start FREEFORMLOGIC settings
$mc_free_form_logic_row_count = "25";
$sc_free_form_logic = "\# This gets executed after the agora.setup.db file is loaded
\# by agora.cgi ... You can set \'html thingies\', load libraries, etc.
\#
\&add_codehook(\"process-order-pre-ship-instructions\",\"order_confirmation_changer_function\");

sub order_confirmation_changer_function {

\$messages{\'ordcnf_08\'} = \"AgoraCart Shopping Receipt - thank you\";

 }

";
#
$sc_free_form_logic_too = "";
#
if ($main_program_running =~ /yes/i) {
  &add_codehook("after_loading_setup_db","run_freeform_logic");
  &add_codehook("pre_header_navigation","run_freeform_logic");
  &add_codehook("open_for_business","run_freeform_logic_too");
 }
$sc_free_form_logic_done = 0; 
sub run_freeform_logic { 
  local($f)=__FILE__;
  local($l)=__LINE__;
  if ($sc_free_form_logic_done) {return '';}
  $sc_free_form_logic_done = 1; 
  eval($sc_free_form_logic);
  if ($@ ne "") {
    &update_error_log("Free Form Logic err: $@",$f,$l);
    open(ERROR, $error_page);
    while (<ERROR>) { print $_; }
    close (ERROR);
    &call_exit;
   }
 }
sub run_freeform_logic_too { 
  local($f)=__FILE__;
  local($l)=__LINE__;
  eval($sc_free_form_logic_too);
  if ($@ ne "") {
    &update_error_log("Free Form Too Logic err: $@",$f,$l);
    open(ERROR, $error_page);
    while (<ERROR>) { print $_; }
    close (ERROR);
    &call_exit;
   }
 }
#:#:#: end FREEFORMLOGIC settings
#:#:#: start LAYOUT settings
$sc_use_html_product_pages = "maybe";
$sc_use_category_name_as_header = "yes";
$sc_use_category_name_as_ppinc_root = "yes";
$sc_should_i_display_cart_after_purchase = "no";
$sc_should_i_display_cart_after_purchase_real = "no";
$sc_db_max_rows_returned = "6";
$sc_money_symbol = qq`\$`;
$sc_money_symbol_placement = "front";
$sc_money_symbol_spaces = "";
$layout_store_productpage_thanks_mess = qq~Thank you, your selection has been added to your order.~;
$sc_search_error_message = qq~I\'m sorry, no matches were found. Please try your search again.~;
$sc_item_ordered_message = '<tr><td class="ac_add_message">Thank you, your selection has been added to your order.</td></tr>';
$sc_show_shipping_label_box = "yes";
$sc_totals_table_ship_label = "Shipping:";
$sc_totals_table_disc_label = "Discount:";
$sc_totals_table_stax_label = "Sales Tax (statehere) :";
$sc_show_subtotal_label_box = "yes";
$sc_totals_table_subtot_label = "Sub Total";
$sc_totals_table_gtot_label = "Grand Total:";
$sc_totals_table_itot_label = "Item Cost Subtotal";
$sc_totals_table_thdr_label = "Order Totals";
$sc_display_cartlinksite = "yes";
$sc_display_cartlinksite_url = "www.domain-here.com";
$sc_display_cartlinksite_name = "domain-here.com";
$sc_display_cartlinkhome = "yes";
$sc_display_cartlinkhome_name = "Restart Shopping";
$sc_footer_copyright_text = "2001-2008 by K-Factor Technologies Inc.";
#:#:#: end LAYOUT settings
#:#:#: start MAIN settings
$sc_set_0077_umask = 'no';
$original_umask = umask 0077;
$sc_allow_ofn_choice = "no";
$sc_gateway_name = "Offline";
$sc_replace_orderform_form_tags = "yes";
$sc_database_lib = "agora_db_lib.pl";
$sc_prod_db_pad_length = "5";
$sc_minimum_order_amount = "2.00";
$sc_minimum_order_text = "US Dollars";
$sc_prevent_zero_total_orders = "No";
$sc_need_short_cart_id = "No";
$sc_use_database_subcats = "Yes";
$sc_subcat_index_field = "user4";
$sc_count_database_cats = "No";
$sc_http_affiliate_call = qq!!;
$sc_temp_affiliate_call = "";
$sc_send_order_to_email = "yes";
$sc_second_send_order_to_email = "no";
$sc_order_email = "address\@domain-here.com";
$sc_first_order_email = "AgoraCart\@domain-here.com";
$sc_second_order_email = "sales\@yourdomain.com";
$sc_use_customer_email_over_admin = "no";
$sc_use_dynamic_email_subjects = "no";
$sc_store_url = "http://www.agoracart.com/store52/agora.cgi";
$sc_ssl_location_url2 = "https://secure.domain-here.net/store52/agora.cgi";
$sc_stepone_order_script_url = "https://secure.domain-here.net/store52/agora.cgi";
$sc_admin_email = "address\@domain-here.com";
$sc_domain_name_for_cookie = "www.domain-here.com";
$sc_path_for_cookie = "/store52";
$sc_self_serve_images = "No";
$URL_of_images_directory = "html/images";
$sc_path_of_images_directory =  "html/images";
$sc_number_days_keep_old_carts = 1;
$sc_shall_i_log_accesses = "no";
$sc_order_check_db = "yes";
$sc_negative_priced_options = "yes";
$sc_use_verified_opt_values = "yes";
$sc_disable_variable_options = "no";
$sc_scramble_cc_info = "yes";
$sc_running_an_SSI_store = 'no';
$sc_use_meta_cookies = 'no';
$sc_debug_mode = "no";
$sc_headerTemplateName = "TheAgora/TheAgora_BluGreen";
$sc_headerTemplateRoot = "TheAgora";
$sc_buttonSetName = "TheAgora_BluGreen";
$sc_buttonSetURL = "html/images/buttonsets/TheAgora_BluGreen";
$sc_displayDynamicCategories = "yes";
$sc_headerStoreTitle = "Powered by AgoraCart version 5.2.005";
$sc_headerStoreTagLine = "Thanks for Visiting our Store!";
$sc_store_header_file = "./html/html-templates/templates/TheAgora/store_header.html";
$sc_store_footer_file = "./html/html-templates/templates/TheAgora/store_footer.html";
$sc_secure_store_header_file = "./html/html-templates/templates/TheAgora/secure_store_header.html";
$sc_secure_store_footer_file = "./html/html-templates/templates/TheAgora/secure_store_footer.html";
$sc_standard_head_info = qq|<link rel="stylesheet" type="text/css" href="agorastyles.css" media="screen">
<link rel="stylesheet" type="text/css" href="html/html-templates/templates/TheAgora/TheAgora_BluGreen/agoratemplate.css" media="screen">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
|;
$sc_secure_standard_head_info = qq|
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
|;
$sc_doctype =  qq|<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">|;
##############################################################
$sc_domain_name_for_cookie = "$ENV{'SERVER_NAME'}";
$sc_my_script_name = "$ENV{'SCRIPT_NAME'}";
#
# Cute little trick to get manager to display correct "guess" at a path
if ($sc_my_script_name eq "") {
  $sc_my_script_name = "/store/agora.cgi";
 }
if ($sc_my_script_name =~ "/protected/manager") {
  $sc_my_script_name =~ s/protected\/manager/agora/;
 }
$sc_store_url = "http://${sc_domain_name_for_cookie}$sc_my_script_name";
$sc_order_email = "orders\@$sc_domain_name_for_cookie";
$sc_admin_email = "sales\@$sc_domain_name_for_cookie";
($sc_path_for_cookie,$junk) = split(/\/ragora.cgi/,$sc_my_script_name,2);
($sc_path_for_cookie,$junk) = split(/\/agora.cgi/,$sc_path_for_cookie,2);
# # # # display special message at manager welcome screen # # # #
{ local ($msg)='';
if ($mc_first_time_user_to_agora_check eq '') {
  $mc_first_time_user_to_agora_check = '1';
  $msg .= "The store setup has 'guessed' at some values, please go ";
  $msg .= 'to the main store settings under "Program Settings" and ';
  $msg .= 'set and SAVE values for this store.   ';
  $other_welcome_message .= "<BR><BR><FONT COLOR=RED>$msg</FONT>";
  $other_welcome_message .= "&nbsp;&nbsp;";
  $other_welcome_message .= "<a href='manager.cgi?main_settings_screen=1'>";
  $other_welcome_message .= "Main Settings";
  $other_welcome_message .= "</a>";
 }
}
##############################################################
#:#:#: end MAIN settings
#:#:#: start NEWPRODUCTS settings
$sc_tenNewProducts = qq~~;
#:#:#: end NEWPRODUCTS settings
#:#:#: start ORDERMANAGER settings
$sc_order_log_name = "your_order.log";
$sc_send_order_to_log = "yes";
$sc_write_individual_order_logs = "yes";
$sc_write_monthly_master_order_logs = "yes";
$sc_write_monthly_short_order_logs = "yes";
$sc_write_product_sales_logs = "yes";
$sc_defaultProductStatus = "in Stock";
$sc_order_status_default = "in Progress";
$sc_item_Total_Weight = "item Total Weight";
#:#:#: end ORDERMANAGER settings
#:#:#: start PGP settings
$sc_use_pgp = "no";
$sc_pgp_change_newline = "";
$sc_pgp_or_gpg = "GPG";
$sc_pgp_or_gpg_path = "/usr/local/bin/gpg";
$sc_pgp_order_email = "sales\@yourdomain.com";
#:#:#: end PGP settings
#:#:#: start SHIPPING settings
$sc_calculate_shipping_loop = "3";
$sc_handling_charge = "0";
$sc_handling_charge_type = "Flat Rate";
$sc_add_handling_cost_if_shipping_is_zero = "no";
$sc_alt_origin_enabled = "yes";
$sc_alt_origin_db_counter = "11";
$sc_use_custom_shipping_logic = "yes";
$sc_location_custom_shipping_logic = "before";
$sc_use_SBW2 = "no";
$sc_custom_shipping_logic = qq`\# In this example shipping types are used from the defaults listed in the
\# Custom Shipping Methods section of the shipping manager setups, plus some extra samples that
\# are commented out with the pound sign (\#) so that they are not used.
\# Remember that the first match found is the one used.  So use catchall or general logic at the end of the array.
\# Arrays start with the \@ symbol.
\#
\# general recipe for each shipping logic, which can be combined on everything but cost, is:
\#  a|b|c|d|e
\# a = shipping method. Can be left blank but must match the name value of the shipping types on the order form used.
\# b = number of items. Can be blank or combined with c and d as conditions to be matched for more complex logic.
\# c = number of items. Can be blank or combined with b and d as conditions to be matched for more complex logic.
\# d = number of items. Can be blank or combined with b and c as conditions to be matched for more complex logic.
\# e = cost of shipping. Can be a fixed cost (3.99) or a percentage of total cost (10.5%), but not both.
\#
\@sc_shipping_logic = 
(
    \"Electronic Delivery|1-9|||0\", \# logic definition is: if electronic delivery method|with 1 or more items|||shipping equals \$0 cost or Free
    \"Electronic Delivery|10-|||3.00\", \# logic definition is: if electronic delivery method|with 1 or more items|||shipping equals \$2 cost
    \"Local Delivery|1-|||100.00\",
    \"Pickup|1-|||0\"  \# logic definition is: if pickup method|with 1 or more items|||shipping equals \$0 cost or Free

\#    \"UPS|||1-9.99|0\"  \# logic definition is: if ups method|||between 1 and 10 pounds|shipping equals \$10 cost
\#    \"UPS|||10-14.99|15\%\"  \# logic definition is: if ups method|||between 10 and 15 pounds|shipping cost is 15\% of order subtotal
\#    \"UPS|1-9||15-19.99|20\"  \# logic definition is: if ups method|with 1 to 9 items||and between 10 and 15 pounds|shipping cost is \$20
\#    \"UPS|10-||15-19.99|9\%\"  \# logic definition is: if ups method|with 10 or more items||and between 10 and 15 pounds|shipping cost is 9\% of order subtotal
\#    \"UPS||199.99-|20-|0\"  \# logic definition is: if ups method||subtotal of order is \$200 or more|and weighing 20 pounds or more|shipping cost is \$0 or Free
\#    \"||349-||0\"  \# logic definition is: any method||where subtotal of order is \$349 or more||shipping cost is \$0 or Free.

);
\#
\$shipping_price = \&calculate_shipping(\$temp_total, 
                  \$total_quantity, \$total_measured_quantity);
\#
\# Code does not force exit, so handling charge will be added!
\# use this to terminate shipping logic:
\# \$ship_logic_done = \'yes\';`;
$sc_use_SBW = "yes";
$sc_use_socket = "LWP";
$sc_use_UPS = "yes";
$sc_UPS_max_wt = "15";
$sc_ups_unitofmeasure = "LBS";
$sc_Origin_City = "Provo";
$sc_shipper_insurance_override = "no";
$sc_use_USPS = "yes";
$sc_USPS_max_wt = "15";
$sc_USPS_Origin_ZIP = "84606";
$sc_USPS_use_API = "";
$sc_USPS_userid = "";
$sc_USPS_password = "";
$sc_USPS_host_URL = "http://production.shippingapis.com/ShippingAPI.dll";
#:#:#: end SHIPPING settings
#:#:#: start TAX settings
$sc_non_taxables_enabled = "yes";
$sc_non_taxables_db_counter = "";
$sc_non_taxables_db_counter2 = "";
$mc_tax_logic_rows = "3";
$sc_sales_tax = ".043";
$sc_sales_tax_state = "CO";
$sc_use_tax1_logic = "no";
$sc_use_tax2_logic = "no";
$sc_use_tax3_logic = "no";
$sc_extra_tax1_name = "City Tax";
$sc_extra_tax2_name = "";
$sc_extra_tax3_name = "";
$sc_extra_tax1_logic = qq`\$sc_city_tax_variable = \"Ecom_ShipTo_Postal_City\";
\$city_variable = \$form_data{\$sc_city_tax_variable};
if (\$city_variable =~ /Louisville/i) { \# replace city name with yours
\$city_tax = (\$subtotal *0.14525);  \# replace decimal values with your tax amount
                 }`;
$sc_extra_tax2_logic = qq``;
$sc_extra_tax3_logic = qq``;
#:#:#: end TAX settings
#
1;
