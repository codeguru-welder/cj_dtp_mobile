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
	
	function getJSessionId(){
	    var jsId = document.cookie.match(/JSESSIONID=[^;]+/);
	    if(jsId != null) {
	        if (jsId instanceof Array)
	            jsId = jsId[0].substring(11);
	        else
	            jsId = jsId.substring(11);
	    }
	    return jsId;
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
				
				// 로그인 성공 후 jsp를 호출하여 해당 페이지내의 session에서 로그인한 유저ID가 취득 되는지 확인.
				var config = {
					url: "http://127.0.0.1:8080/samples2/testjsp/myTest.jsp",
					header: {},
					param: "key=string",
					callback: "_cb.cbHttpSvc"
				}
				miaps.httpSvc(config, _cb.cbHttpSvc);
			}
		},
		
		// httpSvc콜백
		cbHttpSvc: function (data) {
			
			console.log(document.cookie);
			
			if (miaps.isPC()) {
				$("#httpSvcResultDiv").html(data.trim());
			} else {
				var obj = miaps.parse(data);
				$("#httpSvcResultDiv").html(obj.res);
			}
			
			$.ajax({
				url: 'http://192.168.0.3:8080/samples2/testjsp/myTest.jsp',
				async: true,
				type: 'post',
				data: 'value11',
				dataType: 'text', // xml, json, script, html
				crossDomain: true,
				contentType: 'application/x-www-form-urlencoded; charset=utf-8',
				//contentType: 'text/plain; charset=utf-8',
				withCredentials: true,
				//beforeSend: function(xhr){ xhr.withCredentials = true;},			
				success: function (data) {
					if (miaps.isPC()) {
						console.log(data);
					} else {
						var obj = miaps.parse(data);
						console.log(obj.res);
					}
					
					console.log(document.cookie);
				},
				error: function (jqXHR, textStatus, errorThrown) {
					console.log(jqXHR, textStatus, errorThrown);
				}
			});
		}		
	};
	window._cb = callback;
});