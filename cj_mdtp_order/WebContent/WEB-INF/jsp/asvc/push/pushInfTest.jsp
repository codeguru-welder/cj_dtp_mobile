<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="org.springframework.web.bind.annotation.SessionAttributes"%>
<%@ page import="com.thinkm.mink.commons.util.MinkConfig" %>
<%
	/*
	 * 푸시 파연계 API 테스트 화면(pushFileInfTest.jsp)
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
	
	if( '${msg}' != null && '${msg}' != "" ) alert("${msg}");
	
});

function goInsert() {
	document.apiFrm.action = "pushDataInsertInf.miaps?";
	document.apiFrm.submit();
}
</script>

<!-- 탑 메뉴 -->
	<%@ include file="/WEB-INF/jsp/include/header.jsp" %>
</head>
<body>

<!-- 본문 -->
<div class="bodyContent">

	<!-- 왼쪽 메뉴 시작 -->
	<div class="leftContent">
		<%@ include file="/WEB-INF/jsp/include/left.jsp" %>
	</div>
	<!-- 왼쪽 메뉴 끝 -->
	
	<!-- 검색 및 목록 시작 -->
	<div class="searchDivFrm">
		<form id="apiFrm" name="apiFrm" class="detailFrm" method="post" enctype="multipart/form-data" onSubmit="return false;">
			<!-- 검색 hidden -->
		
			<div>
				<h3><span><mink:message code="mink.web.text.push.linkedapi"/></span></h3>
			</div>

			<table class="insertTb" border="1" cellspacing="0" cellpadding="0" width="100%">
				<colgroup>
					<col width="20%" />
					<col width="80%" />
				</colgroup>
				<tbody>
					<tr>
						<th><mink:message code="mink.web.text.pushmessage2"/></th>
						<td><input type="text" name="pushMsg" /></td>
					</tr>
					<tr>
						<th><mink:message code="mink.web.text.push.reserveddate"/></th>
						<td><input type="text" name="reservedDt" /></td>
					</tr>
					<tr>
						<th><mink:message code="mink.web.text.bizid"/></th>
						<td><input type="text" name="taskId" /></td>
					</tr>
					<tr>
						<th><mink:message code="mink.web.text.push.targettype"/></th>
						<td><input type="text" name="targetTp" /></td>
					</tr>
					<tr>
						<th><mink:message code="mink.web.text.push.targetid"/></th>
						<td><input type="text" name="targetId" /></td>
					</tr>
					<tr>
						<th><mink:message code="mink.web.text.is.include.under"/></th>
						<td><input type="text" name="includeSubYn" /></td>
					</tr>
				</tbody>
			</table>
	
			<div class="searchBtnArea">
				<button class='btn-dash' onclick="javascript:goInsert()"><mink:message code="mink.web.text.save"/></button>
			</div>
		</form>

	</div>
</div>

<!-- footer -->
<div class="footerContent" >
	<%@ include file="/WEB-INF/jsp/include/footer.jsp" %>
</div>

</body>
</html>
