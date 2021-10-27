require(["jquery", "miaps", "miapspage", "bootstrap"
         ], function($, miaps, miapsPage) {
	
	$("#btnBack").on("click", function() {miapsPage.back({backparam2:'test2'});});
	
	$("#btnGo").on("click", function() {
		miapsPage.go("navi/pageNaviTest4.html");
	});

	$("#btnLoadValue").on("click", function() {
		miaps.mobile({
				type : "LOADVALUE",
				param : ["key1", "key2"]
			}, function(data) {
				console.log("pageNaviTest2 loadvalue...");
				console.log(data);
			});
	});	

	miapsPage.getPageInfo(function(data) {
		console.log(data);
	});
});