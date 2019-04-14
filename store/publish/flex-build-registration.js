
function DisplayLogName(name) {
  var cookies=document.cookie;
  var start = cookies.indexOf(name + "=");
  var name = "";
  var start1;
  var end1;
  var tmp;
  var signed_in = -1;

      document.write("<div class=\"left_pagelinks\">");
      document.write("<a class=\"left_pagetitle\" href=\"http://shopsite.ipower.com/ss11.2/sc/order.cgi?func=3&amp;storeid=*14894f26aa4140a700d52a22&amp;html_reg=html\">Account Information<\/a>");

  if (start != -1) {
    start = cookies.indexOf("=", start) +1;
    var end = cookies.indexOf("|", start);
    if (end != -1) {
      signed_in = cookies.indexOf("|yes", start);
      name = unescape(cookies.substring(start,end-1));
      document.write("<strong>" + name + "<\/strong>");
      if (signed_in != -1) {
        document.write("<a class=\"left_pagelink\" href=\"http://shopsite.ipower.com/ss11.2/sc/order.cgi?func=3&storeid=*14894f26aa4140a700d52a22&html_reg=html\"><b>View/Edit Account</b><\/a>");
        document.write("<a class=\"left_pagelink\" href=\"http://shopsite.ipower.com/ss11.2/sc/order.cgi?func=4&storeid=*14894f26aa4140a700d52a22&html_reg=html\"><b>Sign Out</b><\/a>");
      }
      else
      {
        document.write("<span>you're no longer<br>signed in</span>");
      }
    }
  }
  if (signed_in == -1) {
    document.write("<a class=\"left_pagelink\" href=\"http://shopsite.ipower.com/ss11.2/sc/order.cgi?func=2&storeid=*14894f26aa4140a700d52a22&html_reg=html\">Click here to <b>Sign In</b><\/a>");
    document.write("<a class=\"left_pagelink\" href=\"http://shopsite.ipower.com/ss11.2/sc/order.cgi?func=1&storeid=*14894f26aa4140a700d52a22&html_reg=html\">Click here to <b>Register</b><\/a>");
  }
 document.write("<\/div>");
}
