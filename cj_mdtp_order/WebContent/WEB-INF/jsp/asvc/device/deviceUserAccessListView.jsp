<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="org.springframework.web.bind.annotation.SessionAttributes"%>
<%@ page import="com.thinkm.mink.commons.util.MinkConfig" %>
<%
	/*
	 * 장치 사용자 접속 현황 화면 - 목록 (deviceUserAccessListView.jsp)
	 * 
	 * @author juni
	 * @since 2014.03.05
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
	$("#topMenuTile").html("<mink:message code='mink.web.text.monitoring_useraccess'/>");
	
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
	
	// 플랫폼 초기화
	if('${search.searchPlatform}' != '') {
		$("#SearchFrm").find("select[name='searchPlatform']").val("<c:out value='${search.searchPlatform}'/>");
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
	document.SearchFrm.action = 'deviceUserAccessList.miaps?';
	document.SearchFrm.submit();
}

// 접속 현황 상세 조회
 function goDetailList(userNo, packageNm, replacePackageNm) {
	/* tag ID에 .이 들어가면 jquery에서 ID를 찾지 못하는 것 같음.
	   그래서 jstl에서 패키지의 .을 제거해서 파라메터로 받아서 listTr뒤에 붙이도록 함. */
	
	checkedTrCheckbox($("#listTr" + userNo + replacePackageNm));	// 선택된 row 색깔변경 
	$("#SearchFrm").find("input[name='userNo']").val(userNo); // (선택한)상세
	$("#SearchFrm").find("input[name='pageNum']").val("1");
	$("#SearchFrm").find("input[name='packageNm']").val(packageNm);
	
	/* ajaxComm('deviceAccessDetailList.miaps?', $('#SearchFrm'), function(data){	
		fnSetDeviceAccessDetailList(data);
	}); */
	 ajaxComm('deviceAccessDetailList.miaps?', $('#SearchFrm'), callbackUserAccessList);
} 

// 접속현황 상세 목록 조회
function goDeviceAccessList(pageNum) {
	$("#SearchFrm").find("input[name='pageNum']").val(pageNum);
	ajaxComm('deviceAccessDetailList.miaps?', SearchFrm, function(data){
		fnSetDeviceAccessDetailList(data);
	});
}
<%--
// 접속현황 상세 목록 set
function fnSetDeviceAccessDetailList(data) {
	
	var resultList = data.deviceAccessDetailList;

	$("#logListTb > tbody > tr").remove();		// tbody 밑의 tr 삭제
	if( resultList.length > 0 ) {	// 결과 목록이 있을경우
		//$("#userNm").html(resultList[0].userNm);	// title의 사용자명
		$("#userNm").html("<a href=\"javascript: void(0);\" onclick=\"javascript:showSearchUserDetailDialog('" + resultList[0].userNo + "');\">" + resultList[0].userNm + setBracket(resultList[0].userId) + "</a>");
		$("#logPackageNm").html(resultList[0].packageNm);	// title의 앱 패키지명		
		for(var i = 0; i < resultList.length; i++) {
			var newRow = $("#logListTb > thead > tr").clone(); // head row 복사
			newRow.children().html("");	// td 내용 초기화
			newRow.removeClass();
			/* newRow.find("td:eq(0)").html(parseInt(data.search.number) - i); */
			newRow.find("td:eq(0)").html(resultList[i].logTm); 
			newRow.find("td:eq(1)").html(resultList[i].urlNm);
			newRow.find("td:eq(1)").attr("align", "left");
			newRow.find("td:eq(2)").html(resultList[i].deviceId);
			newRow.find("td:eq(2)").attr("align", "left");
			$("#logListTb > tbody").append(newRow); 	// body 끝에 붙여넣기
		}
	} else {
		// 결과 목록이 없을 경우
		var emptyRow = "<tr><td colspan='3' align='center'>조회된 내용이 없습니다.</td></tr>";
		$("#logListTb > tbody").append(emptyRow);
	}
	
	// 페이징 조건 재설정 후 페이징 html 생성
	$("#SearchFrm").find("input[name='userNo']").val(data.search.userNo); // (선택한)상세
	//showPageHtml2(data, $("#paginateDiv2"), "goDeviceAccessList"); 
	//$("#detailDiv").show();
	
}
--%>
// 입력 값 검증
/* function validation(frm) {
	var result = false;
	
	return result;
} */

<%--  검색 결과 다운로드 --%>
function goDownloadDeviceUserAccessList(pageNum) {
	document.SearchFrm.pageNum.value = pageNum; // 이동할 페이지
	document.SearchFrm.action = 'deviceUserAccessListDownload.miaps?';
	document.SearchFrm.submit();
}

</script>
<!-- 탑 메뉴 -->
	<%-- <%@ include file="/WEB-INF/jsp/include/header.jsp" %> --%>
</head>

<body>
<%-- 사용자 접속현황 상세화면 다이얼로그 --%> 
<%@ include file="/WEB-INF/jsp/asvc/device/deviceUserAccessListDialog.jsp" %>
<!-- 사용자 상세정보 다이얼로그 -->
<%@ include file="/WEB-INF/jsp/include/searchUserDetailDialog.jsp" %>
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
					<option value="" ${search.searchApp == '' ? 'selected' : ''}><mink:message code="mink.web.text.full.packagename"/></option>
					<c:forEach var="searchApp" items="${search.packageNmList}">
						<option value="<c:out value="${searchApp.packageNm}"/>"><c:out value="${searchApp.appNm}"/></option>
					</c:forEach>
				</select>
			</span>
			<span>
				<select name="searchPlatform">
					<option value="" ${search.searchPlatform == '' ? 'selected' : ''}><mink:message code="mink.web.text.finalaccess.platform"/></option>
					<option value="${PLATFORM_ANDROID}">Android Phone</option>
					<option value="${PLATFORM_ANDROID_TBL}">Android Tablet</option>
					<option value="${PLATFORM_IOS}">iPhone</option>
					<option value="${PLATFORM_IOS_TBL}">iPad</option>
				</select>	
			</span>
			<span>
				<select name="searchKey">
					<option value="" ${search.searchKey == '' ? 'selected' : ''}><mink:message code="mink.web.text.finalaccess.platform"/></option>
					<option value="userNm" ${search.searchKey == 'userNm' ? 'selected' : ''}><mink:message code="mink.web.text.username"/></option>
					<option value="userId" ${search.searchKey == 'userId' ? 'selected' : ''}><mink:message code="mink.web.text.userid"/></option>
				</select>
				<input type="text" name="searchValue" value="<c:out value='${search.searchValue}'/>" size="20"/>
			</span>
			<select name="searchPageSize">
				<option value="10" ${search.searchPageSize == '10' ? 'selected' : ''}><mink:message code="mink.web.text.rows10"/></option>
				<option value="20" ${(search.searchPageSize == null || search.searchPageSize == '20') ? 'selected' : ''}><mink:message code="mink.web.text.rows20"/></option>
				<option value="50" ${search.searchPageSize == '50' ? 'selected' : ''}><mink:message code="mink.web.text.rows50"/></option>
				<option value="100" ${search.searchPageSize == '100' ? 'selected' : ''}><mink:message code="mink.web.text.rows100"/></option>
			</select>
			<span><button id="searchValueBtn" class='btn-dash' onclick="javascript:goList('1');"><mink:message code="mink.web.text.search"/></button></span>
			<span><button class='btn-dash' onclick="javascript:goDownloadDeviceUserAccessList('1');"><mink:message code="mink.web.text.downloadsearchresult"/></button></span>
		</div>
		<div id="miaps-content" style="margin-top: 20px;">
			<!-- 검색 hidden -->
			<input type="hidden" name="userNo" /><!-- 상세조회를 위한 key -->
			<input type="hidden" name="packageNm" /><!-- 상세조회를 위한 key -->
			<input type="hidden" name="pageNum" value="${search.currentPage}" /><!-- 현재 페이지 -->

			<!-- 목록 화면 -->
			<div id="listDiv">
				<table class="listTb" border="0" cellspacing="0" cellpadding="0" width="100%">
					<colgroup>
						<col width="30%" />
						<col width="30%" />
						<col width="10%" />
						<col width="20%" />
						<col width="10%" />
					</colgroup>
					<thead>
						<tr>
							<td><mink:message code="mink.web.text.username.id"/></td>
							<td><mink:message code="mink.web.text.full.packagename"/></td>
							<td><mink:message code="mink.web.text.finalaccess.platform"/></td>
							<td><mink:message code="mink.web.text.finalaccess.date"/></td>
							<td><mink:message code="mink.web.text.count.connection"/></td>
						</tr>
					</thead>
					<tbody id="listTbody">
						<c:forEach var="dto" items="${deviceUserAccessList}" varStatus="i">
						<tr id="listTr${dto.USER_NO}${fn:replace(dto.PACKAGE_NM, '.', '')}" onclick="javascript:goDetailList('${dto.USER_NO}','<c:out value='${dto.PACKAGE_NM}'/>','${fn:replace(dto.PACKAGE_NM, '.', '')}');">
							<td align="left">
								<a href="javascript: void(0);" onclick="showSearchUserDetailDialog('${dto.USER_NO}')">
									<c:if test="${!empty dto.USER_NM}"><c:out value='${dto.USER_NM}'/>(<c:out value='${dto.USER_ID}'/>)</c:if>
									<c:if test="${empty dto.USER_NM}"><c:out value='${dto.USER_ID}'/></c:if>
								</a>
							</td>
							<td align="left">
								<c:set var="dtoAppNm" value="${dto.PACKAGE_NM}" />
								<c:forEach var="searchApp2" items="${search.packageNmList}">
									<c:if test="${searchApp2.packageNm == dto.PACKAGE_NM}">
										<c:set var="dtoAppNm" value="${searchApp2.appNm}" />
									</c:if>
								</c:forEach>
								<c:out value='${dtoAppNm}'/>
							</td>
							<td>
								<c:choose>
									<c:when test="${dto.PLATFORM_CD==PLATFORM_ANDROID}">Android Phone</c:when>
									<c:when test="${dto.PLATFORM_CD==PLATFORM_ANDROID_TBL}">Android Tablet</c:when>
									<c:when test="${dto.PLATFORM_CD==PLATFORM_IOS}">iPhone</c:when>
									<c:when test="${dto.PLATFORM_CD==PLATFORM_IOS_TBL}">iPad</c:when>
									<c:when test="${dto.PLATFORM_CD==PLATFORM_WEB}">Web</c:when>
									<c:otherwise>${dto.PLATFORM_CD}</c:otherwise>
								</c:choose>
							</td>
							<td>${dto.LOG_TM}</td>
							<td>${dto.ACCESS_CNT}</td>	
						</tr>
						</c:forEach>
					</tbody>
					<tfoot id="listEmpty">
						<c:if test="${empty deviceUserAccessList}">
						<tr >
							<td colspan="5"><mink:message code="mink.web.text.noexist.result"/></td>
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
