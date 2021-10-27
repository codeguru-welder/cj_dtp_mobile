<%-- 푸시 업무관리 -> [푸시업무 등록] 클릭 다이얼로그 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="false"%>
<div id="pushTaskInsertDialog" title="<mink:message code='mink.web.text.regist.pushtask'/>" class="dlgStyle">
		<div class="miaps-popup-top-buttons">
			&nbsp;
			<span><button class='btn-dash' onclick="javascript:goInsert();"><mink:message code="mink.web.text.save"/></button></span>
			<span><button class='btn-dash' onclick="javascript:$('#pushTaskInsertDialog').dialog('close');"><mink:message code="mink.web.text.cancel"/></button></span>
		</div>
	<!-- 등록화면 -->
		<form id="insertDialogFrm" name="insertFrm" method="post">
			<input type="hidden" name="regNo" value="${loginUser.userNo}"/>	<!-- 로그인한 사용자 -->
			<input type="hidden" name="searchKey" value=""/>	<!-- 검색조건 -->
			<input type="hidden" name="searchValue" value=""/>	<!-- 검색조건 -->
			<table class="insertTb" border="0" cellspacing="0" cellpadding="0" width="100%">
				<colgroup>
					<col width="20%" />
					<col width="80%" />
				</colgroup>
				<tbody>
					<tr>
						<th><span class="criticalItems"><mink:message code="mink.web.text.taskname"/></span></th>
						<td colspan="3"><input type="text" name="taskNm" size="30"/></td>
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
					<tr/>
					<tr>
						<th><mink:message code="mink.web.text.connectionurl"/></th>
						<td><input type="text" name="taskUrl" /></td>
					</tr>
					<tr>
						<th><mink:message code="mink.web.text.taskdescription"/></th>
						<td colspan="3"><input type="text" name="taskDesc" size="50"/></td>
					</tr>
				</tbody>
				<tfoot></tfoot>
			</table>
<!-- 		
			<div class="insertBtnArea">
			</div> -->
		</form>

</div>

<script type="text/javascript">
$("#pushTaskInsertDialog").dialog({
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


//등록(ajax) 후 목록 호출
function goInsert() {
	if(validation($("#insertDialogFrm"))) return; // 입력 값 검증

	if(!confirm("<mink:message code='mink.web.alert.is.regist'/>")) return;
	ajaxComm('pushTaskInsert.miaps?', $('#insertDialogFrm'), function(data){
		$("#SearchFrm").find("input[name='taskId']").val(data.pushTask.taskId); /* SearchFrm in pushTaskListView.jsp */
		goList('1'); // 목록/검색(1 페이지로 초기화)
	});
}
</script>