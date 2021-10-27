<%-- 사용자 등록 다이얼로그 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="false"%>

<div id="settingCodeGroupRegDialog" title="<mink:message code='mink.web.text.regist.codegroup'/>" class="dlgStyle">
<div class="miaps-popup-top-buttons">
	&nbsp;
	<span><button class='btn-dash' onclick="javascript:goInsert();"><mink:message code="mink.web.text.save"/></button></span>
	<span><button class='btn-dash' onclick="javascript:$('#settingCodeGroupRegDialog').dialog('close');"><mink:message code="mink.web.text.cancel"/></button></span>
</div>	
	<form id="insertFrm" name="insertFrm" method="post" onSubmit="return false;">
		<input type="hidden" name="regNo" value="${loginUser.userNo}"/>	<%-- 로그인한 사용자 --%>
		<input type="hidden" name="searchKey" value=""/>	<%-- 검색조건 --%>
		<input type="hidden" name="searchValue" value=""/>	<%-- 검색조건 --%>
	
		<table class="insertTb" border="0" cellspacing="0" cellpadding="0" width="100%">
			<colgroup>
				<col width="20%"/>
				<col width="30%"/>
				<col width="20%"/>
				<col width="30%"/>
			</colgroup>
			<tbody>
				<tr>
					<th><span class="criticalItems"><mink:message code="mink.web.text.codegroupid"/></span></th>
					<td><input type="text" name="cdGrpId" maxlength="3" value="<mink:message code='mink.web.text.3numchar'/>" onfocus="javascript:onfocusCdGrpId(this)" onblur="javascript:onfocusoutCdGrpId(this)"/></td>
					<th><span class="criticalItems"><mink:message code="mink.web.text.codegroupname"/></span></th>
					<td><input type="text" name="cdGrpNm" maxlength="50"/></td>
				</tr>
				<tr>
					<th><span class="criticalItems"><mink:message code="mink.web.text.sequence"/></span></th>
					<td><input type="text" name="orderSeq" /></td>
					<th><span class="criticalItems"><mink:message code="mink.text.classification"/></span></th>
					<td>
						<input type="radio" name="systemYn" value="Y" id="systemYn_i_y" checked="checked" /><label for="systemYn_i_y" ><mink:message code="mink.web.text.forsystem"/>&nbsp;&nbsp;</label>
						<input type="radio" name="systemYn" value="N" id="systemYn_i_n" /><label for="systemYn_n" ><mink:message code="mink.web.text.public"/>&nbsp;&nbsp;</label>
					</td>							
				</tr>
				<tr>
					<th><mink:message code="mink.web.text.code.description"/></th>
					<td colspan="3">
						<textarea name="cdGrpDesc" style="width:100%;overflow:visible;" onmouseup="textareaResize(this)" onkeyup="textareaResize(this)"></textarea>
					</td>
				</tr>
			</tbody>
			<tfoot></tfoot>
		</table>				
		<!-- <div class="insertBtnArea">	
			<button class='btn-dash' onclick="javascript:goInsert();">저장</button>
		</div> -->
	</form>
</div>

<script type="text/javascript">
var insertFrm = document.insertFrm;

<%-- 입력 값 검증 --%>
function validation(frm) {
	var tmpCdGrpId = frm.find("input[name='cdGrpId']").val();
	if( tmpCdGrpId == "" || tmpCdGrpId == "<mink:message code='mink.web.text.3numchar'/>") {
		alert("<mink:message code='mink.web.alert.input.codegroupid'/>");
		frm.find("input[name='cdGrpId']").focus();
		return true;
	}
	if( frm.find("input[name='cdGrpNm']").val()=="" ) {
		alert("<mink:message code='mink.web.alert.input.codegroupname'/>");
		frm.find("input[name='cdGrpNm']").focus();
		return true;
	}
	var tmpOrderSEQ = frm.find("input[name='orderSeq']").val();
	if( tmpOrderSEQ =="" ) {
		alert("<mink:message code='mink.web.alert.input.order'/>");
		frm.find("input[name='orderSeq']").focus();
		return true;
	}
	if( tmpOrderSEQ !="" && !$.isNumeric(tmpOrderSEQ)) {
		alert("<mink:message code='mink.web.alert.input.number'/>");
		frm.find("input[name='orderSeq']").focus();
		return true;
	}
	
	return false;
}

//등록
function goInsert() {
	if(validation($("#insertFrm"))) return; <%-- 입력 값 검증 --%>

	if(!confirm("<mink:message code='mink.web.alert.is.regist'/>")) return;

    ajaxFileComm('settingCodeGroupInsert.miaps?', $("#insertFrm"), function(data){
    	resultMsg(data.msg);
    	if (data.codeGroup != undefined) {
	    	$("#SearchFrm").find("input[name='cdGrpId']").val(data.codeGroup.cdGrpId); <%-- (등록한)상세 --%>
    		goList('1');
    	}
		goList('1'); <%-- 목록/검색(1 페이지로 초기화) --%>
    });
}

function openSettingCodeGroupRegDialog() {
	$("#settingCodeGroupRegDialog").dialog( "open" );
}

$("#settingCodeGroupRegDialog").dialog({
	autoOpen: false,
    resizable: false,
    width: 'auto',
    modal: true,
	// add a close listener to prevent adding multiple divs to the document
    close: function(event, ui) {
        // remove div with all data and events
        $(this).dialog( "close" );
    }/*,
    buttons: {
		"저장": goInsert,
        "취소": function() {
        	$(this).dialog( "close" );
        }
	}*/
});
</script>