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
	 * 권한 그룹 조직도 treeview ajax json (roleGroupTreeviewAjaxJsonChildNode.jsp)
	 * Parent node click, get Child node(ajax)
	 * 
	 * @author eunkyu
	 * @since 2014.04.17
	 */
%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
[
<c:forEach var="dto" items="${roleGroupList}" varStatus="i">
	<c:if test="${0 < i.index}">
	,
	</c:if>
	{
	<c:if test="${root == 'source' && 0 == i.index}">
		"classes": "important",
	</c:if>
		"text": "<c:out value='${dto.roleGrpNm}'/>",
		"id": "${dto.roleGrpId}",
		<%-- set data --%>
		"grpId": "${dto.roleGrpId}",
		"grpCd": "",
		"grpNm": "<c:out value='${dto.roleGrpNm}'/>",
		"grpDesc": "<c:out value='${dto.roleGrpDesc}'/>",
		"upGrpId": "${dto.upRoleGrpId}",
		"orderSeq": "${dto.orderSeq}",
		"grpLevel": "${dto.grpLevel}",
		"grpNavigation": "<c:out value='${dto.grpNavigation}'/>"
	<c:if test="${!empty dto.hasChildren && 0 < dto.hasChildren}">
		, "hasChildren": true
	</c:if>
	}
</c:forEach>
]