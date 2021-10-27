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
	 * 사용자 그룹 조직도 treeview ajax json (userGroupTreeviewAjaxJsonSelectedNode.jsp)
	 * Current node, Direct parent node, Sibling node
	 * 
	 * @author eunkyu
	 * @since 2014.07.01
	 */
%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:set var="putAcomma" value="false" />
<c:set var="preLevel" value="0" /><%-- [current - 1].grpLevel --%>
[
<c:forEach var="dto" items="${userGroupList}" varStatus="i">
	<%-- End Object before Start Object --%>
	<c:if test="${dto.grpLevel < preLevel}">
	<c:forEach var="j" begin="1" end="${preLevel - dto.grpLevel}">
		]
	}
	</c:forEach>
	</c:if>
	
	<%-- if(,) --%>
	<c:if test="${putAcomma}">
	,
	</c:if>
	
	{
	<c:if test="${0 == i.index}">
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
	
	<c:set var="putAcomma" value="true" />
	<c:if test="${dto.directParentYn == 'Y'}">
		<c:set var="putAcomma" value="false" />
		, "expanded": true
		, "children":
		[
	</c:if>
	
	<c:if test="${dto.directParentYn != 'Y'}">
		<c:if test="${0 < dto.hasChildren}">
		, "hasChildren": true
		</c:if>
	}
	</c:if>
	
	<%-- End Object before End List --%>
	<c:set var="listSize" value="${fn:length(userGroupList)}" />
	<c:if test="${i.index == listSize - 1}">
		<c:if test="${1 < dto.grpLevel}">
			<c:forEach var="k" begin="1" end="${dto.grpLevel - 1}">
				]
			}
			</c:forEach>
		</c:if>
	</c:if>
	
	<%-- Set --%>
	<c:set var="preLevel" value="${dto.grpLevel}" /><%-- preLevel = currLevel --%>
</c:forEach>
]