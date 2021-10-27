<%-- 관리자 권한위임관리 다이얼로그 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="false"%>

<div id="editUserRoleDelegateDialog" title="<mink:message code='mink.web.text.delegate.auth'/>" class="dlgStyle">
<div class="miaps-popup-top-buttons">
	&nbsp;
	<span><button class='btn-dash' onclick="javascript:saveUserRoleDelegate('save');"><mink:message code="mink.web.text.save"/></button></span>
	<span><button class='btn-dash' onclick="javascript:$('#editUserRoleDelegateDialog').dialog('close');"><mink:message code="mink.web.text.cancel"/></button></span>
</div>
<table class="subDetailTb" border="0" cellspacing="0" cellpadding="0" width="100%">
	<tbody>
		<tr>
			<th class="subSearch" style="color: #3e4962;" colspan="2">"<span id="userRoleDelegateGiverTitleSpan"></span>" 권한을<br />아래기간동안 <br />"<span id="userRoleDelegateTargetTitleSpan"></span>"에게 위임합니다.</th>
		</tr>
		<tr>
			<th>
				<mink:message code="mink.web.text.startdate"/>
			</th>
			<td>
				<input type="hidden" name="delegId" />
				<input type="text" name="startDt" class="datepicker" tabindex="-1" />
			</td>
		</tr>
		<tr>
			<th>
				<mink:message code="mink.web.text.enddate"/>
			</th>
			<td>
				<input type="text" name="endDt" class="datepicker" tabindex="-1" />
			</td>
		</tr>
	</tbody>
	<tfoot></tfoot>
</table>
</div>

<script type="text/javascript">
/* *** 관리자 권한위임 사작 *** */
// 관리자 권한위임 등록/수정
function saveUserRoleDelegate(mode) {
	var delegId = $("#editUserRoleDelegateDialog").find(":input[name='delegId']").val();
	var startDt = $("#editUserRoleDelegateDialog").find(":input[name='startDt']").val();
	var endDt = $("#editUserRoleDelegateDialog").find(":input[name='endDt']").val();
	var userNo = '${loginUser.userNo}';
	var delegUserNo = $(":input[name='userNo']", "#userDetailFrm").val();
	var cancelDt = '';
	
	// 알림말
	var alertText = "";
	var url = '';
	
	if('save' == mode) {
		// 검증
		var startDate = new Date(startDt);
		var endDate = new Date(endDt);
		
		if(isNaN(startDate.getTime())) {
			alert('<mink:message code="mink.web.alert.input.startdate"/>');
			return;
		}
		
		if(isNaN(endDate.getTime())) {
			alert('<mink:message code="mink.web.alert.input.enddate"/>');
			return;
		}
		
		if(startDate.getTime() < new Date(getToday()).getTime()) {
			alert("<mink:message code='mink.web.alert.input.sdatefromtoday'/>");
			return;
		}
		
		if(endDate.getTime() - startDate.getTime() < 1) {
			alert('<mink:message code="mink.web.alert.input.edatefromsdate"/>');
			return;
		}
		
		if('' == delegId) {
			url = 'userRoleDelegateInsert.miaps?';
			alertText = "<mink:message code='mink.web.alert.is.regist.authdelegate'/>";
		}
		else {
			url = 'userRoleDelegateUpdate.miaps?';
			alertText = "<mink:message code='mink.web.alert.is.modify.delegatedate'/>";
		}
	}
	else {
		// 위임받은 권한으로 취소불가
		var delegated = false;
		if( "" != "${loginUser.preAdminYn}" ) { // 슈퍼관리자 권한을 위임받음
			delegated = true;
		}
		if( "" != "${loginUser.userGroupMember.preAdminYn}" ) { // 그룹관리자 권한을 위임받음
			delegated = true;
		}
		if(delegated) {
			alert("<mink:message code='mink.web.alert.notuse.delegateauth'/>");
			return;
		}
		
		// 위임취소
		url = 'userRoleDelegateUpdate.miaps?';
		cancelDt = getToday();
		alertText = "<mink:message code='mink.web.alert.is.cancel.authdelegate'/>";
	}
	
	if(!confirm(alertText)) {
		return;
	}
	$.post(url, {delegId: delegId, userNo: userNo, delegUserNo: delegUserNo, startDt: startDt, endDt: endDt, cancelDt: cancelDt}, function(data){
		resultMsg(data.msg);
		//goList(searchFrm.pageNum.value); // 목록/검색
		var userNo = $(":input[name='userNo']", "#userDetailFrm").val();
		var grpId = $(":input[name='userGroupMember.grpId']", "#userDetailFrm").val();
		userDetail(userNo, grpId);
		$("#editUserRoleDelegateDialog").dialog( "close" );
	}, 'json');
}

// 관리자 권한위임관리 다이얼로그 나타나기
function openEditUserRoleDelegateDialog() {
	// 자신에게 위임불가
	if( $(":input[name='userNo']", "#userDetailFrm").val() == "${loginUser.userNo}" ) {
		alert('<mink:message code="mink.web.alert.notuse.delegateself"/>');
		return;
	}
	
	// 위임받은 권한으로 위임불가
	var delegated = false;
	if( "" != "${loginUser.preAdminYn}" ) { // 슈퍼관리자 권한을 위임받음
		delegated = true;
	}
	if( "" != "${loginUser.userGroupMember.preAdminYn}" ) { // 그룹관리자 권한을 위임받음
		delegated = true;
	}
	if(delegated) {
		alert("<mink:message code='mink.web.alert.notuse.delegateauth'/>");
		return;
	}
	
	// 그룹관리자가 그룹이 없는 사용자에게 위임불가
	if( "${ynYes}" == "${loginUser.userGroupMember.adminYn}" ) {
		if( '' == $(":input[name='userGroupMember.preGrpId']", "#userDetailFrm").val() ) {
			alert("<mink:message code='mink.web.text.delegate.message1 '/>");
			return;
		}
	}
	
	// 위임자의 권한보다 높은 권한이나 같은 권한의 사용자에게 위임불가
	var isUpAdmin = false;
	var adminYn = $(":radio[name='adminYn']:checked", "#userDetailFrm").val(); // 위임 받는 자의 권한
	
	if( "${ynYes}" == "${loginUser.adminYn}" ) { // 위임자가 슈퍼관리자인 경우
		if( "" == adminYn || "${ynNo}" == adminYn ) { // 받는 자는 권한이 없거나, 그룹관리자 권한이어야 함
			isUpAdmin = true;
		}
	}
	else if( "${ynYes}" == "${loginUser.userGroupMember.adminYn}" ) { // 위임자가 그룹관리자인 경우
		if( "" == adminYn ) { // 받는 자는 권한이 없어야 함
			isUpAdmin = true;
		}
	}
	
	if(!isUpAdmin) {
		alert("<mink:message code='mink.web.text.delegate.message2'/>");
		return;
	}
	
	$("#editUserRoleDelegateDialog").dialog('open');
}

$("#editUserRoleDelegateDialog").dialog({
	autoOpen: false,
    resizable: false,
    width: 'auto',
    modal: true,
	// add a close listener to prevent adding multiple divs to the document
    close: function(event, ui) {
        // remove div with all data and events
        $(this).dialog( "close" );
    }
});
</script>