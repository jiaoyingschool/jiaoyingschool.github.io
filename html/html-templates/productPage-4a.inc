<!--agorascript-pre
{
#	This file allows you to have any number of 
# rows by setting the following variable
$ags_across = 4; # Number in a row

$ags_row_wd=int(100.0/$ags_across);
local ($myans)="";
if ($rowCount == (1+$minCount)) { #first one
  $ags_row_item=0;
  $ags_row_nmbr=0;
  $ags_tot_item=0;
  $myans .= '<tr><td colspan="3"><table width="100%" border="1">'."\n";
 }
$ags_row_item++;
$ags_tot_item++;
if ($ags_row_item > 1) { # last one
  if ($ags_row_item == $ags_across) {
    $ags_row_item=0; #reset counter
    $ags_row_nmbr++;
    }
  $myans .= '<td width="'.$ags_row_wd.'%" valign="top">';
 } else { #first one
  $myans .= '<tr><td width="'.$ags_row_wd.'%" valign="top">';
 }
$myans.=qq~<form method="post" action="%%scriptURL%%" rel="nofollow">
%%make_hidden_fields%%
<table width="100%">
~;
return $myans;
}
-->
<tr><td class="ac_product_image">%%image%%</td></tr>
<tr><td>
		<h3 class="ac_product_name">Product: %%ProductID%%</h3>
		<p class="ac_product_desc"><span class="ac_product_price">%%price%%</span><br/>
			<a href="%%scripturl%%?cart_id=&amp;p_id=%%ProductID%%&amp;xm=on&amp;ppinc=search2">More Info</a></p>
	</td></tr>
<!--agorascript-pre
{
local ($myans)="";
if ($ags_row_item == 0) { # last one
  $myans .= '</table></form></td></tr>'."\n";
 } else { # first one
  $myans .= '</table></form></td>'."\n";
 }
if (($rowCount == ($maxCount)) || ($rowCount == ($num_returned)))
 { # very last one
  if (!($ags_row_item == 0)) { # finish the row
#    if ($ags_row_nmbr > 0) { # finish the row with blanks
      while ($ags_row_item <  $ags_across) {
        $ags_row_item++;
        $myans .= '<td width="'.$ags_row_wd.'%">&nbsp; </td>';
       }
#     }
    $myans .= '</tr>'."\n";
   }
  $myans .= '</table></td></tr>'."\n";
 }
return $myans;
}
-->
