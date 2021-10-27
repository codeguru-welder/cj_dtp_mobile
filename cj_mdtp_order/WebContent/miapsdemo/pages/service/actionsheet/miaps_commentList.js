
var miaps_commentList = window.miaps_commentList = {
		
	loadData: function (callback) {
		miaps.cursor(null, "wait", true);
		
		miapsWp.callService(
			"com.mink.connectors.hybridtest.login.LoginMan",
			"welfare_req_List",
			{"id" : "user01"}
		).then(callback);
	},	

	/**
	* @param {function} callback
	* @returns {HTMLElement} 액션 시트 블록을 감싸는 HTML 개체. 이 개체에 setContent, show, hide 함수가 붙어 있다.
	*/
	showActionsheet: function (data, callback) {
		
	    var resultHtml = $.ajax({
			type: "GET",
			url: "/miapsdemo/resource/js/commentList_template.html",
			async: false
		}).responseText;
	
		var _layerTemp = Template7.compile(resultHtml);		
		
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
			var content = $temp.find('.commentList-wrap');
			
			// 액션시트 화면 구성
			actionsheet = asFn.actionSheet(content, {
				title:'댓글 ' + data.res.length +'개',
				close: function(){
					temp.hide();
				}
			});
			
			temp.sortList('asc');
		}
		
		temp.show = function () {
			actionsheet.show();
		}
	
		temp.hide = function () {
			$('.dimmed').remove();
			actionsheet.hide();
		}
		
		// template안의 요소 변경할때
		temp.setTemplate = function(){
			var itemTemplet = ''
          	+ '{{#each res}}'
			+ '	<hr>'
			+ '	<div class="content">'
			+ '		<p class="title">{{userid}}</p>'
			+ '		<p class="text">{{reqtitle}}</p>'
			+ '		<p class="time">{{reqdate}}</p>'
			+ '	</div>'
			+ '{{/each}}';
			
			_layerTemp = Template7.compile(itemTemplet)
			var _html = _layerTemp(data);
			$('.commentList-wrap div[id="itemTemplet"]').html(_html);
		}
		
		// template별 구성함수 시작
		var sortType;
	
		$('.btn-close').on('click', function () {
			$(this).closest('.bottom-sheet')[0].hide();
		});
		
		$('.commentList-wrap input[type="radio"]').on('change', function () {
			var checkId = $('.commentList-wrap :radio[name="sort"]:checked').attr('id');
			temp.sortList(checkId);
		});
		
		$('.commentList-wrap #btnWrite').on('click', function(){
			if(!$('.commentList-wrap .comment textarea').val()) return;
			
			var date = moment();
			var param = {"userid": "user01", "reqtitle": $('.commentList-wrap .comment textarea').val(), "reqdate": date.format('YYYYMMDD')};
			
			miaps.cursor(null, "wait", true);
			
			temp.insertList(param, function(reloadData){
				data = miaps.parse(reloadData);
				
				if(data.code == "200"){
					temp.setTemplate();
					$('.commentList-wrap .comment textarea').val("");
					// 해당 액션시트의 타이틀명 바꾸기
					$('.commentList-wrap').parents("div.bottom-sheet-inner").find('.layer-header h1').text('댓글 ' + data.res.length +'개');
				}else{
					alert("작성에 실패했습니다.");
				}
				
				miaps.cursor(null, "default");
			});
		});
		
		temp.sortList = function(sort){
			sortType = sort;
			
			if(sort == 'asc'){
				data.res.sort(function(a, b){
					return a.reqdate < b.reqdate ? -1 : a.reqdate > b.reqdate ? 1 : 0;
				});
			}else if(sort == 'desc'){
				data.res.sort(function(a, b){
					return a.reqdate > b.reqdate ? -1 : a.reqdate < b.reqdate ? 1 : 0;
				});
			}
			
			temp.setTemplate();
		}
		
		temp.insertList = function(param, callback){
			miapsWp.callService(
				"com.mink.connectors.hybridtest.login.LoginMan",
				"insert_welfare_req_List",
				param
			).then(callback);
		}
		// template별 구성함수 끝
		temp.init();
		
		return temp;
	}
}