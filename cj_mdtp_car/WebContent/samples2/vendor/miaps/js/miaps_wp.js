(function (factory) {
    //Environment Detection
    if (typeof define === 'function' && define.amd) {
        define([], factory); //AMD
    } else {
        factory(); // Script tag import i.e., IIFE
  }
}(function () {
	/*
	 * miaps.mobile Promise사용 Wrapper
	 * promise_polyfill.js필수, jquery필수
	 */
	var miapsWp = window.miapsWp = {
		
		// call miaps native 
		callNative: function() {
			var type, params, callback, resTest;
			var args = arguments;
			type = args[0];
			params = args[1];			
			resTest = args[2];
			callback = args[3];
			
			return new Promise(function(resolve) {
				var callbackKey = 'mcb' + (Math.random() * 1000000000 | 0);
				//miapsWp._callbacks[callbackKey] = function() {
				window[callbackKey] = function() {
					//delete miapsWp._callbacks[callbackKey];
					delete window[callbackKey];
					if (callback) {
						callback.apply(null, arguments);
					}
					resolve.apply(null, arguments);
				};
				
				var config = {
					type: type,
					param: params,
					res: resTest,
					//callback: 'miapsWp._callbacks.' + callbackKey
					callback: 'window.' + callbackKey
				};
				//miaps.mobile(config, miapsWp._callbacks[callbackKey]);
				miaps.mobile(config, window[callbackKey]);
			});
		},
		
		// call 3rd party library
		callthirdParty: function() {
			var vendorName, funcName, params, callback;
			var args = arguments;
			vendorName = args[0];
			funcName = args[1];
			params = args[2];
			callback = args[3];			
			
			return new Promise(function(resolve) {
				var callbackKey = 'tcb' + (Math.random() * 1000000000 | 0);
				//miapsWp._callbacks[callbackKey] = function() {
				window[callbackKey] = function() {
					//delete miapsWp._callbacks[callbackKey];
					delete window[callbackKey];
					if (callback) {
						callback.apply(null, arguments);
					}
					resolve.apply(null, arguments);
				};
				
				var config = {
					type: 'extlib',
					param: {
						name: vendorName,
						method: funcName,
						param: params,
						res: ''
					},
					//callback: 'miapsWp._callbacks.' + callbackKey
					callback: 'window.' + callbackKey
				};
				//miaps.mobile(config, miapsWp._callbacks[callbackKey]);
				miaps.mobile(config, window[callbackKey]);
			});
		},
		
		// call miaps connector
		callService: function() {
			var args = arguments;
			var classname = args[0];
			var method = args[1];
			var paramArr = [];
			var funcArr = [];
			var paramStr = '';
			
			for (var i=2; i < args.length; ++i) {
				if (typeof(args[i]) === 'function') {
					funcArr.push(args[i]);
				} else if (typeof(args[i]) === 'object') {
					paramArr.push(args[i]);
				} else if (typeof(args[i]) === 'string') {
					paramStr = args[i];
				}
			}
			
			if (paramArr.length > 0) {
				var params = {};
				paramArr.forEach(function(data) {
					params = Object.assign(params, data);
				});
			} else {
				var params = paramStr;
			} 
						
			var onSuccess = funcArr[0];
			var onError = funcArr[1];
			
			var promise = callConnector(classname, method, params);
			
			if (onSuccess) {
				promise = promise.then(onSuccess);
			}
			if (onError) {
				promise = promise.catch(onError);
			}
			
			return promise;
		}
	};
	// END miapsWp

	miapsWp._callbacks = {};
	//miapsWp._translations = {};
	//miapsWp._eventHandler = {};

	function callConnector() {
		var classname, method, params;
		var args = arguments;
		classname = args[0];
		method = args[1];
		params = args[2];
		
		function _callConnector(classname, method, params) {
			if (window._tmdebug) {
				console.log(classname, method, params);
			}

			
			
			return new Promise(function(resolve, reject) {
				////// header test				
				miaps.mobile({
						type: 'loadvalue',
						param: ['sessionid','token']
					}, 
					function(data) {
						var _header = {};
						
						var objData = miaps.parse(data);
						if (_tmdebug) { console.log(JSON.stringify(objData).replace(/,"/g, ',\n"')); }
						try {
							_header.ReqSid = objData.res.sessionid;
							_header.ReqAdata = objData.res.token;
						} catch (e) {
							if (_tmdebug) { console.log(e.message); }
						}

						
						miaps.miapsSvcSp(classname, method, params, '/minkSvc', 
							function(result) {
								if (typeof result === 'string') {
									try {
										result = JSON.parse(result);
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
							},_header);
					});
				///////
				
			});
		}
		
		return _callConnector(classname, method, params);
	}
	
	return miapsWp;
}));




