require(["jquery", 
         "underscore",
         "miaps",
		 "miapswp", 
		 "miapspage",
		 "bootstrap",
		 "polyfill"		 
         ], function($, _, miaps, miapsWp, miapspage, bootstrap, polyfill) {
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