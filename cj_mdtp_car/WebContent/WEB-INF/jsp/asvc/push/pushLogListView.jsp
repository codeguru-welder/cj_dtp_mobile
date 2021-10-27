<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="org.springframework.web.bind.annotation.SessionAttributes"%>
<%@ page import="com.thinkm.mink.commons.util.MinkConfig" %>
<%
	/*
	 * 푸시 모니터링
	 * 푸시 로그 관리 화면 - 목록 (pushLogListView.jsp)
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

<script type="text/javascript">
$(function() {
	//accordion 선택 페이지를 유지하기위한 설정값 셋팅 ex) home:0 user:1, device:2, app:3, push:4, board:5, monitoring:6, setting:7
	init_accordion('monitoring', '${loginUser.menuListString}');
	$("#topMenuTile").html("<mink:message code='mink.web.text.monitoring_pushhistory'/>");
	
	init(); // 이벤트 핸들러 세팅
	
	showList(); // 목록 보이기
	showPageHtml(); // 페이징 html 생성

	<%-- 푸시 이력(_his) 탭 컨트롤 --%>
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

	pushLogStats(); // 전체 푸시 통계
});

function numberWithCommas(str) {
    return str.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}


// 전체 푸시 통계(푸시 로그관리 목록과 검색조건이 동일함)
function pushLogStats() {
	$.post('pushLogStats.miaps?', $("#SearchFrm").serialize(), function(data){
		var insTag = "<table class='listTb' border='0' cellspacing='0' cellpadding='0' width='100%'>\n";
		insTag += "<colgroup><col width='25%' /><col width='25%' /><col width='25%' /><col width='25%' /></colgroup>";
		insTag += "<thead><tr><td><mink:message code='mink.web.text.count.device'/></td><td><mink:message code='mink.web.text.count.push'/></td><td><mink:message code='mink.web.text.count.success'/></td><td><mink:message code='mink.web.text.count.fail'/></td></tr></thead>";
		if (data.deviceIdCnt > 0) {
			insTag += "<tbody id='listTbody'><tr><td>"+ numberWithCommas(data.deviceIdCnt) +"</td><td>"+ numberWithCommas(data.pushIdCnt);
			insTag += "</td><td>"+ numberWithCommas(data.lastResult200Cnt)+"</td><td>"+ numberWithCommas(data.lastResultNot200Cnt) +"</td></tr></tbody>";
		} else {
			insTag += "<tbody id='listTfoot'><tr><td colspan='4'><mink:message code='mink.web.text.noexist.result'/></td></tr></tbody>";
		}
		insTag += "</table>";
		
		$("#totalPushStatsPtag").html(insTag);
	}, 'json');
}

// 목록검색
function goList(pageNum) {
	<%-- XSS 방어 --%>
	var _searchVal = defenceXSS(document.SearchFrm.searchValue.value); 
	document.SearchFrm.searchValue.value = _searchVal;
	
	if (!validation()) {
		return;
	}
	document.SearchFrm.pageNum.value = pageNum; // 이동할 페이지
	document.SearchFrm.action = 'pushLogListView.miaps?';
	document.SearchFrm.submit();
}

//ajax 로 가져온 data 를 알맞은 위치에 삽입
function fnAjaxInfoMapping(result) {
	// 상세화면 정보 출력
	var frm = $("#detailFrm");
	frm.find("input[name='pushId']").val(result.pushId);
	frm.find("input[name='deviceId']").val(result.deviceId);
	
	var pushIdTd = "<a href=\"javascript: void(0);\" onclick=\"javascript:showPushLog_hisDialog('" + result.pushId + "');\">" + result.pushId + "</a>";
	$("#pushIdTd").html(pushIdTd);
	$("#pushTaskTd").text(result.pushTaskNm);
	$("#deviceIdTd").text(result.deviceId);
	
	if( null != result.userNo && '' !== result.userNo ) {
		$("#userNmTd").html("<a href=\"javascript: void(0);\" onclick=\"javascript:showSearchUserDetailDialog('" + result.userNo + "');\">" + result.userNm + setBracket(result.userId) + "</a>");
	}
	else {
		$("#userNmTd").text("");
	}
	
	$("#retriesTd").text(result.retries);
	$("#lastSendDtTd").text(result.lastSendDt);
	
	var lastResult = result.lastResult;
	if( '200' == lastResult ) lastResult = "<mink:message code='mink.web.text.success'/>" + "(" + lastResult + ")";
	else lastResult = "<mink:message code='mink.web.text.fail'/>" + "(" + lastResult + ")";
	$("#lastResultTd").text(lastResult);
	$("#resultMsgTd").text(nvl(result.resultMsg));
	var deviceRcvYnInfo = nvl(result.deviceRcvYn);
	if (deviceRcvYnInfo == 'Y') deviceRcvYnInfo = nvl(result.deviceRcvDt);
	$("#deviceRcvYnTd").text(deviceRcvYnInfo);
	var appRcvYnInfo = nvl(result.appRcvYn);
	if (appRcvYnInfo == 'Y') appRcvYnInfo = nvl(result.appRcvDt);
	$("#appRcvYnTd").text(appRcvYnInfo);

	var msgTpInfo = nvl(result.msgTp);
	if ("text" == msgTpInfo.toLowerCase()) {
		msgTpInfo = "<mink:message code='mink.web.text.string.normal'/>";
	} else if ("btext" == msgTpInfo.toLowerCase()) {
		msgTpInfo = "<mink:message code='mink.web.text.string.big'/>";
	} else if ("inbox" == msgTpInfo.toLowerCase()) {
		msgTpInfo = "<mink:message code='mink.web.text.listtype'/>";
	}
	$("#msgTpTd").text(msgTpInfo);
	$("#imgUrlTd").text(nvl(result.imgUrl));
	$("#pushMsgTd").text(nvl(result.pushMsg));
	
	// 값이 없으면 공백넣기
	$( "td", "#detailDiv .detailTb tbody" ).each(function(){
		if( '' == $(this).text() ) {
			$(this).html("&nbsp;");
		}
	});
}

// 푸시 로그 이력(_his) 다이얼로그 오픈
function showPushLog_hisDialog(pushId) {
	$.post('pushLog_hisDetail.miaps?', {pushId : pushId}, function(data){
		// 1. 대상(Target) 상세 탭
		$("#pushLog_hisListTbodyUG").html(data.trUG); // 사용자 그룹
		$("#pushLog_hisListTbodyUN").html(data.trUN); // 사용자 NO
		$("#pushLog_hisListTbodyDD").html(data.trDD); // 장치
		$("#pushLog_hisListTbodyUD").html(data.trUD); // 사용자 ID

		// 2. 메시지 상세 탭
		var result = data.pushData;
		if (result != null) {
			// task 목록
			var taskNm = "";
			var packageNm = "";
			for(var i = 0; i < result.pushTaskList.length; i++) {
				var task = result.pushTaskList[i];
				taskNm += "- "+ task.taskNm + "("+task.taskId+")";
				packageNm += "- "+ task.packageNm + "&nbsp;("+task.taskNm+")" + "<br />";
			}
			$("#taskIdPos_his").html(taskNm);
			$("#packageNm_his").html(packageNm);
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
			$("#dataSt_his").html(dataSt);
			$("#pushMsg_his").html(result.pushMsg);

			if ("${pushType}" == "PREMIUM") {
				var msgTp = result.msgTp;
				if ('' == msgTp) msgTp = "Text";
				$("#msgTp_his").html(msgTp);
	
				var imgUrl = result.imgUrl;
				if ('N' == result.imgUrlYn) imgUrl += " (이미지아님)";
				$("#imgUrl_his").html(imgUrl);
			}

			$("#reservedDd_his").html(result.reservedDt);
			$("#sendStartDt_his").html(result.sendStartDt);
			$("#sendEndDt_his").html(result.sendEndDt);
			$("#resultCd_his").html(result.resultCd);
			$("#resultMsg_his").html(result.resultMsg);
			$("#regNm_his").html(result.regNm);
			$("#regNm_his").html(result.regNm);
		}

		$('#pushLog_hisDialog').dialog("open");
	}, 'json');
}

//상세조회호출(ajax)
function goDetail(pushId, deviceId) {
	checkedTrCheckbox($("#listTr"+pushId+deviceId));	// 선택된 row 색깔변경
	$("#SearchFrm").find("input[name='pushId']").val(pushId); // (선택한)상세
	$("#SearchFrm").find("input[name='deviceId']").val(deviceId); // (선택한)상세
	ajaxComm('pushLogDetail.miaps?', $('#SearchFrm'), function(data){
		fnDetailProcess(data.pushLog); // 상세 ajax 세부작업
		$('#pushLogListViewDialog').dialog("open");
	});
	//$(document.body).scrollTop($("#push-log-detail").offset().top); // 곧바로 이동
	//$('body,html').animate({scrollTop: $("#push-log-detail").offset().top}, 800); // 애니메이션 이동 
}

<%--  검색 결과 다운로드 --%>
function goDownloadPushLogList() {
	if (!validation()) {
		return;
	}
	if(!confirm("<mink:message code='mink.web.alert.is.download.searchresult'/>")) return;	
	document.SearchFrm.action = 'pushLogListDownload.miaps?';
	document.SearchFrm.submit();
}

function validation() {
	var frm = $("#SearchFrm");

	var sdt = frm.find("input[name='startDt']").val();
	var edt = frm.find("input[name='endDt']").val();

	if ((null == sdt || "" == sdt) || (null == edt || "" == edt)) {
		alert("<mink:message code='mink.web.alert.select.searchdate'/>");
		return false;
	} else {
		if ((null != sdt && "" != sdt) && (null != edt && "" != edt)) {
			var diff = getDateDiff(edt, sdt);
			//alert("diff:" + getDiff);
			if (diff < 0) {
				alert("<mink:message code='mink.web.alert.reselect.date'/>");
				return false;
			}
		}
	}
	
	return true;
}

//날짜 차이 계산 함수
// date1 : 기준 날짜(YYYY-MM-DD), date2 : 대상 날짜(YYYY-MM-DD)
function getDateDiff(date1,date2) {
    var arrDate1 = date1.split("-");
    var getDate1 = new Date(parseInt(arrDate1[0]),parseInt(arrDate1[1])-1,parseInt(arrDate1[2]));
    var arrDate2 = date2.split("-");
    var getDate2 = new Date(parseInt(arrDate2[0]),parseInt(arrDate2[1])-1,parseInt(arrDate2[2]));
    
    var getDiffTime = getDate1.getTime() - getDate2.getTime();
    
    return Math.floor(getDiffTime / (1000 * 60 * 60 * 24));
}
</script>
</head>
<body>

<!-- 사용자 상세정보 다이얼로그 -->
<%@ include file="/WEB-INF/jsp/include/searchUserDetailDialog.jsp" %>
<!-- 푸시 상세 다이얼로그 -->
<%@ include file="/WEB-INF/jsp/asvc/push/pushLogListViewDialog.jsp" %>
<!-- 푸시 이력(_his) 상세 다이얼로그 -->
<%@ include file="/WEB-INF/jsp/asvc/push/pushLog_hisDialog.jsp" %>
	<div id="miaps-container">
		<div id="miaps-header">
	    	<%@ include file="/WEB-INF/jsp/include/header.jsp" %>
	  	</div>
	  	<div id="miaps-sidebar">
			<%@ include file="/WEB-INF/jsp/include/left.jsp" %>
		</div>
	<form id="SearchFrm" name="SearchFrm" method="post" onSubmit="return false;">	
		<div id="miaps-top-buttons" style="text-align: right;">
			<span>
				<input type="text" name="startDt" size="10" class="datepicker" value="${empty search.startDt ? '' : search.startDt}" />
				~ <input type="text" name="endDt" size="10" class="datepicker" value="${empty search.endDt ? '' : search.endDt}" />
				<input type="hidden" name="startHh" value="00" />
				<input type="hidden" name="startMm" value="00" />
				<input type="hidden" name="endHh" value="23" />
				<input type="hidden" name="endMm" value="59" />
			</span>
			<select name="searchLastResult">
				<option value="" ${search.searchLastResult == null ? 'selected' : ''}><mink:message code="mink.web.text.push.allsend.finalresult"/></option>
				<option value="Y" ${search.searchLastResult == 'Y' ? 'selected' : ''}><mink:message code="mink.web.text.success.send"/></option>
				<option value="N" ${search.searchLastResult == 'N' ? 'selected' : ''}><mink:message code="mink.web.text.fail.send"/></option>
			</select>
			<select name="searchDeviceRcvYn">
				<option value="" ${search.searchDeviceRcvYn == null ? 'selected' : ''}><mink:message code="mink.web.text.status.receive.alldevice"/></option>
				<option value="Y" ${search.searchDeviceRcvYn == 'Y' ? 'selected' : ''}><mink:message code="mink.web.text.received.device"/></option>
				<option value="N" ${search.searchDeviceRcvYn == 'N' ? 'selected' : ''}><mink:message code="mink.web.text.notreceived.device"/></option>
			</select>
			<select name="searchAppRcvYn">
				<option value="" ${search.searchAppRcvYn == null ? 'selected' : ''}><mink:message code="mink.web.text.status.allread"/></option>
				<option value="Y" ${search.searchAppRcvYn == 'Y' ? 'selected' : ''}><mink:message code="mink.web.text.is.read"/></option>
				<option value="N" ${search.searchAppRcvYn == 'N' ? 'selected' : ''}><mink:message code="mink.web.text.is.notread"/></option>
			</select>
			<select name="searchKey">
				<option value="" ><mink:message code="mink.web.text.full.all"/></option>
				<option value="pushId" ${search.searchKey == 'pushId' ? 'selected' : ''}><mink:message code="mink.web.text.pushid"/></option>
				<option value="userNm" ${search.searchKey == 'userNm' ? 'selected' : ''}><mink:message code="mink.web.text.username"/></option>
				<option value="userId" ${search.searchKey == 'userId' ? 'selected' : ''}><mink:message code="mink.web.text.userid"/></option>
				<option value="deviceId" ${search.searchKey == 'deviceId' ? 'selected' : ''}><mink:message code="mink.web.text.deviceid"/></option>
				<option value="taskId" ${search.searchKey == 'taskId' ? 'selected' : ''}><mink:message code="mink.web.text.bizid"/></option>
				<option value="pushMsg" ${search.searchKey == 'pushMsg' ? 'selected' : ''}><mink:message code="mink.web.text.pushmessage2"/></option>
			</select>
			<input type="text" name="searchValue" value="<c:out value='${search.searchValue}'/>"/>
			<select name="searchPageSize">
				<option value="10" ${search.searchPageSize == '10' ? 'selected' : ''}><mink:message code="mink.web.text.rows10"/></option>
				<option value="20" ${(search.searchPageSize == null || search.searchPageSize == '20') ? 'selected' : ''}><mink:message code="mink.web.text.rows20"/></option>
				<option value="50" ${search.searchPageSize == '50' ? 'selected' : ''}><mink:message code="mink.web.text.rows50"/></option>
				<option value="100" ${search.searchPageSize == '100' ? 'selected' : ''}><mink:message code="mink.web.text.rows100"/></option>
			</select>
			<span><button class='btn-dash' onclick="javascript:goList('1');"><mink:message code="mink.web.text.search"/></button></span>	
			<span><button class='btn-dash' onclick="javascript:goDownloadPushLogList();"><mink:message code="mink.web.text.downloadsearchresult"/></button></span>
		
		</div>
		<div id="miaps-content" style="margin-top: 20px;">
			<p id="totalPushStatsPtag"></p>
			
			<!-- 검색 hidden -->
			<input type="hidden" name="pushId" /><!-- 상세 -->
			<input type="hidden" name="deviceId" /><!-- 상세2 -->
			<input type="hidden" name="pageNum" value="${search.currentPage}" /><!-- 현재 페이지 -->	
			
			<!-- 목록 화면 -->
			<div>
				<table class="listTb" border="0" cellspacing="0" cellpadding="0" width="100%">
					<colgroup>
						<col width="10%" />
						<col width="16%" />
						<col width="20%" />
						<col width="22%" />
						<col width="8%" />
						<col width="8%" />
						<col width="8%" />
						<col width="8%" />
					</colgroup>
					<thead>
						<tr>
							<td><mink:message code="mink.web.text.push.allsend.finaldate"/></td>
							<td><mink:message code="mink.web.text.username.id"/></td>
							<td><mink:message code="mink.web.text.deviceid"/></td>
							<td><mink:message code="mink.web.text.pushmessage2"/></td>
							<td><mink:message code="mink.web.text.push.id.taskid"/></td>
							<td><mink:message code="mink.web.text.push.send.finalresult"/></td>
							<td><mink:message code="mink.web.text.status.receive.device"/></td>
							<td><mink:message code="mink.web.text.status.read"/></td>
						</tr>
					</thead>
					<tbody id="listTbody">
						<!-- 목록이 있을 경우 onclick="javascript:goDetail('${dto.pushId}', '${dto.deviceId}');"-->
						<c:forEach var="dto" items="${pushLogList}" varStatus="i">
						<tr id="listTr${dto.pushId}${dto.deviceId}" onclick="javascript:goDetail('${dto.pushId}', '${dto.deviceId}');">
							<td>${dto.lastSendDt}</td>
							<td align="left">
								<c:if test="${!empty dto.userNm}">${dto.userNm}(${dto.userId})</c:if>
								<c:if test="${dto.userNm}">${dto.userId}</c:if>
							</td>
							<td align="left">${dto.deviceId}</td>
							<td align="left">${dto.pushMsg}</td>
							<td>${dto.pushId}/${dto.taskId}</td>
							<td>${'200' == dto.lastResult ? '<mink:message code="mink.web.text.success"/>' : '<mink:message code="mink.web.text.fail"/>'}</td>
							<td>${dto.deviceRcvYn}</td>
							<td>${dto.appRcvYn}</td>
						</tr>
						</c:forEach>
					</tbody>
					<tfoot id="listTfoot">
						<!-- 목록이 없을 경우 -->
						<tr>
							<td colspan="8"><mink:message code="mink.web.text.noexist.result"/></td>
						</tr>
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
			<div style="padding: 10px;">
			</div>
					
		</div>
	</form>
		<!-- footer -->
		<div id="miaps-footer">
			<%@ include file="/WEB-INF/jsp/include/footer.jsp" %>
		</div>
	</div>
</body>
</html>