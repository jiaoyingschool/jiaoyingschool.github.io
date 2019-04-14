# file ./store/protected/Merchandising_tools-ext_lib.pl
#########################################################################
#
# Copyright (c) 2005 to Date K-Factor Technologies, Inc.
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
# K-Factor Technologies, Inc. MAKES NO REPRESENTATIONS OR WARRANTIES ABOUT
# THE SUITABILITY OF THE SOFTWARE, EITHER EXPRESSED OR IMPLIED,
# INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE,
# OR NON-INFRINGEMENT.
#
# K-Factor Technologies, Inc. SHALL NOT BE LIABLE FOR ANY DAMAGES SUFFERED BY
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
# K-Factor Technologies, Inc. in order to distribute this add-on.
#
##########################################################################
$versions{'Merchandising_Tools-ext_lib.pl'} = "5.2.003";

{
 local ($modname) = 'merchant_tools_and_resources';
 &register_extension($modname,"CMS - Content Management System",$versions{$modname});
   &register_menu('display_MerchantTools_screen',"display_MerchantTools_screen",
 $modname,"Merchant Tools & Resources screen");
   &add_item_to_manager_menu("CMS - Content Management","content_management_settings_screen=yes","content_management_settings_screen");
   &add_merchtools_settings_choice("Merchant Tools & Resources"," Merchant Tools & Resources ",
 "display_MerchantTools_screen");
}
#######################################################################################
sub display_MerchantTools_screen
{
local($filename)="$mgrdir/";
print &$manager_page_header("Merchant Tools and Resources","","","","");

print <<ENDOFTEXT;
<CENTER>
<HR>
</CENTER>


<CENTER>
<TABLE>
<TR>
<TD>
<FONT FACE=ARIAL size=2>Welcome to the <b>AgoraCart</b> Merchant Resources Page for your store. This page lists additional tools and resources to help you promote and use your store.<br/><br/></font></TD>
</TR>
</TABLE>
</CENTER>

<CENTER>
<TABLE>
<TR>
<TD><br /></TD>
</TR>
<TR>
<TD COLSPAN=4 bgcolor=#99CC99 align=center><font face="Arial, Helvetica, sans-serif" size=+2><b>Online Directories</b></font></TD>
</TR>
<TR>
<TD><br /></TD>
</TR>
<TR>
<TD colspan=4>
<font size="2" face="Arial, Helvetica, sans-serif">
<a href="http://www.iMegaMall.com" target="_new"><img src="images/Imega5d.gif" width="180" height="44" border="0" align=left> <b>iMegaMall</b></a><br />

Increase your search engine rankings with real link in iMegaMall.com.  iMegaMall aggressively provides very small to mid-sized advertisers the opportunity to get their name in front of targeted shoppers and visitors without having giant internet companies buying up all the premium ad spots. <br /><br />

iMegaMall provides businesses and information content providers with a quality presence to online consumers and offers a wide range of targeted advertising and directory listing options through its large mall-department-category infrastructure of 28 Main Departments, over 500 Shopping & Informational Categories.<br /><br />

Sign up today for your free listing at: <a href="http://www.iMegaMall.com/info/listing.htm" target="_new">www.iMegaMall.com/info/listing.htm</a>
<br />
<br /><br />


<a href="http://www.AgoraCart.com/pages/Shopping/" target="_blank"><img src="images/agoracart.jpg" width="56" height="55" border="0" align=left> <b>AgoraCart Shops</b></a> <b>(real stores using AgoraCart)</b><br />

List your Agoracart based store in the shopping section at AgoraCart.com. Listings are free as long as your site uses and/or promotes AgoraCart.<br />
Sign up today for your free listing at: <a href="http://www.agoracart.com/cgibin/add.cgi" target="_new">www.AgoraCart.com/cgibin/add.cgi</a>
<br />
</font>

</TD>
</TR>
<TR>
<TD><br /></TD>
</TR>
<TR>
<TD COLSPAN=4 bgcolor=#99CC99 align=center><font face="Arial, Helvetica, sans-serif" size=+2><b>Search Engines</b></font></TD>
</TR>
<TR>
<TD><br /></TD>
</TR>
<TR>
<TD colspan=4>
<font size="2" face="Arial, Helvetica, sans-serif">

<a href="http://www.SnooperClick.com" target="_blank"><img src="images/snooperclick.jpg" width="158" height="39" border="0" align=left> <b>SnooperClick.com</b></a><br />
Snoop, Click and Go! with the fantastic SnooperClick Search Engine.  Advertise in SnooperClick for free with a \$2 trial balance, or earn extra money for every valid search you refer.  Or integrate SnooperClick's search results and enhance the content of your site by placing a little bit of code into your website's html pages and earn extra money at the same time.<br /><br />
Sign up as a advertiser or affiliate at: <a href="http://www.SnooperClick.com" target="_blank">www.SnooperClick.com</a>
<br />
</font>

</TD>
</TR>


<TR>
<TD><br /></TD>
</TR>
<TR>
<TD COLSPAN=4 bgcolor=#99CC99 align=center><font face="Arial, Helvetica, sans-serif" size=+2><b>Professional Freelance Exchange</b></font></TD>
</TR>
<TR>
<TD><br /></TD>
</TR>
<TR>
<TD colspan=4>
<font size="2" face="Arial, Helvetica, sans-serif">

<a href="http://www.AgoraPros.com" target="_blank"><img src="images/agorapros160.gif" width="160" height="40" border="0" align=left><b>AgoraPros.com</b></a><br />
AgoraPros.com is a service that connects freelancers with webmasters that need custom programming, design or other custom services done for their websites. Much like an auction, programming and web design projects are posted and interested freelancers bid on them. Listing a project is free for merchants.<br /><br />
An affiliate program is also available that pays you for each person you refer that signs up and posts or bids on projects that result in winning bids ... for the life of that referral.<br /><br />

Sign up as a webmaster, affiliate, or a freelancer at: <a href="http://www.AgoraPros.com" target="_blank">www.AgoraPros.com</a>
<br />
</font>

</TD>
</TR>

<TR>
<TD><br /></TD>
</TR>
<TR>
<TD COLSPAN=4 bgcolor=#99CC99 align=center><font face="Arial, Helvetica, sans-serif" size=+2><b>AgoraCart Project/Community Website Links</b></font></TD>
</TR>
<TR>
<TD><br /></TD>
</TR>
<TR>
<TD colspan=4>
<font size="2" face="Arial, Helvetica, sans-serif">
This section covers various links to the AgoraCart community, manuals, news, and other resources avaiable at the official AgoraCart websites.
<br />

            <br /><font size="+1"><b>Help & Support</b></font><br /><br />
            <a href="http://www.AgoraCart.com/agorawiki/" target="_blank">User Manuals / Wiki</a> Official Manuals and guides. Users may submit, update or edit entires in a collaborative effort to improve the documentation for AgoraCart.<br /><br />
            <a href="http://www.agoraguide.com/faq/" target="_blank">Free Support Forum</a> The official forums for the non-pro version of the cart.<br /><br />
            <a href="http://members.AgoraCartPro.com/proforum/" target="_blank">Pro Version Users Forum</a> The official forums for the Pro Version of the cart.<br /><br />
            <a href="http://www.agoracartpro.com/chat/" target="_blank">Pro Version Chat</a> Chat rooms for Pro Version Members to share information and tips in real time<br /><br /><br />
            <a href="https://www2.hosted-projects.com/bugzilla/AgoraCart/" target="_blank">Bugzilla</a> Submit and track bugs for all versions of AgoraCart<br /><br />
            <a href="http://www.AgoraCart.com/pages/Authorized_Solutions_Providers/" target="_blank">Certified AgoraCart Professionals</a> A list of solutions providers pre-screened and approved by AgoraCart.  However, work by anyone on this list is not guaranteed by AgoraCart <small>(aka: use at your own risk).</small><br /><br />
            <a href="http://www.agoracart.com/proshop/agora.cgi?product=Tech_Support" target="_blank">TechSupport</a> A paid tech support option performed by the official AgoraCart personnel.<br /><br />

            <br /><font size="+1"><b>\@ AgoraCart</b></font><br /><br />
            <a href="http://www.AgoraCart.com/" target="_blank">AgoraCart.com</a> Main AgoraCart Site<br /><br />
            <a href="http://www.AgoraCartPro.com/" target="_blank">AgoraCartPro.com</a> Main Pro Version Site<br /><br />
            <a href="http://www.AgoraCart.com/ancient_greek_agora" target="_blank">The Ancient Greek Agora</a> The inspiration behind the AgoraCart name.<br /><br />
            <a href="http://www.AgoraCart.com/blog" target="_blank">Blog: News &amp; Updates</a> News and Updates on AgoraCart. Also serves as Mister Ed's Blog, the primary ecommerce engineer behind the AgoraCart project.<br /><br />
            <a href="http://www.AgoraCart.com/logos.htm" target="_blank">"Powered by" Logos</a> Logos to show off your pride in using the most flexible open source shopping cart solution on the web.<br /><br />
            <a href="http://www.AgoraCart.com/contest.html" target="_blank">Cool Add-ons Contest</a> Contest for designers and programmers to show off their talents.<br /><br />
            <a href="http://www.AgoraCart.com/foundersclub.htm" target="_blank">Founders Club</a> Official Sponsors and Partners of the AgoraCart project..<br /><br />
            <a href="http://www.AgoraCart.com/dashboard.html" target="_blank">AgoraCart Community Dashboard</a> See the snap-shots and listings for what's happening with others in the AgoraNaut commmunity.<br /><br />

            <a href="http://members.AgoraCartPro.com/downloads/" target="_blank">Pro Version Downloads</a> For Pro Version Members Only<br /><br />
            <a href="http://www.AgoraCart.com/download/" target="_blank">More Downloads</a><br /><br />
            <a href="http://www.AgoraCart.com/proshop/agora.cgi" target="_blank">The AgoraCart Store</a> Buy official AgoraCart add-ons and Pro Version Memberships.<br />

</font>

</TD>
</TR>

</TABLE>
</CENTER>
<br /><br />
ENDOFTEXT

print &$manager_page_footer;
}
#######################################################################################
sub display_New_Orders_screen
{
local($filename)="$mgrdir/";
print &$manager_page_header("Order Management New Orders","","","","");



print <<ENDOFTEXT;
<CENTER>
<HR>
</CENTER>

<FORM ACTION="manager.cgi" METHOD="POST">
ENDOFTEXT

if($in{'system_edit_success'} ne "")
{
print <<ENDOFTEXT;
<p align="center"><br /><font color="#FF0000" face="Arial"><strong>$revmsg</strong></font></p><br />
ENDOFTEXT
}


    if ($form{'grabtype'} eq "main"){
    rename ("$mainlogdir$logname" , "$mainlogdir$workinglogname") || &nolog;
    }

  @single="";
  $counter=0;
  $ordernum="";
  

  open(LOG, "$mainlogdir$workinglogname") || &nolog;
  flock(LOG, 2);
  while (<LOG>){
    if ($_ =~ /------------------------------------------------------------/){
      if ($ordernum ne ""){

      chomp $ordernum;
      $singlename= "$ordernum.txt";
      $singlename =~ s/ //ig;
      $singlename =~ s/\n//ig;

##for testing:
# print "order number $singlename written <br />";
# print "order is:<br />";
# foreach $line(@single){
# print "$line<br />";
# }
# exit;
##end for testing

      open (SINGLE, ">$processdir$singlename");
      print SINGLE "@single";
      $counter ++;
      close (SINGLE);

  
      $ordernum="";
      @single="";
      }
    }else{
      push (@single, $_);
      if ($_ =~/INVOICE:/i){
      $ordernum = $_;
      $ordernum =~ s/INVOICE://i;
      $ordernum =~ s/ //;   
      }   
    }
    
  }
  flock (LOG, 8);
  close (LOG);

$revmsg = "$counter orders grabbed.  You may now process these orders.";


print &$manager_page_footer;
}
#######################################################################################

1; # Library
