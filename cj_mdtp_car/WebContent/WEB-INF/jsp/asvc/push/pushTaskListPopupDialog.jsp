<%--관리자푸시 -> 리스트 클릭 -> 메세지상세 -> 업무선택 클릭  푸시 업무 관리 다이얼로그 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="false"%>
<div id="pushTaskListDetailDialog" title="<mink:message code='mink.web.text.push.taskmanage'/>" class="dlgStyle">
	<div class="miaps-popup-top-buttons">
		&nbsp;
		<span><button class='btn-dash' onclick="javascript:selectTesk();"><mink:message code="mink.web.text.select"/></button></span>
		<span><button class='btn-dash' onclick="javascript:selectCancel();"><mink:message code="mink.web.text.cancel"/></button></span>
	</div>
	
	<form id="dialogSearchFrm" name="dialogSearchFrm" method="post">
	<!-- 검색 hidden -->
	<input type="hidden" name="taskId" /><!-- 상세 -->
	<input type="hidden" name="pageNum" value="${search.currentPage}" /><!-- 현재 페이지 -->
	<input type="hidden" name="isPopup" value="Y" /><!-- 팝업화면으로 이동 -->
	<input type="hidden" name="searchPageSize" value="8"/>
	<!-- 검색 화면 -->
	<div>
		<table class="listTb" border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr> 	
				<td class="search">
					<select id="ptpdSearchKey" name="searchKey">
						<option value="" ${search.searchKey == '' ? 'selected' : ''}><mink:message code="mink.web.text.full.all"/></option>
						<option value="taskId" ${search.searchKey == 'taskId' ? 'selected' : ''}><mink:message code="mink.web.text.bizid"/></option>
						<option value="taskNm" ${search.searchKey == 'taskNm' ? 'selected' : ''}><mink:message code="mink.web.text.taskname"/></option>
						<option value="packageNm" ${search.searchKey == 'packageNm' ? 'selected' : ''}><mink:message code="mink.web.text.packagename"/></option>
					</select>
					<input type="text" id="ptpdSearchValue" name="searchValue" value="<c:out value='${search.searchValue}'/>"/>					
					<button type="button" class='btn-dash' onclick="javascript:goList2('1');"><mink:message code="mink.web.text.search"/></button>
				</td>
			</tr>
		</table>
	</div>
	
	<!-- 목록 화면 -->
	<div style="overflow: auto;">
		<table id="pushTaskListPopupTb" class="listTb" border="0" cellspacing="0" cellpadding="0" width="100%">
			<colgroup>
				<col width="6%" />
				<col width="10%" />
				<col width="34%" />
				<col width="30%" />
				<col width="20%" />
			</colgroup>
			<thead>
				<tr>
					<td><input type="checkbox" name="pushTaskCheckboxAll" /></td>
					<td><mink:message code="mink.web.text.bizid"/></td>
					<td><mink:message code="mink.web.text.taskname"/></td>
					<td><mink:message code="mink.web.text.apppackagename"/></td>
					<td><mink:message code="mink.web.text.regdate"/></td>
				</tr>
			</thead>
			<tbody id="pushTaskListPopupTbody">				
			</tbody>
			<tfoot id="pushTaskListPopupTfoot">
			</tfoot>
		</table>
	</div>
	<div id="paginateDiv2"></div>
	</form>
	
	<!-- 상세화면 -->
	<div id="pushTaskDetailDiv" style="display:none">
		<div>
			<h3><span><mink:message code="mink.web.text.info.pushtaskdetail"/></span></h3>
		</div>
		<table class="detailTb" border="0" cellspacing="0" cellpadding="0" width="100%">
			<colgroup>
				<col width="20%" />
				<col width="30%" />
				<col width="20%" />
				<col width="30%" />
			</colgroup>
			<tbody id="detailTBody">
				<tr>
					<th><mink:message code="mink.web.text.taskname"/></th>
					<td colspan="3"><input type="text" name="taskNm" size="20"/></td>
				</tr>
				<tr>
					<th><mink:message code="mink.web.text.apppackagename"/></th>
					<td><input type="text" name="packageNm" size="20"/></td>
					<th><mink:message code="mink.web.text.connectionurl"/></th>
					<td><input type="text" name="taskUrl" size="20"/></td>
				</tr>
				<tr>
					<th><mink:message code="mink.web.text.taskdescription"/></th>
					<td colspan="3"><input type="text" name="taskDesc" size="50" /></td>
				</tr>
				<tr>
					<th><mink:message code="mink.web.text.regdate"/></th>
					<td><input type="text" name="regDt" size="10"/></td>
					<th><mink:message code="mink.web.text.moddate"/></th>
					<td><input type="text" name="updDt" size="10"/></td>
				</tr>
			</tbody>
			<tfoot></tfoot>
		</table>
	</div>
</div>

<script type="text/javascript">
var taskFrm = "";

/* 팝업창에서 검색 후 목록*/
function goList2(pageNum) {
	<%-- XSS 방어 --%>
	var _searchVal = defenceXSS(document.dialogSearchFrm.searchValue.value); 
	document.dialogSearchFrm.searchValue.value = _searchVal;
	document.dialogSearchFrm.pageNum.value = pageNum; // 이동할 페이지
	
	ajaxComm('${contextURL}/asvc/push/pushTaskListView2.miaps?', $('#dialogSearchFrm'), function(data) {
		setTbodyList(data);
	})
}

/* 리스트 클릭 시 상세화면 호출*/
function goDetail2(taskId) {

	checkedTrCheckbox($("#listTrr"+taskId));	// 선택된 row 색깔변경
	$("#detailFrm").find("input[name='taskId']").val(taskId); // (선택한)상세
	
	
	var taskNm = $('#listTrr'+taskId).find("input[name='taskNm']").val();
	var packageNm = $('#listTrr'+taskId).find("input[name='packageNm']").val();
	var taskUrl = $('#listTrr'+taskId).find("input[name='taskUrl']").val();
	var taskDesc = $('#listTrr'+taskId).find("input[name='taskDesc']").val();
	var regDt = $('#listTrr'+taskId).find("input[name='regDt']").val();
	var updDt = $('#listTrr'+taskId).find("input[name='updDt']").val();
	
 	$('#detailTBody').find("input[name='taskNm']").val(taskNm);
	$('#detailTBody').find("input[name='packageNm']").val(packageNm);
	$('#detailTBody').find("input[name='taskUrl']").val(taskUrl);
	$('#detailTBody').find("input[name='taskDesc']").val(taskDesc);
	$('#detailTBody').find("input[name='regDt']").val(regDt);
	$('#detailTBody').find("input[name='updDt']").val(updDt);
	
	$('#pushTaskDetailDiv').show();
		
}

/* 팝업창 리스트 화면 그리기*/
function setTbodyList(data) {
	
	var _searchKey = data.search.searchKey;
	var _searchVal = data.search.searchValue;
	
	$("#ptpdSearchKey").val(_searchKey);
	$("#ptpdSearchValue").val(_searchVal);
	
	var pushTaskList = data.pushTaskList;

	$('#pushTaskListPopupTbody').empty();
	var tBody = "";
	if(pushTaskList != null) {
		for(var i = 0;i < Object.keys(pushTaskList).length; i++) {
			tBody += "<tr id='listTrr"+pushTaskList[i].taskId+ "' " + "onclick=\"javascript:goDetail2('"+nvl(pushTaskList[i].taskId)+"');\">";
			tBody += 	"<td>";
			tBody +=		"<input type='checkbox' name='taskIds' value='"+nvl(pushTaskList[i].taskId)+"' onclick='checkedCheckboxInTr(event)'/>";
			tBody +=		"<input type='hidden' name='taskNm' value='"+nvl(defenceXSS(pushTaskList[i].taskNm))+"' />";
			tBody +=		"<input type='hidden' name='packageNm' value='"+nvl(defenceXSS(pushTaskList[i].packageNm))+"' />";
			tBody +=		"<input type='hidden' name='taskUrl' value='"+nvl(defenceXSS(pushTaskList[i].taskUrl))+"' />"
			tBody +=		"<input type='hidden' name='taskDesc' value='"+nvl(defenceXSS(pushTaskList[i].taskDesc))+"' />"
			tBody +=		"<input type='hidden' name='regDt' value='"+nvl(pushTaskList[i].regDt)+"' />"
			tBody +=		"<input type='hidden' name='updDt' value='"+nvl(pushTaskList[i].updDt)+"' />"
			tBody +=	"</td>";
			tBody +=	"<td>"+nvl(pushTaskList[i].taskId)+"</td>";
			tBody +=	"<td align='left'>"+nvl(defenceXSS(pushTaskList[i].taskNm))+"</td>";
			tBody +=	"<td align='left'>"+nvl(defenceXSS(pushTaskList[i].packageNm))+"</td>";
			tBody +=	"<td>"+nvl(pushTaskList[i].regDt)+"</td>";
			tBody += "</tr>";	
		}
		
		$('#pushTaskListPopupTbody').append(tBody);		
	} else {
		tBody += "<tr>";
		tBody += 	"<td colspan='5'><mink:message code='mink.web.text.noexist.result'/></td>";
		tBody += "</tr>";
		
		$('#pushTaskListPopupTfoot').html(tBody);
	}
	
	// 페이징 조건 재설정 후 페이징 html 생성
	showPageHtml2(data, $("#paginateDiv2"), "goList2");
	
}


/* 업무 선택*/
function selectTesk() {
	// 검증
	if($("#pushTaskListPopupTbody").find(":checkbox:checked").length < 1) {
		alert("<mink:message code='mink.web.alert.select.taskregist'/>");
		return;
	}
	$('#taskIdPos').html("");
	$('#packageNm').html("");
	
	$("#pushTaskListPopupTbody input:checked").each(function(idx, row){
		
		var curr = $(row).parents("tr");
		var taskId = $(row).val();	
		var taskNm = defenceXSS($(curr).find("input[name='taskNm']").val());
		var packageNm = defenceXSS($(curr).find("input[name='packageNm']").val());
		
		var taskStr = "&nbsp;&nbsp;- "+ taskNm + "("+taskId+")"
					+ "<input type=\"hidden\" name=\"taskIds\" value=\""+taskId+"\" /><br/>";
		var packageStr = "&nbsp;&nbsp;- "+ packageNm + "&nbsp;("+taskNm+")<br/>";
		
		if(taskFrm == "detailFrm") {	//detailFrm 이면 관리자 푸시 -> 리스트 상세 -> 업무선택
			$('#detailFrm').find("span[id='taskIdPos']").append(taskStr);
			$('#detailFrm').find("input[id='taskIdSetYn']").val("Y");
		} else {						//insertFrm 이면 관리자 푸시 -> 푸시등록 -> 업무선택  또는 앱 관리 -> 앱 공지사항 -> 등록 -> 업무선택
			$('#insertFrm').find("span[id='taskIdPos']").append(taskStr);
			$('#insertFrm').find("input[id='taskIdSetYn']").val("Y");
		}
	});
	
	$("#pushTaskListDetailDialog").dialog("close");
	
	
}

function selectCancel() {
	$('#pushTaskDetailDiv').hide();
	$('#pushTaskListDetailDialog').dialog('close');
}

/* detilFrm : in pushListDetailDialog.jsp , insertFrm : in pushListInsertDialog.jsp */
function callbackTaskListPopup(data) {
	
	taskFrm = data.taskIdsLoc;
	$("#pushTaskListDetailDialog").dialog("open");
	setTbodyList(data);	// 팝업창 리스트 그리기
}

$("#pushTaskListDetailDialog").dialog({
	autoOpen: false,
	resizable: false,
	width: 'auto',
	modal: true,
	// add a close listener to prevent adding multiple divs to the document
	close: function(event, ui) {
	    // remove div with all data and events
		$('#pushTaskDetailDiv').hide();
	    $(this).dialog( "close" );
	}
});
</script>