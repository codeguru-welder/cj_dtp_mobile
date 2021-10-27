require(["jquery", "miaps", "pattern-lock", "bootstrap"
         ], function($, miaps, PatternLock) {
	
	//$(function(){
		$("#btnReset").on("click", goReset);
      	$("#btnBack").on("click", function() {window.history.back();});
	//});
	
	function goReset() {
		console.log("reset");
		lock.reset();
	}
	
	// 패턴 입력 끝, 호출되는 콜백, userid와 패턴을 파라메터로 통신하여 로그인 한다.
	function cbPatternEnd(data) {
		console.log("pattern value:" + data);
		
		/* 일반 서블릿 
		$.post("/miaps/hybrid2/regPattern.miaps", {pt: data}, 
			function (data, status){
				alert(data);
			});
		*/
		
		// miaps 통신
		miaps.miapsSvc("com.mink.connectors.hybridtest.login.PatternLoginMan", "login", "MIAPS-PATTERN-LOGIN", "userId=miaps&pt=" + data, "_cb.cbLogin", _cb.cbLogin);
	}
	
	var callback = {	
		cbLogin : function (data) {
			miaps.cursor('iconLogin', 'default');
			console.log('typeof: ' + typeof data);
			console.log(data);
			
			//var obj = miaps.parse(data);
			var obj = miaps.parse(data);
						
			// errCode, errMsg
			if (obj.code != '0') {
				alert(obj.msg);
				return;
			}
			
			if (obj.code == '0') {
				alert(obj.msg);
				
				setTimeout(function() {
					location.href='../../index.html';					
				}, 1000);
				
				return;
			}
		}
	};
	window._cb = callback;
		
	var option = {
			matrix: [3, 3],
	        margin: 20,
	        radius: 25,
	        patternVisible: true,
	        lineOnMove: true,
	        delimiter: "", // a delimiter between the pattern
	        enableSetPattern: false,
	        allowRepeat: true
	};
	
	var lock = new PatternLock("#patternContainer", option);
  	lock.checkForPattern("", cbPatternEnd, null);
});