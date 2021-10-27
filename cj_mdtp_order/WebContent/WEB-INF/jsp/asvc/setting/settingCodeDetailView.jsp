<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="org.springframework.web.bind.annotation.SessionAttributes"%>
<%@ page import="com.thinkm.mink.commons.util.MinkConfig" %>
<%
	/*
	 * 환경설정 - 코드  화면 (settingCodeDetailView.jsp)
	 * 
	 * @author chlee
	 * @since 2015.09.18	 
	 */
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<%@ include file="/WEB-INF/jsp/include/wsACommonInclude.jsp" %>
<%@ include file="/WEB-INF/jsp/include/wsACommonHeadScript.jsp" %>

<c:set var="CODE_DETAIL_ID_TEXT" value=<mink:message code="mink.web.text.under50numchar"/> />

<title><mink:message code="mink.label.page_title"/></title>
<script type="text/javascript">
$(document).ready(function() {
	<%-- accordion 선택 페이지를 유지하기위한 설정값 셋팅 ex) home:0 user:1, role:2 device:3, app:4, push:5, board:6, mail:7, setting:8 --%>
	if('${loginUser.menuListString}' == '') init_accordion(8);
	else init_accordion('setting', '${loginUser.menuListString}');
	init();
	
	showList(); <%-- 목록 보이기 --%>
	showPageHtml();
	
	$("#topMenuTile").html('<mink:message code="mink.web.text.setting_codetail"/>');
});

function textareaResize(obj) {
	obj.style.height = "1px";
	obj.style.height = (20 + obj.scrollHeight) + "px";
}

<%-- 목록검색 --%>
function goList(pageNum) {
	<%-- XSS 방어 --%>
	var _searchVal = defenceXSS(document.SearchFrm.searchValue.value); 
	document.SearchFrm.searchValue.value = _searchVal;
	
	document.SearchFrm.pageNum.value = pageNum; <%-- 이동할 페이지 --%>
	document.SearchFrm.action = 'settingCodeDetailListView.miaps?';
	document.SearchFrm.submit();
}

<%-- code detail --%>
function goDetail(cdGrpId, cdDtlId) {
	checkedTrCheckbox($("#listTr"+cdGrpId+cdDtlId));		<%-- 선택된 row 색깔변경 --%>
	$("#detailFrm").find("input[name='cdGrpId']").val(cdGrpId); <%-- (선택한)상세 --%>
	$("#detailFrm").find("input[name='cdDtlId']").val(cdDtlId); <%-- (선택한)상세 --%>
	
	ajaxComm('settingCodeDetailContents.miaps?', $('#detailFrm'), function(data){
		fnSetCodeDetailDetail(data.codeDetail); <%-- 상세 ajax 세부작업 --%>
		 /* showDetail(); */
		});
}

<%-- code detail로 가져온 값을 세팅 --%>
function fnSetCodeDetailDetail(result) {
	$("#settingCodeDetailModiDialog").dialog( "open" );
	/* alert('test : ' + result.cdGrpId + ',' + result.cdDtlId + ',' + result.cdDtlNm); */
	var frm = $("#detailFrm");
	frm.find("select[name='cdGrpId']").val(result.cdGrpId);
	frm.find("input[name='cdDtlId']").val(result.cdDtlId);
	frm.find("input[name='cdDtlNm']").val(result.cdDtlNm);
	frm.find("input[name='orderSeq']").val(result.orderSeq);
	frm.find("textarea[name='cdDtlDesc']").val(result.cdDtlDesc);
	
}

function onfocusCdDtlId(obj) {
	obj.value = '';
}

function onfocusoutCdDtlId(obj) {
	if(obj.value == null || obj.value == '') {
		obj.value = '${CODE_DETAIL_ID_TEXT}';
	}
}

<%-- 입력 값 검증 --%>
function validation(frm) {
	if (frm.find("selectbox[name=cdGrpId]").val() == "") {
		alert('<mink:message code="mink.web.text.code.message1"/>');
		frm.find("selectbox[name='cdGrpId']").focus();
		return true;
	}
	var tmpcdDtlId = frm.find("input[name='cdDtlId']").val();
	if( tmpcdDtlId == "" || tmpcdDtlId == "${CODE_DETAIL_ID_TEXT}") {
		alert('<mink:message code="mink.web.alert.input.codeid"/>');
		frm.find("input[name='cdDtlId']").focus();
		return true;
	}
	if( frm.find("input[name='cdDtlNm']").val()=="" ) {
		alert('<mink:message code="mink.web.alert.input.codename"/>');
		frm.find("input[name='cdDtlNm']").focus();
		return true;
	}
	var tmpOrderSEQ = frm.find("input[name='orderSeq']").val();
	if( tmpOrderSEQ =="" ) {
		alert('<mink:message code="mink.web.alert.input.order"/>');
		frm.find("input[name='orderSeq']").focus();
		return true;
	}
	if( tmpOrderSEQ !="" && !$.isNumeric(tmpOrderSEQ)) {
		alert('<mink:message code="mink.web.alert.input.number"/>');
		frm.find("input[name='orderSeq']").focus();
		return true;
	}
	
	return false;
}

function goInsert() {
	if(validation($("#insertFrm"))) return; <%-- 입력 값 검증 --%>

	if(!confirm('<mink:message code="mink.web.alert.is.regist"/>') { return;}

    ajaxFileComm('settingCodeDetailInsert.miaps?', $("#insertFrm"), function(data){
    	if (data.msg == undefined) {
    		alert('<mink:message code="mink.web.text.fail.regist"/>');
    	} else {
    	$("#SearchFrm").find("input[name='cdDtlId']").val(data.codeDetail.cdDtlId); <%-- (등록한)상세 --%>
    	}
		goList('1'); <%-- 목록/검색(1 페이지로 초기화) --%>
    });
}

<%-- function goUpdate() {
	if(validation($("#detailFrm"))) return; 입력 값 검증
	
	if(!confirm("저장하시겠습니까?")) return;

	ajaxFileComm('settingCodeDetailUpdate.miaps?', $("#detailFrm"), function(data){
    	resultMsg(data.msg);
		$("#SearchFrm").find("input[name='cdDtlId']").val(data.codeDetail.cdDtlId);	상세조회 key
		goList($("#SearchFrm").find("input[name='pageNum']").val()); 목록/검색
    });
} --%>

<%-- 여러개 삭제요청(ajax) --%>
function goDeleteAll() {
	<%-- 검증 --%>
	if($("#listTbody").find(":checkbox:checked").length < 1) {
		alert('<mink:message code="mink.web.alert.select.deleteitem"/>');
		return;
	}
	if( !confirm('<mink:message code="mink.web.alert.is.delete"/>') ) return;
	ajaxComm('settingCodeDetailDelete.miaps?', $('#SearchFrm'), function(data){
		resultMsg(data.msg);
		document.SearchFrm.cdDtlId.value = ''; <%-- (삭제한)상세 비움 --%>
		goList('1'); <%-- 목록/검색 --%>
	});
}

</script>
</head>
<body>
<!-- 코드 상세 등록 다이얼로그 -->
<%@ include file="/WEB-INF/jsp/asvc/setting/settingCodeDetailRegDialog.jsp" %>
<%@ include file="/WEB-INF/jsp/asvc/setting/settingCodeDetailModiDialog.jsp" %>

<div id="miaps-container">
	<%-- 탑 메뉴 --%>
	<div id="miaps-header">
		<%@ include file="/WEB-INF/jsp/include/header.jsp" %>
	</div>

	<%-- 왼쪽 메뉴 --%>
	<div id="miaps-sidebar">
		<%@ include file="/WEB-INF/jsp/include/left.jsp" %>		
	</div>
	
	<%-- 등록, 삭제 버튼 --%>
	<div id="miaps-top-buttons">
		<span><button class='btn-dash' onclick="javascript:openSettingCodeDetailRegDialog();"><mink:message code="mink.web.text.regist"/></button></span>
		<span><button class='btn-dash' onclick="javascript:goDeleteAll();"><mink:message code="mink.web.text.delete"/></button></span>
	</div>

	<%-- 본문 --%>
	<div id="miaps-content">			
			<form id="SearchFrm" name="SearchFrm" method="post" onSubmit="return false;">
				<%-- 검색 hidden --%>
				<input type="hidden" name="regNo" value="${loginUser.userNo}"/>	<%-- 로그인한 사용자 --%>
				<input type="hidden" name="updNo" value="${loginUser.userNo}"/>	<%-- 로그인한 사용자 --%>
				<input type="hidden" name="cdDtlId" /><%-- 상세 --%>
				<input type="hidden" name="pageNum" value="${search.currentPage}" /><%-- 현재 페이지 --%>
				
				<%-- 검색 화면 --%>
				<div>
					<table border="0" cellspacing="0" cellpadding="0" width="100%">
						<tr>
							<!-- <td class="search" style="text-align:left; padding-left: 5px;">
								<button class='btn-dash' onclick="javascript:showInsert()">등록</button>
								<button class='btn-dash' onclick="javascript:goDeleteAll();">삭제</button>
							</td> -->
							<td class="search">
								<select name="searchKey">
									<option value="" ${search.searchKey == '' ? '' : ''}><mink:message code="mink.web.text.full.all"/></option>
									<option value="cdDtlId" ${search.searchKey == 'cdDtlId' ? 'selected' : ''}><mink:message code="mink.web.text.codegroupid"/></option>
									<option value="cdDtlNm" ${search.searchKey == 'cdDtlNm' ? 'selected' : ''}><mink:message code="mink.web.text.codegroupname"/></option>						
								</select>
								<input type="text" name="searchValue" value="<c:out value='${search.searchValue}'/>"/>
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
							<col width="15%" />
							<col width="20%" />
							<col width="20%" />
							<col width="20%" />
							<col width="22%" />
						</colgroup>
						<thead>
							<tr>
								<td><input type="checkbox" name="appCheckboxAll" /></td>
								<td><mink:message code="mink.web.text.codegroupname"/></td>
								<td><mink:message code="mink.web.text.codeid"/></td>
								<td><mink:message code="mink.web.text.codename"/></td>
								<td><mink:message code="mink.web.text.sequence"/></td>
								<td><mink:message code="mink.web.text.regdate"/></td>
							</tr>
						</thead>
						<tbody id="listTbody">
							<%-- 목록이 있을 경우 --%>
							<c:forEach var="dto" items="${cdDtlList}" varStatus="i">
							<tr id="listTr${dto.cdGrpId}${dto.cdDtlId}" onclick="javascript:goDetail('${dto.cdGrpId}','${dto.cdDtlId}');">
								<td><input type="checkbox" name="cdDtlIds" value="${dto.cdGrpId}${dto.cdDtlId}" onclick="checkedCheckboxInTr(event)" /></td>
								<td align="left"><c:out value='${dto.cdGrpNm}'/></td>
								<td align="left">${dto.cdDtlId}</td>
								<td align="left"><c:out value='${dto.cdDtlNm}'/></td>
								<td align="center">${dto.orderSeq}</td>
								<td>${dto.regDt}</td>
							</tr>
							</c:forEach>
						</tbody>
						<tfoot id="listTfoot">
							<tr>
								<td colspan="6"><mink:message code="mink.web.text.noexist.result"/></td>
							</tr>
						</tfoot>
					</table>
				</div>
				<br/>			
				<div id="paginateDiv" class="paginateDiv" >
					<div class="paginateDivSub">
					<%-- start paging --%>
					<%@ include file="/WEB-INF/jsp/include/pagination.jsp" %>
					<%-- end paging --%>
					</div>
				</div>
				
				<div style="padding: 10px;  background-color: white;">
					<!-- <span class='btn-dash'><button class='btn-dash' onclick="javascript:goDeleteAll();">삭제</button></span> -->
				</div>
			</form>
	<!-- </div> -->

	
		<%-- 등록화면 --%>
		<%-- <div id="insertDiv" style="display: none">
			<form id="insertFrm" name="insertFrm" method="post" class="detailFrm" onSubmit="return false;">
				<input type="hidden" name="regNo" value="${loginUser.userNo}"/>	로그인한 사용자
				<input type="hidden" name="searchKey" value=""/>	검색조건
				<input type="hidden" name="searchValue" value=""/>	검색조건
				
				<div>
					<h3><span>* 코드 등록</span></h3>
				</div>
			
				<table class="insertTb" border="1" cellspacing="0" cellpadding="0" width="100%">
					<colgroup>
						<col width="20%"/>
						<col width="30%"/>
						<col width="20%"/>
						<col width="30%"/>
					</colgroup>
					<tbody>
						<tr>
							<th><span class="criticalItems">코드 그룹 선택</span></th>
							<td>
								<select class="selectSpace" name="cdGrpId">
									<c:forEach var="cdGrpDto" items="${cdGrpSelBox}" varStatus="i">
										<option value="${cdGrpDto.cdGrpId}" >${cdGrpDto.cdGrpNm}(${cdGrpDto.cdGrpId})</option>
									</c:forEach>
								</select>
							</td>
							<th><span class="criticalItems">코드 ID</span></th>
							<td><input type="text" name="cdDtlId" maxlength="50" value="${CODE_DETAIL_ID_TEXT}" onfocus="javascript:onfocusCdDtlId(this)" onblur="javascript:onfocusoutCdDtlId(this)"/></td>
						</tr>
						<tr>
							<th><span class="criticalItems">코드 명</span></th>
							<td><input type="text" name="cdDtlNm" maxlength="50"/></td>
							<th><span class="criticalItems">순서</span></th>
							<td><input type="text" name="orderSeq" /></td>
						</tr>
						<tr>
							<th>코드 설명</th>
							<td colspan="3">
								<textarea name="cdDtlDesc" style="width:100%;overflow:visible;" onmouseup="textareaResize(this)" onkeyup="textareaResize(this)"></textarea>
							</td>
						</tr>
					</tbody>
					<tfoot></tfoot>
				</table>				
				<div class="insertBtnArea">	
					<button class='btn-dash' onclick="javascript:goInsert();">저장</button>
				</div>
			</form>
		</div> --%>
		
		<%-- 상세화면 --%>
		<%-- <div id="detailDiv" style="display: none">
			<form id="detailFrm" name="detailFrm" class="detailFrm" method="POST" onsubmit="return false;">
				<input type="hidden" name="regNo" value="${loginUser.userNo}"/>	로그인한 사용자
				<input type="hidden" name="searchKey" value=""/>	검색조건
				<input type="hidden" name="searchValue" value=""/>	검색조건
				
				<div>
					<h3><span>* 코드 상세</span></h3>
				</div>
			
				<table class="insertTb" border="1" cellspacing="0" cellpadding="0" width="100%">
					<colgroup>
						<col width="20%"/>
						<col width="30%"/>
						<col width="20%"/>
						<col width="30%"/>
					</colgroup>
					<tbody>
						<tr>
							<th><span class="criticalItems">코드 그룹 선택</span></th>
							<td>
								<select class="selectSpace" name="cdGrpId">
									<c:forEach var="cdGrpDto" items="${cdGrpSelBox}" varStatus="i">
										<option value="${cdGrpDto.cdGrpId}" >${cdGrpDto.cdGrpNm}(${cdGrpDto.cdGrpId})</option>
									</c:forEach>
								</select>
							</td>
							<th><span class="criticalItems">코드 ID</span></th>
							<td><input type="text" name="cdDtlId" /></td>
						</tr>
						<tr>
							<th><span class="criticalItems">코드 명</span></th>
							<td><input type="text" name="cdDtlNm" /></td>
							<th><span class="criticalItems">순서</span></th>
							<td><input type="text" name="orderSeq" /></td>													
						</tr>
						<tr>
							<th>코드 설명</th>
							<td colspan="3">
								<textarea name="cdDtlDesc" style="width:100%;overflow:visible;" onmouseup="textareaResize(this)" onkeyup="textareaResize(this)"></textarea>
							</td>
						</tr>
					</tbody>
					<tfoot></tfoot>
				</table>				
				<div id="updateBtnDiv" class="detailBtnArea">
						<button class='btn-dash' onclick="javascript:goUpdate()">수정</button>
				</div>				
			</form>
		</div> --%>
		
	</div>	<%-- END searchDivFrm --%>
	
	<%-- footer --%>
	<div id="miaps-footer">
		<%@ include file="/WEB-INF/jsp/include/footer.jsp" %>
	</div>
</div>

</body>
</html>
