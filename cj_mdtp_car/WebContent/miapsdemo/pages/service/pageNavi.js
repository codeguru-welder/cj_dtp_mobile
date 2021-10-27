require(["jquery",          
		 "miaps", 
		 "miapspage",        
		 "bootstrap"		 
         ], function($, miaps, miapspage) {

	$(".back_btn").on("click", function (e) {
		e.preventDefault();
		// 네이티브 기능 페이지 이동
		miapsPage.back();
	});
	
	$(".home_btn").on("click", function (e) {
		e.preventDefault();
		// 메인 페이지 이동
		miapsPage.goTopPage();
	});   	
	
	$("#goPage").on("click", function (e) {
		e.preventDefault();
		// 페이지를 이동합니다. 이동 할 때 id 및 data(object), type(push,replace)를 파라메터로 줄 수 있습니다
        // miapsPage.go([url])
        // miapsPage.go([id],[url])
        // miapsPage.go([url],[data])
        // miapsPage.go([id],[url],[data])
        // miapsPage.go([id],[url],[data],[type])
		miapsPage.go("pages/service/pageNavigoPage.html", {userId: "Hong", pw: "gildong"});
	});
	
	$("#openPopup").on("click",function (e) {
		e.preventDefault();
		// POPUP 페이지를 Open합니다.
        // miapsPage.openPopup([url])
        // miapsPage.openPopup([url],[data])
		miapsPage.openPopup("pages/service/pageNaviPopup1.html", {PopupData: "pageNaviPopup1 첫번째 Popup 호출"});
	});

	$("#openPopupFrame").on("click", function (e) {
		e.preventDefault();
        miapsPage.openPopup("pages/service/pageNaviTestFrame.html", {url : "https://m.daum.net"});
	});	

    window.miapsOnPopupReceive = function(id, data) {
		console.log("--- miapsOnPopupReceive ---");
    	console.log('id: ' + id);
		console.log(data);

		var obj = miaps.parse(data);
		if (!obj.data.hasOwnProperty('close')) {		 
			miapsPage.openPopup("pages/service/pageNaviPopup2.html", {PopupData: "pageNaviPopup2 두번째 Popup 호출"});
		}
		//}, 100);


		
		// var obj = miaps.parse(data);
		// miaps.mobile(
		// 	{
		// 	  type: "toasts",
		// 	  param: { msg: obj.data.backparam },
		// 	},
		// 	function (data) {}
		// );

	}
});