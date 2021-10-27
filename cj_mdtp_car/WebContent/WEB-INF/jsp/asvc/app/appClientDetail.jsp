<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="org.springframework.web.bind.annotation.SessionAttributes"%>
<%@ page import="com.thinkm.mink.commons.util.MinkConfig" %>
<%
	/*
	 * 앱 클라이언트 관리 화면
	 *
	 * @author juni
	 * @since 2014.03.24
	 * @modify chlee, 2015.09.17
	 */
%>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no" />
<%@ include file="/WEB-INF/jsp/include/wsACommonAppInclude.jsp" %>
<%@ include file="/WEB-INF/jsp/include/wsACommonAppHeadScript.jsp" %>
<link rel="stylesheet" href="${contextPath}/css/layout.appcenter.css" />

<!-- jindo -->
<script src="${contextPath}/js/jindo/jindo.desktop.ns.min.js" type="text/javascript" charset="utf-8"></script>
<script src="${contextPath}/js/jindo/jindo_mobile_component.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript">

//스크롤 내릴경우 목록 더보기 효과
var bool_sw = true;
$(document).ready(function(){
	init();

	// 로딩중 숨김
	$('#lastPostsLoader').hide();
	// 스크롤 더보기 효과
	$(window).scroll(function(){
		if(bool_sw){
			if ($(window).scrollTop() == $(document).height() - $(window).height()-1){
				bool_sw = false;
				goEvalList();
			}
		}
	});

	// 앱 최신버전의 평가 정보가 없을 경우 평가버튼 보임
	if(eval('${!empty app.version.evaluation.evalPoint}')) {
		$('#pointCheck').hide();
		$('#point').show();
	} else {
		$('#pointCheck').show();
		$('#point').hide();
	}

	if ("${fn:length(subApp)}" == "0") {
		$("#subAppTitle").hide();
		$("#subAppView").hide();
	} else {
		var oScroll = new jindo.m.Scroll("subAppView", {
		    bUseHScroll: true,
			bUseVScroll: false,
			bUseMomentum: true,
			nDeceleration: 0.0005,
			nHeight: 120,
		});
	}

	<%-- wsACommonAppHeadScript에서 설정한 정보가 안드로이드일 경우 로그인시 선택 한 값으로 설정을 해야 해서 여기서 바꾼다. --%>
	if(navigator.userAgent.match(/Android/i)) {
		$("input[name='platformCd']").val("${search.platformCd}");
	}

	goEvalList();
});

/**
 * **Download Button 비활성화 함수**
 * - 다운로드 버튼 클릭 시 한 번의 클릭만 허용할 수 있도록 한다.
 * - 모바일 기기에서 다운로드가 완료되었는지 판단하는 것이 힘들기 때문에 5초후 활성화가 풀리도록 한다.
 * @param {string} p_target 다운로드 버튼의 id를 넣는다.
 */
function loadingFreeze(p_target) {
  var target = $('#' + p_target)
  console.log(target.text())
  target.attr('disabled', true)
  target.text('다운중..')

  setTimeout(function () {
    target.attr('disabled', false)
    target.text('다운로드')
  }, 5000)
}

// 앱 평가 등록
function goInsertEval() {
	if( $("input[name='evalDesc']").val() == "" ) {
		alert("평가 설명을 적어주세요.");
		$("input[name='evalDesc']").focus();
		return;
	} else{
		var tmpEvalDesc = $("#searchFrm").find("input[name='evalDesc']").val();
		//console.log(tmpEvalDesc);
		tmpEvalDesc = tmpEvalDesc.replace(/</i, "&lt;");
		tmpEvalDesc = tmpEvalDesc.replace(/>/i, "&gt;");
		//console.log(tmpEvalDesc);
		$("#searchFrm").find("input[name='evalDesc']").val(tmpEvalDesc);

		ajaxComm('appEvaluationInsert.miaps', $(searchFrm), function(data){
			fnEvaluationMapping(data.evaluation);

		});
	}
}

//ajax
function ajaxComm(url, frm, fnCallback) {
	$.post(url, $(frm).serialize(), fnCallback, 'json');
}

// 앱 평가 정보 셋팅
function fnEvaluationMapping(evaluation) {
	//htmlEscapeAll(document); // 특수문자 전체 변환

	$("#point").show();			// 입력되있는 포인트 출력 부분
	$("#pointCheck").hide();	// 포인트 작성하는 부분 숨김
	$("#evalPointStarView").hide();	// 포인트 화면 셋팅 숨기고 span에 결과 출력

	$("#evalUserNm").html(evaluation.userNm);
	var str = "";
	for( var j=1; j<=evaluation.evalPoint; j++ ) {
		str += "★";
	}
	for( var j=1; j<=(5-evaluation.evalPoint); j++ ) {
		str += "☆";
	}
	$("#evalPointStar").html(str);



	$("#evalDescSpan").html(evaluation.evalDesc);

	goEvalList();
}

// 앱평가 목록 조회
function goEvalList() {
	$('#lastPostsLoader').show();
	var out = [];
	$.post('appEvaluationListView.miaps?', $(searchFrm).serialize(), function(data) {
		//console.log(data);
    	if( data != null && data.evalLIst.length > 0 ) {

    		var str = "";
    		for(var i = 0; i < data.evalLIst.length; i++) {
    			var dto = data.evalLIst[i];
    			str = dto.userNm +"&nbsp;&nbsp;&nbsp;";
				for( var j=1; j<=dto.evalPoint; j++ ) {
					str += "★";
				}
				for( var j=1; j<=(5-dto.evalPoint); j++ ) {
					str += "☆";
				}
				str = str + "<br/>" + dto.evalDt + "&nbsp;&nbsp;&nbsp;&nbsp;Ver.&nbsp;" + dto.versionNm;
				str += "<br/>"+ dto.evalDesc;
    			out.push('<li>' + str + '</li>');
    		}
    		$('#searchFrm').find("input[name='startRow']").val(data.search.endRow);
    		$('#listUl').append(out.join('')).listview('refresh');
			setTimeout(function(){bool_sw = true;},0);
    	} else {
			bool_sw = false;
		}
    	$('#lastPostsLoader').hide();
    }, 'json');

}

// 파일다운로드
function fileDown(fileGubun) {
	loadingFreeze("btn-down")
	var frm = $("#searchFrm");

	// 변수 셋팅
	//var userNo = frm.find("input[name='userNo']").val();
	var appId = frm.find("input[name='appId']").val();
	var versionNo = frm.find("input[name='versionNo']").val();
	var downUserNo = frm.find("input[name='downUserNo']").val();
	var deviceId = frm.find("input[name='deviceId']").val();
	var platformCd = frm.find("input[name='platformCd']").val();
	var url = "appFileDown.miaps?filegubun="+fileGubun+"&appId="+appId+"&versionNo="+versionNo+"&downUserNo="+downUserNo+"&deviceId="+deviceId+"&platformCd="+platformCd;

	// 'LG-G pro'단말의 기본 브라우져에서 appFileDown.miaps 파일명으로 다운로드되는 이슈 대응
	//if ( navigator.userAgent.indexOf("Mozilla/5.0 (Linux; U; Android 4.4.2; ko-kr; LG-F240L", 0) === 0 ) {
	if (/LG-F240/i.test(navigator.userAgent)) {
		url += "&resetContentDisposition=Y";
		$("#searchFrm").find("input[name='resetContentDisposition']").val("Y");
	}

	/*
	 * 앱 다운로드 URL을 환경설정으로 지정하여 외부의 장소를 설정하도록 함.
	 * - mingun.park@gmail.com (2015/05/08)
	 */
	var apkUrl = "<%= MinkConfig.getConfig().get("mink.server.url.appdown.android", "") %>".trim();
	if (fileGubun == "appFile" && apkUrl != "") {
		apkUrl = apkUrl.replace(/[$]\{userNo\}/gi, downUserNo);
		apkUrl = apkUrl.replace(/[$]\{deviceId\}/gi, deviceId);
		apkUrl = apkUrl.replace(/[$]\{appId\}/gi, appId);
		apkUrl = apkUrl.replace(/[$]\{versionNo\}/gi, versionNo);
		alert(apkUrl);
		document.location.href = url;
		return;
	}

	// post방식으로 설정 후 get방식으로 변수 넘김 -> 안드로이드 2번호출되는 이유때문
	<%-- 2015.08.04 chlee
		안드로이드는 모두 이 방식으로 호출 해도 문제 없다고 생각 합니다. 개발 서버에서 조건문 없이 무조건 location.href로 호출 하도록 했는데
		안드로이드 버전 2.x, 4.x (3.x는 없어서 못했습니다) 모두 정상 다운로드 되었습니다.
		그래서 일단 이전 4.4 이상으로 되어 있던 부분을 4.x 이상으로 수정 했습니다.
		4.1.2, 4.2.2 에서 예전 조건에 걸리지 않아서 post방식 무시하고 안드로이드 앱 다운로드 매니저가 호출 하도록 해서
		다운로드 받으면 파일명이 appFileDown.miaps로 되며 실행 되는 폰이 있는가 하면 실행되지 않는 폰이 있었습니다.
		추후 테스트를 더 하여 이 부분을 "Android이면 모두 document.location.href를 변경하도록" 하는 것이 좋을 것 같습니다.
		아래의 조건문에 사용한 javascript 정규식은 아래의 사이트를 참조해서 작성하세요
		http://www.nextree.co.kr/p4327/
	 --%>
<%--	if (/SM-G900/i.test(navigator.userAgent) // 갤럭시S5 (SM-G900, SM-G900S SKT, SM-G900K KT, SM-G900L LGT)
			|| /Android\s[4-9]/i.test(navigator.userAgent) // Android 4.x 이상
			|| /Android\s[5-9]/i.test(navigator.userAgent) // Android 5.x Lollipop 이상
		) {
		// 한 번만 호출하도록 함. (4.4.2에서 테스트 결과 두번 호출됨.아래의 post로 호출하면 두번호출을 안해서 다운로드 안됨.)
		document.location.href = url;
		return;
	}
--%>
	document.location.href = url;

//	document.fileFrm.method = "post";
//	document.fileFrm.action = url;
//	document.fileFrm.submit();
}

function fileDownSubApp(count) {
	loadingFreeze("btn-down")
	var frm = $("#searchFrm");

	// 변수 셋팅
	var subAppId = frm.find("input[name='subAppId"+ count +"']").val();
	var subVersionNo = frm.find("input[name='subAppVer"+ count +"']").val();
	var downUserNo = frm.find("input[name='downUserNo']").val();
	var deviceId = frm.find("input[name='deviceId']").val();
	var platformCd = frm.find("input[name='platformCd']").val();
	var url = "appFileDown.miaps?filegubun=appFile&appId="+subAppId+"&versionNo="+subVersionNo+"&downUserNo="+downUserNo+"&deviceId="+deviceId+"&platformCd="+platformCd;

	// 'LG-G pro'단말의 기본 브라우져에서 appFileDown.miaps 파일명으로 다운로드되는 이슈 대응
	//if ( navigator.userAgent.indexOf("Mozilla/5.0 (Linux; U; Android 4.4.2; ko-kr; LG-F240L", 0) === 0 ) {
	if (/LG-F240/i.test(navigator.userAgent)) {
		url += "&resetContentDisposition=Y";
		$("#searchFrm").find("input[name='resetContentDisposition']").val("Y");
	}

	document.location.href = url;

	var subAppTotal = Number("${fn:length(subApp)}") - 1;
	if (count < subAppTotal) {
		count++;
		setTimeout("fileDownSubApp("+ count +")", 1000);
	}
}

// IOS 파일다운로드 요청
function fileDownUrlReq(platformCd) {
	loadingFreeze("btn-down")
	document.searchFrm.platformCd.value = platformCd;
	document.searchFrm.method = "post";
	document.searchFrm.action = "appFileDownUrlReq.miaps?";
	document.searchFrm.submit();
}

<%-- 2019.09.17 chlee, WEB일 경우 새 창에서 URL열기  --%>
function openUrl(appUrl) {
	window.open(appUrl, '_blank');
}
</script>
</head>
<body>
<!-- 본문 -->
<div class="appcenter-header"><mink:message code='mink.label.app_detail_and_down'/></div>
<div id="appcenter-main-content" class="appcenter-detail-def-text">
	<form id="searchFrm" name="searchFrm" method="get" onSubmit="return false;">
		<input type="hidden" name="userNo" value="${loginUser.userNo}"/>	<!-- 로그인한 사용자 -->
		<input type="hidden" name="appId" value="${app.appId}"/>	<!-- key -->
		<input type="hidden" name="pageNum" value="${search.currentPage}" /><!-- 현재 페이지 -->
		<input type="hidden" name="gubun" value="${search.gubun}" /><!-- 탭 구분값 -->
		<input type="hidden" name="versionNo" value="${app.versionNo}" /><!-- 최신버전번호 -->
		<input type="hidden" name="downUserNo" value="${loginUser.userNo}" /><!-- 파일다운로드 등록 정보 -->
		<input type="hidden" name="deviceId" value="" /><!-- 파일다운로드 등록 정보 -->
		<input type="hidden" name="startRow" value="0" />
		<input type="hidden" name="userNm" value="${loginUser.userNm}"/>
		<input type="hidden" name="filegubun" value=""/>
		<input type="hidden" name="platformCd" value="${search.platformCd}" />
		<input type="hidden" name="resetContentDisposition" />
		<input type="hidden" name="addList" value=""/>
		<input type="hidden" name="searchKey" value="" />
		<input type="hidden" name="searchValue" value="" />

		<div id="appDetailTop">
			<c:if test='${null ne app.bigIconNm && !empty app.bigIconNm}'>
				<div style='float:left; margin-top: 5px; background-image:url("${app.bigIconNm}");' class='appcenter-app-block-image'></div>
			</c:if>
			<c:if test='${null eq app.bigIconNm || empty app.bigIconNm}'>
				<div style='float:left; margin-top: 5px;' class='appcenter-app-block-image'></div>
			</c:if>
			<div class="appcenter-app-block-text-list"><c:out value='${app.appNm}'/><br/>${app.updDt}<br/><c:out value='${app.supplierNm}'/></div>
			<div style="text-align: right">
			<c:choose>
				<c:when test="${!empty app.versionNo}">
					<c:if test="${app.platformCd == PLATFORM_ANDROID || app.platformCd == PLATFORM_ANDROID_TBL}" >
						<c:choose>	
							<c:when test="${!empty app.appUrl}" >
								<button id="btn-down" class='btn-dash' onclick="javascript:openUrl('${app.appUrl}');">OPEN</button>
							</c:when>
							<c:when test="${empty app.appUrl}" >			
								<c:if test="${fn:length(subApp) > 0}">
									<button id="btn-down" class='btn-dash' onclick="javascript:fileDownSubApp(0);"><mink:message code='mink.label.download'/></button>
								</c:if>
								<c:if test="${fn:length(subApp) == 0}">
									<button id="btn-down" class='btn-dash' onclick="javascript:fileDown('appFile');"><mink:message code='mink.label.download'/></button>
								</c:if>
							</c:when>
						</c:choose>
					</c:if>
					<c:if test="${app.platformCd == PLATFORM_IOS || app.platformCd == PLATFORM_IOS_TBL}" >
						<c:if test="${empty app.appUrl}" >
							<button id="btn-down" class='btn-dash' onclick="javascript:fileDownUrlReq('${app.platformCd}');"><mink:message code='mink.label.download'/></button>
						</c:if>
						<c:if test="${!empty app.appUrl}" >
							<button id="btn-down" class='btn-dash' onclick="javascript:openUrl('${app.appUrl}');">OPEN</button>
						</c:if>
					</c:if>
					<%-- 2019.09.17 chlee, Web일경우 바로가기 버튼 표시 --%>
					<c:if test="${app.platformCd == PLATFORM_WEB}" >
						<button id="btn-down" class='btn-dash' onclick="javascript:openUrl('${app.appUrl}');">OPEN</button>
					</c:if>
				</c:when>
				<c:when test="${empty app.versionNo}">
					<c:if test="${!empty app.appUrl}" >
						<button id="btn-down" class='btn-dash' onclick="javascript:openUrl('${app.appUrl}');">OPEN</button>
					</c:if>
				</c:when>
			</c:choose>
			</div>
			<div style="clear:both;"></div>
		</div>

		<%-- 종속앱 리스트 --%>
		<div id="subAppTitle" style="margin: 5px 0 0 0;"><mink:message code='mink.label.app_bundle_msg1'/>${fn:length(subApp)}<mink:message code='mink.label.app_bundle_msg2'/></div>
		<div id="subAppView" class="appcenter-app-block-in-main-content">
			<div style="width: 640px; height: 100%;">
				<ul id="subAppList" style="list-style:none;">
				<c:forEach var="dto" items="${subApp}" varStatus="i">
					<li class='appcenter-sub-app-block'>
						<input type="hidden" name="subAppId${i.index}" value="${dto.appId}" />
						<input type="hidden" name="subAppVer${i.index}" value="${dto.versionNo}" />
						<a style='text-decoration: none;' href="javascript:goDetail('${dto.appId}')">
						<c:if test='${dto.smallIconNm ne null && dto.smallIconNm ne ""}'>
							<div style="background-image:url('<c:out value='${app.smallIconNm}'/>')" class='appcenter-sub-app-block-image'></div>
						</c:if>
						<c:if test='${dto.smallIconNm eq null || dto.smallIconNm eq ""}'>
							<div class='appcenter-sub-app-block-image'></div>
						</c:if>
						<div class='appcenter-sub-app-block-text' style="font-size: 10px;"><c:out value='${app.appNm}'/></div>
					</a></li>
				</c:forEach>
				</ul>
			</div>
		</div>

		<div class="appcenter-main-title"><mink:message code='mink.label.explanation'/></div>
		<div style="margin-top: 10px; border-bottom: 1px solid #bcbcbc; padding-bottom: 10px;"><c:out value='${app.version.versionDesc}'/></div>

		<div class="appcenter-main-title">정보</div>
		<div style="margin-top: 10px; border-bottom: 1px solid #bcbcbc; padding-bottom: 10px;">
			<table class="appcenter-detail-info-table" border="0" cellspacing="0" cellpadding="0">
				<tr height="30px">
					<td><mink:message code='mink.label.version'/></td>
					<td><c:out value='${app.version.versionNm}'/></td>
				</tr>
				<tr height="30px">
					<td><mink:message code='mink.label.first_reg_date'/></td>
					<td>${app.regDt}</td>
				</tr>
				<tr height="30px">
					<td><mink:message code='mink.label.update_date'/></td>
					<td>${app.version.updDt ? app.version.updDt : app.version.regDt}</td>
				</tr>
				<tr height="30px">
					<td><mink:message code='mink.web.text.register'/></td>
					<td>${app.regNm}</td>
				</tr>
				<tr height="30px">
					<td><mink:message code='mink.label.manager_email'/></td>
					<td><c:out value='${app.emailAddr}'/></td>
				</tr>
				<tr height="30px">
					<td><mink:message code='mink.label.manager_tel'/></td>
					<td><c:out value='${app.phoneNo}'/></td>
				</tr>
			</table>
		</div>

		<c:if test="${!empty app.version}">
			<div class="appcenter-main-title"><mink:message code='mink.label.app_evaluation'/></div>
			<c:set var="fullStar" value="★ " />
			<c:set var="emptyStar" value="☆ " />

				<!-- 평점내용이 없는 경우 -->
				<div id="pointCheck" class="appcenter-detail-evaluation-text">
					<br/><mink:message code='mink.label.app_eval_score'/> <br/>
					<c:forEach var="i" begin="1" end="5" varStatus="status">
						<input type="radio" name="evalPoint" value="${i}" ${app.version.evaluation.evalPoint == i ? 'checked="checked"' : ''}/>${i}
					</c:forEach>

					<%--
					<select name="evalPoint" data-native-menu="false">
						<c:forEach var="i" begin="0" end="5" varStatus="status">
							<option value="${i}" ${app.version.evaluation.evalPoint == i ? 'selected' : ''}>${i}</option>
						</c:forEach>
					</select>
					 --%>
					<br/>
					<br/><mink:message code='mink.label.app_eval_desc'/><br/><input type="text" id="evalDesc" name="evalDesc" value="" onkeypress="if(event.keyCode == 13) return false;">
					<div align="center" style="margin: 10px 0 0 0;">
						<button class='btn-dash' onclick="javascript:goInsertEval()"><mink:message code='mink.label.app_evaluation'/></button>
					</div>
				</div>

				<!-- 평점내용이 있는 경우 -->
				<div id="point" class="appcenter-detail-evaluation-text">
					<br/><span id="evalUserNm">${app.version.evaluation.userNm}</span>
					<br/><mink:message code='mink.label.app_eval_score'/>
					<span id="evalPointStarView" style="padding-left: 10px;">
						<c:forEach var="i" begin="1" end="${app.version.evaluation.evalPoint}" varStatus="status">
							${fullStar}
						</c:forEach>
						<c:forEach var="i" begin="1" end="${5-app.version.evaluation.evalPoint}" varStatus="status">
							${emptyStar}
						</c:forEach>
					</span>
					<span id="evalPointStar" style="padding-left: 10px; color: #888;"></span>
					<br/><mink:message code='mink.label.app_eval_desc'/><span id="evalDescSpan" style="padding-left: 10px; color: #888;"><c:out value="${app.version.evaluation.evalDesc}"/></span>
				</div>
			 	<ul id="listUl"></ul>
   		</c:if>
   	</form>
   	<form id="fileFrm" name="fileFrm" onsubmit="javascript: alert(this.action);">
	</form>
   	<div style="height: 55px;">&nbsp;</div>
</div>
<%@ include file="/WEB-INF/jsp/asvc/app/appClientMenuBar.jsp" %>
</body>
</html>
