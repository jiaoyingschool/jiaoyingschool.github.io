$sc_gateway_userkey = "Enter your Key Here";
$sc_order_script_url = "https://www.usaepay.com/gate.php";
$merchant_live_mode = "yes";
$sc_USAepay_submit = 'agora.cgi?secpicserve=submit_order.gif';
$sc_USAepay_change = 'agora.cgi?secpicserve=make_changes.gif';
$sc_USAepay_verify_message = "Please verify the information below.  When you are confident it is correct, click on the \'Submit Order For Processing\' button to go to complete your order";
$sc_USAepay_order_desc = "USAepay - AgoraCart Online Order";
$sc_display_checkout_tos = "yes";
$sc_tos_display_address = qq'AgoraCart<br>
123 Main<br>
Salt Lake City, UT 88888<br>
123-456-7890';
$sc_USAepay_top_message = "top message<br>";
$USAepay_order_ok_final_msg_tbl = "top of confirm page<br>";
$messages{'USAepay_declined'} = qq~<br>Declined Payment Message Here. Cart Still exists.   Try Again.~;
$messages{'USAepay_errror'} = qq~<br>Error Message Here. Cart Still exists.  Try Again.~;
$acceptvisa = "yes";
$acceptmastercard = "yes";
$acceptdiscover = "no";
$acceptamex = "no";
1;
