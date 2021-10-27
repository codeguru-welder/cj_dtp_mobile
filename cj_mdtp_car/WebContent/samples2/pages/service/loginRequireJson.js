require(["jquery", "miaps", "bootstrap"
         ], function($, miaps) {
	
	$(function(){
      	$("#btnLogin").on("click", goLogin);
      	$("#btnBack").on("click", function() {window.history.back();});      	
	});
	
	function goLogin() {
		miaps.cursor('iconLogin', 'wait', true);
		
		var params = {
			userId : 'miaps',
			userPw : 'miaps'
		};
		
		console.log(JSON.stringify(params));
		
		miaps.miapsSvc("com.mink.connectors.hybridtest.login.LoginMan", "login", "MIAPS-LOGIN-TEST", params, "_cb.cbLogin", _cb.cbLogin);
	}
	
	/* ---- callback function ---- 
	 * callback function은 앱에서 호출 되어야 하므로 callback.cbVerChk = function(data) {...로 작성하지 않고 callback.cbVerChk = function cbVerChk(data) {...처럼 함수명을 function뒤에 명시하도록 한다.
	 * 제일 마지막에 window._cb = callback; 명령으로 작성한 callback객체를 어느곳에든지 호출 가능 하도록 전역화 한다.
	 */
	var callback = {	
		cbLogin : function (data) {
			miaps.cursor('iconLogin', 'default');
			console.log('typeof: ' + typeof data);
			console.log(data);
			
			//var obj = miaps.parse(data);
			var obj = miaps.parse(data);
			
			alert(obj.msg);
			return;
		}
	};
	window._cb = callback;
});