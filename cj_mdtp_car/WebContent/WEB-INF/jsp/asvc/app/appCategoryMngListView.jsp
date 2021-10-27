<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="org.springframework.web.bind.annotation.SessionAttributes"%>
<%@ page import="com.thinkm.mink.commons.util.MinkConfig" %>
<%
	/*
	 * 앱 카테고리 관리화면 - 목록 및 등록/수정/삭제 (categCategoryMngListView.jsp)
	 * 
	 * @author juni
	 * @since 2014.04.02
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
	init_accordion('app', '${loginUser.menuListString}');
	$("#topMenuTile").html("<mink:message code='mink.menu.app_management'/>" + " > " + "<mink:message code='mink.menu.app_category'/>");
	
	init(); // 이벤트 핸들러 세팅
	
	showList(); // 목록 보이기
	showPageHtml(); // 페이징 html 생성

	// 등록 및 수정 시 검색조건 셋팅
	$("input[name='searchKey']").val("<c:out value='${search.searchKey}'/>");
	$("input[name='searchValue']").val("<c:out value='${search.searchValue}'/>");
	
	if(eval('${!empty categ}')) { 
		var dto = eval("("+'${categ}'+")");
		fnDetailProcess(dto); // 상세정보 매핑
		checkedTrCheckbox($("#listTr"+dto.categId)); // 선택한 tr 의 checkbox 에 체크선택/css 변경
	}
	
});

// 목록검색
function goList(pageNum) {
	<%-- XSS 방어 --%>
	var _searchVal = defenceXSS(document.SearchFrm.searchValue.value); 
	document.SearchFrm.searchValue.value = _searchVal;
	
	$("#SearchFrm").find("input[name='pageNum']").val(defenceXSS(pageNum));
	ajaxComm('appCategoryMngListViewJSON.miaps?', $("#SearchFrm"), function(data) {
		setTbodyAfterSearch(data.categList);
	});
}

function setTbodyAfterSearch(data) {

	$('#listTbody').empty();
	var tBody = "";
	if(data != null) {
		for(var i = 0;i < Object.keys(data).length; i++) {
			tBody += "<tr id='listTr"+data[i].categId+"' onclick='javascript:goDetail(\""+defenceXSS(data[i].categId)+"\")'>";
			tBody += "<td><input type='checkbox' name='categIds' value='"+defenceXSS(data[i].categId)+"' onclick='checkedCheckboxInTr(event)'/></td>";
			tBody += "<td align='center'>"+defenceXSS(data[i].categId)+"</td>";
			tBody += "<td align='left'>"+defenceXSS(data[i].categNm)+"</td>";
			tBody += "<td>"+defenceXSS(data[i].regDt)+"</td></tr>";
		}		
		$('#listTbody').append(tBody);
		
	} else {
		tBody += "<tr>";
		tBody += 	"<td colspan='4'><mink:message code='mink.web.text.noexist.result'/></td>";
		tBody += "</tr>";
		
		$('#listTbody').html(tBody);
	}
}

// 상세조회호출(ajax)
function goDetail(categId) {
	checkedTrCheckbox($("#listTr"+categId));	// 선택된 row 색깔변경
	$("#detailFrm").find("input[name='categId']").val(categId); // (선택한)상세
	ajaxComm('appCategoryDetail.miaps?', $('#detailFrm'),function(data) {
		fnAjaxInfoMapping(data.categ);
		//$("#appCategoryMngListDialog").dialog("open");
	});
}

// ajax 로 가져온 data 를 알맞은 위치에 삽입
function fnAjaxInfoMapping(result) {
	// 상세화면 정보 출력
	var frm = $("#detailFrm");
	frm.find("input[name='categId']").val(result.categId);
	frm.find("input[name='categNm']").val(result.categNm);
	frm.find("input[name='categDesc']").val(result.categDesc);
	frm.find("input[name='regNm']").val(result.regNm);
	frm.find("input[name='regDt']").val(result.regDt);
	
	// 하위목록 key setting
	$("#searchFrm2").find("input[name='categId']").val(result.categId); 
	$("#appListFrm").find("input[name='categId']").val(result.categId); 
	
	// 버전 목록 조회
	goAppMemberList("1");
	
}

// 앱 목록 조회
function goAppMemberList(currPage) {
	$("#searchFrm2").find("input[name='pageNum']").val(currPage);
	ajaxComm('appCategoryMngMemberListView.miaps', searchFrm2, function(data){
		fnSetAppMemberList(data);
		// 목록조회일 경우 versionNo를 초기화하여 상세정보 표시 막음
		$("#searchFrm2").find("input[name='appId']").val("");
	});
}

// 앱 목록 조회 결과
function fnSetAppMemberList(data) {
	var resultList = data.categMemberList;
	
	// 테이블 내용 삭제 후 head를 복사하여 값 셋팅하는 방식
	$("#appListTb > tbody > tr").remove();	// 테이블내용 삭제 (tbody 밑의 tr 삭제)
	if( resultList.length > 0 ) {	// 결과 목록이 있을 경우
		for(var i = 0; i < resultList.length; i++) {
			var newRow = $("#appListTb > thead > tr").clone(); // head row 복사
			newRow.children().html("");	// td 내용 초기화
			newRow.removeClass();
			newRow.attr("id", "listTr"+resultList[i].appId);
			/* newRow.children("td:not(:last):not(:eq(0))").bind("click", {appId:resultList[i].appId}
							   , function(e) { goCategMemberDetail(e.data.appId);  }); */
			newRow.find("td:eq(0)").html("<input type='text' name='orderSeqs' value='"+resultList[i].orderSeq+"' style='width:20px;' />");				   
			var str = "<input type='hidden' name='appIds' value='"+resultList[i].appId+"'/>";
			newRow.find("td:eq(1)").html(resultList[i].appId+str); 
			var appNmInfo = defenceXSS(resultList[i].appNm) + " " + setBracket(defenceXSS(resultList[i].packageNm));
			newRow.find("td:eq(2)").html(appNmInfo);
			newRow.find("td:eq(2)").attr("align", "left");
			var platformCdInfo = getPlatformNm(resultList[i].platformCd);
			newRow.find("td:eq(3)").html(platformCdInfo);
			var publicYnInfo = resultList[i].publicYn == "Y" ? "<mink:message code='mink.label.app_role_public'/>" : "<mink:message code='mink.label.app_role_private'/>";
			newRow.find("td:eq(4)").html(publicYnInfo);
			newRow.find("td:eq(5)").html(resultList[i].regNm);
			newRow.find("td:eq(6)").html(resultList[i].regDt);
			newRow.find("td:eq(7)").html("<button class='btn-dash' onclick=\"javascript:goCategMemberDelete('"+resultList[i].appId+"');\"><mink:message code='mink.web.text.delete'/></button>");
			$("#appListTb > tbody").append(newRow); 	// body 끝에 붙여넣기
		}
		$("#updateCategOrderSpan").show(); // 순서저장 버튼 보임
	} else {	// 결과 목록이 없을 경우
		var emptyRow = "<tr><td colspan='8' align='center'><mink:message code='mink.web.text.noexist.result'/></td></tr>";
		$("#appListTb > tbody").append(emptyRow);
		$("#updateCategOrderSpan").hide(); // 순서저장 버튼 숨김
	}

	// 페이징 조건 재설정 후 페이징 html 생성
	$("input[name='pageNum']").val(data.search.currentPage);	// 상세조회 key
	showPageHtml2(data, $("#paginateDiv2"), "goAppMemberList");
	
	// 상세정보 있을경우
	if( data.categMember != null ) {
		//fnVersionDetailMcateging(data.categMember); // 상세정보 매핑
		checkedTrCheckbox($("#listTr"+data.categMember.categId+data.categMember.appId)); // 선택한 tr 의 checkbox 에 체크선택/css 변경
	} else {
		$("#categMemberDetailDiv").hide();
	}
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

// 상세조회호출(ajax)
function goCategMemberDetail(appId) {
	checkedTrCheckbox($("#listTr"+appId));	// 선택된 row 색깔변경
	$("#searchFrm2").find("input[name='appId']").val(appId); // (선택한)상세
	ajaxComm('appDetail.miaps?', $('#searchFrm2'), function(data){
		fnAppDetailMapping(data.app); // 상세 ajax 세부작업
	});
}

//ajax 로 가져온 data 를 알맞은 위치에 삽입
function fnAppDetailMapping(result) {
	$("#appDetailDiv").show();
	// 상세화면 정보 출력
	var frm = $("#appDetailFrm");
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
	frm.find("input[name='emailAddr']").val(result.emailAddr);
	frm.find("input[name='phoneNo']").val(result.phoneNo);
	frm.find("input[name='regNm']").val(result.regNm);
	frm.find("input[name='regDt']").val(result.regDt);
	
	// 하위목록 key setting
	$("#searchFrm2").find("input[name='appId']").val(result.appId); 
	
	// 스크롤 아래로 이동
	//goToBottomPage(document);
}

// 등록(ajax) 후 목록 호출
function goInsert() {
	if(validation($("#insertFrm"))) return; // 입력 값 검증

	if(!confirm("<mink:message code='mink.message.would_you_register'/>")) return;

    ajaxFileComm('appCategoryInsert.miaps?', $("#insertFrm"), function(data){
    	$("#SearchFrm").find("input[name='categId']").val(data.categ.categId); // (등록한)상세
    	$("#SearchFrm").find("input[name='serchKey']").val('');
    	$("#SearchFrm").find("input[name='serchValue']").val('');
		goList('1'); // 목록/검색(1 페이지로 초기화)
		
		$('#insertCategoryDialog').dialog('close');
    });

}


// 수정(ajax) 후 목록 호출
function goUpdate() {
	if(validation($("#detailFrm"))) return; // 입력 값 검증

	if(!confirm("<mink:message code='mink.message.would_you_save'/>")) return;

	ajaxFileComm('appCategoryUpdate.miaps?', $("#detailFrm"), function(data){
    	resultMsg(data.msg);
		$("#SearchFrm").find("input[name='categId']").val(data.categ.categId);	// 상세조회 key
		$("#SearchFrm").find("input[name='serchKey']").val('');
    	$("#SearchFrm").find("input[name='serchValue']").val('');
		goList($("#SearchFrm").find("input[name='pageNum']").val()); // 목록/검색
    });

}

// 삭제(ajax) 후 목록 호출
function goDelete() {
	if(!confirm("<mink:message code='mink.message.is_delete'/>")) return;
	
	ajaxComm('appCategoryDelete.miaps?', $('#detailFrm'), function(data){
		resultMsg(data.msg);
		$("#SearchFrm").find("input[name='categId']").val(data.categ.categId); // (삭제한)상세 비움
		$("#SearchFrm").find("input[name='serchKey']").val('');
    	$("#SearchFrm").find("input[name='serchValue']").val('');
		goList($("#SearchFrm").find("input[name='pageNum']").val()); // 목록/검색
	});
}

//여러개 삭제요청(ajax)
function goDeleteAll() {
	
	// 검증
	if($("#listTbody").find(":checkbox:checked").length < 1) {
		alert("<mink:message code='mink.message.select_delete_things'/>");
		return;
	}
	if( !confirm("<mink:message code='mink.message.is_delete'/>") ) return;
	ajaxComm('appCategoryDelete.miaps?', $('#SearchFrm'), function(data){
		resultMsg(data.msg);
		//document.SearchFrm.categId.value = ''; 
		$("#SearchFrm").find("input[name='categId']").val(''); // (삭제한)상세 비움
		goList($("#SearchFrm").find("input[name='pageNum']").val()); // 목록/검색
	});

}

//입력 값 검증
function validation(frm) {
	var result = false;
	
	if( frm.find("input[name='categNm']").val()=="" ) {
		alert("<mink:message code='mink.message.input_category_name'/>");
		frm.find("input[name='categNm']").focus();
		return true;
	}

	return result;
}

// 앱 목록 팝업 오픈
function selectAppList() {
	//window.open('${contextURL}/asvc/app/appListView.miaps?isPopup=Y&noshow=P&categId='+$("#searchFrm2").find("input[name='categId']").val(),'miaps앱관리','width=610,height=780,scrollbars=yes,resizable=yes');
	
	var params = {
			"isPopup" : "Y",
			"noshow" : "P",
			"categId" : defenceXSS($("#searchFrm2").find("input[name='categId']").val()),
			"pageNum" : defenceXSS($("#searchFrm2").find("input[name='pageNum']").val()),
			"searchKey" : defenceXSS($("#SearchFrm4appListDialog").find("input[name='searchKey']").val()),
			"searchValue" : defenceXSS($("#SearchFrm4appListDialog").find("input[name='searchValue']").val())
	}
	
	$.ajax({
		url : "appListViewJSON.miaps?",
		data : params,
		success : function(data) {
			setTbodyList(data.appList, data.search.categId);
			$("#appListViewDialog").dialog("open");
		}
	});
}

// 카테고리 멤버 앱 순서 수정
function goCategMemberUpdate() {
	ajaxComm('appCategoryMemberUpdate.miaps?', $('#appListFrm'), function(data){
		resultMsg(data.msg);
		goAppMemberList("1");
	});
}

// 카테고리 멤버 앱 삭제
function goCategMemberDelete(appId) {
	if( !confirm("<mink:message code='mink.message.is_delete'/>") ) return;
	$("#searchFrm2").find("input[name='appId']").val(appId);
	ajaxComm('appCategoryMemberDelete.miaps?', $('#searchFrm2'), function(data){
		resultMsg(data.msg);
		goAppMemberList("1");
	});
}

function openInsertCategory() {
	$("#insertCategoryDialog").dialog("open");
}
</script>
</head>
<body>
	<%-- 카테고리 앱 추가 다이얼로그 --%> 
	<%@ include file="/WEB-INF/jsp/asvc/app/appListViewDialog.jsp" %>
	<%-- 카테고리 등록 다이얼로그 --%> 
	<%@ include file="/WEB-INF/jsp/asvc/app/insertCategoryDialog.jsp" %>

<div id="miaps-container">
	<div id="miaps-header">
    	<%@ include file="/WEB-INF/jsp/include/header.jsp" %>
  	</div>
  	<div id="miaps-sidebar">
		<%@ include file="/WEB-INF/jsp/include/left.jsp" %>
	</div>
	<div id="miaps-top-buttons">
		<div id="miaps-in-top-buttons-left">
			<span><button class='btn-dash' onclick="javascript:openInsertCategory();"><mink:message code='mink.web.text.regist'/></button></span>
			<span><button class='btn-dash' onclick="javascript:goDeleteAll();"><mink:message code='mink.web.text.delete'/></button></span>
		</div>
		<div id="miaps-in-top-buttons-right">
			<span><button id="updateCategOrderSpan" class='btn-dash' onclick="javascript:goCategMemberUpdate();"><mink:message code='mink.label.order_save'/></button></span>
			<span><button class='btn-dash' onclick="javascript:selectAppList();"><mink:message code='mink.label.category_app_add'/></button></span>
		</div>
	</div>
	<div id="miaps-content">
    	<div id="miaps-in-content-left" style="width: 30%; border: 0px;">
			<form id="SearchFrm" name="SearchFrm" method="post" onSubmit="return false;">
			<!-- 검색 hidden -->
			<input type="hidden" name="regNo" value="<c:out value='${loginUser.userNo}'/>"/>	<!-- 로그인한 사용자 -->
			<input type="hidden" name="updNo" value="<c:out value='${loginUser.userNo}'/>"/>	<!-- 로그인한 사용자 -->
			<input type="hidden" name="categId" /><!-- 상세 -->
			<input type="hidden" name="pageNum" value="${search.currentPage}" /><!-- 현재 페이지 -->
			<!-- 검색 화면 -->
			<div>
				<table border="0" cellspacing="0" cellpadding="0" width="100%">
					<tr> 	
						<td class="search">
							<select name="searchKey">
								<option value="" ${search.searchKey == '' ? 'selected' : ''}><mink:message code='mink.label.all'/></option>
								<option value="categNm" ${search.searchKey == 'categNm' ? 'selected' : ''}><mink:message code='mink.label.category_name'/></option>
								<option value="categId" ${search.searchKey == 'categId' ? 'selected' : ''}><mink:message code='mink.label.category_id'/></option>
							</select>
							<input type="text" name="searchValue" value="<c:out value='${search.searchValue}'/>"/>
							<select name="searchPageSize">
								<option value="10" selected="selected">10<mink:message code='mink.label.line'/></option>
								<%--
								<option value="20" ${(search.searchPageSize == null || search.searchPageSize == '20') ? 'selected' : ''}>20줄</option>
								<option value="50" ${search.searchPageSize == '50' ? 'selected' : ''}>50줄</option>
								<option value="100" ${search.searchPageSize == '100' ? 'selected' : ''}>100줄</option>
								 --%>
							</select>
							<button class='btn-dash' onclick="javascript:goList('1');"><mink:message code='mink.web.text.search'/></button>
						</td>
					</tr>
				</table>
			</div>
			
			<!-- 목록 화면 -->
			<div>
				<table class="listTb" border="0" cellspacing="0" cellpadding="0" width="100%">
					<colgroup>
						<col width="10%" />
						<col width="20%" />
						<col width="50%" />
						<col width="20%" />
					</colgroup>
					<thead>
						<tr>
							<td><input type="checkbox" name="categCheckboxAll" /></td>
							<td><mink:message code='mink.label.category_id'/></td>
							<td><mink:message code='mink.label.category_name'/></td>
							<td><mink:message code='mink.label.reg_date'/></td>
						</tr>
					</thead>
					<tbody id="listTbody">
						<!-- 목록이 있을 경우 -->
						<c:forEach var="dto" items="${categList}" varStatus="i">
						<tr id="listTr${dto.categId}" onclick="javascript:goDetail('${dto.categId}');">
							<td><input type="checkbox" name="categIds" value="${dto.categId}" onclick="checkedCheckboxInTr(event)" /></td>
							<%-- <td>${search.number - i.index}</td> --%>
							<td>${dto.categId}</td>
							<td align="left"><c:out value='${dto.categNm}'/></td>
							<td>${dto.regDt}</td>
						</tr>
						</c:forEach>
					</tbody>
					<tfoot id="listTfoot">
						<!-- 목록이 없을 경우 -->
						<tr>
							<td colspan="4"><mink:message code='mink.web.text.noexist.result'/></td>
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
			</form>
			<br/>
			<div class="arrow_box">
				<table style="border:0; width:100%; margin: 5px 0 5px 0;"><tr>
					<td><span><button class='btn-dash' onclick="javascript:goUpdate();"><mink:message code='mink.label.save'/></button></span></td>
				</tr></table>
				
				<form id="detailFrm" name="detailFrm" class="detailFrm1" method="POST" onsubmit="return false;">
					<input type="hidden" name="updNo" value="<c:out value='${loginUser.userNo}'/>"/>	<!-- 로그인한 사용자 -->
					<!-- <input type="hidden" name="categId" value=""/>	key -->
					<input type="hidden" name="searchKey" value=""/>	<!-- 검색조건 -->
					<input type="hidden" name="searchValue" value=""/>	<!-- 검색조건 -->
	
					<table class="detailTb" border="0" cellspacing="0" cellpadding="0" width="100%" class="">
						<colgroup>
							<col width="22%" />
							<col width="68%" />
						</colgroup>
						<tbody>
							<tr>
								<th><mink:message code='mink.label.category_id'/></th>
								<td><input type="text" name="categId" readonly="readonly"/></td>
							</tr>
							<tr>
								<th><span class="criticalItems"><mink:message code='mink.label.category_name'/></span></th>
								<td><input type="text" name="categNm" /></td>
							</tr>
							<tr>
								<th><mink:message code='mink.label.category_desc'/></th>
								<td><input type="text" name="categDesc" /></td>
							</tr>
							<tr>
								<th><mink:message code='mink.web.text.register'/></th>
								<td><input type="text" name="regNm" readonly="readonly"/></td>
							</tr>
							<tr>
								<th style="border-bottom : 0px;"><mink:message code='mink.label.reg_date'/></th>
								<td style="border-bottom : 0px;"><input type="text" name="regDt" readonly="readonly"/></td>
							</tr>
						</tbody>
						<tfoot></tfoot>
					</table>
				</form>	<!-- detailFrm -->
				
				<form id="searchFrm2" name="searchFrm2" method="POST" onsubmit="return false;">
					<input type="hidden" name="pageNum" value="" />	<!-- 현재 페이지 -->
					<input type="hidden" name="categId" value=""/>	<!-- key -->
					<input type="hidden" name="appId" value=""/>	<!-- key -->
				</form>			
			</div>			
		</div>
		<div id="miaps-in-content-right" style="width: 68.5%;">			
			<!-- 앱목록 -->
			<div class="readonlySpace1" >
				<form id="appListFrm" name="appListFrm" method="POST" onsubmit="return false;">
					<input type="hidden" name="categId" value=""/>	<!-- key -->
					<table id="appListTb" border="0" cellspacing="0" cellpadding="0" width="100%" class="read_listTb">
						<colgroup>
							<col width="6%" />
							<col width="6%" />
							<col width="33%" />
							<col width="10%" />
							<col width="10%" />
							<col width="12%" />
							<col width="13%" />
							<col width="10%" />
						</colgroup>
						<thead>
							<tr>
								<td><mink:message code='mink.label.order'/></td>
								<td><mink:message code='mink.label.app_id'/></td>
								<td><mink:message code='mink.label.app_nm_pkgnm'/></td>
								<td><mink:message code='mink.label.platform'/></td>
								<td><mink:message code='mink.label.app_role'/></td>
								<td><mink:message code='mink.web.text.register'/></td> 
								<td><mink:message code='mink.label.reg_date'/></td>   
								<td><mink:message code='mink.web.text.delete'/></td>
							</tr>
						</thead>
						<tbody>
						</tbody>
						<tfoot>
						</tfoot>
					</table>
				</form> <!-- appListFrm -->
				<div id="paginateDiv2" class="paginateDiv"></div>						
			</div> <!-- .readonlySpace1 -->
		</div>
	</div>
	
	<div id="miaps-footer">
    	<%@ include file="/WEB-INF/jsp/include/footer.jsp" %>
  	</div>
</div>
</body>
</html>