<%-- 사용자별 권한변경 이력조회 다이얼로그 - 같은 사용자ID 중에서 선택하기 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="false"%>
<div id="menuAdminUserRoleBySameUserIdDialog" title="동일한 사용자ID 중에서 사용자 선택하기" class="dlgStyle">
	<div id="menuAdminUserRoleBySameUserIdDiv">
		<!-- 목록 화면 -->
		<div id="listDiv3">
			<table id="menuAdminUserRoleBySameUserIdListTb" border="0" cellspacing="0" cellpadding="0" width="100%" class="listTb">
				<thead>
					<tr>
						<td id="menuAdminUserRoleBySameUserIdListThead"><mink:message code="mink.web.text.userid"/></td>
					</tr>
				</thead>
				<tbody id="menuAdminUserRoleBySameUserIdListTbody">
					<tr>
						<td></td>
					</tr>
				</tbody>
				<tfoot>
				</tfoot>
			</table>
		</div>
	</div>
</div>

<script type="text/javascript">
function showMenuAdminUserRoleBySameUserIdDialog(searchUserId, resultList) {
	$("#menuAdminUserRoleBySameUserIdListThead").html("<mink:message code='mink.web.text.userid'/>" + ": " + searchUserId);
	
	var html = "";
	for(var i = 0; i < resultList.length; i++) {
		var userNo = resultList[i].userNo;
		var userInfoSpan2 = getUserInfoSpan2(resultList, i);
		
		html += "<tr onclick='javascript:searchMenuAdminUserRoleHistory2("+userNo+", \""+userInfoSpan2+"\");'>";
		html += "<td align='left'>" + userInfoSpan2 + "</td>";
		html += "</tr>";
	}
	$("#menuAdminUserRoleBySameUserIdListTbody").html(html);
	
	$("#menuAdminUserRoleBySameUserIdDialog").dialog( "open" );
}

function searchMenuAdminUserRoleHistory2(userNo, html) {
	document.searchFrm2.searchUserNo.value = userNo;
	$("#userInfoSpan2").html(" | " + html + " | ");
	searchMenuAdminUserRoleHistory();
	
	$("#menuAdminUserRoleBySameUserIdDialog").dialog( "close" );
}

$("#menuAdminUserRoleBySameUserIdDialog").dialog({
	autoOpen: false,
    resizable: true,
    width: '40%',
    modal: true,
	// add a close listener to prevent adding multiple divs to the document
    close: function(event, ui) {
        // remove div with all data and events
        $(this).dialog( "close" );
    }
});
</script>