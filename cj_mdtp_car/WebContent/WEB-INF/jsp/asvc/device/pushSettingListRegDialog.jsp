<%-- 푸시세팅 리스트 등록 다이얼로그 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="false"%>

<!-- 푸시 셋팅 -->
<div id="pushSettingListRegDialog" title="<mink:message code='mink.web.text.push.regist.modify'/>" class="dlgStyle">
	<div class="miaps-popup-top-buttons" style="border-bottom: 0px;">
		&nbsp;
		<span><button id="btnPushSettingSave" class='btn-dash' onclick="javascript:pushInfoInsert();"><mink:message code="mink.web.text.save"/></button></span>
		<span><button id="btnPushSettingModi" class='btn-dash' onclick="javascript:pushInfoUpdate();"><mink:message code="mink.web.text.modify"/></button></span>
		<span><button class='btn-dash' onclick="javascript:$('#pushSettingListRegDialog').dialog('close');"><mink:message code="mink.web.text.cancel"/></button></span>
	</div>
	<form id="pushSettingRegFrm" name="pushSettingRegFrm" method="post" onSubmit="return false;">

		<table id="pushRegTb" border="0" cellspacing="0" cellpadding="0" width="100%" class="insertTb">
			<colgroup>
				<col width="25%" />
				<col width="75%" />
			</colgroup>
			<tr>
				<th><mink:message code="mink.web.text.push.taskname"/></th>
				<td>
					<select id="pushTaskList" name="pushTaskList">
					</select>
				</td>
			</tr>
			<tr>
				<th><mink:message code="mink.web.text.push.status"/></th>
				<td>
					<input type="radio" id="pushY" name="pushYn" value="Y" checked="checked" /><label for="pushY"><mink:message code="mink.web.text.receive"/></label>
					<input type="radio" id="pushN" name="pushYn" value="N" /><label for="pushN"><mink:message code="mink.web.text.receive"/></label>
				</td>
			</tr>
			<tr>
				<th><mink:message code="mink.web.text.push.token"/></th>
				<td><input type="text" id="pushToken" name="pushToken"/></td>
			</tr>
			<tr>
				<th><mink:message code="mink.web.text.push.servicetype"/></th>
				<td>
					<select id="pushService" name="pushService">
						<option value="apns">APNS</option>
						<option value="gcm">GCM</option>
					</select>
				</td>
			</tr>
		</table>
	</form>
</div>

<script type="text/javascript">
//푸시 정보 등록 다이얼로그 열기, 푸시 업무명
function openPushSettingListRegDialog() {

	//function pushInfoInsert()
	$('#btnPushSettingModi').hide();
	$('#btnPushSettingSave').show();
	
	$("#pushSettingListRegDialog").dialog("open");
	
	ajaxComm('deviceSelectPushTaskList.miaps?', searchFrm2, function(data){
		var resultList = data.pushTaskList;
		var selectId = document.getElementById("pushTaskList");
		var pushTokenId = document.getElementById("pushToken");
		var pushList = "";
		
		if(resultList.length > 0){
			for(var i = 0; i < resultList.length; i++) {
				var obj = resultList[i];
				
				pushList += "<option value=" + obj.task_id + ">" + obj.task_nm + "</option>";
			}
		} 
		else {
			pushList = "<option value='noValue'>" + "<mink:message code='mink.web.text.push.message1'/>" + "</option>";
		}
		
		selectId.innerHTML = pushList;
		pushTokenId.value = "";
		
			if($('#pushTaskList > option').val() == "noValue") {
		        $("#btnPushSettingSave").hide();
		        
			} else {
		        $("#btnPushSettingSave").show();
			}
	});
}

//푸시 정보 등록 저장 버튼
function pushInfoInsert() {
	var deviceId = $("input:text[name='deviceId']").val();							//	deviceID
	var taskId = $('#pushTaskList option:selected').val();
	var pushTask = $('#pushTaskList option:selected').text();
	var pushYn = $("input:radio[name='pushYn']:checked").val();						//	푸시 여부 값
	var pushToken = $("input:text[name='pushToken']").val();						//	푸시 토큰 값
	var serviceType = $('#pushService option:selected').val();
	var userNo = $("input:hidden[name='assignUserNo']").val();						//	사용자 NO
	
	var params = {
			"deviceId" : deviceId, 
			"taskId" : taskId,
			"pushYn" : pushYn,
			"pushToken" : pushToken,
			"serviceType" : serviceType,
			"userNo" : userNo
	}
	$.ajax({
		url : "devicePushTaskInsert.miaps?",
		data : params,
		success : function() {
			$("#pushSettingListRegDialog").dialog("close");
			goPushSettingList('1');
		}
	});
}

function pushInfoUpdate() {
	var deviceId = $("input:text[name='deviceId']").val();
	var taskId = $("select[name='pushTaskList']").val();
	var pushYn = $("input:radio[name='pushYn']:checked").val();
	var pushToken = $("input:text[name='pushToken']").val();
	var serviceTp = $("select[name='pushService']").val();
	var userNo = $("input:hidden[name='assignUserNo']").val();
	
	var params = {
			"deviceId"	: deviceId,
			"taskId"	: taskId,
			"pushYn"	: pushYn,
			"pushToken"	: pushToken,
			"serviceTp"	: serviceTp,
			"userNo"	: userNo
	}

	$.ajax({
		url : "devicePushTaskUpdate.miaps?",
		data : params,
		success : function() {
			$("#pushSettingListRegDialog").dialog("close");
			goPushSettingList('1');
		}
	});
	
}

//	푸시 정보 등록 다이얼로그
$("#pushSettingListRegDialog").dialog({
	dialogClass : 'pushSettingListDialogClass',
	autoOpen: false,
	resizable: false,
	width: '600px',
	modal: true,
	// add a close listener to prevent adding multiple divs to the document
	close: function(event, ui) {
	     // remove div with all data and events
		$(this).dialog( "close" );
	}
});
</script>