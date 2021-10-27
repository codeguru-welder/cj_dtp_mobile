<%-- 사용자 접속현황 상세화면 다이얼로그 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="false"%>
<div id="deviceUserAccessDialog" title="<mink:message code='mink.web.text.detailstatus.useraccess'/>" class="dlgStyle">
	<div id="userAccessDetailDiv">
		<table id="logListTb" border="0" cellspacing="0" cellpadding="0" width="100%" class="read_listTb">
			<colgroup>
				<col width="16%" />
				<col width="34%" />
				<col width="26%" />
				<col width="12%" />
				<col width="12%" />
			</colgroup>
			<thead>
				<tr>
					<td><mink:message code="mink.web.text.access.date"/></td>
					<td><mink:message code="mink.web.text.taskname"/></td>
					<td><mink:message code="mink.web.text.deviceid"/></td>
					<td><mink:message code="mink.web.text.platform"/></td>
					<td><mink:message code="mink.web.text.versionname"/></td>
				</tr>
			</thead>
			<tbody>
			</tbody>
			<tfoot>
			</tfoot>
		</table>
		<div id="paginateDiv2" class="paginateDiv"></div>
	</div>
</div>

<script type="text/javascript">
//접속현황 상세 목록 set
function fnSetDeviceAccessDetailList(data) {
	var resultList = data.deviceAccessDetailList;

	$("#logListTb > tbody > tr").remove();		// tbody 밑의 tr 삭제
	if( resultList.length > 0 ) {	// 결과 목록이 있을경우
		//$("#userNm").html(resultList[0].userNm);	// title의 사용자명
		$("#userNm").html("<a href=\"javascript: void(0);\" onclick=\"javascript:showSearchUserDetailDialog('" + resultList[0].userNo + "');\">" + resultList[0].userNm + setBracket(resultList[0].userId) + "</a>");
		for(var i = 0; i < resultList.length; i++) {
			var newRow = $("#logListTb > thead > tr").clone(); // head row 복사
			newRow.children().html("");	// td 내용 초기화
			newRow.removeClass();
			newRow.find("td:eq(0)").html(resultList[i].logTm); 
			var urlNmInfo = nvl(resultList[i].urlNm);
			if (urlNmInfo == '') {
				urlNmInfo = nvl(resultList[i].targetUrl);
			}
			newRow.find("td:eq(1)").html(urlNmInfo);
			newRow.find("td:eq(1)").attr("align", "left");
			newRow.find("td:eq(2)").html(resultList[i].deviceId);
			newRow.find("td:eq(2)").attr("align", "left");
			newRow.find("td:eq(3)").html(getPlatformNm(resultList[i].platformCd));
			newRow.find("td:eq(4)").html(resultList[i].versionNm);
			$("#logListTb > tbody").append(newRow); 	// body 끝에 붙여넣기
		}
		// 페이징 조건 재설정 후 페이징 html 생성
	} else {
		// 결과 목록이 없을 경우
		var emptyRow = "<tr><td colspan='5' align='center'>" + "<mink:message code='mink.web.text.noexist.inquiry'/>" + "</td></tr>";
		$("#logListTb > tbody").append(emptyRow);
	}
	
	// 페이징 조건 재설정 후 페이징 html 생성
	$("#SearchFrm").find("input[name='userNo']").val(data.search.userNo); // (선택한)상세
	showPageHtml2(data, $("#paginateDiv2"), "goDeviceAccessList");
	//$("#userAccessDetailDiv").show();
	//$("#SearchFrm").find("input[name='userNo']").val(data.search.userNo); // (선택한)상세
	//showPageHtml2(data, $("#paginateDiv2"), "goDeviceAccessList"); 
	$("#deviceUserAccessDialog").dialog( "open" );	
}

function getPlatformNm(platformCd) {
	if ("${PLATFORM_ANDROID}" == platformCd) {
		return "Android Phone";
	} else if ("${PLATFORM_ANDROID_TBL}" == platformCd) {
		return "Android Tablet";
	} else if ("${PLATFORM_IOS}" == platformCd) {
		return "iPhone";
	} else if ("${PLATFORM_IOS_TBL}" == platformCd) {
		return "iPad";
	} else {
		return "";
	}
}

$("#deviceUserAccessDialog").dialog({
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

function callbackUserAccessList(data) {
	fnSetDeviceAccessDetailList(data);
}
</script>