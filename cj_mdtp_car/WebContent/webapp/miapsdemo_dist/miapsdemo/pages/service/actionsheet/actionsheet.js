require(["jquery", 
		 "miaps", 
		 "miapspage",
		 "miapswp",			
		 "tweenmax",
		 "action-sheet",
		 "pages/service/actionsheet/miaps_commentList_require",
		 "pages/service/actionsheet/miaps_checkList_require",
		 "pages/service/actionsheet/miaps_bankList_require",
		 "pages/service/actionsheet/miaps_translations_require",
		 "pages/service/actionsheet/miaps_timepicker_require"
         ], function($, miaps, miapsPage, miapsWp, tweenmax, actionsheet,
					 miaps_commentList, miaps_checkList, miaps_bankList, miaps_translations, miaps_timepicker) {
						
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
	
	// 액션시트 초기화
	var checkListAct = miaps_checkList.showActionsheet();
	var bankListAct = miaps_bankList.showActionsheet();
	var translationsAct = miaps_translations.showActionsheet();
	var timepickerAct = miaps_timepicker.showActionsheet();
	
	// commentList의 경우 마이앱스통신으로 먼저 Template에 채울 값을 가져온 후 액션시트를 만듬
	var commentListAct;
	miaps_commentList.loadData(function(data){
		var data = miaps.parse(data);
		if(data.code == 200) commentListAct = miaps_commentList.showActionsheet(data);
		else alert('miaps_commentList Error\n' + data.msg);
		
		miaps.cursor(null, "default");
	});
	
	// Require.js를 이용한 액션시트
	
    $(".calendarActRequire").on("click", function (e) {
      	e.preventDefault();
      	// 네이티브 기능 페이지 이동
      	miapsPage.go("pages/service/actionsheet/calendarRequire.html");
    });

	$(".commentActRequire").on("click", function (e) {
      	e.preventDefault();

		// actionsheet 보여주기
		if(!commentListAct == false)commentListAct.show();
		else alert('miaps_commentList load Error');
    });

	$(".checkbuttonActRequire").on("click", function (e) {
      	e.preventDefault();
		// actionsheet 보여주기
      	checkListAct.show();
    });

	$(".bankActRequire").on("click", function (e) {
      	e.preventDefault();
		// actionsheet 보여주기
      	bankListAct.show();
    });

	$(".translationsActRequire").on("click", function (e) {
      	e.preventDefault();
		// actionsheet 보여주기
      	translationsAct.show();
    });
	
	$(".timeActRequire").on("click", function (e) {
      	e.preventDefault();
		// actionsheet 보여주기
      	timepickerAct.show();
    });

	// Require.js 끝

	// 일반적인 방식으로 액션시트 호출
	
	$(".calendarActGeneral").on("click", function (e) {
      	e.preventDefault();
      	// 네이티브 기능 페이지 이동
      	miapsPage.go("pages/service/actionsheet/calendar.html");
    });

	$(".commentActGeneral").on("click", function (e) {
      	e.preventDefault();
		// 네이티브 기능 페이지 이동
		miapsPage.go("pages/service/actionsheet/commentList.html");
    });

	$(".checkbuttonActGeneral").on("click", function (e) {
      	e.preventDefault();
		// 네이티브 기능 페이지 이동
      	miapsPage.go("pages/service/actionsheet/checkList.html");
    });

	$(".bankActGeneral").on("click", function (e) {
      	e.preventDefault();
		// 네이티브 기능 페이지 이동
      	miapsPage.go("pages/service/actionsheet/bankList.html");
    });

	$(".translationsActGeneral").on("click", function (e) {
      	e.preventDefault();
		// 네이티브 기능 페이지 이동
      	miapsPage.go("pages/service/actionsheet/translations.html");
    });
	
	$(".timeActGeneral").on("click", function (e) {
      	e.preventDefault();
		// 네이티브 기능 페이지 이동
      	miapsPage.go("pages/service/actionsheet/timepicker.html");
    });

	// 일반적인 방식 끝
});