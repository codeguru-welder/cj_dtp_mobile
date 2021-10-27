<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page session="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 사용자 그룹 구성원(단일) 등록/수정 treeview dialog -->
<div id="editUserGroupMemberSearchUserGroupTreeviewDialog" title="<mink:message code='mink.web.text.info.group'/>" class="dlgStyle">
<div class="miaps-popup-top-buttons">
	&nbsp;
	<span><button id="selectedButton" class='btn-dash'><mink:message code="mink.web.text.select"/></button></span>
	<span><button class='btn-dash' onclick="javascript:$('#editUserGroupMemberSearchUserGroupTreeviewDialog').dialog('close');"><mink:message code="mink.web.text.cancel"/></button></span>
</div>	
	<div>
		<mink:message code="mink.web.text.groupname"/>
		<input type="text" id="editUserGroupMemberSearchUserGroupName" class="width50" />
		<span><button id="editUserGroupMemberSearchUserGroupNameDialogOpenerButton" class='btn-dash'><mink:message code="mink.web.text.search"/></button></span>
	</div>
	
	<div id="twdgDiv">
		<ul class="twNodeStyle">
			<li class="outerBulletStyle">
				<span id="userGroupRootSpan">${corporationName}</span>
				<ul id="editUserGroupMemberSearchUserGroupTreeviewUl" class="treeview"></ul>
			</li>
			<li class="outerBulletStyle">
				<a id="editUserGroupMemberSelectUserGroupUnclassified" href="javascript:return false;">${unclassifiedName}</a>
			</li>
		</ul>
	</div>
	
	<hr style="height:1;">
	
	<div id="editUserGroupMemberSearchUserGroupTreeviewDialogTitle" class="dialogTitle"><mink:message code="mink.web.text.regist.group"/></div>
	
	<div class="hiddenHrDivSmall"></div>
	
	<div id="editUserGroupMemberSelectUserGroupNavigation">
		<c:out value='${search.searchUserGroup.grpNavigation}'/>
	</div>
	
	<div id="addUserGroupMemberUserGroupAdminYN">
		<hr style="height:1;">
		<div class="dialogTitle"><mink:message code="mink.web.text.permission"/></div>
		<div>
			<label><input type="checkbox" name="adminYn" value="Y" style="margin-top: 8px;" /> <mink:message code="mink.web.text.status.groupadmin"/></label>
		</div>
	</div>
	
	<!-- 
	<div class="hiddenHrDivSmall"></div>
	-->
	<div>
		<input type="hidden" id="editUserGroupMemberSelectUserGroupName" />
		<input type="hidden" id="editUserGroupMemberSelectUserGroupId" />
	</div>
	
</div>

<div id="editUserGroupMemberSearchUserGroupNameDialog" title="<mink:message code='mink.web.text.search.groupname'/>" class="dlgStyle">
	<table class="listTb" border="0" cellspacing="0" cellpadding="0" width="100%">
		<thead>
			<tr>
				<th class="subSearch"><mink:message code="mink.web.text.list.search"/></th>
			</tr>
		</thead>
		<tbody id="editUserGroupMemberSearchUserGroupNameDialogTbody">
			<tr>
				<td>
					<mink:message code="mink.web.text.navi.group"/>
				</td>
			</tr>
		</tbody>
		<tfoot id="editUserGroupMemberSearchUserGroupNameDialogTfoot">
			<tr>
				<td>
					<mink:message code="mink.web.text.noexist.result"/>
				</td>
			</tr>
		</tfoot>
	</table>
</div>

<script type="text/javascript">
var mode = "";

/** document ready **/
$(function(){
	// 부모창
	var parentSearchFrmId = "#searchFrm";
	var parentListTbodyId = "#listTbody";
	//
	var parentSearchUserGroupIdId = "#searchUserGroupId";
	//
	var parentInsertSpanId = "#insertUserGroupSpan";
	var parentInsertGrpIdId = "#insertUserGroupSpan :input[name='userGroupMember.grpId']";
	var parentInsertGrpNmId = "#insertUserGroupSpan :input[name='userGroup.grpNm']";
	var parentInsertGrpNavigationId = "#insertUserGroupSpan :input[name='userGroup.grpNavigation']";
	//
	var parentDetailSpanId = "#detailUserGroupSpan";
	var parentDetailGrpIdId = "#detailUserGroupSpan input:hidden[name='userGroupMember.grpId']";
	var parentDetailGrpNmId = "#detailUserGroupSpan input[name='userGroup.grpNm']";
	var parentDetailGrpNavigationId = "#detailUserGroupSpan input[name='userGroup.grpNavigation']";
	//
	var parentInsertOpenerBtnId = "#editUserGroupMemberSearchUserGroupTreeviewDialogOpenerButtonInsert";
	var parentDetailOpenerBtnId = "#editUserGroupMemberSearchUserGroupTreeviewDialogOpenerButtonDetail";
	var parentSaveOpenerBtnId = "#editUserGroupMemberSearchUserGroupTreeviewDialogOpenerButtonSave";
	var parentAddOpenerBtnId = "#addUserGroupMemberSearchUserGroupTreeviewDialogOpenerButton";
	//
	//var parentUpdateUpGrpOpenerBtnId = "#editUserGroupUpGrpSearchUserGroupTreeviewDialogOpenerButtonUpdate";
	//
	// 서버
	
	var loginUserUserNo = "${loginUser.userNo}";
	var loginUserGrpId = "${loginUser.userGroup.grpId}";
	var loginUserAdminYn = "${loginUser.adminYn}";	
	//
	var corporation = "${corporation}";
	var unclassified = "${unclassified}";
	var unclassifiedName = "${unclassifiedName}";
	//
	
	//var parentSearchUserGroupId = "${search.searchUserGroupId}";
	var parentSearchUserGroupId = $("#searchUserGroupId").val();
	var parentSearchUserGroupNm = $("#searchUserGroup_grpNm").val();
	var parentSearchUserGroupNavigation = $("#searchUserGroup_grpNavigation").val();
	
	//
	// 현재창
	var treeviewUrl = "userGroupListTreeview.miaps?";
	var treeviewUlId = "#editUserGroupMemberSearchUserGroupTreeviewUl";
	var treeviewDialogId = "#editUserGroupMemberSearchUserGroupTreeviewDialog";
	//
	var searchNameUrl = "userGroupListSearchName.miaps?";
	var searchNameDialogId = "#editUserGroupMemberSearchUserGroupNameDialog";
	var searchNameOpenserBtnId = "#editUserGroupMemberSearchUserGroupNameDialogOpenerButton";
	var searchNameId = "#editUserGroupMemberSearchUserGroupName";
	//
	var selectNavigationId = "#editUserGroupMemberSelectUserGroupNavigation";
	var selectIdId = "#editUserGroupMemberSelectUserGroupId";
	var selectNmId = "#editUserGroupMemberSelectUserGroupName";
	var selectTitleId = "#editUserGroupMemberSearchUserGroupTreeviewDialogTitle";
	var selectUnclassifiedId = "#editUserGroupMemberSelectUserGroupUnclassified";
	//
	var insertMode = 'insert';
	var detailMode = 'detail';
	var saveMode = 'save';
	var addMode = 'add';
	var updateUpGrpMode = 'updateUpGrp';
	//
	
	// 상위그룹수정
	var updateUpGrpUserGroup = function() {
		var parentSearchUserGroupId = $(parentSearchUserGroupIdId).val(); // 부모창 그룹ID
		var searchUserGroupId = $(selectIdId).val(); // 검색 그룹ID
		
		var grpId = parentSearchUserGroupId;
		var upGrpId = searchUserGroupId;
		var updNo = loginUserUserNo;
		
		if('' == grpId || null == grpId) {
			alert("<mink:message code='mink.web.alert.select.modifygroup.uppergroup'/>");
			return;
		}
		if('' == upGrpId || null == upGrpId) {
			alert("<mink:message code='mink.web.alert.select.uppergroup'/>");
			return;
		}
		
		// 선택 그룹ID와 부모창 그룹ID를 포함한 하위그룹ID 를 비교해서, 같은 ID가 있으면 검증실패(상위그룹이 될 수 없음)
		var answer = false;
		$.ajaxSetup({async:false}); // 비동기 옵션 끄기(ajax 동기화)
		$.post('userGroupContainParentFindChildren.miaps?', { grpId: grpId }, function(data){
			if(0 < data.userGroupList.length) {
				for(var j = 0; j < data.userGroupList.length; j++) {
					if(upGrpId == data.userGroupList[j].grpId) {
						answer = true;
						alert("<mink:message code='mink.web.alert.notbe.uppergroup'/>" + "\n" + "<mink:message code='mink.web.alert.select.othergroup'/>");
						break;
					}
				}
			}
		}, 'json');
		$.ajaxSetup({async:true}); // 비동기 옵션 켜기
		
		if(answer) {
			return;
		}
		
		// 선택창
		if(!confirm("<mink:message code='mink.web.alert.is.modify'/>")) return;
		$.post('userGroupUpdateUpGrpId.miaps?', {grpId: grpId, upGrpId: upGrpId, updNo: updNo}, function(data){
			resultMsg(data.msg);
			goUserListByPage('1'); // 목록/검색
			reloadTreePopup(grpId); // 트리 다시 불러오기 (현재 팝업창)
			reloadTreeview(grpId);  // 트리 다시 불러오기 (userListView.jsp의 트리뷰)
		}, 'json');
	};
	
	// 그룹 구성원의 그룹 이동(다수)
	var saveUserGroupMember = function() {
		var searchUserGroupId = $(selectIdId).val(); // 검색 그룹ID
		//var searchUserGroupNm = $(selectNmId).val(); // 검색 그룹Nm
		var searchUserGroupNavigation = $(selectNavigationId).text(); // 검색 그룹 네비게이션
		if(unclassified == searchUserGroupId) searchUserGroupId = "";
		
		var $checkedUserNoList = $(parentListTbodyId).find(":checkbox:checked"); // 선택된 사용자들
		
		var userNoObjArray = new Array();
		
		// 선택한 그룹과 중복 확인
		var isEqual = false;
		$checkedUserNoList.each(function(){
			if(searchUserGroupId == $(this).next(":input[name='preGrpIdList']").val()) {
				userNoObjArray.push(this);
				isEqual = true;
			}
		});
		if(isEqual) {
			alert("<mink:message code='mink.web.alert.already.ingroup'/>");
			
			if(0 < userNoObjArray.length) {
				for(var i = 0; i < userNoObjArray.length; i++) {
					userNoObjArray[i].checked = false;
				}
			}
			
			return;
		}
		
		// 같은 사용자(겸직일 경우)가 있는지 확인
		isEqual = false;
		userNoObjArray = new Array();
		var preUserNo = '';
		$checkedUserNoList.each(function(){
			if(preUserNo == $(this).val()) {
				userNoObjArray.push(this);
				isEqual = true;
			}
			preUserNo = $(this).val();
		});
		if(isEqual) {
			alert("<mink:message code='mink.web.alert.already.sameuser'/>");
			
			if(0 < userNoObjArray.length) {
				for(var i = 0; i < userNoObjArray.length; i++) {
					userNoObjArray[i].checked = false;
				}
			}
			
			return;
		}
		
		// 선택한 그룹에 이미 등록된 사용자가(겸직일 경우) 있는지 확인
		isEqual = false;
		userNoObjArray = new Array();
		$.ajaxSetup({async:false}); // 비동기 옵션 끄기(ajax 동기화)
		$.post('userGroupMemberByGrpId.miaps?', { grpId: searchUserGroupId }, function(data){
			if(0 < data.userGroupMemberList.length) {
				for(var j = 0; j < data.userGroupMemberList.length; j++) {
					$checkedUserNoList.each(function(idx, userNo){
						if( data.userGroupMemberList[j].userNo == $(userNo).val() ) {
							userNoObjArray.push(this);
							isEqual = true;
						}
					});
				}
			}
		}, 'json');
		$.ajaxSetup({async:true}); // 비동기 옵션 켜기
		if(isEqual) {
			alert("<mink:message code='mink.web.alert.already.member'/>");
			
			if(0 < userNoObjArray.length) {
				for(var i = 0; i < userNoObjArray.length; i++) {
					userNoObjArray[i].checked = false;
				}
			}
			
			return;
		}
		
		if($(parentListTbodyId).find(":checkbox:checked").length < 1) {
			alert("<mink:message code='mink.web.alert.noexist.movemember'/>");
			return;
		}
		
		// 알림말
		var alertText = " <mink:message code='mink.web.text.total'/>" + $checkedUserNoList.length + " <mink:message code='mink.web.text.count.person'/>" + "\n";
		alertText += "'" + searchUserGroupNavigation + "'";
		alertText += " <mink:message code='mink.web.alert.is.move.group'/>";
		
		// 선택창
		if(!confirm(alertText)) return;
		$(parentSearchFrmId).find(":hidden[name='grpId']").val(searchUserGroupId);
		var url = 'userGroupMemberInsert.miaps?';
		if(corporation == $(parentSearchUserGroupIdId).val()) {
			url = 'userGroupMemberRootInsert.miaps?';
			$(parentListTbodyId).find(":checkbox").each(function(){
				if(!this.checked) {
					$(this).next(":input[name='preGrpIdList']").remove();
				}
			});
		}
		ajaxComm(url, $(parentSearchFrmId).get(0), function(data){
			resultMsg(data.msg);
			$(":input[name='userNo']", parentSearchFrmId).val("");
			goUserListByPage($(":input[name='pageNum']", parentSearchFrmId).val());
		});
	};
	
	// 다중 사용자그룹 추가
	var addUserGroup = function() {
		var searchUserGroupId = $(selectIdId).val(); // 검색 그룹ID
		var userNo = $(":input[name='userNo']", parentSearchFrmId).val();
		var adminYn = "N";
		if($("#addUserGroupMemberUserGroupAdminYN").find(":checkbox[name='adminYn']").get(0).checked) {
			// 그룹관리자 권한을 선택했으면, 부모가 슈퍼관리자 권한인지 확인
			if($(":radio[name='adminYn']", "#detailFrm").filter(":radio[title='superAdmin']").get(0).checked) {
				alert("<mink:message code='mink.web.alert.already.superadmin'/>");
				$("#addUserGroupMemberUserGroupAdminYN").find(":checkbox[name='adminYn']").get(0).checked = false;
				return;
			}
			adminYn = 'Y';
		}
		
		// 현재 그룹을 선택했는지 검증
		var selectedGrpId = $("#userGroupTd").find("input[name='userGroupMember.grpId']").val();
		if(searchUserGroupId == selectedGrpId) {
			alert("<mink:message code='mink.web.alert.duplicate.group'/>");
			return;
		}
		
		// 다중 그룹중에서 선택했는지 검증
		var isDuplicated = false;
		$("#userGroupTd").find("input[name='multiGrpId']").each(function(idx, id){
			if(searchUserGroupId == $(id).val()) {
				isDuplicated = true;
			}
		});
		if(isDuplicated) {
			alert("<mink:message code='mink.web.alert.duplicate.group'/>");
			isDuplicated = true;
			return;
		}
		
		// 등록
		if(!confirm("<mink:message code='mink.web.alert.is.add'/>")) return;
		$.post('userGroupMemberInsertOnly.miaps?', {grpId: searchUserGroupId, userNo: userNo, adminYn: adminYn, regNo: "${loginUser.userNo}", preGrpId : selectedGrpId}, function(data){
			resultMsg(data.msg);
			//goUserListByPage($(":input[name='pageNum']", parentSearchFrmId).val()); // 목록/검색
			
			$(treeviewDialogId).dialog('close');
			
			userDetail(data.reqParam.userNo, data.reqParam.preGrpId);
			
		}, 'json');
	};
	
	// 그룹 검색 정보를 부모창에 세팅
	var setSearchUserGroup = function() {
		var searchUserGroupId = $(selectIdId).val(); // 검색 그룹ID
		var searchUserGroupNm = $(selectNmId).val(); // 검색 그룹Nm
		var searchUserGroupNavigation = $(selectNavigationId).html(); // 검색 그룹 네비게이션
		
		var parentIdId = '';
		var parentNmId = '';
		var parentNavigationId = '';
		var parentSpanId = '';
		
		if(insertMode == mode) {
			parentIdId = parentInsertGrpIdId;
			parentNmId = parentInsertGrpNmId;
			parentNavigationId = parentInsertGrpNavigationId;
			parentSpanId = parentInsertSpanId;
		}
		else if(detailMode == mode) {
			parentIdId = parentDetailGrpIdId;
			parentNmId = parentDetailGrpNmId;
			parentNavigationId = parentDetailGrpNavigationId;
			parentSpanId = parentDetailSpanId;
		}
		
		// 부모창에 세팅
		$(parentIdId).val(searchUserGroupId); // 검색 그룹ID
		$(parentNmId).val(searchUserGroupNm); // 검색 그룹ID
		$(parentNavigationId).val(searchUserGroupNavigation); // 검색 그룹 네비게이션
		$(parentSpanId).find("span").html(searchUserGroupNavigation); // 검색 그룹 네비게이션
		
		$( treeviewDialogId ).dialog( "close" );
	};
	
	// 그룹명 검색 선택 후 그룹 조직도 다이얼로그로 돌아가기
	var setSelectUserGroup = function(event) {
		$(selectIdId).val(event.data.userGroup.grpId); // 선택 그룹ID
		$(selectNmId).val(event.data.userGroup.grpNm); // 선택 그룹명
		$(selectNavigationId).html(event.data.userGroup.grpNavigation); // 선택 그룹 네비게이션
		
		$( searchNameDialogId ).dialog( "close" ); // 그룹명 검색 다이얼로그 닫기
		
		reloadTreePopup($(selectIdId).val()); // 트리 다시 불러오기
	};
	
	//그룹 구성원 등록/수정 조직도 다이얼로그 팝업 나타나기
	var showSearchUserGroupTreeviewDialog = function(event) {
		// root 선택불가
		$("#userGroupRootSpan").html("${corporationName}");
		// 그룹없음 노드 보이기
		$("#editUserGroupMemberSelectUserGroupUnclassified").parent("li").show();
		// 권한설정 숨기기
		$("#addUserGroupMemberUserGroupAdminYN").hide();
		
		if(parentInsertOpenerBtnId == "#"+$(event.target).attr("id")) {
			$(selectTitleId).text("<mink:message code='mink.web.text.regist.group'/>");
			mode = insertMode;
			
			$(selectNavigationId).html($(parentInsertGrpNavigationId).val());
			$(selectIdId).val($(parentInsertGrpIdId).val());
			$(selectNmId).val($(parentInsertGrpNmId).val());
		}
		else if(parentDetailOpenerBtnId == "#"+$(event.target).attr("id")) {
			$(selectTitleId).text("<mink:message code='mink.web.text.modify.group'/>");
			mode = detailMode;
			
			$(selectNavigationId).html($(parentDetailGrpNavigationId).val());
			$(selectIdId).val($(parentDetailGrpIdId).val());
			$(selectNmId).val($(parentDetailGrpNmId).val());
		}
		else if(parentSaveOpenerBtnId == "#"+$(event.target).attr("id")) {
			if($(parentListTbodyId).find(":checkbox:checked").length < 1) {
				alert("<mink:message code='mink.web.alert.select.item'/>");
				return;
			}
			
			$(selectTitleId).text("<mink:message code='mink.web.text.move.group'/>");
			mode = saveMode;
			
			var nv = $(parentDetailGrpNavigationId).val();
			if( '' == nv ) nv = "${unclassifiedName}";
			
			var nm = $(parentDetailGrpNmId).val();
			if( '' == nm ) nm = "${unclassifiedName}";
			
			$(selectNavigationId).html(nv);
			$(selectIdId).val($(parentDetailGrpIdId).val());
			$(selectNmId).val(nm);
		}
		else if(parentAddOpenerBtnId == "#"+$(event.target).attr("id")) {
			$(selectTitleId).text("<mink:message code='mink.web.text.add.group'/>");
			mode = addMode;
			
			$(selectNavigationId).html($(parentDetailGrpNavigationId).val());
			$(selectIdId).val($(parentDetailGrpIdId).val());
			$(selectNmId).val($(parentDetailGrpNmId).val());
			
			// 권한설정 보이기
			$("#addUserGroupMemberUserGroupAdminYN").show();
			
			// 그룹없음 노드 숨기기
			$("#editUserGroupMemberSelectUserGroupUnclassified").parent("li").hide();
		}
		<%--
		else if(parentUpdateUpGrpOpenerBtnId == "#"+$(event.target).attr("id")) {
			var $clickRoot = $("<a id='editUserGroupMemberSelectUserGroupCorporation' href='javascript:return false;'>${corporationName}</a>").bind("click", function(){
				alert("1");
				$(selectNavigationId).html("${corporationName}");
				$(selectIdId).val("${corporation}");
				$(selectNmId).val("${corporationName}");
			});
			// root 선택가능
			$("#userGroupRootSpan").html($clickRoot);
			// 그룹없음 노드 숨기기
			$("#editUserGroupMemberSelectUserGroupUnclassified").parent("li").hide();
			
			$(selectTitleId).text("상위그룹수정");
			mode = updateUpGrpMode;

			$(selectNavigationId).html(parentSearchUserGroupNavigation);
			$(selectIdId).val(parentSearchUserGroupId);
			$(selectNmId).val(parentSearchUserGroupNm);
		}
		--%>
		
		$( treeviewDialogId ).dialog( "open" ); // 그룹 검색 조직도 다이얼로그 팝업 나타나기
	}
	
	// 그룹명 검색 다이얼로그 팝업 나타나기
	var showSearchUserGroupNameDialog = function() {
		var selectUserGroupName = $(searchNameId).val();
		
		var grpId = loginUserGrpId;
		var grpNm = selectUserGroupName;
		
		if('' != selectUserGroupName) {
			if('Y' == loginUserAdminYn) grpId = ''; // 슈퍼관리자는 전체 검색 가능
			$.post(searchNameUrl, {grpId: grpId, grpNm: grpNm}, function(data){
				if(0 < data.searchUserGroupList.length) {
					$(searchNameDialogId+"Tbody").html("");
					for(var i = 0; i < data.searchUserGroupList.length; i++) {
						var $td = $("<td style='float: left;' />").html(data.searchUserGroupList[i].grpNavigation);
						var $tr = $("<tr />").bind("click", {userGroup: data.searchUserGroupList[i]}, setSelectUserGroup);
						$tr.append($td);
						$(searchNameDialogId+"Tbody").append($tr);
					}
					
					$(searchNameDialogId+"Tbody").show();
					$(searchNameDialogId+"Tfoot").hide();
				}
				else {
					$(searchNameDialogId+"Tbody").hide();
					$(searchNameDialogId+"Tfoot").show();
				}
				
				$( searchNameDialogId ).dialog( "open" ); // 그룹명 검색 다이얼로그 팝업 나타나기
			}, 'json');
		}
	};
	
	//노드 선택 이벤트
	var clickNode_searchUserGroupTreeviewDialog = function(event){
		console.log("--clickNode_searchUserGroupTreeviewDialog");
		console.log(event.target);
		
		var selectUserGroupId = $(event.target).data("grp").grpId;
		var selectUserGroupName = $(event.target).data("grp").grpNm;
		var searchUserGroupNavigation = $(event.target).data("grp").grpNavigation; // 그룹 네비게이션
		
		$(selectIdId).val(selectUserGroupId); // 그룹ID
		$(selectNmId).val(selectUserGroupName); // 그룹명
		$(selectNavigationId).html(searchUserGroupNavigation); // 그룹 네비게이션
		
		$("a", "#twdgDiv").css("background", "#FFFFFF");
		$(event.target).css("background", "#FFD700"); // check 된 css 적용
	};
	
	var btnSelect = function() {
		if(saveMode == mode) {
			saveUserGroupMember(); // 그룹 구성원의 그룹 이동(다수)
		}
		else if(addMode == mode) {
			addUserGroup(); // 다중 그룹추가
		}
		else if(updateUpGrpMode == mode) {
			updateUpGrpUserGroup(); // 상위그룹변경
		}
		else {
			setSearchUserGroup(); // 그룹 검색 정보를 부모창에 세팅
		}
	};
	
	// 트리 다시 불러오기
	function reloadTreePopup(grpId) {
		if("${corporation}" == grpId || "${unclassified}" == grpId) grpId = "";
		
		var $parent = $(treeviewUlId).parent("li");
		$(treeviewUlId).remove(); // 트리 삭제
		$parent.append("<ul id='" + treeviewUlId.substring(1) + "' class='treeview'></ul>"); // 트리 ul 추가
		
		var url = treeviewUrl;
		if("" != grpId) url = "userGroupListTreeviewSelectedNode.miaps?grpId="+grpId; // 선택한 트리만 열기
		
		treeviewAlink(url, treeviewUlId, clickNode_searchUserGroupTreeviewDialog); // ajax treeview
	}
	
	// 그룹 검색 조직도 다이얼로그
	$( treeviewDialogId ).dialog({
		autoOpen: false
		, modal: true
		, maxHeight: 700
		/*
		, buttons: {
			"선택": function() {
				if(saveMode == mode) {
					saveUserGroupMember(); // 그룹 구성원의 그룹 이동(다수)
				}
				else if(addMode == mode) {
					addUserGroup(); // 다중 그룹추가
				}
				else if(updateUpGrpMode == mode) {
					updateUpGrpUserGroup(); // 상위그룹변경
				}
				else {
					setSearchUserGroup(); // 그룹 검색 정보를 부모창에 세팅
				}
            }
			, "닫기": function() {
				$( this ).dialog( "close" );
            }
		}*/
		, open: function( event, ui ) {
			reloadTreePopup($(selectIdId).val()); // 트리 다시 불러오기
		}
	});
	
	// 그룹명 검색 다이얼로그 팝업
	$( searchNameDialogId ).dialog({
		autoOpen: false
		, width: 600
		, maxHeight: 700
		, modal: true
		, buttons: {
			"<mink:message code='mink.web.text.cancel'/>": function() {
				$( this ).dialog( "close" );
				$( treeviewDialogId ).find(":input:visible").first().focus();
            }
		}
	});
	
	// 그룹명 엔터 검색
	$(searchNameId).on("keypress", function(e){
		if (e.which == 13) {
			showSearchUserGroupNameDialog();
			return false;
		}
	});
	
	// 그룹없음
	$(selectUnclassifiedId).bind("click", function(){
		$(selectIdId).val(unclassified); // 그룹ID
		$(selectNmId).val(unclassifiedName); // 그룹명
		$(selectNavigationId).html(unclassifiedName); // 그룹 네비게이션
		
		$("a", "#twdgDiv").css("background", "#FFFFFF");
		$(selectUnclassifiedId).css("background", "#FFD700"); // check 된 css 적용
	});
		
	//그룹 구성원 등록/수정 조직도 다이얼로그 팝업 나타나기
	$(parentAddOpenerBtnId).bind("click", showSearchUserGroupTreeviewDialog); // 다중 그룹추가
	$(parentSaveOpenerBtnId).bind("click", showSearchUserGroupTreeviewDialog); // 그룹 구성원 등록/수정/삭제(다수)
	$(parentInsertOpenerBtnId).bind("click", showSearchUserGroupTreeviewDialog); //그룹 구성원 등록
	$(parentDetailOpenerBtnId).bind("click", showSearchUserGroupTreeviewDialog); //그룹 구성원 수정
	//$(parentUpdateUpGrpOpenerBtnId).bind("click", showSearchUserGroupTreeviewDialog); // 상위그룹수정
	$('#selectedButton').bind("click", btnSelect); // 선택버튼
	
	//그룹명 검색 다이얼로그 팝업 나타나기
	$(searchNameOpenserBtnId).bind("click", showSearchUserGroupNameDialog);

	treeviewAlink(treeviewUrl, treeviewUlId, clickNode_searchUserGroupTreeviewDialog); // ajax treeview
	//$.post(treeviewUrl, {root: 'source'}, function(data){ alert(data); });
});

// 트리 완료 후 선택 node 체크 표시
function completeTreeview(treeview) {
	if( 'editUserGroupMemberSearchUserGroupTreeviewUl' == $(treeview, "ul").eq(0).attr("id") ) {
		var selectId = $("#editUserGroupMemberSelectUserGroupId").val();
		
		$("a", "#twdgDiv").css("background", "#FFFFFF");
		if("${corporation}" == selectId) $("#editUserGroupMemberSelectUserGroupCorporation").css("background", "#FFD700"); // check 된 css 적용
		else if("${unclassified}" == selectId || '' == selectId) $("#editUserGroupMemberSelectUserGroupUnclassified").css("background", "#FFD700"); // check 된 css 적용
		else {
			$("a", treeview).each(function(){
				if($(this).attr("id") == $("#editUserGroupMemberSelectUserGroupId").val()) {
					$(this).css("background", "#FFD700"); // check 된 css 적용
				}
			});
		}
	}
}

//그룹 구성원 등록/수정 조직도 다이얼로그 팝업 나타나기
//var showSearchUserGroupTreeviewDialog = function(event) {
function showSearchUserGroupTreeviewDialogNotBind() {	
	// root 선택불가
	$("#userGroupRootSpan").html("${corporationName}");
	// 그룹없음 노드 보이기
	$("#editUserGroupMemberSelectUserGroupUnclassified").parent("li").show();
	// 권한설정 숨기기
	$("#addUserGroupMemberUserGroupAdminYN").hide();
		
	var $clickRoot = $("<a id='editUserGroupMemberSelectUserGroupCorporation' href='javascript:return false;'>${corporationName}</a>").bind("click", function(event){
		$("#editUserGroupMemberSelectUserGroupNavigation").html("${corporationName}");
		$("#editUserGroupMemberSelectUserGroupId").val("${corporation}");
		$("#editUserGroupMemberSelectUserGroupName").val("${corporationName}");
		
		$("a", "#twdgDiv").css("background", "#FFFFFF");
		$(event.target).css("background", "#FFD700");
	});
	// root 선택가능
	$("#userGroupRootSpan").html($clickRoot);
	// 그룹없음 노드 숨기기
	$("#editUserGroupMemberSelectUserGroupUnclassified").parent("li").hide();
	
	$("#editUserGroupMemberSearchUserGroupTreeviewDialogTitle").text("<mink:message code='mink.web.text.modify.uppergroup'/>");
	mode = 'updateUpGrp';
	
	var tmpSearchUserGroupId = $("#searchUserGroup_grpId").val();
	console.log(tmpSearchUserGroupId);

	$("#editUserGroupMemberSelectUserGroupNavigation").html($("#searchUserGroup_grpNavigation").val());
	$("#editUserGroupMemberSelectUserGroupId").val(tmpSearchUserGroupId);
	$("#editUserGroupMemberSelectUserGroupName").val($("#searchUserGroup_grpNm").val());
	
	$("a", "#twdgDiv").css("background", "#FFFFFF");
	$("a[id='"+tmpSearchUserGroupId+"']", "#twdgDiv").css("background", "#FFD700");
	
	$("#editUserGroupMemberSearchUserGroupTreeviewDialog").dialog( "open" ); // 그룹 검색 조직도 다이얼로그 팝업 나타나기
}
</script>