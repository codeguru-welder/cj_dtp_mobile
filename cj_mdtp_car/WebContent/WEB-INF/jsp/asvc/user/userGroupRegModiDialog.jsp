<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page session="false"%>
<%-- @ include file="/WEB-INF/jsp/include/wsACommonHeadScript.jsp" --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div id="userGroupRegModiDialog" title="<mink:message code='mink.web.text.addmodify.group'/>" class="dlgStyle">
<div class="miaps-popup-top-buttons">
	&nbsp;
	<span><button class='btn-dash' onclick="javascript:saveUserGroup();"><mink:message code="mink.web.text.save"/></button></span>
	<span><button class='btn-dash' onclick="javascript:$('#userGroupRegModiDialog').dialog('close');"><mink:message code="mink.web.text.cancel"/></button></span>
</div>
<div id="saveUserGroupDiv">
	<table class="subDetailTb" border="0" cellspacing="0" cellpadding="0" width="100%">
		<thead>
			<tr>
				<th id="saveUserGroupDivTitleTh" colspan="2" class="subSearch"><mink:message code="mink.web.text.modify.group"/></th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<th><mink:message code="mink.web.text.groupname"/></th>
				<td>
					<input type="hidden" name="userGroup.grpId" value="${search.searchUserGroup.grpId}" />
					<input type="text" name="userGroup.grpNm" value="${search.searchUserGroup.grpNm}" />
				</td>
			</tr>
			<!-- 
			<tr>
				<th>그룹약어</th>
				<td>
					<input type="text" name="userGroup.upGrpCd" value="${search.searchUserGroup.upGrpCd}" />
					<input type="text" name="userGroup.grpCd" value="${search.searchUserGroup.grpCd}" />
				</td>
			</tr>
			 -->
	</table>
</div>
</div>

<script type="text/javascript">
// 그룹 등록/수정
function saveUserGroup() {
	var grpId = $(":input[name='userGroup.grpId']", "#saveUserGroupDiv").val();
	var upGrpId = $("#searchUserGroupId").val();
	var grpCd = $(":input[name='userGroup.grpCd']", "#saveUserGroupDiv").val();
	var grpNm = $(":input[name='userGroup.grpNm']", "#saveUserGroupDiv").val();
	var grpLevel = parseInt($("#grpLevel").val()) + 1;
	var regNo = '${loginUser.userNo}';
	var updNo = '${loginUser.userNo}';

	if('${corporation}' == upGrpId) {
		upGrpId = '0';
		grpLevel = 1;
	}
	
	if(grpNm == '') {
		alert('<mink:message code="mink.web.alert.input.groupname"/>');
		$(":input[name='userGroup.grpNm']", "#saveUserGroupDiv").focus();
		return;
	}
	
	if('' == grpId) {
		if(!confirm("<mink:message code='mink.web.alert.is.regist'/>")) {
			//alert("return");
			return;
		}
		
		$.post('userGroupInsert.miaps?', {upGrpId: upGrpId, grpCd: grpCd, grpNm: grpNm, grpLevel: grpLevel, regNo: regNo}, function(data){
			//alert("result!!");
			resultMsg(data.msg);
			
			$("#userGroupRegModiDialog").dialog( "close" );
			
			reloadTreeview(data.userGroup.grpId); // 트리 다시 불러오기
		}, 'json');
	}
	else {
		if(!confirm("<mink:message code='mink.web.alert.is.save'/>")) return;
		$.post('userGroupUpdate.miaps?', {grpId: grpId, grpCd: grpCd, grpNm: grpNm, updNo: updNo}, function(data){
			resultMsg(data.msg);
			
			$("#userGroupRegModiDialog").dialog( "close" );
			
			reloadTreeview(grpId); // 트리 다시 불러오기
		}, 'json');
	}
}

//그룹 등록/수정 화면
 function openGroupRegModiDialog(grpId) {
 	if('' == grpId) {
 		/*
 		if('5' == "${search.searchUserGroup.grpLevel}") {
 			alert('더 이상 등록할 수 없습니다.');
 			$("#saveUserGroupDiv").hide();
 			return;
 		}
 		*/
 		$("#userGroupRegModiDialog").attr('title', '<mink:message code="mink.web.text.move.group"/>');
 		$("#saveUserGroupDivTitleTh").text($("#searchUserGroup_grpNm").val() + " <mink:message code='mink.web.text.regist.undergroup'/>");
 		$(":input[name='userGroup.grpId']", "#saveUserGroupDiv").val("");
 		$(":input[name='userGroup.grpCd']", "#saveUserGroupDiv").val("");
 		$(":input[name='userGroup.grpNm']", "#saveUserGroupDiv").val("");
 	}
 	else {
 		$("#userGroupRegModiDialog").attr('title', '<mink:message code="mink.web.text.modify.group"/>');
 		$("#saveUserGroupDivTitleTh").text($("#searchUserGroup_grpNm").val() + " <mink:message code='mink.web.text.modify.group'/>");
 		$(":input[name='userGroup.grpId']", "#saveUserGroupDiv").val($("#searchUserGroup_grpId").val());
 		$(":input[name='userGroup.grpCd']", "#saveUserGroupDiv").val($("#searchUserGroup_grpCd").val());
 		$(":input[name='userGroup.grpNm']", "#saveUserGroupDiv").val($("#searchUserGroup_grpNm").val());
 	}
 	/*
 	if($("#saveUserGroupDiv").is(":hidden")) {
 		callResize2("#saveUserGroupDiv"); // 부모창 스크롤 늘림
 	}
 	else {
 		callResize3("#saveUserGroupDiv"); // 부모창 스크롤 줄임
 	}
 	$("#saveUserGroupDiv").toggle();
 	*/
 	$(":input[name='userGroup.grpNm']", "#saveUserGroupDiv").focus();
 	
 	$("#userGroupRegModiDialog").dialog("open");
 }



// 사용자 상세정보 다이얼로그 팝업
//open the dialog
$("#userGroupRegModiDialog").dialog({
	autoOpen: false,
    resizable: false,
    width: '350px',
    modal: true,
	// add a close listener to prevent adding multiple divs to the document
    close: function(event, ui) {
        // remove div with all data and events
        $(this).dialog( "close" );
    },/*
    buttons: {
    	"저장": saveUserGroup,
        "취소": function() {
			$(this).dialog( "close" );
        }
	}*/
});
</script>