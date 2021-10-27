<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="org.springframework.web.bind.annotation.SessionAttributes"%>
<%@ page import="com.thinkm.mink.commons.util.MinkConfig" %>
<%
	/*
	 * 환경설정 - 코드 그룹 화면 (settingCodeGroupView.jsp)
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
<title><mink:message code="mink.label.page_title"/></title>

<script type="text/javascript">
$(document).ready(function() {
	<%-- accordion 선택 페이지를 유지하기위한 설정값 셋팅 ex) home:0 user:1, role:2 device:3, app:4, push:5, board:6, mail:7, setting:8 --%>
	if('${loginUser.menuListString}' == '') init_accordion(8);
	else init_accordion('setting', '${loginUser.menuListString}');
	init();
	
	showList(); <%-- 목록 보이기 --%>
	showPageHtml();
	
	$("#topMenuTile").html("<mink:message code='mink.web.text.setting_codegroup'/>");
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
	document.SearchFrm.action = 'settingCodeGroupListView.miaps?';
	document.SearchFrm.submit();
}

<%-- code group detail --%>
function goDetail(cdGrpId) {
	checkedTrCheckbox($("#listTr"+cdGrpId));						<%-- 선택된 row 색깔변경 --%>
	$("#detailFrm").find("input[name='cdGrpId']").val(cdGrpId); <%-- (선택한)상세 --%>
	
	ajaxComm('settingCodeGroup.miaps?', $('#detailFrm'), function(data){
		fnSetCodeGroupDetail(data.codeGroup); <%-- 상세 ajax 세부작업 --%>
		/* showDetail(); */
		});
}
<%-- code group detail로 가져온 값을 세팅 --%>
function fnSetCodeGroupDetail(result) {
	$("#settingCodeGroupModiDialog").dialog( "open" );
	
	var frm = $("#detailFrm");
	frm.find("input[name='cdGrpId']").val(result.cdGrpId);
	frm.find("input[name='cdGrpNm']").val(result.cdGrpNm);
	frm.find("input[name='orderSeq']").val(result.orderSeq);
	frm.find("input:radio[name='systemYn'][value='" + result.systemYn + "']").prop('checked', true); <%-- //.attr("checked", "true"); --%>
	frm.find("textarea[name='cdGrpDesc']").val(result.cdDtlDesc);
}

function onfocusCdGrpId(obj) {
	obj.value = '';
}

function onfocusoutCdGrpId(obj) {
	if(obj.value == null || obj.value == '') {
		obj.value = '<mink:message code="mink.web.text.3numchar"/>';
	}
}

<%-- 여러개 삭제요청(ajax) --%>
function goDeleteAll() {
	<%-- 검증 --%>
	if($("#listTbody").find(":checkbox:checked").length < 1) {
		alert("<mink:message code='mink.web.alert.select.deleteitem'/>");
		return;
	}
	if( !confirm("<mink:message code='mink.web.alert.is.delete'/>") ) return;
	ajaxComm('settingCodeGroupDelete.miaps?', $('#SearchFrm'), function(data){
		resultMsg(data.msg);
		document.SearchFrm.cdGrpId.value = ''; <%-- (삭제한)상세 비움 --%>
		goList('1'); <%-- 목록/검색 --%>
	});
}

</script>
</head>
<body>
<!-- 코드 그룹 관리 등록 다이얼로그 -->
<%@ include file="/WEB-INF/jsp/asvc/setting/settingCodeGroupRegDialog.jsp" %>
<%@ include file="/WEB-INF/jsp/asvc/setting/settingCodeGroupModiDialog.jsp" %>

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
		<span><button class='btn-dash' onclick="javascript:openSettingCodeGroupRegDialog();"><mink:message code="mink.web.text.regist"/></button></span>
		<span><button class='btn-dash' onclick="javascript:goDeleteAll();"><mink:message code="mink.web.text.delete"/></button></span>
	</div>

	<%-- 본문 --%>
	<div id="miaps-content">
		<form id="SearchFrm" name="SearchFrm" method="post" onSubmit="return false;">
			<%-- 검색 hidden --%>
			<input type="hidden" name="regNo" value="${loginUser.userNo}"/>	<%-- 로그인한 사용자 --%>
			<input type="hidden" name="updNo" value="${loginUser.userNo}"/>	<%-- 로그인한 사용자 --%>
			<input type="hidden" name="cdGrpId" /><%-- 상세 --%>
			<input type="hidden" name="pageNum" value="${search.currentPage}" /><%-- 현재 페이지 --%>
			
			<%-- 검색 화면 --%>
			<div>
				<table border="0" cellspacing="0" cellpadding="0" width="100%">
					<tr>
						<td class="search">
							<select name="searchKey">
								<option value="" ${search.searchKey == '' ? '' : ''}><mink:message code="mink.web.text.full.all"/></option>
								<option value="cdGrpId" ${search.searchKey == 'cdGrpId' ? 'selected' : ''}><mink:message code="mink.web.text.codegroupid"/></option>
								<option value="cdGrpNm" ${search.searchKey == 'cdGrpNm' ? 'selected' : ''}><mink:message code="mink.web.text.codegroupname"/></option>						
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
						<col width="30%" />
						<col width="30%" />
						<col width="10%" />
						<col width="10%" />
						<col width="17%" />
					</colgroup>
					<thead>
						<tr>
							<td><input type="checkbox" name="appCheckboxAll" /></td>
							<td><mink:message code="mink.web.text.codegroupid"/></td>
							<td><mink:message code="mink.web.text.codegroupname"/></td>
							<td><mink:message code="mink.web.text.sequence"/></td>
							<td><mink:message code="mink.text.classification"/></td>
							<td><mink:message code="mink.web.text.regdate"/></td>
						</tr>
					</thead>
					<tbody id="listTbody">
						<%-- 목록이 있을 경우 --%>
						<c:forEach var="dto" items="${cdGrpList}" varStatus="i">
						<tr id="listTr${dto.cdGrpId}" onclick="javascript:goDetail('${dto.cdGrpId}');">
							<td><input type="checkbox" name="cdGrpIds" value="${dto.cdGrpId}" onclick="checkedCheckboxInTr(event)" /></td>
							<td align="left">${dto.cdGrpId}</td>
							<td align="left"><c:out value='${dto.cdGrpNm}'/></td>
							<td align="center">${dto.orderSeq}</td>
							<td align="center">								
								<c:choose>
									<c:when test="${dto.systemYn=='Y'}"><mink:message code="mink.web.text.forsystem"/></c:when>
									<c:when test="${dto.systemYn=='N'}"><mink:message code="mink.web.text.public"/></c:when>
									<c:otherwise>${dto.systemYn}</c:otherwise>
								</c:choose>
							</td>
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
	</div>	<%-- END searchDivFrm --%>

	<%-- footer --%>
	<div id="miaps-footer">
		<%@ include file="/WEB-INF/jsp/include/footer.jsp" %>
	</div>
</div>

</body>
</html>
