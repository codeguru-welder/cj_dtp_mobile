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
		/*if(window._tmdebug) {				
			if (typeof data == 'object') {				
				console.log(JSON.stringify(data).replace(/,"/g, ',\n"'));
			} else if (typeof data == 'string') {				
				console.log(data);
			}
		}*/
		
		if (data != null) {
			var resValue = miaps.parse(data);

			if (resValue.type.toLowerCase() == 'push') {		// push
				/* 푸시수신확인(읽음확인) 예 */
				console.log("pushValue.res.pid: " + resValue.res.pid);
				miaps.miapsSvc("com.thinkm.mink.connector.login.Device", "receivePush", "Push-receivePush", "type=app&pushId="+resValue.res.pid, null, null);				
            }
            else if (resValue.type.toLowerCase() == 'tabcls') {	// close tab (ios)
            	;
            }
            else if (resValue.type.toLowerCase() == 'foreground') {
            	;
            }
            else if (resValue.type.toLowerCase() == 'background') {
				;
			} 
			else if (resValue.type.toLowerCase() == 'session') {	// miaps.mobile() type:session, timeout
				//alert('notify.js session callback');

				try {
					// 사용자 정의 modal 표시
					require(['/samples2/vendor/miaps/js/miaps_page.js'
						,'/samples2/resource/js/miaps_simple_modal.js']
						, function(miapsPage){
						showModal('세션이 만료 되었습니다.', 'ok', function() {
							miapsPage.closePopupAll();
							miapsPage.goTopPage();
						});					
					});
				} catch (e) {
					alert(e.message);
				}
			}
			else if (resValue.type.toLowerCase() == 'shake') {	// 흔들기 
				miaps.mobile({
					type: 'shake',
					param: ''
				}, null); // 자체 콜백없음. miaps_notify.js의 callback()함수를 사용.

				// go to Top page
				require(['/samples2/vendor/miaps/js/miaps_page.js'], function(miapsPage){
					miapsPage.goTopPage();															
				});
			}
			else if (resValue.type.toLowerCase() == 'openurl') {	// Scheme호출 

			}
			else if (resValue.type.toLowerCase() == 'savedataurl') {	// 사진(갤러리)앱에 이미지 추가 완료 

			}
		}
	}
		
	window._miapsnotify = callback; // use general	
	return callback;	// use AMD
}));