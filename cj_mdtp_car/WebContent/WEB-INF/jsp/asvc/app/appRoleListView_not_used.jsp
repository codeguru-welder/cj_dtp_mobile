<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="org.springframework.web.bind.annotation.SessionAttributes"%>
<%@ page import="com.thinkm.mink.commons.util.MinkConfig" %>
<%
	response.setHeader("cache-control","no-cache");
	response.setHeader("expires","0");
	response.setHeader("pragma","no-cache");
%>
<%
	/*
	 * 앱 권한 관리 화면 - 목록/상세/등록/수정/삭제 (appRoleListView.jsp)
	 * 
	 * @author chlee
	 * @since 2015.05.28
	 */
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<%@ include file="/WEB-INF/jsp/include/wsACommonInclude.jsp" %>
<%@ include file="/WEB-INF/jsp/include/wsACommonHeadScript.jsp" %>
<title><mink:message code="mink.label.page_title"/></title>
<c:set var="mode" value="App" />

<script type="text/javascript">
var searchFrm; // 목록/검색 frm

$(function(){
	// accordion 선택 페이지를 유지하기위한 설정값 셋팅 ex) home:0 user:1, role:2 device:3, app:4, push:5, board:6
	if('${loginUser.menuListString}' == '') init_accordion(4);
	else init_accordion('app', '${loginUser.menuListString}');
	
	searchFrm = document.searchFrm3;
	
	showList(); // 목록 보이기
	showPageHtml(); // 페이징 html 생성

	// 앱 패키지 이름이 같은 경우, tr 병합
	var preIdx = 0;
	var prePkgTxt = '';
	var currPkgTxt = '';
	
	var temp1 = '';
	var temp2 = '';
	var temp3 = '';
	var temp4 = '';
	var temp5 = '';
	var temp6 = '';
	var temp7 = '';
	var temp8 = '';
	
	var removeLength = 0;
	var removeArr = [];
	
	$("tr", "#listTbody").each(function(idx, tr){
		currPkgTxt = $("td:eq(0)", tr).text();
				
		removeLength = idx - preIdx;
		
		if( 0 == idx ) {
			preIdx = idx;
			prePkgTxt = currPkgTxt;
			
			temp1 = $("td:eq(1)", tr).text();
			temp2 = $("td:eq(2)", tr).text();
			temp3 = $("td:eq(3)", tr).text();
			temp4 = $("td:eq(4)", tr).text();
			temp5 = $("td:eq(5)", tr).text();
			temp6 = $("td:eq(6)", tr).text();
		}
		else if( 0 < idx ) {
			// 이전 줄의 패키지명과 다르면 셀 병합
			if( prePkgTxt != currPkgTxt ) {
				if( 1 < removeLength ) {
					$("tr", "#listTbody").eq(preIdx).find("td:eq(1)").html(temp1);
					$("tr", "#listTbody").eq(preIdx).find("td:eq(2)").html(temp2);
					$("tr", "#listTbody").eq(preIdx).find("td:eq(3)").html(temp3);
					$("tr", "#listTbody").eq(preIdx).find("td:eq(4)").html(temp4);
					$("tr", "#listTbody").eq(preIdx).find("td:eq(5)").html(temp5);
					$("tr", "#listTbody").eq(preIdx).find("td:eq(6)").html(temp6);
					
					for(var j = preIdx + 1; j < idx; j++) {
						removeArr.push(j); // 제거할 tr 순번 저장
					}
				}
				
				preIdx = idx;
				prePkgTxt = currPkgTxt;
				
				temp1 = $("td:eq(1)", tr).text();
				temp2 = $("td:eq(2)", tr).text();
				temp3 = $("td:eq(3)", tr).text();
				temp4 = $("td:eq(4)", tr).text();
				temp5 = $("td:eq(5)", tr).text();
				temp6 = $("td:eq(6)", tr).text();
			}
			// 이전 줄의 패키지명과 같으면 셀 내용 저장
			else {
				temp1 = temp1 + "<br />" + $("td:eq(1)", tr).text();
				temp2 = temp2 + "<br />" + $("td:eq(2)", tr).text();
				temp3 = temp3 + "<br />" + $("td:eq(3)", tr).text();
				temp4 = temp4 + "<br />" + $("td:eq(4)", tr).text();
				temp5 = temp5 + "<br />" + $("td:eq(5)", tr).text();
				temp6 = temp6 + "<br />" + $("td:eq(6)", tr).text();
			}
			
			// 마지막 줄인 경우, 직전 셀 내용과 같으면 병합
			if( idx == ($("tr", "#listTbody").length - 1) ) {
				if( $("tr", "#listTbody").eq(idx - 1).find("td:eq(0)").text() == currPkgTxt ) {
					$("tr", "#listTbody").eq(preIdx).find("td:eq(1)").html(temp1);
					$("tr", "#listTbody").eq(preIdx).find("td:eq(2)").html(temp2);
					$("tr", "#listTbody").eq(preIdx).find("td:eq(3)").html(temp3);
					$("tr", "#listTbody").eq(preIdx).find("td:eq(4)").html(temp4);
					$("tr", "#listTbody").eq(preIdx).find("td:eq(5)").html(temp5);
					$("tr", "#listTbody").eq(preIdx).find("td:eq(6)").html(temp6);
					
					for(var j = preIdx; j < idx; j++) {
						removeArr.push(j + 1); // 제거할 tr 순번 저장
					}
				}
			}
		}
	});
	
	// tr 제거(숨김)
	for(var k = 0; k < removeArr.length; k++) {
		$("tr", "#listTbody").eq(removeArr[k]).hide();
	}
	
	// 상세보기
	if(eval('${!empty app.appId}')) { 
		checkedTrCheckbox($("#listTr${app.appId}")); // 선택한 tr 의 checkbox 에 체크선택/css 변경
		$("#appRoleInfoDiv").show();
	}
	else {
		transAllTrCss($("tr:visible", "#listTbody"));
		$("#appRoleInfoDiv").hide();
	}

});

//목록검색
function goList(pageNum) {
	document.searchFrm3.pageNum.value = pageNum; // 이동할 페이지
	searchFrm3.action = 'appRoleListView.miaps?';
	document.searchFrm3.submit();
}

//상세검색
function goDetail(appId) {
	document.searchFrm3.appId.value = appId; // (선택한)상세
	goList(document.searchFrm3.pageNum.value);
}

// 메뉴 구성원 권한그룹(RG), 사용자그룹(UG) 하위조직포함여부 수정
function updateMenuRole(menuNm, roleTp, roleId, checkbox) {
	var appId = '${app.appId}';
	var includeSubYn = '';
	
	var alertText = "";
	
	if('RG' == roleTp) {
		alertText = menuNm + "<mink:message code='mink.web.text.permission.under.permission'/>";
	}
	else if('UG' == roleTp) {
		alertText = menuNm + "<mink:message code='mink.web.text.group.under.group'/>";
	}
	
	if(checkbox.checked) {
		alertText += "<mink:message code='mink.web.alert.is.include'/>";
		includeSubYn = 'Y';
	}
	else {
		alertText += "<mink:message code='mink.web.alert.exclude'/>";
		includeSubYn = 'N';
	}
	
	if(!confirm(alertText)) {
		if(checkbox.checked) checkbox.checked = false;
		else checkbox.checked = true;
		return;
	}
	$.post('appRoleUpdateIncludeSubYn.miaps?', {appId: appId, roleTp: roleTp, roleId: roleId, includeSubYn: includeSubYn}, function(data){
		resultMsg(data.msg);
		goDetail("${app.appId}");
	}, 'json');
}

// 메뉴 구성원(유형별) 삭제(다수)
function deleteAppRoleAll(mode) {
	var RG = "RG"; // roleTp: 권한 그룹
	var UG = "UG"; // roleTp: 사용자 그룹
	var UN = "UN"; // roleTp: 사용자NO
	var UD = "UD"; // roleTp: 사용자ID
	
	var $checkeds = $();
	var alertText = "";
	
	if(mode == RG) {
		searchFrm.roleTp.value = RG;
		$checkeds = $(":checkbox[name$='List']:checked", "#listTbodyRG");
		alertText = "<mink:message code='mink.web.alert.is.delete.from.permissiongroup'/>";
	}
	else if(mode == UG) {
		searchFrm.roleTp.value = UG;
		$checkeds = $(":checkbox[name$='List']:checked", "#listTbodyUG");
		alertText = "<mink:message code='mink.web.alert.is.delete.from.usergroup'/>";
	}
	else if(mode == UN) {
		searchFrm.roleTp.value = UN;
		$checkeds = $(":checkbox[name$='List']:checked", "#listTbodyUN");
		alertText = "<mink:message code='mink.web.alert.is.delete.from.user'/>";
	}
	else if(mode == UD) {
		searchFrm.roleTp.value = UD;
		$checkeds = $(":checkbox[name$='List']:checked", "#listTbodyUD");
		alertText = "<mink:message code='mink.web.alert.is.delete.from.user'/>";
	}
	
	if($checkeds.length < 1) {
		alert("<mink:message code='mink.web.alert.select.item'/>");
		return;
	}
	
	alertText = "<mink:message code='mink.web.text.total'/>" + $checkeds.length + "<mink:message code='mink.web.text.count.person'/>" + "\n" + alertText;
	
	document.searchFrm3.appId.value = '${app.appId}'; // 선택한 앱ID
		
	if(!confirm(alertText)) return;
	ajaxComm('appRoleDeleteAll.miaps?', searchFrm, function(data){
		resultMsg(data.msg);
		goDetail("${app.appId}");
	});
}
</script>

<!-- 탑 메뉴 -->
<%@ include file="/WEB-INF/jsp/include/header.jsp" %>
</head>
<body>

<!-- 메뉴 구성원인 권한 그룹 등록 treeview dialog -->
<%@ include file="/WEB-INF/jsp/asvc/app/searchRoleGroupTreeviewDialog.jsp" %>
<!-- 메뉴 구성원인 사용자 그룹 등록 treeview dialog -->
<%@ include file="/WEB-INF/jsp/asvc/app/searchUserGroupTreeviewDialog.jsp" %>
<!-- 메뉴 구성원인 사용자 등록 dialog -->
<%@ include file="/WEB-INF/jsp/asvc/app/searchUserDialog.jsp" %>
<!-- 사용자 상세정보 다이얼로그 -->
<%@ include file="/WEB-INF/jsp/include/searchUserDetailDialog.jsp" %>

<!-- 본문 -->
<div class="bodyContent">

	<!-- 왼쪽 메뉴 -->
	<div class="leftContent">
		<%@ include file="/WEB-INF/jsp/include/left.jsp" %>
	</div>
	
	<form id="searchFrm3" name="searchFrm3" method="post" onSubmit="return false;">
	<!-- 검색 hidden -->
	<input type="hidden" name="appId" /><!-- 상세 -->
	<input type="hidden" name="pageNum" value="${search.currentPage}" /><!-- 현재 페이지 -->
	<input type="hidden" name="roleTp" /><!-- 구성원 유형(RG, UG, UN, UD) -->
	<input type="hidden" name="direction" value="" /><!-- 선택한 메뉴의 순서 변경 위치 -->
	
	<div class="divDoubleMenu">
		<div>
			<h3>
				<span>
					* 앱 권한관리
				</span>
			</h3>
		</div>
		
		<%-- 검색 화면 --%>
		<div>
			<table border="1" cellspacing="0" cellpadding="0" width="100%">
				<tr> 	
					<td class="search">
						<select name="searchKey">
							<option value="" ${search.searchKey == '' ? '' : ''}><mink:message code="mink.web.text.total"/></option>
							<option value="appNm" ${search.searchKey == 'appNm' ? 'selected' : ''}><mink:message code="mink.web.text.appname"/></option>
							<option value="appId" ${search.searchKey == 'appId' ? 'selected' : ''}><mink:message code="mink.web.text.appid"/></option>
							<option value="packageNm" ${search.searchKey == 'packageNm' ? 'selected' : ''}><mink:message code="mink.web.text.packagename"/></option>
						</select>
						<input type="text" name="searchValue" value="<c:out value='${search.searchValue}'/>"/>
						<button class='btn-dash' onclick="javascript:goList('1');"><mink:message code="mink.web.text.search"/></button>
					</td>
				</tr>
			</table>
		</div>
		
		<%-- 목록 화면 --%>
		<div>
			<table class="listTb" border="1" cellspacing="0" cellpadding="0" width="100%">
				<colgroup>
					<col width="24%" />
					<col width="24%" />
					<col width="11%" />
					<col width="10%" />
					<col width="10%" />
					<col width="10%" />
					<col width="12%" />
				</colgroup>
				<thead>
					<tr>
						<td><mink:message code="mink.web.text.apppackagename"/></td>
						<td><mink:message code="mink.web.text.appname"/></td>
						<td><mink:message code="mink.web.text.platform"/></td>
						<td><mink:message code="mink.web.text.status.regist"/></td>
						<td><mink:message code="mink.web.text.status.commonapp"/></td>
						<td><mink:message code="mink.web.text.resp/dependent"/></td>
						<td><mink:message code="mink.text.regdate"/></td>
					</tr>
				</thead>
				<tbody id="listTbody">
					<%-- 목록이 있을 경우 --%>
					<c:forEach var="dto" items="${appList}" varStatus="i">
					<tr id="listTr${dto.appId}" onclick="javascript:document.searchFrm3.appId.value = ''; goDetail('${dto.appId}');">
						<td align="left">${dto.packageNm}</td>
						<td align="left">${dto.appNm}</td>
						<td>
							<c:choose>
								<c:when test="${dto.platformCd==PLATFORM_ANDROID}">ANDROID</c:when>
								<c:when test="${dto.platformCd==PLATFORM_IOS}">IOS</c:when>
								<c:otherwise>${dto.platformCd}</c:otherwise>
							</c:choose>
						</td>
						<td>
							<c:choose>
								<c:when test="${dto.regSt==APP_REG_ST}"><mink:message code="mink.web.text.approval"/></c:when>
								<c:otherwise><mink:message code="mink.web.text.approval.wait"/></c:otherwise>
							</c:choose>
						</td>
						<td>
							<c:choose>
								<c:when test="${dto.publicYn=='Y'}"><mink:message code="mink.web.text.commonapp"/></c:when>
								<c:when test="${dto.publicYn=='N'}"><mink:message code="mink.web.text.notcommon"/></c:when>
								<c:otherwise>${dto.publicYn}</c:otherwise>
							</c:choose>
						</td>
						<td>
							<c:choose>
								<c:when test="${dto.mainappYn=='Y'}"><mink:message code="mink.web.text.represetativeapp"/></c:when>
								<c:when test="${dto.mainappYn=='N'}"><mink:message code="mink.web.text.dependentapp"/></c:when>
								<c:otherwise>${dto.mainappYn}</c:otherwise>
							</c:choose>
							<c:if test="${dto.mainappYn=='N'}">
								(${dto.mainappId})
							</c:if>
						</td>	
						<td>${dto.regDt}</td>
					</tr>
					</c:forEach>
				</tbody>
				<tfoot id="listTfoot">
					<tr>
						<td colspan="7"><mink:message code="mink.web.text.noexist.result"/></td>
					</tr>
				</tfoot>
			</table>
		</div>
		
		<div id="paginateDiv" class="paginateDiv" >
			<div class="paginateDivSub">
			<%-- start paging --%>
			<%@ include file="/WEB-INF/jsp/include/pagination.jsp" %>
			<%-- end paging --%>
			</div>
		</div>
		
		<!-- 
		<div class="hiddenHrDiv"></div>
		<div class="hiddenHrDiv"></div>
		 -->
		<div id="appRoleInfoDiv"><!-- left/right -->
		
		<!-- 
		<div class="divLeftMenu">
			
		</div>
		 
		<div class="divRightMenu">
		 -->
		<div>
			<div class="hiddenHrDiv"></div>
			<div class="hiddenHrDiv"></div>
			
			<!-- 오른쪽 화면 -->
			<c:set var="display" value="" />
			<c:if test="${empty app.appId}">
				<c:set var="display" value="none" />
			</c:if>
			
			<div style="display: ${display};" class="divRightMenuMemberList">
				<div>
					<h3>
						<span>
							<mink:message code="mink.web.text.permission.group"/>
						</span>
					</h3>
				</div>
				
				<!-- 권한 그룹 목록 -->
				<div>
					<table class="read_listTb" border="1" cellspacing="0" cellpadding="0" width="100%">
						<colgroup>
							<col width="10%" />
							<col width="30%" />
							<col width="35%" />
							<col width="20%" />
						</colgroup>
						<thead>
							<tr>
								<th><input type="checkbox" name="CheckboxAll" /></th>
								<th><mink:message code="mink.web.text.permission.groupid"/></th>
								<th><mink:message code="mink.web.text.permission.groupname"/></th>
								<th><mink:message code="mink.web.text.is.include.underpermission"/></th>
							</tr>
						</thead>
						<tbody id="listTbodyRG">
							<!-- 목록이 있을 경우 -->
							<c:forEach var="dto" items="${appRoleListRG}" varStatus="i">
							<tr>
								<td><input type="checkbox" name="roleGrpIdList" value="${dto.roleGrpId}" /></td>
								<td>${dto.roleGrpId}</td>
								<td>${dto.roleGrpNm}</td>
								<td>
									<input type="checkbox" name="includeSubYn" value="${ynYes}" ${dto.includeSubYn == ynYes ? 'checked' : ''} onclick="updateMenuRole('${dto.roleGrpNm}', 'RG', '${dto.roleGrpId}', this);" />
								</td>
							</tr>
							</c:forEach>
							<c:if test="${empty appRoleListRG}">
							<tr>
								<td colspan="4"><mink:message code="mink.web.text.noexist.result"/></td>
							</tr>
							</c:if>
						</tbody>
					</table>
				</div>
				
				<div class="subDetailMemberBtnArea">
					<span><button id="insertRoleGroupDialogOpenerButton" class='btn-dash' onclick="javascript:return false;"><mink:message code="mink.web.text.regist"/></button></span>
					<span><button class='btn-dash' onclick="deleteAppRoleAll('RG');"><mink:message code="mink.web.text.delete"/></button></span>
				</div>
				
				<div class="hiddenHrDiv"></div>
				
				<div>
					<h3>
						<span>
							<mink:message code="mink.web.text.user.group"/>
						</span>
					</h3>
				</div>
				
				<!-- 사용자 그룹 목록 -->
				<div>
					<table class="read_listTb" border="1" cellspacing="0" cellpadding="0" width="100%">
						<colgroup>
							<col width="10%" />
							<col width="30%" />
							<col width="35%" />
							<col width="20%" />
						</colgroup>
						<thead>
							<tr>
								<th><input type="checkbox" name="CheckboxAll" /></th>
								<th><mink:message code="mink.web.text.user.groupid"/></th>
								<th><mink:message code="mink.web.text.user.groupname"/></th>
								<th><mink:message code="mink.web.text.is.include.undergroup"/></th>
							</tr>
						</thead>
						<tbody id="listTbodyUG">
							<!-- 목록이 있을 경우 -->
							<c:forEach var="dto" items="${appRoleListUG}" varStatus="i">
							<tr>
								<td><input type="checkbox" name="grpIdList" value="${dto.grpId}" /></td>
								<td>${dto.grpId}</td>
								<td>${dto.grpNm}</td>
								<td>
									<input type="checkbox" name="includeSubYn" value="${ynYes}" ${dto.includeSubYn == ynYes ? 'checked' : ''} onclick="updateMenuRole('${dto.grpNm}', 'UG', '${dto.grpId}', this);" />
								</td>
							</tr>
							</c:forEach>
							<c:if test="${empty appRoleListUG}">
							<tr>
								<td colspan="4"><mink:message code="mink.web.text.noexist.result"/></td>
							</tr>
							</c:if>
						</tbody>
					</table>
				</div>
				
				<div class="subDetailMemberBtnArea">
					<span><button id="insertUserGroupDialogOpenerButton" class='btn-dash' onclick="javascript:return false;"><mink:message code="mink.web.text.regist"/></button></span>
					<span><button class='btn-dash' onclick="deleteAppRoleAll('UG');"><mink:message code="mink.web.text.delete"/></button></span>
				</div>
				
				<div class="hiddenHrDiv"></div>
				
				<div>
					<h3>
						<span>
							<mink:message code="mink.web.text.user"/>
						</span>
					</h3>
				</div>
			
				<!-- 사용자NO 목록 -->
				<div>
					<table class="read_listTb" border="1" cellspacing="0" cellpadding="0" width="100%">
						<colgroup>
							<col width="10%" />
							<col width="40%" />
							<col width="50%" />
						</colgroup>
						<thead>
							<tr>
								<th><input type="checkbox" name="CheckboxAll" /></th>
								<th><mink:message code="mink.web.text.userno"/></th>
								<th><mink:message code="mink.web.text.username"/></th>
							</tr>
						</thead>
						<tbody id="listTbodyUN">
							<!-- 목록이 있을 경우 -->
							<c:forEach var="dto" items="${appRoleListUN}" varStatus="i">
							<tr>
								<td><input type="checkbox" name="userNoList" value="${dto.userNo}" /></td>
								<td>${dto.userNo}</td>
								<td><a href="javascript:javascript: void(0);" onclick="showSearchUserDetailDialog('${dto.userNo}');">${dto.userNm}(${dto.userId})</a></td>
							</tr>
							</c:forEach>
							<c:if test="${empty appRoleListUN}">
							<tr>
								<td colspan="3"><mink:message code="mink.web.text.noexist.result"/></td>
							</tr>
							</c:if>
						</tbody>
					</table>
				</div>
				
				<div class="subDetailMemberBtnArea">
					<span><button id="insertUserNoDialogOpenerButton" class='btn-dash' onclick="javascript:return false;"><mink:message code=""/></button></span>
					<span><button class='btn-dash' onclick="deleteAppRoleAll('UN');"><mink:message code=""/></button></span>
				</div>
				
				<div style="display: none;"><!-- 사용자ID 목록 숨김 -->
				<div>
					<h3>
						<span>
							<mink:message code="mink.web.text.userid"/>
						</span>
					</h3>
				</div>
				
				<!-- 사용자ID 목록 -->
				<div>
					<table class="read_listTb" border="1" cellspacing="0" cellpadding="0" width="100%">
						<thead>
							<tr>
								<th><input type="checkbox" name="CheckboxAll" /></th>
								<th>사용자ID</th>
								<th>사용자명</th>
							</tr>
						</thead>
						<tbody id="listTbodyUD">
							<!-- 목록이 있을 경우 -->
							<c:forEach var="dto" items="${appRoleListUD}" varStatus="i">
							<tr>
								<td><input type="checkbox" name="userIdList" value="${dto.userId}" /></td>
								<td>${dto.userId}</td>
								<td><a href="javascript:javascript: void(0);" onclick="showSearchUserDetailDialog('${dto.userNo}');">${dto.userNm}</a></td>
							</tr>
							</c:forEach>
							<c:if test="${empty appRoleListUD}">
							<tr>
								<td colspan="4"><mink:message code="mink.web.text.noexist.result"/></td>
							</tr>
							</c:if>
						</tbody>
					</table>
				</div>
				
				<div class="subDetailMemberBtnArea">
					<span><button id="insertUserIdDialogOpenerButton" class='btn-dash' onclick="javascript:return false;"><mink:message code="mink.web.text.regist"/></button></span>
					<span><button class='btn-dash' onclick="deleteAppRoleAll('UD');"><mink:message code="mink.web.text.delete"/></button></span>
				</div>
				</div>
			</div>
			
			<div class="hiddenHrDiv"></div>
		</div>
		
		</div><!-- left/right -->
		
	</div>
	
	</form>
</div>

<!-- footer -->
<div class="footerContent" >
	<%@ include file="/WEB-INF/jsp/include/footer.jsp" %>
</div>

</body>
</html>
