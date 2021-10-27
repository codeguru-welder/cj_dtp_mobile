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
		miapsPage.back("index");
	});

	$("#btnCamera").on("click", runCamera);		
	  
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
				console.log(JSON.stringify(obj).replace(/,"/g, ',\n"')); 
			} else if (typeof obj == 'string') {
				console.log(obj);
			}			
			
			sessionStorage.setItem("fpath", obj.res);
			changeFile(obj.res);
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
	
});