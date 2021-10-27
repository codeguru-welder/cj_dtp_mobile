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
	
	$("#btnRun").on("click", goRun);
	
	function goRun() {
		var config = {
			type: "SCAN",
			param: 'webtest1234',
			callback: "_cb.cbRun"
		};
		miaps.mobile(config, _cb.cbRun);	
	}
	
	var callback = {
		cbRun : function (data) {
			console.log('typeof: ' + typeof data);
			console.log(data);
			
			if (typeof data == 'object') {
				console.log('typeof: ' + typeof data + ', ' + JSON.stringify(data));
			} else if (typeof data == 'string') {
				console.log('typeof: ' + typeof data + ', ' + data);
			}
			
			var obj = miaps.parse(data);
			
			$("#readData").val("");
			$("#readData").val(data.res);
						
			console.log(obj);
		}
	};
	window._cb = callback;
});