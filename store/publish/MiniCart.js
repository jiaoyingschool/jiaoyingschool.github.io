function DisplayMiniCart(name,style,icon) {
var cookies=document.cookie;  //read in all cookies
var start = cookies.indexOf("ss_cart_0001510433="); 
var cartvalues = "";
var linecount = 0;
var start1;
var end1;
var tmp;

document.write("<div class=\"MiniCart\">");
if ((start == -1) && (style == "Summary"))  //No cart cookie
{
  document.write("<a class=\"mini-txt\" href=\"http://shopsite.ipower.com/ss11.2/sc/order.cgi?storeid=*14894f26aa4140a700d52a22&amp;function=show\">Your Shopping Cart<\/a>");
  document.write("<span class=\"clear mini_contains\">Contains <b>0<\/b> Items</span>");
}
else if ((start == -1) && (style == "Detail"))  //No cart cookie
{
  document.write("<a class=\"mini-txt\" href=\"http://shopsite.ipower.com/ss11.2/sc/order.cgi?storeid=*14894f26aa4140a700d52a22&amp;function=show\">Your Shopping Cart<\/a>");
  document.write("<span class=\"clear mini_contains\">Contains <b>0<\/b> Items</span>");
}
else if (start == -1) {
  if (icon == "white")
  {
    document.write("<a class=\"mini-icon\" href=\"http://shopsite.ipower.com/ss11.2/sc/order.cgi?storeid=*14894f26aa4140a700d52a22&amp;function=show\"><img src=\"https://jiaoying.ipower.com/store/media/themesmedia/cart-white.gif\" border=\"0\" alt=\"cart\" align=\"top\"><\/a> ");
  }
  else
  {
    document.write("<a class=\"mini-icon\" href=\"http://shopsite.ipower.com/ss11.2/sc/order.cgi?storeid=*14894f26aa4140a700d52a22&amp;function=show\"><img src=\"https://jiaoying.ipower.com/store/media/themesmedia/cart-black.gif\" border=\"0\" alt=\"cart\" align=\"top\"><\/a> ");
  }
  document.write("<a class=\"mini-txt\" href=\"http://shopsite.ipower.com/ss11.2/sc/order.cgi?storeid=*14894f26aa4140a700d52a22&amp;function=show\">");
  document.write("0 Items");
  document.write("<\/a> ");
}
else   //cart cookie is present
{
  start = cookies.indexOf("=", start) +1;  
  var end = cookies.indexOf(";", start);  
  if (end == -1)
  {
    end = cookies.length;
  }
  cartvalues = unescape(cookies.substring(start,end)); //read in just the cookie data
  start = 0;
  while ((start = cartvalues.indexOf("|", start)) != -1)
  {
    start++;
    end = cartvalues.indexOf("|", start);
    if ((end != -1) && (style == "Detail"))
    {
      linecount++;
      if (linecount == 3)  // Product Subtotal
      {
        start1 = start;
        end1 = end;
        document.write("<a class=\"mini-txt\" href=\"http://shopsite.ipower.com/ss11.2/sc/order.cgi?storeid=*14894f26aa4140a700d52a22&amp;function=show\">Your Shopping Cart<\/a>");
        document.write("<table id=\"mini-detail\">");
        document.write("<tr><td class=\"mini-pr-txt\">Product<\/td>");
        document.write("<td class=\"mini-qt-txt\">Qty<\/td>");
        document.write("<td class=\"mini-pc-txt\">Price</td><\/tr>");
      }
      if (linecount > 3)  // individual products
      {
        tmp = cartvalues.substring(start,end);
        colon = tmp.indexOf(":", 0);
        document.write("<tr><td class=\"mini-pr\">");
        colon2 = tmp.indexOf(":", colon+1);
        document.write(tmp.substring(colon2+1,end - start));
        document.write("<\/td><td class=\"mini-qt\">");
        document.write(tmp.substring(0,colon));
        document.write("<\/td><td class=\"mini-pc\">");
        document.write(tmp.substring(colon+1,colon2));
        document.write("<\/td><\/tr>");
      }
    }
    else if (end != -1)
    {
      linecount++;
      if ((linecount == 2) && (style == "Summary")) // Total Quantity of Items
      {
        tmp = cartvalues.substring(start,end);
        colon = tmp.indexOf(":", 0);
        document.write("<a class=\"mini-txt\" href=\"http://shopsite.ipower.com/ss11.2/sc/order.cgi?storeid=*14894f26aa4140a700d52a22&amp;function=show\">Your Shopping Cart<\/a>");
        document.write("<br>Contains <b>");
        document.write(tmp.substring(colon+1,end - start));
        document.write("<\/b>");
        if ((tmp.substring(colon+1,end - start)) == 1 )
        {
          document.write(" Item");
        }
        else
        {
          document.write(" Items");
        }
      }
      else if (linecount == 2) // Total Quantity of Items
      {
        tmp = cartvalues.substring(start,end);
        colon = tmp.indexOf(":", 0);
          if (icon == "white")
          {
            document.write("<a class=\"mini-icon\" href=\"http://shopsite.ipower.com/ss11.2/sc/order.cgi?storeid=*14894f26aa4140a700d52a22&amp;function=show\"><img src=\"https://jiaoying.ipower.com/store/media/themesmedia/cart-white.gif\" border=\"0\" alt=\"cart\" align=\"top\"><\/a> ");
          }
          else
          {
            document.write("<a class=\"mini-icon\" href=\"http://shopsite.ipower.com/ss11.2/sc/order.cgi?storeid=*14894f26aa4140a700d52a22&amp;function=show\"><img src=\"https://jiaoying.ipower.com/store/media/themesmedia/cart-black.gif\" border=\"0\" alt=\"cart\" align=\"top\"><\/a> ");
          }
        document.write("<a href=\"http://shopsite.ipower.com/ss11.2/sc/order.cgi?storeid=*14894f26aa4140a700d52a22&amp;function=show\">");
        document.write(tmp.substring(colon+1,end - start));
        if ((tmp.substring(colon+1,end - start)) == 1 )
        {
          document.write(" Item");
        }
        else
        {
          document.write(" Items");
        }

        if (style == "ItemCount")
        {
          document.write("<\/a>");
        }
        else 
        {
          document.write(": ");
        }
      }

      if ((linecount == 3) && (style == "Subtotal"))  // Product Subtotal
      {
        tmp = cartvalues.substring(start,end);
        colon = tmp.indexOf(":", 0);
        document.write(tmp.substring(colon+1,end - start));
        document.write("<\/a>");
      }
      else if ((linecount == 3) && (style == "Summary")) // Product Subtotal
      {
        tmp = cartvalues.substring(start,end);
        colon = tmp.indexOf(":", 0);
        document.write("<br>Subtotal: <b>");
        document.write(tmp.substring(colon+1,end - start));
        document.write("<\/b>");
      }
      start = end;
    }
    else
      break;
    }
if (style == "Detail")
{
  document.write("<tr><td colspan=\"2\" class=\"mini-sub-txt\"><a class=\"mini-sub-txt\" href=\"http://shopsite.ipower.com/ss11.2/sc/order.cgi?storeid=*14894f26aa4140a700d52a22&amp;function=show\">Subtotal<\/a><\/td>");
  document.write("<td class=\"mini-sub\"><a href=\"http://shopsite.ipower.com/ss11.2/sc/order.cgi?storeid=*14894f26aa4140a700d52a22&amp;function=show\">");
  tmp = cartvalues.substring(start1,end1);
  colon = tmp.indexOf(":", 0);
  document.write(tmp.substring(colon+1,end1 - start1));
  document.write("<\/a><\/td><\/tr><\/table>");
}
  }
document.write("<\/div>");
}
