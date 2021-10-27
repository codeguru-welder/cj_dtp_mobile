<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="org.springframework.web.bind.annotation.SessionAttributes"%>
<%@ page import="com.thinkm.mink.commons.util.MinkConfig" %>
<%
	/*
	 * 장치 관리 화면 - 목록 및 등록/수정/삭제 (deviceListView.jsp)
	 * 
	 * @author juni
	 * @since 2014.03.04
	 */
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<%@ include file="/WEB-INF/jsp/include/wsACommonInclude.jsp" %>
<%@ include file="/WEB-INF/jsp/include/wsACommonHeadScript.jsp" %>
<title><mink:message code="mink.label.page_title"/></title>

<script type="text/javascript">

$(function() {
	// 그룹검색 treeview dialog
	actionSearchUserGroup();
	
	//accordion 선택 페이지를 유지하기위한 설정값 셋팅 ex) home:0 user:1, device:2, app:3, push:4, board:5, monitoring:6, setting:7
	init_accordion('device', '${loginUser.menuListString}');
	$("#topMenuTile").html("<mink:message code='mink.menu.device_management'/>" + " > " + "<mink:message code='mink.menu.device_status'/>");
	
	init(); // 초기설정 셋팅

	showList(); // 목록 보이기
	showPageHtml(); // 페이징 html 생성
	
	<%-- 앱 권한 탭 컨트롤 --%>
    $(".tab_content_appRole").hide();
    $(".tab_content_appRole:first").show();

    $("ul.tabs_appRole li").click(function () {
        $("ul.tabs_appRole li").removeClass("active").css("color", "#333");
        $(this).addClass("active").css("color", "#0459c1");
        $(".tab_content_appRole").hide()
        var activeTab = $(this).attr("rel");
        $("#" + activeTab).fadeIn();
        
        
        //javascript:goDeviceLogList('1');   // 장치 사용이력
		//javascript:goPushSettingList('1'); //푸시 정보
        
    });
	
	
	// 상세가 있을 경우, 상세 보이기
 	if(eval('${!empty device}')) { 
		var dto = eval("("+'${device}'+")");
		fnDetailProcess(dto); // 상세정보 매핑
		//checkedTrCheckbox($("#listTr"+dto.deviceId)); // 선택한 tr 의 checkbox 에 체크선택/css 변경
	} 
	// 검색어 Enter 이벤트
	$("#searchFrm").find("input[name='searchValue']").on("keypress", function(event){
		if (event.which == 13) {
			$("#searchValueBtn").trigger("click");
			return false;
		}
	});
	
	$('.tooltip').tooltipster({ 
		contentAsHTML: true,
		iconDesktop: true
	});	// tooltipster html
	
});

// 목록 및 검색요청
function goList(pageNum) {
	
	<%-- XSS 방어 --%>
	var _searchVal = defenceXSS(document.searchFrm.searchValue.value); 
	document.searchFrm.searchValue.value = _searchVal;
	
	document.searchFrm.pageNum.value = defenceXSS(pageNum); // 이동할 페이지
	document.searchFrm.action = 'deviceListView.miaps?';
	document.searchFrm.submit();
}

// 상세정보조회 요청(ajax)
function goDetail(deviceId) {
	$("#deviceDetailFrm").find("input[name='deviceId']").val(deviceId); // (선택한)상세
	ajaxComm('deviceDetail.miaps?', document.deviceDetailFrm, callbackDeviceDetailDialog);
	checkedTrCheckbox($("#listTr"+deviceId));	// 선택된 row 색깔변경
	
	

}

// 등록요청(ajax)
function goInsert() {
	
	if( validation($('#insertFrm')) ) return; // 검증
	if( !confirm("<mink:message code='mink.message_would_you_register'/>") ) return;
	
	ajaxComm('deviceInsert.miaps?', document.insertFrm, function(data){
		resultMsg(data.msg);
		$("#searchFrm").find("input[name='deviceId']").val(data.device.deviceId); // (등록한)상세
		goList('1'); // 목록/검색(1 페이지로 초기화)
	});
}

// 수정요청(ajax)
function goUpdate() {
	
	if( validation($("#deviceDetailFrm")) ) return; // 검증
	if( !confirm("<mink:message code='mink.message.would_you_save'/>") ) return;
	ajaxComm('deviceUpdate.miaps?', document.deviceDetailFrm, function(data){
		resultMsg(data.msg);
		goList($("#searchFrm").find("input[name='pageNum']").val()); // 목록/검색
	});
}

// 여러개 삭제요청(ajax)
function goDeleteAll() {
	// 검증
	if($("#listTbody").find(":checkbox:checked").length < 1) {
		alert("<mink:message code='mink.message.select_delete_item'/>");
		return;
	}
	
	if( !confirm("<mink:message code='mink.message.is_delete'/>") ) return;
	ajaxComm('deviceDelete.miaps?', searchFrm, function(data){
		resultMsg(data.msg);
		$("#searchFrm").find("input[name='deviceId']").val(''); // (삭제한)상세 비움
		goList(document.searchFrm.pageNum.value); // 목록/검색
	});

}

//ajax 로 가져온 data 를 알맞은 위치에 삽입
function fnAjaxInfoMapping(result) {
	
	// 상세화면 정보 출력
	$("input[name='deviceId']").val(result.deviceId);
	var userInfoLink = "<a href=\"javascript: void(0);\" onclick=\"javascript:showSearchUserDetailDialog('" + result.userNo + "');\">" + result.userNm + setBracket(result.userId) + "</a>";
	if (result.userNo == null || result.userNo == "") userInfoLink = "";
	$("#userInfoSpan").html(userInfoLink);
	$("input[name='deviceTp']").val(result.deviceTp);
	$("input[name='modelNo']").val(result.modelNo);
	$("input[name='osTp']").val(result.osTp);
	$("input[name='osNm']").val(result.osNm);
	$("input[name='osVersion']").val(result.osVersion);
	$("input[name='phoneNo']").val(result.phoneNo);
	$("input[name='wifiMacAddr']").val(result.wifiMacAddr);
	$("input[name='btMacAddr']").val(result.btMacAddr);
	$("input[name='activeSt'][value=" + result.activeSt + "]").prop("checked", true);
	$("input[name='regNm']").val(result.regNm);
	$("input[name='regDt']").val(toDateFormatString(result.regDt));

	// 하위목록 key setting
	$("#searchFrm2").find("input[name='deviceId']").val(result.deviceId); 
	
	// 장치 사용 이력 목록 조회
	//goDeviceLogList("1");
	
	// 푸시셋팅 목록 조회
	//goPushSettingList("1");
}




// task 별 푸시수신여부 수정
function goPushUpdate(deviceId, taskId, pushYn, i, originPushYn) {//alert($("#pushListTb").find("input[name='pushYn"+i+"'][value=Y]").val());

	// 수신여부 수정 취소 시 푸시수정여부 원래 값(originPushYn)으로 변경표시
	if( !confirm("<mink:message code='mink.message.would_you_modify_check_push_yn'/>") ) {
		$("#pushListTb").find("input[name='pushYn"+i+"'][value=" + originPushYn + "]").prop("checked", true);
		return;
	}

	$("#searchFrm2").find("input[name='deviceId']").val(deviceId); 
	$("#searchFrm2").find("input[name='taskId']").val(taskId); 
	$("#searchFrm2").find("input[name='pushYn']").val(pushYn); 
	ajaxComm('devicePushSettingUpdate.miaps?', searchFrm2, function(data){ });

}

// 입력 값 검증
function validation(frm) {
	var result = false;
	if( $("input[name=activeSt]:checked").size()==0 ) {
		result = true;
	}
	
	return result;
}

/* *** 라이선스 시작 *** */
//라이선스 현황 보기
function showLicenseStateTr() {
	if($("#licenseStateTr").is(":hidden")) {
		$.post('../user/userLicenseCount.miaps?', function(data){
			// 2014/04/10 [13:58:06] 현재 7개의 라이선스가 사용 되었으며 남은 개수는 493개 입니다.
			var alertText = '[' + getTodayTime() + ']';
			alertText += "<mink:message code='mink.web.message17'/>";
			$("#licenseStateSpan").text(alertText);
		}, 'json');
	}
	
	$("#licenseStateTr").toggle();
}

//라이선스 생성
function userLicenseInsert() {
	// 라이선스 생성 개수 검증
	var answer = false;
	
	$.ajaxSetup({async:false}); // 비동기 옵션 끄기(ajax 동기화)
	ajaxComm('../user/userLicenseCount.miaps?', {}, function(data){
		if(data.licenseMaxLimit <= data.licenseTotalCount) { 
			alert("<mink:message code='mink.message.over_make_license_key'/>"+"\n"+"<mink:message code='mink.message.renew_license'/>");
			
			var alertText = '[' + getTodayTime() + ']';
			alertText += "<mink:message code='mink.web.message17'/>";
			$("#licenseStateSpan").text(alertText);
			$("#licenseStateTr").show();
			
			answer = true;
		}
	});
	$.ajaxSetup({async:true}); // 비동기 옵션 켜기
	
	if(answer) return;
	
	if(!confirm("<mink:message code='mink.message.would_you_generate'/>")) return;
	ajaxComm('../user/userLicenseInsert.miaps?', searchFrm, function(data){
		resultMsg(data.msg);
		goList('1'); // 목록/검색
	});
}

//라이선스 할당
function userLicenseUpdateAll() {
	var $checkeds = $("#listTbody").find(":checkbox:checked");
	
	if($checkeds.length < 1) {
		alert("<mink:message code='mink.message.select_item'/>");
		return true;
	}
	
	var answer = false;
	
	// 라이선스 할당여부 검증
	$checkeds.each(function(){
		if('' != $(this).parent("td").parent("tr").find(":hidden[name='licenseIdList']").val()) {
			//$(this).get(0).checked = false;
			answer = true;
		}
		if('' != $(this).parent("td").parent("tr").find(":hidden[name='userLicenseIdList']").val()) {
			//$(this).get(0).checked = false;
			answer = true;
		}
	});
	
	if(answer) {
		alert("<mink:message code='mink.message.already_exist_device_license'/>");
		return true;
	}
	
	// 라이선스 할당 개수 검증
	$.ajaxSetup({async:false}); // 비동기 옵션 끄기(ajax 동기화)
	ajaxComm('../user/userLicenseCount.miaps?', searchFrm, function(data){
		if(data.licenseUnassignedCount < $checkeds.length) { 
			alert("<mink:message code='mink.message.over_allotment'/>"+"\n"+"<mink:message code='mink.web.message18'/>");
			answer = true;
		}
	});
	$.ajaxSetup({async:true}); // 비동기 옵션 켜기
	
	if(answer) return;
	
	if(!confirm("<mink:message code='mink.message.would_you_assign'/>")) return;
	
	$checkeds.each(function(){
		$(searchFrm).append("<input type='hidden' name='deviceIdList' value='" + this.value + "' />");
	});
	
	ajaxComm('../user/userLicenseUpdate.miaps?', searchFrm, function(data){
		resultMsg(data.msg);
		goList(searchFrm.pageNum.value); // 목록/검색
	});
}

//라이선스 회수
function userLicenseDeleteAll() {
	var $checkeds = $("#listTbody").find(":checkbox:checked");
	
	if($checkeds.length < 1) {
		alert("<mink:message code='mink.message.select_item'/>");
		return true;
	}
	
	var answer = false;
	
	// 라이선스 할당여부 검증
	$checkeds.each(function(){
		if('' == $(this).parent("td").parent("tr").find(":hidden[name='licenseIdList']").val()) {
			//$(this).get(0).checked = false;
			answer = true;
		}
	});
	
	if(answer) {
		alert("<mink:message code='mink.message.not_exist_license_device'/>");
		return;
	}
	
	if(!confirm("<mink:message code='mink.message.would_you_repossess'/>")) return;
	
	// 체크안한 라이선스는 회수할 때 제외
	$("#listTbody").find(":checkbox:not(:checked)").each(function(){
		$(this).parent("td").parent("tr").find(":hidden[name='licenseIdList']").remove();
	});
	
	ajaxComm('../user/userLicenseDelete.miaps?', searchFrm, function(data){
		resultMsg(data.msg);
		goList(searchFrm.pageNum.value); // 목록/검색
	});
}
/* *** 라이선스 끝 *** */

<%--  검색 결과 다운로드 --%>
function goDownloadDeviceList(pageNum) {
	document.searchFrm.pageNum.value = defenceXSS(pageNum); // 이동할 페이지
	document.searchFrm.action = 'deviceListViewDownload.miaps?';
	document.searchFrm.submit();
}
</script>
</head>
<body>
	<!-- 그룹검색 treeview dialog javascript -->
	<%@ include file="/WEB-INF/jsp/include/searchUserGroupTreeviewDialogJavascript.jsp" %>
	
	<!-- 그룹검색 treeview dialog -->
	<%@ include file="/WEB-INF/jsp/include/searchUserGroupTreeviewDialog.jsp" %>
	
	<%-- 장치 상세정보 다이얼로그 --%> 
	<%@ include file="/WEB-INF/jsp/asvc/device/deviceDetailDialog.jsp" %>
	
	<!-- 본문 -->
	<div id="miaps-container">
		<div id="miaps-header">
	    	<%@ include file="/WEB-INF/jsp/include/header.jsp" %>
	  	</div>
	  	<div id="miaps-sidebar">
			<%@ include file="/WEB-INF/jsp/include/left.jsp" %>
		</div>
		<div id="miaps-top-buttons">
			<%-- 
				- 장치를 삭제하더라도 삭제 플래그만 변경되고 실제 데이터가 삭제된 것이 아니므로 여러가지로 문제가 될 수 있어 이 기능을 제거함
				- mingun.park@gmail.com (20180214) 
			<span><button class='btn-dash' onclick="javascript:goDeleteAll();"><mink:message code='mink.label.delete_device'/></button></span>
			--%>
			<%-- 현재 장치 라이선스는 사용하지 않으므로 삭제 2016.09.01 chlee 
			<span><button class='btn-dash' onclick="javascript:userLicenseUpdateAll();"><mink:message code='mink.label.license_assign'/></button></span>
			<span><button class='btn-dash' onclick="javascript:userLicenseDeleteAll();"><mink:message code='mink.label.license_recovery'/></button></span>
			--%>
			<span><button class='btn-dash' onclick="javascript:goDownloadDeviceList('1');"><mink:message code='mink.label.search_result_download'/></button></span>
		</div>
		<div id="miaps-content">
			<form id="searchFrm" name="searchFrm" method="post" onSubmit="return false;">
				<!-- 검색 hidden -->
				<input type="hidden" name="deviceId" /><!-- 상세조회를 위한 key -->
				<input type="hidden" name="pageNum" value="<c:out value='${search.currentPage}'/>" /><!-- 현재 페이지 -->
				<input type="hidden" name="assignUserNo" value="<c:out value='${loginUser.userNo}'/>" /><!-- 라이선스를 할당한 사용자 -->

				<!-- <div id="titleSearchDiv">
					<h3><span>* 장치 관리</span></h3>
				</div> -->
				
				<!-- 검색 화면 -->
				<div id="searchDiv" >
					<table border="0" cellspacing="0" cellpadding="0" width="100%">
						<!-- 그룹검색 시작 -->
						<%@ include file="/WEB-INF/jsp/include/searchUserGroupTr.jsp" %>
						<!-- 그룹검색 끝 -->
						<tr> 	
							<td class="search">
								<select name="searchOsTp">
									<option value="" ${search.searchOsTp == '' ? 'selected' : ''}><mink:message code='mink.label.os_all'/></option>
									<option value="Android" ${search.searchOsTp == 'Android' ? 'selected' : ''}><mink:message code='mink.label.os_android'/></option>
									<option value="iOS" ${search.searchOsTp == 'iOS' ? 'selected' : ''}><mink:message code='mink.label.os_iOS'/></option>
								</select>
								<select name="searchKey">
									<option value="" ${search.searchKey == '' ? 'selected' : ''}><mink:message code='mink.label.all'/></option>
									<option value="userNm" ${search.searchKey == 'userNm' ? 'selected' : ''}><mink:message code='mink.label.user_name'/></option>
									<option value="userId" ${search.searchKey == 'userId' ? 'selected' : ''}><mink:message code='mink.label.user_id'/></option>
									<option value="deviceId" ${search.searchKey == 'deviceId' ? 'selected' : ''}><mink:message code='mink.label.device_id'/></option>
								</select>
								<input type="text" name="searchValue" value="<c:out value='${search.searchValue}'/>"/>
								<select name="searchPageSize">
									<option value="10" ${search.searchPageSize == '10' ? 'selected' : ''}>10<mink:message code='mink.label.line'/></option>
									<option value="20" ${(search.searchPageSize == null || search.searchPageSize == '20') ? 'selected' : ''}>20<mink:message code='mink.label.line'/></option>
									<option value="50" ${search.searchPageSize == '50' ? 'selected' : ''}>50<mink:message code='mink.label.line'/></option>
									<option value="100" ${search.searchPageSize == '100' ? 'selected' : ''}>100<mink:message code='mink.label.line'/></option>
								</select>
								<button id="searchValueBtn" class='btn-dash' onclick="javascript:goList('1');"><mink:message code='mink.web.text.search'/></button>
								<!-- <button class='btn-dash' onclick="javascript:goDownloadDeviceList('1');">검색 결과 다운로드</button> -->
								<!-- <button class='btn-dash' onclick="javascript:showLicenseStateTr();">라이선스관리</button> -->
							</td>
						</tr>
					<!-- <tr id="licenseStateTr" style="display: none;">
						<td>
							<span id="licenseStateSpan"></span>
							<span class="rightFloatSpan">
							<span><button class='btn-dash' onclick="javascript:userLicenseInsert();">라이선스 키생성</button></span>
							<span><button class='btn-dash' onclick="javascript:userLicenseUpdateAll();">라이선스할당</button></span>
							<span><button class='btn-dash' onclick="javascript:userLicenseDeleteAll();">라이선스회수</button></span>
							</span>
						</td>
					</tr> -->
					</table>
				</div>

				<!-- 목록 화면 -->
				<div id="listDiv">
					<table class="listTb" border="0" cellspacing="0" cellpadding="0" width="100%">
						<colgroup>
							<col width="4%" />
							<col width="20%" />
							<col width="26%" />
							<col width="13%" />
							<col width="12%" />							
							<%-- <col width="10%" /> --%>
							<col width="15%" />
							<col width="10%" />
						</colgroup>
						<thead>
							<tr>
								<td><input type="checkbox" name="deviceCheckboxAll" /></td>
								<td><mink:message code='mink.label.user_name_id'/></td>
								<td><mink:message code='mink.label.device_id'/></td>
								<td><mink:message code='mink.label.os_type'/></td>
								<td><mink:message code='mink.label.model_serial'/></td>
								<%--
								<td><mink:message code='mink.label.license'/></td>
								 --%>
								<td><mink:message code='mink.label.reg_date'/></td>
								<td><mink:message code='mink.label.state'/></td>
							</tr>
						</thead>
						<tbody id="listTbody">
							<c:forEach var="dto" items="${deviceList}" varStatus="i">
							<tr id="listTr${dto.deviceId}" onclick="javascript:goDetail('${dto.deviceId}');">
								<td><input type="checkbox" name="deviceIds" value="${dto.deviceId}" onclick="checkedCheckboxInTr(event)" /></td>
								<td align="left"><c:out value='${dto.userNm}'/><c:if test="${!empty dto.userId}">(${dto.userId})</c:if></td>
								<td align="left">${dto.deviceId}</td>
								<td>${dto.osTp}</td>
								<td>${dto.modelNo}</td>
								<%-- 
								<td>
									<input type="hidden" name="userLicenseIdList" value="${dto.userLicenseId}" />
									<input type="hidden" name="licenseIdList" value="${dto.deviceLicenseId}" />
									${empty dto.userLicenseId ? '' : "<mink:message code='mink.label.user_y'/>"}
									${empty dto.deviceLicenseId ? '' : "<mink:message code='mink.label.device_y'/>"}
								</td>
								 --%>
								<td>${dto.regDt}</td>
								<td>
									<c:choose>
										<c:when test="${dto.activeSt == DEVICE_ST_ACTIVE}"><mink:message code='mink.web.text.using'/></c:when>
										<c:when test="${dto.activeSt == DEVICE_ST_SUSPENDED}"><mink:message code='mink.web.text.stoped'/></c:when>
										<c:when test="${dto.activeSt == DEVICE_ST_DISUSED}"><mink:message code='mink.web.text.disposal'/></c:when>
										<c:otherwise><mink:message code='mink.web.text.using'/></c:otherwise>
									</c:choose>
								</td>								
							</tr>
							</c:forEach>
						</tbody>
						<tfoot id="listTfoot">
							<c:if test="${empty deviceList}">
							<tr >
								<td colspan="7"><mink:message code='mink.web.text.noexist.result'/></td>
							</tr>
							</c:if>
						</tfoot>
					</table>
				</div>

				<div id="paginateDiv" class="paginateDiv" >
					<div class="paginateDivSub">
						<!-- start paging -->
						<%@ include file="/WEB-INF/jsp/include/pagination.jsp" %>
						<!-- end paging -->
					</div>
				</div>

				<div style="padding:10px;">
					<!-- <span class='btn-dash'><button class='btn-dash' onclick="javascript:goDeleteAll();">삭제</button></span> -->
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
