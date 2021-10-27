require(["jquery", "miaps", "miapswp", "bootstrap",
         ], function($, miaps, miapswp) {
		
	$("#btnBack").on("click", function() {window.history.back();});
	
	
	$('#ked-show').on('click', function() {
		/*var config = {
				type : 'extlib',
				param : {
					name: 'ked', 
					method: 'ked_show', 
					param: { key1 : 'value1', key2: 'value2'}, 
					res: ''
				},
				callback : '_cb.mobileTest'
		}
		miaps.mobile(config, _cb.mobileTest);
		*/	
		var config = {
			type : 'extlib',
			param : {
				name: 'ked', 
				method: 'ked_show', 
				param: { url : 'http://miaps.thinkm.co.kr/miaps5/kedCallTest.jsp',
					 post: JSON.stringify({
						key1: 'value1',
						key2: 'value2'
					 }),
					 show: true					 
				},
				res: ''
			},
			callback : ''
		}

		var configJsonStr = JSON.stringify(config);

		/* Android */
		if (navigator.userAgent.match(/Android/i)) {
			window.MiAPS.mobile(encodeURIComponent(configJsonStr));
		/* iPhone/iPad */
		} else if (navigator.platform.match(/iPhone|iPad|iPod/i)) {
			var scheme ="MiapsHybrid://mode=mobile&param=" + encodeURIComponent(configJsonStr);
			window.webkit.messageHandlers.miapshybrid.postMessage(scheme);
		} else {
			alert("모바일에서 테스트 가능 합니다.");
		}
	});
	
	$('#espider-driver-license').on('click', function() {
		var config = {
				type : 'extlib',
				param : {
					name: 'espider', 
					method: 'CheckDriverLicense', 
					param: '', 
					res: ''
				},
				callback : '_cb.mobileTest'
		}
		miaps.mobile(config, _cb.mobileTest);
	});
	
	$('#espider-driver-license-wp').on('click', function() {
		// venderName, methodName, param, callback
		miapswp.callthirdParty('espider', 'CheckDriverLicense', '', 
			function(data) {
				var obj = miaps.parse(data);				
				alert(JSON.stringify(obj).replace(/,"/g, ',\n"'));
			});
	});	

	// nfilter 키보드 닫기 (스크립트로 닫기) 
	function closeKeyPad(callbackFunc) {
		miapswp.callthirdParty("nfilter", "closeview", null, function(data){
			//$("body").removeClass("isKeypadOpen");
			if(callbackFunc){
				callbackFunc();
			}
		})
	}
	
	$('#nfilter-full-str').on('click', function() {
		// venderName, methodName, param, callback
		miapswp.callthirdParty('nfilter', 'showKeypad', {
				"type" : "full"	
				,"mode" : "char"		         
		        ,"title" : "문자를 입력 하세요." // type full전용
		        ,"maxlength": "10" // 입력 최대 길이
				,"e2e" : "true"
				,"plaindataenable": true
				,"info": ""
				,"errormessage": ""
		        ,"publickey" : "공용키" // 키패드 호출 전 미리 받아와야 합니다.
			}, 
			function(data) {
				/* [결과]
				성공
				{
					code: 200
					res:{
						"cmd":"done",
						"length":입력된 문자 길이,
						"encdata":enc데이터 값,
						"aesencdata":aesenc 데이터 값,
						"plaindata":plain 데이터값,
						"dummy":더미값
					};
				}
				
				취소
				{
					code: 201
					res:{
						"cmd":"cancel",
					};
				}
				
				글자가 입력 되었을때 
				{
					code: 200
					res:{
						"cmd":"changing",
						"length":입력된 문자 길이,
						"dummy":더미값
					};
				}
				*/
				var obj = miaps.parse(data);				
				alert(JSON.stringify(obj, null, 4));
			});
	});	
	
	$('#nfilter-half-str').on('click', function() {
		// venderName, methodName, param, callback
		miapswp.callthirdParty('nfilter', 'showKeypad', {
		        "mode" : "char"
		        ,"type" : "half" 
		        ,"title" : ""
		        ,"maxlength": "10"
		        ,"e2e" : "true"
		        ,"publickey" : "공용키"
			}, 
			function(data) {
				/* [결과]
				성공
				{
					code: 200
					res:{
					"cmd":"done",
					"length":입력된 문자 길이,
					"encdata":enc데이터 값,
					"aesencdata":aesenc 데이터 값,
					"dummy":더미값};
				}
				
				취소
				{
					code: 201
					res:{
						"cmd":"cancel",
					};
				}
				
				글자가 입력 되었을때
				{
					code: 200
					res:{
						"cmd":"changing",
						"length":입력된 문자 길이,
						"dummy":더미값
					};
				}
				*/
				var obj = miaps.parse(data);				
				alert(JSON.stringify(obj, null, 4));
			});
	});	
	
	$('#nfilter-full-num').on('click', function() {
		// venderName, methodName, param, callback
		miapswp.callthirdParty('nfilter', 'showKeypad', {
		        "mode" : "num"
		        ,"type" : "full" 
		        ,"title" : "숫자를 입력하세요."
		        ,"maxlength": "6"
		        ,"e2e" : "true"
		        ,"publickey" : "공용키"
			}, 
			function(data) {
				/* [결과]
				성공
				{
					code: 200
					res:{
					"cmd":"done",
					"length":입력된 문자 길이,
					"encdata":enc데이터 값,
					"aesencdata":aesenc 데이터 값,
					"dummy":더미값};
				}
				
				취소
				{
					code: 201
					res:{
						"cmd":"cancel",
					};
				}
				
				글자가 입력 되었을때
				{
					code: 200
					res:{
						"cmd":"changing",
						"length":입력된 문자 길이,
						"dummy":더미값
					};
				}
				*/
				var obj = miaps.parse(data);				
				alert(JSON.stringify(obj, null, 4));
			});
	});	
	
	$('#nnfilter-half-num').on('click', function() {
		// venderName, methodName, param, callback
		miapswp.callthirdParty('nfilter', 'showKeypad', {
		        "mode" : "num"
		        ,"type" : "half" 
		        ,"title" : ""
		        ,"maxlength": "6"
		        ,"e2e" : "true"
		        ,"publickey" : "공용키"
			}, 
			function(data) {
				/* [결과]
				성공
				{
					code: 200
					res:{
					"cmd":"done",
					"length":입력된 문자 길이,
					"encdata":enc데이터 값,
					"aesencdata":aesenc 데이터 값,
					"dummy":더미값};
				}
				
				취소
				{
					code: 201
					res:{
						"cmd":"cancel",
					};
				}
				
				글자가 입력 되었을때
				{
					code: 200
					res:{
						"cmd":"changing",
						"length":입력된 문자 길이,
						"dummy":더미값
					};
				}
				*/
				var obj = miaps.parse(data);				
				alert(JSON.stringify(obj, null, 4));
			});
	});			
					
	$('#eightbyte-set-token').on('click', function() {
		// venderName, methodName, param, callback
		miapswp.callthirdParty('eightbyte', 'setToken', {
			        "em" : "em값"
			        ,"pin": "pin값"
			        ,"rnd": "rnd값"
			        ,"msg": "msg값"
				}, 
				function(data) {
				/* [결과]
				성공
				{
					code: 200
					res:{
							"signData": "값", -> 전자서명값
							"code": "0",
							"msg" : ""
						}
				}
				실패
				{
					code: 200
					res:{
							"signData": "", 
							"code": "값", -> 에러코드
							"msg" : ""
						}
				}	
				*/
				var obj = miaps.parse(data);				
				alert(JSON.stringify(obj, null, 4));
			});
	});	
	
	$('#eightbyte-del-token').on('click', function() {
		// venderName, methodName, param, callback
		miapswp.callthirdParty('eightbyte', 'delToken', "", 
				function(data) {
				/* [결과]
				{
					code: 200
					,res: ""
				}
				*/
				var obj = miaps.parse(data);				
				alert(JSON.stringify(obj, null, 4));			
			});
	});	
	
	$('#eightbyte-get-pin-signdata').on('click', function() {
		// venderName, methodName, param, callback
		miapswp.callthirdParty('eightbyte', 'getPinSignData', {
			 		pin : "pin값"
        			,rnd : "rnd값"
        			,msg : "msg값"
				}, 
				function(data) {
					/* [결과]
					{
						"signData": "값" 
						,"code": "0"
						,"msg" : "" 
					}
					*/
					var obj = miaps.parse(data);				
					alert(JSON.stringify(obj, null, 4));		
			});
	});	
	
	$('#eightbyte-set-bio-authdata').on('click', function() {
		// venderName, methodName, param, callback
		miapswp.callthirdParty('eightbyte', 'setBioAuthData', {
			 		pin : "pin값"
        			,rnd : "rnd값"
        			,msg : "msg값"
				}, 
				function(data) {
					/* [결과]
					{
						"code": "0"
						,"msg" : "" 
					}
					*/
					var obj = miaps.parse(data);				
					alert(JSON.stringify(obj, null, 4));		
			});
	});	
	
	$('#eightbyte-del-bio-authdata').on('click', function() {
		// venderName, methodName, param, callback
		miapswp.callthirdParty('eightbyte', 'delBioAuthData', "", 
				function(data) {
					/* [결과]
					{
						"code": "0"
						,"msg" : "" 
					}
					*/
					var obj = miaps.parse(data);				
					alert(JSON.stringify(obj, null, 4));			
			});
	});	
	
	$('#eightbyte-get-bio-signdata').on('click', function() {
		// venderName, methodName, param, callback
		miapswp.callthirdParty('eightbyte', 'getBioSignData', {
        			rnd : "rnd값"
        			,msg : "msg값"
				}, 
				function(data) {
					/* [결과]
					{
						"signData": "값" 
						,"code": "0"
						,"msg" : "" 
					}
					*/
					var obj = miaps.parse(data);				
					alert(JSON.stringify(obj, null, 4));			
			});
	});	
	
	$('#eightbyte-set-pattern-authdata').on('click', function() {
		// venderName, methodName, param, callback
		miapswp.callthirdParty('eightbyte', 'setPatternAuthData', {
        			"pin" : "pin값"
			        ,"rnd": "rnd값"
			        ,"msg": "msg값"
			        ,"flag": flag값 // 색, 라인 표시 "true" / "false"
			        ,"desc": "desc값"  //  제목
			        ,"showLinkFlag": "showLinkFlag값"
				}, 
				function(data) {
					/* [결과]
					{
						"signData": "값" 
						,"code": "0"
						,"msg" : "" 
					}
					*/
					var obj = miaps.parse(data);				
					alert(JSON.stringify(obj, null, 4));		
			});
	});	
	
	$('#eightbyte-chg-pattern-authdata').on('click', function() {
		// venderName, methodName, param, callback
		miapswp.callthirdParty('eightbyte', 'chgPatternAuthData', {
			        "rnd": "rnd값"
			        ,"msg": "msg값"
			        ,"flag": flag값 // 색, 라인 표시 "true" / "false"
			        ,"desc": "desc값"  //  제목
					,"count": "count값"
			        ,"showLinkFlag": "showLinkFlag값"
				}, 
				function(data) {
					/* [결과]
					{
						"signData": "값" 
						,"code": "0"
						,"msg" : "" 
					}
					*/
					var obj = miaps.parse(data);				
					alert(JSON.stringify(obj, null, 4));		
			});
	});	
	
	$('#eightbyte-del-pattern-authdata').on('click', function() {
		// venderName, methodName, param, callback
		miapswp.callthirdParty('eightbyte', 'delPatternAuthData', {
			        "rnd": "rnd값"
			        ,"msg": "msg값"			        
				}, 
				function(data) {
					/* [결과]
					{
						"code": "0"
						,"msg" : "" 
					}
					*/
					var obj = miaps.parse(data);				
					alert(JSON.stringify(obj, null, 4));		
			});
	});	
	
	$('#eightbyte-get-pattern-authdata').on('click', function() {
		// venderName, methodName, param, callback
		miapswp.callthirdParty('eightbyte', 'getPatternSignData', {
			        "rnd": "rnd값"
			        ,"msg": "msg값"
			        ,"flag": flag값 // 색, 라인 표시 "true" / "false"
			        ,"desc": "desc값"  //  제목
					,"count": "count값"
			        ,"showLinkFlag": "showLinkFlag값"
				}, 
				function(data) {
					/* [결과]
					{
						"signData": "값" 
						,"code": "0"
						,"msg" : "" 
					}
					*/
					var obj = miaps.parse(data);				
					alert(JSON.stringify(obj, null, 4));			
			});
	});
	
	$('#eightbyte-set-otp-token').on('click', function() {
		// venderName, methodName, param, callback
		miapswp.callthirdParty('eightbyte', 'setOtpToken', {
			        "uid" :"uid값"
			        ,"org": "org값"
			        ,"rnd": "rnd값"
			        ,"msg": "msg값"
			        ,"digit": "digit값"
			        ,"pin": "pin값"
			        ,"token": "token값"
				}, 
				function(data) {
					/* [결과]
					{
						"signData": "값" 
						,"code": "0"
						,"msg" : "" 
					}
					*/
					var obj = miaps.parse(data);				
					alert(JSON.stringify(obj, null, 4));		
			});
	});
	
	$('#eightbyte-del-otp-token').on('click', function() {
		// venderName, methodName, param, callback
		miapswp.callthirdParty('eightbyte', 'delOtpToken', "",
				function(data) {
					/* [결과]
					{
						"signData": "값" 
						,"code": "0"
						,"msg" : "" 
					}
					*/
					var obj = miaps.parse(data);				
					alert(JSON.stringify(obj, null, 4));			
			});
	});
	
	$('#eightbyte-get-otp-signdata').on('click', function() {
		// venderName, methodName, param, callback
		miapswp.callthirdParty('eightbyte', 'getOtpSignData', {
			        "pin" : "pin값"
			        ,"rnd": "rnd값"
			        ,"msg": "msg값"
			        ,"digit": "digit값"
				}, 
				function(data) {
					/* [결과]
					{
						"signData": "값" 
						,"code": "0"
						,"msg" : "" 
					}
					*/
					var obj = miaps.parse(data);				
					alert(JSON.stringify(obj, null, 4));			
			});
	});
	
	$('#eightbyte-get-otp-numdata').on('click', function() {
		// venderName, methodName, param, callback
		miapswp.callthirdParty('eightbyte', 'getOtpNumData', {
			       	"digit" : "uid값"
			        ,"pin": "org값"
			        ,"rnd": "rnd값"
			        ,"msg": "msg값"
			        ,"digit": "digit값"
				}, 
				function(data) {
					/* [결과]
					{
						"otp": "값" 
						,"code": "0", 
						,"msg": "" 
					}
					*/
					var obj = miaps.parse(data);				
					alert(JSON.stringify(obj, null, 4));		
			});
	});
	
	$('#eightbyte-get-qr-signdata').on('click', function() {
		// venderName, methodName, param, callback
		miapswp.callthirdParty('eightbyte', 'getQRSignData', {
			       	"publicKey" : "publicKey값",
				}, 
				function(data) {
					/* [결과]
					{
						"signData": "값" 
						,"code": "0", 
						,"msg": "" 
					}
					*/
					var obj = miaps.parse(data);				
					alert(JSON.stringify(obj, null, 4));		
			});
	});
	
	$('#inzi-get-ocr-imagedata').on('click', function() {
		// venderName, methodName, param, callback
		miapswp.callthirdParty('inzi', 'getOcrImageData', "", 
				function(data) {
					var obj = miaps.parse(data);				
					alert(JSON.stringify(obj, null, 4));		
			});
	});
	
	$('#mpush-init').on('click', function() {
		// venderName, methodName, param, callback
		miapswp.callthirdParty('mpush', 'init', {
					"cuid" :""
    				,"cname":""
				}, 
				function(data) {
					var obj = miaps.parse(data);				
					alert(JSON.stringify(obj, null, 4));		
			});
	});
	
	$('#inca-get-deviceinfo').on('click', function() {
		// venderName, methodName, param, callback
		miapswp.callthirdParty('inca', 'getDeviceInfo', {
					"serverKey" :"값"
				}, 
				function(data) {
					var obj = miaps.parse(data);				
					alert(JSON.stringify(obj, null, 4));		
			});
	});
		
	/* ---- callback function ---- */ 
	var callback = {	
		mobileTest : function(data) {
			miaps.cursor(null, 'default');
						
			var obj = miaps.parse(data);
			alert(JSON.stringify(obj, null, 4));
		}
	};
	window._cb = callback;	
});