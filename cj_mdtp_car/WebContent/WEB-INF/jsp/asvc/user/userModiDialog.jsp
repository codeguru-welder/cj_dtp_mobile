<%-- 사용자 상세 및 수정 다이얼로그 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="false"%>

<%-- 사용자 메일계정 정보 다이얼로그 --%>
<%@ include file="/WEB-INF/jsp/asvc/user/userEmailRegDialog.jsp" %>
<%@ include file="/WEB-INF/jsp/asvc/user/userEmailModiDialog.jsp" %>

<%-- 사용자 장치 상세정보 다이얼로그 --%>
<%@ include file="/WEB-INF/jsp/asvc/user/userDeviceDetailDialog.jsp" %>

<div id="userModiDialog" title="<mink:message code='mink.web.text.info.userdetail'/>" class="dlgStyle">
<div id="container_user_detail">
	<ul class="tabs_appRole">
		<li class="active" rel="user_tab1"><mink:message code="mink.web.text.info.basic"/></li>
		<li rel="user_tab2"><mink:message code="mink.web.text.mail.account"/></li>
		<li rel="user_tab3"><mink:message code="mink.web.text.info.device"/></li>
	</ul>
	<div class="tab_container_appRole">
		<div id="user_tab1" class="tab_content_appRole">
			<div class="miaps-popup-top-buttons-in-tap" style="border:0;">
				&nbsp;
				<span><button class='btn-dash' onclick="javascript:userUpdateUserPwInit();"><mink:message code="mink.web.text.reset.password"/></button></span>
				<span><button class='btn-dash' onclick="javascript:userUpdate();"><mink:message code="mink.web.text.save"/></button></span>
				<span><button class='btn-dash' onclick="javascript:$('#userModiDialog').dialog('close');"><mink:message code="mink.web.text.cancel"/></button></span>
			</div>
			<!-- 상세화면 -->
			<form id="userDetailFrm" name="userDetailFrm" method="post" onSubmit="return false;">
				<table class="detailTb" border="0" cellspacing="0" cellpadding="0" width="100%">
					<tbody>
						<tr>
							<th><mink:message code="mink.web.text.username"/></th>
							<td>
								<input type="text" name="userNm" />
								<input type="hidden" name="userNmOri" />					
							</td>
							<th><mink:message code="mink.web.text.userid"/></th>
							<td><input type="text" name="userId" readonly="readonly" /></td>
						</tr>
						<tr>
							<th><mink:message code="mink.web.text.userno"/></th>
							<td><input type="text" name="userNo" readonly="readonly" /></td>
							<th><mink:message code="mink.web.text.permission"/></th>
							<td>
								<label><input type="radio" name="adminYn" value=""  title="user" /><mink:message code="mink.text.noexist.none"/></label>
								<span id="subAdminHiddenDetailSpan">
								<label><input type="radio" name="adminYn" value="${ynNo}" title="subAdmin" />${subAdmin}</label>
								</span>
								<label><input type="radio" name="adminYn" value="${ynYes}" title="superAdmin" />${superAdmin}</label>
							</td>
						</tr>
						<tr>
							<th><mink:message code="mink.web.text.group2"/></th>
							<td id="userGroupTd" colspan="3" class="textWithBtnTd">
								<span id="detailUserGroupSpan">
									<input type="hidden" name="userGroupMember.preGrpId" />
									<input type="hidden" name="userGroupMember.grpId" />
									<input type="hidden" name="userGroup.grpNm" />
									<input type="hidden" name="userGroup.grpNavigation"/>
									<span></span>
								</span>
								<span><button id="editUserGroupMemberSearchUserGroupTreeviewDialogOpenerButtonDetail" class='btn-dash'><mink:message code="mink.web.text.modify.group"/></button></span>
								<span><button id="addUserGroupMemberSearchUserGroupTreeviewDialogOpenerButton" class='btn-dash'><mink:message code="mink.web.text.add"/></button></span>
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
						<%--
						<tr>
							<th>관리자 권한위임</th>
							<td colspan="3" class="textWithBtnTd">
								<span id="existUserRoleDelegateSpan">
									<span id="userRoleDelegateDateSpan"></span>
									<span id="userRoleDelegateStateSpan"></span>
									<span id="userRoleDelegateUserSpan"></span>
								</span>
								<span id="emptyUserRoleDelegateSpan">
									위임받은 권한이 없습니다.
								</span>
								<span id="cancelUserRoleDelegateSpan" style="display: none;"><button class='btn-dash' onclick="javascript:saveUserRoleDelegate('cancel');">위임취소</button></span>
								<span id="editUserRoleDelegateSpan"><button class='btn-dash' onclick="openEditUserRoleDelegateDialog();">권한위임관리</button></span>
							</td>
						</tr>
						 --%>
						<tr>
							<th><mink:message code="mink.text.license.user"/></th>
							<td colspan="3">
								<input type="text" name="licenseId" readonly="readonly" />
							</td>
						</tr>
						<tr>
							<th><mink:message code="mink.web.text.regdate"/></th>
							<td><input type="text" name="regDt" readonly="readonly" /></td>
							<th><mink:message code="mink.web.text.moddate"/></th>
							<td><input type="text" name="updDt" readonly="readonly" /></td>
						</tr>
					</tbody>
					<tfoot></tfoot>
				</table>
			
				<input type="hidden" name="regNo" />
				<input type="hidden" name="updNo" value="${loginUser.userNo}" />
				<input type="hidden" name="userPw" />
				<input type="hidden" name="passQuest" />
				<input type="hidden" name="passAnsw" />
				<input type="hidden" name="passCnt" />
				<input type="hidden" name="deleteYn" />
				<input type="hidden" name="preAdminYn" />
				
			</form>
		</div>
		<div id="user_tab2" class="tab_content_appRole">
			<div class="miaps-popup-top-buttons-in-tap" style="border:0;">
				&nbsp;
				<span><button class='btn-dash' onclick="javascript:openUserEmailRegDialog();"><mink:message code="mink.web.text.regist.mailaccount"/></button></span>
				<span><button class='btn-dash' onclick="javascript:$('#userModiDialog').dialog('close');"><mink:message code="mink.web.text.close"/></button></span>
			</div>
			<table class="listTb" border="0" cellspacing="0" cellpadding="0" width="100%">
				<colgroup>
					<col width="12%" />
					<col width="24%" />
					<col width="10%" />
					<col width="15%" />
					<col width="12%" />
					<col width="15%" />
					<col width="12%" />
				</colgroup>
				<thead>
					<tr>
						<td><mink:message code="mink.web.text.status.basicaccount"/></td>
						<td><mink:message code="mink.web.text.mail.mailadress"/></td>
						<td><mink:message code="mink.web.text.mail.protocol"/></td>
						<td><mink:message code="mink.web.text.mail.sendserver.adress"/></td>
						<td><mink:message code="mink.web.text.mail.sendserver.port"/></td>
						<td><mink:message code="mink.web.text.mail.receiveserver.adress"/></td>
						<td><mink:message code="mink.web.text.mail.receiveserver.port"/></td>
					</tr>
				</thead>
				<tbody id="emailAccountFrmListTbody">
				</tbody>
				<tfoot id="emailAccountFrmListTfoot">
					<!-- 목록이 없을 경우 -->
					<tr>
						<td colspan="7"><mink:message code="mink.web.text.noexist.result"/></td>
					</tr>
				</tfoot>
			</table>
			
		</div>
		<div id="user_tab3" class="tab_content_appRole">
			<div class="miaps-popup-top-buttons-in-tap" style="border:0;">
				&nbsp;
				<span><button class='btn-dash' onclick="javascript:$('#userModiDialog').dialog('close');"><mink:message code="mink.web.text.close"/></button></span>
			</div>
			<form id="userDeviceDialogFrm" name="userDeviceDialogFrm" method="post" onSubmit="return false;">
				<input type="hidden" name="pageNum" value="1" /><!-- 현재 페이지 -->
				<input type="hidden" name="userNo" />
				<input type="hidden" name="searchPageSize" value="10"/> 
				<table id="userDeviceDialogTb" class="listTb" border="0" cellspacing="0" cellpadding="0" width="100%">
					<colgroup>
						<col width="20%" />
						<col width="35%" />
						<col width="15%" />
						<col width="15%" />
						<col width="15%" />
					</colgroup>
					<thead>
						<tr>
							<td><mink:message code="mink.web.text.device.regtime"/></td>
							<td><mink:message code="mink.web.text.deviceid"/></td>
							<td><mink:message code="mink.web.text.ostype"/></td>
							<td><mink:message code="mink.web.text.modelnumber"/></td>
							<td><mink:message code="mink.web.text.status.device"/></td>
						</tr>
					</thead>
					<tbody>
					</tbody>
				</table>
				<div id="userDevicePaginateDiv" class="paginateDiv"></div>
			</form>
		</div>
	</div>
</div>
</div>

<script type="text/javascript">
//수정
function userUpdate() {
	if(validation(userDetailFrm, 'userUpdate')) return; // 검증
	
	var msg = "<mink:message code='mink.web.alert.is.save'/>";
	// 겸직인 경우
	if(0 < $("#userGroupTd").find(".addedUserGroupSpan").length) {
		var preAdminYn = $(":input[name='preAdminYn']").val();
		var isCheckedSuperAdmin = $(":radio[name='adminYn']", "#userDetailFrm").filter(":radio[title='superAdmin']").get(0).checked;
		
		// 이전 권한이 슈퍼관리자 권한이 아닌 경우
		if('Y' != preAdminYn) {
			// 슈퍼관리자 권한을 선택한 경우
			if(isCheckedSuperAdmin) {
				msg +=  "<mink:message code='mink.web.text.user.message9'/>";
			}
		}
		// 이전 권한이 슈퍼관리자 권한인 경우
		if('Y' == preAdminYn) {
			// 다른 권한으로 변경하는 경우 타 그룹의 권한이 모두 취소됨
			if(false == isCheckedSuperAdmin) {
				msg += "\n\n" + "<mink:message code='mink.web.text.user.message10'/>" + "\n" + "<mink:message code='mink.web.text.user.message93'/>";
			}
		}
	}
	
	if(!confirm(msg)) return;
	ajaxComm('userUpdate.miaps?', userDetailFrm, function(data){
		resultMsg(data.msg);
		
		var grpId = userDetailFrm["userGroupMember.grpId"].value;
		
		var isUnclassified = false;
		var isCorporation = false;
		if( "${unclassified}" == grpId ) isUnclassified = true;
		if( "${corporation}" == grpId ) isCorporation = true;
		
		if( isUnclassified || isCorporation ) grpId = '';
		
		userDetailFrm["userGroupMember.grpId"].value = grpId;
		
		// 겸직인 경우
		if(0 < $("#userGroupTd").find(".addedUserGroupSpan").length) {
			if( "${corporation}" == searchFrm.searchUserGroupId.value ) { // root(전체)검색인 경우
				if( isUnclassified ) {
					var multiGrpId = $(":input[name='multiGrpId']").eq(0).val();
					grpId = multiGrpId;
				}
			}
		}
		
		$(":input[name='grpId']").val(grpId); // 상세 사용자 그룹ID
		
		goUserListByPage(searchFrm.pageNum.value); // 목록/검색
		
		$("#userModiDialog").dialog( "close" );
	});
}

//비밀번호 초기화
function userUpdateUserPwInit() {
	// 알림말
	var alertText = "<mink:message code='mink.web.text.user.message11'/>" + "\n" + "<mink:message code='mink.web.text.user.message12'/>"
					+ "\n\n" + "<mink:message code='mink.web.text.user.message13'/>";
	
	if(!confirm(alertText)) return;
	$.post('userUpdateUserPwInit.miaps?', {userNo: document.userDetailFrm.userNo.value, userId: document.userDetailFrm.userId.value, updNo: document.userDetailFrm.updNo.value}, function(data){
		resultMsg(data.msg);
	}, 'json');
}


<%-- 겸직 사용자그룹 삭제 --%>
function removeUserGroup(grpId, userNo) {
	if(!confirm("<mink:message code='mink.web.alert.is.delete'/>")) return;
	
	if(grpId == $(":input[name='grpId']").val()) {
		var multiGrpId = $(":input[name='multiGrpId']").eq(0).val();
		$(":input[name='grpId']").val(multiGrpId);
		
		if( searchFrm.searchUserGroupId.value != '${corporation}' ) { // root(전체)검색이 아닌 경우
			searchFrm.userNo.value = ''; // (삭제한)상세 비움
		}
	}
	
	var selectedGrpId = $("#userGroupTd").find("input[name='userGroupMember.grpId']").val();
	//alert(selectedGrpId);
	$.post('userGroupMemberDelete.miaps?', {preGrpId : grpId, userNo : userNo, grpId : selectedGrpId}, function(data){
		resultMsg(data.msg);
		//goUserListByPage(searchFrm.pageNum.value); // 목록/검색
		userDetail(data.reqParam.userNo, data.reqParam.grpId);
		
	}, 'json');
}

<%--
 메일서버 이름변경, userEmailRegDialog.jsp, userEmailModiDialog.jsp 에서 사용. 
--%>
function changeMailserverId(s, form) {
	if(s.value != '') {
		$.post('../mail/mailserverDetail.miaps?', {mailserverId: s.value}, function(data){
			var $frm = $("#" + form);
			
			$frm.find("input[name='serverType']").val(nvl(data.mailserver.serverType));
			$frm.find("input[name='protocol']").val(nvl(data.mailserver.protocol));
			$frm.find("input[name='description']").val(nvl(data.mailserver.description));
			$frm.find("input[name='outServer']").val(nvl(data.mailserver.outServer));
			$frm.find("input[name='sslout'][value=" + nvl(data.mailserver.sslout) + "]").get(0).checked = true;
			$frm.find("input[name='outPort']").val(nvl(data.mailserver.outPort));
			$frm.find("input[name='outAuth'][value=" + nvl(data.mailserver.outAuth) + "]").get(0).checked = true;
			$frm.find("input[name='inServer']").val(nvl(data.mailserver.inServer));
			$frm.find("input[name='sslin'][value=" + nvl(data.mailserver.sslin) + "]").get(0).checked = true;
			$frm.find("input[name='inPort']").val(nvl(data.mailserver.inPort));
			$frm.find("input[name='inboxName']").val(nvl(data.mailserver.inboxName));
			$frm.find("input[name='inboxActive'][value=" + nvl(data.mailserver.inboxActive) + "]").get(0).checked = true;
			$frm.find("input[name='outboxName']").val(nvl(data.mailserver.outboxName));
			$frm.find("input[name='outboxActive'][value=" + nvl(data.mailserver.outboxActive) + "]").get(0).checked = true;
			$frm.find("input[name='sentName']").val(nvl(data.mailserver.sentName));
			$frm.find("input[name='sentActive'][value=" + nvl(data.mailserver.sentActive) + "]").get(0).checked = true;
			$frm.find("input[name='draftsName']").val(nvl(data.mailserver.draftsName));
			$frm.find("input[name='draftsActive'][value=" + nvl(data.mailserver.draftsActive) + "]").get(0).checked = true;
			$frm.find("input[name='trashName']").val(nvl(data.mailserver.trashName));
			$frm.find("input[name='trashActive'][value=" + nvl(data.mailserver.trashActive) + "]").get(0).checked = true;
			$frm.find("input[name='outLogin']").val(nvl(data.mailserver.outLogin));
			$frm.find("input[name='outPassword']").val(nvl(data.mailserver.outPassword));
			$frm.find("input[name='lastWatchTime']").val(nvl(data.mailserver.lastWatchTime));
		}, 'json');
	}
}

/* 호출하는곳에 넣을 코드
  ajaxComm('userDetail.miaps?', parent.document.userDetailFrm, parent.callbackUserDetailDialog);
 */
function callbackUserDetailDialog(data) {
	hideLoading();
	
	var dto = data.user;
	
	var frm = $("#userDetailFrm");
	
	frm.find("input[name='userNo']").val(dto.userNo);
	frm.find("input[name='userId']").val(dto.userId);
	frm.find("input[name='userPw']").val(dto.userPw);
	frm.find("input[name='passQuest']").val(dto.passQuest);
	frm.find("input[name='passAnsw']").val(dto.passAnsw);
	frm.find("input[name='passCnt']").val(dto.passCnt);
	frm.find("input[name='userNm']").val(dto.userNm);
	frm.find("input[name='userNmOri']").val(dto.userNm);
	frm.find("input[name='emailAddr']").val(dto.emailAddr);
	frm.find("input[name='phoneNo1']").val(dto.phoneNo1);
	frm.find("input[name='phoneNo2']").val(dto.phoneNo2);
	frm.find("input[name='deleteYn']").val(dto.deleteYn);
	frm.find("input[name='regNo']").val(dto.regNo);
	frm.find("input[name='regDt']").val(getDateTimeFmt(dto.regDt));
	frm.find("input[name='updDt']").val(getDateTimeFmt(dto.updDt));
	frm.find("input[name='licenseId']").val(dto.licenseId);
	//$(":input[name='updNo']").val(dto.updNo);
	//$(":input[name='adminYn']").val(dto.adminYn);
	if('${ynYes}' == dto.adminYn) {
		$(":radio[name='adminYn']", "#userDetailFrm").filter(":radio[title='superAdmin']").get(0).checked = true;
	}
	else {
		$(":radio[name='adminYn']", "#userDetailFrm").filter(":radio[title='user']").get(0).checked = true;
		if(null != dto.userGroupMember && '${ynYes}' == dto.userGroupMember.adminYn) {
			$(":radio[name='adminYn']", "#userDetailFrm").filter(":radio[title='subAdmin']").get(0).checked = true;
		}
	}
	
	if(null != dto.userGroup) {
		frm.find("input[name='grpId']").val(dto.userGroup.grpId); // 상세 사용자 그룹ID
		frm.find("input[name='userGroupMember.grpId']").val(dto.userGroup.grpId);
		frm.find("input[name='userGroup.grpNm']").val(dto.userGroup.grpNm);
		frm.find("input[name='userGroupMember.preGrpId']").val(dto.userGroup.grpId);
		frm.find("input[name='userGroup.grpNavigation']").val(dto.userGroup.grpNavigation); // 상세 사용자 그룹 네비게이션
		$("#detailUserGroupSpan").find("span").html(dto.userGroup.grpNavigation); // 상세 사용자 그룹 네비게이션
	}
	
	// 이전 권한저장
	var preAdminYn = ''; // 일반사용자
	if('${ynYes}' == dto.adminYn) {
		preAdminYn = 'Y'; // 슈퍼관리자
	}
	else {
		if(null != dto.userGroupMember && '${ynYes}' == dto.userGroupMember.adminYn) {
			preAdminYn = 'N'; // 그룹관리자
		}
	}
	frm.find("input[name='preAdminYn']").val(preAdminYn);
	
	// 겸직 사용자그룹 정보
	$("#userGroupTd").find(".addedUserGroupSpan").remove();
	if(null != dto.userGroupList && 0 < dto.userGroupList.length) {
		for(var i = 0; i < dto.userGroupList.length; i++) {
			var html = "";
			html += "<span class='addedUserGroupSpan'>";
			html += "<br />"+dto.userGroupList[i].grpNavigation;
			html += "<input type='hidden' name='multiGrpId' value='"+dto.userGroupList[i].grpId+"' />";
			html += "</span>";
			html += " <span class='addedUserGroupSpan'>";
			html += " <button class='btn-dash' onclick=\"removeUserGroup('"+dto.userGroupList[i].grpId+"', '"+dto.userNo+"')\"><mink:message code='mink.web.text.delete'/></button>";
			html += " </span>";
			$("#userGroupTd").append(html);
		}
	}
	// 겸직 사용자그룹 추가버튼 숨김/보이기
	$("#addUserGroupMemberSearchUserGroupTreeviewDialogOpenerButton").hide();
	if(null != dto.userGroup && null != dto.userGroup.grpId) {
		$("#addUserGroupMemberSearchUserGroupTreeviewDialogOpenerButton").show();
	}
	
	// 관리자권한위임
	$("#userRoleDelegateGiverTitleSpan").html("<c:out value='${loginUser.userNm}'/>" + "(<c:out value='${loginUser.userId}'/>)"); // 위임자 정보
	$("#userRoleDelegateTargetTitleSpan").html(defenceXSS(dto.userNm) + "(" + defenceXSS(dto.userId) + ")"); // 위임 받는 자 정보
	$("#editUserRoleDelegateSpan").show(); // 권한위임관리 버튼 보이기
	if(null != dto.userRoleDelegate) {
		
		// 위임자 정보
		$.post('userNoDetail.miaps?', {userNo: dto.userRoleDelegate.userNo}, function(data){
			$("#userRoleDelegateUserSpan").html("<a href=\"javascript: void(0);\" onclick=\"javascript:showSearchUserDetailDialog('" + data.user.userNo + "');\">" + defenceXSS(data.user.userNm) + "</a>");
			$("#userRoleDelegateGiverTitleSpan").html(data.user.userNm + "(" + data.user.userId + ")");
		}, 'json');
		
		// 위임기간
		var delegDate = dto.userRoleDelegate.startDt + " ~ " + dto.userRoleDelegate.endDt;
		
		// 위임현황
		var delegState = "";
		if( new Date(dto.userRoleDelegate.startDt).getTime() <= new Date(getToday()) ) delegState = "<mink:message code='mink.web.text.delegating'/>";
		else delegState = "<mink:message code='mink.web.text.delegate.reserved'/>";
		
		$("#userRoleDelegateDateSpan").text(delegDate); // 위임기간
		$("#userRoleDelegateStateSpan").text(delegState); // 위임현황
		
		$("#existUserRoleDelegateSpan").show();
		$("#emptyUserRoleDelegateSpan").hide();
		
		$("#editUserRoleDelegateDialog").find(":input[name='delegId']").val(dto.userRoleDelegate.delegId);
		$("#editUserRoleDelegateDialog").find(":input[name='startDt']").val(dto.userRoleDelegate.startDt);
		$("#editUserRoleDelegateDialog").find(":input[name='endDt']").val(dto.userRoleDelegate.endDt);
		
		$("#cancelUserRoleDelegateSpan").show();
		
		// 그룹관리자는 자신이 위임한 정보만 관리함
		if( "${ynYes}" == "${loginUser.userGroupMember.adminYn}" ) {
			if( dto.userRoleDelegate.userNo != "${loginUser.userNo}" ) {
				$("#editUserRoleDelegateSpan").hide(); // 권한위임관리 버튼 숨기기
				$("#cancelUserRoleDelegateSpan").hide(); // 위임취소 버튼 숨기기
			}
		}
	}
	else {
		$("#emptyUserRoleDelegateSpan").show();
		$("#existUserRoleDelegateSpan").hide();
		
		$("#editUserRoleDelegateDialog").find(":input[name='delegId']").val("");
		$("#editUserRoleDelegateDialog").find(":input[name='startDt']").val("");
		$("#editUserRoleDelegateDialog").find(":input[name='endDt']").val("");
		
		$("#cancelUserRoleDelegateSpan").hide();
	}
	
	// 메일계정 정보 설정
	mailInfoSetting(data);
	
	// 사용자 장치 설정
	userDeviceList(data);

	openUserModiDialog();
};

function mailInfoSetting(data) {
	
	var dto = data.user;
	
	// 메일계정 목록
	$("#emailAccountFrmListTbody > tr").remove(); // tbody 비우기
	if(null != dto.emailAccountList && 0 < dto.emailAccountList.length) {
		// tfoot 숨기기
		$("#emailAccountFrmListTfoot").hide();
		
		var html = "";
		for(var i = 0; i < dto.emailAccountList.length; i++) {
			html += "<tr>";
			
			html += "<td>";
			var defaultMail = nvl(dto.emailAccountList[i].defaultMail);
			var defaultMailInfo = "";
			if ("Y" == defaultMail) defaultMailInfo = "<mink:message code='mink.web.text.basic'/>";
			html += defaultMailInfo; // 기본계정여부
			html += "</td>";
			
			html += "<td>";
			html += nvl(defenceXSS(dto.emailAccountList[i].msAddress)); // 이메일주소
			html += "</td>";
			
			html += "<td>";
			html += nvl(dto.emailAccountList[i].protocol); // 프로토콜
			html += "</td>";
			
			html += "<td>";
			html += nvl(dto.emailAccountList[i].outServer); // 보내는서버주소
			html += "</td>";
			
			html += "<td>";
			html += nvl(dto.emailAccountList[i].outPort); // 보내는서버포트
			html += "</td>";
			
			html += "<td>";
			html += nvl(dto.emailAccountList[i].inServer); // 받는서버주소
			html += "</td>";
			
			html += "<td>";
			html += nvl(dto.emailAccountList[i].inPort); // 받는서버포트
			html += "</td>";
			
			html += "</tr>";
		}
		
		// tbody 채우기
		$("#emailAccountFrmListTbody").html(html);
		
		$("#emailAccountFrmListTbody > tr").each(function(idx, tr){
			$(tr).bind("click", function(e){
				var result = dto.emailAccountList[idx];
				var $frm = $("#emailAccountModiFrm"); <%-- userEmailModiDialog.jsp의 form --%>
				
				$frm.find("input[name='accountId']").val(nvl(result.accountId));
				$frm.find("input[name='userNo']").val(nvl(result.userNo));
				$frm.find("input[name='defaultMail'][value=" + nvl(result.defaultMail) + "]").get(0).checked = true;
				$frm.find("input[name='msAddress']").val(nvl(result.msAddress));
				$frm.find("input[name='msLogin']").val(nvl(result.msLogin));
				//$frm.find("input[name='msPassword']").val(nvl(result.msPassword));
				//$frm.find("input[name='msPassword']").attr("readonly", "readonly").val("");
				$frm.find("input[name='msPassword']").attr("readonly", "readonly").attr("autocomplete","off").val("") // 보안취약점으로 인해 수정 - 20200421 윤다혜
				var mailserverIdObj = $frm.find("select[name='mailserverId']").get(0);
				mailserverIdObj.value = nvl(result.mailserverId);
				$frm.find("input[name='serverType']").val(nvl(result.serverType));
				$frm.find("input[name='protocol']").val(nvl(result.protocol));
				$frm.find("input[name='push'][value=" + nvl(result.push) + "]").get(0).checked = true;
				$frm.find("input[name='description']").val(nvl(result.description));
				$frm.find("input[name='outServer']").val(nvl(result.outServer));
				$frm.find("input[name='sslout'][value=" + nvl(result.sslout) + "]").get(0).checked = true;
				$frm.find("input[name='outPort']").val(nvl(result.outPort));
				$frm.find("input[name='outAuth'][value=" + nvl(result.outAuth) + "]").get(0).checked = true;
				$frm.find("input[name='inServer']").val(nvl(result.inServer));
				$frm.find("input[name='sslin'][value=" + nvl(result.sslin) + "]").get(0).checked = true;
				$frm.find("input[name='inPort']").val(nvl(result.inPort));
				$frm.find("input[name='inboxName']").val(nvl(result.inboxName));
				$frm.find("input[name='inboxActive'][value=" + nvl(result.inboxActive) + "]").get(0).checked = true;
				$frm.find("input[name='outboxName']").val(nvl(result.outboxName));
				$frm.find("input[name='outboxActive'][value=" + nvl(result.outboxActive) + "]").get(0).checked = true;
				$frm.find("input[name='sentName']").val(nvl(result.sentName));
				$frm.find("input[name='sentActive'][value=" + nvl(result.sentActive) + "]").get(0).checked = true;
				$frm.find("input[name='draftsName']").val(nvl(result.draftsName));
				$frm.find("input[name='draftsActive'][value=" + nvl(result.draftsActive) + "]").get(0).checked = true;
				$frm.find("input[name='trashName']").val(nvl(result.trashName));
				$frm.find("input[name='trashActive'][value=" + nvl(result.trashActive) + "]").get(0).checked = true;
				$frm.find("input[name='outLogin']").val(nvl(result.outLogin));
				//$frm.find("input[name='outPassword']").val(nvl(result.outPassword));
				//$frm.find("input[name='outPassword']").attr("readonly", "readonly").val("");
				$frm.find("input[name='outPassword']").attr("readonly", "readonly").attr("autocomplete","off").val(""); // 보안취약점으로 인해 수정 - 20200421 윤다혜
				$frm.find("input[name='lastWatchTime']").val(nvl(result.lastWatchTime));
				/* $frm.find("input[name='regNo']").val(nvl(result.regNo));
				$frm.find("input[name='regDt']").val(nvl(result.regDt)); */
				
				<%--
				$("#emailAccountFrmInsertBtn").hide();
				$("#emailAccountFrmUpdateBtn").show();
				$("#emailAccountFrmDeleteBtn").show();
				
				if($frm.is(":hidden")) {
					callResize2("#emailAccountFrm"); // 부모창 스크롤 늘림
				}
				--%>
				checkedTrCheckbox(tr); // 목록 tr 선택
				
				<%-- $frm.show(); --%>
				
				openUserEmailModiDialog();
			});
		});
	}
	else {
		// tfoot 보이기
		$("#emailAccountFrmListTfoot").show();
	}
}

// 사용자 장치 다이얼로그
function userDeviceList(data) {
	var userDeviceList = data.userDeviceList;

	$("#userDeviceDetail").dialog('close');
	$("#userDeviceDialogTb > tbody > tr").remove();
	if( userDeviceList.length > 0 ) {	<%-- 결과 목록이 있을 경우 --%>
		for(var i = 0; i < userDeviceList.length; i++) {
			var newRow = $("#userDeviceDialogTb > thead > tr").clone(); <%-- head row 복사 --%>

			var lastAccessDt = userDeviceList[i].lastAccessDt;
			var deviceId = userDeviceList[i].deviceId;
			var deviceTp = userDeviceList[i].deviceTp;
			var modelNo = userDeviceList[i].modelNo;
			var osTp = userDeviceList[i].osTp;
			var osNm = userDeviceList[i].osNm;
			var osVersion = userDeviceList[i].osVersion;
			var phoneNo = defenceXSS(userDeviceList[i].phoneNo);
			var wifiMacAddr = userDeviceList[i].wifiMacAddr;
			var btMacAddr = userDeviceList[i].btMacAddr;
			var activeSt = userDeviceList[i].activeSt;
			var deleteYn = userDeviceList[i].deleteYn;
			var regNm = userDeviceList[i].regNm;
			var regDt = userDeviceList[i].regDt;
			var updNo = userDeviceList[i].updNo;
			var updDt = userDeviceList[i].updDt;

			newRow.children().html("");	<%-- td 내용 초기화 --%>
			newRow.removeClass();
			newRow.find("td:eq(0)").html(lastAccessDt);
			newRow.find("td:eq(1)").attr("align", "left").html(deviceId);
			newRow.find("td:eq(2)").html(osTp);
			newRow.find("td:eq(3)").html(modelNo);
			var activeStInfo = "<mink:message code='mink.web.text.using'/>"; // 사용중(Y), 중지(N), 폐기(D)
			if (activeSt  == "N") activeStInfo = "<mink:message code='mink.web.text.stoped'/>";
			else if (activeSt  == "D") activeStInfo = "<mink:message code='mink.web.text.disposal'/>";
			newRow.find("td:eq(4)").html(activeStInfo);
			newRow.find("td:eq(4)").attr("id", "td_activeSt_" + deviceId); // 장치상태 변경시 수정을 위함
			newRow.attr("id", "tr_userDeviceList_" + deviceId); // 장치상태 변경시 수정을 위함

			// row에 data 담기
			newRow.data("lastAccessDt", lastAccessDt);
			newRow.data("deviceId", deviceId);
			newRow.data("deviceTp", deviceTp);
			newRow.data("modelNo", modelNo);
			newRow.data("osTp", osTp);
			newRow.data("osNm", osNm);
			newRow.data("osVersion", osVersion);
			newRow.data("phoneNo", phoneNo);
			newRow.data("wifiMacAddr", wifiMacAddr);
			newRow.data("btMacAddr", btMacAddr);
			newRow.data("activeSt", activeSt);
			newRow.data("deleteYn", deleteYn);
			newRow.data("regNm", regNm);
			newRow.data("regDt", regDt);
			newRow.data("updNo", updNo);
			newRow.data("updDt", updDt);

			// 목록 선택시 상세화면 보임
			newRow.bind("click", function(){
				checkedTrCheckbox($(this)); // 목록 tr 선택
				openUserDeviceDetailDialog($(this));
			});

			$("#userDeviceDialogTb > tbody").append(newRow);
		}
	} else {	<%-- 결과 목록이 없을 경우 --%>
		var emptyRow = "<tr><td colspan='5' align='center'><mink:message code='mink.web.text.noexist.result'/></td></tr>";
		$("#userDeviceDialogTb > tbody").append(emptyRow);
	}
	
	$("#userDeviceDialogFrm").find("input[name='pageNum']").val(data.search.pageNum);
	$("#userDeviceDialogFrm").find("input[name='userNo']").val(data.search.userNo);

	// 페이징 조건 재설정 후 페이징 html 생성
	showPageHtml2(data, $("#userDevicePaginateDiv"), "goUserDevice");
}

// 사용자 장치정보 조회
function goUserDevice(currPage) {
	$("#userDeviceDialogFrm").find("input[name='pageNum']").val(currPage); 
	ajaxComm('userDeviceList.miaps', $("#userDeviceDialogFrm").get(0), function(data){
		userDeviceList(data);
	});
}

function openUserModiDialog() {
	// 첫번째 탭 선택
	$("ul.tabs_appRole li:first").click();
	
	$("#userModiDialog").dialog( "open" );
	var height = $("#userModiDialog").outerHeight();
	$("#userModiDialog").dialog("option", "maxHeight", screen.height);
}

$(function(){
	$("#userModiDialog").dialog({
		autoOpen: false,
	    resizable: false,
	    width: '55%',
	    modal: true,
		// add a close listener to prevent adding multiple divs to the document
	    close: function(event, ui) {
	        // remove div with all data and events
	        $(this).dialog( "close" );
	    }
	});
});
</script>