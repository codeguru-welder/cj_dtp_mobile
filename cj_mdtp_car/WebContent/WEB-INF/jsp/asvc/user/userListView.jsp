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
	 * 사용자 관리 화면 - 목록/상세/등록/수정/삭제 (userListView.jsp)
	 * 사용자 그룹 관리 - 목록/등록/수정/삭제
	 * 사용자 그룹 구성원 관리 - 목록/등록/수정/삭제
	 * 라이선스 관리 - 등록/수정/삭제
	 * 관리자 권한위임 관리 - 등록/수정/위임취소
	 
	 * '대상' ldap 사용자/사용자그룹 동기화
	 * 
	 * @author eunkyu
	 * @since 2014.02.12
	 * @author chlee
	 * @since 2016.01.12 - UI변경 - frame에서 사용하는 화면을 '사용자 그룹 구성원'을 제외하고 모두 dialog로 분리, iframe삭제
	 */
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<%@ include file="/WEB-INF/jsp/include/wsACommonInclude.jsp" %>
<%@ include file="/WEB-INF/jsp/include/wsACommonHeadScript.jsp" %>
<title><mink:message code="mink.label.page_title"/></title>

<script type="text/javascript">
var isGroupMove = false;
var searchFrm; // 목록/검색 frm
var TREE_ITEM_SEL_BK_COLOR = "#FFD700";
var TREE_LIST_BK_COLOR = "#FFFFFF";

/* *** 사용자 그룹 시작 *** */
$(function(){
	//accordion 선택 페이지를 유지하기위한 설정값 셋팅 ex) home:0 user:1, device:2, app:3, push:4, board:5, monitoring:6, setting:7
	init_accordion('user', '${loginUser.menuListString}');
	$("#topMenuTile").html("<mink:message code="mink.web.text.usermanage_user.group.status"/>");
	//init(); // 공통 이벤트 핸들러 세팅
	
	searchFrm = document.searchFrm;
	
	<%-- 앱 권한 탭 컨트롤 --%>
    $(".tab_content_appRole").hide();
    $(".tab_content_appRole:first").show();

    $("ul.tabs_appRole li").click(function () {
        $("ul.tabs_appRole li").removeClass("active").css("color", "#333");
        //$(this).addClass("active").css({"color": "darkred","font-weight": "bolder"});
        $(this).addClass("active").css("color", "#0459c1");
        $(".tab_content_appRole").hide()
        var activeTab = $(this).attr("rel");
        $("#" + activeTab).fadeIn();
    });
	
	//회사노드 선택(전체검색)
	$("#searchUserGroupCorporation").bind("click", setSelectUserGroupCorporation);

	// 그룹없음노드 선택
	$("#searchUserGroupUnclassified").bind("click", setSelectUserGroupUnclassified);

	// 그룹 검색 조직도 treeview
	treeviewAlink("userGroupListTreeview.miaps?", "#searchUserGroupTreeviewUl", clickNode_userListView); // ajax treeview
	
	// 그룹검색 엔터검색
	$("#searchUserGroupName").on("keypress", function(event){
		if(event.which == 13) {
			//showSearchUserGroupNameDialog();
			openSearchUserGroupNameDialog();
			return false;
		}
	});
	
	createGroupButtons();
	
    goUserListByGroupId('${corporation}');
});

// 사용자 그룹 구성원의 그룹검색
function goUserListByGroupId(searchUserGroupId) {
	//showLoading();
	
	$.post('userListFrame.miaps?', {searchUserGroupId : searchUserGroupId}, function(data){
		fnSetUserList(data); // 목록/검색
	}, 'json');
}

<%-- 목록검색/ userListView에서 ↑,↓ 누르면 userListFrame의 userGroupMove() 함수 호출하고, 그 함수에서 여기를 호출 --%>
function goUserListByPage(pageNum) {
	
	<%-- XSS 방어 --%>
	var _searchVal = defenceXSS(document.searchFrm.searchValue.value); 
	document.searchFrm.searchValue.value = _searchVal;
	
	// 하위검색 체크인 경우, root 검색이나 그룹없음 검색이면 체크 해제
	if($(":checkbox[name='searchUserGroupSubAllYn']", searchFrm).get(0).checked) {
		if( searchFrm.searchUserGroupId.value == '${corporation}' || searchFrm.searchUserGroupId.value == '${unclassified}' ) {
			$(":checkbox[name='searchUserGroupSubAllYn']").get(0).checked = false;
		}
	}
	
	//showLoading();
	
	searchFrm.pageNum.value = pageNum; // 이동할 페이지
	ajaxComm('userListFrame.miaps?', searchFrm, fnSetUserList);
}

<%-- hidden setting --%>
function fnSetSearchFrmHiddenValue(result) {
	var frm = $("#searchFrm");
	frm.find("input[name='searchUserGroupId']").val(result.searchUserGroupId);
	frm.find("input[name='preSearchUserGroupId']").val(result.searchUserGroupId);
	frm.find("input[name='pageNum']").val(result.currentPage);
	frm.find("input[name='preGrpId']").val(result.searchUserGroupId);	
	frm.find("input[name='grpLevel']").val(result.searchUserGroup.grpLevel);
	frm.find("input[name='searchUserGroup_upGrpId']").val(result.searchUserGroup.upGrpId);
	frm.find("input[name='searchUserGroup_grpId']").val(result.searchUserGroup.grpId);
	frm.find("input[name='searchUserGroup_grpCd']").val(result.searchUserGroup.grpCd);
	frm.find("input[name='searchUserGroup_grpNm']").val(defenceXSS(result.searchUserGroup.grpNm));
	frm.find("input[name='searchUserGroup_grpNavigation']").val(defenceXSS(result.searchUserGroup.grpNavigation));
	frm.find("input[name='upGrpId']").val(result.searchUserGroup.upGrpId);
	frm.find("input[name='orderSeq']").val(result.searchUserGroup.orderSeq);
}

<%-- search setting --%>
function fnSetSearchValue(result) {
	var frm = $("#searchFrm");
	$("#searchUserGroupNavigationSpan").html(defenceXSS(result.searchUserGroup.grpNavigation));
	$("#searchUserCountSpan").html("(" + result.count + ")");
	
	if (result.searchUserGroupSubAllYn == null || result.searchUserGroupSubAllYn == '') {
		frm.find("input:checkbox[name='searchUserGroupSubAllYn']").attr('checked',false);
	} else {
		frm.find("input:checkbox[name='searchUserGroupSubAllYn']").attr('checked',true);
	}
	
	frm.find("select[name='searchAdminType']").val(result.searchAdminType);
	frm.find("select[name='searchLicenseAssing']").val(result.searchLicenseAssing);
	frm.find("select[name='searchKey']").val(result.searchKey);
	frm.find("input[name='searchValue']").val(result.searchValue);
}

function fnSetSelectedGroupInfo(result) {
	$("#selTreeGrpInfo_navi").html(defenceXSS(result.searchUserGroup.grpNavigation));		
	if ("${corporation}" != result.searchUserGroup.grpId && "${unclassified}" != result.searchUserGroup.grpId) {
		$("#selTreeGrpInfo_nm").html(defenceXSS(result.searchUserGroup.grpNm));
		$("#selTreeGrpInfo_id").html(result.searchUserGroup.grpId);
		$("#selTreeGrpInfo_upid").html(result.searchUserGroup.upGrpId);
	} else {
		$("#selTreeGrpInfo_nm").html("");
		$("#selTreeGrpInfo_id").html("");
		$("#selTreeGrpInfo_upid").html("");
	}
}

<%-- 사용자 그룹 구성원 조회 결과 --%>
function fnSetUserList(data) {
	var resultList = data.userList;
	
	// hidden setting
	fnSetSearchFrmHiddenValue(data.search);
	
	// search setting
	fnSetSearchValue(data.search);
	
	// 선택된 그룹정보를 tree아래에 표시
	fnSetSelectedGroupInfo(data.search);
			
	<%-- 테이블 내용 삭제 후 head를 복사하여 값 셋팅하는 방식 --%>
	$("#userListTb > tbody > tr").remove();	<%-- 테이블내용 삭제 (tbody 밑의 tr 삭제) --%>
	if( resultList.length > 0 ) {	<%-- 결과 목록이 있을 경우 --%>
		
		var tmpUserNo;
		var tmpUserNm;
		var tmpUserId;
		var tmpGrp_GrpId;
		var tmpGrp_GrpNm;
		var tmpGrpMem_AdminYn;
		var tmpPhoneNo1;
		var tmpLicenseId;
		var tmpAdminYn;
		var tmpRegDt;
	
		for(var i = 0; i < resultList.length; i++) {
			var newRow = $("#userListTb > thead > tr").clone(); <%-- head row 복사 --%>
			
			tmpUserNo = resultList[i].userNo;
			tmpUserNm = defenceXSS(resultList[i].userNm);
			tmpUserId = defenceXSS(resultList[i].userId);
			tmpPhoneNo1 = defenceXSS(resultList[i].phoneNo1);
			tmpAdminYn = resultList[i].adminYn;
			tmpRegDt = resultList[i].regDt;
			
			if (resultList[i].userGroup == null) {
				tmpGrp_GrpId = '';
				tmpGrp_GrpNm = '';
			} else {
				tmpGrp_GrpId = resultList[i].userGroup.grpId;
				tmpGrp_GrpNm = defenceXSS(resultList[i].userGroup.grpNm);
			}
			
			if (resultList[i].userGroupMember == null) {
				tmpGrpMem_AdminYn = '';
			} else {
				tmpGrpMem_AdminYn = resultList[i].userGroupMember.adminYn;
			}
			
			<%--
			<!-- 목록이 있을 경우 -->
			<c:forEach var="dto" items="${userList}" varStatus="i">
			<tr id="listTr${dto.userNo}${dto.userGroup.grpId}" onclick="userDetail('${dto.userNo}', '${dto.userGroup.grpId}');">
				<td>
					<input type="checkbox" name="userNoList" value="${dto.userNo}" onclick="checkedCheckboxInTr(event);" />
					<input type="hidden" name="preGrpIdList" value="${dto.userGroup.grpId}" />
				</td>
				<td>${dto.userNo}</td>
				<td align="left">${dto.userNm}(${dto.userId})</td>
				<td align="left">${dto.userGroup.grpNm}</td>
				<td>${dto.phoneNo1}</td>
				<td>${dto.adminYn == ynYes ? superAdmin : dto.userGroupMember.adminYn == ynYes ? subAdmin : ''}</td>
				<td>
					<input type="hidden" name="licenseIdList" value="${dto.licenseId}" />
					${empty dto.licenseId ? '' : '할당됨'}
				</td>
			</tr>
			</c:forEach>
			--%>
			newRow.children().html("");	<%-- td 내용 초기화 --%>
			newRow.removeClass();
			newRow.attr("id", "listTr" + tmpUserNo + tmpGrp_GrpId);
			newRow.attr("onclick", "userDetail('" + tmpUserNo + "', '" + tmpGrp_GrpId + "');");			
			newRow.find("td:eq(0)").html("<input type='checkbox' name='userNoList' value='"+ tmpUserNo + "' onclick='checkedCheckboxInTr(event);' />\n<input type='hidden' name='preGrpIdList' value='" + tmpGrp_GrpId + "' />"); 
			newRow.find("td:eq(1)").html(tmpUserNm + "(" + tmpUserId + ")");
			newRow.find("td:eq(1)").attr("align", "left");
			if (nvl(tmpGrp_GrpNm) == "") newRow.find("td:eq(2)").html(tmpGrp_GrpNm);
			else newRow.find("td:eq(2)").html("<a href=\"javascript: void(0);\" onclick=\"javascript:showSearchUserGroupNaviDialog('" + tmpGrp_GrpId + "');\">" + tmpGrp_GrpNm + "</a>");
			newRow.find("td:eq(2)").attr("align", "left");
			newRow.find("td:eq(3)").html(tmpUserNo); 
			if (tmpAdminYn == '${ynYes}') {
				newRow.find("td:eq(4)").html('${superAdmin}');
			} else if (tmpGrpMem_AdminYn == '${ynYes}') {
				newRow.find("td:eq(4)").html('${subAdmin}');
			} else {
				newRow.find("td:eq(4)").html('');
			}
			newRow.find("td:eq(5)").html("<input type='hidden' name='licenseIdList' value='" + resultList[i].licenseId + "' />");
			if (resultList[i].licenseId == null || resultList[i].licenseId == '') {
				newRow.find("td:eq(5)").append('');
			} else {
				newRow.find("td:eq(5)").append("<mink:message code='mink.web.text.assigned'/>");
			}
			newRow.find("td:eq(6)").html(getDateFmt(tmpRegDt));
			$("#userListTb > tbody").append(newRow);
		}
	} else {	<%-- 결과 목록이 없을 경우 --%>
	var emptyRow = "<tr><td colspan='7' align='center'><mink:message code='mink.web.text.noexist.result'/></td></tr>"
		$("#userListTb > tbody").append(emptyRow);
	}

	<%-- 페이징 조건 재설정 후 페이징 html 생성 --%>
	$("input[name='pageNum']").val(data.search.currentPage);	<%-- 상세조회 key --%>
	showPageHtml2(data, $("#paginateDiv"), "goUserListByPage");
}	


//회사노드 선택(전체검색)
function setSelectUserGroupCorporation() {
	
	//console.log("setSelectUserGroupCorporation");
	
	var searchUserGroupId = "${corporation}"; // 검색 그룹ID
	
	$("#searchUserGroupId").val(searchUserGroupId); // 검색 그룹ID
	
	goUserListByGroupId(searchUserGroupId); // 바로 검색
	
	$("a", "#searchUserGroupTotalUl").css("background", TREE_LIST_BK_COLOR);
	$("#searchUserGroupCorporation").css("background", TREE_ITEM_SEL_BK_COLOR); // check 된 css 적용

	createGroupButtons();
	return;
}

// 그룹없음노드 선택
function setSelectUserGroupUnclassified() {
	//console.log("setSelectUserGroupUnclassified");
	
	var searchUserGroupId = "${unclassified}"; // 검색 그룹ID
	
	$("#searchUserGroupId").val(searchUserGroupId); // 검색 그룹ID
	
	goUserListByGroupId(searchUserGroupId); // 바로 검색
	
	//$("a", ".divLeftMenuTreeviewScoll").css("background", TREE_LIST_BK_COLOR);
	//var treeviewUlId = $("#searchUserGroupTotalUl");
	$("a", "#searchUserGroupTotalUl").css("background", TREE_LIST_BK_COLOR);
	$("#searchUserGroupUnclassified").css("background", TREE_ITEM_SEL_BK_COLOR); // check 된 css 적용

	createGroupButtons();
}

//노드 선택 이벤트
function clickNode_userListView(event){
	isGroupMove = false;
	var searchUserGroupId = $(event.target).data("grp").grpId; // 검색 그룹ID
	
	//console.log("--clickNode_userListView");
	//console.log(event.target);
	
	$("#searchUserGroupId").val(searchUserGroupId); // 검색 그룹ID
	
	goUserListByGroupId(searchUserGroupId); // 바로 검색
	
	//$("a", ".divLeftMenuTreeviewScoll").css("background", TREE_LIST_BK_COLOR);
	//var treeviewUlId = $("#searchUserGroupTotalUl");
	$("a", "#searchUserGroupTotalUl").css("background", TREE_LIST_BK_COLOR);
	$(event.target).css("background", TREE_ITEM_SEL_BK_COLOR); // check 된 css 적용
	
	createGroupButtons();
}

<%-- 그룹관련 버튼 생성 --%>
function createGroupButtons() {
	$("#groupBtnArea").html("");
	var _userGroupId = $("#searchUserGroupId").val();
	if (_userGroupId == '') {
		_userGroupId = '0';
	}
	
	var appendHtml = "";
	if ('${unclassified}' != _userGroupId) {
		appendHtml = "<td colspan='2' style='padding: 6px;'>";
		appendHtml += "<span><button class='btn-dash' onclick=\"javascript:openGroupRegModiDialog('');\"><mink:message code='mink.web.text.add'/></button></span>";
		
		if ('${corporation}' != _userGroupId) {
			appendHtml += " <span><button class='btn-dash' onclick=\"javascript:openGroupRegModiDialog("+ $("#searchUserGroupId").val() +");\"><mink:message code='mink.web.text.modify'/></button></span>" + 
				" <span><button class='btn-dash' onclick=\"javascript:deleteUserGroup();\"><mink:message code='mink.web.text.delete'/></button></span>" +
				" <span><button id=\"editUserGroupUpGrpSearchUserGroupTreeviewDialogOpenerButtonUpdate\" onclick='showSearchUserGroupTreeviewDialogNotBind();' class='btn-dash'><mink:message code='mink.web.text.move'/></button></span>" +
				" <span><button class='btn-dash' onclick=\"javascript:userGroupMove('pre');\">↑</button></span>" +
				" <span><button class='btn-dash' onclick=\"javascript:userGroupMove('next');\">↓</button></span>";
		}
		appendHtml += "</td>";
		$("#groupBtnArea").html(appendHtml);
	}
}

// 트리 완료 후 선택 node 체크 표시
function completeTreeview(treeview) {
	if( 'searchUserGroupTreeviewUl' == $(treeview, "ul").eq(0).attr("id") ) {
		var searchUserGroupId = ("#searchUserGroupId").val();
		$("a[id='"+searchUserGroupId+"']", treeview).css("background", TREE_ITEM_SEL_BK_COLOR); // check 된 css 적용
		//isEndTreeLoading = true; // 트리 로딩 끝
	}
}

// 트리 다시 불러오기
function reloadTreeview(grpId) {
	
	console.log("userListView.jsp, reloadTreeview(), grpId: "+ grpId);
	
	$("#searchUserGroupTreeviewUl").remove(); // 트리 삭제
	$("#searchUserGroupTreeviewTopLi").append("<ul id='searchUserGroupTreeviewUl' class='treeview'></ul>"); // 트리 ul 추가
	
	
	<%--
	//노드 선택 이벤트
	var clickNodeCall = function (event){
		var searchUserGroupId = $(event.target).data("grp").grpId; // 검색 그룹ID
		
		console.log("--clickNodeCall");
		
		// 부모창에 세팅
		$("#searchUserGroupId").val(searchUserGroupId); // 검색 그룹ID
				
		goUserListByGroupId(searchUserGroupId); // 바로 검색
		
		//$("a", ".divLeftMenuTreeviewScoll").css("background", TREE_LIST_BK_COLOR);
		$("a", "#searchUserGroupTotalUl").css("background", TREE_LIST_BK_COLOR);
		$(event.target).css("background", TREE_ITEM_SEL_BK_COLOR); // check 된 css 적용
	};
	--%>
	
	var treeviewUlId = $("#searchUserGroupTotalUl");
	$("a", treeviewUlId).css("background", "#FFFFFF");
	$("a" ,treeviewUlId).each(function(){
		$("a[id='"+grpId+"']", treeviewUlId).css("background", "#FFD700"); // check 된 css 적용
	});
		
	// 그룹 검색 조직도 treeview
	isGroupMove = true;
	if('' != grpId) {
		treeviewAlink("userGroupListTreeviewSelectedNode.miaps?grpId="+grpId, "#searchUserGroupTreeviewUl", clickNode_userListView); // ajax treeview
	}
	else {
		treeviewAlink("userGroupListTreeview.miaps?", "#searchUserGroupTreeviewUl", clickNode_userListView); // ajax treeview
	}
	//$.post("userGroupListTreeviewSelectedNode.miaps?root=source&grpId="+grpId, {root: grpId}, function(data){ alert(data); });
	
	
}

function userDeleteAll() {
	document.userListFrame.userDeleteAll();
}

<%-- 기존 iframe --%>
<%-- 사용자 상세 --%>
function userDetail(userNo, grpId) {
	//alert(userNo+","+grpId);
	<%-- 기본searchFrm의 userNo셋팅:그룹선택 다이얼로그에서 searchFrm의 userNo를 사용한다. --%>
	searchFrm.userNo.value = userNo;
	<%-- 사용자상세 폼의 userNo세팅 --%>
	userDetailFrm.userNo.value = userNo;
	userDetailFrm["userGroupMember.grpId"].value = grpId;
	ajaxComm('userDetail.miaps?', userDetailFrm, callbackUserDetailDialog);
	// 선택된 row 색깔변경 
	checkedTrCheckbox($("#listTr" + userNo + grpId).get(0));
}

<%-- 삭제 --%>
function userDelete() {
	<%-- var msg = "<mink:message code='mink.web.alert.is.delete'/>"; --%>
	var msg = "<mink:message code='mink.web.confirm.deleteuser'/>"; <%-- 사용자를 삭제하면 복구할 수 없습니다.\\n정말 삭제하시겠습니까? --%>
	if(0 < $("#userGroupTd").find(".addedUserGroupSpan").length) {
		msg += "\n\n" + "<mink:message code='mink.web.text.user.message101'/>" + "\n" + "<mink:message code='mink.web.text.user.message102'/>";
		msg += "\n-------------------------------------------------------------";
		msg += "\n" + "<mink:message code='mink.web.text.user.message201'/>" + " \n" + "<mink:message code='mink.web.text.user.message202'/>";
	}
	
	if(!confirm(msg)) return;
	ajaxComm('userDelete.miaps?', searchFrm, function(data){
		resultMsg(data.msg);
		searchFrm.userNo.value = ''; // (삭제한)상세 비움
		goUserListByPage(searchFrm.pageNum.value); // 목록/검색
	});
}

<%-- 삭제(다수) --%>
function userDeleteAll() {
	// 검증
	if($("#listTbody").find(":checkbox:checked").length < 1) {
		alert("<mink:message code='mink.web.alert.select.deleteuser'/>");
		return;
	}
	userDelete(); // 삭제
}

<%-- 검증(클라이언트) --%>
function validation(frm, fnName) {
	var answer = false;
	
	if('userInsert' == fnName) {
		if(frm.userId.value == '') {
			alert("<mink:message code='mink.web.alert.input.userid'/>");
			$(frm.userId).focus();
			return true;
		}
		/* 
		if(frm.userNm.value == '') {
			alert('사용자명을 입력하세요.');
			$(frm.userNm).focus();
			return true;
		}
		 */
		if(frm["userGroupMember.grpId"].value == '' && $(":radio[title='subAdmin']", frm).get(0).checked) {
			alert("<mink:message code='mink.web.alert.input.groupname'/>");
			return true;
		}
		if(frm["userGroupMember.grpId"].value == '${corporation}') {
			alert("<mink:message code='mink.web.alert.input.groupname'/>");
			return true;
		}
	}
	
	if('userUpdate' == fnName) {
		if(frm.userNm.value == '') {
			alert("<mink:message code='mink.web.text.input.username'/>");
			$(frm.userNm).focus();
			return true;
		}
		if(frm["userGroupMember.grpId"].value == '' && $(":radio[title='subAdmin']", frm).get(0).checked) {
			alert("<mink:message code='mink.web.alert.input.groupname'/>");
			return true;
		}
	}
	
	return answer;
}

<%-- 그룹 삭제 --%>
function deleteUserGroup() {
	var grpId = $("#searchUserGroupId").val();
	var grpNm = $("#searchUserGroup_grpNm").val();
	var grpLevel = $("#grpLevel").val();
	var upGrpId = $("#searchUserGroup_upGrpId").val();
	if(upGrpId == '') {
		upGrpId = '${corporation}';
	}
	var updNo = $(":input[name='updNo']", searchFrm).val();
	
	if('${loginUser.userGroup.grpId}' == grpId) {
		alert("<mink:message code='mink.web.alert.notdelete.group'/>");
		return;
	}
	
	// 알림말
	var alertText = grpNm + "<mink:message code='mink.web.alert.is.delete.group'/>";
	alertText += "\n\n" + "<mink:message code='mink.web.alert.delete.also.group'/>";
	alertText += "\n" + "<mink:message code='mink.web.text.user.message3'/>";
	
	if(!confirm(alertText)) return;
	$.post('userGroupDelete.miaps?', {grpId: grpId, grpLevel: grpLevel, updNo: updNo}, function(data){
		resultMsg(data.msg);
		
		if('0' == upGrpId) {
			searchFrm.searchUserGroupId.value = '${loginUser.userGroup.grpId}';
		}
		else {
			searchFrm.searchUserGroupId.value = upGrpId;
		}
		
		goUserListByPage('1');
		
		if('0' == searchFrm.searchUserGroupId.value) {
			reloadTreeview(''); // 트리 다시 불러오기
		}
		else {
			reloadTreeview(searchFrm.searchUserGroupId.value); // 트리 다시 불러오기
		}
		
	}, 'json');
}

<%-- 사용자 그룹 위치 이동 --%>
function userGroupMove(direction) {
	var frm = $("#searchFrm");

	frm.find("input[name='grpId']").val(frm.find("input[name='preGrpId']").val()); 
	frm.find("input[name='direction']").val(direction);
	
	ajaxComm('userGroupMoveUpdate.miaps?', searchFrm, function(data){
		goUserListByPage(searchFrm.pageNum.value); // 목록/검색
		reloadTreeview(frm.find("input[name='grpId']").val()); // 트리 다시 불러오기
	});
}

<%-- 라이선스 할당 --%>
function userLicenseUpdateAll() {
	var $checkeds = $("#listTbody").find(":checkbox:checked");
	
	console.log($checkeds.length);
	
	if($checkeds.length < 1) {
		alert("<mink:message code='mink.web.alert.select.lisenceuser'/>");
		return true;
	}
	
	var answer = false;
	
	<%-- 라이선스 할당여부 검증 --%>
	$checkeds.each(function(){
		var chkValue = $(this).parent("td").parent("tr").find(":hidden[name='licenseIdList']").val();
		if('' != chkValue && 'null' != chkValue) {
			//$(this).get(0).checked = false;
			answer = true;
		}
	});
	
	if(answer) {
		alert("<mink:message code='mink.web.text.user.message4'/>");
		return true;
	}
	
	<%-- 라이선스 할당 개수 검증 --%>
	$.ajaxSetup({async:false}); // 비동기 옵션 끄기(ajax 동기화)
	ajaxComm('userLicenseCount.miaps?', searchFrm, function(data){
		if(data.licenseUnassignedCount < $checkeds.length) { 
			alert("할당 개수를 초과하였습니다!"+"\n"+"현재 라이선스는 "+data.licenseUnassignedCount+"개만 할당할 수 있습니다.");
			answer = true;
		}
	});
	$.ajaxSetup({async:true}); // 비동기 옵션 켜기
	
	if(answer) return;
	
	<%-- 기존 장치라이선스 사용여부 검증 --%>
	var alertText = "<mink:message code='mink.web.alert.already.devicelicense'/>";
	var licenseIdList = [];
	for(var i = 0; i < $checkeds.length; i++) {
		// ajax
		$.ajaxSetup({async:false}); // 비동기 옵션 끄기(ajax 동기화)
		$.post('userLicenseDevice.miaps?', { userNo: $checkeds.eq(i).val() }, function(data){
			// 장치라이선스가 있는 경우
			if(0 < data.userDeviceLicenseIdList.length) {
				// 알림말
				for(var j = 0; j < data.userDeviceLicenseIdList.length; j++) {
					alertText += "\n\n";
					alertText += "(" + (j + 1) + ")";
					alertText += "\n" + "<mink:message code='mink.web.text.username'/>" + defenceXSS(data.user.userNm) + "(" + defenceXSS(data.user.userId) + ")" + "\n" + "<mink:message code='mink.web.text.userno'/>" + data.user.userNo + "\n" + "<mink:message code='mink.web.text.devicelicense'/>" + data.userDeviceLicenseIdList[j];
					licenseIdList.push(data.userDeviceLicenseIdList[j]);
				}
			}
			//
		}, 'json');
		$.ajaxSetup({async:true}); // 비동기 옵션 켜기
		//
	}
	alertText += "\n\n"+"<mink:message code='mink.web.text.user.message6'/>";
	
	if(0 < licenseIdList.length) {
		if(!confirm(alertText)) return;
		
		var $frm = $("<form method='post' />");
		var $licenseIdList = $();
		for(var i = 0; i < licenseIdList.length; i++) {
			$licenseIdList = $("<input type='hidden' name='licenseIdList' value='" + licenseIdList[i] + "' />");
			$frm.append($licenseIdList);
		}
		var $cancelUserNo = $(":input[name='cancelUserNo']", searchFrm).clone();
		$frm.append($cancelUserNo);
		
		// ajax
		$.ajaxSetup({async:false}); // 비동기 옵션 끄기(ajax 동기화)
		$.post('userLicenseDelete.miaps?', $frm.serialize(), function(data){
			if("<mink:message code='mink.web.text.saved'/>" == data.msg) alert(data.result+"<mink:message code='mink.web.text.user.message7'/>");
			else resultMsg(data.msg);
		}, 'json');
		$.ajaxSetup({async:true}); // 비동기 옵션 켜기
		//
	}
	else {
		if(!confirm("<mink:message code='mink.web.alert.is.assign'/>")) return;
	}
	
	ajaxComm('userLicenseUpdate.miaps?', searchFrm, function(data){
		resultMsg(data.msg);
		goUserListByPage(searchFrm.pageNum.value); // 목록/검색
	});
}

<%-- 라이선스 회수 --%>
function userLicenseDeleteAll() {
	var $checkeds = $("#listTbody").find(":checkbox:checked");
	
	console.log($checkeds.length);
	
	if($checkeds.length < 1) {
		alert("<mink:message code='mink.web.alert.select.recall.userlicense'/>");
		return true;
	}
	
	var answer = false;
	
	<%-- 라이선스 할당여부 검증 --%>
	$checkeds.each(function(){
		var chkValue = $(this).parent("td").parent("tr").find(":hidden[name='licenseIdList']").val();
		if('' == chkValue || 'null' == chkValue) {
			//$(this).get(0).checked = false;
			answer = true;
		}
	});
	
	if(answer) {
		alert("<mink:message code='mink.web.text.user.message8'/>");
		return;
	}
	
	if(!confirm("<mink:message code='mink.web.alert.is.recall'/>")) return;
	
	// 체크안한 라이선스는 회수할 때 제외
	$("#listTbody").find(":checkbox:not(:checked)").each(function(){
		$(this).parent("td").parent("tr").find(":hidden[name='licenseIdList']").remove();
	});
	
	ajaxComm('userLicenseDelete.miaps?', searchFrm, function(data){
		resultMsg(data.msg);
		goUserListByPage(searchFrm.pageNum.value); // 목록/검색
	});
}
<%-- *** 라이선스 끝 *** --%>

function showNaviInfo() {
	/*
	$("#grpNaviDetailInfo1").toggle('fast', function() {
		$("#grpNaviDetailInfo2").toggle('fast', function() {
			$("#grpNaviDetailInfo3").toggle('fast');		
		});
	});
	*/
	
	$("#grpNaviDetailInfo1").toggle('fast');
	$("#grpNaviDetailInfo2").toggle('fast');
	$("#grpNaviDetailInfo3").toggle('fast');
}

</script>
</head>
<body>
<%-- !!!! Dialog Include순서에 유의!!! Dialog가 열리지 않는 경우가 있음. --%>
<!-- 사용자 그룹 등록/수정, 구성원 그룹이동 다이얼로그 -->
<%@ include file="/WEB-INF/jsp/asvc/user/searchUserGroupTreeviewDialog.jsp" %>

<!-- 사용자 그룹 상세정보 다이얼로그 -->
<%@ include file="/WEB-INF/jsp/asvc/user/userGroupDetailDialog.jsp" %>

<%-- 그룹 등록/수정 다이얼로그 --%>
<%@ include file="/WEB-INF/jsp/asvc/user/userGroupRegModiDialog.jsp" %>

<%-- 관리자 권한위임관리 다이얼로그 --%>
<%@ include file="/WEB-INF/jsp/asvc/user/editUserRoleDelegateDialog.jsp" %>

<%-- 사용자 상세정보 다이얼로그 --%> 
<%@ include file="/WEB-INF/jsp/asvc/user/userModiDialog.jsp" %>
<%-- 사용자 등록 다이얼로그 --%>
<%@ include file="/WEB-INF/jsp/asvc/user/userRegDialog.jsp" %>
<%-- 사용자 장치 다이얼로그
<%@ include file="/WEB-INF/jsp/asvc/user/userDeviceDialog.jsp" %>
 --%> 
 
<!-- 사용자 상세정보 다이얼로그 -->
<%@ include file="/WEB-INF/jsp/include/searchUserDetailDialog.jsp" %>

<!-- 사용자 그룹 내비게이션 다이얼로그 -->
<%@ include file="/WEB-INF/jsp/include/searchUserGroupNaviDialog.jsp" %>

<%-- 그룹명 검색 다이얼로그 --%>
<%@ include file="/WEB-INF/jsp/asvc/user/searchGroupNameDialog.jsp" %>


<div id="miaps-container">
	<div id="miaps-header">
    	<%@ include file="/WEB-INF/jsp/include/header.jsp" %>
  	</div>
  	<div id="miaps-sidebar">
		<%@ include file="/WEB-INF/jsp/include/left.jsp" %>		
	</div>
	<div id="miaps-top-buttons">
		<span><button class='btn-dash' id="editUserGroupMemberSearchUserGroupTreeviewDialogOpenerButtonSave"><mink:message code="mink.web.text.move.usergroup"/></button></span>
		<span><button class='btn-dash' onclick="javascript:openUserRegDialog();"><mink:message code="mink.web.text.regist.user"/></button></span>
		<%-- 
			- 사용자를 삭제하더라도 삭제 플래그만 변경되고 실제 데이터가 삭제된 것이 아니므로 여러가지로 문제가 될 수 있어 이 기능을 제거함
			- mingun.park@gmail.com (20180214)
			- 완전삭제로 기능을 다시 살림 (2020/02/13) 
		--%>
		<span><button class='btn-dash' onclick="javascript:userDeleteAll();"><mink:message code="mink.web.text.delete.user"/></button></span><%-- 사용자삭제 --%>
		<span><button class='btn-dash' onclick="javascript:userLicenseUpdateAll();"><mink:message code="mink.web.text.assign.license"/></button></span>
		<span><button class='btn-dash' onclick="javascript:userLicenseDeleteAll();"><mink:message code="mink.web.text.recall.license"/></button></span>
	</div>
	<div id="miaps-content">
		<div id="miaps-in-content-left">
	    	<!-- 본문 -->
	    	<%--
			<div><h3><span>* 사용자 관리</span></h3></div>
			 --%>
			<div>
				<table class="userTable" border="0" cellspacing="0" cellpadding="0" width="100%">
					<thead>
						<%-- <tr><td class="subSearch">사용자 그룹</td></tr> --%>
						<tr id="groupBtnArea" style="border-bottom: 1px solid #dedede;"> <%-- 추가, 수정,삭제, 이동,↑,↓ 버튼은 스크립트에서 추가 --%>
							<td colspan="2" style="padding: 6px;"></td>
						</tr>
						<tr>
							<td colspan="2" style="padding: 6px;">
								<mink:message code="mink.web.text.groupname"/><input id="searchUserGroupName" name="searchUserGroupName" type="text" value="${search.searchUserGroupName}" />
								<span><button class='btn-dash' onclick="javascript:openSearchUserGroupNameDialog();"><mink:message code="mink.web.text.search"/></button></span>
							</td>
						</tr>
					</thead>
					<tbody>
						<tr>
							<th><a style="text-decoration: none;" href="javascript:showNaviInfo()"><mink:message code="mink.web.text.navi.group"/></a></th>
							<td id="selTreeGrpInfo_navi"></td>
						</tr>
						<tr id="grpNaviDetailInfo1" style="display: none;">
							<th><mink:message code="mink.web.text.groupname"/></th>
							<td id="selTreeGrpInfo_nm"></td>
						</tr>
						<tr id="grpNaviDetailInfo2" style="display: none;">
							<th><mink:message code="mink.web.text.groupid"/></th>
							<td id="selTreeGrpInfo_id"></td>
						</tr>
						<tr id="grpNaviDetailInfo3" style="display: none;">
							<th><mink:message code="mink.web.text.uppergroupid"/></th>
							<td id="selTreeGrpInfo_upid"></td>
						</tr>
						<tr><td colspan="2">
							<ul id="searchUserGroupTotalUl" class=twNodeStyle>
								<li id="searchUserGroupTreeviewTopLi" class="outerBulletStyle">
									<c:if test="${ynYes == loginUser.adminYn}">
									<a id="searchUserGroupCorporation" href="javascript:return false;">${corporationName}</a>
									</c:if>
									<c:if test="${ynNo == loginUser.adminYn}">
									<span>${corporationName}</span>
									</c:if>
									<ul id="searchUserGroupTreeviewUl" class="treeview"></ul>
								</li>
								<li class="outerBulletStyle">
									<a id="searchUserGroupUnclassified" href="javascript:return false;">${unclassifiedName}</a>
								</li>
							</ul>
						</td></tr>
					</tbody>
				</table>
			</div>
			
			
		</div>
		<div id="miaps-in-content-right">
			<form id="searchFrm" name="searchFrm" method="post" onSubmit="return false;">
				<!-- 검색 hidden -->
				<input type="hidden" id="searchUserGroupId" name="searchUserGroupId" /><!-- 검색(단일 그룹) // TODO: id='필수그룹검색요소' -->
				<input type="hidden" name="preSearchUserGroupId" /><!-- 검색그룹이 달라졌을 경우, 상세정보 없음 -->
				<input type="hidden" name="pageNum" />	<!-- 현재 페이지 -->
				<input type="hidden" name="preGrpId" /><!-- 사용자 그룹 구성원 이전 그룹ID -->
				<input type="hidden" name="createUserNo" value="${loginUser.userNo}" /><!-- 라이선스 생성자 -->
				<input type="hidden" name="assignUserNo" value="${loginUser.userNo}" /><!-- 라이선스 할당자 -->
				<input type="hidden" name="cancelUserNo" value="${loginUser.userNo}" /><!-- 라이선스 회수자 -->
				<input type="hidden" name="regNo" value="${loginUser.userNo}" />
				<input type="hidden" name="updNo" value="${loginUser.userNo}" />
				<input type="hidden" name="userNo" />
				<input type="hidden" name="grpId" />
				<input type="hidden" name="grpLevel" id="grpLevel" />
				<input type="hidden" name="searchUserGroup_upGrpId" id="searchUserGroup_upGrpId" />
				<input type="hidden" name="searchUserGroup_grpId" id="searchUserGroup_grpId" />
				<input type="hidden" name="searchUserGroup_grpCd" id="searchUserGroup_grpCd" />
				<input type="hidden" name="searchUserGroup_grpNm" id="searchUserGroup_grpNm" />
				<input type="hidden" name="searchUserGroup_grpNavigation" id="searchUserGroup_grpNavigation" />
				<input type="hidden" name="direction" /><!-- 선택한 사용자 그룹의 순서 변경 위치 -->
				<input type="hidden" name="upGrpId" /><!-- 선택한 사용자 그룹의 상위그룹ID (사용자그룹 이동시 사용) -->
				<input type="hidden" name="orderSeq" /><!-- 선택한 사용자 그룹의 순서 (사용자그룹 이동시 사용) -->
				<%--
				<div><h3><span>| 사용자 그룹 구성원</span></h3></div>
				 --%>
				<!-- 검색 화면 -->
				<div>
					<table class="search" border="0" cellspacing="0" cellpadding="0" width="100%">
						<tr>
							<td class="navigationTd">
								<span class="leftFloatSpan">
									<span id="searchUserGroupNavigationSpan"></span><!-- 그룹 네비게이션 // TODO: id='필수그룹검색요소' -->
									<span id="searchUserCountSpan"></span>
								</span>
								<span class="rightFloatSpan">
									<span><label><input type="checkbox" name="searchUserGroupSubAllYn" id="searchUserGroupSubAllChekbox" ${!empty search.searchUserGroupSubAllYn ? 'checked' : '' } value="${ynYes}" /><mink:message code="mink.web.text.include.under"/></label></span><!-- 하위그룹 검색포함여부 // TODO: id='필수그룹검색요소' -->
									<span><button id="searchUserGroupTreeviewDialogOpenerButton" class='btn-dash' style="display: none;"><mink:message code="mink.web.text.search.group"/></button></span><!-- 그룹 조직도(treeview) 다이얼로그 오프너 // TODO: id='필수그룹검색요소' -->
								</span>
							</td>
						</tr>
						<tr>
							<td class="search">
								<select name="searchAdminType">
									<option value="" ${search.searchAdminType == '' ? 'selected' : ''}><mink:message code="mink.web.text.all.permission"/></option>
									<option value="superAdmin" ${search.searchAdminType == 'superAdmin' ? 'selected' : ''}>${superAdmin}</option>
									<option value="subAdmin" ${search.searchAdminType == 'subAdmin' ? 'selected' : ''}>${subAdmin}</option>
									<option value="user" ${search.searchAdminType == 'user' ? 'selected' : ''}>${commUser}</option>
								</select>
								<select name="searchLicenseAssing">
									<option value="" ${search.searchLicenseAssing == '' ? 'selected' : ''}><mink:message code="mink.web.text.all.license"/></option>
									<option value="licenseAssingY" ${search.searchLicenseAssing == 'licenseAssingY' ? 'selected' : ''}><mink:message code="mink.web.text.assigning.license"/></option>
									<option value="licenseAssingN" ${search.searchLicenseAssing == 'licenseAssingN' ? 'selected' : ''}><mink:message code="mink.web.text.noassign.lisence"/></option>
								</select>
								<select name="searchKey">
									<option value="" ${search.searchKey == '' ? 'selected' : ''}><mink:message code="mink.web.text.totaluser"/></option>
									<option value="userId" ${search.searchKey == 'userId' ? 'selected' : ''}><mink:message code="mink.web.text.userid"/></option>
									<option value="userNo" ${search.searchKey == 'userNo' ? 'selected' : ''}><mink:message code="mink.web.text.userno"/></option>
									<option value="userNm" ${search.searchKey == 'userNm' ? 'selected' : ''}><mink:message code="mink.web.text.username"/></option>
								</select>
								<input type="text" name="searchValue" value="<c:out value='${search.searchValue}'/>"/>
								<select name="searchPageSize">
									<option value="10" ${search.searchPageSize == '10' ? 'selected' : ''}><mink:message code="mink.web.text.rows10"/></option>
									<option value="20" ${(search.searchPageSize == null || search.searchPageSize == '20') ? 'selected' : ''}><mink:message code="mink.web.text.rows20"/></option>
									<option value="50" ${search.searchPageSize == '50' ? 'selected' : ''}><mink:message code="mink.web.text.rows50"/></option>
									<option value="100" ${search.searchPageSize == '100' ? 'selected' : ''}><mink:message code="mink.web.text.rows100"/></option>
								</select>
								<button class='btn-dash' onclick="javascript:goUserListByPage('1');"><mink:message code="mink.web.text.search"/></button>
								<%--
								<button class='btn-dash' onclick="javascript:showLicenseStateTr();">라이선스관리</button>
								 --%>
							</td>
						</tr>
						<%--
						<tr id="licenseStateTr" style="display: none;">
							<td>
								<span id="licenseStateSpan" class="licenseInfoText"></span>
								<span class="rightFloatSpan">
								<span><button class='btn-dash' onclick="javascript:userLicenseInsert();">라이선스 키생성</button></span>
								<span><button class='btn-dash' onclick="javascript:userLicenseUpdateAll();">라이선스할당</button></span>
								<span><button class='btn-dash' onclick="javascript:userLicenseDeleteAll();">라이선스회수</button></span>
								</span>
							</td>
						</tr>
						 --%>
					</table>
				</div>
				
				<!-- 목록 화면 -->
				<div>
					<table id="userListTb" class="listTb" border="0" cellspacing="0" cellpadding="0" width="100%">
						<colgroup>
							<col width="6%" />
							<col width="30%" />
							<col width="24%" />
							<col width="10%" />
							<col width="10%" />
							<col width="10%" />
							<col width="10%" />
						</colgroup>
						<thead>
							<tr>
								<td><input type="checkbox" name="CheckboxAll" /></td>
								<td><mink:message code="mink.web.text.username.id"/></td>
								<td><mink:message code="mink.web.text.groupname"/></td>
								<td><mink:message code="mink.web.text.userno"/></td>
								<td><mink:message code="mink.web.text.permission"/></td>
								<td><mink:message code="mink.web.text.license"/></td>
								<td><mink:message code="mink.web.text.regdate"/></td>
							</tr>
						</thead>
						<tbody id="listTbody">
						</tbody>
						<tfoot></tfoot>
					</table>
				</div>
				<div id="paginateDiv"></div>
			</form>
		</div>
	</div>	
  	<div id="miaps-footer">
    	<%@ include file="/WEB-INF/jsp/include/footer.jsp" %>
  	</div>
  	</div>
</body>
</html>
