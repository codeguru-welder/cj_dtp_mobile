<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="org.springframework.web.bind.annotation.SessionAttributes"%>
<%@ page import="com.thinkm.mink.commons.util.MinkConfig" %>
<%
	/*
	 * 앱 클라이언트 리스트 화면
	 * 
	 * @author chlee
	 * @since 2016.03.14
	 */
%>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no" />
<%@ include file="/WEB-INF/jsp/include/wsACommonAppInclude.jsp" %>
<%@ include file="/WEB-INF/jsp/include/wsACommonAppHeadScript.jsp" %>
<link rel="stylesheet" href="${contextPath}/css/layout.appcenter.css" />

<script type="text/javascript">
var paste_id = 0; 
$(document).ready(function(){
	init();
	
	// 로딩중 숨김
	$('#lastPostsLoader').hide();
	
	<%-- wsACommonAppHeadScript에서 설정한 정보가 안드로이드일 경우 로그인시 선택 한 값으로 설정을 해야 해서 여기서 바꾼다. --%>
	if(navigator.userAgent.match(/Android/i)) {
		$("input[name='platformCd']").val("${search.platformCd}");
	}
}); 

String.prototype.escapeHtml = function() {
	return this.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');	
}

// 목록검색
function goList() {
	var out = [];
	$.post('appClientListGubunView.miaps?', $(searchFrm).serialize(), function(data){
		if (data != null && data.appList.length > 0) {
			for(var i = 0; i < data.appList.length; i++) {
    			var dto = data.appList[i];
    			var appBlock = "<li ";
    			if (i == 0) {
    				paste_id++;
    				appBlock = appBlock + "id='sc"+ paste_id +"'";
    			}
    			appBlock = appBlock + " class='appcenter-app-block-list'>";
    			appBlock = appBlock + "<a style='text-decoration: none;' href='javascript:goDetail("+ dto.appId +")'><div style='float:left; ";
    			if (null != dto.smallIconNm && "" != dto.smallIconNm) {
    				appBlock = appBlock + "background-image:url("+ dto.smallIconNm +")";
    			}
    			appBlock = appBlock + "' class='appcenter-app-block-image-list'></div><div class='appcenter-app-block-text-list'>"+ dto.appNm.escapeHtml() +"<br/>" + dto.updDt;
    			if (null != dto.supplierNm && "" != dto.supplierNm) {
    				appBlock = appBlock + "<br/>" + dto.supplierNm.escapeHtml() +"</div></a></li>"; 
    			} else {
    				appBlock = appBlock + "</div></a></li>";
    			}
    			out.push(appBlock);
        	}
			
			<%-- li개수가 전체 수보다 작으면 더보기를 표시한다. --%>
			var liCnt = $("li").length + data.appList.length;
			if (data.search.count > liCnt) {
				out.push("<li id='more' class='appcenter-app-block-text-list-more'><a style='text-decoration: none;' href='javascript:goList();''><mink:message code='mink.label.view_more'/></a></li>");
			}
			
			$('#searchFrm').find("input[name='startRow']").val(data.search.endRow);
			$('#more').remove();				
			$('#listUl').append(out.join(''));//.listview('refresh');
			
			/* 붙여넣기 후 리스트 스크롤 */
			$('body,html').animate({scrollTop: $("#sc"+paste_id).offset().top}, 500);
		}
	});

}
</script>
</head>
<body>
<div class="appcenter-header" style="padding-left: 30px;">
	<c:if test="${search.gubun=='new'}"><mink:message code='mink.label.app_new'/></c:if>
	<c:if test="${search.gubun=='my'}"><mink:message code='mink.label.app_my'/></c:if>
	<c:if test="${search.gubun==''}"><mink:message code='mink.label.app_all'/></c:if>
	<span class='list-count'>${search.count}</span>
</div>
<div>
	<form id="searchFrm" name="searchFrm" method="get" onSubmit="return false;">
		<!-- 검색 hidden -->
		<input type="hidden" name="appId" /><!-- 상세 -->
		<input type="hidden" name="pageNum" value="${search.pageNum}" /><!-- 현재 페이지 -->
		<input type="hidden" name="gubun" value="${search.gubun}" /><!-- 탭 구분값 -->
		<input type="hidden" name="downUserNo" value="${loginUser.userNo}" /> <!-- 다운로드 받은 유저 -->
		<input type="hidden" name="grpId" value="${loginUser.userGroup.grpId}"/>
		<input type="hidden" name="loginUserNo" value="${loginUser.userNo}"/>
		<input type="hidden" name="addList" value="Y" />
		<input type="hidden" name="startRow" value="${search.endRow}" /><!-- 페이지 더보기 -->
		<input type="hidden" name="platformCd" value="${search.platformCd}" />
		<input type="hidden" name="searchKey" value="" />
		<input type="hidden" name="searchValue" value="" />
   
   		<div id="appcenter-main-content">
	   		<div class="appcenter-app-block-in-main-content" style="border:0;">
				<div>
					<ul id="listUl" style="list-style:none;">
						<c:forEach var="dto" items="${appList}" varStatus="i">
				            <li class='appcenter-app-block-list'>
				            	<a style='text-decoration: none;' href="javascript:goDetail('${dto.appId}')">
				            	<c:if test='${null ne dto.smallIconNm && !empty dto.smallIconNm}'>
									<div style='float:left; background-image:url("${dto.smallIconNm}")' class='appcenter-app-block-image-list'></div> 
								</c:if>
								<c:if test='${null eq dto.smallIconNm || empty dto.smallIconNm}'>
									<div style='float:left;' class='appcenter-app-block-image-list'></div>
								</c:if>
								<div class="appcenter-app-block-text-list"><c:out value='${dto.appNm}'/><br/>${dto.updDt}<br/><c:out value='${dto.supplierNm}'/></div>
								</a>
							</li>
						</c:forEach>
						<c:if test="${fn:length(appList) < search.count}">
							<li id="more" class='appcenter-app-block-text-list-more'><a style='text-decoration: none;' href="javascript:goList();"><mink:message code='mink.label.view_more'/></a></li>
						</c:if>
					</ul>
				</div>
			</div>
			<div style="height: 55px;">&nbsp;</div>
        </div>
		<img id="lastPostsLoader" src="${contextURL}/app/images/loading.gif">
	</form>
</div>
<%@ include file="/WEB-INF/jsp/asvc/app/appClientMenuBar.jsp" %>
</body>
</html>
