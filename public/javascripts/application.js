// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

/* Make sure there is an active Facebook Connect Session to perform
 func method call */
function safetyCallFB(func) {
	FB.ensureInit(function () {
		FB.Facebook.get_sessionState().waitUntilReady(function() {
			func();
		});
	});
}
/* Update the page select element with options of the pages the user
 has admin access to.
*/
function updatePageOptions(element, uid, select_id) {
	safetyCallFB(function() {
		FB.Facebook.apiClient.fql_query("SELECT page_id, name from page WHERE page_id IN (SELECT page_id FROM page_admin WHERE uid = " + uid + ")", function(results) {
			var fields = $(element);
			fields.html($('<option></option>').attr({
				value: uid,
				text: 'You',
				selected: (select_id && uid==select_id) ? 'selected' : ''
			}))
			if (results) {
				for(var i = 0; i < results.length; i++) {
					fields.append($('<option></option>').attr({
						value: results[i].page_id,
						text: results[i].name,
						selected: (select_id && results[i].page_id.toString() == select_id) ? 'selected' : ''
					}));
				}
			}
		});
	});
}

function askForPermissionOnForm(permission, uid) {
	safetyCallFB(function() {
		FB.Connect.showPermissionDialog(permission, function(perms) {}, true, [uid]);
	});
}

$(document).ready(function() {
	$('a.lightbox').fancybox({
			hideOnContentClick: false,
			hideOnOverlayClick: false
	});
	$('a.close_lightbox').live('click', function(){
		$.fn.fancybox.close();
		return false;
	});
});

function closeLightbox() {
	$.fn.fancybox.close();
	$('a.lightbox').fancybox({
			hideOnContentClick: false,
			hideOnOverlayClick: false
	});
}