require(["jquery", "miaps", "miapspage", "bootstrap"
         ], function($, miaps, miapsPage) {
	
	$("#btnCloseAll").on("click", function() {
		miapsPage.closePopupAll({rmpopup_all_param:'removeAll'});}
	);
	
	$("#btnClose").on("click", function() {
		miapsPage.closePopup({rmpopup_all_param:'valueAAA'});}
	);

	miapsPage.getPopupData(function(data) {
		console.log(data);
	});		
});