<%--푸시 업무관리 -> 리스트 클릭 상세정보 다이얼로그 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="false"%>
<div id="pushTaskListDetailDialog" title="<mink:message code='mink.web.text.info.pushtaskdetail'/>" class="dlgStyle">
		<div class="miaps-popup-top-buttons">
			&nbsp;
			<span><button class='btn-dash' onclick="javascript:goUpdate();"><mink:message code="mink.web.text.save"/></button></span>
			<span><button class='btn-dash' onclick="javascript:$('#pushTaskListDetailDialog').dialog('close');"><mink:message code="mink.web.text.cancel"/></button></span>
		</div>
	<!-- 상세화면 -->
		<form id="detailDialogFrm" name="detailFrm" method="post">
			<input type="hidden" name="updNo" value="${loginUser.userNo}"/>	<!-- 로그인한 사용자 -->
			<!-- <input type="hidden" name="taskId" value=""/> -->	<!-- key -->
			<input type="hidden" name="searchKey" value=""/>	<!-- 검색조건 -->
			<input type="hidden" name="searchValue" value=""/>	<!-- 검색조건 -->
			<table class="detailTb" border="0" cellspacing="0" cellpadding="0" width="100%">
				<colgroup>
					<col width="20%" />
					<col width="80%" />
				</colgroup>
				<tbody>
					<tr>
						<th><span><mink:message code="mink.web.text.bizid"/></span></th>
						<td><input type="text" name="taskId" size="20" readonly="readonly"/></td>
					</tr>
					<tr>
						<th><span class="criticalItems"><mink:message code="mink.web.text.taskname"/></span></th>
						<td><input type="text" name="taskNm" size="20"/></td>						
					</tr>
					<tr>
						<th><span class="criticalItems"><mink:message code="mink.web.text.full.packagename"/></span></th>
						<td>
							&nbsp;
							<select name="packageNm">
								<option value=""><mink:message code="mink.web.alert.choiceplease"/></option>
								<c:forEach var="appInfo" items="${packageNms}">
								<option value="<c:out value='${appInfo.packageNm}'/>"><c:out value='${appInfo.appNm}'/></option>
								</c:forEach>
							</select>
						</td>						
					</tr>
					<tr>
						<th><mink:message code="mink.web.text.connectionurl"/></th>
						<td><input type="text" name="taskUrl" size="20"/></td>
					</tr>
					<tr>
						<th><mink:message code="mink.web.text.taskdescription"/></th>
						<td colspan="3"><input type="text" name="taskDesc" size="50" /></td>
					</tr>
					<tr>
						<th><mink:message code="mink.web.text.regdate"/></th>
						<td><input type="text" name="regDt" size="10" readonly="readonly"/></td>
					</tr>
					<tr>
						<th><mink:message code="mink.web.text.moddate"/></th>
						<td><input type="text" name="updDt" size="10" readonly="readonly"/></td>
					</tr>
				</tbody>
				<tfoot></tfoot>
			</table>
			
			<!-- <div class="detailBtnArea">
				<button class='btn-dash' onclick="javascript:goUpdate()">저장하기</button>&nbsp;
				<button class='btn-dash' onclick="javascript:hiddenInsertDetail();">닫기</button>
			</div> -->
		</form>
</div>

<script type="text/javascript">

/* pushTaskListView.jsp function goDetail() 에서 callback*/
function callbackDetail(data) {
	fnDetailProcess(data.pushTask);
	$("#pushTaskListDetailDialog").dialog("open");
}

$("#pushTaskListDetailDialog").dialog({
	autoOpen: false,
	resizable: false,
	width: 'auto',
	modal: true,
	// add a close listener to prevent adding multiple divs to the document
	close: function(event, ui) {
		// remove div with all data and events
		$(this).dialog( "close" );
	}
});


//수정(ajax) 후 목록 호출
function goUpdate() {
	if(validation($("#detailDialogFrm"))) return; // 입력 값 검증
	if(!confirm("<mink:message code='mink.web.alert.is.save'/>")) return;

	ajaxComm('pushTaskUpdate.miaps?', $('#detailDialogFrm'), function(data){
		resultMsg(data.msg);
		$("#SearchFrm").find("input[name='taskId']").val(data.pushTask.taskId);	// 상세조회 key   searchFrm in pushTaskListView.jsp
		goList($("#SearchFrm").find("input[name='pageNum']").val()); // 목록/검색
	});

}

</script>