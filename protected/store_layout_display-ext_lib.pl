# file ./store/protected/store_layout_display-ext_lib.pl
#########################################################################
#
# Copyright (c) 2002-Present K-Factor Technologies, Inc.
# http://www.k-factor.net/  and  http://www.AgoraCart.com/
# All Rights Reserved.
#
# This software is the confidential and proprietary information of
# K-Factor Technologies, Inc.  You shall
# not disclose such Confidential Information and shall use it only in
# accordance with the terms of the license agreement you entered into
# with K-Factor Technologies, Inc.
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
# You may not give this script away or distribute it an any way without
# written permission.
#
##########################################################################
$versions{'store_layout_display-ext_lib.pl'} = "5.2.001";

{
 local ($modname) = 'misc_store_layout_display';
 &register_extension($modname,"Layout and Design Settings - Misc",$versions{$modname});
 &add_settings_choice("Layout and Design Settings - Misc","Layout & Design Settings - Misc",
  "change_store_layout_screen");
 &register_menu('LayoutSettings',"write_store_layout_settings",
  $modname,"Write Store Layout Settings");
 &register_menu('change_store_layout_screen',"display_store_layout_screen",
  $modname,"Display Store Layout Settings");
}
#######################################################################################
sub write_store_layout_settings {
my ($info,$thanks_info, $temp_page_thanks_layout2);
my ($myset)="";
my (@temp,$junk);

  &ReadParse;


$myset .= "\$sc_use_html_product_pages = \"$in{'sc_use_html_product_pages'}\";\n";
$myset .= "\$sc_use_category_name_as_header = \"$in{'sc_use_category_name_as_header'}\";\n";
$myset .= "\$sc_use_category_name_as_ppinc_root = \"$in{'sc_use_category_name_as_ppinc_root'}\";\n";

$myset .= "\$sc_should_i_display_cart_after_purchase = \"$in{'sc_should_i_display_cart_after_purchase'}\";\n";
$myset .= "\$sc_should_i_display_cart_after_purchase_real = \"$in{'sc_should_i_display_cart_after_purchase'}\";\n";
$myset .= "\$sc_db_max_rows_returned = \"$in{'sc_db_max_rows_returned'}\";\n";
$temp_money_symbol = &my_escape($in{'sc_money_symbol'});
if ($temp_money_symbol =~ /\$/i) {
$myset .= "\$sc_money_symbol = qq`$temp_money_symbol`;\n";
 } else {
  $myset .= "\$sc_money_symbol = \'$in{'sc_money_symbol'}\';\n";
 }
$myset .= "\$sc_money_symbol_placement = \"$in{'sc_money_symbol_placement'}\";\n";
$myset .= "\$sc_money_symbol_spaces = \"$in{'sc_money_symbol_spaces'}\";\n";
$thanks_info = &my_escape($in{'layout_store_productpage_thanks_mess'});
$myset .= "\$layout_store_productpage_thanks_mess = qq~$thanks_info~;\n";
$temp_page_thanks_layout2 = "<tr><td class=\"ac_add_message\">$in{'layout_store_productpage_thanks_mess'}</td></tr>";
my $temp_message = &my_escape($in{'sc_search_error_message'});
$myset .= "\$sc_search_error_message = qq~$temp_message~;\n";
$myset .= "\$sc_item_ordered_message = \'$temp_page_thanks_layout2\';\n";
$myset .= "\$sc_show_shipping_label_box = \"$in{'sc_show_shipping_label_box'}\";\n";
$myset .= "\$sc_totals_table_ship_label = \"$in{'sc_totals_table_ship_label'}\";\n";
$myset .= "\$sc_totals_table_disc_label = \"$in{'sc_totals_table_disc_label'}\";\n";
$myset .= "\$sc_totals_table_stax_label = \"$in{'sc_totals_table_stax_label'}\";\n";
$myset .= "\$sc_show_subtotal_label_box = \"$in{'sc_show_subtotal_label_box'}\";\n";
$myset .= "\$sc_totals_table_subtot_label = \"$in{'sc_totals_table_subtot_label'}\";\n";
$myset .= "\$sc_totals_table_gtot_label = \"$in{'sc_totals_table_gtot_label'}\";\n";
$myset .= "\$sc_totals_table_itot_label = \"$in{'sc_totals_table_itot_label'}\";\n";
$myset .= "\$sc_totals_table_thdr_label = \"$in{'sc_totals_table_thdr_label'}\";\n";
$myset .= "\$sc_display_cartlinksite = \"$in{'sc_display_cartlinksite'}\";\n";
$myset .= "\$sc_display_cartlinksite_url = \"$in{'sc_display_cartlinksite_url'}\";\n";
$myset .= "\$sc_display_cartlinksite_name = \"$in{'sc_display_cartlinksite_name'}\";\n";
$myset .= "\$sc_display_cartlinkhome = \"$in{'sc_display_cartlinkhome'}\";\n";
$myset .= "\$sc_display_cartlinkhome_name = \"$in{'sc_display_cartlinkhome_name'}\";\n";

my $temp_footer_text = &my_escape($in{'sc_footer_copyright_text'});
$myset .= "\$sc_footer_copyright_text = \"$temp_footer_text\";\n";



  &update_store_settings('layout',$myset); # layout settings

$in{'custom_sc_main_category_indent'} =~ s/\s/&nbsp;/g; #'&bull;';
$in{'custom_sc_sub_category_indent'}  =~ s/\s/&nbsp;/g;
$in{'custom_sc_main_category_end_html'}  =~ s/\s/&nbsp;/g;
$in{'custom_sc_sub_category_end_html'} =~ s/\s/&nbsp;/g;
$custom_sc_main_category_indent = "$in{'custom_sc_main_category_indent'}";
$custom_sc_sub_category_indent = "$in{'custom_sc_sub_category_indent'}";
$custom_sc_main_category_css_class = "$in{'custom_sc_main_category_css_class'}";
$custom_sc_sub_category_css_class = "$in{'custom_sc_sub_category_css_class'}";
$custom_sc_main_category_end_html = "$in{'custom_sc_main_category_end_html'}";
$custom_sc_sub_category_end_html = "$in{'custom_sc_sub_category_end_html'}";

my $file = qq| # file ./store/protected/custom/customizeable_category_builder_routines.pl
#######################################################################################
#
# Use this file to customize your category and sub category links that are displayed in the headers
# or footers of the store when a customer visits your store.
#
# change only the values for the variables (they start with a \$) between the single quote marks (')
# If you are not familiar with editing of programming variables, just use the defaults.
# 
#######################################################################################
\$custom_sc_main_category_indent = "$in{'custom_sc_main_category_indent'}"; #'&bull;';
\$custom_sc_sub_category_indent = "$in{'custom_sc_sub_category_indent'}";
\$custom_sc_main_category_css_class = "$in{'custom_sc_main_category_css_class'}";
\$custom_sc_sub_category_css_class = "$in{'custom_sc_sub_category_css_class'}";
\$custom_sc_main_category_end_html = "$in{'custom_sc_main_category_end_html'}";
\$custom_sc_sub_category_end_html = "$in{'custom_sc_sub_category_end_html'}";
1;
|;
 open(UPDATEFILE,">$mgrdir/custom/customizeable_category_builder_routines.pl") || &my_die("Can't Open $mgrdir/custom/customizeable_category_builder_routines.pl");
     print (UPDATEFILE $file);
  close(UPDATEFILE);

  &display_store_layout_screen;
 }
################################################################################
sub display_store_layout_screen
{
print &$manager_page_header("Store Layout","","","","");

if ($sc_show_shipping_label_box eq "") {
    $sc_show_shipping_label_box = "yes";
}

if ($sc_show_subtotal_label_box eq "") {
    $sc_show_shipping_label_box = "no";
}

if ($sc_totals_table_subtot_label eq "") {
    $sc_totals_table_subtot_label = "Sub Total";
}

if ($sc_footer_copyright_text eq "") {
    $sc_footer_copyright_text = "2002-2008 by K-Factor Technologies Inc.";
}

if ($sc_search_error_message eq "") {
    $sc_search_error_message = qq~I'm sorry, no matches were found. Please try your search again.~;
}

print <<ENDOFTEXT;
<CENTER>
<HR>
</CENTER>

<FORM ACTION="manager.cgi" METHOD="POST">
<CENTER>
<TABLE>
<TR>
<TD>
<FONT FACE=ARIAL>Welcome to the <b>AgoraCart</b> Store Layout Manager.  The Store Layout manager controls misc variables like messages, cart order table titles, and controls for cartlink pages.  To change store attributes like fonts, colors, widths and more; please see the <a href="manager.cgi?store_design_editor_screen=yes">Store CSS File Editor</a>.</TD>
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
<TD><br>
<FONT FACE=ARIAL SIZE=2 COLOR=RED>System settings have been 
successfully updated. </FONT>
</TD>
</TR>
</TABLE>
</CENTER>
ENDOFTEXT
}


print <<ENDOFTEXT;

<FONT FACE=ARIAL SIZE=2>
<CENTER>
<TABLE BORDER=0 CELLPADDING=1 CELLSPACING=0 BORDER=0>
<TR>
<TD><br></TD>
</TR>
<TR>
<TD COLSPAN=4 bgcolor=#99CC99 align=center><font face="Arial, Helvetica, sans-serif" size=+2><b>Dynamic Product Viewing & Page Layout</b></font></TD>
</TR>
<TR>
<TD><br></TD>
</TR>

<TR>
<TD colspan=2><b>Use Category Name for Header/Footer Includes?</b>  <small>Default is YES which allows you to create and use headers and/or footers for each individual category of products being viewed.  For example, if you have a category named PERL (as listed in product database) and you want to have a custom header (but still use the standard store footer) in that category in such a fashion that is different from the standard store header, then you would create a file called header-PERL.inc (prepend with header-, then the category name - case sensitive, and appended with the .inc which stands for "include".  Category specific footers would be similar in naming convention, but using footer prepended to name instead of header: footer-PERL.inc).  Repeat for every product category you wish to be different from the standard store header (named: store_header.inc) or the standard store footer (named: store_footer.inc). <br><br>These files would go into the store's "html/html-templates" sub-directory.  <b>You do not need custom headers or footers for every category name</b>, but if they are put into the store's "html/html-templates" sub-directory, then they will be automatically used the next time that any product or list of products from that category are viewed by a visitor.  You can use either a header or a footer or both as long as they match up layout wise. <b>Speed Enhancement:</b> Your store will run faster with this set to no.</small></TD>
<TD colspan=2><SELECT NAME="sc_use_category_name_as_header">
<OPTION>$sc_use_category_name_as_header</OPTION>
<OPTION>yes</OPTION>
<OPTION>no</OPTION>
</SELECT></TD>
</TR>

<TR>
<TD COLSPAN=4><HR></TD>
</TR>
<TR>
<TD colspan=2><b>Use Category Name as ppinc Root?</b>  <small>Default is YES which allows you to create and drop in product page layouts based on the category name of products being viewed.  For example, if you have a category named PERL (as listed in product database) and you want to layout products in that category in such a fashion that is different from the main product layout, then you would create a file called PERL.inc (must be exactly like category name as listed in product database - is case sensitive, and appended with the .inc which stands for "include)".  Repeat for every product category you wish to be different from the main product layout (main layout file is named: productPage.inc).  These files go into the store's "html/html-templates" sub-directory.  You do not have to have one of these files for every category, but if they are put into the store's "html/html-templates" sub-directory, then they will be automatically used the next time that any product or list of products from that category are viewed by a visitor.  Unless you have a good reason to set this to no, leave set at YES.</small></TD>
<TD colspan=2><SELECT NAME="sc_use_category_name_as_ppinc_root">
<OPTION>$sc_use_category_name_as_ppinc_root</OPTION>
<OPTION>yes</OPTION>
<OPTION>no</OPTION>
</SELECT></TD>
</TR>

<TR>
<TD COLSPAN=4><HR></TD>
</TR>

<TR>
<TD colspan=4><font size="2" face="Arial, Helvetica, sans-serif">
<b>Enter the thank you message for dynamicly generated product pages:</b><br>this is basically the thank you message or message of choice that is show after a visitor adds an item to the cart (for the product pages productPage.inc type files).<br><br>
<TEXTAREA NAME="layout_store_productpage_thanks_mess" cols="68" 
rows="2" wrap=off>$layout_store_productpage_thanks_mess</TEXTAREA>
</font>
</TD>
</TR>

<TR>
<TD COLSPAN=4><HR></TD>
</TR>

<TR>
<TD colspan=2><b>How do you want to generate database based html product pages?</b>  <small>Default is "maybe" which allows you to generate database product pages unless a specific ppinc page is specified.  "No" will allow you to only generate pages from the products in the database.  Say "yes" if running an HTML-based store and you are not using a database. NOTE: links to cart and database still need to come from the same domain name as AgoraCart runs from.</small></TD>
<TD colspan=2><SELECT NAME="sc_use_html_product_pages">
<OPTION>$sc_use_html_product_pages</OPTION>
<OPTION>yes</OPTION>
<OPTION>no</OPTION>
<OPTION>maybe</OPTION>
</SELECT></TD>
</TR>

<TR>
<TD COLSPAN=4><HR></TD>
</TR>

<TR>
<TD colspan=2><b>How many products do you wish to display on each product page?</b><br>
<small>(You may override this on individual links manually by setting the URL/Form variable maxp=nn in a URL like so: agoracgi?%%cart_id%%&maxp=27)   <b>Speed Enhancement:</b> Your store will run faster with this set to the smallest number possible.</small></td>
<TD colspan=2>
<INPUT NAME="sc_db_max_rows_returned" TYPE=TEXT SIZE=4 
  VALUE="$sc_db_max_rows_returned">
</TD>
</TD>
</TR>

<TR>
<TD COLSPAN=4><HR></TD>
</TR>
<TR>
<TD colspan=2><b>How do you want to the customer to view the cart contents after adding an item to the cart?</b>  <small>Default is "no" which takes the customer back to the database generated product page they were originally at with a thank you message generated towards the top of the page.  Say "yes" if running an HTML-based store and you DO NOT want to the customer to go to a database generated product page.</small></TD>
<TD colspan=2><SELECT NAME="sc_should_i_display_cart_after_purchase">
<OPTION>$sc_should_i_display_cart_after_purchase</OPTION>
<OPTION>yes</OPTION>
<OPTION>no</OPTION>
</SELECT></TD>
</TR>

<TR>
<TD COLSPAN=4><HR></TD>
</TR>

<TR>
<TD colspan=3>
<b>Enter your Monetary Symbol and Select the position of the Symbol:</b>
<br>
Money Symbol (\$ € £): <INPUT NAME="sc_money_symbol" TYPE="TEXT" SIZE=1 
MAXLENGTH="1" VALUE="$sc_money_symbol">
&nbsp;&nbsp;&nbsp;&nbsp;
Position of Symbol: <SELECT NAME=sc_money_symbol_placement>
<option>$sc_money_symbol_placement</option>
<option>front</option>
<option>back</option>
</SELECT>
<br>
Set space/character between money symbol and numeric values: <INPUT NAME="sc_money_symbol_spaces" TYPE="TEXT" SIZE=2
MAXLENGTH="2" VALUE="$sc_money_symbol_spaces">

</TD>
</TR>

<TR>
<TD><br></TD>
</TR>
<TR>
<TD COLSPAN=4 bgcolor=#99CC99 align=center><font face="Arial, Helvetica, sans-serif" size=+2><b>Order Table Display Layout Section</b></font></TD>
</TR>
<TR>
<TD><br></TD>
</TR>

<TR>
<TD colspan=2><font size="2" face="Arial, Helvetica, sans-serif">
<b>Enter header titles for the Order Display Table:</b><br>this is the table that lists such things as shipping, subtotals, discounts given and the grand total. The order table contents can be seen during "view cart" and the rest of the check out process.<br><br>

Display Shipping Label/Costs at View Cart and Checkout?: 
<SELECT NAME=sc_show_shipping_label_box>
<option>$sc_show_shipping_label_box</option>
<option>yes</option>
<option>no</option>
</SELECT><br><br>

Shipping Label: <INPUT NAME="sc_totals_table_ship_label" TYPE="TEXT" SIZE=20 
MAXLENGTH="30" VALUE="$sc_totals_table_ship_label">&nbsp;&nbsp;&nbsp;&nbsp;
Discount Label: <INPUT NAME="sc_totals_table_disc_label" TYPE="TEXT" SIZE=20 
MAXLENGTH="30" VALUE="$sc_totals_table_disc_label"><br><br>
Sales Tax Label: <INPUT NAME="sc_totals_table_stax_label" TYPE="TEXT" SIZE=20 
MAXLENGTH="30" VALUE="$sc_totals_table_stax_label">&nbsp;&nbsp;&nbsp;&nbsp;
Grand Total Label: <INPUT NAME="sc_totals_table_gtot_label" TYPE="TEXT" SIZE=20 
MAXLENGTH="30" VALUE="$sc_totals_table_gtot_label"><br><br>
Display Sub Total label instead of Grand Total label?<br>
<small>This will change the Grand Total title to the Sub Total title at view cart and at the checkout form. Grand Total will not be shown until the verify page right before payment is made.  Set to "yes" if your customers are getting confused by the totals before making actual payments.</small>
<SELECT NAME=sc_show_subtotal_label_box>
<option>$sc_show_subtotal_label_box</option>
<option>yes</option>
<option>no</option>
</SELECT><br><br>
Sub Total Label: <INPUT NAME="sc_totals_table_subtot_label" TYPE="TEXT" SIZE=20 
MAXLENGTH="30" VALUE="$sc_totals_table_subtot_label"><br><br>
Item Cost Subtotal Label: <INPUT NAME="sc_totals_table_itot_label" TYPE="TEXT" SIZE=30 
MAXLENGTH="35" VALUE="$sc_totals_table_itot_label"><br><br>
Order Totals Header Label: <INPUT NAME="sc_totals_table_thdr_label" TYPE="TEXT" SIZE=30 
MAXLENGTH="35" VALUE="$sc_totals_table_thdr_label">
</font>
</TD>
</TR>

<TR>
<TD><br></TD>
</TR>
<TR>
<TD COLSPAN=4 bgcolor=#99CC99 align=center><font face="Arial, Helvetica, sans-serif" size=+2><b>Static Pages: CartLinks Section</b></font></TD>
</TR>
<TR>
<TD><br></TD>
</TR>

<TR>
<TD colspan=2><br><font size="2" face="Arial, Helvetica, sans-serif">
<b>Enter Cart Links Info:</b><br>this is where you can designate if a home page link or a main store page with link will be created when using the cartlinks auto linking options.  The URL to your Home Page should be in the form of: www.yoursite.com or www.your-site.com/pagename.html.  <b>Do not</b> add the http:// to the URL.  "Name of links" are the Names shown on the web pages that you would click on to go to the Home Page or Main Store Page<br><br>
Do you want a link to your Home Page? <SELECT NAME=sc_display_cartlinksite>
<OPTION SELECTED>$sc_display_cartlinksite</OPTION>
<OPTION>yes</OPTION>
<OPTION>no</OPTION>
</SELECT><br><br>

URL to your Home Page: <INPUT NAME="sc_display_cartlinksite_url" TYPE="TEXT" SIZE=45 
MAXLENGTH="75" VALUE="$sc_display_cartlinksite_url"><br><br>

Name of link to the URL to your Home Page: <INPUT NAME="sc_display_cartlinksite_name" TYPE="TEXT" SIZE=20 
MAXLENGTH="35" VALUE="$sc_display_cartlinksite_name"><br><br>

<br><br>
Do you want a link to your Main Store Page? <SELECT NAME=sc_display_cartlinkhome>
<OPTION SELECTED>$sc_display_cartlinkhome</OPTION>
<OPTION>yes</OPTION>
<OPTION>no</OPTION>
</SELECT><br><br>
Name of link to the URL to your Main Store Page: <INPUT NAME="sc_display_cartlinkhome_name" TYPE="TEXT" SIZE=20 
MAXLENGTH="35" VALUE="$sc_display_cartlinkhome_name"><br><br>

</font>
</TD>
</TR>
<TR>
<TD><br></TD>
</TR>

<TR>
<TD COLSPAN=4 bgcolor=#99CC99 align=center><font face="Arial, Helvetica, sans-serif" size=+2><b>Product Category Layout / Formatting Section</b></font></TD>
</TR>
<TR>
<TD><br></TD>
</TR>

<TR>
<TD colspan=2><font size="2" face="Arial, Helvetica, sans-serif">
This section allows you to update basic formatting used in the display of your category and sub-category links, which are used used in agorascript enabled headers or footers<br><br>
<b>Indent/HTML at Beginning of each Main Product Category:</b> <INPUT NAME="custom_sc_main_category_indent" TYPE="TEXT" SIZE=25 
MAXLENGTH="25" VALUE="$custom_sc_main_category_indent"><br><br>

<b>Indent/HTML at Beginning of each Product Sub-Category:</b> <INPUT NAME="custom_sc_sub_category_indent" TYPE="TEXT" SIZE=25 
MAXLENGTH="25" VALUE="$custom_sc_sub_category_indent"><br><br>

<b>CSS "Class Tag Name" for Main Product Categories:</b> <INPUT NAME="custom_sc_main_category_css_class" TYPE="TEXT" SIZE=25 
MAXLENGTH="25" VALUE="$custom_sc_main_category_css_class"><br><br>

<b>CSS "Class Tag Name" for Product Sub-Categories:</b> <INPUT NAME="custom_sc_sub_category_css_class" TYPE="TEXT" SIZE=25 
MAXLENGTH="25" VALUE="$custom_sc_sub_category_css_class"><br><br>

<b>HTML used at the end of each Main Product Category:</b> <INPUT NAME="custom_sc_main_category_end_html" TYPE="TEXT" SIZE=25 
MAXLENGTH="25" VALUE="$custom_sc_main_category_end_html"><br><br>

<b>HTML used at the end of each Product Sub-Category:</b> <INPUT NAME="custom_sc_sub_category_end_html" TYPE="TEXT" SIZE=25 
MAXLENGTH="25" VALUE="$custom_sc_sub_category_end_html"><br><br>

</font>
</TD>
</TR>
<TR>
<TD><br></TD>
</TR>

<TR>
<TD COLSPAN=4 bgcolor=#99CC99 align=center><font face="Arial, Helvetica, sans-serif" size=+2><b>Misc Cart Messages</b></font></TD>
</TR>
<TR>
<TD><br></TD>
</TR>

<TR>
<TD colspan=2><br><font size="2" face="Arial, Helvetica, sans-serif">
<b>Cart Search Error: No Results Found From Searches and/or in Product Categories</b></font><br>
            <textarea NAME="sc_search_error_message" ROWS="5" COLS="50" 
            wrap="soft">$sc_search_error_message</textarea><br><br>

</TD>
</TR>

<TR>
<TD colspan=2><br><font size="2" face="Arial, Helvetica, sans-serif">
<b>Cart Footer Copyright Text:</b><br />
Used by default in the Copyright &copy;" portion of official templates/themes.  Must be added to custom templates.<br /></font>
            <textarea NAME="sc_footer_copyright_text" ROWS="2" COLS="50" 
            wrap="soft">$sc_footer_copyright_text</textarea><br><br>
</TD>
</TR>

<TR>
<TD COLSPAN=4><HR></TD>
</TR>

<TR>
<TD COLSPAN=4>
<CENTER>
<INPUT TYPE="HIDDEN" NAME="system_edit_success" VALUE="yes">
<INPUT NAME="LayoutSettings" TYPE="SUBMIT" VALUE="Submit">
&nbsp;&nbsp;
<INPUT TYPE="RESET" VALUE="Reset">
</CENTER>
</TD>
</TR>

<TR>
<TD COLSPAN=4>
<HR>
</TD>
</TR>

</TABLE>

</CENTER>
</FORM>
ENDOFTEXT
print &$manager_page_footer;
}
################################################################################
1; # Library
