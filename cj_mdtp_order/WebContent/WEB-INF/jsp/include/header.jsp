<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="mink" uri="/WEB-INF/tld/mink.tld" %>
<%@ page import = "com.thinkm.mink.commons.MinkTotalConstantsProperties" %>
<c:set var="superAdmin" value="<%=MinkTotalConstantsProperties.SUPER_ADMIN_ROLE_NAME%>" /><!-- 권한명: 슈퍼관리자 -->
<c:set var="subAdmin" value="<%=MinkTotalConstantsProperties.SUB_ADMIN_ROLE_NAME%>" /><!-- 권한명: 그룹관리자 -->
<c:set var="commUser" value="<%=MinkTotalConstantsProperties.COMM_USER_ROLE_NAME%>" /><!-- 권한명: 일반사용자 -->

<c:set var="adminName" value="" />
<c:if test="${ynYes == loginUser.adminYn}">
<c:set var="adminName" value="${superAdmin}" />
</c:if>
<c:if test="${ynNo == loginUser.adminYn}">
<c:set var="adminName" value="${commUser}" />
<c:if test="${ynYes == loginUser.userGroupMember.adminYn}">
<c:set var="adminName" value="${subAdmin}" />
</c:if>
</c:if>

<script type="text/javascript">
function toggleLeftMenu() {
	<%-- 이미지 버튼 빙글 돌리기 --%>
	if($("#rotate_btn").hasClass("rotate_90")) {
		$("#rotate_btn").removeClass("rotate_90");
	} else {
		$("#rotate_btn").addClass("rotate_90");	
	}
	
	<%--  get effect type from --%>
	var selectedEffect = 'slide'
	
	<%--  most effect types need no options passed by default --%>
	var options = {};
	options = {left: 0};
	
	<%--  run the effect : bToggle 전역변수와 sideMenuToggleCallback()는 admincenterCommon.js의 최상단에 정의되어 있습니다. chlee --%>
	$("#miaps-sidebar").toggle( selectedEffect,  200, sideMenuToggleCallback);
}
</script>

<div class="topContent">
	<div class="leftTopUserInfo">
		<table border="0" style="width:100%;"><tr>
			<td style="width:70px;"><img style="padding-left: 10px; padding-top: 10px;" src="${contextURL}/asvc/images/admin_img_usercircle.png" border="0"></td>
			<td><a class="loginUserLink" id="loginUserDetailDialogOpener" class="loginUserLink" onclick="showLoginUserDetailDialog()">${loginUser.userNm}<br/>(${loginUser.userId})</a></td>
		</tr></table>
		<span class="rotate_img">
			<img id="rotate_btn" class="roate_stop" src="${contextURL}/asvc/images/admin_img_folding.png" border="0" onclick="javascript:toggleLeftMenu();">
		</span>
	</div>
	<div class="logoContent">
		<img src="${contextURL}/asvc/images/admin_logo.png" border="0" onclick="location.href='${contextURL}/asvc/common/commonMainView.miaps?'">
	</div>
	
	 <div id="topMenuTile" class="menuTitle">
	 </div>
</div>
<div style="clear: both;"></div>

<div id="loginUserDetailDialog" title="<mink:message code='mink.web.text.login'/> <mink:message code='mink.web.text.info.user'/>" class="dlgStyle">
<div class="miaps-popup-top-buttons">
	&nbsp;
	<span><button class='btn-dash' onclick="location.href='${contextURL}/asvc/common/commonLogout.miaps?'"><mink:message code='mink.label.logout'/></button></span>
	<span><button id="btn_change_pw" class='btn-dash' onclick="javascript:showLoginUserPassWordDialog();"><mink:message code='mink.web.text.user.change.password'/></button></span>
	<span><button class='btn-dash' onclick="javascript:$('#loginUserDetailDialog').dialog('close');"><mink:message code='mink.web.text.close'/></button></span>
</div>
	<table class="detailTb" border="0" cellspacing="0" cellpadding="7" width="100%">
		<colgroup>
			<col width="30%" />
			<col width="70%" />
		</colgroup>
		<tbody>
			<tr>
				<th><mink:message code='mink.label.user'/>NO</th>
				<td>${loginUser.userNo}</td>
			</tr>
			<tr>
				<th><mink:message code='mink.label.user'/>ID</th>
				<td>${loginUser.userId}</td>
			</tr>
			<tr>
				<th><mink:message code='mink.label.user_name'/></th>
				<td>${loginUser.userNm}</td>
			</tr>
			<tr>
				<th><mink:message code='mink.label.group_name'/></th>
				<td>${loginUser.userGroup.grpNavigation}</td>
			</tr>
			<tr>
				<th><mink:message code='mink.label.permission'/></th>
				<td>${adminName}</td>
			</tr>
			<tr>
				<th><mink:message code='mink.web.text.resp.pnumber'/></th>
				<td>${loginUser.phoneNo1}</td>
			</tr>
			<tr>
				<th><mink:message code='mink.label.phone_number'/></th>
				<td>${loginUser.phoneNo2}</td>
			</tr>
			<tr>
				<th>e-mail</th>
				<td>${loginUser.emailAddr}</td>
			</tr>
			<tr>
				<th><mink:message code='mink.label.license'/></th>
				<td>${loginUser.licenseId}</td>
			</tr>
		</tbody>
		<tfoot></tfoot>
	</table>
</div>

<div id="loginUserPassWordDialog" title="<mink:message code='mink.web.text.password'/> <mink:message code='mink.web.text.user.modify'/>" class="dlgStyle">
<div class="miaps-popup-top-buttons">
	&nbsp;
	<span><button class='btn-dash' onclick="javascript:changePw();"><mink:message code="mink.label.save"/></button></span>
	<span><button class='btn-dash' onclick="javascript:$('#loginUserPassWordDialog').dialog('close');"><mink:message code='mink.label.cancel'/></button></span>
</div>
	<form id="loginUserPasswordFrm" name="loginUserPasswordFrm" method="post" onSubmit="return false;">
	<input type="hidden" name="userNo" value="${loginUser.userNo}" />
	<input type="hidden" name="updNo" value="${loginUser.userNo}" />
	
	<table id="loginUserPassWordTb" class="detailTb" border="0" cellspacing="0" cellpadding="0" width="100%">
		<colgroup>
			<col width="35%" />
			<col width="65%" />
		</colgroup>
		<tbody>
			<tr>
				<th>
					<mink:message code="mink.web.text.setting.current"/>&nbsp;<mink:message code="mink.web.text.password"/>					
				</th>
				<td>
					<input type="password" name="preUserPw" />
				</td>
			</tr>
			<tr>
				<th>
					<mink:message code="mink.web.text.user.modify"/>&nbsp;<mink:message code="mink.web.text.password"/>	
				</th>
				<td>
					<input type="password" name="userPw" />
				</td>
			</tr>
			<tr>
				<th>
					<mink:message code="mink.web.text.user.modify"/>&nbsp;<mink:message code="mink.web.text.user.passwordquiz"/>
				</th>
				<td>
					<input type="text" name="passQuest" />
				</td>
			</tr>
			<tr>
				<th>
					<mink:message code="mink.web.text.user.modify"/>&nbsp;<mink:message code="mink.web.text.user.passwordanswer"/>
				</th>
				<td>
					<input type="text" name="passAnsw" />
				</td>
			</tr>
		</tbody>
	</table>
	</form>
</div>

<script type="text/javascript">
// 로그인 사용자 정보 팝업 나타나기
function showLoginUserDetailDialog() {
	$( "#loginUserDetailDialog" ).dialog( "open" );
}

// 비밀번호 변경 팝업 나타나기
function showLoginUserPassWordDialog() {
	$(":input", "#loginUserPassWordTb").val(""); // 입력창 초기화
	
	$( "#loginUserPassWordDialog" ).dialog( "open" );
}

function changePw() {
	var pwFrm = document.loginUserPasswordFrm;
	
	// 비밀번호 변경
	if(pwFrm.preUserPw.value == '') {
		alert('<mink:message code="mink.web.text.user.change.password.msg.01"/>');
		$(pwFrm.preUserPw).focus();
		return;
	}
	if(pwFrm.userPw.value == '') {
		alert('<mink:message code="mink.web.text.user.change.password.msg.02"/>');
		$(pwFrm.userPw).focus();
		return;
	} else {
		if( checkPwd($(pwFrm.userPw)) ) {
			return;
		}
	}
	if(pwFrm.passQuest.value == '') {
		alert('<mink:message code="mink.web.text.user.change.password.msg.04"/>');
		$(pwFrm.passQuest).focus();
		return;
	}
	if(pwFrm.passAnsw.value == '') {
		alert('<mink:message code="mink.web.text.user.change.password.msg.05"/>');
		$(pwFrm.passAnsw).focus();
		return;
	}
	
	if ($(pwFrm.passQuest).val() == $(pwFrm.passAnsw).val()) {
		alert('<mink:message code="mink.web.text.user.change.password.msg.06"/>');
		$(pwFrm.passAnsw).focus();
		return;
	}
	
	ajaxComm('../user/userUpdateUserPw.miaps?', pwFrm, function(data){
		resultMsg(data.msg);
		
		if(0 < data.result) { // 정상 변경 후 다이얼로그 닫기
			$( "#loginUserPassWordDialog" ).dialog( "close" );
		}
	});
}

<%-- 보안성 검토 (취약한 접근 통제 관리 - 패스워드 정책 유무 및 반영 여부) - 20200401 --%>
function checkPwd(password) {
	var cnt1 = 0; //동일문자 카운트
	var cnt2 = 0; //연속성(+) 카운드
	var cnt3 = 0; //연속성(-) 카운드
	
	var pwd1;
	var pwd2;
	
	for(var i = 0; i < password.val().length; i++) {
		pwd1 = password.val().charAt(i);
		pwd2 = password.val().charAt(i+1);
		
		//동일문자 카운트
		if(pwd1 == pwd2) {
			cnt1 = cnt1 + 1
		}
		//연속성(+) 카운드
		if(pwd1.charCodeAt(0) - pwd2.charCodeAt(0) == 1) {
			cnt2 = cnt2 + 1
		}
		//연속성(-) 카운드
		if(pwd1.charCodeAt(0) - pwd2.charCodeAt(0) == -1) {
			cnt3 = cnt3 + 1
		}
		
		if(cnt1 == 1 && pwd1 != pwd2) cnt1 = 0;
		if(cnt2 == 1 && pwd1.charCodeAt(0) - pwd2.charCodeAt(0) != 1) cnt2 = 0;
		if(cnt3 == 1 && pwd1.charCodeAt(0) - pwd2.charCodeAt(0) != -1) cnt3 = 0;
	}
	
	if(cnt1 > 1) {
		alert("<mink:message code='mink.message.alert.password.retry1'/>");
		password.focus();
		return true;
	}
	if(cnt2 > 1 || cnt3 > 1 )  {
		alert("<mink:message code='mink.message.alert.password.retry2'/>");
		password.focus();
		return true;
	}
	
	return false;
}

// 로그인 사용자 정보 다이얼로그 팝업
$( "#loginUserDetailDialog" ).dialog({
	autoOpen: false
	, width: 500
	, modal: true
	/*, buttons: {
		"확인": function() {
			$( this ).dialog( "close" );
        }
	}*/
	, position: { my: "left top", at: "left bottom", of: $("#loginUserDetailDialogOpener") }
});

// 비밀번호 변경 다이얼로그 팝업
$( "#loginUserPassWordDialog" ).dialog({
	autoOpen: false
	, width: 450
	, modal: true
	/*, buttons: {
		"선택": changePw,
		"취소": function() {
			$( this ).dialog( "close" );
        }
	}*/
	, position: { my: "left top", at: "left bottom", of: $("#btn_change_pw") }
});
</script>