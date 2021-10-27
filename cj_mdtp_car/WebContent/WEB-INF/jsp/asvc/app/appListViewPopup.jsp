<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="org.springframework.web.bind.annotation.SessionAttributes"%>
<%@ page import="com.thinkm.mink.commons.util.MinkConfig" %>
<%
	/*
	 * 앱 관리 팝업 화면 - 목록 (appListViewPopup.jsp)
	 * 
	 * @author juni
	 * @since 2014.05.02
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

	init(); // 이벤트 핸들러 세팅
	
	showList(); // 목록 보이기
	showPageHtml(); // 페이징 html 생성

	// 등록 및 수정 시 검색조건 셋팅
	$("input[name='searchKey']").val("<c:out value='${search.searchKey}'/>");
	$("input[name='searchValue']").val("<c:out value='${search.searchValue}'/>");
	
	if(eval('${!empty app}')) { 
		var dto = eval("("+'${app}'+")");
		fnDetailProcess(dto); // 상세정보 매핑
		checkedTrCheckbox($("#listTr"+dto.appId)); // 선택한 tr 의 checkbox 에 체크선택/css 변경
	}

});

// 목록검색
function goList(pageNum) {
	document.SearchFrm.pageNum.value = pageNum; // 이동할 페이지
	document.SearchFrm.action = 'appListView.miaps?';
	document.SearchFrm.submit();
}

// 상세조회호출(ajax)
function goDetail(appId) {
	checkedTrCheckbox($("#listTr"+appId));	// 선택된 row 색깔변경
	$("#detailFrm").find("input[name='appId']").val(appId); // (선택한)상세
	ajaxComm('appDetail.miaps?', $('#detailFrm'), function(data){
		fnDetailProcess(data.app); // 상세 ajax 세부작업
	});
}

// ajax 로 가져온 data 를 알맞은 위치에 삽입
function fnAjaxInfoMapping(result) {
	// 상세화면 정보 출력
	var frm = $("#detailFrm");
	frm.find("input[name='appId']").val(result.appId);
	frm.find("input[name='appNm']").val(result.appNm);
	frm.find("input[name='appDesc']").val(result.appDesc);
	frm.find("input[name='packageNm']").val(result.packageNm);
	frm.find("input[name='prePackageNm']").val(result.packageNm);
	frm.find("select[name='platformCd']").val(result.platformCd);
	frm.find("input[name='publicYn'][value=" + result.publicYn + "]").attr("checked", "checked");

	if( result.smallIcon != null ) {
		var smallIconImg = "<img width=\"100\" height=\"100\" src=\"appImage.miaps?appId="+defenceXSS(result.appId)+"&filenm=smallIcon\"/>";
		frm.find("#smallIconImg").html(smallIconImg);
	}
	else frm.find("#smallIconImg").html("");
	if( result.bigIcon != null ) {
		var bigIconImg = "<img width=\"100\" height=\"100\" src=\"appImage.miaps?appId="+defenceXSS(result.appId)+"&filenm=bigIcon\"/>";
		frm.find("#bigIconImg").html(bigIconImg);
	}
	else frm.find("#bigIconImg").html("");	
	frm.find("input[name='androidPackage']").val(result.androidPackage);
	frm.find("input[name='androidActivity']").val(result.androidActivity);
	frm.find("select[name='regSt']").val(result.regSt);
	//frm.find("input[name='launcherYn'][value=" + result.launcherYn + "]").attr("checked", "checked");
	frm.find("input[name='emailAddr']").val(result.emailAddr);
	frm.find("input[name='phoneNo']").val(result.phoneNo);
	frm.find("input[name='regNm']").val(result.regNm);
	frm.find("input[name='regDt']").val(result.regDt);
	
	// 하위목록 key setting
	$("#searchFrm2").find("input[name='appId']").val(result.appId); 
	
	// 버전 목록 조회
	goVersionList("1");
	
}

// 버전 목록 조회
function goVersionList(currPage) {
	$("#searchFrm2").find("input[name='pageNum']").val(currPage);
	ajaxComm('appVersionListView.miaps', searchFrm2, function(data){
		fnSetVersionList(data);
		// 목록조회일 경우 versionNo를 초기화하여 상세정보 표시 막음
		$("#searchFrm2").find("input[name='versionNo']").val("");
	});
}

// 버전 목록 조회 결과
function fnSetVersionList(data) {
	var resultList = data.versionList;
	
	// 테이블 내용 삭제 후 head를 복사하여 값 셋팅하는 방식
	$("#verListTb > tbody > tr").remove();	// 테이블내용 삭제 (tbody 밑의 tr 삭제)
	if( resultList.length > 0 ) {	// 결과 목록이 있을 경우
		for(var i = 0; i < resultList.length; i++) {
			var newRow = $("#verListTb > thead > tr").clone(); // head row 복사
			newRow.children().html("");	// td 내용 초기화
			newRow.removeClass();
			newRow.attr("id", "listTr"+resultList[i].appId+resultList[i].versionNo);
			newRow.bind("click", {appId:resultList[i].appId
							   , versionNo:resultList[i].versionNo}
							   , function(e) { goVersionDetail(e.data.appId, e.data.versionNo);  });
			//newRow.click("goVersionDetail('"+resultList[i].appId+"','"+resultList[i].versionNo+"')");
			/* newRow.find("td:eq(0)").html(parseInt(data.search.number) - i); */
			newRow.find("td:eq(0)").html(resultList[i].versionNm); 
			newRow.find("td:eq(0)").attr("align", "left");
			newRow.find("td:eq(1)").html(resultList[i].regDt); 
			newRow.find("td:eq(2)").html(resultList[i].versionDesc);
			newRow.find("td:eq(2)").attr("align", "left");
			$("#verListTb > tbody").append(newRow); 	// body 끝에 붙여넣기
		}
	} else {	// 결과 목록이 없을 경우
		var emptyRow = "<mink:message code='mink.web.text.noexist.inquiry'/>";
		$("#verListTb > tbody").append(emptyRow);
	}

	// 페이징 조건 재설정 후 페이징 html 생성
	$("input[name='pageNum']").val(data.search.currentPage);	// 상세조회 key
	showPageHtml2(data, $("#paginateDiv2"), "goVersionList");
	
	// 상세정보 있을경우
	if( data.version != null ) {
		fnVersionDetailMapping(data.version); // 상세정보 매핑
		checkedTrCheckbox($("#listTr"+data.version.appId+data.version.versionNo)); // 선택한 tr 의 checkbox 에 체크선택/css 변경
	} else {
		$("#verDetailDiv").hide();
	}
}

// 상세조회호출(ajax)
function goVersionDetail(appId, versionNo) {
	checkedTrCheckbox($("#listTr"+appId+versionNo));	// 선택된 row 색깔변경
	$("#verDetailFrm").find("input[name='appId']").val(appId); // (선택한)상세
	$("#verDetailFrm").find("input[name='versionNo']").val(versionNo); // (선택한)상세
	ajaxComm('appVersionDetail.miaps?', $('#verDetailFrm'), function(data){
		fnVersionDetailMapping(data.version); // 상세 ajax 세부작업
	});
}

// ajax 로 가져온 data 를 알맞은 위치에 삽입
function fnVersionDetailMapping(result) {
	$("#verDetailDiv").show();
	
	// 상세화면 정보 출력
	$('#verDetailFrm')[0].reset();	// form 초기화
	var frm = $("#verDetailFrm");
	frm.find("input[name='appId']").val(result.appId);
	frm.find("input[name='versionNo']").val(result.versionNo);
	frm.find("input[name='versionNm']").val(result.versionNm);
	frm.find("input[name='deleteYn']").attr("disabled", false);
	frm.find("input[name='deleteYn'][value=" + result.deleteYn + "]").prop("checked", "checked");
	frm.find("input[name='versionDesc']").val(result.versionDesc);
	// 첨부된 파일 셋팅
	if( result.appFileNm != null ) {
		//frm.find("#appFileImg").attr("src", "appImage.miaps?appId="+result.appId+"&versionNo="+result.versionNo+"&filenm=appFile");
		frm.find("input[name='appFileNm']").show();
		frm.find("input[name='appFileNm']").val(result.appFileNm);
		$("#appFileDown").show();
	} else {
		//frm.find("#appFileImg").hide();
		frm.find("input[name='appFileNm']").hide();
		$("#appFileDown").hide();
	}
	if( result.manifestFileNm != null ) {
		//frm.find("#manifestFileImg").attr("src", "appImage.miaps?appId="+result.appId+"&versionNo="+result.versionNo+"&filenm=manifestFile");
		frm.find("input[name='manifestFileNm']").show();
		frm.find("input[name='manifestFileNm']").val(result.manifestFileNm);
		$("#manifestFileDown").show();
	} else {
		//frm.find("#manifestFileImg").hide();	
		frm.find("input[name='manifestFileNm']").hide();
		$("#manifestFileDown").hide();
	}
	
	// 스크롤 아래로 이동
	//goToBottomPage(document);
}


// 앱파일 다운로드
function fileDown(filenm) {
	var appId = $("#verDetailFrm").find("input[name='appId']").val();
	var versionNo = $("#verDetailFrm").find("input[name='versionNo']").val();
	document.verDetailFrm.action = "appImage.miaps?appId="+defenceXSS(appId)+"&versionNo="+versionNo+"&filenm="+filenm;
	document.verDetailFrm.submit();
	
}

// 앱 목록 선택
function selectAppList() {
	var checkedCnt = $("#listTbody").find(":checkbox:checked").length;
	if(checkedCnt < 1) {
		alert("<mink:message code='mink.web.alert.select.regapp'/>");
		return;
	}
	
	
	if( !confirm(checkedCnt+ "<mink:message code='mink.web.alert.is.registapp'/>") ) return;
	ajaxComm('appCategoryMemberInsert.miaps?', $('#SearchFrm'), function(data){
		//resultMsg(data.msg);
		opener.goAppMemberList("1");
		self.close();
	});
}


</script>

</head>
<body>

<!-- 본문 -->
<div>
	
	<div >
		<form id="SearchFrm" name="SearchFrm" method="post" onSubmit="return false;">
		<!-- 검색 hidden -->
		<input type="hidden" name="appId" /><!-- 상세 -->
		<input type="hidden" name="pageNum" value="${search.currentPage}" /><!-- 현재 페이지 -->
		<input type="hidden" name="isPopup" value="Y" />
		<input type="hidden" name="categId" value="${search.categId}"/><!-- 부모창의 id -->
		<input type="hidden" name="regNo" value="${loginUser.userNo}"/>	<!-- 로그인한 사용자 -->
		
		<div>
			<h3><span><mink:message code="mink.web.text.appmanage"/></span></h3>
		</div>
		
		<div style="text-align: right; font: italic 13px 맑은 고딕, 돋움, arial; color:#808080;"><mink:message code="mink.web.text.invisible.nopublicapp"/></div>
		
		<!-- 검색 화면 -->
		<div>
			<table border="1" cellspacing="0" cellpadding="0" width="100%">
				<tr> 	
					<td class="search">
						<select name="searchKey">
							<option value="" ${search.searchKey == '' ? '' : ''}><mink:message code="mink.web.text.total"/></option>
							<option value="appNm" ${search.searchKey == 'appNm' ? 'selected' : ''}><mink:message code="mink.web.text.appname"/></option>
							<option value="appId" ${search.searchKey == 'appId' ? 'selected' : ''}><mink:message code="mink.web.text.appid"/></option>
							<option value="packageNm" ${search.searchKey == 'packageNm' ? 'selected' : ''}><mink:message code="mink.web.text.packagename"/></option>
						</select>
						<input type="text" name="searchValue" value="<c:out value='${search.searchValue}'/>"/>
						<button class='btn-dash' onclick="javascript:goList('1');"><mink:message code="mink.web.text.search"/></button>
					</td>
				</tr>
			</table>
		</div>
		
		<!-- 목록 화면 -->
		<div>
			<table class="listTb" border="1" cellspacing="0" cellpadding="0" width="100%">
				<colgroup>
					<col width="6%" />
					<col width="40%" />
					<col width="11%" />
					<col width="14%" />
					<col width="15%" />
					<col width="14%" />
				</colgroup>
				<thead>
					<tr>
						<td><input type="checkbox" name="appCheckboxAll" /></td>
						<!-- <td>순번</td> -->
						<td><mink:message code="mink.web.text.appname"/></td>
						<td><mink:message code="mink.web.text.platform"/></td>
						<td><mink:message code="mink.web.text.status.regist"/></td>
						<td><mink:message code="mink.web.text.status.commonapp"/></td>
						<td><mink:message code="mink.web.text.regdate"/></td>
					</tr>
				</thead>
				<tbody id="listTbody">
					<!-- 목록이 있을 경우 -->
					<c:forEach var="dto" items="${appList}" varStatus="i">
					<tr id="listTr${dto.appId}" onclick="javascript:goDetail('${dto.appId}');">
						<td><input type="checkbox" name="appIds" value="${dto.appId}" onclick="checkedCheckboxInTr(event)" /></td>
						<%-- <td>${search.number - i.index}</td> --%>
						<td align="left">${dto.appNm}</td>
						<td>
							<c:choose>
								<c:when test="${dto.platformCd==PLATFORM_ANDROID}">Android Phone</c:when>
								<c:when test="${dto.platformCd==PLATFORM_ANDROID_TBL}">Android Tablet</c:when>
								<c:when test="${dto.platformCd==PLATFORM_IOS}">iPhone/iPod</c:when>
								<c:when test="${dto.platformCd==PLATFORM_IOS_TBL}">iPad</c:when>
								<c:when test="${dto.platformCd==PLATFORM_WEB}">Web</c:when>
								<c:otherwise>${dto.platformCd}</c:otherwise>
							</c:choose>
						</td>
						<td>
							<c:choose>
								<c:when test="${dto.regSt==APP_REG_ST}"><mink:message code="mink.web.text.approval"/></c:when>
								<c:otherwise><mink:message code="mink.web.text.unapproval"/></c:otherwise>
							</c:choose>
						</td>
						<td>
							<c:choose>
								<c:when test="${dto.publicYn=='Y'}"><mink:message code="mink.web.text.commonapp"/></c:when>
								<c:when test="${dto.publicYn=='N'}"><mink:message code="mink.web.text.notcommon"/></c:when>
								<c:otherwise>${dto.publicYn}</c:otherwise>
							</c:choose>
						</td>	
						<td>${dto.regDt}</td>
					</tr>
					</c:forEach>
				</tbody>
				<tfoot id="listTfoot">
					<!-- 목록이 없을 경우 -->
					<tr>
						<td colspan="6"><mink:message code="mink.web.text.noexist.result"/></td>
					</tr>
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

		<div class="searchBtnArea">
			<button class='btn-dash' onclick="javascript:selectAppList();"><mink:message code="mink.web.text.select.app"/></button>&nbsp;&nbsp;
			<button class='btn-dash' onclick="javascript:self.close();"><mink:message code="mink.web.text.close"/></button>
		</div>
		</form>
	
	
		<br /><br />
		<!-- 상세화면 -->
		<div id="detailDiv" style="display: none">
			<form id="detailFrm" name="detailFrm" class="detailFrm" method="POST" enctype="multipart/form-data" onsubmit="return false;">
				<input type="hidden" name="updNo" value="${loginUser.userNo}"/>	<!-- 로그인한 사용자 -->
				<!-- <input type="hidden" name="appId" value=""/>	key -->
				<input type="hidden" name="searchKey" value=""/>	<!-- 검색조건 -->
				<input type="hidden" name="searchValue" value=""/>	<!-- 검색조건 -->
				<input type="hidden" name="prePackageNm" value=""/>	<!-- 앱 패키지 이름 수정시, 앱 메뉴의 패키지 이름 수정필수 -->
				<input type="hidden" name="regSt" value="${APP_REG_ST}" /> <!-- 일단 디폴트값(9)으로 지정 -->
				<input type="hidden" name="launcherYn" value="Y" /><!-- 일단 론처에표시(Y)로 디폴트값 지정 -->
				
				<div>
					<h3><span><mink:message code="mink.web.text.info.appmanagedetail"/></span></h3>
				</div>
				<table class="detailTb" border="1" cellspacing="0" cellpadding="0" width="100%">
					<colgroup>
						<col width="20%" />
						<col width="30%" />
						<col width="20%" />
						<col width="30%" />
					</colgroup>
					<tbody>
						<tr>
							<th><span class="criticalItems"><mink:message code="mink.web.text.appname"/></span></th>
							<td><input type="text" name="appNm" /></td>
							<th><span class="criticalItems"><mink:message code="mink.web.text.appid"/></span></th>
							<td><input type="text" name="appId" /></td>
						</tr>
						<tr>
							<th><mink:message code="mink.web.text.description.app"/></th>
							<td colspan="3"><input type="text" name="appDesc" /></td>
						</tr>
						<tr>
							<th><span class="criticalItems"><mink:message code="mink.web.text.apppackagename"/></span></th>
							<td colspan="3"><input type="text" name="packageNm" /></td>
						</tr>
						<tr>
							<th><span class="criticalItems"><mink:message code="mink.web.text.platform"/></span></th>
							<td>
								<select class="selectSpace" name="platformCd" disabled="disabled">
									<option value="${PLATFORM_IOS}">iPhone/iPod</option>
									<option value="${PLATFORM_IOS_TBL}">iPad</option>
									<option value="${PLATFORM_ANDROID}">Android Phone</option>
									<option value="${PLATFORM_ANDROID_TBL}">Android Tablet</option>
									<option value="${PLATFORM_WEB}">Web</option>
								</select>
							</td>
							<th><span class="criticalItems"><mink:message code="mink.web.text.status.commonapp"/></span></th>
							<td>
								<input type="radio" name="publicYn" value="Y" id="publicYn_y" disabled="disabled"/><label for="publicYn_y" ><mink:message code="mink.web.text.commonapp"/></label>
								<input type="radio" name="publicYn" value="N" id="publicYn_n" disabled="disabled"/><label for="publicYn_n" ><mink:message code="mink.web.text.notcommon.need.permission"/></label>
							</td>
						</tr>
						<tr>
							<th><mink:message code="mink.web.text.icon.small"/></th>
							<td colspan="3" >
								<span id="smallIconImg"></span>
							<td>
						</tr>
						<tr>
							<th><mink:message code="mink.web.text.icon.large"/></th>
							<td colspan="3">
								<span id="bigIconImg"></span>
							<td>
						</tr>
						<tr>
							<th><mink:message code="mink.web.text.android.package"/></th>
							<td><input type="text" name="androidPackage" /></td>
							<th><mink:message code="mink.web.text.android.activity"/></th>
							<td><input type="text" name="androidActivity" /></td>
						</tr>
						<!-- <tr>
							<th><span class="criticalItems">등록 상태</span></th>
							<td>
								<select class="selectSpace" name="regSt">
									<option value="9" >승인</option>
								</select>
							</td>
							<th><span class="criticalItems">메인 론처에 표시</span></th>
							<td>
								<input type="radio" name="launcherYn" value="Y" id="launcherYn_y" class="radio" /><label for="launcherYn_y" >론처에 표시&nbsp;&nbsp;</label>
								<input type="radio" name="launcherYn" value="N" id="launcherYn_n" class="radio" /><label for="launcherYn_n" >아님&nbsp;&nbsp;</label>
							</td>
						</tr> -->
						<tr>
							<th><mink:message code="mink.web.text.admin.email"/></th>
							<td><input type="text" name="emailAddr" /></td>
							<th><mink:message code="mink.web.text.admin.pnumber"/></th>
							<td><input type="text" name="phoneNo" /></td>
						</tr>
					</tbody>
					<tfoot></tfoot>
				</table>
				
				<div class="detailBtnArea">
					<div id="updateBtnDiv">
						<span><button class='btn-dash' onclick="javascript:hiddenInsertDetail();"><mink:message code="mink.web.text.close"/></button></span>
					</div>
				</div>
			</form>
			
			
			<form id="searchFrm2" name="searchFrm2" method="POST" onsubmit="return false;">
				<input type="hidden" name="pageNum" value="" />	<!-- 현재 페이지 -->
				<input type="hidden" name="appId" value=""/>	<!-- key -->
				<input type="hidden" name="versionNo" value=""/>	<!-- key -->
			</form>


			<!-- 버전 -->
			<br /><br />
			<div class="readonlySpace">
				
				<div id="titleDetailDiv">
					<h3><mink:message code="mink.web.text.list.appversion"/></h3>
				</div>
	
				<table id="verListTb" border="1" cellspacing="0" cellpadding="0" width="100%" class="read_listTb">
					<colgroup>
						<col width="15%" />
						<col width="25%" />
						<col width="60%" />
					</colgroup>
					<thead>
						<tr>
							<td><mink:message code="mink.web.text.version"/></td>
							<td><mink:message code="mink.web.text.regdate"/></td>
							<td><mink:message code="mink.web.text.description.version"/></td>
						</tr>
					</thead>
					<tbody>
					</tbody>
					<tfoot></tfoot>
				</table>
				
				<div id="paginateDiv2" class="paginateDiv"></div>
				
			</div>
			
			<!-- 버전 상세화면 -->
			<br /><br /><br />
			<div id="verDetailDiv" style="display: none">
				<form id="verDetailFrm" name="verDetailFrm" class="detailFrm" method="POST" enctype="multipart/form-data" onsubmit="return false;">
					<input type="hidden" name="regNo" value="${loginUser.userNo}"/>	<!-- 로그인한 사용자 -->
					<input type="hidden" name="updNo" value="${loginUser.userNo}"/>	<!-- 로그인한 사용자 -->
					<input type="hidden" name="pageNum" value="" />	<!-- 현재 페이지 -->
					<input type="hidden" name="appId" value=""/>	<!-- key -->
					<input type="hidden" name="versionNo" value=""/>	<!-- key -->
					<!-- <input type="hidden" name="searchKey" value=""/> -->	<!-- 검색조건 -->
					<!-- <input type="hidden" name="searchValue" value=""/> -->	<!-- 검색조건 -->
						
					<div>
						<h3><span><mink:message code="mink.web.text.info.version"/></span></h3>
					</div>
					<table class="detailTb" border="1" cellspacing="0" cellpadding="0" width="100%">
						<colgroup>
							<col width="20%" />
							<col width="30%" />
							<col width="20%" />
							<col width="30%" />
						</colgroup>
						<tbody>
							<tr>
								<th><span class="criticalItems"><mink:message code="mink.web.text.appversion"/></span></th>
								<td><input type="text" name="versionNm" /></td>
								<th><span class="criticalItems"><mink:message code="mink.web.text.is.use"/></span></th>
								<td>
									<input type="radio" name="deleteYn" value="N" id="deleteYn_n" class="radio" disabled="disabled" /><label for="deleteYn_n" ><mink:message code="mink.web.text.using"/></label>
									<input type="radio" name="deleteYn" value="Y" id="deleteYn_y" class="radio" disabled="disabled"/><label for="deleteYn_y" ><mink:message code="mink.web.text.stoped"/></label>
								</td>
							</tr>
							<tr>
								<th><span class="criticalItems"><mink:message code="mink.web.text.install.file"/></span></th>
								<td>
									<!-- <img id="appFileImg" width="100" height="100" src=""/>  -->
									<input type="text" name="appFileNm" />
								</td>
								<th><mink:message code="mink.web.text.install.pathfile"/></th>
								<td>
									<!-- <img id="manifestFileImg" width="100" height="100" src=""/>  -->
									<input type="text" name="manifestFileNm" />
								</td>
							</tr>
							<tr>
								<th><mink:message code="mink.web.text.description.version"/></th>
								<td colspan="3"><input type="text" name="versionDesc" /></td>
							</tr>
						</tbody>
						<tfoot></tfoot>
					</table>

					<div class="detailBtnArea">
						<span><button class='btn-dash' onclick="javascript:hiddenTb($('#verDetailDiv'));">닫기</button></span>
					</div>
				</form>
			</div>
		</div>
	</div>
	

</div>

<!-- footer -->
<div class="footerContent" >
	<%@ include file="/WEB-INF/jsp/include/footer.jsp" %>
</div>
	
</body>
</html>
