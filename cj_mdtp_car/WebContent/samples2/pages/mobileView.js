require(["jquery", "miaps", "miapswp", "miapspage", "bootstrap",
         ], function($, miaps, miapswp, miapsPage) {
	
	var _gEncData = '';

	$(function(){
		
		if(miaps.MobilePlatform.Android()) {
			$("#newtab").remove();			
		} else {
			$("#btnBackEnable").remove();
			$("#btnBackDisable").remove();
		}

		//버튼이벤트
		initBtn();
	});
		
	function initBtn() {
		$("#btnBack").on("click", function() {
			try {
				miapsPage.back();
			} catch (e) {
				window.history.back();
			}
		}); 
		
		// 모바일함수 체크
		$('#finger').on('click', function() {
			var config = {
					type : 'FINGER',
					param : 'start',
					callback : '_cb.mobileTest'
			}
			miaps.mobile(config, _cb.mobileTest);
		});
		
		$('#finger-checkdevice').on('click', function() {
			var config = {
					type : 'FINGER',
					param : 'checkdevice',
					callback : '_cb.mobileTest'
			}
			miaps.mobile(config, _cb.mobileTest);
		});
		
		$('#finger-checkreg').on('click', function() {
			var config = {
					type : 'FINGER',
					param : 'checkreg',
					callback : '_cb.mobileTest'
			}
			miaps.mobile(config, _cb.mobileTest);
		});
		
		/* iOS Touch-ID, Face-ID 구분
		 * iOS11부터는 내부 API로 구분할 수 있음. 이전 단말은 스크립트에서 단말모델 값으로 구분하도록 함.
		 */
		$('#ios-id').on('click', function() {
			if (miaps.isAndroid()) {
				alert('Android is not supported');
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
						alert("네이티브 사용 테스트 입니다.");
					//if (osVersion >= 20) { // 아래쪽 스크립트 테스트 시 사용.
						miaps.mobile({
							type: 'FINGER',
							param: 'checktype'
						}, function(data) {
							obj = miaps.parse(data);
							if (obj.res == '0') {
								alert('생체인식을 지원하지 않는 장치 입니다.');
							} else if (obj.res == '1') {
								alert('Touch ID 지원 장치 입니다.')
							} else if (obj.res == '2') {
								alert('Face ID 지원 장치 입니다.')
							}
						});
					// iOS11보다 이전 버전이면 스크립트로 처리한다. 매년 새 모델 발표 시 갱신 필요.	
					// 참고사이트 https://everyi.com/by-identifier/ipod-iphone-ipad-specs-by-model-identifier.html
					} else { // 0:없음, 1:TouchID, 2:FaceID
						alert("스크립트 사용 테스트 입니다.");
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
											alert('생체인식을 지원하지 않는 장치 입니다.');
										} else if (resStr == '1') {
											alert('Touch ID 지원 장치 입니다.')
										} else if (resStr == '2') {
											alert('Face ID 지원 장치 입니다.')
										}
									});
						}
						
					}
				}
			});
		});
		//////////////////////////////////////////
		
		$('#devicemodel').on('click', function() {
			var config = {
					type : 'DEVICEMODEL',
					param : '',
					callback : '_cb.mobileTest'
			}
			miaps.mobile(config, _cb.mobileTest);
		});
		
		$('#language').on('click', function() {
			var config = {
					type : 'LANGUAGE',
					param : '',
					callback : '_cb.mobileTest'
			}
			miaps.mobile(config, _cb.mobileTest);
		});
		
		$('#platform').on('click', function() {
			var config = {
					type : 'PLATFORM',
					param : '',
					callback : '_cb.mobileTest'
			}
			miaps.mobile(config, _cb.mobileTest);
		});
		
		$('#appid').on('click', function() {
			var config = {
					type : 'APPID',
					param : '',
					callback : '_cb.mobileTest'
			}
			miaps.mobile(config, _cb.mobileTest);
		});
		
		$('#version').on('click', function() {
			var config = {
					type : 'VERSION',
					param : '',
					callback : '_cb.mobileTest'
			}
			miaps.mobile(config, _cb.mobileTest);
		});
		
		$('#savevalue').on('click', function() {
			var config = {
					type : 'SAVEVALUE',
					//param : {"id":"koreanre"}, // json
					param : { id : "abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz"},
					callback : '_cb.mobileTest'
			}
			miaps.mobile(config, _cb.mobileTest);
		});
		
		$('#loadvalue').on('click', function() {
			var config = {
					type : 'LOADVALUE',
					param : ["id"],	// array
					callback : '_cb.mobileTest'
			}
			miaps.mobile(config, _cb.mobileTest);
		});
		
		$('#clearallvalue').on('click', function() {
			var config = {
					type : 'clearallvalue',
					param : '',
					callback : '_cb.mobileTest'
			}
			miaps.mobile(config, _cb.mobileTest);
		});
		
		
		
		$('#timezone').on('click', function() {
			var config = {
					type : 'TIMEZONE',
					param : '',
					callback : '_cb.mobileTest'
			}
			miaps.mobile(config, _cb.mobileTest);
		});
		
		$('#deviceid').on('click', function() {
			var config = {
					type : 'DEVICEID',
					param : '',
					callback : '_cb.mobileTest'
			}
			miaps.mobile(config, _cb.mobileTest);
		});
		
		$('#istablet').on('click', function() {
			var config = {
					type : 'ISTABLET',
					param : '',
					callback : '_cb.mobileTest'
			}
			miaps.mobile(config, _cb.mobileTest);
		});
		
		//start : true(GPS를 시작한다.), false(GPS를 종료한다.)
		//onetime : true(값을 받자 마자 자동으로 stop한다.) , false(stop 명령이 오기전까지 계속해서 GPS를 받는다.)
		//type : navigate(네비게이션형태의 GPS), best(그냥,저냥 가져온다.)
		$('#geo').on('click', function() {
			miaps.cursor(null, 'wait', true);
			var vparam = {
				"start": true,
				"onetime": true,
				"type": "navigate"
			};
			var config = {
					type : 'GEOLOCATION',
					param : vparam,
					callback : '_cb.mobileTest'
			}
			miaps.mobile(config, _cb.mobileTest);
		});
		

		$('#bundleid').on('click', function() {
			var config = {
					type : 'BUNDLEID',
					param : '',
					callback : '_cb.mobileTest'
			}
			miaps.mobile(config, _cb.mobileTest);
		});
		
		$('#platformversion').on('click', function() {
			var config = {
					type : 'PLATFORMVERSION',
					param : '',
					callback : '_cb.mobileTest'
			}
			miaps.mobile(config, _cb.mobileTest);
		});	
		
		$('#statuscolor_red').on('click', function() {
			var vparam = {
					statusbar: "255,0,0"
				}
			var config = {
					type : 'COLOR',
					param : vparam,
					callback : '_cb.mobileTest'										
				}
			miaps.mobile(config, _cb.mobileTest);
		});
		
		$('#statuscolor_blue').on('click', function() {
			var vparam = {
					statusbar: "0,0,255"
				}
			var config = {
					type : 'COLOR',
					param : vparam,
					callback : '_cb.mobileTest'										
				}
			miaps.mobile(config, _cb.mobileTest);
		});
		
		$('#statuscolor_yellow').on('click', function() {
			var vparam = {
					statusbar: "255,255,0"
				}
			var config = {
					type : 'COLOR',
					param : vparam,
					callback : '_cb.mobileTest'										
				}
			miaps.mobile(config, _cb.mobileTest);
		});
		
		$('#watermark_off').on('click', function() {
			console.log("watermark_off");
			var vparam = {
					visible: false
				}
			var config = {
					type : 'WATERMARK',
					param : vparam,
					callback : '_cb.mobileTest'										
				}
			miaps.mobile(config, _cb.mobileTest);
		});	
		    
		$('#watermark_on').on('click', function() {
			console.log("watermark_on");
			var vparam = {
					visible: true,
					rgb: "255,0,0",
					fontsize: 28,
					x: 0,
					y: 0,
					angle: 45,
					transparency: 50,
					msg: "Watermark TEST Message!!"
				}
			var config = {
					type : 'WATERMARK',
					param : vparam,
					callback : '_cb.mobileTest'										
				}
			miaps.mobile(config, _cb.mobileTest);
		});
		
		/* 새 탭  (로컬)*/
		$('#newtab_inside').on('click', function() {
			
			//window.location.href = "testListView.html";
			window.open('mobileView.html', '_blank');
		});
		
		/* 새 탭 (외부) */
		$('#newtab_outside').on('click', function() {
			window.open('http://m.daum.net', '_blank');
		});
		/*
		$('#getvalue').on('click', function() {
			var val = miaps.getValue('key');
			alert(val);
		});
		*/
		$('#filelist').on('click', function() {
			var config = {
				type: "FILELIST",
				param: {
					path: "C:/Users/dantr/Pictures"
					//path: "${ResourceRoot}\\res"
				},
				callback: "_cb.mobileTest"
			};
			miaps.mobile(config, _cb.mobileTest)
		});

		$('#filecontents').on('click', function() {
			var config = {
				type: "filecontents",
				param: {
					path: "C:/Users/dantr/Pictures/iCloud Photos/Downloads/587115304.639666.jpg"
					//path: "${ResourceRoot}\\res"
				},
				callback: "_cb.mobileTest"
			};
			miaps.mobile(config, _cb.mobileTest)
		});
		
		$('#toasts').on('click', function() {
			var config = {
				type: "TOASTS",
				param: { msg : "Toasts 테스트 입니다." },
				callback: ""
			};
			miaps.mobile(config, null);
		});
		
		$('#newbrowser').on('click', function() {
			var config = {
				type: "NEWBROWSER",
				param: { url: "http://m.daum.net" },
				callback: ""
			};
			miaps.mobile(config, null);
		});
		
		

		$('#multicall').on('click', function() {
			var types = ['deviceid','platform','devicemodel','platformversion','version'];
			for (var i = 0; i < types.length; i++) {
				var config = {
						type : types[i],
						param : i,
						callback : '_cb.multicall'
				}
				miaps.mobile(config, _cb.multicall);
			}			
		});
		
		$('#ori_portrait').on('click', function() {
			var config = {
				type: "orientation",
				param: [ "up", "down" ],
				callback: ""
			};
			miaps.mobile(config, null);
		});
		$('#ori_landscape').on('click', function() {
			var config = {
				type: "orientation",
				param: [ "left", "right" ],
				callback: ""
			};
			miaps.mobile(config, null);
		});
		$('#ori_all').on('click', function() {
			var config = {
				type: "orientation",
				param: [ "left", "right", "up", "down" ],
				callback: ""
			};
			miaps.mobile(config, null);
		});	
		
		$('#btnBackEnable').on('click', function() {
			var config = {
				type: "enablebackbtn",
				param: "",
				callback: ""
			};
			miaps.mobile(config, null);
		});
		
		$('#btnBackDisable').on('click', function() {
			var config = {
				type: "disablebackbtn",
				param: "",
				callback: "_cb.mobileTest"
			};
			miaps.mobile(config, _cb.mobileTest);
		});
		
		
		$('#btnEncrypt').on('click', function() {
			var config = {
				type: "encrypt",
				param: {type: "aes128", data:"1234"},
				callback: "_cb.mobileTest"
			};
			miaps.mobile(config, _cb.mobileTest);
		});
		
		$('#btnDecrypt').on('click', function() {
			var config = {
				type: "decrypt",
				//param: {type: "aes128", data:"hZ2pfW+Y5upncivQAJf9wA=="},
				param: {type: "aes128", data:_gEncData},
				callback: "_cb.mobileTest"
			};
			miaps.mobile(config, _cb.mobileTest);
		});
		
		$('#getIp').on('click', function() {
			var config = {
				type: "DEVICEIP",
				param: "IPv4",   // IPv4 or IPv6, 공백일경우 IPv4 기본
				callback: "_cb.mobileTest"
			};
			miaps.mobile(config, _cb.mobileTest);
		});
		
		$('#checkNetwork').on('click', function() {
			var config = {
				type: "NETWORK",
				param: "mobile"   // 앱에서는 사용안함. (PC에서 테스트 시 wifi, mobile(3G,LTE), none 입력하면 callback시 res값으로 리턴)
				//callback: "_cb.mobileTest"
			};
			miaps.mobile(config, _cb.mobileTest);
		});
		
		
		$('#devicemodel-wp').on('click', function() {
			miapswp.callNative('devicemodel', 'testResult:iPhoneXX', '', function(data) {
				var obj = miaps.parse(data);
				
				if (typeof obj == 'object') {
					alert(JSON.stringify(obj).replace(/,"/g, ',\n"'));
				} else if (typeof obj == 'string') {
					alert(obj);
				}
			});
		});
		
		$('#applicationinfo').on('click', function() {
			var config = {
				type: "applicationinfo",
				param: ""				
			};
			miaps.mobile(config, function(data) {
				miaps.cursor(null, 'default');
				
				var obj = miaps.parse(data);
				
				alert(obj.common.serverurl);
			});
		});

		$('#camera').on('click', function() {
			var config = {
				type: "camera"
				,param: {
					resolution:"1200",
					path: "${ResourceRoot}\\temp"   // 임시저장 디렉토리				
				}
				,res: "C:\/Temp\/iamges\/dry_corn_640.jpg"		// PC에서 테스트에 사용되는 값		
			};
			miaps.mobile(config, function(data) {
				var obj = miaps.parse(data);
				alert(JSON.stringify(obj).replace(/,"/g, ',\n"'));				

				//sessionStorage.setItem('tempCamera', data.res);

				var tmpPath = obj.res;
				tmpPath = tmpPath.substring(0, tmpPath.lastIndexOf('/'));

				miaps.mobile({
						type:'savevalue', 
						param: {
							'tempCameraPath': obj.res,
							'tempDir': tmpPath
						}
					}, function (data) {
						obj = miaps.parse(data);
						alert(JSON.stringify(obj).replace(/,"/g, ',\n"'));
					});
			});
		});
		$('#gallery').on('click', function() {
			var config = {
				type: "gallery"
				,param: {
					resolution:"1200",
					path: "${ResourceRoot}\\temp"   // 임시저장 디렉토리
					, multi : "1"
				}
				,res: "C:\/Temp\/iamges\/dry_corn_640.jpg"	// PC에서 테스트에 사용되는 값
			};
			miaps.mobile(config, function(data) {
				var obj = miaps.parse(data);
				alert(JSON.stringify(obj).replace(/,"/g, ',\n"'));
				
				var tmpPath = obj.res;
				tmpPath = tmpPath.substring(0, tmpPath.lastIndexOf('/'));

				//sessionStorage.setItem('tempGallery', data.res);
				miaps.mobile({
						type:'savevalue', 
						param: {
							'tempGalleryPath': obj.res,
							'tempDir': tmpPath
						}
					}, function (data) {
						obj = miaps.parse(data);
						alert(JSON.stringify(obj).replace(/,"/g, ',\n"'));
					});
			});
		});

		$('#filedelete').on('click', function() {

			//var del1 = sessionStorage.getItem('tempCamera');
			//var del2 = sessionStorage.getItem('tempGallery');
			miaps.mobile({
				type:'loadvalue', 
				param: ['tempCameraPath','tempGalleryPath']					
			}, function (data) {
				obj = miaps.parse(data);
				alert(JSON.stringify(obj).replace(/,"/g, ',\n"'));

				var del1 = obj.res.tempCameraPath;
				var del2 = obj.res.tempGalleryPath;

				alert("삭제할 파일은 아래와 같습니다.\n" + del1 + '\n' + del2);

				var config = {
					type: "FILEDELETE",
					param: [del1, del2],
					callback: "_cb.mobileTest"
				};
				miaps.mobile(config, _cb.mobileTest)
			});			
		});

		
		$('#filedeleteall').on('click', function() {

			miaps.mobile({
				type:'loadvalue', 
				param: ['tempDir']
			}, function (data) {
				obj = miaps.parse(data);
				alert(JSON.stringify(obj).replace(/,"/g, ',\n"'));

				var deldir = obj.res.tempDir;

				var config = {
					type: "FILEDELETE",
					param: deldir,
					callback: "_cb.mobileTest"
				};
				miaps.mobile(config, _cb.mobileTest)
			});			
		});

		$('#nativetest').on('click', function () {
			location.href = 'mobile/nativeTest.html'
		})
	}

	/* ---- callback function ---- 
	 * callback function은 앱에서 호출 되어야 하므로 callback.cbVerChk = function(data) {...로 작성하지 않고 callback.cbVerChk = function cbVerChk(data) {...처럼 함수명을 function뒤에 명시하도록 한다.
	 * 제일 마지막에 window._cb = callback; 명령으로 작성한 callback객체를 어느곳에든지 호출 가능 하도록 전역화 한다.
	 */
	var callback = {
			mobileTest : function(data) {
				miaps.cursor(null, 'default');
				
				var obj = miaps.parse(data);
				
				if (typeof obj == 'object') {
					alert(JSON.stringify(obj).replace(/,"/g, ',\n"'));
					console.log(JSON.stringify(obj).replace(/,"/g, ',\n"'));
				} else if (typeof obj == 'string') {

					console.log(obj);
				}

				if (obj.type == 'encrypt') {
					_gEncData = obj.res;
					console.log('_gEncData : ' + _gEncData);
					console.log('_gEncData(decodeURIComponent) : ' + decodeURIComponent(_gEncData));					
				}
			},
			
			multicall: function(data) {
				miaps.cursor(null, 'default');
				var obj = miaps.parse(data);
				
				window.sessionStorage.setItem(obj.type, obj.res);
				
				if (obj.type == 'version') { // last data
					var types = ['deviceid','platform','devicemodel','platformversion','version'];
					console.log('---result---');
					for (var i = 0; i < types.length; i++) {
						alert(window.sessionStorage.getItem(types[i]));
					}					
				}
			}
	
	};
	window._cb = callback;	
});