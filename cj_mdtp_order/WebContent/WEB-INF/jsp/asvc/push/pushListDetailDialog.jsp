<!-- 관리자 푸시 -> 리스트 클릭 --> 
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page import="com.thinkm.mink.commons.MinkTotalConstants"%>
<%@ page import="com.thinkm.mink.commons.util.MinkContextParam"%>

<div id="pushListDetailDialog" title="<mink:message code='mink.web.text.push.detail'/>" class="dlgStyle">
<div id="detailDiv">
	<div id="container_appRole"> <!-- menuPushTargetDiv -->
		<ul class="tabs_appRole"><!-- <ul class="menu"> -->
			<li id="pushDetail" class="active" rel="tab1"><mink:message code="mink.web.text.push.mesagedetail"/></li>
			<li id="userGroup" rel="tab2"><mink:message code="mink.web.text.user.group"/></li>
			<li id="userInfo" rel="tab3"><mink:message code="mink.web.text.user"/></li>
			<li id="userDevice" rel="tab4"><mink:message code="mink.web.text.device"/></li>
		</ul>
		<div class="tab_container_appRole">	<!-- <div class='detailPush'><br/> -->
			<div class="miaps-popup-top-buttons-in-tap">
				&nbsp;
				<span><button id="btnSelectSave" class='btn-dash' onclick="javascript:selectSave();"><mink:message code="mink.web.text.save"/></button></span>
				<span><button class='btn-dash' onclick="javascript:$('#pushListDetailDialog').dialog('close');"><mink:message code="mink.web.text.cancel"/></button></span>
				<span><button class='btn-dash' onclick="javascript:toDeleteAll();"><mink:message code="mink.web.text.push.delete.all.pushtarget"/></button></span>
			</div>
			<input type="hidden" name="pushId" value=""/>
			<div id="tab1" class="tab_content_appRole">
				<!-- 상세화면 폼 시작 -->
				<form id="detailFrm" name="detailFrm" method="post" class="detailFrm1">
					<input type="hidden" name="updNo" value="${loginUser.userNo}"/>	<!-- 로그인한 사용자 -->
					<input type="hidden" name="regNo" value="${loginUser.userNo}"/>	<!-- 등록한 사용자(재발송시) -->
					<input type="hidden" name="resendYn" value=""/>	<!-- 재발송 여부(재발송시) -->
					<input type="hidden" name="prePushId" value=""/>	<!-- 이전 key(재발송시) -->
					<input type="hidden" name="pushId" value=""/>	<!-- key -->
					<input type="hidden" name="searchPageSize" value="8"/>
					<!-- <input type="hidden" name="taskId" value=""/> -->
					<table class="detailTb" border="0" cellspacing="0" cellpadding="0" width="100%">
						<colgroup>
							<col width="20%" />
							<col width="80%" />
						</colgroup>
						<tbody>
							<tr>
								<th><span class="criticalItems"><mink:message code="mink.web.text.taskname"/></span></th>
								<td>
									&nbsp;<button type="button" id="btnTask" class="btn-dash" onclick="javascript:selectTaskDetail('detailFrm')"><mink:message code="mink.web.text.select.task"/></button><br />
									<span id="taskIdPos"></span>
									<input type='hidden' id='taskIdSetYn' value='Y' />
									<input type='hidden' name = "taskIdsLoc" value="detailFrm"/>
									<input type='hidden' name = "isPopup" value="Y"/>
								</td>
							</tr>
							<tr>
								<th><mink:message code="mink.web.text.apppackagename"/></th>
								<td><span id="packageNm"></span></td>
							</tr>
							<tr>
								<th><mink:message code="mink.web.text.status.regist"/></th>
								<td><input type="text" name="dataSt" readonly="readonly" /></td>
							</tr>
							<tr>
								<th><span class="criticalItems"><mink:message code="mink.web.text.pushmessage2"/></span></th>
								<td>
									<!--  input type="text" name="pushMsg"  maxlength="85"/ -->
									<textarea name="pushMsg" onmouseup="textareaResize(this)" onkeyup="textareaResize(this)"></textarea>
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
										<input id="dtlImgUrlYn" type="checkbox" name="imgUrlYn" value="N" class="checkbox_with_label" style="width: 13px; height: 13px;" /><!-- style=.detailTb tbody tr td input{width: 100%} -->
										<label for="dtlImgUrlYn" title="<mink:message code='mink.web.text.push.imageurl3'/>" class="label_with_checkbox"><mink:message code="mink.web.text.notimage"/></label>
									</span>
								</td>
							</tr>
						</c:if>
							<tr>
								<th><mink:message code="mink.web.text.push.reserved.senddate"/></th>
								<td class="pushDate_2">
									<input type="text" name="reservedDd" size="13" class="datepicker"/>
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
									<input type="text" name="badgeCnt" value="0" maxlength="3" onKeyup="this.value=this.value.replace(/[^0-9]/g, '');"/>&nbsp;
									0 초기화, &gt;0 카운트 변경, &lt;0 변경없음
								</td>
							</tr>
							<c:if test='${pushType eq "PREMIUM"}'>
							<tr>
								<th><span><mink:message code="mink.web.text.userdata"/></span></th>
								<td><!-- 커스텀 데이터 입력하기 - 2018/09/12 -->
									<table id="tblDtl_UserData" class="listTb" border="0" cellspacing="0" cellpadding="0" width="100%">
									<colgroup>
										<col width="30%" />
										<col width="70%" />
									</colgroup>
									<tbody>
									<c:forEach var="userData" items="${addedDetailData}" varStatus="i">
									<tr>
										<th>${userData.desc}(${userData.key})</th>
										<td><input type="text" name="dtlUserData_${userData.key}" readonly="readonly"/></td>
									</tr>
									</c:forEach>
									</tbody>
									</table>
								</td>
							</tr>
							</c:if>
							<tr>
								<th><mink:message code="mink.web.text.push.start.senddate"/></th>
								<td><input type="text" name="sendStartDt" readonly="readonly"/></td>
							</tr>
							<tr>
								<th><mink:message code="mink.web.text.push.end.senddate"/></th>
								<td><input type="text" name="sendEndDt" readonly="readonly"/></td>
							</tr>
							<tr>
								<th><mink:message code="mink.web.text.push.resultcode"/></th>
								<td><input type="text" name="resultCd" readonly="readonly"/></td>
							</tr>
							<tr>
								<th><mink:message code="mink.web.text.push.resultdetail"/></th>
								<td><input type="text" name="resultMsg" size="20" readonly="readonly"/></td>
							</tr>
							<tr>
								<th><mink:message code="mink.web.text.register"/></th>
								<td><input type="text" name="regNm" readonly="readonly"/></td>
							</tr>
							<tr>
								<th><mink:message code="mink.web.text.regdate"/></th>
								<td><input type="text" name="regDt" readonly="readonly"/></td>
							</tr>
						</tbody>
						<tfoot></tfoot>
					</table>
				</form>
				<!-- 상세화면 폼 끝 -->
			</div>
	
			<div id="tab2" class="tab_content_appRole">			<!-- <div class="content group"><br/> -->
				<input type="hidden" name="regNo" value="${loginUser.userNo}"/>	<!-- 로그인한 사용자 -->
				<input type="hidden" name="pushId" value=""/>	
				<div style="float:left; width: 310px;">
					<div class="pushLeftScrollBoarder" style="width:100%; height: 720px; margin-bottom: 10px;">
						<ul>
							<li>
								<form id="userGroupSearchFrm" name="userGroupSearchFrm" method="post" onsubmit="return false;">
								<input type="hidden" name="pageNum" value=""/>
								<input type="hidden" name="pushId" /><!-- 푸시타겟 목록관리대상으로 조회할때 구분값 -->
								</form>
							</li>
						</ul>
						<div id="treeviewUlIdDiv" class="twNodeStyle" style="font: normal 12px 맑은 고딕, HYHeadLine, 돋움, verdana, arial, helvetica, sans-serif; margin:0px 10px 0px 30px;">
							<li class="outerBulletStyle"><span style="padding-left:1px;"><b><mink:message code="mink.web.text.user.group"/></b></span>
								<ul id="treeviewUlId" class="treeview" style="text-decoration: none;"></ul>
							</li>
						</div>		
					</div>
				</div>
				<div id="rightDiv" style="float:left; margin : 0px 10px 0px 10px;">
					<!-- 화살표 버튼 시작 -->
					<button id="pushRBtn" class='btn-arrow' onclick="javascript:toRight()">→</button><br/>
					<button id="pushLBtn" class='btn-arrow' onclick="javascript:toLeft()">←</button>
					<!-- 화살표 버튼 끝 -->
				</div>
				<div id="groupDiv2" style="float:right; width: 640px;"">
					<form name="pushTargetFrm" id="pushTargetFrm">
					<input type="hidden" name="pushId" value=""/>	
					<table id="ugListTb" border="0" cellspacing="0" cellpadding="0" width="100%" class="listTb">
						<colgroup>
							<col width="5%" />
							<col width="35%" />
							<col width="30%" />
							<col width="25%" />
						</colgroup>
						<thead>
							<tr>
								<td><input type="checkbox" name="ugCheckboxAll" /></td>
								<td><mink:message code="mink.web.text.user.groupname"/></td><td><mink:message code="mink.web.text.user.groupid"/></td><td><mink:message code="mink.web.text.include.undergroup"/></td>
							</tr>
						</thead>
						<tbody>
						</tbody>
						<tfoot></tfoot>
					</table>
					</form>
				</div>
			</div>
	
			<div id="tab3" class="tab_content_appRole"><!-- <div class="content user"><br/> -->
				<div style="float:left; width:475px; height: 720px;">
					<!-- 푸시타겟 사용자관리 시작-->
					<form id="userSearchFrm" name="userSearchFrm" method="post" onSubmit="return false;"  >
						<input type="hidden" name="pageNum" value=""/>
						<input type="hidden" name="pushId" /><!-- 푸시타겟 목록관리대상으로 조회할때 구분값 -->
						<input type="hidden" name="existPaging" value="Y" /><!-- 푸시타겟 목록관리대상으로 조회할때 사용자목록 구분값 -->
						<input type="hidden" name="startRow" value="1" /><!-- 시작줄 -->
						
						
						<!-- 검색 화면 시작 -->
						<table border="0" cellspacing="0" cellpadding="0" width="100%">
							
							<!-- 그룹검색 시작 -->
							<%@ include file="/WEB-INF/jsp/include/searchUserGroupTr.jsp" %>
							<!-- 그룹검색 끝 -->
							
							<tr>
								<td class="search">
									<select name="searchKey">
										<option value=""><mink:message code="mink.web.text.full.all"/></option>
										<option value="userNo"><mink:message code="mink.web.text.userno"/></option>
										<option value="userId"><mink:message code="mink.web.text.userid"/></option>
										<option value="userNm"><mink:message code="mink.web.text.username"/></option>
									</select>
									<select name="pageSize">
										<option value="20" ${search.searchKey == '20' ? 'selected' : ''}><mink:message code="mink.web.text.view.by20"/></option>
										<option value="100" ${search.searchKey == '100' ? 'selected' : ''}><mink:message code="mink.web.text.view.by100"/></option>
										<option value="500" ${search.searchKey == '500' ? 'selected' : ''}><mink:message code="mink.web.text.view.by500"/></option>
									</select>
									<input type="text" name="searchValue" />
									<button class='btn-dash' onclick="javascript:goUserList('1');"><mink:message code="mink.web.text.search"/></button>
								</td>
							</tr>
						</table>
					</form>
				    <!-- 검색 화면 끝 -->
					<!-- 목록 시작-->
					<div class="pushLeftScroll" style="height: 600px;">
						<table id="userListTb" border="0" cellspacing="0" cellpadding="0" width="100%" class="listTb">
							<colgroup>
								<col width="5%" />
								<col width="65%" /><col width="30%" /><!-- <col width="35%" /> -->
							</colgroup>
							<thead>
								<tr>
									<td><input type="checkbox" name="userCheckboxAll" /></td>
									<td><mink:message code="mink.web.text.username.id"/></td><td><mink:message code="mink.web.text.userno"/></td><!-- <td>그룹명</td> -->
								</tr>
							</thead>
							<tbody>
							</tbody>
						</table>
						<div id="moreUserDiv" style="display: none; text-align: center;"><button class='btn-dash' style="margin-top: 5px;" onclick="javascript:moreUser();"><mink:message code="mink.web.text.viewmore"/></button></div>
					</div>
				</div>
				
				<div id="rightDiv" style="float:left; margin: 0px 10px 0px 10px;">
						<!-- 화살표 버튼 시작 -->
					<button id="pushRBtn" class='btn-arrow' onclick="javascript:toRight()">→</button><br/>
					<button id="pushLBtn" class='btn-arrow' onclick="javascript:toLeft()">←</button>
					<!-- 화살표 버튼 끝 -->
				</div>	
				
				<div id="userDiv2" style="float:right; width: 475px; height: 720px; overflow:auto;">
				<form name="pushTargetFrm" id="pushTargetFrm">
					<table id="unListTb" border="0" cellspacing="0" cellpadding="0" width="100%" class="listTb">
						<colgroup>
							<col width="5%" />
							<col width="65%" /><col width="30%" /><!-- <col width="40%" /> -->
						</colgroup>
						<thead>
							<tr>
								<td><input type="checkbox" name="unCheckboxAll" /></td>
								<td><mink:message code="mink.web.text.username.id"/></td><td><mink:message code="mink.web.text.userno"/></td><!-- <td>그룹명</td> -->
							</tr>
						</thead>
						<tbody>
						</tbody>
					</table>
					</form>
					<br/>
					<table border="0" cellspacing="0" cellpadding="0" width="100%" class="listTb">
						<thead>
							<tr>
								<td><mink:message code="mink.web.text.message11"/></td>
							</tr>
						</thead>
					</table>
					<table id="udListTb" border="0" cellspacing="0" cellpadding="0" width="100%" class="listTb">
						<colgroup>
							<col width="5%" /><col width="65%" /><col width="30%" />
						</colgroup>
						<thead>
							<tr>
								<td></td><td><mink:message code="mink.web.text.username.id"/></td><td><mink:message code="mink.web.text.userno"/></td>
							</tr>
						</thead>
						<tbody>
						</tbody>
					</table>
				</div>
			</div>
			
			<div id="tab4" class="tab_content_appRole"><!-- <div class="content device"><br/> -->
				<div style="float:left; width:475px; height: 720px;">
					<!-- 푸시타겟 장치관리 시작-->
					<form id="deviceSearchFrm" name="deviceSearchFrm1" method="post" onSubmit="return false;">
						<input type="hidden" name="pageNum" value=""/>
						<input type="hidden" name="pushId" /><!-- 푸시타겟 목록관리대상으로 조회할때 구분값 -->
						<input type="hidden" name="existPaging" value="Y"/>
						<input type="hidden" name="searchUserGroupId" value="${loginUser.adminYn == ynYes ? corporation : loginUser.userGroup.grpId}"/><!-- 로그인 사용자 그룹 -->
						<input type="hidden" name="searchUserGroupSubAllYn" value="${ynYes}"/><!-- 사용자 그룹 하위포함 -->
						<input type="hidden" name="startRow" value="1" /><!-- 시작줄 -->
						
						<!-- 검색 화면 시작 -->
						<table border="0" cellspacing="0" cellpadding="0" width="100%">
							<tr> 	
								<td class="search">
									<select name="searchKey">
										<option value=""><mink:message code="mink.web.text.full.all"/></option>
										<option value="userNm"><mink:message code="mink.web.text.username"/></option>
										<option value="userId"><mink:message code="mink.web.text.userid"/></option>
										<option value="deviceId"><mink:message code="mink.web.text.deviceid"/></option>
									</select>
									<select name="pageSize">
										<option value="20" ${search.searchKey == '20' ? 'selected' : ''}><mink:message code="mink.web.text.view.by20"/></option>
										<option value="100" ${search.searchKey == '100' ? 'selected' : ''}><mink:message code="mink.web.text.view.by100"/></option>
										<option value="500" ${search.searchKey == '500' ? 'selected' : ''}><mink:message code="mink.web.text.view.by500"/></option>
									</select>
									<input type="text" name="searchValue" value=""/>
									<button class='btn-dash' onclick="javascript:goDeviceList('1');"><mink:message code="mink.web.text.search"/></button>
								</td>
							</tr>
						</table>
					</form>
					<!-- 검색 화면 끝 -->
					<!-- 목록 시작-->
					<div class="pushLeftScroll" style="height: 640px;">
						<table id="deviceListTb" border="0" cellspacing="0" cellpadding="0" width="100%" class="listTb">
							<colgroup>
								<col width="5%" />
								<col width="45%" /><col width="50%" />
							</colgroup>
							<thead>
								<tr>
									<td><input type="checkbox" name="deviceCheckboxAll" id="deviceCheckboxAll" /></td>
									<td><mink:message code="mink.web.text.username.id"/></td><td><mink:message code="mink.web.text.deviceid"/></td><!-- <td>전화번호</td><td>상태</td><td>등록일</td> -->
								</tr>
							</thead>
							<tbody>
							</tbody>
						</table>
						<div id="moreDeviceDiv" style="display: none; text-align: center;"><button class='btn-dash' style="margin-top: 5px;" onclick="javascript:moreDevice();"><mink:message code="mink.web.text.viewmore"/></button></div>
					</div>
				</div>
				
				<div id="rightDiv" style="float:left; margin: 0px 10px 0px 10px;">
						<!-- 화살표 버튼 시작 -->
					<button id="pushRBtn" class='btn-arrow' onclick="javascript:toRight()">→</button><br/>
					<button id="pushLBtn" class='btn-arrow' onclick="javascript:toLeft()">←</button>
					<!-- 화살표 버튼 끝 -->
				</div>								
				
				<div id="deviceDiv2"  style="float:right; width: 475px; height: 720px; overflow:auto;">
					<form name="pushTargetFrm" id="pushTargetFrm">
					<table id="ddListTb" border="0" cellspacing="0" cellpadding="0" width="100%" class="listTb">
						<colgroup>
							<col width="5%" />
							<col width="45%" />
							<col width="50%" />
						</colgroup>
						<thead>
							<tr>
								<td><input type="checkbox" name="ddCheckboxAll" /></td>
								<td><mink:message code="mink.web.text.username.id"/></td><td><mink:message code="mink.web.text.deviceid"/></td><!-- <td>전화번호</td><td>상태</td><td>등록일</td> -->
							</tr>
						</thead>
						<tbody>
						</tbody>
					</table>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>
</div>				

<script type="text/javascript">

/* 업무선택 팝업 */
function selectTaskDetail(taskIdsLoc) {
	ajaxComm('pushTaskListView2.miaps?',$('#detailFrm'), callbackTaskListPopup); // callbackTaskListPopup in pushTaskListPopupDialog.jsp
}

function selectSave(){
	if($('#pushDetail').hasClass('active')) {
  		goUpdate(); /* 푸시 상세정보 저장 function in pushListView.jsp */
	}else {
  		goUpdateTarget(); /* 푸시 타겟 저장 function in pushListView.jsp*/
	}
}

/* pushListDetailDialog.jsp 팝업창 */ 
$("#pushListDetailDialog").dialog({
	autoOpen: false,
	resizable: true,
	width: '1050px',
	height: 880,
	modal: true,
	// add a close listener to prevent adding multiple divs to the document
	close: function(event, ui) {
	    $(this).dialog( "close" );
	}
});

</script>