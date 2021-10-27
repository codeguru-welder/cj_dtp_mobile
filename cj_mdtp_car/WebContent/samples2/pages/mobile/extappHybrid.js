require(["jquery", "miaps", "bootstrap"
         ], function($, miaps) {
	

  	$("#btnRun").on("click", goRun);
  	$("#btnBack").on("click", function() {window.history.back();});      	
	$("#pkgNm").focus();
	
	// 스킴명에는 _가 들어가면 안된다.(호출되지 않음)
	var _gScheme = "";
	
	function goRun() {
		miaps.cursor('iconLogin', 'wait', true);
		
		var _pkgNm = $("#pkgNm").val();
		_gScheme = $("#schemeNm").val();
		var _param = "";
		
		if (miaps.MobilePlatform.Android()) {
			_param = _pkgNm;
		} else {
			_param = _gScheme;
		}
		
		var config = {
			type: "isinstalled",
			param: _param,
			callback: "_cb.cbRun"
		};
		miaps.mobile(config, _cb.cbRun);
	}
	
	var callback = {	
		cbRun : function (data) {
			miaps.cursor('iconLogin', 'default');
			var obj = miaps.parse(data);
			
			if (typeof obj == 'object') {
				alert(JSON.stringify(obj).replace(/,"/g, ',\n"'));
			} else if (typeof obj == 'string') {
				alert(obj);
			}
			
			if (obj.res == "true") {
				location.href=_gScheme;						
										
			} else {
				/*
				var downlink = "itms-services://?action=download-manifest&url=https%3A%2F%2Fmiaps.thinkm.co.kr%2Fmiaps5%2Fapp%2FappInstall.miaps%3Fq%3DxKAORUZMkvPIm4F409LzqQ%253D%253D%26filegubun%3DmanifestFile%26platformCd%3D2000013";
				if (miaps.MobilePlatform.Android()) {
					downlink = "http://miaps.thinkm.co.kr/miaps5/app/appInstall.miaps?q=Np%2BSU4zeeys7KgBPdfC2Yg%3D%3D&filegubun=appFile&platformCd=2000012";
				}
				alert(downlink);
				location.href=downlink;
				*/
				if (window.confirm("앱이 설치되어 있지 않습니다.\n설치페이지로 이동하시겠습니까?")) { 
					location.href = "http://miaps.thinkm.co.kr/miaps5/app/";	
	            }				
			}
		}
	};
	window._cb = callback;
});