require(["jquery", "miaps", "miapswp", "bootstrap"
         ], function($, miaps, miapswp) {
	
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
		
		var param = {};
		param.id = $("#userId").val();
		param.pw = $("#userPw").val();
		
		// param1키명으로 json string 전달
		miapswp.callService('com.mink.connectors.hybridtest.receivedata.ReceiveDataMan',
				'receiveData',
				'param1=' + JSON.stringify(param)
			).then(function(result) {				
				console.log(result);
			});
		
				
		// 객체를 key=value&key=value형태로 전달 (이름없는 json object를 넣으면 내부에서 key=value&~스타일로 변경합니다)
		/*miapswp.callService('com.mink.connectors.hybridtest.receivedata.ReceiveDataMan',
				'receiveData',
				param,
				function(result) {
					console.log(result);
			}, function(error) {
					console.log(error);
			});
		*/
		
		// 여러 개의 객체를 합쳐서 하나로 전달
		/*miapswp.callService('com.mink.connectors.hybridtest.receivedata.ReceiveDataMan',
				'receiveData',
				{id: param.id, pw: param.pw},
				{test: 'testvalue'},
				function(result) {
					console.log(result);
			}, function(error) {
					console.log(error);
			});
		*/
		
		//miaps.miapsSvc("com.mink.connectors.hybridtest.login.LoginMan", "login", "MIAPS-LOGIN-TEST", $("#loginFrm").serialize(), "_cb.cbLogin", _cb.cbLogin);
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
});