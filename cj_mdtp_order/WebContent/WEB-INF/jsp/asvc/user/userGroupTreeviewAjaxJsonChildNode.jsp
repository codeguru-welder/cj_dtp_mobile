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
	 * 사용자 그룹 조직도 treeview ajax json (userGroupTreeviewAjaxJsonChildNode.jsp)
	 * Parent node click, get Child node(ajax)
	 * 
	 * @author eunkyu
	 * @since 2014.02.12
	 */
%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
[
<c:forEach var="dto" items="${userGroupList}" varStatus="i">
	<c:if test="${0 < i.index}">
	,
	</c:if>
	{
	<c:if test="${root == 'source' && 0 == i.index}">
		"classes": "important",
	</c:if>
		"text": "<c:out value='${dto.grpNm}'/>",
		"id": "${dto.grpId}", 
		<%-- set data --%>
		"grpId": "${dto.grpId}",
		"grpCd": "${dto.grpCd}",
		"grpNm": "<c:out value='${dto.grpNm}'/>",
		"grpDesc": "",
		"upGrpId": "${dto.upGrpId}",
		"orderSeq": "${dto.orderSeq}",
		"grpLevel": "${dto.grpLevel}",
		"grpNavigation": "<c:out value='${dto.grpNavigation}'/>"
	<c:if test="${!empty dto.hasChildren && 0 < dto.hasChildren}">
		, "hasChildren": true
	</c:if>
	}
</c:forEach>
]