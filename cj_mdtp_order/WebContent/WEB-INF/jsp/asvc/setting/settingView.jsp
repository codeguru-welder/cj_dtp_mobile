<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="org.springframework.web.bind.annotation.SessionAttributes"%>
<%@ page import="com.thinkm.mink.commons.util.MinkConfig" %>
<%@ page import="com.thinkm.mink.commons.util.MinkContextParam" %>
<%
	/*
	 * 환경설정 화면 (settingView.jsp)
	 * 
	 * @author chlee
	 * @since 2016.02.12	 
	 */
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<%@ include file="/WEB-INF/jsp/include/wsACommonInclude.jsp" %>
<%@ include file="/WEB-INF/jsp/include/wsACommonHeadScript.jsp" %>
<title><mink:message code="mink.label.page_title"/></title>

<script type="text/javascript">
$(function() {
	//accordion 선택 페이지를 유지하기위한 설정값 셋팅 ex) home:0 user:1, device:2, app:3, push:4, board:5, monitoring:6, setting:7
	init_accordion('setting', '${loginUser.menuListString}');
	$("#topMenuTile").html("<mink:message code='mink.web.text.setting_miapssetting'/>");
	
	init();
	
	$.get('${contextURL}/minkSvc?version',  function(data){
		var versionInfo = data.replace(/\r\n/gi, '<br/>');
		versionInfo = versionInfo.replace(/\n/gi, '<br/>');
		
		//console.log(versionInfo);
		$("#adminVersion").html(versionInfo);
	}, 'html');
	
	showLicenseState();
	showPushLicense();
	showTempPushLogListFilesInfo();
	
	$('.tooltip').tooltipster({ 
		contentAsHTML: true,
		iconDesktop: true
	});	// tooltipster html
});

<%-- 푸시 라이선스  --%>
function showPushLicense() {
	$.post('${contextURL}/asvc/setting/settingPushLicense.miaps?',  function(data){		
		var plText = data.pushType;
		$("#pushLicenseStateSpan").text(plText);
	}, 'json');
}

<%-- 라이선스 현황 보기(간단)  
function showLicenseState() {
	$.post('userLicenseCount.miaps?', function(data){
		var alertText = "License: 사용(" + data.licenseAssignedCount + '), 남은 수(' + data.licenseUnassignedCount + ')';
		$("#licenseStateSpan").text(alertText);
	}, 'json');	
}
--%>

<%-- 라이선스 현황 보기
// 2014/04/10 [13:58:06] 현재 7개의 라이선스가 사용 되었으며 남은 개수는 493개 입니다. 
--%> 
function showLicenseState() {
	$.post('${contextURL}/asvc/user/userLicenseCount.miaps?',  function(data){		
		var alertText = '[' + getTodayTime() + ']';
		alertText += "<mink:message code='mink.web.text.setting.current'/>" + data.licenseAssignedCount + "<mink:message code='mink.web.text.setting.usedlicense'/>" + data.licenseUnassignedCount + "<mink:message code='mink.web.text.setting.remaininglicense'/>";
		if (data.licenseMaxLimit <= 0) {
			alertText += "<mink:message code='mink.web.text.allowed.unlimitedlicense'/>";
		}
		$("#licenseStateSpan").text(alertText);		
	}, 'json');
}

<%-- 라이선스 생성 --%>
function userLicenseInsert() {
	<%-- 라이선스 생성 개수 검증 --%>
	var answer = false;
	
	<%-- 비동기 옵션 끄기(ajax 동기화) --%>
	$.ajaxSetup({async:false});
	
	ajaxComm('${contextURL}/asvc/user/userLicenseCount.miaps?', {}, function(data){
		
		if(data.licenseMaxLimit <= data.licenseTotalCount) {
			
			alert("<mink:message code='mink.web.alert.allowed.morelicense'/>"+"\n"+"<mink:message code='mink.web.alert.renew.license'/>");
			
			var alertText = '[' + getTodayTime() + ']';
			alertText += "<mink:message code='mink.web.text.setting.current'/>" + data.licenseAssignedCount + "<mink:message code='mink.web.text.setting.usedlicense'/>" + data.licenseUnassignedCount + "<mink:message code='mink.web.text.setting.remaininglicense'/>";
			$("#licenseStateSpan").text(alertText);
			
			answer = true;
		}
	});
	<%-- 비동기 옵션 켜기 --%>
	$.ajaxSetup({async:true});
	
	if(answer) return;
	
	if(!confirm("<mink:message code='mink.web.alert.is.create'/>")) return;
	
	ajaxComm('${contextURL}/asvc/user/userLicenseInsert.miaps?', {}, function(data){
		resultMsg(data.msg);
	});
}

<%-- 임시 다운로드 파일 삭제 --%>
function goDeleteTempDownloadFiles() {
	if(!confirm("<mink:message code='mink.web.alert.is.delete.downloadtmpfile'/>")) return;
	$.ajaxSetup({async:false});
	ajaxComm('settingDeleteTempDownloadFiles.miaps?', {}, function(data){
		alert(data.msg);
	});
	$.ajaxSetup({async:true});
	
	showTempPushLogListFilesInfo();
}

<%-- 임시 다운로드 파일 정보 (개수, 리스트) --%>
function showTempPushLogListFilesInfo() {
	ajaxComm('settingTempDownloadFilesInfo.miaps?', {}, function(data){
		
		$("#tempFileDir").html("<mink:message code='mink.web.text.tmpdownloaddir'/> " + data.tmpFilePath + "<br/><mink:message code='mink.web.text.totalfilesize'/>" + data.tmp_file_totalsize.toLocaleString() + "byte");
		
		if (data.tmp_file_cnt == 0) {
			$("#tempDownloadFilesInfo").html("<mink:message code='mink.web.alert.noexist.tmpfile'/>");
		} else {
			$("#tempDownloadFilesInfo").html("<a href='javascript:toggleTempFileList();'>" + data.tmp_file_cnt + "<mink:message code='mink.web.alert.exist.tmpfile'/>" + "</a>");
		}
		
		var fileList = "";
		for (i = 0; i < data.tmp_file_list.length; i++) {
			if (i > 0 && i % 4 == 0) {
				fileList += "</br>";
			} else {
				if (i > 0) {
					fileList += ", ";
				}
			}
			
			fileList += data.tmp_file_list[i];
		}
		
		$("#tempDownloadFilesList").html(fileList);
	});
}

function toggleTempFileList() {
	$("#_tempFilesList").toggle();
}

function downloadZip() {
	if(!confirm("<mink:message code='mink.web.alert.fulldownload.zipfile'/>")) {
		return;
	}
	
	var frm = $("#downloadFrm");
	var projectPath = frm.find("input[name='projectPath']").val();
	
	if (projectPath == null || projectPath == '') {
		alert("프로젝트 경로를 입력 해 주십시오.");
		return;
	}
	
	//var updateResourceUrl = '${contextURL}/webapp/' + projectPath + '/UpdateResourceZip.jsp'
	var updateResourceUrl = '${contextURL}/webapp/' + projectPath + '/MakeZip.jsp';
	// console.log(updateResourceUrl);
	showLoading();
	// UpdateResourceZip.jsp실행
	$.ajax({
		url: updateResourceUrl,
		async: true,
		type: 'GET',
		data: '',
		contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
		dataType: 'html',
		beforeSend: function(xhr) {
			xhr.setRequestHeader("deploy-service", "true"); // PC배포화면에서 manual UpdateResource.jsp호출하는 것과, 브라우저에서 호출하는 것 구분하기 위해 추가.
		},
		success: function(result) {
			hideLoading();
			console.log(result);
			
			// miapsresource.zip파일 다운로드 실행
			document.downloadFrm.action = '${contextURL}/asvc/deploy/resourceDownloadZipInSettingView.miaps?';
			document.downloadFrm.submit();
		},
		error: function(result) {
			hideLoading();
			alert('UpdateResource 실행 중 에러가 발생 했습니다. 프로젝트 경로를 확인 해 주십시오.');
			return;
		}		
	});
}
</script>
</head>
<body>

<%-- JVM 메모리 정보 확인 다이얼로그 --%>
<%@ include file="/WEB-INF/jsp/asvc/setting/miapsJvmImageDialog.jsp" %>
<%@ include file="/WEB-INF/jsp/asvc/setting/miapsJvmInfoDialog.jsp" %>

<div id="miaps-container">
	<div id="miaps-header">
    	<%@ include file="/WEB-INF/jsp/include/header.jsp" %>
  	</div>
  	<div id="miaps-sidebar">
		<%@ include file="/WEB-INF/jsp/include/left.jsp" %>		
	</div>
	<div id="miaps-content" style="top: 55px;">
		<br/>
		<div class="licenseInfoText"><mink:message code="mink.web.text.info.miapsserver"/></div>
		<div class="setting_box">
			<div class="setting_top_button">
				&nbsp;
				<span><button class='btn-dash' onclick="javascript:openMiapsJvmInfoDialog();">JVM Memory</button></span>
			</div>
			<div class="licenseInfoText setting_contents">
				<span id="adminVersion"></span>
			</div>			
		</div>
		<br/><br/>
		<div class="licenseInfoText"><mink:message code="mink.web.text.info.license"/></div>
		<div class="setting_box">
			<div class="setting_top_button">
				&nbsp;
				<span><button class='btn-dash' onclick="javascript:userLicenseInsert();"><mink:message code="mink.web.text.create.licensekey"/></button></span>
			</div>
			<div class="licenseInfoText setting_contents">
				<span>MiAPS : </span><span id="licenseStateSpan"></span>
			</div>
			<div class="setting_top_button"></div>
			<div class="licenseInfoText setting_contents">
				<span>PUSH : </span><span id="pushLicenseStateSpan"></span>
			</div>
		</div>
		<br/><br/>
		<div class="licenseInfoText"><mink:message code="mink.web.text.info.tmpdownloadfile"/><span class="tooltip" title="<mink:message code='mink.web.message991'/><br><mink:message code='mink.web.message992'/><br><mink:message code='mink.web.message993'/>"></span>
		</div>
		<div class="setting_box">
			<div class="setting_top_button">
				&nbsp;
				<button class='btn-dash' onclick="javascript:goDeleteTempDownloadFiles();"><mink:message code="mink.web.text.delete.tmpdownloadfile"/></button>
			</div>
			<div class="licenseInfoText setting_contents">
				<span id="tempFileDir"></span>
			</div>
			<div class="licenseInfoText setting_contents">
				<span id="tempDownloadFilesInfo"></span>
			</div>
			<div id="_tempFilesList" class="licenseInfoText setting_top_button setting_contents" style="display: none;">
				<span id="tempDownloadFilesList"></span>
			</div>
		</div>
		<br/><br/>
		<div class="licenseInfoText">MiAPS Hybrid Resource ZIP File Download</div>
		<div class="setting_box">
			<div class="setting_top_button">
				&nbsp;
				<span><button class='btn-dash' onclick="javascript:downloadZip()"><img src='${contextURL}/asvc/images/zip-48.png' width='22px' height='22px' alt='download zip' style="vertical-align:middle;">&nbsp;Download ZIP</button></span>
			</div>
			<form id="downloadFrm" name="downloadFrm" method="post" onSubmit="return false;">
				<table id="settingTable" class="insertTb" border="0" cellspacing="0" cellpadding="0" width="100%">
					<colgroup>
						<col width="15%" />
						<col width="85%" />
					</colgroup>
					<tbody>
						<tr>
							<th><span class="criticalItems tooltip" title="<mink:message code='mink.web.message15'/>"><mink:message code="mink.web.text.projectpath"/></span></th>
							<td><input type="text" name="projectPath" id="projectPath" /></td>
						</tr>					
					</tbody>
					<tfoot></tfoot>
				</table>
			</form>			
		</div>	
	</div>
	<div id="miaps-footer">
    	<%@ include file="/WEB-INF/jsp/include/footer.jsp" %>
  	</div>
</div>
</body>
</html>
