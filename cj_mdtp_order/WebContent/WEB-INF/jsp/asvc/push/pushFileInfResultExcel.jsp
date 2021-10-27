<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@page import="com.thinkm.mink.asvc.util.DateUtil"%>
<%@page import="com.thinkm.mink.commons.util.MinkUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="org.springframework.web.bind.annotation.SessionAttributes"%>
<%@ page import="com.thinkm.mink.commons.util.MinkConfig" %>
<%
	/*
	 * 푸시 파일 업로드 연계 API 결과 엑셀(pushFileInfResultExcel.jsp)
	 * 
	 * @author eunkyu
	 * @since 2014.05.19
	 */
	
	response.setHeader("cache-control","no-cache");
	response.setHeader("expires","0");
	response.setHeader("pragma","no-cache");
	 
	response.setHeader("Content-Disposition", "attachment; filename=pushResult"+ DateUtil.getTodayTime2() +".xls");
	response.setHeader("Content-Description", "JSP Generated Data"); 
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title><mink:message code="mink.web.text.push.fileuploadapiresult"/></title>
</head>
<body>
	<table border=1>
		<!-- border=1은 필수 excel 셀의 테두리가 생기게함 -->
		<tr bgcolor=#CACACA>
			<!-- bgcolor=#CACACA excel 셀의 바탕색을 회색으로 -->
			<td colspan=9><H3><mink:message code="mink.web.text.push.batchregistresult"/> <%= DateUtil.getTodayTime() %></H3></td>
		</tr>
		<tr bgcolor=yellow>
			<td><mink:message code="mink.web.text.pushmessage2"/></td>
			<td><mink:message code="mink.web.text.push.reserveddate"/></td>
			<td><mink:message code="mink.web.text.bizid"/></td>
			<td><mink:message code="mink.web.text.push.targettype"/></td>
			<td><mink:message code="mink.web.text.push.targetid"/></td>
			<td><mink:message code="mink.web.text.is.include.under"/></td>
			<td><mink:message code="mink.web.text.is.success"/></td>
			<td><mink:message code="mink.web.text.registed.pushid"/></td>
			<td><mink:message code="mink.web.text.message.error"/></td>
		</tr>
		${result}
	</table>
</body>
</html>