require(["jquery",         
		 "miaps", 
		 "miapspage",
		 "handlebars",         
		 "bootstrap"		 
         ], function($, miaps, miapspage, handlebars) {
			
	$(".x_btn, #closePopup").on("click", close_btn);
	
	$("#openPopup").on("click",function (e) {
		e.preventDefault();
		// POPUP 페이지를 Open합니다.
        // miapsPage.openPopup([url])
        // miapsPage.openPopup([url],[data])
		miapsPage.openPopup("pages/service/pageNaviPopup2.html", {PopupData: "pageNaviPopup2 두번째 Popup 호출"});
	});
	
	function close_btn() {
		// POPUP 페이지를 Close합니다.
		// POPUP을 닫으면 부모 페이지에 설정 해 놓은 window.miapsOnPopupReceive function()을 호출 합니다.
		// POPUP을 닫을 때 이벤트를 받으려면 부모 페이지에 반드시 window.miapsOnPopupReceive function()을 작성 해 놓아야합니다.
		// miapsPage.closePopup([data])		
		miapsPage.closePopup({backparam:'pageNaviPopup1_첫번째 Popup 닫기'});
	}

	miapsPage.getPopupData(function(data) {
		console.log(data);
	});

    window.miapsOnPopupReceive = function(id, data) {
		console.log("--- miapsOnPopupReceive ---");
    	console.log('id: ' + id);
		console.log(data);

		var obj = miaps.parse(data);
		miaps.mobile(
			{
			  type: "toasts",
			  param: { msg: obj.data.backparam },
			},
			function (data) {}
		);
	}

	miapsPage.getPopupList(function(data) {
		var source = $('#navi-template').html();
		var tempTemplate = handlebars.compile(source);

		var obj = miaps.parse(data);

		for(var i = 0; i < obj.res.length; i++) {
			var dto = obj.res[i];
			$(".topbar-img").append(tempTemplate(dto));
		}
	});	
	
});