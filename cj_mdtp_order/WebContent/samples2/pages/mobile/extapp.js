require(["jquery", "miaps", "bootstrap"
         ], function($, miaps) {
	

  	$("#btnRun").on("click", goRun);
  	$("#btnRun2").on("click", goRun2);
  	$("#btnBack").on("click", function() {window.history.back();});      	
	
  	var naver_url_adr_store = 'https://play.google.com/store/apps/details?id=com.nhn.android.search';
  	var naver_url_ios_store = 'https://itunes.apple.com/kr/app/id393499958?mt=8';  	                           
  	var naver_scheme = 'naversearchapp://';
  	var store_url = '';
	
	function goRun() {
		if (miaps.MobilePlatform.Android()) {			
			location.href = 'intent://qmenu=voicerecg&version=1#Intent;scheme=naversearchapp;action=android.intent.action.VIEW;category=android.intent.category.BROWSABLE;package=com.nhn.android.search;end';

		} else if (miaps.MobilePlatform.iPhone() || miaps.MobilePlatform.iPad()) {
			var clickedAt = +new Date;

		    naverAppCheckTimer = setTimeout(function() {
		        if (+new Date - clickedAt < 2000){
		            if (window.confirm("네이버 앱 최신 버전이 설치되어 있지 않습니다.   \n설치페이지로 이동하시겠습니까?")) { 
		            	location.href = naver_url_ios_store; // jump app store
		            }
		        }
		    }, 1500);
		    
		    location.replace = 'naversearchapp://search?qmenu=voicerecg&version=1'; // 앱 실행
		}
	}
	
	function goRun2() {
		var clickedAt = +new Date;

	    naverAppCheckTimer = setTimeout(function() {
	        if (+new Date - clickedAt < 2000){
	            if (window.confirm("네이버 앱 최신 버전이 설치되어 있지 않습니다.   \n설치페이지로 이동하시겠습니까?")) { 
	            	if (miaps.MobilePlatform.Android()) {			
	            		store_url = naver_url_adr_store;
	        		} else if (miaps.MobilePlatform.iPhone() || miaps.MobilePlatform.iPad()) {
	        			store_url = naver_url_ios_store;
	        		}
	            	location.href = store_url; // jump app store
	            }
	        }
	    }, 1500);
	    
	    location.href = 'naversearchapp://search?qmenu=voicerecg&version=1'; // 앱 실행
	}
});

/* iOS 앱 스토어 URL 찾기 https://itunes.apple.com/kr 접속 후 해당 앱 찾아서 상세페이지 이동 후, URL복사하여 사용. */