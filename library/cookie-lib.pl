# Perl Routines to Manipulate Web Browser Cookies
# kovacsp@egr.uri.edu
# $Id: cookie-lib.txt,v 0.913 1998/11/20 19:45:36 kovacsp Exp $
$versions{'cookie-lib.pl'} = "5.1.000";
#
# Copyright (c) 1998 Peter D. Kovacs  
# Unpublished work.
# Permission granted to use and modify this library so long as the
# copyright above is maintained, modifications are documented, and
# credit is given for any use of the library.
#
# Portions of this library are taken, without permission (and much 
# appreciated), from the cgi-lib.pl.  You may get that at 
# http://cgi-lib.stanford.edu/cgi-lib
#

# For more information, see:
# http://www.egr.uri.edu/~kovacsp/cookie-lib/

# For more information on cookies, go to:
# http://search.netscape.com/newsref/std/cookie_spec.html
#
# Modified for agora.cgi to optionally use meta tags to set cookies
# and return only the first cart_id cookie found, all sorts of other
# stuff too!
# SPK -- Feb 8, 2002
# Updated/Modified by Mister Ed Nov 2003, Aug 2005

sub get_all_cookie_info {
  local($chip, $val);
  foreach (split(/; /, $ENV{'HTTP_COOKIE'})) {
    	# split cookie at each ; (cookie format is name=value; name=value; etc...)
    	# Convert plus to space (in case of encoding (not necessary, but recommended)
    s/\+/ /g;
    	# Split into key and value.  
    ($chip, $val) = split(/=/,$_,2); # splits on the first =.
    	# Convert %XX from hex numbers to alphanumeric
    $chip =~ s/%([A-Fa-f0-9]{2})/pack("c",hex($1))/ge;
    $val =~ s/%([A-Fa-f0-9]{2})/pack("c",hex($1))/ge;
    	# Associate key and value
    $cookie{$chip} .= "\1" if (defined($cookie{$chip})); # \1 is the multiple separator
    $cookie{$chip} .= $val;
  }
}

sub get_cookie {
  local($chip, $val);
  foreach (split(/; /, $ENV{'HTTP_COOKIE'})) {
    	# split cookie at each ; (cookie format is name=value; name=value; etc...)
    	# Convert plus to space (in case of encoding (not necessary, but recommended)
    s/\+/ /g;
    	# Split into key and value.  
    ($chip, $val) = split(/=/,$_,2); # splits on the first =.
    	# Convert %XX from hex numbers to alphanumeric
    $chip =~ s/%([A-Fa-f0-9]{2})/pack("c",hex($1))/ge;
    $val =~ s/%([A-Fa-f0-9]{2})/pack("c",hex($1))/ge;
    	# Associate key and value
    $cookie{$chip} .= "\1" if (defined($cookie{$chip})); # \1 is the multiple separator
    $cookie{$chip} .= $val;
  }
}

sub set_cookie { # For compatability with older stores
  &set_agora_cookies;
  print $sc_cookie_information;
  $sc_cookie_information='';
 }

sub set_agora_cookies {
  # $expires must be in unix time format, if defined.  If not defined it sets the expiration to December 31, 1999.
  # If you want no expiration date set, set $expires = -1 (this causes the cookie to be deleted when user closes
  # his/her browser).

  local($my_cookie);
  local($expires,$domain,$path,$sec) = @_;
    local(@days) = ("Sun","Mon","Tue","Wed","Thu","Fri","Sat");
    local(@months) = ("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec");
  local($seconds,$min,$hour,$mday,$mon,$year,$wday) = gmtime($expires) if ($expires > 0); #get date info if expiration set.
  $seconds = "0" . $seconds if $seconds < 10; # formatting of date variables
  $min = "0" . $min if $min < 10; 
  $hour = "0" . $hour if $hour < 10; 
  local(@secure) = ("","secure"); # add security to the cookie if defined.  I'm not too sure how this works.
  if (! defined $expires) { $expires = " expires\=Fri, 31-Dec-1999 00:00:00 GMT;"; } # if expiration not set, expire at 12/31/1999
  elsif ($sc_cookie_days == -1) { $expires = "" } # if expiration set to less than 1, then eliminate expiration of cookie.
  else { 
    $year += 1900; 
    $expires = "expires\=$days[$wday], $mday-$months[$mon]-$year $hour:$min:$seconds GMT; "; #form expiration from value passed to function.
  }
  if (! defined $domain) { $domain = $ENV{'SERVER_NAME'}; } #set domain of cookie.  Default is current host.
  if (! defined $path) { $path = "/"; } #set default path = "/"
  if (! defined $secure) { $secure = "0"; }
  local($key);
  foreach $key (keys %cookie) {
    $cookie{$key} =~ s/ /+/g; #convert plus to space.
    $my_cookie =  "$key\=$cookie{$key}; $expires path\=$path; ";
    $my_cookie .= "domain\=$domain; $secure[$sec]";
  # print cookie to browser,
  # this must be done *before* you print any content type headers.
    if (!($sc_use_pre_content_cookies =~ /no/i)) {
      $sc_cookie_information .= "Set-Cookie: $my_cookie\n";
    }
  # Meta tags go out in the page header
    if ($sc_use_meta_cookies =~ /yes/i) {
      $sc_special_page_meta_tags .= '<META HTTP-EQUIV="Set-Cookie"' . 
                              " Content=\"$my_cookie\">\n";
    }
  }
}

sub delete_cookie {
  # to delete a cookie, simply pass delete_cookie the name of the cookie to delete.
  # you may pass delete_cookie more than 1 name at a time.
  local(@to_delete) = @_;
  local($name,$my_cookie);
  foreach $name (@to_delete) {
   undef $cookie{$name}; #undefines cookie so if you call set_cookie, it doesn't reset the cookie.
   $my_cookie = "$name=deleted; expires=Thu, 01-Jan-1970 00:00:00 GMT;";
 #this also must be done before you print any content type headers.
   print "Set-Cookie: $my_cookie\n";
   if ($sc_use_meta_cookies =~ /yes/i) {
     $sc_special_page_meta_tags .= '<META HTTP-EQUIV="Set-Cookie"' . 
                             " Content=\"$my_cookie\">\n";
    }
  }
}

sub split_cookie {
# split_cookie
# Splits a multi-valued parameter into a list of the constituent parameters

  local ($param) = @_;
  local (@params) = split ("\1", $param);
  return (wantarray ? @params : $params[0]);
}
##########################################################################
{ # Initializations . . .
  local($inx);
  local($agent) = $ENV{'HTTP_USER_AGENT'};
  if ($agent eq '') {$agent='unknown'};
  $agent = substr($agent,0,63);
  $agent =~ tr/A-Z/a-z/;
  $user_agent_dotval = 0;
  for ($inx=0; $inx < length($agent); $inx++) {
    $user_agent_dotval=$user_agent_dotval+$inx+ord(substr($agent,$inx,1));
   }
  $user_agent_dotval = 'a' . $user_agent_dotval;
 #
}

1;
