<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="org.springframework.web.bind.annotation.SessionAttributes"%>
<%@ page import="com.thinkm.mink.commons.util.MinkConfig" %>
<%
	/*
	 * 장치 업무별 접속 현황 화면 - 목록 (deviceBizAccessListView.jsp)
	 * 
	 * @author juni
	 * @since 2014.03.05
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
	$("#topMenuTile").html("<mink:message code='mink.menu.monitoring'/>" + " > " + "<mink:message code='mink.menu.task_access_history'/>");
	
	init(); // 초기설정 셋팅
	
	showList(); // 목록 보이기
	showPageHtml(); // 페이징 html 생성
	
	// 검색날짜 없을 경우 초기화
	if( '${search.endDt}' == '' ) {
		$("select[name='endHh']").val("00");	
		$("select[name='endMm']").val("00");
	}
	
	// 앱 패키지 검색 초기화
	if('<c:out value="${search.searchApp}"/>' != '') {
		$("#SearchFrm").find("select[name='searchApp']").val("<c:out value='${search.searchApp}'/>");
	}
	
	// 검색어 Enter 이벤트
	$("#SearchFrm").find("input[name='searchValue']").on("keypress", function(event){
		if (event.which == 13) {
			$("#searchValueBtn").trigger("click");
			return false;
		}
	});

	if (eval('${isFirstRequest}')) {
		$("#listEmpty td").text("<mink:message code='mink.web.text.searchplease'/>");
	}
});

// 목록/검색
function goList(pageNum) {
	<%-- XSS 방어 --%>
	var _searchVal = defenceXSS(document.SearchFrm.searchValue.value); 
	document.SearchFrm.searchValue.value = _searchVal;
	
	document.SearchFrm.pageNum.value = pageNum; // 이동할 페이지
	document.SearchFrm.action = 'deviceBizAccessList.miaps?';
	document.SearchFrm.submit();
}

// 접속 현황 상세 조회
function goDetailList(targetUrl, urlNm, packageNm, logPackageNm) {
	checkedTrCheckbox($("#listTr" + targetUrl + logPackageNm));	// 선택된 row 색깔변경
	$("#SearchFrm").find("input[name='targetUrl']").val(targetUrl); // (선택한)상세
	$("#SearchFrm").find("input[name='urlNm']").val(urlNm);
	$("#SearchFrm").find("input[name='pageNum']").val("1");
	$("#SearchFrm").find("input[name='packageNm']").val(packageNm);
	ajaxComm('deviceAccessDetailList.miaps?', $('#SearchFrm'), callbackUserAccessList);
/* 	ajaxComm('deviceAccessDetailList.miaps?', $('#SearchFrm'), function(data){
		fnSetDeviceAccessDetailList(data);
	}); */
}

function goDeviceAccessList(pageNum) {
	$("#SearchFrm").find("input[name='pageNum']").val(pageNum);
	ajaxComm('deviceAccessDetailList.miaps?', SearchFrm, function(data){
		fnSetDeviceAccessDetailList(data);
	});
}

// 입력 값 검증
function validation(frm) {
	var result = false;
	
	return result;
}

<%--  검색 결과 다운로드 --%>
function goDownloadDeviceTargetAccessList(pageNum) {
	document.SearchFrm.pageNum.value = pageNum; // 이동할 페이지
	document.SearchFrm.action = 'deviceBizAccessListDownload.miaps?';
	document.SearchFrm.submit();
}
</script>

</head>
<body>

<!-- 사용자 상세정보 다이얼로그 -->
<%@ include file="/WEB-INF/jsp/include/searchUserDetailDialog.jsp" %>
<%-- 장치 상세정보 다이얼로그 --%> 
<%@ include file="/WEB-INF/jsp/asvc/device/deviceBizAccessListDialog.jsp" %>

	<!-- 본문 -->
	<div id="miaps-container">
		<div id="miaps-header">
	    	<%@ include file="/WEB-INF/jsp/include/header.jsp" %>
	  	</div>
	  	<div id="miaps-sidebar">
			<%@ include file="/WEB-INF/jsp/include/left.jsp" %>
		</div>
	<form id="SearchFrm" name="SearchFrm" method="post">	
		<div id="miaps-top-buttons" style="text-align: right;">
			<span>
				<input type="text" name="startDt" size="10" class="datepicker" value="${empty search.startDt ? '' : search.startDt}" />
				~ <input type="text" name="endDt" size="10" class="datepicker" value="${empty search.endDt ? '' : search.endDt}" />
				<input type="hidden" name="startHh" value="00" />
				<input type="hidden" name="startMm" value="00" />
				<input type="hidden" name="endHh" value="23" />
				<input type="hidden" name="endMm" value="59" />
			</span>
			<span>
			<select name="searchApp">
				<option value="" ${search.searchApp == '' ? 'selected' : ''}><mink:message code='mink.label.all_app_nm_pkgnm'/></option>
				<c:forEach var="searchApp" items="${search.packageNmList}">
					<option value="<c:out value="${searchApp.packageNm}"/>"><c:out value="${searchApp.appNm}"/></option>
				</c:forEach>
			</select>
			</span>
			<!-- 
			&nbsp;&nbsp;
			<span class="colorWhite">사용자 :</span>
			 -->
			<span>
			<select name="searchKey">
				<option value="" ${search.searchKey == '' ? 'selected' : ''}><mink:message code='mink.label.all'/></option>
				<option value="targetUrl" ${search.searchKey == 'targetUrl' ? 'selected' : ''}><mink:message code='mink.label.task_name'/></option>
				<!-- 
				<option value="userNm" ${search.searchKey == 'userNm' ? 'selected' : ''}>최종접속자명</option>
				<option value="userId" ${search.searchKey == 'userId' ? 'selected' : ''}>최종접속자ID</option>
				 -->
			</select>
			<input type="text" name="searchValue" value="<c:out value='${search.searchValue}'/>" size="20"/>
			</span>
			<select name="searchPageSize">
				<option value="10" ${search.searchPageSize == '10' ? 'selected' : ''}>10<mink:message code='mink.label.line'/></option>
				<option value="20" ${(search.searchPageSize == null || search.searchPageSize == '20') ? 'selected' : ''}>20<mink:message code='mink.label.line'/></option>
				<option value="50" ${search.searchPageSize == '50' ? 'selected' : ''}>50<mink:message code='mink.label.line'/></option>
				<option value="100" ${search.searchPageSize == '100' ? 'selected' : ''}>100<mink:message code='mink.label.line'/></option>
			</select>
			<span><button id="searchValueBtn" class='btn-dash' onclick="javascript:goList('1');"><mink:message code='mink.web.text.search'/></button></span>
			<span><button class='btn-dash' onclick="javascript:goDownloadDeviceTargetAccessList('1');"><mink:message code='mink.label.search_result_download'/></button></span>
		</div>	
		<div id="miaps-content" style="margin-top: 20px;">
			<!-- 검색 hidden -->
			<input type="hidden" name="targetUrl" /><!-- 상세조회를 위한 key -->
			<input type="hidden" name="packageNm" /><!-- 상세조회를 위한 key -->
			<input type="hidden" name="pageNum" value="${search.currentPage}" /><!-- 현재 페이지 -->
			<input type="hidden" name="urlNm" value="" /><!-- 상세 타이틀명 -->
			
			<!-- 목록 화면 -->
			<div id="listDiv">
				<table class="listTb" border="0" cellspacing="0" cellpadding="0" width="100%">
					<colgroup>
						<!-- <col width="10%" /> -->
						<col width="35%" />
						<col width="55%" />
						<!-- <col width="20%" /> -->
						<!-- <col width="15%" />
						<col width="20%" /> -->
						<col width="10%" />
					</colgroup>
					<thead>
						<tr>
							<!-- <td>순번</td> -->
							<td><mink:message code='mink.label.app_nm_pkgnm'/></td>
							<td><mink:message code='mink.label.task_name'/></td>
							<!-- <td>최종접속자그룹</td> -->
							<!-- <td>최종접속자명</td>
							<td>최종접속일시</td> -->
							<td><mink:message code='mink.label.access_count'/></td>
						</tr>
					</thead>
					<tbody id="listTbody">
						<c:forEach var="dto" items="${deviceBizAccessList}" varStatus="i">
						<tr id="listTr${dto.TARGET_URL}${fn:replace(dto.PACKAGE_NM, '.', '')}" onclick="javascript:goDetailList('${dto.TARGET_URL}', '${dto.URL_NM}','${dto.PACKAGE_NM}','${fn:replace(dto.PACKAGE_NM, '.', '')}');">
							<%-- <td>${search.number - i.index}</td> --%>
							<td align="left">
								<c:set var="dtoAppNm" value="${dto.PACKAGE_NM}" />
								<c:forEach var="searchApp2" items="${search.packageNmList}">
									<c:if test="${searchApp2.packageNm == dto.PACKAGE_NM}">
										<c:set var="dtoAppNm" value="${searchApp2.appNm}" />
									</c:if>
								</c:forEach>
								${dtoAppNm}
							</td>
							<%-- <td align="left">${dto.URL_NM}<c:if test="${empty dto.URL_NM}">${dto.TARGET_URL}</c:if></td> --%>
							<td align="left">${dto.URL_NM} (${dto.TARGET_URL})</td>
							<%-- <td>${dto.USER_GRP_NM}</td> --%>
							<%-- <td>${empty dto.USER_NM ? 'guest' : dto.USER_NM}<c:if test="${!empty dto.USER_ID}">(${dto.USER_ID})</c:if></td> --%>
							<%-- <td>${dto.LOG_TM}</td> --%>
							<td>${dto.ACCESS_CNT}</td>	
						</tr>
						</c:forEach>
					</tbody>
					<tfoot id="listEmpty">
						<c:if test="${empty deviceBizAccessList}">
						<tr >
							<td colspan="3"><mink:message code='mink.web.text.noexist.result'/></td>
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
			<div style="padding: 10px;">
				<!-- <span class='btn-dash'><button class='btn-dash' onclick="javascript:goDeleteAll();">삭제</button></span> -->
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