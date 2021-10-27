<%-- 게시판 상세  다이얼로그 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page session="false"%>


<div id="boardDataDetailDialog" title="<mink:message code='mink.label.board_detail'/>" class="dlgStyle">
<div class="miaps-popup-top-buttons">
	&nbsp;
	<span><button class='btn-dash' onclick="javascript:goReSendPush();" id="btnReSendPush" style="display: block;"><mink:message code="mink.label.request_repeat_push"/></button></span>
	<span><button class='btn-dash' onclick="javascript:goUpdate();"><mink:message code="mink.label.modified"/></button></span>
	<span><button class='btn-dash' onclick="javascript:$('#boardDataDetailDialog').dialog('close');"><mink:message code="mink.label.cancel"/></button></span>
</div>
	<form id="detailFrm" name="detailFrm" method="post"
		onSubmit="return false;">
		<input type="hidden" name="updNo" value="${loginUser.userNo}" />
		<!-- 로그인한 사용자 -->
		<input type="hidden" name="contentNo" value="" />
		<!-- key -->
		<input type="hidden" name="searchApp" value="" />
		<!-- 검색조건 -->
		<input type="hidden" name="searchSeparator" value="" />
		<!-- 검색조건 -->
		<input type="hidden" name="searchKey" value="" />
		<!-- 검색조건 -->
		<input type="hidden" name="searchValue" value="" />
		<!-- 검색조건 -->
		<table class="detailTb" border="0" cellspacing="0" cellpadding="0"
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
						<select name="tmpPackageNm">
							<c:forEach var="searchApp" items="${search.packageNmList}">
								<option value="<c:out value="${searchApp.packageNm}"/>"
									disabled="disabled"><c:out value="${searchApp.appNm}" /></option>
							</c:forEach>
						</select>
						<input type="hidden" name="packageNm" />
						<span id="idShowPackageNms"></span>
					</td>
				</tr>
				<tr>
					<th><span class="criticalItems"><mink:message code="mink.label.devision"/></span></th>
					<td><select class="selectSpace" name="separationCd">
							<c:forEach var="spDto" items="${search.boardSeparateList}"
								varStatus="i">
								<option value="${spDto.cdGrpId}${spDto.cdDtlId}"
									disabled="disabled">${spDto.cdDtlNm}</option>
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
					<td colspan="3"><input type="text" name="taskNm" size="30"
						readonly="readonly" /> <input type="hidden" name="taskIds" /> <input
						type='hidden' id='taskIdSetYn' name="taskIdSetYn" value='N' /> <input
						type='hidden' name="pushId" /></td>
				</tr>
				<tr>
					<th><mink:message code="mink.label.push_message"/></th>
					<td colspan="3"><input type="text" name="pushMsg" size="30"
						readonly="readonly" /></td>
				</tr>
				<tr>
					<th><span class="criticalItems"><mink:message code="mink.label.subject"/></span></th>
					<td colspan="3"><input type="text" name="subject" size="30" /></td>
				</tr>
				<tr>
					<th colspan="4"><textarea name="contents" id="contents_detail"
							rows="10" cols="100"></textarea></th>
				</tr>
			</tbody>
			<tfoot></tfoot>
		</table>		
	</form>
</div>

<script type="text/javascript">
	
<%-- //게시글 상세 가기
 function goDetail(contentNo) {
		checkedTrCheckbox($("#listTr"+contentNo));	// 선택된 row 색깔변경
		$("#detailFrm").find("input[name='contentNo']").val(contentNo); // (선택한)상세
		ajaxComm('boardDataDetail.miaps?', $('#detailFrm'), function(data){
			fnDetailProcess_Borad(data.boardData);
			푸시 재전송 버튼 표시/비표시
			var tmpTaskIdSet = $("#detailFrm").find("input[name='taskIdSetYn']").val();
			if (tmpTaskIdSet == 'N') {
				$("#btnReSendPush").css("display", "none");
			} else {
				
				$("#btnReSendPush").removeAttr("style");
			}
		});
		 $("#boardDataDetailDialog").dialog( "open" );  
	}
 --%>
// 게시글 상세 조회
function showDetail_Borad() {
	$("#boardDataDetailDialog").dialog("open");		
	resizeEditor('contents_detail');
}

function fnAjaxInfoMapping(result) {

	// 상세화면 정보 출력
	var frm = $("#detailFrm");
	frm.find("input[name='contentNo']").val(result.contentNo);
	frm.find("input[name='subject']").val(result.subject);
	//frm.find("input[name='readCnt']").val(result.readCnt);
	frm.find("input[name='regNm']").val(result.regNm);
	frm.find("input[name='regDt']").val(toDateFormatString(result.regDt));
	frm.find("input[name='packageNm']").val(result.packageNm);
	frm.find("select[name='tmpPackageNm']").val(result.packageNm);
	frm.find("select[name='separationCd']").val(result.separationCd);

	frm.find("input[name='pushId']").val(result.pushId);
	frm.find("input[name='taskNm']").val(result.taskNm);
	frm.find("input[name='taskIds']").val(result.taskIds);
	frm.find("input[name='pushMsg']").val(result.pushMsg);

	if (result.taskIds != null && result.pushMsg != null) {
		frm.find("input[name='taskIdSetYn']").val("Y");
	} else {
		frm.find("input[name='taskIdSetYn']").val("N");
	}
	
	// 게시 기간
	var startDt = nvl(result.startDt);
	var startDate = "";
	var startHh = '00';
	var startMm = '00';
	if (startDt != '') {
		startDate = startDt.substring(0, 4) + "-" + startDt.substring(4, 6) + "-" + startDt.substring(6, 8);
		startHh = startDt.substring(8, 10);
		startMm = startDt.substring(10, 12);
	}
	
	var endDt = nvl(result.endDt);
	var endDate = "";
	var endHh = '23';
	var endMm = '59';
	if (endDt != '') {
		endDate = endDt.substring(0, 4) + "-" + endDt.substring(4, 6) + "-" + endDt.substring(6, 8);
		endHh = endDt.substring(8, 10);
		endMm = endDt.substring(10, 12);
	}
	
	frm.find("input[name='startDt']").val(startDate);
	frm.find("input[name='startHh']").val(startHh);
	frm.find("input[name='startMm']").val(startMm);
	frm.find("input[name='endDt']").val(endDate);
	frm.find("input[name='endHh']").val(endHh);
	frm.find("input[name='endMm']").val(endMm);

	$("#tempContents").val(result.contents);
	var crossText = $("#tempContents").val();
	var htmlText = $("#tempContents").html(crossText).text();
	oEditorsDetail.getById["contents_detail"].exec("SET_CONTENTS", [ "" ]);

	<%-- 네이버스마트에디터 내용 초기화 --%>
	oEditorsDetail.getById["contents_detail"].exec("PASTE_HTML", [ htmlText ]);
	<%-- 네이버스마트에디터 내용 붙여넣기 --%>
	//htmlEscapeAll(document); // 특수문자 전체 변환 (제목)
	//getPackageNames("detailFrm");	
}

<%-- 수정(ajax) 후 목록 호출 --%>
function goUpdate() {
	if (validation("detailFrm"))
		return;
	if (!confirm("<mink:message code='mink.message.would_you_save'/>"))
		return;

	ajaxComm('boardDataUpdate.miaps?', $('#detailFrm'), function(data) {
		resultMsg(data.msg);
		$("#SearchFrm").find("input[name='contentNo']").val(
				data.boardData.contentNo); // 상세조회 key
		goList($("#SearchFrm").find("input[name='pageNum']").val()); // 목록/검색
	});
}

<%-- 푸시 재전송 --%>
function goReSendPush() {
	if (!confirm("<mink:message code='mink.message.would_you_repeat_push'/>"))
		return;
	ajaxComm('boardReSendPushData.miaps?', $("#detailFrm"), function(data) {
		resultMsg(data.msg);
	});
}

$("#boardDataDetailDialog").dialog({
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