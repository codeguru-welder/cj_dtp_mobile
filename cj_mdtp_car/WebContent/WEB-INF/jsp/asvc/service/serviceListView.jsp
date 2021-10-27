<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="org.springframework.web.bind.annotation.SessionAttributes"%>
<%@ page import="com.thinkm.mink.commons.util.MinkConfig" %>
<%
	/*
	 * 서비스 관리 화면
	 * 
	 * @author eunkyu
	 * @since 2014.02.12
	 */
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<%@ include file="/WEB-INF/jsp/include/wsACommonInclude.jsp" %>
<%@ include file="/WEB-INF/jsp/include/wsACommonHeadScript.jsp" %>
<title><mink:message code="mink.label.page_title"/></title>

<script type="text/javascript">

$(document).ready(function() {
	// accordion 선택 페이지를 유지하기위한 설정값 셋팅 ex) user:1, device:2, app:3, push:4, board:5, service:6
	//init_accordion(6);
	init_accordion('service','<%=(String) request.getAttribute("menuListString")%>');
});
</script>

</head>
<body>

<!-- 본문 -->
<div class="bodyContent">
	
	<!-- 템플릿 작업을 위한 임시 table 시작 1-->
	<br />
	<br />
	<table border="0" >
	<tr>
	<td valign="top" width="200px">
	<!-- 템플릿 작업을 위한 임시 table 끝 -->
	
	<!-- 왼쪽 메뉴 -->
	<div class="leftContent">
		<%@ include file="/WEB-INF/jsp/include/left.jsp" %>
	</div>

	<!-- 템플릿 작업을 위한 임시 table 시작 2-->
	</td>
	<td width="40px"></td>
	<td valign="top">
	<!-- 템플릿 작업을 위한 임시 table 끝 -->
	
	<mink:message code="mink.web.text.test_page"/>
	
	<!-- 템플릿 작업을 위한 임시 table 시작 3-->
	</td>
	</tr>
	</table>
	<!-- 템플릿 작업을 위한 임시 table 끝 -->
	
</div>

<!-- footer -->
<div class="footerContent" >
	<%@ include file="/WEB-INF/jsp/include/footer.jsp" %>
</div>
	
</body>
</html>
