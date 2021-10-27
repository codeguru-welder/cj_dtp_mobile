require(["jquery", "miaps", "miapspage", "bootstrap"
         ], function($, miaps, miapsPage) {
	
	$("#btnClose").on("click", function() {
		miapsPage.closePopup({rmpopup_all_param:'valueAAA'});}
	);
	$("#btnPopup").on("click", function() {
		miapsPage.openPopup("navi/pageNaviTest3-2.html", {id: '111', pw: 'CCCC'});
	});
	
	miapsPage.getPopupData(function(data) {
		console.log(data);
	});		

	window.miapsOnPopupReceive = function(id, data) {
		console.log("--- miapsOnPopupReceive ---");
    	console.log('id: ' + id);
		console.log(data);
	}
});