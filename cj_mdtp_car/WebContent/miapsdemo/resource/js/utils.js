(function(factory) {
	if (typeof define === 'function' && define.amd) {
		define([], factory);
	} else {
		factory([]);
	}
}(function() {
	var CommonUtil = {
		// 암호화 관련 함수
		crypto : {
			aes : { // aes128
				key : '0123456789012345'
				,encrypt: function(value) {
					return CryptoJS.AES.encrypt(value, CommonUtil.crypto.aes. key).toString();
				}
				, decrypt: function(value) {
					return CryptoJS.AES.decrypt(value, CommonUtil.crypto.aes.key).toString(CryptoJS.enc.Utf8);
				}
			},
			seed : {
				key : '1234567890123456'
				,encrypt: function(value) {
					return CryptoJS.SEED.encrypt(value, CommonUtil.crypto.seed.key).toString();
				}
				, decrypt: function(value) {
					return CryptoJS.SEED.decrypt(value, CommonUtil.crypto.seed.key).toString(CryptoJS.enc.Utf8);
				}
			},
			sha256 : { // 단방향
				encrypt: function(value) {
					return CryptoJS.SHA256.encrypt(value).toString();
				}
			}
		},			
		// 세션 관련 함수
		sessions : {
			set: function(name, value) {				
				if (typeof value == 'object') {
					window.sessionStorage.setItem(name, JSON.stringify(value));
				} else {
					window.sessionStorage.setItem(name, value);
				}
			}
			, get: function(name) {
				if (
					window.sessionStorage.getItem(name) == null
					|| typeof window.sessionStorage.getItem(name) == 'undefined'
				) {
					return null;
				} else {
					return window.sessionStorage.getItem(name);
				}
			}
			, setValues: function(object) {
				for (var name in object) {
					if (typeof object[name] == 'string') {
						window.sessionStorage.setItem(name, object[name]);
					} else {
						window.sessionStorage.setItem(name, JSON.stringify(object[name]));
					}
				}
			}
			, getValues: function(){
				var object = new Object();

				for (var i=0; i<window.sessionStorage.length; i++) {
					var key = window.sessionStorage.key(i); 
					object[key] = window.sessionStorage.getItem(key);
				}

				return object;
			}
			, remove: function(name) {
				window.sessionStorage.removeItem(name);
			}
			, removeProcData: function() {
				console.dir(window.sessionStorage);
				for (var i=0; i<window.sessionStorage.length; i++) {
					if (window.sessionStorage.key(i).startsWith('proc_')) {
						window.sessionStorage.removeItem(window.sessionStorage.key(i));
					}
				}
			}		 
		} 
		// 로컬 스토리지 관련함수
		, storage: {
			get: function(name) {
				return window.localStorage.getItem(name);
			}
			, set: function(name, value) {
				window.localStorage.setItem(name, value);
			}
			, remove: function(name) {
				window.localStorage.removeItem(name);
			}			
		}
		, properties: {
			item: {}
			, set: function(name, value) {
				var params = JSON.parse('{"' + name + '":"' + value + '"}');

				miaps.mobile(
					{
						type: 'savevalue'
						, param: params
						, callback: 'utils.properties.callbackPropertiesSet'
					}
					, utils.properties.callbackPropertiesSet
				);
			}
			, callbackPropertiesSet: function(data) {
				var json = (typeof data === 'string') ? JSON.parse(data) : data;
			}
			, get: function(name) {
				miaps.mobile(
					{
						type: 'loadvalue'
						, param: [name]
						, callback: 'utils.properties.callbackPropertiesGet'
					}
					, utils.properties.callbackPropertiesGet
				);
			}
			, callbackPropertiesGet: function(data) {
				var json = (typeof data === 'string') ? JSON.parse(data) : data;

				$.extend(utils.properties.item, json.res);
				
				utils.properties.item[json.param[0]];
			}
		}
		// 데이터 관련 함수
		, json: {
			encode: false
			, params: function(data) {
				var json = (typeof data === 'string') ? JSON.parse(data) : data;
				var returnParams	= "";
				
				//miaps.cursor(null, 'loadip', null);
								
				for (var key in json) {
					if (key == 'usip') {
						json[key] = window.localStorage.getItem('publicIpAddress');
					}
					
					if (CommonUtil.json.encode === true) {
						returnParams += (returnParams == "") ? key + "=" + encodeURIComponent(json[key]) : "&" + key + "=" + encodeURIComponent(json[key]);
					} else {
						returnParams += (returnParams == "") ? key + "=" + json[key] : "&" + key + "=" + json[key];
					}
				}

				return returnParams;
			}
			, stringParams: function(data) {
				if (CommonUtil.json.encode === true) {
					return encodeURIComponent(data);
				} else {
					return data;
				}
			}
		}
		// 문자열 관련 함수
		, strings: {
			toAccount: function(value) {
				if (value == null || typeof value == 'undefined') {
					return value;
				} else {
					if (value.length == 14) {
						return value.substring(0, 3)
							+ '-' + value.substring(3, 5)
							+ '-' + value.substring(5, 7)
							+ '-' + value.substring(7, 14);
					} else {
						return value;
					}
				}
			}
			, toDate: function(value, date_delimiter, time_delimiter){
				var date = '';
				if (validate.isEmpty(date_delimiter)) {
					date_delimiter = '.';
				}
				if (validate.isEmpty(time_delimiter)) {
					time_delimiter = ':';
				}

				if (!validate.isEmpty(value)) {
					switch (value.length) {
						case 14:
							date	= value.substring(0, 4)
									+ date_delimiter + value.substring(4, 6)
									+ date_delimiter + value.substring(6, 8)
									+ ' ' + value.substring(8, 10)
									+ time_delimiter + value.substring(10, 12)
									+ time_delimiter + value.substring(12, 14);
							break;
						case 8:
							date	= value.substring(0, 4)
									+ date_delimiter + value.substring(4, 6)
									+ date_delimiter + value.substring(6, 8);
							break;
						case 6:
							date	= value.substring(0, 2)
									+ time_delimiter + value.substring(2, 4)
									+ time_delimiter + value.substring(4, 6);
							break;
						default:
							date	= value;
							break;
					}
				}
				
				return date;
			}
			, toMobile: function(value) {
				var pattern = /^[0-9]{7,12}$/g;
				
				if (utils.validate.mobileNoType(value, '') && pattern.test(value)) {
					switch (value.length) {
						case 7:
							return 	value.substring(0,3)
									+ '-' + value.substring(3,7);
							break;
						case 8:
							return 	value.substring(0,4)
									+ '-' + value.substring(4,8);
							break;
						case 10:
							return	value.substring(0,3)
									+ '-' + value.substring(3,6)
									+ '-' + value.substring(6,10);
							break;
						case 11:
							return	value.substring(0,3)
									+ '-' + value.substring(3,7)
									+ '-' + value.substring(7,11);
							break;
						case 12:
							return	value.substring(0,4)
									+ '-' + value.substring(4,8)
									+ '-' + value.substring(8,12);
							break;
						default:
							return	'';
							break;
					}
				} else {
					return '';
				}
			}
			, dateText: function(value, format) {
				value = utils.strings.toNumber(value);

				if (value != null && typeof value != 'undefined') {
					switch (value.length) {
						case 14:
							format = format
									.replace('yyyy', value.substring(0, 4))
									.replace('mm', value.substring(4, 6))
									.replace('dd', value.substring(6, 8))
									.replace('hh', value.substring(8, 10))
									.replace('mi', value.substring(10, 12))
									.replace('ss', value.substring(12, 14));
							break;
						case 8:
							format = format
									.replace('yyyy', value.substring(0, 4))
									.replace('mm', value.substring(4, 6))
									.replace('dd', value.substring(6, 8));
							break;
						case 6:
							format = format
									.replace('yyyy', value.substring(0, 4))
									.replace('mm', value.substring(4, 6));
							break;
						case 4:
							format = format
									.replace('yyyy', value.substring(0, 4));
							break;
						default:
							format	= format;
							break;
					}
				}
				
				return format;
			}
			, toNumber: function(value) {
				return value.replace(/[^0-9]/gi, '');
			}
			, numberFormat: function(value) {
				var number = Number(value);

				return number.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
			}
			, numberText: function(value) {
				var array1 = new Array('', '일', '이', '삼', '사', '오', '육', '칠', '팔', '구', '십');
				var array2 = new Array('', '십', '백', '천');
				var array3 = new Array('', '만', '억', '조');
				var text = '';
				

				if (!isNaN(value)) {
					var empty = (value.substring(1, value.length).replace(/0/gi, '') == '');

					for (var i=0; i<value.length; i++) {
						var str = ''

						han = array1[value.charAt(value.length - (i + 1))];
						
						if (han != '') str = han + array2[i % 4];

						if (i == 4) {
							if (empty) {
								if (value.length <= 8 ) {
									str += array3[i / 4];
								}
							} else {
								if (value.substring(value.length - 8, value.length - 4).replace(/0/gi, '') != '') {
									str += array3[i / 4];
								}
							}
						}
						
						if (i == 8) {
							if (empty) {
								if (value.length <= 12 ) {
									str += array3[i / 4];
								}
							} else {
								if (value.substring(value.length - 12, value.length - 8).replace(/0/gi, '') != '') {
									str += array3[i / 4];
								}
							}
						}
						
						if (i == 12) {
							if (empty) {
								if (value.length <= 16 ) {
									console.log('1');
									str += array3[i / 4];
								}
							} else {
								console.log('2');
								if (value.substring(value.length - 16, value.length - 12).replace(/0/gi, '') != '') {
									str += array3[i / 4];
								}
							}
						}

						text = str + text;
					}
				}
				
				return text;
			}			
		}
		// 날짜 관련 함수
		, date: {
			dateAdd: function(type, term, date, separator) {
				var yyyy, mm, dd;
				var returnDate;

				if (
					typeof separator == 'undefined'
					|| separator == null
					|| separator == '' 
				) {
					if (date.length == 8) {
						yyyy	= Number(date.substring(0, 4));
						mm		= Number(date.substring(4, 6));
						dd		= Number(date.substring(6, 8));
					} else {
						console.log('invalid date format');
						return date;
					}
				} else {
					if (
						date.length == 10 && date.indexOf(separator) > -1
					) {
						yyyy	= Number(date.split(separator)[0]);
						mm		= Number(date.split(separator)[1]);
						dd		= Number(date.split(separator)[2]);
					} else {
						console.log('invalid date format');
						return date;
					}
				}

				returnDate = new Date(yyyy, mm - 1, dd);

				switch (type) {
					case 'd':
						returnDate.setTime(returnDate.getTime() + (term * (24 * 60 * 60 * 1000)));
						break;
					case 'm':
						var date1, date2;
						var y = parseInt(term / 12);
						var m = term % 12;

						if (mm + m > 1 && mm + m < 12) {
							date1 = new Date(yyyy + y, mm - 1, 1);
							date2 = new Date(yyyy + y, (mm + m) - 1, 1);

							if (term > 0) {
								returnDate.setTime(
									returnDate.getTime()
									+ Math.abs((365 * y) * (24 * 60 *60 * 1000))
									+ Math.abs(date1.getTime() - date2.getTime())
									- (24 * 60 *60 * 1000) // 이동후 하루를 뺀다.
								);
							} else {
								returnDate.setTime(
									returnDate.getTime()
									- Math.abs((365 * y) * (24 * 60 *60 * 1000))
									- Math.abs(date1.getTime() - date2.getTime())
									+ (24 * 60 *60 * 1000) // 이동후 하루를 더한다.
								);
							}
						} else {
							date1 = new Date(yyyy, mm - 1, 1);

							if (term > 0) {
								date2 = new Date(
									yyyy + Math.abs(y) + Math.abs(parseInt((m + mm) / 12))
									, parseInt((m + mm) % 12) - 1
									, 1
								);

								returnDate.setTime(
									returnDate.getTime()
									+ Math.abs(date1.getTime() - date2.getTime())
									- (24 * 60 *60 * 1000) // 이동후 하루를 뺀다.
								);
							} else {
								date2 = new Date(
									yyyy - Math.abs(y) - Math.abs(parseInt(m / mm))
									, ((mm - Math.abs(m)) > 0 ? (mm - Math.abs(m)) : 12 - Math.abs(mm - Math.abs(m))) - 1
									, 1
								);

								returnDate.setTime(
									returnDate.getTime()
									- Math.abs(date1.getTime() - date2.getTime())
									+ (24 * 60 *60 * 1000) // 이동후 하루를 더한다.
								);
							}
						}

						break;
					case 'y':
						returnDate.setYear(yyyy + term);

						if (term > 0) {
							returnDate.setTime(
								returnDate.getTime()
								- (24 * 60 *60 * 1000) // 이동후 하루를 뺀다.
							);
						} else {
							returnDate.setTime(
								returnDate.getTime()
								+ (24 * 60 *60 * 1000) // 이동후 하루를 더한다.
							);
						}
						break;
					default:
						returnDate.setTime(date1.getTime() + (term * (24 * 60 * 60 * 1000)));
						break;
				}

				return returnDate.getFullYear()
					+ separator + ((returnDate.getMonth() + 1 >= 10) ? returnDate.getMonth() + 1 : '0' + (returnDate.getMonth() + 1))
					+ separator + ((returnDate.getDate() >= 10) ? returnDate.getDate() : '0' + returnDate.getDate());
			}
			, dateDiff: function(date1, date2, separator, timeTF) {
				var yyyy1, mm1 ,dd1;
				var yyyy2, mm2 ,dd2;
				var time;

				if (
					typeof separator == 'undefined'
					|| separator == null
					|| separator == '' 
				) {
					if (date1.length == 8 && date2.length == 8) {
						yyyy1	= Number(date1.substring(0, 4));
						yyyy2	= Number(date2.substring(0, 4));
						mm1		= Number(date1.substring(4, 6)) - 1;
						mm2		= Number(date2.substring(4, 6)) - 1;
						dd1		= Number(date1.substring(6, 8));
						dd2		= Number(date2.substring(6, 8));
					} else {
						console.log('invalid date format');
						return 0;
					}
				} else {
					if (
						date1.length == 10
						&& date2.length == 10
						&& date1.indexOf(separator) > -1
						&& date2.indexOf(separator) > -1
					) {
						yyyy1	= Number(date1.split(separator)[0]);
						yyyy2	= Number(date2.split(separator)[0]);
						mm1		= Number(date1.split(separator)[1]) - 1;
						mm2		= Number(date2.split(separator)[1]) - 1;
						dd1		= Number(date1.split(separator)[2]);
						dd2		= Number(date2.split(separator)[2]);
					} else {
						console.log('invalid date format');
						return 0;
					}
				}

				time = Number(
					new Date(yyyy2, mm2, dd2).getTime()
					- new Date(yyyy1, mm1, dd1).getTime()
				);

				return (timeTF) ? time : time / (24 * 60 * 60 * 1000);
			}
			, dateString: function() {
				var now = new Date();

				return String(now.getFullYear())
					+ ((now.getMonth() >= 9) ? String(now.getMonth() + 1) : '0' + String(now.getMonth() + 1))
					+ ((now.getDate() >= 10) ? String(now.getDate()) : '0' + String(now.getDate()))
					+ ((now.getHours() >= 10) ? String(now.getHours()) : '0' + String(now.getHours()))
					+ ((now.getMinutes() >= 10) ? String(now.getMinutes()) : '0' + String(now.getMinutes()))
					+ ((now.getSeconds() >= 10) ? String(now.getSeconds()) : '0' + String(now.getSeconds()));
			}
			, dateParse: function(value, separator) {
				var dateArray = value.split(separator);

				return new Date(dateArray[0], dateArray[1], dateArray[2]);
			}
		}
		// 유효성 체크관련 함수
		, validate: {
			email : function(value) {
				var emailAdr	= value;
				var re			= /^(([^<>()\[\]\.,;:\s@\"]+(\.[^<>()\[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;

				return re.test(emailAdr);
			}
			, telNoType : function(value, type) {
				var telNo	= value;
				var re		= '';
				
				if(type == '-') {
//					re = /^\d{2,3}-\d{3,4}-\d{4}$/;
					re = /^(0(2|3[1-3]|4[1-4]|5[1-5]|6[1-4]))-(\d{3,4})-(\d{4})$/;
				}
				else {
//					re = /^\d{2,3}\d{3,4}\d{4}$/;
					re = /^(0(2|3[1-3]|4[1-4]|5[1-5]|6[1-4]))(\d{3,4})(\d{4})$/;
				}
				
				return re.test(telNo);
				
			}
			, mobileNoType : function(value, type) {
				var mobileNo	= value;
				var re			= '';
				
				if(type == '-') {
//					re = /^\d{3}-\d{3,4}-\d{4}$/;
					re = /^01([0|1|6|7|8|9]?)-?([0-9]{3,4})-?([0-9]{4})$/;
				}
				else {
//					re = /^\d{3}\d{3,4}\d{4}$/;
					re = /^01([0|1|6|7|8|9]?)?([0-9]{3,4})?([0-9]{4})$/;
				}
				
				return re.test(mobileNo);
			}
			, isEmpty: function(value) {
				if (
					typeof value == 'undefined'
					|| value == null
					|| value == ''
				) {
					return true;
				}
				
				return false;
			}
			, isUndefined: function(value) {
				return (typeof value == 'undefined');
			}
			, isNull: function(value) {
				return (value == null);
			}
			, isObject: function(value) {
				return (typeof value == 'object' && value != null);
			}
			
			, chkPwdPatternDef: function (pwd) {
				var patternVal = /^(?=.*[a-zA-Z])(?=.*[0-9]).{8,12}/; // 영문,숫자 조합, 8-12자리
				return patternVal.test(pwd);
			}, chkEnglish: function (text) {
				var engPatternVal = /^[a-zA-z\s]+$/; // 영문 및 공백만 허용
				return engPatternVal.test(text);
			}
		}
		, control: {
			scrollLockEnable: function() {
				var scrollTop = $(window).scrollTop();
				
				$(window).on('scroll', function() {
					$(window).scrollTop(scrollTop);
				});
			}
			, scrollLockDisable: function() {
				$(window).off('scroll');
			}
		}
	};

	window.utils = CommonUtil;
	
	return CommonUtil;
}));

//console.log('common');