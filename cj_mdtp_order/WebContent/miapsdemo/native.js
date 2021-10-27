require(["jquery", 
		 "miaps", 
		 "miapspage"
         ], function($, miaps, miapsPage) {

	 $(".back_btn, .home_btn").on("click", function (e) {
      e.preventDefault();
      // 네이티브 기능 페이지 이동
      miapsPage.back();
    });

    $(".push_list").on("click", function (e) {
      e.preventDefault();
      // 네이티브 기능 페이지 이동
      // miapsPage.go("pages/service/notification.html");
      miapsPage.go("pages/service/pushList.html");
    });

    $(".file_upload").on("click", function (e) {
      e.preventDefault();
      // 네이티브 기능 페이지 이동
      miapsPage.go("pages/service/fileUploadMobile.html");
    });

    $(".file_download").on("click", function (e) {
      e.preventDefault();
      // 네이티브 기능 페이지 이동
      miapsPage.go("pages/service/fileDownloadMobile.html");
    });    

    $(".gps").on("click", function (e) {
      e.preventDefault();
      // 네이티브 기능 페이지 이동
      miapsPage.go("pages/service/gpsMobile.html");
    });

    $(".camera").on("click", function (e) {
      e.preventDefault();
      // 네이티브 기능 페이지 이동
      miapsPage.go("pages/service/cameraMobile.html");
    });

    $(".testpage").on("click", function (e) {
      e.preventDefault();
      // 네이티브 기능 페이지 이동
      miapsPage.go("pages/service/pushList_sqlite.html");
    });

    $(".QRcode").on("click", function (e) {
      e.preventDefault();
      // 네이티브 기능 페이지 이동
      miapsPage.go("pages/service/QRcode.html");
    });

    $(".Sqlite").on("click", function (e) {
      e.preventDefault();
      // 네이티브 기능 페이지 이동
      miapsPage.go("pages/service/sqlite.html");
    });

    $(".docView").on("click", function (e) {
      e.preventDefault();
      // 네이티브 기능 페이지 이동
      miapsPage.go("pages/service/docView.html");
    });

    $(".deviceInfo").on("click", function (e) {
      e.preventDefault();
      // 네이티브 기능 페이지 이동
      miapsPage.go("pages/service/deviceInfo.html");
    });

    $(".fingerprint").on("click", function (e) {
      e.preventDefault();
      // 네이티브 기능 페이지 이동
      miapsPage.go("pages/service/fingerprint.html");
    });

    $(".saveLoadValue").on("click", function (e) {
      e.preventDefault();
      // 네이티브 기능 페이지 이동
      miapsPage.go("pages/service/saveLoadValue.html");
    });
    
    $(".localFile").on("click", function (e) {
        e.preventDefault();
        // 네이티브 기능 페이지 이동
        miapsPage.go("pages/service/localFile.html");
     });	

    $(".aes128").on("click", function (e) {
      e.preventDefault();
      // 네이티브 기능 페이지 이동
      miapsPage.go("pages/service/AES128.html");
    }); 

    $(".actionsheet").on("click", function (e) {
      e.preventDefault();
      // 네이티브 기능 페이지 이동
      miapsPage.go("pages/service/actionsheet/actionsheet.html");
    }); 

    $(".3rdparty").on("click", function (e) {
      e.preventDefault();
      // 네이티브 기능 페이지 이동
      miapsPage.go("pages/service/3rdparty.html");
    }); 

    $(".UIcategory").on("click", function (e) {
      e.preventDefault();
      // 네이티브 기능 페이지 이동
      miapsPage.go("pages/service/UIcategory.html");
    }); 

    $(".miapsSVC").on("click", function (e) {
      e.preventDefault();
      // 네이티브 기능 페이지 이동
      miapsPage.go("pages/service/miapsSVC.html");
    }); 

    $(".pageNavi").on("click", function (e) {
      e.preventDefault();
      // 네이티브 기능 페이지 이동
      miapsPage.go("pages/service/pageNavi.html");
    });

	$(".translations").on("click", function (e) {
      e.preventDefault();
      // 네이티브 기능 페이지 이동
      miapsPage.go("pages/service/translations.html");
    });

    $(".toastUiGrid").on("click", function (e) {
        e.preventDefault();
        // 네이티브 기능 페이지 이동
        miapsPage.go("pages/service/gridSample.html");
    });

    $(".fileUploadEncodingTest").on("click", function (e) {
        e.preventDefault();
        // 네이티브 기능 페이지 이동
        miapsPage.go("pages/service/fileUploadEncodingTest.html");
    });
    $(".sqliteExecuteTest").on("click", function (e) {
        e.preventDefault();
        // 네이티브 기능 페이지 이동
        miapsPage.go("pages/service/sqliteExecuteTest.html");
    });

    $(".gpsTracking").on("click", function (e) {
      e.preventDefault();
      // 네이티브 기능 페이지 이동
      miapsPage.go("pages/service/gpsTracking.html");
  });
});