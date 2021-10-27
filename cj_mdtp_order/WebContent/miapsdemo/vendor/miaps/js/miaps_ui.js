/*
 * miaps.css필수
 */
(function (factory) {
    //Environment Detection
    if (typeof define === 'function' && define.amd) {
        //AMD
        define([], factory);
    } else {
        // Script tag import i.e., IIFE
    	factory();
  }
}(function () {
	var miapsUI = window.miapsUI = {
		
		/**
	     * 페이지에서 Template7을 사용하기 위해 준비한다.
	     * 이 함수를 호출하지 않으면 모든 script 태그 중 type이 "text"로
	     * 시작하는 dom 요소의 내부 html로 자동 초기화된다.
	     * @param {string} tmplSelector script 태그 외에 템플릿 문자열을 추출할 dom 개체를 지정한다.
	     *      이 값이 없으면 모든 script 태그 중 type이 "text"로 시작하는 경우만 처리한다.
	     */
	    initTemplates: function(tmplSelector) {
	        miapsUI._templates = {};
	
	        // script 태그부터 확인
	        $('script' + (tmplSelector ? ', ' + tmplSelector : '')).each(function () {
	            var tag = this.tagName;
	            var type = (this.type || '').toLowerCase();
	            if (tag !== 'SCRIPT' || (type.indexOf('text') === 0 && type != 'text/javascript')) {
	                var tmpl = Template7.compile($(this).html());
	                miapsUI._templates[this.id ? '#' + this.id : this] = tmpl;
	            }
	        });
	
	        if (_debug)
	            console.log('템플릿 컴파일함', Object.keys(miapsUI._templates));
	    },

		/**
	     * 템플릿을 렌더링하여 html을 만들어낸다.
	     * @param {string} tmplSelector 템플릿 문자열을 가지고 있던 dom 개체 선택
	     * @param {object} data 
	     */
	    runTemplate: function(tmplSelector, data) {
	        if (!miapsUI._templates || !miapsUI._templates[tmplSelector])
	            miapsUI.initTemplates(tmplSelector);
	
	        var tmpl = miapsUI._templates[tmplSelector];
	        if (!tmpl) {
	            console.log('HTML 템플릿 개체를 찾지 못함');
	            return null;
	        }
	
	        return tmpl(data);
	    },
		
		/**
		 * 동적으로 DOM객체를 생성한다.
		 */
		dom: function(parent, tag, attrs, text) {
			var el = document.createElement(tag);
			if(attrs){
				for(var key in attrs){
					var val = attrs[key];
					if(typeof val === 'object'){
						var x = el[key];
						for(var k in val){
							x[k] = val[k];
						}
					} else {
						el[key] = val;
					}
				}
			}
			
			if(text){
				el.appendChild(document.createTextNode(text));
			}
			
			if (typeof parent === 'string'){
				parent = document.querySelector(parent);
			}			
			if (parent){
				parent.append(el);
			}			
			return el;
		},
		
		popClose : function(e) {
		    $(e).closest('.layer').removeClass('on').hide();
		    if ($('body').find('.layer.on').length == 0){
		        $('.dimmed').remove();
		    }
		    thisEle.focus();
		},//팝업 닫기
		
		stopScroll: function() {
		    if (undefined != $('#container').css('top'))
		    {
		        var scrollPosition = Math.abs($('#container').css('top').split('px')[0]);
		        console.log(scrollPosition);
		        $('body, html').removeClass('open-pop').find('#container').removeAttr('style');
		        $(document).scrollTop(scrollPosition);
		    }
		},
		
		openPop_scroll : function(){
		    var documentScroll = $(document).scrollTop();
		    $('#container').css({
		        'position' : 'fixed',
		        'top' : -documentScroll,
		        'left' : 0,
		        'width' : '100%'
		    });
		},//팝업이 떴을때 스크롤 막기

		/**
	     * 레이어 팝업 창 기본 형태 만들기. 아래와 같은 화면 구조의 div 개체를 반환한다.
	     * 매개변수 중 `titleText`가 없으면 `layer-header` 영역은 만들지 않는다.
	     * ```
	    ┌--class=dimmed---------------------┐
	    |                                   |
	    |    ┌---class=layer-----------┐    |
	    |    |┌-class=layer-header----┐|    |
	    |    ||                       ||    |
	    |    |└-----------------------┘|    |
	    |    |┌-class=layer-contents--┐|    |
	    |    ||                       ||    |
	    |    |└-----------------------┘|    |
	    |    |┌-class=bottom-btn-set--┐|    |
	    |    ||                       ||    |
	    |    |└-----------------------┘|    |
	    |    └-------------------------┘    |
	    |                                   |
	    └-----------------------------------┘
	    ```
	     * DOM 구조상에서는 아래와 같이 된다.
	     * ```
	    document.body
	       |- layer
	       |    |- layer-header
	       |    |- layer-contents
	       |    \- bottom-btn-set
	       \- dim
	     ```
	     * @param {string} titleText 
	     * @param {any} content 내용 html 또는 DOM 배열
	     * @param {array} buttonHtmls 단추 텍스트(html) 목록
	     * @param {any} callbacks 콜백 함수 배열 또는 동일한 콜백을 적용할 경우 함수 하나
	     * @returns 팝업창 div 개체. 이 개체에 show, hide 함수가 붙는다.
	     */
	    popup: function(titleText, content, buttonHtmls, callbacks) {
	        var popup = this.dom(document.getElementById('container'), 'div', {
	            className: 'layer'
	        });
	        
	        // 딤을 표시하는 클래스 추가
	        $(popup).addClass('depth2');
	        
	        if (titleText) {
	            var header = this.dom(popup, 'div', {className: 'layer-header'});
	            this.dom(header, 'h1', null, titleText);
	            $('<button type="button" class="btn-close"><i class="ico-close"></i><span class="sr-only">닫기</span></button>').appendTo(header);
	        }
	
	        /** cssText: 'max-height: ' + $(window).height() * .7 + 'px; overflow-y: auto;' */
	        var body = this.dom(popup, 'div', {
	            className: 'layer-contents',
	            style: {cssText: 'overflow-y: auto;'}
	        });
	        $(body).append(content);
	
	        if (buttonHtmls) {
	            $(popup).addClass('has_bottom_btn');
	            var buttons = this.dom(popup, 'div', {className: 'bottom-btn-set'});
	            for (var i = 0, count = buttonHtmls.length; i < count; ++i) {
	                $(buttonHtmls[i]).appendTo(buttons);
	            }
	            $('button', buttons).click(callbacks[i] || callbacks);
	        }
	        
	        popup.show = function(callback) {
	            // 아래를 setTimeout에 안 넣은 데에는 이유가 없다
	        	var documentScroll = $(document).scrollTop();
	           
	            //disableBodyScroll();
	            
	            $(this).addClass('on').css('display', 'block');
	            miapsUI.openPop_scroll();
	            
	            setTimeout(function(popup) {
	                // 위치 잡기 및 화면 표시
	                var top = ($(window).outerHeight() - popup.offsetHeight) / 2;
	                //popup.style.top = ($(document).scrollTop() + top) + 'px';
	                popup.style.top = top + 'px';
	                popup.style.opacity = 1;
	                
	                //[2020-01-10] popup에서 사요되는 dimmed와 화면에 있는 dimmed 구분을 위해 무조건 dimmed를 추가하도록 처리
	                //var $dimmed = $('.dimmed').length ? $('.dimmed') : $('<div class="dimmed" style="display:block"></div>').appendTo(document.body);
	                //[2020-01-10] actionSheet에서 dimmed 문제 발생하여 커멘트 처리
	                //$('<div class="dimmed" style="display:block"></div>').appendTo(document.body);
	                
	                // [2019-10-22] 뱅킹 업무팀 요청으로 커멘트 처리
	                /*$dimmed.click(function() {
	                    popup.hide();
	                });*/
	                if (callback)
	                    callback();
	            }, 1, this);
	        };
	
	        popup.hide = function(callback) {
	            //enableBodyScroll();
	
	            $('body, html').removeClass('open-pop');
	            $(this).removeClass('on').css('display', 'none');
	            
	            if ($('body').find('.layer.on').length < 1){
	        		miapsUI.stopScroll();
	        	};
	            
	            if ($('.layer.on').length == 0) {
	                //[2020-01-10] dimmed가 여러개 존재할 수 있으므로 제일 마지막 dimmed 제거
	                //$('.dimmed').remove();
	                //[2020-01-10] actionSheet에서 dimmed 문제 발생하여 커멘트 처리
	                //if ($('.dimmed').length > 0) {
	                //    $('.dimmed')[$('.dimmed').length - 1].remove();
	                //}
	            }
	            if (callback)
	                callback();
	        };
	        
	        $(header).find('.btn-close').off('click').on('click', function(e){
	        	popup.hide();
	        });
	
	        return popup;
	    }

		
		
	};
	// END miapsUI
	window.alert = miapsUI.alert
	return miapsUI;
}));




