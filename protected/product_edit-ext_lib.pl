# file ./store/protected/product_edit-ext_lib.pl

$versions{'product_edit-ext_lib.pl'} = "5.2.002";
$sc_userfieldsfile="$mgrdir/misc/userfields.pl";
$mc_shipfilename = "$sc_data_file_dir/shipping_dimensions.file";
&require_supporting_libraries(__FILE__,__LINE__,
  "$mgrdir/misc/userfields.pl");

{
 local ($modname) = 'product_edit';
 &register_extension($modname,"Product DB Edit",$versions{$modname});
 &register_menu('display_screen',"display_catalog_screen",
  $modname,"Display Product DB Catalog");
 &register_menu('add_screen',"add_product_screen",
  $modname,"Write New Product");
 &register_menu('edit_screen',"edit_product_screen",
  $modname,"Edit Product");
 &register_menu('skip_edit_screen',"edit_product_screen",
  $modname,"BASE -- needed if editing products");
 &register_menu('delete_screen',"delete_product_screen",
  $modname,"Delete Product Screen");
 &register_menu('AddProduct',"action_add_product",
  $modname,"Add Product Form");
 &register_menu('EditProduct',"action_edit_product",
  $modname,"Edit Product Form");
 &register_menu('SubmitEditProduct',"action_submit_edit_product",
  $modname,"Write Edited Product");
 &register_menu('DeleteProduct',"action_delete_product",
  $modname,"Delete a product");

 &register_menu('rename_userfields_screen',"display_user_naming_screen",
  $modname,"Rename DB UserFields");
 &register_menu('SubmitEditUserfields',"action_submit_edit_userfields",
  $modname,"Write Edited UserField Names");

 &add_settings_choice("UserFields - Rename for Manager Displays","UserFields - Rename in Managers",
  "rename_userfields_screen");

 &add_item_to_manager_menu("Product Add","add_screen=yes","");
 &add_item_to_manager_menu("Product Edit","edit_screen=yes","");
 &add_item_to_manager_menu("Product Delete","delete_screen=yes","");
}

# set defaults
if ($mc_max_items_per_page eq '') { # Used when listing items in a category
  $mc_max_items_per_page = 100; 
 }
if ($mc_put_edit_helper_at_top eq '') { #edit item/show category
  $mc_put_edit_helper_at_top = 'no'; 
 }
if ($mc_put_edit_helper_at_bot eq '') { #edit item/show category
  $mc_put_edit_helper_at_bot = 'yes'; 
 }

################################################################################
sub display_categories {

local ($link_to) = @_;
local ($maxcols) = 3;
local (%category_list,%db_ele);

print <<ENDOFTEXT;
<CENTER>
<TABLE WIDTH=550 BORDER=0 CELLPADDING=0 CELLSPACING=0>
  <TR WIDTH=550>
  <TD colspan=$maxcols>
        <center><FORM METHOD=POST ACTION=manager.cgi>
  <INPUT TYPE=SUBMIT NAME=$link_to 
          VALUE=" Display All Items in All Categories">
  <INPUT TYPE=HIDDEN NAME=category VALUE="_ALL_">
  </FORM></center>
  </TD>
  </TR>
ENDOFTEXT

$element_id = $db{"product"};
&get_mgr_prod_db_element($element_id,*db_ele);

foreach $sku (keys %db_ele) {
  $category = $db_ele{$sku};
  $category_list{$category}++;
} # End of foreach $sku

$items = 0;

foreach $category (sort(keys(%category_list))) {
 $items++;
###
 if ($items == 1) {
   print "<TR WIDTH=550>\n";
  }
 print <<ENDOFTEXT;
  <TD colspan=1>
  <CENTER>
  <FORM METHOD=POST ACTION=manager.cgi>
  <INPUT TYPE=SUBMIT NAME=$link_to 
         VALUE="$category ($category_list{$category})">
  <INPUT TYPE=HIDDEN NAME=category VALUE="$category">
  </FORM>
  </CENTER>
  </TD>
ENDOFTEXT

 if ($items == $maxcols) {
   $items = 0;
   print "</TR>\n";
  }

 }
# End of foreach

 if ($items > 0) {
   $items = 0;
   print "</TR>\n";
  }


print <<ENDOFTEXT;
  </TABLE>
  </CENTER>
ENDOFTEXT

}

#############################################################################################

sub display_items_in_category {

local ($button,$col_header,$link,$return_link) = @_;
local ($items) = 0;
local ($first,$last);
local (%category_list,%db_ele);
local ($product_id,$found_it,@db_row,$raw_data);

###

# Get every element's product category
$element_id = $db{"product"};
&get_mgr_prod_db_element($element_id,*db_ele);
$first = $in{'first'};
if (($first+0) lt 1) { $first = 1;}
$last = $first -1 +$mc_max_items_per_page;
$table_text = '';
foreach $sku (sort(keys %db_ele)) {
  $category = $db_ele{$sku};

if ($sku) {

if ($in{'category'} eq "_ALL_" || $in{'category'} eq $category) {

 if ($items <= $last) {
   $found_it = &get_prod_db_row($sku, *db_row, *raw_data, "no");
  } else {
   $raw_data='';
   @db_row=();
  }
$price = $db_row[$db{"price"}];
$name  = $db_row[$db{"name"}];

$subcats ='';
$subcats_thingy = '';

if ($sc_use_database_subcats =~/yes/i) {
$subcats  = $db_row[$db{"$sc_subcat_index_field"}];
$subcats =~ s/::/, /g;
$subcats_thingy = qq~
  <TD WIDTH=100>
  <font face=arial size=2>$subcats</font>
  </TD>
~;
}

#($sku, $category, $price, $short_description, $image, 
# $long_description, $options) = split(/\|/,$_);

 $items++;
 if (($items >= $first) && ($items <= $last)) {
   $table_text .= qq~
  <TR WIDTH=550>
  <TD WIDTH=125>
<INPUT TYPE="SUBMIT" NAME="$link\WhichProduct" VALUE="$sku">
</TD>
  <TD WIDTH=100>
  <font face=arial size=2>$category</font>
  </TD>
  <TD WIDTH=275>
  <font face=arial size=2>$name</font>
  </TD>
$subcats_thingy
  <TD WIDTH=75>
  <font face=arial size=2>$price</font>
  </TD>
  </TR>
   ~;
   }
 }
# End of foreach
}

} # End of while database

if ($items < $last) {$last = $items;}
$link_info = 
"manager.cgi?${return_link}=yes&category=$in{'category'}";
$nav_info = "Found $items items, showing $first to $last.";
$nav_info .= "&nbsp;&nbsp;&nbsp;";
if ($first > 1) {
  $newfirst = $first - $mc_max_items_per_page;
  $nav_info .= "<A HREF='$link_info&first=$newfirst'>Previous</A>";
  $nav_info .= "&nbsp;&nbsp;&nbsp;";
# $link_info

 }
if ($items > $last) {
  $newfirst = $last + 1;
  $nav_info .= "<A HREF='$link_info&first=$newfirst'>Next</A>";
  $nav_info .= "&nbsp;&nbsp;&nbsp;";
 }

print <<ENDOFTEXT;
<CENTER>
<TABLE WIDTH=550 BORDER=0 CELLPADDING=4 CELLSPACING=0>
<TR WIDTH=550>
<TD ALIGN="CENTER">
$nav_info
</TD>
</TR>
</TABLE>
</CENTER>
ENDOFTEXT

$subcats_header = '';

if ($sc_use_database_subcats =~/yes/i) {
$subcats_header = qq~
  <TD WIDTH=100>
  <B>Sub Categories</B>
  </TD>
~;
}

print <<ENDOFTEXT;
<CENTER>
<FORM METHOD=POST ACTION=manager.cgi>
<INPUT TYPE=HIDDEN NAME=$link\Product VALUE="$button">
<INPUT TYPE=HIDDEN NAME=category VALUE=$in{'category'}>
<INPUT TYPE=HIDDEN NAME="first" VALUE="$in{'first'}">
<TABLE WIDTH=550 BORDER=1 CELLPADDING=5 CELLSPACING=0>
  <TR WIDTH=550>
  <TD WIDTH=125>
  $col_header
  </TD>
  <TD WIDTH=100>
  <B>Category</B>
  </TD>

  <TD WIDTH=275>
  <B>Description</B>
  </TD>
$subcats_header
  <TD WIDTH=75>
  <B>Price</B>
  </TD>

  </TR>
$table_text
ENDOFTEXT

if ($items <= 0) {
 print <<ENDOFTEXT;
  <TR>
  <TD colspan=5><font face=arial size=2>
        <center><a href="manager.cgi?edit_screen=yes&">Click here</a> to display the categories in your catalog/database.
  </center></font>
  </TD>
  </TR>
ENDOFTEXT
 }
print <<ENDOFTEXT;
<CENTER>
<TABLE WIDTH=550 BORDER=0 CELLPADDING=4 CELLSPACING=0>
<TR WIDTH=550>
<TD ALIGN="CENTER">
<br>
$nav_info
</TD>
</TR>
</TABLE>
</CENTER>
</TABLE>
</FORM>
</CENTER>
ENDOFTEXT

}
################################################################################
sub DisplayRequestedProduct

{

print <<ENDOFTEXT;


<TR WIDTH=500>
<TD WIDTH=125>
$sku
</TD>
<TD WIDTH=125>
$category
</TD>
<TD WIDTH=125>
$short_description
</TD>
<TD WIDTH=125>
$price
</TD>
</TR>

ENDOFTEXT

}
#######################################################################################
sub add_product_screen

{
local($add_product_success) = @_;

##

local($sku, $category, $price, $short_description, $image, 
      $long_description, $shipping_price, $userDefinedOne, 
      $userDefinedTwo, $userDefinedThree, $userDefinedFour, 
      $userDefinedFive, $options);

$new_sku = &get_next_prod_key;
if ($mc_assign_final_sku_at_update =~ /yes/i) {
  $new_sku .= "*";
 }
##

$options_file_list = &make_file_option_list("./html/options","");

print &add_item_form;

}
############################################################################
sub edit_item_form {
 
return &edit_item_form_new;

}
############################################################################
sub add_item_form {
 
return &add_item_form_new;

}
############################################################################
sub add_item_form_new {
local ($form,$msg,$imgup)="";

if ($mc_file_upload_ok =~ /yes/) { 
  $imgup = qq~<tr><td colspan=4><FONT FACE=ARIAL SIZE=2>Upload Image File(s): 
           <input type=file name=upfile1 size=20> &nbsp;&nbsp; 
           <input type=file name=upfile2 size=20><br>
            &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp;<input type=file name=upfile3 size=20> &nbsp;&nbsp; 
           <input type=file name=upfile4 size=20> &nbsp;&nbsp; 
           <input type=file name=upfile5 size=20><br>This is for uploading images only.  Does not do any automatic field/data entry for image names.  Use .gif .jpg or .png formats</font></td></tr>\n~;
 }

# Added in by Bonnie at Scottcrew Web Services for Alternate Origins on Add screen
if ($sc_alt_origin_enabled =~ /yes/) { # allow alternate origins
  $alternate_origin_row = qq~<tr><td colspan=4><font FACE="ARIAL" SIZE="2">Alternate Shipping origins are enabled.  If this product is shipped from a different location than the original location within your shipping settings, then please enter the Zip/Postal Code and the State/Province this product is shipping from.  If not needed, leave blank.<br>
           Zip/Postal Code: <input type=text name="alt_origin_postalcode" size=16 value="$alt_origin_postalcode"> &nbsp;&nbsp; 
           State / Province: <input type=text name="alt_origin_stateprov" size=3 value="$alt_origin_stateprov"><br>
           </td></tr>\n~;
 }

if ($sc_dimensional_shipping_enabled =~ /yes/) { # allow dimensions per box
  $dimension_row = qq~<tr><td colspan=4><font FACE="ARIAL" SIZE="2">Shipping Dimensions are enabled.  Enter the length, width, height of the box. If using a non-rectangular package and not using a shipper supplied container, enter in the girth of the widest point perpendicular to the length of the package.  Select the packaging type as well.  If you use more than one shipping company for real-time quotes, do not select anything other than "your packaging".  <b>If this product is to be boxed with other items, leave these fields blank </b>(it will use defaults from the real-time shipping settings instead).<br>
Box Type: <select name="boxtype">
<option>$boxtype</option>
<option value="02">02 - UPS Your Packaging</option>
<option value="03">03 - UPS Tube (38" Long, posters &amp; prints)</option>
<option value="RECTANGULAR">USPS Your Packaging - Rectangular</option>
<option value="NONRECTANGULAR">USPS Your Packaging - Non-Rectangular</option>
<option value="FLAT RATE BOX">USPS Flat Rate Box - Priority Mail Only</option>
<option value="FLAT RATE ENVELOPE">USPS Flat Rate Envelope</option>
      <option value='RECTANGULARPACKAGING'>Your Packaging (rectagular for any shipper)</option>
<option value="">None</option>
</select> &nbsp;&nbsp;
           Length: <input type=text name=length size=3 value=$length> &nbsp;&nbsp; 
           Width: <input type=text name=width size=3 value=$width> &nbsp;&nbsp; 
           Height: <input type=text name=height size=3 value=$height> &nbsp;&nbsp;
           Girth: <input type=text name=girth size=3 value=$girth><br>
           </td></tr>\n~;
 }

if($add_product_success eq "yes"){
$msg .= qq~<br><FONT FACE=ARIAL SIZE=2 COLOR=RED>Product number <a 
target="_BLANK"
href="../agora.cgi?p_id=$in_sku"><b>$in_sku</b></a> has been added
to the catalog.</FONT>~;
} elsif($add_product_success eq "no") {
$msg .= qq~<br><FONT FACE=ARIAL SIZE=2 COLOR=RED>PRODUCT ID # already 
exists in datafile! Unable to add product, please 
choose a new PRODUCT ID # number.</FONT>~;
} 

$form = qq~<HTML>
<HEAD>
<TITLE>Add Product $new_sku</TITLE>
</HEAD>
<BODY BGCOLOR=WHITE>
<form METHOD="POST" ACTION="manager.cgi" enctype="multipart/form-data">
  <div align="center"><center><table BORDER="0" CELLPADDING="0"
CELLSPACING="0" WIDTH="755">
    <tr><td><table border=0 cellpadding=2 ><tr>
     <td colspan=3 width="72%">
<strong> $manager_banner_main 
Quick Entry</strong>&nbsp;&nbsp;&nbsp;$msg</td>
<td><INPUT 
TYPE=SUBMIT NAME="edit_screen" 
VALUE="Done Entering Products"><INPUT TYPE=HIDDEN NAME="first"
VALUE="$in{'first'}"></td>
</td>
    </tr></table></td>
    </tr>
<tr><td colspan=4><table BORDER="1" CELLPADDING="2" CELLSPACING="0"
WIDTH="755">
  
    <tr>
      <td colspan="1" width="30%"><font FACE="ARIAL" SIZE="2"><b>PRODUCT ID #</b><br><small>(normally do
      not change this!)</small></font><br>&nbsp;&nbsp;<input NAME="sku" VALUE="$new_sku" 
      TYPE="TEXT" SIZE="10" MAXLENGTH="10"></td>
      <td colspan="2" width="40%"><div align="left"><table border="0" cellpadding="0"
      cellspacing="0">
               <tr>
          <td><font FACE="ARIAL" SIZE="2"><b>Price</b><br><small>Do not enter currency symbol</small></font></td>
          <td>&nbsp; <input NAME="price" SIZE="10" MAXLENGTH="10"
           value="$price"></td>
        </tr>
        <tr>
          <td colspan=2><font FACE="ARIAL" SIZE="2"><hr></td>
        </tr>
        <tr>
          <td><font FACE="ARIAL" SIZE="2"><b>Shipping Price or Weight</b><br>(weight only if using SBW module)<br><small>Do not enter anything but the shipping price or weight in numerical form.<br>Leave completely blank if no price or weight needed for this product</small></font></td>
          <td>&nbsp; <input NAME="shipping_price" SIZE="10" MAXLENGTH="10"
           value="$shipping_price"></td>
        </tr>
      </table>
      </div></td>
      <td width="30%"><font FACE="ARIAL" SIZE="2"><b>Option File</b>***<br><small>choose from the list of files in the options directory, usually html/options sub-directory of the store.</small><br>
      </font><select NAME="option_file" size="1">
$options_file_list
      </select> </td>
    </tr>
$alternate_origin_row
$dimension_row
    <tr>
      <td colspan=1><font FACE="ARIAL" SIZE="2"><b>Category</b><br><small>spaces & dashes okay. 50 characters max.</small></font><br><input NAME="category" TYPE="TEXT" SIZE="25"
        MAXLENGTH="50"></td>
      <td colspan=2><font FACE="ARIAL" SIZE="2"><b>Product Name</b><br><small>4 to 8 words. 70 characters max.  No quote marks allowed</small></font><br>
        <input NAME="name" TYPE="TEXT" SIZE="35" MAXLENGTH="70"></td>
      <td colspan=1><font FACE="ARIAL" SIZE="2"><b>Image File</b><br><small>use format of: name.gif (or .jpg / .png).  85 max characters. Case Sensitive, names must match! Do not enter path, name only.</small></font><br>
      <input NAME="image" TYPE="TEXT" SIZE="25" MAXLENGTH="85"></td>
    </tr>
$imgup
    <tr> 
      <td colspan="4" width="100%"><div align=center><table
        cellpadding="1" cellspacing="0">
        <tr>
          <td><font FACE="ARIAL" 
            SIZE="2"><b>Description</b> - Enter the
            Text &amp; HTML describing the product.</font><br>
            <textarea NAME="description" ROWS="10" COLS="85" 
            wrap="soft"></textarea></td>
        </tr>
      </div></table></td>
    </tr>
    <tr>
      <td colspan="2" width="50%"><font face="ARIAL" size="2" color="RED">*2nd Image: </font><input
      NAME="userDefinedOne" SIZE="35" MAXLENGTH="256" style="font-family: Courier, monospace"></td>
      <td colspan="2" width="50%"><font face="ARIAL" size="2" color="RED">$user2: </font><input
      NAME="userDefinedTwo" SIZE="35" MAXLENGTH="256" style="font-family: Courier, monospace"></td>
    </tr>
    <tr>
      <td colspan="2" width="50%"><font face="ARIAL" size="2" color="RED">$user3: </font><input
      NAME="userDefinedThree" SIZE="35" MAXLENGTH="256" style="font-family: Courier, monospace"></td>
      <td colspan="2" width="50%"><font face="ARIAL" size="2" color="RED">$user4: </font><input
      NAME="userDefinedFour" SIZE="35" MAXLENGTH="256" 
      style="font-family: Courier, monospace"></td>
    </tr>
    <tr>
      <td colspan="2" width="50%"><font face="ARIAL" size="2" color="RED">$user5: </font><input
      NAME="userDefinedFive" SIZE="35" MAXLENGTH="256" style="font-family: Courier, monospace"></td>
      <td colspan="2" width="50%">&nbsp;&nbsp; <input TYPE="SUBMIT" NAME="AddProduct"
      VALUE="Add Product">&nbsp;&nbsp;&nbsp; <input TYPE="RESET" VALUE="Clear Form"> </td>
    </tr>
  </table></td></tr>
  </table></center></div>
<blockquote><font face=arial size=2>
<b>QUICK HELP & TIPS</b><br><br>
Change userfield titles displayed in Add Product and Edit Product screens <a href=manager.cgi?rename_userfields_screen=yes>here</a>
<br><br>For help, see the online manual regarding addition of products to your database using the online manager interface at: <a href="http://www.agoracart.com/agorawiki/index.php?title=Adding_Products_to_Your_Store_V5" target="_new">http://www.agoracart.com/agorawiki/index.php?title=Adding_Products_to_Your_Store_V5</a><br><br>
<b>Use the least amount of text as possible in each field</b>.  Shorten names a much as possible. The shorter and/or less text you use, the faster and more efficient your store will run.<br><br>
<b>Remember all entries are case sensitive</b> and will cause errors if even one character is wrong in case (capitals or small caps).<br><br>
*<b>2nd image</b>: This is the image used in the cart contents displayed (view cart, checkout, etc).  Leave blank if not using images in cart contents layout (see cart layout manager).  If using this image, use <b>%%img%%</b> in front of the image name for auto-built images for the image displayed ( example: %%img%%small_imagename.jpg).  Use smaller images, no larger than approx 40-70 pixels in width and/or height, or your cart contents displays will look really terrible and skew your layouts.<br><br>
**<b>sub categories</b>:  if using sub categories, indicate sub category name in a userfield that is open (make sure this is setup in the main store settings/setups screen).  If you need more than one sub category for the product, separate sub category names with two colons ( :: ).  Spaces are acceptable in sub category names.<br><br>
***<b>Option Files</b> can be created in a text editor. You can also download manager add-ons for creating options at the AgoraCart.com or "members only" download sections.  You can add option files later if you desire (and after creating the option html file) using the Product Edit screens for each product.<br><br>
<b>Import/Export Product Database</b>:  The product database is a pipe delimited text file, so you can download (as is or use the Database manager for more conversions) and edit it in a text editor, a spreadsheet, etc.  for tips on how to perform product database imports/exports, see the online manual at: <a href="http://www.agoracart.com/agorawiki/index.php?title=Database_V5" target="_new">http://www.agoracart.com/agorawiki/index.php?title=Database_V5</a></font></blockquote>
</form>
</body>
</html>~;
return $form;
}
############################################################################
sub edit_item_form_new {
local ($form,$msg,$imgup)="";
my ($dimension_row,$alternate_origin_row)="";

if ($mc_file_upload_ok =~ /yes/) { # allow images to be uploaded
  $imgup = qq~<tr><td colspan=4>Upload Image File(s): 
           <input type=file name=upfile1 size=20> &nbsp;&nbsp; 
           <input type=file name=upfile2 size=20><br>
            &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp;<input type=file name=upfile3 size=20> &nbsp;&nbsp; 
           <input type=file name=upfile4 size=20> &nbsp;&nbsp; 
           <input type=file name=upfile5 size=20><br>
           </td></tr>\n~;
 }
if ($sc_alt_origin_enabled =~ /yes/) { # allow alternate origins
  $alternate_origin_row = qq~<tr><td colspan=4><font FACE="ARIAL" SIZE="2">Alternate Shipping origins are enabled.  If this product is shipped from a different location than the original location within your shipping settings, then please enter the Zip/Postal Code and the State/Province this product is shipping from.  If not needed, leave blank.<br>
           Zip/Postal Code: <input type=text name="alt_origin_postalcode" size=16 value="$alt_origin_postalcode"> &nbsp;&nbsp; 
           State / Province: <input type=text name="alt_origin_stateprov" size=3 value="$alt_origin_stateprov"><br>
           </td></tr>\n~;
 }

if ($sc_dimensional_shipping_enabled =~ /yes/) { # allow dimensions per box
  $dimension_row = qq~<tr><td colspan=4><font FACE="ARIAL" SIZE="2">Shipping Dimensions are enabled.  Enter the length, width, height of the box. If using a non-rectangular package and not using a shipper supplied container, enter in the girth of the widest point perpendicular to the length of the package.  Select the packaging type as well.  If you use more than one shipping company for real-time quotes, do not select anything other than "your packaging".  <b>If this product is to be boxed with other items, leave these fields blank </b>(it will use defaults from the real-time shipping settings instead).<br>
Box Type: <select name="boxtype">
<option>$boxtype</option>
<option value="02">02 - UPS Your Packaging</option>
<option value="03">03 - UPS Tube (38" Long, posters &amp; prints)</option>
<option value="RECTANGULAR">USPS Your Packaging - Rectangular</option>
<option value="NONRECTANGULAR">USPS Your Packaging - Non-Rectangular</option>
<option value="FLAT RATE BOX">USPS Flat Rate Box - Priority Mail Only</option>
<option value="FLAT RATE ENVELOPE">USPS Flat Rate Envelope</option>
      <option value='RECTANGULARPACKAGING'>Your Packaging (rectagular for any shipper)</option>
<option value="">None</option>
</select> &nbsp;&nbsp;
           Length: <input type=text name=length size=3 value=$length> &nbsp;&nbsp; 
           Width: <input type=text name=width size=3 value=$width> &nbsp;&nbsp; 
           Height: <input type=text name=height size=3 value=$height> &nbsp;&nbsp;
           Girth: <input type=text name=girth size=3 value=$girth><br>
           </td></tr>\n~;
 }

$form = qq~<HTML>
<HEAD>
<TITLE>Edit Product $sku</TITLE>
</HEAD>
<BODY BGCOLOR=WHITE>
<BODY BGCOLOR=WHITE>
<form METHOD="POST" ACTION="manager.cgi" enctype="multipart/form-data">
  <div align="center"><center><table BORDER="0" CELLPADDING="0"
CELLSPACING="0" WIDTH="755">
    <tr><td><table border=0 cellpadding=2 ><tr>
     <td colspan=3 width="80%"><strong> $manager_banner_main 
Quick Edit</strong>&nbsp;&nbsp;&nbsp;$msg</td>
<td><INPUT TYPE=SUBMIT NAME="skip_edit_screen" 
     VALUE="Skip This Record - Done"><INPUT TYPE=HIDDEN NAME="first"
VALUE="$in{'first'}"></td>
    </tr></table></td>
    </tr>
<tr><td colspan=4><table BORDER="1" CELLPADDING="2" CELLSPACING="0"
WIDTH="755">  
    <tr>
      <td colspan="1" width="30%"><font FACE="ARIAL" SIZE="2"><b>PRODUCT
      ID # $sku</b><br><small>(change ID to save as NEW record)</small></font><br>&nbsp;&nbsp;<input 
      NAME="new_sku" VALUE="$sku" TYPE="TEXT" SIZE="10" MAXLENGTH="10"></td>
      <td colspan="2" width="40%"><div align="left"><table border="0" cellpadding="0"
      cellspacing="0">
        <tr>
          <td><font FACE="ARIAL" SIZE="2"><b>Price</b><br><small>Do not enter currency symbol</small></font></td>
          <td>&nbsp; <input NAME="price" SIZE="10" MAXLENGTH="10"
           value="$price"></td>
        </tr>
        <tr>
          <td colspan=2><font FACE="ARIAL" SIZE="2"><hr></td>
        </tr>
        <tr>
          <td><font FACE="ARIAL" SIZE="2"><b>Shipping Price or Weight</b><br>(weight only if using SBW module)<br><small>Do not enter anything but the shipping price or weight in numerical form.<br>Leave completely blank if no price or weight needed for this product</small></font></td>
          <td>&nbsp; <input NAME="shipping_price" SIZE="10" MAXLENGTH="10"
           value="$shipping_price"></td>
        </tr>
      </table>
      </div></td>
      <td width="30%"><font FACE="ARIAL" SIZE="2"><b>Option File</b><br><small>choose from the list of files in the options directory, usually html/options sub-directory of the store</small><br>
      </font><select NAME="option_file" size="1">
        <option>$options</option>
$options_file_list
      </select> </td>
    </tr>
$alternate_origin_row
$dimension_row
    <tr>
      <td colspan=1><font FACE="ARIAL" SIZE="2"><b>Category</b><br><small>spaces & dashes okay. 50 characters max.</small></font><br><input NAME="category" TYPE="TEXT" SIZE="25"
        MAXLENGTH="50" value="$category"></td>
      <td colspan=2><font FACE="ARIAL" SIZE="2"><b>Product Name</b><br><small>4 to 8 words. 70 characters max.  No quote marks allowed</small></font><br>
        <input NAME="name" TYPE="TEXT" SIZE="35" MAXLENGTH="70"
       value="$short_description"></td>
      <td colspan=1><font FACE="ARIAL" SIZE="2"><b>Image File</b><br><small>use format of: name.gif (or .jpg / .png). 85 max characters. Case Sensitive, names must match! Do not enter path, name only.</small></font><br>
      <input NAME="image" TYPE="TEXT" SIZE="25" MAXLENGTH="85"
       value="$image"></td>
    </tr>
$imgup
    <tr> 
      <td colspan="4" width="100%"><div align=center><table
        cellpadding="1" cellspacing="0">
        <tr>
          <td><font FACE="ARIAL" 
            SIZE="2"><b>Description</b> - Enter the
            Text &amp; HTML describing the product. </font><br>
            <textarea NAME="description" ROWS="10" COLS="85" 
            wrap="soft">$long_description</textarea></td>
        </tr>
      </div></table></td>
    </tr>
    <tr>
      <td colspan="2" width="50%"><font face="ARIAL" size="2" color="RED">*2nd Image: </font><input
      value='$userDefinedOne' 
      NAME="userDefinedOne" SIZE="35" MAXLENGTH="256" style="font-family: Courier, monospace"></td>
      <td colspan="2" width="50%"><font face="ARIAL" size="2" color="RED">$user2: </font><input
      value='$userDefinedTwo'
      NAME="userDefinedTwo" SIZE="35" MAXLENGTH="256" style="font-family: Courier, monospace"></td>
    </tr>
    <tr>
      <td colspan="2" width="50%"><font face="ARIAL" size="2" color="RED">$user3: </font><input
      value='$userDefinedThree' 
      NAME="userDefinedThree" SIZE="35" MAXLENGTH="256" style="font-family: Courier, monospace"></td>
      <td colspan="2" width="50%"><font face="ARIAL" size="2" color="RED">$user4: </font><input
      value='$userDefinedFour' 
      NAME="userDefinedFour" SIZE="35" MAXLENGTH="256" 
      style="font-family: Courier, monospace"></td>
    </tr>
    <tr>
      <td colspan="2" width="50%"><font face="ARIAL" size="2" color="RED">$user5: </font><input
      value='$userDefinedFive' 
      NAME="userDefinedFive" SIZE="35" MAXLENGTH="256" style="font-family: Courier, monospace"></td>
      <td colspan="2" width="50%">&nbsp;&nbsp; <INPUT TYPE=SUBMIT 
      NAME="SubmitEditProduct" VALUE="Submit Edit">&nbsp;&nbsp;&nbsp;
      <input TYPE="RESET" VALUE="Undo Edit">
      <INPUT TYPE=HIDDEN NAME=save_category VALUE="$in{'category'}">
      <INPUT TYPE=HIDDEN NAME="ProductEditSku" VALUE="$sku"></td>
    </tr>
  </table></td></tr>
  </table></center></div>
<blockquote><font face=arial size=2>
<b>QUICK HELP & TIPS</b><br><br>
Change userfield titles displayed in Add Product and Edit Product screens <a href=manager.cgi?rename_userfields_screen=yes>here</a>
<br><br>
For help, see the online manual regarding editing/adding of products in your database using the online manager interface at: <a href="http://www.agoracart.com/agorawiki/index.php?title=Adding_Products_to_Your_Store_V5" target="_new">http://www.agoracart.com/agorawiki/index.php?title=Adding_Products_to_Your_Store_V5</a><br><br>
<b>Use the least amount of text as possible in each field</b>.  Shorten names a much as possible. The shorter and/or less text you use, the faster and more efficient your store will run.<br><br>
<b>Remember all entries are case sensitive</b> and will cause errors if even one character is wrong in case (capitals or small caps).<br><br>
*<b>2nd image</b>: This is the image used in the cart contents displayed (view cart, checkout, etc).  Leave blank if not using images in cart contents layout (see cart layout manager).  If using this image, use <b>%%img%%</b> in front of the image name for auto-built images for the image displayed ( example: %%img%%small_imagename.jpg).  Use smaller images, no larger than approx 40-70 pixels in width and/or height, or your cart contents displays will look really terrible and skew your layouts.<br><br>
**<b>sub categories</b>:  if using sub categories, indicate sub category name in a userfield that is open (make sure this is setup in the main store settings/setups screen).  If you need more than one sub category for the product, separate sub category names with two colons ( :: ).  Spaces are acceptable in sub category names.<br><br>
***<b>Option Files</b> can be created in a text editor. You can also download manager add-ons for creating options at the AgoraCart.com or "members only" download sections.<br><br>
<b>Import/Export Product Database</b>:  The product database is a pipe delimited text file, so you can download (as is or use the Database manager for more conversions) and edit it in a text editor, a spreadsheet, etc.  for tips on how to perform product database imports/exports, see the online manual at: <a href="http://www.agoracart.com/agorawiki/index.php?title=Database_V5" target="_new">http://www.agoracart.com/agorawiki/index.php?title=Database_V5</a>
  </font></blockquote>
</form>
</body>
</html>~;
return $form;
}
############################################################################
sub edit_product_screen
{

local ($message,@categories,$cat_str,$inx);
local ($helper,$helper_top,$helper_bot);

print &$manager_page_header("Edit Product","","","","");

if ($in{'skip_edit_screen'} ne "") {
  $edit_error_message = "Record $in{'ProductEditSku'} Skipped.";
  $in{'ProductEditSku'} = "";
  if ($in{'save_category'} ne "") {
    $in{'category'} = $in{'save_category'};
   }
 }

if ($in{'category'} ne "") {
  $message = qq~Click a button for the ID number under the "Item # to Edit" column to make changes to an individual product listing in your catalog.<br><br><a href="manager.cgi?edit_screen=yes&">Click here</a> to display the categories in your catalog/database.~;
 } else {
  $message = "Click below to select the category to display."; 
 }

@categories = &get_prod_db_category_list;
$cat_str = '';
foreach $inx (@categories) {
  $cat_str .= "<OPTION>$inx</OPTION>\n";
 }

if (($mc_put_edit_helper_at_top =~ /yes/i) ||
    ($mc_put_edit_helper_at_bot =~ /yes/i)) {
$helper = qq~
<HR>
<TABLE WIDTH=100% BORDER=0 CELLPADDING=0 CELLSPACING=0>
<TR>
<TD WIDTH=40%>
<FORM METHOD="POST" ACTION="manager.cgi">
<CENTER>
<INPUT TYPE=SUBMIT NAME=Helper VALUE="Edit Item -->">
<input type=text name="EditWhichProduct" size=12>
<INPUT TYPE=HIDDEN NAME=category VALUE="$in{'category'}">
<INPUT TYPE=HIDDEN NAME=EditProduct VALUE="Edit">
</CENTER>
</FORM>
</TD>
<TD WIDTH=60%>
<FORM METHOD="POST" ACTION="manager.cgi">
<CENTER>
<INPUT TYPE=SUBMIT NAME="edit_screen" 
         VALUE="Show Category -->">
<SELECT NAME=category>$cat_str</SELECT>
</CENTER>
</FORM>
</TD>
</TR>
</TABLE>
~;
}

if ($mc_put_edit_helper_at_top =~ /yes/i) {
  $helper_top = $helper;
 }
if ($mc_put_edit_helper_at_bot =~ /yes/i) {
  $helper_bot = $helper;
 }

print <<ENDOFTEXT;
<CENTER>
<HR WIDTH=550>
</CENTER>

<CENTER>
<TABLE WIDTH=550>
<TR>
<TD WIDTH=550>
<FONT FACE=ARIAL>
This is the Edit-A-Product screen of the <b>AgoraCart</b> product manager. 
$message $helper_top<hr></td></TR>
</TABLE>
</CENTER>

ENDOFTEXT

if ($in{'ProductEditSku'} ne "")
{
print <<ENDOFTEXT;
<CENTER>
<TABLE WIDTH=550 BORDER=0>
<CENTER>
<TR WIDTH=550 BORDER=0>
<TD WIDTH=550 BORDER=0>
<CENTER><FONT FACE=ARIAL SIZE=2 COLOR=RED>
Product ID \# $in{'ProductEditSku'} successfully edited</FONT></CENTER>
</TD>
</TR>
</CENTER>
</TABLE>
</CENTER>
ENDOFTEXT
}

if ($edit_error_message ne "")
{
print <<ENDOFTEXT;
<CENTER>
<TABLE WIDTH=550 BORDER=0>
<CENTER>
<TR WIDTH=550 BORDER=0>
<TD WIDTH=550 BORDER=0>
<CENTER><FONT FACE=ARIAL SIZE=2 COLOR=RED>
$edit_error_message</FONT></CENTER>
</TD>
</TR>
</CENTER>
</TABLE>
</CENTER>
ENDOFTEXT
}

if ($conv_result ne "")
{
print <<ENDOFTEXT;
<CENTER>
<TABLE WIDTH=550 BORDER=0>
<CENTER>
<TR WIDTH=550 BORDER=0>
<TD WIDTH=550 BORDER=0>
<CENTER><FONT FACE=ARIAL SIZE=2 COLOR=RED>$conv_result</FONT></CENTER>
</TD>
</TR>
</CENTER>
</TABLE>
</CENTER>
ENDOFTEXT
}

if ($in{'category'} ne "") {
 &display_items_in_category("Edit",
  "<b>Item # to Edit</b>",
  "Edit",
  "edit_screen");
 } else {
 &display_categories("edit_screen");
 }

print <<ENDOFTEXT;
<CENTER>
<TABLE WIDTH=550 BORDER=0 CELLPADDING=0>
<tr><td>
$helper_bot
<HR>
</td></tr>
</table>
</center>
ENDOFTEXT
print &$manager_page_footer;
}
#############################################################################################

sub delete_product_screen
{
local ($message,$my_script, $my_body_tag);

$my_body_tag = $mc_standard_body_tag;
if ($in{'category'} ne "") {
  $my_body_tag .= ' onLoad="WarnDelete()"';
 }

$my_script = qq~
<SCRIPT>
function WarnDelete()
{
alert("CAREFUL! Clicking  Delete will immediately remove a product from the database");
}
</SCRIPT>~;

print &$manager_page_header("Delete Product",$my_script,$my_body_tag,"","");

if ($in{'category'} ne "") {
  $message ='<a href="manager.cgi?delete_screen=yes&">' .
  'Click here</a> to display the categories in your catalog.';
 } else {
  $message = "Click below to select the category to display."; 
 }

print <<ENDOFTEXT;
<CENTER>
<HR WIDTH=500>
</CENTER>

<CENTER>
<TABLE WIDTH=500>
<TR>
<TD WIDTH=500>
<FONT FACE=ARIAL COLOR=RED>
WARNING!</FONT>
<FONT FACE=ARIAL>Clicking an <b>'Item # to Delete'</b> button will 
IMMEDIATELY remove that product from your catalog. &nbsp;You've been warned!
<br>$message</TD>
</TR>
</TABLE>
</CENTER>

<CENTER>
<HR WIDTH=500>
</CENTER>

ENDOFTEXT

if ($in{'DeleteWhichProduct'} ne "")
{
print <<ENDOFTEXT;
<CENTER>
<TABLE WIDTH=550 BORDER=0>
<CENTER>
<TR WIDTH=550 BORDER=0>
<TD WIDTH=550 BORDER=0>
<CENTER><FONT FACE=ARIAL SIZE=2 COLOR=RED>
Product ID \# $in{'DeleteWhichProduct'} successfully
deleted</FONT></CENTER>
</TD>
</TR>
</CENTER>
</TABLE>
</CENTER>
ENDOFTEXT
}

if ($in{'category'} ne "") {
 &display_items_in_category(
        "Delete",
        "<B><FONT COLOR=RED>Item # to Delete</FONT></B>",
        "Delete",
        "delete_screen");
 } else {
 &display_categories("delete_screen");
 }

print <<ENDOFTEXT;
<CENTER>
<TABLE WIDTH=550 BORDER=0 CELLPADDING=0>
<tr><td><HR></td></tr>
</table>
</center>
ENDOFTEXT
print &$manager_page_footer;

}
#############################################################################################
sub display_perform_edit_screen

{

$options_file_list = &make_file_option_list("./html/options","");

print &edit_item_form;

}
################################################################################
sub action_add_product
{
local($my_new_rec)="";
local($product_id,@db_row);
local($found_it)="";
local($mode,$in_sku);
local($sku, $category, $price, $short_description, $image, 
      $long_description, $shipping_price, $userDefinedOne, 
      $userDefinedTwo, $userDefinedThree, $userDefinedFour,
      $userDefinedFive, $options);


$in_sku = $in{"sku"};
if (substr($in_sku,length($in_sku)-1,1) eq "*") {
  $in_sku = substr($in_sku,0,length($in_sku)-1);
  if ($in_sku eq "") {
    $mode = "";
   } else {
    $mode = &check_db_with_product_id($in_sku,*db_row);
   }
  if ($mode) { 
    $in_sku = &get_next_prod_key;
   }
  $found_it = "";
 } else {
  $found_it = &check_db_with_product_id($in_sku,*db_row);
 }

if ($found_it) { 
  #print "sku already exists!"; 
  $add_product_status="no";
  &add_product_screen($add_product_status);
  &call_exit;
 }

$formatted_description = $in{'description'};
$formatted_description =~ s/\r/ /g;
$formatted_description =~ s/\t/ /g;
$formatted_description =~ s/\n/ /g;
$formatted_description =~ s/\s+/ /g;

$in{'name'} =~ s/\"//g;
$in{'name'} =~ s/\'//g;
$in{'name'} =~ s/\`//g;
&my_escape($in{'name'});

if ($in{'option_file'} ne "")

{
  if (-e "./html/options/$in{'option_file'}")
  {
  $formatted_option_file = "\%\%OPTION\%\%$in{'option_file'}";
  }
  else
  {
  $formatted_option_file = "\%\%OPTION\%\%blank.html";
  }
}

else

{
$formatted_option_file = "\%\%OPTION\%\%blank.html";
}

# NO Multiple BLANKS ALLOWED!  No tabs, newlines or carriage returns
$in{'category'} =~ s/\s+/ /g; 
my @arrayThing = (name,category,userDefinedOne,userDefinedTwo,userDefinedThree,userDefinedFour,userDefinedFive);
foreach $arrayThing (@arrayThing) {
    $in{$arrayThing} =~ s/\s+/ /g;
    $in{$arrayThing} =~ s/\r//g;
    $in{$arrayThing} =~ s/\t//g;
    $in{$arrayThing} =~ s/\n//g;
}

# NO BLANKS OR WHITESPACE ALLOWED!
my @arrayThing2 = (sku,price,shipping_price,image);
foreach $arrayThing2 (@arrayThing2) {
    $in{$arrayThing2} =~ s/\s//g;
}

$image = $in{'image'};
if ($image eq "") {
  $image = "notavailable.gif";
 }
$formatted_image = &create_image_string($image);


if ($in{'category'} eq "") {
  $in{'category'} = "*Nameless*";
 }

$my_new_rec = "$in_sku|$in{'category'}|$in{'price'}|$in{'name'}" .
   "|$formatted_image|$formatted_description|$in{shipping_price}" .
   "|$in{'userDefinedOne'}|$in{'userDefinedTwo'}" .
   "|$in{'userDefinedThree'}|$in{'userDefinedFour'}" .
   "|$in{'userDefinedFive'}|$formatted_option_file";

&add_new_record_to_prod_db($my_new_rec);

$add_product_status="yes";
&category_list_builder_for_store;
&add_product_screen($add_product_status);

}
################################################################################
sub display_catalog_screen{
 $in{'category'}="";
 &edit_product_screen;
}
################################################################################
sub action_edit_product
{
  
local($sku, $category, $price, $short_description, $image, 
      $long_description, $shipping_price, $userDefinedOne, $userDefinedTwo, 
      $userDefinedThree, $userDefinedFour, $userDefinedFive, 
      $options);
local($product_id,$found_it,@db_row,$raw_data);

$found_it = &get_prod_db_row($in{'EditWhichProduct'},*db_row, *raw_data, "no");

($sku, $category, $price, $short_description, $image, 
 $long_description, $shipping_price, $userDefinedOne, 
 $userDefinedTwo, $userDefinedThree, $userDefinedFour, 
 $userDefinedFive, $options) = split(/\|/,$raw_data);

chomp($options);

if ($sku ne $in{'EditWhichProduct'}) {
  if ($found_it) {
    $long_description = "Error, expected sku of $in{'EditWhichProduct'}, " 
  . "found $sku instead!";
  }
  $sku = $in{'EditWhichProduct'};
 } 

$options =~ s/%%OPTION%%//g;
$image =~ s/.*%%URLofImages%%\///g;
$image =~ s/.png.*/.png/g;
$image =~ s/.gif.*/.gif/g;
$image =~ s/.jpg.*/.jpg/g;
($image,$junkjunkjunk)=split(/\"/,$image,2); # safety net

&display_perform_edit_screen;


}

################################################################################
sub action_submit_edit_product
{
local($sku, $category, $price, $short_description, $image, 
  $long_description, $shipping_price, $userDefinedOne, 
  $userDefinedTwo, $userDefinedThree, $userDefinedFour, 
  $userDefinedFive, $options);
local($temp);
my($boxindicator);


$formatted_description = $in{'description'};
$formatted_description =~ s/\r/ /g;
$formatted_description =~ s/\t/ /g;
$formatted_description =~ s/\n/ /g;
$formatted_description =~ s/\s+/ /g;

$in{'name'} =~ s/\"//g;
$in{'name'} =~ s/\'//g;
$in{'name'} =~ s/\`//g;
&my_escape($in{'name'});


if ($in{'option_file'} ne "")

{
  if (-e "./html/options/$in{'option_file'}")
  {
  $formatted_option_file = "\%\%OPTION\%\%$in{'option_file'}";
  }
  else
  {
  $formatted_option_file = "\%\%OPTION\%\%blank.html";
  }
}

else

{
$formatted_option_file = "\%\%OPTION\%\%blank.html";
}


# NO Multiple BLANKS ALLOWED!  No tabs, newlines or carriage returns
$in{'category'} =~ s/\s+/ /g; 
my @arrayThing = (name,category,userDefinedOne,userDefinedTwo,userDefinedThree,userDefinedFour,userDefinedFive);
foreach $arrayThing (@arrayThing) {
    $in{$arrayThing} =~ s/\s+/ /g;
    $in{$arrayThing} =~ s/\r//g;
    $in{$arrayThing} =~ s/\t//g;
    $in{$arrayThing} =~ s/\n//g;
}

# NO BLANKS OR WHITESPACE ALLOWED!
my @arrayThing2 = (new_sku,price,shipping_price,image,alt_origin_postalcode,alt_origin_stateprov,height,width,length,girth);
foreach $arrayThing2 (@arrayThing2) {
    $in{$arrayThing2} =~ s/\s+//g;
}

$image = $in{'image'};
if ($image eq "") {
  $image = "notavailable.gif";
 }
$formatted_image = &create_image_string($image);

if ($in{'category'} eq "") {
  $in{'category'} = "*Nameless*";
 }

$raw_line =  
 "$in{'ProductEditSku'}|$in{'category'}|$in{'price'}|$in{'name'}" .
 "|$formatted_image|$formatted_description|$in{'shipping_price'}" .
 "|$in{'userDefinedOne'}|$in{'userDefinedTwo'}|$in{'userDefinedThree'}" .
 "|$in{'userDefinedFour'}|$in{'userDefinedFive'}|$formatted_option_file";

if (substr($in{'new_sku'},length($in{'new_sku'})-1,1) eq "*") {
  $temp = substr($in{'new_sku'},0,length($in{'new_sku'})-1);
  if (($in{'new_sku'} eq "*") || ($temp ne $in{'ProductEditSku'})) {
    if ($temp ne "") { #test if it is there first ...
      $found_it = &check_db_with_product_id($temp,*db_row);
      if ($found_it) { 
  $in{'new_sku'} = &get_next_prod_key;
       } else {
  $in{'new_sku'} = $temp;
       }
     } else {
      $in{'new_sku'} = &get_next_prod_key;
     }
   } else { 
    $in{'new_sku'} = $temp;
   }
 }

if (($in{'new_sku'} eq "") || ($in{'new_sku'} eq $in{'ProductEditSku'})) {
  $result = &put_prod_db_raw_line($in{'ProductEditSku'},$raw_line,"no");
 } else { # new product
  $found_it = &check_db_with_product_id($in{'new_sku'},*db_row);
  if ($found_it) {
    $in{'ProductEditSku'}="";
    $edit_error_message="Sorry, that item (" . $in{'new_sku'} .
                        ") is already in the database.";
    $edit_error_message.= "&nbsp; Hit browser BACK BUTTON to re-edit.";
   } else {
    $in{'ProductEditSku'}=$in{'new_sku'};
    $edit_error_message="(NOTE: That item was ADDED to the database)";
    $raw_line =  
      "$in{'ProductEditSku'}|$in{'category'}|$in{'price'}|$in{'name'}" .
      "|$formatted_image|$formatted_description|$in{'shipping_price'}" .
      "|$in{'userDefinedOne'}|$in{'userDefinedTwo'}|$in{'userDefinedThree'}" .
      "|$in{'userDefinedFour'}|$in{'userDefinedFive'}|$formatted_option_file";
    &add_new_record_to_prod_db($raw_line);
   }
 }

if (($sc_alt_origin_enabled =~ /yes/i)||($sc_dimensional_shipping_enabled =~ /yes/i)) {
    if (($in{'length'} ne '') && ($in{'width'} ne '') && ($in{'height'} ne '')) {
       $boxindicator = "yes";
    }

# NO BLANKS OR WHITESPACE ALLOWED!
my @arrayThing3 = (alt_origin_postalcode,alt_origin_stateprov,height,width,length,girth);
foreach $arrayThing3 (@arrayThing3) {
    $in{$arrayThing3} =~ s/\s+//g;
}

    my $raw_line2 =  
      "$in{'ProductEditSku'}|$boxindicator|$in{'length'}|$in{'width'}" .
      "|$in{'height'}|$in{'girth'}|$in{'boxtype'}|$in{'alt_origin_postalcode'}" .
      "|$in{'alt_origin_stateprov'}";
    my $result2 = &put_prod_dimensions_raw_line($in{'ProductEditSku'},$raw_line2);
}

$in{'category'} = $in{'save_category'}; 
&category_list_builder_for_store;
&edit_product_screen;

### End
}
################################################################################

sub action_delete_product
{

&del_prod_from_db($in{'DeleteWhichProduct'});

&category_list_builder_for_store;

&delete_product_screen;

}
#########################################################################
sub action_submit_edit_userfields {
local($myset)="";

&ReadParse;


my $tempthingy = 2;
while ($tempthingy <= $sc_userfields_available) {
my $tempthingy2 = "user" . "$tempthingy";
if ($in{$tempthingy2} ne "") {
    $myset .= "\$$tempthingy2 = \"$in{$tempthingy2}\";\n";
    $$tempthingy2 = $in{$tempthingy2};
} else {
    $myset .= "\$$tempthingy2 = \"User $tempthingy\";\n";
}
$tempthingy++
}


&update_userfield_names('$sc_userfieldsfile',$myset);
  &display_user_naming_screen;
 }
################################################################################
sub update_userfield_names {
  local($item,$stuff) = @_;
  $pass_file_settings{$item} = $stuff;
local($pass_settings) = "$mgrdir/misc/userfields.pl";
  local($item,$zitem);

  &get_file_lock("$pass_settings.lockfile");
  open(PASSFILE,">$pass_settings") || &my_die("Can't Open $pass_settings");
  foreach $zitem (sort(keys %pass_file_settings)) {
    $item = $zitem;
     print (PASSFILE $pass_file_settings{$zitem});
   }
  close(PASSFILE);
  &release_file_lock("$pass_settings.lockfile");
&require_supporting_libraries(__FILE__,__LINE__,
  "$mgrdir/misc/userfields.pl");
 }
#######################################################################################
sub display_user_naming_screen {

local($filename)="$mgrdir/";
print &$manager_page_header("User Field Name Editor","","","","");



print <<ENDOFTEXT;
<CENTER>
<HR>
</CENTER>

<FORM ACTION="manager.cgi" METHOD="POST">
<CENTER>
<TABLE>
<TR>
<TD>
<FONT FACE=ARIAL size=2>Welcome to the <b>AgoraCart</b>  Database UserField Names Editor.  This area allows you to changes the names of the database userfields as they are dsplayed in the Add Product and Edit Product screens.  This does not change the names of the user fields anywhere else.</center></TD>
</TR>
</TABLE>
</CENTER>

ENDOFTEXT

if($in{'system_edit_success'} ne "")
{
print <<ENDOFTEXT;
<CENTER><br>
<TABLE>
<TR>
<TD>
<FONT FACE=ARIAL SIZE=2 COLOR=RED>UserField names have been 
successfully updated.</FONT>
</TD>
</TR>
</TABLE>
</CENTER>
ENDOFTEXT
}

print qq~
<br>
<FORM ACTION="manager.cgi" METHOD="POST">
   <div align="center">
   <table border="0" cellspacing="0">
<TR>
<TD>
~;

my $tempthingy = 2;
while ($tempthingy <= $sc_userfields_available) {
my $tempthingy2 = "user" . "$tempthingy";
print qq~
New Name for $tempthingy2 (30 characters max): &nbsp;&nbsp;
<INPUT NAME="$tempthingy2" TYPE="TEXT" SIZE=30 
MAXLENGTH="30" VALUE="$$tempthingy2"><br>
~;
$tempthingy++
}
print qq~
</TD>
</TR>
   </table>

   </div>
   <p align="center">&nbsp;</p>
   <p align="center"><font face="Arial"><INPUT TYPE="HIDDEN" NAME="system_edit_success" value="yes">
<INPUT NAME="SubmitEditUserfields" TYPE="SUBMIT" value="Submit">
&nbsp;&nbsp;
<INPUT TYPE="RESET" value="Reset"></font></p>
   </form>
~;
print &$manager_page_footer;
}
############################################################
#
# get a row from the product shipping dimensions database.
# added by Mister Ed May 17, 2007
#
############################################################

sub get_prod_shipping_dimensions_in_db_row_for_edit {
  my ($product_id) = @_;
  my ($db_product_id,$save_the_line,$filename,$result);
  my ($sku,$boxindicator,$length,$width,$height,$girth,$boxtype,$alt_origin_postalcode,$alt_origin_stateprov);
  $db_product_id = "";
                #
                # First we open the data file.
                # If the open fails. We call the
                # file open error routine in order
                # to log the error
                #

  open(DATAFILE, "$mc_shipfilename") || &file_open_error("$mc_shipfilename",
      "Read Dimensions Database",__FILE__,__LINE__);

  while (($line = <DATAFILE>) && ($product_id ne $db_product_id)) {
    chomp($line);
    ($sku,$boxindicator,$length,$width,$height,$girth,$boxtype,$alt_origin_postalcode,$alt_origin_stateprov) = split(/\|/,$line);
    $save_the_line = $line;
    $db_product_id = $sku;
  }

  if ($product_id eq $db_product_id) { 
	$result = "$save_the_line";
  }
  close (DATAFILE);

  return $result;

} 
######################################################################################
sub put_prod_dimensions_raw_line {
  my($product_id, $db_raw_line) = @_;
  local($result,$db_product_id,$ProductEditSku)='';
  my($junk, $line, @lines);
                #
                # First we open the data file.
                # If the open fails. We call the
                # file open error routine in order
                # to log the error
                #
#Note: could check to see if $product_id and $ProductEditSku match!
($ProductEditSku,$junk) = split(/\|/,$db_raw_line,2);
 
&get_file_lock("${mc_shipfilename}.lock");
open(OLDFILE, "$mc_shipfilename") || &my_die("Can't Open $mc_shipfilename");
@lines = <OLDFILE>;
#print @lines;
close (OLDFILE);
open(NEWFILE,">$mc_shipfilename") || &my_die("Can't Open $mc_shipfilename");

foreach $line (@lines){
  chomp $line;
  ($ProductEditSku, $junk) = split(/\|/,$line,2);

  if ($ProductEditSku eq $product_id) {
   print NEWFILE $db_raw_line . "\n";
   $result=1;
  } else {
   print NEWFILE $line . "\n";
  }
 }

if ($result ne 1 ) {
  print NEWFILE $db_raw_line . "\n";
  $result=1;
 }

close (NEWFILE);
&release_file_lock("${mc_shipfilename}.lock");


return $result;

} # End of put_prod_db_raw_line 

############################################################
1; # Library
