require(["jquery", "miaps", "bootstrap",
         ], function($, miaps) {
	
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
		}		
	};
	window._cb = callback;	

	$("#btnBack").on("click", function() {window.history.back();}); 
		
	// 모바일함수 체크
	$('#ktb_getuuid1').on('click', function() {
		var ext_lib_param = {
				name: "KTB", // KIDO, KTB,....
				method: "getUUID1",
				param: "",
				res: ""
			};
			var config = {
				type: "EXTLIB",
				param: ext_lib_param,
				callback: "_cb.mobileTest"
			};
		miaps.mobile(config, _cb.mobileTest);
	});
	
	$('#xecure_getsigncertlist').on('click', function() {
		var ext_lib_param = {
				name: "Xecure_SignCert", // KIDO, KTB,....
				method: "getsigncertlist",
				param: "",
				res: ""
			};
			var config = {
				type: "EXTLIB",
				param: ext_lib_param,
				callback: "_cb.mobileTest"
			};
		miaps.mobile(config, _cb.mobileTest);
	});
	
	$('#xecure_keyboard').on('click', function() {
		var ext_lib_param = {
				name: "Xecure_SignCert", // KIDO, KTB,....
				method: "ShowSignCertKeyboard",
				param: {"type":"normal","title":"테스트","limitlength":"13","server":"false", "vendor":"hee"},
				res: ""
			};
			var config = {
				type: "EXTLIB",
				param: ext_lib_param,
				callback: "_cb.mobileTest"
			};
			miaps.mobile(config, _cb.mobileTest);
	});
	
	$('#xecure_getsigncert').on('click', function() {
		var ext_lib_param = {
				name: "Xecure_SignCert", // KIDO, KTB,....
				method: "GetSignCert",
				param: {randomkey:"",password:"",subjectdn:"",signtype:"",signplain:""},
				res: ""
			};
			var config = {
				type: "EXTLIB",
				param: ext_lib_param,
				callback: "_cb.mobileTest"
			};
		miaps.mobile(config, _cb.mobileTest);
	});
	
	$('#xecure_importauth').on('click', function() {
		var ext_lib_param = {
				name: "Xecure_SignCert", // KIDO, KTB,....
				method: "ImportSignCert",
				param: "",
				res: ""
			};
			var config = {
				type: "EXTLIB",
				param: ext_lib_param,
				callback: "_cb.mobileTest"
			};
		miaps.mobile(config, _cb.mobileTest);
	});
	
	$('#xecure_importcert').on('click', function() {
		var ext_lib_param = {
				name: "Xecure_SignCert", // KIDO, KTB,....
				method: "ImportSaveSignCert",
				param: "",
				res: ""
			};
			var config = {
				type: "EXTLIB",
				param: ext_lib_param,
				callback: "_cb.mobileTest"
			};
		miaps.mobile(config, _cb.mobileTest);
	});
	
	$('#inzi').on('click', function() {
		var ext_lib_param = {
				name: "inzi", // KIDO, KTB,....
				method: "camera",
				param: "",
				res: ""
			};
			var config = {
				type: "EXTLIB",
				param: ext_lib_param,
				callback: "_cb.mobileTest"
			};
		miaps.mobile(config, _cb.mobileTest);
	});
	
	$('#espider').on('click', function() {
		var ext_lib_param = {
				name: "ESpider", // KIDO, KTB,....
				method: "CheckDriverLicense",
				param: {subjectdn:"cn=박형수()0003049200907241303794,ou=IBK,ou=personal4IB,o=yessign,c=kr", password:"034a8bfe160b329ea9da49051e54d7bd", randomkey:"zk8VmuAZALrt4vxQ9\/p8cTfigY0=", reqUserName:"박형수", reqIdentity:"8009091001312", commAddrSido:"서울특별시", commAddrSigungu:"관악구", reqAddress:"호암로", reqPastAddrChangeYN:"0", reqInmateYN:"0", reqRelationWithHHYN:"0", reqChangeDateYN:"0", reqCompositionReasonYN:"0", reqIsIdentityViewYn:"0", reqIsNameViewYn:"0"},
				res: ""
			};
			var config = {
				type: "EXTLIB",
				param: ext_lib_param,
				callback: "_cb.mobileTest"
			};
		miaps.mobile(config, _cb.mobileTest);
	});
	
	$('#tms_login').on('click', function() {
		var ext_lib_param = {
				name: "TMS", 
				method: "login",
				param: {custid:"00050_0001"},
				res: ""
			};
			var config = {
				type: "EXTLIB",
				param: ext_lib_param,
				callback: "_cb.mobileTest"
			};
		miaps.mobile(config, _cb.mobileTest);
	});
	$('#tms_login1').on('click', function() {
		var ext_lib_param = {
				name: "TMS", 
				method: "login",
				param: {custid:"00050_0002"},
				res: ""
			};
			var config = {
				type: "EXTLIB",
				param: ext_lib_param,
				callback: "_cb.mobileTest"
			};
		miaps.mobile(config, _cb.mobileTest);
	});
	
	$('#isbcr').on('click', function() {
		var ext_lib_param = {
				name: "isbcr", 
				method: "General_Camera",
				param: {key:"9060b0bd0e744e713ec82c196001-Pvqg"},
				res: ""
			};
			var config = {
				type: "EXTLIB",
				param: ext_lib_param,
				callback: "_cb.mobileTest"
			};
		miaps.mobile(config, _cb.mobileTest);
	});
	
	
	
	$('#cctv').on('click', function() {
		var ext_lib_param = {
				name: "HITRON", 
				method: "cctv",
				param: {"id":"admin", "pw":"admin", "dvnrsid":"60AAEC", "etime":"2018-08-17 09:00:00", "title":"8월14일 이벤트"},
				res: ""
			};
			var config = {
				type: "EXTLIB",
				param: ext_lib_param,
				callback: ""
			};
		miaps.mobile(config, null);
	});
	
	$('#exafe_keypad').on('click', function() {
		var ext_lib_param = {
				name: "EXTRUS", 
				method: "keypad",
				param: {"type":"number", "title":"푸른저축은행", "subtitle":"인증서 비밀번호", "hint":"인증서 비밀번호를 입력해 주세요.", "min":"10", "max":"15", "e2e":"true"},
				res: ""
			};
			var config = {
				type: "EXTLIB",
				param: ext_lib_param,
				callback: "_cb.mobileTest"
			};
		miaps.mobile(config, _cb.mobileTest);
	});
	
	$('#wizvera_certlist').on('click', function() {
		var ext_lib_param = {
				name: "wizvera", 
				method: "certlist",
				param: "",
				res: ""
			};
			var config = {
				type: "EXTLIB",
				param: ext_lib_param,
				callback: "_cb.mobileTest"
			};
		miaps.mobile(config, _cb.mobileTest);
	});
	
	$('#wizvera_sign').on('click', function() {
		var ext_lib_param = {
				name: "wizvera", 
				method: "sign",
				param: {subject:"CN=박형수-6422061,OU=HTS,OU=동양,OU=증권,O=SignKorea,C=KR", password:"", signdata:""},
				res: ""
			};
			var config = {
				type: "EXTLIB",
				param: ext_lib_param,
				callback: "_cb.mobileTest"
			};
		miaps.mobile(config, _cb.mobileTest);
	});
	
	$('#nfilter_full').on('click', function() {
		var ext_lib_param = {
				name: "nfilter", 
				method: "full",
				param: {type:"char", desc:"키보드설명", e2e:"false"},
				res: ""
			};
			var config = {
				type: "EXTLIB",
				param: ext_lib_param,
				callback: "_cb.mobileTest"
			};
		miaps.mobile(config, _cb.mobileTest);
	});
	
	$('#nfilter_view').on('click', function() {
		var ext_lib_param = {
				name: "nfilter", 
				method: "view",
				param: {type:"char", desc:"키보드설명1", e2e:"false"},
				res: ""
			};
			var config = {
				type: "EXTLIB",
				param: ext_lib_param,
				callback: "_cb.mobileTest"
			};
		miaps.mobile(config, _cb.mobileTest);
	});
	
	$('#ssenstone_finger').on('click', function() {
		var ext_lib_param = {
				name: "ssenstone", 
				method: "finger",
				param: "",
				res: ""
			};
			var config = {
				type: "EXTLIB",
				param: ext_lib_param,
				callback: "_cb.mobileTest"
			};
		miaps.mobile(config, _cb.mobileTest);
	});
	
	$('#rosis_ocr').on('click', function() {
		var ext_lib_param = {
				name: "rosis", 
				method: "ocr",
				param: "",
				res: ""
			};
		var config = {
				type: "EXTLIB",
				param: ext_lib_param,
				callback: "_cb.mobileTest1"
			};
		miaps.mobile(config, _cb.mobileTest);
	});
	
	$('#ktb_fds').on('click', function() {
		// FDS 호출을 위한 KTB 데이터 요청
		var ext_lib_param = {
			name: 'ktb'
			, method: 'getEncSum'
			, param: {
				serverIp			: utils.storage.get('ktbip')
				, serverPort		: utils.storage.get('ktbport')
				, isDisconnected	: 'false'
			}
			, res: ''
		};	
		var config = {
			type: "extlib",
			param: ext_lib_param,
			callback: "_cb.mobileTest"
		};		
		miaps.mobile(config, _cb.mobileTest);
	});
	
	
	
	$('#webview').on('click', function() {
		var ext_lib_param = {
				name: "webview", 
				method: "open",
				param: "http://m.naver.com",
				res: ""
			};
			var config = {
				type: "EXTLIB",
				param: ext_lib_param,
				callback: "_cb.mobileTest"
			};
		miaps.mobile(config, _cb.mobileTest);
	});
	
	$('#permission').on('click', function() {
		var ext_lib_param = {
				name: "permission", 
				method: "app_setting",
				param: "",
				res: ""
			};
			var config = {
				type: "EXTLIB",
				param: ext_lib_param,
				callback: "_cb.mobileTest"
			};
		miaps.mobile(config, _cb.mobileTest);
	});
	
	$('#createbarcode').on('click', function() {
		
		var _param = {
				format: "qrcode", 
				data: "http://gw.thinkm.co.kr",
				orientation: "",
				size: "400:400",
				bgcolor: "",
				color: "",
				res: ""
			};
			
		var config = {
			type: "createbarcode",
			param: _param,
			callback: "_cb.mobileTest"
		};
		miaps.mobile(config, _cb.mobileTest);
	});
	
});