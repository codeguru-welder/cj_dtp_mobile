<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
	/*
	 * 에러화면 (commonErrorView.jsp)
	 * 에러메세지를 log 로 남기고 이전 페이지로 돌아가기
	 * 
	 * @author eunkyu
	 * @since 2014.05.28
	 * @modified chlee. 2017.04.05 :  exceptionMessage는 보안 문제로 에러메시지를 표시하지 않도록 삭제, 페이지 모양 변경
	 */
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>error</title>
<link rel="STYLESHEET" type="text/css" href="${contextPath}/css/admincenter.css">
<style type="text/css">
.btn-dash {
     padding-left: 20px;
     padding-right: 20px;
     border: 1px solid #8bbcff;
     background-color: #ffffff;
     color: #0459c1;
     line-height: 28px;
     margin: 1px 0 1px 0;
}
/* 마우스 오버 */
.btn-dash:hover {
    cursor: pointer;
    border: 1px solid #ffffff;
    background-color: #8bbcff;
    color: #ffffff;
}
 /* 마우스 클릭 */
.btn-dash:active {
    border: 1px solid #ffffff;
    background-color: #8bbcff;
	color: #ffffff;
	text-decoration: none;
 }
.err-font-title {
	font: bold 32px sans-serif;
	color: #166fe7;
}
.err-font {
	font: normal 24px 맑은 고딕, HYHeadLine, 돋움, verdana, arial, helvetica, sans-serif;
	color: #3f4246;
}
hr.style-one { 
	border: 0;
	height: 1px;
	background: #333;
	background-image: linear-gradient(to right, #ccc, #333, #ccc); 
}
.div-position {
	margin-left: 20px;
}
</style>
<script type="text/javascript">
function errBack() {
	history.back();
}
</script>
</head>
<body>
<div class="div-position"><span class="err-font-title">Hybrid Resource Deploy Error</span></div>
<hr class="style-one"/>
<div class="div-position" style="margin-top: 20px;">
	<span class="err-font">${msg}</span>
</div>
<br/><br/>
<div style="margin-left: 20px;">
	<button class='btn-dash' onclick="javascript:errBack();"><mink:message code="mink.web.text.back"/></button>
</div>
<%--
<div>
	 ${exceptionMessage}
</div>
 --%>
</body>
</html>