require(["jquery", "miaps", "miapspage", "bootstrap"
         ], function($, miaps, miapsPage) {
	
	$("#btnBackId").on("click", function() {
		miapsPage.back("index");		
	});	

	$("#btnBackSize").on("click", function() {
		miapsPage.back(-2);		
	});	

	$("#btnTopPageId").on("click", function() {
		miapsPage.getTopPageId(function(data) {
			var obj = miaps.parse(data);
			console.log(obj);
		});	
	});	

	$("#btnGoTopPageNoParam").on("click", function() {
		miapsPage.goTopPage();	
	});	

	$("#btnGoTopPageWithParam").on("click", function() {
		miapsPage.goTopPage({ id : "chlee"});	
	});	
		
	
});