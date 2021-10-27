<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="org.springframework.web.bind.annotation.SessionAttributes"%>
<%@ page import="com.thinkm.mink.commons.util.MinkConfig" %>
<%
	/*
	 * 앱 관리화면 - 목록 및 등록/수정/삭제 (appListView.jsp)
	 * 
	 * @author juni
	 * @since 2014.04.02
	 * 
	 * @modify chlee
	 * @2015.01~
	 * @2015.02~ 팝업으로 분리
	 */
%>
<% 
	String appRoleYn = MinkConfig.getConfig().get("miaps.app.role.yn");
	if (appRoleYn == null) {
		appRoleYn = "N";
	}
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
	init_accordion('app', '${loginUser.menuListString}');
	$("#topMenuTile").html("<mink:message code='mink.web.text.appmanage_appstatus'/>");
	
	init(); <%-- 이벤트 핸들러 세팅 --%>
	
	showList(); <%-- 목록 보이기 --%>
	showPageHtml(); <%-- 페이징 html 생성 --%>
	
	<%-- 앱 권한 탭 컨트롤 --%>
    $(".tab_content_appRole").hide();
    $(".tab_content_appRole:first").show();

    activeTab();

    <%--
    $("ul.tabs_appRole li").click(function () {
        $("ul.tabs_appRole li").removeClass("active").css("color", "#333");
        //$(this).addClass("active").css({"color": "darkred","font-weight": "bolder"});
        $(this).addClass("active").css("color", "#0459c1");
        $(".tab_content_appRole").hide()
        var activeTab = $(this).attr("rel");
        $("#" + activeTab).fadeIn()
    });
   	--%>

	<%-- 등록 및 수정 시 검색조건 셋팅 --%>
	$("input[name='searchKey']").val("<c:out value='${search.searchKey}'/>");
	$("input[name='searchValue']").val("<c:out value='${search.searchValue}'/>");

	<%--
	if(eval('${!empty app}')) { 
		var dto = eval("("+'${app}'+")");
		fnDetailProcess(dto);

if ("Y".equalsIgnoreCase(appRoleYn)) {		
		var roleGrpDto = eval("("+'${appRoleListRG}'+")");
		fnSetAppRole_RoleGroupList(roleGrpDto);
		var grpDto = eval("("+'${appRoleListUG}'+")");
		fnSetAppRole_GroupList(grpDto);
		var userDto = eval("("+'${appRoleListUN}'+")");
		fnSetAppRole_UserList(userDto);
		
		if (dto.publicYn == 'N') {
			$("#appRoleDiv").show();
		} else {
			$("#appRoleDiv").hide();
		}
}
		checkedTrCheckbox($("#listTr"+dto.appId)); // 선택한 tr 의 checkbox 에 체크선택/css 변경
	}
	--%>

	// $( document ).tooltip();  // jquery-ui default tooltip
	//$('.tooltip').tooltipster();	// tooltipster default 
	$('.tooltip').tooltipster({ 
		contentAsHTML: true,
		/*theme: 'tooltipster-punk',*/
		iconDesktop: true
	});	// tooltipster html
	
	// 디폴트 정렬조건 표시
	setOrderByUpDown('<c:out value="${search.ordColumnNm}"/>', '<c:out value="${search.ordAscDesc}"/>');

	if(eval('${!empty app}')) {
		try {
		<%-- var dto = eval("("+"${app}"+")"); --%>
		<%
		String _strJson = "";
		if (request.getAttribute("app") instanceof App) {
		%>
			<%-- var dto = eval("("+"${app}"+")"); --%>
			var dto = {"appId": ${app.id}};
		<%
		} else if (request.getAttribute("app") instanceof String) {
			_strJson = (String) request.getAttribute("app");
			if (_strJson != null && _strJson.length() > 0) {
				_strJson = _strJson.replace("/", "\\/");
			}%>
			var dto = <%=_strJson%>;
		<%}%>		
		goDetail(dto.appId);
		} catch (e) {
			// do nothing
		}
	}
});

<%-- 목록검색 --%>
function goList(pageNum) {
	<%-- XSS 방어 --%>
	var _searchVal = defenceXSS(document.SearchFrm.searchValue.value); 
	document.SearchFrm.searchValue.value = _searchVal;
	
	document.SearchFrm.pageNum.value = pageNum; <%-- 이동할 페이지 --%>
	document.SearchFrm.action = 'appListView.miaps?';
	document.SearchFrm.submit();
}

<%-- 상세조회호출(ajax) --%>
function goDetail(appId) {
	checkedTrCheckbox($("#listTr"+appId));	<%-- 선택된 row 색깔변경 --%>
	$("#detailFrm").find("input[name='appId']").val(appId); <%-- (선택한)상세 --%>
	ajaxComm('appDetail.miaps?', $('#detailFrm'), function(data){
		fnDetailProcess(data.app); <%-- 상세 ajax 세부작업 --%>
		// 종속 앱 여부 세팅
		setDependencyApp(data.app, data.mainappList, data.dependencyIdList);

<%if ("Y".equalsIgnoreCase(appRoleYn)) {%>		
		fnSetAppRole_RoleGroupList(data.appRoleListRG);
		fnSetAppRole_GroupList(data.appRoleListUG);
		fnSetAppRole_UserList(data.appRoleListUN);
		
		if (data.app.publicYn == 'N') {
			$("#appRoleLi1").show();
			$("#appRoleLi2").show();
		} else {
			$("#appRoleLi1").hide();
			$("#appRoleLi2").hide();
		}
<%}%>
	});

	//goToBottomPage("#app-detail", 800);
}

<%-- ajax 로 가져온 data 를 알맞은 위치에 삽입 --%>
function fnAjaxInfoMapping(result) {
	<%-- 상세화면 정보 출력 --%>
	var frm = $("#detailFrm");
	frm.find("input[name='appId']").val(result.appId);
	frm.find("input[name='appNm']").val(result.appNm);
	<%-- frm.find("input[name='appDesc']").val(result.appDesc); --%>
	frm.find("textarea[name='appDesc']").val(result.appDesc);
	frm.find("input[name='packageNm']").val(result.packageNm);
	frm.find("input[name='prePackageNm']").val(result.packageNm);
	frm.find("select[name='platformCd']").val(result.platformCd);
	frm.find("input:radio[name='publicYn'][value='" + result.publicYn + "']").prop('checked', true); <%-- //.attr("checked", "true"); --%>
	frm.find("input[name='extAppId']").val(result.extAppId);
	// appUrl에 파라메타를 붙일 수 있게 함 (20150724;)
//	frm.find("input[name='appUrl']").val(result.appUrl);
	var appUrl = result.appUrl;
	var idx = appUrl == null ? -1 : appUrl.lastIndexOf("%{param}");
	if (idx >= 0) {
		appUrl = appUrl.substring(0, idx - 1);
		frm.find(":input[name='webParamYn']").get(0).checked = true;
	} else {
		frm.find(":input[name='webParamYn']").get(0).checked = false;
	}
	// appUrl 데이터존재 할경우 등록 구분 항목(radio)에 checked 처리 // 2020.09 KMD
	if(appUrl == '' || appUrl == null )	{
		$("input:radio[name='modi_type']:radio[value='P']").prop('checked', true);
		activeTab();
	} else 	{
		$("input:radio[name='modi_type']:radio[value='W']").prop('checked', true);
		$("ul.tabs_appRole li:first").click();
		$("ul.tabs_appRole li").not("li.active").css({"text-decoration":"line-through","cursor":"default"});
		$("ul.tabs_appRole li").off();
	}
	frm.find("input[name='appUrl']").val(appUrl);

	if( result.smallIcon != null ) {
		<%-- var smallIconImg = "<img width=\"100\" height=\"100\" src=\"${contextPath}/asvc/app/appImage.miaps?appId="+defenceXSS(result.appId)+"&filenm=smallIcon\"/>"; --%>
		var smallIconImg = document.createElement("img");
		smallIconImg.setAttribute("width", "100");
		smallIconImg.setAttribute("height", "100");
		smallIconImg.setAttribute("src", "appImage.miaps?appId="+defenceXSS(result.appId)+"&filenm=smallIcon");
		
		frm.find("#smallIconImg").html(smallIconImg);
		frm.find("#smallIconNm").text(result.smallIconNm);
	} else {
		frm.find("#smallIconImg").html("");
		frm.find("#smallIconNm").text("");
	}
	if( result.bigIcon != null ) {
		<%-- var bigIconImg = "<img width=\"100\" height=\"100\" src=\"${contextPath}/asvc/app/appImage.miaps?appId="+defenceXSS(result.appId)+"&filenm=bigIcon\"/>"; --%>
		var bigIconImg = document.createElement("img");
		bigIconImg.setAttribute("width", "100");
		bigIconImg.setAttribute("height", "100");
		bigIconImg.setAttribute("src", "appImage.miaps?appId="+defenceXSS(result.appId)+"&filenm=bigIcon");
		
		frm.find("#bigIconImg").html(bigIconImg);
		frm.find("#bigIconNm").text(result.bigIconNm);
	} else {
		frm.find("#bigIconImg").html("");	
		frm.find("#bigIconNm").text("");
	}
	frm.find("input[name='androidActivity']").val(result.androidActivity);
	frm.find("input[name='mainappYn']").val(result.mainappYn);
	frm.find("input[name='mainappId']").val(result.mainappId);
	frm.find("input[name='supplierNm']").val(result.supplierNm);
	frm.find("select[name='regSt']").val(result.regSt);
	<%-- frm.find("input[name='launcherYn'][value=" + result.launcherYn + "]").attr("checked", "checked"); --%>
	frm.find("input[name='emailAddr']").val(result.emailAddr);
	frm.find("input[name='phoneNo']").val(result.phoneNo);
	frm.find("input[name='regNm']").val(result.regNm);
	frm.find("input[name='regDt']").val(result.regDt);

	var platformCd = nvl(result.platformCd);
	var androidPackage = nvl(result.androidPackage);
	var appScheme = nvl(result.appScheme);
	frm.find(":input[name='appScheme']").val(appScheme);

	$("#tr_modi_androidPackage").hide();
	$("#tr_modi_bundleId").hide();
	$("#tr_modi_appUrl").hide();
	if (platformCd == '${PLATFORM_ANDROID}' || platformCd == '${PLATFORM_ANDROID_TBL}') {
		frm.find(":input[name='androidPackage']").val(androidPackage);
		frm.find(":input[name='appScheme_android']").val(appScheme);
		// 2020.09 KMD 수정
		if(appUrl == '' || appUrl == null )	{
			$("#tr_modi_androidPackage").show();
		} else 	{
			$("#tr_modi_appUrl").show();
		}
		$("#tr_modi_cls").show();
		$("ul.tabs_appRole li").on("click");
	} else if (platformCd == '${PLATFORM_IOS}' || platformCd == '${PLATFORM_IOS_TBL}') {
		frm.find(":input[name='bundleId']").val(androidPackage);
		frm.find(":input[name='appScheme_ios']").val(appScheme);
		// 2020.09 KMD 수정
		if(appUrl == '' || appUrl == null )	{
			$("#tr_modi_bundleId").show();
		} else 	{
			$("#tr_modi_appUrl").show();
		}
		$("#tr_modi_cls").show();
		$("ul.tabs_appRole li").on("click");
	} else if (platformCd == '${PLATFORM_WEB}') {
		$("#tr_modi_appUrl").show();
		// 2020.09 KMD 추가
		$("#tr_modi_cls").hide();
		$("ul.tabs_appRole li").off("click");
	}

	<%-- 하위목록 key setting --%>
	$("#searchFrm2").find("input[name='appId']").val(result.appId);
	$("#searchFrm3").find("input[name='appId']").val(result.appId);
	$("#searchFrm3").find("input[name='packageNm']").val(result.packageNm);

	var installUrlEx = nvl(result.installUrlEx);
	frm.find("#installUrlEx").val(installUrlEx);

	<%-- 버전 목록 조회 --%>
	goVersionList("1");
	
	openAppModiDialog();
}

// 종속 앱 여부 세팅
function setDependencyApp(app, mainappList, dependencyIdList) {
	var appId = nvl(app.appId);
	$("#updateMainappYnFrm").find(":input[name='appId']").val(appId);
	var mainappId = nvl(app.mainappId);
	$("#updateMainappYnFrm").find(":input[name='mainappId']").val(mainappId);
	var mainappYn = nvl(app.mainappYn);
	$("#updateMainappYnFrm").find("input:radio[name='mainappYn'][value='" + mainappYn + "']").prop('checked', true);
	$("#updateMainappYnFrm").find(":input[name='preMainappYn']").val(mainappYn);
	// 
	$("#updateMainappYnFrm").find(":input[name='mainappId']").html('<option value=""><mink:message code="mink.web.text.unselected"/></option>');
	$("#updateMainappYnFrm").find(":input[name='dependencyId']").html('<option value=""><mink:message code="mink.web.text.unselected"/></option>');
	if (mainappList != null && mainappList.length > 0) {
		for (var i = 0; i < mainappList.length; i++) {
			var m = mainappList[i];
			var appId = m.app_id;
			var appNm = defenceXSS(m.app_nm);
			var option = "<option value=\"" + appId + "\">" + appNm + "(ID:" + appId + ")</option>";
			$("#updateMainappYnFrm").find(":input[name='mainappId']").append(option);
			$("#updateMainappYnFrm").find(":input[name='dependencyId']").append(option);
		}
	}
	$("#updateMainappYnFrm").find(":input[name='mainappId']").val(mainappId);
	$("#updateMainappYnFrm").find(":input[name='dependencyId']").val("");
	// 
	var dependencyIdEmptyTxt = $("#dependencyIdEmptySpan").text();
	$("#dependencyIdListSpan").html(dependencyIdEmptyTxt);
	if (mainappYn == "Y") {
		$("#updateMainappYnFrm").find(":input[name='mainappId']").prop('disabled', true);
		if (dependencyIdList != null && dependencyIdList.length > 0) {
			$("#dependencyIdListSpan").html("");
			for (var i = 0; i < dependencyIdList.length; i++) {
				var dId = dependencyIdList[i];
				var span = "<span id=\"dependencyId" + dId.appId + "\">";
				if (i > 0) span += "<br>";
				span += "- " + dId.appNm + "(ID:" + dId.appId + ") <button class=\"btn-mini\" onclick=\"javascript:deleteDependencyId('"+dId.appId+"');\"<mink:message code='mink.web.text.delete'/>";
				span += "</span>";
				$("#dependencyIdListSpan").append(span);
				//
				var dependencyIds = $("#updateMainappYnFrm").find(":input[name='dependencyIds']").val();
				dependencyIds += dId.appId + ",";
				$("#updateMainappYnFrm").find(":input[name='dependencyIds']").val(dependencyIds);
			}
		}
		$("#mainappYnSpan").hide();
		$("#dependencyIdListTr").show();
	} else {
		$("#updateMainappYnFrm").find(":input[name='mainappId']").prop('disabled', false);
		$("#mainappYnSpan").show();
		$("#dependencyIdListTr").hide();
	}
}

// 종속 앱 삭제(해당 앱을 대표앱으로 수정함)
function deleteDependencyId(appId) {
	if(confirm("<mink:message code='mink.web.alert.is.delete'/>")) {
		$.post('appMainappYnUpdate.miaps?', {appId: appId, mainappYn: 'Y'}, function(data){
			resultMsg(data.msg);
			if (data.appId != null) {
				var appId = $("#updateMainappYnFrm").find("input[name='appId']").val();
				$("#SearchFrm").find("input[name='appId']").val(appId);
				goList($("#SearchFrm").find("input[name='pageNum']").val());
			}
		}, 'json');
	}
}

function fnSetAppRole_RoleGroupList(data) {
	var resultList = data;
	
	$("#appRoleListTbRG > tbody > tr").remove();
	if( resultList.length > 0 ) {
		for(var i = 0; i < resultList.length; i++) {
			var newRow = $("#appRoleListTbRG > thead > tr").clone();
			newRow.children().html("");
			newRow.removeClass();
			newRow.find("td:eq(0)").html("<input type='checkbox' name='roleGrpIdList' value='"+ resultList[i].roleGrpId + "' />"); 
			newRow.find("td:eq(1)").html(resultList[i].roleGrpId); 
			newRow.find("td:eq(2)").html(defenceXSS(resultList[i].roleGrpNm));
			
			var subChkHtml = "<input type='checkbox' name='includeSubYn' value=''";
			if (resultList[i].includeSubYn == 'Y') {
				subChkHtml = subChkHtml + ' checked'
			}
			subChkHtml = subChkHtml + " onclick=\"updateMenuRole('" + defenceXSS(resultList[i].roleGrpNm) + "', 'RG', '" + resultList[i].roleGrpId + "', this);\" />";
			newRow.find("td:eq(3)").html(subChkHtml);
			//newRow.find("td:eq(2)").attr("align", "left");
			$("#appRoleListTbRG > tbody").append(newRow);
		}
	} else {
		var emptyRow = "<tr><td colspan='4' align='center'>" + "<mink:message code='mink.web.text.noexist.inquiry'/>" + "</td></tr>";
		$("#appRoleListTbRG > tbody").append(emptyRow);
	}
	<%-- 페이징 조건 재설정 후 페이징 html 생성 
	$("input[name='pageNum']").val(data.search.currentPage);
	showPageHtml2(data, $("#paginateDiv2"), "goVersionList");
	--%>
}

function fnSetAppRole_GroupList(data) {
	var resultList = data;
	
	$("#appRoleListTbUG > tbody > tr").remove();
	if( resultList.length > 0 ) {
		for(var i = 0; i < resultList.length; i++) {
			var newRow = $("#appRoleListTbUG > thead > tr").clone();
			newRow.children().html("");
			newRow.removeClass();
			newRow.find("td:eq(0)").html("<input type='checkbox' name='grpIdList' value='"+ resultList[i].grpId + "' onclick=\"checkedCheckboxInTr(event);\" />"); 
			newRow.find("td:eq(1)").attr("align", "left").html(defenceXSS(resultList[i].grpNm));
			newRow.find("td:eq(2)").html(resultList[i].grpId);
			
			var subChkHtml = "<input type='checkbox' name='includeSubYn' value=''";
			if (resultList[i].includeSubYn == 'Y') {
				subChkHtml = subChkHtml + ' checked'
			}
			subChkHtml = subChkHtml + " onclick=\"updateMenuRole('" + defenceXSS(resultList[i].grpNm) + "', 'UG', '" + resultList[i].grpId + "', this);\" />";
			newRow.find("td:eq(3)").html(subChkHtml);

			newRow.click(function(){
				clickTrCheckedCheckbox(this);
			});

			$("#appRoleListTbUG > tbody").append(newRow);
		}
	} else {
		var emptyRow = "<tr><td colspan='4' align='center'>" + "<mink:message code='mink.web.text.noexist.inquiry'/>" + "</td></tr>";
		$("#appRoleListTbUG > tbody").append(emptyRow);
	}
}

function fnSetAppRole_UserList(data) {
	var resultList = data;
	
	$("#appRoleListTbUN > tbody > tr").remove();
	if( resultList.length > 0 ) {
		for(var i = 0; i < resultList.length; i++) {
			var newRow = $("#appRoleListTbUN > thead > tr").clone();
			newRow.children().html("");
			newRow.removeClass();
			newRow.find("td:eq(0)").html("<input type='checkbox' name='userNoList' value='"+ resultList[i].userNo + "' onclick=\"checkedCheckboxInTr(event);\" />"); 
			var userLinkHtml = "<a href=\"javascript: void(0);\" onclick=\"javascript:showSearchUserDetailDialog('" + resultList[i].userNo + "');\">" + nvl(defenceXSS(resultList[i].userNm)) + "(" + resultList[i].userId + ")</a>";
			newRow.find("td:eq(1)").attr("align", "left").html(userLinkHtml);
			newRow.find("td:eq(2)").html(resultList[i].userNo); 

			newRow.click(function(){
				clickTrCheckedCheckbox(this);
			});

			$("#appRoleListTbUN > tbody").append(newRow);
		}
	} else {
		var emptyRow = "<tr><td colspan='3' align='center'>" + "<mink:message code='mink.web.text.noexist.inquiry'/>" + "</td></tr>";
		$("#appRoleListTbUN > tbody").append(emptyRow);
	}
}

<%-- 버전 목록 조회 --%>
function goVersionList(currPage) {
	$("#searchFrm2").find("input[name='pageNum']").val(currPage);
	ajaxComm('appVersionListView.miaps', searchFrm2, function(data){
		fnSetVersionList(data);
		<%-- 목록조회일 경우 versionNo를 초기화하여 상세정보 표시 막음 --%>
		$("#searchFrm2").find("input[name='versionNo']").val("");
	});
}

<%-- 버전 목록 조회 결과 --%>
function fnSetVersionList(data) {
	var resultList = data.versionList;
	
	<%-- 테이블 내용 삭제 후 head를 복사하여 값 셋팅하는 방식 --%>
	$("#verListTb > tbody > tr").remove();	<%-- 테이블내용 삭제 (tbody 밑의 tr 삭제) --%>
	if( resultList.length > 0 ) {	<%-- 결과 목록이 있을 경우 --%>
		for(var i = 0; i < resultList.length; i++) {
			var newRow = $("#verListTb > thead > tr").clone(); <%-- head row 복사 --%>
			newRow.children().html("");	<%-- td 내용 초기화 --%>
			newRow.removeClass();
			newRow.attr("id", "listTr"+resultList[i].appId+'v'+resultList[i].versionNo);
			newRow.bind("click", {appId:resultList[i].appId
							   , versionNo:resultList[i].versionNo}
							   , function(e) { goVersionDetail(e.data.appId, e.data.versionNo);  });
			<%--
			//newRow.click("goVersionDetail('"+resultList[i].appId+"','"+resultList[i].versionNo+"')");
			/* newRow.find("td:eq(0)").html(parseInt(data.search.number) - i); */
			--%>
			newRow.find("td:eq(0)").html(resultList[i].versionNo); 
			newRow.find("td:eq(0)").attr("align", "center");
			newRow.find("td:eq(1)").html(defenceXSS(resultList[i].versionNm)); 
			newRow.find("td:eq(1)").attr("align", "left");
			newRow.find("td:eq(2)").html(defenceXSS(resultList[i].storeVersionNm)); 
			newRow.find("td:eq(2)").attr("align", "left");
			var deleteYnInfo = "<mink:message code='mink.web.text.using'/>";
			if (resultList[i].deleteYn == "Y") deleteYnInfo = "<mink:message code='mink.web.text.stoped'/>";
			newRow.find("td:eq(3)").html(deleteYnInfo);
			var forceUpdateYnInfo = "<mink:message code='mink.web.text.disabled'/>";
			if (resultList[i].forceUpdateYn == "Y") forceUpdateYnInfo = "<mink:message code='mink.web.enabled'/>";
			newRow.find("td:eq(4)").html(forceUpdateYnInfo);
			newRow.find("td:eq(5)").html(resultList[i].regDt); 
			newRow.find("td:eq(6)").html(resultList[i].updDt);
			newRow.find("td:eq(7)").html(defenceXSS(resultList[i].versionDesc));
			newRow.find("td:eq(7)").attr("align", "left");
			$("#verListTb > tbody").append(newRow); 	<%-- body 끝에 붙여넣기 --%>
		}
	} else {	<%-- 결과 목록이 없을 경우 --%>
		var emptyRow = "<tr><td colspan='8' align='center'>" + "<mink:message code='mink.web.text.noexist.inquiry'/>" + "</td></tr>";
		$("#verListTb > tbody").append(emptyRow);
	}

	<%-- 페이징 조건 재설정 후 페이징 html 생성 --%>
	$("input[name='pageNum']").val(data.search.currentPage);	<%-- 상세조회 key --%>
	showPageHtml2(data, $("#paginateDiv2"), "goVersionList");
	
	<%-- 상세정보 있을경우 
	if( data.version != null ) {
		fnVersionDetailMapping(data.version); // 상세정보 매핑
		checkedTrCheckbox($("#listTr"+data.version.appId+'v'+data.version.versionNo)); // 선택한 tr 의 checkbox 에 체크선택/css 변경
	} else {
		$("#verDetailDiv").hide();
	}
	--%>
}

var appfileDownloadUrl;
var manifestDownloadUrl;

<%-- ajax 로 가져온 data 를 알맞은 위치에 삽입 --%>
function fnVersionDetailMapping(result) {
	//$("#verDetailDiv").show();
	
	<%-- 상세화면 정보 출력 --%>
	$('#verDetailFrm')[0].reset();	<%-- form 초기화 --%>
	var frm = $("#verDetailFrm");
	frm.find("input[name='appId']").val(result.appId);
	frm.find("input[name='versionNo']").val(result.versionNo);
	frm.find("input[name='versionNm']").val(result.versionNm);
	frm.find("input[name='storeVersionNm']").val(result.storeVersionNm);
	frm.find("input[name='deleteYn']").attr("disabled", false);
	frm.find("input[name='deleteYn'][value=" + result.deleteYn + "]").prop("checked", "checked");
	frm.find("input[name='forceUpdateYn'][value=" + result.forceUpdateYn + "]").prop("checked", "checked");
	<%-- frm.find("input[name='versionDesc']").val(result.versionDesc); --%>
	frm.find("textarea[name='versionDesc']").val(result.versionDesc);
	<%-- 첨부된 파일 셋팅 --%>
	if( result.appFileNm != null ) {
		<%-- frm.find("#appFileImg").attr("src", "appImage.miaps?appId="+result.appId+"&versionNo="+result.versionNo+"&filenm=appFile"); --%>
		frm.find("input[name='appFileNm']").show();
		frm.find("input[name='appFileNm']").val(result.appFileNm);
		$("#appFileDown").show();
	} else {
		<%-- frm.find("#appFileImg").hide(); --%>
		frm.find("input[name='appFileNm']").hide();
		$("#appFileDown").hide();
	}
	if( result.manifestFileNm != null ) {
		<%-- frm.find("#manifestFileImg").attr("src", "appImage.miaps?appId="+result.appId+"&versionNo="+result.versionNo+"&filenm=manifestFile"); --%>
		frm.find("input[name='manifestFileNm']").show();
		frm.find("input[name='manifestFileNm']").val(result.manifestFileNm);
		$("#manifestFileDown").show();
	} else {
		<%-- frm.find("#manifestFileImg").hide(); --%>	
		frm.find("input[name='manifestFileNm']").hide();
		$("#manifestFileDown").hide();
	}

	appfileDownloadUrl = result.appfileDownloadUrl;
	manifestDownloadUrl = result.manifestDownloadUrl;

	<%-- 수정 및 저장 버튼 change --%>
	//$("#verInsertSpan").hide();
	//$("#verUpdateSpan").show();
	<%--
	//$("#verDeleteSpan").show();
	
	// 스크롤 아래로 이동
	//goToBottomPage(document);
	--%>
}

function downloadFile(type) {
	var downUrl = "";
	if ('manifest' == type) {
		downUrl = manifestDownloadUrl;
	}
	if ('appfile' == type) {
		downUrl = appfileDownloadUrl;
	}

	if (downUrl == null || downUrl == "") {
		return;
	}

	downUrl = "../../app/" + downUrl;
	window.open(downUrl);
}

//appUrl에 파라메타를 붙일 수 있게 함 (20150724;)
function validateWeburlParam(frm) {
	var paramYn = frm.find(":input[name='webParamYn']:input[value='Y']:checked").val();
	if ("Y" == paramYn) {
		var appUrl = frm.find("input[name='appUrl']").val();
		appUrl = appUrl + (appUrl.lastIndexOf("?") > 0 ? "&" : "?") + "%{param}";
		frm.find("input[name='appUrl']").val(appUrl);
	}
}

<%-- 등록(ajax) 후 목록 호출 --%>


<%-- 수정(ajax) 후 목록 호출 --%>


<%-- 삭제(ajax) 후 목록 호출 --%>
function goDelete() {
	if(!confirm("<mink:message code='mink.web.alert.is.delete'/>")) return;
	
	ajaxComm('appDelete.miaps?', $('#detailFrm'), function(data){
		resultMsg(data.msg);
		$("#SearchFrm").find("input[name='appId']").val(data.app.appId); <%-- (삭제한)상세 비움 --%>
		goList($("#SearchFrm").find("input[name='pageNum']").val()); <%-- 목록/검색 --%>
	});
}

<%-- 여러개 삭제요청(ajax) --%>
function goDeleteAll() {
	<%-- 검증 --%>
	if($("#listTbody").find(":checkbox:checked").length < 1) {
		alert("<mink:message code='mink.web.alert.select.deleteitem'/>");
		return;
	}
	if( !confirm("<mink:message code='mink.web.alert.is.delete'/>") ) return;
	ajaxComm('appDelete.miaps?', $('#SearchFrm'), function(data){
		resultMsg(data.msg);
		document.SearchFrm.appId.value = ''; <%-- (삭제한)상세 비움 --%>
		goList($("#SearchFrm").find("input[name='pageNum']").val()); <%-- 목록/검색 --%>
	});

}

<%-- 입력 값 검증 --%>
function validation(frm) {
	var result = false;
	
	if( frm.find("input[name='appNm']").val()=="" ) {
		alert("<mink:message code='mink.web.input.appname'/>");
		frm.find("input[name='appNm']").focus();
		return true;
	}
	var packageNm = $.trim(frm.find("input[name='packageNm']").val().replace(/ /g, '')); // 모든공백제거
	frm.find("input[name='packageNm']").val(packageNm);
	if( frm.find("input[name='packageNm']").val()=="" ) {
		alert("<mink:message code='mink.web.input.packagename'/>");
		frm.find("input[name='packageNm']").focus();
		return true;
	}
	var platformCd = frm.find("select[name='platformCd']").val();
	if (platformCd=="${PLATFORM_ANDROID}" || platformCd=="${PLATFORM_ANDROID_TBL}") {
		
		var c_reg_type = $("input[name=modi_type]:checked").val();
		if (c_reg_type == 'P') {			// 패키지/스킴 , 번들
			// 플랫폼이 Android Phone, Android Tablet 일 경우
			var appScheme = frm.find("input[name='appScheme_android']").val();
			frm.find("input:hidden[name='appScheme']").val(appScheme);
			frm.find("input[name='appUrl']").val("");
			frm.find(":input[name='webParamYn']").get(0).checked = false;
		} else if (c_reg_type == 'W') {		// 앱 URL
			var appUrl = $.trim(frm.find("input[name='appUrl']").val().replace(/ /g, '')); // 모든공백제거
			frm.find("input[name='appUrl']").val(appUrl);
			if (frm.find("input[name='appUrl']").val() == "") {
				alert("<mink:message code='mink.web.input.appurl'/>");
				frm.find("input[name='appUrl']").focus();
				return true;
			}
			frm.find("input:hidden[name='androidPackage']").val("");
			frm.find("input:hidden[name='appScheme']").val("");
		}
		
		
	} else if (platformCd=="${PLATFORM_IOS}" || platformCd=="${PLATFORM_IOS_TBL}") {
		var c_reg_type = $("input[name=modi_type]:checked").val();
		if (c_reg_type == 'P') {			// 패키지/스킴 , 번들
			// 플랫폼이 iPhone, iPad 일 경우
			var bundleId = frm.find("input[name='bundleId']").val();
			if (bundleId == "") {
				alert("<mink:message code='mink.web.input.bundleid'/>");
				frm.find("input[name='bundleId']").focus();
				return true;
			}
			frm.find("input[name='androidPackage']").val(bundleId);
			var appScheme = frm.find("input[name='appScheme_ios']").val();
			frm.find(":input:hidden[name='appScheme']").val(appScheme);
			frm.find("input[name='appUrl']").val("");
			frm.find(":input[name='webParamYn']").get(0).checked = false;
		} else if (c_reg_type == 'W') {		// 앱 URL
			var appUrl = $.trim(frm.find("input[name='appUrl']").val().replace(/ /g, '')); // 모든공백제거
			frm.find("input[name='appUrl']").val(appUrl);
			if (frm.find("input[name='appUrl']").val() == "") {
				alert("<mink:message code='mink.web.input.appurl'/>");
				frm.find("input[name='appUrl']").focus();
				return true;
			}
			frm.find("input:hidden[name='androidPackage']").val("");
			frm.find("input:hidden[name='appScheme']").val("");
		}
		
	} else if (platformCd=="${PLATFORM_WEB}") {
		// 플랫폼이 Web 일 경우
		var appUrl = $.trim(frm.find("input[name='appUrl']").val().replace(/ /g, '')); // 모든공백제거
		frm.find("input[name='appUrl']").val(appUrl);
		if (frm.find("input[name='appUrl']").val() == "") {
			alert("<mink:message code='mink.web.input.appurl'/>");
			frm.find("input[name='appUrl']").focus();
			return true;
		}
		frm.find("input:hidden[name='androidPackage']").val("");
		frm.find("input:hidden[name='appScheme']").val("");
	}

	return result;
}

<%-- 버전 등록 div 펼침 --%>


<%-- 앱파일 다운로드 --%>
function fileDown(filenm) {
	var appId = $("#verDetailFrm").find("input[name='appId']").val();
	var versionNo = $("#verDetailFrm").find("input[name='versionNo']").val();
	document.verDetailFrm.action = "appImage.miaps?appId="+defenceXSS(appId)+"&versionNo="+versionNo+"&filenm="+filenm;
	document.verDetailFrm.submit();
	
}

function textareaResize(obj) {
	obj.style.height = "1px";
	obj.style.height = (20 + obj.scrollHeight) + "px";
}

function activeTab() {
	$("ul.tabs_appRole li").not("li.active").css({"text-decoration":"none","cursor":"pointer"});
	$("ul.tabs_appRole li").on("click", function () {
	    $("ul.tabs_appRole li").removeClass("active").css("color", "#333");	    
	    $(this).addClass("active").css("color", "#0459c1");
	    $(".tab_content_appRole").hide()
	    var activeTab = $(this).attr("rel");        
	    $("#" + activeTab).fadeIn()
	});
}

function completeTreeview() {
	
}

</script>
</head>
<body>

<%if ("Y".equalsIgnoreCase(appRoleYn)) {%>
<!-- 메뉴 구성원인 권한 그룹 등록 treeview dialog -->
<%@ include file="/WEB-INF/jsp/asvc/app/searchRoleGroupTreeviewDialog.jsp" %>
<!-- 메뉴 구성원인 사용자 그룹 등록 treeview dialog -->
<%@ include file="/WEB-INF/jsp/asvc/app/searchUserGroupTreeviewDialog.jsp" %>
<!-- 메뉴 구성원인 사용자 등록 dialog -->
<%@ include file="/WEB-INF/jsp/asvc/app/searchUserDialog.jsp" %>
<%-- 메뉴 구성원인 '업체'사용자 등록 dialog 
<%@ include file="/WEB-INF/jsp/asvc/app/searchUserDialogByLegacy.jsp" %>
--%>
<!-- 사용자 상세정보 다이얼로그 -->
<%@ include file="/WEB-INF/jsp/include/searchUserDetailDialog.jsp" %>
<%}%>

<%-- 앱 등록 다이얼로그 --%>
<%@ include file="/WEB-INF/jsp/asvc/app/appRegDialog.jsp" %>
<%-- 앱 수정 다이얼로그 --%>
<%@ include file="/WEB-INF/jsp/asvc/app/appModiDialog.jsp" %>
<%-- 앱 버전 등록/상세조회/수정 다이얼로그 --%>
<%@ include file="/WEB-INF/jsp/asvc/app/appVersionRegModiDialog.jsp" %>


<div id="miaps-container">
	<div id="miaps-header">
    	<%@ include file="/WEB-INF/jsp/include/header.jsp" %>
  	</div>
  	<div id="miaps-sidebar">
		<%@ include file="/WEB-INF/jsp/include/left.jsp" %>
	</div>
	<div id="miaps-top-buttons">
		<span><button class='btn-dash' onclick="javascript:openAppRegDialog()"><mink:message code="mink.web.text.regist"/></button></span>
		<span><button class='btn-dash' onclick="javascript:goDeleteAll();"><mink:message code="mink.web.text.delete"/></button></span>
	</div>
	<div id="miaps-content">
    	<!-- 본문 -->
		<form id="SearchFrm" name="SearchFrm" method="post" onSubmit="return false;">
		<%-- 검색 hidden --%>
		<input type="hidden" name="regNo" value="${loginUser.userNo}"/>	<%-- 로그인한 사용자 --%>
		<input type="hidden" name="updNo" value="${loginUser.userNo}"/>	<%-- 로그인한 사용자 --%>
		<input type="hidden" name="appId" /><%-- 상세 --%>
		<input type="hidden" name="pageNum" value='<c:out value="${search.currentPage}"/>' /><%-- 현재 페이지 --%>
		<input type="hidden" name="ordColumnNm" value='<c:out value="${search.ordColumnNm}"/>' />
		<input type="hidden" name="ordAscDesc" value='<c:out value="${search.ordAscDesc}"/>' />
		<%--
		<div><h3><span>* 앱 관리</span></h3></div>
		--%>
		<%-- 검색 화면 --%>
		<div>
			<table border="0" cellspacing="0" cellpadding="0" width="100%">
				<tr> 	
					<td class="search">
						<select name="searchKey">
							<option value="" ${search.searchKey == '' ? '' : ''}><mink:message code="mink.web.text.full.all"/></option>
							<option value="appNm" ${search.searchKey == 'appNm' ? 'selected' : ''}><mink:message code="mink.web.text.appname"/></option>
							<option value="appId" ${search.searchKey == 'appId' ? 'selected' : ''}><mink:message code="mink.web.text.appid"/></option>
							<option value="packageNm" ${search.searchKey == 'packageNm' ? 'selected' : ''}><mink:message code="mink.web.text.packagename"/></option>
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
			</table>
		</div>
		
		<%-- 목록 화면 --%>
		<div>
			<table class="listTb" border="0" cellspacing="0" cellpadding="0" width="100%">
				<colgroup>
					<col width="3%" />
					<col width="40%" />
					<col width="12%" />
					<col width="20%" />
					<col width="11%" />
					<col width="10%" />
					<col width="4%" />
				</colgroup>
				<thead>
					<tr>
						<td><input type="checkbox" name="appCheckboxAll" /></td>
						<td id="order_app_nm" class="order_by_column" onclick="orderBy('app_nm', 'SearchFrm', function(){ goList('1'); });"><mink:message code="mink.web.text.appname"/></td>
						<td id="order_reg_dt" class="order_by_column" onclick="orderBy('reg_dt', 'SearchFrm', function(){ goList('1'); });"><mink:message code="mink.web.text.regdate"/></td>
						<td id="order_package_nm" class="order_by_column" onclick="orderBy('package_nm', 'SearchFrm', function(){ goList('1'); });"><mink:message code="mink.web.text.apppackagename"/></td>
						<td id="order_platform_cd" class="order_by_column" onclick="orderBy('platform_cd', 'SearchFrm', function(){ goList('1'); });"><mink:message code="mink.web.text.platform"/></td>
						<td id="order_public_yn" class="order_by_column" onclick="orderBy('public_yn', 'SearchFrm', function(){ goList('1'); });"><mink:message code="mink.web.text.permission.appuse"/></td>
						<td id="order_app_id" class="order_by_column" onclick="orderBy('app_id', 'SearchFrm', function(){ goList('1'); });">ID</td>
					</tr>
				</thead>
				<tbody id="listTbody">
					<%-- 목록이 있을 경우 --%>
					<c:forEach var="dto" items="${appList}" varStatus="i">
					<tr id="listTr${dto.appId}" onclick="javascript:goDetail('${dto.appId}');">
						<td><input type="checkbox" name="appIds" value="${dto.appId}" onclick="checkedCheckboxInTr(event)" /></td>
						<td align="left" style="padding: 5px;">
					    	<c:if test='${null ne dto.smallIconNm && !empty dto.smallIconNm}'>
								<div style='float:left; background-image:url("appImage.miaps?appId=${dto.appId}&filenm=smallIcon")' class='applist-img-block'></div> 
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
				<tfoot id="listTfoot">
					<tr>
						<td colspan="7"><mink:message code="mink.web.text.noexist.result"/></td>
					</tr>
				</tfoot>
			</table>
		</div>
		
		<div id="paginateDiv">
			<div class="paginateDivSub">
			<%@ include file="/WEB-INF/jsp/include/pagination.jsp" %>
			</div>
		</div>
		</form>
	</div>
	<div id="miaps-footer">
    	<%@ include file="/WEB-INF/jsp/include/footer.jsp" %>
  	</div>
</div>
</body>
</html>
