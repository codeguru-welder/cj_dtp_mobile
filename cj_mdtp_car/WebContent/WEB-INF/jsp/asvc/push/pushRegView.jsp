<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="org.springframework.web.bind.annotation.SessionAttributes"%>
<%@ page import="com.thinkm.mink.commons.util.MinkConfig" %>
<%
	/*
	 * 어드민 푸시
	 * 푸시 등록 화면 - (pushReg.jsp)
	 * 
	 * @author chlee
	 * @since 2016.04.08
	 */
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<%@ include file="/WEB-INF/jsp/include/wsACommonInclude.jsp" %>
<%@ include file="/WEB-INF/jsp/include/wsACommonHeadScript.jsp" %>
<title><mink:message code="mink.label.page_title"/></title>

<!-- bxSlider  
<link href="${contextPath}/js/bxslider/jquery.bxslider.css" rel="stylesheet" />
<script src="${contextPath}/js/bxslider/jquery.bxslider.min.js"></script>
-->

<!-- 그룹검색 treeview dialog javascript -->
<%@ include file="/WEB-INF/jsp/include/searchUserGroupTreeviewDialogJavascript.jsp" %>

<script type="text/javascript">
// 더보기 실행 변수
var tgUserPageSize = "${search.pageSize}"; // PageUtil.pageSize = 20
var tgDevicePageSize = "${search.pageSize}"; // PageUtil.pageSize = 20
var pushTargetUgList;	// 사용자그룹타겟목록(현재지정되어있는 그룹타겟, 그룹트리생성시 현재타겟으로 지정되어 있는지 확인하기 위한 변수정의)
var pushTargetUgDeleteList = [];	// 사용자그룹타겟테이블에서 삭제한 그룹ID목록(사용자그룹트리를 펼쳤을 경우 체크 해제 표시를 위한 정의)
var currTargetUgList = [];	// 현재사용자그룹 타겟테이블 목록(그룹트리에서 타겟을 지정할 때마다 타겟테이블에 추가 시 중복하여 제외하기 위한 정의)
$(function() {
	
	<%-- 그룹검색 treeview dialog --%>
	actionSearchUserGroup();
		
	<%-- accordion 선택 페이지를 유지하기위한 설정값 셋팅 ex) home:0 user:1, device:2, app:3, push:4, board:5, monitoring:6, setting:7 --%>
	init_accordion('push', '${loginUser.menuListString}');
	$("#topMenuTile").html("<mink:message code='mink.web.text.pushmanage_registpush'/>");
	
	init();
	
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
    });

	// 각 검색 폼 초기화
	$("#userSearchFrm")[0].reset();
	$("#deviceSearchFrm")[0].reset();
	
	// 왼쪽목록 초기화
	leftInit();

 /*
 	var slider = $('#bxslider').bxSlider({
		pager: false,
		controls: false,
		touchEnabled: false,
		mode: 'horizontal'
	});

 	$('#slider-next').click(function(){
 		slider.goToNextSlide(); 		
 		return false;
 	});
 	
 	$('#slider-prev').click(function(){
 		slider.goToPrevSlide();
 		return false;
 	});
*/
});


//업무관리 팝업 오픈
function selectTask(taskIdsLoc) {
	ajaxComm('pushTaskListView2.miaps?',$('#insertFrm'), callbackTaskListPopup);	// callbackTaskListPopup in pushTaskListPopupDialog.jsp
}

function goInsertPush() {
	if(validation($("#insertFrm"))) {
		return;
	}
	if(!confirm("<mink:message code='mink.web.alert.is.regist'/>")) {
		return;
	}
	
	<%-- append_params에 그룹, 장치, 유저 선택한 값을 input hidden으로 삽입한다.
	 1. insertFrm에 등록했던 targetTps, targetIds, includeSubYns, ugCheckbox 항목을 삭제
	 2. 그룹, 장치, 유저 form를 돌면서 checkbox를(체크와 관계 없음) 읽어와 insertFrm에 위 name으로 hidden 타입값으로 입력한다.
	 --%>
	$("#append_params").html("");
	
	var reservedDt = reservedDtToDate($("#insertFrm"));
	$("#insertFrm").find("input[name='reservedDt']").val(reservedDt);
	
	var _gfrm = $("#groupTargetFrm");
	var _ufrm = $("#userTargetFrm");
	var _dfrm = $("#deviceTargetFrm");
	
	<%-- 그룹 체크 --%>
	_gfrm.find("input:checkbox[name='ugCheckbox']").each(function() {
		$("#append_params").append("<input type='hidden' name='targetTps' value='UG'/>");
		$("#append_params").append("<input type='hidden' name='targetIds' value='"+ $(this).val() +"'/>");
	});
	<%-- 하위그룹포함 체크 --%>
	_gfrm.find("input:checkbox[name='includeSubYns']:checked").each(function() {
		$("#append_params").append("<input type='hidden' name='includeSubYns' value='"+ $(this).val() +"'/>");
	});
	
	<%-- 유저 체크 --%>
	_ufrm.find("input:checkbox[name='userCheckboxAll']").each(function() {
		$("#append_params").append("<input type='hidden' name='targetTps' value='UN'/>");
		$("#append_params").append("<input type='hidden' name='targetIds' value='"+ $(this).val() +"'/>");
	});
	
	<%-- 장치 체크 --%>
	_dfrm.find("input:checkbox[name='deviceCheckboxAll']").each(function() {
		$("#append_params").append("<input type='hidden' name='targetTps' value='DD'/>");
		$("#append_params").append("<input type='hidden' name='targetIds' value='"+ $(this).val() +"'/>");
	});
	
	//document.insertFrm.action = 'pushInsertAtOnce.miaps?';
	//document.insertFrm.submit();
	
	ajaxFileComm('pushInsertAtOnce.miaps?', $('#insertFrm'), function(data){
		goResult(data);
	});
}

function goResult(data) {
	
	
	$("#insertFrm").find("input[name=pushId]").val(data.pushDataTarget.pushId);
	$("#insertFrm").find("input[name='resendYn']").val("R");
	document.insertFrm.action = 'pushDataDetail.miaps?';
	document.insertFrm.submit();
}


<%-- 그룹관리 트리 완료 후 지정된 타겟 체크 표시 --%>
function completeTreeview(treeview) {
	var id = $(treeview, "ul").eq(0).attr("id");
	
	<%-- 푸시타겟 사용자그룹  --%>
	if( 'treeviewUlId' == id ) {
		if( pushTargetUgList != null ) {
			for(var i = 0; i < pushTargetUgList.length; i++) {
				$("#treeviewUlId").find(":checkbox[value='"+pushTargetUgList[i].targetId+"']").prop("checked", true);
			}
		}
		for(var j = 0; j < pushTargetUgDeleteList.length; j++) {
			$("#treeviewUlId").find(":checkbox[value='"+pushTargetUgDeleteList[j]+"']").prop("checked", false);
		}
	} else if( 'searchUserGroupTreeviewUl' == id ) { <%-- 사용자그룹 검색(다이얼로그) --%>		
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

<%-- 예약일시 셋팅 --%>
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


function leftInit() {
	$("#treeviewUlId").remove();
	$("#treeviewUlIdDiv").append("<ul id='treeviewUlId' class='treeview'></ul>");
	
	<%-- 사용자그룹 트리 --%>
	treeviewAlinkCheckboxAfterReset('../user/userGroupListTreeview.miaps?', '#treeviewUlId', '#treeviewUlIdDiv');
	
	<%-- 사용자관리 --%>
	fnSetUserList("", "");
	<%-- 장치관리 --%>
	fnSetDeviceList("", "");
}


<%--
 * 타겟목록 결과(테이블 내용 삭제 후 head를 복사하여 값 셋팅하는 방식)
 * targetList: 적용할 타겟목록
 * tb: 적용될 테이블 id명
 * div: 적용될 div명
--%>
function fnSetTargetList(targetList, tb, div) {
	
	$("#"+tb+" > tbody > tr").remove();	// tbody내용 삭제 (tbody 밑의 tr 삭제)
	$("#"+tb+" > thead > tr").find("td:eq(0)").find(":checkbox").attr("checked", false);	// head checkbox checked 초기화
	if( targetList.length > 0 ) {
		for(var i = 0; i < targetList.length; i++) {
			var newRow;
			newRow = $("#"+tb+" > thead > tr").clone(); // head row 복사
			newRow.removeClass();
			var obj = targetList[i];
			// hidden값 셋팅
			<%--
			var hiddenStr = "<input type=\"hidden\" name=\"targetTps\" value=\""+obj.targetTp+"\" />"
						  + "<input type=\"hidden\" name=\"targetIds\" value=\""+obj.targetId+"\" />";
		  	var j = 0;
		  	newRow.find("td:eq(0)").html(newRow.find("td:eq(0)").html()+hiddenStr);
		  	--%>
			newRow.find("td:eq(0)").find("input:checkbox").val(obj.targetId);	// checkbox의 value로 타겟목록에서 제거했을 경우 트리에서 체크해제
			newRow.find("td:eq(0)").find("input:checkbox").bind("click", function(event){
				checkedCheckboxInTr(event);
			});
			if( div == "ugDiv" ) {
				var grpNaviInfoLink = "<a href=\"javascript: void(0);\" onclick=\"javascript:showSearchUserGroupNaviDialog('" + obj.targetId + "');\">" + defenceXSS(obj.grpNm) + "</a>";
				newRow.find("td:eq(1)").attr("align", "left").html(defenceXSS(grpNaviInfoLink));
				newRow.find("td:eq(2)").html(obj.targetId); 
				var includeSubYnChecked = "";	// 하위포함여부 체크
				if( -1 < obj.includeSubYn.indexOf('Y') ) includeSubYnChecked = "checked";
				newRow.find("td:eq(3)").html("<input type=\"checkbox\" name=\"includeSubYns\" value=\""+obj.targetId+"\" "+includeSubYnChecked+"/>");
			} else if( div == "unDiv" ) {
				var userInfoLink = "<a href=\"javascript: void(0);\" onclick=\"javascript:showSearchUserDetailDialog('" + obj.targetId + "');\">" + nvl(defenceXSS(obj.userNm)) + setBracket(defenceXSS(obj.userId)) + "</a>";
				if (obj.targetId == null || obj.targetId == "") userInfoLink = "";
				newRow.find("td:eq(1)").attr("align", "left").html(userInfoLink);
				newRow.find("td:eq(2)").html(obj.targetId); 
				//newRow.find("td:eq(3)").html(obj.userGrpNm);
			} else if( div == "udDiv" ) {
				newRow.find("td:eq(1)").html(defenceXSS(obj.userGrpNm));
				newRow.find("td:eq(2)").html(obj.targetId); 
				newRow.find("td:eq(3)").html(nvl(defenceXSS(obj.userNm))+setBracket(defenceXSS(obj.userId))); 
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
			<%--
			var hiddenStr = "<input type=\"hidden\" name=\"targetTps\" value=\"UN\" />"
			 			  + "<input type=\"hidden\" name=\"targetIds\" value=\""+obj.userNo+"\" />";
			newRow.find("td:eq("+j+")").html(newRow.find("td:eq("+j+++")").html()+hiddenStr);
			--%>
			var j = 1;			
			newRow.find("td:eq(0)").find("input:checkbox").val(obj.userNo);
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

			$("#"+tb+" > tbody").append(newRow); 	// body 끝에 추가
		};
	} else {	// 결과 목록이 없을 경우
		var emptyRow = "<tr id=\""+tb+"EmptyTr\"><td colspan='"+$("#"+tb+" > thead > tr > td").length+"' align='center'><mink:message code='mink.web.text.noexist.inquiry'/></td></tr>";
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
				<%--
				var hiddenStr = "<input type=\"hidden\" name=\"targetTps\" value=\"UN\" />"
				 			  + "<input type=\"hidden\" name=\"targetIds\" value=\""+obj.userNo+"\" />";
				newRow.find("td:eq("+j+")").html(newRow.find("td:eq("+j+++")").html()+hiddenStr);
				--%>
				var j = 1;
				newRow.find("td:eq(0)").find("input:checkbox").val(obj.userNo);
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
	
	console.log("goDeviceList");
	
	// 더보기 실행 변수 초기화
	$("#deviceSearchFrm").find(":input[name='startRow']").val("1");
	
	$("#deviceSearchFrm").find("input[name='pageNum']").val(pageNum); // (선택한)상세
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
			<%--
			var hiddenStr = "<input type=\"hidden\" name=\"targetTps\" value=\"DD\" />"
			 			  + "<input type=\"hidden\" name=\"targetIds\" value=\""+obj.deviceId+"\" />";
			--%>
			var userInfoLink = "<a href=\"javascript: void(0);\" onclick=\"javascript:showSearchUserDetailDialog('" + obj.userNo + "');\">" + nvl(obj.userNm) + setBracket(obj.userId) + "</a>";
			if (obj.userNo == null || obj.userNo == "") userInfoLink = "";

			var j = 1;
			<%-- newRow.find("td:eq("+j+")").html(newRow.find("td:eq("+j+++")").html()+hiddenStr); --%>
			newRow.find("td:eq(0)").find("input:checkbox").val(obj.deviceId);
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
		var emptyRow = "<tr id=\""+tb+"EmptyTr\"><td colspan='"+$("#"+tb+" > thead > tr > td").length+"' align='center'><mink:message code='mink.web.text.noexist.inquiry'/></td></tr>";
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
				<%--
				var hiddenStr = "<input type=\"hidden\" name=\"targetTps\" value=\"DD\" />"
				 			  + "<input type=\"hidden\" name=\"targetIds\" value=\""+obj.deviceId+"\" />";
				--%>
				var userInfoLink = "<a href=\"javascript: void(0);\" onclick=\"javascript:showSearchUserDetailDialog('" + obj.userNo + "');\">" + nvl(defenceXSS(obj.userNm)) + setBracket(defenceXSS(obj.userId)) + "</a>";
				if (obj.userNo == null || obj.userNo == "") userInfoLink = "";

				var j = 1;
				<%-- newRow.find("td:eq("+j+")").html(newRow.find("td:eq("+j+++")").html()+hiddenStr); --%>
				newRow.find("td:eq(0)").find("input:checkbox").val(obj.deviceId);
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
			var grpNm = $(row).siblings("a").text();
			var newTarget = "<tr><td><input type=\"checkbox\" name=\"ugCheckbox\" value=\""+grpId+"\" onclick=\"checkedCheckboxInTr(event);\" />"
								  + "<input type=\"hidden\" name=\"targetTps\" value=\"UG\" />"
								  + "<input type=\"hidden\" name=\"targetIds\" value=\""+grpId+"\" />"
							  + "</td>"
							  + "<td align='left'><a href=\"javascript:javascript: void(0);\" onclick=\"showSearchUserGroupNaviDialog('"+grpId+"');\">"+grpNm+"</a></td>"
							  + "<td>"+grpId+"</td>"
							  + "<td><input type=\"checkbox\" name=\"includeSubYns\" value=\""+grpId+"\" /></td></tr>";
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
	
	<%-- 예약 일시 체크 --%>
	var reservedDd = frm.find($("input[name='reservedDd']")).val();
	if( reservedDd != null && reservedDd != "" ){
		var reservedHh = frm.find($("select[name='reservedHh']")).val();
		if  (reservedHh == null || reservedHh == "") {
			reservedHh = "00";
		}
		var reservedMm = frm.find($("select[name='reservedMm']")).val();
		if  (reservedMm == null || reservedMm == "") {
			reservedMm = "00";
		}
		var tmpdate = reservedDd.replace(/-/g, "/")  + ' ' + reservedHh + ':' + reservedMm + ':00';
		console.log(tmpdate);
		var reservedDay = new Date(tmpdate);
		var today = new Date();
		
		console.log(reservedDay);
		console.log(today);
	
		if(today > reservedDay) {
			alert("<mink:message code='mink.web.alert.select.bigger.regdate'/>");
			return true;
		}
	}
	
	<%-- 그룹 체크 --%>
	var chk_gcnt = $("#groupTargetFrm").find("input:checkbox[name='ugCheckbox']").length;
	<%-- 유저 체크 --%>
	var chk_ucnt = $("#userTargetFrm").find("input:checkbox[name='userCheckboxAll']").length;
	<%-- 장치 체크 --%>
	var chk_dcnt = $("#deviceTargetFrm").find("input:checkbox[name='deviceCheckboxAll']").length;
	
	if (chk_gcnt == 0 && chk_ucnt == 0 && chk_dcnt == 0) {
		alert("<mink:message code='mink.web.alert.select.pushtarget'/>");
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
<%-- 푸시 업무 상세정보 다이얼로그 --%> 
<%@ include file="/WEB-INF/jsp/asvc/push/pushTaskListPopupDialog.jsp" %>

<div id="miaps-container">
	<div id="miaps-header">
    	<%@ include file="/WEB-INF/jsp/include/header.jsp" %>
  	</div>
  	<div id="miaps-sidebar">
		<%@ include file="/WEB-INF/jsp/include/left.jsp" %>
	</div>
	
	<div id="miaps-content">
<%-- <ul id="bxslider">
	<li>
 --%>
		<div id="miaps-top-buttons">
			<span><button class='btn-dash' onclick="javascript:goInsertPush();"><mink:message code="mink.web.text.regist"/></button></span>
		</div>
		<form id="insertFrm" name="insertFrm" method="post" onSubmit="return false;" enctype="multipart/form-data" >
			<input type="hidden" name="regNo" value="${loginUser.userNo}" />
			<input type="hidden" name="searchPageSize" value="8"/>
			<input type="hidden" name="pushId" />
			<input type="hidden" name="resendYn"/>
			<p id="append_params"></p>
			
			<table class="insertTb" border="0" cellspacing="0" cellpadding="0" width="100%">
				<colgroup>
					<col width="20%" />
					<col width="80%" />
				</colgroup>
				<tbody>
					<tr>
						<th style="border-top: 0;"><span class="criticalItems"><mink:message code="mink.web.text.taskname.id"/></span></th>
						<td colspan="3" style="border-top: 0;">
							&nbsp;<button type="button" class='btn-dash' onclick="javascript:selectTask('insertFrm')"><mink:message code="mink.web.text.select.task"/></button><br />
							<span id="taskIdPos"></span>
							<input type='hidden' id='taskIdSetYn' value='N' />
							<input type='hidden' name = "taskIdsLoc" value="insertFrm"/>
							<input type='hidden' name = "isPopup" value="Y"/>
						</td>
					</tr>
					<tr>
						<th><span class="criticalItems"><mink:message code="mink.web.text.push.message.under600char"/></span></th>
						<td colspan="3">
							<!-- input type="text" name="pushMsg" maxlength="85"/ -->
							<textarea name="pushMsg" style="width:100%;overflow:visible;" onmouseup="textareaResize(this)" onkeyup="textareaResize(this)"></textarea>
						</td>
					</tr>
				<c:if test='${pushType eq "PREMIUM"}'>
					<tr>
						<th><span><mink:message code="mink.web.text.push.messagetype"/></span></th>
						<td>
						<select name="msgTp">
							<option value="Text"><mink:message code="mink.web.text.string.normal"/></option>
							<option value="BText"><mink:message code="mink.web.text.string.big"/></option>
							<option value="Inbox"><mink:message code="mink.web.text.listtype"/></option>
						</select>
						</td>
					</tr>
					<tr>
						<th><span><mink:message code="mink.web.text.push.imageurl2"/></span></th>
						<td>
						<input type="text" name="imgUrl"/>
						<input type="file" name="imgFile"/>
						<span>
							<input id="insImgUrlYn" type="checkbox" name="imgUrlYn" value="N" class="checkbox_with_label" style="width: 13px; height: 13px;" /><!-- style=.insertTb tbody tr td input{width: 100%} -->
							<label for="insImgUrlYn" title="<mink:message code='mink.web.text.push.imageurl3'/>" class="label_with_checkbox"><mink:message code="mink.web.text.notimage"/></label>
						</span>
						</td>
					</tr>
				</c:if>
					<tr>
						<th><mink:message code="mink.web.text.push.reserved.senddate"/></th>
						<td class="pushDate_1">
							<input type="text" name="reservedDd" size="10" class="datepicker"/>
							<select name="reservedHh">
								<c:forEach var="i" begin="0" end="24" varStatus="status">
									<fmt:formatNumber value="${i}" pattern="00" var="hh" />
									<option value="${hh}" >${hh}</option>
								</c:forEach>
							</select>
							<select name="reservedMm">
								<c:forEach var="i" begin="0" end="59" varStatus="status">
									<fmt:formatNumber value="${i}" pattern="00" var="mm" />
									<option value="${mm}" >${mm}</option>
								</c:forEach>
							</select>
							<input type="hidden" name="reservedDt" />
						</td>
					</tr>
					<tr>					
						<th><span>Badge Count</span></th>
						<td class="pushDate_1">
							<input type="text" name="badgeCnt" maxlength="3" value="0" onKeyup="this.value=this.value.replace(/[^0-9]/g, '');"/>&nbsp;
							0 <mink:message code="mink.web.text.push.count.init"/>, &gt;0 <mink:message code="mink.web.text.push.count.change"/>, &lt;0 <mink:message code="mink.web.text.push.count.not.change"/>
						</td>
					</tr>
				</tbody>
				<tfoot></tfoot>
			</table>
		</form>
<%--   
	 푸시 타겟 선택  
	<li>
 --%>	
		<div id="container_appRole"> <!-- menuPushTargetDiv -->
			<ul class="tabs_appRole"><!-- <ul class="menu"> -->
				<li id="userGroup" class="active" rel="tab1"><mink:message code="mink.web.text.user.group"/></li>
				<li id="userInfo" rel="tab2"><mink:message code="mink.web.text.user"/></li>
				<li id="userDevice" rel="tab3"><mink:message code="mink.web.text.device"/></li>
			</ul>
			<div class="tab_container_appRole">	<!-- <div class='detailPush'><br/> -->
				<div id="tab1" class="tab_content_appRole">			<!-- <div class="content group"><br/> -->
					<div style="float:left; width: 40%;">
						<div class="pushLeftScrollBoarder" style="width:100%; height: 800px; margin-bottom: 10px;">
							<ul>
								<li>
									<form id="userGroupSearchFrm" name="userGroupSearchFrm" method="post" onsubmit="return false;">
									<input type="hidden" name="pageNum" value=""/>
									</form>
								</li>
							</ul>
							<div id="treeviewUlIdDiv" class="twNodeStyle" style="font: normal 12px 맑은 고딕, HYHeadLine, 돋움, verdana, arial, helvetica, sans-serif; margin:0px 10px 0px 30px;">
								<li class="outerBulletStyle"><span style="padding-left:1px;"><b><mink:message code="mink.web.text.user.group"/></b></span>
									<ul id="treeviewUlId" class="treeview" style="text-decoration: none;"></ul>
								</li>
							</div>
						</div>
					</div>
					<div id="rightDiv" style="float:left; margin : 0px 10px 0px 10px;">
						<!-- 화살표 버튼 시작 -->
						<button id="pushRBtn" class='btn-arrow' onclick="javascript:toRight()">→</button><br/>
						<button id="pushLBtn" class='btn-arrow' onclick="javascript:toLeft()">←</button>
						<!-- 화살표 버튼 끝 -->
					</div>
					<div id="groupDiv2" style="float:right; width: 55%;">
					<form name="groupTargetFrm" id="groupTargetFrm">
						<table id="ugListTb" border="0" cellspacing="0" cellpadding="0" width="100%" class="listTb">
							<colgroup>
								<col width="5%" />
								<col width="35%" />
								<col width="30%" />
								<col width="25%" />
							</colgroup>
							<thead>
								<tr>
									<td><input type="checkbox" name="ugCheckboxAll" /></td>
									<td><mink:message code="mink.web.text.user.groupname"/></td><td><mink:message code="mink.web.text.user.groupid"/></td><td><mink:message code="mink.web.text.include.undergroup"/></td>
								</tr>
							</thead>
							<tbody>
							</tbody>
							<tfoot></tfoot>
						</table>
					</form>
					</div>
				</div>
		
				<div id="tab2" class="tab_content_appRole"><!-- <div class="content user"><br/> -->
					<div style="float:left; width:40%; height: 800px;">
						<!-- 푸시타겟 사용자관리 시작-->
						<form id="userSearchFrm" name="userSearchFrm" method="post" onSubmit="return false;"  >
							<input type="hidden" name="pageNum" value=""/>
							<input type="hidden" name="existPaging" value="Y" /><!-- 푸시타겟 목록관리대상으로 조회할때 사용자목록 구분값 -->
							<input type="hidden" name="startRow" value="1" /><!-- 시작줄 -->
							
							
							<!-- 검색 화면 시작 -->
							<table border="0" cellspacing="0" cellpadding="0" width="100%">
								
								<!-- 그룹검색 시작 -->
								<%@ include file="/WEB-INF/jsp/include/searchUserGroupTr.jsp" %>
								<!-- 그룹검색 끝 -->
								
								<tr>
									<td class="search">
										<select name="searchKey">
											<option value=""><mink:message code="mink.web.text.full.all"/></option>
											<option value="userNo"><mink:message code="mink.web.text.userno"/></option>
											<option value="userId"><mink:message code="mink.web.text.userid"/></option>
											<option value="userNm"><mink:message code="mink.web.text.username"/></option>
										</select>
										<select name="pageSize">
											<option value="20" ${search.searchKey == '20' ? 'selected' : ''}><mink:message code="mink.web.text.view.by20"/></option>
											<option value="100" ${search.searchKey == '100' ? 'selected' : ''}><mink:message code="mink.web.text.view.by100"/></option>
											<option value="500" ${search.searchKey == '500' ? 'selected' : ''}><mink:message code="mink.web.text.view.by500"/></option>
										</select>
										<input type="text" name="searchValue" />
										<button class='btn-dash' onclick="javascript:goUserList('1');"><mink:message code="mink.web.text.search"/></button>
									</td>
								</tr>
							</table>
						</form>
					    <!-- 검색 화면 끝 -->
						<!-- 목록 시작-->
						<div class="pushLeftScroll" style="height: 680px;">
							<table id="userListTb" border="0" cellspacing="0" cellpadding="0" width="100%" class="listTb">
								<colgroup>
									<col width="5%" />
									<col width="65%" /><col width="30%" /><!-- <col width="35%" /> -->
								</colgroup>
								<thead>
									<tr>
										<td><input type="checkbox" name="userCheckboxAll" /></td>
										<td><mink:message code="mink.web.text.username.id"/></td><td><mink:message code="mink.web.text.userno"/></td><!-- <td>그룹명</td> -->
									</tr>
								</thead>
								<tbody>
								</tbody>
							</table>
							<div id="moreUserDiv" style="display: none; text-align: center;"><button class='btn-dash' style="margin-top: 5px;" onclick="javascript:moreUser();"><mink:message code="mink.web.text.viewmore"/></button></div>
						</div>
					</div>
					
					<div id="rightDiv" style="float:left; margin: 0px 10px 0px 10px;">
							<!-- 화살표 버튼 시작 -->
						<button id="pushRBtn" class='btn-arrow' onclick="javascript:toRight()">→</button><br/>
						<button id="pushLBtn" class='btn-arrow' onclick="javascript:toLeft()">←</button>
						<!-- 화살표 버튼 끝 -->
					</div>	
					
					<div id="userDiv2" style="float:right; width: 55%; height: 800px; overflow:auto;">
					<form name="userTargetFrm" id="userTargetFrm">
						<table id="unListTb" border="0" cellspacing="0" cellpadding="0" width="100%" class="listTb">
							<colgroup>
								<col width="5%" />
								<col width="65%" /><col width="30%" /><!-- <col width="40%" /> -->
							</colgroup>
							<thead>
								<tr>
									<td><input type="checkbox" name="unCheckboxAll" /></td>
									<td><mink:message code="mink.web.text.username.id"/></td><td><mink:message code="mink.web.text.userno"/></td><!-- <td>그룹명</td> -->
								</tr>
							</thead>
							<tbody>
							</tbody>
						</table>
						</form>			
					</div>
				</div>
				
				<div id="tab3" class="tab_content_appRole"><!-- <div class="content device"><br/> -->
					<div style="float:left; width:40%; height: 800px;">
						<!-- 푸시타겟 장치관리 시작-->
						<form id="deviceSearchFrm" name="deviceSearchFrm" method="post" onSubmit="return false;">
							<input type="hidden" name="pageNum" value=""/>
							<input type="hidden" name="pushId" value="_DUMMY"/> <!-- 검색에러를 피하기 위한 더미-->
							<input type="hidden" name="existPaging" value="Y"/>
							<input type="hidden" name="searchUserGroupId" value="${loginUser.adminYn == ynYes ? corporation : loginUser.userGroup.grpId}"/><!-- 로그인 사용자 그룹 -->
							<input type="hidden" name="searchUserGroupSubAllYn" value="${ynYes}"/><!-- 사용자 그룹 하위포함 -->
							<input type="hidden" name="startRow" value="1" /><!-- 시작줄 -->
							
							<!-- 검색 화면 시작 -->
							<table border="0" cellspacing="0" cellpadding="0" width="100%">
								<tr> 	
									<td class="search">
										<select name="searchKey">
											<option value=""><mink:message code="mink.web.text.full.all"/></option>
											<option value="userNm"><mink:message code="mink.web.text.username.id"/></option>
											<option value="userId"><mink:message code="mink.web.text.userid"/></option>
											<option value="deviceId"><mink:message code="mink.web.text.deviceid"/></option>
										</select>
										<select name="pageSize">
											<option value="20" ${search.searchKey == '20' ? 'selected' : ''}><mink:message code="mink.web.text.view.by20"/></option>
											<option value="100" ${search.searchKey == '100' ? 'selected' : ''}><mink:message code="mink.web.text.view.by100"/></option>
											<option value="500" ${search.searchKey == '500' ? 'selected' : ''}><mink:message code="mink.web.text.view.by500"/></option>
										</select>
										<input type="text" name="searchValue" value=""/>
										<button class='btn-dash' onclick="javascript:goDeviceList('1');"><mink:message code="mink.web.text.search"/></button>
									</td>
								</tr>
							</table>
						</form>
						<!-- 검색 화면 끝 -->
						<!-- 목록 시작-->
						<div class="pushLeftScroll" style="height: 680px;">
							<table id="deviceListTb" border="0" cellspacing="0" cellpadding="0" width="100%" class="listTb">
								<colgroup>
									<col width="5%" />
									<col width="45%" /><col width="50%" />
								</colgroup>
								<thead>
									<tr>
										<td><input type="checkbox" name="deviceCheckboxAll" id="deviceCheckboxAll" /></td>
										<td><mink:message code="mink.web.text.username.id"/></td><td><mink:message code="mink.web.text.deviceid"/></td><!-- <td>전화번호</td><td>상태</td><td>등록일</td> -->
									</tr>
								</thead>
								<tbody>
								</tbody>
							</table>
							<div id="moreDeviceDiv" style="display: none; text-align: center;"><button class='btn-dash' style="margin-top: 5px;" onclick="javascript:moreDevice();"><mink:message code="mink.web.text.viewmore"/></button></div>
						</div>
					</div>
					
					<div id="rightDiv" style="float:left; margin: 0px 10px 0px 10px;">
							<!-- 화살표 버튼 시작 -->
						<button id="pushRBtn" class='btn-arrow' onclick="javascript:toRight()">→</button><br/>
						<button id="pushLBtn" class='btn-arrow' onclick="javascript:toLeft()">←</button>
						<!-- 화살표 버튼 끝 -->
					</div>								
					
					<div id="deviceDiv2"  style="float:right; width: 55%; height: 800px; overflow:auto;">
					<form name="deviceTargetFrm" id="deviceTargetFrm">
						<table id="ddListTb" border="0" cellspacing="0" cellpadding="0" width="100%" class="listTb">
							<colgroup>
								<col width="5%" />
								<col width="45%" />
								<col width="50%" />
							</colgroup>
							<thead>
								<tr>
									<td><input type="checkbox" name="ddCheckboxAll" /></td>
									<td><mink:message code="mink.web.text.username.id"/></td><td><mink:message code="mink.web.text.deviceid"/></td><!-- <td>전화번호</td><td>상태</td><td>등록일</td> -->
								</tr>
							</thead>
							<tbody>
							</tbody>
						</table>
					</form>
					</div>
				</div>
			</div>
		</div>
<%--
	</li>
	</ul>
 --%>
	</div>
	
	<!-- footer -->
	<div id="miaps-footer">
		<%@ include file="/WEB-INF/jsp/include/footer.jsp" %>
	</div>	
</div>
</body>
</html>