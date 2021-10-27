require(["jquery", "miaps", "miapspage", "bootstrap"
         ], function($, miaps, miapsPage) {
	
	$("#btnClose").on("click", function() {miapsPage.closePopup({backparam:'test'});});
	$("#btnPopup").on("click", function() {
		miapsPage.openPopup("navi/pageNaviTest3-1.html", {id: 'OOO', pw: 'BBBB'});
	});
	
	miapsPage.getPopupData(function(data) {
		console.log(data);
	});
	
	window.miapsOnPopupReceive = function(id, data) {
		console.log("--- miapsOnPopupReceive ---");
    	console.log('id: ' + id);
		console.log(data);
	}

	$("#btnLoadValue").on("click", function() {
		miaps.mobile({
				type : "LOADVALUE",
				param : ["key1", "key2"]
			}, function(data) {
				console.log("pageNaviTest3(popup) loadvalue...");
				console.log(data);
			});
	});	
});