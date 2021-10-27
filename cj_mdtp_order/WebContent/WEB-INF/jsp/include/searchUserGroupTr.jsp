<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page session="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="mink" uri="/WEB-INF/tld/mink.tld" %>
<!-- 그룹검색 tr -->
<tr>
	<td class="navigationTd">
		<span class="leftFloatSpan">
			<span id="searchUserGroupNavigationSpan">${twSearchUserGroup.grpNavigation}</span><!-- 그룹 네비게이션 -->
			<%-- 주석처리(값이 맞지 않음)
			<c:if test="${search != null && !empty search.count}">
			<span>(${search.count})</span>
			</c:if>
			 --%>
		</span>
		<span class="rightFloatSpan">
			<input id="searchUserGroupId" type="hidden" name="searchUserGroupId" value="${twSearchUserGroup.grpId}" /><!-- 검색그룹ID -->
			<span><label><input id="searchUserGroupSubAllChekbox" type="checkbox" name="searchUserGroupSubAllYn" ${!empty twSearchSubAllYn ? 'checked' : '' } value="${ynYes}" /><mink:message code="mink.web.text.include.under"/></label></span><!-- 하위그룹 검색포함여부 -->
			<span><button id="searchUserGroupTreeviewDialogOpenerButton" class='btn-dash'><mink:message code="mink.web.text.search.group"/></button></span><!-- 그룹 조직도(treeview) 다이얼로그 오프너 -->
		</span>
	</td>
</tr>
