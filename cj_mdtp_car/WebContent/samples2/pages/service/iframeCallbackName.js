require(["jquery", "miaps", "bootstrap"
         ], function($, miaps) {
	
	$(function(){
      	$("#btnLogin").on("click", goLogin);
      	$("#btnBack").on("click", function() {window.history.back();});      	
      	$("#userId").on("keypress", enterLogin());
      	$("#userPw").on("keypress", enterLogin());
      	      	
		$("#userid").focus();
	});
	
	function goLogin() {
		
		miaps.cursor('iconLogin', 'wait', true);
		
		console.log("form:" + $("#loginFrm").serialize());
		
		miaps.miapsSvc("com.mink.connectors.hybridtest.login.LoginMan", "loginSession", "MIAPS-LOGIN-TEST", $("#loginFrm").serialize(), "_cb.cbLogin", _cb.cbLogin);
	}
	
	function enterLogin(obj) {
		var loginFrm = document.loginFrm;
		
		if(loginFrm.userId === obj) {
			if(loginFrm.userId.value == '') return;
			if(loginFrm.userPw.value == '') {
				$(loginFrm.userPw).focus();
				return;
			} else {
				goLogin();
			}
		}
		if(loginFrm.userPw === obj) {
			if(loginFrm.userPw.value == '') return;
			if(loginFrm.userId.value == '') {
				$(loginFrm.userId).focus();
				return;
			} else {
				goLogin();
			}
		}
	}
	
	function validation() {
		var loginFrm = document.loginFrm;
		
		var answer = false;
		
		if(loginFrm.userId.value == '') {
			alert(resources.msg.not.input.userid);
			$(loginFrm.userId).focus();
			return true;
		}
		if(loginFrm.userPw.value == '') {
			alert(resources.msg.not.input.password);
			$(loginFrm.userPw).focus();
			return true;
		}
		
		return answer;
	}
	
	var callback = {	
				
		// 로그인 커넥터 콜백
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
				console.log(document.cookie);
			}
		}		
	};
	window._cb = callback;
});