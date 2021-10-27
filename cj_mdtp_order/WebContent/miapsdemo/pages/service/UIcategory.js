require(["jquery", 
		 "miaps", 
		 "miapspage"
         ], function($, miaps, miapsPage) {

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

    $(".ui-ctg-1").on("click", function (e) {
		e.preventDefault();
		// pull and refresh 기능 페이지 이동
		miapsPage.go("pages/service/UIcategory/pullAndRefresh.html");
    });

	$(".ui-ctg-2").on("click", function (e) {
		e.preventDefault();
		// horizon swipe 기능 페이지 이동
		miapsPage.go("pages/service/UIcategory/horizonSwipe.html");
	});

	$(".ui-ctg-3").on("click", function (e) {
		e.preventDefault();
		// infinite scroll 기능 페이지 이동
		miapsPage.go("pages/service/UIcategory/infiniteScroll.html");
    });

});


    
