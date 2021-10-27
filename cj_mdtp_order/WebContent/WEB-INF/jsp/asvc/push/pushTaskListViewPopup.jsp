<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="org.springframework.web.bind.annotation.SessionAttributes"%>
<%@ page import="com.thinkm.mink.commons.util.MinkConfig" %>
<%
	/*
	 * 푸시 업무 관리 화면 - 목록 및 등록/수정/삭제 (pushTaskListView.jsp)
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
	// accordion 선택 페이지를 유지하기위한 설정값 셋팅 ex) home:0 user:1, role:2 device:3, app:4, push:5, board:6
	//init_accordion(5);
	init_accordion('push','<%=(String) request.getAttribute("menuListString")%>');
	init(); // 이벤트 핸들러 세팅
	
	showList(); // 목록 보이기
	showPageHtml(); // 페이징 html 생성

});

//ajax 로 가져온 data 를 알맞은 위치에 삽입
function fnAjaxInfoMapping(result) {
	// 상세화면 정보 출력
	var frm = $("#detailFrm");
	frm.find("input[name='taskId']").val(result.taskId);
	frm.find("input[name='taskNm']").val(result.taskNm);
	frm.find("input[name='taskDesc']").val(result.taskDesc);
	frm.find("input[name='packageNm']").val(result.packageNm);
	frm.find("input[name='taskUrl']").val(result.taskUrl);
	frm.find("input[name='regDt']").val(result.regDt);
	frm.find("input[name='updDt']").val(result.updDt);
}

// 목록검색
function goList(pageNum) {
	document.SearchFrm.pageNum.value = pageNum; // 이동할 페이지
	document.SearchFrm.action = 'pushTaskListView.miaps?';
	document.SearchFrm.submit();
}

// 상세조회호출(ajax)
function goDetail(taskId) {
	checkedTrCheckbox($("#listTr"+taskId));	// 선택된 row 색깔변경
	$("#detailFrm").find("input[name='taskId']").val(taskId); // (선택한)상세
	ajaxComm('pushTaskDetail.miaps?', $('#detailFrm'), function(data){
		fnDetailProcess(data.pushTask); // 상세 ajax 세부작업
	});
	
	//$(document.body).scrollTop($("#push-task-pop-detail").offset().top); // 곧바로 이동
	$('body,html').animate({scrollTop: $("#push-task-pop-detail").offset().top}, 800); // 애니메이션 이동 
}

// 업무 선택
function selectTesk() {
	// 검증
	if($("#pushTaskListPopupTbody").find(":checkbox:checked").length < 1) {
		alert("<mink:message code='mink.web.alert.select.taskregist'/>");
		return;
	}

	var frm = '${taskIdsLoc}';
	$("#"+frm+" #taskIdPos", opener.document).html("");
	$("#"+frm+" #packageNm", opener.document).html("");
	
	$("#pushTaskListPopupTbody input:checked").each(function(idx, row){
		
		var curr = $(row).parents("tr");
		var taskId = $(row).val();	
		var taskNm = $(curr).find("input[name='taskNm']").val();
		var packageNm = $(curr).find("input[name='packageNm']").val();
		
		var taskStr = "&nbsp;&nbsp;- "+ taskNm + "("+taskId+")"
					+ "<input type=\"hidden\" name=\"taskIds\" value=\""+taskId+"\" /><br/>";
		$("#"+frm+" #taskIdPos", opener.document).append(taskStr);
		var packageStr = "&nbsp;&nbsp;- "+ packageNm + "&nbsp;("+taskNm+")<br/>";
		$("#"+frm+" #packageNm", opener.document).append(packageStr);
	});
	
	$("#taskIdSetYn", opener.document).val("Y");	// 푸시업무 셋팅 완료 표시
	
	self.close();
	
}

</script>

</head>
<body>

<!-- 본문 -->
<div id="taskPopup" >
	
	
	<form id="SearchFrm" name="SearchFrm" method="post" onSubmit="return false;">
	<!-- 검색 hidden -->
	<input type="hidden" name="taskId" /><!-- 상세 -->
	<input type="hidden" name="pageNum" value="${search.currentPage}" /><!-- 현재 페이지 -->
	<input type="hidden" name="isPopup" value="Y" /><!-- 팝업화면으로 이동 -->
	<!-- 검색 화면 -->
	<div>
		<table class="listTb" border="1" cellspacing="0" cellpadding="0" width="100%">
			<tr> 	
				<td class="search">
					<select name="searchKey">
						<option value="" ${search.searchKey == '' ? 'selected' : ''}><mink:message code="mink.web.text.full.all"/></option>
						<option value="taskId" ${search.searchKey == 'taskId' ? 'selected' : ''}><mink:message code="mink.web.text.bizid"/></option>
						<option value="taskNm" ${search.searchKey == 'taskNm' ? 'selected' : ''}><mink:message code="mink.web.text.taskname"/></option>
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
					<td><mink:message code="mink.web.text.apppackagename"/></td>
					<!-- <td>내용</td> -->
					<td><mink:message code="mink.web.text.regdate"/></td>
					<!-- <td>수정일</td> -->
				</tr>
			</thead>
			<tbody id="listTbody">
				<!-- 목록이 있을 경우 -->
				<c:forEach var="dto" items="${pushTaskList}" varStatus="i">
				<tr id="listTr${dto.taskId}" onclick="javascript:goDetail('${dto.taskId}');">
					<td>
						<input type="checkbox" name="taskIds" value="${dto.taskId}" onclick="checkedCheckboxInTr(event)"/>
						<input type="hidden" name="taskNm" value="${dto.taskNm}" />
						<input type="hidden" name="packageNm" value="${dto.packageNm}" />
					</td>
					<%-- <td>${search.number - i.index}</td> --%>
					<td>${dto.taskId}</td>
					<td align="left">${dto.taskNm}</td>
					<td align="left">${dto.packageNm}</td>
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
		
		<div class="searchBtnArea">
			<button class='btn-dash' onclick="javascript:selectTesk();"><mink:message code="mink.web.text.select"/></button>
			<button class='btn-dash' onclick="javascript:self.close();"><mink:message code="mink.web.text.close"/></button>
		</div>
	</div>
	
	<div id="paginateDiv" class="paginateDiv" >
		<div class="paginateDivSub">
		<!-- start paging -->
		<%@ include file="/WEB-INF/jsp/include/pagination.jsp" %>
		<!-- end paging -->
		</div>
	</div>
	
	</form>
	
	<div id="push-task-pop-detail"></div>

	<!-- 상세화면 -->
	<div id="detailDiv" style="display: none">
		<form id="detailFrm" name="detailFrm" method="post" class="detailFrm">
			<input type="hidden" name="updNo" value="${loginUser.userNo}"/>	<!-- 로그인한 사용자 -->
			<input type="hidden" name="taskId" value=""/>	<!-- key -->
			<div>
				<h3><span><mink:message code="mink.web.text.info.pushtaskdetail"/></span></h3>
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
						<th><mink:message code="mink.web.text.taskname"/></th>
						<td colspan="3"><input type="text" name="taskNm" size="20"/></td>
					</tr>
					<tr>
						<th><mink:message code="mink.web.text.apppackagename"/></th>
						<td><input type="text" name="packageNm" size="20"/></td>
						<th><mink:message code="mink.web.text.connectionurl"/></th>
						<td><input type="text" name="taskUrl" size="20"/></td>
					</tr>
					<tr>
						<th><mink:message code="mink.web.text.taskdescription"/></th>
						<td colspan="3"><input type="text" name="taskDesc" size="50" /></td>
					</tr>
					<tr>
						<th><mink:message code="mink.web.text.regdate"/></th>
						<td><input type="text" name="regDt" size="10"/></td>
						<th><mink:message code="mink.web.text.moddate"/></th>
						<td><input type="text" name="updDt" size="10"/></td>
					</tr>
				</tbody>
				<tfoot></tfoot>
			</table>
			
			<!-- <div class="detailBtnArea">
				<button class='btn-dash' onclick="javascript:hiddenInsertDetail();">닫기</button>
			</div> -->
		</form>
	</div>
	
	
</div>
	
</body>
</html>
