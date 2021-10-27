<%--푸시 모니터링 -> 리스트 클릭  상세 다이얼로그 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="false"%>

<div id="pushLogListViewDialog" title="<mink:message code='mink.web.text.push.monitoringdetail'/>" class="dlgStyle">
	<div class="miaps-popup-top-buttons" style="border-bottom: 0px;">
		&nbsp;
		<span><button class='btn-dash' onclick="javascript:$('#pushLogListViewDialog').dialog('close');"><mink:message code="mink.web.text.close"/></button></span>
	</div>
	<!-- 상세화면 -->
	<div id="detailDiv">
		<form id="detailFrm" name="detailFrm" method="post"  onSubmit="return false;">
			<!-- <input type="hidden" name="updNo" value="${loginUser.userNo}""/> -->	<!-- 로그인한 사용자 -->
			<!-- <input type="hidden" name="pushId" value=""/> -->	<!-- key -->
			<!-- <input type="hidden" name="deviceId" value=""/> -->	<!-- key2 -->
			<input type="hidden" name="pushId" />
			<input type="hidden" name="deviceId" />
			
			<table class="detailTb" border="0" cellspacing="0" cellpadding="0" width="100%">
				<colgroup>
					<col width="15%" />
					<col width="35%" />
					<col width="15%" />
					<col width="35%" />
				</colgroup>
				<tbody>
					<tr>
						<th><mink:message code="mink.web.text.pushid"/></th>
						<td id="pushIdTd" class="onlyTextTd"></td>
						<th><mink:message code="mink.web.text.push.taskname"/></th>
						<td id="pushTaskTd" class="onlyTextTd"></td>
					</tr>
					<tr>
						<th><mink:message code="mink.web.text.user"/></th>
						<td id="userNmTd" class="onlyTextTd"></td>
						<th><mink:message code="mink.web.text.deviceid"/></th>
						<td id="deviceIdTd" class="onlyTextTd"></td>
					</tr>
					<tr>
						<th><mink:message code="mink.web.text.push.messagetype"/></th>
						<td id="msgTpTd" class="onlyTextTd"></td>
						<th><mink:message code="mink.web.text.push.imageurl"/></th>
						<td id="imgUrlTd" class="onlyTextTd"></td>
					</tr>
					<tr>
						<th><mink:message code="mink.web.text.pushmessage2"/></th>
						<td id="pushMsgTd" colspan="3" class="onlyTextTd"></td>
					</tr>
					<tr>
						<th><mink:message code="mink.web.text.count.retry"/></th>
						<td id="retriesTd" colspan="3" class="onlyTextTd"></td>
					</tr>
					<tr>
						<th><mink:message code="mink.web.text.push.allsend.finaldate"/></th>
						<td id="lastSendDtTd" class="onlyTextTd"></td>
						<th><mink:message code="mink.web.text.push.send.finalresult"/></th>
						<td id="lastResultTd" class="onlyTextTd"></td>
					</tr>
					<tr>
						<th><mink:message code="mink.web.text.push.resultdetail"/></th>
						<td id="resultMsgTd" colspan="3" class="onlyTextTd"></td>
					</tr>
					<tr>
						<th><mink:message code="mink.web.text.status.receive.device"/></th>
						<td id="deviceRcvYnTd" class="onlyTextTd"></td>
						<th><mink:message code="mink.web.text.status.read"/></th>
						<td id="appRcvYnTd" class="onlyTextTd"></td>
					</tr>
				</tbody>
				<tfoot></tfoot>
			</table>
		</form>
	</div>
</div>

<script type="text/javascript">
/* pusLogListViewDialog.jsp 팝업창 */
$("#pushLogListViewDialog").dialog({
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
</script>	