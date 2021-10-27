require(["jquery", 
         "underscore",
         "handlebars",
		 "miaps", 
		 "miapspage",
         "miapswp",
		 "bootstrap"		 
         ], function($, _, handlebars, miaps, miapspage, miapsWp) {

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
	


	var callback = {
		cbmiapsSvc : function (data) {
			var obj = miaps.parse(data);
            if (obj.code != "200") {
              console.log(obj.msg);
            } else {
              var data = obj.res;
              console.log(data);              
            }
            miaps.cursor(null, "default");
		}
	};
	window._cb = callback;
});