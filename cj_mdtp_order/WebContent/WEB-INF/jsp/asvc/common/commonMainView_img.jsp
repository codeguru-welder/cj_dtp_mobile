<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="org.springframework.web.bind.annotation.SessionAttributes"%>
<%@ page import="com.thinkm.mink.commons.util.MinkConfig" %>
<%
	/*
	 * 메인화면 (commonMainView.jsp)
	 * 앱 신청현황
	 * 최근 사용자 접속현황
	 * 앱 다운로드 현황
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
	init_accordion(0);
});

// 앱 관리 상세조회로 이동
function goAppDetail(appId) {
	$("tr", "#appListTbody").find(":input[name='appId']").remove();
	$("#SearchFrm").find(":input[name='appId']").eq(0).val(appId);
	goAppList(); 
}

// 앱 관리 목록으로 이동
function goAppList() {
	if( '' == $("#SearchFrm").find(":input[name='appId']").eq(0).val() ) {
		$("#SearchFrm").find(":input[name='appId']").remove();
	}
	
	//document.SearchFrm.pageNum.value = pageNum; // 이동할 페이지
	document.SearchFrm.action = '../app/appListView.miaps?type=GET';
	document.SearchFrm.submit();
}

</script>

<!-- 탑 메뉴 -->
	<%@ include file="/WEB-INF/jsp/include/header.jsp" %>
</head>
<body>

<!-- 본문 -->
<div class="bodyContent">
	
	<!-- 왼쪽 메뉴 -->
	<div class="leftContent">
		<%@ include file="/WEB-INF/jsp/include/left.jsp" %>
	</div>
	
	<div class="searchDivFrm">
		<div style="text-align: center; margin-top: 60px;">
		<!-- <img alt="메인" src="../../coex/main_img.png" style="width: 100%; max-width: 1000px;" /> -->
		<img alt="메인" src="../../asvc/images/main_img.png" style="width: 100%; max-width: 1000px;" />
		</div>
	</div>
	
</div>


<!-- footer -->
<%-- <div class="footerContent" >
	<%@ include file="/WEB-INF/jsp/include/footer.jsp" %>
</div> --%>

</body>
</html>
