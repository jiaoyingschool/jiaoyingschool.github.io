# file ./store/protected/custom/customizeable_category_builder_routines.pl
#######################################################################################
#
# Use this file to customize your category and sub category links that are displayed in the headers
# or footers of the store when a customer visits your store.
#
# change only the values for the variables (they start with a \$) between the single quote marks (')
# If you are not familiar with editing of programming variables, just use the defaults.
# 
#######################################################################################
$custom_sc_main_category_indent = '&bull;';
$custom_sc_sub_category_indent = '&nbsp;&nbsp; ';
$custom_sc_main_category_css_class = 'ac_left_links';
$custom_sc_sub_category_css_class = 'ac_left_links';
$custom_sc_main_category_end_html = '<br/>';
$custom_sc_sub_category_end_html = '<br/>';
1;