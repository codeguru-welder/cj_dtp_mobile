require(["jquery", 
         "underscore",
         "handlebars",
		 "miaps", 
		 "miapspage",
		 "bootstrap"		 
         ], function($, _, handlebars, miaps, miapspage) {

	$("#backbtn").on("click", function (e) {
		e.preventDefault();
		// 네이티브 기능 페이지 이동
		miapsPage.closePopup();
	});
	
	$("body").on("click", function (e) {
		e.preventDefault();
		// 네이티브 기능 페이지 이동
		miapsPage.closePopup();
	});
	
	$(function () {
		miapsPage.getPopupData(function(data){
			console.log(data.res.data);
			
			if(data.res.data.type == 'txt'){
				$("#text").append(data.res.data.res);
			}else{
				$("#image").attr("src", data.res.data.res);
			}
		});
	}); 
});