<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<html>
<head>
<title>test-ajax</title>
<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<script  src="http://code.jquery.com/jquery-latest.min.js"></script>
    <script type="text/javaScript">
    
    var objErr;
    var objData;
    function callAjax() {

    	var serverUrl = $("#serverUrl").val();
    	alert("START CALL! => "+serverUrl);
		$.ajax({
		    url: serverUrl, //request 보낼 서버의 경로
		    type:'get', // 메소드(get, post, put 등)
		    data:{'id':'admin'}, //보낼 데이터
		    success: function(data) {
		        //서버로부터 정상적으로 응답이 왔을 때 실행
		        objData = data;
		        alert("Success data="+data);
		    },
		    error: function(err) {
		        //서버로부터 응답이 정상적으로 처리되지 못햇을 때 실행
		        objErr = err;
		    	alert("error="+err);
		    }
		});
    }
    
    $(document).ready(function() {
		$('#callAjaxBtn').click(function() { callAjax(); });
	});
    
    function goForm(){
    	alert("1");
	    $('#myForm' ).submit(function( event ) {
	    	  event.preventDefault();
	    	  var url = $(this).attr( "action" );
	    	  var data = $(this).serialize();
	    	  
	    	  $.post( url, data )
	    	  .done(function( data ) {
	    	    console.log('--->', data.userId, data.pwd);
	    	  });
	    });
    
	</script>
</head>

<body onload="javascript:goForm();">
<h1>AJAX Service Test</h1>
<br/><br/>

URL : <input type="text" id="serverUrl" action="/mdtpcar/fileUplaodCamera.mdtp" style="width:300px;"><br/><br/><br/>
	<input type="button" id="callAjaxBtn" value="Call Ajax">
	<form id="myForm" action="/mdtpcar/test-ajax.mdtp"> 
		<input type="hidden" name="userId" value=${userId}>
		<input type="hidden" name="pwd" value=${pwd}>
	</form>
</body>

</html>
