<%-- 장치 상세 및 수정 다이얼로그 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="false"%>
<!-- 사용자 상세정보 다이얼로그 -->
<%@ include file="/WEB-INF/jsp/include/searchUserDetailDialog.jsp" %>
<!-- 푸시세팅 리스트 등록 다이얼로그 -->
<%@ include file="/WEB-INF/jsp/asvc/device/pushSettingListRegDialog.jsp" %>

<div id="deviceDetailDialog" title="<mink:message code='mink.label.device_detail'/>" class="dlgStyle">
<div id="container_device_detail">
	<ul class="tabs_appRole">
		<li class="active" rel="dev_tab1"><mink:message code='mink.label.basic_info'/></li>
		<li rel="dev_tab2" onclick="goDeviceLogList('1')"><mink:message code='mink.label.usage_history'/></li>
		<li rel="dev_tab3"><mink:message code='mink.label.push_info'/></li>
	</ul>
	<div class="tab_container_appRole">
		<div id="dev_tab1" class="tab_content_appRole">
			<div class="miaps-popup-top-buttons-in-tap" style="border:0;">
				&nbsp;
				<span><button class='btn-dash' onclick="javascript:goUpdate();"><mink:message code="mink.web.text.save"/></button></span>
				<span><button class='btn-dash' onclick="javascript:$('#deviceDetailDialog').dialog('close');"><mink:message code="mink.web.text.cancel"/></button></span>
			</div>
			<form id="deviceDetailFrm" name="deviceDetailFrm" method="post" onSubmit="return false;">
				<table class="detailTb" border="0" cellspacing="0" cellpadding="0" width="100%">
					<colgroup>
						<col width="15%" />
						<col width="35%" />
						<col width="15%" />
						<col width="35%" />
					</colgroup>
					<tbody>
						<tr>
							<!-- <th>사용자그룹</th>
							<td><input class="inputHeight" type="text" name="userGrpNm" readonly="readonly"/></td> -->
							<th><mink:message code='mink.label.user_name'/><br/>(<mink:message code='mink.label.user_id'/>)</th>
							<td colspan="3" >
								<span id="userInfoSpan"></span>
							</td>
						</tr>
						<tr>
							<th><mink:message code='mink.label.device_id'/></th>
							<td><input type="text" name="deviceId" readonly="readonly"/></td>
							<th><mink:message code='mink.label.device_type'/></th>
							<td><input type="text" name="deviceTp" /></td>
						</tr>
						<tr>
							<th><mink:message code='mink.label.model_serial'/></th>
							<td><input type="text" name="modelNo" /></td>
							<th><mink:message code='mink.label.os_type'/></th>
							<td><input type="text" name="osTp" /></td>
						</tr>
						<tr>
							<th><mink:message code='mink.label.os_name'/></th>
							<td><input type="text" name="osNm" /></td>
							<th><mink:message code='mink.label.os_version'/></th>
							<td><input type="text" name="osVersion" /></td>
						</tr>
						<tr>
							<th><mink:message code='mink.label.wifi_address'/></th>
							<td><input type="text" name="wifiMacAddr" /></td>
							<th><mink:message code='mink.label.bluetooth_address'/></th>
							<td><input type="text" name="btMacAddr" /></td>
						</tr>
						<tr>
							<th><mink:message code='mink.label.phone_number'/></th>
							<td><input type="text" name="phoneNo" /></td>
							<th><mink:message code='mink.label.device_status'/></th>
							<td>
								<input type="radio" name="activeSt" value="${DEVICE_ST_ACTIVE}" id="activeSt_y" /><label for="activeSt_y" ><mink:message code="mink.web.text.using"/></label> 
								<input type="radio" name="activeSt" value="${DEVICE_ST_SUSPENDED}" id="activeSt_l" /><label for="activeSt_l" title="<mink:message code='mink.text.login.restrict'/>"><mink:message code="mink.web.text.stoped"/></label> 
								<input type="radio" name="activeSt" value="${DEVICE_ST_DISUSED}" id="activeSt_d" /><label for="activeSt_d" title="<mink:message code='mink.text.login.restrict.deletedata'/>"><mink:message code="mink.web.text.disposal"/></label> 
							</td>
						</tr>
						<tr>
							<th><mink:message code='mink.label.reg_date'/></th>
							<td><input type="text" name="regDt" readonly="readonly"/></td>
							<th><mink:message code='mink.label.modified_date'/></th>
							<td><input type="text" name="updDt" readonly="readonly"/></td>
						</tr>
					</tbody>
					<tfoot></tfoot>
				</table>
				<!-- <div class="detailBtnArea">
					<span id="ajaxUpdateSpan"><button class='btn-dash' onclick="javascript:goUpdate();">저장하기</button></span>
					<span id="showListSpan"><button class='btn-dash' onclick="javascript:hiddenInsertDetail();">닫기</button></span>
				</div> -->
			</form>
		</div>
		<div id="dev_tab2" class="tab_content_appRole">
			<div class="miaps-popup-top-buttons-in-tap" style="border:0;">
				&nbsp;
				<span><button class='btn-dash' onclick="javascript:$('#deviceDetailDialog').dialog('close');"><mink:message code="mink.web.text.close"/></button></span>
			</div>
				<table id="logListTb" border="0" cellspacing="0" cellpadding="0" width="100%" class="listTb">
					<colgroup>
						<col width="14%" />
						<col width="16%" />
						<col width="24%" />
						<col width="26%" />
						<col width="10%" />
						<col width="10%" />
					</colgroup>
					<thead>
						<tr>
							<td><mink:message code='mink.label.connect_time'/></td>
							<td><mink:message code='mink.label.user_name_id'/></td>
							<td><mink:message code='mink.label.app_nm_pkgnm'/></td>
							<td><mink:message code='mink.label.task'/></td>
							<td><mink:message code='mink.label.platform'/></td>
							<td><mink:message code='mink.label.version_name'/></td>
						</tr>
					</thead>
					<tbody>
					</tbody>
					<tfoot></tfoot>
				</table>
				<div id="paginateDiv2"></div>
				
				<!-- 하위 paging 검색 hidden -->
				<form id="searchFrm2" name="searchFrm2" method="post" >
					<input type="hidden" name="pageNum" value="" />
					<input type="hidden" name="searchPageSize" value="10"/> 
					<input type="hidden" name="deviceId" value="" />
					<input type="hidden" name="taskId" value="" />
					<input type="hidden" name="pushYn" value="" />
					<input type="hidden" name="updNo" value="${loginUser.userNo}"/>
				</form>
		</div>
		<div id="dev_tab3" class="tab_content_appRole">
			<div class="miaps-popup-top-buttons-in-tap" style="border:0;">
				&nbsp;
				<span><button class='btn-dash' onclick="javascript:openPushSettingListRegDialog();"><mink:message code='mink.web.text.regist'/></button></span>
				<span><button class='btn-dash' onclick="javascript:$('#deviceDetailDialog').dialog('close');"><mink:message code='mink.label.cancel'/></button></span>
			</div>
			<table id="pushListTb" border="0" cellspacing="0" cellpadding="0" width="100%" class="listTb">
				<colgroup>
					<!-- <col width="7%" /> -->
					<col width="15%" />
					<col width="15%" />
					<col width="10%" />
					<col width="30%" />
					<col width="10%" />
					<col width="10%" />
					<col width="10%" />
				</colgroup>
				<thead>
					<tr>
						<!-- <td>순번</td> -->
						<td><mink:message code='mink.label.push_task_name'/></td>
						<td><mink:message code='mink.label.app_bundle_id'/></td>
						<td><mink:message code='mink.label.check_push_yn'/></td>
						<td><mink:message code='mink.label.push_token'/></td>
						<td><mink:message code='mink.label.service_type'/></td>
						<td><mink:message code='mink.label.reg_date'/></td>
						<td><mink:message code='mink.label.modified_date'/></td>
					</tr>
				</thead>
				<tbody>
				</tbody>
				<tfoot></tfoot>
			</table>
			<div id="paginateDiv3"></div>
			
			<!-- 하위 paging 검색 hidden -->
			<form id="searchFrm3" name="searchFrm3" method="post" >
				<input type="hidden" name="pageNum" value="" />
				<input type="hidden" name="searchPageSize" value="7"/> 
				<input type="hidden" name="deviceId" value="" />
				<input type="hidden" name="taskId" value="" />
				<input type="hidden" name="pushYn" value="" />
				<input type="hidden" name="updNo" value="${loginUser.userNo}"/>
			</form>
		</div>
	</div>
</div>
</div>

<script type="text/javascript">
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

function callbackDeviceDetailDialog(data) {
	hideLoading();
	
	var result = data.device;
	
	// 상세화면 정보 출력
	$("input[name='deviceId']").val(result.deviceId);
	var userInfoLink = "<a href=\"javascript: void(0);\" onclick=\"javascript:showSearchUserDetailDialog('" + result.userNo + "');\">" + defenceXSS(result.userNm) + setBracket(defenceXSS(result.userId)) + "</a>";
	if (result.userNo == null || result.userNo == "") userInfoLink = "";
	$("#userInfoSpan").html(userInfoLink);
	$("input[name='deviceTp']").val(result.deviceTp);
	$("input[name='modelNo']").val(result.modelNo);
	$("input[name='osTp']").val(result.osTp);
	$("input[name='osNm']").val(result.osNm);
	$("input[name='osVersion']").val(result.osVersion);
	$("input[name='phoneNo']").val(defenceXSS(result.phoneNo));
	$("input[name='wifiMacAddr']").val(result.wifiMacAddr);
	$("input[name='btMacAddr']").val(result.btMacAddr);
	$("input[name='activeSt'][value=" + result.activeSt + "]").prop("checked", true);
	$("input[name='regNm']").val(result.regNm);
	$("input[name='regDt']").val(toDateFormatString(result.regDt));
	$("input[name='updDt']").val(toDateFormatString(result.updDt));

	// 하위목록 key setting
	//$("#searchFrm2").find("input[name='deviceId']").val(result.deviceId); 
	
	// 장치 사용 이력 목록 조회
	//goDeviceLogList("1");
	
	// 푸시셋팅 목록 조회
	goPushSettingList("1");

	$("#deviceDetailDialog").dialog( "open" );
	$("ul.tabs_appRole li").eq(0).click(); // 첫번째 탭(기본정보) 보이기
	
};

$("#deviceDetailDialog").dialog({
	autoOpen: false,
  resizable: true,
  width: '60%',
  modal: true,
	// add a close listener to prevent adding multiple divs to the document
  close: function(event, ui) {
      // remove div with all data and events
      $(this).dialog( "close" );
  }
  
});
</script>

<script type="text/javascript">
//장치 사용 이력 목록 조회
function goDeviceLogList(currPage) {
	$("#searchFrm2").find("input[name='pageNum']").val(currPage); 
	ajaxComm('deviceLogList.miaps', searchFrm2, function(data){
		fnSetDeviceLogList(data);
	});
}

// 장치 사용 이력 목록 조회 결과
function fnSetDeviceLogList(data) {
	var resultList = data.deviceLogList;
	var packageNmList = data.packageNmList;
	
	// 테이블 내용 삭제 후 head를 복사하여 값 셋팅하는 방식
	$("#logListTb > tbody > tr").remove();
	if( resultList.length > 0 ) {
		for(var i = 0; i < resultList.length; i++) {
			var newRow = $("#logListTb > thead > tr").clone();
			newRow.children().html("");
			newRow.removeClass();
			var userInfo = "<a href=\"javascript: void(0);\" onclick=\"javascript:showSearchUserDetailDialog("+resultList[i].userNo+")\">"+defenceXSS(resultList[i].userNm)+setBracket(defenceXSS(resultList[i].userId))+"</a>";
			
			var packageNm = resultList[i].packageNm;
			var appNm = packageNm;
			for (var j = 0; j < packageNmList.length; j++) {
				if (packageNm == packageNmList[j].packageNm) {
					appNm = packageNmList[j].appNm;
					break;
				}
			}
			
			newRow.find("td:eq(0)").html(resultList[i].logTm); 
			newRow.find("td:eq(1)").html(userInfo);
			newRow.find("td:eq(1)").attr("align", "left");
			newRow.find("td:eq(2)").html(defenceXSS(appNm));
			newRow.find("td:eq(2)").attr("align", "left");
			newRow.find("td:eq(3)").html(resultList[i].urlNm);
			newRow.find("td:eq(3)").attr("align", "left");
			newRow.find("td:eq(4)").html(getPlatformNm(resultList[i].platformCd));
			newRow.find("td:eq(5)").html(defenceXSS(resultList[i].versionNm));
			$("#logListTb > tbody").append(newRow); 	// body 끝에 붙여넣기
		}
	} else {	// 결과 목록이 없을 경우
		var emptyRow = "<tr><td colspan='6' align='center'><mink:message code='mink.web.text.noexist.inquiry'/></td></tr>";
		$("#logListTb > tbody").append(emptyRow);
	}

	// 페이징 조건 재설정 후 페이징 html 생성
	showPageHtml2(data, $("#paginateDiv2"), "goDeviceLogList");
}
</script>

<script type="text/javascript">
//장치별 푸시셋팅 목록 조회
function goPushSettingList(currPage) {
	$("#searchFrm3").find("input[name='pageNum']").val(currPage); 
	ajaxComm('devicePushSettingListView.miaps?', searchFrm3, function(data){
		fnSetPushSettingList(data);
	});
}

//장치별 푸시셋팅 목록 조회 결과
function fnSetPushSettingList(data) {
	var resultList = data.pushSettingList;
	
	// 테이블 내용 삭제 후 head를 복사하여 값 셋팅하는 방식
	$("#pushListTb > tbody > tr").remove();
	if( resultList.length > 0 ) {
		for(var i = 0; i < resultList.length; i++) {
			var newRow = $("#pushListTb > thead > tr").clone();
			newRow.children().html("");
			newRow.removeClass();
			var obj = resultList[i];
			/* newRow.find("td:eq(0)").html(parseInt(data.search.number) - i); */
			newRow.find("td:eq(0)").html(defenceXSS(obj.taskNm)); 
			newRow.find("td:eq(0)").attr("align", "left");			
			newRow.find("td:eq(1)").html(defenceXSS(obj.appBundleId)); 
			newRow.find("td:eq(1)").attr("align", "left");			
			var pushYn = "<input type=\'radio\' name=\"pushYn"+i+"\" value=\'Y\' style=\'width: 15px !important\' onclick=\"javascript:goPushUpdate('"+obj.deviceId+"', '"+obj.taskId+"', this.value, "+i+", '"+obj.pushYn+"');\"><mink:message code='mink.web.text.receive'/></button><br/>";
				pushYn += "<input type=\'radio\' name=\"pushYn"+i+"\" value=\'N\' style=\'width: 15px !important\' onclick=\"javascript:goPushUpdate('"+obj.deviceId+"', '"+obj.taskId+"', this.value, "+i+", '"+obj.pushYn+"');\"><mink:message code='mink.web.text.receiveno'/></button>";
			newRow.find("td:eq(2)").html(pushYn); 
			newRow.find("td:eq(2)").attr("align", "left");
			newRow.find("input[name='pushYn"+i+"'][value=" + obj.pushYn + "]").attr("checked", true);
			
			// 글자가 칸에서 넘칠 경우 ... 으로 숨김
			var pushToken = obj.pushToken;
			if(null != pushToken && '' != pushToken && 50 < pushToken.length) {
				pushToken = pushToken.substring(0, 50) + '...';
			}
			newRow.find("td:eq(3)").attr("align", "left").html(pushToken);
			newRow.find("td:eq(3)").attr("title", obj.pushToken);
			newRow.find("td:eq(4)").html(obj.serviceTp); 
			newRow.find("td:eq(5)").html(obj.regDt); 
			newRow.find("td:eq(6)").html(obj.updDt);
			//var updateObj = "<button class=\"btn-dash\" onclick=\"javascript:goPushUpdate('"+obj.deviceId+"', '"+obj.taskId+"', this.value);\">수정</button>";
			//newRow.find("td:eq(6)").html(updateObj);
			$("#pushListTb > tbody").append(newRow); 	// body 끝에 붙여넣기
			//$("#pushListTb > tbody > tr:eq("+i+")").on("click", function() {openPushSettingListForUpdate(obj)});
			$("#pushListTb > tbody > tr:eq("+i+")").click(obj,openPushSettingListDialog4Update);
			
		}
	} else {	// 결과 목록이 없을 경우
		var emptyRow = "<tr><td colspan='6' align='center'><mink:message code='mink.web.text.noexist.result'/></td></tr>";
		$("#pushListTb > tbody").append(emptyRow);
	}
	
	// 페이징 조건 재설정 후 페이징 html 생성
	showPageHtml2(data, $("#paginateDiv3"), "goPushSettingList"); 
}

//task 별 푸시수신여부 수정
function goPushUpdate(deviceId, taskId, pushYn, i, originPushYn) {
	// 수신여부 수정 취소 시 푸시수정여부 원래 값(originPushYn)으로 변경표시
	if( !confirm("<mink:message code='mink.message.would_you_modify_check_push_yn'/>") ) {
		$("#pushListTb").find("input[name='pushYn"+i+"'][value=" + originPushYn + "]").prop("checked", true);
		return;
	}

	$("#searchFrm3").find("input[name='deviceId']").val(deviceId); 
	$("#searchFrm3").find("input[name='taskId']").val(taskId); 
	$("#searchFrm3").find("input[name='pushYn']").val(pushYn); 
	ajaxComm('devicePushSettingUpdate.miaps?', searchFrm3, function(data){ });

}

function openPushSettingListDialog4Update(obj) {
	
	//tr에서 radio button 클릭 시 종료
	if(event.target.type =='radio') return;
	
	//업무명
	var pushNm = "<option value='"+ obj.data.taskId +"'>" + defenceXSS(obj.data.taskNm) + "</option>";
	$("#pushTaskList").html(pushNm);
	
	//푸시 수신여부
	if(obj.data.pushYn == "Y") {
		$("#pushRegTb").find("input[id='pushY']").prop("checked", true);
	}
	else if(obj.data.pushYn == "N") {
		$("#pushRegTb").find("input[id='pushN']").prop("checked", true);
	}
	
	//푸시토큰
	$("#pushRegTb").find("input[id='pushToken']").val(obj.data.pushToken);
	
	//서비스유형
	if(obj.data.serviceTp == "apns") {
		$("#pushService option:eq(0)").prop("selected", "selected");
	}
	else if(obj.data.serviceTp == "gcm") {
		$("#pushService option:eq(1)").prop("selected", "selected");
	}
	
	//function pushInfoUpdate()
	$('#btnPushSettingSave').hide();
	$('#btnPushSettingModi').show();

	checkedTrCheckbox($(event.target).parent("tr")); // 목록 tr 선택
}
</script>