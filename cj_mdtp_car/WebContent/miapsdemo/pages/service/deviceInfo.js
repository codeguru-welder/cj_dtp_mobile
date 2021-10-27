require(["jquery", 
         "underscore",
         "handlebars",
		 "miaps", 
		 "miapspage",
		 "bootstrap"		 
         ], function($, _, handlebars, miaps, miapspage) {
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
	
	$('#js_user_agent').on('long-press', function(e) {
		miaps.mobile(
			{
			  type: "toasts",
			  param: { msg: $(this).val()},
			},
			function (data) {}
		);
	});

	$('#long_press').on('long-press', function(e) {
		miaps.mobile(
			{
			  type: "toasts",
			  param: { msg: $('#js_user_agent').val()},
			},
			function (data) {}
		);
	});

	var source = $('#display-template').html();
	var tempTemplate = handlebars.compile(source);
	
	$(function () {
    	multicall();
	});  
	
	function multicall(){
		var types = ['DEVICEMODEL',
					'DEVICEID',
					'ISTABLET',
					'LANGUAGE',
					'PLATFORM',
					'PLATFORMVERSION',
					'APPID',
					'BUNDLEID',
					'VERSION'
				];
			for (var i = 0; i < types.length; i++) {
				var config = {
					type : types[i],
					param : i,
					callback : '_cb.cbMulticall'
			}
			miaps.mobile(config, _cb.cbMulticall);
		}	

		$('#js_user_agent').val(navigator.userAgent);		
	}
	
	// 장치 모델 정보
	function devicemodel(){
		var config = {
				type : 'DEVICEMODEL',
				param : '',
				callback : '_cb.cbDeviceInfo'
		}
		miaps.mobile(config, _cb.cbDeviceInfo);
	}
	
	// 장치 ID 정보
	function deviceid(){
		var config = {
				type : 'DEVICEID',
				param : '',
				callback : '_cb.cbDeviceInfo'
		}
		miaps.mobile(config, _cb.cbDeviceInfo);
	}  
	
	// 테블릿 확인
	function istablet(){
		var config = {
				type : 'ISTABLET',
				param : '',
				callback : '_cb.cbDeviceInfo'
		}
		miaps.mobile(config, _cb.cbDeviceInfo);
	} 	
	
	// 장치 언어
	function language(){
		var config = {
				type : 'LANGUAGE',
				param : '',
				callback : '_cb.cbDeviceInfo'
		}
		miaps.mobile(config, _cb.cbDeviceInfo);
	}
	
	// 플랫폼
	function platform(){
		var config = {
				type : 'PLATFORM',
				param : '',
				callback : '_cb.cbDeviceInfo'
		}
		miaps.mobile(config, _cb.cbDeviceInfo);
	}
	
	// 플랫폼 버전
	function platformversion(){
		var config = {
				type : 'PLATFORMVERSION',
				param : '',
				callback : '_cb.cbDeviceInfo'
		}
		miaps.mobile(config, _cb.cbDeviceInfo);
	}
	
	// 앱 ID
	function appid(){
		var config = {
				type : 'APPID',
				param : '',
				callback : '_cb.cbDeviceInfo'
		}
		miaps.mobile(config, _cb.cbDeviceInfo);
	}
	
	// Bundle ID
	function bundleid(){
		var config = {
				type : 'BUNDLEID',
				param : '',
				callback : '_cb.cbDeviceInfo'
		}
		miaps.mobile(config, _cb.cbDeviceInfo);
	}
	
	// 앱 버전 정보
	function version(){
		var config = {
				type : 'VERSION',
				param : '',
				callback : '_cb.cbDeviceInfo'
		}
		miaps.mobile(config, _cb.cbDeviceInfo);
	}
	
	var callback = {	
		cbDeviceInfo : function (data) {
			miaps.cursor(null, 'default');
				
			var obj = miaps.parse(data);
			
			if (typeof obj == 'object') {
				console.log(JSON.stringify(obj).replace(/,"/g, ',\n"'));
				alert(obj.res);
			} else if (typeof obj == 'string') {
				console.log(obj);
				alert(obj);
			}
		},
		
		cbMulticall: function(data) {
				miaps.cursor(null, 'default');
				var obj = miaps.parse(data);
				
				window.sessionStorage.setItem(obj.type, obj.res);

				if (obj.type == 'VERSION') { // last data
					var data = {result: []};
					var parent = $("#contents");
					
					var types = ['DEVICEMODEL',
								'DEVICEID',
								'ISTABLET',
								'LANGUAGE',
								'PLATFORM',
								'PLATFORMVERSION',
								'APPID',
								'BUNDLEID',
								'VERSION'
								];
					console.log('---result---');
					for (var i = 0; i < types.length; i++) {
						console.log(window.sessionStorage.getItem(types[i]));
						var tmp = {type: types[i], res: window.sessionStorage.getItem(types[i])};
						data.result.push(tmp);
					}		
					parent.append(tempTemplate(data));	
				}
			}
	};
	window._cb = callback;
});