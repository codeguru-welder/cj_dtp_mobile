<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page session="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%--
/** 그룹검색 treeview dialog 4가지 필요 **/

1. include dialog Javascript 삽입
	<title>...</title>
	<!-- 그룹검색 treeview dialog javascript -->
	<%@ include file="/WEB-INF/jsp/include/searchUserGroupTreeviewDialogJavascript.jsp" %> <=== 삽입
	...

2. 그룹검색 함수 삽입
	$(function() {
		// 그룹검색 treeview dialog
		actionSearchUserGroup(); <=== 삽입
		...

3. include dialog HTML 삽입
	<body>
	<!-- 사용자 그룹 검색 다이얼로그 -->
	<%@ include file="/WEB-INF/jsp/include/searchUserGroupTreeviewDialog.jsp" %> <=== 삽입
	...

4. include tr HTML 삽입
	<!-- 검색 화면 -->
	<div id="searchDiv" >
		<table border="1" cellspacing="0" cellpadding="0" width="100%">
			<!-- 그룹검색 시작 -->
			<%@ include file="/WEB-INF/jsp/include/searchUserGroupTr.jsp" %> <=== 삽입
			<!-- 그룹검색 끝 -->
			<tr> 	
				<td class="search">
					<select name="searchKey">


/** java/xml 작업 **/

1. Controller.java 검색조건 삽입
/* 그룹검색 */
UserController.setParamsSearchUserGroupInfo(request, params); <=== 삽입
// 전체 글의 수 추가(검색조건을 포함한)
...

2. sql.xml 검색조건 삽입
\com\thinkm\mink\admin\maps\mysql\Device.xml 참고

 --%>

<!-- 그룹검색 treeview dialog -->
<div>
<div id="searchUserGroupTreeviewDialog" title="<mink:message code='mink.web.text.search.group'/>" class="dlgStyle">
	
	<div>
		<mink:message code="mink.web.text.group"/>
		<input type="text" id="searchUserGroupName" class="width50" />
		<span><button id="searchUserGroupNameDialogOpenerButton" class='btn-dash'><mink:message code="mink.web.text.search"/></button></span>
	</div>
	
	<div id="schUgTwdgDiv">
		<ul class="twNodeStyle">
			<li id="searchUserGroupTreeviewTopLi" class="outerBulletStyle">
				<c:if test="${ynYes == loginUser.adminYn}">
					<a id="searchUserGroupCorporation" href="javascript:return false;">${corporationName}</a>
				</c:if>
				<c:if test="${ynNo == loginUser.adminYn}">
					<span>${corporationName}</span>
				</c:if>
				
				<ul id="searchUserGroupTreeviewUl" class="treeview"></ul>
			</li>
			
			<li class="outerBulletStyle">
				<a id="searchUserGroupUnclassified" href="javascript:return false;">${unclassifiedName}</a>
			</li>
		</ul>
	</div>
	
	<hr style="height:1;">
	
	<div class="dialogTitle"><mink:message code="mink.web.text.search.group"/></div>
	
	<div class="hiddenHrDivSmall"></div>
	
	<div id="selectUserGroupNavigation">
		${twSearchUserGroup.grpNavigation}
	</div>
	<!-- 
	<div class="hiddenHrDivSmall"></div>
	 -->
	<div>
		<input type="hidden" id="selectUserGroupName" value="${twSearchUserGroup.grpNavigation == unclassifiedName ? unclassifiedName : twSearchUserGroup.grpNm}" />
		<input type="hidden" id="selectUserGroupId" value="${twSearchUserGroup.grpNavigation == unclassifiedName ? unclassified : twSearchUserGroup.grpId}" />
		<input type="hidden" id="selectUserGroupLevel" value="${twSearchUserGroup.grpNavigation == unclassifiedName ? '0' : twSearchUserGroup.grpLevel}" />
	</div>
	<!-- 
	<div class="hiddenHrDivSmall"></div>
	 -->
	<div style="display: none;">
		<label><input type="checkbox" id="selectUserGroupSubAll" ${!empty searchUserGroupSubAllYn ? 'checked' : ''} value="${ynYes}" />${subGroupContainText}</label><!-- subGroupContainText: 하위포함 -->
	</div>
	
</div>

<div id="searchUserGroupNameDialog" title="<mink:message code='mink.web.text.search.groupname'/>" class="dlgStyle">
	<table class="listTb" border="0" cellspacing="0" cellpadding="0" width="100%">
		<thead>
			<tr>
				<th class="subSearch"><mink:message code="mink.web.text.list.search"/></th>
			</tr>
		</thead>
		<tbody id="searchUserGroupNameDialogTbody">
			<tr>
				<td>
					<mink:message code="mink.web.text.navi.group"/>
				</td>
			</tr>
		</tbody>
		<tfoot id="searchUserGroupNameDialogTfoot">
			<tr>
				<td>
					<mink:message code="mink.web.text.noexist.result"/>
				</td>
			</tr>
		</tfoot>
	</table>
</div>
</div>
