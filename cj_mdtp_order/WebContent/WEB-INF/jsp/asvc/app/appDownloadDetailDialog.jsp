<%-- 앱 등록 다이얼로그 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div id="appDownloadDetailDialog" title="<mink:message code='mink.web.text.appdownloaddetail'/>" class="dlgStyle">
<div class="miaps-popup-top-buttons">
	&nbsp;
	<span><button class='btn-dash' onclick="javascript:goDownloadAppDownDetail('1');"><mink:message code="mink.web.text.downloadsearchresult"/></button></span>
	<span><button class='btn-dash' onclick="javascript:$('#appDownloadDetailDialog').dialog('close');"><mink:message code="mink.web.text.close"/></button></span>
</div>
<form id="searchFrm2" name="searchFrm2" method="POST" onsubmit="return false;">
	<input type="hidden" name="pageNum" value="" />
	<input type="hidden" name="appId" value=""/>
	<input type="hidden" name="verNo" value=""/>
	<input type="hidden" name="searchVerKey" value=""/>
	<input type="hidden" name="searchVerValue" value=""/>
	<input type="hidden" name="searchUserKey" value=""/>
	<input type="hidden" name="searchUserValue" value=""/>
	<input type="hidden" name="startDt" value=""/>
	<input type="hidden" name="startHh" value="00" />
	<input type="hidden" name="startMm" value="00" />
	<input type="hidden" name="endDt" value=""/>
	<input type="hidden" name="endHh" value="23" />
	<input type="hidden" name="endMm" value="59" />
	<input type="hidden" name="packageNm" value=""/>
	<input type="hidden" name="platformCd" value=""/>
	<input type="hidden" name="searchUserGroupId" />
	<input type="hidden" name="searchUserGroupSubAllYn" />
		
	<table id="appDownDetailListTb" class="read_listTb" border="0" cellspacing="0" cellpadding="0" width="100%">
		<colgroup>
			<col width="12%" />
			<col width="12%" />
			<col width="16%" />
			<col width="10%" />
			<col width="10%" />
			<col width="30%" />
		</colgroup>
		<thead>
			<tr>
				<td><mink:message code="mink.web.text.date"/></td>
				<td><mink:message code="mink.web.text.username.id"/></td>
				<td><mink:message code="mink.web.text.groupname"/></td>
				<td><mink:message code="mink.web.text.versionname"/></td>
				<td><mink:message code="mink.web.text.platform"/></td>
				<td><mink:message code="mink.web.text.deviceid"/></td>
			</tr>
		</thead>
		<tbody></tbody>
		<tfoot></tfoot>
	</table>
	<div id="paginateDiv2" class="paginateDiv"></div>
</form>
</div>

<script type="text/javascript">
<%-- 상세 목록 조회 --%>
function openAppDnDetailDialog(packageNm, platformCd, trId, currPage) {
	checkedTrCheckbox($("#listTr"+trId));	<%-- 선택된 row 색깔변경 --%>
	
	<%-- 다운로드 목록 상세용 검색 설정을 미리 세팅  --%>
	var frm = $("#searchFrm");
	var searchFrm2 = $("#searchFrm2");
	searchFrm2.find("input[name='searchVerKey']").val(frm.find("select[name='searchVerKey']").val());
	searchFrm2.find("input[name='searchVerValue']").val(frm.find("input[name='searchVerValue']").val());
	searchFrm2.find("input[name='searchUserKey']").val(frm.find("select[name='searchUserKey']").val());
	searchFrm2.find("input[name='searchUserValue']").val(frm.find("input[name='searchUserValue']").val());
	searchFrm2.find("input[name='startDt']").val(frm.find("input[name='startDt']").val());
	searchFrm2.find("input[name='endDt']").val(frm.find("input[name='endDt']").val());
	searchFrm2.find("input[name='pageNum']").val(currPage);
	searchFrm2.find("input[name='packageNm']").val(packageNm);
	searchFrm2.find("input[name='platformCd']").val(platformCd);
	searchFrm2.find("input[name='searchUserGroupId']").val($("#searchUserGroupId").val());
	var grpSubAllYn = "";
	if ($("#searchUserGroupSubAllChekbox").get(0).checked) grpSubAllYn = $("#searchUserGroupSubAllChekbox").val();
	searchFrm2.find("input[name='searchUserGroupSubAllYn']").val(grpSubAllYn);
	
	goDetailPaging(currPage);
}

function goDetailPaging(page) {
	var searchFrm2 = $("#searchFrm2");
	searchFrm2.find("input[name='pageNum']").val(page);
	ajaxComm('appDownloadDetailListView.miaps', searchFrm2, function(data){
		fnSetVersionList(data);
	});
	
	/*goToBottomPage("#app-down-detail", 800);*/
}

<%-- 버전 목록 조회 결과 --%>
function fnSetVersionList(data) {
	/*$("#appDownDetailDiv").show();*/
	var resultList = data.appDownDetailList;
	
	<%-- 테이블 내용 삭제 후 head를 복사하여 값 셋팅하는 방식 --%>
	$("#appDownDetailListTb > tbody > tr").remove();	<%-- 테이블내용 삭제 (tbody 밑의 tr 삭제) --%>
	if( resultList.length > 0 ) {	<%-- 결과 목록이 있을 경우 --%>
		for(var i = 0; i < resultList.length; i++) {
			var downDt = nvl(resultList[i].down_dt);
			var userNo = nvl(resultList[i].user_no);
			var userNm = nvl(resultList[i].user_nm);
			var userId = nvl(resultList[i].user_id);
			var grpId = nvl(resultList[i].grp_id);
			var grpNm = nvl(resultList[i].grp_nm);
			var versionNm = nvl(resultList[i].version_nm);
			var versionNo = nvl(resultList[i].version_no);
			var platformCd = nvl(resultList[i].platform_cd);
			var deviceId = nvl(resultList[i].device_id);

			var newRow = $("#appDownDetailListTb > thead > tr").clone(); <%-- head row 복사 --%>
			newRow.children().html("");	<%-- td 내용 초기화 --%>
			newRow.removeClass();
			newRow.find("td:eq(0)").html(downDt); 
			newRow.find("td:eq(0)").attr("align", "center");
			newRow.find("td:eq(1)").html("<a href=\"javascript: void(0);\" onclick=\"javascript:showSearchUserDetailDialog('" + userNo + "');\">" + userNm + setBracket(userId) + "</a>");
			newRow.find("td:eq(1)").attr("align", "left");
			if (grpNm != "") {
				grpNm = "<a href=\"javascript: void(0);\" onclick=\"javascript:showSearchUserGroupNaviDialog('" + grpId + "');\">" + grpNm + "</a>";
			}
			newRow.find("td:eq(2)").html(grpNm); 
			newRow.find("td:eq(2)").attr("align", "left");
			newRow.find("td:eq(3)").html(versionNm + ' (' + versionNo + ')'); 
			newRow.find("td:eq(3)").attr("align", "left");
			newRow.find("td:eq(4)").html(getPlatformNm(platformCd)); 
			newRow.find("td:eq(4)").attr("align", "left");
			newRow.find("td:eq(5)").html(deviceId);
			newRow.find("td:eq(5)").attr("align", "left");
			$("#appDownDetailListTb > tbody").append(newRow); 	<%-- body 끝에 붙여넣기 --%>
		}
		var appNm = nvl(resultList[0].app_nm);
		var packageNm = nvl(resultList[0].package_nm);
		$("#idSelectedAppInfo").html('* ' + appNm + ' (' + packageNm + ')' + "<mink:message code='mink.web.text.downloaddetail'/>");
	} else {	<%-- 결과 목록이 없을 경우 --%>
		var emptyRow = "<mink:message code='mink.web.text.noexist.inquiry'/>";
		$("#appDownDetailListTb > tbody").append(emptyRow);
	}

	<%-- 페이징 조건 재설정 후 페이징 html 생성 --%>
	$("#searchFrm2").find("input[name='pageNum']").val(data.search.currentPage);	<%-- 상세조회 key --%>
	showPageHtml2(data, $("#paginateDiv2"), "goDetailPaging");
	
	$("#appDownloadDetailDialog").dialog( "open" );
}

<%--  '다운로드 상세내역' 검색 결과 다운로드 --%>
function goDownloadAppDownDetail(pageNum) {
	document.searchFrm2.pageNum.value = defenceXSS(pageNum); // 이동할 페이지
	document.searchFrm2.action = 'appDownloadDetailListViewDownload.miaps?';
	document.searchFrm2.submit();
}


$("#appDownloadDetailDialog").dialog({
	autoOpen: false,
    resizable: false,
    width: '65%',
    modal: true,
	// add a close listener to prevent adding multiple divs to the document
    close: function(event, ui) {
        // remove div with all data and events
        $(this).dialog( "close" );
    }
});
</script>