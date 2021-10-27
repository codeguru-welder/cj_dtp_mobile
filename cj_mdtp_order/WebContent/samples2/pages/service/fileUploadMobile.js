require(["jquery", 
         "underscore",
         "handlebars",
         "miaps", 
         "bootstrap"
         ], function($, _, handlebars, miaps) {

	$("#btnCamera").on("click", runCamera);
	$("#btnGallery").on("click", runGallery);
	//$("#btnUpload").on("click", uploadFile);
	$("#btnUpload").on("click", uploadFileAndParam);
	$("#btnBack").on("click", function() {window.history.back();});
	
	var source = $('#display-template').html();
	var tempTemplate = handlebars.compile(source);
	
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
		    obj.res.path = sessionStorage.getItem("fpath");
		    parent.append(tempTemplate(obj.res));            
		},		
		cbCamera: function (data) {
			// type, code, msg, res
			var obj = miaps.parse(data);
			if (typeof obj == 'object') {
				alert(JSON.stringify(obj).replace(/,"/g, ',\n"')); 
			} else if (typeof obj == 'string') {
				alert(obj);
			}			
			
			sessionStorage.setItem("fpath", obj.res);
			changeFile(obj.res);
		},		
		cbGallery: function (data) {			
			var obj = miaps.parse(data);			
			if (typeof obj == 'object') {
				alert(JSON.stringify(obj).replace(/,"/g, ',\n"')); 
			} else if (typeof obj == 'string') {
				alert(obj);
			}			
			sessionStorage.setItem("fpath", obj.res);
			changeFile(obj.res);
		},
		cbFileUpload: function(data) {
			var obj = miaps.parse(data);
			if (typeof obj == 'object') {
				alert(JSON.stringify(obj).replace(/,"/g, ',\n"')); 
			} else if (typeof obj == 'string') {
				alert(obj);
			}
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
			//,res: "http://localhost:8080/samples2/pages/service/dry_corn_640.jpg"
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
	
	// upload - default
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
		var f = sessionStorage.getItem("fpath");
		if (f == null || f == '') {
			alert("먼저 파일을 선택 해 주십시오.");
			return;
		}
		
		var config = {
			type: "fileupload",
			param: {
				params: {
					a: 1,
					b: 2,
					c: 3					
				},
				files:[
			        {path: sessionStorage.getItem("fpath")}
			    ],
			    pathname:'/minkSvc'
			},
			callback: "_cb.cbFileUpload"
		};
		
		miaps.mobile(config, _cb.cbFileUpload);
	}
	
	
});