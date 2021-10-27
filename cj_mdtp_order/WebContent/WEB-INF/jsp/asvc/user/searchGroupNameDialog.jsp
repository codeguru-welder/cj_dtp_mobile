<%-- 그룹명 검색 다이얼로그 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="false"%>

<div id="searchUserListViewGroupNameDialog" title="<mink:message code='mink.web.text.search.groupname'/>" class="dlgStyle">
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

<script type="text/javascript">
function callbackUserGroupNameDialog(data) {
	var grpListLen = parseInt(data.searchUserGroupList.length);

	if(grpListLen > 0) {
		$("#searchUserGroupNameDialogTbody").html("");		

		for(var i = 0; i < data.searchUserGroupList.length; i++) {
			var $td = $("<td style='text-align: left;' />").html(data.searchUserGroupList[i].grpNavigation);
			var $tr = $("<tr />").bind("click", {userGroup: data.searchUserGroupList[i]},
				function(event){
					var currGrpId = event.data.userGroup.grpId;
					var currGrpNavigation = event.data.userGroup.grpNavigation;
					var alertText = "'" + currGrpNavigation + "'" + " <mink:message code='mink.web.alert.is.move.group'/>";
					
					if( !confirm(alertText) ) {
						return;
					}
					
					var treeviewUlId = $("#searchUserGroupTotalUl");
					$("a", treeviewUlId).css("background", "#FFFFFF");
					$("a" ,treeviewUlId).each(function(){
						$("a[id='"+currGrpId+"']", treeviewUlId).css("background", "#FFD700"); // check 된 css 적용
					});
					
					$("#searchUserGroupId").val(currGrpId);
					goUserListByPage('1'); // 목록/검색(1 페이지로 초기화)
					reloadTreeview(currGrpId); // 트리 다시 불러오기
					
					$("#searchUserListViewGroupNameDialog").dialog("close"); 
				});
			
			$tr.append($td);
			$("#searchUserGroupNameDialogTbody").append($tr);
		}

		$("#searchUserGroupNameDialogTbody").show();
		$("#searchUserGroupNameDialogTfoot").hide();
	}
	else {
		$("#searchUserGroupNameDialogTbody").hide();
		$("#searchUserGroupNameDialogTfoot").show();
	}
	
	$("#searchUserListViewGroupNameDialog").dialog('open');
}

function openSearchUserGroupNameDialog() {
// 그룹명 검색 다이얼로그 팝업 나타나기
	var searchNameUrl = "userGroupListSearchName.miaps?";
	
	var searchUserGroupName = $("#searchUserGroupName").val();
	var loginUserGrpId = "${loginUser.userGroup.grpId}";
	var loginUserAdminYn = "${loginUser.adminYn}";
	
	var grpId = loginUserGrpId;
	var grpNm = defenceXSS(searchUserGroupName);
	
	if('' != searchUserGroupName) {
		if('Y' == loginUserAdminYn) {
			grpId = ''; // 슈퍼관리자는 전체 검색 가능
		}
		
		$.post(searchNameUrl, {grpId: grpId, grpNm: grpNm}, callbackUserGroupNameDialog, 'json');
	}
}

//그룹명 검색 다이얼로그 팝업
$("#searchUserListViewGroupNameDialog").dialog({
	autoOpen: false,
    resizable: true,
    width: 'auto',
    modal: true,
	// add a close listener to prevent adding multiple divs to the document
    close: function(event, ui) {
        // remove div with all data and events
        $(this).dialog("close");
    }/*,
    buttons: {
        "닫기": function() {
        	$(this).dialog("close");
        }
	}*/
});
</script>