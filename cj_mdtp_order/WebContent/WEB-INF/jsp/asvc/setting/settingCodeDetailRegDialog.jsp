<%-- 사용자 등록 다이얼로그 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="false"%>

<div id="settingCodeDetailRegDialog" title="<mink:message code='mink.web.text.regist.code'/>" class="dlgStyle">
<div class="miaps-popup-top-buttons">
	&nbsp;
	<span><button class='btn-dash' onclick="javascript:goInsertR();"><mink:message code="mink.web.text.save"/></button></span>
	<span><button class='btn-dash' onclick="javascript:$('#settingCodeDetailRegDialog').dialog('close');"><mink:message code="mink.web.text.cancel"/></button></span>
</div>
	<form id="insertFrmR" name="insertFrmR" method="post" onSubmit="return false;">
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
					<th><span class="criticalItems"><mink:message code="mink.web.text.select.codegroup"/></span></th>
					<td>
						<select class="selectSpace" name="cdGrpId">
							<c:forEach var="cdGrpDto" items="${cdGrpSelBox}" varStatus="i">
								<option value="${cdGrpDto.cdGrpId}" ><c:out value='${cdGrpDto.cdGrpNm}'/>(${cdGrpDto.cdGrpId})</option>
							</c:forEach>
						</select>
					</td>
					<th><span class="criticalItems"><mink:message code="mink.web.text.codeid"/></span></th>
					<%-- <td><input type="text" name="cdDtlId" maxlength="50" value="${CODE_DETAIL_ID_TEXT}" onfocus="javascript:onfocusCdDtlId(this)" onblur="javascript:onfocusoutCdDtlId(this)"/></td> --%>
					<td><input type="text" name="cdDtlId" maxlength="50" value="<mink:message code='mink.web.text.under50numchar'/>" onfocus="javascript:onfocusCdDtlId(this)" onblur="javascript:onfocusoutCdDtlId(this)"/></td>
				</tr>
				<tr>
					<th><span class="criticalItems"><mink:message code="mink.web.text.codename"/></span></th>
					<td><input type="text" name="cdDtlNm" maxlength="50"/></td>
					<th><span class="criticalItems"><mink:message code="mink.web.text.sequence"/></span></th>
					<td><input type="text" name="orderSeq" /></td>
				</tr>
				<tr>
					<th><mink:message code="mink.web.text.code.description"/></th>
					<td colspan="3">
						<textarea name="cdDtlDesc" style="width:100%;overflow:visible;" onmouseup="textareaResize(this)" onkeyup="textareaResize(this)"></textarea>
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

function openSettingCodeDetailRegDialog() {
	var cdGrpId = $("#SearchFrm").find("input[name='cdGrpId']").val();
	$("#insertFrmR").find("select[name='cdGrpId'] option[value='"+ cdGrpId +"']").attr("selected", "selected");
	$("#settingCodeDetailRegDialog").dialog( "open" );
}

$("#settingCodeDetailRegDialog").dialog({
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