require(["jquery", "miaps", "utils", "nice-auth", "bootstrap",
         ], function($, miaps, utils) {
	
	/* ---- callback function ---- */ 
	var callback = {			
		mobileTest : function(data) {
			miaps.cursor(null, 'default');
			
			var obj = miaps.parse(data);
			
			if (typeof obj == 'object') {
				alert(JSON.stringify(obj).replace(/,"/g, ',\n"'));
			} else if (typeof obj == 'string') {
				alert(obj);
			}
		},
		
		myDeviceId : function(data) {
			var obj = miaps.parse(data);
			utils.sessions.set('my_device_id', obj.res);

			var _token = utils.sessions.get('my_device_id');
			initNiceAuth(_token, false);
		},
		
		// 본인 인증 후에 호출되는 함수 (본인인증 페이지에는 반드시 구현해야 함.)
		/*completeNiceAuth: function() {
			if (window._debug == true) {
				alert(
						'niceToken: ' + utils.sessions.get('niceToken') + '\n'
						+ 'niceName: ' + utils.sessions.get('niceName') + '\n'
						+ 'niceBirth: ' + utils.sessions.get('niceBirth') + '\n'
						+ 'niceGener: ' + utils.sessions.get('niceGender') + '\n'
					);
			}
			var _token = utils.sessions.get('dbProc_phoneDeviceId');
			//alert('_token: ' + _token);
			
			if (utils.sessions.get('niceToken') == _token) {
				
				utils.sessions.set('dbProc_niceName', utils.sessions.get('niceName'));
				utils.sessions.set('dbProc_niceBirth', utils.sessions.get('niceBirth'));
				utils.sessions.set('dbProc_niceGender', utils.sessions.get('niceGender'));
				
				openModal('본인인증에 성공하였습니다.', function() {
					$('#btn-ok').on('click', function(e){ 
						e.preventDefault();
						//closeModal();
						
						// 다음화면 이동
						window.location.href = getBaseURL(0) + 'html/nonfacing/non.facing.acnut.estbl.rrc.before.html';
					});
				});
				
			} else {
				openModal('본인인증에 실패하였습니다. 정확한 값을 입력하셨는지 확인 해 주시고, 다시 한번 시도해 주세요.', null);						
				// 더이상 진행할 수 없도록 하기.. 메인으로 돌아간다거나..
			}
		}*/
	};
	window._cb = callback;
	
	/* 본인인증 호출 전에 deviceid취득 */
	var config = {
		type: 'deviceid'
		,param: 'pctest_deviceid'
		,callback: '_cb.myDeviceId'
	};
	miaps.mobile(config, _cb.myDeviceId);
	
	
/*
	$("#btnBack").on("click", function() {window.history.back();}); 
		
	// 나이스 본인인증
	$('#btnNiceAuth').on('click', function() {		
		// 휴대폰 본인인증 화면 생성
		var _token = utils.sessions.get('my_device_id');
		initNiceAuth(_token, false);
	});
*/	

	window.miapsOnPopupReceive = function(id, data) {
		console.log("--- miapsOnPopupReceive ---");
    	console.log('id: ' + id);
		console.log(data);

		if (window._debug == true) {
			alert(
					'niceToken: ' + utils.sessions.get('niceToken') + '\n'
					+ 'niceName: ' + utils.sessions.get('niceName') + '\n'
					+ 'niceBirth: ' + utils.sessions.get('niceBirth') + '\n'
					+ 'niceGener: ' + utils.sessions.get('niceGender') + '\n'
				);
		}
		var _token = utils.sessions.get('dbProc_phoneDeviceId');
		//alert('_token: ' + _token);
		
		if (utils.sessions.get('niceToken') == _token) {
			
			utils.sessions.set('dbProc_niceName', utils.sessions.get('niceName'));
			utils.sessions.set('dbProc_niceBirth', utils.sessions.get('niceBirth'));
			utils.sessions.set('dbProc_niceGender', utils.sessions.get('niceGender'));
			
			openModal('본인인증에 성공하였습니다.', function() {
				$('#btn-ok').on('click', function(e){ 
					e.preventDefault();
					//closeModal();
					
					// 다음화면 이동
					window.location.href = getBaseURL(0) + 'html/nonfacing/non.facing.acnut.estbl.rrc.before.html';
				});
			});
			
		} else {
			openModal('본인인증에 실패하였습니다. 정확한 값을 입력하셨는지 확인 해 주시고, 다시 한번 시도해 주세요.', null);						
			// 더이상 진행할 수 없도록 하기.. 메인으로 돌아간다거나..
		}
	}
});