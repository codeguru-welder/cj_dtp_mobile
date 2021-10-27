require(["jquery",         
		 "miaps", 
		 "miapspage",       
		 "bootstrap"		 
         ], function($, miaps, miapspage) {

	$(".back_btn, #backPage").on("click", function (e) {
		e.preventDefault();
		// 네이티브 기능 페이지 이동
		miapsPage.back();
	});	

    miapsPage.getPageInfo(function(data) {
		var obj = miaps.parse(data);
		miaps.mobile(
			{
			  type: "toasts",
			  param: { msg: `전단받은 데이터 ${JSON.stringify(obj.res.param.data)}`},
			},
			function (data) {}
		);

	});
});