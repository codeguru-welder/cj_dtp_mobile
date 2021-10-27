<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="org.springframework.web.bind.annotation.SessionAttributes"%>
<%@ page import="com.thinkm.mink.commons.util.MinkConfig" %>
<%
	/*
	 * 앱 다운로드 현황 조회 - 앱별 총 다운로드 횟수조회, 앱별 다운로드 상세 조회, 사용자 별 앱 다운로드 횟수 조회(앱 별 다운로드 상세조회에서 사용자 선택 시), 사용자 별, 선택 앱 다운로드 상세 조회 (appDownloadListView.jsp)
	 * 
	 * @author chlee
	 * @since 2015.12.16	 
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

$(function() {
	// 그룹검색 treeview dialog
	actionSearchUserGroup();
	
	//accordion 선택 페이지를 유지하기위한 설정값 셋팅 ex) home:0 user:1, device:2, app:3, push:4, board:5, monitoring:6, setting:7
	init_accordion('monitoring', '${loginUser.menuListString}');
	$("#topMenuTile").html("<mink:message code='mink.web.text.monitoring_appdownload'/>");
	
	init(); <%-- 이벤트 핸들러 세팅 --%>
	
	showList(); <%-- 목록 보이기 --%>
	showPageHtml(); <%-- 페이징 html 생성 --%>
	
	<%-- 등록 및 수정 시 검색조건 셋팅 --%>
	$("input[name='searchAppKey']").val("<c:out value='${search.searchAppKey}'/>");
	$("input[name='searchAppValue']").val("<c:out value='${search.searchAppValue}'/>");
	
	$("input[name='searchUserKey']").val("<c:out value='${search.searchUserKey}'/>");
	$("input[name='searchUserValue']").val("<c:out value='${search.searchUserValue}'/>");
	
	<%--
	if(eval('${!empty app}')) {
		var dto = eval("("+'${app}'+")");
		fnDetailProcess(dto);
		checkedTrCheckbox($("#listTr"+dto.appId)); // 선택한 tr 의 checkbox 에 체크선택/css 변경 
	}
	--%>
	
	// 검색어 Enter 이벤트
	$("#searchFrm").find("input[name='searchUserValue']").on("keypress", function(event){
		if (event.which == 13) {
			$("#searchValueBtn").trigger("click");
			return false;
		}
	});
	
});

<%-- 목록검색 --%>
function goList(pageNum) {
	<%-- XSS 방어 --%>
	var _searchVal = defenceXSS(document.searchFrm.searchUserValue.value); 
	document.searchFrm.searchUserValue.value = _searchVal;
	
	var frm = $("#searchFrm");
	/* 
	var verValue = frm.find("input[name='searchVerValue']").val();
	if (verValue != null && verValue != '') {
		var appValue = frm.find("input[name='searchAppValue']").val();
		if (appValue == null || appValue == '') {
			alert("버전 검색 조건을 추가할 때는 앱 검색 조건이 필수 입니다. 앱 검색 조건을 추가 해 주세요.");
			return;
		}
	}
	 */
	document.searchFrm.pageNum.value = pageNum; <%-- 이동할 페이지 --%>
	document.searchFrm.action = 'appDownloadListView.miaps?';
	document.searchFrm.submit();
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

<%--  '앱 다운로드 현황' 검색 결과 다운로드 --%>
function goDownloadAppDownList(pageNum) {
	document.searchFrm.pageNum.value = pageNum; // 이동할 페이지
	document.searchFrm.action = 'appDownloadListViewDownload.miaps?';
	document.searchFrm.submit();
}
</script>
</head>
<body>

<!-- 그룹검색 treeview dialog -->
<%@ include file="/WEB-INF/jsp/include/searchUserGroupTreeviewDialog.jsp" %>
<!-- 사용자 상세정보 다이얼로그 -->
<%@ include file="/WEB-INF/jsp/include/searchUserDetailDialog.jsp" %>
<!-- 사용자 그룹 내비게이션 다이얼로그 -->
<%@ include file="/WEB-INF/jsp/include/searchUserGroupNaviDialog.jsp" %>

<%-- 앱 다운로드 상세 다이얼로그 --%>
<%@ include file="/WEB-INF/jsp/asvc/app/appDownloadDetailDialog.jsp" %>

<div id="miaps-container">
	<div id="miaps-header">
    	<%@ include file="/WEB-INF/jsp/include/header.jsp" %>
  	</div>
  	<div id="miaps-sidebar">
		<%@ include file="/WEB-INF/jsp/include/left.jsp" %>
	</div>
<form id="searchFrm" name="searchFrm" method="post" onSubmit="return false;">
	<div id="miaps-top-buttons" style="text-align: right;">
		<span>
			<input type="text" name="startDt" size="10" class="datepicker" value="${empty search.startDt ? '' : search.startDt}" />
			~ <input type="text" name="endDt" size="10" class="datepicker" value="${empty search.endDt ? '' : search.endDt}" />
			<input type="hidden" name="startHh" value="00" />
			<input type="hidden" name="startMm" value="00" />
			<input type="hidden" name="endHh" value="23" />
			<input type="hidden" name="endMm" value="59" />
		</span>
		<input type="hidden" name="searchAppKey" value="packageNm" />
		<select name="searchAppValue">
			<option value="" ${search.searchAppValue == '' ? 'selected' : ''}><mink:message code="mink.web.text.full.packagename"/></option>
			<c:forEach var="searchAppValue" items="${search.packageNmList}">
				<option value="<c:out value="${searchAppValue.packageNm}"/>" ${search.searchAppValue == searchAppValue.packageNm ? 'selected' : ''}><c:out value="${searchAppValue.appNm}"/></option>
			</c:forEach>
		</select>
		&nbsp;
		<select name="searchPfKey">
			<option value="" ${search.searchPfKey == '' ? 'selected' : ''}><mink:message code="mink.web.text.platform.noidentify"/></option>
			<option value="${PLATFORM_ANDROID}" ${search.searchPfKey == PLATFORM_ANDROID ? 'selected' : ''}>Android Phone</option>
			<option value="${PLATFORM_ANDROID_TBL}" ${search.searchPfKey == PLATFORM_ANDROID_TBL ? 'selected' : ''}>Android Tablet</option>
			<option value="${PLATFORM_IOS}" ${search.searchPfKey == PLATFORM_IOS ? 'selected' : ''}>iPhone</option>
			<option value="${PLATFORM_IOS_TBL}" ${search.searchPfKey == PLATFORM_IOS_TBL ? 'selected' : ''}>iPad</option>
			<option value="allPlatform" ${search.searchPfKey == 'allPlatform' ? 'selected' : ''}><mink:message code="mink.web.text.by.platform"/></option>
		</select>
		&nbsp;
		<select name="searchUserKey">
			<option value="" ${search.searchUserKey == '' ? '' : ''}><mink:message code="mink.web.text.totaluser"/></option>
			<option value="userNm" ${search.searchUserKey == 'userNm' ? 'selected' : ''}><mink:message code="mink.web.text.username"/></option>
			<option value="userId" ${search.searchUserKey == 'userId' ? 'selected' : ''}><mink:message code="mink.web.text.userid"/></option>
		</select>
		<input type="text" name="searchUserValue" value="<c:out value='${search.searchUserValue}'/>"/>
		<select name="searchPageSize">
			<option value="10" ${search.searchPageSize == '10' ? 'selected' : ''}><mink:message code="mink.web.text.rows10"/></option>
			<option value="20" ${(search.searchPageSize == null || search.searchPageSize == '20') ? 'selected' : ''}><mink:message code="mink.web.text.rows20"/></option>
			<option value="50" ${search.searchPageSize == '50' ? 'selected' : ''}><mink:message code="mink.web.text.rows50"/></option>
			<option value="100" ${search.searchPageSize == '100' ? 'selected' : ''}><mink:message code="mink.web.text.rows100"/></option>
		</select>
		<button id="searchValueBtn" class='btn-dash' onclick="javascript:goList('1');"><mink:message code="mink.web.text.search"/></button>
		<button class='btn-dash' onclick="javascript:goDownloadAppDownList('1');"><mink:message code="mink.web.text.downloadsearchresult"/></button>
	</div>
	<div id="miaps-content">
		
		<input type="hidden" name="pageNum" value="${search.currentPage}" /><%-- 현재 페이지 --%>
	
		<%-- 검색 화면 --%>
		<div>
			<table border="0" cellspacing="0" cellpadding="0" width="100%">
				<!-- 그룹검색 시작 -->
				<%@ include file="/WEB-INF/jsp/include/searchUserGroupTr.jsp" %>
				<!-- 그룹검색 끝 -->				
			</table>
		</div>
		
		<%-- 목록 화면 --%>
		<div>
			<table class="listTb" border="0" cellspacing="0" cellpadding="0" width="100%">
				<colgroup>
					<col width="50%" />
					<col width="30%" />
					<col width="20%" />
				</colgroup>
				<thead>
					<tr>
						<td><mink:message code="mink.web.text.full.packagename"/></td>
						<td><mink:message code="mink.web.text.platform"/></td>
						<td><mink:message code="mink.web.text.count.downloaduser"/></td>
					</tr>
				</thead>
				<tbody id="listTbody">
					<%-- 목록이 있을 경우 --%>
					<c:forEach var="dto" items="${appDownList}" varStatus="i">
					<tr id="listTr${fn:replace(dto.packageNm, '.', '')}${dto.platformCd}" onclick="javascript:openAppDnDetailDialog('${dto.packageNm}', '${dto.platformCd}', '${fn:replace(dto.packageNm, '.', '')}${dto.platformCd}', '1');">
						<td align="left">
							<c:set var="dtoAppNm" value="${dto.packageNm}" />
							<c:forEach var="appInfo" items="${search.packageNmList}">
								<c:if test="${appInfo.packageNm == dto.packageNm}">
									<c:set var="dtoAppNm" value="${appInfo.appNm}" />
								</c:if>
							</c:forEach>
							<c:out value='${dtoAppNm}'/>
						</td>
						<td align="left"><!-- 216줄 - 기존 &nbsp; 였지만 크롬과 IE9에서는 인식이 되지않음. 변경. 2019-04-04 kjs -->
							<c:choose>
								<c:when test="${dto.platformCd==''}"></c:when>
								<c:when test="${dto.platformCd==PLATFORM_ANDROID}">Android Phone</c:when>
								<c:when test="${dto.platformCd==PLATFORM_ANDROID_TBL}">Android Tablet</c:when>
								<c:when test="${dto.platformCd==PLATFORM_IOS}">iPhone</c:when>
								<c:when test="${dto.platformCd==PLATFORM_IOS_TBL}">iPad</c:when>
								<c:otherwise><br></c:otherwise>
							</c:choose>
						</td>
						<td>${dto.downloadCnt}</td>
					</tr>
					</c:forEach>
				</tbody>
				<tfoot id="listTfoot">
					<tr>
						<td colspan="3"><mink:message code="mink.web.text.noexist.result"/></td>
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
	</div>
</form>	
	<div id="miaps-footer">
    	<%@ include file="/WEB-INF/jsp/include/footer.jsp" %>
  	</div>
</div>
</body>
</html>
