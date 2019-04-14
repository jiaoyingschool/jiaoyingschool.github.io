$IPN_order_script_url = "https://www.paypal.com/cgi-bin/webscr";
$sc_order_notify_url = "http://www.domain.com/cgi-bin/store/agora.cgi";
$sc_order_return_url = "http://www.domain.com/cgi-bin/store/agora.cgi";
$sc_paypal_cancel_return = "";
$sc_paypal_header_image = "";
$currency_id = "USD";
$sc_PayPalIPN_show_table = "yes";
$sc_PayPalIPN_top_message = qq'Enter top message here or leave blank';
$sc_PayPalIPN_shipping_message = qq'Enter shipping message here or leave blank';
$sc_PayPalIPN_special_message = qq'Enter special message here or leave blank';
$sc_PayPalIPN_order_name = qq'PayPalIPN AgoraCart Purchase, INV# $sc_verify_inv_no';
$sc_display_checkout_tos = "no";
$sc_tos_display_address = qq'AgoraCart<br>
123 Main<br>
Salt Lick City, UT 88888<br>
123-456-7890';
$order_ok_final_msg_tbl = qq'';
$sc_paypal_return_button_text = qq'';
$messages{'paypalipn_echeck'} = qq~~;
$messages{'paypalipn_pending'} = qq~~;
$messages{'paypalipn_denied'} = qq~~;
1;
