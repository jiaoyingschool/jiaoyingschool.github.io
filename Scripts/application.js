// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function highlightRows() {
   if(!document.getElementsByTagName) return false;
   var rows = $$('tbody tr');
   
   for (var i=0; i<rows .length; i++) {
       //Event.observe(rows[i], 'mouseover', function() { $(this).addClassName('highlight');});
       //Event.observe(rows[i], 'mouseout', function() { $(this).removeClassName('highlight');});
       rows[i].onmouseover = function() { $(this).addClassName('highlight');}
       rows[i].onmouseout = function() { $(this).removeClassName('highlight');}
   }
}

/*
Clear default form value script- by JavaScriptKit.com
Featured on JavaScript Kit (http://javascriptkit.com)
Visit javascriptkit.com for 400+ free scripts!
*/

function clearText(thefield){
  if (thefield.defaultValue==thefield.value)
  thefield.value = ""
} 

Event.observe(window, 'load', function(e) {
  $$('#flash.notice').each(function(n) {
    n.fade({delay:5});
  })
});

// form field focus

window.onload = focusForm;

function focusForm(){
/*   if(document.getElementById("email")){
      document.getElementById("email").focus();
   } */
}

// site nav drop-downs
if (Prototype.Browser.IE) {
	Event.observe(window, 'load', function() {
	  $$('.dropdowns li').each(function(node) {
	    Event.observe(node, 'mouseenter', function(event) { node.addClassName('over') });
	    Event.observe(node, 'mouseleave', function(event) { node.removeClassName('over') });
	  });
	});
} else {
	Event.observe(window, 'load', function() {
	  $$('.dropdowns li').each(function(node) {
	    Event.observe(node, 'mouseover', function(event) { node.addClassName('over') });
	    Event.observe(node, 'mouseout', function(event) { node.removeClassName('over') });
	  });
	});
}

/*
$j().ready(function() {
  $j('.dropdowns li').hover(
    function() { $j(this).addClass('over') },
    function() { $j(this).removeClass('over') })
});
*/