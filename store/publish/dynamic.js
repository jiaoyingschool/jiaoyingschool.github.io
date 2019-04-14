function DisplayCart(name) {
  document.write("<a class=\"miniclear\" href=\"http://shopsite.ipower.com/ss11.2/sc/order.cgi?storeid=*14894f26aa4140a700d52a22&amp;function=show\" rel=\"nofollow\" title=\"Your Shopping Cart - JiaoYing's Shops\"><span class=\"cart-icon\">cart<\/span> [View Cart]<\/a>");
}
 jQuery(document).ready(function() {
                 var $parentDiv = $('#header-full');
                 var $childDiv = $('#placeholder');
                 var $navDivone = $('#menu-left');
                 var $navDivtwo = $('#menu-right');
                 var $contentDiv = $('#content');
                 $childDiv .css('height', $parentDiv.height());
                 $navDivone .css('margin-top', $parentDiv.height());
                 $navDivtwo .css('margin-top', $parentDiv.height());
                 $contentDiv .css('min-height', $navDivone.height());           
        });
