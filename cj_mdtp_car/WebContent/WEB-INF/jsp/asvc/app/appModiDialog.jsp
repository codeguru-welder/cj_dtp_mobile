<%-- 앱 수정 다이얼로그 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div id="appModiDialog" title="<mink:message code='mink.web.text.info.appdetail'/>" class="dlgStyle">
	<div id="container_app_detail">
		<ul class="tabs_appRole">
			<li class="active" rel="main_tab1"><mink:message code="mink.web.text.info.appdetail"/></li>
			<li rel="main_tab2"><mink:message code="mink.web.text.info.appversion"/></li>
			<li id="appRoleLi1" style="display:none; width:145px;" rel="main_tab3"><mink:message code="mink.web.text.apppermission.group"/></li>
			<li id="appRoleLi2" style="display:none;width:136px;" rel="main_tab4"><mink:message code="mink.web.text.apppermission.user"/></li>
			<li rel="main_tab5"><mink:message code="mink.web.text.info.appdependent"/></li>
		</ul>
		<div class="tab_container_appRole">
		<!-- #tab1 앱 상세 정보 -->
			<div id="main_tab1" class="tab_content_appRole">
				<div class="miaps-popup-top-buttons-in-tap">
					&nbsp;
					<span><button class='btn-dash' onclick="javascript:goUpdate();"><mink:message code="mink.web.text.modify"/></button></span>
					<span><button class='btn-dash' onclick="javascript:$('#appModiDialog').dialog('close');"><mink:message code="mink.web.text.cancel"/></button></span>
				</div>
				<form id="detailFrm" name="detailFrm" method="POST" enctype="multipart/form-data" onsubmit="return false;">
					<input type="hidden" name="updNo" value="${loginUser.userNo}"/>	<%-- 로그인한 사용자 --%>
					<%-- <input type="hidden" name="appId" value=""/>	key --%>
					<input type="hidden" name="searchKey" value=""/>	<%-- 검색조건 --%>
					<input type="hidden" name="searchValue" value=""/>	<%-- 검색조건 --%>
					<input type="hidden" name="prePackageNm" value=""/>	<%-- 앱 패키지 명 수정시, 앱 메뉴의 패키지 이름 수정필수 --%>
					<input type="hidden" name="regSt" value="${APP_REG_ST}" /> <%-- 일단 디폴트값(9)으로 지정 --%>
					<input type="hidden" name="launcherYn" value="Y" /> <%-- 일단 론처에표시(Y)로 디폴트값 지정 --%>
					<input type="hidden" name="mainappYn" /> <%-- 종속 앱 여부 --%>
					<input type="hidden" name="mainappId" /> <%-- 종속 앱의 대표 앱ID --%>
					
					<%--
					<div><h3><span>* 앱 관리 상세정보</span></h3>	</div>
					--%>

					<table class="detailTb" border="0" cellspacing="0" cellpadding="0" width="100%">
						<colgroup>
							<col width="10%" />
							<col width="40%" />
							<col width="10%" />
							<col width="40%" />
						</colgroup>
						<tbody>
							<tr>
								<th><span class="criticalItems"><mink:message code="mink.web.text.appid"/></span></th>
								<td><input type="text" name="appId" readonly="readonly" /></td>
								<th>&nbsp;</th>
								<td>&nbsp;</td>
							</tr>
							<tr>
								<th><span class="criticalItems"><mink:message code="mink.web.text.appname"/></span></th>
								<td><input type="text" name="appNm" /></td>
								<th><span class="criticalItems tooltip" title="<mink:message code='mink.web.message1'/>"><mink:message code="mink.web.text.packagename"/></span></th>
								<td><input type="text" name="packageNm" /></td>
							</tr>
							<tr>
								<th><span class="criticalItems"><mink:message code="mink.web.text.platform"/></span></th>
								<td>
									<select class="selectSpace" name="platformCd" id="modi_platformCd" onchange="javascript:onChangePlatform(this.value);">
										<option value="${PLATFORM_ANDROID}">Android Phone</option>
										<option value="${PLATFORM_ANDROID_TBL}">Android Tablet</option>
										<option value="${PLATFORM_IOS}">iPhone</option>
										<option value="${PLATFORM_IOS_TBL}">iPad</option>
										<option value="${PLATFORM_WEB}">Web</option>
									</select>
								</td>
								<th><span class="criticalItems tooltip" title="<mink:message code='mink.web.message2'/>"><mink:message code="mink.web.text.apppermission"/></span></th>
								<td>
									<label><input type="radio" name="publicYn" value="Y" /><mink:message code="mink.web.text.commonapp"/></label>
									<label><input type="radio" name="publicYn" value="N" /><mink:message code="mink.web.text.permissionapp"/></label>
									<label><input type="radio" name="publicYn" value="P" /><mink:message code="mink.web.text.nopublic"/></label>
								</td>
							</tr>
							<tr id="tr_modi_cls">
								<!-- <th><mink:message code="mink.web.text.android.package"/></th> -->
								<th><span class="criticalItems"><mink:message code="mink.web.text.reg.class"/></th>
								<td>
									<label><input type="radio" name="modi_type" value="P" checked="checked" onchange="javascript:onChange_modi_cls(this.value);"/><mink:message code="mink.web.text.package.scheme"/></label>
									<label><input type="radio" name="modi_type" value="W" onchange="javascript:onChange_modi_cls(this.value);"/><mink:message code="mink.web.text.app.url"/></label>					
								</td>				
							</tr>
							<tr id="tr_modi_androidPackage">
								<th><mink:message code="mink.web.text.android.package"/></th>
								<td><input type="text" name="androidPackage" /></td>
								<th><mink:message code="mink.web.text.scheme"/></th>
								<td><input type="text" name="appScheme_android" /><input type="hidden" name="appScheme" /></td>
							</tr>
							<tr id="tr_modi_bundleId" style="display: none;">
								<th><span class="criticalItems"><mink:message code="mink.web.text.bundleid"/></span></th>
								<td><input type="text" name="bundleId" /></td>
								<th><mink:message code="mink.web.text.scheme"/></th>
								<td><input type="text" name="appScheme_ios" /></td>
							</tr>
							<tr id="tr_modi_appUrl">
								<th><span class="criticalItems"><mink:message code="mink.web.text.appurl"/></span></th>
								<td colspan="3">
									<input type="text" name="appUrl" style="width: 100%;" />
									<%-- 2019.09.17 코오롱 적용 기능으로 삭제 chlee --%>
									<label style="display: none;"><input type="checkbox" name="webParamYn" value="Y" style="width: 20px;" /><mink:message code="mink.web.text.exist.param"/></label>									
								</td>
							</tr>
							<tr>
								<th><mink:message code="mink.web.text.icon.small"/></th>
								<td colspan="3">
									<span id="smallIconImg"></span> <span id="smallIconNm"></span>
									<input type="file" id="smallIconFile" name="smallIconFile" accept="image/*">
								</td>
							</tr>
							<tr>
								<th><mink:message code="mink.web.text.icon.large"/></th>
								<td colspan="3">
									<span id="bigIconImg"></span> <span id="bigIconNm"></span>
									<input type="file" id="bigIconFile" name="bigIconFile" accept="image/*">
								</td>
							</tr>
							<tr>
								<th><mink:message code="mink.web.text.description.app"/></th>
								<td colspan="3">
									<textarea name="appDesc" style="width:100%;overflow:visible;" onmouseup="textareaResize(this)" onkeyup="textareaResize(this)"></textarea>
								</td>
							</tr>
							<tr>
								<th><mink:message code="mink.web.text.externalapp.id"/></th>
								<td><input type="text" name="extAppId" /></td>
								<th><mink:message code="mink.web.text.android.activity"/></th>
								<td><input type="text" name="androidActivity" /></td>
							</tr>
							<tr>
								<th><mink:message code="mink.web.text.admin.email"/></th>
								<td><input type="text" name="emailAddr" /></td>
								<th><mink:message code="mink.web.text.admin.pnumber"/></th>
								<td><input type="text" name="phoneNo" /></td>
							</tr>
							<tr>
								<th><mink:message code="mink.web.text.supplier.nm"/></th>
								<td colspan=3><input type="text" name="supplierNm" /></td>
							</tr>
							<tr>
								<th><mink:message code="mink.web.text.externalinstall.url"/></th>
								<td colspan="3">
									<textarea readonly="readonly" id="installUrlEx" name="installUrlEx" style="width:100%;overflow:visible;" rows="3"></textarea>
								</td>
							</tr>
						</tbody>
					</table>
					<%--
					String tmpAppRoleYn2 = com.thinkm.mink.commons.util.MinkConfig.getConfig().get("miaps.app.role.yn");
					if (tmpAppRoleYn2 == null) {
						tmpAppRoleYn2 = "N";
					}
					if ("Y".equalsIgnoreCase(tmpAppRoleYn2)) {
					%>
					<div><span style="font: italic 13px 맑은 고딕, 돋움, arial; color:#39f;">"앱 사용 권한" 항목에서 "공통 아님(권한 필요)"을 선택 하여 저장 할 경우 앱 패키지 명 단위로 사용 권한을 추가로 입력 할 수 있습니다.</span></div>
					<%} --%>
				</form>
			</div>
		<!-- #tab2 앱 버전 정보 -->
			<div id="main_tab2" class="tab_content_appRole"> 
				<div class="miaps-popup-top-buttons-in-tap">
					&nbsp;
					<span><button class='btn-dash' onclick="javascript:goVerInsertShow();"><mink:message code="mink.web.text.add.appversion"/></button></span>
					<span><button class='btn-dash' onclick="javascript:$('#appModiDialog').dialog('close');"><mink:message code="mink.web.text.cancel"/></button></span>
				</div>
				<table class="listTb" id="verListTb" border="0" cellspacing="0" cellpadding="0" width="100%" class="listTb">
					<colgroup>
						<col width="6%" />
						<col width="8%" />
						<col width="8%" />
						<col width="8%" />
						<col width="8%" />
						<col width="12%" />
						<col width="12%" />
						<col width="38%" />
					</colgroup>
					<thead>
						<tr>
							<td><mink:message code="mink.web.text.versionno"/></td>
							<td><mink:message code="mink.web.text.version"/></td>
							<td><mink:message code="mink.web.text.version.store"/></td>
							<td><mink:message code="mink.web.text.is.use"/></td>
							<td><mink:message code="mink.web.text.forced.update"/></td>
							<td><mink:message code="mink.web.text.regdate"/></td>
							<td><mink:message code="mink.web.text.moddate"/></td>
							<td><mink:message code="mink.web.text.description.version"/></td>
						</tr>
					</thead>
					<tbody>
					</tbody>
					<tfoot></tfoot>
				</table>
				<div id="paginateDiv2"></div>
			</div>
		<!-- #tab3 앱 권한 - 그룹 -->
			
			<form id="searchFrm3" name="searchFrm3" method="POST" onsubmit="return false;">							
				<input type="hidden" name="pageNum" /><%-- 현재 페이지 --%>
				<input type="hidden" name="packageNm" />
				<input type="hidden" name="appId" />
				<input type="hidden" name="roleTp" /><!-- 구성원 유형(RG, UG, UN, UD) -->
			
				<div id="main_tab3" class="tab_content_appRole">
					<div class="miaps-popup-top-buttons-in-tap">
						&nbsp;
						<span><button id="insertUserGroupDialogOpenerButton" class='btn-dash' onclick="javascript:return false;"><mink:message code="mink.web.text.regist"/></button></span>
						<span><button class='btn-dash' onclick="deleteAppRole('UG');"><mink:message code="mink.web.text.delete"/></button></span>
						<span><button class='btn-dash' onclick="javascript:$('#appModiDialog').dialog('close');"><mink:message code="mink.web.text.cancel"/></button></span>
					</div>
					<div id="titleDetailDiv">
						<span style="font: italic 13px 맑은 고딕, 돋움, arial; color:#808080;"><mink:message code="mink.web.message3"/></span>				
					</div>
					<table class="listTb" id="appRoleListTbUG" class="read_listTb" border="0" cellspacing="0" cellpadding="0" width="100%">
						<colgroup>
							<col width="10%" />
							<col width="35%" />
							<col width="30%" />
							<col width="20%" />
						</colgroup>
						<thead>
							<tr>
								<td><input type="checkbox" name="CheckboxAll" /></td>
								<td><mink:message code="mink.web.text.usergroupname"/></td>
								<td><mink:message code="mink.web.text.usergroupid"/></td>
								<td><mink:message code="mink.web.text.is.include.under"/></td>
							</tr>
						</thead>
						<tbody id="listTbodyUG">
						</tbody>
					</table>
				</div>
				<div id="main_tab4" class="tab_content_appRole">
					<div class="miaps-popup-top-buttons-in-tap">
						&nbsp;
						<%-- 
						<span><button id="insertUserNoDialogOpenerButtonByLegacy" class='btn-dash' onclick="javascript:return false;">업체사용자등록</button></span> 
						--%>
						<span><button id="insertUserNoDialogOpenerButton" class='btn-dash' onclick="javascript:return false;"><mink:message code="mink.web.text.regist"/></button></span>
						<span><button class='btn-dash' onclick="deleteAppRole('UN');"><mink:message code="mink.web.text.delete"/></button></span>
						<span><button class='btn-dash' onclick="javascript:$('#appModiDialog').dialog('close');"><mink:message code="mink.web.text.cancel"/></button></span>
					</div>
					<table class="listTb" id="appRoleListTbUN" class="read_listTb" border="0" cellspacing="0" cellpadding="0" width="100%">
						<colgroup>
							<col width="10%" />
							<col width="40%" />
							<col width="50%" />
						</colgroup>
						<thead>
							<tr>
								<td><input type="checkbox" name="CheckboxAll" /></td>
								<td><mink:message code="mink.web.text.username.id"/></td>
								<td><mink:message code="mink.web.text.userno"/></td>
							</tr>
						</thead>
						<tbody id="listTbodyUN">									
						</tbody>
					</table>
				</div>			
			</form>
			
			<!-- #tab5 종속 앱 정보 -->
			<div id="main_tab5" class="tab_content_appRole">
				<form id="updateMainappYnFrm" name="updateMainappYnFrm" method="POST" onsubmit="return false;">
				<input type="hidden" name="appId" />
				<input type="hidden" name="preMainappYn" />
				<input type="hidden" name="dependencyIds" />

				<div class="miaps-popup-top-buttons-in-tap">
					&nbsp;
					<span><button class='btn-dash' onclick="javascript:goUpdateMainappYn();"><mink:message code="mink.web.text.save"/></button></span>
					<span><button class='btn-dash' onclick="javascript:$('#appModiDialog').dialog('close');"><mink:message code="mink.web.text.cancel"/></button></span>
				</div>
				<table class="detailTb" border="0" cellspacing="0" cellpadding="0" width="100%">
					<colgroup>
						<col width="10%" />
						<col width="90%" />
					</colgroup>
					<tbody>
						<tr>
							<th><span class="criticalItems"><mink:message code="mink.web.text.dependentapp"/></span></th>
							<td>
								<label><input type="radio" name="mainappYn" value="Y" style="width: 20%;" onchange="changedMainappYn('Y')" /><mink:message code="mink.web.text.represetativeapp"/></label>
								<label><input type="radio" name="mainappYn" value="N" style="width: 20%;" onchange="changedMainappYn('N')" /><mink:message code="mink.web.text.dependentapp"/></label>
								<span id="mainappYnSpan" style="display: none;">
									 	<mink:message code="mink.web.text.represetativeapp.name"/>
									<select name="mainappId" style="width: 60%;">
										<option value=""><mink:message code="mink.web.text.unselected"/></option>
									</select>
								</span>
							</td>
						</tr>
						<tr id="dependencyIdListTr">
							<th><mink:message code="mink.web.text.list.depedentapp.in.repapp"/></th>
							<td>
								<mink:message code="mink.web.text.dependentapp.name"/>
								<select name="dependencyId" style="width: 60%;">
									<option value=""><mink:message code="mink.web.text.unselected"/></option>
								</select>
								<span><button class='btn-mini' onclick="javascript:addDependencyId();"><mink:message code="mink.web.text.regist"/></button></span>
								<hr />
								<!-- 
								<span id="dependencyIdListSpan">
									<span>A앱 <a href="javascript:alert('A앱 삭제!');" style="color: blue;">삭제</a></span>
									<span><br />B앱 <a href="javascript:alert('B앱 삭제!');" style="color: blue;">삭제</a></span>
									<span><br />C앱 <a href="javascript:alert('C앱 삭제!');" style="color: blue;">삭제</a></span>
								</span>
								 -->
								<span id="dependencyIdListSpan"></span>
								<span id="dependencyIdEmptySpan" style="display: none;"><mink:message code="mink.web.alert.noexist.dependent.app"/></span>
							</td>
						</tr>
					</tbody>
					<tfoot></tfoot>
				</table>
				</form>
			</div>
			
		</div>
	</div>
<!-- .tab_container_appRole -->
</div>
<!-- #container_app_detail -->

<script type="text/javascript">
// 종속 앱 추가
function addDependencyId() {
	var appId = $("#updateMainappYnFrm").find(":input[name='appId']").val();
	var mainappYn = $("#updateMainappYnFrm").find(":input[name='mainappYn']:checked").val();
	var mainappId = $("#updateMainappYnFrm").find(":input[name='mainappId']").val();
	var dependencyId = $("#updateMainappYnFrm").find(":input[name='dependencyId']").val();
	var preMainappYn = nvl($("#updateMainappYnFrm").find(":input[name='preMainappYn']").val());

	// 이전에 종속 앱이었으면, 먼저 대표 앱으로 수정하도록 함
	if (preMainappYn == "N") {
		alert("<mink:message code='mink.web.alert.is.norespapp'/>");
		return;
	}
	if (mainappYn == "N") {
		alert("<mink:message code='mink.web.alert.select.respapp'/>");
		$("#updateMainappYnFrm").find(":input[name='mainappYn'][value='Y']").focus();
		return;
	}
	if (dependencyId == "") {
		alert("<mink:message code='mink.web.alert.select.dependentapp'/>");
		$("#updateMainappYnFrm").find(":input[name='dependencyId']").focus();
		return;
	}
	if (dependencyId == appId) {
		alert("<mink:message code='mink.web.alert.select.otherapp'/>");
		$("#updateMainappYnFrm").find(":input[name='dependencyId']").focus();
		return;
	}

	if(confirm("<mink:message code='mink.web.alert.is.regist'/>")) {
		$.post('appMainappYnUpdate.miaps?', {appId: dependencyId, mainappId: appId, mainappYn: 'N'}, function(data){
			resultMsg(data.msg);
			if (data.mainappId != null) {
				$("#SearchFrm").find("input[name='appId']").val(data.mainappId);
				goList($("#SearchFrm").find("input[name='pageNum']").val());
			}
		}, 'json');
	}
}
</script>

<script type="text/javascript">
<%-- 버전 삭제 후 목록 호출 --%>
function goVerDelete() {

	if(!confirm("<mink:message code='mink.web.alert.is.delete'/>")) return;

	ajaxFileComm('appVersionDelete.miaps?', $("#verDetailFrm"), function(data){
    	resultMsg(data.msg);
		$("#searchFrm2").find("input[name='appId']").val(data.version.appId);	// 상세조회 key
		$("#searchFrm2").find("input[name='versionNo']").val(data.version.versionNo);	// 상세조회 key
		goVersionList($("#searchFrm2").find("input[name='pageNum']").val()); // 목록/검색
    });

}

function goUpdate() {
	if(fileTypeCheck($("#detailFrm"))) return; <%-- 보안성 검토 (악성 코드 파일 업로드 가능성 - 파일 업로드 확장자) - 20200331 --%>
	if(validation($("#detailFrm"))) return; <%-- 입력 값 검증 --%>
	if(!confirm("<mink:message code='mink.web.alert.is.save'/>")) return;

	validateWeburlParam($("#detailFrm"));

	ajaxFileComm('appUpdate.miaps?', $("#detailFrm"), function(data){
    	if (data.msg == undefined) {
    		alert("<mink:message code='mink.web.alert.fail.save'/>");
    	} else {
    		resultMsg(data.msg);
    		if (data.app) {
    			$("#SearchFrm").find("input[name='appId']").val(data.app.appId);	<%-- 상세조회 key --%>
    		}    		
    	}
		goList($("#SearchFrm").find("input[name='pageNum']").val()); <%-- 목록/검색 --%>
    });
}

<%-- 보안성 검토 (악성 코드 파일 업로드 가능성 - 파일 업로드 확장자) - 20200331 --%>
function fileTypeCheck(frm) {
	var result = false;
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

//앱 권한: 권한그룹(RG), 사용자그룹(UG) 하위조직포함여부 수정
function updateMenuRole(menuNm, roleTp, roleId, checkbox) {
	var packageNm = $("#searchFrm3").find("input[name='packageNm']").val();
	var appId = $("#searchFrm3").find("input[name='appId']").val();
	var includeSubYn = '';
	
	var alertText = "";
	
	if('RG' == roleTp) {
		alertText = menuNm + "<mink:message code='mink.web.text.permission.under.permission'/>";
	}
	else if('UG' == roleTp) {
		alertText = menuNm + "<mink:message code='mink.web.text.group.under.group'/>";
	}
	
	if(checkbox.checked) {
		alertText += "<mink:message code='mink.web.alert.is.include'/>";
		includeSubYn = 'Y';
	}
	else {
		alertText += "<mink:message code='mink.web.alert.exclude'/>";
		includeSubYn = 'N';
	}
	
	if(!confirm(alertText)) {
		if(checkbox.checked) checkbox.checked = false;
		else checkbox.checked = true;
		return;
	}
	
	$.post('appRoleUpdateIncludeSubYn.miaps?', {packageNm: packageNm, roleTp: roleTp, roleId: roleId, includeSubYn: includeSubYn}, function(data){
		resultMsg(data.msg);
		goDetail(appId);
	}, 'json');
	
}

// 앱 권한 (유형별) 삭제(다수)
function deleteAppRole(mode) {
	var RG = "RG"; // roleTp: 권한 그룹
	var UG = "UG"; // roleTp: 사용자 그룹
	var UN = "UN"; // roleTp: 사용자NO
	<%-- var UD = "UD"; // roleTp: 사용자ID --%>
	
	var $checkeds = $();
	var alertText = "";
	
	if(mode == RG) {
		document.searchFrm3.roleTp.value = RG;
		$checkeds = $(":checkbox[name$='List']:checked", "#listTbodyRG");
		alertText = "<mink:message code='mink.web.alert.is.delete.from.permissiongroup'/>";
	}
	else if(mode == UG) {
		document.searchFrm3.roleTp.value = UG;
		$checkeds = $(":checkbox[name$='List']:checked", "#listTbodyUG");
		alertText = "<mink:message code='mink.web.alert.is.delete.from.usergroup'/>";
	}
	else if(mode == UN) {
		document.searchFrm3.roleTp.value = UN;
		$checkeds = $(":checkbox[name$='List']:checked", "#listTbodyUN");
		alertText = "<mink:message code='mink.web.alert.is.delete.from.user'/>";
	}
	<%--
	else if(mode == UD) {
		document.searchFrm3.roleTp.value = UD;
		$checkeds = $(":checkbox[name$='List']:checked", "#listTbodyUD");
		alertText = "사용자에서 삭제하시겠습니까?";
	}
	--%>
	
	if($checkeds.length < 1) {
		alert("<mink:message code='mink.web.alert.select.item'/>");
		return;
	}
	
	alertText = "<mink:message code='mink.web.text.total'/>" + $checkeds.length + "<mink:message code='mink.web.text.count.person'/>" + "\n" + alertText;
	
	if(!confirm(alertText)) {
		return;
	}
	
	var appId = $("#searchFrm3").find("input[name='appId']").val();
	ajaxComm('appRoleDelete.miaps?', document.searchFrm3, function(data){
		resultMsg(data.msg);
		goDetail(appId);
	});
}

function changedMainappYn(yn) {
	if (yn == "Y") {
		$("#updateMainappYnFrm").find(":input[name='mainappId']").val("");
		$("#updateMainappYnFrm").find(":input[name='mainappId']").prop('disabled', true);
		$("#mainappYnSpan").hide();
		$("#dependencyIdListTr").show();
	} else {
		$("#updateMainappYnFrm").find(":input[name='mainappId']").prop('disabled', false);
		$("#mainappYnSpan").show();
		$("#dependencyIdListTr").hide();
	}
}

// 종속 앱 정보 수정
function goUpdateMainappYn() {
	var mainappYn = nvl($("#updateMainappYnFrm").find(":input[name='mainappYn']:checked").val());
	var mainappId = nvl($("#updateMainappYnFrm").find(":input[name='mainappId']").val());
	var preMainappYn = nvl($("#updateMainappYnFrm").find(":input[name='preMainappYn']").val());

	if (mainappYn == "Y") {
		$("#updateMainappYnFrm").find(":input[name='mainappId']").val("");
	} else if (mainappYn == "N") {
		// 이전에 대표 앱이었으면, 종속 앱이 있는지 검증
		if (preMainappYn == "Y") {
			var dependencyIds = nvl($("#updateMainappYnFrm").find(":input[name='dependencyIds']").val());
			if (dependencyIds.length > 0) {
				alert("<mink:message code='mink.web.alert.delete.origin.dependentapp'/>");
				$("#updateMainappYnFrm").find(":input[name='mainappYn'][value='Y']").click();
				return;
			}
		}
		if (mainappId == "") {
			alert("<mink:message code='mink.web.alert.select.respapp'/>");
			$("#updateMainappYnFrm").find(":input[name='mainappId']").focus();
			return;
		}
	} else {
		alert("<mink:message code='mink.web.alert.select.dependentapp.status'/>");
		$("#updateMainappYnFrm").find(":input[name='mainappYn'][value='Y']").focus();
		return;
	}

	if(confirm("<mink:message code='mink.web.alert.is.save'/>")) {
		var appId = $("#updateMainappYnFrm").find(":input[name='appId']").val();
		ajaxComm('appMainappYnUpdate.miaps?', document.updateMainappYnFrm, function(data){
			resultMsg(data.msg);
			if (data.appId != null) {
				$("#SearchFrm").find("input[name='appId']").val(data.appId);
				goList($("#SearchFrm").find("input[name='pageNum']").val());
			}
		});
	}
}

function onChangePlatform(platform) {
	// 플랫폼별 입력항목 닫기
	$("#tr_modi_androidPackage").hide();
	$("#tr_modi_bundleId").hide();
	$("#tr_modi_appUrl").hide();

	// 등록 구분(패키지/스킴 : 앱 URL) 2020.09 KMD 추가
	$("input:radio[name='modi_type']:radio[value='P']").prop('checked', true);
	
	// 플랫폼별 입력항목 열기
	if (platform == '${PLATFORM_ANDROID}' || platform == '${PLATFORM_ANDROID_TBL}') {
		$("#tr_modi_cls").show();
		$("#tr_modi_androidPackage").show();
		activeTab();
	} else if (platform == '${PLATFORM_IOS}' || platform == '${PLATFORM_IOS_TBL}') {
		$("#tr_modi_cls").show();
		$("#tr_modi_bundleId").show();
		activeTab();
	} else if (platform == '${PLATFORM_WEB}') {
		$("#tr_modi_cls").hide();
		$("#tr_modi_appUrl").show();
		$("ul.tabs_appRole li").not("li.active").css({"text-decoration":"line-through","cursor":"default"});
		$("ul.tabs_appRole li").off();
	}
}

function onChange_modi_cls(modi_cls) {	
	// 등록 구분 입력항목 열기
	if (modi_cls == 'P') {	// 패키지/스킴 , 번들		
		// 현재 선택된 플랫폼 값
		var cur_platform = $("#modi_platformCd").val();	
		// 플랫폼별 입력항목 열기
		if (cur_platform == '${PLATFORM_ANDROID}' || cur_platform == '${PLATFORM_ANDROID_TBL}') {		
			$("#tr_modi_androidPackage").show();			
		} else if (cur_platform == '${PLATFORM_IOS}' || cur_platform == '${PLATFORM_IOS_TBL}') {
			$("#tr_modi_bundleId").show();
		}
		$("#tr_modi_appUrl").hide();		
		activeTab();
	} else if (modi_cls == 'W') {
		$("#tr_modi_androidPackage").hide();
		$("#tr_modi_bundleId").hide();
		$("#tr_modi_appUrl").show();					
		$("ul.tabs_appRole li").not("li.active").css({"text-decoration":"line-through","cursor":"default"});
		$("ul.tabs_appRole li").off();
	}	
}

function openAppModiDialog() {
	// 첫번째 탭 선택
	$("ul.tabs_appRole li:first").click();
	
	$("#appModiDialog").dialog( "open" );
	var height = $("#appModiDialog").outerHeight();
	$("#appModiDialog").dialog("option", "maxHeight", screen.height);
}

function goVerInsertShow() {
	var frm = $("#verDetailFrm");
	
	<%-- 버튼 처리 --%>
	//$("#verDetailDiv").show();
	//$("#verInsertSpan").show();
	//$("#verUpdateSpan").hide();
	$("#spanVerInsert").show();
	$("#spanVerUpdate").hide();
	<%-- $("#verDeleteSpan").hide(); --%>
	$("#verDetailFrm")[0].reset();	<%-- form 초기화 --%>
	frm.find("input:radio[name='deleteYn'][value='N']").prop("checked", "checked"); <%-- 사용중으로 디폴트값 지정 --%>
	<%-- $("input:radio[name='deleteYn']").attr("disabled",true);	등록 할 때는 변경 불가 --%>
	frm.find("input:radio[name='forceUpdateYn'][value='N']").prop("checked", "checked"); <%-- 강제 업데이트 사용안함으로 디폴트값 지정 --%>
	
	<%-- 파일 첨부 셋팅 --%>
	frm.find("#appFileImg").hide();
	frm.find("input[name='appFileNm']").hide();
	frm.find("#manifestFileImg").hide();	
	frm.find("input[name='manifestFileNm']").hide();
	
	<%-- 스크롤 아래로 이동 --%>
	//goToBottomPage("#app-version-detail", 800);
	openAppVersionRegDialog();
}

$("#appModiDialog").dialog({
	autoOpen: false,
    resizable: true,
    width: '75%',
    modal: true,
	// add a close listener to prevent adding multiple divs to the document
    close: function(event, ui) {
        // remove div with all data and events
        $(this).dialog( "close" );
    }
});
</script>