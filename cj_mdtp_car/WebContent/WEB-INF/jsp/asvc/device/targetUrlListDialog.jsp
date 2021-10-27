<%-- 업무구분 상세정보 다이얼로그 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="false"%>


<div id="targetUrlListDialog" title="<mink:message code='mink.web.text.info.taskclassificationdetail'/>" class="dlgStyle">
	<div class="miaps-popup-top-buttons">
		&nbsp;
		<span><button class='btn-dash' onclick="javascript:goUpdate();"><mink:message code="mink.web.text.save"/></button></span>
		<span><button class='btn-dash' onclick="javascript:$('#targetUrlListDialog').dialog('close');"><mink:message code="mink.web.text.cancel"/></button></span>
	</div>
	<form id="targetUrlListFrm" name="targetUrlListFrm" method="post" onSubmit="return false;">
			
		<table class="detailTb" border="0" cellspacing="0" cellpadding="0" width="100%">
			<colgroup>
				<col width="20%" />
				<col width="80%" />
			</colgroup>
			<tbody>
				<tr>
					<th><span class="criticalItems"><mink:message code="mink.web.text.classification.task"/></span></th>
					<td><input type="text" name="targetUrl" readonly="readonly"/></td>
				</tr>
				<tr>
					<th><span class="criticalItems"><mink:message code="mink.web.text.classification.taskname"/></span></th>
					<td><input type="text" name="urlNm" /></td>		
				</tr>
			</tbody>
			<tfoot></tfoot>
		</table>
<!-- 		<div class="detailBtnArea">
			<span><button class='btn-dash' onclick="javascript:goUpdate()">저장하기</button></span>
			<span><button class='btn-dash' onclick="javascript:hiddenInsertDetail();">닫기</button></span>
		</div> -->
	</form>	
</div>

<div id="insertTargetUrlListDialog" title="<mink:message code='mink.web.text.regist.taskclassification'/>" class="dlgStyle">
	<div class="miaps-popup-top-buttons">
		&nbsp;
		<span><button class='btn-dash' onclick="javascript:goInsert();"><mink:message code="mink.web.text.save"/></button></span>
		<span><button class='btn-dash' onclick="javascript:$('#insertTargetUrlListDialog').dialog('close');"><mink:message code="mink.web.text.close"/></button></span>
	</div>
	<form id="insertFrm" name="insertFrm" method="post" onSubmit="return false;">
		<table class="insertTb" border="0" cellspacing="0" cellpadding="0" width="100%">
			<colgroup>
				<col width="20%" />
				<col width="80%" />
			</colgroup>
			<tbody>
				<tr>
					<th><span class="criticalItems"><mink:message code="mink.web.text.classification.task"/></span></th>
					<td><input type="text" name="targetUrl" /></td>
				</tr>
				<tr>
					<th><span class="criticalItems"><mink:message code="mink.web.text.classification.taskname"/></span></th>
					<td><input type="text" name="urlNm" /></td>		
				</tr>
			</tbody>
			<tfoot></tfoot>
		</table>
	</form>	
</div>
<script type="text/javascript">

function callInsertFrm() {
	$("#insertTargetUrlListDialog").dialog( "open" );
}


function callbackTargetUrlListDialog(data) {
	
	var result = data.targetUrl;
	// 상세화면 정보 출력
	var frm = $("#targetUrlListFrm");
	frm.find("input[name='targetUrl']").val(result.targetUrl);
	frm.find("input[name='urlNm']").val(result.urlNm);
	$("#targetUrlListDialog").dialog( "open" );
}

$("#targetUrlListDialog").dialog({
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

$("#insertTargetUrlListDialog").dialog({
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

//등록(ajax) 후 목록 호출
function goInsert() {
	if(validation($("#insertFrm"))) return; // 입력 값 검증
	if( !goCheckUrl($('#insertFrm').find("input[name='targetUrl']").val()) ) {
		return;
	} 
	if(!confirm("<mink:message code='mink.web.alert.is.regist'/>")) return;
	ajaxComm('deviceTargetUrlInsert.miaps?', $('#insertFrm'), function(data){
		$("#SearchFrm").find("input[name='targetUrl']").val(data.targetUrl.targetUrl); // (등록한)상세
		goList('1'); // 목록/검색(1 페이지로 초기화)
	});
}

//수정(ajax) 후 목록 호출
function goUpdate() {
	if(validation($("#targetUrlListFrm"))) return; // 입력 값 검증
	if(!confirm("<mink:message code='mink.web.alert.is.save'/>")) return;
	
	ajaxComm('deviceTargetUrlUpdate.miaps?', targetUrlListFrm, function(data){
		resultMsg(data.msg);
		$("#targetUrlListFrm").find("input[name='targetUrl']").val(data.targetUrl.targetUrl);	// 상세조회 key
		goList($("#SearchFrm").find("input[name='pageNum']").val()); // 목록/검색
	});
}

//목록검색
function goList(pageNum) {
	<%-- XSS 방어 --%>
	var _searchVal = defenceXSS(document.SearchFrm.searchValue.value); 
	document.SearchFrm.searchValue.value = _searchVal;
	
	document.SearchFrm.pageNum.value = pageNum; // 이동할 페이지
	document.SearchFrm.action = 'deviceTargetUrlListView.miaps?';
	document.SearchFrm.submit();
}

//입력 값 검증
function validation(frm) {
	var result = false;
	
	if( frm.find("input[name='targetUrl']").val()=="" ) {
		alert("<mink:message code='mink.web.alert.input.taskclassification'/>");
		frm.find("input[name='targetUrl']").focus();
		return true;
	}
	if( frm.find("input[name='urlNm']").val()=="" ) {
		alert("<mink:message code='mink.web.alert.input.taskclassificationname'/>");
		frm.find("input[name='urlNm']").focus();
		return true;
	}

	
	return result;
}
</script>