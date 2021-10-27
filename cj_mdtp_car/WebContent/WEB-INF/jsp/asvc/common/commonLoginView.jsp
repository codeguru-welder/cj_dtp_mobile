<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="org.springframework.web.bind.annotation.SessionAttributes"%>
<%@ page import="com.thinkm.mink.commons.util.MinkConfig" %>
<%
	/*
	 * 어드민 센터 로그인 화면 (commonLoginView.jsp)
	 * 
	 * @author eunkyu
	 * @since 2014.02.12
 	 * @modify chlee 2015.03.26
 	 * @modify chlee 2016.02.15 새 디자인 적용
	 */
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="mink" uri="/WEB-INF/tld/mink.tld" %>
<%@ include file="/WEB-INF/jsp/include/wsACommonHeadScript.jsp" %>
<script type="text/javascript" src="<c:url value="/js/sha256.js"/>"></script>

<c:set var="protocol" value="http" />
<c:if test="<%=request.isSecure()%>">
<c:set var="protocol" value="https" />
</c:if>
<c:set var="searverName" value="${pageContext.request.serverName}" />
<c:set var="serverPort" value="${pageContext.request.serverPort}" />
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<c:set var="contextURL" value="${contextPath}" />

<link href="${contextURL}/css/css01.css" rel="stylesheet" type="text/css" />
<link href="${contextURL}/css/menu.css"  rel="stylesheet" type="text/css" media="all"  />

<style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
-->
</style>

<title><mink:message code="mink.label.page_title"/></title>

<script type="text/javascript">

$(function(){
	<%-- miaps-sidebar 표시하는 값으로 쿠키 설정 --%>
	$.cookie("sidebar_toggle", "block");
	//console.log("commonLoginView: get cookie value:" + $.cookie("sidebar_toggle"));
	
	<%-- 최초 그룹 선택 막기(navi_group일 경우) --%>
	if ('navi_group' == '${loginMethod}') {
		$("#sel_group").attr("disabled", "true");
		$("#img_group").attr("src", "${contextURL}/asvc/images/admin_group_icon_dis.png");
		$("#lable_group").css("color", "BCBCBC");
		$("#lable_group").css("drop-shadow", "FFFFFF");
	}
	
	if(eval('${!empty msg}')) { <%-- 에러 알림말이 있는 경우 --%> 
		var loginFrm = document.loginFrm;
		loginFrm.userId.value = "<c:out value='${user.userId}'/>";
		loginFrm.userPw.value = "<c:out value='${user.userPw}'/>";
		loginFrm["userGroup.grpId"].value = "<c:out value='${user.userGroup.grpId}'/>";
		resultMsg("<c:out value='${msg}'/>");
	}

	<%-- 보안성 검토 (계정 정보 파악 가능성) - 20200331 --%> 
	<%-- if('ERR_USER_DUPLICATION' == '${errCode}' || 'ERR_INVALID_PW' == '${errCode}') { // userid가 중복이면 활성
		if ('navi_group' == '${loginMethod}') {
			$("#sel_group").removeAttr("disabled");
			$("#img_group").attr("src", "${contextURL}/asvc/images/admin_group_icon.png");
			$("#lable_group").css("color", "black");
		}
		getGrpUserNo();
	} --%>
	
	$("#userid").focus();
});

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
	loginFrm.action = 'commonLoginUserWelcome.miaps?';
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
	
	ajaxComm('commonSelectGroupUserNoList.miaps', $('#loginFrm'), function(data){
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
	
	changeRowspanValue(true);
}

function changeRowspanValue(toggleSwitch) {
	if (toggleSwitch == false) {
		$("#userid").css("width", "100%");
		
	} else {
		$("#userid").css("width", "50%");
	}
}

 
function changeUser() {
//	alert('${contextURL}' + '/asvc/');
	window.location.replace('${contextURL}' + '/asvc/');
}
</script>

</head>
<body>

<!-- 본문 -->
<div id="admin_login_box">
	<div id="admin_login_box_in">
	<!-- 로그인화면 -->
	<form id="loginFrm" name="loginFrm" method="post" onSubmit="return false;">
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td>&nbsp;</td>
			<td align="center" width="374px" style="padding-bottom: 40px;"><img src="${contextURL}/asvc/images/admin_login_logo.png"></td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td height="200px" background="${contextURL}/asvc/images/admin_login_bg.png"></td>
			<td id="admin_login_input_box">
				<table border="0" cellpadding="0" cellspacing="0">
	            <tr>
	              <td>
	              	<c:if test="${loginMethod == 'top_group'}">
            			<img id="img_group" src="${contextURL}/asvc/images/admin_group_icon.png" class="login_img_group">&nbsp;<b>Group</b>
            		</c:if>
            		<c:if test="${loginMethod == 'navi_group'}">
              			<img id="img_group" src="${contextURL}/asvc/images/admin_group_icon_dis.png" class="login_img_group">&nbsp;<span id="lable_group" style="color:#BCBCBC;"><b>Group</b></span>
              		</c:if>
				  </td>
	              <td>
	              	<c:if test="${loginMethod == 'top_group'}">
	              		<c:if test="${grpNaviList == null || fn:length(grpNaviList) == 0}">
		                	<select name="userGroup.grpId">
								<option value=""><mink:message code="mink.web.text.select.group"/></option>
								<c:forEach var="dto" items="${userGroupTopList}" varStatus="i">
									<option value="${dto.grpId}"><c:out value='${dto.grpNm}'/></option>
								</c:forEach>
							</select>
			            </c:if>
			            <c:if test="${grpNaviList != null && fn:length(grpNaviList) > 0}">
		                	<select id="sel_group" name="userGroup.grpId" onchange="javascript:getGrpUserNo()">
								<c:forEach var="dto" items="${grpNaviList}" varStatus="i">
									<option value="${dto.grpId}"><c:out value='${dto.grpNavigation}'/></option>
								</c:forEach>
							</select>
		                </c:if>
	              	</c:if>
	              	<c:if test="${loginMethod == 'navi_group'}">
						<c:if test="${grpNaviList == null || fn:length(grpNaviList) == 0}">
	                	<select id="sel_group" name="userGroup.grpId">
	                		<option value="NOT_USED"><mink:message code="mink.web.text.duplicateid"/></option>
	                	</select>
		                </c:if>
		                <c:if test="${grpNaviList != null && fn:length(grpNaviList) > 0}">
		                	<select id="sel_group" name="userGroup.grpId" onchange="javascript:getGrpUserNo()">
		                		<c:forEach var="dto" items="${grpNaviList}" varStatus="i">
									<option value="${dto.grpId}"><c:out value='${dto.grpNavigation}'/></option>
								</c:forEach>
							</select>
		                </c:if>
		            </c:if> 
	              </td>
	            </tr>
	            <tr>
	              <td>
	              	<img src="${contextURL}/asvc/images/admin_user_icon.png" class="login_img_group">&nbsp;<b>User ID</b>			              
	              </td>
	              <td>		              	
	                <input name="userId" type="text" id="userid" onkeypress="if(event.keyCode == 13) enterLogin(this);" style="ime-mode:inactive; width:100%;">
	                <%-- 보안성 검토 (계정 정보 파악 가능성) - 20200331  --%>
	                <%-- <c:if test='${"ERR_USER_DUPLICATION" == errCode || "ERR_INVALID_PW" == errCode}'>
		            	&nbsp;<b>User No</b>&nbsp;&nbsp;<select id="grpUserNo" name="userNo"></select>
			        </c:if>	  --%>               
	              </td>
	            </tr>
	            <tr>
	              <td>
	              	<img src="${contextURL}/asvc/images/admin_pw_icon.png" class="login_img_group">&nbsp;<b>Password</b>
	              </td>
	              <td>
	              	<input name="userPw" type="password" id="userpassword" onkeypress="if(event.keyCode == 13) enterLogin(this);" style="width:100%;" autocomplete="off" >		                			              	
	              </td>
	            </tr>
	            <tr>
	              <td colspan="2" style="height: 25px; border-bottom: 1px solid #8bbcff;">
	              </td>
	            </tr>	            	            
	       		</table>
			</td>
			<td height="200px" background="${contextURL}/asvc/images/admin_login_bg.png"></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td width="374px">
				<table align="center" width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
	              <td style="height: 15px; vertical-align: middle;">
	              	<a href="javascript:showSearchLoginUserPassWordDialog();"><mink:message code="mink.web.text.search.password"/></a>
	              </td>
	              <td style="height: 15px; vertical-align: middle; text-align: right;">
	              	<a href="javascript:changeUser();"><mink:message code="mink.web.text.login.otheruser"/></a>
	              </td>
	            </tr>
	            <tr>
	              <td colspan="2" style="text-align: center; padding: 10 0 10 0;">
	                  <a href="javascript:goLogin();"><img src="${contextURL}/asvc/images/adminlogin_B.png" border="0" /></a>
	               </td>
	            </tr>
	            </table>
			</td>
			<td>&nbsp;</td>
		</tr>
		</table>
	</form>
	<div align="center" class="text_sm">${copyright}</div><br/>
	<div align="center" class="text_bule"><mink:message code="mink.web.message7" /> <br />
	    <mink:message code="mink.web.message8" /></div>
	<div align="center" class="text_sm"><a href="http://windows.microsoft.com/ko-KR/internet-explorer/download-ie" target="_blank" rel="noopener noreferrer"><mink:message code="mink.web.text.support.afterexplorer10"/></a></div>
	<div align="center" class="text_sm"><a href="http://windows.microsoft.com/ko-kr/internet-explorer/use-compatibility-view#ie=ie-11-win-7" target="_blank" rel="noopener noreferrer"><mink:message code="mink.web.message9"/></a></div>
			      
	</div>
</div>

<%-- 임시 테스트 사용자 시작 
<div>
	***easy Login User***
	<br /><a href="javascript:goLogin2('101');">[솔루션사업팀]슈퍼관리자</a>
	<br /><a href="javascript:goLogin2('2');">[솔루션사업부]그룹관리자</a>
	<br /><a href="javascript:goLogin2('3');">[솔루션사업부]사용자</a>
</div>
<script type="text/javascript">
function goLogin2(userNo) {
	var loginFrm = document.loginFrm;
	loginFrm.userNo.value = userNo;
	
	loginFrm.action = 'commonLoginUserWelcome.miaps?';
	loginFrm.submit();
}
</script>
--%>

<div id="searchLoginUserPassWordDialog" title="<mink:message code='mink.web.text.search.password'/>" class="dlgStyle">
	<input type="hidden" name="userNo" />
	<table class="detailTb" border="0" cellspacing="0" cellpadding="0" width="100%">
		<tbody>
			<tr>
				<th>
					<mink:message code="mink.web.text.passwordquiz"/>
				</th>
				<td class="onlyTextTd">
					<span id="passQuestSpan" style="float: left;"></span>
				</td>
			</tr>
			<tr>
				<th>
					<mink:message code="mink.web.text.passwordanswer"/>
				</th>
				<td>
					<input type="hidden" name="prePassAnsw" />
					<input type="text" name="passAnsw" />
				</td>
			</tr>
		</tbody>
	</table>
</div>

<script type="text/javascript">
<%-- 비밀번호 변경 팝업 나타나기 --%>
function showSearchLoginUserPassWordDialog() {
	if(document.loginFrm.userId.value == '') {
		alert("<mink:message code='mink.web.alert.input.userid'/>");
		$(document.loginFrm.userId).focus();
		return;
	}
	
	ajaxComm('commonLoginUserSearchUserPw.miaps?', document.loginFrm, function(data){
		if('' == data.msg) {
			if(null != data.loginUser.passQuest && '' != data.loginUser.passQuest) {
				$("#passQuestSpan").text(data.loginUser.passQuest);
				$(":input[name='prePassAnsw']", "#searchLoginUserPassWordDialog").val(data.loginUser.passAnsw);
				$(":input[name='userNo']", "#searchLoginUserPassWordDialog").val(data.loginUser.userNo);
				
				$(":input[name='passAnsw']", "#searchLoginUserPassWordDialog").val(""); // 입력창 초기화
				$("#searchLoginUserPassWordDialog").dialog("open"); // 비밀번호 변경 다이얼로그 팝업 나타나기
			}
			else {
				alert("<mink:message code='mink.web.text.noexist.passwordquiz'/>");
			}
		}
		else {
			alert(data.msg);
		}
	});
}

<%-- 비밀번호 변경 다이얼로그 팝업 --%>
$("#searchLoginUserPassWordDialog").dialog({
	autoOpen: false
	, modal: true
	, resizable: false
	, buttons: {
		"<mink:message code='mink.web.text.ok'/>": function() {
			var passAnsw = $(":input[name='passAnsw']", "#searchLoginUserPassWordDialog").val();
			var userNo = $(":input[name='userNo']", "#searchLoginUserPassWordDialog").val();
			
			if(passAnsw == '') {
				alert("<mink:message code='mink.web.alert.input.passwordanswer'/>");
				$(":input[name='passAnsw']", "#searchLoginUserPassWordDialog").focus();
				return;
			}
			else {
				var _passAnsw = $(":input[name='passAnsw']", "#searchLoginUserPassWordDialog").val();
				$.post('commonLoginUserSearchUserPwUpdate.miaps?', {userNo:userNo, passAnsw:_passAnsw}, function(data){
					if(0 < data.result) {
						alert("<mink:message code='mink.web.message10'/>" + document.loginFrm.userId.value + '\n' + "<mink:message code='mink.web.message10.1'/>");
						$( "#searchLoginUserPassWordDialog" ).dialog( "close" );
					}
					else {
						resultMsg(data.msg);
						return;
					}
				}, 'json');
			}
        },
        "<mink:message code='mink.web.text.cancel'/>": function() {
			$( this ).dialog( "close" );
        }
	}
});

</script>
 
</body>
</html>
