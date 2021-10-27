<%-- 코드 그룹 상세 및 수정 다이얼로그 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="false"%>

<div id="settingCodeGroupModiDialog" title="<mink:message code='mink.web.text.codegroup.detail'/>" class="dlgStyle">
<div class="miaps-popup-top-buttons">
	&nbsp;
	<span id="updateBtn_settingCodeGroupModiDialog"><button class='btn-dash' onclick="javascript:goUpdate();"><mink:message code="mink.web.text.save"/></button></span>
	<span><button class='btn-dash' onclick="javascript:$('#settingCodeGroupModiDialog').dialog('close');"><mink:message code="mink.web.text.cancel"/></button></span>
</div>
	<!-- 상세화면 -->
	<form id="detailFrm" name="detailFrm" method="POST" onsubmit="return false;">
		<input type="hidden" name="regNo" value="${loginUser.userNo}"/>	<%-- 로그인한 사용자 --%>
		<input type="hidden" name="searchKey" value=""/>	<%-- 검색조건 --%>
		<input type="hidden" name="searchValue" value=""/>	<%-- 검색조건 --%>
	
		<table class="detailTb" border="0" cellspacing="0" cellpadding="0" width="100%">
			<colgroup>
				<col width="20%"/>
				<col width="30%"/>
				<col width="20%"/>
				<col width="30%"/>
			</colgroup>
			<tbody>
				<tr>
					<th><span class="criticalItems"><mink:message code="mink.web.text.codegroupid"/></span></th>
					<td><input type="text" name="cdGrpId" /></td>
					<th><span class="criticalItems"><mink:message code="mink.web.text.codegroupname"/></span></th>
					<td><input type="text" name="cdGrpNm" /></td>						
				</tr>
				<tr>
					<th><span class="criticalItems"><mink:message code="mink.web.text.sequence"/></span></th>
					<td><input type="text" name="orderSeq" /></td>
					<th><span class="criticalItems"><mink:message code="mink.text.classification"/></span></th>
					<td>
						<input type="radio" name="systemYn" value="Y" id="systemYn_i_y" /><label for="systemYn_i_y" ><mink:message code="mink.web.text.forsystem"/>&nbsp;&nbsp;</label>
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
	</form>
</div>

<script type="text/javascript">
//	Dialog 버튼
$("#settingCodeGroupModiDialog").dialog({
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

function goUpdate() {
	if(validation($("#detailFrm"))) return; <%-- 입력 값 검증 --%>
	
	if(!confirm('<mink:message code="mink.web.alert.is.save"/>')) return;

	ajaxFileComm('settingCodeGroupUpdate.miaps?', $("#detailFrm"), function(data){
    	resultMsg(data.msg);
		$("#SearchFrm").find("input[name='cdGrpId']").val(data.codeGroup.cdGrpId);	<%-- 상세조회 key --%>
		goList($("#SearchFrm").find("input[name='pageNum']").val()); <%-- 목록/검색 --%>
    });
}

</script>