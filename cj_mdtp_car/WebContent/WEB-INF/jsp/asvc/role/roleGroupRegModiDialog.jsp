<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page session="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/jsp/include/wsACommonHeadScript.jsp" %>

<div id="roleGroupRegModiDialog" title="<mink:message code='mink.web.text.addmodify.group'/>" class="dlgStyle">
	<div id="saveRoleGroupDiv">
		<table class="subDetailTb" border="0" cellspacing="0" cellpadding="0" width="100%">
			<thead>
				<tr>
					<th id="saveRoleGroupDivTitleTh" colspan="2" class="subSearch"><mink:message code="mink.web.text.modify.permissiongrop"/></th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<th><mink:message code="mink.web.text.permission.groupname"/></th>
					<td>
						<input type="text" name="roleGrpNm" value="<c:out value='${roleGroup.roleGrpNm}'/>" />
					</td>
				</tr>
				<tr>
					<th><mink:message code="mink.web.text.permissiongroup.description"/></th>
					<td>
						<input type="text" name="roleGrpDesc" value="<c:out value='${roleGroup.roleGrpDesc}'/>" />
					</td>
				</tr>
		</table>
	</div>
</div>

<script type="text/javascript">
//권한 그룹 등록/수정
function saveRoleGroup() {
	var roleGrpId = $(":input[name='roleGrpId']", "#searchFrm").val();
	var upRoleGrpId = '${roleGroup.roleGrpId}';
	var roleGrpNm = $(":input[name='roleGrpNm']", "#saveRoleGroupDiv").val();
	var roleGrpDesc = $(":input[name='roleGrpDesc']", "#saveRoleGroupDiv").val();
	var grpLevel = parseInt("${roleGroup.grpLevel}") + 1;
	var regNo = $(":input[name='regNo']", "#searchFrm").val();
	var updNo = $(":input[name='updNo']", "#searchFrm").val();
	
	if('' == upRoleGrpId) {
		upRoleGrpId = '0';
		grpLevel = 1;
	}
	
	if(roleGrpNm == '') {
		alert('<mink:message code="mink.web.alert.input.permissiongroupname"/>');
		$(":input[name='roleGrpNm']", "#saveRoleGroupDiv").focus();
		return true;
	}
	
	//alert(roleGrpId);
	
	if('' == roleGrpId) {
		if(!confirm("<mink:message code='mink.web.alert.is.regist'/>")) return;
		$.post('roleGroupInsert.miaps?', {upRoleGrpId: upRoleGrpId, roleGrpNm: roleGrpNm, roleGrpDesc: roleGrpDesc, grpLevel: grpLevel, regNo: regNo}, function(data){
			resultMsg(data.msg);
			$(":input[name='roleGrpId']", "#searchFrm").val(upRoleGrpId);
			goList();
		}, 'json');
	}
	else {
		if(!confirm("<mink:message code='mink.web.alert.is.save'/>")) return;
		$.post('roleGroupUpdate.miaps?', {roleGrpId: roleGrpId, roleGrpNm: roleGrpNm, roleGrpDesc: roleGrpDesc, updNo: updNo}, function(data){
			resultMsg(data.msg);
			goList();
		}, 'json');
	}
}

//그룹 등록/수정 화면
 function openRoleGroupRegModiDialog(grpId) {
 	$("#roleGroupRegModiDialog").dialog("open");
 }



// 사용자 상세정보 다이얼로그 팝업
//open the dialog
$("#roleGroupRegModiDialog").dialog({
	autoOpen: false,
    resizable: false,
    width: 'auto',
    modal: true,
	// add a close listener to prevent adding multiple divs to the document
    close: function(event, ui) {
        // remove div with all data and events
        $(this).dialog( "close" );
    },
    buttons: {
    	"<mink:message code='mink.web.text.save'/>": saveRoleGroup,
        "<mink:message code='mink.web.text.cancel'/>": function() {
			$(this).dialog( "close" );
        }
	}
});
</script>