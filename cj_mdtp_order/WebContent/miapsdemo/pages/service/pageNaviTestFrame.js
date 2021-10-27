require(["jquery", "miaps", "miapspage", "bootstrap"
         ], function($, miaps, miapsPage) {
	
	$("#btnClose").on("click", function(e) {
		e.preventDefault();
		// POPUP 페이지를 Close합니다.
		// POPUP을 닫으면 부모 페이지에 설정 해 놓은 window.miapsOnPopupReceive function()을 호출 합니다.
		// POPUP을 닫을 때 이벤트를 받으려면 부모 페이지에 반드시 window.miapsOnPopupReceive function()을 작성 해 놓아야합니다.
		// miapsPage.closePopup([data])
		miapsPage.closePopup({backparam:'iFrame(외부URL) popup 종료'});
	});
	
	miapsPage.getPopupData(function(data) {
		console.log(data);
		alert(JSON.stringify(data));
		
		var obj = miaps.parse(data);
		console.log(obj);
		console.log("url:" + obj.res.data.url);
		
		document.getElementById("frmDaum").src = obj.res.data.url; 
	});		
});