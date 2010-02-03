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

function grabFacebookLinkPreview(url, callback) {
	safetyCallFB(function() {
		FB.Facebook.apiClient.callMethod('links.preview', {url:url}, function(results) {
			callback(results);
		});
	});
}

/* specific to editing the message for facebook */
function setupLinkFields() {
    var form = $('#link_preview');
    if (form.css('display') == 'block') {
        var attrs = ['name','description','caption'];
        for(var attr in attrs) {
            var attr_name = attrs[attr];
            form.append($('<input>').attr({type:'hidden',name:'message['+attr_name+']', value:$('#link_preview .'+attr_name).text()}));
        }
        if ($('#link_preview #preview_thumbnail:checked').val() != "1") {
            form.append($('<input>').attr({type:'hidden',name:'message[media]', value:$('#link_preview .thumbnail img:first').attr('src')}));
        }
    } else {
		var attrs = ['name','description','media','caption'];
        for(var attr in attrs) {
            var attr_name = attrs[attr];
            form.append($('<input>').attr({type:'hidden',name:'message['+attr_name+']', value:null}));
        }
	}
}
function displayLinkPreview(url) {
    $('#link_preview .loader').show();
    $('#link_preview .attachment').hide();
    $('#link_preview').show();
    grabFacebookLinkPreview(url, function(preview) {
        if (preview != null) {
	        $('#link_preview .loader').hide();
            $('#link_preview .thumbnail').html('');
            for(var i=0; i<preview.media.length; i++) {
                var media = preview.media[i];
                $('#link_preview .thumbnail').append($('<img/>').attr({'src':media.src}));
            }
            $('#link_preview .thumbnail img:first').show();
            var attrs = ['name','href','description','caption'];
            for(var attr in attrs) {
                var attr_name = attrs[attr];
                $('#link_preview .'+attr_name).text(preview[attr_name]);
            }
			$('#link_preview .attachment').show();
        }
    });
}
function hasURL(text) {
    var regexp = /(http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/
    var matches = regexp.exec(text);
    return(matches ? matches[0] : null);
}
function slideThumbnailLeft() {
    var img = $('#link_preview .thumbnail img:first');
    img.hide();
    var thumbnail = $('#link_preview .thumbnail');
    thumbnail.append(img);
    img = $('#link_preview .thumbnail img:first');
    img.show();
}
function slideThumbnailRight() {
    var img = $('#link_preview .thumbnail img:first');
    img.hide();
    img = $('#link_preview .thumbnail img:last');
    img.show();
    var thumbnail = $('#link_preview .thumbnail');
    thumbnail.prepend(img);
}


/* when the page loads up */
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