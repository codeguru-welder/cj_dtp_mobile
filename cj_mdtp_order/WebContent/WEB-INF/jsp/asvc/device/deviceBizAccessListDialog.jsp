<%-- 업무별 접속현황 상세화면 다이얼로그 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="false"%>
<div id="deviceBizAccessDialog" title="<mink:message code='mink.label.task_access_status'/>" class="dlgStyle">
	<!-- 상세화면 -->
	<div id="bizAccessDetailDiv">		
		<table id="logListTb" border="0" cellspacing="0" cellpadding="0" width="100%" class="read_listTb">
			<colgroup>
				<col width="16%" />
				<!-- <col width="20%" /> -->
				<col width="20%" />
				<col width="40%" />
				<col width="12%" />
				<col width="12%" />
			</colgroup>
			<thead>
				<tr>
					<td><mink:message code='mink.label.access_date'/></td>
					<!-- <td>접속자그룹</td> -->
					<td><mink:message code='mink.label.visit_name_id'/></td>
					<td><mink:message code='mink.label.device_id'/></td>
					<td><mink:message code='mink.label.platform'/></td>
					<td><mink:message code='mink.label.version_name'/></td>
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
// 접속현황 상세 목록 set
function fnSetDeviceAccessDetailList(data) {
	var resultList = data.deviceAccessDetailList;
	
	$("#logListTb > tbody > tr").remove();		// tbody 밑의 tr 삭제
	if( resultList.length > 0 ) {	// 결과 목록이 있을경우
		(nvl(data.search.urlNm) != "")? $("#targetUrl").html(data.search.urlNm) : $("#targetUrl").html(data.search.targetUrl);	// title의 업무명
		//$("#logPackageNm").html(resultList[0].packageNm);	// title의 앱 패키지명
		
		for(var i = 0; i < resultList.length; i++) {
			var newRow = $("#logListTb > thead > tr").clone(); // head row 복사
			newRow.children().html("");	// td 내용 초기화
			newRow.removeClass();
			/* newRow.find("td:eq(0)").html(parseInt(data.search.number) - i); */
			newRow.find("td:eq(0)").html(resultList[i].logTm); 
			//newRow.find("td:eq(1)").html(resultList[i].userGrpNm);
			
			//newRow.find("td:eq(1)").html(nvl(resultList[i].userNm)+setBracket(resultList[i].userId));
			var userInfoLink = "<a href=\"javascript: void(0);\" onclick=\"javascript:showSearchUserDetailDialog('" + resultList[i].userNo + "');\">" + resultList[i].userNm + setBracket(resultList[i].userId) + "</a>";
			newRow.find("td:eq(1)").html(userInfoLink);
			if(resultList[i].userId == null) {
				newRow.find("td:eq(1)").html("guest");
			}
			newRow.find("td:eq(1)").attr("align", "left");
			
			newRow.find("td:eq(2)").html(resultList[i].deviceId);
			newRow.find("td:eq(2)").attr("align", "left");
			
			newRow.find("td:eq(3)").html(getPlatformNm(resultList[i].platformCd));
			newRow.find("td:eq(4)").html(resultList[i].versionNm);
			$("#logListTb > tbody").append(newRow); 	// body 끝에 붙여넣기
		}
	} else {
		// 결과 목록이 없을 경우
		var emptyRow = "<tr><td colspan='5' align='center'><mink:message code='mink.web.text.noexist.result'/></td></tr>";
		$("#logListTb > tbody").append(emptyRow);
	}
	
	// 페이징 조건 재설정 후 페이징 html 생성
	$("#SearchFrm").find("input[name='targetUrl']").val(data.search.targetUrl); // (선택한)상세
	showPageHtml2(data, $("#paginateDiv2"), "goDeviceAccessList"); 
	$("#deviceBizAccessDialog").dialog( "open" );	
	//$("#detailDiv").show();
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

$("#deviceBizAccessDialog").dialog({
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