(function (factory) {
    //Environment Detection
    if (typeof define === 'function' && define.amd) {
        //AMD
        define([], factory);
    } else {
        // Script tag import i.e., IIFE
    	factory();
  }
}(function () {
	
	if(window._tmdebug) {
		console.log("start miapsnotify");
	}
	
	/**
	 * 공통알림 함수
	 * @param  data
	 * Push Message의 경우 - data : {"code":"200", "type":"push", "res": 
	 * 								{"msg":"푸시메시지", "pid":"푸시ID", "tsk":"푸시업무ID", "rmk":"Text|http://miaps.thinkm.co.kr/miaps5/minkSvc?command=resfile&i=21&f=392x244_2.jpg|", "app":"", "frm":""}
	 * 						}
	 * Timer의 경우 - {"code":"200", "msg":"", "type":"timer", "res":"시간 및 메시지"}
	 * Tab Close의 경우 - {"code":"200", "msg":"", "type":"timer", "res":"탭ID"}
	 * Backgroud event의 경우 - {"code":"200", "msg":"", "type":"background", "res":""}
	 * Foregroud evnet의 경우 - {"code":"200", "msg":"", "type":"foreground", "res":""} 
	 */
	var	callback = function(data) {
		/* 푸시수신확인(읽음확인) 예 */
		if (data != null) {
			var resValue = miaps.parse(data);

			if (window._tmdebug) console.log(JSON.stringify(resValue).replace(/,"/g, ',\n"'));

			if (resValue.type.toLowerCase() == 'push') {
				console.log("pushValue.res.pid: " + resValue.res.pid);
				miaps.miapsSvcSp("com.thinkm.mink.connector.login.Device", "receivePush", "type=app&pushId="+resValue.res.pid, function(data) {
					console.log('읽음 확인 완료');	
				});				
				try {
					// 사용자 정의 modal 표시	
					var push_msg;
					//and, ios 메시지 경로가 서로 다름
					if (miaps.isIOS()) {
						console.log("resValue.res.aps.alert: " + resValue.res.aps.alert);
						push_msg = resValue.res.aps.alert;
					} else	{
						console.log("resValue.res.msg: " + resValue.res.msg);
						push_msg = resValue.res.msg;
					}
					showModal(push_msg, 'OK');										

				} catch (e) {
					console.log(e.message);
					alert(e.message);
				}
            }
            else if (resValue.type.toLowerCase() == 'tabcls') {
            	;
            }
            else if (resValue.type.toLowerCase() == 'foreground') {
            	;
            }
            else if (resValue.type.toLowerCase() == 'background') {
				;
			} 
			else if (resValue.type.toLowerCase() == 'session') {
				alert('notify.js session callback');
			}
		}
	}
		
	window._miapsnotify = callback; // use general	
	return callback;	// use AMD
}));