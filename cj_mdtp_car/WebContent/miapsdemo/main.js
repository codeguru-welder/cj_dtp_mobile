require(["jquery", 
		 "miaps", 
		 "miapspage"
         ], function($, miaps, miapsPage) {
 	
    $("#go_native").on("click", function (e) {
      e.preventDefault();
      // 네이티브 기능 페이지 이동
      miapsPage.go("native.html");
    });

    $("#go_welfare").on("click", function (e) {
      e.preventDefault();
      // 경기복지 페이지 이동
      miapsPage.go("view/LN/LN040.html");
    });
/*
    $("#backtest").on("click", function (e) {
      e.preventDefault();
      miapsPage.back();
    });
*/
    $("#go_schedule").on("click", function (e) {
      e.preventDefault();
      if (miaps.isPC()) {
        showModal("[Miaps 일정]앱을 설치해주세요.", "OK");
        return;
      }
      var userAgentstr = navigator.userAgent.toLowerCase();
      if (userAgentstr.indexOf("android") > -1) {
        var scheduleAppInfo = "kr.co.miaps.hybrid.schedule";
      } else {
        var scheduleAppInfo = "hybridschedule";
      }

      miaps.mobile(
        {
          type: "isinstalled",
          param: scheduleAppInfo,
          // param: "kr.co.miaps.hybrid.schedule", // adroid 패키지명
          // param: "hybridschedule", // ios 스킴명
        },
        function (data) {
          var obj = miaps.parse(data);
          if (obj.code != "200") {
            console.log(obj.msg);
          } else {
            var data = obj.res;
            if (data === "true") {
              // Miaps 일정 앱 호출
              location.href = "hybridschedule://";
            } else {
              showModal("[Miaps 일정]앱을 설치해주세요.", "OK");              
            }
          }
        }
      );
	});
  
  miapsPage.setTopPage('main', function() {
      // 장치정보 등록,  라이선스 체크, 푸시 토큰 취득
      miaps.setDeviceInfo("test", "", "", "", "");
  });
  
});