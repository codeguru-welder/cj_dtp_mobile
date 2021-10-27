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
	 * 어드민 메뉴 관리 화면 - 목록/상세/등록/수정/삭제 (menuAdminListView.jsp)
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
<c:set var="mode" value="Admin" />

<script type="text/javascript">
var searchFrm; // 목록/검색 frm

$(function(){
	//accordion 선택 페이지를 유지하기위한 설정값 셋팅 ex) home:0 user:1, device:2, app:3, push:4, board:5, monitoring:6, setting:7
	init_accordion('setting', '${loginUser.menuListString}');
	$("#topMenuTile").html("<mink:message code='mink.web.text.setting_menupermission'/>");
	
	searchFrm = document.searchFrm;
});

//목록/검색
function goList() {
	searchFrm.action = 'menuAdminListView.miaps?';
	searchFrm.submit();
}
</script>

<script type="text/javascript">
$(function(){
	//노드 선택 이벤트
	function clickNode_menuAdminListView(event){
		var menuId = $(event.target).data("grp").grpId; // 메뉴ID
		
		// 부모창에 세팅
		$(":input[name='menuId']", searchFrm).val(menuId); // 메뉴ID
		
		goList(); // 바로 검색
	};
	
	// 메뉴 treeview
	treeviewAlink("menuAdminListTreeviewAllNode.miaps?", "#menuTreeviewUl", clickNode_menuAdminListView); // ajax treeview
	//$.post("menuAdminListTreeviewAllNode.miaps?", {root: 'source'}, function(data){ alert(data); });
	
	if("" == "${menu.menuId}") {
		$("#rootTreeviewAlink").css("background", "#FFD700"); // check 된 css 적용
	}
});

//트리 완료 후 선택 node 체크 표시
function completeTreeview(treeview) {
	
	var id = $(treeview, "ul").eq(0).attr("id");
	
	// 어드민메뉴 트리
	if( 'menuTreeviewUl' == id ) {
		$("a", treeview).each(function(){
			if($(this).attr("id") == "${menu.menuId}") $(this).css("background", "#FFD700"); // check 된 css 적용
		});
	}
	// 어드민메뉴 트리(다이얼로그)
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
		$("a", "#rgTwdgDiv").css("background", "#FFFFFF");
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
		
		$("#saveMenuDivTitleTh").text(menuNm + " " + "<mink:message code='mink.web.text.regist.submenu'/>");
		$(":input[name='menuId']", "#saveMenuDiv").val("");
		$(":input[name='menuNm']", "#saveMenuDiv").val("");
		$(":input[name='menuDesc']", "#saveMenuDiv").val("");
		$(":input[name='menuUrl']", "#saveMenuDiv").val("");
	}
	else {
		$("#saveMenuDivTitleTh").text("${menu.menuNm}" + " " + "<mink:message code='mink.web.text.modify.menu'/>");
		$(":input[name='menuId']", "#saveMenuDiv").val("${menu.menuId}");
		$(":input[name='menuNm']", "#saveMenuDiv").val("${menu.menuNm}");
		$(":input[name='menuDesc']", "#saveMenuDiv").val("${menu.menuDesc}");
		$(":input[name='menuUrl']", "#saveMenuDiv").val("${menu.menuUrl}");
	}
	
	$("#saveMenuDiv").toggle();
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
	
	if('' == upMenuId) {
		upMenuId = '0';
		grpLevel = 1;
	}
	
	if(menuNm == '') {
		alert("<mink:message code='mink.web.alert.input.menuname'/>");
		$(":input[name='menuNm']", "#saveMenuDiv").focus();
		return;
	}
	
	if('' == menuId) {
		if(!confirm("<mink:message code='mink.web.alert.is.regist'/>")) return;
		$.post('menuAdminInsert.miaps?', {upMenuId: upMenuId, menuNm: menuNm, menuDesc: menuDesc, menuUrl: menuUrl, grpLevel: grpLevel, regNo: regNo}, function(data){
			resultMsg(data.msg);
			$(":input[name='menuId']", "#saveMenuDiv").val(upMenuId);
			goList();
		}, 'json');
	}
	else {
		if(!confirm("<mink:message code='mink.web.alert.is.save'/>")) return;
		$.post('menuAdminUpdate.miaps?', {menuId: menuId, menuNm: menuNm, menuDesc: menuDesc, menuUrl: menuUrl, updNo: updNo}, function(data){
			resultMsg(data.msg);
			goList();
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
	$.post('menuAdminDelete.miaps?', {menuId: menuId, grpLevel: grpLevel}, function(data){
		resultMsg(data.msg);
		searchFrm.menuId.value = upMenuId;
		goList();
	}, 'json');
}

// 메뉴 위치 이동
function menuMove(direction) {
	var frm = $("#searchFrm");
	frm.find("input[name='direction']").val(direction); 
	ajaxComm('menuMoveUpdate.miaps?', searchFrm, function(data){
		goList();
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
	
	cancelPropagation(event); // tr click 이벤트 막음
	if(!confirm(alertText)) {
		if(checkbox.checked) checkbox.checked = false;
		else checkbox.checked = true;
		return;
	}
	$.post('menuRoleAdminUpdateIncludeSubYn.miaps?', {menuId: menuId, roleTp: roleTp, roleId: roleId, includeSubYn: includeSubYn}, function(data){
		resultMsg(data.msg);
		goList();
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
	var unit = "<mink:message code='mink.web.alert.unit'/>";
	
	if(mode == RG) {
		searchFrm.roleTp.value = RG;
		$checkeds = $(":checkbox[name$='List']:checked", "#listTbodyRG");
		alertText = "<mink:message code='mink.web.alert.is.delete.from.permissiongroup'/>";
		unit = "<mink:message code='mink.web.text.permission.group2'/>";
	}
	else if(mode == UG) {
		searchFrm.roleTp.value = UG;
		$checkeds = $(":checkbox[name$='List']:checked", "#listTbodyUG");
		alertText = "<mink:message code='mink.web.alert.is.delete.from.usergroup'/>";
		unit = "<mink:message code='mink.web.text.user.group2'/>";
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
	
	alertText = "<mink:message code='mink.web.text.total'/>" + $checkeds.length + unit + "\n" + alertText;
	
	if(!confirm(alertText)) return;
	ajaxComm('menuRoleAdminDeleteAll.miaps?', searchFrm, function(data){
		resultMsg(data.msg);
		goList();
	});
}


function showNaviInfo() {
	$("#grpNaviDetailInfo1").toggle('fast');
	$("#grpNaviDetailInfo2").toggle('fast');
	$("#grpNaviDetailInfo3").toggle('fast');
	$("#grpNaviDetailInfo4").toggle('fast');
}

function deleteAdminMenu(yn) {
	var m = "";
	if ("Y" == yn) m = "<mink:message code='mink.web.text.delete'/>";
	else m = "<mink:message code='mink.web.text.use'/>";
	if (confirm(m + "하시겠습니까?")) {
		searchFrm.deleteYn.value = yn;
		ajaxComm('menuAdminDelete.miaps?', searchFrm, function(data){
			resultMsg(data.msg);
			goList();
		});
	} else {
		$("input[name='deleteYnOpt'][value=" + (yn == 'N' ? 'Y' : 'N') + "]").prop("checked", true);
		return;
	}
}

//메뉴기능저장
function saveMenuFn() {
	if( !confirm("<mink:message code='mink.web.alert.is.save'/>") ) return;
	
	ajaxComm('menuAdminUpdateMenuFn.miaps?', document.searchFrm, function(data){
		// 재조회안함
		if (data.msg != '' && data.code != 'OK') resultMsg(data.msg); // 에러메시지
		else alert("<mink:message code='mink.web.text.saved'/>"); // 성공메시지
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
<!-- 사용자 그룹 내비게이션 다이얼로그 -->
<%@ include file="/WEB-INF/jsp/include/searchUserGroupNaviDialog.jsp" %>
<!-- 상위 메뉴 수정 treeview dialog -->
<%@ include file="/WEB-INF/jsp/asvc/menu/searchMenuTreeviewDialog.jsp" %>
<!-- 사용자별 권한변경 이력조회 다이얼로그 -->
<%@ include file="/WEB-INF/jsp/asvc/menu/menuAdminUserRoleDialog.jsp" %>
<!-- 사용자별 권한변경 이력조회 다이얼로그 - 같은 사용자ID 중에서 선택하기 -->
<%@ include file="/WEB-INF/jsp/asvc/menu/menuAdminUserRoleBySameUserIdDialog.jsp" %>



<div id="miaps-container">
	<div id="miaps-header">
    	<%@ include file="/WEB-INF/jsp/include/header.jsp" %>
  	</div>
  	<div id="miaps-sidebar">
		<%@ include file="/WEB-INF/jsp/include/left.jsp" %>
	</div>
	<form id="searchFrm" name="searchFrm" method="post" onSubmit="return false;">
	<div id="miaps-top-buttons">
		<span><button id="insertRoleGroupDialogOpenerButton" class='btn-dash' onclick="javascript:return false;"><mink:message code="mink.web.text.regist.permissiongroup"/></button></span>
		<span><button class='btn-dash' onclick="deleteMenuRoleAll('RG');"><mink:message code="mink.web.text.delete.permissiongroup"/></button></span>
		<span><button id="insertUserGroupDialogOpenerButton" class='btn-dash' onclick="javascript:return false;"><mink:message code="mink.web.text.regist.usergroup"/></button></span>
		<span><button class='btn-dash' onclick="deleteMenuRoleAll('UG');"><mink:message code="mink.web.text.delete.usergroup"/></button></span>
		<span><button id="insertUserNoDialogOpenerButton" class='btn-dash' onclick="javascript:return false;"><mink:message code="mink.web.text.regist.user"/></button></span>
		<span><button class='btn-dash' onclick="deleteMenuRoleAll('UN');"><mink:message code="mink.web.text.delete.user"/></button></span>
		<span><button class='btn-dash' onclick="showMenuAdminUserRoleDialog();"><mink:message code="mink.web.text.inquiry.changepermission.byuser"/></button></span>
	</div>
	<div id="miaps-content">
    	<!-- 본문 -->
		
		<input type="hidden" name="mode" value="admin" />
		<input type="hidden" name="roleTp" /><!-- 구성원 유형(RG, UG, UN, UD) -->
		<input type="hidden" name="direction" value="" /><!-- 선택한 메뉴의 순서 변경 위치 -->
		
		<div id="miaps-in-content-left">
			<%--
			<div><h3><span>* 어드민센터 메뉴관리</span></h3></div>
			 --%>
			<table class="userTable" border="0" cellspacing="0" cellpadding="0" width="100%">
				<thead>
					<tr id="groupBtnArea" style="display: none;">
						<td colspan="2" style="padding: 6px;">
							<span><button class='btn-dash' onclick="javascript:showSaveMenu('');"><mink:message code="mink.web.text.regist.submenu"/></button></span>
							<c:if test="${!empty menu.menuId}">
								<span><button class='btn-dash' onclick="javascript:menuMove('pre');">↑</button></span>
								<span><button class='btn-dash' onclick="javascript:menuMove('next');">↓</button></span>
								<span><button id="editMenuUpGrpSearchMenuTreeviewDialogOpenerButtonUpdate" class='btn-dash'><mink:message code="mink.web.text.modify.uppermenu"/></button></span>
								<span><button class='btn-dash' onclick="javascript:showSaveMenu('${menu.menuId}');"><mink:message code="mink.web.text.modify.menu"/></button></span>
								<span><button class='btn-dash' onclick="javascript:deleteMenu();"><mink:message code="mink.web.text.delete.menu"/></button></span>
							</c:if>
						</td>
					</tr>
				</thead>
				<tbody>
					<tr>
						<th><a style="text-decoration: none;" href="javascript:showNaviInfo()"><mink:message code="mink.web.text.navi.menu"/></a></th>
						<td>${empty menu.grpNavigation? 'root' : menu.grpNavigation}</td>
					</tr>
					<tr id="grpNaviDetailInfo0">
						<th><mink:message code="mink.web.text.is.use"/></th>
						<td>
							<c:if test="${!empty menu.menuId}">
							<label><input type="radio" name="deleteYnOpt" value="N" onchange="deleteAdminMenu('N')" ${menu.deleteYn == 'N' ? 'checked' : ''} /><mink:message code="mink.web.text.using"/></label>
							<label><input type="radio" name="deleteYnOpt" value="Y" onchange="deleteAdminMenu('Y')" ${menu.deleteYn == 'Y' ? 'checked' : ''} /><mink:message code="mink.web.text.disabled"/></label>
							</c:if>
							<input type="hidden" name="deleteYn" value="${menu.deleteYn}" />
						</td>
					</tr>
					<tr id="grpNaviDetailInfo1">
						<th><mink:message code="mink.web.text.uppermenuid"/></th>
						<td>${menu.upMenuId}</td>
					</tr>
					<tr id="grpNaviDetailInfo2">
						<th><mink:message code="mink.web.text.menuid"/></th>
						<td>${menu.menuId}</td>
					</tr>
					<tr id="grpNaviDetailInfo3">
						<th><mink:message code="mink.web.text.menuname"/></th>
						<td>${menu.menuNm}</td>
					</tr>
					<tr id="grpNaviDetailInfo4">
						<th><mink:message code="mink.web.text.description.menu"/></th>
						<td>${menu.menuDesc}</td>
					</tr>
					<!-- 
					<tr>
						<th>URL</th>
						<td>${menu.menuUrl}</td>
					</tr>
					 -->
					<tr>
						<td colspan="2">
							<ul class="twNodeStyle">
								<li class="outerBulletStyle">
									<a id="rootTreeviewAlink" href="javascript:document.searchFrm.menuId.value = ''; goList();">root</a>
									<ul id="menuTreeviewUl" class="treeview"></ul>
								</li>
							</ul>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div id="miaps-in-content-right">
			<div id="saveMenuDiv" class="saveGroupDiv" style="display: none;">
				<table class="detailTb" border="0" cellspacing="0" cellpadding="0" width="100%">
					<thead>
						<tr class="search">
							<th id="saveMenuDivTitleTh" colspan="2" class="subSearch"><mink:message code="mink.web.text.modify.menu"/></th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<th><mink:message code="mink.web.text.menuname"/></th>
							<td>
								<input type="hidden" name="menuId" value="${menu.menuId}" />
								<input type="hidden" name="upMenuId" value="${menu.upMenuId}" />
								<input type="hidden" name="orderSeq" value="${menu.orderSeq}" />
								<input type="hidden" name="regNo" value="${loginUser.userNo}" />
								<input type="hidden" name="updNo" value="${loginUser.userNo}" />
								<input type="text" name="menuNm" value="${menu.menuNm}" />
							</td>
						</tr>
						<tr>
							<th><mink:message code="mink.web.text.description.menu"/></th>
							<td>
								<input type="text" name="menuDesc" value="${menu.menuDesc}" />
							</td>
						</tr>
						<tr>
							<th>URL</th>
							<td>
								<input type="text" name="menuUrl" value="${menu.menuUrl}" />
							</td>
						</tr>
				</table>
				<span><button class='btn-dash' onclick="javascript:saveMenu();"><mink:message code="mink.web.text.save"/></button></span>
			</div>

			<c:set var="display" value="" />
			<c:if test="${empty menu.menuId}">
				<c:set var="display" value="none" />
			</c:if>
			
			<div style="display: ${display};" class="divRightMenuMemberList">
			<c:if test="${menu.upMenuId != '0'}">
				<div><h3><span>| <mink:message code="mink.web.text.function.menu"/></span></h3></div>
				
				<!-- 메뉴 기능 -->
				<div>
					<table border="0" cellspacing="0" cellpadding="0" width="100%" class="read_listTb">
						<colgroup>
							<col width="100%" />
						</colgroup>
						<thead>
							<tr>
								<td><mink:message code="mink.web.text.functionname"/></td>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td align="left">
									01. <input type="text" name="menuFunctionNm[]" value="${menuFn[0].MENU_FUNCTION_NM}" style="width: 10%;" />
									02. <input type="text" name="menuFunctionNm[]" value="${menuFn[1].MENU_FUNCTION_NM}" style="width: 10%;" />
									03. <input type="text" name="menuFunctionNm[]" value="${menuFn[2].MENU_FUNCTION_NM}" style="width: 10%;" />
									04. <input type="text" name="menuFunctionNm[]" value="${menuFn[3].MENU_FUNCTION_NM}" style="width: 10%;" />
									05. <input type="text" name="menuFunctionNm[]" value="${menuFn[4].MENU_FUNCTION_NM}" style="width: 10%;" />
									06. <input type="text" name="menuFunctionNm[]" value="${menuFn[5].MENU_FUNCTION_NM}" style="width: 10%;" />
									07. <input type="text" name="menuFunctionNm[]" value="${menuFn[6].MENU_FUNCTION_NM}" style="width: 10%;" />
									08. <input type="text" name="menuFunctionNm[]" value="${menuFn[7].MENU_FUNCTION_NM}" style="width: 10%;" />
									<br />
									09. <input type="text" name="menuFunctionNm[]" value="${menuFn[8].MENU_FUNCTION_NM}" style="width: 10%;" />
									10. <input type="text" name="menuFunctionNm[]" value="${menuFn[9].MENU_FUNCTION_NM}" style="width: 10%;" />
									11. <input type="text" name="menuFunctionNm[]" value="${menuFn[10].MENU_FUNCTION_NM}" style="width: 10%;" />
									12. <input type="text" name="menuFunctionNm[]" value="${menuFn[11].MENU_FUNCTION_NM}" style="width: 10%;" />
									13. <input type="text" name="menuFunctionNm[]" value="${menuFn[12].MENU_FUNCTION_NM}" style="width: 10%;" />
									14. <input type="text" name="menuFunctionNm[]" value="${menuFn[13].MENU_FUNCTION_NM}" style="width: 10%;" />
									15. <input type="text" name="menuFunctionNm[]" value="${menuFn[14].MENU_FUNCTION_NM}" style="width: 10%;" />
									16. <input type="text" name="menuFunctionNm[]" value="${menuFn[15].MENU_FUNCTION_NM}" style="width: 10%;" />
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span><button class='btn-dash' onclick="javascript:saveMenuFn();"><mink:message code="mink.web.text.save"/></button></span>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="hiddenHrDiv"></div>
			</c:if>
				
				<div><h3><span>| <mink:message code="mink.web.text.permission.group"/></span></h3></div>
				
				<!-- 권한 그룹 목록 -->
				<div>
					<table border="0" cellspacing="0" cellpadding="0" width="100%" class="listTb">
						<colgroup>
							<col width="10%" />
							<col width="40%" />
							<col width="30%" />
							<col width="20%" />
						</colgroup>
						<thead>
							<tr>
								<td><input type="checkbox" name="CheckboxAll" /></td>
								<td><mink:message code="mink.web.text.permission.groupname"/></td>
								<td><mink:message code="mink.web.text.permission.groupid"/></td>
								<td><mink:message code="mink.web.text.is.include.underpermission"/></td>
							</tr>
						</thead>
						<tbody id="listTbodyRG">
							<!-- 목록이 있을 경우 -->
							<c:forEach var="dto" items="${menuRoleListRG}" varStatus="i">
							<tr onclick="clickTrCheckedCheckbox(this)">
								<td><input type="checkbox" name="roleGrpIdList" value="${dto.roleGrpId}" onclick="checkedCheckboxInTr(event);" /></td>
								<td align="left">${dto.roleGrpNm}</td>
								<td>${dto.roleGrpId}</td>
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
				</div>
				
				
				
				<div class="hiddenHrDiv"></div>
				
				<div><h3><span>| <mink:message code="mink.web.text.user.group"/></span></h3></div>
				
				<!-- 사용자 그룹 목록 -->
				<div>
					<table border="0" cellspacing="0" cellpadding="0" width="100%" class="listTb">
						<colgroup>
							<col width="10%" />
							<col width="40%" />
							<col width="30%" />
							<col width="20%" />
						</colgroup>
						<thead>
							<tr>
								<td><input type="checkbox" name="CheckboxAll" /></td>
								<td><mink:message code="mink.web.text.user.groupname"/></td>
								<td><mink:message code="mink.web.text.user.groupid"/></td>
								<td><mink:message code="mink.web.text.is.include.undergroup"/></td>
							</tr>
						</thead>
						<tbody id="listTbodyUG">
							<!-- 목록이 있을 경우 -->
							<c:forEach var="dto" items="${menuRoleListUG}" varStatus="i">
							<tr onclick="clickTrCheckedCheckbox(this)">
								<td><input type="checkbox" name="grpIdList" value="${dto.grpId}" onclick="checkedCheckboxInTr(event);" /></td>
								<td align="left">${dto.grpNm}</td>
								<td><a href="javascript: void(0);" onclick="javascript:showSearchUserGroupNaviDialog('${dto.grpId}');">${dto.grpId}</a></td>
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
				</div>
				
				
				<div class="hiddenHrDiv"></div>
				
				<div><h3><span>| <mink:message code="mink.web.text.user"/></span></h3></div>
			
				<!-- 사용자NO 목록 -->
				<div>
					<table border="0" cellspacing="0" cellpadding="0" width="100%" class="listTb">
						<colgroup>
							<col width="10%" />
							<col width="40%" />
							<col width="30%" />
							<col width="20%" />
						</colgroup>
						<thead>
							<tr>
								<td><input type="checkbox" name="CheckboxAll" /></td>
								<td><mink:message code="mink.web.text.username"/></td>
								<td><mink:message code="mink.web.text.userid"/></td>
								<td><mink:message code="mink.web.text.userno"/></td>
							</tr>
						</thead>
						<tbody id="listTbodyUN">
							<!-- 목록이 있을 경우 -->
							<c:forEach var="dto" items="${menuRoleListUN}" varStatus="i">
							<tr onclick="clickTrCheckedCheckbox(this)">
								<td><input type="checkbox" name="userNoList" value="${dto.userNo}"  onclick="checkedCheckboxInTr(event);"/></td>
								<td align="left">${dto.userNm}</td>
								<td><a href="javascript:javascript: void(0);" onclick="showSearchUserDetailDialog('${dto.userNo}');">${dto.userId}</a></td>
								<td>${dto.userNo}</td>
							</tr>
							</c:forEach>
							<c:if test="${empty menuRoleListUN}">
							<tr>
								<td colspan="4"><mink:message code="mink.web.text.noexist.result"/></td>
							</tr>
							</c:if>
						</tbody>
					</table>
				</div>
				
			
				
				<div style="display: none;"><!-- 사용자ID 목록 숨김 -->
					<div><h3><span><mink:message code="mink.web.text.userid"/></span></h3></div>
					
					<!-- 사용자ID 목록 -->
					<div>
						<table border="0" cellspacing="0" cellpadding="0" width="100%" class="listTb">
							<thead>
								<tr>
									<td><input type="checkbox" name="CheckboxAll" /></td>
									<td><mink:message code="mink.web.text.userid"/></td>
									<td><mink:message code="mink.web.text.username"/></td>
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
									<td colspan="3"><mink:message code="mink.web.text.noexist.result"/></td>
								</tr>
								</c:if>
							</tbody>
						</table>
					</div>
					
					<div class="subDetailMemberBtnArea">
						<span><button id="insertUserIdDialogOpenerButton" class='btn-dash' onclick="javascript:return false;"><mink:message code="mink.web.text.regist"/></button></span>
						<span><button class='btn-dash' onclick="deleteMenuRoleAll('UD');"><mink:message code="mink.web.text.delete"/></button></span>
					</div>
				</div>
			</div>
		</div>
	</div>
	</form>
	<div id="miaps-footer">
    	<%@ include file="/WEB-INF/jsp/include/footer.jsp" %>
  	</div>
  	
</div>

</body>
</html>
