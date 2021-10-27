<%-- 상세 다이얼로그 > 푸시ID 클릭 > 푸시 이력(_his) 상세 다이얼로그 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div id="pushLog_hisDialog" title="<mink:message code='mink.web.text.push.historydetail'/>" class="dlgStyle">
	<div class="miaps-popup-top-buttons" style="border-bottom: 0px;">
		&nbsp;
		<span><button class='btn-dash' onclick="javascript:$('#pushLog_hisDialog').dialog('close');"><mink:message code="mink.web.text.close"/></button></span>
	</div>
	<!-- 상세화면 -->
	<div id="container_appRole"> <!-- menuPushTargetDiv -->
		<ul class="tabs_appRole">
			<li class="active" rel="tab1"><mink:message code="mink.web.text.targetdetail"/></li>
			<li rel="tab2"><mink:message code="mink.web.text.push.mesagedetail"/></li>
		</ul>

		<div class="tab_container_appRole">
			<div id="tab1" class="tab_content_appRole">
				<div><h3><span><mink:message code="mink.web.text.user.group"/></span></h3></div>
				<div>
					<table class="read_listTb" border="0" cellspacing="0" cellpadding="0" width="100%">
						<thead>
							<tr>
								<td><mink:message code="mink.web.text.user.groupname"/></td><td><mink:message code="mink.web.text.user.groupid"/></td><td><mink:message code="mink.web.text.include.undergroup"/></td>
							</tr>
						</thead>
						<tbody id="pushLog_hisListTbodyUG">
						</tbody>
					</table>
				</div>

				<div><h3><span><mink:message code="mink.web.text.user"/></span></h3></div>
				<div>
					<table class="read_listTb" border="0" cellspacing="0" cellpadding="0" width="100%">
						<thead>
							<tr>
								<td><mink:message code="mink.web.text.username.id"/></td><td><mink:message code="mink.web.text.userno"/></td>
							</tr>
						</thead>
						<tbody id="pushLog_hisListTbodyUN">
						</tbody>
					</table>
				</div>

				<div><h3><span><mink:message code="mink.web.text.device"/></span></h3></div>
				<div>
					<table class="read_listTb" border="0" cellspacing="0" cellpadding="0" width="100%">
						<thead>
							<tr>
								<td><mink:message code="mink.web.text.username.id"/></td><td><mink:message code="mink.web.text.deviceid"/></td>
							</tr>
						</thead>
						<tbody id="pushLog_hisListTbodyDD">
						</tbody>
					</table>
				</div>

				<div><h3><span><mink:message code="mink.web.text.userid"/></span></h3></div>
				<div>
					<table class="read_listTb" border="0" cellspacing="0" cellpadding="0" width="100%">
						<thead>
							<tr>
								<td><mink:message code="mink.web.text.userid"/></td>
							</tr>
						</thead>
						<tbody id="pushLog_hisListTbodyUD">
						</tbody>
					</table>
				</div>
			</div>

			<div id="tab2" class="tab_content_appRole">
				<div>
					<table class="detailTb" border="0" cellspacing="0" cellpadding="0" width="100%">
						<colgroup>
							<col width="20%" />
							<col width="80%" />
						</colgroup>
						<tbody>
							<tr>
								<th><mink:message code="mink.web.text.taskname"/></th>
								<td><span id="taskIdPos_his"></span></td>
							</tr>
							<tr>
								<th><mink:message code="mink.web.text.apppackagename"/></th>
								<td><span id="packageNm_his"></span></td>
							</tr>
							<tr>
								<th><mink:message code="mink.web.text.status.regist"/></th>
								<td><span id="dataSt_his"></span></td>
							</tr>
							<tr>
								<th><mink:message code="mink.web.text.pushmessage2"/></th>
								<td><span id="pushMsg_his"></span></td>
							</tr>
							<c:if test='${pushType eq "PREMIUM"}'>
							<tr>
								<th><span><mink:message code="mink.web.text.push.messagetype"/></span></th>
								<td><span id="msgTp_his"></span></td>
							</tr>
							<tr>
								<th><span><mink:message code="mink.web.text.push.imageurl2"/></span></th>
								<td><span id="imgUrl_his"></span></td>
							</tr>
							</c:if>
							<tr>
								<th><mink:message code="mink.web.text.push.reserved.senddate"/></th>
								<td><span id="reservedDt_his"></span></td>
							</tr>
							<tr>
								<th><mink:message code="mink.web.text.push.start.senddate"/></th>
								<td><span id="sendStartDt_his"></span></td>
							</tr>
							<tr>
								<th><mink:message code="mink.web.text.push.end.senddate"/></th>
								<td><span id="sendEndDt_his"></span></td>
							</tr>
							<tr>
								<th><mink:message code="mink.web.text.push.resultcode"/></th>
								<td><span id="resultCd_his"></span></td>
							</tr>
							<tr>
								<th><mink:message code="mink.web.text.push.resultdetail"/></th>
								<td><span id="resultMsg_his"></span></td>
							</tr>
							<tr>
								<th><mink:message code="mink.web.text.register"/></th>
								<td><span id="regNm_his"></span></td>
							</tr>
							<tr>
								<th><mink:message code="mink.web.text.regdate"/></th>
								<td><span id="regDt_his"></span></td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
/* pushLog_hisDialog.jsp 팝업창 */
$("#pushLog_hisDialog").dialog({
	autoOpen: false,
  resizable: true,
  width: '750',
  modal: true,
	// add a close listener to prevent adding multiple divs to the document
  close: function(event, ui) {
      // remove div with all data and events
      $(this).dialog( "close" );
  }
});
</script>	