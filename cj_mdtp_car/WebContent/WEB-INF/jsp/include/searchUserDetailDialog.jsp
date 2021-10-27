<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page session="false"%>

<!-- 사용자 상세정보 dialog -->
<div id="searchUserDetailDialog" title="<mink:message code='mink.web.text.info.userdetail'/>" class="dlgStyle">
<div class="miaps-popup-top-buttons" style="border-bottom: 0px;">
	&nbsp;
	<span><button class='btn-dash' onclick="javascript:$('#searchUserDetailDialog').dialog('close');"><mink:message code="mink.web.text.close"/></button></span>
</div>	
	<!-- 상세화면 -->
	<table class="detailTb" border="0" cellspacing="0" cellpadding="7" width="100%">
		<colgroup>
			<col width="30%" />
			<col width="70%" />
		</colgroup>
		<tbody>
			<tr>
				<th><mink:message code="mink.web.text.userno"/></th>
				<td id="searchUserNoTd"></td>
			</tr>
			<tr>
				<th><mink:message code="mink.web.text.userid"/></th>
				<td id="searchUserIdTd"></td>
			</tr>
			<tr>
				<th><mink:message code="mink.web.text.username"/></th>
				<td id="searchUserNmTd"></td>
			</tr>
			<tr>
				<th><mink:message code="mink.web.text.group2"/></th>
				<td id="searchUserGrpNavigationsTd"></td>
			</tr>
			<tr>
				<th><mink:message code="mink.web.text.permission"/></th>
				<td id="searchAdminYnTd"></td>
			</tr>
			<tr>
				<th><mink:message code="mink.web.text.resp.pnumber"/></th>
				<td id="searchPhoneNo1Td"></td>
			</tr>
			<tr>
				<th><mink:message code="mink.web.text.pnumber"/></th>
				<td id="searchPhoneNo2Td"></td>
			</tr>
			<tr>
				<th>e-mail</th>
				<td id="searchEmailAddrTd"></td>
			</tr>
			<tr>
				<th><mink:message code="mink.web.text.license"/></th>
				<td id="searchLicenseIdTd"></td>
			</tr>
		</tbody>
		<tfoot></tfoot>
	</table>
</div>

<script type="text/javascript">
//ajax 로 가져온 data 를 알맞은 위치에 삽입
function showSearchUserDetailDialog(userNo) {
	cancelPropagation(event); // tr click 이벤트 막음
	
	var hrf = document.location.href; // ex)${contextURL}/asvc/user/userListView.miaps?type=GET
	hrf = hrf.split('.miaps'); // ex)${contextURL}/asvc/user/userListView
	hrf = hrf[0].split('/'); // ex)[0]=http:, ..., [5]=user, [6]=userListView
	hrf = hrf[hrf.length - 2]; // 파일 디렉토리(폴더) 추출 // ex)user
	
	var url = '../user/userUserGroupsDetail.miaps?';
	if(hrf == 'user') {
		url = 'userUserGroupsDetail.miaps?';
	}
	
	$.post(url, {userNo: userNo}, callbackUSearchUserDetailDialog, 'json');
}

function callbackUSearchUserDetailDialog(data) {
	var dto = data.user;

	$("#searchUserNoTd").html(dto.userNo);
	$("#searchUserIdTd").html(defenceXSS(dto.userId));
	$("#searchUserNmTd").html(defenceXSS(dto.userNm));
	$("#searchEmailAddrTd").html(defenceXSS(dto.emailAddr));
	$("#searchPhoneNo1Td").html(defenceXSS(dto.phoneNo1));
	$("#searchPhoneNo2Td").html(defenceXSS(dto.phoneNo2));
	$("#searchLicenseIdTd").html(dto.licenseId);
	var adminYn = '<mink:message code="mink.text.noexist.none"/>'; 
	if('${ynYes}' == dto.adminYn) {
		adminYn = '${superAdmin}';
	}
	else {
		if(null != dto.userGroupMember && '${ynYes}' == dto.userGroupMember.adminYn) {
			adminYn = '${subAdmin}';
		}
	}
	$("#searchAdminYnTd").html(adminYn);
	
	var nav = '';
	if(null != dto.userGroup) {
		for(var i = 0; i < dto.userGroup.grpNavigationList.length; i++) {
			if( 0 < i ) nav += "<br />";
			nav += dto.userGroup.grpNavigationList[i]; // 사용자 그룹 네비게이션(다수그룹)
		}
	}
	else {
		nav = "${unclassifiedName}";
	}
	$("#searchUserGrpNavigationsTd").html(nav);
	
	$("#searchUserDetailDialog").dialog('open');
}

$(function(){
	// 사용자 상세정보 다이얼로그 팝업
	$("#searchUserDetailDialog").dialog({
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
});

</script>