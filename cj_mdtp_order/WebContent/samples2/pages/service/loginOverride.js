require(["jquery", "miaps", "miapsoverride", "bootstrap"
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
		/*
		miaps.miapsSvcSp("com.mink.connectors.hybridtest.login.LoginMan", 
			"login", 
			$("#loginFrm").serialize(), 
			function(data) {
				miaps.cursor('iconLogin', 'default');
				console.log(data);
				var obj = miaps.parse(data);
				alert(obj.msg);				
			});
		*/
		
		// get application.json infomation
		miaps.mobile({
			type: 'applicationinfo',
			param : ''
		}, function(data) {
			var obj = miaps.parse(data);
			//alert(obj.common.serverurl);

			var _url = 'http://localhost:8080/hybrid/loginTest.miaps';
			if (!miaps.isPC()) {
				_url = obj.res.common.serverurl + '/hybrid/loginTest.miaps';	
			} 			

			$.post(_url,
				$("#loginFrm").serialize(),
				function(data) {
					miaps.cursor('iconLogin', 'default');
					console.log(data);
					var obj = miaps.parse(data);
					var resObj = miaps.parse(obj.res);
					alert(resObj.msg);				
				});
		});
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
});