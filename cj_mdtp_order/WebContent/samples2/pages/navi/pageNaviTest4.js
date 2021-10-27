require(["jquery", "miaps", "miapspage", "bootstrap"
         ], function($, miaps, miapsPage) {
	
	$("#btnBack").on("click", function() {
		/*miapsPage.back({backparam4:'test4'}, function(data) {
			var obj = miaps.parse(data);
			alert(obj.code);
		});*/
		
		miapsPage.back('pageNaviTest', {backparam4:'test4'});
	});	
	
	$("#btnGo").on("click", function() {
		miapsPage.go("navi/pageNaviTest5.html");
	});
	
	$("#btnHome").on("click", function() {
		miapsPage.setTopPage("pageNaviTest4", function(data) {
			console.log("setTopPage Callback ----");
			console.log(data);
		});
	});	
});