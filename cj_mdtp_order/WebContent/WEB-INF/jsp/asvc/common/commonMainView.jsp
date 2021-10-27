<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="org.springframework.web.bind.annotation.SessionAttributes"%>
<%@ page import="com.thinkm.mink.commons.util.MinkConfig" %>
<%
	/*
	 * 메인화면 (commonMainView.jsp)
	 * 앱 신청현황
	 * 최근 사용자 접속현황
	 * 앱 다운로드 현황
	 * 
	 * @author eunkyu
	 * @since 2014.02.12
	 */
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<%@ include file="/WEB-INF/jsp/include/wsACommonInclude.jsp" %>
<%@ include file="/WEB-INF/jsp/include/wsACommonHeadScript.jsp" %>
<title><mink:message code="mink.label.page_title"/></title>

<script type="text/javascript">
$(document).ready(function() {
	
	//init_accordion(0);
	init_accordion('home', null);

	/* 
	 * 
	 * 같은 값이 있는 열을 병합함
	 * 
	 * 사용법 : $('#테이블 ID').rowspan(0);
	 * 
	 */     
	$.fn.rowspan = function(colIdx, isStats) {       
		return this.each(function(){      
			var that;     
			$('tr', this).each(function(row) {      
				$('td:eq('+colIdx+')', this).filter(':visible').each(function(col) {
					
					if ($(this).html() == $(that).html()
						&& (!isStats 
								|| isStats && $(this).prev().html() == $(that).prev().html()
								)
						) {            
						rowspan = $(that).attr("rowspan") || 1;
						rowspan = Number(rowspan)+1;

						$(that).attr("rowspan",rowspan);
						$(that).css("background-color", "#ffffff"); // 홀수 css 적용
						
						// do your action for the colspan cell here            
						$(this).hide();
						
						//$(this).remove(); 
						// do your action for the old cell here
						
					} else {            
						that = this;         
					}          
					
					// set the that if not already set
					that = (that == null) ? this : that;      
				});     
			});    
		});  
	};
	
	$('#recentDeviceLogTb').rowspan (0);
	
	init();
});

// 앱 관리 상세조회로 이동
function goAppDetail(appId) {
	document.SearchFrm.appId.value = appId;
	document.SearchFrm.action = '../app/appListView.miaps?';
	document.SearchFrm.submit();
}

// 앱 관리 목록으로 이동
function goAppList() {
	location.href = '../app/appListView.miaps?type=GET';
}

<%-- 앱 다운로드 현황으로 이동 --%>
function goAppDownloadList() {
	location.href = '../app/appDownloadListView.miaps?type=GET';
}
</script>
</head>
<body>

<div id="miaps-container">
	<div id="miaps-header">
    	<%@ include file="/WEB-INF/jsp/include/header.jsp" %>
  	</div>
  	<div id="miaps-sidebar">
		<%@ include file="/WEB-INF/jsp/include/left.jsp" %>
	</div>
	<div id="miaps-content">
    	
    	<!-- 본문 -->
		<div class="bodyContent">
			<!-- <div class="searchDivFrm"> -->
			<div>
			
			<div> <%-- <div style="background-color: #e2e2e2;"> --%>
			
			<!-- 목록 화면 -->
			<form id="SearchFrm" name="SearchFrm" method="post" onSubmit="return false;">
				<input type="hidden" name="appId" /><!-- 상세 -->
				<input type="hidden" name="pageNum" value="1" /><!-- 현재 페이지 -->
				
				<div style="padding-top: 1px;">
					<h3>
						<span style="margin-left: 2%"><mink:message code="mink.web.text.status.appregist"/></span> <!-- 앱 등록현황 -->
						<span style="margin-right: 2%; float:right;"><font size="3"><a href="javascript:goAppList();"><img src="${contextURL}/asvc/images/btn_more.gif" width="40" height="9" border="0"/></a></font></span>
					</h3>
				</div>
				
				<div id="listDiv" style="padding: 0 2% 2% 2%;">
					<table class="listTb" border="0" cellspacing="0" cellpadding="0" width="99%">
						<colgroup>
							<col width="40%" />
							<col width="12%" />
							<col width="23%" />
							<col width="11%" />
							<col width="10%" />
							<col width="4%" />
						</colgroup>
						<thead>
							<tr>
								<td><mink:message code="mink.web.text.appname"/></td>
								<td><mink:message code="mink.text.regdate"/></td>
								<td><mink:message code="mink.web.text.apppackagename"/></td>
								<td><mink:message code="mink.text.platform"/></td>
								<td><mink:message code="mink.web.text.permission.appuse"/></td>
								<td>ID</td>
							</tr>
						</thead>
						<tbody id="appListTbody">
							<c:forEach var="dto" items="${appList}" varStatus="i">
							<tr onclick="goAppDetail('${dto.appId}');">
								<td align="left" style="padding: 5px;">
									<c:if test='${null ne dto.smallIconNm && !empty dto.smallIconNm}'>
										<div style='float:left; background-image:url("../app/appImage.miaps?appId=${dto.appId}&filenm=smallIcon")' class='applist-img-block'></div> 
									</c:if>
									<c:if test='${null eq dto.smallIconNm || empty dto.smallIconNm}'>
										<div style='float:left;' class='applist-img-block'></div>
									</c:if>
									<div style="display:table; height: 40px;"><p style="display:table-cell; vertical-align: middle;"><c:out value='${dto.appNm}'/></p></div>
								</td>
								<td>${dto.regDt}</td>
								<td align="left"><c:out value='${dto.packageNm}'/></td>
								<td>
									<c:choose>
										<c:when test="${dto.platformCd==PLATFORM_ANDROID}">Android Phone</c:when>
										<c:when test="${dto.platformCd==PLATFORM_ANDROID_TBL}">Android Tablet</c:when>
										<c:when test="${dto.platformCd==PLATFORM_IOS}">iPhone</c:when>
										<c:when test="${dto.platformCd==PLATFORM_IOS_TBL}">iPad</c:when>
										<c:when test="${dto.platformCd==PLATFORM_WEB}">Web</c:when>
										<c:otherwise>${dto.platformCd}</c:otherwise>
									</c:choose>
								</td>
								<td>
									<c:choose>
										<c:when test="${dto.publicYn=='Y'}"><mink:message code="mink.web.text.commonapp"/></c:when>
										<c:when test="${dto.publicYn=='N'}"><mink:message code="mink.web.text.permissionapp"/></c:when>
										<c:when test="${dto.publicYn=='P'}"><mink:message code="mink.web.text.nopublic"/></c:when>
										<c:otherwise>${dto.publicYn}</c:otherwise>
									</c:choose>
								</td>
								<td>${dto.appId}</td>
							</tr>
							</c:forEach>
						</tbody>
						<c:if test="${empty appList}">
						<tfoot>
							<tr >
								<td colspan="6"><mink:message code="mink.web.text.noexist.result"/></td>
							</tr>
						</tfoot>
						</c:if>
					</table>
				</div>
				</form>
			</div>
				
			<div class="mainLeftMenu">
				<div style="padding-top: 1px;">
					<h3>
						<span style="margin-left: 2%">
							<mink:message code="mink.web.status.access.recentdevice"/>
						</span>
					</h3>
				</div>
				<div style="padding: 0 0% 2% 3%;">
					<table class="read_listTb" border="0" cellspacing="0" cellpadding="0" width="96%">
						<colgroup>
							<col width="20%" />
							<col width="60%" />
							<col width="20%" />
						</colgroup>
						<thead>
							<tr>
								<th><mink:message code="mink.web.text.date"/></th>
								<th><mink:message code="mink.web.apppackagename"/></th>
								<th><mink:message code="mink.text.count.connection"/></th>
							</tr>
						</thead>
						<tbody id="recentDeviceLogTb">
							<c:forEach var="map" items="${userDeviceRecentList}" varStatus="i">
							<tr>
								<td>${map.RECENT_DT}</td>
								<td align="left"><c:out value='${map.PACKAGE_NM}'/></td>
								<td>${map.ACCENT_CNT}</td>
							</tr>
							</c:forEach>
						</tbody>
						<c:if test="${empty userDeviceRecentList}">
						<tfoot>
							<tr >
								<td colspan="3"><mink:message code="mink.web.text.noexist.result"/></td>
							</tr>
						</tfoot>
						</c:if>
					</table>
				</div>
			</div>
			
			<div class="mainRightMenu">
				<div style="padding-top: 1px;">
					<h3>
						<span style="margin-left: 2%"><mink:message code="mink.web.text.status.appdownload"/></span>
						<span style="margin-right: 2%; float:right;"><font size="3"><a href="javascript:goAppDownloadList();"><img src="${contextURL}/asvc/images/btn_more.gif" width="40" height="9" border="0"/></a></font></span>
					</h3>
				</div>
				<div style="padding: 0 0% 2% 3%;">
					<table class="read_listTb" border="0" cellspacing="0" cellpadding="0" width="96%">
						<colgroup>
							<col width="10%" />
							<col width="70%" />
							<col width="20%" />
						</colgroup>
						<thead>
							<tr>
								<th>NO</th>
								<th><mink:message code="mink.web.text.apppackagename"/></th>
								<th><mink:message code="mink.web.text.download"/></th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="dto" items="${appDownloadList}" varStatus="i">
							<tr>
								<td>${i.index + 1}</td>
								<td align="left"><c:out value='${dto.appNm}'/></td>
								<td>${dto.downloadCnt}</td>
							</tr>
							</c:forEach>
						</tbody>
						<c:if test="${empty appDownloadList}">
						<tfoot>
							<tr >
								<td colspan="3"><mink:message code="mink.web.text.noexist.result"/></td>
							</tr>
						</tfoot>
						</c:if>
					</table>
				</div>
			</div>
			
			</div>
			
		</div>
    </div>	
  	<div id="miaps-footer">
    	<%@ include file="/WEB-INF/jsp/include/footer.jsp" %>
  	</div>
</div>








<!-- footer -->
<%-- <div class="footerContent" >
	<%@ include file="/WEB-INF/jsp/include/footer.jsp" %>
</div> --%>

</body>
</html>
