require(["jquery", "handlebars", "miaps", "utils", "bootstrap"
			], function($, handlebars, miaps, utils) {

	//화면에 들어갈 리스트 목록
	var output;
	
	//리스트 결과가 더있는지 유무 확인 변수, 시작 수, 끝 수, split한 날짜 값, 필터링 조건값
	var nextList;
	var startNum 	= 1;
	var endNum		= 10;
	
	miaps.cursor(null, 'wait', true);
	$("#btnBack").on("click", function() {window.history.back();});
	//더 보기 기능
	$('#btn_more').on('click', function(e) {
		getUserList();
		return;
	});
	
	/* ---- callback function ---- */
	var callback = {		
		getUserList : function(data) {
			miaps.cursor(null, 'default');
			var json = miaps.parse(data);

			if(json.errCode == 'S') {
				output 		= json.userList;
				nextList 	= json.nextList;
				startNum 	+= 10;
				endNum 		+= 10;
				$('#totalCount').html(json.userListCnt);
					
				var source = $('#list-template').html();
				tempTemplate = handlebars.compile(source);
				
				for(var i = 0; i < output.length; i++) {
					var dto = output[i];
					$("#listUl").append(tempTemplate(dto));
				}
				
				// 더보기 표시
				if(nextList == 'Y') {
					$('#btn_more').show();
				} else {
					$('#btn_more').hide();
				}
				
			} else {
				alert(json.errMsg);
			}
		}
	
	};
	window._cb = callback;
	
	//목록검색	
	//miaps.miapsSvc("com.mink.connectors.hybridtest.list.JsonService", "run", "MIAPS-LIST-TEST", $("#searchFrm").serialize(), "_cb.cbGetList", _cb.cbGetList);
	
	function getUserList() {
		var jsonParam = {
				'START_ROW' : startNum,
				'END_ROW' : endNum
		};
		
		var param = utils.json.params(jsonParam);
		miaps.cursor(null, 'wait', true);

		setTimeout(function() {
			miaps.miapsSvc(
					'com.mink.connectors.hybridtest.list.ListMan'				
					, 'getUserList'
					, 'business_getUserList'
					, param
					, '_cb.getUserList'
					, _cb.getUserList
			);
		}, 3000);
	}
	
	getUserList();
});