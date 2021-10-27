require(["jquery", 
		 "miaps",
		 "handlebars",
         "bootstrap"
         ], function($, miaps, handlebars) {

//	$(document).ready(function(){
		$("#btnDownloadConnectorUrlFileProtocol").on("click", btnDownloadConnectorUrlFileProtocol);
		$("#btnDownloadConnectorUrlPath").on("click", btnDownloadConnectorUrlPath);
		$("#btnDownloadConnectorUrlPathPdf").on("click", btnDownloadConnectorUrlPathPdf);
		$("#btnDownloadConnectorUrlPathCsv").on("click", btnDownloadConnectorUrlPathCsv);
		$("#btnDownloadConnectorUrlPathXlsx").on("click", btnDownloadConnectorUrlPathXlsx);
		$("#btnBack").on("click", function() {window.history.back();});	
//	}); 

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
		    obj.res.path = sessionStorage.getItem("fpath");
		    parent.append(tempTemplate(obj.res));            
		}
	}
	window._cb = callback;
	
	function changeFile (fullpath) {
		console.log(fullpath);
		
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
				orgurl : 'file:///D:/MiAPS_Server/MiAPS6beta/apache-tomcat-8.5.11/webapps/miaps6beta/asvc/images/zip-48.png',	// file path (1) file:// (2) smb:// (3) /image/pic.jpg (miaps서버 하위 경로)
				dstpath : '${ResourceRoot}/temp/zip-48.png',   // 임시저장 디렉토리
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
				orgurl : 'http://miaps.thinkm.co.kr/miaps6beta/asvc/images/zip-48.png',
				dstpath : '${ResourceRoot}/temp/zip-48.png',   // 임시저장 디렉토리
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

	function btnDownloadConnectorUrlPathXlsx() {
		var config = {
			type: 'filedownload',
			param : {
				orgurl : '/asvc/PushSample.xlsx', // 도메인이 없으면 miaps.server.url을 사용
				dstpath : '${ResourceRoot}/temp/PushSample.xlsx',   // 임시저장 디렉토리
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
						path : '${ResourceRoot}/temp/PushSample.xlsx',
						name : 'MiAPS_Push-Quick_Insert.pdf'
					}
				}
				miaps.mobile(config, null);
			} else if (miaps.isAndroid()) {
				// 안드로이드는 newbrowser
				var config = {
					type: 'newbrowser',
					param : {
						url : 'http://127.0.0.1:18088/temp/PushSample.xlsx'
					},
					callback: ''
				}
				miaps.mobile(config, null);
			}
		});
	}
});