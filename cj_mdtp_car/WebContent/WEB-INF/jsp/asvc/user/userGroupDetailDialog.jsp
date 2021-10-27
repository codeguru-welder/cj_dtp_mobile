<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page session="false"%>
<%--@ include file="/WEB-INF/jsp/include/wsACommonHeadScript.jsp" --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!--
//회사노드 선택(전체검색)
$("#searchUserGroupCorporation").bind("click", setSelectUserGroupCorporation); 
 -->

<!-- 사용자 상세정보 dialog -->
<div id="userGroupDetailDialog" title="<mink:message code='mink.web.text.info.usergroupdetail'/>" class="dlgStyle">
	<table class="userTable" border="0" cellspacing="0" cellpadding="0" width="100%">
		<thead>
			<tr>
				<td class="subSearch" colspan="2"><mink:message code="mink.web.text.info.usergroupdetail"/></td>
			</tr>
<!-- 				<tr>
					<td class="search" colspan="2">
						<input id="searchUserGroupName" name="searchUserGroupName" type="text" value="${search.searchUserGroupName}" />
						<span><button id="searchUserGroupNameDialogOpener" class='btn-dash'>그룹검색</button></span>
					</td>
				</tr> -->
		</thead>
		<tbody>
			<tr>
				<th><mink:message code="mink.web.text.navi.group"/></th>
				<td id="grpNavigation">					
				</td>
			</tr>
			<c:if test="${corporation != search.searchUserGroup.grpId && unclassified != search.searchUserGroup.grpId}">
			<tr>
				<th><mink:message code="mink.web.text.groupname"/></th>
				<td id="grpNm"></td>
			</tr>
			<tr>
				<th><mink:message code="mink.web.text.groupid"/></th>
				<td id="grpId"></td>
			</tr>
			<tr>
				<th><mink:message code="mink.web.text.uppergroupid"/></th>
				<td id="upGrpId"></td>
			</tr>
			</c:if>
		</tbody>
	</table>
</div>


<script type="text/javascript">
/* 호출하는곳에 넣을 코드
  $.post(url, "{'type':'post', 'searchUserGroupId':'"+ searchUserGroupId +"'}", callbackUserGroupDetailDialog, 'json');
 */
function callbackUserGroupDetailDialog(data) {
	hideLoading();
	
	var dto = data.search;
	
	$("#grpNavigation").html(dto.searchUserGroup.grpNavigation);
	$("#grpNm").html(dto.searchUserGroup.grpNm);
	$("#grpId").html(dto.searchUserGroup.grpId);
	$("#upGrpId").html(dto.searchUserGroup.upGrpId);
	
	$("#userGroupDetailDialog").dialog("open");
	
};

// 사용자 상세정보 다이얼로그 팝업
//open the dialog
$("#userGroupDetailDialog").dialog({
	// add a close listener to prevent adding multiple divs to the document
    close: function(event, ui) {
        // remove div with all data and events
        $(this).dialog( "close" );
    },
    buttons: {
		"<mink:message code=''/>": function() {
			$(this).dialog( "close" );
        }
	},
    autoOpen: false,
    modal: true,
    width: 1000
});
</script>