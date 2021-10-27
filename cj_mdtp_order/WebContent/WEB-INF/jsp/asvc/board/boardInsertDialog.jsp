<%-- 사용자 등록 다이얼로그 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page session="false"%>

<div id="boardRegDialog" title="<mink:message code='mink.label.board_registration'/>" class="dlgStyle">
<div class="miaps-popup-top-buttons">
	&nbsp;
	<span><button class='btn-dash' onclick="javascript:goInsert();"><mink:message code='mink.label.save'/></button></span>
	<span><button class='btn-dash' onclick="javascript:$('#boardRegDialog').dialog('close');"><mink:message code='mink.label.cancel'/></button></span>
</div>
	<!-- 등록화면 -->
	<form id="insertFrm" name="insertFrm" method="post"
		onSubmit="return false;">
		<input type="hidden" name="regNo" value="${loginUser.userNo}" />
		<!-- 로그인한 사용자 -->
		<input type="hidden" name="searchKey" value="" />
		<!-- 검색조건 -->
		<input type="hidden" name="searchValue" value="" />
		<!-- 검색조건 -->
		<input type="hidden" name="regGrpId"
			value="${loginUser.userGroup.grpId}" />
		<!-- 게시판 등록자의 그룹 ID로 게시판 메뉴 권한 생성 -->
		<input type="hidden" name="regAdminYn" value="${loginUser.adminYn}" />
		<!-- 게시판 등록자가 슈퍼관리자일 경우 전체가 볼수 있는 권한 생성 -->
		<table class="insertTb" border="0" cellspacing="0" cellpadding="0"
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
						id="publicYn_i_y" /><label for="publicYn_i_y"><mink:message code='mink.label.all'/>&nbsp;&nbsp;</label>
						<input type="radio" name="publicYn" value="N" id="publicYn_i_n" /><label
						for="publicYn_i_n"><mink:message code='mink.label.relevant_group'/>&nbsp;&nbsp;</label></td>
				</tr>
				<tr>
					<th><mink:message code='mink.label.board_explain'/></th>
					<td colspan="3"><input type="text" name="boardDesc" size="70" /></td>
				</tr>
			</tbody>
			<tfoot></tfoot>
		</table>
	</form>
</div>

<script type="text/javascript">
	var insertFrm = document.insertFrm;

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

	function goInsert() {
		if (validation($("#insertFrm")))
			return; // 입력 값 검증

		if (!confirm("<mink:message code='mink.message.would_you_register'/>"))
			return;
		ajaxComm('boardInsert.miaps?', $('#insertFrm'), function(data) {
			$("#SearchFrm").find("input[name='boardId']").val(
					data.board.boardId); // (등록한)상세
			goList('1'); // 목록/검색(1 페이지로 초기화)
		});
	}

	//등록
	/* function userInsert() {
	 if( validation() ) {
	 return; // 검증
	 }
	 if( !confirm("등록하시겠습니까?") ) {
	 return;
	 }
	 ajaxComm('userInsert.miaps?', insertFrm, function(data){
	 hideLoading();
	 resultMsg(data.msg);
	 document.userListFrame.searchFrm.userNo.value = data.user.userNo; // (등록한)상세
	 $("#userRegDialog").dialog( "close" );
	
	 document.userListFrame.goList('1'); // 목록/검색(1 페이지로 초기화)
	 });
	 }
	 */
	function openBoardRegDialog() {

		$("#boardRegDialog").dialog("open");
	}

	$("#boardRegDialog").dialog({
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
			"저장" : goInsert,
			"취소" : function() {
				$(this).dialog("close");
			}
		}*/
	});
</script>