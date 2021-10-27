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
	var	results = function(config) {
		
		// 여기서 부터  name = { method 명으로 추가 합니다.
		/////////////////////////////////////////////////////////////////////////////////////
		
		// KTB 테스트를 위한 dummy 데이터
		var ktb = {
			getModelName : JSON.stringify({
				param: {param: '',method: 'getModelName',name: 'KTB',res: {}}
				, code: '200'
				, type: 'EXTLIB'
				, res: 'SM-N920S'
				, callback: 'callbackFunction'
			})
			, getSystemVersion : JSON.stringify({
				param: {param: '',method: 'getSystemVersion',name: 'KTB',res: {}}
				, code: '200'
				, type: 'EXTLIB'
				, res: '7.0'
				, callback: 'callbackFunction'
			})
			, checkPhoneRooted	: JSON.stringify({
				param: {param: '',method: 'checkPhoneRooted',name: 'KTB',res: {}}
				, code: '200'
				, type: 'EXTLIB'
				, res: 'n'
				, callback: 'callbackFunction'
			})
			,getUUID1	: JSON.stringify({
				param: {param: '',method: 'getUUID1',name: 'KTB',res: {}}
				, code: '200'
				, type: 'EXTLIB'
				, res: '352469078189074noblelteskt'
				, callback: 'callbackFunction'
			})
			,getUUID2	: JSON.stringify({
				param: {param: '',method: 'getUUID2',name: 'KTB',res: {}}
				, code: '200'
				, type: 'EXTLIB'
				, res: '05160248abe93baaSMN920S'
				, callback: 'callbackFunction'
			})
			,getSimSerialNumber	: JSON.stringify({
				param: {param: '',method: 'getSimSerialNumber',name: 'KTB',res: {}}
				, code: '200'
				, type: 'EXTLIB'
				, res: '8982051407606727317'
				, callback: 'callbackFunction'
			})
		},
		//공인인증서 테스트를 위한 dummy 데이터
		Xecure_SignCert = { 
			getSignCertList: JSON.stringify({
				type			: 'EXTLIB'
				 , param		: {
									name		: 'Xecure_SignCert'
									, method	: 'GetSignCertList'
									, param		: ''
									, res		: '{}'
								}
				, callback		: 'signCert.callbackList'
				, code			: 200
				, res			: [
					{
						STATE						: '0'
						, VERSION					: '3'
						, SERIAL					: '20e121bf'
						, SIGNATURE_ALG_DESC		: 'SHA256 + RSA'
						, ISSUER_RDN				: 'cn=yessignCA Class 2,ou=AccreditedCA,o=yessign,c=kr'
						, FROM						: '2017-12-28 09:00:00'
						, TO						: '2019-01-21 08:59:59'
						, SUBJECT_RDN				: 'cn=홍길동()0003040200501070949785,ou=IBK,ou=personal4IB,o=yessign,c=kr'
						, SUBJECT_KEY_ALG_DESC		: 'RSA (2048 Bits)'
						, SUBJECT_PUBLIC_KEY		: '3082010a0282010100f68797621e654db477132ff27014386306e62fd218b1d7f03cd4762b9aa7e3a5394dce5ed18d7040791ad2dc5f7d4bcf5542af409b4cc2a84f8c79485a2a7b20f409ed64faa1549e601b657b9901d791a8d357d171f60133c85b15ee07dc5ec0ed1afb8da55cb05d74802548c6b18bd6927c5208e7ac24789b4ca80164fb498c375bc3a0e27345a2b8d70516f1caac6683a90f3a70a244ca5ac8fe50ea1b27e70a882628386eeebf13d0e4376a7105d2401f7603b27b2d7aa736cbaba7a73c9881def7392c735ad716aa1190267053b2e97c4bb8449b4cbe6a88347cecec3e45a635ac776c4f6fcffaf504a48b5b42f4aa0cda319291aa69f0618f7820e114b90203010001'
						, CERT_SIGNATURE			: '8b95b46cd5bfb62fa5691738cdd81aebda97815bedd48944151acdf59b0d089aff0e69e386064b99e4ba5de1885133c562eb2501c22a48ea50b747dddea85156b68ee0c684aa5e70269075ce66e1f05b1f41440432a514ff8f0945a7b7b7ae12d7a471abc6d9fe263105daac072e8917a9ed4bccae0d8acee91839f25a2f6517fc9188ea40ae4e89ae3cc05fd70da51012a48167c831faf284b9af5db6c5b9d82cbf8310abf7826e7989f386d65f5114ff878f6c644c69e1d02d9cf32e6c1cd49c5baf1b625402806ff2012e40d25f1f69ccab49612dad6ea32783d0118c4409d4c5227eee2dc08a03b5cfdcc0e7b84ec02b030be03a1490707c0e15cd587c0a'
						, AUTHORITY_KEY_ID			: 'efdc44d2c68dc00ea338c07c93c6c341bf4a8ff0'
						, POLICY_ID					: '1.2.410.200005.1.1.4'
						, SUBJECT_ALT_NAME			: 'digitalSignature,nonRepudiation'
						, KEY_USAGE_DESC			: ''
						, BASIC_CONSTRAINTS			: 'ON=VID=304e0c09ebb095ec9d98eb8f993041303f060a2a831a8c9a440a0101013031300b0609608648016503040201a02204203c77f6cd3d7c4310164b4257a76713479e959606ebdc69c0fc0fd7fc9816ee90'
						, CRL_DISTRIBUTION_POINTS	: 'URL=ldap://ds.yessign.or.kr:389/ou=dp5p22874,ou=AccreditedCA,o=yessign,c=kr?certificateRevocationList'
						, USER_NOTICE				: '이 인증서는 공인인증서 입니다'
						, CPS_URI					: 'http://www.yessign.or.kr/cps.htm'
						, AIAS						: 'OCSP:URL=http://ocsp.yessign.org:4612'
						, ISSUER					: '금융결제원'
						, getPolicyID				: '은행개인'
					}
				]
			})
		},

		/* OCR Inzisoft ()신분증 촬영) */
		inzi = {
			getOcrImageData : JSON.stringify({				param:  {name: 'inzi', method: 'getOcrImageData', param: '', res: ''}
				, type: 'EXTLIB'
				, code: '200'
				, res: {
					"code": "값",	// 동작 취소 시 code 리턴
					"msg": "값",	// 동작 취소 시 msg 리턴.  (동작 취소시 code, msg만 리턴 합니다.)
					"idType": "값",
					"orgImage": "값", 
					"maskImage": "값",
					"orgEncImage": "값",
					"maskEncImage": "값",
					"faceImage": "값",
					"fa_qa": "값",
					"faceinfo": "값",
					"data": {
						"name": "값",
						"id": "값",
						"iddec": "값",
						"issuedate": "값",
						"address": "값",
						"issueoffice": "값",
						"licensenum": "값",
						"licensenumdec": "값",
						"datestart": "값",
						"dateend": "값",
						"licensetype": "값",
						"serialnum": "값"
					}
				}
			})	
		},
		rosis = {
			ocr: JSON.stringify({
				param:  {name: 'rosis', method: 'ocr', param: '', res: ''}
				, code: '200'
				, type: 'extlib'
				, res: {
					type:'주민등록증'
					,rrn: '9901011000000' // 주민등록번호
					,name: '홍길동'
					,org: '서울특별시 송파구청장'
					,date: '20010901'		// 발행일
					,acfn: ''
					,licenseNumber: ''
					,licenseaptitudedate: ''
					,licensetype: ''
				    ,photomasking:''
				    ,photo:''
				}			
			})
		},		
		espider = {
			CheckDriverLicense: JSON.stringify({
				param:  {name: 'espider', method: 'CheckDriverLicense', param: '', res: ''}
				, code: '200'
				, type: 'EXTLIB'
				, res: {
					result:{
						lists:[{
							resUserNm: '홍길동'
							,commBirthDate:'20110411'
							,resAuthenticityDesc1:'암호일련번호가 일치합니다.'
							,resAuthenticityDesc2:'도로교통공단 전산 자료와 일치합니다.'
							,resAuthenticity:'1'
							//,resAuthenticityDesc1:'도로교통공단 전산 자료와 일치합니다.'
							//,resAuthenticityDesc2:'암호일련번호가 일치하지 않습니다.'
							//,resAuthenticity:'2'
							//,resAuthenticityDesc1:'도로교통공단 전산 자료와 일치하지 않습니다.'
							//,resAuthenticityDesc2:''
							//,resAuthenticity:'0'						
							,resSearchDateTime:'2018년04월18일16:56' 
						}]
					}
				}
				, callback: '_cb.chkLicenseResult'
			})
			,checkSecurityNumberRslt: JSON.stringify({
				param:  {name: 'espider', method: 'checkSecurityNumberRslt', param: '', res: ''}
				, code: '200'
				, type: 'EXTLIB'
				, res: {
					result:{
						lists:[{
							resUserNm: '홍길동'
							,resUserIdentityNo: '770101*******'
							,resAuthenticityDesc:'입력하신 내용은 등록된 내용과 일치합니다..'
							,resAuthenticity:'1'
							//,resAuthenticityDesc:'입력하신 내용은 사용할 수 없는 주민등록증입니다. 궁금하신 사항은 가까운 읍면동에 문의하시기 바랍니다.'
							//,resAuthenticity:'0'
							,resSearchDateTime:'2018년04월18일16:56' 
						}]
					}
				}
				, callback: '_cb.chkIdResult'
			})
		},
		wizvera = {
			certlist: JSON.stringify({
				param:  {name: 'wizvera', method: 'certlist', param: '', res: ''}
				, code: '200'
				, type: 'extlib'
				, res: [
					{
						version: 3
						,serial: '585841703'
						,signalgorithm: 'SHA256WITHRSA'
						,policyoid: '1.2.410.200005.1.1.4'
						,subject:'CN=홍길동()0020047201212122524344,OU=WOORI,OU-personal4IB,O=yessign,C=kr'
						,issuer:'CN=yessignCA Class2,OU=AccreditedCA,O=yessign,C=kr'
						,cn:'홍길동()0020047201212122524344'
						,ou:'WOORI'
						,o:'yessign'
						,c:'kr'
						,notbefore:'2018.09.03'
						,notafter:'2019.03.30'
						,validate:'2'
					}
				]
			}),
			sign: JSON.stringify({
				param:  {name: 'wizvera'
						,method: 'sign'
						,param: {
							subject: 'CN=홍길동-6422061,OU=HTS,OU=동양,OU=증권,O=SignKorea,C=KR'
							,password: ''
							,signdata: ''
						}	
						,res: ''}
				, code: '200'
				, type: 'extlib'
				, res: ''
			})
		},
		nfilter = {
			showKeypad: JSON.stringify({
				param:  {name: 'nfilter'
					,method: 'showKeypad'
					,param: {
						mode: 'char'
						,type: 'full'
						,title: '문자를 입력 하세요.'
						,maxlength: '6'
						,e2e:'true'
						,publickey: 'MDIwGhMABBYDANxV4UGSCyLQ47g+XplAMbzb7qvqBBTrRc/v7ZNI0PlgMhxyJmKn/VlvbA=='
					}
					,res: ''}
				, code: '200' // 확인버튼: 200, 취소버튼:201
				, type: 'extlib'
				, res: {
					cmd: 'done'	// done, cancel, changing
					,encdata:'18ffca675d520b67faa3d5321f3715af' // TEST
					,length:4
					,aesencdata: ''
					,dummy:'2b913'
				}
			})
		},
		
		// 최초 토큰 저장 & 생성 : PIN번호로 등록과 동시에 sign데이터까지 전달 한다.
		eightbyte = {
			setToken: JSON.stringify({	
				param:  {name: 'eightbyte'
					,method: 'setToken'
					,param: {
						"em" : "em값"
				        ,"pin": "pin값"
				        ,"rnd": "rnd값"
				        ,"msg": "msg값"
					}
					,res: ''}
				, code: '200'
				, type: 'extlib'
				, res: {
					"signData": "값" // 전자서명값
					,"code": "0" // 8byte 에러코드 (0성공, 0이외 코드는 8byte자료참고)
					,"msg" : ""
				}
			}),
			// 토큰 삭제
			delToken: JSON.stringify({
				param:  {name: 'eightbyte'
					,method: 'delToken'
					,param: ""
					,res: ''}
				, code: '200'
				, type: 'extlib'
				, res: ""
			}),
			// PIN 기반 전자서명 데이터 생성
			getPinSignData: JSON.stringify({
				param:  {name: 'eightbyte'
					,method: 'getPinSignData'
					,param: {
						 "pin" : "pin값"
				        ,"rnd": "rnd값"
				        ,"msg": "msg값"
					}
					,res: ''}
				, code: '200'
				, type: 'extlib'
				, res: {
					"signData": "값" // 전자서명값
					,"code": "0" // 8byte 에러코드 (0성공, 0이외 코드는 8byte자료참고)
					,"msg" : ""
				}
			}),
			//  생체 정보 등록
			setBioAuthData: JSON.stringify({
				param:  {name: 'eightbyte'
					,method: 'setBioAuthData'
					,param: {
						 "pin" : "pin값"
				        ,"rnd": "rnd값"
				        ,"msg": "msg값"
					}
					,res: ''}
				, code: '200'
				, type: 'extlib'
				, res: {
					"code": "0" // 8byte 에러코드 (0성공, 0이외 코드는 8byte자료참고)
					,"msg" : "" // 에러 발생할 경우 에러 메시지
				}
			}),
			//  생체 정보 삭제
			delBioAuthData: JSON.stringify({
				param:  {name: 'eightbyte'
					,method: 'delBioAuthData'
					,param: ""
					,res: ''}
				, code: '200'
				, type: 'extlib'
				, res: {
					"code": "0" // 8byte 에러코드 (0성공, 0이외 코드는 8byte자료참고)
					,"msg" : "" // 에러 발생할 경우 에러 메시지
				}
			}),
			// 생체정보 기반 전자서명 데이터 생성
			getBioSignData: JSON.stringify({
				param:  {name: 'eightbyte'
					,method: 'getBioSignData'
					,param: {
				         "rnd": "rnd값"
				        ,"msg": "msg값"
					}
					,res: ''}
				, code: '200'
				, type: 'extlib'
				, res: {
					"signData": "값" // 전자서명값
					,"code": "0" // 8byte 에러코드 (0성공, 0이외 코드는 8byte자료참고)
					,"msg" : ""
				}
			}),
			// 패턴 정보 등록
			setPatternAuthData: JSON.stringify({	
				param:  {name: 'eightbyte'
					,method: 'setPatternAuthData'
					,param: {
						"pin" : "pin값"
				        ,"rnd": "rnd값"
				        ,"msg": "msg값"
				        ,"flag": "flag값" 	// 색, 라인 표시 "true" / "false"
				        ,"desc": "desc값"  	// 제목
				        ,"showLinkFlag": "showLinkFlag값"
					}
					,res: ''}
				, code: '200'
				, type: 'extlib'
				, res: {
					"signData": "값" // 전자서명값
					,"code": "0" // 8byte 에러코드 (0성공, 0이외 코드는 8byte자료참고)
					,"msg" : ""
				}
			}),
			// 패턴 정보 변경
			chgPatternAuthData: JSON.stringify({	
				param:  {name: 'eightbyte'
					,method: 'chgPatternAuthData'
					,param: {
						 "rnd" : "rnd값"
				        ,"msg": "msg값"
				       ,"flag": "flag값" 	// 색, 라인 표시 "true" / "false"
				        ,"desc": "desc값"  // 제목
				        ,"count": "count값"
				        ,"showLinkFlag": "showLinkFlag값"
					}
					,res: ''}
				, code: '200'
				, type: 'extlib'
				, res: {
					"signData": "값" // 전자서명값
					,"code": "0" // 8byte 에러코드 (0성공, 0이외 코드는 8byte자료참고)
					,"msg" : ""
				}
			}),
			// 패턴 정보 삭제
			delPatternAuthData: JSON.stringify({	
				param:  {name: 'eightbyte'
					,method: 'delPatternAuthData'
					,param: {
						 "rnd" : "rnd값"
				        ,"msg": "msg값"
					}
					,res: ''}
				, code: '200'
				, type: 'extlib'
				, res: {
					"code": "0" // 8byte 에러코드 (0성공, 0이외 코드는 8byte자료참고)
					,"msg" : ""
				}
			}),
			// 패턴정보 기반 전자서명 데이터 생성
			getPatternSignData: JSON.stringify({	
				param:  {name: 'eightbyte'
					,method: 'getPatternSignData'
					,param: {
						 "rnd" : "rnd값"
				        ,"msg": "msg값"
				        ,"flag": "msg값"
				        ,"desc": "msg값"
				        ,"count": "count값"
				        ,"showLinkFlag": "showLinkFlag값"
					}
					,res: ''}
				, code: '200'
				, type: 'extlib'
				, res: {
					"signData": "값" // 전자서명값
					,"code": "0" // 8byte 에러코드 (0성공, 0이외 코드는 8byte자료참고)
					,"msg" : ""
				}
			}),
			// OTP정보 등록
			setOtpToken: JSON.stringify({	
				param:  {name: 'eightbyte'
					,method: 'setOtpToken'
					,param: {
						 "uid" :"uid값"
				        ,"org": "org값"
				        ,"rnd": "rnd값"
				        ,"msg": "msg값"
				        ,"digit": "digit값"
				        ,"pin": "pin값"
				        ,"token": "token값"
					}
					,res: ''}
				, code: '200'
				, type: 'extlib'
				, res: {
					"signData": "값" // 전자서명값
					,"code": "0" // 8byte 에러코드 (0성공, 0이외 코드는 8byte자료참고)
					,"msg" : ""
				}
			}),
			// OTP정보 삭제
			delOtpToken: JSON.stringify({	
				param:  {name: 'eightbyte'
					,method: 'delOtpToken'
					,param: ""
					,res: ''}
				, code: '200'
				, type: 'extlib'
				, res: {
					"signData": "값" // 전자서명값
					,"code": "0" // 8byte 에러코드 (0성공, 0이외 코드는 8byte자료참고)
					,"msg" : ""
				}
			}),
			// OTP Sign데이터 전달
			getOtpSignData: JSON.stringify({	
				param:  {name: 'eightbyte'
					,method: 'getOtpSignData'
					,param: {
						 "pin" : "pin값"
				        ,"rnd": "rnd값"
				        ,"msg": "msg값"
				        ,"digit": "digit값"
					}
					,res: ''}
				, code: '200'
				, type: 'extlib'
				, res: {
					"signData": "값" // 전자서명값
					,"code": "0" // 8byte 에러코드 (0성공, 0이외 코드는 8byte자료참고)
					,"msg" : ""
				}
			}),
			// OTP정보 추출
			getOtpNumData: JSON.stringify({	
				param:  {name: 'eightbyte'
					,method: 'getOtpNumData'
					,param: {
						 "digit" : "uid값"
				        ,"pin": "org값"
				        ,"rnd": "rnd값"
				        ,"msg": "msg값"
				        ,"digit": "digit값"
					}
					,res: ''}
				, code: '200'
				, type: 'extlib'
				, res: {
					"signData": "값" // 전자서명값
					,"code": "0" // 8byte 에러코드 (0성공, 0이외 코드는 8byte자료참고)
					,"msg" : ""
				}
			}),
			// QR 검증
			getQRSignData: JSON.stringify({	
				param:  {name: 'eightbyte'
					,method: 'getQRSignData'
					,param: {
						"publicKey" : "publicKey값"
					}
					,res: ''}
				, code: '200'
				, type: 'extlib'
				, res: {
					"signData": "값" // 전자서명값
					,"code": "0" // 8byte 에러코드 (0성공, 0이외 코드는 8byte자료참고)
					,"msg" : ""
				}
			}),
			
		},
		// PUSH
		// 사용자 등록
		mpush = {
			init: JSON.stringify({
				param:  {name: 'mpush'
					,method: 'init'
					,param: {
						"cuid" :""
    					,"cname":""
					}
					,res: ''}
				, code: '200' // 확인버튼: 200, 취소버튼:201
				, type: 'extlib'
				, res: {
					"code": "0" // 0(성공), -1(실패), 예외(-2)
					,"msg": "메시지" 
				}
			})
		},
		// 잉카인터넷 (디바이스 정보)
		inca = {
			getDeviceInfo: JSON.stringify({
				param:  {name: 'inca'
					,method: 'getDeviceInfo'
					,param: {
						"serverKey" :"값"
					}
					,res: ''}
				, code: '200' // 확인버튼: 200, 취소버튼:201
				, type: 'extlib'
				, res: {
					"data": "값" // 암호화된 수집 정보
					,"code": "0"	// 0(성공), -1(실패)
					,"msg": ""
					,"uuid1": "값"					
					,"uuid2": "값"
					,"key": "값"  // 암호를 복호화 시킬때 필요한 key
				}
			}),
			// 랜덤키 값 가쟈오기
			getNativeRandomKey: JSON.stringify({
				param:  {name: 'inca'
					,method: 'getNativeRandomKey'
					,param: ""
					,res: ''}
				, code: '200' // 확인버튼: 200, 취소버튼:201
				, type: 'extlib'
				, res: {
					"randomKey": "값"
					,"code": "0"
					,"msg": ""
				}
			})
		}
		///////////////////////////////////////////////////////////////////////////////////////
		// 여기까지
		
		var extRes = null;
		eval('extRes = ' + config.name.toLowerCase() + '.' + config.method + ';');
		return extRes;
	}
		
	window._miapsextlib = results; // use general	
	return results;	// use AMD
}));


