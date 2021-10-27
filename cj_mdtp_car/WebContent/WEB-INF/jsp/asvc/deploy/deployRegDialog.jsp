<%-- 배포 등록 다이얼로그 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div id="deployRegDialog" title="<mink:message code='mink.web.text.deploysetting'/>" class="dlgStyle">
<div class="miaps-popup-top-buttons">
	&nbsp;
	<span><button class='btn-dash' id="buttonSettingConfirm"><mink:message code="mink.web.text.ok"/></button></span>
	<span><button class='btn-dash' id="buttonAccessConfirm"><mink:message code="mink.web.text.conn.urltest"/></button></span>
	<span id="access-test-url2"><button class='btn-dash' id="buttonAccessConfirm2" onclick="javascript:deployServerAccessTestFromRegModiDlg(2)"><mink:message code="mink.web.text.conn.url2test"/></button></span>
	<span><button class='btn-dash' onclick="javascript:$('#deployRegDialog').dialog('close');"><mink:message code="mink.web.text.cancel"/></button></span>
</div>
<form id="settingFrm" name="settingFrm" method="post" enctype="multipart/form-data" onSubmit="return false;">
	<input type="hidden" id="dialogType">
	<input type="hidden" id="setting-deployid" name="setting-deployid">
	<table id="settingTable" class="insertTb" border="0" cellspacing="0" cellpadding="0" width="100%">
		<colgroup>
			<col width="17%" />
			<col width="17%" />
			<col width="15%" />
			<col width="17%" />
			<col width="17%" />
			<col width="17%" />
		</colgroup>
		<tbody>
			<tr>
				<th><span class="criticalItems"><mink:message code="mink.web.text.servername"/></span></th>
				<td colspan="2"><input type="text" name="setting-name" id="setting-name" /></td>
				<th><span class="criticalItems"><mink:message code="mink.web.text.username"/></span></th>
				<td colspan="2"><input type="text" name="setting-username" id="setting-username"/></td>
			</tr>
			<tr>
				<th><span class="criticalItems"><mink:message code="mink.web.text.serverconfig"/></span></th>
				<td colspan="5">
					<label><input type="radio" name="setting-server-cnt" value="1" /><mink:message code="mink.web.text.singleserver"/></label>
					<label><input type="radio" name="setting-server-cnt" value="2" /><mink:message code="mink.web.text.doubleserver"/></label>
				</td>
			</tr>
			<tr>
				<th><span class="criticalItems tooltip" title="<mink:message code='mink.web.message11'/>"><mink:message code="mink.web.text.servleturl"/></span></th>
				<td colspan="5"><input type="text" name="setting-address" id="setting-address" /></td>
			</tr>
			<tr id="servlet-url2">
				<th><span class="criticalItems tooltip" title="<mink:message code='mink.web.message12'/>"><mink:message code="mink.web.text.servleturl2"/></span></th>
				<td colspan="5"><input type="text" name="setting-address2" id="setting-address2" /></td>
			</tr>
			<tr>
				<th><span class="criticalItems tooltip" title="<mink:message code='mink.web.message13'/>">ID</span></th>
				<td colspan="5"><input type="text" name="setting-accessid" id="setting-accessid" /></td>
			</tr>
			<tr>
				<th><span class="criticalItems tooltip" title="<mink:message code='mink.web.message14'/>">Password</span></th>
				<td colspan="5"><input type="password" name="setting-accesspw" id="setting-accesspw" autocomplete="off" /></td>
			</tr>
			<tr>
				<th rowspan="2">배포경로</th>
				<td><span class="criticalItems tooltip" title="<mink:message code='mink.web.message15'/>"><mink:message code="mink.web.text.projectpath"/></span></td>
				<td colspan="4"><input type="text" name="setting-projectpath" id="setting-projectpath" /></td>
			</tr>
			<tr>
				<td><span class="criticalItems tooltip" title="<mink:message code='mink.web.message14'/>"><mink:message code="mink.web.text.localpath"/></span></td>
				<td colspan="4"><input type="text" name="setting-localpath" id="setting-localpath" /></td>
			</tr>
		</tbody>
		<tfoot></tfoot>
	</table>
</form>
</div>

<script type="text/javascript">
function initDeploySettingDialog(type) {
	$('#settingFrm input').val("");
	$('#dialogType').val(type);
	
	$('#servlet-url').show();
	$('#servlet-url2').hide();
	$('#access-test-url2').hide();
	
	<%-- radio 기본값 설정, $('#settingFrm input').val("");으로 input내용을 모두 지우므로 다시 설정한 후 첫번째 값을 체크한다.  --%>
	var elems = document.getElementsByName("setting-server-cnt");
	for (var i = 0; i < elems.length; i++) {
		elems[i].value = i + 1;
	}
	$('#settingFrm').find("input:radio[name='setting-server-cnt'][value='1']").prop('checked', true);
}

function modiDeploySettingDialog(type) {
	$('#dialogType').val(type);
	var deployId = $('#config-info-deployid').val();
	var name = $('#config-info-name').val();
	var address = $('#config-info-address').val();
	var address2 = $('#config-info-address2').val();
	var projectPath = $('#config-info-serverpath').val();
	var localPath = $('#config-info-localpath').val();
	var accessId = $('#config-info-accessid').val();
	var accessPw = $('#config-info-accesspw').val();
	var upUserName = $("#config-info-upload-username").val();
	var serverCnt = $('#config-info-server-cnt').val();
	
	$('#setting-deployid').val(deployId);
	$('#setting-name').val(name);
	$('#setting-username').val(accessId);
	$('#setting-address').val(address);
	$('#setting-address2').val(address2);
	$('#setting-accessid').val(accessId);
	$('#setting-accesspw').val(accessPw);
	$('#setting-projectpath').val(projectPath);
	$('#setting-localpath').val(localPath);
	$('#setting-username').val(upUserName);
	
	if (serverCnt == 1) {
		$('#settingFrm').find("input:radio[name='setting-server-cnt'][value='1']").prop('checked', true);
		$('#servlet-url2').hide();
		$('#access-test-url2').hide();
	} else if (serverCnt == 2) {
		$('#settingFrm').find("input:radio[name='setting-server-cnt'][value='2']").prop('checked', true);
		$('#servlet-url2').show();
		$('#access-test-url2').show();
	}
	
}

// 확인버튼
function setDeployConfig() {
	var _name = $('#setting-username').val();
	var _projectPath = $('#setting-projectpath').val();
	var _localPath = $('#setting-localpath').val();
	var _accessId = $('#setting-accessid').val();
	var _accessPw = $('#setting-accesspw').val();
	var _upUserName = $("#setting-username").val();
	var _address = $('#setting-address').val();
	
	if (_name == '') { alert("<mink:message code='mink.web.text.input.servername'/>"); return; }
	if (_projectPath == '') { alert("<mink:message code='mink.web.text.input.projectpath'/>"); return; }
	if (_localPath == '') { alert("<mink:message code='mink.web.text.input.localpath'/>"); return; }
	if (_accessId == '') { alert("<mink:message code='mink.web.text.input.id'/>"); return; }
	if (_accessPw == '') { alert("<mink:message code='mink.web.text.input.password'/>"); return; }
	if (_upUserName == '') { alert("<mink:message code='mink.web.text.input.username'/>"); return; }
	if (_address == '') { alert("<mink:message code='mink.web.text.input.servleturl'/>"); return; }	
	
	<%-- 프로젝트 폴더 /추가시 앞뒤값 같은지 확인 (예: samples/samples(성공), samples/test(실패) --%>
	if (_projectPath.indexOf('/') > -1) {
		var _ppSplit = _projectPath.split('/');
		
		if (_ppSplit.length > 2) {
			alert("프로젝트 경로에 \"/\"는 한개이상 사용 할 수 없습니다.");
			return;
		}
		
		if (_ppSplit[0] != _ppSplit[1]) {
			alert("프로젝트 경로에 \"/\"을 사용 할 경우에는 \"/\"앞,뒤의 입력한 내용이 같아야 합니다. (예:samples/samples)");
			return;
		}
	}
	
	var selVal = $('#settingFrm').find("input:radio[name='setting-server-cnt']:checked").val();
	if (selVal == 2) {
		var _address2 = $('#setting-address2').val();
		if (_address2 == '') { alert("<mink:message code='mink.web.text.input.servleturl2'/>"); return; }
		
		<%-- 추후 IP주소 체크 추간 --%>
	}
	
	var type = $('#dialogType').val();
	var servletNm = "";
	
	if(type == 'add') {
		servletNm = 'insDeployConfig.miaps';
	}
	else if(type == 'modi') {
		servletNm = 'updDeployConfig.miaps';
	}
	
	ajaxComm(servletNm, $('#settingFrm'), function(data){
		alert("<mink:message code='mink.web.text.success'/>");
		$('#deployRegDialog').dialog('close');
		initDeployConfigDialog();
		getDeployList();
	});
	
}

function deployServerAccessTestFromRegModiDlg(serverNo) {
	var projectPath = $('#setting-projectpath').val();
	var localPath = $('#setting-localpath').val();
	var accessId = $('#setting-accessid').val();
	var accessPw = $('#setting-accesspw').val();
	var address = null;
	
	if (serverNo == 1) {
		address = $('#setting-address').val();
	} else if (serverNo == 2) {
		address = $('#setting-address2').val();
	}
	
	console.log("serverNo: " + serverNo + ", address: " + address);
	
	$('#accessTestFrm [name="projectPath"]').val(projectPath);
	$('#accessTestFrm [name="localPath"]').val(localPath);
	$('#accessTestFrm [name="url"]').val(address);
	$('#accessTestFrm [name="accessId"]').val(accessId);
	$('#accessTestFrm [name="accessPw"]').val(accessPw);
	
	ajaxFileComm('accessConfirmView.miaps', $("#accessTestFrm"), function(data){
		alert(data.msg);
	});
}

function changeServletPath() {
	var selVal = $('#settingFrm').find("input:radio[name='setting-server-cnt']:checked").val();
	
	if (selVal == 1) {
		$("#servlet-url2").hide();
		$("#access-test-url2").hide();
	} else if (selVal == 2) {
		$("#servlet-url2").show();
		$("#access-test-url2").show();
	}
}

function validateIPaddress(ipaddress) {  
	var ipformat = /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/; 
	if (ipaddress.match(ipformat)) {
	    return true;   
  	}  
	return false;  
}

$("#deployRegDialog").dialog({
	autoOpen: false,
    resizable: false,
    width: '55%',
    modal: true,
    position : { my : 'center', at : 'center', of : $('#deployListDlg') },
	// add a close listener to prevent adding multiple divs to the document
    close: function(event, ui) {
        // remove div with all data and events
        $(this).dialog( "close" );
    }
});
</script>