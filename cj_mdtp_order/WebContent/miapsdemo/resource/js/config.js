var locale = localStorage.getItem('locale') || navigator.language || navigator.userLanguage;
//console.log('localStorage locale: ' + localStorage.getItem('locale'));
//console.log('navigator.language: ' + navigator.language);
//console.log('navigator.userLanguage: ' + navigator.userLanguage);

var require = {
	baseUrl: getBaseURL(),
	paths: {
		'jquery': 'vendor/jquery/jquery.min',
		'jquery-ui': 'vendor/jquery/jquery-ui-1.12.1',
		'popper': 'vendor/popper/popper.min',
		'bootstrap' : 'vendor/bootstrap/js/bootstrap.min',
		'underscore' :  'vendor/underscore/underscore',
		'text'	: 'vendor/require/text',
		'i18n'	: 'vendor/require/i18n',
		'handlebars': 'vendor/handlebars/handlebars-4.0.11',
		'moment' : 'vendor/moment/moment.min',
		'moment-timezone' : 'vendor/moment/moment-timezone-with-data',
		'utils' : 'resource/js/utils',
		'polyfill'	: 'vendor/polyfill/polyfill',
		'miaps' : 'vendor/miaps/js/miaps_hybrid',
		'miapswp' : 'vendor/miaps/js/miaps_wp',
		'miapspage' : 'vendor/miaps/js/miaps_page',
		'pattern-lock': "vendor/patternLock/patternLock",
		'templates' : "templates",
		'template7': 'vendor/template7/template7',
		'tweenmax': 'vendor/TweenMax',
		'action-sheet': 'resource/js/action_sheet',
		'miaps-modal': 'resource/js/miaps_simple_modal',
		'common': 'resource/js/common',
		'swiper': 'resource/js/swiper',
		'tui-time-picker': 'vendor/toastui/grid/tui-time-picker',
		'tui-date-picker': 'vendor/toastui/grid/tui-date-picker',
		'tui-pagination': 'vendor/toastui/grid/tui-pagination',
		'tui-grid': 'vendor/toastui/grid/tui-grid'
	},
	config: {
		i18n: {
			locale: locale
		}
	},
	shim: {
		'miaps-modal': {
			deps: ['jquery']
		},
		'miaps': {
			deps: ['jquery']
		},
		'miapswp': {
			deps: ['jquery','miaps','polyfill']
		},
		'miapspage': {
			deps: ['miaps','miaps-modal']
		},
		'underscore': {
		    exports: '_'
		},
		'bootstrap': {
			deps: ['jquery','popper']      
	    },
	    'moment-timezone' : {
	        deps: ['moment']
	    },
	    'pattern-lock': {
	    	deps: ['jquery']
	    },
		'action-sheet': {
			deps: ['jquery']
		},
		'template7': {
			deps: ['jquery']
		},
		'tweenmax': {
			deps: ['jquery']
		},
		'swiper': {
			deps: ['jquery']
		},
		'tui-date-picker': {
			deps: ['tui-time-picker']
		},
		'tui-grid': {
			deps: ['tui-date-picker', 'tui-pagination']
		}
	}
};

function getBaseURL() {
	
	var pathConfig = {
		myFileRoot: "/miapsdemo/"				// 개인 프로젝트별로 재정의 (hybrid local path, Ex: /hybrid/)
	}
	
	/*if (navigator.userAgent.match(/Android|iPhone|iPod|iPad/i) && (navigator.platform.match(/Linux|null/i) || navigator.platform.match(/iPhone|iPad|iPod/i))) {
		pathConfig.myFileRoot = "/";
	}*/
	
	var url = location.pathname;
	console.log('pathname: ' + location.pathname); // /miaps/hybrid2/index.html , /index.html
	//alert(url);
	
	var lastPathIndex = url.lastIndexOf("/", url.length);
	var rootIndex = url.indexOf(pathConfig.myFileRoot, 0);
		
	var tmpStr = url.substring(rootIndex + pathConfig.myFileRoot.length, lastPathIndex + 1); //첫번째 /는 제외
	if (tmpStr == '/') {
		tmpStr = '';
	}	
	console.log(tmpStr);
	//alert(tmpStr);
	/*
	 * root index를 찾고, 마지막 /를 찾은 후, root부터 마지막/까지의 문자열안에 '/'수를 찾아서 그 개수만큼 '..'를 붙여준다. 
	 */
	var pathNum = tmpStr.match(/\//g); // /g: 문자열내의 모든 패턴을 찾습니다.
	console.log(pathNum);
	//alert(pathNum);
	
	var resPath = "./";
	if (pathNum != null) {
		resPath = "";
		for (i = 0; i < pathNum.length; i++) {
			resPath = resPath + "../";
		}
	}
	
	console.log(resPath);
	//alert(resPath);
	
	return resPath;
}