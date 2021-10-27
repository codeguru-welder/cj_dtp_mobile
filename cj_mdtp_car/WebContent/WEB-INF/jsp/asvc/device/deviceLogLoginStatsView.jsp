<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="org.springframework.web.bind.annotation.SessionAttributes"%>
<%@ page import="com.thinkm.mink.commons.util.MinkConfig" %>
<%
	/*
	 * 로그인 통계 화면 - 목록 (deviceLogLoginStatsView.jsp)
	 * 
	 * @author eunkyu
	 * @since 2014.08.21
	 * @modify 2015.09.04~ chlee
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
	$("#topMenuTile").html("<mink:message code='mink.web.text.monitoring_loginhistory'/>");
	
	init(); // 이벤트 핸들러 세팅
	
	showPageHtml(); // 페이징 html 생성
	
	checkedTrCheckbox($("#yearListTr${search.logMonth}")); // 선택한 tr 의 checkbox 에 체크선택/css 변경
	
	setdatepicker(); // 달력 설정 변경(년/월 검색)
	
	showCalendar(parseInt("${search.logYear}"), parseInt("${search.logMonth}")); // 달력 생성
	
	// 앱 패키지 검색 초기화
	if('<c:out value="${search.searchApp}"/>' != '') {
		$("#searchFrm").find("select[name='searchApp']").val("<c:out value='${search.searchApp}'/>");
	}
	
	// 로그인 앱 상세정보 다이얼로그 팝업
	$( "#searchAppDetailDialog" ).dialog({
		autoOpen: false,
	   	resizable: false,
	   	width: 'auto',
	   	modal: true,
	   	close: function(event, ui) {
	       // remove div with all data and events
	       $(this).dialog( "close" );
	   	}
	});

	if (eval('${isFirstRequest}')) {
		$("#listTfoot td").text("<mink:message code='mink.web.text.searchplease'/>");
	}
});

// 목록검색
function goList(pageNum) {
	<%-- XSS 방어 --%>
	var _searchVal = defenceXSS(document.searchFrm.searchValue.value); 
	document.searchFrm.searchValue.value = _searchVal;
	
	// 최대 조회가능 기간 검증
	if(isMaxSearchSpan()) {
		return;
	}
	
	document.searchFrm.pageNum.value = pageNum; // 이동할 페이지
	document.searchFrm.action = 'deviceLogLoginStatsView.miaps?';
	document.searchFrm.submit();
}

// 최대 조회가능 기간 검증
function isMaxSearchSpan() {
	var maxSearchSpan = "12"; // 월별 최대 조회가능 기간(12개월)
	var startDate = document.searchFrm.startDate.value;
	var endDate = document.searchFrm.endDate.value;
	var logYear = endDate.substring(0, 4);
	var logMonth = endDate.substring(5, 7);
	
	if('' != startDate && '' != endDate) {
		// 검증
		var startDt = new Date(startDate+'-01');
		var endDt = new Date(endDate+'-01');
		
		var maxMonthDate = new Date(endDt.getFullYear(), endDt.getMonth(), 1);
		maxMonthDate.setMonth(maxMonthDate.getMonth() - parseInt(maxSearchSpan)); // 종료날짜를 기준으로 최대 조회가능 기간 계산
		
		if((endDt - maxMonthDate) < (endDt - startDt)) {
			alert("<mink:message code='mink.web.message19'/>" + maxSearchSpan + "<mink:message code='mink.web.message19.1'/>");
			document.searchFrm.startDate.focus();
			return true;
		}
	}
	
	return false;
}

// 월별검색
function searchYear_goList() {
	var startDate = document.searchFrm.startDate.value;
	var endDate = document.searchFrm.endDate.value;
	var logYear = endDate.substring(0, 4);
	var logMonth = endDate.substring(5, 7);
	
	// 최대 조회가능 기간 검증
	if(isMaxSearchSpan()) {
		return;
	}
	
	// 검색한 년/월의 마지막 월로 일별검색 초기화
	document.searchFrm.mode.value = 'year'; // 목록별 보기 제어
	document.searchFrm.logYear.value = logYear; // 검색한 종료일자 년 초기화
	document.searchFrm.logMonth.value = logMonth; // 검색한 종료일자 월 초기화
	document.searchFrm.logDate.value = '01'; // 일자 초기화
	// 금년인 경우, 오늘 날짜로 초기화
	var today = getToday();
	var tdYearMonth = today.substring(0, 7);
	var tdDate = today.substring(8, 10);
	if(tdYearMonth == (logYear + '-' + logMonth)) {
		document.searchFrm.logDate.value = tdDate; // 일자 초기화
	}
	
	// 사용자별검색조건 초기화
	document.searchFrm.searchKey.value = '';
	document.searchFrm.searchValue.value = '';
	
	goList('1');
}

// 해당 년도의 월별 목록에서 '월' 선택 후, 선택한 월의 '일별' 목록검색
function clickYear_showMonthList_goList(logYear, logMonth) {
	// 최대 조회가능 기간 검증
	if(isMaxSearchSpan()) {
		return;
	}
	
	document.searchFrm.mode.value = 'month'; // 목록별 보기 제어
	document.searchFrm.logYear.value = logYear; // 선택한 년
	document.searchFrm.logMonth.value = logMonth; // 선택한 월
	document.searchFrm.logDate.value = '01'; // 일자 초기화

	// 금년인 경우, 오늘 날짜로 초기화
	var today = getToday();
	var tdYearMonth = today.substring(0, 7);
	var tdDate = today.substring(8, 10);
	if(tdYearMonth == (logYear + '-' + logMonth)) {
		document.searchFrm.logDate.value = tdDate; // 일자 초기화
	}
	
	// 사용자별검색조건 초기화
	document.searchFrm.searchKey.value = '';
	document.searchFrm.searchValue.value = '';
	
	goList('1');
}

// 해당 월의 일자별 목록에서 '일' 선택 후, 선택한 일자의 '사용자별' 목록검색
function clickMonth_showDateList_goList(logDate) {
	document.searchFrm.mode.value = 'date'; // 목록별 보기 제어
	document.searchFrm.logDate.value = logDate; // 선택한 일자
	
	// 사용자별검색조건 초기화
	document.searchFrm.searchKey.value = '';
	document.searchFrm.searchValue.value = '';
	
	goList('1');
}

// 달력 설정 변경(년/월 검색)
function setdatepicker() {
	var datepicker_default = {
	        currentText: "<mink:message code='mink.web.text.thismonth'/>",
	        changeMonth: true,
	        changeYear: true,
	        showButtonPanel: true,
	        yearRange: 'c-99:c+99',
	        showOtherMonths: true,
	        selectOtherMonths: true
	    };
    
	datepicker_default.closeText = "<mink:message code='mink.web.text.select'/>";
    datepicker_default.dateFormat = "yy-mm";
    datepicker_default.onClose = function (dateText, inst) {
        var month = $("#ui-datepicker-div .ui-datepicker-month :selected").val();
        var year = $("#ui-datepicker-div .ui-datepicker-year :selected").val();
        $(this).datepicker( "option", "defaultDate", new Date(year, month, 1) );
        $(this).datepicker('setDate', new Date(year, month, 1));
    };
    
    $("#sdate").datepicker(datepicker_default);
    $("#edate").datepicker(datepicker_default);
    
    $("#sdate").datepicker( "option", "defaultDate", new Date('<c:out value="${search.startDate}"/>'+"-01") );
    $("#edate").datepicker( "option", "defaultDate", new Date('<c:out value="${search.endDate}"/>'+"-01") );
    $("#sdate").datepicker('setDate', new Date('<c:out value="${search.startDate}"/>'+"-01") );
    $("#edate").datepicker('setDate', new Date('<c:out value="${search.endDate}"/>'+"-01") );
}
</script>

<script language="JavaScript">
// 달력 생성
function showCalendar(y, m) {
	var dateLogCntMap = eval("("+'${dateLogCntMap}'+")"); // 일별 접속자수(명)
	var month = (10<=m?''+m:'0'+m);
	var yearMonth = y + '-' + month;
	var text = '<h3><span>[' + yearMonth + ']' + "<mink:message code='mink.web.text.mmdd_visitors'/>" + '</span></h3>\n'; 
	text += '<table id="calendarTb" class="userTable" border="0" cellspacing="0" cellpadding="0" width="100%" style="table-layout:fixed; word-break:break-all;">';
	//text += '\n<thead><tr>';
	//text += '<td colspan="7" class="subSearch" style="text-align:left;">'; 
	//text += '<h3><span>[' + yearMonth + ']월 일별 방문자수(명)</span></h3>'; 
	//text += '</td></tr></thead>';
	text += '<tbody>';
    var d1 = (y+(y-y%4)/4-(y-y%100)/100+(y-y%400)/400+m*2+(m*5-m*5%9)/9-(m<3?y%4||y%100==0&&y%400?2:3:4))%7; 
    for (var i = 0; i < 42; i++) {
	   if (i!=0 && i%7==0) {
	   	text += '</tr>\n<tr style="height: 30px;">';
	   }
	   if ( i < d1 || i >= d1+(m*9-m*9%8)/8%2+(m==2?y%4||y%100==0&&y%400?28:29:30) ) {
		  text += '<td style="padding: 5px 0 0 0;" class="log_calendar"> </td>'; 
	   } else {
		  var d = (i+1-d1); // 날짜
		  d = (10<=d)?""+d:"0"+d;
		  
		  var cnt = dateLogCntMap[d]; // 일별 접속자수(명)
		  if(null == cnt || '' == cnt) cnt = "0";
		  else cnt += "";
		  cnt = trim(cnt);
		  
		  text += '<td id="monthListTr'+d+'" class="log_calendar" style="padding: 8px 0 8px 0; text-align:center; cursor: pointer;'+(i%7==0 ? 'color:red;' : (i+1)%7==0 ? 'color:blue;' : '')+'" onclick="javascript:clickMonth_showDateList_goList(\''+d+'\');">';
		  text += '<div style="width:30px; height:30px; margin: auto;" id="date'+d+'">' + (i+1-d1) + '</div>'; 
		  text += '<br/>';
		  text += '<span style="font-style:normal; font-size:14px; line-height: 0;'+("0"==cnt?'visibility:hidden;':'')+'">'+cnt + "<mink:message code='mink.web.text.count.person'/>"+'</span>';
		  text += '</td>'; 
	   }
	}
	text += '</tbody>';
	document.getElementById('calendarDiv').innerHTML = text + '</tr>\n</table>';
	$("#calendarTb").find("tr").each(function(i, tr){
		var txt = trim($(tr).text());
		if('' == txt) $(tr).remove();
	});
	
	<%-- 오늘날짜 색 변경 --%>
	var today = getToday();
	var tdYearMonth = today.substring(0, 7);
	var tdDate = today.substring(8, 10);
	if(tdYearMonth == yearMonth) {
		$("#calendarTb").find("div[id='date"+tdDate+"']").css("color", "#e96765");
		$("#calendarTb").find("div[id='date"+tdDate+"']").css("font-weight", "bold");
		//$("#calendarTb").find("span[id='date"+tdDate+"']").css("text-shadow", "0px 2px 2px rgba(233, 103, 101, 1)");
	}
	
	<%-- 선택한 날짜 모양변경  --%>
	$("#calendarTb").find("td").each(function(j, td){
		if("monthListTr${search.logDate}" == $(td).attr("id")) {
			$(td).find("div").attr("class","log_calendar_select");
			if($(td).find("div").attr("id") == 'date' + tdDate) {
				$(td).find("div").css("color","white");
				$(td).find("div").css("background-color","#e96765");
			}
		}
	});
}

// 문자 앞/뒤 공백제거
function trim(str) {
    return str.replace(/(^\s*)|(\s*$)/, ""); // 공백제거 정규식
}

<%--  검색 결과 다운로드(월별/일별/사용자별) --%>
function goDownloadDeviceLogLoginStatsViewByMode(mode, pageNum) {
	document.searchFrm.downloadMode.value = mode; // 다운로드 구분
	document.searchFrm.pageNum.value = pageNum; // 이동할 페이지
	document.searchFrm.action = 'deviceLogLoginStatsViewDownloadByMode.miaps?';
	document.searchFrm.submit();
}

<%--  검색 결과 다운로드 --%>
function goDownloadDeviceLogLoginStatsView(pageNum) {
	// 최대 조회가능 기간 검증
	if(isMaxSearchSpan()) {
		return;
	}
	
	document.searchFrm.pageNum.value = pageNum; // 이동할 페이지
	document.searchFrm.action = 'deviceLogLoginStatsViewDownload.miaps?';
	document.searchFrm.submit();
}

// 로그인 앱 상세정보
function showLoginAppDetailDialog(logTm, userNm, deviceId, packageNm, platformCd, versionNm) {
	var packageNmInfo = packageNm;
	$("#searchFrm select option").each(function(){
		var pNm = $(this).val();
		if (pNm != "" && pNm == packageNm) {
			packageNmInfo = $(this).html();
		}
	});
	
	$("#searchAppLogTmTd").html(logTm);
	$("#searchAppUserNmTd").html(userNm);
	$("#searchAppDeviceIdTd").html(deviceId);
	$("#searchAppNmTd").html(packageNmInfo);
	$("#searchAppPlatformCd").html(getPlatformNm(platformCd));
	$("#searchAppVersionNmTd").html(versionNm);
	
	$("#searchAppDetailDialog").dialog( "open" ); // 다이얼로그 팝업 나타나기
}

function getPlatformNm(platformCd) {
	if ("${PLATFORM_ANDROID}" == platformCd) {
		return "Android Phone";
	} else if ("${PLATFORM_ANDROID_TBL}" == platformCd) {
		return "Android Tablet";
	} else if ("${PLATFORM_IOS}" == platformCd) {
		return "iPhone";
	} else if ("${PLATFORM_IOS_TBL}" == platformCd) {
		return "iPad";
	} else {
		return "";
	}
}

</script>

<style type="text/css">
table.ui-datepicker-calendar { display:none; }
</style>

</head>
<body>

<!-- 로그인 앱 상세정보 dialog -->
<div>
<div id="searchAppDetailDialog" title="<mink:message code='mink.web.text.info.loginappdetail'/>" class="dlgStyle">
<div class="miaps-popup-top-buttons" style="border-bottom: 0px;">
	&nbsp;
	<span><button class='btn-dash' onclick="javascript:$('#searchAppDetailDialog').dialog('close');"><mink:message code="mink.web.text.close"/></button></span>
</div>	
	<!-- 상세화면 -->
	<table class="detailTb" border="0" cellspacing="0" cellpadding="7" width="100%">
		<colgroup>
			<col width="30%" />
			<col width="70%" />
		</colgroup>
		<tbody>
			<tr>
				<th><mink:message code="mink.web.text.logincount.finally.today"/></th>
				<td id="searchAppLogTmTd"></td>
			</tr>
			<tr>
				<th><mink:message code="mink.web.text.username.id"/></th>
				<td id="searchAppUserNmTd"></td>
			</tr>
			<tr>
				<th><mink:message code="mink.web.text.deviceid"/></th>
				<td id="searchAppDeviceIdTd"></td>
			</tr>
			<tr>
				<th><mink:message code="mink.web.text.full.packagename"/></th>
				<td id="searchAppNmTd"></td>
			</tr>
			<tr>
				<th><mink:message code="mink.web.text.platform"/></th>
				<td id="searchAppPlatformCd"></td>
			</tr>
			<tr>
				<th><mink:message code="mink.web.text.versionname"/></th>
				<td id="searchAppVersionNmTd"></td>
			</tr>
		</tbody>
		<tfoot></tfoot>
	</table>
</div>
</div>

<!-- 사용자 상세정보 다이얼로그 -->
<%@ include file="/WEB-INF/jsp/include/searchUserDetailDialog.jsp" %>
<%-- 장치 상세정보 다이얼로그 --%> 
<!-- 본문 -->
<div id="miaps-container">
	<div id="miaps-header">
    	<%@ include file="/WEB-INF/jsp/include/header.jsp" %>
  	</div>
  	<div id="miaps-sidebar">
		<%@ include file="/WEB-INF/jsp/include/left.jsp" %>
	</div>
<form id="searchFrm" name="searchFrm" method="post" onsubmit="return false;">	
	<div id="miaps-top-buttons">
		<button class='btn-dash' onclick="javascript:goDownloadDeviceLogLoginStatsViewByMode('month', '1');"><mink:message code="mink.web.text.download.monthly"/></button>
		<button class='btn-dash' onclick="javascript:goDownloadDeviceLogLoginStatsViewByMode('date', '1');"><mink:message code="mink.web.text.download.daily"/></button>
		<button class='btn-dash' onclick="javascript:goDownloadDeviceLogLoginStatsViewByMode('user', '1');"><mink:message code="mink.web.text.download.user"/></button>
		&nbsp;
		<span style="float:right;">
			<span class="licenseInfoText" style="font-size: 12px;"><mink:message code="mink.web.text.max12month"/></span>
			<select name="searchApp">
				<option value="" ${search.searchApp == '' ? 'selected' : ''}><mink:message code="mink.web.text.full.packagename"/></option>
				<c:forEach var="searchApp" items="${search.packageNmList}">
					<option value="<c:out value="${searchApp.packageNm}"/>"><c:out value="${searchApp.appNm}"/></option>
				</c:forEach>
			</select>
			<input type="text" id="sdate" name="startDate" value="${search.startDate}" size="7" maxlength="7" />
			~ <input type="text" id="edate" name="endDate" value="${search.endDate}" size="7" maxlength="7" />
			<button class='btn-dash' onclick="javascript:searchYear_goList();"><mink:message code="mink.web.text.search"/></button>
		</span>
		<!-- 
		<button class='btn-dash' onclick="javascript:goDownloadDeviceLogLoginStatsView('1');">검색 결과 다운로드</button>
		 -->
		 <span style="clear: both;"></span>
	</div>
	<div id="miaps-content">
		<!-- 검색 hidden -->
		<input type="hidden" name="pageNum" value='<c:out value="${search.currentPage}"/>' /><!-- 현재 페이지 -->
		<input type="hidden" name="logYear" value='<c:out value="${search.logYear}"/>' /><!-- 년 -->
		<input type="hidden" name="logMonth" value='<c:out value="${search.logMonth}"/>' /><!-- 월 -->
		<input type="hidden" name="logDate" value='<c:out value="${search.logDate}"/>' /><!-- 일 -->
		<input type="hidden" name="mode" value='<c:out value="${searchMode}"/>' /><!-- 월별/일별/사용자별 검색구분(목록별 보기 제어) -->
		<input type="hidden" name="downloadMode" /><!-- 월별/일별/사용자별 다운로드 구분 -->
		<div id="miaps-in-content-left" style="width: 40%; border: 0px;">
			<h3><span style="padding-left: 4px;"><mink:message code="mink.web.text.mm_visitors"/></span></h3>
			<!-- 목록 화면 -->
			<div>
				<table id="listTb" class="listTb" border="0" cellspacing="0" cellpadding="0" width="100%">
					<colgroup>
						<col width="50%" />
						<col width="50%" />
					</colgroup>
					<thead>
						<tr>
							<td><mink:message code="mink.web.text.month"/></td>
							<td><mink:message code="mink.web.text.visitors2"/></td>
						</tr>
					</thead>
					<tbody id="listTbody">
						<!-- 목록이 있을 경우 -->
						<c:forEach var="dto" items="${deviceLogMonthList}" varStatus="i">
						<tr id="yearListTr${dto.logMonth}" onclick="javascript:clickYear_showMonthList_goList('${dto.logYear}','${dto.logMonth}');">
							<td>${dto.logYear}-${dto.logMonth}</td>
							<td>${dto.logCount}<mink:message code="mink.web.text.count.person"/></td>
						</tr>
						</c:forEach>
					</tbody>
					<tfoot id="listTfoot">
						<c:if test="${empty deviceLogMonthList || fn:length(deviceLogMonthList) < 1}">
						<!-- 목록이 없을 경우 -->
						<tr>
							<td colspan="2"><mink:message code="mink.web.text.noexist.result"/></td>
						</tr>
						</c:if>
					</tfoot>
				</table>
			</div>
			<div>
				<div id="monthDiv">
					<div id="calendarDiv"></div><!-- 일별 방문자수(명) 달력화면 -->
				</div>				
			</div>
		</div>
		<div id="miaps-in-content-right" style="width: 58.5%;">
			<h3><span style="padding-left: 4px;">[<c:out value="${search.logYear}"/>-<c:out value="${search.logMonth}"/>-<c:out value="${search.logDate}"/>]<mink:message code="mink.web.text.count.byuser"/></span></h3>
			<!-- 검색 화면 -->
			<div>
				<table class="userTable" border="0" cellspacing="0" cellpadding="0" width="100%">
					<%-- <thead><tr><td class="subSearch"><h3><span style="padding-left: 4px;">[${search.logYear}-${search.logMonth}-${search.logDate}]일 사용자별 방문횟수</span></h3></td></tr></thead> --%>
					<tbody>
						<tr> 	
							<td class="search">
								<select name="searchKey">
									<option value="" ${search.searchKey == '' ? 'selected' : ''}><mink:message code="mink.web.text.full.all"/></option>
									<option value="userNm" ${search.searchKey == 'userNm' ? 'selected' : ''}><mink:message code="mink.web.text.username"/></option>
									<option value="userId" ${search.searchKey == 'userId' ? 'selected' : ''}><mink:message code="mink.web.text.userid"/></option>
									<option value="deviceId" ${search.searchKey == 'deviceId' ? 'selected' : ''}><mink:message code="mink.web.text.deviceid"/></option>
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
					</tbody>
				</table>
			</div>
				
			<!-- 목록 화면 -->
			<div>
				<table class="read_listTb" border="0" cellspacing="0" cellpadding="0" width="100%">
					<colgroup>
						<col width="20%" />
						<col width="28%" />
						<col width="40%" />
						<col width="12%" />
					</colgroup>
					<thead>
						<tr>
							<td><mink:message code="mink.web.text.logincount.finally.today"/></td>
							<td><mink:message code="mink.web.text.username.id"/></td>
							<td><mink:message code="mink.web.text.deviceid"/></td>
							<td><mink:message code="mink.web.text.logincount.today"/></td>
						</tr>
					</thead>
					<tbody id="listTbody">
						<!-- 목록이 있을 경우 -->
						<c:forEach var="dto" items="${deviceLogUserList}" varStatus="i">
						 <tr>
							<td>${dto.logTm}</td>
							<td align="left">
								<c:set var="loginUserNm" value="" />
								<c:if test="${!empty dto.userId}">
										<c:if test="${empty dto.userNm}">
											<c:set var="loginUserNm" value="${dto.userId}" />
										</c:if>
										<c:if test="${!empty dto.userNm}">
											<c:set var="loginUserNm" value="${dto.userNm} (${dto.userId})" />
										</c:if>
								</c:if>
								
								<c:if test="${!empty dto.userId}">
									<a href="javascript:javascript: void(0);" onclick="showSearchUserDetailDialog('${dto.userNo}');">
									${loginUserNm}
									</a>
								</c:if>
								<c:if test="${empty dto.userId}">
									<mink:message code="mink.web.text.deleteuser"/>
								</c:if>
							</td>
							<td align="left">
								<a href="javascript:showLoginAppDetailDialog('${dto.logTm}', '${dto.userNm}', '${dto.deviceId}', '${dto.packageNm}', '${dto.platformCd}', '${dto.versionNm}');">
									${dto.deviceId}
								</a>
							</td>
							<td>${dto.logCount}</td>
						</tr>
						</c:forEach>
					</tbody>
					<tfoot id="listTfoot">
						<c:if test="${empty deviceLogUserList || fn:length(deviceLogUserList) < 1}">
						<!-- 목록이 없을 경우 -->
						<tr>
							<td colspan="4"><mink:message code="mink.web.text.noexist.result"/></td>
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