############################################################
#                       SEND-MAIL-LIB.PL
#
# This script was written by Steve Kneizys for AgoraCart
# Copyright 1999-2005 K-Factor Technologies, Inc
# at http://www.AgoraCart.com

$versions{'send-mail-lib.pl'} = "5.1.000";

#
#   You may copy this under the terms of the GNU General Public
#   License or the Artistic License which is distributed with
#   copies of Perl v5.x for UNIX.
#
# Purpose: Provides a set of library routines to send email
# over the internet using the perl module "Mail::Sendmail".
#
# Main Procedure:
#  send_mail - drop in replacement for standard routine.
#
# TO USE THIS LIBRARY:
# Global variables need to be set, this can be done in the 
# agora.setup.db file or in the free-form logic in the manager.
# Set global variable $smtp_host if not 'localhost'.
# Set the global variable for the mail library:
#   $sc_mail_lib_path = "$sc_lib_dir/send-mail-lib.pl";
#
# Mark S. (MAS) Contribution/Revision 07/17/2004.  A pro member.
# * Updated to conform to Sendmail 0.78. 
# * Fixed bug that would have forced into always using
#  'localhost' as smtp host. 
# * Fixed hash key problems that would have caused multiple 
#   content-types to appear in header. 
# * Added code to allow hacks to add content type to 
#   subject
#----------------------------------------------------------
# Structured and minor cosmetic changes by Mister Ed 08/2004
############################################################

use MIME::QuotedPrint;
use Mail::Sendmail 0.78;

############################################################
#
# subroutine: send_mail 
#   Usage: (send from me to you)
#     &send_mail("me@myhouse.com","you@yourhouse.com",
#     "Mysubject", "My message");
#
#   Parameters:
#     $smtp_from    = Full Email address of sender
#     $smtp_to      = Full Email address of receiver
#     $smtp_subject = Subject of message
#     $smtp_text    = Body of message including newlines.
# 
#   Output:
#     None, unless there is an error
#
############################################################

sub send_mail {
local($smtp_from, $smtp_to, $smtp_subject, $smtp_text) = @_;
local(%mail,$boundary,$plain);
local $regcaps;
local $smtp_host = $smtp_host ? $smtp_host : 'localhost';

$boundary = "====" . time() . "====";

# Key hashes are case sensive. Sendmail.pm needs Content-Type and Smtp
%mail = (Smtp => $smtp_host,
         From => $smtp_from,
         To => $smtp_to,
         Subject => $smtp_subject,
         'Content-Type' => "multipart/alternative; boundary=\"$boundary\""
        );

$plain = encode_qp $smtp_text;
$boundary = '--'.$boundary;

# Following sets default content type (text/plain)
local $contentType = 'Content-Type: text/plain; charset="iso-8859-1"';

# Not everyone may want this, but these lines allow
# certain hacks to use the subject line to override default content type
# but only if $sc_use_dynamic_email_subjects is set to yes in store manager settings.

 if  ((@regcaps = ($smtp_subject =~ /Content-Type: (.+)/i )) && ($sc_use_dynamic_email_subjects eq "yes")) {
    $contentType = $regcaps[0] ;
    $mail{Subject} =~ s/Content-Type:.+//i ;
}


# create it
$mail{body} = <<END_OF_BODY;
$boundary
Content-Type: $contentType
Content-Transfer-Encoding: quoted-printable

$plain

$boundary--
END_OF_BODY

 sendmail(%mail) || die("Send mail failed %s -- %s",__FILE__,__LINE__) ;

}
##########
sub send_mail_lib_error {
  local ($text,$file,$line) = @_;
  $text =~ s/\n/\|/g;
  &update_error_log($text,$file,$line);
 }
##########
1; # Library
