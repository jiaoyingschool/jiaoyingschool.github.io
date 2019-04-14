################################################################################
#                     CREDIT_CARD_VALIDATION_LIB.PL v1.1
#
# Date Created: 12-02-96
# Date Last Modified: 02-07-2000 SPK

$versions{'credit_card_validation_lib.pl'} = "5.1.000";

#
# Author: Doug Miles
# E-mail: dmiles@primenet.com
#
# Copyright Information: This script was written by Doug Miles
#   having been inspired by countless other perl authors.  Feel free to copy,
#   cite, reference, sample, borrow or plagiarize the contents.  However, if you
#   don't mind, please let me know where it goes so that I can at least
#   watch and take part in the development of the memes. Information
#   wants to be free, support public domain freeware.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#
# Credits:
#
#   Thanks to my friend Mark Schaeffner for a better implementation to the Luhn
#   Check Digit Algorithm.
#
#   Also, thanks to Selena Sol and Gunther Birznieks, whose generosity inspired
#   me to spend just a little bit more time on this library to make it usable
#   and understandable for everyone.
#
# Purpose: This library contains routines to validate submitted credit card
#          information.
#
# Main Procedures:
#   validate_credit_card_information - This routine validates submitted credit
#                                      card information.
#
#   validate_credit_card_name - This routine validates that the name of the
#                               credit card is one that can be processed by this
#                               library.  (VISA, MASTERCARD, AMERICAN EXPRESS,
#                               DISCOVER)
#
#   validate_credit_card_number - This routine validates that the credit card
#                                 number is valid.
#
#   validate_credit_card_expiration_date - This routine verifies that the credit
#                                          card has not expired.
#   (Modified by Steve Kneizys for format MM/DD/YYYY on Feb 7, 2000)
#
################################################################################

################################################################################
#  
# Subroutine: validate_credit_card_information
#
#   Usage:
#     &validate_credit_card_information($credit_card_name, $credit_card_number,
#                                       $credit_card_expiration_date)
#
#   Parameters:
#     $credit_card_name = name of the credit card (VISA, MASTERCARD, AMERICAN
#                                                  EXPRESS, DISCOVER).
#     $credit_card_number = the 13,15, or 16 digit credit card number.
#     $credit_card_expiration_date = the month and year that the credit card
#                                    expires in.
#
#   Purpose:
#     This routine performs the following validations on the credit card data:
#
#       1. Validates that $credit_card_name is one of these cards:
#
#          VISA
#          MASTERCARD
#          AMERICAN EXPRESS
#          DISCOVER
#
#       2. Checks $credit_card_number to see if it is a VALID credit card
#          number.  The first check is length of $credit_card_number for the
#          given  $credit_card_name.  The second check is validating
#          $credit_card_number using the Luhn Check Digit Algorithm.
#
#       3. Verifies that $credit_card_expiration_date is a date in the future.
#
#   Output:
#     validate_credit_card_information returns the associative array %error.
#     The key is the error code, and the value is the error message.  Possible
#     return values are:
#
#       0: Credit Card Passed Validation.
#       1: Invalid Credit Card Type.
#       2: Invalid Credit Card Number.
#       3: Credit Card Expired.
#
################################################################################

# The purpose of this routine (and library) is twofold.  First, it catches
# credit card information typographical errors.  Second, it prevents someone
# from just "making up" credit card information (i.e. credit card number).  Just
# because a credit card successfully passes all the checks in this routine,
# (obviously) does NOT mean that there are funds available on the card, NOR does
# it mean that the person who is submitting the card information is the actual
# owner of the card.  This routine simply verifies that:
# 1. the card is a valid type (VISA, MASTERCARD, AMERICAN EXPRESS, DISCOVER),
# 2. the number is a possible valid credit card number, and
# 3. the card has not expired.

sub validate_credit_card_information
{

# Declare all variables local, so as not to conflict with variables in the
# calling program.

  local($credit_card_name, $credit_card_number,
        $credit_card_expiration_date) = @_;
  local($invalid);

# The main part of validate_credit_card_information is pretty straight forward.
# There is a call to three separate routines which do the real validation work:
#
# &validate_credit_card_name
# &validate_credit_card_number
# &validate_credit_card_expiration_date
#
# The return value in each case is stored to $invalid.  If $invalid is non-zero,
# the validation failed, and the routine is exited immediately with an error
# code/error message combination stored in the associative array %error.  If all
# three tests pass successfully, a return code 0 and success message are
# returned to the calling program.

  # Convert $credit_card_name to upper case for matching purposes later.
  $credit_card_name = "\U$credit_card_name\E";

  $invalid = &validate_credit_card_name($credit_card_name);

  if($invalid)
  {

    $error{1} = "I'm sorry, I can't validate $credit_card_name credit cards. \
Please try one of these cards: VISA, MASTERCARD, AMERICAN EXPRESS, \
or DISCOVER.";

    # Return the error code and message.
    return(%error);

  }
  
  $invalid = &validate_credit_card_number($credit_card_name,
                                          $credit_card_number);

  if($invalid)
  {

    $error{2} = "I'm sorry, $credit_card_number is not a valid number for \
$credit_card_name. Please double check the number and try again.";

    # Return the error code and message.
    return(%error);

  }
  
  $invalid = &validate_credit_card_expiration_date($credit_card_expiration_date);

  if($invalid)
  {

    $error{3} = "I'm sorry, that credit card has expired, or the date entered \
is invalid.  Please try another card or re-enter the expiration date.";

    # Return the error code and message.
    return(%error);

  }

# Error is a misnomer here, but error code zero usually means success.

  $error{0} = "Credit card $credit_card_name: $credit_card_number \
$credit_card_expiration_date passed validation.";

  # Return the success code and message.
  %error;

} # END: sub validate_credit_card_information

################################################################################
#  
# Subroutine: validate_credit_card_name
#
#   Usage:
#     &validate_credit_card_name($credit_card_name)
#
#   Parameters:
#     $credit_card_name = name of the credit card (VISA, MASTERCARD, AMERICAN
#                                                  EXPRESS, DISCOVER)
#
#   Purpose:
#     This routine performs the following validations on the credit card name:
#
#       Validates that $credit_card_name is one of these cards:
#
#         VISA
#         MASTERCARD
#         AMERICAN EXPRESS
#         DISCOVER
#
#   Output:
#     validate_credit_card_name returns $error_code.  Possible return values
#     are:
#
#       0: Credit Card Number Passed Validation.
#       1: Invalid Credit Card Number Length.
#       2: Invalid Credit Card Number.
#
################################################################################

# First, @valid_credit_cards is filled with the type of cards that this library
# can handle.  Then the submitted credit card name is compared against each
# valid card in the array.  If a match is found, 0 is returned, indicating
# success.  If the end of the array is reached, and no match is found, 1 is
# returned indicating failure.

sub validate_credit_card_name
{

  local($credit_card_name) = @_;
  local($invalid);

  # Cards that this routine will accept.
  @valid_credit_cards = ("VISA", "MASTERCARD", "AMERICAN EXPRESS", "DISCOVER");

  foreach $valid_credit_card (@valid_credit_cards)
  {

    if($credit_card_name eq $valid_credit_card)
    {

      return(0); # Credit Card Name is Valid.

    }

  }

  return(1); # Error 1: Credit Card Type Cannot be Processed.

} # END: sub validate_credit_card_name

################################################################################
#  
# Subroutine: validate_credit_card_number
#
#   Usage:
#     &validate_credit_card_number($credit_card_name, $credit_card_number)
#
#   Parameters:
#     $credit_card_name = name of the credit card (VISA, MASTERCARD, AMERICAN
#                                                  EXPRESS, DISCOVER)
#     $credit_card_number = the 13,15, or 16 digit credit card number
#
#   Purpose:
#     This routine performs the following validations on the credit card number:
#
#       1. Verifies that the length of $credit_card_number is valid for the
#          given $credit_card_name.
#
#       2. Validates $credit_card_number using the Luhn Check Digit Algorithm.
#
#   Output:
#     validate_credit_card_number returns $error_code.  Possible return values
#     are:
#
#       0: Credit Card Number Passed Validation.
#       1: Invalid Credit Card Number Length.
#       2: Invalid Credit Card Number.
#
################################################################################

# In this routine, the first step is to remove any dashes or spaces from the
# credit card number.  If there are any non-numeric characters remaining in the
# number, an error is returned.  The next check is validating the correct number
# of digits for each card type. If not, return an error.
#
# The algorithm used to validate the card number is the Check Digit Algorithm.
# This is the algorithm step by step:
#
# 1. Reverse the credit card number and split into individual digits.  The
#    reason for this is that for an odd digit count, the digits of interest are
#    the even ones.  For an even digit count, the digits of interest are the odd
#    ones.  Reversing a number with an odd number of digits leaves the same
#    digits in the even positions.  Reversing a number with an even number of
#    digits swaps the even and odd positions.  For example:
#
#    123456789 (Odd digit count)   987654321 (Odd digit count reversed)
#    OEOEOEOEO                     OEOEOEOEO
#     \      \_____________________/      /
#      \_________________________________/
#                      |
#    Notice that both 1 and 8 are in an odd and even position, respectively, in
#    both cases.
#
#
#    12345678 (Even digit count)   87654321 (Even digit count reversed)
#    OEOEOEOE                      OEOEOEOE
#    --------                      --------
#     \      \____________________/      /
#      \________________________________/
#                      |
#    Notice that 1 changes from an odd position to an even position, and 8
#    changes from an even position to an odd position.
#
# 2. Multiply every even numbered digit by 2.  If the result is greater than 9,
#    9 is subtracted from the product.  The original even digit is replaced with
#    the result of these calculations.
#
# 3. Add all the digits together (the original odd digits and the replaced even
#    digits)
#
# 4. Divide this sum by 10.  If the remainder is zero, the number is valid.
#    Otherwise, the number is invalid.

sub validate_credit_card_number
{

  local($credit_card_name, $credit_card_number) = @_;
  local($credit_card_number_length, $digit_times_two, $digit,
        @credit_card_number_digit, $validation_number);

  # Remove dashes and spaces from $credit_card_number.
  $credit_card_number =~ s/-//g;
  $credit_card_number =~ s/ //g;
  $credit_card_number_length = length($credit_card_number);

  # Make sure that only numbers exist
  if(!($credit_card_number =~ /^[0-9]*$/))
  {

    return(1); # Error 1: Invalid Characters in Credit Card Number.
 
  }

  # Check for correct number of digits for each credit card type.
  if($credit_card_name eq "VISA" &&
     ($credit_card_number_length != 13 && $credit_card_number_length != 16))
  {

    return(2); # Error 2: Invalid Number of Digits for Given Credit Card.

  }
  elsif($credit_card_name eq "MASTERCARD" &&
        $credit_card_number_length != 16)
  {

    return(2); # Error 2: Invalid Number of Digits for Given Credit Card.

  }
  elsif($credit_card_name eq "AMERICAN EXPRESS" &&
        $credit_card_number_length != 15)
  {

    return(2); # Error 2: Invalid Number of Digits for Given Credit Card.

  }
  elsif($credit_card_name eq "DISCOVER" &&
        $credit_card_number_length != 16)
  {

    return(2); # Error 2: Invalid Number of Digits for Given Credit Card.

  }

  # Step 1.
  @credit_card_number_digit = split(/ */, reverse($credit_card_number));

  # Step 2.
  for($digit_position = 1; $digit_position < $credit_card_number_length;
      $digit_position += 2)
  {

    $digit_times_two = ($credit_card_number_digit[$digit_position] * 2);

    if($digit_times_two > 9)
    {

      $credit_card_number_digit[$digit_position] = ($digit_times_two - 9);

    }
    else
    {

      $credit_card_number_digit[$digit_position] = $digit_times_two;

    }

  }

  $validation_number = 0;

  # Step 3.
  foreach $digit (@credit_card_number_digit)
  {

    $validation_number += $digit;

  }

  # Step 4.
  $validation_number % 10;

} # END: sub validate_credit_card_number

################################################################################
#  
# Subroutine: validate_credit_card_expiration_date
#
#   Usage:
#     &validate_credit_card_expiration_date($credit_card_expiration_date)
#
#   Parameters:
#     $credit_card_expiration_date = the month and year that the credit card
#                                    expires in
#
#   Purpose:
#     This routine performs the following validations on the credit card
#     expiration date:
#
#       Verifies that $credit_card_expiration_date is a date in the future.
#
#   Output:
#     validate_credit_card_expiration_date returns $error_code.  Possible return
#     values are:
#
#       0: Credit Card Expiration Date Passed Validation.
#       1: Credit Card Has Expired.
#
################################################################################

sub validate_credit_card_expiration_date
{

# The main purpose of this routine is to prevent expiration date typos.
# Obviously, an unscrupulous user can enter any value they want for the
# expiration date.

# In this routine, the first task is the removal of any dashes, slashes, or
# spaces from $credit_card_expiration_date.  If only one digit was used for the
# month (i.e. "1" instead of "01"), the month is padded with a zero.  The date
# should now be in the form MMYY.  Next, the $credit_card_expiration_date is
# split into $expiration_month and $expiration_year.  The following check
# handles dates > 1999.  Following this, the current system date is read and
# checked for the > 1999 condition (obviously it is important that the system
# date is correct).  The last step is to put the dates in CCYYMM format, and
# compare.  If the expiration date is less than the current date, the card has
# expired. Otherwise return an OK status.

  local($credit_card_expiration_date) = @_;
  local($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst);
  local($expiration_month,$expiration_day,$expiration_year,$expiration_card);
  local($my_today);

  # Remove dashes, slashes, and spaces from $credit_card_expiration_date.
#  $credit_card_expiration_date =~ s/-//g;
#  $credit_card_expiration_date =~ s/\///g;
#  $credit_card_expiration_date =~ s/ //g;
#  if(length($credit_card_expiration_date) < 3)
#  {
#    return(1); # Error 1: Invalid Date.
#  }
#
#  # Add initial "0" to month if not present.
#  if(length($credit_card_expiration_date) < 4)
#  {
#    $credit_card_expiration_date = "0" . $credit_card_expiration_date;
#  }  
#  # Get entered month and year.
#  $expiration_year = substr($credit_card_expiration_date, -2);
#  $expiration_month = substr($credit_card_expiration_date, -4, 2);
#  # Assume if $expiration_year is less that 90, it is past 2000.
#  if($expiration_year > 90)
#  {
#    $expiration_year = "19" . $expiration_year;
#  }
#  else
#  {
#    $expiration_year = "20" . $expiration_year;
#  }

# Modified by Steve Kneizys for format MM/DD/YYYY

  ($expiration_month,$expiration_day,$expiration_year) = 
         split(/\//,$credit_card_expiration_date,3);
  if ($expiration_year < 100) {
    $expiration_year = $expiration_year + 2000; # works for a few years yet
   }
  if ($expiration_day < 1) {
    $expiration_day = 31;# works no matter what month ... assume end of month
   }

  # Get current month and year.
  ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) =
  localtime(time);

  # localtime returns posible values of 0-11.  Increment to change range to
  # 1-12.
  $mon++;

  $my_today = $mday + 100*($mon + 100*(1900 + $year));
  $expiration_card = 100* (100 * $expiration_year + $expiration_month) 
                     + $expiration_day;

  if($my_today > $expiration_card)
  {
    return(2); # Error 2: Credit Card Expired.
  }

  return(0); # Card has not expired.

} # END: sub validate_credit_card_expiration_date

1; # Libraries always end this way so that they return true to require
