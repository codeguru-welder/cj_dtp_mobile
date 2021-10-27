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
			
	$("#btnCamera").on("click", runCamera);
	$("#btnGallery").on("click", runGallery);	
	$("#btnUpload").on("click", uploadFileAndParam);	
	$("#btnUpload_base64").on("click", btnUploadBase64);
	  
	var source = $('#display-template').html();
	var tempTemplate = handlebars.compile(source);
	
	var UploadSource = $('#upload-template').html();
	var UploadTemplate = handlebars.compile(UploadSource);

	sessionStorage.setItem("fpath", "");
	
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
		},		
		cbCamera: function (data) {
			// type, code, msg, res
			var obj = miaps.parse(data);
			if(obj.res == '')	{
				return;
			}
			if (typeof obj == 'object') {
				console.log(JSON.stringify(obj).replace(/,"/g, ',\n"')); 
			} else if (typeof obj == 'string') {
				console.log(obj);
			}			
			
			sessionStorage.setItem("fpath", obj.res);
			changeFile(obj.res);
		},		
		cbGallery: function (data) {			
			var obj = miaps.parse(data);
			if(obj.res == '')	{
				return;
			}
			if (typeof obj == 'object') {
				console.log(JSON.stringify(obj).replace(/,"/g, ',\n"')); 
			} else if (typeof obj == 'string') {
				console.log(obj);
			}			
			sessionStorage.setItem("fpath", obj.res);
			changeFile(obj.res);
		},
		cbFileUpload: function(data) {
			// http://miaps.thinkm.co.kr/miaps6beta/minkSvc?command=filedownload&DOWN_FILE_PATH=URL인코딩파일전체경로&VIEW_MODE=webView
			var obj = miaps.parse(data);
			if (typeof obj == 'object') {
				if (obj.code != "200") {
					console.log(obj);
				} else {		
					console.log(obj);			
					var filedownpath = '';
					// 현재 ios와 안드로이드 리턴값이 다름 - 수정예정
					if (miaps.isIOS()) {
						arrpath = obj.res[0];
						filedownpath = arrpath.filename;
					} else if (miaps.isAndroid()) {						
						filedownpath = obj.res;
					}
  
					  // http://miaps.thinkm.co.kr/miaps6beta/minkSvc?command=filedownload&DOWN_FILE_PATH=URL인코딩파일전체경로&VIEW_MODE=webView
					  obj.path = `http://miaps.thinkm.co.kr/miaps6beta/minkSvc?command=filedownload&DOWN_FILE_PATH=${encodeURIComponent(filedownpath)}&VIEW_MODE=webView`;
					  
					  console.log(obj.path);
					  
					  var resobjdata = {datas: obj};
  
					  var parent = $("#upload-image");
					  parent.children("#_upload_display2").remove();
					  parent.children("#desc2").remove();
  
					  parent.append(UploadTemplate(resobjdata.datas));
				}				 
			} else if (typeof obj == 'string') {
				console.log(obj);
			}
		},
		cbUploadBase64: function(data)	{
		// upload - file_Base64 + text param		
			var obj = miaps.parse(data);
			p_base64img = obj.res.src;	
	
			miaps.cursor(null, "wait", true);
			miaps.miapsSvcSp(
			  "com.mink.connectors.hybridtest.file.FileMan",
			  "saveObject",
			  {p_base64:p_base64img },
			  "/minkSvc",
			  function (data) {
				var obj = miaps.parse(data);
				if (obj.code != "200") {
				  console.log(obj.msg);
				} else {
					var data = obj.msg;
					console.log(data);				

					// http://miaps.thinkm.co.kr/miaps6beta/minkSvc?command=filedownload&DOWN_FILE_PATH=URL인코딩파일전체경로&VIEW_MODE=webView
					obj.path = `http://miaps.thinkm.co.kr/miaps6beta/minkSvc?command=filedownload&DOWN_FILE_PATH=${encodeURIComponent(data)}&VIEW_MODE=webView`;
					
					console.log(obj.path);
					
					var resobjdata = {datas: obj};

					var parent = $("#upload-image");
					parent.children("#_upload_display2").remove();
					parent.children("#desc2").remove();

					parent.append(UploadTemplate(resobjdata.datas));
			  	}
				miaps.cursor(null, "default");
			  }
			);		
		}		
	};
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
	
	/*
	 * camera를 열고, 사진을 찍으면 이미지파일을 ${ResourceRoot}\\temp에 임시저장하고, 경로를 리턴한다.
	 */
	function runCamera() {
		var config = {
			type: "camera"
			,param: {
				path: "${ResourceRoot}\\temp",   // 임시저장 디렉토리
				resolution: "800" // 0(원본), 800,1200,2800...
			}
			,res: "C:\/workspace_kor\/com.miaps.server.5\/src\/main\/webapp\/samples2\/pages\/service\/dry_corn_640.jpg" // 앱에서는 사용안함. PC에서 테스트할 떄 결과로 받을 값.
			,callback: "_cb.cbCamera"
		};
		miaps.mobile(config, _cb.cbCamera);
	}
	
	/*
	 * gallery를 열고, 이미지를 선택하면 선택한 이미지파일을 ${ResourceRoot}\\temp에 임시저장하고, 경로를 리턴한다.
	 */
	function runGallery() {
		var config = {
			type: "gallery"
			,param: {
				path: "${ResourceRoot}\\temp",   // 임시저장 디렉토리				
			}
			,res: "C:\/workspace_kor\/com.miaps.server.5\/src\/main\/webapp\/samples2\/pages\/service\/dry_corn_640.jpg" // 앱에서는 사용안함. PC에서 테스트할 떄 결과로 받을 값.
			,callback: "_cb.cbGallery"
		};
		miaps.mobile(config, _cb.cbGallery);

	}
	
	// upload - default 사용안함(삭제)
	function uploadFile() {
		var f = sessionStorage.getItem("fpath");
		if (f == null || f == '') {
			alert("먼저 파일을 선택 해 주십시오.");
			return;
		}
		
		var config = {
			type: "fileupload",
			param: [
			        {path: sessionStorage.getItem("fpath")}
			],
			 callback: "_cb.cbFileUpload"
		};
		
		miaps.mobile(config, _cb.cbFileUpload);
	}
	
	// upload - file + text param
	function uploadFileAndParam() {
		var filePath = sessionStorage.getItem("fpath");
		if (filePath == null || filePath == '') {
			alert("먼저 파일을 선택 해 주십시오.");
			return;
		}
		
		var config = {
			type: "fileupload",
			param: {
				params: {
					// a: 1,
					// b: 2,
					// c: 3					
				},
				files:[
			        {path: filePath}
			    ],
			    pathname:'/minkSvc'
			},
			callback: "_cb.cbFileUpload"
		};
		
		miaps.mobile(config, _cb.cbFileUpload);
	}
	
	function btnUploadBase64 () {
		var filePath = sessionStorage.getItem("fpath");
		if (filePath == null || filePath == '') {
			alert("먼저 파일을 선택 해 주십시오.");
			return;
		}
		
		var config = {
				type: "filecontents",
				param: { 
					path: filePath
				},
				callback: "_cb.cbUploadBase64"
		}			
		miaps.mobile(config, _cb.cbUploadBase64);	
	}	
});