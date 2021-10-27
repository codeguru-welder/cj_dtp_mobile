<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="org.springframework.web.bind.annotation.SessionAttributes"%>
<%@ page import="com.thinkm.mink.commons.util.MinkConfig" %>
<%
	/*
	 * 푸시 업무관리 화면 - 목록 및 등록/수정/삭제 (pushTaskListView.jsp)
	 * 
	 * @author juni
	 * @since 2014.03.12
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
	init_accordion('push', '${loginUser.menuListString}');
	$("#topMenuTile").html("<mink:message code='mink.web.text.pushmanage_pushtask'/>");
	
	init(); // 이벤트 핸들러 세팅
	
	showList(); // 목록 보이기
	showPageHtml(); // 페이징 html 생성

	// 등록 및 수정 시 검색조건 셋팅
	$("input[name='searchKey']").val("<c:out value='${search.searchKey}'/>");
	$("input[name='searchValue']").val("<c:out value='${search.searchValue}'/>");
	
	if(eval('${!empty pushTask}')) {
		<%-- var dto = eval("("+'${pushTask}'+")"); --%>
		<%
		String _strJson = "";
		if (request.getAttribute("pushTask") instanceof PushTask) {
		%>
			var dto = eval("("+'${pushTask}'+")");
		<%
		} else if (request.getAttribute("pushTask") instanceof String) {
			_strJson = (String) request.getAttribute("pushTask");
			if (_strJson != null && _strJson.length() > 0) {
				_strJson = _strJson.replace("/", "\\/");
			}%>
			var dto = <%=_strJson%>;
		<%}%>
		
		fnDetailProcess(dto); // 상세정보 매핑
		checkedTrCheckbox($("#listTr"+dto.taskId)); // 선택한 tr 의 checkbox 에 체크선택/css 변경
	}
});

//ajax 로 가져온 data 를 알맞은 위치에 삽입
function fnAjaxInfoMapping(result) {
	// 상세화면 정보 출력
	var frm = $("#detailDialogFrm");
	frm.find("input[name='taskId']").val(result.taskId);
	frm.find("input[name='taskNm']").val(result.taskNm);
	frm.find("input[name='taskDesc']").val(result.taskDesc);
	frm.find(":input[name='packageNm']").each(function(){
		this.value = result.packageNm;
	});
	frm.find("input[name='taskUrl']").val(result.taskUrl);
	frm.find("input[name='regDt']").val(result.regDt);
	frm.find("input[name='updDt']").val(result.updDt);
}

// 목록검색
function goList(pageNum) {
	<%-- XSS 방어 --%>
	var _searchVal = defenceXSS(document.SearchFrm.searchValue.value); 
	document.SearchFrm.searchValue.value = _searchVal;
	
	document.SearchFrm.pageNum.value = pageNum; // 이동할 페이지
	document.SearchFrm.action = 'pushTaskListView.miaps?';
	document.SearchFrm.submit();
}

//입력 값 검증
function validation(frm) {
	var result = false;
	
	if( frm.find("input[name='taskNm']").val()=="" ) {
		alert("<mink:message code='mink.web.text.input.taskname'/>");
		frm.find("input[name='taskNm']").focus();
		return true;
	}
	if( frm.find("option:selected", ":input[name='packageNm']").val()=="" ) {
		alert("<mink:message code='mink.web.alert.apppackagename'/>");
		return true;
	}
	
	return result;
}

// 상세조회호출(ajax)
function goDetail(taskId) {
	checkedTrCheckbox($("#listTr"+taskId));	// 선택된 row 색깔변경
	$("#detailDialogFrm").find("input[name='taskId']").val(taskId); // (선택한)상세
	ajaxComm('pushTaskDetail.miaps?', $('#detailDialogFrm'),callbackDetail); // callbackDetail in pushTaskListDetailDialog.jsp 
	
}

// 삭제(ajax) 후 목록 호출
function goDelete() {
	if(!confirm("<mink:message code='mink.web.alert.is.delete'/>")) return;
	
	ajaxComm('pushTaskDelete.miaps?', $('#detailFrm'), function(data){
		resultMsg(data.msg);
		$("#SearchFrm").find("input[name='taskId']").val(data.pushTask.taskId); // (삭제한)상세 비움
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
	ajaxComm('pushTaskDelete.miaps?', $('#SearchFrm'), function(data){
		resultMsg(data.msg);
		document.SearchFrm.taskId.value = ''; // (삭제한)상세 비움
		goList($("#SearchFrm").find("input[name='pageNum']").val()); // 목록/검색
	});
}

/* 푸시 업무등록 */
function popupInsert() {
	$("#pushTaskInsertDialog").dialog( "open" );	//pushTaskInsertDialog.jsp
}


</script>

</head>
<body>
	<%-- 푸시 업무 등록 다이얼로그 --%> 
	<%@ include file="/WEB-INF/jsp/asvc/push/pushTaskInsertDialog.jsp" %>
	<%-- 푸시 업무 상세정보 다이얼로그 --%> 
	<%@ include file="/WEB-INF/jsp/asvc/push/pushTaskListDetailDialog.jsp" %>
	
	<div id="miaps-container">
		<div id="miaps-header">
	    	<%@ include file="/WEB-INF/jsp/include/header.jsp" %>
	  	</div>
	  	<div id="miaps-sidebar">
			<%@ include file="/WEB-INF/jsp/include/left.jsp" %>
		</div>
		<div id="miaps-top-buttons">
			<span><button class='btn-dash' onclick="javascript:popupInsert();"><mink:message code="mink.web.text.regist"/></button></span>
			<span><button class='btn-dash' onclick="javascript:goDeleteAll();"><mink:message code="mink.web.text.delete"/></button></span>
		</div>
		<div id="miaps-content">
			<form id="SearchFrm" name="SearchFrm" method="post" onSubmit="return false;">
				<!-- 검색 hidden -->
				<input type="hidden" name="regNo" value="${loginUser.userNo}"/>	<!-- 로그인한 사용자 -->
				<input type="hidden" name="updNo" value="${loginUser.userNo}"/>	<!-- 로그인한 사용자 -->
				<input type="hidden" name="taskId" /><!-- 상세 -->
				<input type="hidden" name="pageNum" value="${search.currentPage}" /><!-- 현재 페이지 -->
				<!-- 검색 화면 -->
				<div>
					<table border="0" cellspacing="0" cellpadding="0" width="100%">
						<tr> 	
							<td class="search">
								<select name="searchKey">
									<option value="" ${search.searchKey == '' ? 'selected' : ''}><mink:message code="mink.web.text.full.all"/></option>
									<option value="taskId" ${search.searchKey == 'taskId' ? 'selected' : ''}><mink:message code="mink.web.text.bizid"/></option>
									<option value="taskNm" ${search.searchKey == 'taskNm' ? 'selected' : ''}><mink:message code="mink.web.text.taskname"/></option>
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

				<!-- 목록 화면 -->
				<div>
					<table class="listTb" border="0" cellspacing="0" cellpadding="0" width="100%">
						<colgroup>
							<col width="6%" />
							<!-- <col width="10%" /> -->
							<col width="10%" />
							<col width="34%" />
							<col width="30%" />
							<!-- <col width="20%" /> -->
							<col width="20%" />
							<!-- <col width="10%" /> -->
						</colgroup>
						<thead>
							<tr>
								<td><input type="checkbox" name="pushTaskCheckboxAll" /></td>
								<!-- <td>순번</td> -->
								<td><mink:message code="mink.web.text.bizid"/></td>
								<td><mink:message code="mink.web.text.taskname"/></td>
								<td><mink:message code="mink.web.text.full.packagename"/></td>
								<!-- <td>내용</td> -->
								<td><mink:message code="mink.web.text.regdate"/></td>
								<!-- <td>수정일</td> -->
							</tr>
						</thead>
						<tbody id="listTbody">
							<!-- 목록이 있을 경우 -->
							<c:forEach var="dto" items="${pushTaskList}" varStatus="i">
							<tr id="listTr${dto.taskId}" onclick="javascript:goDetail('${dto.taskId}');">
								<td><input type="checkbox" name="taskIds" value="${dto.taskId}" onclick="checkedCheckboxInTr(event)"/></td>
								<%-- <td>${search.number - i.index}</td> --%>
								<td>${dto.taskId}</td>
								<td align="left"><c:out value='${dto.taskNm}'/></td>
								<td align="left">
									<c:set var="dtoAppNm" value="<c:out value='${dto.packageNm}'/>" />
									<c:forEach var="appInfo2" items="${packageNms}">
										<c:if test="${appInfo2.packageNm == dto.packageNm}">
											<c:set var="dtoAppNm" value="${appInfo2.appNm}" />
										</c:if>
									</c:forEach>
									<c:out value='${dtoAppNm}'/>
								</td>
								<%-- <td>${dto.taskDesc}</td> --%>
								<td>${dto.regDt}</td>
								<%-- <td>${dto.updDt}</td> --%>
							</tr>
							</c:forEach>
						</tbody>
						<tfoot id="listTfoot">
							<!-- 목록이 없을 경우 -->
							<tr>
								<td colspan="7"><mink:message code="mink.web.text.noexist.result"/></td>
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
			</form>
		</div>
		<!-- footer -->
		<div id="miaps-footer">
			<%@ include file="/WEB-INF/jsp/include/footer.jsp" %>
		</div>	
	</div>
</body>
</html>