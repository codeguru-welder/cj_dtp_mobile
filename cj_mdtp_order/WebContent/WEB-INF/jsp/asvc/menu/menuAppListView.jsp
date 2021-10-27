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
	 * 앱 메뉴 관리 화면 - 목록/상세/등록/수정/삭제 (menuAppListView.jsp)
	 * 
	 * @author eunkyu
	 * @since 2014.04.17
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
$(function(){
	//accordion 선택 페이지를 유지하기위한 설정값 셋팅 ex) home:0 user:1, device:2, app:3, push:4, board:5, monitoring:6, setting:7
	init_accordion('app', '${loginUser.menuListString}');
	$("#topMenuTile").html("<mink:message code='mink.web.text_appmanage_appmenu'/>");
	
	//showList(); <%-- 목록 보이기 --%>
	//showPageHtml();

});

//상세검색
function goDetail(packageNm) {
	$("#searchFrm").find("input[name='searchPackageNm']").val(packageNm);	// (선택한)상세
	document.searchFrm.action = 'menuAppListView.miaps?';
	document.searchFrm.submit();
}

function goList(packageNum) {
	$("#searchFrm").find("input[name='pageNum']").val(packageNum);	// (선택한)상세
	document.searchFrm.action = 'menuAppListView.miaps?';
	document.searchFrm.submit();
}
</script>

<script type="text/javascript">
$(function(){
	//노드 선택 이벤트
	function clickNode_menuAppListView(event){
		var menuId = $(event.target).data("grp").grpId; // 메뉴ID
		
		// 부모창에 세팅
		$(":input[name='menuId']", document.searchFrm).val(menuId); // 메뉴ID
		
		goDetail("${searchPackageNm}");
	};
	
	// 메뉴 treeview
	treeviewAlink("menuAppListTreeviewAllNode.miaps?packageNm=${searchPackageNm}", "#menuTreeviewUl", clickNode_menuAppListView); // ajax treeview
	//$.post("menuAppListTreeviewAllNode.miaps?", {root: 'source'}, function(data){ alert(data); });
	
	if("" == "${menu.menuId}") {
		$("#rootTreeviewAlink").css("background", "#FFD700"); // check 된 css 적용
	}
});

//트리 완료 후 선택 node 체크 표시
function completeTreeview(treeview) {
	var id = $(treeview, "ul").eq(0).attr("id");
	
	// 앱메뉴 트리
	if( 'menuTreeviewUl' == id ) {
		$("a", treeview).each(function(){
			if($(this).attr("id") == "${menu.menuId}") $(this).css("background", "#FFD700"); // check 된 css 적용
		});
	}
	// 앱메뉴 트리(다이얼로그)
	else if( 'searchMenuTreeviewUl' == id ) {
		$("a", "#mnTwdgDiv").css("background", "#FFFFFF");
		$("a", treeview).each(function(){
			if($(this).attr("id") == $("#selectMenuId").val()) $(this).css("background", "#FFD700"); // check 된 css 적용
		});
	}
	// 사용자그룹 트리(다이얼로그)
	else if( 'searchUserGroupTreeviewUl' == id ) {
		var selectId = $("#selectUserGroupId").val();
		
		$("a", "#ugTwdgDiv").css("background", "#FFFFFF");
		if("${corporation}" == selectId) $("#selectUserGroupRootAlink").css("background", "#FFD700"); // check 된 css 적용
		else if("${unclassified}" == selectId || '' == selectId) $("#selectUserGroupUnclassifiedAlink").css("background", "#FFD700"); // check 된 css 적용
		else {
			$("a", treeview).each(function(){
				if($(this).attr("id") == $("#selectUserGroupId").val()) {
					$(this).css("background", "#FFD700"); // check 된 css 적용
				}
			});
		}
	}
	// 권한그룹 트리(다이얼로그)
	else if( 'searchRoleGroupTreeviewUl' == id ) {
		$("a", treeview).each(function(){
			if($(this).attr("id") == $("#selectRoleGroupId").val()) $(this).css("background", "#FFD700"); // check 된 css 적용
		});
	}
}

// 메뉴 등록/수정 화면 열기/닫기
function showSaveMenu(menuId) {
	if('' == menuId) {
		if('3' == "${menu.grpLevel}") {
			alert("<mink:message code='mink.web.text.alert.regist.nomore'/>");
			$("#saveMenuDiv").hide();
			return;
		}
		
		var menuNm = "${menu.menuNm}";
		if("" == menuNm) menuNm = "root";
		
		$("#menuAddModiDialog").attr("title", menuNm+"<mink:message code='mink.web.text.regist.submenu'/>");
		$("#menuAddModiDialog").find("button[name='btnAddModi']").text("<mink:message code='mink.web.text.regist'/>");
		$(":input[name='menuId']", "#saveMenuDiv").val("");
		$(":input[name='menuNm']", "#saveMenuDiv").val("");
		$(":input[name='menuDesc']", "#saveMenuDiv").val("");
		$(":input[name='menuUrl']", "#saveMenuDiv").val("");
	}
	else {
		$("menuAddModiDialog").attr("title", "${menu.menuNm}" + "<mink:message code='mink.web.text.modify.menu'/>");
		$("#menuAddModiDialog").find("button[name='btnAddModi']").text("<mink:message code='mink.web.text.modify'/>");
		$(":input[name='menuId']", "#saveMenuDiv").val("${menu.menuId}");
		$(":input[name='menuNm']", "#saveMenuDiv").val("${menu.menuNm}");
		$(":input[name='menuDesc']", "#saveMenuDiv").val("${menu.menuDesc}");
		$(":input[name='menuUrl']", "#saveMenuDiv").val("${menu.menuUrl}");
	}
	
	$("#menuAddModiDialog").dialog("open");
	$(":input[name='menuNm']", "#saveMenuDiv").focus();
}

// 메뉴 등록/수정
function saveMenu() {
	var menuId = $(":input[name='menuId']", "#saveMenuDiv").val();
	var upMenuId = '${menu.menuId}';
	var menuNm = $(":input[name='menuNm']", "#saveMenuDiv").val();
	var menuDesc = $(":input[name='menuDesc']", "#saveMenuDiv").val();
	var menuUrl = $(":input[name='menuUrl']", "#saveMenuDiv").val();
	var grpLevel = parseInt("${menu.grpLevel}") + 1;
	var regNo = $(":input[name='regNo']", "#saveMenuDiv").val();
	var updNo = $(":input[name='updNo']", "#saveMenuDiv").val();
	
	var packageNm = "${searchPackageNm}";
	
	if('' == upMenuId) {
		upMenuId = '0';
		grpLevel = 1;
	}
	
	if(packageNm == '') {
		alert("<mink:message code='mink.web.alert.select.app'/>");
		return;
	}
	
	if(menuNm == '') {
		alert("<mink:message code='mink.web.alert.input.menuname'/>");
		$(":input[name='menuNm']", "#saveMenuDiv").focus();
		return;
	}
	
	if('' == menuId) {
		if(!confirm("<mink:message code='mink.web.alert.is.regist'/>")) return;
		$.post('menuAppInsert.miaps?', {packageNm: packageNm, upMenuId: upMenuId, menuNm: menuNm, menuDesc: menuDesc, menuUrl: menuUrl, grpLevel: grpLevel, regNo: regNo}, function(data){
			resultMsg(data.msg);
			$(":input[name='menuId']", "#saveMenuDiv").val(upMenuId);
			goDetail("${searchPackageNm}");
		}, 'json');
	}
	else {
		if(!confirm("<mink:message code='mink.web.alert.is.modify'/>")) return;
		$.post('menuAppUpdate.miaps?', {packageNm: packageNm, menuId: menuId, menuNm: menuNm, menuDesc: menuDesc, menuUrl: menuUrl, updNo: updNo}, function(data){
			resultMsg(data.msg);
			goDetail("${searchPackageNm}");
		}, 'json');
	}
}

// 메뉴 삭제
function deleteMenu() {
	var menuId = '${menu.menuId}';
	var upMenuId = '${menu.upMenuId}';
	var menuNm = '${menu.menuNm}';
	var grpLevel = '${menu.grpLevel}';
	
	// 알림말
	var alertText = menuNm + "<mink:message code='mink.web.alert.is.delete.menu'/>";
	alertText += "\n\n" + "<mink:message code='mink.web.text.delete.also.submenu'/>";
	alertText += "\n" + "<mink:message code='mink.web.text.delete.also.member'/>";
	
	if(!confirm(alertText)) return;
	$.post('menuAppDelete.miaps?', {menuId: menuId, grpLevel: grpLevel}, function(data){
		resultMsg(data.msg);
		document.searchFrm.menuId.value = upMenuId;
		goDetail("${searchPackageNm}");
	}, 'json');
}

// 메뉴 위치 이동
function menuMove(direction) {
	var frm = $("#searchFrm");
	frm.find("input[name='direction']").val(direction); 
	ajaxComm('menuMoveUpdate.miaps?', document.searchFrm, function(data){
		goDetail("${searchPackageNm}");
	});
}
</script>

<script type="text/javascript">
// 메뉴 구성원 권한그룹(RG), 사용자그룹(UG) 하위조직포함여부 수정
function updateMenuRole(menuNm, roleTp, roleId, checkbox) {
	var menuId = '${menu.menuId}';
	var includeSubYn = '';
	
	var alertText = "";
	
	if('RG' == roleTp) {
		alertText = menuNm + "<mink:message code='mink.web.text.permission.under.permission'/>";
	}
	else if('UG' == roleTp) {
		alertText = menuNm +"<mink:message code='mink.web.text.group.under.group'/>";
	}
	
	if(checkbox.checked) {
		alertText += "<mink:message code='mink.web.alert.is.include'/>";
		includeSubYn = 'Y';
	}
	else {
		alertText += "<mink:message code='mink.web.alert.exclude'/>";
		includeSubYn = 'N';
	}
	
	cancelPropagation(event); // tr click 이벤트 막음
	if(!confirm(alertText)) {
		if(checkbox.checked) checkbox.checked = false;
		else checkbox.checked = true;
		return;
	}
	$.post('menuRoleAppUpdateIncludeSubYn.miaps?', {menuId: menuId, roleTp: roleTp, roleId: roleId, includeSubYn: includeSubYn}, function(data){
		resultMsg(data.msg);
		goDetail("${searchPackageNm}");
	}, 'json');
}

// 메뉴 구성원(유형별) 삭제(다수)
function deleteMenuRoleAll(mode) {
	var RG = "RG"; // roleTp: 권한 그룹
	var UG = "UG"; // roleTp: 사용자 그룹
	var UN = "UN"; // roleTp: 사용자NO
	var UD = "UD"; // roleTp: 사용자ID
	
	var $checkeds = $();
	var alertText = "";
	
	if(mode == RG) {
		document.searchFrm.roleTp.value = RG;
		$checkeds = $(":checkbox[name$='List']:checked", "#listTbodyRG");
		alertText = "<mink:message code='mink.web.alert.is.delete.from.permissiongroup'/>";
	}
	else if(mode == UG) {
		document.searchFrm.roleTp.value = UG;
		$checkeds = $(":checkbox[name$='List']:checked", "#listTbodyUG");
		alertText = "<mink:message code='mink.web.alert.is.delete.from.usergroup'/>";
	}
	else if(mode == UN) {
		document.searchFrm.roleTp.value = UN;
		$checkeds = $(":checkbox[name$='List']:checked", "#listTbodyUN");
		alertText = "<mink:message code='mink.web.alert.is.delete.from.user'/>";
	}
	else if(mode == UD) {
		document.searchFrm.roleTp.value = UD;
		$checkeds = $(":checkbox[name$='List']:checked", "#listTbodyUD");
		alertText = "<mink:message code='mink.web.alert.is.delete.from.user'/>";
	}
	
	if($checkeds.length < 1) {
		alert("<mink:message code='mink.web.alert.select.item'/>");
		return;
	}
	
	alertText = "<mink:message code='mink.web.text.total'/>" + $checkeds.length + "<mink:message code='mink.web.text.count.person'/>" + "\n" + alertText;
	
	if(!confirm(alertText)) return;
	ajaxComm('menuRoleAppDeleteAll.miaps?', document.searchFrm, function(data){
		resultMsg(data.msg);
		goDetail("${searchPackageNm}");
	});
}
</script>
</head>
<body>

<!-- 메뉴 구성원인 권한 그룹 등록 treeview dialog -->
<%@ include file="/WEB-INF/jsp/asvc/menu/searchRoleGroupTreeviewDialog.jsp" %>
<!-- 메뉴 구성원인 사용자 그룹 등록 treeview dialog -->
<%@ include file="/WEB-INF/jsp/asvc/menu/searchUserGroupTreeviewDialog.jsp" %>
<!-- 메뉴 구성원인 사용자 등록 dialog -->
<%@ include file="/WEB-INF/jsp/asvc/menu/searchUserDialog.jsp" %>
<!-- 사용자 상세정보 다이얼로그 -->
<%@ include file="/WEB-INF/jsp/include/searchUserDetailDialog.jsp" %>
<!-- 상위 메뉴 수정 treeview dialog -->
<%@ include file="/WEB-INF/jsp/asvc/menu/searchMenuTreeviewDialog.jsp" %>
<!-- 메뉴추가/수정 다이얼로그 -->
<%@ include file="/WEB-INF/jsp/asvc/menu/menuAddModiDialog.jsp" %>

<div id="miaps-container">
	<div id="miaps-header">
    	<%@ include file="/WEB-INF/jsp/include/header.jsp" %>
  	</div>
  	<div id="miaps-sidebar">
		<%@ include file="/WEB-INF/jsp/include/left.jsp" %>
	</div>
	<div id="miaps-top-buttons">
		<span><button id="insertRoleGroupDialogOpenerButton" class='btn-dash' onclick="javascript:return false;"><mink:message code="mink.web.text.regist.permissiongroup"/></button></span>
		<span><button class='btn-dash' onclick="javascript:deleteMenuRoleAll('RG');"><mink:message code="mink.web.text.delete.permissionsgroup"/></button></span>
		<span><button id="insertUserGroupDialogOpenerButton" class='btn-dash' onclick="javascript:return false;"><mink:message code="mink.web.text.regist.usergroup"/></button></span>
		<span><button class='btn-dash' onclick="javascript:deleteMenuRoleAll('UG');"><mink:message code="mink.web.text.delete.usergroup"/></button></span>
		<span><button id="insertUserNoDialogOpenerButton" class='btn-dash' onclick="javascript:return false;"><mink:message code="mink.web.text.regist.user"/></button></span>
		<span><button class='btn-dash' onclick="javascript:deleteMenuRoleAll('UN');"><mink:message code="mink.web.text.delete.user"/></button></span>
	</div>	<!-- miaps-top-buttons -->
	<div id="miaps-content">
    	<!-- 본문 -->
		<div class="bodyContent">
		<!-- <div class="searchDivFrm"> -->
			<form id="searchFrm" name="searchFrm" method="post" onSubmit="return false;">
				<!-- 검색 hidden -->
				<input type="hidden" name="roleTp" /><!-- 구성원 유형(RG, UG, UN, UD) -->
				<input type="hidden" name="mode" value="app" />
				<input type="hidden" name="direction" value="" /><!-- 선택한 메뉴의 순서 변경 위치 -->
				<input type="hidden" name="pageNum" value="${search.currentPage}" /><!-- 현재 페이지 -->
				<input type="hidden" name="packageNm" value="${menu.packageNm}" />
				<input type="hidden" name="menuId" value="${menu.menuId}" />
				<input type="hidden" name="upMenuId" value="${menu.upMenuId}" />
				<input type="hidden" name="orderSeq" value="${menu.orderSeq}" />
				<input type="hidden" name="regNo" value="${loginUser.userNo}" />
				<input type="hidden" name="updNo" value="${loginUser.userNo}" />
				<div id="miaps-popup-sidebar">
					<div class="divLeftMenu">
						<div>
							<select  style="width:100%;" name="searchPackageNm" onchange="document.searchFrm.menuId.value = ''; goDetail(this.value)">
									<option value="" ${searchPackageNm == '' ? 'selected' : ''}><mink:message code="mink.text.full.packagename"/></option>
									<c:forEach var="p" items="${packageNmList}">
										<option value="${p.packageNm}" ${searchPackageNm == p.packageNm ? 'selected' : ''}>${p.appNm}</option>
									</c:forEach>
							</select>
						</div>
						<div>  <!-- style="height:33%;" -->
							<div class="subDetailBtnArea" style="float:left; margin:0px 0px 15px 0px;">
								<%-- <c:if test="${!empty searchPackageNm}"> --%>
										<span><button class='btn-dash' onclick="javascript:showSaveMenu('');"><mink:message code="mink.web.text.regist.submenu"/></button></span>
								<%-- </c:if> --%>
								<%-- <c:if test="${!empty menu.menuId}"> --%>
										<span><button class='btn-dash' onclick="javascript:menuMove('pre');">↑</button></span>
										<span><button class='btn-dash' onclick="javascript:menuMove('next');">↓</button></span>
										<span><button id="editMenuUpGrpSearchMenuTreeviewDialogOpenerButtonUpdate" class='btn-dash'><mink:message code="mink.web.text.modify.uppermenu"/></button></span>
										<span><button class='btn-dash' onclick="javascript:showSaveMenu('${menu.menuId}');"><mink:message code="mink.web.text.modify.menu"/></button></span>
										<span><button class='btn-dash' onclick="javascript:deleteMenu();"><mink:message code="mink.web.text.delete.menu"/></button></span>
								<%-- </c:if> --%>
							</div>	<!-- .subDetailBtnArea -->
							<!-- 메뉴 상세화면 -->
							<div>	<!-- S1 -->  <!-- style="height:33%;" -->
								<div> <!-- S2 -->
									<table class="userTable" border="0" cellspacing="0" cellpadding="0" width="100%">
										<thead>
											<tr>
												<th class="subSearch" colspan="2"><mink:message code="mink.web.text.info.menudetail"/></th>
											</tr>
										</thead>
										<tbody>
											<tr>
												<th><mink:message code="mink.web.text.navi.menu"/></th>
												<td>${empty menu.grpNavigation ? 'root' : menu.grpNavigation}</td>
											</tr>
											<c:if test="${!empty menu.menuId}">
											<tr>
												<th><mink:message code="mink.web.text.uppermenuid"/></th>
												<td>${menu.upMenuId}</td>
											</tr>
											<tr>
												<th><mink:message code="mink.web.text.menuid"/></th>
												<td>${menu.menuId}</td>
											</tr>
											<tr>
												<th><mink:message code="mink.web.text.menuname"/></th>
												<td>${menu.menuNm}</td>
											</tr>
											<tr>
												<th><mink:message code="mink.web.text.description.menu"/></th>
												<td>${menu.menuDesc}</td>
											</tr>
											<tr>
												<th>URL</th>
												<td>${menu.menuUrl}</td>
											</tr>
											</c:if>
										</tbody>
									</table>
								</div>	<!-- S2 -->
							</div>	<!-- S1 -->
							<table class="userTable" border="0" cellspacing="0" cellpadding="0" width="100%">
								<%-- <thead>
									<tr>
										<td class="search">
											<select name="searchPackageNm" onchange="document.searchFrm.menuId.value = ''; goDetail(this.value)">
												<option value="" ${searchPackageNm == '' ? 'selected' : ''}>전체 앱명 (패키지명)</option>
												<c:forEach var="p" items="${packageNmList}">
													<option value="${p.packageNm}" ${searchPackageNm == p.packageNm ? 'selected' : ''}>${p.appNm}</option>
												</c:forEach>
											</select>
										</td>
									</tr>
								</thead> --%>
								<tbody>
									<tr>
										<td>
											<ul class="twNodeStyle">
												<li class="outerBulletStyle">
													<a id="rootTreeviewAlink" href="javascript:document.searchFrm.menuId.value = ''; goDetail('${searchPackageNm}'); ">root</a>
													<ul id="menuTreeviewUl" class="treeview"></ul>
												</li>
											</ul>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>	<!-- .divLeftMenu -->
				</div>	<!-- .divDoubleMenu -->
				<div class="divRightMenu" id="miaps-popup-content">					
					<div class="divRightMenuMemberList" style="height:100%;">
						<!-- 권한 그룹 목록 -->
						<div style="height:33%;">	<!-- S1 -->
							<table class="read_listTb" border="0" cellspacing="0" cellpadding="0" width="100%">
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
									<c:forEach var="dto" items="${menuRoleListRG}" varStatus="i">
									<tr>
										<td><input type="checkbox" name="roleGrpIdList" value="${dto.roleGrpId}" /></td>
										<td>${dto.roleGrpId}</td>
										<td>${dto.roleGrpNm}</td>
										<td>
											<input type="checkbox" name="includeSubYn" value="${ynYes}" ${dto.includeSubYn == ynYes ? 'checked' : ''} onclick="updateMenuRole('${dto.roleGrpNm}', 'RG', '${dto.roleGrpId}', this);" />
										</td>
									</tr>
									</c:forEach>
									<c:if test="${empty menuRoleListRG}">
									<tr>
										<td colspan="4"><mink:message code="mink.web.text.noexist.result"/></td>
									</tr>
									</c:if>
								</tbody>
							</table>
						</div>	<!-- S1 -->
						<div class="hiddenHrDiv"></div>
						<!-- 사용자 그룹 목록 -->
						<div style="height:33%;">	<!-- S2 -->
							<table class="read_listTb" border="0" cellspacing="0" cellpadding="0" width="100%">
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
									<c:forEach var="dto" items="${menuRoleListUG}" varStatus="i">
									<tr>
										<td><input type="checkbox" name="grpIdList" value="${dto.grpId}" /></td>
										<td>${dto.grpId}</td>
										<td>${dto.grpNm}</td>
										<td>
											<input type="checkbox" name="includeSubYn" value="${ynYes}" ${dto.includeSubYn == ynYes ? 'checked' : ''} onclick="updateMenuRole('${dto.grpNm}', 'UG', '${dto.grpId}', this);" />
										</td>
									</tr>
									</c:forEach>
									<c:if test="${empty menuRoleListUG}">
									<tr>
										<td colspan="4"><mink:message code="mink.web.text.noexist.result"/></td>
									</tr>
									</c:if>
								</tbody>
							</table>
						</div>	<!-- S2 -->						
						<div class="hiddenHrDiv"></div>
						<!-- 사용자NO 목록 -->
						<div style="height:33%;">	<!-- S3 -->
							<table class="read_listTb" border="0" cellspacing="0" cellpadding="0" width="100%">
								<colgroup>
									<col width="10%" />
									<col width="40%" />
									<col width="50%" />
								</colgroup>
								<thead>
									<tr>
										<th><input type="checkbox" name="CheckboxAll" /></th>
										<th><mink:message code="mink.web.text.userno"/></th>
										<th><mink:message code="mink.web.text.username.id"/></th>
									</tr>
								</thead>
								<tbody id="listTbodyUN">
									<!-- 목록이 있을 경우 -->
									<c:forEach var="dto" items="${menuRoleListUN}" varStatus="i">
									<tr>
										<td><input type="checkbox" name="userNoList" value="${dto.userNo}" /></td>
										<td>${dto.userNo}</td>
										<td><a href="javascript:javascript: void(0);" onclick="showSearchUserDetailDialog('${dto.userNo}');">${dto.userNm}(${dto.userId})</a></td>
									</tr>
									</c:forEach>
									<c:if test="${empty menuRoleListUN}">
									<tr>
										<td colspan="3"><mink:message code="mink.web.text.noexist.result"/></td>
									</tr>
									</c:if>
								</tbody>
							</table>
						</div>	<!-- S3 -->
						<div style="display: none;"><!-- 사용자ID 목록 숨김 --> <!-- S4 -->
							<!-- 사용자ID 목록 -->
							<div>	<!-- S5 -->
								<table class="read_listTb" border="0" cellspacing="0" cellpadding="0" width="100%">
									<thead>
										<tr>
											<th><input type="checkbox" name="CheckboxAll" /></th>
											<th><mink:message code="mink.web.text.userid"/></th>
											<th><mink:message code="mink.web.text.username"/></th>
										</tr>
									</thead>
									<tbody id="listTbodyUD">
										<!-- 목록이 있을 경우 -->
										<c:forEach var="dto" items="${menuRoleListUD}" varStatus="i">
										<tr>
											<td><input type="checkbox" name="userIdList" value="${dto.userId}" /></td>
											<td>${dto.userId}</td>
											<td><a href="javascript:javascript: void(0);" onclick="showSearchUserDetailDialog('${dto.userNo}');">${dto.userNm}</a></td>
										</tr>
										</c:forEach>
										<c:if test="${empty menuRoleListUD}">
										<tr>
											<td colspan="4"><mink:message code="mink.web.text.noexist.result"/></td>
										</tr>
										</c:if>
									</tbody>
								</table>
							</div>	<!-- S5 -->
						</div>	<!-- S4 -->
					</div>	<!-- .divRightMenuMemberList -->
					<div class="hiddenHrDiv"></div>
				</div>	<!-- .divRightMenu -->
			</form>	<!-- searchFrm -->
		</div>	<!-- .bodyContent -->
	</div>	<!-- miaps-content -->
	<div id="miaps-footer">
    	<%@ include file="/WEB-INF/jsp/include/footer.jsp" %>
  	</div>	<!-- miaps-footer -->
</div>	<!-- miaps-container -->
</body>
</html>
