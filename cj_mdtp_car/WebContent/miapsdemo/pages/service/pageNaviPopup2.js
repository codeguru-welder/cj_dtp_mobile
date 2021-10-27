require(["jquery",          
		 "miaps", 
		 "miapspage",
		 "handlebars", 
		 "bootstrap"		 
         ], function($, miaps, miapspage, handlebars ) {

	$(".x_btn, #closePopup").on("click", function (e) {
		e.preventDefault();
		// POPUP 페이지를 Close합니다.
		// POPUP을 닫으면 부모 페이지에 설정 해 놓은 window.miapsOnPopupReceive function()을 호출 합니다.
		// POPUP을 닫을 때 이벤트를 받으려면 부모 페이지에 반드시 window.miapsOnPopupReceive function()을 작성 해 놓아야합니다.
		// miapsPage.closePopup([data])
		miapsPage.closePopup({backparam:'pageNaviPopup2_두번째 Popup 닫기', close:true});
	});	 	
	
	$("#closePopupAll").on("click",function (e) {
		e.preventDefault();
		// 모든 POPUP 페이지를 Close합니다.
        // 첫번째 열린 POPUP페이지의 부모 페이지에 등록된 window.miapsOnPopupReceive function()를 호출 합니다.
        // miapsPage.closePopupAll([data])
        miapsPage.closePopupAll({backparam:'pageNaviPopup2_모든 POPUP 페이지 닫기'});
	});

    miapsPage.getPopupData(function(data) {
		console.log(data);
	});

    window.miapsOnPopupReceive = function(id, data) {
		console.log("--- miapsOnPopupReceive ---");
    	console.log('id: ' + id);
		console.log(data);
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