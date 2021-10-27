require(["jquery", "miaps", "miapspage", "bootstrap"
         ], function($, miaps, miapsPage) {
	
	$("#btnLogin").on("click", goLogin);
	$("#btnPopup").on("click", goPopup);
	$("#btnExpPopup").on("click", goExpPopup);
	$("#btnExpPopupFrame").on("click", goExpPopupFrame);
	$("#btnSaveValue").on("click", goSaveValue);
	
	$("#btnSessionAuto").on("click", goSessionAuto);
	$("#btnSessionCustom").on("click", goSessionCustom);
	
	
	
  	$("#btnBack").on("click", function() {miapsPage.back();});

	function init() {
		miapsPage.getPageInfo(function(hArray) {
			console.log(hArray);
			
			var obj = miaps.parse(hArray);
			if (obj.hasOwnProperty("res")) {
				$("#userId").val(obj.res.param.data.id);
			}
		});
	}
	
	function goLogin() {
		/*miapsPage.go("navi/pageNaviTest2.html", {
			//userId: $("#userId").val(), 
			userId: "abcdefghfsgaskjsdlkfjl;a",
			pw: $("#userPw").val()
			})
		*/
		
		/*
			{
				id: '', 	// 생략하면 url파일명
				url: '',	// 필수
				data: {},	// object
				type: ''	// 생략가능, 생략하면 기본값 push
			}
		*/
		miapsPage.go({
			url : 'navi/pageNaviTest2.html',
			data : {
				userId: "abcdefghfsgaskjsdlkfjl;a",
				pw: $("#userPw").val()
			}			
		});
	}
	
	function goPopup() {
		miapsPage.openPopup("navi/pageNaviTest3.html", {id: $("#userId").val(), pw: $("#userPw").val()});
	}
	
	function goExpPopup() {
		miapsPage.openPopup("https://m.daum.net");
	}
	
	function goExpPopupFrame() {
		miapsPage.openPopup("navi/pageNaviTestFrame.html", {url : "https://m.daum.net"});
	}
	
	function goSaveValue() {
		miaps.mobile({
				type:"SAVEVALUE",
			 	param: {
					key1 : "value1",
					key2 : "value2"					
				}
			}, 
			function(data) {
				console.log(data);	
			});
	}
	
	function goSessionAuto() {
		miaps.mobile({
			type: 'session',
			param: {
				type: 'auto', // auto, custom
				second: '5'
			}
		}, null);
	}
	
	function goSessionCustom() {
		miaps.mobile({
			type: 'session',
			param: {
				type: 'custom', // auto, custom
				second: '5'
			}
		}, null);
	}
	
	window.miapsOnPopupReceive = function(id, data) {
		console.log("--- miapsOnPopupReceive ---");
    	console.log('id: ' + id);
		console.log(data);
	}
	
	init();			
});