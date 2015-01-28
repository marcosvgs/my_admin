/**
 * Unobtrusive scripting adapter for jQuery
 *
 * Requires jQuery 1.4.3 or later.
 * https://github.com/rails/jquery-ujs
 */
// 
// $(document).ready(function() {
// 	// Make sure that every Ajax request sends the CSRF token
// 	function CSRFProtection(xhr) {
// 		var token = $('meta[name="csrf-token"]').attr('content');
// 		if (token) xhr.setRequestHeader('X-CSRF-Token', token);
// 	}
// 	if ('ajaxPrefilter' in $) $.ajaxPrefilter(function(options, originalOptions, xhr){ CSRFProtection(xhr) });
// 	else $(document).ajaxSend(function(e, xhr){ CSRFProtection(xhr) });
// 
// 	// Triggers an event on an element and returns the event result
// 	function fire(obj, name, data) {
// 		var event = $.Event(name);
// 		obj.trigger(event, data);
// 		return event.result !== false;
// 	}
// 
// 	// Submits "remote" forms and links with ajax
// 	function handleRemote(element) {
// 		var method, url, data,
// 			dataType = element.data('type') || ($.ajaxSettings && $.ajaxSettings.dataType);
// 
// 	if (fire(element, 'ajax:before')) {
// 		if (element.is('form')) {
// 			method = element.attr('method');
// 			url = element.attr('action');
// 			data = element.serializeArray();
// 			// memoized value from clicked submit button
// 			var button = element.data('ujs:submit-button');
// 			if (button) {
// 				data.push(button);
// 				element.data('ujs:submit-button', null);
// 			}
// 		} else {
// 			method = element.data('method');
// 			url = element.attr('href');
// 			data = null;
// 		}
// 			$.ajax({
// 				url: url, type: method || 'GET', data: data, dataType: dataType,
// 				// stopping the "ajax:beforeSend" event will cancel the ajax request
// 				beforeSend: function(xhr, settings) {
// 					if (settings.dataType === undefined) {
// 						xhr.setRequestHeader('accept', '*/*;q=0.5, ' + settings.accepts.script);
// 					}
// 					return fire(element, 'ajax:beforeSend', [xhr, settings]);
// 				},
// 				success: function(data, status, xhr) {
// 					element.trigger('ajax:success', [data, status, xhr]);
// 				},
// 				complete: function(xhr, status) {
// 					element.trigger('ajax:complete', [xhr, status]);
// 				},
// 				error: function(xhr, status, error) {
// 					element.trigger('ajax:error', [xhr, status, error]);
// 				}
// 			});
// 		}
// 	}
// 
// 	// Handles "data-method" on links such as:
// 	// <a href="/users/5" data-method="delete" rel="nofollow" data-confirm="Are you sure?">Delete</a>
// 	function handleMethod(link) {
// 		var href = link.attr('href'),
// 			method = link.data('method'),
// 			csrf_token = $('meta[name=csrf-token]').attr('content'),
// 			csrf_param = $('meta[name=csrf-param]').attr('content'),
// 			form = $('<form method="post" action="' + href + '"></form>'),
// 			metadata_input = '<input name="_method" value="' + method + '" type="hidden" />';
// 
// 		if (csrf_param !== undefined && csrf_token !== undefined) {
// 			metadata_input += '<input name="' + csrf_param + '" value="' + csrf_token + '" type="hidden" />';
// 		}
// 
// 		form.hide().append(metadata_input).appendTo('body');
// 		form.submit();
// 	}
// 
// 	function disableFormElements(form) {
// 		form.find('input[data-disable-with]').each(function() {
// 			var input = $(this);
// 			input.data('ujs:enable-with', input.val())
// 				.val(input.data('disable-with'))
// 				.attr('disabled', 'disabled');
// 		});
// 	}
// 
// 	function enableFormElements(form) {
// 		form.find('input[data-disable-with]').each(function() {
// 			var input = $(this);
// 			input.val(input.data('ujs:enable-with')).removeAttr('disabled');
// 		});
// 	}
// 
// 	function allowAction(element) {
// 		var message = element.data('confirm');
// 		return !message || (fire(element, 'confirm') && confirm(message));
// 	}
// 
// 	function requiredValuesMissing(form) {
// 		var missing = false;
// 		form.find('input[name][required]').each(function() {
// 			if (!$(this).val()) missing = true;
// 		});
// 		return missing;
// 	}
// 
// 	$('a[data-confirm], a[data-method], a[data-remote]').on('click.rails', function(e) {
// 		var link = $(this);
// 		if (!allowAction(link)) return false;
// 
// 		if (link.data('remote') != undefined) {
// 			handleRemote(link);
// 			return false;
// 		} else if (link.data('method')) {
// 			handleMethod(link);
// 			return false;
// 		}
// 	});
// 
// 	$('form').on('submit.rails', function(e) {
// 		var form = $(this), remote = form.data('remote') != undefined;
// 		if (!allowAction(form)) return false;
// 
// 		// skip other logic when required values are missing
// 		if (requiredValuesMissing(form)) return !remote;
// 
// 		if (remote) {
// 			handleRemote(form);
// 			return false;
// 		} else {
// 			// slight timeout so that the submit button gets properly serialized
// 			setTimeout(function(){ disableFormElements(form) }, 13);
// 		}
// 	});
// 
// 	$('form input[type=submit], form button[type=submit], form button:not([type])').on('click.rails', function() {
// 		var button = $(this);
// 		if (!allowAction(button)) return false;
// 		// register the pressed submit button
// 		var name = button.attr('name'), data = name ? {name:name, value:button.val()} : null;
// 		button.closest('form').data('ujs:submit-button', data);
// 	});
// 
// 	$('form').on('ajax:beforeSend.rails', function(event) {
// 		if (this == event.target) disableFormElements($(this));
// 	});
// 
// 	$('form').on('ajax:complete.rails', function(event) {
// 		if (this == event.target) enableFormElements($(this));
// 	});
// });
// 
// var Rails = {
// 	ALIASES: {
// 		"create": "new",
// 		"update": "edit"
// 	},
// 
// 	ua: navigator.userAgent,
// 
// 	init: function() {
// 		Rails.dispatcher();
// 		Rails.browserName();
// 	},
// 	controllerName: function(){
//     return $("head meta[name=rails-controller]").attr("content");
// 	},
//     actionName: function(){
//     return $("head meta[name=rails-action]").attr("content");
//     },
// 	browserName: function() {
// 		var css_name = null;
// 		var matches = null;
// 		var capable = true;
// 
// 		if (this.ua.match(/firefox/i)) {
// 			css_name = "firefox";
// 		} else if (this.ua.match(/safari/i)) {
// 			css_name = "safari";
// 		} else if (matches = this.ua.match(/msie (\d+)/i)) {
// 			css_name = "ie ie" + matches[1];
// 			capable = parseInt(matches[1] || 0) >= 7;
// 		} else if (this.ua.match(/opera/i)) {
// 			css_name = "opera";
// 		} else if (this.ua.match(/mozilla/i)) {
// 			css_name = "mozilla";
// 		}
// 
// 		if (css_name) {
// 			$("body")
// 				.addClass("has-js")
// 				.addClass(css_name)
// 				.addClass(capable? "capable" : "");
// 			return css_name;
// 		}
// 	},
// 
// 	dispatcher: function() {
// 		var controller_name = $("head meta[name=rails-controller]").attr("content");
// 		var action_name = $("head meta[name=rails-action]").attr("content");
// 
// 		action_name = Rails.ALIASES[action_name] || action_name;
// 
// 		// Executed before every controller action
// 		if (Rails.before) {
// 			for (var i = 0; i < Rails.before.length; i++) {
// 				Rails.before[i]();
// 			}
// 		}
// 
// 		if (Rails[controller_name] && Rails[controller_name]['before']) {
// 			// Executed before action from the current controller
// 			for (var i = 0; i < Rails[controller_name]['before'].length; i++) {
// 				Rails[controller_name]['before'][i]();
// 			}
// 		}
// 
// 		if (Rails[controller_name] && Rails[controller_name][action_name]) {
// 			// Executed before any action from the current controller
// 			for (var i = 0; i < Rails[controller_name][action_name].length; i++) {
// 				Rails[controller_name][action_name][i]();
// 			}
// 		}
// 	}
// };
// 
// Rails.before = [];
// 
// Rails.add = function(controller, action, func) {
// 
// 	if (!Rails[controller]) {
// 		Rails[controller] = [];
// 	}
// 
// 	if (typeof(action) == 'object') {
// 		for (var key in action) {
// 			if (!Rails[controller][key]) {
// 				Rails[controller][key] = [];
// 			}
// 
// 			Rails[controller][key].push(action[key]);
// 		}
// 	}
// 	else {
// 
// 		if (!Rails[controller][action]) {
// 			Rails[controller][action] = [];
// 		}
// 
// 		Rails[controller][action].push(func);
// 	}
// };
// 
// 
// (function($){
// 	$.stopEvent = function(e) {
// 		e.stopPropagation();
// 		e.preventDefault();
// 	};
// 
// 	$(document).ready(Rails.init);
// })(jQuery);


jQuery.extend(jQuery.fn, { flashMessage : function(message, type) { flashMessage(message, type); return this; } } );

var showMessage = function(element, message, type, permanent)
{
    if(!$(element).hasClass('notify-wrapper'))
        $(element).jnotifyInizialize({ oneAtTime: true });
    
    $(element).jnotifyAddMessage({
        text: message,
        permanent: permanent,
        type: type
    });
}

var flashMessage = function(message, type) {

  if( $("#notification").size() == 0 ) {
    $("body").prepend('<div id="notification"></div>');
    
    $('#notification').jnotifyInizialize({
        oneAtTime: false,
        appendType: 'append'
    });
    
  }
  
  $('#notification').jnotifyAddMessage({
      text: message,
      permanent: false,
      type: type
  });

};

colorToHex = function(color) {
    if (color.substr(0, 1) === '#') {
        return color;
    }
    var digits = /(.*?)rgb\((\d+), (\d+), (\d+)\)/.exec(color);
    
    var red = parseInt(digits[2]);
    var green = parseInt(digits[3]);
    var blue = parseInt(digits[4]);
    
    var rgb = blue | (green << 8) | (red << 16);
    rgb = rgb.toString(16)
    
    var total = rgb.length;
    
    if(total < 6)
        for (i=0;i< (6 - total);i++)
            rgb = "0" + rgb;

    return digits[1] + '#' + rgb;
};

jQuery.extend(jQuery.fn, {
  htmlLoaderSmall: function(css) {

    var self = $(this).html('<div class="loaderSmall" style="display:block;"></div>');

    if (css){
      self.find('.loaderSmall').css(css);
    }

    return self;
  }
});

jQuery.extend(jQuery.fn, {
  appendLoaderSmall: function(css) {

    var self = $(this).append('<div class="loaderSmall" style="display:block;"></div>');

    if (css){
      self.find('.loaderSmall').css(css);
    }

    return self;
  }
});