require(["jquery", "miaps", "bootstrap"
         ], function($, miaps) {
	

  	$("#btnStartWith").on("click", goStartWith);
  	$("#btnIndexOf").on("click", goIndexOf);
  	$("#btnBack").on("click", function() {window.history.back();});      	
	
  	var _val = '1234567890';
  	
	function goStartWith() {
		try {
			// startsWith, 안드로이드 4.4이하에서는 에러발생
			if (_val.startsWith('8')) {
				$('#result-div').html('true');
			} else {
				$('#result-div').html('false');
			}
		} catch (e) {
			$('#result-div').html(e.message);
		}
	}
	
	function goIndexOf() {
		if (_val.indexOf('8') === 0) {
			$('#result-div').html('true');
		} else {
			$('#result-div').html('false');
		}
	}
});

/* iOS 앱 스토어 URL 찾기 https://itunes.apple.com/kr 접속 후 해당 앱 찾아서 상세페이지 이동 후, URL복사하여 사용. */