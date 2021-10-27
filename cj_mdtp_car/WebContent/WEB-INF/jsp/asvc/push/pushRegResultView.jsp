<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="org.springframework.web.bind.annotation.SessionAttributes"%>
<%@ page import="com.thinkm.mink.commons.util.MinkConfig" %>
<%
	/*
	 * 어드민 푸시
	 * 푸시 등록 완료 화면 - (pushRegResultView.jsp)
	 * 
	 * @author chlee
	 * @since 2016.04.14
	 */
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<%@ include file="/WEB-INF/jsp/include/wsACommonInclude.jsp" %>
<%@ include file="/WEB-INF/jsp/include/wsACommonHeadScript.jsp" %>
<title><mink:message code="mink.label.page_title"/></title>
<script type="text/javascript">
$(function() {
	<%-- accordion 선택 페이지를 유지하기위한 설정값 셋팅 ex) home:0 user:1, device:2, app:3, push:4, board:5, monitoring:6, setting:7 --%>
	init_accordion('push', '${loginUser.menuListString}');
	$("#topMenuTile").html("<mink:message code='mink.web.text.pushmanage_registpush'/>");
	
	init();
	
	textareaResize();
});

function textareaResize() {
	$("#_pushMsg").css("height", "1px");
	$("#_pushMsg").css("height", (20 +  $("#_pushMsg").prop("scrollHeight") + "px"));
}
</script>
</head>
<body>
<div id="miaps-container">
	<div id="miaps-header">
    	<%@ include file="/WEB-INF/jsp/include/header.jsp" %>
  	</div>
  	<div id="miaps-sidebar">
		<%@ include file="/WEB-INF/jsp/include/left.jsp" %>
	</div>
	<div id="miaps-content">
		<div id="miaps-top-buttons">
			<span style="margin:10px 0 10px 0; color:#0080ff; font: normal 20px 맑은 고딕, HYHeadLine, 돋움, verdana, arial, helvetica, sans-serif;"><mink:message code="mink.web.alert.registed.pushmessage"/></span>
		</div>
		<div >
			<table class="detailTb" border="0" cellspacing="0" cellpadding="0" width="100%">
				<colgroup>
					<col width="20%" />
					<col width="80%" />
				</colgroup>
				<tbody>
					<tr>
						<th style="border-top: 0;"><span><mink:message code="mink.web.text.taskname.id"/></span></th>
						<td colspan="3" style="border-top: 0;">
							<c:forEach var="dto" items="${pushData.pushTaskList}" varStatus="i">
								<c:if test="${i.index > 0}">
									,
								</c:if>
								<c:out value='${dto.taskNm}'/>
							</c:forEach>
						</td>
					</tr>
					<tr>
						<th><span><mink:message code="mink.web.text.pushmessage2"/></span></th>
						<td colspan="3">
							<textarea id="_pushMsg" name="pushMsg" style="width:100%;overflow:visible;" readonly="readonly"><c:out value='${pushData.pushMsg}'/></textarea>
						</td>
					</tr>
				<c:if test='${pushType eq "PREMIUM"}'>
					<tr>
						<th><span><mink:message code="mink.web.text.push.messagetype"/></span></th>
						<td>
						<c:choose>
							<c:when test="${msgTp=='Text'}"><mink:message code="mink.web.text.string.normal"/></c:when>
							<c:when test="${msgTp=='BText'}"><mink:message code="mink.web.text.string.bignormal"/></c:when>
							<c:when test="${msgTp=='Inbox'}"><mink:message code="mink.web.text.listtype"/></c:when>
							<c:otherwise><mink:message code="mink.web.text.string.normal"/></c:otherwise>
						</c:choose>
						</td>
					</tr>
					<tr>
						<th><span><mink:message code="mink.web.text.push.imageurl2"/></span></th>
						<td>
							${pushData.imgUrl}
						</td>
					</tr>
				</c:if>
					<tr>
						<th><mink:message code="mink.web.text.push.reserved.senddate"/></th>
						<td>
							${pushData.reservedDt}
						</td>
					</tr>
					<tr>					
						<th><span>Badge Count</span></th>
						<td>
							${pushData.badgeCnt}
						</td>
					</tr>
				</tbody>
				<tfoot></tfoot>
			</table>
		</div>
		<div class="push-target-block" style="float:left;">
			<table id="ugListTb" border="0" cellspacing="0" cellpadding="0" width="100%" class="listTb">
				<colgroup>
					<col width="35%" />
					<col width="35%" />
					<col width="25%" />
				</colgroup>
				<thead>
					<tr>
						<td><mink:message code="mink.web.text.user.groupname"/></td>
						<td><mink:message code="mink.web.text.user.groupid"/></td>
						<td><mink:message code="mink.web.text.include.undergroup"/></td>
					</tr>
				</thead>
				<tbody>
					<c:if test="${pushData.pushTargetList.UG == null || fn:length(pushData.pushTargetList.UG) == 0}">
						<tr><td colspan="3"><mink:message code="mink.web.alert.noexist.target"/></td></tr>
					</c:if>
					<c:if test="${pushData.pushTargetList.UG != null && fn:length(pushData.pushTargetList.UG) > 0}">
						<c:forEach var="dto" items="${pushData.pushTargetList.UG}" varStatus="i">
							<tr><td><c:out value='${dto.grpNm}'/></td>
							<td>${dto.targetId}</td>
							<td>${dto.includeSubYn}</td></tr>
						</c:forEach>
					</c:if>
				</tbody>
				<tfoot></tfoot>
			</table>
		</div>
		<!-- <div class="push-target-block" style="display: inline-block;"> -->
		<div class="push-target-block" style="float: left">
			<table id="userListTb" border="0" cellspacing="0" cellpadding="0" width="100%" class="listTb">
				<colgroup>
					<col width="70%" />
					<col width="30%" />
				</colgroup>
				<thead>
					<tr>
						<td><mink:message code="mink.web.text.username.id"/></td>
						<td><mink:message code="mink.web.text.userno"/></td>
					</tr>
				</thead>
				<tbody>
					<c:if test="${pushData.pushTargetList.UN == null || fn:length(pushData.pushTargetList.UN) == 0}">
						<tr><td colspan="2">대상이 없습니다.<mink:message code="mink.web.alert.noexist.target"/></td></tr>
					</c:if>
					<c:if test="${pushData.pushTargetList.UN != null && fn:length(pushData.pushTargetList.UN) > 0}">
						<c:forEach var="dto" items="${pushData.pushTargetList.UN}" varStatus="i">
							<tr><td><c:out value='${dto.userNm}'/>(<c:out value='${dto.userId}'/>)</td>
							<td>${dto.targetId}</td></tr>
						</c:forEach>
					</c:if>
				</tbody>
			</table>
		</div>
		<div class="push-target-block" style="float: left">
			<table id="deviceListTb" border="0" cellspacing="0" cellpadding="0" width="100%" class="listTb">
				<colgroup>
					<col width="50%" />
					<col width="50%" />
				</colgroup>
				<thead>
					<tr>
						<td><mink:message code="mink.web.text.username.id"/></td>
						<td><mink:message code="mink.web.text.deviceid"/></td>
					</tr>
				</thead>
				<tbody>
					<c:if test="${pushData.pushTargetList.DD == null || fn:length(pushData.pushTargetList.DD) == 0}">
						<tr><td colspan="3"><mink:message code="mink.web.alert.noexist.target"/></td></tr>
					</c:if>
					<c:if test="${pushData.pushTargetList.DD != null && fn:length(pushData.pushTargetList.DD) > 0}">
						<c:forEach var="dto" items="${pushData.pushTargetList.DD}" varStatus="i">
							<tr><td><c:out value='${dto.userNm}'/>(<c:out value='${dto.userId}'/>)</td>
							<td>${dto.targetId}</td></tr>
						</c:forEach>
					</c:if>
				</tbody>
			</table>
			<div id="moreDeviceDiv" style="display: none; text-align: center;"><button class='btn-dash' style="margin-top: 5px;" onclick="javascript:moreDevice();"><mink:message code="mink.web.text.viewmore"/></button></div>
		</div>		
	</div>
	<div id="miaps-footer">
		<%@ include file="/WEB-INF/jsp/include/footer.jsp" %>
	</div>	
</div>
</body>
</html>