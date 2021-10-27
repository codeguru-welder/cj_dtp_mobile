<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="org.springframework.web.bind.annotation.SessionAttributes"%>
<%@ page import="com.thinkm.mink.commons.util.MinkConfig" %>
<%
	/*
	 * 푸시 파일 업로드 연계 API 화면(pushFileInfView.jsp)
	 * 
	 * @author juni
	 * @since 2014.05.07
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
	//accordion 선택 페이지를 유지하기위한 설정값 셋팅 ex) home:0 user:1, device:2, app:3, push:4, board:5, monitoring:6, setting:7
	init_accordion('push', '${loginUser.menuListString}');
	$("#topMenuTile").html("<mink:message code='mink.web.text.pushmanage_pushbatchregsit'/>");
	
	init();
	
	if( '${errorMsg}' != null && '${errorMsg}' != "" ) alert("${errorMsg}");
	
});

function goInsert() {
	if( $("#apiFile").val() == "" ) {
		alert("<mink:message code='mink.web.alert.push.select.pushfile'/>");
		$("#apiFile").focus();
		return;
	}
	document.apiFileFrm.action = "pushDataInsertFileInf.miaps?";
	document.apiFileFrm.submit();
}

function downloadFile(ext) {
	<%
		String dnFile = "PushSample";
		String locale = MinkConfig.getConfig().get("resource.locale");
		if (locale != null && !"ko".equals(locale)) {
			dnFile += "_en";
		}
	%>
	location.href = "pushSampleDownloadFile.miaps?path="+"/asvc/" + "<%=dnFile%>" + ext;
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
		<div id="miaps-top-buttons">
			<span><button class='btn-dash' onclick="javascript:goInsert();"><mink:message code="mink.web.text.save"/></button></span>
		</div>
		<div id="miaps-content">
			<!-- 본문 -->
			<!-- 검색 및 목록 시작 -->
			<div class="searchDivFrm">
				<form id="apiFileFrm" name="apiFileFrm" method="post" enctype="multipart/form-data" onSubmit="return false;">

					<input type="hidden" name="regNo" value="${loginUser.userNo}" />
	
					<div style="padding-top: 1px;">
						<h3>
							<span style="margin-left: 2%"><mink:message code="mink.web.text.push.regist.batchpush"/></span>
						</h3>
					</div>
	
					<div style="font: normal 14px 맑은 고딕, HYHeadLine, 돋움, verdana, arial, helvetica, sans-serif;">
						=============================================================================================<br/>
							&nbsp;&nbsp;<mink:message code="mink.web.text.push.ext.uploadfile"/><br/>
							&nbsp;&nbsp;<mink:message code="mink.web.alert.push.description.uploadfile"/><br/>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<mink:message code="mink.web.text.pushmessage"/><br/>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<mink:message code="mink.web.text.push.reserved.startdate"/><br/>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<mink:message code="mink.web.text.classification.taskid"/><mink:message code="mink.web.text.push.taskmanage.taskid"/><br/>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<mink:message code="mink.web.text.push.targettype2"/><br/>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<mink:message code="mink.web.text.push.targetdesc"/><br/>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<mink:message code="mink.web.text.push.underinclude.desc"/><br/>
							&nbsp;&nbsp;<mink:message code="mink.web.alert.push.downloaddesc"/><br/>
							&nbsp;&nbsp;<a href="javascript:downloadFile('.csv');"><mink:message code="mink.web.text.push.download.samplecsv"/></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:downloadFile('.xlsx');"><mink:message code="mink.web.text.push.download.samplexlsx"/></a><br/>
						=============================================================================================<br/>
					</div>
	
					<div style="font: normal 14px 맑은 고딕, HYHeadLine, 돋움, verdana, arial, helvetica, sans-serif;">
						&nbsp;&nbsp;<mink:message code="mink.web.text.push.message10"/>
						&nbsp;&nbsp;<input type="text" value="${contextURL}/asvc/push/pushDataInsertInf.miaps?pushMsg=1&reservedDt=2&taskId=3&targetTp=4&targetId=5&includeSubYn=6" size="150" readonly="readonly" style="background-color: white; border: none;"><br />
						=============================================================================================<br/><br/>
					</div>
	
					<table class="listTb" border="0" cellspacing="0" cellpadding="0" width="100%">
						<colgroup>
							<col width="25%" />
							<col width="15%" />
							<col width="15%" />
							<col width="15%" />
							<col width="15%" />
							<col width="15%" />
						</colgroup>
						<thead>
							<tr>
								<td><mink:message code="mink.web.text.pushmessage2"/></td>
								<td><mink:message code="mink.web.text.push.reserveddate"/></td>
								<td><mink:message code="mink.web.text.bizid"/></td>
								<td><mink:message code="mink.web.text.push.targettype"/></td>
								<td><mink:message code="mink.web.text.push.targetid"/></td>
								<td><mink:message code="mink.web.text.is.include.under"/></td>
							</tr>
						</thead>
					</table>
	
					<table class="read_listTb" border="0" cellspacing="0" cellpadding="0" width="100%">
						<colgroup>
							<col width="100%" />
						</colgroup>
						<thead>
							<tr>
								<td><mink:message code="mink.web.text.fileupload"/></td>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td align="left"><input type="file" id="apiFile" name="apiFile" size="100%" ></td>
							</tr>
						</tbody>
					</table>					
				</form>
				<!-- 
				<br /><br /><br /><br />
				<div>
					<h3><span>* 푸시 일괄등록 결과</span></h3>
				</div>
		
				<table class="listTb" border="1" cellspacing="0" cellpadding="0" width="100%">
					<colgroup>
						<col width="10%" />
						<col width="10%" />
						<col width="10%" />
						<col width="10%" />
						<col width="10%" />
						<col width="10%" />
						<col width="10%" />
						<col width="10%" />
						<col width="20%" />
					</colgroup>
					<thead>
						<tr>
							<td>푸시메시지</td>
							<td>예약일시</td>
							<td>업무ID</td>
							<td>타겟유형</td>
							<td>타겟ID</td>
							<td>하위포함여부</td>
							<td>성공여부</td>
							<td>등록된 푸시ID</td>
							<td>오류메시지</td>
						</tr>
					</thead>
					<tbody>
						${result}
					</tbody>
				</table>
				 -->
			</div>
		</div>
		<!-- footer -->
		<div id="miaps-footer">
			<%@ include file="/WEB-INF/jsp/include/footer.jsp" %>
		</div>
	</div>
</body>
</html>
