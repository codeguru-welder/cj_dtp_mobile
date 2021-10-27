/*
 * Async Treeview 0.1 - Lazy-loading extension for Treeview
 * 
 * http://bassistance.de/jquery-plugins/jquery-plugin-treeview/
 *
 * Copyright (c) 2007 Jörn Zaefferer
 *
 * Dual licensed under the MIT and GPL licenses:
 *   http://www.opensource.org/licenses/mit-license.php
 *   http://www.gnu.org/licenses/gpl.html
 *
 * Revision: $Id$
 *
 */

;(function($) {

function load(settings, root, child, container) {
	function createNode(parent) {
		var current;
		var $id = this.id;
		var $li = $("<li/>").attr("id", this.id || "");
		var $checkbox = $("<input/>").attr({ type: "checkbox", name: "treeviewCheckbox", value: this.id });
		var $a = $("<a/>").attr({ href:  "javascript:returnFalseAlink();", id: $id }).text(this.text);
		var $span = $("<span/>").text(this.text);
		
		var deleteYn_ = "";
		if ("Y" == this.deleteYn) {
			$a.css("text-decoration", "line-through");
			$a.css("color", "grey");
			$span.css("text-decoration", "line-through");
			$span.css("color", "grey");
			deleteYn_ = "Y";
		} else {
			deleteYn_ = "N";
		}
		
		var data = {
			grpId: this.grpId, 
			grpCd: this.grpCd, 
			grpNm: this.grpNm, 
			grpDesc: this.grpDesc, 
			upGrpId: this.upGrpId, 
			orderSeq: this.orderSeq, 
			deleteYn: deleteYn_, 
			grpLevel: this.grpLevel,
			grpNavigation: this.grpNavigation
		};
		$li.data("grp", data);
		$checkbox.data("grp", data);
		$a.data("grp", data);
		$span.data("grp", data);
		
		// checkbox
		if (settings.checkbox) {
			// chainReaction
			if (settings.chainReaction) {
				// a
				if('a' == settings.node) {
					$a.click(function(){
						$checkbox.click();
					});
				}
				// span
				else {
					$span.click(function(){
						$checkbox.click();
					});
				}
			}
		}
		else {
			// callbackFn
			if('a' == settings.node) {
				if( $.isFunction( settings.callbackFn ) ) {
					$a.bind("click", settings.callbackFn);
				}
			}
		}
		
		// append li
		if('a' == settings.node) {
			if (settings.checkbox) {
				current = $li.append($checkbox).append($a);
			}
			else {
				current = $li.append($a);
			}
		}
		else {
			if (settings.checkbox) {
				current = $li.append($checkbox).append($span);
			}
			else {
				current = $li.append($span);
			}
		}
		current.appendTo(parent);
		
		//var current = $li.append($("<span/>").text(this.text)).appendTo(parent);
		if (this.classes) {
			//current.children("span").addClass(this.classes);
			if('a' == settings.node) {
				current.children("a").addClass(this.classes);
			}
			else {
				current.children("span").addClass(this.classes);
			}
		}
		if (this.expanded) {
			current.addClass("open");
		}
		if (this.hasChildren || this.children && this.children.length) {
			var branch = $("<ul/>").appendTo(current);
			if (this.hasChildren) {
				current.addClass("hasChildren");
				createNode.call({
					classes: "placeholder",
					text: "&nbsp;",
					children:[]
				}, branch);
			}
			if (this.children && this.children.length) {
				$.each(this.children, createNode, [branch]);
			}
		}
	}
	$.ajax($.extend(true, {
		url: settings.url,
		dataType: "json",
		data: {
			root: root
		},
		success: function(response) {
			child.empty();
			$.each(response, createNode, [child]);
	        $(container).treeview({add: child});
	    },
	    complete: function(){
	    	completeTreeview(container);
        }
	}, settings.ajax));
	/*
	$.getJSON(settings.url, {root: root}, function(response) {
		function createNode(parent) {
			var current = $("<li/>").attr("id", this.id || "").html("<span>" + this.text + "</span>").appendTo(parent);
			if (this.classes) {
				current.children("span").addClass(this.classes);
			}
			if (this.expanded) {
				current.addClass("open");
			}
			if (this.hasChildren || this.children && this.children.length) {
				var branch = $("<ul/>").appendTo(current);
				if (this.hasChildren) {
					current.addClass("hasChildren");
					createNode.call({
						text:"placeholder",
						id:"placeholder",
						children:[]
					}, branch);
				}
				if (this.children && this.children.length) {
					$.each(this.children, createNode, [branch])
				}
			}
		}
		$.each(response, createNode, [child]);
        $(container).treeview({add: child});
    });
    */
}

var proxied = $.fn.treeview;
$.fn.treeview = function(settings) {
	if (!settings.url) {
		return proxied.apply(this, arguments);
	}
	var container = this;
	load(settings, "source", this, container);
	var userToggle = settings.toggle;
	return proxied.call(this, $.extend({}, settings, {
		collapsed: true,
		toggle: function() {
			var $this = $(this);
			if ($this.hasClass("hasChildren")) {
				var childList = $this.removeClass("hasChildren").find("ul");
				childList.empty();
				load(settings, this.id, childList, container);
			}
			if (userToggle) {
				userToggle.apply(this, arguments);
			}
		}
	}));
};

})(jQuery);