<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="org.springframework.web.bind.annotation.SessionAttributes"%>
<%@ page import="com.thinkm.mink.commons.util.MinkConfig" %>
<%
	/*
	 * TARGET URL  관리 화면 - 목록 및 등록/수정/삭제 (targetUrlListView.jsp)
	 * 
	 * @author juni
	 * @since 2014.04.16
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
	init_accordion('setting', '${loginUser.menuListString}');
	$("#topMenuTile").html("<mink:message code='mink.web.text.setting_taskclassification'/>");
	
	init(); // 이벤트 핸들러 세팅
	
	showList(); // 목록 보이기
	showPageHtml(); // 페이징 html 생성

	if(eval('${!empty targetUrl}')) { 
		<%-- var dto = eval("("+'${targetUrl}'+")"); --%>
		<%
			String _strJson = (String) request.getAttribute("targetUrl");
			if (_strJson != null && _strJson.length() > 0) {
				_strJson = _strJson.replace("/", "\\/");
			}
		%>
		var dto = <%=_strJson%>;
		fnDetailProcess(dto); // 상세정보 매핑
		//checkedTrCheckbox($("#listTr"+dto.targetUrl)); // 선택한 tr 의 checkbox 에 체크선택/css 변경
	}
});

//ajax 로 가져온 data 를 알맞은 위치에 삽입
function fnAjaxInfoMapping(result) {
	// 상세화면 정보 출력
	var frm = $("#targetUrlListFrm");
	frm.find("input[name='targetUrl']").val(result.targetUrl);
	frm.find("input[name='urlNm']").val(result.urlNm);
}

// 목록검색
function goList(pageNum) {
	<%-- XSS 방어 --%>
	var _searchVal = defenceXSS(document.SearchFrm.searchValue.value); 
	document.SearchFrm.searchValue.value = _searchVal;
	
	document.SearchFrm.pageNum.value = pageNum; // 이동할 페이지
	document.SearchFrm.action = 'deviceTargetUrlListView.miaps?';
	document.SearchFrm.submit();
}

//입력 값 검증
function validation(frm) {
	var result = false;
	
	if( frm.find("input[name='targetUrl']").val()=="" ) {
		alert("<mink:message code='mink.web.alert.input.taskclassification'/>");
		frm.find("input[name='targetUrl']").focus();
		return true;
	}
	if( frm.find("input[name='urlNm']").val()=="" ) {
		alert("<mink:message code='mink.web.alert.input.taskclassificationname'/>");
		frm.find("input[name='urlNm']").focus();
		return true;
	}

	
	return result;
}

// 상세조회호출(ajax)
function goDetail(targetUrl) {
	checkedTrCheckbox($("#listTr"+targetUrl));	// 선택된 row 색깔변경
	$("#targetUrlListFrm").find("input[name='targetUrl']").val(targetUrl); // (선택한)상세
	ajaxComm('deviceTargetUrlDetail.miaps?', document.targetUrlListFrm, callbackTargetUrlListDialog);
	/* ajaxComm('deviceTargetUrlDetail.miaps?', $('#SearchFrm'), function(data){
		fnDetailProcess(data.targetUrl); // 상세 ajax 세부작업
	}); */
}

function showInsertFrm() {
	$("#insertTargetUrlListDialog").dialog( "open" );
}



// 등록(ajax) 후 목록 호출
function goInsert() {
	if(validation($("#insertFrm"))) return; // 입력 값 검증
	if( !goCheckUrl($('#insertFrm').find("input[name='targetUrl']").val()) ) {
		return;
	} 
	if(!confirm("<mink:message code='mink.web.alert.is.regist'/>")) return;
	ajaxComm('deviceTargetUrlInsert.miaps?', $('#insertFrm'), function(data){
		$("#SearchFrm").find("input[name='targetUrl']").val(data.targetUrl.targetUrl); // (등록한)상세
		goList('1'); // 목록/검색(1 페이지로 초기화)
	});
}

// 수정(ajax) 후 목록 호출
function goUpdate() {
	if(validation($("#detailFrm"))) return; // 입력 값 검증
	if(!confirm("<mink:message code='mink.web.alert.is.save'/>")) return;
	
	ajaxComm('deviceTargetUrlUpdate.miaps?', $('#detailFrm'), function(data){
		resultMsg(data.msg);
		$("#SearchFrm").find("input[name='targetUrl']").val(data.targetUrl.targetUrl);	// 상세조회 key
		goList($("#SearchFrm").find("input[name='pageNum']").val()); // 목록/검색
	});
}

// 삭제(ajax) 후 목록 호출
function goDelete() {
	if(!confirm("<mink:message code='mink.web.alert.is.delete'/>")) return;
	
	ajaxComm('deviceTargetUrlDelete.miaps?', $('#detailFrm'), function(data){
		resultMsg(data.msg);
		$("#SearchFrm").find("input[name='targetUrl']").val(data.targetUrl.targetUrl); // (삭제한)상세 비움
		goList($("#SearchFrm").find("input[name='pageNum']").val()); // 목록/검색
	});
}

//여러개 삭제요청(ajax)
function goDeleteAll() {
	// 검증
	if($("#listTbody").find(":checkbox:checked").length < 1) {
		alert("<mink:message code='mink.web.alert.select.deleteitem'/>");
		return;
	}
	if( !confirm("<mink:message code='mink.web.alert.is.delete'/>") ) return;
	ajaxComm('deviceTargetUrlDelete.miaps?', $('#SearchFrm'), function(data){
		resultMsg(data.msg);
		document.SearchFrm.targetUrl.value = ''; // (삭제한)상세 비움
		goList($("#SearchFrm").find("input[name='pageNum']").val()); // 목록/검색
	});

}

function goCheckUrl(targetUrl) {
	var result = true;
	$("#SearchFrm").find("input[name='targetUrl']").val(targetUrl); // (선택한)상세
	
	$.ajaxSetup({async:false}); // 비동기 옵션 끄기(ajax 동기화)
	ajaxComm('deviceTargetUrlDetail.miaps?', $('#SearchFrm'), function(data){
		if( data.targetUrl != null ) {
			alert("<mink:message code='mink.web.alert.already.targeturl'/>");
			result = false;
		} else {
			result = true;
		}
	});
	$.ajaxSetup({async:true}); // 비동기 옵션 켜기
	
	return result;
}

</script>

</head>
<body>
	<%-- 장치 상세정보 다이얼로그 --%> 
	<%@ include file="/WEB-INF/jsp/asvc/device/targetUrlListDialog.jsp" %>
	<!-- 본문 -->
	<div id="miaps-container">
		<div id="miaps-header">
	    	<%@ include file="/WEB-INF/jsp/include/header.jsp" %>
	  	</div>
	  	<div id="miaps-sidebar">
			<%@ include file="/WEB-INF/jsp/include/left.jsp" %>
		</div>
		<form id="SearchFrm" name="SearchFrm" method="post" onSubmit="return false;">
		<div id="miaps-top-buttons">
			<span><button class='btn-dash' onclick="javascript:showInsertFrm();"><mink:message code="mink.web.text.regist"/></button></span>
			<span><button class='btn-dash' onclick="javascript:goDeleteAll();"><mink:message code="mink.web.text.delete"/></button></span>
			&nbsp;
			<span style="float:right;">
				<select name="searchKey">
					<option value="" ${search.searchKey == '' ? 'selected' : ''}><mink:message code="mink.web.text.full.all"/></option>
					<option value="urlId" ${search.searchKey == 'urlId' ? 'selected' : ''}><mink:message code="mink.web.text.classification.task"/></option>
					<option value="urlNm" ${search.searchKey == 'urlNm' ? 'selected' : ''}><mink:message code="mink.web.text.classification.taskname"/></option>
				</select>
				<input type="text" name="searchValue" value="<c:out value='${search.searchValue}'/>" />
				<select name="searchPageSize">
					<option value="10" ${search.searchPageSize == '10' ? 'selected' : ''}><mink:message code="mink.web.text.rows10"/></option>
					<option value="20" ${(search.searchPageSize == null || search.searchPageSize == '20') ? 'selected' : ''}><mink:message code="mink.web.text.rows20"/></option>
					<option value="50" ${search.searchPageSize == '50' ? 'selected' : ''}><mink:message code="mink.web.text.rows50"/></option>
					<option value="100" ${search.searchPageSize == '100' ? 'selected' : ''}><mink:message code="mink.web.text.rows100"/></option>
				</select>
				<button class='btn-dash' onclick="javascript:goList('1');"><mink:message code="mink.web.text.search"/></button>
			</span>
			<span style="clear: both;"></span>
		</div>	
		<div id="miaps-content">
				<!-- 검색 hidden -->
				<input type="hidden" name="targetUrl" /><!-- 상세 -->
				<input type="hidden" name="pageNum" value="${search.currentPage}" /><!-- 현재 페이지 -->

				<!-- <div>
					<h3><span>* 업무구분 관리</span></h3>
				</div> -->

				<!-- 목록 화면 -->
				<div>
					<table class="listTb" border="0" cellspacing="0" cellpadding="0" width="100%">
						<colgroup>
							<col width="10%" />
							<col width="40%" />
							<col width="50%" />
						</colgroup>
						<thead>
							<tr>
								<td><input type="checkbox" name="targetUrlCheckboxAll" /></td>
								<!-- <td>순번</td> -->
								<td><mink:message code="mink.web.text.classification.task"/></td>
								<td><mink:message code="mink.web.text.classification.taskname"/></td>
							</tr>
						</thead>
						<tbody id="listTbody">
							<!-- 목록이 있을 경우 -->
							<c:forEach var="dto" items="${targetUrlList}" varStatus="i">
							<tr id="listTr<c:out value='${dto.targetUrl}'/>" onclick="javascript:goDetail('<c:out value='${dto.targetUrl}'/>');">
								<td><input type="checkbox" name="targetUrls" value="<c:out value='${dto.targetUrl}'/>" onclick="checkedCheckboxInTr(event)"/></td>
								<%-- <td>${search.number - i.index}</td> --%>
								<td align="left"><c:out value='${dto.targetUrl}'/></td>
								<td align="left"><c:out value='${dto.urlNm}'/></td>
							</tr>
							</c:forEach>
						</tbody>
						<tfoot id="listTfoot">
							<!-- 목록이 없을 경우 -->
							<tr>
								<td colspan="3"><mink:message code="mink.web.text.noexist.result"/></td>
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
				<div style="padding: 10px;">
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



<!-- 등록화면 -->
<!-- 	<div id="insertDiv" style="display: none">
	
		<form id="insertFrm" name="insertFrm" method="post" class="detailFrm" onSubmit="return false;">	
			<div>
				<h3><span>* 업무구분 등록</span></h3>
			</div>
	
			<table class="insertTb" border="1" cellspacing="0" cellpadding="0" width="100%">
				<colgroup>
					<col width="20%" />
					<col width="80%" />
				</colgroup>
				<tbody>
					<tr>
						<th><span class="criticalItems">업무구분</span></th>
						<td><input type="text" name="targetUrl" /></td>
					</tr>
					<tr>
						<th><span class="criticalItems">업무구분명</span></th>
						<td><input type="text" name="urlNm" /></td>		
					</tr>
				</tbody>
				<tfoot></tfoot>
			</table>
		
			<div class="insertBtnArea">
				<span><button class='btn-dash' onclick="javascript:goInsert();">저장하기</button> <button class='btn-dash' onclick="javascript:hiddenInsertDetail();">취소</button></span>
			</div>
		</form>
	</div> -->

	
		<!-- 상세화면 -->
<!-- 	<div id="detailDiv" style="display: none">
		<form id="detailFrm" name="detailFrm" method="post" class="detailFrm" onSubmit="return false;">
				
			<div>
				<h3><span>* 업무구분 상세정보</span></h3>
			</div>
			<table class="detailTb" border="1" cellspacing="0" cellpadding="0" width="100%">
				<colgroup>
					<col width="20%" />
					<col width="80%" />
				</colgroup>
				<tbody>
					<tr>
						<th><span class="criticalItems">업무구분</span></th>
						<td><input type="text" name="targetUrl" readonly="readonly"/></td>
					</tr>
					<tr>
						<th><span class="criticalItems">업무구분명</span></th>
						<td><input type="text" name="urlNm" /></td>		
					</tr>
				</tbody>
				<tfoot></tfoot>
			</table>
			
			<div class="detailBtnArea">
				<span><button class='btn-dash' onclick="javascript:goUpdate()">저장하기</button></span>
				<span><button class='btn-dash' onclick="javascript:hiddenInsertDetail();">닫기</button></span>
			</div>
		</form>
	</div> -->