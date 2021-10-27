
var miaps_translations = window.miaps_translations = {
	/**
	* @param {function} callback
	* @returns {HTMLElement} 액션 시트 블록을 감싸는 HTML 개체. 이 개체에 setContent, show, hide 함수가 붙어 있다.
	*/
	showActionsheet: function (callback) {

	    var resultHtml = $.ajax({
			type: "GET",
			url: "/miapsdemo/resource/js/translations_template.html",
			async: false
		}).responseText;
	
		var _layerTemp = Template7.compile(resultHtml);
		
		//테스트 data 시작
		
		//테스트 data 끝
		
		// 로드한 template의 {{}}값은  JSON으로 Argument에 작성
		var _html = _layerTemp();
		var temp, $temp = $(_html);
		var actionsheet;
	
		var temp = $temp[0];
		if ($temp.parent().length === 0) {
			$temp.appendTo(document.body);
		}
		
		temp.init = function(){
			// .layer-contents 하위 요소의 html
			var content = $temp.find('.translations-wrap');
			
			// 액션시트 화면 구성
			actionsheet = asFn.actionSheet(content, {
				title:'다국어 처리 예시',
				close: function(){
					temp.hide();
				}
			});
		}
		
		temp.show = function () {
			actionsheet.show();
			
		}
	
		temp.hide = function () {
			$('.dimmed').remove();
			actionsheet.hide();
		}
		
		// template별 구성함수 시작
		
		// html()함수로 새로 구성된 요소의 이벤트를 실행시키려면 event delegate을 시켜야함
		jQuery(function($) {
		
		    miapsWp.translate();
		
		    $('.translations-wrap .nation_btn_wrap button').click(function() {
				var lang = this.getAttribute('data-lang');
		        miapsWp.setLanguage(lang);
		        miapsWp.translate();
		    });

			$('.translations-wrap .btn').on('click', function(){
				miapsWp.getTranslations(function(data){
					alert(data.COMM000001);
				});
			});
		});
		// template별 구성함수 끝
		temp.init();
		
		// 타이틀 속성값 변경
		$('.translations-wrap').parents("div.bottom-sheet-inner").find('.layer-header h1').attr('data-miaps-i18n', 'COMH000001');
			
		return temp;
	}
}