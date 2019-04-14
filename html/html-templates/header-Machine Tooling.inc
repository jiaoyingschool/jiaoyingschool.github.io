<!--BEGIN HEADER TABLE-->
<STYLE TYPE="text/css">
<!--
.templatehead_mainbackground{
  background-color : #0000FF;
  width :100%;
  padding: 0px;
  text-align: center;
  font-family : Verdana, Arial;
  color: #FFFFFF;
}
-->
</STYLE>
<table class="templatehead_mainbackground">
<tr>
  <td>
<!--agorascript-pre 
&capture_STDOUT; 
print qq~<font class="template_fonth1"><b>Tools-n-Gizmos.com</b></font>~;
print qq~<font class="template_fonth2"><br>A Custom Header for sample products</font>~;
&uncapture_STDOUT;  -->
  </td>
  <td class="ac_header_search">
    <form method="post" action="agora.cgi">
      <input type="hidden" name="cart_id" value="%%cart_id%%">
      <input type="text" name="keywords" size="20" maxlength="40">
      <input type="hidden" name="ppinc" value="search">
      <input type="submit" name="search_request_button" value="Search"> 
    </form>
  </td>
</tr>
</table>
<table class="ac_mainbody" cellpadding=0 cellspacing=0>
<tr>
  <td class="ac_left_nav">
  <h3>Shopping Categories:</h3>
<!--agorascript-pre { # code to list categories and/or sub categories
# updated for AgoraCart 5.x by Mister Ed Jan 11, 2005
# updated to fit CSS mods by Eric Welin Feb 02, 2005
local($sku,$category,$subcategory);
my ($catnumber,$catnumber2)= '';
local(%db_ele,%subcatarray)= ();
if (!($sc_db_lib_was_loaded =~ /yes/i)){ 
  &require_supporting_libraries (__FILE__, __LINE__, "$sc_db_lib_path"); 
}
&capture_STDOUT;
print "  <ul>";
if ($sc_use_database_subcats =~ /yes/i) {
  &get_prod_db_element($db{"product"},*db_ele);
  foreach $sku (sort (keys %db_ele)) {
    $catnumber = "";
    $category = $db_ele{$sku};
    %subcatarray = %{$db_ele{$category}};
    $category2 = $category;
    $category2=~s/ /%20/g;
    if ($sc_count_database_cats =~ /yes/i) {
      $catnumber = "(" . $db_ele2{$category} . ")";
    }
    print qq~\n    <li><a href="agora.cgi?cart_id=%%cart_id%%&amp;product=$category2" class="ac_left_links" title="$category">$category</a> $catnumber</li>~;
    foreach $subcategoryarray (sort(keys %subcatarray)) {
      $category3 = $subcategoryarray;
#      $category3=~s/ /%20/g;
      if ($sc_count_database_cats =~ /yes/i) {
        $catnumber2 = "(" . $db_ele{$category}->{$subcategoryarray} . ")";
      }
      print qq~\n    <li><a href="agora.cgi?cart_id=%%cart_id%%&amp;product=$category2&amp;user4=$category3" class="ac_left_sub_links" title="$category3">$category3</a> $catnumber2</li>~;
    }
  }
} else { 
  &get_prod_db_element($db{"product"},*db_ele);
  foreach $sku (keys %db_ele) {
    $category = $db_ele{$sku};
    $category_list{$category}++;
  }
  foreach $category (sort(keys %category_list)) {
    $category2 = $category;
    $category2=~s/_/ /g;
    print qq~\n    <li><a href="agora.cgi?cart_id=%%cart_id%%&amp;product=$category" class="ac_left_links" title="$category2">$category2</a></li>~;
  }
}
print "\n  </ul>";
&uncapture_STDOUT; }
-->
    <hr/>
    <form method="post" action="agora.cgi">
      <h3>
        Look For Gifts<br/>
        under this Price:<br/>
        <input type="hidden" name="cart_id" value="%%cart_id%%">
        $ <input type="text" name="query_price_high_range" size="6" maxlength="10"><br/>
        <input type="hidden" name="ppinc" value="search">
        <input type="submit" name="search_request_button" value=" Search ">
      </h3>
    </form>
    <hr/>
    <h3>Company Info:</h3>
<!--agorascript-pre 
&capture_STDOUT; 
&cartlinks;
print $cartlinks;
&uncapture_STDOUT;  -->
    
    <div id="ac_html_validator">
      <a href="http://validator.w3.org/check?uri=referer" target="_new">
        <img src="%%URLofImages%%/valid-html401.png"
          alt="Valid HTML 4.01!" height="31" width="88"></a>
    </div>
    
  </td>
  <td class="ac_content">
<!--agorascript-pre {
local (@my_cart_fields,$my_cart_row_number,$result);
local ($count,$price,$product_id,$quantity,$total_cost,$total_qty)=0;
if ((!(-f "$sc_cart_path"))||($sc_processing_order =~ /yes/i)) {return ""}
open (CART, "$sc_cart_path") || &file_open_error("$sc_cart_path",
 "display_cart_contents_in_header", __FILE__, __LINE__);
 while (<CART>)
  {
   $count++;
   chop;    
   @my_cart_fields = split (/\|/, $_);
   $my_cart_row_number = pop(@my_cart_fields);
   push (@my_cart_fields, $my_cart_row_number);
   $quantity = $my_cart_fields[0];
   $product_id = $my_cart_fields[1];
   $price = $my_cart_fields[$sc_cart_index_of_price_after_options]; 
   $total_cost = $total_cost + $quantity * $price;
   $total_qty = $total_qty + $quantity;
  } # End of while (<CART>)
close (CART);
if ($count > 0) {
  $result = '<div align="center"><table class="ac_cart_summary"><tr>' .
      '<td><a href="agora.cgi?dc=1&amp;%%href_fields%%' . 
      '">View Cart</a></td>' .
      "<td> Items in shopping cart: $total_qty\n" . 
      "<br/> Item cost subtotal:&nbsp; " . &display_price($total_cost) . 
      "</td>\n" .
      '<td><a href="%%StepOneURL%%?order_form_button.x=1&amp;%%href_fields%%' . 
      '">Check Out</a></td>' .
      "</tr></table></div>";
 } else {
  $result = "";
 }
 return $result;
}-->
<!--END HEADER TABLE-->
