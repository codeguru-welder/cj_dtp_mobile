<!DOCTYPE HTML>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<style>

.configInfo {
	border : solid 1px #a6c9e2;
	margin-top : 10px;
}

.configInfo > div {
	height: 30px;
	padding : 10px 10px 10px 10px;
	width : 98%;
}

.inputDiv {
	width : 86%;
	height : 100%;
	display : inline-block;
	float:left;
}

.inputDiv input {
	height: 100%;
	width: 100%;
	font-size : 14px;
} 

.labelDiv {
	width: 10%;
	height: 100%;
	float:left;
	margin-right : 10px;
}

.labelDiv label {
	color : #0459c1;
	height: 100%;
	width: 100%;
	font-size : 14px;
}

#tbody-deployList>tr>td {
	text-align : left;
}

.ui-dialog {
    top: 50% !important;
    margin-left: -175px !important; 
    margin-top: -175px !important; 
} 

</style>

<script type="text/javascript">


function initDeployConfigDialog() {
	$('#deployListDlg input').val("");
	$('#config-modi').hide();
	$('#config-del').hide();
}

<%--  수정삭제버튼 기본 = disabled --%>

<%--  배포관리 리스트 구하기 --%>
function getDeployList() {
	ajaxComm('deployList.miaps', $('#TestFrm'), function(data){
		renderDeployList(data);
	});
}

<%--  배포관리 리스트 그리기 --%>
function renderDeployList(data) {
	
	var deployList = data.deployList;
	$('#tbody-deployList').html("");
	var resultHtml = "";
	
	if(deployList.length == 0) {
		resultHtml = "<tr><td colspan='3' style='text-align:center;'><mink:message code='mink.web.text.noexist.result'/></td></tr>";
	} else {
		for(var i=0; i<deployList.length; i++) {
			resultHtml += "<tr data-deployinfo='" + JSON.stringify(deployList[i]) + "'><td>" + deployList[i].deploy_nm + "</td><td style='text-align:center;'>";
			resultHtml += deployList[i].server_cnt + "</td><td>" + deployList[i].url + "</td><td>" + deployList[i].project_path + "</td><td>" + deployList[i].local_path + "</td></tr>";
		}
	}
	
	$('#tbody-deployList').html(resultHtml);
	
	$("#deployListDlg").dialog({
		autoOpen: false,
	    resizable: true,
	    width: '80%',
	    modal: true,
	    close: function(event, ui) {
	        $(this).dialog( "close" );
	    }
	})
	.dialog('open');
	
}

function initEventBind() {
	<%-- 리스트 라인 클릭 - 수정/삭제버튼 enabled , config-info 채우기 --%>
	
	$(document).on('click', '#tbody-deployList>tr', function(e) {
		
		var deployInfo = JSON.parse(e.currentTarget.dataset.deployinfo);
		
		var name = deployInfo.deploy_nm;
		var serverCnt = deployInfo.server_cnt;
		var address = deployInfo.url;
		var address2 = deployInfo.url2;
		var projectPath = deployInfo.project_path;
		var localPath = deployInfo.local_path;
		var accessId = deployInfo.access_id;
		var accessPw = deployInfo.access_pw;
		var deployId = deployInfo.deploy_id;
		var updUser = deployInfo.upd_user;
				
		$('#config-info-name').val(name);
		$('#config-info-serverpath').val(projectPath);
		$('#config-info-localpath').val(localPath);
		$('#config-info-accessid').val(accessId);
		$('#config-info-accesspw').val(accessPw);
		$('#config-info-deployid').val(deployId);
		$('#config-info-upload-username').val(updUser);
		$('#config-info-server-cnt').val(serverCnt);
		$('#config-info-address').val(address);
		$('#config-info-address2').val(address2);
		
		$('#config-modi').show();
		$('#config-del').show();
		
		if (serverCnt == 1) {
			$('#config-buttonAccessConfirm2').hide();
			$('#divUrl2').hide();
		} else if (serverCnt == 2) {
			$('#config-buttonAccessConfirm2').show();
			$('#divUrl2').show();
		}
		
	});

	<%-- 확인버튼 --%>
 	$(document).on('click', '#config-ok', function() {
 		confirmOK();
	});
	
 	<%-- 취소버튼 --%>
	$(document).on('click', '#config-close', function() {
		$('#deployListDlg').dialog('close');
	});

	<%-- 추가버튼 --%>
	$(document).on('click', '#config-add', function() {
		initDeploySettingDialog('add');
		$('#deployRegDialog').dialog('open');
	});

	<%-- 수정버튼 --%>
	$(document).on('click', '#config-modi', function(e) {
		modiDeploySettingDialog('modi');
		$('#deployRegDialog').dialog('open');
	});
	
	<%-- 삭제버튼 --%>
	$(document).on('click', '#config-del', function(e) {
		var deployId = $('#config-info-deployid').val();
		var deployName = $('#config-info-name').val();
		var result = confirm(deployName + "<mink:message code='mink.web.alert.is.delete'/>"); 
		
		if(result) { 
			ajaxComm('delDeployConfig.miaps', $('#TestFrm'), function(data){
				alert("<mink:message code='mink.web.text.deleted'/>");
				$('#deployListDlg').dialog('close');
				initDeployConfigDialog();
				getDeployList();
			}); 
		} else {
			return false;
		}

	});
	
	<%-- 등록/수정화면 확인버튼 --%>
	$(document).on('click', '#buttonSettingConfirm', function() {
		setDeployConfig();
	});
	
	<%-- 접속 테스트 버튼 - 등록 --%>
	$(document).on('click', '#buttonAccessConfirm', function() {
		deployServerAccessTestFromRegModiDlg(1);
	});
	<%-- 접속 테스트 버튼 - 배포관리 --%>
	$(document).on('click', '#config-buttonAccessConfirm', function() {
		deployServerAccessTest(1);
	});
	<%-- 서버 구성 선택 --%>
	$("#settingFrm").find("input:radio[name='setting-server-cnt']").on('change', function() {
		changeServletPath();
	});
}

<%-- 배포 목록 조회 --%>
function goDeployList(currPage) {
	$("#deployListDlg").dialog({
		autoOpen: false,
	    resizable: true,
	    width: '80%',
	    modal: true,
	    close: function(event, ui) {
	        $(this).dialog( "close" );
	    }
	})
	.dialog('open');
}

function confirmOK() {
	var projectPath = $('#config-info-serverpath').val();
	var localPath = $('#config-info-localpath').val();
	var address = $('#config-info-address').val();
	var address2 = $('#config-info-address2').val();
	var accessId = $('#config-info-accessid').val();
	var accessPw = $('#config-info-accesspw').val();
	var upUserName = $('#config-info-upload-username').val();
	var serverCnt = $('#config-info-server-cnt').val();
	
	$('#deployFrm [name="projectPath"]').val(projectPath);
	$('#deployFrm [name="localPath"]').val(localPath);
	$('#deployFrm [name="serverCnt"]').val(serverCnt);
	$('#deployFrm [name="url"]').val(address);
	$('#deployFrm [name="url2"]').val(address2);
	$('#deployFrm [name="accessId"]').val(accessId);
	$('#deployFrm [name="accessPw"]').val(accessPw);
	$('#deployFrm [name="uploadUser"]').val(upUserName);
	
	$("#spanUrl").html(address);
	$("#spanProjectPath").html(projectPath);
	$("#spanLocalPath").html(localPath);
	
	$("#deployListDlg").dialog("close");
	
	ajaxFileComm('fileDiffView.miaps', $("#deployFrm"), function(data){
		if (data.msg != null) {
			alert(data.msg);	
		} else {
			renderDiffFileList(data);
			changeContentAreaSize();
		}
	});
}	

function deployServerAccessTest(serverNo) {
	var projectPath = $('#config-info-serverpath').val();
	var localPath = $('#config-info-localpath').val();
	var accessId = $('#config-info-accessid').val();
	var accessPw = $('#config-info-accesspw').val();
	var address = null;
	if (serverNo == 1) {
		address = $('#config-info-address').val();
	} else if (serverNo == 2) {
		address = $('#config-info-address2').val();
	}
	
	$('#accessTestFrm [name="projectPath"]').val(projectPath);
	$('#accessTestFrm [name="localPath"]').val(localPath);
	$('#accessTestFrm [name="url"]').val(address);
	$('#accessTestFrm [name="accessId"]').val(accessId);
	$('#accessTestFrm [name="accessPw"]').val(accessPw);
	
	ajaxFileComm('accessConfirmView.miaps', $("#accessTestFrm"), function(data){
		alert(data.msg);
	});
}
</script>

<div id="deployListDlg" title="<mink:message code='mink.web.text.deploymanagement'/>" class="dlgStyle">
	<div class="miaps-popup-top-buttons-in-tap" style="border:0;">
			&nbsp;
		<span><button class='btn-dash' name="config-add" id="config-add"><mink:message code="mink.web.text.add"/></button></span>
		<span><button class='btn-dash' name="config-modi" id="config-modi" style="display:none;"><mink:message code="mink.web.text.modify"/></button></span>
		<span><button class='btn-dash' name="config-del" id="config-del" style="display:none;"><mink:message code="mink.web.text.delete"/></button></span>
		<span><button class='btn-dash' name="config-buttonAccessConfirm" id="config-buttonAccessConfirm"><mink:message code="mink.web.text.conn.urltest"/></button></span>
		<span><button class='btn-dash' name="config-buttonAccessConfirm2" id="config-buttonAccessConfirm2" onclick="javascript:deployServerAccessTest(2)"><mink:message code="mink.web.text.conn.url2test"/></button></span>
		<span><button style="float:right; margin-right:5px;" class='btn-dash' name="config-close" id="config-close"><mink:message code="mink.web.text.close"/></button></span>
		<span><button style="float:right; margin-right:5px;" class='btn-dash' name="config-ok" id="config-ok"><mink:message code="mink.web.text.ok"/></button></span>
	</div>
	<table id="deployListTb" border="0" cellspacing="0" cellpadding="0" width="100%" class="listTb">
		<colgroup>
			<col width="15%" />
			<col width="10%" />
			<col width="30%" />
			<col width="15%" />
			<col width="30%" />
		</colgroup>
		<thead>
			<tr>
				<td><mink:message code="mink.web.text.name"/></td>
				<td><mink:message code="mink.web.text.serverconfig"/></td>
				<td><mink:message code="mink.web.text.servleturl"/></td>
				<td><mink:message code="mink.web.text.projectpath"/></td>
				<td><mink:message code="mink.web.text.localpath"/></td>
			</tr>
		</thead>
		<tbody id="tbody-deployList">
		</tbody>
		<tfoot></tfoot>
	</table>
	<div class="configInfo">
		<div><div class="labelDiv"><label for="config-info-name"><mink:message code="mink.web.text.name"/></label></div><div class="inputDiv"><input type="text" name="config-info-name" id="config-info-name" disabled/></div></div>
		<div><div class="labelDiv"><label for="config-info-address" ><mink:message code="mink.web.text.servleturl"/></label></div><div class="inputDiv"><input type="text" name="config-info-address" id="config-info-address" disabled/></div></div>
		<div id="divUrl2"><div class="labelDiv"><label for="config-info-address2" ><mink:message code="mink.web.text.servleturl2"/></label></div><div class="inputDiv"><input type="text" name="config-info-address2" id="config-info-address2" disabled/></div></div>
		<div><div class="labelDiv"><label for="config-info-serverpath"><mink:message code="mink.web.text.projectpath"/></label></div><div class="inputDiv"><input type="text" name="config-info-serverpath" id="config-info-serverpath" disabled/></div></div>
		<div><div class="labelDiv"><label for="config-info-localpath"><mink:message code="mink.web.text.localpath"/></label></div><div class="inputDiv"><input type="text" name="config-info-localpath" id="config-info-localpath" disabled/></div></div>
	</div>
	
	<form id="TestFrm" name="TestFrm" method="post" onSubmit="return false;">
		<input type="hidden" id="config-info-deployid" name="config-info-deployid">
		<input type="hidden" id="config-info-accessid">
		<input type="hidden" id="config-info-accesspw">
		<input type="hidden" id="config-info-upload-username">
		<input type="hidden" id="config-info-server-cnt">
	</form>	
	
	<form id="accessTestFrm" method="post" onSubmit="return false;">
		<input type="hidden" id="url" name="url" value=""/>
		<input type="hidden" id="accessId" name="accessId" value=""/>
		<input type="hidden" id="accessPw" name="accessPw" value=""/>
		<input type="hidden" id="localPath" name="localPath" value="" />
		<input type="hidden" id="projectPath" name="projectPath" value="" />
	</form>
</div>