<%-- TopMenu [푸시 등록] 클릭 다이얼로그 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="false"%>
<%@ page import="com.thinkm.mink.commons.MinkTotalConstants"%>
<%@ page import="com.thinkm.mink.commons.util.MinkContextParam"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div id="pushListInsertDialog" title="<mink:message code='mink.web.text.regist.push'/>" class="dlgStyle">
	<div class="miaps-popup-top-buttons">
		&nbsp;
		<span><button class='btn-dash' onclick="javascript:goInsert('');"><mink:message code="mink.web.text.save"/></button></span>
		<span><button class='btn-dash' onclick="javascript:$('#pushListInsertDialog').dialog('close');"><mink:message code="mink.web.text.cancel"/></button></span>
	</div>
	<form id="insertFrm" name="insertFrm" method="post" onSubmit="return false;" enctype="multipart/form-data" >
		<input type="hidden" name="regNo" value="${loginUser.userNo}" />	<!-- 로그인한 사용자 -->

		<table class="insertTb" border="0" cellspacing="0" cellpadding="0" width="100%">
			<colgroup>
				<col width="20%" />
				<col width="80%" />
			</colgroup>
			<tbody>
				<tr>
					<th><span class="criticalItems"><mink:message code="mink.web.text.taskname.id"/></span></th>
					<td>
						&nbsp;<button type="button" class='btn-dash' onclick="javascript:selectTask('insertFrm')"><mink:message code="mink.web.text.select.task"/></button><br />
						<span id="taskIdPos"></span>
						<input type='hidden' id='taskIdSetYn' value='N' />
						<input type='hidden' name = "taskIdsLoc" value="insertFrm"/>
						<input type='hidden' name = "isPopup" value="Y"/>
						<input type="hidden" name="searchPageSize" value="8"/>
					</td>
				</tr>
				<tr>
					<th><span class="criticalItems"><mink:message code="mink.web.text.push.message.under600char"/></span></th>
					<td>
						<!-- input type="text" name="pushMsg" maxlength="85"/ -->
						<textarea name="pushMsg" style="width:100%;overflow:visible;" onmouseup="textareaResize(this)" onkeyup="textareaResize(this)"></textarea>
					</td>
				</tr>
			<c:if test='${pushType eq "PREMIUM"}'>
				<tr>
					<th><span><mink:message code="mink.web.text.push.messagetype"/></span></th>
					<td>
					<select name="msgTp">
						<option value="Text"><mink:message code="mink.web.text.string.normal"/></option>
						<option value="BText"><mink:message code="mink.web.text.string.big"/></option>
						<option value="Inbox"><mink:message code="mink.web.text.listtype"/></option>
					</select>
					</td>
				</tr>
				<tr>
					<th><span><mink:message code="mink.web.text.push.imageurl2"/></span></th>
					<td>
					<input type="text" name="imgUrl"/>
					<input type="file" name="imgFile"/>
					<span>
						<input id="insImgUrlYn" type="checkbox" name="imgUrlYn" value="N" class="checkbox_with_label" style="width: 13px; height: 13px;" /><!-- style=.insertTb tbody tr td input{width: 100%} -->
						<label for="insImgUrlYn" title="<mink:message code='mink.web.text.push.imageurl3'/>" class="label_with_checkbox"><mink:message code="mink.web.text.notimage"/></label>
					</span>
					</td>
				</tr>
			</c:if>
				<tr>
					<th><mink:message code="mink.web.text.push.reserved.senddate"/></th>
					<td class="pushDate_1">
						<input type="text" name="reservedDd" size="10" class="datepicker"/>
						<select name="reservedHh">
							<c:forEach var="i" begin="0" end="24" varStatus="status">
								<fmt:formatNumber value="${i}" pattern="00" var="hh" />
								<option value="${hh}" >${hh}</option>
							</c:forEach>
						</select>
						<select name="reservedMm">
							<c:forEach var="i" begin="0" end="59" varStatus="status">
								<fmt:formatNumber value="${i}" pattern="00" var="mm" />
								<option value="${mm}" >${mm}</option>
							</c:forEach>
						</select>
						<input type="hidden" name="reservedDt" />
					</td>
				</tr>
				<tr>					
					<th><span>Badge Count</span></th>
					<td class="pushDate_1">
						<input type="text" name="badgeCnt" maxlength="3" value="0" onKeyup="this.value=this.value.replace(/[^0-9]/g, '');"/>&nbsp;
						0 초기화, &gt;0 카운트 변경, &lt;0 변경없음
					</td>
				</tr>
				<c:if test='${pushType eq "PREMIUM"}'>
				<tr>
					<th><span><mink:message code="mink.web.text.userdata"/></span></th>
					<td><!-- 커스텀 데이터 입력하기 - 2018/09/12 -->
						<table id="tblIns_UserData" class="listTb" border="0" cellspacing="0" cellpadding="0" width="100%">
						<colgroup>
							<col width="35%" />
							<col width="65%" />
						</colgroup>
						<tbody>
						<c:forEach var="userData" items="${addedDetailData}" varStatus="i">
						<tr>
							<th>${userData.desc}(${userData.key})</th>
							<td><input type="text" name="insUserData_${userData.key}"/></td>
						</tr>
						</c:forEach>
						</tbody>
						</table>
						<button type="button" id="btnAddUserData" class="btn-dash" onclick="javascript:addUserData('insertFrm')"><mink:message code="mink.web.text.add.userdataentry"/></button>
					</td>
				</tr>
				</c:if>
			</tbody>
			<tfoot></tfoot>
		</table>
	
		<div class="insertBtnArea">
		</div>
	</form>
</div>

<script type="text/javascript">
/* pushListInsertDialog.jsp 팝업창 */
$("#pushListInsertDialog").dialog({
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

//업무관리 팝업 오픈
function selectTask(taskIdsLoc) {
	ajaxComm('pushTaskListView2.miaps?',$('#insertFrm'), callbackTaskListPopup);	// callbackTaskListPopup in pushTaskListPopupDialog.jsp
}

//등록/재발송(ajax) 후 목록 호출
function goInsert(mode) {
	var alertText = "<mink:message code='mink.web.alert.is.regist'/>";
	var $frm = $('#insertFrm');
	
	// 재발송인 경우
	if('resend' == mode) {
		alertText = "<mink:message code='mink.web.alert.is.resend'/>";
		$frm = $('#detailFrm');
		$frm.find("input[name='resendYn']").val("Y");
	}
	
	var reservedDt = reservedDtToDate($frm);
	$frm.find("input[name='reservedDt']").val(reservedDt);
	
	if( validation($frm) ) return; // 입력 값 검증
	
	if( !confirm(alertText) ) return;
	ajaxFileComm('pushDataInsert.miaps?', $frm, function(data){
		$("#SearchFrm").find("input[name='pushId']").val(data.pushData.pushId); // searchFrm in pushListView.jsp
		goList('1'); // 목록/검색(1 페이지로 초기화)
	});
}
</script>
