<%-- 앱 등록 다이얼로그 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div id="appRegDialog" title="<mink:message code='mink.web.text.registapp'/>" class="dlgStyle">
<div class="miaps-popup-top-buttons">
	&nbsp;
	<span><button class='btn-dash' onclick="javascript:goInsert();"><mink:message code="mink.web.text.save"/></button></span>
	<span><button class='btn-dash' onclick="javascript:$('#appRegDialog').dialog('close');"><mink:message code="mink.web.text.cancel"/></button></span>
</div>
<form id="insertFrm" name="insertFrm" method="post" enctype="multipart/form-data" onSubmit="return false;">
	<input type="hidden" name="regNo" value="${loginUser.userNo}"/>	<%-- 로그인한 사용자 --%>
	<input type="hidden" name="searchKey" value=""/>	<%-- 검색조건 --%>
	<input type="hidden" name="searchValue" value=""/>	<%-- 검색조건 --%>
	<input type="hidden" name="regSt" value="${APP_REG_ST}" /> <%-- 일단 디폴트값(9)으로 지정 --%>
	<input type="hidden" name="launcherYn" value="Y" /> <%-- 일단 론처에표시(Y)로 디폴트값 지정 --%>
	<input type="hidden" name="mainappYn" value="Y" /> <!-- 종속앱 여부는 디폴트로 대표앱(Y)으로 등록함 -->
	
	<%--
	<div><h3><span>* 앱 등록</span></h3></div>
	--%>
	<table class="insertTb" border="0" cellspacing="0" cellpadding="0" width="100%">
		<colgroup>
			<col width="15%" />
			<col width="35%" />
			<col width="15%" />
			<col width="35%" />
		</colgroup>
		<tbody>
			<tr>
				<th><span class="criticalItems"><mink:message code="mink.web.text.appname"/></span></th>
				<td><input type="text" name="appNm" /></td>
				<th><span class="criticalItems tooltip" title="<mink:message code='mink.web.message1'/>"><mink:message code="mink.web.text.apppackagename"/></span></th>
				<td><input type="text" name="packageNm" /></td>
			</tr>
			<tr>
				<th><span class="criticalItems"><mink:message code="mink.web.text.platform"/></span></th>
				<td>
					<select class="selectSpace" name="platformCd" onchange="javascript:onChangePlatform_reg(this.value);">
						<option value="${PLATFORM_ANDROID}">Android Phone</option>
						<option value="${PLATFORM_ANDROID_TBL}">Android Tablet</option>
						<option value="${PLATFORM_IOS}">iPhone</option>
						<option value="${PLATFORM_IOS_TBL}">iPad</option>
						<option value="${PLATFORM_WEB}">Web</option>
					</select>
				</td>
				<th><span class="criticalItems tooltip" title="<mink:message code='mink.web.message4'/>"><mink:message code="mink.web.text.apppermission"/></span></th>
				<td>
					<label><input type="radio" name="publicYn" value="Y" checked="checked" /><mink:message code="mink.web.text.commonapp"/></label>
					<label><input type="radio" name="publicYn" value="N" /><mink:message code="mink.web.text.permissionapp"/></label>
					<label><input type="radio" name="publicYn" value="P" /><mink:message code="mink.web.text.nopublic"/></label>
				</td>
			</tr>
			<tr id="tr_reg_cls">
				<!-- <th><mink:message code="mink.web.text.android.package"/></th> -->
				<th><span class="criticalItems"><mink:message code="mink.web.text.reg.class"/></th>
				<td>
					<label><input type="radio" name="reg_type" value="P" checked="checked" onchange="javascript:onChange_regType(this.value);" /><mink:message code="mink.web.text.package.scheme"/></label>
					<label><input type="radio" name="reg_type" value="W" onchange="javascript:onChange_regType(this.value);"/><mink:message code="mink.web.text.app.url"/></label>					
				</td>				
			</tr>
			<tr id="tr_reg_androidPackage">
				<th><mink:message code="mink.web.text.android.package"/></th>
				<td><input type="text" name="androidPackage" /></td>
				<th><mink:message code="mink.web.text.scheme"/></th>
				<td><input type="text" name="appScheme_android" /><input type="hidden" name="appScheme" /></td>
			</tr>
			<tr id="tr_reg_bundleId" style="display: none;">
				<th><span class="criticalItems"><mink:message code="mink.web.text.bundleid"/></span></th>
				<td><input type="text" name="bundleId" /></td>
				<th><mink:message code="mink.web.text.scheme"/></th>
				<td><input type="text" name="appScheme_ios" /></td>
			</tr>
			<tr id="tr_reg_appUrl" style="display: none;">
				<th><span class="criticalItems" ><mink:message code="mink.web.text.appurl"/></span></th>
				<td colspan="3">
					<input type="text" name="appUrl" style="width: 100%;" />
					<%-- 2019.09.17 코오롱 적용 기능으로 삭제 chlee --%>
					<label style="display: none;"><input type="checkbox" name="webParamYn" value="Y" style="width: 20px;" /><mink:message code="mink.web.text.exist.param"/></label>					 
				</td>
			</tr>
			<tr>
				<th><mink:message code="mink.web.text.icon.small"/></th>
				<td colspan="3"><input type="file" name="smallIconFile" accept="image/*"><td>
			</tr>
			<tr>
				<th><mink:message code="mink.web.text.icon.large"/></th>
				<td colspan="3"><input type="file" name="bigIconFile" accept="image/*"><td>
			</tr>
			<tr>
				<th><mink:message code="mink.web.text.description.app"/></th>
				<td colspan="3">
					<textarea name="appDesc" style="width:100%;overflow:visible;" onmouseup="textareaResize(this)" onkeyup="textareaResize(this)"></textarea>
				</td>
			</tr>
			<tr>
				<th><mink:message code="mink.web.text.supplier.nm"/></th>
				<td colspan=3><input type="text" name="supplierNm" /></td>
			</tr>
		</tbody>
		<tfoot></tfoot>
	</table>
	<%--
	String tmpAppRoleYn = com.thinkm.mink.commons.util.MinkConfig.getConfig().get("miaps.app.role.yn");
	if (tmpAppRoleYn == null) {
		tmpAppRoleYn = "N";
	}
	if ("Y".equalsIgnoreCase(tmpAppRoleYn)) {
	%>
	<div><span style="font: italic 13px 맑은 고딕, 돋움, arial; color:#39f;">"앱 사용 권한" 항목에서 "공통 아님(권한 필요)"을 선택 하여 저장 할 경우 앱 패키지 명 단위로 사용 권한을 추가로 입력 할 수 있습니다.</span></div>
	<%} --%>
</form>
</div>

<script type="text/javascript">
function onChangePlatform_reg(platform) {
	// 플랫폼별 입력항목 닫기
	$("#tr_reg_androidPackage").hide();
	$("#tr_reg_bundleId").hide();
	$("#tr_reg_appUrl").hide();

	// 입력항목 값 초기화
	$("#insertFrm").find(":input[name='androidPackage']").val("");
	$("#insertFrm").find(":input[name='appScheme_android']").val("");
	$("#insertFrm").find(":input[name='appScheme']").val("");
	$("#insertFrm").find(":input[name='bundleId']").val("");
	$("#insertFrm").find(":input[name='appScheme_ios']").val("");
	$("#insertFrm").find(":input[name='appUrl']").val("");
	$("#insertFrm").find(":input[name='webParamYn']").get(0).checked = false;
	
	// 등록 구분(패키지/스킴 : 앱 URL) 2020.09 KMD 추가
	$("input:radio[name='reg_type']:radio[value='P']").prop('checked', true);
	
	// 플랫폼별 입력항목 열기
	if (platform == '${PLATFORM_ANDROID}' || platform == '${PLATFORM_ANDROID_TBL}') {
		$("#tr_reg_cls").show();
		$("#tr_reg_androidPackage").show();
	} else if (platform == '${PLATFORM_IOS}' || platform == '${PLATFORM_IOS_TBL}') {
		$("#tr_reg_cls").show();
		$("#tr_reg_bundleId").show();
	} else if (platform == '${PLATFORM_WEB}') {
		$("#tr_reg_cls").hide();
		$("#tr_reg_appUrl").show();
	}
}

function onChange_regType(reg_cls) {
	// 입력항목 값 초기화
	$("#insertFrm").find(":input[name='androidPackage']").val("");
	$("#insertFrm").find(":input[name='appScheme_android']").val("");
	$("#insertFrm").find(":input[name='appScheme']").val("");
	$("#insertFrm").find(":input[name='bundleId']").val("");
	$("#insertFrm").find(":input[name='appScheme_ios']").val("");
	$("#insertFrm").find(":input[name='appUrl']").val("");
	$("#insertFrm").find(":input[name='webParamYn']").get(0).checked = false;

	
	// 등록 구분 입력항목 열기
	if (reg_cls == 'P') {	// 패키지/스킴 , 번들
		
		// 현재 선택된 플랫폼 값
		var cur_platform = $("[name=platformCd]").val();	
		// 플랫폼별 입력항목 열기
		if (cur_platform == '${PLATFORM_ANDROID}' || cur_platform == '${PLATFORM_ANDROID_TBL}') {		
			$("#tr_reg_androidPackage").show();			
		} else if (cur_platform == '${PLATFORM_IOS}' || cur_platform == '${PLATFORM_IOS_TBL}') {
			$("#tr_reg_bundleId").show();
		}
		$("#tr_reg_appUrl").hide();
	} else if (reg_cls == 'W') {
		$("#tr_reg_androidPackage").hide();
		$("#tr_reg_bundleId").hide();
		$("#tr_reg_appUrl").show();		
	}	
}

function goInsert() {
	if(validation_reg($("#insertFrm"))) return; <%-- 입력 값 검증 --%>

	if(!confirm("<mink:message code='mink.web.alert.is.regist'/>")) return;
	validateWeburlParam($("#insertFrm"));

    ajaxFileComm('appInsert.miaps?', $("#insertFrm"), function(data){
    	if (data.msg == undefined) {
    		alert("<mink:message code='mink.web.alert.fail.regist'/>");
    	} else {
    		alert(data.msg);
    		if (data.app) {
    			$("#SearchFrm").find("input[name='appId']").val(data.app.appId); <%-- (등록한)상세 --%>
    		}
    	}
		goList('1'); <%-- 목록/검색(1 페이지로 초기화) --%>
    });
}

<%-- 입력 값 검증 --%>
function validation_reg(frm) {
	var result = false;
	
	if( frm.find("input[name='appNm']").val()=="" ) {
		alert("<mink:message code='mink.web.input.appname'/>");
		frm.find("input[name='appNm']").focus();
		return true;
	}
	var packageNm = $.trim(frm.find("input[name='packageNm']").val().replace(/ /g, '')); // 모든공백제거
	frm.find("input[name='packageNm']").val(packageNm);
	if( frm.find("input[name='packageNm']").val()=="" ) {
		alert("<mink:message code='mink.web.input.packagename'/>");
		frm.find("input[name='packageNm']").focus();
		return true;
	}
	var platformCd = frm.find("select[name='platformCd']").val();
	if (platformCd=="${PLATFORM_ANDROID}" || platformCd=="${PLATFORM_ANDROID_TBL}") {
		// 현재 등록 구분값( P:패키지/스킴, W:앱 URL )
		var c_reg_type = $("input[name=reg_type]:checked").val();
		if (c_reg_type == 'P') {			// 패키지/스킴 , 번들
			// 플랫폼이 Android Phone, Android Tablet 일 경우
			var appScheme = frm.find("input[name='appScheme_android']").val();
			frm.find("input:hidden[name='appScheme']").val(appScheme);
		} else if (c_reg_type == 'W') {		// 앱 URL
			var appUrl = $.trim(frm.find("input[name='appUrl']").val().replace(/ /g, '')); // 모든공백제거
			frm.find("input[name='appUrl']").val(appUrl);
			if (frm.find("input[name='appUrl']").val() == "") {
				alert("<mink:message code='mink.web.input.appurl'/>");
				frm.find("input[name='appUrl']").focus();
				return true;
			}
			frm.find("input:hidden[name='androidPackage']").val("");
			frm.find("input:hidden[name='appScheme']").val("");
		}
		
	} else if (platformCd=="${PLATFORM_IOS}" || platformCd=="${PLATFORM_IOS_TBL}") {
		// 현재 등록 구분값( P:패키지/스킴, W:앱 URL )
		var c_reg_type = $("input[name=reg_type]:checked").val();
		if (c_reg_type == 'P') {			// 패키지/스킴 , 번들
			// 플랫폼이 iPhone, iPad 일 경우
			var bundleId = frm.find("input[name='bundleId']").val();
			if (bundleId == "") {
				alert("<mink:message code='mink.web.input.bundleid'/>");
				frm.find("input[name='bundleId']").focus();
				return true;
			}
			frm.find("input[name='androidPackage']").val(bundleId);
			var appScheme = frm.find("input[name='appScheme_ios']").val();
			frm.find(":input:hidden[name='appScheme']").val(appScheme);
		} else if (c_reg_type == 'W') {		// 앱 URL
			var appUrl = $.trim(frm.find("input[name='appUrl']").val().replace(/ /g, '')); // 모든공백제거
			frm.find("input[name='appUrl']").val(appUrl);
			if (frm.find("input[name='appUrl']").val() == "") {
				alert("<mink:message code='mink.web.input.appurl'/>");
				frm.find("input[name='appUrl']").focus();
				return true;
			}
			frm.find("input:hidden[name='androidPackage']").val("");
			frm.find("input:hidden[name='appScheme']").val("");
		}		
	} else if (platformCd=="${PLATFORM_WEB}") {
		// 플랫폼이 Web 일 경우
		var appUrl = $.trim(frm.find("input[name='appUrl']").val().replace(/ /g, '')); // 모든공백제거
		frm.find("input[name='appUrl']").val(appUrl);
		if (frm.find("input[name='appUrl']").val() == "") {
			alert("<mink:message code='mink.web.input.appurl'/>");
			frm.find("input[name='appUrl']").focus();
			return true;
		}
		frm.find("input:hidden[name='androidPackage']").val("");
		frm.find("input:hidden[name='appScheme']").val("");
	}

	<%-- 보안성 검토 (악성 코드 파일 업로드 가능성 - 파일 업로드 확장자) - 20200401 --%>
	var regExp =  /[\/?;:*^<>\\]/gi;
	
	var smallIcon = frm.find("input[name='smallIconFile']").val();
	if(smallIcon != "" && smallIcon != null) {
		var type = smallIcon.slice(smallIcon.lastIndexOf(".") + 1).toLowerCase();
		if (!(type == "gif" || type == "jpg" || type == "png" || type == "jpeg")) {
			alert("<mink:message code='mink.message.alert.fileupload.image'/>");
			frm.find("input[name='smallIconFile']").val("");
		    return true;
		}
		var tmp = smallIcon.slice(smallIcon.lastIndexOf("\\") + 1).toLowerCase();
		var name = tmp.substr(0, tmp.lastIndexOf("."));
		if(regExp.test(name)) {
			alert("<mink:message code='mink.message.alert.fileupload.filename'/>");
			frm.find("input[name='smallIconFile']").val("");
			return true;
		}
	}

	var bigIcon = frm.find("input[name='bigIconFile']").val();
	if(bigIcon != "" && bigIcon != null) {
		var type = bigIcon.slice(bigIcon.lastIndexOf(".") + 1).toLowerCase();
		if (!(type == "gif" || type == "jpg" || type == "png" || type == "jpeg")) {
			alert("<mink:message code='mink.message.alert.fileupload.image'/>");
			frm.find("input[name='bigIconFile']").val("");
		    return true;
		}
		var tmp = bigIcon.slice(bigIcon.lastIndexOf("\\") + 1).toLowerCase();
		var name = tmp.substr(0, tmp.lastIndexOf("."));
		if(regExp.test(name)) {
			alert("<mink:message code='mink.message.alert.fileupload.filename'/>");
			frm.find("input[name='bigIconFile']").val("");
			return true;
		}
	}
	
	return result;
}

function openAppRegDialog() {
	$("#appRegDialog").dialog( "open" );
}

$("#appRegDialog").dialog({
	autoOpen: false,
    resizable: false,
    width: '55%',
    modal: true,
	// add a close listener to prevent adding multiple divs to the document
    close: function(event, ui) {
        // remove div with all data and events
        $(this).dialog( "close" );
    }
    <%--
    buttons: {
		"저장": goInsert,
        "취소": function() {
        	$(this).dialog( "close" );
        }
	}
	--%>
});
</script>