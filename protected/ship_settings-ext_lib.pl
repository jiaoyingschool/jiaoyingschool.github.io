# file ./store/protected/ship_settings-ext_lib.pl
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
##########################################################################

$versions{'ship_settings-ext_lib.pl'} = "5.2.003";
$sc_custom_shipping_methodname_string = '';
$sc_shipadminfile="$mgrdir/misc/ship_admin.pl";

{
 local ($modname) = 'shipping_settings';
 &register_extension($modname,"Shipping Library Settings",$versions{$modname});
 &add_settings_choice("shipping settings"," Shipping Settings & Logic ",
  "shipping_settings_screen");
 &register_menu('shipping_settings_screen',"show_ship_settings_screen",
  $modname,"Display Shipping Library Settings");
 &register_menu('ChangeShipSettings',"action_input_ship_settings",
  $modname,"Write Shipping Library Settings");
}
#######################################################################################
sub action_input_ship_settings
{

local($admin_email, $order_email, $cookieDomain, $cookiePath);
local($other_program_settings)="";
my ($temp_db_thingy, $ups_xml_temp_thingy, $ups_temp_thingy, $usps_temp_thingy)="";
my ($temp_origin_country_thingy, $myset, $myset2)="";

&ReadParse;

if ($in{'sc_alt_origin_db_counter2'} ne "") {
  $temp_db_thingy = $in{'sc_alt_origin_db_counter2'};
  if ($temp_db_thingy =~ /User 20/i) {
    $sc_alt_origin_db_counter = 26;
  } elsif ($temp_db_thingy =~ /User 2/i) {
    $sc_alt_origin_db_counter = 8;
  } elsif ($temp_db_thingy =~ /User 3/i) {
    $sc_alt_origin_db_counter = 9;
  } elsif ($temp_db_thingy =~ /User 4/i) {
    $sc_alt_origin_db_counter = 10;
  } elsif ($temp_db_thingy =~ /User 5/i) {
    $sc_alt_origin_db_counter = "11";
  } else {
    $sc_alt_origin_db_counter = "";
  }
}

#set admin file stuff. reduces variable overhead
$myset2 .= "\$sc_howmanycustomshippingmethods = \"$in{'sc_howmanycustomshippingmethods'}\";\n";

$myset .= "\$sc_ship_thingy_p_id_indicator_enabled = \"$in{'sc_ship_thingy_p_id_indicator_enabled'}\";\n";
$myset .= "\$sc_calculate_shipping_loop = \"$in{'sc_calculate_shipping_loop'}\";\n";
$myset .= "\$sc_handling_charge = \"$in{'sc_handling_charge'}\";\n";
$myset .= "\$sc_handling_charge_type = \"$in{'sc_handling_charge_type'}\";\n";
$myset .= "\$sc_add_handling_cost_if_shipping_is_zero = \"$in{'sc_add_handling_cost_if_shipping_is_zero'}\";\n";
$myset .= "\$sc_alt_origin_enabled = \"$in{'sc_alt_origin_enabled'}\";\n";
$myset .= "\$sc_use_custom_shipping_logic = \"$in{'sc_use_custom_shipping_logic'}\";\n";
$myset .= "\$sc_location_custom_shipping_logic = \"$in{'sc_location_custom_shipping_logic'}\";\n";
$myset .= "\$sc_use_SBW2 = \"$in{'sc_use_SBW2'}\";\n";
$sc_custom_shipping_logic = &my_escape($in{'sc_custom_shipping_logic'});
$myset .= "\$sc_custom_shipping_logic = qq`$sc_custom_shipping_logic`;\n";
$myset .= "\$sc_use_SBW = \"$in{'sc_use_SBW'}\";\n";
$myset .= "\$sc_use_socket = \"$in{'sc_use_socket'}\";\n";
$myset .= "\$sc_dimensional_shipping_enabled = \"$in{'sc_dimensional_shipping_enabled'}\";\n";
  $myset .= "\$sc_use_UPS = \"$in{'sc_use_UPS'}\";\n";
    $myset .= "\$sc_UPS_Origin_ZIP = \"$in{'sc_UPS_Origin_ZIP'}\";\n";
    $myset .= "\$sc_UPS_max_wt = \"$in{'sc_UPS_max_wt'}\";\n";
    $myset .= "\$sc_UPS_RateChart = \"$in{'sc_UPS_RateChart'}\";\n";
    $myset .=  "\$sc_upsgroundres = \"$in{'sc_upsgroundres'}\";\n";
    $myset .=  "\$sc_upsgroundcomm = \"$in{'sc_upsgroundcomm'}\";\n";
    $myset .=  "\$sc_ups2da = \"$in{'sc_ups2da'}\";\n";
    $myset .=  "\$sc_ups1da = \"$in{'sc_ups1da'}\";\n";
    $myset .=  "\$sc_ups_non_xml_adjust = \"$in{'sc_ups_non_xml_adjust'}\";\n";
    $myset .=  "\$sc_ups_non_xml_adjust_rate = \"$in{'sc_ups_non_xml_adjust_rate'}\";\n";

$myset .= "\$sc_use_USPS = \"$in{'sc_use_USPS'}\";\n";
my $usps_temp_thingy = $in{'sc_use_USPS'};
if ($usps_temp_thingy =~ /yes/i) {
  $myset .= "\$sc_USPS_max_wt = \"$in{'sc_USPS_max_wt'}\";\n";
  $myset .= "\$sc_USPS_Origin_ZIP = \"$in{'sc_USPS_Origin_ZIP'}\";\n";
  $myset .= "\$sc_USPS_use_API = \"$in{'sc_USPS_use_API'}\";\n";
  $myset .= "\$sc_USPS_userid = \"$in{'sc_USPS_userid'}\";\n";
#  $myset .= "\$sc_USPS_password = \"$in{'sc_USPS_password'}\";\n";
  $myset .= "\$sc_USPS_host_URL = \"$in{'sc_USPS_host_URL'}\";\n";
  $myset .= "\$USPS_PackageType = \"$in{'USPS_PackageType'}\";\n";
  $myset .= "\$sc_USPS_avg_package_length = \"$in{'sc_USPS_avg_package_length'}\";\n";
  $myset .= "\$sc_USPS_avg_package_width = \"$in{'sc_USPS_avg_package_width'}\";\n";
  $myset .= "\$sc_USPS_avg_package_height = \"$in{'sc_USPS_avg_package_height'}\";\n";
  $myset .= "\$sc_USPS_avg_package_girth = \"$in{'sc_USPS_avg_package_girth'}\";\n";
  $myset2 .=  "\$sc_uspsparcelpost = \"$in{'sc_uspsparcelpost'}\";\n";
  $myset2 .=  "\$sc_uspsprioritymail = \"$in{'sc_uspsprioritymail'}\";\n";
  $myset2 .=  "\$sc_uspsexpressmail = \"$in{'sc_uspsexpressmail'}\";\n";
  $myset2 .=  "\$sc_uspspriorityintern = \"$in{'sc_uspspriorityintern'}\";\n";
  $myset2 .=  "\$sc_uspsexpressintern = \"$in{'sc_uspsexpressintern'}\";\n";
  $myset2 .=  "\$sc_uspsglobexpmail = \"$in{'sc_uspsglobexpmail'}\";\n";
}


# build shipping method stuff for cut and paste box.
$sc_shiptomethod_4forms = "";

$sc_howmanycustomshippingmethods = $in{'sc_howmanycustomshippingmethods'};
my $howmanycustomshippingmethod_temp = "0";
my $myset3 = "\$sc_custom_shipping_methodname_string = \"";
my $myset4 = "\$sc_custom_shipping_methoddescrip_string = \"";
if ($sc_howmanycustomshippingmethods > 0) {
  while ($howmanycustomshippingmethod_temp < $sc_howmanycustomshippingmethods) {
    my $custom_shipping_methodname2 = "sc_custom_shipping_methodname" . "$howmanycustomshippingmethod_temp";
    my $custom_shipping_methoddescrip2 = "sc_custom_shipping_methoddescrip" . "$howmanycustomshippingmethod_temp";

    $myset3 .=  "$in{$custom_shipping_methodname2}|";
    $myset4 .=  "$in{$custom_shipping_methoddescrip2}|";
    if ($in{$custom_shipping_methodname2} ne "") {
      $sc_shiptomethod_4forms .= qq~\n<OPTION value="$in{$custom_shipping_methodname2}">
      $in{$custom_shipping_methoddescrip2}</option>~;
    }
    $howmanycustomshippingmethod_temp++
  }
  $myset3 .=  "\";\n";
  $myset4 .=  "\";\n";
  $myset2 .=  "$myset3";
  $myset2 .=  "$myset4";
}

if ($in{'sc_uspsparcelpost'} =~ /yes/i) {
  $sc_shiptomethod_4forms .= qq~\n<option value="USPS Parcel Post (Parcel)">
USPS Parcel Post (5-14 days)</option>~;
}
if ($in{'sc_uspsprioritymail'} =~ /yes/i) {
  $sc_shiptomethod_4forms .= qq~\n<option value="USPS Priority Mail (Priority)">
USPS Priority Mail (3-7 days)</option>~;
}
if ($in{'sc_uspsexpressmail'} =~ /yes/i) {
  $sc_shiptomethod_4forms .= qq~\n<option value="USPS Express Mail (Express)">
USPS Express Mail (1-3 days)</option>~;
}
if ($in{'sc_uspspriorityintern'} =~ /yes/i) {
  $sc_shiptomethod_4forms .= qq~\n<option value="USPS (Priority Mail International)">
Priority Mail International (6-10 days)</option>~;
}
if ($in{'sc_uspsexpressintern'} =~ /yes/i) {
  $sc_shiptomethod_4forms .= qq~\n<option value="USPS (Express Mail International)">
Express Mail International (3-5 days)</option>~;
}
if ($in{'sc_uspsglobexpmail'} =~ /yes/i) {
  $sc_shiptomethod_4forms .= qq~\n<option value="USPS (Global Express Guaranteed)">
Global Express Guaranteed (1-3 days)</option>~;
}

if ($in{'sc_upsgroundres'} =~ /yes/i) {
  $sc_shiptomethod_4forms .= qq~\n<OPTION value="UPS Ground Residential(GNDRES)">UPS Ground Residential</option>~;
}
if ($in{'sc_upsgroundcomm'} =~ /yes/i) {
  $sc_shiptomethod_4forms .= qq~\n<OPTION value="UPS Ground Commercial (GNDCOM)">UPS Ground Commercial</option>~;
}
if ($in{'sc_ups2da'} =~ /yes/i) {
  $sc_shiptomethod_4forms .= qq~\n<OPTION value="UPS 2nd Day (2DA)">UPS 2nd Day</option>~;
}
if ($in{'sc_ups1da'} =~ /yes/i) {
  $sc_shiptomethod_4forms .= qq~\n<OPTION value="UPS Next Day (1DA)">UPS Next Day</option>~;
}

  $myset .=  "\$sc_override_shipmethods_4forms = qq~$in{'sc_override_shipmethods_4forms'}~;\n";
  $myset .=  "\$sc_shiptostates_4forms = qq~$in{'sc_shiptostates_4forms'}~;\n";
  $myset .=  "\$sc_shiptocountries_4forms = qq~$in{'sc_shiptocountries_4forms'}~;\n";

if ($in{'sc_override_shipmethods_4forms'} eq 'No') {
  $myset .=  "\$sc_shiptomethod_4forms = qq~$in{'sc_shiptomethod_4forms'}~;\n";
} else {
  $myset .=  "\$sc_shiptomethod_4forms = qq~$sc_shiptomethod_4forms~;\n";
}

&update_store_settings('shipping',$myset); # main settings
$myset = "";
$myset2 .=  "\n1;\n";
&update_Shipadmin_settings("$sc_shipadminfile",$myset2);
&require_supporting_libraries(__FILE__,__LINE__,
  "$mgrdir/misc/ship_admin.pl");
&show_ship_settings_screen;
}
#############################################################################################
sub show_ship_settings_screen
{
print &$manager_page_header("Shipping Settings","","","","");

my $howmanycustomshippingmethod_temp = "0";

#set some defaults
if ($sc_debug_mode eq ""){
  $sc_debug_mode = "no";
 }

   $test_result = eval("use LWP::Simple; 1;");
   if ($@ eq "") {
#     use LWP::Simple;
    } else {
     $Lib_message="<FONT COLOR=RED><b>WARNING:</b> LWP library was " .
                  "not found!  Choose one of the other options.</FONT><BR>";
    }
#   $test_result = eval('require "./library/http-lib.pl"');
   if (!($http_lib_ok =~ /yes/i)) {
     $Lib_message .= "<FONT COLOR=RED>Couldn't load http-lib. " .   
                  "Choose one of the other options.</FONT><BR>";
    } 

if ($sc_path_of_images_directory ne "") {
 $URL_of_images_directory = $sc_path_of_images_directory;
}

if ($sc_ship_thingy_p_id_indicator_enabled eq "") {
 $sc_ship_thingy_p_id_indicator_enabled = "no";
}


if ($sc_ups_non_xml_adjust_rate eq '') {
    $sc_ups_non_xml_adjust_rate = "1.04";
}

if ($sc_ups_non_xml_adjust eq '') {
    $sc_ups_non_xml_adjust = "yes";
}

if ($sc_shiptostates_4forms eq '') {
    $sc_shiptostates_4forms = qq|
<option value="">---USA---</option>
<option>AK</option>
<option>AL</option> 
<option>AR</option>
<option>AZ</option> 
<option>CA</option> 
<option>CO</option> 
<option>CT</option> 
<option>DC</option>
<option>DE</option> 
<option>FL</option> 
<option>GA</option> 
<option>GU</option> 
<option>HI</option> 
<option>IA</option>
<option>ID</option> 
<option>IL</option> 
<option>IN</option> 
<option>KS</option> 
<option>KY</option> 
<option>LA</option> 
<option>MA</option> 
<option>MD</option>
<option>ME</option> 
<option>MI</option> 
<option>MN</option> 
<option>MO</option>
<option>MS</option> 
<option>MT</option> 
<option>NC</option> 
<option>ND</option> 
<option>NE</option> 
<option>NH</option> 
<option>NJ</option> 
<option>NM</option> 
<option>NV</option> 
<option>NY</option> 
<option>OH</option> 
<option>OK</option> 
<option>OR</option> 
<option>PA</option> 
<option>PR</option> 
<option>RI</option> 
<option>SC</option> 
<option>SD</option> 
<option>TN</option> 
<option>TX</option> 
<option>UT</option> 
<option>VA</option>
<option>VI</option> 
<option>VT</option> 
<option>WA</option> 
<option>WI</option>
<option>WV</option> 
<option>WY</option>
<option value=""></option>
<option value="">--AUSTRALIA--</option>
<option value="ACT">ACT</option>
<option value="NSW">NSW</option>
<option value="NT">NT</option>
<option value="QLD">QLD</option>
<option value="SA">SA</option>
<option value="TAS">TAS</option>
<option value="VIC">VIC</option>
<option value="WA">WA</option>
<option value=""></option>
<option value="">--CANADA--</option>
<option value="AB">AB</option>
<option value="BC">BC</option>
<option value="MB">MB</option>
<option value="NB">NB</option>
<option value="NFLD">NFLD</option>
<option value="NWT">NWT</option>
<option value="NS">NS</option>
<option value="ON">ON</option>
<option value="PEI">PEI</option>
<option value="PQ">PQ</option>
<option value="SK">SK</option>
<option value="YK">YK</option>
<option value="">--UK / England--</option>
<option value="Aberdeen City">Aberdeen City</option>
<option value="Aberdeenshire">Aberdeenshire</option>
<option value="Angus">Angus</option>
<option value="Argyll & Bute">Argyll & Bute</option>
<option value="Bath & North East Somerset">Bath & North East Somerset</option>
<option value="Bedfordshire">Bedfordshire</option>
<option value="Berkshire">Berkshire</option>
<option value="Blaenau Gwent">Blaenau Gwent</option>
<option value="Bridgend">Bridgend</option>
<option value="Bristol">Bristol</option>
<option value="Buckinghamshire">Buckinghamshire</option>
<option value="Caerphilly ">Caerphilly </option>
<option value="Cambridgeshire">Cambridgeshire</option>
<option value="Cardiff">Cardiff</option>
<option value="Carmarthenshire">Carmarthenshire</option>
<option value="Ceredidgion">Ceredidgion</option>
<option value="Cheshire">Cheshire</option>
<option value="ClackMannanshire">ClackMannanshire</option>
<option value="Conwy">Conwy</option>
<option value="Cornwall">Cornwall</option>
<option value="Cumbria">Cumbria</option>
<option value="Denbighshire">Denbighshire</option>
<option value="Derbyshire">Derbyshire</option>
<option value="Devon">Devon</option>
<option value="Dorset">Dorset</option>
<option value="Dumfries & Galloway">Dumfries & Galloway</option>
<option value="Dundee City">Dundee City</option>
<option value="Durham">Durham</option>
<option value="East Ayrshire">East Ayrshire</option>
<option value="East Dunbartonshire">East Dunbartonshire</option>
<option value="East Lothian">East Lothian</option>
<option value="East Renfrewshire">East Renfrewshire</option>
<option value="East Riding of Yorkshire">East Riding of Yorkshire</option>
<option value="East Sussex">East Sussex</option>
<option value="Edinburgh">Edinburgh</option>
<option value="Essex">Essex</option>
<option value="Falkirk">Falkirk</option>
<option value="Fife">Fife</option>
<option value="Flintshire">Flintshire</option>
<option value="Glasgow">Glasgow</option>
<option value="Gloucestershire">Gloucestershire</option>
<option value="Greater Manchester">Greater Manchester</option>
<option value="Gwynedd">Gwynedd</option>
<option value="Hampshire">Hampshire</option>
<option value="Herefordshire">Herefordshire</option>
<option value="Hertfordshire">Hertfordshire</option>
<option value="Highlands">Highlands</option>
<option value="Inverclyde">Inverclyde</option>
<option value="Isle of Anglesey">Isle of Anglesey</option>
<option value="Kent">Kent</option>
<option value="Lancashire">Lancashire</option>
<option value="Leicestershire">Leicestershire</option>
<option value="Lincolnshire">Lincolnshire</option>
<option value="London">London</option>
<option value="Merseyside">Merseyside</option>
<option value="Merthyr Tydfil">Merthyr Tydfil</option>
<option value="Midlothian">Midlothian</option>
<option value="Monmouthshire">Monmouthshire</option>
<option value="Moray">Moray</option>
<option value="Neath Port Talbot">Neath Port Talbot</option>
<option value="Newport">Newport</option>
<option value="Norfolk">Norfolk</option>
<option value="North Ayrshire">North Ayrshire</option>
<option value="North Lanarkshire">North Lanarkshire</option>
<option value="North Somerset">North Somerset</option>
<option value="North Yorkshire">North Yorkshire</option>
<option value="Northamptonshire">Northamptonshire</option>
<option value="Northumberland">Northumberland</option>
<option value="Nottinghamshire">Nottinghamshire</option>
<option value="Orkney">Orkney</option>
<option value="Oxfordshire">Oxfordshire</option>
<option value="Pembrokeshire">Pembrokeshire</option>
<option value="Perth & Kinross">Perth & Kinross</option>
<option value="Powys">Powys</option>
<option value="Renfrewshire">Renfrewshire</option>
<option value="Rhondda Cynon Taff">Rhondda Cynon Taff</option>
<option value="Rutland">Rutland</option>
<option value="Scottish Borders">Scottish Borders</option>
<option value="Shetland">Shetland</option>
<option value="Shropshire">Shropshire</option>
<option value="Somerset">Somerset</option>
<option value="South Lanarkshire">South Lanarkshire</option>
<option value="South Yorkshire">South Yorkshire</option>
<option value="Staffordshire">Staffordshire</option>
<option value="Stirling">Stirling</option>
<option value="Suffolk">Suffolk</option>
<option value="Surrey">Surrey</option>
<option value="Swansea">Swansea</option>
<option value="Teesside">Teesside</option>
<option value="Torfaen">Torfaen</option>
<option value="Tyne & Wear">Tyne & Wear</option>
<option value="Vale of Glamorgan">Vale of Glamorgan</option>
<option value="Warwickshire">Warwickshire</option>
<option value="West Dunbartonshire">West Dunbartonshire</option>
<option value="West Lothian">West Lothian</option>
<option value="West Midlands">West Midlands</option>
<option value="West Sussex">West Sussex</option>
<option value="West Yorkshire">West Yorkshire</option>
<option value="Western Isles">Western Isles</option>
<option value="Wiltshire">Wiltshire</option>
<option value="Worcestershire">Worcestershire</option>
<option value="Wrexham">Wrexham</option>|;
}

if ($sc_shiptocountries_4forms eq '') {
    $sc_shiptocountries_4forms = qq|
<option>United States</option>
<option>Australia</option>
<option>Canada</option>
<option>Ireland</option>
<option>Puerto Rico</option>
<option>Scotland</option>
<option>United Kingdom</option>
<option>Wales</option>
<option></option>
<option>American Samoa</option>
<option>Argentina</option>
<option>Austria</option>
<option>Belgium</option>
<option>Belize</option>
<option>Brazil</option>
<option>Chile</option>
<option>Costa Rica</option>
<option>Denmark</option>
<option>Dominican Republic</option>
<option>Finland</option>
<option>France</option>
<option>Germany</option>
<option>Greece</option>
<option>Guatemala</option>
<option>Hong Kong</option>
<option>Israel</option>
<option>Italy</option>
<option>Jamaica</option>
<option>Japan</option>
<option>Mexico</option>
<option>Netherlands</option>
<option>New Zealand</option>
<option>Norway</option>
<option>Panama</option>
<option>Portugal</option>
<option>Spain</option>
<option>Sweden</option>
<option>Switzerland</option>
<option>Taiwan</option>
<option>Tonga</option>
<option>Virgin Islands (US)</option>|;
}

if ($sc_shiptomethod_4forms eq '') {
    $sc_shiptomethod_4forms = qq|
<select name=Ecom_ShipTo_Method>
<option value="\$vform_Ecom_ShipTo_Method">\$vform_Ecom_ShipTo_Method2</option>
<option value="Local Delivery">
      Local Delivery</option>
<option value="Pickup">
      Pickup</option>
<option value="USPS Priority Mail (Priority)">
USPS Priority Mail (3-7 days)</option>
<option value="USPS (Priority Mail International)">
Priority Mail International (6-10 days)</option>
<option value="UPS Ground (GND)">UPS Ground (7-10 days)</option>
<option value="UPS Standard (STD)">UPS Standard to Canada Only (7-10 days)</option>
<option value="UPS 3 Day Select (3DS)">UPS 3 Day Select (3-4 days)</option>
<option value="UPS 2nd Day Air (2DA)">UPS 2nd Day Air</option>
</select>|;
}

&require_supporting_libraries(__FILE__,__LINE__,
  "$mgrdir/misc/ship_admin.pl");

print <<ENDOFTEXT;

<CENTER>
<TABLE cellspacing=0 border=0>
<tr>
<td><br/><hr></td>
</tr>
<tr>
<td bgcolor=#99CC99>
<FONT FACE=ARIAL>Welcome to the <b>AgoraCart</b> Shipping Manager / Library settings.</td>
</tr>
<tr>
<td><hr></td>
</tr>
</TABLE><br/>
</CENTER>

ENDOFTEXT

if ($in{'system_edit_success'} ne "") {
print <<ENDOFTEXT;
<br><CENTER>
<TABLE>
<tr>
<td><br>
<FONT FACE=ARIAL SIZE=2 COLOR=RED>System settings have been 
successfully updated. </FONT><br><br>
</td>
</tr>
</TABLE>
</CENTER>
ENDOFTEXT
}

&make_lists_of_various_options;

print <<ENDOFTEXT;

<FONT FACE=ARIAL SIZE=2>
<FORM METHOD="POST" ACTION="manager.cgi">
<CENTER>
<TABLE BORDER=0 CELLPADDING=1 CELLSPACING=0 BORDER=0>

<tr>
<td><b><b>In what loop</b> of calculate_final_values do you wish to calculate
the shipping?</b><br>If zero is selected, shipping will never be
calculated.<br>If 3 is selected, then the tax is based on the
pre-shipping subtotal.<br>if either 1 or 2 is selected, then
the tax is based on the subtotal of merchandise + shipping.
</td>

<td>
<select name="sc_calculate_shipping_loop">
<option>$sc_calculate_shipping_loop</option>
<option>0</option>
<option>1</option>
<option>2</option>
<option>3</option>
</select>
</td>
</tr>

<tr>
<td colspan=2><hr></td>
</tr>

<tr>
<td><b>Handling Charge to be added to all orders</b>.<br><small>No \$ Needed. Enter amount (2.75) or percentage of order (0.0635) you wish to add to orders.  Enter 0 if no handling charge is to be added to orders.</small></td>
<td>
<input name="sc_handling_charge" type="TEXT" SIZE=5 MAXLENGTH="5"
value="$sc_handling_charge">
</td>
</td>
</tr>

<tr>
<td colspan=2><br></td>
</tr>

<tr>
<td><b>Handling Charge Type:</b><br><small>Flat Rate is a single charge no matter the size of order (default).  Percentage will charge a percentage of the total order as a handling fee</small></td>
<td>
<select name=sc_handling_charge_type>
<option>$sc_handling_charge_type</option>
<option>Flat Rate</option> 
<option>Percentage</option> 
</select>
</td>
</td>
</tr>

<tr>
<td colspan=2><br></td>
</tr>

<tr>
<td><b>Add handling Charge if shipping total is Zero?</b></td>
<td>
<select name=sc_add_handling_cost_if_shipping_is_zero>
<option>$sc_add_handling_cost_if_shipping_is_zero</option>
<option>yes</option> 
<option>no</option> 
</select>
</td>
</td>
</tr>
<tr>
<td colspan=2><br></td>
</tr>
<tr>
<td colspan=2><hr></td>
</tr>
<tr>
<td colspan="2" bgcolor=#99CC99>
<b>Alternate Origins:</b>
</td>
</tr>
<tr>
<td colspan=2 ><hr/></td>
</tr>
<tr>
<td><br><b>Use Alternate Origins?</b>  Great for drop-shipped products and/or multiple shipping location shippers.  To use this, select a default origin for each shipping method default (UPS, USPS, etc), ususally where most of your products will ship from. Then in each individual product that ships from a different location, enter the origination zipcode/postal-code and an origination state/province for that particular product.  No limit to locations/origination points.<br><i>Limitations:</i> Must be from same country and use same shipping methods... or simular methods (cannot compute multiple shipping methods without some extensive custom programming).</td>
<td>
<select name=sc_alt_origin_enabled>
<option>$sc_alt_origin_enabled</option>
<option>yes</option> 
<option>no</option> 
</select>
</td>
</td>
</tr>

<tr>
<td colspan=2><br></td>
</tr>

<tr>
<td colspan=2><hr/></td>
</tr>

<tr>
<td colspan="2" bgcolor=#99CC99>
<b>Dimensional Shipping Measurements:</b>
</td>
</tr>
<tr>
<td colspan=2><hr/></td>
</tr>
<tr>
<td><br><b>Enable Dimensions in Product Database?</b>  This allows you to enter individual product dimensions for items that ship in their own box or separately from other items via a real-time shipping method (USPS). If unsure, leave blank. </td>
<td>
<select name=sc_dimensional_shipping_enabled>
<option>$sc_dimensional_shipping_enabled</option>
<option>yes</option> 
<option>no</option> 
</select>
</td>
</td>
</tr>

<tr>
<td colspan=2><br></td>
</tr>

<tr>
<td colspan=2><hr></td>
</tr>

<tr>
<td colspan="2" bgcolor=#99CC99>
<b>Custom Shipping Logic:</b>
</td>
</tr>
<tr>
<td colspan=2 ><hr/></td>
</tr>
<tr>
<td><br><b>Use the custom shipping logic?</b>  If yes, you may still use the
SBW module (perhaps some items are not appropriate for that 
module and you desire to handle these differently).&nbsp;  If Custom logic and SBW are 
both set to "no" then the "shipping" field in the database
is the shipping price of the individual items and added together for items in cart when customer checks out.</td>

<td>
<select name=sc_use_custom_shipping_logic>
<option>$sc_use_custom_shipping_logic</option>
<option>yes</option> 
<option>no</option> 
</select>
</td>
</tr>
<tr>
<td colspan=2 ><hr/></td>
</tr>
<tr>
<td><br><b>When to run custom shipping logic?</b>  Select when to run custom shipping logic.  If you need to alter shipping rates after real-time rates have been provided, the select AFTER. Select BEFORE for default operations.  If using AFTER, there is a special variable to use that stores the value of realtime shipping costs that you can use in your shipping logic called \$SBW_shipping_price which allows you to alter or delete the costs of real time rates as you desire.</td>

<td>
<select name=sc_location_custom_shipping_logic>
<option>$sc_location_custom_shipping_logic</option>
<option>before</option> 
<option>after</option> 
</select>
</td>
</tr>
<tr>

<td colspan=2><hr></td>
</tr>
<tr>
<td><b>If using Custom Logic, is shipping measured by weight?</b>  In other words, do you define total shipping price by total order weight within the custom shipping logic? If so, select yes</td>

<td>
<select name=sc_use_SBW2>
<option>$sc_use_SBW2</option>
<option>yes</option> 
<option>no</option> 
</select>
</td>
</tr>
<tr>
<td colspan=2><hr></td>
</tr>
<tr>
<td colspan="2">
<br> For examples of custom shipping logic, <a href="DOCS/shipping.txt" target="_new">Click Here</a><br>
<TEXTAREA name="sc_custom_shipping_logic" 
cols="110" rows=20 wrap=off>$sc_custom_shipping_logic</TEXTAREA><br><br>
</td>
</tr>

<tr>
<td colspan=2><br></td>
</tr>
<tr>
<td colspan=2><hr></td>
</tr>
<tr>
<td colspan="2" bgcolor=#99CC99>
<b>Custom Shipping Methods:</b>
</td>
</tr>
<tr>
<td colspan=2 ><hr/></td>
</tr>
<tr>
<td><br><b>How Many Custom Shipping Methods Do You Need?</b><br><small>These are shipping methods used on your order forms that are needed in addition to the Real Time shipping methods or as complete replacements.  Usually these custom methods are used in custom shipping logic for rating purposes.  Examples include: Local Delivery, Standard Delivery, Electronic Delivery, or any name you wish to use.  Select number needed, then save settings to display the number of fields you need.  The actual logic is created in the section above (see the example custom logic, and consult the user forums and the <a href="http://www.agoracart.com/agorawiki/index.php?title=The_AgoraCart_Project:User_Manual" target="_blank">wiki/documentation</a> for more help).  You will also need to place the output at the bottom of this page (only after pressing the submit button) in your order forms as it's not automatically inserted/changed in the checkout/order forms.</small></td>
<td>
<select name=sc_howmanycustomshippingmethods>
<option>$sc_howmanycustomshippingmethods</option>
<OPTION value="">None</option> 
<option>1</option>
<option>2</option>
<option>3</option>
<option>4</option>
<option>5</option>
<option>6</option>
<option>7</option>
<option>8</option>
<option>9</option>
<option>10</option>
<option>11</option>
<option>12</option>
<option>13</option>
<option>14</option>
<option>15</option>
<option>16</option>
<option>17</option>
<option>18</option>
<option>19</option>
<option>20</option>
<option>21</option>
<option>22</option>
<option>23</option>
<option>24</option>
<option>25</option>
<option>26</option>
<option>27</option>
<option>28</option>
<option>29</option>
<option>30</option>
<option>31</option>
<option>32</option>
<option>33</option>
<option>34</option>
<option>35</option>
<option>36</option>
<option>37</option>
<option>38</option>
<option>39</option>
<option>40</option>
</select>
</td>
</tr>
<tr>
<td colspan=2><br></td>
</tr>
<tr>
<td colspan=2> 
ENDOFTEXT


if ($sc_howmanycustomshippingmethods > 0) {
while ($howmanycustomshippingmethod_temp < $sc_howmanycustomshippingmethods) {
my ($custom_shipping_methodname2) = '';
($custom_shipping_methodname2,$sc_custom_shipping_methodname_string) = split(/\|/,$sc_custom_shipping_methodname_string,2);
($custom_shipping_methoddescrip2,$sc_custom_shipping_methoddescrip_string) = split(/\|/,$sc_custom_shipping_methoddescrip_string,2);
my $custom_shipping_methodname = "sc_custom_shipping_methodname" . "$howmanycustomshippingmethod_temp";
my $custom_shipping_methoddescrip = "sc_custom_shipping_methoddescrip" . "$howmanycustomshippingmethod_temp";

print <<ENDOFTEXT;
<small>Method Name: </small><input name="$custom_shipping_methodname" type="TEXT" SIZE=22 MAXLENGTH="35" value="$custom_shipping_methodname2">
&nbsp;&nbsp;<small>Name for Drop-down Lists: </small><input name="$custom_shipping_methoddescrip" type="TEXT" SIZE=22 MAXLENGTH="35" value="$custom_shipping_methoddescrip2"><br>
ENDOFTEXT
$howmanycustomshippingmethod_temp++;
}

} else {

print <<ENDOFTEXT;
</td>
</tr>
<tr>
<td colspan=2><small>No Custom Shipping Methods Available.  Please select the number needed above. If none needed, leave blank or at 0.<br></small></td>
</tr>
ENDOFTEXT

}

print <<ENDOFTEXT;
<tr>
<td colspan=2><br/><hr></td>
</tr>


<tr>
<td colspan=2 bgcolor=#99CC99>
<b>Real-Time SBW (Ship By Weight) Shipping Module Information:</b><BR>
</td>
</tr>
<tr>
<td colspan=2  bgcolor=#99CC99><hr></td>
</tr>
<tr>
<td><br><b>Use the Live/Real-Time SBW (Ship By Weight for UPS/USPS) module?</b>  If yes, then
the "shipping" field in the product database is a shipping weight (instead of 
shipping price.).</td>
<td>
<select name=sc_use_SBW>
<option>$sc_use_SBW</option>
<option>yes</option> 
<option>no</option> 
</select>
</td>
</tr>

<tr>
<td colspan=2><hr></td>
</tr>

<tr>
<td colspan=2><b>Allow Shipments via which services?</b><br/><small>(selecting yes or no on a shipping method does not change shipping options on order forms)</small><br><br>
&nbsp;&nbsp;
USPS:<select name=sc_use_USPS>
<option>$sc_use_USPS</option>
<option>no</option>
<option>yes</option> 
</select>
&nbsp;&nbsp;&nbsp;&nbsp;
ENDOFTEXT

  print "UPS (non-XML):<select name=sc_use_UPS>
  <option>$sc_use_UPS</option>
  <option>no</option>
  <option>yes</option>
  </select>";

print <<ENDOFTEXT;
</td>
</tr><tr><td colspan=2><hr></td></tr>

<tr>
<td colspan=2><b>Max weight per box</b> (lbs.)  If zero is entered, each item 
customer selects is shipped it its own box. Max Weight per box is 150 lbs for UPS and 70 lbs for USPS<br><br>
&nbsp;&nbsp;UPS: <input name="sc_UPS_max_wt" type="TEXT" SIZE=3 MAXLENGTH="3" value="$sc_UPS_max_wt">
&nbsp;&nbsp;&nbsp;&nbsp;USPS: <input name="sc_USPS_max_wt" type="TEXT" SIZE=3 MAXLENGTH="3"
value="$sc_USPS_max_wt">
ENDOFTEXT

print <<ENDOFTEXT;
</td>
</tr>

<tr>
<td><br><b>Display Product ID number in recommended box packing order?</b><br>
When a customer orders enough product to warrant additional boxes over the maximum weight per box as set above, you can display the product database ID number in front of the product name of each product listed per each recommended box pack order (which is very guesstimate in nature).
</td>

<td>
<select name="sc_ship_thingy_p_id_indicator_enabled">
<option>$sc_ship_thingy_p_id_indicator_enabled</option>
<option>yes</option>
<option>no</option>
</select>
</td>
</tr>
<tr>
<td colspan=2><hr></td>
</tr>
<tr> <td> $Lib_message How do you wish to connect to UPS (non-XML) / USPS XML?  The LWP library should be
present and is the default option. If not, then the http-lib has been included here as a backup.  Note: If on a vdeck control panel based server, do not select the "http-lib" option.<br>
</td>
<td> 
 <select name=sc_use_socket>
 <option>$sc_use_socket</option> 
 <option>LWP</option>
 <option>http-lib</option> 
 </select></td> 
</tr>
ENDOFTEXT

if (($sc_use_USPS =~ /yes/i)||($sc_use_USPS eq '')) {
print <<ENDOFTEXT;
<tr>
<td colspan=2><br/><hr></td>
</tr>
<tr>
<td colspan=2 bgcolor=#99CC99>
<b>USPS - United States Postal Service</b>
</td>
</tr>
<tr>
<td colspan=2 ><hr/></td>
</tr>
<tr>
<td colspan=2><br>
<small>note: using the USPS interface requires that you be registered and 
ACCEPT the license agreement.<br>You must also call or email USPS customer support in order to get your account switched to the production server.  This software has already been tested, so you do not need to perform testing in most cases. See the USPS site for more information.  All USPS real-time shipping methods require USPS in the name of the method.<br><br>
the production URL is currently:  http://production.shippingapis.com/ShippingAPI.dll</small><br><br>
USPS API URL: <input name="sc_USPS_host_URL" type="TEXT" SIZE=60
MAXLENGTH="75" value="$sc_USPS_host_URL"><br>
USPS API Userid: <input name="sc_USPS_userid" type="TEXT" SIZE=14
MAXLENGTH="25" value="$sc_USPS_userid">
<!--&nbsp;&nbsp;&nbsp;&nbsp;
USPS API Password: <input name="sc_USPS_password" type="TEXT" SIZE=14
MAXLENGTH="25" value="$sc_USPS_password">--><br>
USPS ORIGIN ZIP: <input name="sc_USPS_Origin_ZIP" type="TEXT" SIZE=5
MAXLENGTH="5" value="$sc_USPS_Origin_ZIP"><br><br>
Do you offer USPS Parcel Post: <select name="sc_uspsparcelpost">
<option>$sc_uspsparcelpost</option>
<option>yes</option>
<option>no</option>
</select><br/>
Do you offer USPS Priority Mail: <select name="sc_uspsprioritymail">
<option>$sc_uspsprioritymail</option>
<option>yes</option>
<option>no</option>
</select><br/>
Do you offer USPS Express Mail: <select name="sc_uspsexpressmail">
<option>$sc_uspsexpressmail</option>
<option>yes</option>
<option>no</option>
</select><br/><br/>
<b>International (Outside of US & PR) Shipping Options:</b><br/>
Do you offer USPS <option value="USPS (Priority Mail International)">
Priority Mail International 6-10 days: <select name="sc_uspspriorityintern">
<option>$sc_uspspriorityintern</option>
<option>yes</option>
<option>no</option>
</select><br/>
Do you offer USPS <option value="USPS (Express Mail International)">
Priority Mail International 3-5 days: <select name="sc_uspsexpressintern">
<option>$sc_uspsexpressintern</option>
<option>yes</option>
<option>no</option>
</select><br/>
Do you offer USPS <option value="USPS (Global Express Guaranteed)">
Global Express Guaranteed 1-3 days: <select name="sc_uspsglobexpmail">
<option>$sc_uspsglobexpmail</option>
<option>yes</option>
<option>no</option>
</select><br/>
</td>
</tr>
ENDOFTEXT
}

if (($sc_use_UPS =~ /yes/i)||($sc_use_UPS eq '')) {
print <<ENDOFTEXT;
<tr>
<td colspan=2><br/><hr></td>
</tr>
<tr>
<td colspan=2 bgcolor=#99CC99>
<b>UPS - United Parcel Service</b>
</td>
</tr>
<tr>
<td colspan=2 ><hr/></td>
</tr>
<tr>
<td colspan=2>
<br>
ENDOFTEXT

print <<ENDOFTEXT;
<b>Note:</b> <small>this UPS module is not the most accurate version and should be used for approximations only.  please use the "members only" UPS XML version for more accurate rating services.</small><br><br>

UPS ORIGIN ZIP: <input name="sc_UPS_Origin_ZIP" type="TEXT" SIZE=5 MAXLENGTH="5"
value="$sc_UPS_Origin_ZIP"><br>
UPS Pickup Type: <select name="sc_UPS_RateChart">
   <OPTION value="$sc_UPS_RateChart">$sc_UPS_RateChart</option>
   <OPTION value="Regular Daily Pickup">Regular Daily Pickup
   <OPTION value="On Call Air">On Call Air
   <OPTION value="One Time Pickup">One Time Pickup
   <OPTION value="Letter Center">Letter Center
   <OPTION value="Customer Counter">Customer Counter
</select><br><br>

<br><b>Select Shipping Methods that you offer:</b><br>

UPS Ground Residential: <select name=sc_upsgroundres>
<option>$sc_upsgroundres</option>
<option>yes</option>
<option>no</option>
</select><br>

UPS Ground Commercial: <select name=sc_upsgroundcomm>
<option>$sc_upsgroundcomm</option>
<option>yes</option>
<option>no</option>
</select><br>

UPS 2nd Day: <select name=sc_ups2da>
<option>$sc_ups2da</option>
<option>yes</option>
<option>no</option>
</select><br>

UPS Next Day: <select name=sc_ups1da>
<option>$sc_ups1da</option>
<option>yes</option>
<option>no</option>
</select><br>
<br><hr><br>

Adjust UPS rates up or down from the quote?<br><small>will use percentage entered below to adjust the rate of shipping up or down.  Enable if the rates differ from what you actually pay for the shipment charges. Default is yes.</small> <select name=sc_ups_non_xml_adjust>
<option>$sc_ups_non_xml_adjust</option>
<option>yes</option>
<option>no</option>
</select>
Enter Percentage to adjust by:<br><small>Will be a percentage of the shipping cost.  Can be negative to deduct from the shippign cost. Max of 7 characters can be entered.</small><br> <input name="sc_ups_non_xml_adjust_rate" type="TEXT" SIZE=7 MAXLENGTH="7"
value="$sc_ups_non_xml_adjust_rate"><br><br>
ENDOFTEXT
}

print <<ENDOFTEXT;
</td>
</tr>
<tr>
<td colspan=2><br><hr/></td>
</tr>
<tr>
<td colspan=2 bgcolor=#99CC99>
<b>Ship To: State/Province and Country Lists for Order Froms</b>
</td>
</tr>
<tr>
<td colspan=2><hr/></td>
</tr>
<tr>
<td><br/>
<b>States/Provinces:</b><br/>
Below are the states/provinces you allow shipments to, for use within your order forms.<br><br><b>NOTE:</b>  New order forms will use this output. If your order form does not automatically reflect any changes, your orderforms are older and you must <b>Cut and paste</b> the code below and place it into your order forms manually for the gateways you wish to use:<br>
<textarea 
name="sc_shiptostates_4forms" 
cols="55" rows="15" 
wrap="soft">$sc_shiptostates_4forms</textarea>
</td>
<td><br/>
<b>Countries:</b><br/>
Below are the countries you allow shipment to, for use in your order forms. <br><br><b>NOTE:</b>  New order forms will use this output. If your order form does not automatically reflect any changes, your orderforms are older and you must <b>Cut and paste</b> the code below and place it into your order forms manually for the gateways you wish to use:<br>
<textarea 
name="sc_shiptocountries_4forms" 
cols="55" rows="15" 
wrap="soft">$sc_shiptocountries_4forms</textarea>
</td>
</tr>
<tr>
<td colspan=2><br><hr/></td>
</tr>
<tr>
<td colspan=2 bgcolor=#99CC99>
<b>Shipping Methods Pre-Built for Order Froms</b>
</td>
</tr>
<tr>
<td colspan=2><hr/></td>
</tr>
<tr>
<td colspan=2><br/>
Below are the shipping options built for use within your order forms. If nothing you have selected above, shipping methods wise, appears to be updated, please hit the submit button when ready and the code will be re-compiled from the realtime and custom options selected above.<br><br><b>NOTE:</b>  New order forms will use this output. If your order form does not automatically reflect any changes, your orderforms are older and you must <b>Cut and paste</b> the code below and place it into your order forms manually for the gateways you wish to use:<br>
<textarea 
name="sc_shiptomethod_4forms" 
cols="90" rows="20" 
wrap="soft">$sc_shiptomethod_4forms</textarea>
</td>
</tr>

<tr>
<td colspan=2><hr></td>
</tr>

<tr>
<td colspan=2>
<CENTER>
<input type="HIDDEN" name="system_edit_success" value="yes">
<input name="ChangeShipSettings" type="SUBMIT" value="Submit">
&nbsp;&nbsp;
<input type="RESET" value="Reset">
</CENTER>
</td>
</tr>

<tr>
<td colspan=2>
<hr>
</td>
</tr>

</TABLE>

</CENTER>
</FORM>
ENDOFTEXT

print &$manager_page_footer;
}
#######################################################################################
sub update_Shipadmin_settings {
  local($item,$stuff) = @_;
  $shipadmin_file_settings{$item} = $stuff;
local($shipadmin_settings) = "$mgrdir/misc/ship_admin.pl";
  local($item,$zitem);

  &get_file_lock("$shipadmin_settings.lockfile");
  open(SHIPADMINFILE,">$shipadmin_settings") || &my_die("Can't Open $shipadmin_settings");
  foreach $zitem (sort(keys %shipadmin_file_settings)) {
    $item = $zitem;
     print (SHIPADMINFILE $shipadmin_file_settings{$zitem});
   }
  close(SHIPADMINFILE);
  &release_file_lock("$shipadmin_settings.lockfile");
&require_supporting_libraries(__FILE__,__LINE__,
  "$mgrdir/misc/ship_admin.pl");
 }
#######################################################################################
1; #Library
