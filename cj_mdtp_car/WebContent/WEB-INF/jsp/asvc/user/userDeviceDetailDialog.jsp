<%-- 사용자 메일계정 등록 다이얼로그 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div id="userDeviceDetailDialog" title="<mink:message code='mink.web.text.info.userdevicedetail'/>" class="dlgStyle">
<div class="miaps-popup-top-buttons">
	&nbsp;
	<span><button class='btn-dash' onclick="javascript:$('#userDeviceDetailDialog').dialog('close');"><mink:message code="mink.web.text.close"/></button></span>
</div>

<table class="detailTb" border="0" cellspacing="0" cellpadding="0" width="100%">
	<colgroup>
		<col width="12%" />
		<col width="38%" />
		<col width="12%" />
		<col width="38%" />
	</colgroup>
	<tbody>
	<tr>
		<th><mink:message code="mink.web.text.username"/><br/>(<mink:message code="mink.web.text.userid"/>)</th>
		<td id="userDeviceDetail_userInfo"></td>
		<th><mink:message code="mink.web.text.regist.devicedate"/></th>
		<td id="userDeviceDetail_lastAccessDt"></td>
	</tr>
	<tr>
		<th><mink:message code="mink.web.text.deviceid"/></th>
		<td id="userDeviceDetail_deviceId"></td>
		<th><mink:message code="mink.web.text.devicetype"/></th>
		<td id="userDeviceDetail_deviceTp"></td>
	</tr>
	<tr>
		<th><mink:message code="mink.text.modelnumber"/></th>
		<td id="userDeviceDetail_modelNo"></td>
		<th><mink:message code="mink.web.text.ostype"/></th>
		<td id="userDeviceDetail_osTp"></td>
	</tr>
	<tr>
		<th><mink:message code="mink.web.text.osname"/></th>
		<td id="userDeviceDetail_osNm"></td>
		<th><mink:message code="mink.web.text.osversion"/></th>
		<td id="userDeviceDetail_osVersion"></td>
	</tr>
	<tr>
		<th>WiFi MAC<br/><mink:message code="mink.web.text.address"/></th>
		<td id="userDeviceDetail_wifiMacAddr"></td>
		<th>Bluetooth MAC<br/><mink:message code="mink.web.text.address"/></th>
		<td id="userDeviceDetail_btMacAddr"></td>
	</tr>
	<tr>
	<th><mink:message code="mink.web.text.pnumber"/></th>
	<td id="userDeviceDetail_phoneNo"></td>
	<th><mink:message code="mink.web.text.status.device"/></th>
	<td>
		<input type="radio" name="activeSt" value="${DEVICE_ST_ACTIVE}" id="userDeviceDetail_activeSt_Y" onchange="updateUserDeviceActiveSt(this)" /><label for="userDeviceDetail_activeSt_Y" ><mink:message code="mink.web.text.using"/></label>
		<input type="radio" name="activeSt" value="${DEVICE_ST_SUSPENDED}" id="userDeviceDetail_activeSt_N" onchange="updateUserDeviceActiveSt(this)" /><label for="userDeviceDetail_activeSt_N" ><mink:message code="mink.web.text.stoped"/></label>
		<input type="radio" name="activeSt" value="${DEVICE_ST_DISUSED}" id="userDeviceDetail_activeSt_D" onchange="updateUserDeviceActiveSt(this)" /><label for="userDeviceDetail_activeSt_D" ><mink:message code="mink.web.text.disposal"/></label>
		<span id="userDeviceDetail_activeSt_pre" style="display: none;"></span>
		</td>
	</tr>
	<tr>
		<th><mink:message code="mink.web.text.regdate"/></th>
		<td id="userDeviceDetail_regDt"></td>
		<th><mink:message code="mink.web.text.moddate"/></th>
		<td id="userDeviceDetail_updDt"></td>
	</tr>
	</tbody>
	<tfoot></tfoot>
</table>
</div>

<script type="text/javascript">
// 사용자 장치 상세정보 열기
function openUserDeviceDetailDialog($row) {
	var lastAccessDt = $row.data("lastAccessDt");
	var deviceId = $row.data("deviceId");
	var deviceTp = $row.data("deviceTp");
	var modelNo = $row.data("modelNo");
	var osTp = $row.data("osTp");
	var osNm = $row.data("osNm");
	var osVersion = $row.data("osVersion");
	var phoneNo = $row.data("phoneNo");
	var wifiMacAddr = $row.data("wifiMacAddr");
	var btMacAddr = $row.data("btMacAddr");
	var activeSt = $row.data("activeSt");
	var deleteYn = $row.data("deleteYn");
	var regNm = $row.data("regNm");
	var regDt = $row.data("regDt");
	var updNo = $row.data("updNo");
	var updDt = $row.data("updDt");
	var userNm = $("#userDetailFrm").find(":input[name='userNmOri']").val();
	var userId = $("#userDetailFrm").find(":input[name='userId']").val();
	var userInfo = userNm + setBracket(userId);

	$("#userDeviceDetail_userInfo").html(userInfo);
	$("#userDeviceDetail_lastAccessDt").html(lastAccessDt);
	$("#userDeviceDetail_deviceId").html(deviceId);
	$("#userDeviceDetail_deviceTp").html(deviceTp);
	$("#userDeviceDetail_modelNo").html(modelNo);
	$("#userDeviceDetail_osTp").html(osTp);
	$("#userDeviceDetail_osNm").html(osNm);
	$("#userDeviceDetail_osVersion").html(osVersion);
	$("#userDeviceDetail_phoneNo").html(phoneNo);
	$("#userDeviceDetail_wifiMacAddr").html(wifiMacAddr);
	$("#userDeviceDetail_btMacAddr").html(btMacAddr);
	//$("#userDeviceDetail_activeSt").html(activeSt);
	$("#userDeviceDetail_deleteYn").html(deleteYn);
	$("#userDeviceDetail_regNm").html(regNm);
	$("#userDeviceDetail_regDt").html(getDateTimeFmt(regDt));
	$("#userDeviceDetail_updNo").html(updNo);
	$("#userDeviceDetail_updDt").html(getDateTimeFmt(updDt));

	if (activeSt == "Y") $("#userDeviceDetail_activeSt_Y").get(0).checked = true; // 사용중
	else if (activeSt == "N") $("#userDeviceDetail_activeSt_N").get(0).checked = true; // 중지
	else if (activeSt == "D") $("#userDeviceDetail_activeSt_D").get(0).checked = true; // 폐기
	$("#userDeviceDetail_activeSt_pre").html(activeSt);

	$("#userDeviceDetailDialog").dialog( "open" );	
}

// 사용자 장치상태 변경
function updateUserDeviceActiveSt(o) {
	var userNo = $("#userDetailFrm").find(":input[name='userNo']").val();
	var deviceId = $.trim($("#userDeviceDetail_deviceId").text());
	var activeSt = $(o).val();

	var msg = "<mink:message code='mink.web.text.is.use.device'/>"; // 사용중(Y)
	if (activeSt == "N") msg = "<mink:message code='mink.web.text.is.stop.device'/>"; // 중지(N)
	else if (activeSt == "D") msg = "<mink:message code='mink.web.text.is.disposal.device'/>"; // 폐기(D)
	if(confirm(msg)) {
		$.post('userDeviceActiveStUpdate.miaps?', {userNo: userNo, deviceId: deviceId, activeSt: activeSt}, function(data){
			resultMsg(data.msg);
			if (data.result > 0) {
				var activeStInfo = "<mink:message code='mink.web.text.using'/>";
				if (activeSt == "N") activeStInfo = "<mink:message code='mink.web.text.stoped'/>";
				else if (activeSt == "D") activeStInfo = "<mink:message code='mink.web.text.disposal'/>";
				$("#td_activeSt_" + deviceId).html(activeStInfo); // 목록 정보수정
				$("#tr_userDeviceList_" + deviceId).data("activeSt", activeSt); // tr data수정
			}
		}, 'json');
	} else {
		var pre = $.trim($("#userDeviceDetail_activeSt_pre").text());
		$("#userDeviceDetail_activeSt_" + pre).get(0).checked = true;
		return;
	}
}

$(function(){
	$("#userDeviceDetailDialog").dialog({
		autoOpen: false,
	    resizable: false,
	    width: 'auto',
	    modal: true,
		// add a close listener to prevent adding multiple divs to the document
	    close: function(event, ui) {
	        // remove div with all data and events
	        $(this).dialog( "close" );
	    }
	});
});

</script>