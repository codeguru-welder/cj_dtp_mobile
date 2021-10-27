require(["jquery", 
         "underscore",
         "handlebars",
		 "miaps", 
		 "miapspage",
		 "bootstrap"		 
         ], function($, _, handlebars, miaps, miapspage) {

	$(".back_btn").on("click", function (e) {
		e.preventDefault();
		// 네이티브 기능 페이지 이동
		miapsPage.back();
	});
	
	$(".home_btn").on("click", function (e) {
		e.preventDefault();
		// 메인 페이지 이동
		miapsPage.goTopPage();
	});   	
	
	$("#saveValue").on("click", saveValue);
	
	$("#loadValue").on("click", loadValue);
	
	$("#clearAllValue").on("click", clearAllValue);
	
	function saveValue() {
		var data = $("#data").val();
		var config = {
				type : 'SAVEVALUE',
				param : {"data":data}, // json
				callback : '_cb.cbProcess'
		}
		miaps.mobile(config, _cb.cbProcess);
	}
	
	function loadValue() {
		var config = {
				type : 'LOADVALUE',
				param : ["data"],	// array
				callback : '_cb.cbLoadValue'
		}
		miaps.mobile(config, _cb.cbLoadValue);
	}
	
	function clearAllValue(){
		var config = {
				type : 'clearallvalue',
				param : '',
				callback : '_cb.cbProcess'
		}
		miaps.mobile(config, _cb.cbProcess);
	}
	
	var callback = {
		cbProcess : function (data) {
			var obj = miaps.parse(data);
			
			if(obj.code == '200') alert('성공적으로 처리하였습니다.');
			else alert('처리에 실패했습니다.');
				
			console.log(obj);
		},
		
		cbLoadValue : function (data) {
			var obj = miaps.parse(data);
			
			if(obj.code == '200') alert('저장된 값 : ' + obj.res.data);
			else alert('로드에 실패했습니다.');
			
			console.log(obj);
		}
	};
	window._cb = callback;
});