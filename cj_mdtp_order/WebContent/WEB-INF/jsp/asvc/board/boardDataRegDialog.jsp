<%-- 게시판 상세  다이얼로그 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page session="false"%>

<%-- 푸시 업무 상세정보 다이얼로그 --%> 
<%@ include file="/WEB-INF/jsp/asvc/push/pushTaskListPopupDialog.jsp" %>

<div id="boardDataRegDialog" title="<mink:message code='mink.label.article_registration'/>" class="dlgStyle">
<div class="miaps-popup-top-buttons">
	&nbsp;
	<span><button class='btn-dash' onclick="javascript:goInsert();"><mink:message code="mink.label.save"/></button></span>
	<span><button class='btn-dash' onclick="javascript:$('#boardDataRegDialog').dialog('close');"><mink:message code="mink.label.cancel"/></button></span>
</div>
	<form id="insertFrm" name="insertFrm" method="post"
		onSubmit="return false;">
		<input type="hidden" name="regNo" value="${loginUser.userNo}" />
		<!-- 로그인한 사용자 -->
		<input type="hidden" name="boardId" value="${board.boardId}" />
		<!-- 글 등록할 게시판 -->
		<input type="hidden" name="searchApp" value="" />
		<!-- 검색조건 -->
		<input type="hidden" name="searchSeparator" value="" />
		<!-- 검색조건 -->
		<input type="hidden" name="searchKey" value="" />
		<!-- 검색조건 -->
		<input type="hidden" name="searchValue" value="" />
		<!-- 검색조건 -->

		<table class="insertTb" border="0" cellspacing="0" cellpadding="0"
			width="100%">
			<colgroup>
				<col width="10%" />
				<col width="40%" />
				<col width="10%" />
				<col width="40%" />
			</colgroup>
			<tbody>
				<tr>
					<th><span class="criticalItems"><mink:message code="mink.label.app_nm_pkgnm"/></span></th>
					<td colspan="3">
						<select name="packageNm">
							<c:forEach var="searchApp" items="${search.packageNmList}">
								<option value="<c:out value="${searchApp.packageNm}"/>"><c:out
										value="${searchApp.appNm}" /></option>
							</c:forEach>
						</select> <span id="idShowPackageNms"></span></td>
					</tr>
				<tr>
					<th><span class="criticalItems"><mink:message code="mink.label.devision"/></span></th>
					<td><select class="selectSpace" name="separationCd">
							<c:forEach var="spDto" items="${search.boardSeparateList}"
								varStatus="i">
								<option value="${spDto.cdGrpId}${spDto.cdDtlId}">${spDto.cdDtlNm}</option>
							</c:forEach>
					</select></td>
					<th><mink:message code="mink.label.post_period"/></th>
					<td>
						<input type="text" name="startDt" class="datepicker" style="width: 120px;" />
						~ <input type="text" name="endDt" class="datepicker" style="width: 120px;" />
						<input type="hidden" name="startHh" value="00" />
						<input type="hidden" name="startMm" value="00" />
						<input type="hidden" name="endHh" value="23" />
						<input type="hidden" name="endMm" value="59" />
					</td>
				</tr>
				<tr>
					<th><mink:message code="mink.label.select_push_task"/></th>
					<td colspan="3">
						<button class='btn-dash'
							onclick="javascript:selectTask('insertFrm')"><mink:message code="mink.label.select_task"/></button>
						<button class='btn-dash' onclick="javascript:deleteAllTaskIds()"><mink:message code="mink.label.delete_task"/></button>
						<span id="taskIdPos"></span>
						<input type='hidden' id='taskIdSetYn' value='N' />
						
					</td>
				</tr>
				<tr>
					<th><mink:message code="mink.label.push_message"/></th>
					<td colspan="3"><input type="text" name="pushMsg" size="30" /></td>
				</tr>
				<tr>
					<th><span class="criticalItems"><mink:message code="mink.label.subject"/></span></th>
					<td colspan="3"><input type="text" name="subject" size="30" /></td>
				</tr>
				<tr>
					<th colspan="4">
						<!-- <textarea name="contents" id="contents" rows="10" cols="100"></textarea> -->
						<textarea name="contents" id="contents_insert" rows="10" cols="100"></textarea>
					</th>
				</tr>
			</tbody>
			<tfoot></tfoot>
		</table>
	</form>
</div>

<script type="text/javascript">
<%-- 업무관리 팝업 오픈 --%>
function selectTask(taskIdsLoc) {
	var frm = $("#" + taskIdsLoc);
	var selPackageNm = frm.find("select[name='packageNm']").val(); // 선택한 패키지명을 파라메터로 전달
	
	$.post("${contextURL}/asvc/push/pushTaskListView2.miaps?", {'isPopup':'Y', 'taskIdsLoc':taskIdsLoc, 'searchKey':'packageNm', 'searchValue':selPackageNm}, callbackTaskListPopup, 'json'); // callbackTaskListPopup in pushTaskListPopupDialog.jsp
}

<%-- 업무삭제 --%>
function deleteAllTaskIds() {
	$("#taskIdPos").html("");
	$("#packageNm").html("");
	$("#taskIdSetYn").val("N");
}

// 게시글 등록창
function showInsert_Borad() {
	$("#boardDataRegDialog").dialog("open");
	$('#insertFrm')[0].reset();
	// form 초기화 
	resizeEditor('contents_insert');
	//nseFocus("insertFrm");

	// 디폴트 게시 기간 설정
	var today = getToday();
	var nextYear = (parseInt(today.substring(0, 4)) + 1) + "-" + today.substring(5, 7) + "-" + today.substring(8, 10);
	$('#insertFrm').find("input[name='startDt']").val(today); // 시작일(오늘)
	$('#insertFrm').find("input[name='endDt']").val(nextYear); // 종료일(일년 후)
}

//등록(ajax) 후 목록 호출
function goInsert() {
	if (validation("insertFrm"))
		return;
	if (!confirm("<mink:message code='mink.message.would_you_register'/>"))
		return;

	ajaxComm(
			'boardDataInsert.miaps?',
			$('#insertFrm'),
			function(data) {
				if (data.msg == "NO_USER_TO_SEND_PUSH") {
					alert("<mink:message code='mink.message.fail_reg_push_no_receiver'/>");
				}

				$("#SearchFrm").find("input[name='contentNo']").val(
						data.boardData.contentNo); // (등록한)상세
				goList('1'); // 목록/검색(1 페이지로 초기화)
			});
}

// 게시글 등록 상세
$("#boardDataRegDialog").dialog({
	autoOpen : false,
	resizable : true,
	width : 'auto',
	/*height: 900,*/
	modal : true,	
	// add a close listener to prevent adding multiple divs to the document
	close : function(event, ui) {
		// remove div with all data and events
		$(this).dialog("close");
	}
});
</script>