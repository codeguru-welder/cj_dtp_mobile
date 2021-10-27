require(["jquery", "miaps", "miapswp", "bootstrap"
         ], function($, miaps, miapswp) {
	
	$(function(){

		//miaps.isMiaps();
      	$("#btnLogin").on("click", goLogin);
      	$("#btnBack").on("click", function() {window.history.back();});      	
      	$("#userId").on("keypress", enterLogin());
		$("#userPw").on("keypress", enterLogin());
		$("#btnSessionAuto").on("click", goSessionAuto);
		$("#btnSessionCustom").on("click", goSessionCustom);
      	      	
		$("#userid").focus();
		
		// 버전체크 예제  -- 인하우스 배포 시 사용, 앱에서 자동으로 팝업 표시 및 자동 업데이트
		//MiapsHybrid.updateApp(null, null);
		//miaps.updateApp("platform_cd=2000012&sw_name=kr.co.miaps.mshop.dev", _cb.cbVerChk);
		//miaps.updateApp("platform_cd=2000013&sw_name=kr.co.miaps.MiapsLib.MiapsLibSample", _cb.cbVerChk);
		
		// 리얼 스토어(앱스토어, 구글 플래이) 버전 체크 후 스토어 점프 - 커넥터를 이용해서 버전 확인 후 콜백에서 스토어 점프
		var param = {};
		param.platformCd = '2000013';
		param.packageNm = 'kr.co.miaps.MiapsLib.MiapsLibSample';
		miaps.miapsSvc("com.thinkm.mink.connector.hybrid.AppVerChkHybrid", "appVerChk", "MIAPS-HYBRID-APPVERCHK", param, "_cb.cbVerChkHybrid", _cb.cbVerChkHybrid);
		
		/*console.log(navigator.userAgent);
		if(miaps.MobilePlatform.Android()) {
			console.log("andorid");
		} else if (miaps.MobilePlatform.iPhone()) {
			console.log("iPhone");
		} else if (miaps.MobilePlatform.iPad()) {
			console.log("iPad");
		} else if (miaps.MobilePlatform.Opera()) {
			console.log("Opera");
		} else if (miaps.MobilePlatform.Windows()) {
			console.log("Windows");
		} else if (miaps.MobilePlatform.BlackBerry()) {
			console.log("blackberry");
		} else {
			console.log("unknown");
		}
		
		miaps.mobile({
	            "type" : "loadvalue",
	            "param" : {
	                "id" : "",
	                "pw" : ""
	            },
	            "callback" : "_cd.cbLoadAccount"
		}, _cb.cbLoadAccount);
		*/
	});

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
	
	function goLogin() {
		
		miaps.cursor('iconLogin', 'wait', true);
		
		console.log("form:" + $("#loginFrm").serialize());
		
		//miaps.miapsSvc("com.mink.connectors.hybridtest.login.LoginMan", "login", "MIAPS-LOGIN-TEST", $("#loginFrm").serialize(), "_cb.cbLogin", _cb.cbLogin);	
		
		miapswp.callService("com.mink.connectors.cjlogistics.login.LoginMan", 
			"login", { 
				userId : 'miaps',
				userPw : 'miaps' 
			}, function(data) {
				miaps.cursor('iconLogin', 'default');
				var obj = miaps.parse(data);
				console.log(JSON.stringify(obj).replace(/,"/g, ',\n"'));
			});
		
		/*miaps.miapsSvcEx({
			class: 'com.mink.connectors.hybridtest.login.LoginMan'
			,method: 'login'
			,params: {
				userId: 'miaps'
				,userPw: 'miaps'
			}
		},
		_cb.cbLogin
		function(data) {
			miaps.cursor('iconLogin', 'default');
			var obj = miaps.parse(data);
			console.log(JSON.stringify(obj).replace(/,"/g, ',\n"'));
		}
		);*/
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
	
	/* ---- callback function ---- 
	 * callback function은 앱에서 호출 되어야 하므로 callback.cbVerChk = function(data) {...로 작성하지 않고 callback.cbVerChk = function cbVerChk(data) {...처럼 함수명을 function뒤에 명시하도록 한다.
	 * 제일 마지막에 window._cb = callback; 명령으로 작성한 callback객체를 어느곳에든지 호출 가능 하도록 전역화 한다.
	 */
	var callback = {	
		cbVerChk : function (data) {
			console.log('===cbVerChk callback===');
			console.log(data);
			return;
		},
		
		cbSetDeviceInfo : function (data) {
			console.log('===cbSetDeviceInfo callback===');
			console.log(data);
			return;
		},
		
		cbLoadAccount : function(data) {
			console.log('===cbLoadAccount callback===');
            var loadVal = JSON.parse(data).res;
            console.debug("loadVal : ", loadVal);
            if (loadVal) {
                $("#userId").val(loadVal.id);
                $("#userPw").val(loadVal.pw);

               /* if (cmmUtil.nvlB(loadVal.id) !== "") {
                    $("#saveID").prop("checked", true);
                }*/
            }
        },
		
		cbLogin : function (data) {
			console.log('===cbLogin callback===');
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
				
				
				
				 miaps.mobile({
		            "type" : "savevalue",
		            "param" : {
		                "id" : $("#userId").val(),
		                "pw" : $("#userPw").val()
		            }
		        }, function(){});
			
				
				// SetDeviceInfo 예제 
				console.log(obj.res.Login.userNo);
				console.log(obj.res.Login.userId);
				console.log(obj.res.Login.userPw);
				console.log(obj.res.Login.groupId);
				//userid, userpw, userno, groupid, cb_func
				miaps.setDeviceInfo(obj.res.Login.userId, '', '', '', _cb.cbSetDeviceInfo);
				//miaps.setDeviceInfo(obj.res.Login.userId, '', '', '', null);
				
				// 바로 페이지 이동하면 setDeviceInfo가 실행되지 않아서 타이머를 넣어봄
				/*setTimeout(function() {
					location.href='index.html';
					//location.href="http://miaps.thinkm.co.kr/miaps5/hybrid2/webtest.html";
				}, 1000);
				*/

				

				return;
			}
		}, 
		
		cbVerChkHybrid: function(data) {
			console.log('===cbVerChkHybrid callback===');
			var obj = miaps.parse(data);				
			console.log(JSON.stringify(obj, null, 4));
			return;
		}
	};
	window._cb = callback;

	/*miaps.mobile({
		type: 'session',
		param: {
			type: 'custom',
			second: '5'
		}
	}, function(data) {
		alert('loginRequire session');
	});*/
});