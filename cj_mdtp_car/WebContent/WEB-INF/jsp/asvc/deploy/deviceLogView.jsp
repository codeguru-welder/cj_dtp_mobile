<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<html>
<head>
    <link rel="STYLESHEET" type="text/css" href="${contextPath}/css/admincenter.css">
	<link rel="STYLESHEET" type="text/css" href="${contextPath}/css/include.css">
	<link rel="STYLESHEET" type="text/css" href="${contextPath}/css/layout.css">
	        
	<link rel="STYLESHEET" type="text/css" href="${contextPath}/css/layout.deploy.css">
	
	<script type="text/javascript" src="${contextPath}/js/jquery/jquery-1.10.2.js"></script>
		        
    <title>Device Log console</title>
    <script>
    	var connectedIdList = [];
    	var disconnectedIdList = [];
    	var maxEleCnt = 5000;
    	var host = location.host;
    	//var path = location.pathname;
    	//var context = path.replace('/asvc/deploy/deviceLogView.miaps', '');
    	
    	$(document).ready(function(){
    		$("#id-list").change(function(){
            	for (i = 0; i < connectedIdList.length; i++) {
            		if (connectedIdList[i] != this.value) {
            			$("." + connectedIdList[i]).hide();
            		}
            	}
            	for (i = 0; i < disconnectedIdList.length; i++) {
            		if (disconnectedIdList[i] != this.value) {
            			$("." + disconnectedIdList[i]).hide();
            		}
            	}
            	$("." + this.value).show();
            });
    	});
    	
        var ws = new WebSocket('ws://' + host + '${contextPath}' + '/wslog/WsDeviceLog?console'); 
        ws.onopen = function(){
        	console.log('websocket open..');
        	
        	$("#id-pc-connected").empty();
        	$("#id-pc-connected").css("color", "green");
        	$("#id-pc-connected").html("conneted");        	
        };
        ws.onmessage = function(message){
        	var parent = document.getElementById("device-log");
        	
        	// check element count
        	var eleCnt = parent.childElementCount / 2;
        	
        	// delete top element
        	if (eleCnt >= maxEleCnt) {
        		parent.removeChild(parent.childNodes[0]);
        		parent.removeChild(parent.childNodes[0]);
        	}
        	
        	//console.log(message.data);
        	
        	var msgObj = JSON.parse(message.data);
        	
        	<%-- add id --%>
        	if (connectedIdList.indexOf(msgObj.id) == -1) {
        		connectedIdList.push(msgObj.id);
        		<%-- add selectbox id --%>
                addIdList();
                addIdConnectedStatus();
        	} else {
        		<%-- 연결이 종료된 메시지가 오면 selectbox에서 제거한다. --%>
        		if (msgObj.msg.substring(0, 16) == 'closed sessionId') {
        			console.log("yes");
        			removeIdList(msgObj.id);
        		}
        	}
        	
        	<%-- add log, 현재 선택된 ID일 경우 바로 표시하고, 아닐 경우 display:none한다. --%>
        	var eP = document.createElement('p');
        	eP.className = msgObj.id;
        	eP.innerHTML = msgObj.msg;
        	
            var selectedId = $("#id-list option:selected").val();
        	if (selectedId != msgObj.id) {
        		eP.style.cssText = "display:none;";
        	}
            
            parent.appendChild(eP);
            
            <%-- 자동 스크롤 --%>
            var scrollingElement = (document.scrollingElement || document.body);
            scrollingElement.scrollTop = scrollingElement.scrollHeight;
        };
        function postToServer(){
            ws.send(document.getElementById("msg").value);
            document.getElementById("msg").value = "";
        }
        function addIdList() {
        	$("#id-list").empty();
        	var _option = '';
        	for (i = 0; i < connectedIdList.length; i++) {
        		_option += '<option class="rm_'+ connectedIdList[i] +'" key="_'+ i +'">' + connectedIdList[i] + '</option>\n';	
        		console.log('addIdList:' + connectedIdList[i]);
        	}
        	for (i = 0; i < disconnectedIdList.length; i++) {
        		_option += '<option class="rm_'+ disconnectedIdList[i] +'" key="_'+ i +'">' + disconnectedIdList[i] + '</option>\n';	
        		console.log('add Backup List:' + disconnectedIdList[i]);
        	}
        	$('#id-list').html(_option);
        }
        
        function addIdConnectedStatus() {
        	$("#id-status").empty();
        	var _span = '';
        	for (i = 0; i < connectedIdList.length; i++) {
        		var tmp = connectedIdList[i];
        		if (i > 0) {
        			tmp = ',' + tmp;
        		}
        		_span += '<span class="rm_'+ connectedIdList[i] +'">' + tmp + '</span>\n';	
        		console.log('addIdConnectedStatus:' + connectedIdList[i]);
        	}
        	$('#id-status').html(_span);      	
        }
       
        function removeIdList(id) {
        	console.log("remove id:" + id);
        	
			$("#id-status").remove(".rm_" + id);
			
        	<%-- connectedIdList에서 제거 --%>
        	connectedIdList.splice($.inArray(id, connectedIdList), 1);
        	
        	<%-- disconnectedIdList에 추가 (백업리스트) --%>
        	disconnectedIdList.push(id);
        }
        
        <%-- Button Event --%>
        function closeConnect(){
        	console.log("websocket close..");
            ws.close();
            
            $("#id-pc-connected").empty();
            $("#id-pc-connected").css("color", "red");
        	$("#id-pc-connected").html("disconneted");
        }
        
        function clearLog() {
        	$("#device-log").empty();
        }
        
        function refresh() {
        	 addIdList();
             addIdConnectedStatus();
        }
    </script>
</head>
<body style="font-size:12px;">
	<!-- 본문 -->
	<div id="deploy-container">
		<div id="deploy-header">
    		<div class="topContent">
				<div class="logoContent">
					<!-- <img src="${contextURL}/asvc/images/hybrid_deploy_logo.png" border="0"> -->
					<span style="font: normal bold 30px Consoles;">MiAPS Hybrid</span>&nbsp;
					<span style="font: italic 20px Consoles;">Device Log Console</span>&nbsp;
					<span style="font: italic 12px Consoles;" id="id-pc-connected"></span>
					<div style="float: right; padding: 20px 15px 0 0;">icon by <a target="_blank" href="https://icons8.com">Icons8</a></div>
				</div>
			</div>
 		</div>
 		<div id="deploy-top-buttons">
			<div style="float: left;">
				<span><button class='btn-dash' onclick="javascript:closeConnect()"><img src='${contextPath}/asvc/images/settings-40.png' width='20px' height='20px' alt='setting' style="vertical-align:middle;">&nbsp;Close Socket</button></span>
				<span><button class='btn-dash' onclick="javascript:clearLog()"><img src='${contextPath}/asvc/images/trash-40.png' width='20px' height='20px' alt='setting' style="vertical-align:middle;">&nbsp;Clear Log</button></span>
				<span><button class='btn-dash' onclick="javascript:refresh()"><img src='${contextPath}/asvc/images/replay-48.png' width='22px' height='22px' alt='setting' style="vertical-align:middle;">&nbsp;Refresh</button></span>
			</div>
			<div style="float: right; padding: 6px 15px 0 0;">
				<span>Select ID : <select id="id-list"></select></span>
				<span>Connected ID : <span id="id-status"></span></span>				
			</div>
			<div style="float:none;"></div>
		</div>	
		
		<div id="deploy-content" style="top: 115px;">
			<div id="device-log"></div><br/>
       <%--
		    전송 테스트: <input id="msg" type="text" />
      		<button type="submit" id="sendButton" onClick="postToServer()">Send</button>
       --%>
		</div>			
	</div>
	<a target="_blank" href="https://icons8.com/icons/set/empty-trash">Empty Trash icon</a> icon by <a target="_blank" href="https://icons8.com">Icons8</a>
</body>
</html>

<%-- 
* 보안에 대한 고려 사항
웹소켓은 혼합된 연결 환경에서 이용되어서는안됩니다. 
예를들어 HTTPS를 이용해 로드된 페이지에서 non-secure 웹소켓 연결을 수립하는것(또는 반대) 처럼 말입니다. 
몇몇 브라우저들은 이를 강제로 금지하고 있습니다. 
파이어폭스 버전 8이상도 이를 금지합니다.
--%>