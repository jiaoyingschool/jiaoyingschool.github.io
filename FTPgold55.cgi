#!/usr/bin/perl
#
# FTP/WWW Installation Instructions:
#
# This file is actually a perl program that may be used to install
# AgoraCart on a UNIX or LINUX web hosting server that has only FTP access.  
# Copyright 2000 to Present by K-Factor Technologies,Inc / AgoraCart.com
#
# This is NOT FREE AND/OR GPL SOFTWARE!
# This software is a separate script to install an ecommerce shopping cart and 
# is the confidential and proprietary information of K-Factor Technologies, Inc.  You shall
# not disclose such Confidential Information and shall use it only in
# conjunction with the AgoraCart (aka agora.cgi) shopping cart and/or AgoraCart Gold,
# AgoraSQL, AgoraCartSQL, or AgoraSuite.
#
#
# STEP 1 -- Put the correct path to perl on line 1 of this file, above.
#
# STEP 2 -- Transfer this file via FTP, in ASCII mode, in the directory of your
# hosting account that you wish to install your store.
#
# STEP 3 -- Rename this file to FTPgold55.cgi
#
# STEP 4 -- make this file readable/executeable (chmod 755) via your FTP software.
#
# STEP 5 -- If you already have 
# a directory named 'agoracart55', please rename it to something else now!
#
# STEP 6 -- run this script from your web browser via a URL like:
#   http://www.yourdomain.com/FTPgold55.cgi
#
# STEP 7 -- Make sure this file is erased from your server immediately.
# this script will attempt to delete itself and the compressed files it downloads.  
#
#
# Copyright (c) 2000 to Present by K-Factor Technologies, Inc and AgoraCart.
# http://www.k-factor.net/  and  http://www.AgoraCart.com/
# All Rights Reserved.
#
# Use with permission only with AgoraCart, AgoraCart Gold, AgoraSQL, AgoraCartSQL, 
# or AgoraSuite
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
######################################################################
sub get_pro_file {
    use LWP::UserAgent;
    my $browser = LWP::UserAgent->new();
    my $req = HTTP::Request->new(GET => "http://members.agoracart.com/downloads/$filename");
    $req->authorization_basic($goldUserName, $goldPassWord);
    my $response = $browser->request($req);
    $file = $response->content();
}
######################################################################
sub write_file {
my $msg = "Can't Open $filename";
open(UPLOADFILE,">./$filename") || die $msg;
     print (UPLOADFILE $file);
close(UPLOADFILE);
}
######################################################################
sub print_footer {
print qq~
      <font><br><br>
      </blockquote>
      </body>
      </html>
   ~;
}
######################################################################
sub print_problem {
print qq~
<font face="arial,helvetica" size=+3 color=red>ERROR:</font><br>
<font face="arial,helvetica" size=2 color=red>There was a problem with getting the files needed to complete your installation request.  Please try again later or use another installation method<font>
~;
}
######################################################################
sub get_extract {

   print qq~
      <html>
      <head>
      <title>AgoraCart Gold Version 5.5.001 Installation</title>
      </head>
      <body>
<div align=center><font face="arial,helvetica" size=+3 color=green>AgoraCart Gold 5.5.001 Installation In Progress</font><br><br><font face="arial,helvetica" size=2 color=black>The Pro version is installing ...  <font></div><br><br>
      <blockquote>
~;
$error1 = "Authorization Required";
$error2 = "This server could not verify";
$error3 = "not in gzip format";
$error4 = "Error exit delayed from previous errors";
$result = '';
$message_pro_access = qq~
<div align=center><font face="arial,helvetica" size=+3 color=green>SUCCESS!!!!</font><br></div><br>
<font face="arial,helvetica" size=2 color=black><br>Thank you for purchasing an AgoraCart Gold membership.  Your AgoraCart Gold version 5.5.001 shopping cart has been installed, but it will still need some basic configuration before it is secure and fully functional.<br><br>
Please <b>edit your store settings/configuration</b> using the following link (<font color=red>Please bookmark it!</font>):<br><br>
<a href="agoracart55/protected/manager.cgi">http://www.your-domain-name.com/agoracart55/protected/manager.cgi</a><br><br>
using the following credentials:<br>
<b>username:</b>  manager<br>
<b>password:</b>  admin
<br><br>
<b>SETUP NOTES:</b> <br><br><b>1)</b> Make sure to setup the <b>Primary/Core Agoracart Settings</b> prior to setting any other settings<br><b>2)</b> Set the password settings prior to using the update/upgrade modules manager.<font></div><br><br><br>
<font size=+1 color=green><b>Initial/Basic Setup Cheat Sheet for Gold Version 5.5.001:</b></font><br>
<br>
<b>Setup your Gold version in the order listed below, using the included online managers found by clicking on "AgoraCart Main Setup/Settings" link</b> (assuming default installation.  Please make notes or print this process before setting membership passwords as this screen changes):
<br>
<ul>
<li> Primary/Cart AgoraCart Setup/Settings <small>(make sure your URLs are correct! save and login again)</small></li>
<li> Password Settings <small>(save and then login again)</small></li>
<li> Set .htaccess protection <small>(on main link menu, skip if not shown as a link. submit and login at popup login screen)</small></li>
<li> Upgrade AgoraCart Modules <small>(upgrade any modules that should be upgraded. Skip new modules/features for now)</small></li>
<li> Store Design - Misc Settings <small>(fill in what makes sense to change)</small></li>
<li> Shipping Settings and Logic <small>(set up. If not sure, consult user manuals and forums for help)</small></li>
<li> Tax Settings and Logic <small>(set up. If not sure, consult user manuals and forums for help)</small></li>
<li> Payment Gateway  <small>(set main gateway in Main Store Setup/Settings screen)</small></li>
<li> Test store with default products  <small>(can delete later)</small></li>
<li> Finish store setup and product/service database entry.</li>
</ul>
<br>
~;
if (-e $filename) {
print qq~
<div align=center><font face="arial,helvetica" size=+3 color=green>AgoraCart tarball file already here</font><br><br><font face="arial,helvetica" size=2 color=black>The Gold version is installing ...  <font></div><br><br><br>
      <blockquote>
~;
$result = `tar -xzvpf $filename 2>&1`;
if (($result ne '') && (($result =~ /agora\.cgi/i)||($result =~ /authorizenet/i))) {
    print $message_pro_access;
} else {
$file = '';
unlink $filename;
&print_problem;
&print_footer;
exit;
}
} else {
if (($goldUserName ne '') && ($goldPassWord ne '')) {
&get_pro_file;

if (($file =~ /you do not have permission to access this area/) || ($file =~ /Howdy/) || ($file =~ /$error1/) || ($file =~ /$error2/i)) {
$file = '';
print qq~
      <font face="arial,helvetica" size=+3 color=red>ERROR:</font><br>
      <font face="arial,helvetica" size=2 color=red>Your credentials were not valid. Please run this script again, or press the back button and try again.<font>
      <br><font face="arial,helvetica" size=2 color=black><br>
      NOTICE: if you are not going to run this script again, please make sure to delete this installation file immediately, or your store could be reinstalled to the generic installation/defaults by accident and/or by a 3rd party trying to see if this script resides on your site.
   ~;
&print_footer;
exit;
} 
if ($file ne '') {
&write_file;
$result = `tar -xzvpf $filename 2>&1`;
if (($result ne '') && (($result !~ /$error3/i)||($result !~ /$error4/i))) {
    print $message_pro_access;
} elsif (($result =~ /$error3/i) || ($result =~ /$error4/i)) {
unlink $filename;
$filename = "agoracart55.tgz";
if (-e $filename) {
print qq~
<div align=center><font face="arial,helvetica" size=+3 color=green>AgoraCart tarball file already here</font><br><br><font face="arial,helvetica" size=2 color=black>The Gold version is installing ... <font></div><br><br><br>
      <blockquote>
~;
} else {
&get_pro_file;
&write_file;
}
$result = `tar -xzvpf $filename 2>&1`;
if (($result ne '') && (($result =~ /agora/i)||($result =~ /protected/i))) {
    print $message_pro_access;
} else {
if (($result ne '') && ($result =~ /$error4/i)) {
 unlink $filename;
$filename = "agoracart55.tar";
&get_pro_file;
&write_file;
$result = `tar -xvpf $filename 2>&1`;
if (($result ne '') && (($result =~ /agora\.cgi/i)||($result =~ /authorizenet/i))) {
    print $message_pro_access;
} else {
$file = '';
unlink $filename;
&print_problem;
&print_footer;
exit;
}
} else {
$file = '';
unlink $filename;
&print_problem;
&print_footer;
exit;
}
} # end inner result
} # end of result - outter
} # end of file
# end of pro thingies
} else {
$filename = "agoracgi.tar.gz";
$target_file = "http://www.agoracart.com/$filename";
use LWP::Simple;
$file = get($target_file);
if ($file ne '') {
my $msg = "Can't Open $filename";
open(UPLOADFILE,">./$filename") || die $msg;
     print (UPLOADFILE $file);
close(UPLOADFILE);
$result = `tar -xzvpf $filename 2>&1`;
} else {
print qq~
<font face="arial,helvetica" size=+3 color=red>ERROR:</font><br>
<font face="arial,helvetica" size=2 color=red>There was a problem with getting the files needed to complete your installation request.  Please try again later or use another installation method<font>
~;
unlink $filename;
}
}
}
&print_footer;
unlink $filename;
unlink $filename2;
}
######################################################################
use CGI qw(:standard);
use CGI::Carp qw/fatalsToBrowser/;
$| = 1;
$ENV{'PATH'} = "/bin:/usr/bin";
$filename = "agoracart55.tar.gz";
#$filename = "agoracart55.tgz";
$filename2 = "FTPgold55.cgi";
$file = '';
foreach my $sparam (param()){$form_data{$sparam} = param($sparam);}
print "Content-type: text/html\n\n";
if ($form_data{"install_now"}) {
$goldUserName = $form_data{"goldUserName"};
$goldPassWord = $form_data{"goldPassWord"};
   &get_extract;
} else {
$temp2 = "$ENV{'SERVER_NAME'}";
$temp = $ENV{'PATH'};
$ENV{'PATH'} = "/bin:/usr/bin";
$my_id = `id`;
$whoami = `whoami`;

$my_modules = '';
$lwp_error_message = '';
foreach $x(qw(
  LWP::UserAgent
  LWP::Simple
  File::Copy
  MIME::QuotedPrint
  HTTP::Request
  XML::Simple
  Net::SSLeay
  )) {
  eval "use $x";
  $my_modules .= "<br/><b>$x</b> :  <font color=red>";
if ($x eq "XML::Simple") {
  $my_modules .=  "$@" ? 'will use AgoraCart Gold supplied version'."<!--\n$@\n-->" : ' installed';
} elsif ($x eq "LWP::UserAgent") {
my $temp_thingy = ' installed';
my $test_perl_module = `perl -MLWP::UserAgent -e 'print "$LWP::UserAgent::VERSION\n"'`;
if ($test_perl_module < 2.999  && $test_perl_module ne '') {
$lwp_error_message = "<br/><br/><font color=red><b>WARNING: the LWP::UserAgent Perl Module is too old</b>.</font> You will not be able to get Gold Version notices nor use the Upgrade manager, but your cart will work perfectly for customers without these. Please ask your hosting provider to update the LWP::UserAgent Perl Module, currently at: $test_perl_module<br>";
$temp_thingy .= " <b>BUT OUTDATED</b>";
}


  $my_modules .=  "$@" ? '<b>NOT installed</b>'."<!--\n$@\n-->" : $temp_thingy;
} else {
  $my_modules .=  "$@" ? '<b>NOT installed</b>'."<!--\n$@\n-->" : ' installed';
}

  $my_modules .=  "</font>\n";
}


$test8 = sprintf("%vd", $^V);
if ($test8 lt "5.6.1") {
$my_modules .= "<br/><br/><font color=red><b>WARNING: Your Perl version is VERY old (Released before August of 2003)</b>.</font> The most current Perl version is 5.10.x.  AgoraCart Gold 5.1.000 and above requires at least Perl 5.6.1 but works best on Perl 5.8.6 or higher. Please ask your hosting provider to upgrade Perl to at least version 5.8.8<br>";
}elsif ($test8 lt "5.6.9") {
$my_modules .= "<br/><br/><font color=red><b>Your Perl version is OK but VERY old (Released late 2003)</b>.</font> The most current Perl version is 5.10.0.  AgoraCart Gold 5.1.000 and above requires at least Perl 5.6.1 but works best on Perl 5.8.6 or higher. We recommend that ask your hosting provider to upgrade Perl to version 5.8.8.  <b>You can still use / install AgoraCart</b><br>";
} elsif ($test8 lt "5.8.6") {
$my_modules .= "<br/><br/><font color=red><b>Your Perl version is OK but slightly outdated</b>.</font>  The most current Perl version is 5.10.0 or even 5.8.8 is okay  Please ask your hosting provider to upgrade Perl to version 5.8.8.  <b>You can still use / install AgoraCart</b><br>";
}


$ENV{'PATH'} = $temp;
if (!(-e $filename2)) {
   print qq~
      <html>
      <head>
      <title>AgoraCart Gold Version 5.5.001 Installation</title>
      </head>
      <body>
<div align=center><font face="arial,helvetica" size=+3 color=green>AgoraCart Gold Version 5.5.001 Installer</font><br><br><font face="arial,helvetica" size=2 color=black>Thank You for using Agoracart and supporting the project!<font></div><br><br><blockquote>
      <p align="center"><font face="Arial" color=red size="+1"><b>Please rename this file to FTPgold55.cgi and try again!</b></font></p><br>
      </blockquote>
      <div align="center">
      <center>
      </div>
<p align="center"> Brought to you by <a href="http://www.AgoraCart.com">AgoraCart.com</a></p><br><br>
      </body>
      </html>
   ~;
exit;
} else {
   print qq~
      <html>
      <head>
      <title>AgoraCart Gold Version 5.5.001 Installation</title>
      </head>
      <body>
<div align=center><font face="arial,helvetica" size=+3 color=green>AgoraCart Gold Version 5.5.001 Installer</font><br><br><font face="arial,helvetica" size=2 color=black>Thank You for using AgoraCart and supporting our project!<font></div><br><br><blockquote>
      <p align="left"><font face="Arial">This program has been designed to make the process of installing AgoraCart Gold as easy as possible.</font></p>
      <p align="left"><font face="Arial">The first thing that you should know is that this program may not work for everyone. With all the possible
      configurations of server it is possible that you may run into problems installing this software on your server.</font></p>
      <p align="left"><font face="Arial">First we need to determine who scripts run as on your server. If they run under a generic
      user, which is the case on some servers, you will not be able to use this installation program. You must be very careful about this because if you do
      install the software using the script under a generic id you may not be able to edit, change, or delete the files once they are installed.</font></p><br>
      </blockquote>
      <div align="center">
      <center>
      <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="90%">
      <tr>
      <td width="100%"><font face="arial,helvetica" size=+1 color=green>Here are the results for your server:</font></td>
      </tr>
      <tr>
      <td width="100%"><font face="Arial" size="2"><b>Server:</b> $temp2<br><b>Scripts are running under id:</b> $my_id<br>
      <b>Unix 'whoami' responds with:</b> <font color="#FF0000">$whoami</font><br/><br/><font color="green"><b>Perl Module Check: </b></font><br/><b>Perl Version:</b> 
~;
 printf "%vd", $^V;
   print qq~
 $my_modules
$lwp_error_message
</font><br></td>
      </tr>
      </table>
      </center>
      </div>
      <blockquote>
      <p><font face="Arial">
If the Unix whoami command responds back with your username, you do not need the wrappers and you can go ahead and proceed with the install.<br><br>

If the Unix whoami command and/or the UID response is: 'nobody', 'www', 'apache', or something other than your username (typically the ID you use to login with when accessing your hosting account), you should NOT use this install script, and you might also need to install wrappers.  If you need to install the wrappers, please see <a href="http://www.AgoraCart.com/security.html">http://www.AgoraCart.com/security.html</a> for the current copies as well as any other wrapper information and updates.<br>
 </font></p>
<br>
<font face="arial,helvetica" size=+1 color=green>Gold Version Users Only:</font><br><font face="arial,helvetica" size=2 color=black>If you are a Gold version member, enter your valid/current member credentials in order to install the Gold version.  <!--Otherwise leave the following blank, then the standard version will be installed.--></font><br><br>
      <form method="POST">
      <p align="center">
<input type="text" NAME="goldUserName" size="15" maxlength="15">
<input type="text" NAME="goldPassWord" size="15" maxlength="15">
      <input type="submit" value="    Continue with install    " name="install_now"></p>
      </form>
      </blockquote>
<p align="center"> Brought to you by <a href="http://www.AgoraCart.com">AgoraCart.com</a></p><br><br>
      </body>
      </html>
   ~;
exit;
}
}
