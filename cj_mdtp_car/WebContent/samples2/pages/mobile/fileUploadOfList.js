require(["jquery", 
         "underscore", 
         "handlebars", 
		 "miaps", 
         "bootstrap"
         ], function($, _, handlebars, miaps, _previewTemplate, _fileListTemplate) {

	var preview_src = $('#preview-template').html();
	var tempTemplate = handlebars.compile(preview_src);
	
	$(document).ready(function(){
		$("#btnUpload").on("click", uploadFile);
		$("#btnBase64Upload").on("click", uploadFileBase64);		
		$("#btnBack").on("click", function() {window.history.back();});
		
		$("#data").on('change', function(){  // 값이 변경되면
			if(window.FileReader){  // modern browser
				console.log($(this));
				var filename = $(this)[0].files[0].name;
				alert("window.FileReader: " + filename);
			} 
			else {  // old IE
				var filename = $(this).val().split('/').pop().split('\\').pop();  // 파일명만 추출
				alert("old IE: "+ filename);
			}
		    
			// 추출한 파일명 삽입
			$(this).siblings('.upload-name').val(filename);
		});
	
		$("#data").on('change', function(){
		    //var parent = $(this).parent();
		    var parent = $("#show-image");
		    parent.children("#_upload_display").remove();
		    parent.children("#desc").remove();
	
		    if(window.FileReader){
		    	var file = $(this)[0].files[0];
		        //image 파일만
		        if (!file.type.match(/image\//)) return;
		        
		        var reader = new FileReader();
		        
		        reader.onload = function(e){
		            file.src = e.target.result;	
		            parent.prepend(tempTemplate(file));
		        }
		        reader.readAsDataURL(file);
		    }
		});
	}); 
	
	function uploadFileBase64() {
		var _bdata = "p_base64=" + encodeURIComponent(document.getElementById("_preview").getAttribute("data-src"));
		//miaps.miapsSvc("com.mink.connectors.hybridtest.file.FileMan", "saveObject", "BASE64_UPLOAD", _bdata, "_cb.cbFileUpload", _cb.cbFileUpload);
		miaps.miapsSvcSp("com.mink.connectors.hybridtest.file.FileMan", 
				"saveObject", _bdata, function(data) {
					console.log(data);
					var obj = miaps.parse(data);
					
					if (typeof obj == 'object') {
						alert(JSON.stringify(obj).replace(/,"/g, ',\n"')); 
					} else if (typeof obj == 'string') {
						alert(obj);
					}
				});
	}
	
	// upload
	function uploadFile() {
		var config = {
			type: "fileupload",
			param: [
			        //{path: "E:\\workspace_kor\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp0\\wtpwebapps\\com.miaps.server.5\\hybrid2\\res\\yotusba.jpg"}
			        //,{path: "E:\\workspace_kor\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp0\\wtpwebapps\\com.miaps.server.5\\hybrid2\\res\\yotusba2.jpg"}
			        {path: "${ResourceRoot}\\res\\yotusba.jpg"}
			        ,{path: "${ResourceRoot}\\res\\yotusba2.jpg"}
			],
			callback: "_cb.cbFileUpload"
		};
		
		miaps.mobile(config, _cb.cbFileUpload);
	}
	
	/*
	function uploadFile() {
		var form = $('frmFile')[0];
	    var formData = new FormData(form); // jquery.form.min.js
		formData.append("fileObj", $("#data")[0].files[0]);
	   // formData.append("dir", "Z:\comehere");
	    
	    $.ajax({
	    	//url: 'http://miaps.thinkm.co.kr/miaps5/minkSvc',
			url: 'http://localhost:8080/miaps/minkSvc',
        	processData: false,
            contentType: false,
            data: formData,
            type: 'POST',
            timeout: 10000, //milliseconds
            //crossDomain: true, // HTTP 접근 제어 (CORS) 허용. 보안 상의 이유로, 브라우저들은 스크립트 내에서 초기화되는 cross-origin HTTP 요청을 제한합니다.
            xhrFields: {
                withCredentials: false
			},
            success: function(result, textStatus, jqXHR){
            	alert("success!! result =" + result + ", status =" + textStatus);
           		
           		// 파일 업로드 후 업무 커넥터 호출
           		//MiapsHybrid.miapsSvc("com.mink.connectors.test.HybridTest", "getList", "MIAPS-LIST-TEST", $("#searchFrm").serialize(), cbGetList);           		
			},
			error: function (jqXHR, textStatus, errorThrown) {
				alert("error!! jqXHR.status=" + jqXHR.status + ", jqXHR.message=" + jqXHR.responseText +  ", errorThrown =" + errorThrown + ", status =" + textStatus);
			}			
		});
	}
	*/
	
	/* ---- callback function ---- */
	var callback = {
		paste_id : 1,
		
		cbGetList : function (data) {
			
			miaps.cursor(null, 'default');
			
			console.log(data);
			var obj = miaps.parse(data);
			var out = [];
			var filelistTemplate;
			console.log(obj);
			
			$('#more').remove();
			
			if (obj != null) {
				
				if (obj.res != null && obj.res.length > 0) {
					
					var source = $('#filelist-template').html();
					filelistTemplate = handlebars.compile(source);
					
					for(var i = 0; i < obj.res.length; i++, _cb.paste_id++) {
						var dto = obj.res[i];
						
						dto.paste_id = _cb.paste_id;
						dto.fullpath = dto.fullpath.replace(/\\/g, '\\\\');
						$("#listUl").append(filelistTemplate(dto));
					}
					/* li개수가 전체 수보다 작으면 더보기를 표시한다. */
					var liCnt = $("li").length + obj.res.length;
					
					/* 붙여넣기 후 리스트 스크롤 */
					var idx = _cb.paste_id - 1;
					
					$('body,html').animate({
						scrollTop: $("#sc_"+ idx).offset().top
					}, 500);
					
				} else {
					alert(obj.msg);
				}
			}
		},
		changeFile: function (fullpath, filename) {
			console.log(fullpath + "\\" + filename);
			
			var config = {
					type: "filecontents",
					param: { 
						path: fullpath + "\\" + filename
					},
					callback: "_cb.cbRedraw"
			}
			
			if (filename.lastIndexOf(".txt") > -1) {
				miaps.mobile(config, _cb.cbFileUpload);	
			} else {
				miaps.mobile(config, _cb.cbRedraw);	
			}
		},
		cbRedraw: function(data) {
			console.log(data);
			
			var parent = $("#show-image");
		    parent.children("#_upload_display").remove();
		    parent.children("#desc").remove();
		    
		    var obj = miaps.parse(data);
		    
            parent.prepend(tempTemplate(obj.res));
			
		},
		cbFileUpload: function (data) {
			console.log(data);
			var obj = miaps.parse(data);
			
			if (typeof obj == 'object') {
				alert(JSON.stringify(obj).replace(/,"/g, ',\n"')); 
			} else if (typeof obj == 'string') {
				alert(obj);
			}
		}		
	};
	window._cb = callback;
	
	//목록검색	
	var config = {
		type: "FILELIST",
		param: {
			//path: "C:\\Users\\thinkm\\Pictures\\movecut"
			path: "${ResourceRoot}\\res"
		},
		callback: "_cb.cbGetList"
	};
	miaps.mobile(config, _cb.cbGetList);
});