require(["jquery", 
		 "miaps", 
		 "miapspage",
		 "moment",
		 "template7",
		 "tweenmax",
		 "action-sheet",
		 "pages/service/actionsheet/miaps_calendar_require"
         ], function($, miaps, miapsPage, moment, Template7, tweenmax, actionsheet, miaps_calendar) {

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

	$(function () {
		var cal1, cal2;
	    $('#inpCal').on('click', function () {
			cal1 = miaps_calendar.showCalender($(this));
		});
		$('#inpCal2').on('click', function () {
			miaps_calendar.showCalender($(this));
		});
		$('#btnShowCal').on('click', function () {
			cal2 = miaps_calendar.showCalender($(this), '2020.07.13', '2020.03.01', '2020.05.31', function (data) {
				console.log(data);
			});
		});
		$('#btnShowCal2').on('click', function () {
			miaps_calendar.showCalender(null, null, null, null, function (data) {
				console.log(data);
			});
		});
	});
});