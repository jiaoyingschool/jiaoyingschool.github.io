#!/usr/local/bin/perl
#
#License Agreement for all Extropia Applications and Code
#
#NOTE: This contract is based upon the  "Artistic License" 
#and the "MIT License" as made available by Eric Raymond 
#at www.opensource.org.  The contract was written on 
#November 17, 1998.
#
#Preamble
#
#The intent of this document is to state the conditions
#under which a Package may be copied, such that the Copyright 
#Holder maintains some semblance of artistic control over the 
#development of the package, while giving the users of the 
#package the right to use and distribute the Package in a 
#more-or-less customary fashion, plus the right to make
#reasonable modifications.
#
#
#Definitions:
#
#
#    "Package" refers to the collection of files distributed 
#    by the Copyright Holder, and derivatives of that 
#    collection of files created through textual modification.
#
#    "Standard Version" refers to such a Package if it has 
#    not been modified, or has been modified in accordance 
#    with the wishes of the Copyright Holder.
#
#    "Copyright Holder" is whoever is named in the 
#    copyright or copyrights for the package.
#
#    "You" is you, if you're thinking about copying or 
#    distributing this Package.
#
#    "Reasonable copying fee" is whatever you can justify 
#    on the basis of media cost, duplication charges, time of 
#    people involved, and so on.  (You will not be required to 
#    justify it to the Copyright Holder, but only to the 
#    computing community at large as a market that must bear 
#    the fee.)
#
#    "Freely Available" means that no fee is charged for 
#    the item itself, though there may be fees involved in 
#    handling the item. It also means that recipients of the 
#    item may redistribute it under the same conditions they 
#    received it.
#
#1. You may make and give away verbatim copies of the source 
#form of the Standard Version of this Package without 
#restriction, provided that you duplicate all of the original 
#copyright notices and associated disclaimers.
#
#2. You may apply bug fixes, portability fixes and other 
#modifications derived from the Public Domain or from the 
#Copyright Holder.  A Package modified in such a way shall 
#still be considered the Standard Version.
#
#3. You may otherwise modify your copy of this Package in any 
#way, provided that you insert a prominent notice in each 
#changed file stating how and when you changed that file, and 
#provided that you do at least ONE of the following:
#
#    a) place your modifications in the Public Domain or otherwise 
#    make them Freely Available, such as by posting said 
#    modifications to Usenet or an equivalent medium, or placing 
#    the modifications on a major archive site such as ftp.uu.net, 
#    or by allowing the Copyright Holder to include your 
#    modifications in the Standard Version of the Package.
#
#    b) use the modified Package only within your corporation or 
#    organization.
#
#    c) rename any non-standard executables so the names do not 
#    conflict with standard executables, which must also be 
#    provided, and provide a separate manual page for each 
#    non-standard executable that clearly documents how it differs 
#    from the Standard Version.
#
#    d) make other distribution arrangements with the Copyright 
#    Holder.
#
#4. You may distribute the programs of this Package in object 
#code or executable form, provided that you do at least ONE of 
#the following:
#
#    a) distribute a Standard Version of the executables and 
#    library files, together with instructions (in the manual 
#    page or equivalent) on where to get the Standard Version.
#
#    b) accompany the distribution with the machine-readable 
#    source of the Package with your modifications.
#
#    c) accompany any non-standard executables with their 
#    corresponding Standard Version executables, giving the 
#    non-standard executables non-standard names, and clearly 
#    documenting the differences in manual pages (or equivalent), 
#    together with instructions on where to get the Standard 
#    Version.
#
#    d) make other distribution arrangements with the Copyright 
#    Holder.
#
#5. You may charge a reasonable copying fee for any 
#distribution of this Package.  You may charge any fee you 
#choose for support of this Package. You may not charge a fee 
#for this Package itself.  However, you may distribute this 
#Package in aggregate with other (possibly commercial) 
#programs as part of a larger (possibly commercial) software
#distribution provided that you do not advertise this Package 
#as a product of your own.
#
#6. The scripts and library files supplied as input to or 
#produced as output from the programs of this Package do not 
#automatically fall under the copyright of this Package, but 
#belong to whomever generated them, and may be sold 
#commercially, and may be aggregated with this Package.
#
#7. C or perl subroutines supplied by you and linked into this 
#Package shall not be considered part of this Package.
#
#8. The name of the Copyright Holder may not be used to endorse 
#or promote products derived from this software without 
#specific prior written permission.
#
#9. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY 
#KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE 
#WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
#PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE AUTHORS 
#OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR 
#OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
#OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
#SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
#10. We encourage you to report any successful 
#implementations of Extropia applications or Extropia-based 
#applications.  To notify us, send email to 
#register@extropia.com.  By notifying us of your installation, 
#you ensure that you will be notified immediately in the
#case of bug fixes or security enhancements.
#
#11. Finally, if you have done some cool modifications to the scripts, 
#please consider submitting your code back to the public domain and getting
#some community recognition by submitting your modifications to the
#Extropia Cool Hacks page.  To do so, send email to hacks@extropia.com
#
############################################################
#                       HTTP_LIB.PL
#
# This script was written by Gunther Birznieks.
# Date Created: 5-15-96

$versions{'http-lib.pl'} = "5.1.000";

#
# Copyright:
#    
#     You may use this code according to the terms specified in
#     the "Artistic License" included with this distribution.  The license
#     can be found in the "Documentation" subdirectory as a file named
#     README.LICENSE. If for some reason the license is not included, you
#     may also find it at www.extropia.com.
# 
#     Though you are not obligated to do so, please let us know if you
#     have successfully installed this application.  Not only do we
#     appreciate seeing the wonderful things you've done with it, but we
#     will then be able to contact you in the case of bug reports or
#     security announcements.  To register yourself, simply send an
#     email to register@extropia.com.
#    
#    Finally, if you have done some cool modifications to the scripts,
#    please consider submitting your code back to the public domain and
#    getting some community recognition by submitting your modifications
#    to the Extropia Cool Hacks page.  To do so, send email to 
#    hacks@extropia.com
#
# Purpose: Provides a set of library routines to connect as
# a browser to another HTTP site and then return the results to
# the caller.
#
# Main Procedures:
#  HTTPGet - Gets a URL using the GET Method
#  HTTPPost - Gets a URL using the POST Method
#
# Set the $http_os variable equal to NT if you are on Windows NT perl
# Set it to UNIX for normal UNIX operations.
#
# If you do not have a version of PERL with the Socket.pm, you
# can manually define $AF_INET and $SOCK_STREAM to 2 and 1 respectively.
# On some systems, SOCK_STREAM may be 2.
#
############################################################

# Use the Sockets library for TCP/IP Communications
use Socket;
$http_os = "UNIX";

############################################################
#
# subroutine: HTTPGet
#   Usage:
#     $buf = &HTTPGet("/index.html", "www.eff.org", 80,
#	"var1=value1&var2=value2&etc=etc);
#
#   Parameters:
#     $url = URL To Connect To Relative to the host
#     $hostname = HostName of WebSite to Connect To
#     $port = port to connect to (normally 80)
#     $in = Form Values To Mimic sending to the site
#
#   Output:
#     HTML Code Output from the Web Server.
#
############################################################

sub HTTPGet {
    local($url, $hostname, $port, $in) = @_;
    local($form_vars, $x, $socket);
    local ($buf);
    $socket = &OpenSocket($hostname, $port);


    $form_vars = &FormatFormVars($in);
# we need to add the ? to the front of the passed
# form variables
    $url .= "?" . $form_vars;

# The following sends the information to the HTTP Server.
    print  $socket <<__END_OF_SOCKET__;
GET $url HTTP/1.0
Accept: text/html
Accept: text/plain
User-Agent: Mozilla/1.0


__END_OF_SOCKET__
   
# RetrieveHTTP retrieves the HTML code
    $buf = &RetrieveHTTP($socket);
    $buf;

} #end of HTTPGet

############################################################
#
# subroutine: HTTPPost
#   Usage:
#     $buf = &HTTPPost("/index.html", "www.eff.org", 80,
#	"var1=value1&var2=value2&etc=etc);
#
#   Parameters:
#     $url = URL To Connect To Relative to the host
#     $hostname = HostName of WebSite to Connect To
#     $port = port to connect to (normally 80)
#     $in = Form Values To Mimic sending to the site
#
#   Output:
#     HTML Code Output from the Web Server.
#
############################################################

sub HTTPPost {
    local($url, $hostname, $port, $in) = @_;
    local($form_vars, $x, $socket);
    local ($buf, $form_var_length);
    $socket = &OpenSocket($hostname, $port);
# The following sends the information to the HTTP Server.

    $form_vars = &FormatFormVars($in);

# We need the length of the form variables
# that are passed to the server to pass as
# content-length.
    $form_var_length = length($form_vars);
    print $socket <<__END_OF_SOCKET__;
POST $url HTTP/1.0
Accept: text/html
Accept: text/plain
User-Agent: Mozilla/1.0
Content-type: application/x-www-form-urlencoded
Content-length: $form_var_length

$form_vars
__END_OF_SOCKET__

    $buf = &RetrieveHTTP($socket);
    $buf;

} #end of HTTPPost

############################################################
#
# subroutine: FormatFormVars
#   Usage:
#     $formvars = &FormatFormVars($in);
#
#   Parameters:
#     $in = form variables to process
#
#   Output:
#     Processed form variables.  Illegal characters
#     are replaced with their %Hexcode equivalents.
#     Currently the routine only handles spaces but
#     could be expanded for more.
#
############################################################

sub FormatFormVars {
    local ($in) = @_; 

    $in =~ s/ /%20/g;

    $in;
} # FormatFormVars

############################################################
#
# subroutine: RetrieveHTTP
#   Usage:
#     $buf = &RetrieveHTTP($socket_handle);
#
#   Parameters:
#     $socket = Handle to the socket we are communicating
#               with
#
#   Output:
#     Buffer containing the output of the HTTP Server
#
############################################################

sub RetrieveHTTP {
    local ($socket) = @_;
    local ($buf,$x, $split_length);

    $buf = read_sock($socket, 6);
# if the buffer has a status code of 200 in it,
# then we know its safe to read in the rest of the document

    if ($buf =~ /200/) {
        while(<$socket>) {
            $buf .= $_;
        }
    }

# We strip off the HTTP header by looking for 
# two newlines or two newlines preceeded with
# carriage returns.  Different Web Servers use
# different delimiters sometimes.
#
    $x = index($buf, "\r\n\r\n");
    $split_length = 4;

    if ($x == -1) {
        $x = index($buf, "\n\n");
        $split_length = 2;
    }
#
# The following actually splits the header off
    if ($x > -1) {
        $buf = substr($buf,$x + $split_length);
    }

    close $socket;

$buf;
} # End of RetrieveHTTP

############################################################
#
# subroutine: OpenSocket
#   Usage:
#     $socket_handle = &OpenSocket($host, $port);
#
#   Parameters:
#     $host = host name to connect to
#     $port = port to connect to
#
#   Output:
#     Handle to socket that was opened
#
############################################################

sub OpenSocket {
    local($hostname, $port) = @_;

    local($ipaddress, $fullipaddress, $packconnectip);
    local($packthishostip);
    local($AF_INET, $SOCK_STREAM, $SOCK_ADDR);
    local($PROTOCOL, $HTTP_PORT); 

# The following variables are set using values defined in
# The sockets.pm library.  If your version of perl (v4) does
# not have the sockets library, you can substitute some 
# default values such as 2 for AF_INIT, and 1 for SOCK_STREAM.
# if 1 does not work for SOCK_STREAM, try using 2.
#
# AF_INET defines the internet class of addressing
#
# SOCK_STREAM is a variable telling the program to use
# a socket connection.  This varies from using SOCK_DGRAM
# which would send UDP datagrams using a connectionless paradigm
# instead.
# 
# PROTOCOL is TCPIP (6).
#
# PORT Should generally be 80 for HTTP Access, some sites use
# alternative ports such as 8080.
#
# SOCK_ADDR is the packeted format of the full socket address
# including the AF_INIT value, HTTP_PORT, and IP ADDRESS in that order
#

    $AF_INET = AF_INET;
    $SOCK_STREAM = SOCK_STREAM;

    $SOCK_ADDR = "S n a4 x8";

# The following routines get the protocol information
#

    $PROTOCOL = (getprotobyname('tcp'))[2];

    $HTTP_PORT = $port;
    $HTTP_PORT = 80 unless ($HTTP_PORT =~ /^\d+$/);
    $PROTOCOL = 6 unless ($PROTOCOL =~ /^\d+$/);

# Ip address is the Address of the host that we need to connect
# to
    $ipaddress = (gethostbyname($hostname))[4];

    $fullipaddress = join (".", unpack("C4", $ipaddress));

    $packconnectip = pack($SOCK_ADDR, $AF_INET, 
		   $HTTP_PORT, $ipaddress);
    $packthishostip = pack($SOCK_ADDR, 
			 $AF_INET, 0, "\0\0\0\0");

# First we allocate the socket
    socket (S, $AF_INET, $SOCK_STREAM, $PROTOCOL) || 
	&web_error( "Can't make socket:$!\n");

# Then we bind the socket to the local host
    bind (S,$packthishostip) || 
	&web_error( "Can't bind:$!\n");
# Then we connect the socket to the remote host
    connect(S, $packconnectip) || 
	&web_error( "Can't connect socket:$!\n");

# The following selects the socket handle and turns off
# output buffering
#
    select(S);
    $| = 1;
    select (STDOUT);

S;
} # End of OpenSocket

############################################################
#
# subroutine: read_sock
#   Usage:
#     &read_socket(SOCKET_HANDLE, $timeout);
#
#   Parameters:
#     SOCKET_HANDLE = Handle to an allocated Socket
#     $timeout = amount of time read_sock is allowed to
#                wait for input before timing out
#                (measured in seconds)
#
#   Output:
#     Buffer containing what was read from the socket
# 
############################################################

sub read_sock {
    local($handle, $endtime) = @_;
    local($localbuf,$buf);
    local($rin,$rout,$nfound);

# Set endtime to be time + endtime.
    $endtime += time;

# Clear buffer
    $buf = "";

# Clear $rin (Read Input variable)
    $rin = '';
# Set $rin to be a vector of the socket file handle
    vec($rin, fileno($handle), 1) = 1;

# nfound is 0 since we have not read anything yet
    $nfound = 0;

# Loop until we time out or something was read 
read_socket: 
while (($endtime > time) && ($nfound <= 0)) {
# Read 1024 bytes at a time
    $length = 1024;
# Preallocate buffer
    $localbuf = " " x 1025;
	# NT does not support select for polling to see if 
	# There are characters to be received.  This is important
	# Because we dont want to block if there is nothing
	# being received.
    $nfound = 1;
    if ($http_os ne "NT") {
# The following polls to see if there is anything in the input
# buffer to read.  If there is, we will later call the sysread routine
	$nfound = select($rout=$rin, undef, undef,.2);
	    }
}
	
# If we found something in the read socket, we should
# get it using sysread.
    if ($nfound > 0) {
	$length = sysread($handle, $localbuf, 1024);
	if ($length > 0) {
	    $buf .= $localbuf;
	    }
    }

# Return the contents of the buffer
$buf;
}

############################################################
#
# subroutine: web_error
#   Usage:
#     &web_error("File xxx could not be opened");
#
#   Parameters:
#     $error = Description of Web Error
#
#   Output:
#     None
# 
############################################################

sub web_error
{
local ($error) = @_;
$error = "Error Occured: $error";
print "$error<p>\n";

# Die exits the program prematurely and prints an error to
# stderr

die $error;

} # end of web_error

1;

