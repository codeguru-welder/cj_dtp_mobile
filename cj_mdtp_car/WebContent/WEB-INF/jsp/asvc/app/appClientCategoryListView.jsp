<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="org.springframework.web.bind.annotation.SessionAttributes"%>
<%@ page import="com.thinkm.mink.commons.util.MinkConfig" %>
<%
	/*
	 * 앱 센터(웹) 카테고리 화면
	 * 
	 * @author juni
	 * @since 2014.03.31
	 * @modify 2016.03.22 chlee
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

// 목록검색
function goList() {
	var out = [];
	$.post('appCategoryListView.miaps?', $(searchFrm).serialize(), function(data) { 	
		if (data != null && data.categList.length > 0) {
			for(var i = 0; i < data.categList.length; i++) {
    			var dto = data.categList[i];
/*     			out.push('<li>' + "<a href=\"javascript:goDetail('"+dto.categId+"', '"+dto.categNm+"')\">"+dto.categNm+"<span class=\"ui-li-count\">"+dto.memberCnt+"</span></</a>" + '</li>'); */
    			var appBlock = "<li ";
    			if (i == 0) {
    				paste_id++;
    				appBlock = appBlock + "id='sc"+ paste_id +"'";
    			}
    			appBlock = appBlock + " class='appcenter-app-block-list-category'>";
    			
    			if (dto.memberCnt > 0) {
    				appBlock = appBlock + "<a style='text-decoration: none;' href='javascript:goCategoryMemberList('"+dto.categId+"', '"+dto.categNm+"')'>";
    			}
    			appBlock = appBlock + "<div style='float:left; background-image:url(../app/images/app_menu_category.png)' class='appcenter-app-block-image-list-category'></div>";
    			appBlock = appBlock + "<div class='appcenter-app-block-text-list-category'>"+ dto.categNm;
    			appBlock = appBlock + "<span class='category-count'>"+dto.memberCnt+"</span></div>";
    			
    			if (dto.memberCnt > 0) {
    				appBlock = appBlock + "</a>";
    			}
    			appBlock = appBlock + "</li>";
    			out.push(appBlock);
    		}
			<%-- li개수가 전체 수보다 작으면 더보기를 표시한다. --%>
			var liCnt = $("li").length + data.categList.length;
			if (data.search.count > liCnt) {
				out.push("<li id='more' class='appcenter-app-block-text-list-more'><a style='text-decoration: none;' href='javascript:goList();'><mink:message code='mink.label.view_more'/></a></li>");
			}
			
    		$('#searchFrm').find("input[name='startRow']").val(data.search.endRow);
    		$('#more').remove();
    		$('#listUl').append(out.join('')); //.listview('refresh');
    		
    		/* 붙여넣기 후 리스트 스크롤 */
			$('body,html').animate({scrollTop: $("#sc"+paste_id).offset().top}, 500);
		}
    }, 'json');

}

// 상세조회호출
function goCategoryMemberList(categId, categNm) {
	var frm = document.searchFrm;
	frm.categId.value = categId;
	frm.categNm.value = categNm;
	frm.addList.value = "";
	frm.startRow.value = 0;
	frm.action = 'appCategoryMemberListView.miaps?';
	frm.submit();
}
</script>

</head>
<body>
<body>
<div class="appcenter-header"><mink:message code='mink.label.category'/></div>
<div>
	<form id="searchFrm" name="searchFrm" method="get" onSubmit="return false;">
		<input type="hidden" name="appId" /><!-- 상세 -->
		<input type="hidden" name="pageNum" value="${search.pageNum}" /><!-- 현재 페이지 -->
		<input type="hidden" name="gubun" value="${search.gubun}" /><!-- 탭 구분값 -->
		<input type="hidden" name="downUserNo" value="${loginUser.userNo}" /> <!-- 다운로드 받은 유저 -->
		<input type="hidden" name="grpId" value="${loginUser.userGroup.grpId}"/>
		<input type="hidden" name="loginUserNo" value="${loginUser.userNo}"/>
		<input type="hidden" name="addList" value="Y" />
		<input type="hidden" name="startRow" value="${search.endRow}" /><!-- 페이지 더보기 -->
		<input type="hidden" name="categId" value=""/><!-- 상세 -->
		<input type="hidden" name="categNm" value=""/> <!-- 카테고리 title 정보 -->
		<input type="hidden" name="platformCd" value="${search.platformCd}" />
		<input type="hidden" name="searchKey" value="" />
		<input type="hidden" name="searchValue" value="" />
			
		<div id="appcenter-main-content" style="">
	   		<div class="appcenter-app-block-in-main-content" style="border:0;">
				<div>
					<ul id="listUl" style="list-style:none;">
						<c:forEach var="dto" items="${categList}" varStatus="i">
				            <li class='appcenter-app-block-list-category'>
				            	<c:if test="${dto.memberCnt > 0}">
				            		<a style="text-decoration: none;" href="javascript:goCategoryMemberList('${dto.categId}', '${dto.categNm}')">
				            	</c:if>
				    			<div style="float:left; background-image:url(../app/images/app_menu_category.png)" class='appcenter-app-block-image-list-category'></div>
				    			<div class='appcenter-app-block-text-list-category'>${dto.categNm}<span class='category-count'>${dto.memberCnt}</span></div>
				    			<c:if test="${dto.memberCnt > 0}">
				    				</a>
				    			</c:if>
							</li>
						</c:forEach>
						<c:if test="${fn:length(categList) < search.count}">
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
