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
			
	$("#btnDownloadConnectorUrlFileProtocol").on("click", btnDownloadConnectorUrlFileProtocol);
	$("#btnDownloadConnectorUrlPath").on("click", btnDownloadConnectorUrlPath);
	$("#btnDownloadConnectorUrlPathPdf").on("click", btnDownloadConnectorUrlPathPdf);
	$("#btnDownloadConnectorUrlPathCsv").on("click", btnDownloadConnectorUrlPathCsv);	
	  
	var source = $('#display-template').html();
	var tempTemplate = handlebars.compile(source);	
	
	var callback = {
        cbRedraw: function(data) {
			console.log(data);
			
			var parent = $("#show-image");
		    parent.children("#_upload_display").remove();
		    parent.children("#desc").remove();
		    
		    var obj = miaps.parse(data);
		    console.log(obj);
		    
		    /*
		     * obj: res.src, res.name, res.size, res.type
		     */		    	
		    // obj.res.path = sessionStorage.getItem("fpath");
		    parent.append(tempTemplate(obj.res));            
		}
	};
	window._cb = callback;
	
	
	function changeFile (fullpath) {
		console.log(fullpath);
		
		miaps.mobile(
			{
			  type: "toasts",
			  param: { msg: fullpath },
			},
			function (data) {}
		);

		var config = {
				type: "filecontents",
				param: { 
					path: fullpath
				},
				callback: "_cb.cbRedraw"
		}			
		miaps.mobile(config, _cb.cbRedraw);	
	}	
	
	function btnDownloadConnectorUrlFileProtocol() {
		var config = {
			type: 'filedownload',
			param : {
				orgurl : 'file:///D:/MiAPS_Server/MiAPS6beta/apache-tomcat-8.5.11/webapps/miaps6beta/asvc/images/moon.jpg',	// file path (1) file:// (2) smb:// (3) /image/pic.jpg (miaps서버 하위 경로)
				dstpath : '${ResourceRoot}/temp/moon.jpg',   // 임시저장 디렉토리
				isprogress : '0',	//  0: not use, 1: show progress bar, 2: show wait cursor
				miaps : 'true'		// miaps (true/false)
			}
		}
		miaps.mobile(config, function(data) {
			console.log(data);
			changeFile(data.res);
		});
	}

	function btnDownloadConnectorUrlPath() {
		var config = {
			type: 'filedownload',
			param : {
				orgurl : 'http://miaps.thinkm.co.kr/miaps6beta/asvc/images/startrails.jpg',
				dstpath : '${ResourceRoot}/temp/startrails.jpg',   // 임시저장 디렉토리
				isprogress : '0',	//  0: not use, 1: show progress bar, 2: show wait cursor
				miaps : 'true'		// miaps (true/false)				
			}
		}
		miaps.mobile(config, function(data) {
			console.log(data);
			changeFile(data.res);
		});
	}

	function btnDownloadConnectorUrlPathPdf() {
		var config = {
			type: 'filedownload',
			param : {
				orgurl : 'http://miaps.thinkm.co.kr/miaps6beta/asvc/MiAPS_Push-Quick_Insert.pdf',
				dstpath : '${ResourceRoot}/temp/MiAPS_Push-Quick_Insert.pdf',   // 임시저장 디렉토리
				isprogress : '0',	//  0: not use, 1: show progress bar, 2: show wait cursor
				miaps : 'true'		// miaps (true/false)				
			}
		}
		miaps.mobile(config, function(data) {
			console.log(data);

			// iOS의 경우 파일공유 창 열기
			if (miaps.isIOS()) {
				var config = {
					type: 'fileshare',
					param : {
						path : '${ResourceRoot}/temp/MiAPS_Push-Quick_Insert.pdf',
						name : 'MiAPS_Push-Quick_Insert.pdf'
					}
				}
				miaps.mobile(config, null);
			} else if (miaps.isAndroid()) {
				// 안드로이드는 newbrowser
				var config = {
					type: 'newbrowser',
					param : {
						url : 'http://127.0.0.1:18088/temp/MiAPS_Push-Quick_Insert.pdf'						
					},
					callback: ''
				}
				miaps.mobile(config, null);
			}
		});
	}

	function btnDownloadConnectorUrlPathCsv() {
		var config = {
			type: 'filedownload',
			param : {
				orgurl : 'http://miaps.thinkm.co.kr/miaps6beta/asvc/PushSample.csv',
				dstpath : '${ResourceRoot}/temp/PushSample.csv',   // 임시저장 디렉토리
				isprogress : '0',	//  0: not use, 1: show progress bar, 2: show wait cursor
				miaps : 'true'		// miaps (true/false)				
			}
		}
		miaps.mobile(config, function(data) {
			console.log(data);

			// iOS의 경우 파일공유 창 열기
			if (miaps.isIOS()) {
				var config = {
					type: 'fileshare',
					param : {
						path : '${ResourceRoot}/temp/PushSample.csv',
						name : 'MiAPS_Push-Quick_Insert.pdf'
					}
				}
				miaps.mobile(config, null);
			} else if (miaps.isAndroid()) {
				// 안드로이드는 newbrowser
				var config = {
					type: 'newbrowser',
					param : {
						url : 'http://127.0.0.1:18088/temp/PushSample.csv'
					},
					callback: ''
				}
				miaps.mobile(config, null);
			}
		});
	}	
});