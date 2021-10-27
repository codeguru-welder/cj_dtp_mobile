<%-- 사용자 등록 다이얼로그 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page session="false"%>

<div id="mailDeatilDialog" title="<mink:message code='mink.web.text.regist.mail.serverinfo'/>" class="dlgStyle">
<div class="miaps-popup-top-buttons">
	&nbsp;
	<span><button class='btn-dash' onclick="javascript:goUpdate();"><mink:message code="mink.web.text.save"/></button></span>
	<span><button class='btn-dash' onclick="javascript:$('#mailDeatilDialog').dialog('close');"><mink:message code="mink.web.text.cancel"/></button></span>
</div>
	<!-- 등록화면 -->
	<form id="detailFrm" name="detailFrm" method="post" onSubmit="return false;">
		<input type="hidden" name="preMailserverId" />
		<!-- 기존 ID 저장(수정시 사용) -->
		<input type="hidden" name="updNo" value="${loginUser.userNo}" />
		<!-- 로그인한 사용자 -->
		<table class="detailTb" border="0" cellspacing="0" cellpadding="0"
			width="100%">
			<tbody>
				<tr>
					<th><mink:message code="mink.web.text.mail.servername"/></th>
					<td><input type="text" name="mailserverId" /></td>
					<th><mink:message code="mink.web.text.mail.serverstatus"/></th>
					<td><label><input type="radio" name="defaultMail"
							value="Y" checked="checked" />Y</label> <label><input
							type="radio" name="defaultMail" value="N" />N</label></td>
				</tr>
				<tr>
					<th><mink:message code="mink.web.text.mail.servertype"/></th>
					<td><input type="text" name="serverType" /></td>
					<th><mink:message code="mink.web.text.mail.serverprotocol"/></th>
					<td><input type="text" name="protocol" /></td>
				</tr>
				<tr>
					<th><mink:message code="mink.web.text.mail.serverdescription"/></th>
					<td colspan="3"><input type="text" name="description" /></td>
				</tr>
				<tr>
					<th><mink:message code="mink.web.text.mail.sendserver.adress"/></th>
					<td><input type="text" name="outServer" /></td>
					<th><mink:message code="mink.web.text.mail.sendserver.sslstatus"/></th>
					<td><label><input type="radio" name="sslout" value="Y"
							checked="checked" />Y</label> <label><input type="radio"
							name="sslout" value="N" />N</label></td>
				</tr>
				<tr>
					<th><mink:message code="mink.web.text.mail.sendserver.port"/></th>
					<td><input type="text" name="outPort"
						onKeyPress="return keyPressNum(event)" /></td>
					<th><mink:message code="mink.web.text.mail.sendserver.auth"/></th>
					<td><label><input type="radio" name="outAuth"
							value="Y" checked="checked" />Y</label> <label><input
							type="radio" name="outAuth" value="N" />N</label></td>
				</tr>
				<tr>
					<th><mink:message code="mink.web.text.mail.receiveserver.adress"/></th>
					<td><input type="text" name="inServer" /></td>
					<th><mink:message code="mink.web.text.mail.receiveserver.sslstatus"/></th>
					<td><label><input type="radio" name="sslin" value="Y"
							checked="checked" />Y</label> <label><input type="radio"
							name="sslin" value="N" />N</label></td>
				</tr>
				<tr>
					<th><mink:message code="mink.web.text.mail.receiveserver.port"/></th>
					<td colspan="3"><input type="text" name="inPort"
						onKeyPress="return keyPressNum(event)" /></td>
				</tr>
				<tr>
					<th><mink:message code="mink.web.text.mail.inbox.name"/></th>
					<td><input type="text" name="inboxName" /></td>
					<th><mink:message code="mink.web.text.mail.inbox.usestatus"/></th>
					<td><label><input type="radio" name="inboxActive"
							value="Y" checked="checked" />Y</label> <label><input
							type="radio" name="inboxActive" value="N" />N</label></td>
				</tr>
				<tr>
					<th><mink:message code="mink.web.text.mail.outbox.name"/></th>
					<td><input type="text" name="outboxName" /></td>
					<th><mink:message code="mink.web.text.mail.outbox.usestatus"/></th>
					<td><label><input type="radio" name="outboxActive"
							value="Y" checked="checked" />Y</label> <label><input
							type="radio" name="outboxActive" value="N" />N</label></td>
				</tr>
				<tr>
					<th><mink:message code="mink.web.text.mail.sendbox.name"/></th>
					<td><input type="text" name="sentName" /></td>
					<th><mink:message code="mink.web.text.mail.sendbox.usestatus"/></th>
					<td><label><input type="radio" name="sentActive"
							value="Y" checked="checked" />Y</label> <label><input
							type="radio" name="sentActive" value="N" />N</label></td>
				</tr>
				<tr>
					<th><mink:message code="mink.web.text.mail.tempbox.name"/></th>
					<td><input type="text" name="draftsName" /></td>
					<th><mink:message code="mink.web.text.mail.tempbox.usestatus"/></th>
					<td><label><input type="radio" name="draftsActive"
							value="Y" checked="checked" />Y</label> <label><input
							type="radio" name="draftsActive" value="N" />N</label></td>
				</tr>
				<tr>
					<th><mink:message code="mink.web.text.mail.recycle.name"/></th>
					<td><input type="text" name="trashName" /></td>
					<th><mink:message code="mink.web.text.mail.recycle.usestatus"/></th>
					<td><label><input type="radio" name="trashActive"
							value="Y" checked="checked" />Y</label> <label><input
							type="radio" name="trashActive" value="N" />N</label></td>
				</tr>
			</tbody>
			<tfoot></tfoot>
		</table>

		<!-- <div class="detailBtnArea">
						<span id="updateBtnDiv"><button class='btn-dash'
								onclick="javascript:goUpdate()">저장하기</button></span> <span><button
								class='btn-dash' onclick="javascript:hiddenInsertDetail();">닫기</button></span>
					</div> -->
	</form>
</div>

<script type="text/javascript">
	/* var insertFrm = document.insertFrm;

	//입력 값 검증
	function validation(frm) {
		var result = false;

		if (frm.find("input[name='mailserverId']").val() == "") {
			alert("메일서버 이름을 입력하세요.");
			frm.find("input[name='mailserverId']").focus();
			return true;
		}
		if (frm.find("input[name='serverType']").val() == "") {
			alert("메일서버 유형을 입력하세요.");
			frm.find("input[name='serverType']").focus();
			return true;
		}
		if (frm.find("input[name='protocol']").val() == "") {
			alert("메일서버 프로토콜을 입력하세요.");
			frm.find("input[name='protocol']").focus();
			return true;
		}
		if (frm.find("input[name='outServer']").val() == "") {
			alert("보내는 서버 주소를 입력하세요.");
			frm.find("input[name='outServer']").focus();
			return true;
		}
		if (frm.find("input[name='outPort']").val() == "") {
			alert("보내는 서버 포트를 입력하세요.");
			frm.find("input[name='outPort']").focus();
			return true;
		}
		if (isNaN(frm.find("input[name='outPort']").val())) {
			alert("보내는 서버 포트를 숫자로 입력하세요.");
			frm.find("input[name='outPort']").focus();
			return true;
		}
		if (frm.find("input[name='inServer']").val() == "") {
			alert("받는 서버 주소를 입력하세요.");
			frm.find("input[name='inServer']").focus();
			return true;
		}
		if (frm.find("input[name='inPort']").val() == "") {
			alert("받는 서버 포트를 입력하세요.");
			frm.find("input[name='inPort']").focus();
			return true;
		}
		if (isNaN(frm.find("input[name='inPort']").val())) {
			alert("받는 서버 포트를 숫자로 입력하세요.");
			frm.find("input[name='inPort']").focus();
			return true;
		}

		return result;
	} */

	// 등록(ajax) 후 목록 호출
	function goInsert() {
		if (validation($("#insertFrm")))
			return; // 입력 값 검증

		// ID중복 검증
		if (isDuplicatedMailserverId($("#insertFrm"))) {
			alert("<mink:message code='mink.web.text.mail.duplicate.servername'/>");
			$("#insertFrm").find("input[name='mailserverId']").focus();
			return true;
		}

		if (!confirm("<mink:message code='mink.web.alert.is.regist'/>"))
			return;
		ajaxComm('mailserverInsert.miaps?', $('#insertFrm'), function(data) {
			resultMsg(data.msg);
			$("#SearchFrm").find("input[name='mailserverId']").val(
					data.mailserver.mailserverId); // (등록한)상세
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
	/* 	function openInsertDialog() {

	 $("#mailDeailDialog").dialog("open");
	 }
	 */
	$("#mailDeatilDialog").dialog({
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
			"저장" : goUpdate,
			"취소" : function() {
				$(this).dialog("close");
			}
		}*/
	});
</script>