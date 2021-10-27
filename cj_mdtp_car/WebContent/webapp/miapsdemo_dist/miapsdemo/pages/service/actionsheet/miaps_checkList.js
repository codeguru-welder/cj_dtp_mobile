
var miaps_checkList = window.miaps_checkList = {
	/**
	* @param {function} callback
	* @returns {HTMLElement} 액션 시트 블록을 감싸는 HTML 개체. 이 개체에 setContent, show, hide 함수가 붙어 있다.
	*/
	showActionsheet: function (callback) {

	    var resultHtml = $.ajax({
			type: "GET",
			url: "/miapsdemo/resource/js/checkList_template.html",
			async: false
		}).responseText;
	
		var _layerTemp = Template7.compile(resultHtml);
		
		//테스트 data 시작
		var data = {
			"result":[
				{"head": "일반좌석", "item": "1인 기본 좌석입니다."},
				{"head": "유아동반석", "item": "유아동반 또는 편한대화 객차입니다."},
				{"head": "휠체어석", "item": "휠체어석과 일행을 위한 일반좌석이 자동배정됩니다."},
				{"head": "전동휠체어석", "item": "전동휠체어석과 일행을 위한 일반좌석이 자동배정됩니다."},
				{"head": "자전거석", "item": "자전거 휴대시 자전거석을 예매하거나, 접힌 상태 또는 분해하여 가방에 담긴 상태여아 합니다."},
				{"head": "2층석", "item": "ITX청춘 열차에만 존재하는 좌석입니다."}
			]
		}
		//테스트 data 끝
		
		// 로드한 template의 {{}}값은  JSON으로 Argument에 작성
		var _html = _layerTemp(data);
		var temp, $temp = $(_html);
		var actionsheet;
	
		var temp = $temp[0];
		if ($temp.parent().length === 0) {
			$temp.appendTo(document.body);
		}
		
		temp.init = function(){
			// .layer-contents 하위 요소의 html
			var content = $temp.find('.checkList-wrap');
			
			// 액션시트 화면 구성
			actionsheet = asFn.actionSheet(content, {
				title:'Check List',
				close: function(){
					temp.hide();
				},
				no: function(){
					temp.hide();
				},
				yes: function(){
					var result = '';
					$('.item-wrap input:checkbox[name="item"]:checked').each(function() {
						result += this.id + '\n';
					});
					result = result.substr(0, result.length-1);
					alert(result);
					
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
			
			/*asFn.hideActionSheet(temp);
			$(this).closest('.bottom-sheet')[0].hide();*/
		}
		
		// template별 구성함수 시작
		
		// template별 구성함수 끝
		temp.init();
	
		return temp;
	}
}