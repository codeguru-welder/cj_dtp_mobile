<%-- 앱 버전 등록/수정/상세조회 다이얼로그 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div id="appVersionRegModiDialog" title="<mink:message code='mink.web.text.info.appversion'/>" class="dlgStyle">
<div class="miaps-popup-top-buttons">
	&nbsp;
	<span id="spanVerInsert"><button class='btn-dash' onclick="javascript:goVerInsert();"><mink:message code="mink.web.text.save"/></button></span>
	<span id="spanVerUpdate"><button class='btn-dash' onclick="javascript:goVerUpdate();"><mink:message code="mink.web.text.modify"/></button></span>
	<span><button class='btn-dash' onclick="javascript:$('#appVersionRegModiDialog').dialog('close');"><mink:message code="mink.web.text.cancel"/></button></span>
</div>
<form id="verDetailFrm" name="verDetailFrm" method="POST" enctype="multipart/form-data" onsubmit="return false;">
	<input type="hidden" name="regNo" value="${loginUser.userNo}"/>	<%-- 로그인한 사용자 --%>
	<input type="hidden" name="updNo" value="${loginUser.userNo}"/>	<%-- 로그인한 사용자 --%>
	<input type="hidden" name="appId" value=""/>
	<input type="hidden" name="pageNum" value="" />	<%-- 현재 페이지 --%>
	<%-- <input type="hidden" name="searchKey" value=""/>  검색조건 --%>
	<%-- <input type="hidden" name="searchValue" value=""/> 검색조건 --%>
	<%--	
	<div><h3><span>* 버전 정보</span></h3></div>
	--%>
	<table class="insertTb" border="0" cellspacing="0" cellpadding="0" width="100%">
		<colgroup>
			<col width="20%" />
			<col width="30%" />
			<col width="20%" />
			<col width="30%" />							
		</colgroup>
		<tbody>
			<tr>
				<th><span class="criticalItems"><mink:message code="mink.web.text.versionno"/></span></th>
				<td><input type="text" name="versionNo" readonly="readonly" /></td>
				<th></th>
				<td></td>
			</tr>
			<tr>
				<th><span class="criticalItems"><mink:message code="mink.web.text.appversion"/></span></th>
				<td><input type="text" name="versionNm" /></td>
				<th><mink:message code="mink.web.text.appversion.store"/></th>
				<td><input type="text" name="storeVersionNm" /></td>				
			</tr>
			<tr>
				<th><span class="criticalItems"><mink:message code="mink.web.text.is.use"/></span></th>
				<td>
					<input type="radio" name="deleteYn" value="N" id="deleteYn_n" /><label for="deleteYn_n" ><mink:message code="mink.web.text.using"/></label>
					<input type="radio" name="deleteYn" value="Y" id="deleteYn_y" /><label for="deleteYn_y" ><mink:message code="mink.web.text.stoped"/></label>
				</td>
				<th><span class="criticalItems"><mink:message code="mink.web.text.forced.update"/></span></th>
				<td>
					<input type="radio" name="forceUpdateYn" value="N" id="forceUpdateYn_n" /><label for="forceUpdateYn_n" ><mink:message code="mink.web.text.disabled"/></label>
					<input type="radio" name="forceUpdateYn" value="Y" id="forceUpdateYn_y" /><label for="forceUpdateYn_y" ><mink:message code="mink.web.enabled"/></label>
				</td>
			</tr>
			<tr>
				<th><span class="criticalItems"><mink:message code="mink.web.text.install.file"/></span></th>
				<td colspan="3">
					<%-- <img id="appFileImg" width="100" height="100" src=""/>  --%>
					<input type="text" name="appFileNm" readonly="readonly" onclick="javascript: downloadFile('appfile');"/>
					<input type="file" id="appFileAttach" name="appFileAttach" >
				</td>
			</tr>
			<tr>
				<th><mink:message code="mink.web.text.install.pathfile"/></th>
				<td colspan="3">
					<%-- <img id="manifestFileImg" width="100" height="100" src=""/>  --%>
					<input type="text" name="manifestFileNm" readonly="readonly" onclick="javascript: downloadFile('manifest');"/>
					<input type="file" id="manifestFileAttach" name="manifestFileAttach" >
				</td>
			</tr>
			<tr>
				<th><mink:message code="mink.web.text.description.version"/></th>
				<td colspan="3">
					<textarea name="versionDesc" style="width:100%;overflow:visible;" onmouseup="textareaResize(this)" onkeyup="textareaResize(this)"></textarea>
				</td>
			</tr>
		</tbody>
		<tfoot></tfoot>
	</table>

	<div class="detailBtnArea">
		<%if (com.thinkm.mink.commons.util.MinkConfig.getConfig().get("miaps.app.update.push.send.value") != null) {%>
			<input type="checkbox" id="pushYnId" name="pushYn" value="Y"/><span style="font: bold 16px 맑은 고딕, HYHeadLine, 돋움, verdana, arial, helvetica, sans-serif;"><mink:message code="mink.web.text.appupdate.sendpush"/></span>&nbsp;
		<%}%>			
	</div>
	
	<progress id="progressBar" value="0" max="100" style="width: 100%;"></progress>
</form>

<form id="searchFrm2" name="searchFrm2" method="POST" onsubmit="return false;">
	<input type="hidden" name="pageNum" value="" />	<%-- 현재 페이지 --%>
	<input type="hidden" name="appId" value=""/>	<%-- key --%>
	<input type="hidden" name="versionNo" value=""/>	<%-- key --%>
</form>
</div>

<script type="text/javascript">
function runVerInsert() {
	<%--
	 ajaxFileComm('appVersionInsert.miaps?', $("#verDetailFrm"), function(data){
	    	if( data.msg != null && data.msg != "" ) {
	    		alert(data.msg);
	    	} else {
	    		alert("<mink:message code='mink.web.alert.success.regist'/>");
	    		$("#appVersionRegModiDialog").dialog( "close" );
	    		$("#searchFrm2").find("input[name='appId']").val(data.version.appId); // (등록한)상세 
	        	$("#searchFrm2").find("input[name='versionNo']").val(data.version.versionNo); // (등록한)상세 
	        	goVersionList('1'); // 목록/검색(1 페이지로 초기화) 
	    	}
	    	
	    	// 버전 추가 할 때 파일을 사용 했었다면 사용 했던 파일 값을 초기화 시킨다. 
			if ($("#verDetailFrm").find("input[name='appFileAttach']").val() != null) {
				$("#verDetailFrm").find("input[name='appFileAttach']").remove();
				$("#verDetailFrm").find("input[name='appFileNm']").after("<input type=\"file\" id=\"appFileAttach\" name=\"appFileAttach\" >");
			}
			
			if ($("#verDetailFrm").find("input[name='manifestFileAttach']").val() != null) {
				$("#verDetailFrm").find("input[name='manifestFileAttach']").remove();
				$("#verDetailFrm").find("input[name='manifestFileNm']").after("<input type=\"file\" id=\"manifestFileAttach\" name=\"manifestFileAttach\" >");
			}
	    });
	 --%>
	var progressBar = $("#progressBar");
	 
	/* ADD FILE TO PARAM AJAX */
	var formData = new FormData();
	   $.each($("#verDetailFrm").find("input[type='file']"), function(i, tag) {
	       $.each($(tag)[0].files, function(i, file) {
	           formData.append(tag.name, file);
	       });
	   });
	   
	   /* ADD INFO TO PARAM AJAX */
	   var params = $("#verDetailFrm").serializeArray();
	   $.each(params, function (i, val) {
	       formData.append(val.name, val.value);
	   });
	   
	$.ajax({
	    url: 'appVersionInsert.miaps?',
	    data: formData,
	    cache: false,
	    contentType: false,
	    processData: false,
	    type: 'POST',
	    xhr: function() {
	    	var xhr = new window.XMLHttpRequest();
	    	xhr.upload.addEventListener("progress", function(e) {
	    		if (e.lengthComputable) {
	    			var percent = (e.loaded / e.total) * 100;
	    			progressBar.val(percent);
	    		}
	    	}, false);
	    	return xhr;
	    }
	})
	.done(function(data) {
		progressBar.val("0");
		if( data.msg != null && data.msg != "" ) {
    		alert(data.msg);
    	} else {
    		alert("<mink:message code='mink.web.alert.success.regist'/>");
    		$("#appVersionRegModiDialog").dialog( "close" );
    		$("#searchFrm2").find("input[name='appId']").val(data.version.appId); // (등록한)상세 
        	$("#searchFrm2").find("input[name='versionNo']").val(data.version.versionNo); // (등록한)상세 
        	goVersionList('1'); // 목록/검색(1 페이지로 초기화) 
    	}
    	
    	// 버전 추가 할 때 파일을 사용 했었다면 사용 했던 파일 값을 초기화 시킨다. 
		if ($("#verDetailFrm").find("input[name='appFileAttach']").val() != null) {
			$("#verDetailFrm").find("input[name='appFileAttach']").remove();
			$("#verDetailFrm").find("input[name='appFileNm']").after("<input type=\"file\" id=\"appFileAttach\" name=\"appFileAttach\" >");
		}
		
		if ($("#verDetailFrm").find("input[name='manifestFileAttach']").val() != null) {
			$("#verDetailFrm").find("input[name='manifestFileAttach']").remove();
			$("#verDetailFrm").find("input[name='manifestFileNm']").after("<input type=\"file\" id=\"manifestFileAttach\" name=\"manifestFileAttach\" >");
		}
	})
	.fail(function(xhr, status, errorThrown) {
		progressBar.val("0");
		alert('xhr: ' + JSON.stringify(xhr) + '\nstatus: ' + status + '\nerrorThrown: ' + errorThrown);
	});
}

<%-- 버전 등록(ajax) 후 목록 호출 --%>
function goVerInsert() {
	$("#verDetailFrm").find("input[name='appId']").val($("#searchFrm2").find("input[name='appId']").val());

	if(validationVer($("#verDetailFrm"))) return; <%-- 입력 값 검증 --%>

	if ($("#pushYnId").length > 0) {
		if($("input:checkbox[name='pushYn']").is(":checked") == true) {
			if(!confirm("<mink:message code='mink.web.message5'/>")) {
				return;
			}
			runVerInsert();
		} else {
			if(!confirm("<mink:message code='mink.web.alert.is.regist'/>")) {
				return;
			}
			runVerInsert();
		}
	} else {	
		if(!confirm("<mink:message code='mink.web.alert.is.regist'/>")) {
			return;
		}
		runVerInsert();
	}

}

function runVerUpdate() {
	<%--
	ajaxFileComm('appVersionUpdate.miaps?', $("#verDetailFrm"), function(data){
   		resultMsg(data.msg);
		$("#searchFrm2").find("input[name='appId']").val(data.version.appId);	// 상세조회 key
		$("#searchFrm2").find("input[name='versionNo']").val(data.version.versionNo);	// 상세조회 key
		goVersionList($("#searchFrm2").find("input[name='pageNum']").val()); // 목록/검색 
		
		// 버전 업데이트 할 때 파일을 사용 했었다면 사용 했던 파일 값을 초기화 시킨다.
		if ($("#verDetailFrm").find("input[name='appFileAttach']").val() != null) {
			$("#verDetailFrm").find("input[name='appFileAttach']").remove();
			$("#verDetailFrm").find("input[name='appFileNm']").after("<input type=\"file\" id=\"appFileAttach\" name=\"appFileAttach\" >");
		}
		
		if ($("#verDetailFrm").find("input[name='manifestFileAttach']").val() != null) {
			$("#verDetailFrm").find("input[name='manifestFileAttach']").remove();
			$("#verDetailFrm").find("input[name='manifestFileNm']").after("<input type=\"file\" id=\"manifestFileAttach\" name=\"manifestFileAttach\" >");
		}
   });
   --%>
   var progressBar = $("#progressBar");

   /* ADD FILE TO PARAM AJAX */
	var formData = new FormData();
	   $.each($("#verDetailFrm").find("input[type='file']"), function(i, tag) {
	       $.each($(tag)[0].files, function(i, file) {
	           formData.append(tag.name, file);
	       });
	   });
	   
	   /* ADD INFO TO PARAM AJAX */
	   var params = $("#verDetailFrm").serializeArray();
	   $.each(params, function (i, val) {
	       formData.append(val.name, val.value);
	   });
	   
	$.ajax({
	    url: 'appVersionUpdate.miaps?',
	    data: formData,
	    cache: false,
	    contentType: false,
	    processData: false,
	    type: 'POST',
	    xhr: function() {
	    	var xhr = new window.XMLHttpRequest();
	    	xhr.upload.addEventListener("progress", function(e) {
	    		if (e.lengthComputable) {
	    			var percent = (e.loaded / e.total) * 100;
	    			progressBar.val(percent);
	    		}
	    	}, false);
	    	return xhr;
	    }
	})
	.done(function(data) {
		progressBar.val("0");
		resultMsg(data.msg);
		$("#searchFrm2").find("input[name='appId']").val(data.version.appId);	// 상세조회 key
		$("#searchFrm2").find("input[name='versionNo']").val(data.version.versionNo);	// 상세조회 key
		goVersionList($("#searchFrm2").find("input[name='pageNum']").val()); // 목록/검색 
		
		// 버전 업데이트 할 때 파일을 사용 했었다면 사용 했던 파일 값을 초기화 시킨다.
		if ($("#verDetailFrm").find("input[name='appFileAttach']").val() != null) {
			$("#verDetailFrm").find("input[name='appFileAttach']").remove();
			$("#verDetailFrm").find("input[name='appFileNm']").after("<input type=\"file\" id=\"appFileAttach\" name=\"appFileAttach\" >");
		}
		
		if ($("#verDetailFrm").find("input[name='manifestFileAttach']").val() != null) {
			$("#verDetailFrm").find("input[name='manifestFileAttach']").remove();
			$("#verDetailFrm").find("input[name='manifestFileNm']").after("<input type=\"file\" id=\"manifestFileAttach\" name=\"manifestFileAttach\" >");
		}
	})
	.fail(function(xhr, status, errorThrown) {
		progressBar.val("0");
		alert('xhr: ' + JSON.stringify(xhr) + '\nstatus: ' + status + '\nerrorThrown: ' + errorThrown);
	});
}

<%-- 버전 수정(ajax) 후 목록 호출 --%>
function goVerUpdate() {
	if(validationVer($("#verDetailFrm"))) return; // 입력 값 검증
	
	if ($("#pushYnId").length > 0) {
		if($("input:checkbox[name='pushYn']").is(":checked") == true) {
			if(!confirm("<mink:message code='mink.web.message5'/>")) {
				return;
			}
			runVerUpdate();
			
		} else {
			if(!confirm("<mink:message code='mink.web.alert.is.save'/>")) {
				return;
			}
			runVerUpdate();
		}
	} else {
		if(!confirm("<mink:message code='mink.web.alert.is.save'/>")) {
			return;
		}
		runVerUpdate();
	}
}

<%-- 버전정보 입력 값 검증 --%>
function validationVer(frm) {
	var result = false;
	
	if( frm.find("input[name='versionNm']").val()=="" ) {
		alert("<mink:message code='mink.web.input.versionname'/>");
		frm.find("input[name='versionNm']").focus();
		return true;
	}
	
	<%-- 스토어 앱 버전이 있으면 앱 파일은 업로드 하지 않아도 되도록 수정. 2020.01.19 chlee  --%>
	if( frm.find("input[name='storeVersionNm']").val() == "" ) {
		if( frm.find("input[name='appFileNm']").val()=="" && frm.find("input[name='appFileAttach']").val() == "" ) {
			alert("<mink:message code='mink.web.alert.select.installfile'/>");
			frm.find("input[name='appFileNm']").focus();
			return true;
		}
	}
	
	<%-- IOS 인 경우, 설치경로지정파일이 필수항목임 
	 	2015.05.27 chlee : 파일이 존재하지 않으면 만들어서 사용하도록 수정 --%>
	/*if( $("#detailFrm").find("select[name='platformCd'] option:selected").val() == "${PLATFORM_IOS}" ) {
		if( frm.find("input[name='manifestFileNm']").val()=="" && frm.find("input[name='manifestFileAttach']").val() == "" ) {
			alert("<mink:message code='mink.web.message21'/>");
			frm.find("input[name='manifestFileNm']").focus();
			return true;
		}
	}*/
	
	<%-- 보안성 검토 (악성 코드 파일 업로드 가능성 - 파일 업로드 확장자) - 20200401 --%>
	var regExp =  /[\/?;:*^<>\\]/gi;
		
	var appFile = frm.find("input[name='appFileAttach']").val();
	if(appFile != "" && appFile != null) {
		var type = appFile.slice(appFile.lastIndexOf(".") + 1).toLowerCase();
		if (!(type == "apk" || type == "ipa" )) {
			alert("<mink:message code='mink.message.alert.fileupload.file'/>");
			frm.find("input[name='appFileAttach']").val("");
		    return true;
		}
		var tmp = appFile.slice(appFile.lastIndexOf("\\") + 1).toLowerCase();
		var name = tmp.substr(0, tmp.lastIndexOf("."));
		if(regExp.test(name)) {
			alert("<mink:message code='mink.message.alert.fileupload.filename'/>");
			frm.find("input[name='appFileAttach']").val("");
			return true;
		}
	}
	
	var manifestFile = frm.find("input[name='manifestFileAttach']").val();
	if(manifestFile != "" && manifestFile != null) {
		var type = manifestFile.slice(manifestFile.lastIndexOf(".") + 1).toLowerCase();
		if (!(type == "plist" )) {
			alert("<mink:message code='mink.message.alert.fileupload.file'/>");
			frm.find("input[name='manifestFileAttach']").val("");
		    return true;
		}
		var tmp = manifestFile.slice(manifestFile.lastIndexOf("\\") + 1).toLowerCase();
		var name = tmp.substr(0, tmp.lastIndexOf("."));
		if(regExp.test(name)) {
			alert("<mink:message code='mink.message.alert.fileupload.filename'/>");
			frm.find("input[name='manifestFileAttach']").val("");
			return true;
		}
	}
	
	return result;
}

<%-- 버전상세조회호출(ajax) --%>
function goVersionDetail(appId, versionNo) {
	checkedTrCheckbox($("#listTr"+appId+'v'+versionNo));	<%-- 선택된 row 색깔변경 --%>
	$("#verDetailFrm").find("input[name='appId']").val(appId); <%-- (선택한)상세 --%>
	$("#verDetailFrm").find("input[name='versionNo']").val(versionNo); <%-- (선택한)상세 --%>
	$("#spanVerUpdate").show();
	$("#spanVerInsert").hide();
	ajaxComm('appVersionDetail.miaps?', $('#verDetailFrm'), function(data){
		fnVersionDetailMapping(data.version); <%-- 상세 ajax 세부작업 --%>
	});
	
	//goToBottomPage("#app-version-detail", 800);
	$("#appVersionRegModiDialog").dialog( "open" );
}

function openAppVersionRegDialog() {
	$("#appVersionRegModiDialog").dialog( "open" );
}

$("#appVersionRegModiDialog").dialog({
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