<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<html>
<head>
<title>MiAPS Hybrid FileUpload Sample</title>
<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<c:set var="protocol" value="http" />
<c:if test="<%=request.isSecure()%>">
<c:set var="protocol" value="https" />
</c:if>
<c:set var="searverName" value="${pageContext.request.serverName}" />
<c:set var="serverPort" value="${pageContext.request.serverPort}" />
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="contextURL" value="${contextPath}" />

<link rel="stylesheet" src="${contextPath}/cj/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" src="${contextPath}/cj/jquery/jquery-ui-1.12.1.css">

<script type="text/javascript" src="${contextPath}/cj/jquery/jquery.min.js"></script>
<script type="text/javascript" src="${contextPath}/cj/jquery/jquery.form.min.js"></script>
<script type="text/javascript" src="${contextPath}/cj/jquery/jquery-ui-1.12.1.js"></script>
<script type="text/javascript" src="${contextPath}/cj/bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript" src="${contextPath}/cj/template7/template7.min.js"></script>

</head>

<%
	String contextPath = request.getContextPath();
	out.println("@@@@@@@@@@@@@@@@@");
%>

<body>
<div class="container">
	<h2>FileUpload Sample - Camera</h2>
	<hr>
	<form id="frmFile" name="frmFile" method="post" enctype="multipart/form-data" onSubmit="return false;">
		<div class="filebox bs3-primary preview-image">
			<!-- <input id="data" type="file" class="upload-hidden" accept="image/*" capture="camera">  -->
			<input id="data" type="file" class="upload-hidden" accept="image/*">
		</div>
		<span id="show-image"></span>
		<br/>
		<div align="center"><button id="btnUpload" class="btn btn-default"><span class="glyphicon glyphicon-cloud-upload"></span> Upload</button></div>
	</form>
	
	<br/>
	<div style="text-align: center;">
		<button id="btnBack" class="btn btn-block btn-primary"><span class="glyphicon glyphicon-circle-arrow-left"></span> Back</button>
	</div>

	<hr>
	<div style="text-align: center;">
		<button id="btnSend" class="btn btn-block btn-primary"><span class="glyphicon glyphicon-send"></span> Ajax Send</button>
	</div>

	<br>
	<div id="id-req-result"></div>

	<hr>

	<div id="id-res-result"></div>

</div>

<script type="text/javascript">

$(document).ready(function(){
	// read template
	var templateSrc = $('#list-template').html();
	tempTemplate = Template7.compile(templateSrc);

	
	$("#btnUpload").on("click", uploadFile);
	$("#btnBack").on("click", function() {window.history.back();});
	
	$("#data").on('change', function(){  // 값이 변경되면
		if(window.FileReader){  // modern browser
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

// upload
function uploadFile() {
	var form = $('frmFile')[0];
    var formData = new FormData(form); // jquery.form.min.js
	formData.append("fileObj", $("#data")[0].files[0]);
    formData.append("testParam1", "testValue1"); // 추가 데이터
    formData.append("testParam2", "testValue2");	// 추가 데이터
    
    $.ajax({
    	url: location.origin + '/minkSvc',
    	processData: false,
        contentType: false,
        data: formData,
        type: 'POST',
        timeout: 10000, //milliseconds
        //crossDomain: true, // HTTP 접근 제어 (CORS) 허용. 보안 상의 이유로, 브라우저들은 스크립트 내에서 초기화되는 cross-origin HTTP 요청을 제한합니다.
        /*xhrFields: {
            withCredentials: false
		},*/
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

// ajax send test
$("#btnSend").on("click", function() {
	$.ajax({
		url: location.href.substring(0, location.href.lastIndexOf('/')) + '/ajaxTest.miaps', 
		async: true,
		type: 'post',
		data: '',
		dataType: 'text', // xml, json, script, html
		success: function(data, textStatus, request){		
			$("#id-req-result").html(data.replace(/\n/g, '<br>')); 
			$("#id-res-result").html(request.getAllResponseHeaders());   
		},
		 error: function (request, textStatus, errorThrown) {
			 $("#id-req-result").html('');
			$("#id-res-result").html(request.getAllResponseHeaders());    
		}
	});
});
</script>


<script type="text/template7" id="list-template">
	<div id="_upload_display" class="upload-display" style="float:left; margin: 10px 5px 0 0;">
		<div class="upload-thumb-wrap"><img src="{{src}}" class="img-thumbnail" width="304" height="236" id="_preview" data-src="{{src}}"></div>
	</div>
	<div id='desc' style='margin-top: 10px;'>
		<strong>Name:</strong>{{name}}<br/> 
		<strong>Size:</strong>{{size}}bytes<br/> 
		<strong>Type:</strong>{{type}}
	</div>
	<div style='clear: both;'></div>
</script>
</body>
</html>