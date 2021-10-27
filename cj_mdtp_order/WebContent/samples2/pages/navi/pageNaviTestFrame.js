require(["jquery", "miaps", "miapspage", "bootstrap"
         ], function($, miaps, miapsPage) {
	
	$("#btnClose").on("click", function() {miapsPage.closePopup({backparam:'test'});});
	
	miapsPage.getPopupData(function(data) {
		console.log(data);
		alert(JSON.stringify(data));
		
		var obj = miaps.parse(data);
		console.log(obj);
		console.log("url:" + obj.res.data.url);
		
		document.getElementById("frmDaum").src = obj.res.data.url; 
	});		
});