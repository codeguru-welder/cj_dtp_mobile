require(["jquery", "miaps", "polyfill", "bootstrap"
         ], function($, miaps) {

  	$("#btnRun").on("click", goRun);
  	$("#btnBack").on("click", function() {window.history.back();});      	
  	
  	function callConnector() {
		var classNm, method, params;
		
		classNm = arguments[0];
		method = arguments[1];
		params = arguments[2];
		
		function _callConnector(classNm, method, params) {
			if (window._debug) {
				console.log('callConnector', method, params);
			}
			
			return new Promise(function(resolve, reject) {
				miaps.miapsSvcSp(classNm, method, params, '/minkSvc', 
					function(result) {
						if (typeof result === 'string') {
							try {
								result = miaps.parse(result);
							} catch(e) {
								reject({code: '9999', error: result});
								return;
							}
						}
						
						if (result.error) {
							reject(result);
						} else {
							resolve(result);
						}
					})						
			});
		}
		
		return _callConnector(classNm, method, params);
	}
  	
  	function callService() {
		var args = arguments;
		var classNm = args[0];
		var method = args[1];
		var paramArr = [];
		var funcArr = [];
		
		for (var i=2; i < args.length; i++) {
			if (typeof(args[i]) === 'function') {
				funcArr.push(args[i]);
			} else {
				paramArr.push(args[i]);
			}
		}
		
		var params = Object.assign({}, paramArr);
		//params.body = paramArr[0];
		//params.serviceCode = args[0];
		var onSuccess = funcArr[0];
		var onError = funcArr[1];
		
		var promise = callConnector(classNm, method, params);
		if (onSuccess) {
			promise = promise.then(onSuccess);
		}
		if (onError) {
			promise = promise.catch(onError);
		}
		
		return promise;
	}
  	
	function goRun() {
		var timestamp = new Date().getTime();
		
		Promise.all([
			callService('com.mink.connectors.hybridtest.list.JsonService',
			'run',{
				a:'1',
				b:'2'
			}).then(function(result) {
				console.log('첫번째');
				console.log(result);
			}),
			/*}, function(result) {
				console.log('첫번째');
				console.log(result);
			}),*/
			callService('com.mink.connectors.hybridtest.list.JsonService',
			'run',{
				a:'1',
				b:'2'
			}).then(function(result) {
				console.log('두번째');
				console.log(result);
			})
			/*}, function(result) {
				console.log('두번째');
				console.log(result);
			})*/			
		]).then(function(result) {
			console.log('끝');
			console.log(result);
			alert('ok');
		}).catch(function(error) {
			alert(error);
		});
	}
});
