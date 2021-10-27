<%-- 코드 그룹 상세 및 수정 다이얼로그 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="false"%>

<div id="settingCodeDetailModiDialog" title="<mink:message code='mink.web.text.code.detail'/>" class="dlgStyle">
<div class="miaps-popup-top-buttons">
	&nbsp;
	<span id="updateBtn_settingCodeDetailModiDialog"><button class='btn-dash' onclick="javascript:goUpdateR();"><mink:message code="mink.web.text.save"/></button></span>
	<span><button class='btn-dash' onclick="javascript:$('#settingCodeDetailModiDialog').dialog('close');"><mink:message code="mink.web.text.cancel"/></button></span>
</div>
	<form id="detailFrmR" name="detailFrmR" method="POST" onsubmit="return false;">
		<input type="hidden" name="updNo" value="${loginUser.userNo}"/>	<!-- 로그인한 사용자 -->
		<input type="hidden" name="searchKey" value=""/>	<!-- 검색조건 -->
		<input type="hidden" name="searchValue" value=""/>	<!-- 검색조건 -->
	
		<table class="detailTb" border="0" cellspacing="0" cellpadding="0" width="100%">
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
						<select class="selectSpace" id="cdGrpId" name="cdGrpId">
							<c:forEach var="cdGrpDto" items="${result.cdGrpSelBox}" varStatus="i">
								<option value="${cdGrpDto.cdGrpId}"><c:out value='${cdGrpDto.cdGrpNm}'/>(${cdGrpDto.cdGrpId})</option>
							</c:forEach>
						</select>
					</td>
					<th><span class="criticalItems"><mink:message code="mink.web.text.codeid"/></span></th>
					<td><input type="text" name="cdDtlId" /></td>
				</tr>
				<tr>
					<th><span class="criticalItems"><mink:message code="mink.web.text.codename"/></span></th>
					<td><input type="text" name="cdDtlNm" /></td>
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
	</form>
</div>

<script type="text/javascript">
//	Dialog 버튼
$("#settingCodeDetailModiDialog").dialog({
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
		"수정": goUpdate,
        "취소": function() {
        	$(this).dialog( "close" );
        }
	}*/
});

function goUpdateR() {
	if(validation($("#detailFrmR"))) return; <%-- 입력 값 검증 --%>
	
	if(!confirm('<mink:message code="mink.web.alert.is.save"/>')) return;

	ajaxFileComm('settingCodeDetailUpdate.miaps?', $("#detailFrmR"), function(data){
    	resultMsg(data.msg);
		$("#SearchFrmR").find("input[name='cdDtlId']").val(data.codeDetail.cdDtlId);	<%-- 상세조회 key --%>
		goList($("#SearchFrmR").find("input[name='pageNum']").val()); <%-- 목록/검색 --%>
    });
}

</script>