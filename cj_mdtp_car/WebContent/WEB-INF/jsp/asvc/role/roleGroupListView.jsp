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
	 * 권한 그룹 관리 화면 - 목록/상세/등록/수정/삭제 (roleGroupListView.jsp)
	 * 
	 * @author eunkyu
	 * @since 2014.04.10
	 */
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<%@ include file="/WEB-INF/jsp/include/wsACommonInclude.jsp" %>
<%@ include file="/WEB-INF/jsp/include/wsACommonHeadScript.jsp" %>
<title><mink:message code="mink.label.page_title"/></title>

<script type="text/javascript">
var searchFrm; // 목록/검색 frm

$(function(){
	//accordion 선택 페이지를 유지하기위한 설정값 셋팅 ex) home:0 user:1, device:2, app:3, push:4, board:5, monitoring:6, setting:7
	init_accordion('setting', '${loginUser.menuListString}');
	$("#topMenuTile").html("<mink:message code='mink.web.text.setting_permissiongroup'/>");
	
	searchFrm = document.searchFrm;
	
	//노드 선택 이벤트
	function clickNode_roleGroupListView(event){
		var roleGrpId = $(event.target).data("grp").grpId; // 권한 그룹ID
		
		// 부모창에 세팅
		$(":input[name='roleGrpId']", searchFrm).val(roleGrpId); // 권한 그룹ID
		
		goList(); // 바로 검색
	};
	// 권한 그룹 treeview
	treeviewAlink("roleGroupListTreeviewAllNode.miaps?", "#roleGroupTreeviewUl", clickNode_roleGroupListView); // ajax treeview
	
	if("" == "${roleGroup.roleGrpId}") {
		$("#rootTreeviewAlink").css("background", "#FFD700"); // check 된 css 적용
	}
});

//목록/검색
function goList() {
	searchFrm.action = 'roleGroupListView.miaps?';
	searchFrm.submit();
}

// 트리 완료 후 선택 node 체크 표시
function completeTreeview(treeview) {

	var id = $(treeview, "ul").eq(0).attr("id");
	
	// 권한 그룹 트리
	if( 'roleGroupTreeviewUl' == id ) {
		$("a", treeview).each(function(){
			if($(this).attr("id") == "${roleGroup.roleGrpId}") $(this).css("background", "#FFD700"); // check 된 css 적용
		});
	}
	// 권한 그룹 트리(다이얼로그)
	else if( 'searchRoleGroupTreeviewUl' == id ) {
		$("a", "#rgTwdgDiv").css("background", "#FFFFFF");
		$("a", treeview).each(function(){
			if($(this).attr("id") == $("#selectRoleGroupId").val()) $(this).css("background", "#FFD700"); // check 된 css 적용
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
}

// 권한 그룹 등록/수정 화면 열기/닫기
function showSaveRoleGroup(roleGrpId) {
	if('' == roleGrpId) {
		if('4' == "${roleGroup.grpLevel}") {
			alert("<mink:message code='mink.web.text.alert.regist.nomore'/>");
			//$("#saveRoleGroupDiv").hide();
			return;
		}
		
		var roleGrpNm = "<c:out value='${roleGroup.roleGrpNm}'/>";
		if("" == roleGrpNm) roleGrpNm = "root";
		
		$("#saveRoleGroupDivTitleTh").text("<mink:message code='mink.web.text.regist.underpermission'/>");
		$(":input[name='roleGrpId']", "#searchFrm").val("");
		$(":input[name='roleGrpNm']", "#saveRoleGroupDiv").val("");
		$(":input[name='roleGrpDesc']", "#saveRoleGroupDiv").val("");
	}
	else {
		$("#saveRoleGroupDivTitleTh").text("<mink:message code='mink.web.text.modify.permission'/>");
		$(":input[name='roleGrpId']", "#searchFrm").val("${roleGroup.roleGrpId}");
		$(":input[name='roleGrpNm']", "#saveRoleGroupDiv").val("<c:out value='${roleGroup.roleGrpNm}'/>");
		$(":input[name='roleGrpDesc']", "#saveRoleGroupDiv").val("<c:out value='${roleGroup.roleGrpDesc}'/>");
	}
	
	//$("#saveRoleGroupDiv").toggle();
	//$(":input[name='roleGrpNm']", "#saveRoleGroupDiv").focus();
	
	openRoleGroupRegModiDialog("${roleGroup.roleGrpId}");
}



// 권한 그룹 삭제
function deleteRoleGroup() {
	var roleGrpId = '${roleGroup.roleGrpId}';
	var upRoleGrpId = '${roleGroup.upRoleGrpId}';
	var roleGrpNm = "<c:out value='${roleGroup.roleGrpNm}'/>";
	var grpLevel = '${roleGroup.grpLevel}';
	
	// 알림말
	var alertText = "<mink:message code='mink.web.alert.is.delete.permissiongroup'/>";
	alertText += "\n\n" + "<mink:message code='mink.web.text.delete.also.underpermissiongroup'/>";
	alertText += "\n" + "<mink:message code='mink.web.text.delete.also.member'/>";
	
	if(!confirm(alertText)) return;
	$.post('roleGroupDelete.miaps?', {roleGrpId: roleGrpId, grpLevel: grpLevel}, function(data){
		resultMsg(data.msg);
		searchFrm.roleGrpId.value = upRoleGrpId;
		goList();
	}, 'json');
}

// 권한 그룹 구성원 사용자그룹(UG) 하위조직포함여부 수정
function updateRoleGroupMemberUG(roleGrpNm, memId, checkbox) {
	var roleGrpId = '${roleGroup.roleGrpId}';
	var includeSubYn = '';
	
	var alertText = roleGrpNm;
	if(checkbox.checked) {
		alertText += "<mink:message code='mink.web.alert.is.include.undergroup'/>";
		includeSubYn = 'Y';
	}
	else {
		alertText += "<mink:message code='mink.web.alert.is.exclude.undergroup'/>";
		includeSubYn = 'N';
	}
	
	cancelPropagation(event); // tr click 이벤트 막음
	if(!confirm(alertText)) {
		if(checkbox.checked) checkbox.checked = false;
		else checkbox.checked = true;
		return;
	}
	$.post('roleGroupMemberUGUpdateIncludeSubYn.miaps?', {roleGrpId: roleGrpId, memId: memId, includeSubYn: includeSubYn}, function(data){
		resultMsg(data.msg);
		goList();
	}, 'json');
	
}

// 권한 그룹 구성원(유형별) 삭제(다수)
function deleteRoleGroupMemberAll(mode) {
	var UG = "UG"; // memTp: 사용자 그룹
	var UN = "UN"; // memTp: 사용자NO
	var UD = "UD"; // memTp: 사용자ID
	
	var $checkeds = $();
	var alertText = "";
	var unit = "<mink:message code='mink.web.text.count.person'/>";
	
	if(mode == UG) {
		searchFrm.memTp.value = UG;
		$checkeds = $(":checkbox[name$='List']:checked", "#listTbodyUG");
		alertText = "<mink:message code='mink.web.alert.is.delete.from.usergroup'/>";
		unit = "<mink:message code='mink.web.text.count.group'/>";
	}
	else if(mode == UN) {
		searchFrm.memTp.value = UN;
		$checkeds = $(":checkbox[name$='List']:checked", "#listTbodyUN");
		alertText ="<mink:message code='mink.web.alert.is.delete.from.user'/>";
	}
	else if(mode == UD) {
		searchFrm.memTp.value = UD;
		$checkeds = $(":checkbox[name$='List']:checked", "#listTbodyUD");
		alertText = "<mink:message code='mink.web.alert.is.delete.from.user'/>";
	}
	
	if($checkeds.length < 1) {
		alert("<mink:message code='mink.web.alert.select.item'/>");
		return true;
	}
	
	alertText = "<mink:message code='mink.web.text.total'/>" + $checkeds.length + unit + "\n" + alertText;
	
	if(!confirm(alertText)) return;
	ajaxComm('roleGroupMemberDeleteAll.miaps?', searchFrm, function(data){
		resultMsg(data.msg);
		goList();
	});
}

// 권한 그룹 위치 이동
function roleGroupMove(direction) {
	var frm = $("#searchFrm");
	frm.find("input[name='direction']").val(direction); 
	ajaxComm('roleGroupMoveUpdate.miaps?', searchFrm, function(data){
		goList();
	});
}

function showNaviInfo() {
	$("#grpNaviDetailInfo1").toggle('fast');
	$("#grpNaviDetailInfo2").toggle('fast');
	$("#grpNaviDetailInfo3").toggle('fast');
	$("#grpNaviDetailInfo4").toggle('fast');
}
</script>
</head>
<body>

<!-- 권한 그룹 구성원인 사용자 그룹 등록 treeview dialog -->
<%@ include file="/WEB-INF/jsp/asvc/role/searchUserGroupTreeviewDialog.jsp" %>
<!-- 권한 그룹 구성원인 사용자 등록 dialog -->
<%@ include file="/WEB-INF/jsp/asvc/role/searchUserDialog.jsp" %>
<!-- 사용자 상세정보 다이얼로그 -->
<%@ include file="/WEB-INF/jsp/include/searchUserDetailDialog.jsp" %>
<!-- 사용자 그룹 내비게이션 다이얼로그 -->
<%@ include file="/WEB-INF/jsp/include/searchUserGroupNaviDialog.jsp" %>
<!-- 상위 권한 그룹 수정 treeview dialog -->
<%@ include file="/WEB-INF/jsp/asvc/role/searchRoleGroupTreeviewDialog.jsp" %>

<%-- 권한그룹 등록/수정 --%>
<%@ include file="/WEB-INF/jsp/asvc/role/roleGroupRegModiDialog.jsp" %>

<div id="miaps-container">
	<div id="miaps-header">
    	<%@ include file="/WEB-INF/jsp/include/header.jsp" %>
  	</div>
  	<div id="miaps-sidebar">
		<%@ include file="/WEB-INF/jsp/include/left.jsp" %>		
	</div>
	<div id="miaps-top-buttons">
		<span><button id="insertUserGroupDialogOpenerButton" class='btn-dash' onclick="javascript:return false;"><mink:message code="mink.web.text.regist.usergroup"/></button></span>
		<span><button class='btn-dash' onclick="deleteRoleGroupMemberAll('UG');"><mink:message code="mink.web.text.delete.usergroup"/></button></span>
		<span><button id="insertUserNoDialogOpenerButton" class='btn-dash' onclick="javascript:return false;"><mink:message code="mink.web.text.regist.user"/></button></span>
		<span><button class='btn-dash' onclick="deleteRoleGroupMemberAll('UN');"><mink:message code="mink.web.text.delete.user"/></button></span>
	</div>
	<div id="miaps-content">
		<form id="searchFrm" name="searchFrm" method="post" onSubmit="return false;">
		<input type="hidden" name="memTp" /><!-- 구성원 유형(UG, UN, UD) -->
		<input type="hidden" name="direction" value="" /><!-- 선택한 권한의 순서 변경 위치 -->
		<input type="hidden" name="roleGrpId" value="${roleGroup.roleGrpId}" />
		<input type="hidden" name="upRoleGrpId" value="${roleGroup.upRoleGrpId}" />
		<input type="hidden" name="orderSeq" value="${roleGroup.orderSeq}" />
		<input type="hidden" name="regNo" value="${loginUser.userNo}" />
		<input type="hidden" name="updNo" value="${loginUser.userNo}" />
	
		<div id="miaps-in-content-left">
			<%--
			<div><h3><span>* 권한 그룹 관리</span></h3></div>
			 --%>
			<table class="userTable" border="0" cellspacing="0" cellpadding="0" width="100%">
				<thead>
					<tr id="groupBtnArea">
						<td colspan="2" style="padding: 6px;">
							<span><button class='btn-dash' onclick="javascript:showSaveRoleGroup('');"><mink:message code="mink.web.text.add"/></button></span>
							<c:if test="${!empty roleGroup.roleGrpId}">
								<span><button class='btn-dash' onclick="javascript:showSaveRoleGroup('${roleGroup.roleGrpId}');"><mink:message code="mink.web.text.modify"/></button></span>
								<span><button class='btn-dash' onclick="javascript:deleteRoleGroup();"><mink:message code="mink.web.text.delete"/></button></span>
								<span><button id="editRoleGroupUpGrpSearchRoleGroupTreeviewDialogOpenerButtonUpdate" class='btn-dash'><mink:message code="mink.web.text.move"/></button></span>
								<span><button class='btn-dash' onclick="javascript:roleGroupMove('pre');">↑</button></span>
								<span><button class='btn-dash' onclick="javascript:roleGroupMove('next');">↓</button></span>
							</c:if>		
						</td>
					</tr>
				</thead>
				<tbody>
					<tr>
						<th><a style="text-decoration: none;" href="javascript:showNaviInfo()"><mink:message code="mink.web.text.navi.group"/></a></th>
						<td><c:out value="${empty roleGroup.grpNavigation ? 'root' : roleGroup.grpNavigation}"/></td>
					</tr>
					<tr id="grpNaviDetailInfo1">
						<th><mink:message code="mink.web.text.upperpermissiongroup.id"/></th>
						<td>${roleGroup.upRoleGrpId}</td>
					</tr>
					<tr id="grpNaviDetailInfo2">
						<th><mink:message code="mink.web.text.permission.groupid"/></th>
						<td>${roleGroup.roleGrpId}</td>
					</tr>
					<tr id="grpNaviDetailInfo3">
						<th><mink:message code="mink.web.text.permission.groupname"/></th>
						<td><c:out value='${roleGroup.roleGrpNm}'/></td>
					</tr>
					<tr id="grpNaviDetailInfo4">
						<th><mink:message code="mink.web.text.permissiongroup.description"/></th>
						<td><c:out value='${roleGroup.roleGrpDesc}'/></td>
					</tr>
					<tr>
						<td colspan="2">
							<ul class="twNodeStyle">
								<li class="outerBulletStyle">
									<a id="rootTreeviewAlink" href="javascript:document.searchFrm.roleGrpId.value = ''; goList();">root</a>
									<ul id="roleGroupTreeviewUl" class="treeview"></ul>
								</li>
							</ul>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div id="miaps-in-content-right">
		
		
		<c:set var="display" value="" />
		<c:if test="${empty roleGroup.roleGrpId}">
			<c:set var="display" value="none" />
		</c:if>
		<div style="display: ${display};" class="divRightMenuMemberList">
			<div><h3><span><mink:message code="mink.web.text.user.group"/></span>	</h3></div>
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
						<c:forEach var="dto" items="${roleGroupMemberListUG}" varStatus="i">
						<tr onclick="clickTrCheckedCheckbox(this)">
							<td><input type="checkbox" name="grpIdList" value="${dto.grpId}" onclick="checkedCheckboxInTr(event);" /></td>
							<td align="left"><c:out value='${dto.grpNm}'/></td>
							<td><a href="javascript: void(0);" onclick="javascript:showSearchUserGroupNaviDialog('${dto.grpId}');">${dto.grpId}</a></td>
							<td>
								<input type="checkbox" name="includeSubYn" value="${ynYes}" ${dto.includeSubYn == ynYes ? 'checked' : ''} onclick="updateRoleGroupMemberUG('<c:out value='${dto.grpNm}'/>', '${dto.grpId}', this);" />
							</td>
						</tr>
						</c:forEach>
						<c:if test="${empty roleGroupMemberListUG}">
						<tr>
							<td colspan="4"><mink:message code="mink.web.text.noexist.result"/></td>
						</tr>
						</c:if>
					</tbody>
				</table>
			</div>
			
			<div class="hiddenHrDiv"></div>
			
			<div><h3><span><mink:message code="mink.web.text.user"/></span></h3></div>
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
						<c:forEach var="dto" items="${roleGroupMemberListUN}" varStatus="i">
						<tr onclick="clickTrCheckedCheckbox(this)">
							<td><input type="checkbox" name="userNoList" value="${dto.userNo}" onclick="checkedCheckboxInTr(event);" /></td>
							<td align="left"><c:out value='${dto.userNm}'/></td>
							<td><a href="javascript:javascript: void(0);" onclick="showSearchUserDetailDialog('${dto.userNo}');">${dto.userId}</a></td>
							<td>${dto.userNo}</td>
						</tr>
						</c:forEach>
						<c:if test="${empty roleGroupMemberListUN}">
						<tr>
							<td colspan="4"><mink:message code="mink.web.text.noexist.result"/></td>
						</tr>
						</c:if>
					</tbody>
				</table>
			</div>
		</div>
			<%--
			<div style="display: none;"><!-- 사용자ID 목록 숨김 -->
			<div>
				<h3>
					<span>
						| 사용자ID
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
						<c:forEach var="dto" items="${roleGroupMemberListUD}" varStatus="i">
						<tr>
							<td><input type="checkbox" name="userIdList" value="${dto.userId}" /></td>
							<td>${dto.userId}</td>
							<td><a href="javascript:javascript: void(0);" onclick="showSearchUserDetailDialog('${dto.userNo}');">${dto.userNm}</a></td>
						</tr>
						</c:forEach>
						<c:if test="${empty roleGroupMemberListUD}">
						<tr>
							<td colspan="4">결과가 없습니다</td>
						</tr>
						</c:if>
					</tbody>
				</table>
			</div>
			
			<div class="subDetailMemberBtnArea">
				<span><button id="insertUserIdDialogOpenerButton" class='btn-dash' onclick="javascript:return false;">등록</button></span>
				<span><button class='btn-dash' onclick="deleteRoleGroupMemberAll('UD');">삭제</button></span>
			</div>
			</div>
			--%>
		</div>			
		</form>
	</div>
	<div id="miaps-footer">
  		<%@ include file="/WEB-INF/jsp/include/footer.jsp" %>
 	</div>
 </div>
</body>
</html>
