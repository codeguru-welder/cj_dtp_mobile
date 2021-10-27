require(["jquery",         
		 "miaps", 
		 "miapspage",
		 "miaps-modal"	 
         ], function($,miaps, miapspage) {

    $(".back_btn").on("click", function (e) {
        e.preventDefault();
        // 네이티브 기능 페이지 이동
        miapsPage.back();
    });

    $(".home_btn").on("click", function (e) {
        e.preventDefault();
        // 메인 페이지 이동
        miapsPage.goTopPage();
    });

	// 지문인식
    // 1. 지문인식 기능을 지원하지 않을 경우 (iPhone 5s 이전 모델) : 8801
    // 2. 지문인식 기능을 가지고 있지만 사용설정을 안했을 경우 : 8802
    // 3. 지문인식 기능을 설정했으나 지문인식이 실패할 경우(ex 등록된 지문이없다) : 8803
    // 4. 지문인식 기능이 잠겼을 경우(iOS는지문인식 실패가 많으면 기능이꺼진다.5번) : 8804
    // 5. 취소 버튼을 눌렀을 경우 : 8805
    // 6. 권한이 없는 경우(안드로이드) : 8806
    // 7. 지문인식 성공 : 8800
    $('#finger').on('click', function() {
        miaps.mobile({
            type : 'FINGER',
            param : 'start'               
        }, function(data) {
            var obj = miaps.parse(data);
            if(obj.code != 200) {
				alert(obj.msg);
				return;
			}
              
            if (obj.res === 8801) {                
                showModal(`지문인식 기능을 지원하지 않습니다.\n ${obj.res}`, '확인');
            } else if(obj.res === 8802) {
                showModal(`지문인식 사용설정을 확인하세요.\n ${obj.res}`, '확인');
            } else if(obj.res === 8803) {
                showModal(`지문인식에 실패하였습니다.\n ${obj.res}`, '확인');
            } else if(obj.res === 8804) {
                showModal(`지문인식이 잠겼습니다.\n ${obj.res}`, '확인');
            } else if(obj.res === 8805) {
                showModal(`지문인식이 취소되었습니다.\n ${obj.res}`, '확인');
            } else if(obj.res === 8806) {
                showModal(`지문인식 권한이 없습니다.\n ${obj.res}`, '확인');
            } else if(obj.res === 8800) {
                showModal(`지문인식에 성공하였습니다.\n ${obj.res}`, '확인');
            }
        });            
    });

    // 지문 지원체크
    // true:지문인식 장치지원
    // false:지문인식 장치지원하지 않음
    $('#finger-checkdevice').on('click', function() {
        miaps.mobile({
                type : 'FINGER',
                param : 'checkdevice'
        }, function(data) {
            var obj = miaps.parse(data);
            if(obj.code != 200) {
				alert(obj.msg);
				return;
			}

            if (obj.res === "true") {                
                showModal(`지문인식 장치를 지원합니다.\n ${obj.res}`, 'OK');              
            } else  {
                showModal(`지문인식 장치를 지원하지않습니다.\n ${obj.res}`, 'OK');  
            }
        });
    });
    
    // 지문 등록여부 확인
    // true:지문등록 되어있음
    // false:지문이 등록되어 있지 않음
    $('#finger-checkreg').on('click', function() {
        miaps.mobile({
            type : 'FINGER',
            param : 'checkreg'
        }, function(data) {
            var obj = miaps.parse(data);
            if(obj.code != 200) {
				alert(obj.msg);
				return;
			}

            if (obj.res === "true") {                
                showModal(`지문등록이 되어있습니다.\n ${obj.res}`, 'OK');                
            } else  {
                showModal(`지문등록이 되어있지 않습니다.\n ${obj.res}`, 'OK');
            }
        });
    });
    
    /* iOS Touch-ID, Face-ID 구분
     * iOS11부터는 내부 API로 구분할 수 있음. 이전 단말은 스크립트에서 단말모델 값으로 구분하도록 함.
    0: 생체인식을 지원하지 않는 장치
    1: TouchID
    2: FaceID (iOS 11 이상 사용가능)
     */
    $('#ios-id').on('click', function() {
        if (miaps.isAndroid()) {
            showModal('Android is not supported','OK');
            return;
        }
        
        // Check OS version
        miaps.mobile({
            type : 'PLATFORMVERSION',
            param : '10'
        }, function(data) {
            var obj = miaps.parse(data);
            if (obj.res && (typeof obj.res == 'string')) {
                var osVersion = Number(obj.res);
                // iOS11보다 크면 OS제공 API를 사용한다.
                if (osVersion >= 11) {
                    showModal('네이티브 사용 테스트 입니다.','OK');
                //if (osVersion >= 20) { // 아래쪽 스크립트 테스트 시 사용.
                    miaps.mobile({
                        type: 'FINGER',
                        param: 'checktype'
                    }, function(data) {
                        obj = miaps.parse(data);
                        if (obj.res == '0') {
                            showModal('생체인식을 지원하지 않는 장치 입니다.','OK');
                        } else if (obj.res == '1') {
                            showModal('Touch ID 지원 장치 입니다.','OK');
                        } else if (obj.res == '2') {
                            showModal('Face ID 지원 장치 입니다.','OK');
                        }
                    });
                // iOS11보다 이전 버전이면 스크립트로 처리한다. 매년 새 모델 발표 시 갱신 필요.	
                // 참고사이트 https://everyi.com/by-identifier/ipod-iphone-ipad-specs-by-model-identifier.html
                } else { // 0:없음, 1:TouchID, 2:FaceID
                    
                    var iPhone = {
                         'iPhone1,1'	:'0'																				//iPhone
                        ,'iPhone1,2'	:'0'	,'iPhone1,2*'	:'0'														//iPhone 3G
                        ,'iPhone2,1'	:'0'	,'iPhone2,1*'	:'0'														//iPhone 3GS
                        ,'iPhone3,1'	:'0'	,'iPhone3,2'	:'0'	,'iPhone3,3'	:'0'								//iPhone 4
                        ,'iPhone4,1'	:'0'	,'iPhone4,1*'	:'0'														//iPhone 4s
                        ,'iPhone5,1'	:'0'	,'iPhone5,2'	:'0'	,'iPhone5,3'	:'0'	,'iPhone5,4'	:'0'		//iPhone 5, 5c
                        ,'iPhone6,1'	:'1'	,'iPhone6,2'	:'1'														//iPhone 5s
                        ,'iPhone7,2'	:'1'	,'iPhone7,1'	:'1'														//iPhone 6
                        ,'iPhone8,1'	:'1'	,'iPhone8,2'	:'1'														//iPhone 6s
                        ,'iPhone8,4'	:'1'																				//iPhone SE
                        ,'iPhone9,1'	:'1'	,'iPhone9,3'	:'1'	,'iPhone9,2'	:'1'	,'iPhone9,4'	:'1'		//iPhone7
                        ,'iPhone10,1'	:'1'	,'iPhone10,2'	:'1'	,'iPhone10,4'	:'1'	,'iPhone10,5'	:'1'		//iPhone 8
                        ,'iPhone10,3'	:'2'	,'iPhone10,6'	:'2'														//iPhone X
                        ,'iPhone11,2'	:'2'	,'iPhone11,4'	:'2'	,'iPhone11,6'	:'2'								//iPhone XS 
                        ,'iPhone11,8'	:'2'																				//iPhone XR
                        ,'iPhone12,1'	:'2'	,'iPhone12,3'	:'2'	,'iPhone12,5'	:'2'								//iPhone 11
                        ,'iPhone12,8'	:'1'																				//iPhone SE2
                        ,'iPhone13,1'	:'2'	,'iPhone13,2'	:'2'	,'iPhone13,3'	:'2'	,'iPhone13,4'	:'2'		//iPhone 12
                    };
                    var iPad = {
                        'iPad1,1'	:'0'																					// iPad
                        ,'iPad2,1'	:'0'	,'iPad2,2'	:'0'	,'iPad2,3'	:'0'	,'iPad2,4'	:'0'						// iPad2
                        ,'iPad3,1'	:'0'	,'iPad3,2'	:'0'	,'iPad3,3'	:'0'											// iPad 3rd Gen
                        ,'iPad3,4'	:'0'	,'iPad3,4'	:'0'	,'iPad3,4'	:'0'											// iPad 4rd Gen
                        ,'iPad6,11'	:'1'	,'iPad6,12'	:'1'																// iPad 9.7" 5th Gen
                        ,'iPad7,5'	:'1'	,'iPad7,6'	:'1'																// iPad 9.7" 6th Gen
                        ,'iPad7,11'	:'1'	,'iPad7,12' :'1'																// iPad 10.2" 7th Gen
                        ,'iPad11,6' :'1'	,'iPad11,7' :'1'																// iPad 10.2" 8th Gen
                        ,'iPad4,1'	:'0'	,'iPad4,2'	:'0'	,'iPad4,3'	:'0'											// iPad Air
                        ,'iPad5,3'	:'1'	,'iPad5,4'	:'1'																// iPad Air2
                        ,'iPad11,3'	:'1'	,'iPad11,4'	:'1'																// iPad Air 3rd Gen
                        ,'iPad13,1'	:'1'	,'iPad13,2'	:'1'																// iPad Air 4th Gen
                        ,'iPad2,5'	:'0'	,'iPad2,6'	:'0'	,'iPad2,7'	:'0'											// iPad mini
                        ,'iPad4,4'	:'0'	,'iPad4,5'	:'0'	,'iPad4,6'	:'0'											// iPad mini2
                        ,'iPad4,7'	:'1'	,'iPad4,8'	:'1'	,'iPad4,9'	:'1'											// iPad mini3
                        ,'iPad5,1'	:'1'	,'iPad5,2'	:'1'																// iPad mini4
                        ,'iPad11,1'	:'1'	,'iPad11,2'	:'1'																// iPad mini 5th Gen
                        ,'iPad6,7'	:'1'	,'iPad6,8'	:'1'																// iPad Pro 12.9"
                        ,'iPad6,3'	:'1'	,'iPad6,4'	:'1'																// iPad Pro 9.7"
                        ,'iPad7,3'	:'1'	,'iPad7,4'	:'1'																// iPad Pro 10.5"
                        ,'iPad7,1'	:'1'	,'iPad7,2'	:'1'																// iPad Pro 12.9" (2nd Gen)
                        ,'iPad8,1'	:'2'	,'iPad8,2**':'2'	,'iPad8,3'	:'2'	,'iPad8,4**'	:'2'					// iPad Pro 11"
                        ,'iPad8,5'	:'2'	,'iPad8,6**':'2'	,'iPad8,7'	:'2'	,'iPad8,8**'	:'2'					// iPad Pro 12.9" (3nd Gen)
                        ,'iPad8,9'	:'2'	,'iPad8,10':'2'																	// iPad Pro 11" (2nd Gen)
                        ,'iPad8,11'	:'2'	,'iPad8,12'	:'2'																// iPad Pro 12.9" (4nd Gen)
                    }
                    
                    if (miaps.isIOS() || miaps.isPC()) {
                        miaps.mobile({
                            type: 'DEVICEMODEL',
                            param: 'iPad4,1'
                        }, function(data) {
                            var obj = miaps.parse(data);
                            var resStr = '0';
                                    
                            if (iPhone.hasOwnProperty(obj.res)) {
                                resStr = iPhone[obj.res];
                            }
                            if (iPad.hasOwnProperty(obj.res)) {
                                resStr =  iPad[obj.res];
                            }
                                    
                            if (resStr == '0') {
                                showModal('생체인식을 지원하지 않는 장치 입니다.','OK');
                            } else if (resStr == '1') {
                                showModal('Touch ID 지원 장치 입니다.','OK');
                            } else if (resStr == '2') {
                                showModal('Face ID 지원 장치 입니다.','OK');
                            }
                        });
                    }
                    
                }
            }
        });
    });
});