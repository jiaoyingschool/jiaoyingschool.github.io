######################################################################################
# This file contains the HTML for the store admin screens
######################################################################################
$versions{'store_admin_html.pl'} = "5.2.006";
&require_supporting_libraries(__FILE__,__LINE__,
  "$mgrdir/misc/mgr_miscmain.pl");
if ($mc_max_top_menu_items eq '') { 
  $mc_max_top_menu_items = 6;
 }
#&add_item_to_manager_menu("View New Orders","order_log=yes","");
&add_item_to_manager_menu("Error Log","error_log=yes","");
if ($mgr_shall_i_log_accesses =~ /yes/i) {
  &add_item_to_manager_menu("Tracking","tracking_screen=yes","");
}
if ($commando_ok =~ /yes/i) {
$commando_ok = "yes";
  &add_item_to_manager_menu("Commando","commando=yes","");
 }
###############################################################################
sub add_item_to_manager_menu 
{
  local ($display_name,$action,$sort_name) = @_;
  local ($continue) = "";
  if ($sort_name eq '') {$sort_name = $display_name;}
  &codehook("add-item-to-manager-menu");
  if ($continue eq "no") { return;}
  $sort_name =~ tr/a-z/A-Z/;
  $top_menu{$sort_name} = $action;
  $top_menu_name{$sort_name} = $display_name;
}
#########################################################################
sub make_lists_of_various_options{
local (@glist,@dblibs,@zlist,$item,$item_lc);
opendir (USER_LIBS, "./library");
@dblibs = sort(grep(/_db_lib\.pl\b/i,readdir(USER_LIBS)));
closedir (USER_LIBS);
$mylist_of_database_libs="";
foreach $item (@dblibs) {
  if ($item eq $sc_database_lib) {
    $mylist_of_database_libs .= "<OPTION SELECTED>$item</OPTION>\n";
   } else {
    $mylist_of_database_libs .= "<OPTION>$item</OPTION>\n";
   }
 }

$mylist_of_gateway_options = "";
@glist = split(/\|/,$mc_gateways);
foreach $item (@glist) {
  if ($item ne "") {
    $item_lc = $item;
    $item_lc =~ tr/A-Z/a-z/;
    if ($item ne $sc_gateway_name) {
      $zlist{$item_lc} = "<OPTION>$item</OPTION>\n";
     } else {
      $zlist{$item_lc} = "<OPTION SELECTED>$item</OPTION>\n";
     } 
   } 
 }
foreach $item (sort(keys %zlist)) {
  $mylist_of_gateway_options .= $zlist{$item};
 }
}
#########################################################################
sub parse_image_string{
 local ($str) = @_;
 local ($image,$junk);
 ($junk,$image) = split(/\<IMG SRC=\"/i,$str,2);# keep part up to the "
 ($image,$junk) = split(/\"/,$image,2);# discard " and anything after
# >
 $image =~ s/.*%%URLofImages%%\///g;
 $image =~ s/.*Html\/Images\///g;
 $image =~ s/.*html\/Images\///g;
 $image =~ s/.*html\/images\///g;
 $image =~ s/.png.*/.png/g;
 $image =~ s/.gif.*/.gif/g;
 $image =~ s/.jpg.*/.jpg/g;
 return $image;
}
#########################################################################
sub create_image_string{
 local ($str) = @_;
 local ($image,$junk);
 $image = $sc_image_string_template;
 $image =~ s/%%image%%/$str/ig;
 return $image;
}
#########################################################################
sub PageHeader {
print <<ENDOFTEXT;
<HTML>
<BODY BGCOLOR=WHITE>
<CENTER>
<TABLE WIDTH=500>
<TR WIDTH=500>
<TD WIDTH=125>
<B>Ref. #</B>
</TD>
<TD WIDTH=125>
<B>Category</B>
</TD>
<TD WIDTH=125>
<B>Description</B>
</TD>
<TD WIDTH=125>
<B>Price</B>
</TD>
</TR>
ENDOFTEXT
}
#######################################################################################
sub PageFooter
{
print <<ENDOFTEXT;
</TABLE>
</CENTER>
ENDOFTEXT
print &$manager_page_footer;
}
#######################################################################################
sub display_login
{
  opendir (USER_LOGINS, "$ip_file_dir"); 
  @myfiles = grep(/\.login/,readdir(USER_LOGINS)); 
  closedir (USER_LOGINS);
  foreach $zfile (@myfiles){
    $my_path = "$ip_file_dir/$zfile";
    if (-M "$my_path" > 0.1) {
      $my_path =~ /([^\xFF]*)/;
      $my_path = $1;
      unlink("$my_path");
     }
   }
print <<ENDOFTEXT;
<HTML>
<HEAD>
<TITLE>Build an online store with AgoraCart</TITLE>
<META NAME="description" CONTENT="FREE shopping cart software - AgoraCart"> 
<META NAME="keywords" CONTENT="free, shopping cart, e-commerce, software, perl, 
database, easy, secure, store, dynamic, web based, c, c++, javascript, html">
</HEAD>
<BODY BGCOLOR="WHITE">
<CENTER>
$manager_banner
</CENTER>
<FORM METHOD=POST ACTION=manager.cgi>
<CENTER>
<TABLE WIDTH=500 BORDER=0 CELLPADDING=2>
<TR>
<TD COLSPAN=2>
<HR WIDTH=550>
</TD>
</TR>

ENDOFTEXT

if (! -e "$mgrdir/.htaccess")
{
print <<ENDOFTEXT;

<TR>
<TD COLSPAN=2>
<FONT FACE=ARIAL>
<STRONG>
<blink><FONT COLOR="#FF0000">WARNING</FONT></blink> No .htaccess file found
in the /$mgrdirname directory. &nbsp;
YOU STILL NEED TO PASSWORD PROTECT THAT DIRECTORY<BR>
</STRONG>
</FONT>
</TD>
</TR>

ENDOFTEXT
}

print <<ENDOFTEXT;

<TR>
<TD COLSPAN=2><P>&nbsp;</P></TD>
</TR>

<TR>
<TD COLSPAN=2>Username:&nbsp;<INPUT TYPE=text NAME=username></TD>
</TR>
<TR>
<TD COLSPAN=2>Password:&nbsp;<INPUT TYPE=password NAME=password></TD>
</TR>

<TR>
<TD><br>Note:  you must have atleast two periods (.) in the URL you are using to access this manager area.  For example, if you are using: www.yourname.com/store/protected/manager.cgi, then you are okay.  If using something like: yourname.com/store/protected/manager.cgi (notice no preceeding www.), you will have login problems.<br><br></TD>
</TR>

<TR>
<TD COLSPAN=2>
<CENTER>
<INPUT TYPE=HIDDEN NAME="login" VALUE="yes">
<INPUT TYPE=HIDDEN NAME="welcome_screen" VALUE="yes">
<INPUT TYPE=submit VALUE=submit>&nbsp;<INPUT TYPE=reset VALUE=reset>
</CENTER>
</TD>
</TR>

</TABLE>
</CENTER>
</FORM>

<HR WIDTH=550>

<P>&nbsp;</P>

<CENTER>
<TABLE BORDER=0 CELLPADDING=0 CELLSPACING=0 WIDTH="550">
<TR>
<TD>
<IMG SRC="manager.cgi?picserve=front_footer.gif" BORDER=0>
</TD>
</TR>
</TABLE>
</CENTER>
ENDOFTEXT
print &$manager_page_footer;
}
################################################################################
sub std_manager_footer_code {
local ($text);
$text = <<ENDOFTEXT;
<center>
<small>Copyright 1999 to Present K-Factor Technologies Inc. at <a href="http://www.agoracart.com">AgoraCart.com</a> & 
<a href="http://www.k-factor.net">K-Factor.net</a></small>
</center>
ENDOFTEXT
&codehook("manager_footer_code");
$text .= "\n</BODY>\n</HTML>\n";
return $text;
}
################################################################################
sub std_manager_header_code {
  local ($ztitle,$header_code,$body_tag,$messages,$err_msgs) = @_;
  local ($my_header);
  local ($errs) = &html_eval_settings;
  $title = "AgoraCart Manager";
  if ($ztitle ne "") {
    $title .= " - " . $ztitle;
  }
  if ($body_tag eq "") {
    $body_tag = $mc_standard_body_tag;
  }
my $imageURLthingy = "images";
my $temp_store_url_checker = "${sc_domain_name_for_cookie}";
if ((($sc_self_serve_images =~ /no/i) && (($temp_store_url_checker =~ /cgi/i) && ($temp_store_url_checker =~ /bin/i))) || ($sc_self_serve_images =~ /yes/i) || (($sc_self_serve_images =~ /no/i) && (($sc_store_url =~ /cgi/i) && ($sc_store_url =~ /bin/i)))) {
  $imageURLthingy = "manager.cgi?picserve=";
} 

  $my_header =  <<ENDOFTEXT;
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd" />
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
    <title>$title</title>
$header_code
<style>
body{
  font-family: Arial, Bitstream Vera Sans, Helvetica, sans-serif;
  margin: 0px;
  padding: 0px;
}
.top_banner{
  text-align: center;
  vertical-align : middle;
}
/*~~~ Folder Tabs Along the Top ~~~*/
table.folders{
  padding-left:5px;
}
tr.folder_tabs{
  font-size: 10px;
  color: #ffcc00;
  background-image : url($imageURLthingy/agora-cart-button-bg.jpg);
  height: 28px;
  text-align:center;
}
td.first{
  padding-left:10px;
}

/* ~~~ Top Links just below the folder tabs ~~~ */
.top_links{
  font-size: 10px;
  font-weight: normal;
  color: #ffcc00; 
  background-color: #257B29;
  padding: 0px 0px 2px 25px;
  height: 30px;
  text-align: center;
}
/* ~~~ Left Menu Links ~~~ */
.left_menu{
  background-color: #257B29;
  font-size: 10px;
  width: 3px;
  color: #FFCC00;
  padding: 10px 0px 20px 10px;
  vertical-align : top;
}
.lm_first{
  font-size: 11px;
  padding-left: 2px;
  margin: 10px 0px 0px 0px;
  font-weight: bold;
}
/* ~~~ Main Body parts ~~~ */
img{
  border: 0px;
}
img.border{
  border: 1px;
}
.main_body{
  vertical-align : top;
  padding: 10px 10px 10px 10px;
  font-size: 9pt;
  text-align : justify;
}
.main_text{
  padding: 20px 10px 5px 10px;
  text-align: justify;
  vertical-align : top;
}
.main_text2{
  padding: 6px 6px 6px 6px;
  font-size: 10pt;
  vertical-align : top;
}
.main_set_text{
  font-size: 10pt;
  margin:0px 0px 0px 0px;
  padding:0px 0px 0px 0px;
  width: 226px;
}
h1{
  color: #257B29;
  font-family: Arial, Bitstream Vera Sans, Helvetica, sans-serif;
  text-align: center;
  font-size: 28px;
}
h2{
  font-size: 20px;
  font-family: Arial, Bitstream Vera Sans, Helvetica, sans-serif;
  color: #257B29;
  font-weight: bold;
  text-align: center;
  margin: 10px 0px 2px 0px;
  padding: 0px 0px 0px 0px;
}
h3{
  color:#257b29;
   font-size: 13px;
   text-align: center;
   margin: 0px 0px 0px 0px;
}
h4{
  color:#000000;
  margin: 10px 0px 0px 0px;
}

.center_links{
  color: #257B29;
  text-align: center;
  font-weight : bold;
  margin: 5px 0px 10px 0px;
}
.notes{
  font-size: 8pt;
  font-family: Arial, Bitstream Vera Sans, Helvetica, sans-serif;
  font-style : italic;
  margin: 0px 0px 0px 0px;
  padding: 2px 0px 10px 0px;
  font-weight : normal;
}
.news{
  overflow: auto;
  background-color: #99cc99;
  vertical-align : top;
  padding: 0px 5px 5px 5px;
  text-align : left;
}

/* ~~~ Hyper Links ~~~ */
a.buttons:link {
  text-decoration: none; 
  font-size: 11px;
  font-weight: normal; 
  color: #FFCC00;
}
a.buttons:visited {
  text-decoration: none; 
  font-size: 11px;
  color: #FFCC00;
}
a.buttons:active  {
  text-decoration: none; 
  font-size: 11px;
  color: #FFCC00;
}
a.buttons:hover {
  text-decoration: none; 
  font-size: 11px;
  color: #257B29; 
  background-color: #FED700;
}

a.centbuttons:link {
  text-decoration: none; 
  font-size: 11px;
  font-weight: normal; 
  color: #FFCC00;
}
a.centbuttons:visited {
  text-decoration: none; 
  font-size: 11px;
  color: #FFCC00;
}
a.centbuttons:active  {
  text-decoration: none; 
  font-size: 11px;
  color: #FFCC00;
}
a.centbuttons:hover {
  text-decoration: none; 
  font-size: 11px;
  color: #257B29; 
  background-color: #FED700;
}

a.center_links{
  text-decoration: underline;
  font-weight: bold;
}
a.links{
  text-decoration: underline;
  font-weight: normal;
}
a.links:link,.a.center_links:link {
  color: #257B29;
}
a.links:visited, a.center_links:visited {
  color: #993300;
}
a.links:active,a.center_links:active {
  color: #257B29;
}
a.links:hover, a.center_links:hover {
  color: #CC9900;
}
/* ~~~ Template Credit ~~~ */
.design_by{
  text-align:center;
  padding: 10px 0px 20px 0px;
}
/* ~~~ Copyright ~~~ */
.copyright{
  font-family: Arial, Bitstream Vera Sans, Helvetica, sans-serif;
  font-size:8pt;
  color:#FFCC00;
  background-color: #257B29;
  text-align:center;
  padding: 5px 0px 5px 120px;
}
/* ~~~ Text Alignment ~~~ */
.center{
  text-align: center;
  margin: 10px 0px 0px 0px;
}
/* ~~~ Manager Items ~~~ */
.manager_menu{
  font-size: 10pt;
  font-family: Arial, Bitstream Vera Sans, Helvetica, sans-serif;
  text-align: center;
}
.manager_menu a:visited{
  color: purple;
}
.manager_menu a:hover{
  color: red;
}

</style>
</head>
<body $body_tag>
<table width="100%" border="0" cellspacing="0" cellpadding="0" >
  <tr>
    <td>
			<table width="100%" border="0" cellspacing="0" cellpadding="0" background="$imageURLthingy/background.gif">
				<tr>
					<td width="534"><img src="$imageURLthingy/header.gif" width="534" height="72" border="0"></td>
					<td align=right background="$imageURLthingy/background.gif"/><div valign=top align=right><img src="$imageURLthingy/Agora-logo-white2.gif" width="286" height="55" border="0" alt="The Official Website of AgoraCart and Agora.cgi"><img src="$imageURLthingy/blank.gif" width="50" height="1" border="0"> </div>
						</td></tr></table>

    </td>
  </tr>
  <tr>
    <td>
      <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr class="folder_tabs">
           <td class="first"><a href="$sc_store_url" class="buttons" target="_blank">View Your Store</a></td>
          <td width="33"><img src="$imageURLthingy/agora-cart-button.jpg" width="33" height="28"></td>
          <td><a href="manager.cgi?change_settings_screen=yes" class="buttons">Your Store Settings/Managers</a></td>
          <td width="33"><img src="$imageURLthingy/agora-cart-button.jpg" width="33" height="28"></td>
          <td><a href="manager.cgi?order_management_settings_screen=yes" class="buttons">Order Management</a></td>
          <td width="33"><img src="$imageURLthingy/agora-cart-button.jpg" width="33" height="28"></td>
          <td><a href="manager.cgi?content_management_settings_screen=yes" class="buttons">CMS - Content Management</a></td>
          <td width="33"><img src="$imageURLthingy/agora-cart-button.jpg" width="33" height="28"></td>
          <td><a href="http://www.AgoraCart.com/agorawiki/" class="buttons" target="_blank">User Manuals & Wiki</a></td>  
          <td width="33"><img src="$imageURLthingy/agora-cart-button.jpg" width="33" height="28"></td> 
          <td><a href="http://www.agoraguide.com/faq/" class="buttons" target="_blank">Free User Forums</a> </td>
          <td width="33"><img src="$imageURLthingy/agora-cart-button.jpg" width="33" height="28"></td><td><a href="http://www.AgoraCart.com/proforum.htm" class="buttons" target="_blank">Upgrade to Gold Version</a></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td bgcolor="#FFCC00" width="100%" height="1"><img src="$imageURLthingy/blank.gif" height="1" width="1px" /></td>
  </tr>
  <tr>
    <td>
      <table width="100%" class="top_links" border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td>
            <a class="centbuttons" href="manager.cgi?add_screen=yes">Product Add</a> &nbsp; |  &nbsp;
            <a class="centbuttons" href="manager.cgi?edit_screen=yes">Product Edit</a> &nbsp; | &nbsp;
            <a class="centbuttons" href="manager.cgi?delete_screen=yes">Product Delete</a> &nbsp;&nbsp; | &nbsp;&nbsp;
            <a class="centbuttons" href="manager.cgi?order_log=yes">View New Orders</a> &nbsp;&nbsp; | &nbsp;&nbsp;
            <a class="centbuttons" href="manager.cgi?login_screen=yes">Store Manager Home</a> &nbsp; | &nbsp;
            <a class="centbuttons" href="manager.cgi?log_out=yes">Log Out</a>
          </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td>
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td class="left_menu" height="100%"><img src="$imageURLthingy/blank.gif" height="1" width="1px" /></td>
          <td class="main_body">
        <table width="100%" cellpadding=0 cellspacing=0 border=0>
        <tr>
          <td width=100% class="main_text">

$manager_banner
$manager_menu
$errs
$messages

ENDOFTEXT

  return $my_header;
}
#######################################################################################
sub welcome_screen {
 &$manager_welcome_screen;
 }
#######################################################################################
sub std_welcome_screen {
print &$manager_page_header("Welcome!","","","","");
my $imageURLthingy = "images";
my $temp_store_url_checker = "${sc_domain_name_for_cookie}";
if ((($sc_self_serve_images =~ /no/i) && (($temp_store_url_checker =~ /cgi/i) && ($temp_store_url_checker =~ /bin/i))) || ($sc_self_serve_images =~ /yes/i) || (($sc_self_serve_images =~ /no/i) && (($sc_store_url =~ /cgi/i) && ($sc_store_url =~ /bin/i)))) {
  $imageURLthingy = "manager.cgi?picserve=";
}

use LWP::Simple;
my $imagemasterlist = get("http://www.agoracart.com/downloadupdates/imagelist.txt");
if ($imagemasterlist ne '') {
my @line = split(/\n/, $imagemasterlist);
foreach $imageline (@line) {
 my ($imagename) = split(/\|/, $imageline);
 chomp $imagename;
 $imagename =~ /([\w\-\/]+)\.(\w+)/;
 $imagename = "$1.$2";
   if (!(-e "./$mgrdir/images/$imagename")) {
      getstore("http://www.agoracart.com/downloadupdates/$imagename","./$mgrdir/images/$imagename");
      `chmod 644 ./$mgrdir/images/$imagename`;
   }
}
}

print <<ENDOFTEXT;
<CENTER>
<TABLE BORDER=0 CELLPADDING=2>
ENDOFTEXT

if($error_message ne "")

{

print <<ENDOFTEXT;

<TR>
<TD COLSPAN=2>
<CENTER>
<TABLE>
<TR>
<TD class=main_text2>
<FONT FACE=ARIAL SIZE=2 COLOR=RED>$error_message</FONT>
</TD>
</TR>
</TABLE>
</CENTER>
</TD>
</TR>

ENDOFTEXT

}

print <<ENDOFTEXT;

<TR>
<TD COLSPAN=2 class=main_text2>
<center><a href="http://www.agoracart.com/agorawiki/index.php?title=The_AgoraCart_Project:User_Manual" target="_blank">User Manual</a>  | 
<a href="http://www.agoracart.com/agorawiki/index.php?title=3rd_Party_Reference_%26_Tutorials" target="_blank">Misc Reference \& Tutorials</a>  | 
<a href="DOCS/" target="_blank">Your Store's DOCS directory</a>  | 
<a href="http://www.AgoraCart.com/blog" target="_blank">Blog: News & Updates</a>  | 
<a href="http://www.agoracart.com/paymentgateways.htm" target="_blank">Payment Gateways Supported</a></center><br/>
ENDOFTEXT
#read files for updates added by Mister Ed Jan 2006
$target_file = "http://www.agoracart.com/news.txt";
if ($mc_first_time_user_to_agora_check2 eq '') {
    $target_file = "http://www.agoracart.com/news_fnew.txt";
}
use LWP::Simple;
my $file = get($target_file);
$file =~ s/\$imageURLthingy/$imageURLthingy/g;
 @line = split(/\n/, $file);
 print "@line";
print <<ENDOFTEXT;

<font size=+1><b>Please Donate:</b></font><br>
Like many Open Source Projects, we rely heavily upon donations to keep our project running. If you found this program useful, please donate what you can, such as: time, money, templates, or code.  Opportunities to contribute include becoming a Gold Member/Supporter (aka Gold member or Members Only), contributing templates or perl code improvements, helping others in our user forums, or even supporting our affiliated services.  If you cannot contribute time or code, our suggested donation is \$15.00 average per year. &nbsp;&nbsp; Regardless, we will greatly appreciate your support, so please donate and donate as often as you are able to.
<br><br>
<form action="https://www.paypal.com/cgi-bin/webscr" method="post" target="_new">
          				<b>Donation by PayPal:</b>&nbsp;&nbsp;
  										<input type="hidden" name="cmd" value="_xclick"/>
										<input type="hidden" name="business" value="webmaster\@imegamall.com"/>
										<input type="hidden" name="item_name" value="AgoraCart Donation"/>
											Amount of Donation:&nbsp;&nbsp;
											<select name="amount" size=1>
												<option>5.00</option>
												<option>10.00</option>
												<option>15.00</option>
												<option>20.00</option>
												<option>25.00</option>
												<option>30.00</option>
												<option>35.00</option>
												<option>40.00</option>
												<option>45.00</option>
												<option>50.00</option>
												<option>75.00</option>
												<option>100.00</option>
												<option>125.00</option>
												<option>150.00</option>
												<option>175.00</option>
												<option>200.00</option>
												<option>225.00</option>
												<option>250.00</option>
											</select>&nbsp;&nbsp;
											<input type="hidden" name="cn" value="Special Instructions"/>
											<input type="hidden" name="no_note" value="1"/>
											Currency:&nbsp;&nbsp;
											<select name="currency_code" size=1>
												<option>USD</option>
												<option>CAD</option>
												<option>GBP</option>
												<option>AUS</option>
												<option>EUR</option>
											</select>&nbsp;&nbsp;
											<input type="hidden" name="return" value="http://www.agoracart.com/thanksdonation.htm"/>
											<input type="submit" value="Pay with PayPal"/></form>

          				<form method='post' action='https://secure.paymentclearing.com/cgi-bin/mas/buynow.cgi'/ target="_new">
          					<input type='hidden' name='vendor_id' value='36895'/>
          					<input type='hidden' name='home_page' value='http://www.agoracart.com/donation.htm'/>
          					<input type='hidden' name='ret_addr' value='http://www.agoracart.com/thanksdonation.htm'/>
          					<input type='hidden' name='mername' value='AgoraCart.org'/>
          					<input type='hidden' name='acceptchecks' value='1'/>
          					<input type='hidden' name='acceptcards' value='1'/>
          					<input type='hidden' name='showaddr' value='1'/>
          					<input type='hidden' name="1-qty" value="1"/>
          					<input type='hidden' name="1-desc" value="AgoraCart Donation">
<INPUT type="hidden" name="mastimage" value="1">
<INPUT type="hidden" name="mast" value="https://secure.serverf.net/~agoracgi/images2/Agora-logo-white2.gif">
          				<b>Donation by Visa/MC/Discover/eCheck: </b>&nbsp;&nbsp; Amount of Donation:&nbsp;
<select name="1-cost" size=1>
												<option>5.00</option>
												<option>10.00</option>
												<option>15.00</option>
												<option>20.00</option>
												<option>25.00</option>
												<option>30.00</option>
												<option>35.00</option>
												<option>40.00</option>
												<option>45.00</option>
												<option>50.00</option>
												<option>75.00</option>
												<option>100.00</option>
												<option>125.00</option>
												<option>150.00</option>
												<option>175.00</option>
												<option>200.00</option>
												<option>225.00</option>
												<option>250.00</option>
											</select>&nbsp;
										<input type=hidden name="visaimage" value="1"/>
										<input type=hidden name="mcimage" value="1"/>
										<input type=hidden name="discimage" value="1"/>
											<input type=submit value="Pay Securely through NiftyPay">
									</form>

<br>

$other_welcome_message
</TD>
</TR>
</TABLE>
</CENTER>
            <p class="center">
              <a href="http://www.hotscripts.com/Detailed/11562.html" target="_blank">
                <img src="http://images.hotscripts.com/dynamic/rating.gif?11562" /></a>
              <br />
            </p>

<HR>
<CENTER>
<TABLE BORDER=0 CELLPADDING=0 CELLSPACING=0>
<TR>
<TD><IMG SRC="manager.cgi?picserve=front_footer.gif" BORDER=0>
</TD>
</TR>
</TABLE>
</CENTER>
ENDOFTEXT
print &$manager_page_footer;

}
################################################################################
sub display_order_log
{
local ($errs)='';
my ($lines)=0;
local ($logfile)= "$sc_logs_dir/$sc_order_log_name";
my ($year,$month,$day,$stuff, $order_filename, $junk2, $Location, $sorry_thingy);
my (%orderLoggingHash);

print &$manager_page_header("Display Order Log","","","");

print "<center>\n";

print qq~<br><br>
<table width=740 border=0 cellpadding=2 cellspacing=0><tr>
<td valign=middle align=center><font face=arial size=+1><b>New Orders Overview</b></font></td>
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
open(LOGFILE, "$logfile") || print "<tr><td width=620 colspan=8 align=center><font face=arial size=2>Sorry, Cannot Find Order Log File</font></td></tr>\n";
while (<LOGFILE>) {

($year,$month,$day,$orderLoggingHash{'invoiceNumber'},$orderLoggingHash{'customerNumber'},$orderLoggingHash{'orderStatus'},$orderLoggingHash{'firstName'},$orderLoggingHash{'lastName'},$orderLoggingHash{'fullName'},$orderLoggingHash{'companyName'},$orderLoggingHash{'emailAddress'},$orderLoggingHash{'orderFromState'},$orderLoggingHash{'orderFromPostal'},$orderLoggingHash{'orderFromCountry'},$orderLoggingHash{'shipMethod'},$orderLoggingHash{'shippingTotal'},$orderLoggingHash{'salesTax'},$orderLoggingHash{'tax1'},$orderLoggingHash{'tax2'},$orderLoggingHash{'tax3'},$orderLoggingHash{'discounts'},$orderLoggingHash{'netProfit'},$orderLoggingHash{'subTotal'},$orderLoggingHash{'orderTotal'},$orderLoggingHash{'affiliateTotal'},$orderLoggingHash{'affiliateID'},$orderLoggingHash{'affiliateMisc'},$orderLoggingHash{'GatewayUsed'},$orderLoggingHash{'buySafe'}) = split(/\t/,$_);

$orderLoggingHash{'orderTotal'} = &format_pricemgr($orderLoggingHash{'orderTotal'});

 if (($orderLoggingHash{'invoiceNumber'} eq "") && ($_ eq "")) {
   print "<tr><td width=620 colspan=8 align=center><font face=arial size=2>Sorry, No Orders</font></td></tr>\n";
   $sorry_thingy= "stop";
  }

my $buysafe_display = '';
if ((($orderLoggingHash{'GatewayUsed'} =~ /Offline/i)||($orderLoggingHash{'GatewayUsed'} =~ /paypal standard/i)) && ($sc_buySafe_is_enabled =~ /yes/) && ($orderLoggingHash{'buySafe'} ne '')) {
        $buysafe_display = qq~<a href="manager.cgi?buysafecanceltrigger=yes&customerNumber=$orderLoggingHash{'customerNumber'}&invNumber=$orderLoggingHash{'invoiceNumber'}&buyMonth=$month&buyYear=$year">Cancel buySAFE Bond</a><br>~;
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
<td valign=middle align=center><font face=arial size=2><a href="manager.cgi?invoiceviewertrigger=invoiceviewertrigger&invoiceNumber=$orderLoggingHash{'invoiceNumber'}&customerNumber=$orderLoggingHash{'customerNumber'}&year=$year&month=$month" target="_new">View Invoice</a><br><a href="manager.cgi?viewertrigger=viewertrigger&invoiceNumber=$orderLoggingHash{'invoiceNumber'}&customerNumber=$orderLoggingHash{'customerNumber'}&year=$year&month=$month">View/Update</a><br><a href="manager.cgi?packingviewertrigger=packingviewertrigger&invoiceNumber=$orderLoggingHash{'invoiceNumber'}&customerNumber=$orderLoggingHash{'customerNumber'}&year=$year&month=$month" target="_new">Packing Slip</a><br><a href="manager.cgi?originalviewertrigger=originalviewertrigger&invoiceNumber=$orderLoggingHash{'invoiceNumber'}&customerNumber=$orderLoggingHash{'customerNumber'}&year=$year&month=$month" target="_new">Original Order</a><br><a href="manager.cgi?deleteviewertrigger=yes&invoiceNumber=$orderLoggingHash{'invoiceNumber'}&customerNumber=$orderLoggingHash{'customerNumber'}&year=$year&month=$month">Delete/Remove</a><br>$buysafe_display</font></td>
</tr>
~;
}
 }
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
################################################################################
sub display_error_log
{
local ($stuff);
local ($lines)=0;
local ($logfile)= "./log_files/error.log";
print &$manager_page_header("Error Log","","","","");
print "<center>\n";
print "<table width='90%' border=0 cellpadding=10>",
      "<tr width=600><td><font face=courier>\n",
      "<b>ERROR LOG: $logfile<br></b></td>\n",
      "<td>&nbsp;</td>\n",
      '<td align=right><a href="manager.cgi?clear_error_log=yes">',
      "<b>CLEAR ERROR LOG</b></a></td>\n",
      "</tr></table>\n";

&display_a_file($logfile,"yes","Empty Error Log");
print "</center>\n";
print &$manager_page_footer;
}
#######################################################################################
sub display_a_file
{
local ($logfile,$need_rules,$empty_msg)=@_;
local ($stuff);
local ($lines)=0;
print "<table width='90%' border=1 cellpadding=10>",
      "<tr width=600><td width=600><font face=courier>\n";
open(LOGFILE, "$logfile") || print "";
while(<LOGFILE>){
 if (($lines > 0) && ($need_rules)) {
   print "<hr>\n";
  }
 $stuff = $_;
 $stuff =~ s/\</\&lt;/g;
 $stuff =~ s/\>/\&gt;/g;
 $stuff =~ s/\|/\<br\>/g;
 print "$stuff<br>\n";
 $lines++;
 }
close(LOGFILE);

 if ($lines == 0) {
   print "$empty_msg\n";
  }
print "</font></td></tr></table>\n";
}
#############################################################################################
sub display_main_settings_choices {
my ($maxcols) = 3;
local ($colwidth) = int(690/$maxcols);
local (%my_list, @my_keys, $inx, $items, $link);
print <<ENDOFTEXT;
<CENTER>
<TABLE WIDTH=690 BORDER=0 CELLPADDING=5 CELLSPACING=0>
ENDOFTEXT
if ($mc_change_main_settings_ok =~ /yes/i) {
print <<ENDOFTEXT;
  <TR WIDTH=690>
  <TD colspan=$maxcols>
        <center><FORM METHOD=POST ACTION=manager.cgi>
  <INPUT TYPE=SUBMIT NAME="main_settings_screen" 
          VALUE="  >>>  Primary/Core AgoraCart Settings - Set Up First! <<<  ">
  </FORM></center>
  </TD>
  </TR>
ENDOFTEXT
}

$items = 0;
foreach $inx (sort(keys(%store_settings_name))){
  $link = $store_settings_link{$inx}; 
  if ($menu_items_disabled{$link} eq '') {
    $items++;
    if ($items == 1) {
      print "<TR WIDTH=690>\n";
     }
    print <<ENDOFTEXT; 
  <TD colspan=1 WIDTH=$colwidth>

  <FORM METHOD=POST ACTION=manager.cgi>
  <INPUT TYPE=SUBMIT NAME=$store_settings_link{$inx} 
         VALUE="$store_settings_name{$inx}" class=main_set_text />
  </FORM>

  </TD>
ENDOFTEXT
    if ($items == $maxcols) {
      $items = 0;
      print "</TR>\n";
     }
   }
 }
 if ($items > 0) {
   while ($items < $maxcols) {
     $items++;
     print "<TD colspan=1 WIDTH=$colwidth>&nbsp;</TD>\n";
    }
   $items = 0;
   print "</TR>\n";
  }
print <<ENDOFTEXT;

</TABLE>
</CENTER>

ENDOFTEXT
}
#############################################################################################
sub display_ordermanagement_settings_choices {
my ($maxcols) = 3;
local ($colwidth) = int(690/$maxcols);
local (%my_list, @my_keys, $inx, $items, $link);
print <<ENDOFTEXT;
<CENTER>
<TABLE WIDTH=690 BORDER=0 CELLPADDING=5 CELLSPACING=0>
ENDOFTEXT

$items = 0;
foreach $inx (sort(keys(%ordermanage_settings_name))){
  $link = $ordermanage_settings_link{$inx}; 
  if ($menu_items_disabled{$link} eq '') {
    $items++;
    if ($items == 1) {
      print "<TR WIDTH=690>\n";
     }
    print <<ENDOFTEXT; 
  <TD colspan=1 WIDTH=$colwidth>

  <FORM METHOD=POST ACTION=manager.cgi>
  <INPUT TYPE=SUBMIT NAME=$ordermanage_settings_link{$inx} 
         VALUE="$ordermanage_settings_name{$inx}" class=main_set_text />
  </FORM>

  </TD>
ENDOFTEXT

    if ($items == $maxcols) {
      $items = 0;
      print "</TR>\n";
     }
   }
 }
 if ($items > 0) {
   while ($items < $maxcols) {
     $items++;
     print "<TD colspan=1 WIDTH=$colwidth>&nbsp;</TD>\n";
    }
   $items = 0;
   print "</TR>\n";
  }
print <<ENDOFTEXT;

</TABLE>
</CENTER>

ENDOFTEXT

}
#############################################################################################
sub display_merchandisingtools_settings_choices {
my ($maxcols) = 3;
local ($colwidth) = int(690/$maxcols);
local (%my_list, @my_keys, $inx, $items, $link);

print <<ENDOFTEXT;
<CENTER>
<TABLE WIDTH=690 BORDER=0 CELLPADDING=5 CELLSPACING=0>
ENDOFTEXT

$items = 0;
foreach $inx (sort(keys(%merchtools_settings_name))){
  $link = $merchtools_settings_link{$inx}; 
  if ($menu_items_disabled{$link} eq '') {
    $items++;
    if ($items == 1) {
      print "<TR WIDTH=690>\n";
     }
    print <<ENDOFTEXT; 
  <TD colspan=1 WIDTH=$colwidth>

  <FORM METHOD=POST ACTION=manager.cgi>
  <INPUT TYPE=SUBMIT NAME=$merchtools_settings_link{$inx} 
         VALUE="$merchtools_settings_name{$inx}" class=main_set_text />
  </FORM>

  </TD>
ENDOFTEXT

    if ($items == $maxcols) {
      $items = 0;
      print "</TR>\n";
     }
   }
 }

 if ($items > 0) {
   while ($items < $maxcols) {
     $items++;
     print "<TD colspan=1 WIDTH=$colwidth>&nbsp;</TD>\n";
    }
   $items = 0;
   print "</TR>\n";
  }
print <<ENDOFTEXT;

</TABLE>
</CENTER>

ENDOFTEXT

}
#############################################################################################
sub html_eval_settings
{
local($errs)='';
$errs = &eval_store_settings;
if ($errs ne '') {
  $errs = qq~<div style="text-align:center; color:red;">$errs</div>\n~;
 }
return $errs;
}
#############################################################################################
sub setup_htaccess_screen
{
local ($the_id,$temp,$whoami);
print &$manager_page_header("htaccess","","","","");
$temp = $ENV{'PATH'};
$ENV{'PATH'} = "/bin:/usr/bin";
$the_id = `id`;
$whoami = `whoami`;
$ENV{'PATH'} = $temp;
print <<ENDOFTEXT;
<CENTER>
<HR>
</CENTER>

<CENTER>
<FORM ACTION="manager.cgi" METHOD="POST">
<TABLE>
<TR>
<TD>
<FONT FACE=ARIAL>Welcome to the htaccess section of the
<b>AgoraCart</b> System Manager.
This code is here to assist you in the event that you are
running Apache or compatable server and have no way to setup 
your .htaccess file to protect the /$mgrdirname directory.
If your ISP or web hosting company has allowed for you to
password protect this directory in another fashion, then 
go ahead and use that.  If not, this procedure will attempt
to place a generic .htaccess file as well as a manager.access 
password file in this directory.  <br><br>
Scripts are running under id: $the_id<br>
Unix 'whoami' responds with: $whoami<br><br>
Note: If your scripts run only under the permissions
of a generic id (such as "nobody") 
and not your user id, and you get locked out after setting this option,
you will have to delete the .htaccess file (use COMMANDO 
if necessary).  You might be able to 
install the wrapper programs to solve this problem.
</TD>
</TR>
</TABLE>
</CENTER>

ENDOFTEXT

if($in{'system_edit_success'} ne "")
{
print <<ENDOFTEXT;
<CENTER>
<TABLE>
<TR>
<TD>
<FONT FACE=ARIAL SIZE=2 COLOR=RED>Settings have been
successfully updated.</FONT>
</TD>
</TR>
</TABLE>
</CENTER>
ENDOFTEXT
}

print <<ENDOFTEXT;

<FONT FACE=ARIAL SIZE=2>
<CENTER>
<TABLE BORDER=0 CELLPADDING=2 CELLSPACING=0>

<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<tr><td colspan=2><center>
<TABLE BORDER=2 CELLPADDING=2 CELLSPACING=0 WIDTH=560>

<TR>
<TD>
username:<INPUT NAME="username" TYPE="TEXT" SIZE=8 maxlength=8 
 VALUE="manager">
</TD>
<TD>
password:<INPUT NAME="password" TYPE="TEXT" SIZE=8 maxlength=8 
 VALUE="">(plain text, will be visible!)</TD>
</TR>

</table></center>
</td></tr>
<TR>
<TD COLSPAN=2><HR></TD>
</TR>

<TR>
<TD COLSPAN=2>
<CENTER>
<INPUT TYPE="HIDDEN" NAME="system_edit_success" VALUE="yes">
<INPUT NAME="htaccessSettings" TYPE="SUBMIT" VALUE="Submit">
&nbsp;&nbsp;
<INPUT TYPE="RESET" VALUE="Reset">
</CENTER>
</TD>
</TR>

<TR>
<TD COLSPAN=2>
<HR>
</TD>
</TR>

</TABLE>

</CENTER>
</FORM>
ENDOFTEXT
print &$manager_page_footer;
}
#############################################################################################
sub change_settings_screen
{
local ($the_id,$temp,$whoami);
print &$manager_page_header("Change Settings","","","","");
$temp = $ENV{'PATH'};
$ENV{'PATH'} = "/bin:/usr/bin";
$the_id = `id`;
$whoami = `whoami`;
$ENV{'PATH'} = $temp;
print <<ENDOFTEXT;
<CENTER>
<HR>
</CENTER>

<CENTER>
<TABLE>
<TR>
<TD>
<FONT FACE=ARIAL>Welcome to the System Settings section of the
<b>AgoraCart</b> System Manager.
</TD>
</TR>
</TABLE>
</CENTER>

ENDOFTEXT

if($in{'system_edit_success'} ne "")
{
print <<ENDOFTEXT;
<CENTER>
<TABLE>
<TR>
<TD>
<FONT FACE=ARIAL SIZE=2 COLOR=RED>Settings have been
successfully updated.</FONT>
</TD>
</TR>
</TABLE>
</CENTER>
ENDOFTEXT
}

&display_main_settings_choices;

print <<ENDOFTEXT;

<CENTER>
<HR>
</CENTER>
ENDOFTEXT
print &$manager_page_footer;
}
#############################################################################################
#added by Mister Ed October 2005
sub order_management_settings_screen {
local ($the_id,$temp,$whoami);
print &$manager_page_header("Order Management Options","","","","");
$temp = $ENV{'PATH'};
$ENV{'PATH'} = "/bin:/usr/bin";
$the_id = `id`;
$whoami = `whoami`;
$ENV{'PATH'} = $temp;
print <<ENDOFTEXT;
<CENTER>
<HR>
</CENTER>

<CENTER>
<TABLE>
<TR>
<TD>
<FONT FACE=ARIAL>Welcome to the Order Management section of the
<b>AgoraCart</b> System Manager.
</TD>
</TR>
</TABLE>
</CENTER>

ENDOFTEXT

if($in{'system_edit_success'} ne "")
{
print <<ENDOFTEXT;
<CENTER>
<TABLE>
<TR>
<TD>
<FONT FACE=ARIAL SIZE=2 COLOR=RED>Settings have been
successfully updated.</FONT>
</TD>
</TR>
</TABLE>
</CENTER>
ENDOFTEXT
}

&display_ordermanagement_settings_choices;

print <<ENDOFTEXT;

<CENTER>
<HR>
</CENTER>
ENDOFTEXT
print &$manager_page_footer;
}
#############################################################################################
#added by Mister Ed October 2005
sub content_management_settings_screen {
local ($the_id,$temp,$whoami);
print &$manager_page_header("CMS - Content Management Options","","","","");
$temp = $ENV{'PATH'};
$ENV{'PATH'} = "/bin:/usr/bin";
$the_id = `id`;
$whoami = `whoami`;
$ENV{'PATH'} = $temp;
print <<ENDOFTEXT;
<CENTER>
<HR>
</CENTER>

<CENTER>
<TABLE>
<TR>
<TD>
<FONT FACE=ARIAL>Welcome to the <b>AgoraCart</b> Content Management System for your store.
</TD>
</TR>
</TABLE>
</CENTER>

ENDOFTEXT

if($in{'system_edit_success'} ne "")
{
print <<ENDOFTEXT;
<CENTER>
<TABLE>
<TR>
<TD>
<FONT FACE=ARIAL SIZE=2 COLOR=RED>Settings have been
successfully updated.</FONT>
</TD>
</TR>
</TABLE>
</CENTER>
ENDOFTEXT
}

&display_merchandisingtools_settings_choices;
print <<ENDOFTEXT;

<CENTER>
<HR>
</CENTER>
ENDOFTEXT
print &$manager_page_footer;
}
#############################################################################################
sub tracking_screen
{
print &$manager_page_header("Tracking","","","","");
$| = 1;
print <<ENDOFTEXT;
<CENTER>
<HR WIDTH=500>
</CENTER>

<CENTER>
<TABLE WIDTH=500>
<TR>
<TD WIDTH=500>
<FONT FACE=ARIAL>
Welcome to the <b>AgoraCart</b> Tracking Manager. Here you will learn some
important information about your visitors and your store.
</FONT>
</TD>
</TR>
</TABLE>
<CENTER>

<CENTER>
<TABLE WIDTH=500>
<TR>
<TD>
<HR WIDTH=500>
<a href="manager.cgi?clear_access_log=yes"><b>CLEAR ACCESS LOG</b></a><br>
<HR WIDTH=500>
<FONT FACE=ARIAL SIZE=2>
<h4>These are the pages that are linking to your store</h4><br>

ENDOFTEXT

$datafile = "./log_files/access.log";
open(DATABASE, "$datafile") || die "Can't Open $datafile";
while(<DATABASE>)
  {
($url, $shortdate, $requested_page, $visit_number, $ip_address, $browser_type, 
 $referring_page, $unix_date) = split(/\|/, $_);
$referring_page = substr($referring_page, 0, 110);
$requested_page = substr($requested_page, 0, 110);
foreach ($referring_page) {
  if ($requested_page ne "")
  {
  $referring_page_count{$referring_page}++;
  }
}
foreach ($requested_page) {
  if ($referring_page eq "possible bookmarks"){
  if ($requested_page ne "")
  {
  $count_bookmarked_pages{$requested_page}++;
  }
} 
foreach ($requested_page) {
  if ($requested_page ne ""){
  $count_first_hit_pages{$requested_page}++;
  }
}
foreach ($ip_address) {
  if ($ip_address ne ""){
  $count_ip{$ip_address}++;
  }
}
foreach ($visit_number) {
  if ($visit_number ne ""){
  $count_visit{$visit_number}++;
  }
}
foreach ($browser_type) {
  if ($browser_type ne ""){
  $count_browser{$browser_type}++;
 }
}
}
  }
close DATABASE;
foreach $referring_page (sort { $referring_page_count{$b} <=> $referring_page_count{$a} } keys %referring_page_count) {
if ($referring_page_count{$referring_page} > 1)
{
print <<ENDOFTEXT;

$referring_page_count{$referring_page} visits from <a href=$referring_page>$referring_page</a><br>

ENDOFTEXT
}
}
print <<ENDOFTEXT;

<BR>
<CENTER>
<HR WIDTH=500>
</CENTER>
<BR>

<h4>These pages appear to be accessed directly, <br>possibly through a bookmark.</h4><br>
ENDOFTEXT

foreach $requested_page (sort { $count_bookmarked_pages{$b} <=> $count_bookmarked_pages{$a} } keys %count_bookmarked_pages) {
if ($count_bookmarked_pages{$requested_page} > 1)
{
print <<ENDOFTEXT;

$count_bookmarked_pages{$requested_page} visits to <a href=$requested_page>$requested_page</a><br>

ENDOFTEXT
}
}
print <<ENDOFTEXT;

<BR>
<CENTER>
<HR WIDTH=500>
</CENTER>
<BR>

<h4>These pages were accessed first during visits to your store</h4><br>
ENDOFTEXT

foreach $requested_page (sort { $count_first_hit_pages{$b} <=> $count_first_hit_pages{$a} } keys %count_first_hit_pages) {

if ($count_first_hit_pages{$requested_page} > 1)

{
print <<ENDOFTEXT;

$count_first_hit_pages{$requested_page} first visits to <a href=$requested_page>$requested_page</a><br>

ENDOFTEXT
}
}

print <<ENDOFTEXT;

<BR>
<CENTER>
<HR WIDTH=500>
</CENTER>
<BR>

<h4>I.P. Addresses of the visitors to your store.</h4><br>
ENDOFTEXT

foreach $ip_address (sort { $count_ip{$b} <=> $count_ip{$a} } keys %count_ip) {
if ($count_ip{$ip_address} > 1)
{
print <<ENDOFTEXT;

$count_ip{$ip_address} visitors from I.P. address <a href=http://$ip_address>$ip_address</a>.<br>

ENDOFTEXT
}
}
print <<ENDOFTEXT;

<BR>
<CENTER>
<HR WIDTH=500>
</CENTER>
<BR>

<h4>Web browsers your visitors are using.</h4><br>
ENDOFTEXT

foreach $browser_type (sort { $count_browser{$b} <=> $count_browser{$a} } keys %count_browser) {
if ($count_browser{$browser_type} > 1)
{
print <<ENDOFTEXT;

$count_browser{$browser_type} visitors use $browser_type as a web browser.<br>

ENDOFTEXT
}
}
print <<ENDOFTEXT;

<BR>
<CENTER>
<HR WIDTH=500>
</CENTER>
<BR>

</FONT>
</TD>
</TR>
</TABLE>
</CENTER>
</BODY>

ENDOFTEXT
}
########################################################################### 
# Written by Steve Kneizys 4-JAN-2000
########################################################################### 
sub make_file_option_list {
 local($my_path,$add_path_to_option_value) = @_;
 local($answer) = "";
 opendir (USER_FILES, "$my_path");
 @files = sort(grep(/\w/,readdir(USER_FILES)));
  foreach $filename (@files) {
  if (-f "$my_path/$filename") {
    if ($add_path_to_option_value =~ /yes/i) {
      $answer .= "<option value=\"$my_path/$filename\">$filename</option>\n";
    } else {
      $answer .= "<option>$filename</option>\n";
    }
 #  print "$my_path/$filename\n";
  } else {
 #  print "$my_path/$filename is not a file\n";
  }
 }
 closedir (USER_FILES);
 return $answer;
}
#############################################################################################
# Writen by Steve Kneizys to serve images 04-FEB-2000
# HTML usage examples:
# <IMG SRC="xxx.cgi?picserve=/images/store.jpg" BORDER=0>
# <IMG SRC="xxx.cgi?picserve=http://www.site.com/images/store.jpg" BORDER=0>
#
# Note: using the http:// format is less efficient
# converted to taint-mode sub 2/5/2000
sub serve_picture
{
 local ($qstr, $sc_path_of_images_directory) = @_;
 local ($test, $test2, $my_path_to_image);
 $qstr =~ /([\w\-\=\+\/\.\:]+)/;
 $qstr = "$1";
 $my_path_to_image = $sc_path_of_images_directory . $qstr ;
 $test = substr($my_path_to_image,0,6);
 $test2 = substr($my_path_to_image,(length($my_path_to_image)-3),3);
 if ($test2 =~ /jpg/i || $test2 =~ /png/i || $test2 =~ /gif/i) {
  if ($test2 =~ /jpg/i) {
    $test2 = "jpeg";
   } 
  if ($test=~ /http:\//i || $test =~ /https:/i) { 
   } else { 
    print "Content-type: image/$test2\n\n";
    open(MYPIC,$my_path_to_image);
    $size = 250000;
    while ($size > 0) {
      $size = read(MYPIC,$the_picture,$size); 
      print "$the_picture";
     }
    close(MYPIC);
   }
 }
}
#######################################################################
sub format_pricemgr
{
local ($unformatted_price) = @_;
local ($formatted_price);
$formatted_price = sprintf ("%.2f", $unformatted_price);
return $formatted_price;
}
############################################################
#added by Mister Ed October 2005
sub set_log_years_months {
if ($scm_logdirs_loaded ne "done") {
opendir(LOGYEARS,"$scm_order_logpath")||die("Cannot open Orders Directory!");
%scm_logyears = "";
$scm_logyearsCount = "0";
my @scm_logyearsTemp = readdir(LOGYEARS);
close (LOGYEARS);
foreach $scm_logyearsTemp(@scm_logyearsTemp) {
  if (($scm_logyearsTemp =~ /(\d{4})/) && (!($scm_logyearsTemp =~ /[a-zA-Z]/))) {
      $scm_logyears{$scm_logyearsTemp} = "$scm_logyearsCount";
      $scm_logyearsCount++;
  }
}
$scm_yearlinks = "";
$scm_monthlinks = "";
@yearlogkeys = sort(keys(%scm_logyears));
foreach $yearlogkeys(@yearlogkeys) {
if ($yearlogkeys ne ""){
$scm_logyears{$scm_logyearsCount} = "$yearlogkeys";
$scm_yearlinks .= "<option>$yearlogkeys</option>\n";
}
}
@monthsLong = ('January','February','March','April','May','June','July',
     'August','September','October','November','December');
foreach $monthsLong(@monthsLong) {
$scm_monthlinks .= "<option>$monthsLong</option>\n";
}
my $daysofmonth = 1;
while ($daysofmonth < 32) {
$scm_daylinks .= "<option>$daysofmonth</option>\n";
$daysofmonth++;
}
}
$scm_logdirs_loaded = "done";
}
############################################################
# Added by Mister Ed at AgoraCart.com in 2002
sub log_out
{
if (-e "$ip_file")
 {
  unlink ("$ip_file"); }
    &display_login;
    &call_exit;
}
#######################################################################
1;
