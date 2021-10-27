<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="org.springframework.web.bind.annotation.SessionAttributes"%>
<%@ page import="com.thinkm.mink.commons.util.MinkConfig" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%
	response.setHeader("cache-control","no-cache");
	response.setHeader("expires","0");
	response.setHeader("pragma","no-cache");
%>
<%
	/*
	 * 메뉴 treeview ajax json (menuTreeviewAjaxJsonAllNode.jsp)
	 * Parent node click, get Child node(ajax)
	 * 
	 * @author eunkyu
	 * @since 2014.05.05
	 */
%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
[
<c:forEach var="dto" items="${menuList}" varStatus="i">
	<c:if test="${0 < i.index}">
	,
	</c:if>
	{
	<c:if test="${root == 'source' && 0 == i.index}">
		"classes": "important",
	</c:if>
		"text": "${dto.menuNm}",
		"id": "${dto.menuId}",
		<%-- set data --%>
		"grpId": "${dto.menuId}",
		"grpCd": "",
		"grpNm": "${dto.menuNm}",
		"grpDesc": "${dto.menuDesc}",
		"upGrpId": "${dto.upMenuId}",
		"orderSeq": "${dto.orderSeq}",
		"deleteYn": "${dto.deleteYn}",
		"grpLevel": "${dto.grpLevel}",
		"grpNavigation": "${dto.grpNavigation}"
	<c:if test="${!empty dto.hasChildren && 0 < dto.hasChildren}">
		, "hasChildren": true
	</c:if>
	}
</c:forEach>
]