<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="org.springframework.web.bind.annotation.SessionAttributes"%>
<%@ page import="com.thinkm.mink.commons.util.MinkConfig" %>
<%
	/*
	 * 앱 센터 로그인 화면 (commonAppLoginView.jsp)
	 * 
	 * @author eunkyu
	 * @since 2014.02.12
	 * @modify chlee 2015.03.26
	 */
%>
<html>
<head>
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="mink" uri="/WEB-INF/tld/mink.tld" %>
<%@ page import = "com.thinkm.mink.commons.MinkTotalConstants" %>
<%-- CODE Constants --%>
<c:set var="PLATFORM_IOS" value="<%=MinkTotalConstants.PLATFORM_IOS%>" />
<c:set var="PLATFORM_IOS_TBL" value="<%=MinkTotalConstants.PLATFORM_IOS_TBL%>" />
<c:set var="PLATFORM_ANDROID" value="<%=MinkTotalConstants.PLATFORM_ANDROID%>" />
<c:set var="PLATFORM_ANDROID_TBL" value="<%=MinkTotalConstants.PLATFORM_ANDROID_TBL%>" />
<c:set var="PLATFORM_WEB" value="<%=MinkTotalConstants.PLATFORM_WEB%>" />

<c:set var="protocol" value="http" />
<c:if test="<%=request.isSecure()%>">
<c:set var="protocol" value="https" />
</c:if>
<c:set var="searverName" value="${pageContext.request.serverName}" />
<c:set var="serverPort" value="${pageContext.request.serverPort}" />
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<c:set var="contextURL" value="${contextPath}" />

<%@ include file="/WEB-INF/jsp/include/wsACommonAppHeadScript.jsp" %>
<script type="text/javascript" src="<c:url value="/js/sha256.js"/>"></script>

<%-- CODE Constants --%>


<%-- <link href="${contextURL}/css/css01.css" rel="stylesheet" type="text/css" />
<link href="${contextURL}/css/menu.css"  rel="stylesheet" type="text/css" media="all"  /> --%>
<%-- <link rel="stylesheet" type="text/css" href="${contextURL}/css/screen.css" media="screen" /> --%>	


<title>App Center</title>

<script type="text/javascript">

$(function(){	
	init();	
	
	<%-- init()에서 platformCd가 ANDROID로 나오면 플랫폼을 다시 선택 하도록 한다. (폰/태블릿) --%>
	var chkAndroid = $("input[name='platformCd']").val();
	if ("${PLATFORM_ANDROID}" == chkAndroid) {
		$("#tr_platform_android").show();
	} else {
		$("#tr_platform_android").hide();
	}
		
	<%-- 유저No 비표시 --%>
	$("#tr_userno").css("display", "none");
		
	if(eval('${!empty msg}')) { <%-- 에러 알림말이 있는 경우 --%> 
		var loginFrm = document.loginFrm;
		loginFrm.userId.value = "<c:out value='${user.userId}'/>";
		loginFrm.userPw.value = "<c:out value='${user.userPw}'/>";
		loginFrm["userGroup.grpId"].value = "<c:out value='${user.userGroup.grpId}'/>";
	
		$("#loginFrm").find("select[name='android_platform_select']").val("<c:out value='${platformCd}'/>");
		$("#loginFrm").find("input[name='platformCd']").val("<c:out value='${platformCd}'/>");
		
		resultMsg("<c:out value='${msg}'/>");
	}
	
	<%-- 보안성 검토 (계정 정보 파악 가능성) - 20200331 --%>
	/* if("ERR_USER_DUPLICATION" == '${errCode}' || "ERR_INVALID_PW" == '${errCode}') { //userid가 중복이면 활성
		$("#tr_userno").css("display", "");
		getGrpUserNo();
	} */
	
	$("#userid").focus();
});

<%-- controller 결과 메시지 출력 --%>
function resultMsg(msg) {
	if( msg != null && msg != "" ) {
		alert(msg);
	}
}

<%-- 로그인 --%>
function goLogin() {
	var loginFrm = document.loginFrm;
	
	if(validation()) {
		return;
	}
<%
	String secureLogin = MinkConfig.getConfig().get("miaps.web.secure.login");
	if (secureLogin != null && "Y".equalsIgnoreCase(secureLogin)) {
%>
	loginFrm.userPw.value = SHA256(loginFrm.userPw.value);
<%}%>	
	loginFrm.action = 'commonAppLoginUserWelcome.miaps?';
	loginFrm.submit();
}

<%-- 엔터친 경우 로그인 --%>
function enterLogin(obj) {
	var loginFrm = document.loginFrm;
	
	if(loginFrm.userId === obj) {
		if(loginFrm.userId.value == '') return;
		if(loginFrm.userPw.value == '') {
			$(loginFrm.userPw).focus();
			return;
		} else {
			goLogin();
		}
	}
	if(loginFrm.userPw === obj) {
		if(loginFrm.userPw.value == '') return;
		if(loginFrm.userId.value == '') {
			$(loginFrm.userId).focus();
			return;
		} else {
			goLogin();
		}
	}
}

<%-- 검증(클라이언트) --%>
function validation() {
	var loginFrm = document.loginFrm;
	
	var answer = false;
	
	<%--
	if(loginFrm["userGroup.grpId"].value == '') {
		alert('소속그룹을 선택하세요!');
		$(loginFrm["userGroup.grpId"]).focus();
		return true;
	}
	--%>
	if(loginFrm.userId.value == '') {
		alert("<mink:message code='mink.web.alert.input.userid'/>");
		$(loginFrm.userId).focus();
		return true;
	}
	if(loginFrm.userPw.value == '') {
		alert("<mink:message code='mink.web.alert.input.password'/>");
		$(loginFrm.userPw).focus();
		return true;
	}
	
	return answer;
}

<%-- 유저ID와 그룹ID로 유저No를 취득하여 selectbox에 넣기 --%>
function getGrpUserNo() {
	if ($("#sel_group option:selected").val() == "NOT_USED") {
		<%-- 비활성일 경우 리턴 --%>
		return;
	}
	
	ajaxComm('commonAppSelectGroupUserNoList.miaps', $('#loginFrm'), function(data){
		fnSetUserNoMapping(data); <%-- callback function --%>
	});
}

<%-- ajax 로 가져온 data 를 알맞은 위치에 삽입: UserNo리스트 --%>
function fnSetUserNoMapping(result) {
	$("#grpUserNo option").each(function() {
		$(this).remove();
	});
	
	var resultList = result.userNoList;
	for(var i = 0; i < resultList.length; i++) {
		$("#grpUserNo").append("<option value=\"" + resultList[i].userNo + "\">" + resultList[i].userNo + "</option>");
	}
	
	var frm = $("#loginFrm");
	frm.find("select[name='grpUserNo']").val(result.userNo);
}

function onChangeAndroidPlatform() {
	var selectedVal = $("select[name=android_platform_select]").val();
	//console.log(selectedVal);
	$("input[name='platformCd']").val(selectedVal);
}
</script>

</head>
<body>

<form id="loginFrm" name="loginFrm" method="post" onSubmit="return false;">
	<input type="hidden" name="platformCd" />
	
	<div id="mobileWrap">
		<div style="height:6px; background-color: #2259ba;"></div>
		<div id="logtop" style="height:54px; background-color: #ffffff; line-height:54px; vertical-align: middle;">
			&nbsp;<img src="${contextURL}/app/images/m_appcenter_logo.png" width="208px" height="25px"/>
		</div>
		<div id="contentsWrap">	
			<input type="hidden" name="platformName" />
			
			<table class="applogin" width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr id="tr_platform_android" style="display: none;">
					<td width="95px;">
						<img src="${contextURL}/app/images/app_icon_platform.png" class="login_img_group_appcenter">&nbsp;<b><span style="vertical-align: middle;">Platform</span></b>
					</td>
					<td>
						<select name="android_platform_select" id="android_platform_select" class="applogin_selectbox" onchange="javascript:onChangeAndroidPlatform()">
							<option value="${PLATFORM_ANDROID}">Android Phone</option>
							<option value="${PLATFORM_ANDROID_TBL}">Android Tablet</option>							
						</select>
					</td>
				</tr>
				<tr>
					<td width="95px;">
						<img src="${contextURL}/app/images/app_group_icon.png" class="login_img_group_appcenter">&nbsp;<b><span style="vertical-align: middle;">Group</span></b>
					</td>
					<td>
						<c:if test="${loginMethod == 'top_group'}">
		              		<c:if test="${grpNaviList == null || fn:length(grpNaviList) == 0}"> <!-- 유저ID중복 전, 최상위그룹 표시 -->
			                	<select name="userGroup.grpId" class="applogin_selectbox">
									<option value=""><mink:message code="mink.web.text.select.group"/></option>
									<c:forEach var="dto" items="${userGroupTopList}" varStatus="i">
										<option value="${dto.grpId}" ${dto.grpId == user.userGroup.grpId ? 'selected' : ''}>${dto.grpNm}</option>
									</c:forEach>
								</select>
				            </c:if>
				            <c:if test="${grpNaviList != null && fn:length(grpNaviList) > 0}"> <!-- 유저ID중복 후, 중복된 유저의 그룹네비게이션 표시 -->
			                	<select id="sel_group" name="userGroup.grpId" onchange="javascript:getGrpUserNo()" class="applogin_selectbox">
									<c:forEach var="dto" items="${grpNaviList}" varStatus="i">
										<option value="${dto.grpId}">${dto.grpNavigation}</option>
									</c:forEach>
								</select>
			                </c:if>
		              	</c:if>
		              	<c:if test="${loginMethod == 'navi_group'}">
							<c:if test="${grpNaviList == null || fn:length(grpNaviList) == 0}">
		                	<select id="sel_group" name="userGroup.grpId" class="applogin_selectbox">
		                		<option value=""><mink:message code="mink.web.text.duplicateid"/></option>
		                	</select>
			                </c:if>
			                <c:if test="${grpNaviList != null && fn:length(grpNaviList) > 0}">
			                	<select id="sel_group" name="userGroup.grpId" onchange="javascript:getGrpUserNo()" class="applogin_selectbox">
			                		<c:forEach var="dto" items="${grpNaviList}" varStatus="i">
										<option value="${dto.grpId}">${dto.grpNavigation}</option>
									</c:forEach>
								</select>
			                </c:if>
			            </c:if> 
					</td>
				</tr>
				<tr id="tr_userno">
					<td width="95px;">
						<img src="${contextURL}/app/images/app_user_icon_no.png" class="login_img_group_appcenter">&nbsp;<b><span style="vertical-align: middle;">User No</span></b>
					</td>
					<td>
						<select id="grpUserNo" name="userNo" class="applogin_selectbox">
						</select>
					</td>
				</tr>
				<tr>
					<td width="95px;">
						<img src="${contextURL}/app/images/app_user_icon_id.png" class="login_img_group_appcenter">&nbsp;<b><span style="vertical-align: middle;">User ID</span></b>
					</td>
					<td>
						<input name="userId" type="text" id="userid" onkeypress="if(event.keyCode == 13) enterLogin(this);" style="ime-mode:inactive; padding: 10px; width:100%; margin-right: 2%; font-size: 16px;">
					</td>
				</tr>
				<tr>
					<td width="95px;">
						<img src="${contextURL}/app/images/app_pw_icon.png" class="login_img_group_appcenter">&nbsp;<b><span style="vertical-align: middle;">Password</span></b>
					</td>
					<td>
						<input name="userPw" type="password" id="userpassword" autocomplete="off" onkeypress="if(event.keyCode == 13) enterLogin(this);" style="padding: 10px; width:100%; margin-right: 2%; font-size: 16px;">
					</td>
				</tr>			
			</table>
			<br/>
			<div align="center"><div class="applogin_button" onclick="javascript:goLogin();"><mink:message code="mink.web.text.login"/></div></div>							
		</div>		
	</div>
	<div id="footerWrap" >
		<div style="color: #929292; font: 9px sans-serif; text-align: center;"><p class="copy">Copyright ⓒ 2016 ThinkM All rights reserved.</p></div>		
		<div style="color: #005abb; font: smaller sans-serif; text-align: center;"><p><font color="blue"><mink:message code="mink.web.message6"/></font></p></div>		
	</div>
</form>

<%-- 임시 테스트 사용자 시작 --%>
<%-- <div>
	***easy Login User***
	<br /><a href="javascript:goLogin2('1');">[솔루션사업부]슈퍼관리자</a>
	<br /><a href="javascript:goLogin2('2');">[솔루션사업부]일반관리자</a>
	<br /><a href="javascript:goLogin2('3');">[솔루션사업부]사용자</a>
</div>
<script type="text/javascript">
function goLogin2(userNo) {
	var loginFrm = document.loginFrm;
	loginFrm.userNo.value = userNo;
	
	loginFrm.action = 'commonLoginUserWelcome.miaps?';
	loginFrm.submit();
	/*
	ajaxComm('commonLoginUserWelcome.miaps?', loginFrm, function(data){
		if('' == data.msg) {
			location.href = 'commonMainView.miaps?';
		}
		else {
			alert(data.msg);
		}
	});
	*/
}
</script> --%>
<%-- 임시 테스트 사용자 끝 --%> 
</body>
</html>
