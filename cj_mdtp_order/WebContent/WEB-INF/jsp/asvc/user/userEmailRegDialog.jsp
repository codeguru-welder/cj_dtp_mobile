<%-- 사용자 메일계정 등록 다이얼로그 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div id="userEmailRegDialog" title="<mink:message code='mink.web.text.usermailaccount'/>" class="dlgStyle">
<div class="miaps-popup-top-buttons">
	&nbsp;
	<span><button class='btn-dash' onclick="javascript:insertEmailAccount();"><mink:message code="mink.web.text.save"/></button></span>
	<span><button class='btn-dash' onclick="javascript:$('#userEmailRegDialog').dialog('close');"><mink:message code="mink.web.text.cancel"/></button></span>
</div>	
<form id="emailAccountRegFrm" name="emailAccountRegFrm" method="post" onSubmit="return false;">
	<input type="hidden" name="regNo" value="${loginUser.userNo}" />
	<input type="hidden" name="regDt" />
	<input type="hidden" name="updNo" value="${loginUser.userNo}" />
	<input type="hidden" name="updDt" />
	<input type="hidden" name="userNo" />
	<!-- 
	<div><h3><span>| 사용자 메일계정 정보</span></h3></div>
	-->
	<table class="insertTb" border="0" cellspacing="0" cellpadding="0" width="100%">
		<tbody>
			<tr>	
				<th><mink:message code="mink.web.text.mail.accountid"/></th>
				<td><input type="text" name="accountId" readonly="readonly" /></td>
				<th><mink:message code="mink.web.text.mail.defaultmailstatus"/></th>
				<td>
					<label><input type="radio" name="defaultMail" value="Y" />Y</label>
					<label><input type="radio" name="defaultMail" value="N" />N</label>
				</td>
			</tr>
			<tr>
				<th><mink:message code="mink.web.text.mail.mailadress"/></th>
				<td colspan="3"><input type="text" name="msAddress" /></td>
			</tr>
			<tr>
				<th><mink:message code="mink.web.text.mail.serverloginid"/></th>
				<td><input type="text" name="msLogin" /></td>
				<th><mink:message code="mink.web.text.mail.serverpassword"/></th>
				<td><input type="password" name="msPassword" autocomplete="off"/></td>
			</tr>
			<tr>
				<th><mink:message code="mink.web.text.mail.servername"/></th>
				<td>
					<!-- 
					<input type="text" name="mailserverId" />
					 -->
					<select name="mailserverId" onchange="changeMailserverId(this, 'emailAccountRegFrm')">
						<option value=""><mink:message code="mink.web.text.unselected"/></option>
						<c:forEach var="dto" items="${mailserverList}">
						<option value="${dto.mailserverId}">${dto.mailserverId}</option>
						</c:forEach>
					</select>
				</td>
				<th><mink:message code="mink.web.text.mail.servertype"/></th>
				<td><input type="text" name="serverType" /></td>
			</tr>
			<tr>
				<th><mink:message code="mink.web.text.mail.serverprotocol"/></th>
				<td><input type="text" name="protocol" /></td>
				<th><mink:message code="mink.text.status.push"/></th>
				<td>
					<label><input type="radio" name="push" value="Y" />Y</label>
					<label><input type="radio" name="push" value="N" />N</label>
				</td>
			</tr>
			<tr>
				<th><mink:message code="mink.web.text.mail.serverdescription"/></th>
				<td colspan="3"><input type="text" name="description" /></td>
			</tr>
			<tr>
				<th><mink:message code="mink.web.text.mail.sendserver.adress"/></th>
				<td><input type="text" name="outServer" /></td>
				<th><mink:message code="mink.web.text.mail.sendserver.sslstatus"/></th>
				<td>
					<label><input type="radio" name="sslout" value="Y" />Y</label>
					<label><input type="radio" name="sslout" value="N" />N</label>
				</td>
			</tr>
			<tr>
				<th><mink:message code="mink.web.text.mail.sendserver.port"/></th>
				<td><input type="text" name="outPort" onkeypress="return keyPressNum(event)" /></td>
				<th><mink:message code="mink.web.text.mail.sendserver.auth"/></th>
				<td>
					<label><input type="radio" name="outAuth" value="Y" />Y</label>
					<label><input type="radio" name="outAuth" value="N" />N</label>
				</td>
			</tr>
			<tr>
				<th><mink:message code="mink.web.text.mail.receiveserver.adress"/></th>
				<td><input type="text" name="inServer" /></td>
				<th><mink:message code="mink.web.text.mail.receiveserver.sslstatus"/></th>
				<td>
					<label><input type="radio" name="sslin" value="Y" />Y</label>
					<label><input type="radio" name="sslin" value="N" />N</label>
				</td>
			</tr>
			<tr>
				<th><mink:message code="mink.web.text.mail.receiveserver.port"/></th>
				<td colspan="3"><input type="text" name="inPort" onkeypress="return keyPressNum(event)" /></td>
			</tr>
			<tr>
				<th><mink:message code="mink.web.text.mail.inbox.name"/></th>
				<td><input type="text" name="inboxName" /></td>
				<th><mink:message code="mink.web.text.mail.inbox.usestatus"/></th>
				<td>
					<label><input type="radio" name="inboxActive" value="Y" />Y</label>
					<label><input type="radio" name="inboxActive" value="N" />N</label>
				</td>
			</tr>
			<tr>
				<th><mink:message code="mink.web.text.mail.outbox.name"/></th>
				<td><input type="text" name="outboxName" /></td>
				<th><mink:message code="mink.web.text.mail.outbox.usestatus"/></th>
				<td>
					<label><input type="radio" name="outboxActive" value="Y" />Y</label>
					<label><input type="radio" name="outboxActive" value="N" />N</label>
				</td>
			</tr>
			<tr>
				<th><mink:message code="mink.web.text.mail.sendbox.name"/></th>
				<td><input type="text" name="sentName" /></td>
				<th><mink:message code="mink.web.text.mail.sendbox.usestatus"/></th>
				<td>
					<label><input type="radio" name="sentActive" value="Y" />Y</label>
					<label><input type="radio" name="sentActive" value="N" />N</label>
				</td>
			</tr>
			<tr>
				<th><mink:message code="mink.web.text.mail.tempbox.name"/></th>
				<td><input type="text" name="draftsName" /></td>
				<th><mink:message code="mink.web.text.mail.tempbox.usestatus"/></th>
				<td>
					<label><input type="radio" name="draftsActive" value="Y" />Y</label>
					<label><input type="radio" name="draftsActive" value="N" />N</label>
				</td>
			</tr>
			<tr>
				<th><mink:message code="mink.web.text.mail.recycle.name"/></th>
				<td><input type="text" name="trashName" /></td>
				<th><mink:message code="mink.web.text.mail.recycle.usestatus"/></th>
				<td>
					<label><input type="radio" name="trashActive" value="Y" />Y</label>
					<label><input type="radio" name="trashActive" value="N" />N</label>
				</td>
			</tr>
			<tr>
				<th><mink:message code="mink.web.text.mail.sendserver.id"/></th>
				<td><input type="text" name="outLogin" /></td>
				<th><mink:message code="mink.web.text.mail.sendserver.password"/></th>
				<td><input type="password" name="outPassword" autocomplete="off"/></td>
			</tr>
			<tr>
				<th><mink:message code="mink.web.text.mail.watcherserver.lasttime"/></th>
				<td colspan="3"><input type="text" name="lastWatchTime" readonly="readonly" /></td>
			</tr>
		</tbody>
		<tfoot></tfoot>
	</table>
</form>
</div>

<script type="text/javascript">

//메일계정 등록
function insertEmailAccount() {
	var $frm = $("#emailAccountRegFrm");
	
	if($frm.find("input[name='msAddress']").val() == '') {
		alert('<mink:message code="mink.web.text.mail.input.mailadress"/>');
		$frm.find("input[name='msAddress']").focus();
		return;
	}
	if($frm.find("input[name='msLogin']").val() == '') {
		alert('<mink:message code="mink.web.text.mail.input.mailserverloginid"/>');
		$frm.find("input[name='msLogin']").focus();
		return;
	}
	if($frm.find("input[name='protocol']").val() == '') {
		alert('<mink:message code="mink.web.text.mail.input.serverprotocol"/>');
		$frm.find("input[name='protocol']").focus();
		return;
	}
	if($frm.find("input[name='outServer']").val() == '') {
		alert('<mink:message code="mink.web.text.mail.input.sendserver.address"/>');
		$frm.find("input[name='outServer']").focus();
		return;
	}
	if($frm.find("input[name='outPort']").val() == '') {
		alert('<mink:message code="mink.web.text.mail.input.sendserver.port"/>');
		$frm.find("input[name='outPort']").focus();
		return;
	}
	if(isNaN($frm.find("input[name='outPort']").val())) {
		alert('<mink:message code="mink.web.text.mail.input.number.sendserver.port"/>');
		$frm.find("input[name='outPort']").focus();
		return;
	}
	if($frm.find("input[name='inServer']").val() == '') {
		alert('<mink:message code="mink.web.text.mail.input.receiveserver.adress"/>');
		$frm.find("input[name='inServer']").focus();
		return;
	}
	if($frm.find("input[name='inPort']").val() == '') {
		alert('<mink:message code="mink.web.text.mail.input.receiveserver.port"/>');
		$frm.find("input[name='inPort']").focus();
		return;
	}
	if(isNaN($frm.find("input[name='inPort']").val())) {
		alert('<mink:message code="mink.web.text.mail.input.number.receiveserver.port"/>');
		$frm.find("input[name='inPort']").focus();
		return;
	}
	
	if( !confirm("<mink:message code='mink.web.alert.is.regist'/>") ) return;
	ajaxComm('../mail/mailAccountInsert.miaps?', $frm, function(data){
		resultMsg(data.msg);
		//goList(searchFrm.pageNum.value); // 목록/검색
		
		$("#userEmailRegDialog").dialog( "close" );
		
		<%-- 사용자 상세 정보 다이얼로그의 사용자 메일계정 목록 실시간 업데이트, userDetail.miaps호출 후 callback으로 userModiDialog의 mailInfoSetting을 호출 --%>
		ajaxComm('userDetail.miaps?', document.userDetailFrm, mailInfoSetting);
	});
}


//사용자 메일계정 정보 등록화면 열기
function openUserEmailRegDialog() {
	var $frm = $("#emailAccountRegFrm");
	
	$frm.find("input:text").val("");
	$frm.find("input:password").val("");
	$frm.find("select option").get(0).selected = true;
	$frm.find(":radio[value='Y']").each(function(){
		this.checked = true;
	});
	$frm.find("input[name='regNo']").val("${loginUser.userNo}");
	
	$frm.find("input[name='msPassword']").removeAttr("readonly");
	$frm.find("input[name='outPassword']").removeAttr("readonly");
	
	var selUserNo = $("#userDetailFrm").find("input[name='userNo']").val();
	$frm.find("input[name='userNo']").val(selUserNo);
	
	$("#userEmailRegDialog").dialog( "open" );	
}

$("#userEmailRegDialog").dialog({
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
</script>