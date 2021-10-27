<%-- 사용자 등록 다이얼로그 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="false"%>

<div id="userRegDialog" title="<mink:message code='mink.web.text.regist.user'/>" class="dlgStyle">
<div class="miaps-popup-top-buttons">
	&nbsp;
	<span><button class='btn-dash' onclick="javascript:userInsert();"><mink:message code="mink.web.text.save"/></button></span>
	<span><button class='btn-dash' onclick="javascript:$('#userRegDialog').dialog('close');"><mink:message code="mink.web.text.cancel"/></button></span>
</div>
<!-- 등록화면 -->
<form id="insertFrm" name="insertFrm" method="post" onSubmit="return false;">
	<input type="hidden" name="regNo" value="${loginUser.userNo}" />
	<table class="insertTb" border="0" cellspacing="0" cellpadding="0" width="100%">
		<tbody>
			<tr>
				<th><span class="criticalItems"><mink:message code="mink.web.text.username"/></span></th>
				<td><input type="text" name="userNm" /></td>
				<th><span class="criticalItems"><mink:message code="mink.web.text.userid"/></span></th>
				<td><input type="text" name="userId" /></td>
			</tr>
			<tr>
				<th><mink:message code="mink.web.text.password"/></th>
				<td><input type="text" name="userPw" /></td>
				<th><mink:message code="mink.web.text.permission"/></th>
				<td>
					<label><input type="radio" name="adminYn" title="user" value="" checked="checked" /><mink:message code="mink.text.noexist.none"/></label>
					<span id="subAdminHiddenInsertSpan">
					<label><input type="radio" name="adminYn" title="subAdmin" value="${ynNo}" />${subAdmin}</label>
					</span>
					<label><input type="radio" name="adminYn" title="superAdmin" value="${ynYes}" />${superAdmin}</label>
				</td>
			</tr>
			<tr>
				<th><mink:message code="mink.web.text.group2"/></th>
				<td colspan="3" class="onlyTextTd">
					<span id="insertUserGroupSpan">
					<input type="hidden" name="userGroupMember.grpId" />
					<input type="hidden" name="userGroup.grpNm" />
					<input type="hidden" name="userGroup.grpNavigation" />
					<span></span>
					</span>
					<span style="display: none;"><button id="editUserGroupMemberSearchUserGroupTreeviewDialogOpenerButtonInsert" class='btn-dash'><mink:message code="mink.web.text.regist.group"/></button></span>
				</td>
			</tr>
			<tr>
				<th><mink:message code="mink.web.text.resp.pnumber"/></th>
				<td><input type="text" name="phoneNo1" /></td>
				<th><mink:message code="mink.web.text.pnumber"/></th>
				<td><input type="text" name="phoneNo2" /></td>
			</tr>
			<tr>
				<th>e-mail</th>
				<td colspan="3"><input type="text" name="emailAddr" /></td>
			</tr>
		</tbody>
		<tfoot></tfoot>
	</table>
</form>
</div>

<script type="text/javascript">
var insertFrm = document.insertFrm;
/* userListView.jsp에 있는 것을 사용하므로 삭제.
function validation() {
	var answer = false;
	var frm = document.insertFrm;
	
	if(frm.userId.value == '') {
		alert('사용자ID를 입력하세요.');
		$(frm.userId).focus();
		return true;
	}
	 
	if(frm.userNm.value == '') {
		alert('사용자명을 입력하세요.');
		$(frm.userNm).focus();
		return true;
	}
	
	if(frm["userGroupMember.grpId"].value == '' && $(":radio[title='subAdmin']", frm).get(0).checked) {
		alert('${subAdmin} 그룹을 입력하세요.');
		return true;
	}
	if(frm["userGroupMember.grpId"].value == '${corporation}') {
		alert('그룹을 입력하세요.');
		return true;
	}
}*/
//등록
function userInsert() {
	if( validation() ) {
		return; // 검증
	}
	if( !confirm("<mink:message code='mink.web.alert.is.regist'/>") ) {
		return;
	}
	ajaxComm('userInsert.miaps?', insertFrm, function(data){
		hideLoading();
		resultMsg(data.msg);
		searchFrm.userNo.value = data.user.userNo; // (등록한)상세
		/* 등록 후 사용자상세를 표시할 필요가 없으므로 삭제
		if( null != data.user.userGroupMember && "" != nvl(data.user.userGroupMember.grpId) ) {
			var grpId = data.user.userGroupMember.grpId;
			if( "${unclassified}" == grpId || "${corporation}" == grpId ) grpId = '';
			detailFrm["userGroupMember.grpId"].value = grpId;
			
			$(":input[name='grpId']").val(grpId); // 상세 사용자 그룹ID
		}
		else {
			$(":input[name='grpId']").val(''); // 상세 사용자 그룹ID
		}
		*/
		$("#userRegDialog").dialog( "close" );
		
		goUserListByPage('1'); // 목록/검색(1 페이지로 초기화)
	});
}

function openUserRegDialog() {
	$("#insertUserGroupSpan").find("span").html($("#searchUserGroupNavigationSpan").html());
	$('input[name=\'userId\']', '#insertFrm').focus();
	
	var _userGroupId = $("#searchUserGroupId").val(); // 그룹트리에서 그룹을 선택 할 때마다 값을 바꾸도록 해 놨음.
	if (_userGroupId == '') {
		_userGroupId = '0';
	}
	
	//if("${corporation}" == $("#searchUserGroupId", document.userListFrame.searchFrm).val()) {
	if("${corporation}" == _userGroupId) {	
		$("#editUserGroupMemberSearchUserGroupTreeviewDialogOpenerButtonInsert").parent("span").show();
		
		// root 인 경우 사용자등록시 그룹없음으로 초기화
		insertFrm["userGroupMember.grpId"].value = '';
		insertFrm["userGroup.grpNm"].value = '${unclassifiedName}';
		insertFrm["userGroup.grpNavigation"].value = '${unclassifiedName}';
		$("#insertUserGroupSpan").find("span").html("${unclassifiedName}");
	}
	else {
		insertFrm["userGroupMember.grpId"].value = $("#searchUserGroup_grpId").val();
		insertFrm["userGroup.grpNm"].value = $("#searchUserGroup_grpNm").val();
		insertFrm["userGroup.grpNavigation"].value = $("#searchUserGroup_grpNavigation").val();
	
		$("#editUserGroupMemberSearchUserGroupTreeviewDialogOpenerButtonInsert").parent("span").hide();
	}
	
	$('#insertFrm')[0].reset();	// form 초기화	
	
	$("#userRegDialog").dialog( "open" );
}

$("#userRegDialog").dialog({
	autoOpen: false,
    resizable: false,
    width: 'auto',
    modal: true,
	// add a close listener to prevent adding multiple divs to the document
    close: function(event, ui) {
        // remove div with all data and events
        $(this).dialog( "close" );
    },
    /*
    buttons: {
		"저장": userInsert,
        "취소": function() {
        	$(this).dialog( "close" );
        }
	}*/
});
</script>