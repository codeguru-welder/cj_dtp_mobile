<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="org.springframework.web.bind.annotation.SessionAttributes"%>
<%@ page import="com.thinkm.mink.commons.util.MinkConfig" %>
<%
	/*
	 * 앱 클라이언트 관리 화면
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

<!-- bxSlider CSS file -->
<link href="${contextPath}/js/bxslider/jquery.bxslider.css" rel="stylesheet" />

<!-- bxSlider Javascript file -->
<script src="${contextPath}/js/bxslider/jquery.bxslider.min.js"></script>

<!-- jindo -->
<script src="${contextPath}/js/jindo/jindo.desktop.ns.min.js" type="text/javascript" charset="utf-8"></script>
<script src="${contextPath}/js/jindo/jindo_mobile_component.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript">

//스크롤 내릴경우 목록 더보기 효과
var bool_sw = true;
$(function() {
	init();
	 
	var oScroll = new jindo.m.Scroll("newView", {
	    bUseHScroll: true,
		bUseVScroll: false,
		bUseMomentum: true,
		nDeceleration: 0.0005,
		nHeight: 160,
	});
	
	var oScroll = new jindo.m.Scroll("allView", {
	    bUseHScroll: true,
		bUseVScroll: false,
		bUseMomentum: true,
		nDeceleration: 0.0005,
		nHeight: 160,
	});
	
	var oScroll = new jindo.m.Scroll("myView", {
	    bUseHScroll: true,
		bUseVScroll: false,
		bUseMomentum: true,
		nDeceleration: 0.0005,
		nHeight: 160,
	});
	
	$('#bxslider').bxSlider({
		slideMargin: 0,
		captions: true,
		pager: false,
		controls: false,
		auto: true
	});
	
	<%-- wsACommonAppHeadScript에서 설정한 정보가 안드로이드일 경우 로그인시 선택 한 값으로 설정을 해야 해서 여기서 바꾼다. --%>
	if(navigator.userAgent.match(/Android/i)) {
		$("input[name='platformCd']").val("${search.platformCd}");
	}
	
	$("#searchFrm").find("input[name='gubun']").val("new");
	goAppClientList();	
});

function goAppClientList() {
	var gubun = $("#searchFrm").find("input[name='gubun']").val();
	var grpId = $("#searchFrm").find("input[name='grpId']").val();
	var platformCd = $("#searchFrm").find("input[name='platformCd']").val();
	var downUserNo = $("#searchFrm").find("input[name='downUserNo']").val();
	
	console.log("gubun:" + gubun + ", plat:" + platformCd + ", downNo:" + downUserNo + ", grpId:" + grpId);
	
	$.post('appClientListView.miaps?', {"gubun": gubun, "downUserNo":downUserNo, "platformCd": platformCd, "addList": "main", "grpId": grpId}, function(data){
		setAppClientList(data);
		
		if(gubun == "new") {
			$("#loadImgNewView").hide();
			$("#searchFrm").find("input[name='gubun']").val("my");
			setTimeout("goAppClientList()", 100);
		} else if (gubun == "my") {
			$("#loadImgMyView").hide();
			$("#searchFrm").find("input[name='gubun']").val("");
			setTimeout("goAppClientList()", 100);
		} else {
			$("#loadImgAllView").hide();
		}
	}, 'json');
}

String.prototype.escapeHtml = function() {
	return this.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');	
}

function setAppClientList(data) {

	console.log("data.search.gubun:"+data.search.gubun);
	var $targetId = "appItems";
	if (data.search.gubun == "new") {
		$targetId = $("#appItemsNew");
	}else if(data.search.gubun=="my") {
		$targetId = $("#appItemsMy");
	}else if(data.search.gubun == "") {
		$targetId = $("#appItemsAll");	
	}
	
	//console.log(data.appList.length);
	if (data != null && data.appList.length > 0) {
		var i = 0;
		for(i = 0; i < data.appList.length; i++) {
			var dto = data.appList[i];			
//			console.log(dto.bigIconNm);			
			var appBlock = "<li class='appcenter-app-block'>";
			appBlock = appBlock + "<a style='text-decoration: none;' href='javascript:goDetail("+ dto.appId +")'><div ";
			if (null != dto.bigIconNm && "" != dto.bigIconNm) {
				appBlock = appBlock + "style='background-image:url("+ dto.bigIconNm +")' ";
			}
			appBlock = appBlock + "class='appcenter-app-block-image'></div><div class='appcenter-app-block-text'>"+ dto.appNm.escapeHtml() +"</div></a></li>";
			
			$targetId.append(appBlock);
		}
		
		/* 마지막 데이터 보이지 않는 이슈로 삭제 -200414 윤다혜- 
		if (i < 4) {
			$targetId.parent().css("width", "100%");
		} else {
			var contentsWidth = Number(i) * 105;
			$targetId.parent().css("width", contentsWidth + "px");
		}
		*/
		
	} else {
		$targetId.parent().css("width", "100%");
		$targetId.append("<div class='appcenter-app-block-nodata'>앱이 없습니다.</div>");
	}
}

function search_clear() {
	$("#searchApp").css("background", "");
}

</script>
</head>
<body>
<div>
	<ul id="bxslider">
		<li><img src="${contextPath}/app/images/main_img_sample01.png" title="마이앱스 앱센터에 오신 것을 환영합니다!"/></li>
		<li><img src="${contextPath}/app/images/main_img_sample02.png" title="등록 된 여러 앱을 다운로드 받으세요!"/></li>
	</ul>
</div>
<div>
	<form id="searchFrm" name="searchFrm" >
	<input type="hidden" name="appId" /><!-- 상세 -->
	<input type="hidden" name="pageNum" value="${search.pageNum}" /><!-- 현재 페이지 -->
	<input type="hidden" name="gubun" value="${search.gubun}" /><!-- 탭 구분값 -->
	<input type="hidden" name="downUserNo" value="${loginUser.userNo}" /> <!-- 다운로드 받은 유저 -->
	<input type="hidden" name="grpId" value="${loginUser.userGroup.grpId}"/>
	<input type="hidden" name="loginUserNo" value="${loginUser.userNo}"/>
	<input type="hidden" name="addList" value="" />
	<input type="hidden" name="startRow" value="${search.endRow}" /><!-- 페이지 더보기 -->
	<input type="hidden" name="platformCd" value="<c:out value='${search.platformCd}'/>" />
	<input type="hidden" name="searchKey" value="" />
	<input type="hidden" name="searchValue" value="" />

	<div id="appcenter-main-content">
		<%--  Ext.App link START 
		<table style="width:100%; border:0;"><tr>
			<td class="appcenter-main-title">제목1</td>			
		</tr></table>	
		<div id="linkView" class="appcenter-app-block-in-main-content">
			<div style="width: 720px; height: 159px;">
				<ul style="list-style:none;">
					<li class="appcenter-app-block">
						<c:if test="${search.platformCd eq '2000012' || search.platformCd eq '2000022'}"> 
							<a style="text-decoration: none;" href="https://play.google.com/store/apps/details?id=com.kakao.talk&hl=ko">
								<div style="background-image:url(${contextURL}/app/images/kakaotalk.png)" class="appcenter-app-block-image"></div>
								<div class="appcenter-app-block-text" style="text-align: center;">앱명</div>
							</a> 
						</c:if>
						<c:if test="${search.platformCd eq '2000013' || search.platformCd eq '2000023'}">
							<a style="text-decoration: none;" href="https://apps.apple.com/kr/app/%EC%B9%B4%EC%B9%B4%EC%98%A4%ED%86%A1-kakaotalk/id362057947">
								<div style="background-image:url(${contextURL}/app/images/kakaotalk.png)" class="appcenter-app-block-image"></div>
								<div class="appcenter-app-block-text" style="text-align: center;">앱명</div>
							</a>		
						</c:if>						
					</li>
				</ul>
			</div>
		</div> --%>
		<%--  Ext.App link END --%>
				
		<table style="width:100%; border:0;"><tr>
			<td class="appcenter-main-title">신규 앱</td>
			<td class="appcenter-main-show-all"><a style="text-decoration: none;" href="javascript:goTabList('new');">전체보기&gt;</a></td>
		</tr></table>	
		<div id="newView" class="appcenter-app-block-in-main-content">
			<div style="width: 720px; height: 100%;">
				<div class="loading-img"><img id="loadImgNewView" src="${contextURL}/app/images/loading.gif"></div>
				<ul id="appItemsNew" style="list-style:none;">
				</ul>
			</div>
		</div>
		
		<table style="width:100%; border:0;"><tr>
			<td class="appcenter-main-title">전체 앱</td>
			<td class="appcenter-main-show-all"><a style="text-decoration: none;" href="javascript:goTabList('');">전체보기&gt;</a></td>
		</tr></table>
		<div id="allView" class="appcenter-app-block-in-main-content">
			<div style="width: 720px; height: 100%;">
				<div class="loading-img"><img id="loadImgAllView" src="${contextURL}/app/images/loading.gif"></div>
				<ul id="appItemsAll" style="list-style:none;">
				</ul>
			</div>
		</div>
		
		<table style="width:100%; border:0;"><tr>
			<td class="appcenter-main-title">내 앱</td>
			<td class="appcenter-main-show-all"><a style="text-decoration: none;" href="javascript:goTabList('my');">전체보기&gt;</a></td>
		</tr></table>		
		<div id="myView" class="appcenter-app-block-in-main-content">
			<div style="width: 720px; height: 100%;">
				<div class="loading-img"><img id="loadImgMyView" src="${contextURL}/app/images/loading.gif"></div>
				<ul id="appItemsMy" style="list-style:none;">
				</ul>
			</div>
		</div>
		<div style="height: 55px;">&nbsp;</div>		
	</div>
	</form>
	<button
		class="btn-dash"
		style="margin-bottom: 50px;width: 100%"
		onclick="location.href='/asvc/common/commonLogout.miaps?home=app'"
	>로그아웃</button>
</div>
<%@ include file="/WEB-INF/jsp/asvc/app/appClientMenuBar.jsp"%>
</body>
</html>
