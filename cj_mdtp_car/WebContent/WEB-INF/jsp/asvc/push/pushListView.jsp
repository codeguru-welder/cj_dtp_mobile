<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="org.springframework.web.bind.annotation.SessionAttributes"%>
<%@ page import="com.thinkm.mink.commons.util.MinkConfig" %>
<%
	/*
	 * 어드민 푸시
	 * 푸시 관리 화면 - 목록 및 등록/수정/삭제 (pushDataListView.jsp)
	 * 
	 * @author juni
	 * @since 2014.03.13
	 */
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<%@ include file="/WEB-INF/jsp/include/wsACommonInclude.jsp" %>
<%@ include file="/WEB-INF/jsp/include/wsACommonHeadScript.jsp" %>
<title><mink:message code="mink.label.page_title"/></title>

<!-- 그룹검색 treeview dialog javascript -->
<%@ include file="/WEB-INF/jsp/include/searchUserGroupTreeviewDialogJavascript.jsp" %>

<script type="text/javascript">
// 더보기 실행 변수
var tgUserPageSize = "${search.pageSize}"; // PageUtil.pageSize = 20
var tgDevicePageSize = "${search.pageSize}"; // PageUtil.pageSize = 20

$(function() {
	
	// 그룹검색 treeview dialog
	actionSearchUserGroup();
		
	//accordion 선택 페이지를 유지하기위한 설정값 셋팅 ex) home:0 user:1, device:2, app:3, push:4, board:5, monitoring:6, setting:7
	init_accordion('push', '${loginUser.menuListString}');
	$("#topMenuTile").html("<mink:message code='mink.web.text.pushmanage_adminpush'/>");
	
	init(); // 이벤트 핸들러 세팅
	
	showList(); // 목록 보이기
	showPageHtml(); // 페이징 html 생성
	
	<%-- 앱 권한 탭 컨트롤 --%>
    $(".tab_content_appRole").hide();
    $(".tab_content_appRole:first").show();

    $("ul.tabs_appRole li").click(function () {
        $("ul.tabs_appRole li").removeClass("active").css("color", "#333");
        //$(this).addClass("active").css({"color": "darkred","font-weight": "bolder"});
        $(this).addClass("active").css("color", "#0459c1");
        $(".tab_content_appRole").hide();
        var activeTab = $(this).attr("rel");
        $("#" + activeTab).fadeIn();
        /* Sent 상태는 메세지상세 저장버튼 비활성환*/
        if($(this).attr("id") == "pushDetail" && $("#detailFrm").find("input[name='dataSt']").val() == "Sent") {
        	$("#btnSelectSave").hide();
    		$("#btnSelectSave").attr("disabled", true);
           // .addClass("ui-state-disabled");
        }else {
        	$("#btnSelectSave").show();
        	$("#btnSelectSave").attr("disabled", false);
           // .removeClass("ui-state-disabled");
        }
    });

 	if(eval('${!empty pushData}')) { 
		<%-- var dto = eval("("+'${pushData}'+")"); --%>
		<%
		String _strJson = "";
		if (request.getAttribute("pushData") instanceof PushData) {
		%>
			var dto = eval("("+'${pushData}'+")");
		<%
		} else if (request.getAttribute("pushData") instanceof String) {
			_strJson = (String) request.getAttribute("pushData");
			if (_strJson != null && _strJson.length() > 0) {
				_strJson = _strJson.replace("/", "\\/");
			}%>
			var dto = <%=_strJson%>;
		<%}%>
		
		fnDetailProcess(dto); // 상세정보 매핑
		checkedTrCheckbox($("#listTr"+dto.pushId)); // 선택한 tr 의 checkbox 에 체크선택/css 변경
	}
 	
});


var pushTargetUgList;	// 사용자그룹타겟목록(현재지정되어있는 그룹타겟, 그룹트리생성시 현재타겟으로 지정되어 있는지 확인하기 위한 변수정의)
var pushTargetUgDeleteList = [];	// 사용자그룹타겟테이블에서 삭제한 그룹ID목록(사용자그룹트리를 펼쳤을 경우 체크 해제 표시를 위한 정의)
var currTargetUgList = [];	// 현재사용자그룹 타겟테이블 목록(그룹트리에서 타겟을 지정할 때마다 타겟테이블에 추가 시 중복하여 제외하기 위한 정의)

// 그룹관리 트리 완료 후 지정된 타겟 체크 표시
function completeTreeview(treeview) {
	var id = $(treeview, "ul").eq(0).attr("id");
	
	// 푸시타겟 사용자그룹
	if( 'treeviewUlId' == id ) {
		if( pushTargetUgList != null ) {
			for(var i = 0; i < pushTargetUgList.length; i++) {
				$("#treeviewUlId").find(":checkbox[value='"+pushTargetUgList[i].targetId+"']").prop("checked", true);
			}
		}
		for(var j = 0; j < pushTargetUgDeleteList.length; j++) {
			$("#treeviewUlId").find(":checkbox[value='"+pushTargetUgDeleteList[j]+"']").prop("checked", false);
		}
	}
	// 사용자그룹 검색(다이얼로그)
	else if( 'searchUserGroupTreeviewUl' == id ) {
		$("a", "#schUgTwdgDiv").css("background", "#FFFFFF");
		if("${corporation}" == $("#selectUserGroupId").val()) $("#searchUserGroupCorporation").css("background", "#FFD700"); // check 된 css 적용
		else if("${unclassified}" == $("#selectUserGroupId").val() || '' == $("#selectUserGroupId").val()) $("#searchUserGroupUnclassified").css("background", "#FFD700"); // check 된 css 적용
		else {
			$("a", treeview).each(function(idx, a){
				if( $("#selectUserGroupId").val() == $(a).data("grp").grpId ) {
					$(a).css("background", "#FFD700"); // check 된 css 적용
				}
			});
		}
	}
}

//목록검색
function goList(pageNum) {
	<%-- XSS 방어 --%>
	var _searchVal = defenceXSS(document.SearchFrm.searchValue.value); 
	document.SearchFrm.searchValue.value = _searchVal;
	
	document.SearchFrm.pageNum.value = pageNum; // 이동할 페이지
	document.SearchFrm.action = 'pushDataListView.miaps?';
	document.SearchFrm.submit(); 
}

// 타겟 저장
function goUpdateTarget() {
	var msg = "";
	var dataSt = $("#detailFrm").find("input[name='dataSt']").val();
	if("Targeted" == dataSt || "Sent" == dataSt) msg = "<mink:message code='mink.alert.already.target'/>" + "\n";
	
	if(!confirm(msg + "<mink:message code='mink.web.alert.is.savetarget'/>")) return;
	ajaxComm('pushTargetUpdate.miaps?', $("form[name='pushTargetFrm']"), function(data){
		alert(data.msg);
	});
}

function popupInsert() {
	$("#pushListInsertDialog").dialog("open");
}
	
// 등록/재발송(ajax) 후 목록 호출
/* function goInsert(mode) {
	var alertText = "등록하시겠습니까?";
	var $frm = $('#insertFrm');
	
	// 재발송인 경우
	if('resend' == mode) {
		alertText = "재발송하시겠습니까?";
		$frm = $('#detailFrm');
		$frm.find("input[name='resendYn']").val("Y");
	}
	
	var reservedDt = reservedDtToDate($frm);
	$frm.find("input[name='reservedDt']").val(reservedDt);
	
	if( validation($frm) ) return; // 입력 값 검증
	
	if( !confirm(alertText) ) return;
	ajaxFileComm('pushDataInsert.miaps?', $frm, function(data){
		$("#SearchFrm").find("input[name='pushId']").val(data.pushData.pushId); // (등록한)상세
		goList('1'); // 목록/검색(1 페이지로 초기화)
	});
} */

// 예약일시 셋팅
function reservedDtToDate(frm) {
	var reservedDd = frm.find($("input[name='reservedDd']")).val();
	var reservedHh = frm.find($("select[name='reservedHh']")).val();
	var reservedMm = frm.find($("select[name='reservedMm']")).val();
	if( reservedDd != null && reservedDd != "" ){
		reservedDd = reservedDd.replace(/-/g, "") + reservedHh + reservedMm + "00";
	} else {
		reservedDd = "";
	}
		
	return reservedDd;
}

// 수정(ajax) 후 목록 호출
function goUpdate() {
	var reservedDt = reservedDtToDate($("#detailFrm"));
	$("#detailFrm").find("input[name='reservedDt']").val(reservedDt);
	
	if(validation($("#detailFrm"))) return; // 입력 값 검증
	if(!confirm("<mink:message code='mink.web.alert.is.save'/>")) return;
	
	ajaxFileComm('pushDataUpdate.miaps?', $('#detailFrm'), function(data){
		resultMsg(data.msg);
		$("#SearchFrm").find("input[name='pushId']").val(data.pushData.pushId);	// 상세조회 key
		goList($("#SearchFrm").find("input[name='pageNum']").val()); // 목록/검색
	});
}

// 삭제(ajax) 후 목록 호출
function goDelete() {
	if(!confirm("<mink:message code='mink.web.alert.is.delete'/>")) return;
	
	ajaxComm('pushDataDeleteAll.miaps?', $('#detailFrm'), function(data){
		resultMsg(data.msg);
		$("#SearchFrm").find("input[name='pushId']").val(data.pushData.pushId); // (삭제한)상세 비움
		goList($("#SearchFrm").find("input[name='pageNum']").val()); // 목록/검색
	});
}

//여러개 삭제요청(ajax)
function goDeleteAll() {
	// 검증
	if($("#listTbody").find(":checkbox:checked").length < 1) {
		alert("<mink:message code='mink.web.alert.select.deleteitem'/>");
		return;
	}
	
	if( !confirm("<mink:message code='mink.web.alert.is.delete'/>") ) return;
	ajaxComm('pushDataDeleteAll.miaps?', $('#SearchFrm'), function(data){
		document.SearchFrm.pushId.value = ''; // (삭제한)상세 비움
		goList($("#SearchFrm").find("input[name='pageNum']").val()); // 목록/검색
	});
	
}

//상세조회호출(ajax)
function goDetail(pushId, taskId) {
	checkedTrCheckbox($("#listTr"+pushId));	// 선택된 row 색깔변경
	$("#detailFrm").find("input[name='pushId']").val(pushId); // (선택한)상세
	ajaxComm('pushDataDetail.miaps', $('#detailFrm'), function(data){
		var result = data.pushData;
		
		// 푸시관리 상세정보 결과
		fnDetailProcess(result); 
	});

	// 첫번째 탭 선택
	$("ul.tabs_appRole li:first").click();

	$("#pushListDetailDialog").dialog("open");
}



// 관리목록 상세정보 조회 시 초기화
function leftInit() {
	
	$("#treeviewUlId").remove();
	$("#treeviewUlIdDiv").append("<ul id='treeviewUlId' class='treeview'></ul>");
	
	// 사용자그룹 트리
	treeviewAlinkCheckboxAfterReset('../user/userGroupListTreeview.miaps?', '#treeviewUlId', '#treeviewUlIdDiv');
	
	// 사용자관리
	fnSetUserList("", "");
	// 장치관리
	fnSetDeviceList("", "");
}

// 푸시 추가 데이터 항목 추가 버튼
function addUserData(frmName) {
	fnCreateUserDataRow(null, "tblIns_UserData", "insUserData", "", "", null);
}

// 푸시 추가 데이터 입력을 초기화함
function fnInitializeUserDataRow(frm, tblId) {
	var table = $("#" + tblId);

	var rows = table.find("tr[trtype='added']");
	if(rows.length > 0) {
		for (var i = rows.length - 1; i >= 0; i--) {
			rows[i].remove();
		}
	}

	var addedFields = table.find("input");
	if (addedFields.length > 0) {
		for ( var i = 0; i < addedFields.length; i++ ) {
			addedFields[i].value = "";
		}
	}
}

//푸시 추가 데이터 항목을 테이블 목록에 추가함
function fnCreateUserDataRow(frm, tblId, namePrefix, key, value, readonly) {
	var tr = $("<tr>").attr("trtype", "added");

	var inputKey = $("<input>").attr("type", "text").attr("name", namePrefix + "Key").attr("value", key);
	if (readonly != null) inputKey.attr("readonly", readonly)
	tr.append($("<th>").append(inputKey));

	var inputValue = $("<input>").attr("type", "text").attr("name", namePrefix + "Value").attr("value", value);
	if (readonly != null) inputValue.attr("readonly", readonly);
	tr.append($("<td>").append(inputValue));

	$("#" + tblId).find("tbody").append(tr);
}

//ajax 로 가져온 data 를 알맞은 위치에 삽입
function fnAjaxInfoMapping(result) {
	// 상세화면 정보 출력
	var frm = $("#detailFrm");
	frm.find("input[name='pushId']").val(result.pushId);
	frm.find("input[name='prePushId']").val(result.pushId);
	// task 목록
	var taskNm = "";
	var packageNm = "";
	for(var i = 0; i < result.pushTaskList.length; i++) {
		var task = result.pushTaskList[i];
		taskNm += "&nbsp;&nbsp;- "+ defenceXSS(task.taskNm) + "("+task.taskId+")" 
			    + "<input type='hidden' name='taskIds' value='"+task.taskId+"' /><br />";
		packageNm += "&nbsp;&nbsp;- "+ defenceXSS(task.packageNm) + "&nbsp;("+defenceXSS(task.taskNm)+")" + "<br />";
	}
	frm.find("#taskIdPos").html(taskNm);
	frm.find("#packageNm").html(packageNm);
	var dataSt = "";
	if( result.dataSt == '${PUSH_DATA_ST_NEW}' ) {
		dataSt = "New";
	} else if( result.dataSt == '${PUSH_DATA_ST_DELETED}' ) {
		dataSt = "Delete";
	} else if( result.dataSt == '${PUSH_DATA_ST_TARGETED}' ) {
		dataSt = "Targeted";
	} else if( result.dataSt == '${PUSH_DATA_ST_SENT}' ) {
		dataSt = "Sent";
	} else {
		dataSt = result.dataSt;
	}
	frm.find("input[name='dataSt']").val(dataSt);
	/* Sent일 경우 저장하기 버튼 비표시 */
	if (dataSt == "Sent") {
		$("#btnSelectSave").hide();
		$("#btnSelectSave").attr("disabled", true)
        //.addClass("ui-state-disabled");
	} else {
		$("#btnSelectSave").show();
		$("#btnSelectSave").attr("disabled", false)
        //.removeClass("ui-state-disabled");
	}
	
	
	frm.find("textarea[name='pushMsg']").val(result.pushMsg);
	// 예약일시 mapping
	var strDate = result.reservedDt;
	frm.find("input[name='reservedDd']").val(strDate.substring(0, 10));
	
	var reservedHh = strDate.substring(11,13);
	if('' == reservedHh) reservedHh = '00';
	
	var reservedMm = strDate.substring(14,16);
	if('' == reservedMm) reservedMm = '00';
	
	frm.find("select[name='reservedHh']").val(reservedHh);
	frm.find("select[name='reservedMm']").val(reservedMm);
	frm.find("input[name='sendStartDt']").val(result.sendStartDt);
	frm.find("input[name='sendEndDt']").val(result.sendEndDt);
	frm.find("input[name='resultCd']").val(result.resultCd);
	frm.find("input[name='resultMsg']").val(result.resultMsg);
	frm.find("input[name='regNm']").val(result.regNm);
	frm.find("input[name='regDt']").val(result.regDt);
	
	frm.find("input[name='badgeCnt']").val(result.badgeCnt);

	if ("${pushType}" == "PREMIUM") {
		var msgTp = result.msgTp;
		if ('' == msgTp) msgTp = "Text";
		frm.find("select[name='msgTp']").val(msgTp);
		frm.find("input[name='imgUrl']").val(result.imgUrl);
		
		if ('N' == result.imgUrlYn) frm.find("input[name='imgUrlYn']").get(0).checked = true;
		else frm.find("input[name='imgUrlYn']").get(0).checked = false;

		// 사용자 데이터 항목 처리 - 2018/09/12
		fnInitializeUserDataRow(frm, "tblDtl_UserData");
		var adData = result.addedDetailData;
		if (Array.isArray(adData)) {
			for (var i = 0; i < adData.length; i++) {
				var d = adData[i];
				var name = "dtlUserData_" + d.key;
				var ele = frm.find("input[name='" + name + "']");
				if (ele.length > 0) {
					if (d.value != null) ele.val(d.value);
				} else {
					// 찾은 input이 없으면 row를 생성함
					fnCreateUserDataRow(frm, "tblDtl_UserData", "dtlUserData", d.key, d.value == null ? "" : d.value, "readonly");
				}
			}
		}
	}
	
	// 공통key
	$(".tab_container_appRole").find("input[name='pushId']").val(result.pushId);
	pushTargetUgList = result.pushTargetList.UG;
	for(var i=0; i < result.pushTargetList.UG.length; i++ ) {
		currTargetUgList.push(result.pushTargetList.UG[i].targetId);
	}
	
	// 각 검색 폼 초기화
	$("#userSearchFrm")[0].reset();
	$("#deviceSearchFrm")[0].reset();
	
	// 왼쪽목록 초기화
	leftInit();
	
	// 지정된 타겟목록
	fnSetTargetList(result.pushTargetList.UG, "ugListTb", "ugDiv");
	fnSetTargetList(result.pushTargetList.UN, "unListTb", "unDiv");
	fnSetTargetList(result.pushTargetList.UD, "udListTb", "udDiv");
	fnSetTargetList(result.pushTargetList.DD, "ddListTb", "ddDiv");
	
	htmlEscapeAll(document); // 특수문자 전체 변환
	
	// 푸시가 전송된 상태인 경우, 재발송 버튼 보임
	// 기능 사용안함(2014.09.23) '타겟저장' 버튼을 다시 누르면 재발송 됨
	/* if(dataSt == "Sent") $("#resendPushBtn").show();
	else $("#resendPushBtn").hide(); */
}

/** 
 * 타겟목록 결과(테이블 내용 삭제 후 head를 복사하여 값 셋팅하는 방식)
 * targetList: 적용할 타겟목록
 * tb: 적용될 테이블 id명
 * div: 적용될 div명
 */
function fnSetTargetList(targetList, tb, div) {
	
	$("#"+tb+" > tbody > tr").remove();	// tbody내용 삭제 (tbody 밑의 tr 삭제)
	$("#"+tb+" > thead > tr").find("td:eq(0)").find(":checkbox").attr("checked", false);	// head checkbox checked 초기화
	if( targetList.length > 0 ) {	// 결과 목록이 있을 경우
		for(var i = 0; i < targetList.length; i++) {
			var newRow;
			newRow = $("#"+tb+" > thead > tr").clone(); // head row 복사
			newRow.removeClass();
			var obj = targetList[i];
			// hidden값 셋팅
			var hiddenStr = "<input type=\"hidden\" name=\"targetTps\" value=\""+obj.targetTp+"\" />"
						  + "<input type=\"hidden\" name=\"targetIds\" value=\""+obj.targetId+"\" />";
		  	var j = 0;
		  	newRow.find("td:eq(0)").html(newRow.find("td:eq(0)").html()+hiddenStr);
			newRow.find("td:eq(0)").find("input:checkbox").val(obj.targetId);	// checkbox의 value로 타겟목록에서 제거했을 경우 트리에서 체크해제
			newRow.find("td:eq(0)").find("input:checkbox").bind("click", function(event){
				checkedCheckboxInTr(event);
			});
			if( div == "ugDiv" ) {
				var grpNaviInfoLink = "<a href=\"javascript: void(0);\" onclick=\"javascript:showSearchUserGroupNaviDialog('" + obj.targetId + "');\">" + defenceXSS(obj.grpNm) + "</a>";
				newRow.find("td:eq(1)").attr("align", "left").html(grpNaviInfoLink);
				newRow.find("td:eq(2)").html(obj.targetId); 
				var includeSubYnChecked = "";	// 하위포함여부 체크
				if( -1 < obj.includeSubYn.indexOf('Y') ) includeSubYnChecked = "checked";
				newRow.find("td:eq(3)").html("<input type=\"checkbox\" name=\"includeSubYns\" value=\""+obj.targetId+"\" "+includeSubYnChecked+" onclick=\"checkedCheckboxInTr_doNotChangedCSS(event)\" />");
			} else if( div == "unDiv" ) {
				var userInfoLink = "<a href=\"javascript: void(0);\" onclick=\"javascript:showSearchUserDetailDialog('" + obj.targetId + "');\">" + nvl(defenceXSS(obj.userNm)) + setBracket(defenceXSS(obj.userId)) + "</a>";
				if (obj.targetId == null || obj.targetId == "") userInfoLink = "";
				newRow.find("td:eq(1)").attr("align", "left").html(userInfoLink);
				newRow.find("td:eq(2)").html(obj.targetId); 
				//newRow.find("td:eq(3)").html(obj.userGrpNm);
			} else if( div == "udDiv" ) {
				var userInfoLink = "<a href=\"javascript: void(0);\" onclick=\"javascript:showSearchUserDetailDialog('" + nvl(obj.userNo) + "');\">" + nvl(defenceXSS(obj.userNm)) + setBracket(defenceXSS(obj.userId)) + "</a>";
				if (obj.userNo == null || obj.userNo == "") userInfoLink = nvl(defenceXSS(obj.userNm)) + setBracket(defenceXSS(obj.userId));
				newRow.find("td:eq(1)").attr("align", "left").html(userInfoLink);
				newRow.find("td:eq(2)").html(nvl(obj.userNo)); 
			} else if( div == "ddDiv" ) {
				if( nvl(obj.deviceUserId) != "" ) {
					var userInfoLink = "<a href=\"javascript: void(0);\" onclick=\"javascript:showSearchUserDetailDialog('" + obj.deviceUserNo + "');\">" + nvl(obj.deviceUserNm) + setBracket(obj.deviceUserId) + "</a>";
					if (obj.deviceUserNo == null) userInfoLink = "";
					newRow.find("td:eq(1)").attr("align", "left").html(userInfoLink);
				} else {
					newRow.find("td:eq(1)").attr("align", "left").html("");
				}
				newRow.find("td:eq(2)").attr("align", "left").html(obj.targetId); 
				//newRow.find("td:eq(4)").html(obj.devicePhoneNo);
				//newRow.find("td:eq(5)").html(obj.deviceActiveSt);
				//newRow.find("td:eq(6)").html(obj.regDt);
			}

			newRow.click(function(){
				clickTrCheckedCheckbox(this);
			});

			$("#"+tb+" > tbody").append(newRow); 	// body 끝에 추가
		}	
		
	} else {	// 결과 목록이 없을 경우
		var emptyRow = "<tr id=\""+tb+"EmptyTr\"><td colspan='"+$("#"+tb+" > thead > tr > td").length+"' align='center'><mink:message code='mink.web.text.noexist.inquiry'/></td></tr>";
		$("#"+tb+" > tbody").append(emptyRow);
	}
	$("#"+div).show();
}

// 사용자관리 목록 조회
function goUserList(pageNum){
	// 더보기 실행 변수 초기화
	$("#userSearchFrm").find(":input[name='startRow']").val("1");
	
	$("#userSearchFrm").find("input[name='pageNum']").val(pageNum); // (선택한)상세
	$("#userSearchFrm").find("input[name='pushId']").val($(".tab_container_appRole").find("input[name='pushId']").val()); // 목록조회시 구분 key
	ajaxComm('../user/userListSearch.miaps?', $('#userSearchFrm'), function(data){
		
		// 목록내용
		fnSetUserList(data.userList, data.search);
		
		// 검색조건
		$('#userSearchFrm').find("select[name='searchKey']").val(data.search.searchKey);
		$('#userSearchFrm').find("input[name='searchValue']").val(data.search.searchValue);
		
		// 페이징 조건 재설정 후 페이징 html 생성
		//showPageHtml2(data, $("#paginateDiv2"), "goUserList"); 
	});
}

// 사용자관리 목록 조회 결과
function fnSetUserList(targetList, search) {
	var tb = "userListTb";

	$("#"+tb+" > tbody > tr").remove();	// tbody내용 삭제 (tbody 밑의 tr 삭제)
	$("#"+tb+" > thead > tr").find("td:eq(0)").find(":checkbox").attr("checked", false);	// head checkbox checked 초기화
	if( targetList.length > 0 ) {	// 결과 목록이 있을 경우
		for(var i = 0; i < targetList.length; i++) {
			
			var newRow = $("#"+tb+" > thead > tr").clone(); // head row 복사
			newRow.children("td:not(:first)").html("");	// td 내용 초기화
			newRow.removeClass();
			var obj = targetList[i];
			var hiddenStr = "<input type=\"hidden\" name=\"targetTps\" value=\"UN\" />"
			 			  + "<input type=\"hidden\" name=\"targetIds\" value=\""+obj.userNo+"\" />";
			var j = 0;
			newRow.find("td:eq("+j+")").html(newRow.find("td:eq("+j+++")").html()+hiddenStr);
			newRow.find("td:eq(0)").find("input:checkbox").bind("click", function(event){
				checkedCheckboxInTr(event);
			});
			var grpNm = "";
			if( obj.userGroup == null ) grpNm = "${unclassifiedName}";
			else grpNm = defenceXSS(obj.userGroup.grpNm);
			newRow.find("td:eq("+j+++")").attr("align", "left").html("<a href=\"javascript: void(0);\" onclick=\"javascript:showSearchUserDetailDialog("+obj.userNo+")\">"+nvl(defenceXSS(obj.userNm))+setBracket(defenceXSS(obj.userId))+"</a>"); 
			newRow.find("td:eq("+j+++")").html(obj.userNo); 
			//newRow.find("td:eq("+j+++")").html(grpNm);

			newRow.click(function(){
				clickTrCheckedCheckbox(this);
			});

			$("#"+tb+" > tbody").append(newRow); 	// body 끝에 추가
		};
	} else {	// 결과 목록이 없을 경우
		var emptyRow = "<tr id=\""+tb+"EmptyTr\"><td colspan='"+$("#"+tb+" > thead > tr > td").length+"' align='center'>" + "<mink:message code='mink.web.text.noexist.inquiry'/>" + "</td></tr>";
		$("#"+tb+" > tbody").append(emptyRow);
	}
	
	$("#moreUserDiv").hide();
	if(tgUserPageSize == $("#"+tb+" > tbody > tr").length) {
		$("#moreUserDiv").show(); // 더보기 사용자찾기 보이기
	}
	
}

// 더보기 사용자찾기
function moreUser() {
	var startRow = $("#userSearchFrm").find(":input[name='startRow']").val();
	startRow = Number(startRow) + Number(tgUserPageSize);
	$("#userSearchFrm").find(":input[name='startRow']").val(startRow);
	
	var pageSize = $("#userSearchFrm").find(":input[name='pageSize']").val();
	tgUserPageSize = pageSize;
	
	// 사용자관리 목록 조회
	$("#userSearchFrm").find("input[name='pushId']").val($(".tab_container_appRole").find("input[name='pushId']").val()); // 목록조회시 구분 key
	ajaxComm('../user/userListSearch.miaps?', $('#userSearchFrm'), function(data){
		var targetList = data.userList;
		
		// 사용자관리 목록 조회 결과
		//$("#"+tb+" > tbody > tr").remove();	// tbody내용 삭제 (tbody 밑의 tr 삭제)
		$("#userListTb"+" > thead > tr").find("td:eq(0)").find(":checkbox").attr("checked", false);	// head checkbox checked 초기화
		if( targetList.length > 0 ) {	// 결과 목록이 있을 경우
			for(var i = 0; i < targetList.length; i++) {
				newRow = $("#userListTb"+" > thead > tr").clone(); // head row 복사
				newRow.children("td:not(:first)").html("");	// td 내용 초기화
				newRow.removeClass();
				var obj = targetList[i];
				var hiddenStr = "<input type=\"hidden\" name=\"targetTps\" value=\"UN\" />"
				 			  + "<input type=\"hidden\" name=\"targetIds\" value=\""+obj.userNo+"\" />";
				var j = 0;
				newRow.find("td:eq("+j+")").html(newRow.find("td:eq("+j+++")").html()+hiddenStr);
				newRow.find("td:eq(0)").find("input:checkbox").bind("click", function(event){
					checkedCheckboxInTr(event);
				});
				var grpNm = "";
				if( obj.userGroup == null ) grpNm = "${unclassifiedName}";
				else grpNm = obj.userGroup.grpNm;
				newRow.find("td:eq("+j+++")").attr("align", "left").html("<a href=\"javascript: void(0);\" onclick=\"javascript:showSearchUserDetailDialog("+obj.userNo+")\">"+nvl(defenceXSS(obj.userNm))+setBracket(defenceXSS(obj.userId))+"</a>"); 
				newRow.find("td:eq("+j+++")").html(obj.userNo); 
				//newRow.find("td:eq("+j+++")").html(grpNm);

				newRow.click(function(){
					clickTrCheckedCheckbox(this);
				});

				$("#userListTb"+" > tbody").append(newRow); 	// body 끝에 추가
			}
		}
		
		if( targetList.length < 1 ) {
			$("#moreUserDiv").hide(); // 더보기 사용자찾기 숨기기
			//alert("사용자를 모두 검색했습니다.");
		}
	});
}

// 장치관리 목록 조회
function goDeviceList(pageNum){
	// 더보기 실행 변수 초기화
	$("#deviceSearchFrm").find(":input[name='startRow']").val("1");
	
	$("#deviceSearchFrm").find("input[name='pageNum']").val(pageNum); // (선택한)상세
	$("#deviceSearchFrm").find("input[name='pushId']").val($(".tab_container_appRole").find("input[name='pushId']").val()); // 목록조회시 구분 key
	ajaxComm('../device/deviceListView.miaps', $('#deviceSearchFrm'), function(data){
		// 목록내용
		fnSetDeviceList(data.deviceList, data.search);
		
		
		
		// 검색조건
		$('#deviceSearchFrm').find("select[name='searchKey']").val(data.search.searchKey);
		$('#deviceSearchFrm').find("input[name='searchValue']").val(data.search.searchValue);
		
		// 페이징 조건 재설정 후 페이징 html 생성
		//showPageHtml2(data, $("#paginateDiv3"), "goDeviceList"); 
	});
	
}

// 장치관리 목록 조회 결과
function fnSetDeviceList(targetList, search) {
	var tb = "deviceListTb";
	
	var pageSize = $("#deviceSearchFrm").find(":input[name='pageSize']").val();
	tgDevicePageSize = pageSize;
	
	$("#"+tb+" > tbody > tr").remove();	// tbody내용 삭제 (tbody 밑의 tr 삭제)
	$("#"+tb+" > thead > tr").find("td:eq(0)").find(":checkbox").attr("checked", false);	// head checkbox checked 초기화
	if( targetList.length > 0 ) {	// 결과 목록이 있을 경우
		for(var i = 0; i < targetList.length; i++) {
			newRow = $("#"+tb+" > thead > tr").clone(); // head row 복사
			newRow.children("td:not(:first)").html("");	// td 내용 초기화
			newRow.removeClass();
			var obj = targetList[i];
			var hiddenStr = "<input type=\"hidden\" name=\"targetTps\" value=\"DD\" />"
			 			  + "<input type=\"hidden\" name=\"targetIds\" value=\""+obj.deviceId+"\" />";

			var userInfoLink = "<a href=\"javascript: void(0);\" onclick=\"javascript:showSearchUserDetailDialog('" + obj.userNo + "');\">" + nvl(defenceXSS(obj.userNm)) + setBracket(defenceXSS(obj.userId)) + "</a>";
			if (obj.userNo == null || obj.userNo == "") userInfoLink = "";

			var j = 0;
			newRow.find("td:eq("+j+")").html(newRow.find("td:eq("+j+++")").html()+hiddenStr);
			newRow.find("td:eq(0)").find("input:checkbox").bind("click", function(event){
				checkedCheckboxInTr(event);
			});
			newRow.find("td:eq("+j+++")").attr("align", "left").html(userInfoLink);
			newRow.find("td:eq("+j+++")").attr("align", "left").html(obj.deviceId);
			/* newRow.find("td:eq("+j+++")").html(obj.phoneNo);
			newRow.find("td:eq("+j+++")").html(obj.activeSt);
			newRow.find("td:eq("+j+++")").html(obj.regDt); */

			newRow.click(function(){
				clickTrCheckedCheckbox(this);
			});

			$("#"+tb+" > tbody").append(newRow); 	// body 끝에 추가
		};
	} else {	// 결과 목록이 없을 경우
		var emptyRow = "<tr id=\""+tb+"EmptyTr\"><td colspan='"+$("#"+tb+" > thead > tr > td").length+"' align='center'>" + "<mink:message code='mink.web.text.noexist.inquiry'/>" + "</td></tr>";
		$("#"+tb+" > tbody").append(emptyRow);
	}
	
	$("#moreDeviceDiv").hide();
	if(tgDevicePageSize == $("#"+tb+" > tbody > tr").length) {
		$("#moreDeviceDiv").show(); // 더보기 장치찾기 보이기
	}
	
}

// 더보기 장치찾기
function moreDevice() {
	var startRow = $("#deviceSearchFrm").find(":input[name='startRow']").val();
	startRow = Number(startRow) + Number(tgDevicePageSize);
	$("#deviceSearchFrm").find(":input[name='startRow']").val(startRow);
	
	var pageSize = $("#deviceSearchFrm").find(":input[name='pageSize']").val();
	tgDevicePageSize = pageSize;
	
	$("#deviceSearchFrm").find("input[name='pushId']").val($(".tab_container_appRole").find("input[name='pushId']").val()); // 목록조회시 구분 key
	ajaxComm('../device/deviceListView.miaps', $('#deviceSearchFrm'), function(data){
		var targetList = data.deviceList;
		
		// 장치관리 목록 조회 결과
		//$("#"+tb+" > tbody > tr").remove();	// tbody내용 삭제 (tbody 밑의 tr 삭제)
		$("#deviceListTb"+" > thead > tr").find("td:eq(0)").find(":checkbox").attr("checked", false);	// head checkbox checked 초기화
		if( targetList.length > 0 ) {	// 결과 목록이 있을 경우
			for(var i = 0; i < targetList.length; i++) {
				newRow = $("#deviceListTb"+" > thead > tr").clone(); // head row 복사
				newRow.children("td:not(:first)").html("");	// td 내용 초기화
				newRow.removeClass();
				var obj = targetList[i];
				var hiddenStr = "<input type=\"hidden\" name=\"targetTps\" value=\"DD\" />"
				 			  + "<input type=\"hidden\" name=\"targetIds\" value=\""+obj.deviceId+"\" />";

				var userInfoLink = "<a href=\"javascript: void(0);\" onclick=\"javascript:showSearchUserDetailDialog('" + obj.userNo + "');\">" + nvl(defenceXSS(obj.userNm)) + setBracket(defenceXSS(obj.userId)) + "</a>";
				if (obj.userNo == null || obj.userNo == "") userInfoLink = "";

				var j = 0;
				newRow.find("td:eq("+j+")").html(newRow.find("td:eq("+j+++")").html()+hiddenStr);
				newRow.find("td:eq(0)").find("input:checkbox").bind("click", function(event){
					checkedCheckboxInTr(event);
				});
				newRow.find("td:eq("+j+++")").attr("align", "left").html(userInfoLink);
				newRow.find("td:eq("+j+++")").attr("align", "left").html(obj.deviceId);
				/* newRow.find("td:eq("+j+++")").html(obj.phoneNo);
				newRow.find("td:eq("+j+++")").html(obj.activeSt);
				newRow.find("td:eq("+j+++")").html(obj.regDt); */

				newRow.click(function(){
					clickTrCheckedCheckbox(this);
				});

				$("#deviceListTb"+" > tbody").append(newRow); 	// body 끝에 추가
			};
		}
		
		if( targetList.length < 1 ) {
			$("#moreDeviceDiv").hide(); // 더보기 장치찾기 숨기기
			//alert("장치를 모두 검색했습니다.");
		}
	});
}

// 타겟목록으로 이동(->)
function toRight() {
	
	// 그룹지정
	//if( $("#treeviewUlId input:checked").length > 0 ) $("#ugListTbEmptyTr").remove();		// 조회결과없음 메시지 삭제
	$("#ugListTbEmptyTr").remove();
	$("#treeviewUlId input:checked").each(function(idx, row){
		// 현재 타겟테이블(currTargetUgList)에 있는 것 제외 한 후 나머지 append 
		var appendObj = true;
		for(var i =0; i<currTargetUgList.length; i++) {
			if( $(row).val() == currTargetUgList[i] ) appendObj = false;
		}

		// 나머지 append 
		if( appendObj ) {
			var curr = $(row).parents("li");
			var grpId = $(row).val();
			var grpNm = defenceXSS($(row).siblings("a").text());
			var newTarget = "<tr><td><input type=\"checkbox\" name=\"ugCheckbox\" value=\""+grpId+"\" onclick=\"checkedCheckboxInTr(event);\" />"
								  + "<input type=\"hidden\" name=\"targetTps\" value=\"UG\" />"
								  + "<input type=\"hidden\" name=\"targetIds\" value=\""+grpId+"\" />"
							  + "</td>"
							  + "<td align='left'><a href=\"javascript:javascript: void(0);\" onclick=\"showSearchUserGroupNaviDialog('"+grpId+"');\">"+grpNm+"</a></td>"
							  + "<td>"+grpId+"</td>"
							  + "<td><input type=\"checkbox\" name=\"includeSubYns\" value=\""+grpId+"\" onclick=\"checkedCheckboxInTr_doNotChangedCSS(event)\" /></td></tr>";
			$("#ugListTb > tbody:last").append(newTarget);

			$("#ugListTb > tbody tr").unbind("click");
			$("#ugListTb > tbody tr").click(function(){
				clickTrCheckedCheckbox(this);
			});

		}
		currTargetUgListInit();	// 현재 타겟테이블(currTargetUgList) 셋팅
	});
	
	// 사용자지정
	if( $("#userListTb > tbody input:checked").length > 0 ) $("#unListTb #unListTbEmptyTr").remove();		// 조회결과없음 메시지 삭제
	$("#userListTb > tbody input:checked").each(function(idx, row){
		$(row).attr("checked", false);
		var curr = $(row).parents("tr");
		$("#unListTb > tbody:last").append(curr);
	});
	
	// 장치지정
	if( $("#deviceListTb > tbody input:checked").length > 0 ) $("#ddListTb #ddListTbEmptyTr").remove();		// 조회결과없음 메시지 삭제
	$("#deviceListTb > tbody input:checked").each(function(idx, row){
		$(row).attr("checked", false);
		var curr = $(row).parents("tr");
		curr.removeClass();
		$("#ddListTb > tbody:last").append(curr);
	
	});

}

// 현재 타겟테이블(currTargetUgList) 내용 초기화 후 새로 현 시점의 테이블 내용으로 변경
function currTargetUgListInit() {
	var $allTr = $("#ugListTb").find("tbody").find("tr"); // 모든 rt
	currTargetUgList = [];
	$allTr.each(function(i){
		currTargetUgList.push($(this).find(":hidden[name=targetIds]").val());
	});
}

// 관리목록으로 이동(<-)
function toLeft() {
	
	// 사용자그룹 타겟목록
	$("#ugListTb > tbody tr td:first-child input:checked").each(function(idx, row){
		var curr = $(row).parents("tr");
		$("#treeviewUlId").find(":checkbox[value='"+$(row).val()+"']").prop("checked", false);
		curr.remove();
		pushTargetUgDeleteList.push($(row).val());
		currTargetUgListInit();
	});
	
	// 사용자타겟목록
	$("#unListTb > tbody input:checked").each(function(idx, row){
		$(row).attr("checked", false);
		var curr = $(row).parents("tr");
		$("#userListTb > tbody:last").append(curr);
	});

	// 장치타겟목록
	$("#ddListTb > tbody input:checked").each(function(idx, row){
		$(row).attr("checked", false);
		var curr = $(row).parents("tr");
		$("#deviceListTb > tbody:last").append(curr);
	});
	
	
}
	
function pushDetailTabOn() {
	$("#treeviewUlId > input:checked").attr("checked", "");
	$("#userListTb > input:checked").attr("checked", "");
	$("#deviceListTb > input:checked").attr("checked", "");
}

//사용자그룹관리 탭 클릭
function userGroupTabOn(onDiv) {
	$("#detailTb > input:checked").attr("checked", "");
	$("#userListTb > input:checked").attr("checked", "");
	$("#deviceListTb > input:checked").attr("checked", "");
}

//사용자관리 탭 클릭
function userTabOn() {
	$("#detailTb > input:checked").attr("checked", "");
	$("#treeviewUlId > input:checked").attr("checked", "");
	$("#deviceListTb > input:checked").attr("checked", "");
	//goUserList("1");
	$("#userGroupDiv").hide();
	$("#userDiv").show();
	$("#deviceDiv").hide();
}

//장치관리 탭 클릭
function deviceTabOn() {
	$("#detailTb > input:checked").attr("checked", "");
	$("#userListTb > input:checked").attr("checked", "");
	$("#treeviewUlId > input:checked").attr("checked", "");
	//goDeviceList("1");
	$("#userGroupDiv").hide();
	$("#userDiv").hide();
	$("#deviceDiv").show();
}

//입력 값 검증
function validation(frm) {
	var result = false;
	
	if( frm.find("#taskIdSetYn").val() == "N" ) {
		alert("<mink:message code='mink.web.alert.select.task'/>");
		return true;
	}
	if( frm.find("textarea[name='pushMsg']").val()=="" ) {
		alert("<mink:message code='mink.web.alert.input.pushmessage'/>");
		frm.find("textarea[name='pushMsg']").focus();
		return true;
	}
	if( 600 < frm.find("textarea[name='pushMsg']").val().length ) {
		alert("<mink:message code='mink.web.alert.exceed.pushmessage'/>");
		frm.find("textarea[name='pushMsg']").focus();
		return true;
	}
	
	return result;
}

// 푸시타겟목록 전체 초기화
function toDeleteAll() {
	// 그룹푸시타겟
	var tb = "ugListTb";
	$("#"+tb+" > tbody > tr").remove();
	emptyRow = "<tr id=\""+tb+"EmptyTr\"><td colspan='4' align='center'><mink:message code='mink.alert.noexist.content'/></td></tr>";
	$("#"+tb+" > tbody").append(emptyRow);
	//$("#ugListTb > tbody > tr").remove();
	
	// 사용자푸시타겟
	tb = "unListTb";
	$("#"+tb+" > tbody > tr").remove();
	emptyRow = "<tr id=\""+tb+"EmptyTr\"><td colspan='3' align='center'><mink:message code='mink.alert.noexist.content'/></td></tr>";
	$("#"+tb+" > tbody").append(emptyRow);
	
	// 장치푸시타겟
	tb = "ddListTb";
	$("#"+tb+" > tbody > tr").remove();
	emptyRow = "<tr id=\""+tb+"EmptyTr\"><td colspan='3' align='center'><mink:message code='mink.alert.noexist.content'/></td></tr>";
	$("#"+tb+" > tbody").append(emptyRow);
}



function textareaResize(obj) {
	obj.style.height = "1px";
	obj.style.height = (20 + obj.scrollHeight) + "px";
}
</script>
</head>
<body>

	<!-- 사용자 상세정보 다이얼로그 -->
	<%@ include file="/WEB-INF/jsp/include/searchUserDetailDialog.jsp" %>
	<!-- 사용자 그룹 내비게이션 다이얼로그 -->
	<%@ include file="/WEB-INF/jsp/include/searchUserGroupNaviDialog.jsp" %>
	<!-- 사용자 그룹 검색 다이얼로그 -->
	<%@ include file="/WEB-INF/jsp/include/searchUserGroupTreeviewDialog.jsp" %>
	<%-- 푸시 업무 등록 다이얼로그 --%> 
	<%@ include file="/WEB-INF/jsp/asvc/push/pushListDetailDialog.jsp" %>
	<%-- 푸시 업무 상세정보 다이얼로그 --%> 
	<%@ include file="/WEB-INF/jsp/asvc/push/pushTaskListPopupDialog.jsp" %>
	<%-- 푸시 업무 등록 다이얼로그 --%> 
	<%@ include file="/WEB-INF/jsp/asvc/push/pushTaskInsertDialog.jsp" %>
	<%-- 푸시 등록 다이얼로그 --%> 
	<%@ include file="/WEB-INF/jsp/asvc/push/pushListInsertDialog.jsp" %>
	
	
	
	<div id="miaps-container">
		<div id="miaps-header">
	    	<%@ include file="/WEB-INF/jsp/include/header.jsp" %>
	  	</div>
	  	<div id="miaps-sidebar">
			<%@ include file="/WEB-INF/jsp/include/left.jsp" %>
		</div>
		<div id="miaps-top-buttons">
			<span><button class='btn-dash' onclick="javascript:popupInsert();"><mink:message code="mink.web.text.regist.push"/></button></span>
			<span><button class='btn-dash' onclick="javascript:goDeleteAll();"><mink:message code="mink.web.text.delete.push"/></button></span>
		</div>
		<div id="miaps-content">
			<!-- 검색 및 목록 시작 -->
			<form id="SearchFrm" name="SearchFrm" method="post">
				<!-- 검색 hidden -->
				<input type="hidden" name="regNo" value="${loginUser.userNo}"/>	<!-- 로그인한 사용자 -->
				<input type="hidden" name="updNo" value="${loginUser.userNo}"/>	<!-- 로그인한 사용자 -->
				<input type="hidden" name="pushId" value=""/><!-- 상세 -->
				<input type="hidden" name="taskId" value=""/><!-- 상세 -->
				<input type="hidden" name="pageNum" value="${search.currentPage}" /><!-- 현재 페이지 -->
						
				<!-- 검색 화면 시작 -->
				<div>
					<table border="0" cellspacing="0" cellpadding="0" width="100%">
						<tr> 	
							<td class="search">
								<select name="searchKey">
									<option value="" ${search.searchKey == '' ? 'selected' : ''}><mink:message code="mink.web.text.full.all"/></option>
									<option value="pushId" ${search.searchKey == 'pushId' ? 'selected' : ''}><mink:message code="mink.web.text.pushid"/></option>
									<option value="pushMsg" ${search.searchKey == 'pushMsg' ? 'selected' : ''}><mink:message code="mink.web.text.pushmessage2"/></option>
									<option value="taskNm" ${search.searchKey == 'taskNm' ? 'selected' : ''}><mink:message code="mink.web.text.taskname"/></option>
									<option value="packageNm" ${search.searchKey == 'packageNm' ? 'selected' : ''}><mink:message code="mink.web.text.packagename"/></option>
								</select>
								<input type="text" name="searchValue" value="<c:out value='${search.searchValue}'/>"/>
								<select name="searchPageSize">
									<option value="10" ${search.searchPageSize == '10' ? 'selected' : ''}><mink:message code="mink.web.text.rows10"/></option>
									<option value="20" ${(search.searchPageSize == null || search.searchPageSize == '20') ? 'selected' : ''}><mink:message code="mink.web.text.rows20"/></option>
									<option value="50" ${search.searchPageSize == '50' ? 'selected' : ''}><mink:message code="mink.web.text.rows50"/></option>
									<option value="100" ${search.searchPageSize == '100' ? 'selected' : ''}><mink:message code="mink.web.text.rows100"/></option>
								</select>
								<button class='btn-dash' onclick="javascript:goList('1');"><mink:message code="mink.web.text.search"/></button>
							</td>
						</tr>
					</table>
				</div>	
				<!-- 검색 화면 끝 -->
		
		
				<!-- 목록 화면 시작-->
				<table class="listTb" border="0" cellspacing="0" cellpadding="0" width="100%">
					<colgroup>
						<col width="6%" />
						<col width="10%" />
						<col width="30%" />
						<col width="20%" />
						<col width="12%" />
						<col width="14%" />
						<col width="8%" />
					</colgroup>
					<thead>
						<tr>
							<td><input type="checkbox" name="listTbCheckboxAll" /></td>
							<td><mink:message code="mink.web.text.pushid"/></td>
							<td><mink:message code="mink.web.text.pushmessage2"/></td>
							<td><mink:message code="mink.web.text.taskname"/></td>
							<td><mink:message code="mink.web.text.push.resultcode"/></td>
							<td><mink:message code="mink.web.text.push.reserved.senddate"/></td>
							<td><mink:message code="mink.web.text.status"/></td>
						</tr>
					</thead>
					<tbody id="listTbody">
						<!-- 목록이 있을 경우 -->
						<c:forEach var="dto" items="${pushDataList}" varStatus="i">
						<tr id="listTr${dto.pushId}" onclick="javascript:goDetail('${dto.pushId}');">
							<td><input type="checkbox" name="pushIds" value="${dto.pushId}" onclick="checkedCheckboxInTr(event)"/></td>
							<%-- <td>${search.number - i.index}</td> --%>
							<td>${dto.pushId}</td>
							<td align="left"><c:out value='${dto.pushMsg}'/></td>
							<td align="left">
								<c:set var="listSize"  value="${fn:length(dto.pushTaskList) }" />
								<c:forEach var="pushTask" items="${dto.pushTaskList}" varStatus="j">
									<c:out value='${pushTask.taskNm}'/><c:if test="${listSize != j.count}">,&nbsp;</c:if>
								</c:forEach>
							</td>
							<%-- <td>${dto.reservedDt}</td>
							<td>${dto.sendStartDt}</td>
							<td>${dto.sendEndDt}</td> --%>
							<td>${dto.resultCd}</td>
							<td>${dto.reservedDt}</td>
							<td>
								<c:choose>
									<c:when test="${dto.dataSt==PUSH_DATA_ST_NEW}">New</c:when>
									<c:when test="${dto.dataSt==PUSH_DATA_ST_DELETED}">Deleted</c:when>
									<c:when test="${dto.dataSt==PUSH_DATA_ST_TARGETED}">Targeted</c:when>
									<c:when test="${dto.dataSt==PUSH_DATA_ST_SENT}">Sent</c:when>
									<c:otherwise>${dto.dataSt}</c:otherwise>
								</c:choose>
							</td>
						</tr>
						</c:forEach>
					</tbody>
					<tfoot id="listTfoot">
						<c:if test="${empty pushDataList}">
							<tr >
								<td colspan="7"><mink:message code="mink.web.text.noexist.result"/></td>
							</tr>
							</c:if>
					</tfoot>
				</table>
		
		
				<div id="paginateDiv" class="paginateDiv" >
					<div class="paginateDivSub">
					<!-- start paging -->
					<%@ include file="/WEB-INF/jsp/include/pagination.jsp" %>
					<!-- end paging -->
					</div>
				</div>
				<div style="padding: 10px;">
				</div>
			</form>
		</div>
		<!-- footer -->
		<div id="miaps-footer">
			<%@ include file="/WEB-INF/jsp/include/footer.jsp" %>
		</div>	
	</div>
</body>
</html>