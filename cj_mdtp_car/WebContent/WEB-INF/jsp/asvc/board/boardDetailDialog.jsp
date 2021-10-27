<%-- 게시판 상세  다이얼로그 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page session="false"%>

<div id="boardDetail" title="<mink:message code='mink.label.board_detail'/>" class="dlgStyle">
<div class="miaps-popup-top-buttons">
	&nbsp;
	<span id="updateBtn_boardDetailDialog"><button class='btn-dash' onclick="javascript:goUpdate();"><mink:message code='mink.label.save'/></button></span>
	<span><button class='btn-dash' onclick="javascript:$('#boardDetail').dialog('close');"><mink:message code='mink.label.cancel'/></button></span>
</div>
	<!-- 상세화면  -->
	<form id="detailFrm" name="detailFrm" method="post"
		onSubmit="return false;">
		<input type="hidden" name="updNo" value="${loginUser.userNo}" />
		<!-- 로그인한 사용자 -->
		<input type="hidden" name="boardId" value="" />
		<!-- key -->
		<input type="hidden" name="searchKey" value="" />
		<!-- 검색조건 -->
		<input type="hidden" name="searchValue" value="" />
		<!-- 검색조건 -->
		<table class="detailTb" border="0" cellspacing="0" cellpadding="0"
			width="100%">
			<tbody>
				<tr>
					<th><span class="criticalItems"><mink:message code='mink.label.board_name'/></span></th>
					<td><input type="text" name="boardNm" /></td>
					<th><span class="criticalItems"><mink:message code='mink.label.board_devision_code_group'/></span></th>
					<td><select class="selectSpace" name="cdGrpId">
							<option value=""><mink:message code='mink.label.not_used'/></option>
							<c:forEach var="cgDto" items="${codeGroupList}" varStatus="i">
								<option value="${cgDto.cdGrpId}">${cgDto.cdGrpNm}</option>
							</c:forEach>
					</select></td>
				</tr>
				<tr>
					<th><span class="criticalItems"><mink:message code='mink.label.priority'/></span></th>
					<td><input type="text" name="orderSeq" size="5"
						onKeyPress="return keyPressNum(event)" /></td>
					<th><span class="criticalItems"><mink:message code='mink.label.common_use_yn'/></span></th>
					<td><input type="radio" name="publicYn" value="Y"
						id="publicYn_y" /><label for="publicYn_y"><mink:message code='mink.label.all'/>&nbsp;&nbsp;</label>
						<input type="radio" name="publicYn" value="N" id="publicYn_n" /><label
						for="publicYn_n"><mink:message code='mink.label.relevant_group'/>&nbsp;&nbsp;</label></td>
				</tr>
				<tr>
					<th><mink:message code='mink.label.board_explain'/></th>
					<td colspan="3"><input type="text" name="boardDesc" size="70" /></td>
				</tr>
				<tr>
					<th><mink:message code='mink.web.text.register'/></th>
					<td><input type="text" name="regNm" readonly="readonly" /></td>
					<th><mink:message code='mink.label.reg_date'/></th>
					<td><input type="text" name="regDt" readonly="readonly" /></td>
				</tr>
			</tbody>
			<tfoot></tfoot>
		</table>

	</form>
</div>



<script type="text/javascript">
	var insertFrm = document.insertFrm;
	//ajax 로 가져온 data 를 알맞은 위치에 삽입
	function fnAjaxInfoMapping(result) {
		// 상세화면 정보 출력
		var frm = $("#detailFrm");
		frm.find("input[name='boardId']").val(result.boardId);
		frm.find("input[name='boardNm']").val(result.boardNm);
		frm.find("input[name='boardDesc']").val(result.boardDesc);
		frm.find("input[name='orderSeq']").val(result.orderSeq);
		frm.find("input[name='publicYn'][value=" + result.publicYn + "]").attr(
				"checked", "checked");
		//frm.find("input[name='deleteYn'][value=" + result.deleteYn + "]").attr("checked", "checked");
		frm.find("select[name=cdGrpId]").val(result.cdGrpId);
		frm.find("input[name='regNm']").val(result.regNm);
		frm.find("input[name='regDt']").val(result.regDt);
		if (result.defaultBoard == 'Y') { // id가 특정번호(0)일 경우 한줄공지 게시판으로 구분되어 수정버튼 숨김
			$('#updateBtnDiv').hide();
		} else {
			$('#updateBtnDiv').show();
		}
		
		if ('0' == result.boardId) $("#updateBtn_boardDetailDialog").hide();
		else $("#updateBtn_boardDetailDialog").show();

		htmlEscapeAll(document); // 특수문자 전체 변환
	}

	//입력 값 검증
	function validation(frm) {
		var result = false;

		if (frm.find("input[name='boardNm']").val() == "") {
			alert("<mink:message code='mink.message.enter_board_name'/>");
			frm.find("input[name='boardNm']").focus();
			return true;
		}
		if (frm.find("input[name='orderSeq']").val() == "") {
			alert("<mink:message code='mink.message.enter_priority'/>");
			frm.find("input[name='orderSeq']").focus();
			return true;
		}
		if (frm.find("input[name=publicYn]:checked").size() == 0) {
			alert("<mink:message code='mink.message.enter_common_use'/>");
			return true;
		}

		return result;
	}

	//게시판 수정
	function goUpdate() {
		if (validation($("#detailFrm")))
			return; // 입력 값 검증
		if (!confirm("<mink:message code='mink.message.would_you_save'/>"))
			return;
		ajaxComm('boardUpdate.miaps?', $('#detailFrm'), function(data) {
			resultMsg(data.msg);
			$("#SearchFrm").find("input[name='boardId']").val(
					data.board.boardId); // 상세조회 key
			goList($("#SearchFrm").find("input[name='pageNum']").val()); // 목록/검색
		});
	}

	// 게시판 상세 조회
	$("#boardDetail").dialog({
		autoOpen : false,
		resizable : false,
		width : 'auto',
		modal : true,
		// add a close listener to prevent adding multiple divs to the document
		close : function(event, ui) {
			// remove div with all data and events
			$(this).dialog("close");
		}/*,
		buttons : {
			"수정" : goUpdate,
			"취소" : function() {
				$(this).dialog("close");
			}
		}*/
	});
</script>