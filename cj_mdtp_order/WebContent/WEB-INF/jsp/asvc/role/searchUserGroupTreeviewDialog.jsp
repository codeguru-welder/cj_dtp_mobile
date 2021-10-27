<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page session="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 권한 그룹 구성원인 사용자 그룹 등록 treeview dialog -->
<div>
<div id="searchUserGroupTreeviewDialog" title="<mink:message code='mink.web.text.info.group'/>" class="dlgStyle">
	
	<div>
		<mink:message code="mink.web.text.groupname"/>
		<input type="text" id="searchUserGroupName" class="width50" />
		<span><button id="searchUserGroupNameDialogOpenerButton" class='btn-dash'><mink:message code="mink.web.text.search"/></button></span>
	</div>
	
	<div id="ugTwdgDiv">
		<ul class="twNodeStyle">
			<li class="outerBulletStyle">
				<span id="selectUserGroupRootSpan">${corporationName}</span>
				<ul id="searchUserGroupTreeviewUl" class="treeview"></ul>
			</li>
			<li id="selectUserGroupUnclassifiedLi" class="outerBulletStyle">
				<a id="selectUserGroupUnclassifiedAlink" href="javascript:return false;">${unclassifiedName}</a>
			</li>
		</ul>
	</div>
	
	<hr style="height:1;">
	
	<div id="searchUserGroupTreeviewDialogTitle" class="dialogTitle"><mink:message code="mink.web.text.permissionmember_registusergroup"/></div>
	
	<div class="hiddenHrDivSmall"></div>
	
	<div id="selectUserGroupNavigation">
		<c:out value='${loginUser.userGroup.grpNavigation}'/>
	</div>
	
	<div class="hiddenHrDivSmall"></div>
	
	<div>
		<input type="hidden" id="selectUserGroupId" value="${loginUser.userGroup.grpId}" />
		<input type="hidden" id="selectUserGroupName" value="<c:out value='${loginUser.userGroup.grpNm}'/>" />
	</div>
	<!-- 
	<div class="hiddenHrDivSmall"></div>
	 -->
	<div style="display: none;">
		<label><input type="checkbox" id="selectUserGroupSubAll" value="${ynYes}" />${subGroupContainText}</label><!-- subGroupContainText: 하위포함 -->
	</div>
	
</div>

<div id="searchUserGroupNameDialog" title="<mink:message code='mink.web.text.search.groupname'/>" class="dlgStyle">
	<table class="listTb" border="1" cellspacing="0" cellpadding="0" width="100%">
		<thead>
			<tr>
				<th class="subSearch"><mink:message code="mink.web.text.list.search"/></th>
			</tr>
		</thead>
		<tbody id="searchUserGroupNameDialogTbody">
			<tr>
				<td>
					<mink:message code="mink.web.text.navi.group"/>
				</td>
			</tr>
		</tbody>
		<tfoot id="searchUserGroupNameDialogTfoot">
			<tr>
				<td>
					<mink:message code="mink.web.text.noexist.result"/>
				</td>
			</tr>
		</tfoot>
	</table>
</div>
</div>

<script type="text/javascript">
/** 사용자그룹 등록 **/
$(function(){
	var memTp = 'UG'; // memTp: 사용자 그룹
	// 부모창
	var parentInsertOpenerBtnId = "#insertUserGroupDialogOpenerButton";
	var parentSearchUserOpenerBtnId = "#searchUserGroupTreeviewDialogOpenerButton"; // 사용자 그룹 검색
	// 서버
	var loginUserNo = "${loginUser.userNo}";
	var loginUserGrpId = "${loginUser.userGroup.grpId}";
	var loginUserAdminYn = "${loginUser.adminYn}";
	var roleGrpId = "${roleGroup.roleGrpId}"; // 권한ID
	//
	var ynYes = "${ynYes}";
	var ynNo = "${ynNo}";
	//
	// 현재창
	var treeviewUrl = "../user/userGroupListTreeview.miaps?";
	var treeviewUlId = "#searchUserGroupTreeviewUl";
	var treeviewDialogId = "#searchUserGroupTreeviewDialog";
	// 
	var searchNameUrl = "../user/userGroupListSearchName.miaps";
	var searchNameDialogId = "#searchUserGroupNameDialog";
	var searchNameOpenserBtnId = "#searchUserGroupNameDialogOpenerButton";
	var searchNameId = "#searchUserGroupName";
	//
	var selectTitleId = "#searchUserGroupTreeviewDialogTitle";
	var selectNavigationId = "#selectUserGroupNavigation";
	var selectIdId = "#selectUserGroupId";
	var selectNmId = "#selectUserGroupName";
	var selectSubAllId = "#selectUserGroupSubAll";
	//
	var mode = "";
	var insertMode = 'insert';
	var searchMode = 'search';
	
	// 권한그룹에 사용자그룹등록
	var insertUG = function() {
		var $frm = $("<form method='post' />");
		var memId = $(selectIdId).val();
		var includeSubYn = "";
		if($(selectSubAllId).get(0).checked) includeSubYn = ynYes;
		else includeSubYn = ynNo;
		var regNo = loginUserNo;
		
		$frm.append($("<input type='hidden' name='roleGrpId' />").val(roleGrpId));
		$frm.append($("<input type='hidden' name='memTp' />").val(memTp));
		//$frm.append($("<input type='hidden' name='memId' />").val(memId));
		$frm.append($("<input type='hidden' name='memIdList' />").val(memId));
		$frm.append($("<input type='hidden' name='includeSubYn' />").val(includeSubYn));
		$frm.append($("<input type='hidden' name='regNo' />").val(regNo));
		
		// 검증
		if( '${corporation}' == memId ) {
			alert("<mink:message code='mink.web.alert.select.usergroup'/>");
			return;
		}
		else if( '${unclassified}' == memId ) {
			alert("<mink:message code='mink.web.alert.select.usergroup'/>");
			return;
		}
		else if( '' == memId ) {
			alert("<mink:message code='mink.web.alert.select.usergroup'/>");
			return;
		}
		
		// 서버검증
		// ajax
		var anwser = false;
		$.ajaxSetup({async:false}); // 비동기 옵션 끄기(ajax 동기화)
		$.post('roleGroupMemberCount.miaps?', $frm.serialize(), function(data){
			if(0 < data.count) anwser = true;
		}, 'json');
		$.ajaxSetup({async:true}); // 비동기 옵션 켜기
		if(anwser) {
			alert("<mink:message code='mink.alert.already.group'/>");
			return;
		}
		//
		
		// 알림말
		var alertText = "'" + $(selectNavigationId).text() + "'" + "<mink:message code='mink.web.alert.is.registgroup'/>";
		if(!confirm(alertText)) return;
		// ajax
		$.post('roleGroupMemberInsert.miaps?', $frm.serialize(), function(data){
			resultMsg(data.msg);
			goList(); // 바로 검색
		}, 'json');
		//
	};
	
	// 그룹 검색 정보를 부모창에 세팅
	var setSearchUserGroup = function() {
		var searchUserGroupId = $(selectIdId).val(); // 검색 그룹ID
		var searchUserGroupNm = $(selectNmId).val(); // 검색 그룹NM
		var searchUserGroupNavigation = $(selectNavigationId).html(); // 검색 그룹 네비게이션
		
		var parentIdId = "#searchUserGroupId";
		var parentNavigationId = "#searchUserGroupNavigationSpan";
		
		// 부모창에 세팅
		$(parentIdId, "#searchUserDialog").val(searchUserGroupId); // 검색 그룹ID
		$("#searchUserGroupNm", "#searchUserDialog").val(searchUserGroupNm); // 검색 그룹NM
		$(parentNavigationId, "#searchUserDialog").html(defenceXSS(searchUserGroupNavigation)); // 검색 그룹 네비게이션
		
		// 하위포함여부 체크시, 부모창에도 체크
		if(searchUserGroupId == '${unclassified}' || searchUserGroupId == '${corporation}') {
			$("#selectUserGroupSubAll").get(0).checked = false;
		}
		if($("#selectUserGroupSubAll").get(0).checked) {
			$("#searchUserGroupSubAllChekbox").get(0).checked = true;
		}
		
		$( treeviewDialogId ).dialog( "close" );
	};
	
	// 그룹명 검색 선택 후 그룹 조직도 다이얼로그로 돌아가기
	var setSelectUserGroup = function(event) {
		$(selectIdId).val(event.data.userGroup.grpId); // 선택 그룹ID
		$(selectNmId).val(event.data.userGroup.grpNm); // 선택 그룹명
		$(selectNavigationId).html(defenceXSS(event.data.userGroup.grpNavigation)); // 선택 그룹 네비게이션
		
		$( searchNameDialogId ).dialog( "close" ); // 그룹명 검색 다이얼로그 닫기
		
		reloadTreeview($(selectIdId).val()); // 트리 다시 불러오기
	};
	
	// 그룹없음
	$("#selectUserGroupUnclassifiedAlink").bind("click", function(){
		$(selectIdId).val("${unclassified}"); // 그룹ID
		$(selectNmId).val("${unclassifiedName}"); // 그룹명
		$(selectNavigationId).html("${unclassifiedName}"); // 그룹 네비게이션
		
		$("a", "#ugTwdgDiv").css("background", "#FFFFFF");
		$(this).css("background", "#FFD700"); // check 된 css 적용
	});
	
	// 권한그룹 사용자그룹등록 조직도 다이얼로그 팝업 나타나기
	var showSearchUserGroupTreeviewDialog = function(event) {
		// root 선택불가
		$("#selectUserGroupRootSpan").html("${corporationName}");
		// 그룹없음 노드 숨기기
		$("#selectUserGroupUnclassifiedLi").hide();
		// 하위포함여부 체크풀기
		$("#selectUserGroupSubAll").get(0).checked = false;
		
		if(parentInsertOpenerBtnId == "#"+$(event.target).attr("id")) {
			$(selectTitleId).html("<mink:message code='mink.web.text.permissionmember_registusergroup'/>");
			mode = insertMode;
			
			$(selectNavigationId).html("${loginUser.adminYn == ynYes ? corporationName : loginUser.userGroup.grpNavigation}");
			$(selectIdId).val("${loginUser.adminYn == ynYes ? corporation : loginUser.userGroup.grpId}");
			$(selectNmId).val("${loginUser.adminYn == ynYes ? corporationName : loginUser.userGroup.grpNm}");
		}
		else if(parentSearchUserOpenerBtnId == "#"+$(event.target).attr("id")) {
			$(selectTitleId).text("<mink:message code='mink.web.text.search.usergroup'/>");
			mode = searchMode;
			
			$(selectNavigationId).html($("#searchUserGroupNavigationSpan").html());
			$(selectIdId).val($("#searchUserGroupId").val());
			$(selectNmId).val($("#searchUserGroupNm").val());
			
			var $clickRoot = $("<a id='selectUserGroupRootAlink' href='javascript:return false;'>${corporationName}</a>").bind("click", function(e){
				$(selectNavigationId).html("${corporationName}");
				$(selectIdId).val("${corporation}");
				$(selectNmId).val("${corporationName}");
				
				$("a", "#ugTwdgDiv").css("background", "#FFFFFF");
				$(e.target).css("background", "#FFD700"); // check 된 css 적용
			});
			// root 선택가능
			if( eval('${loginUser.adminYn == ynYes}') ) $("#selectUserGroupRootSpan").html($clickRoot);
			// 그룹없음 노드 보이기
			$("#selectUserGroupUnclassifiedLi").show();
			// 부모창에 하위포함여부가 체크되었다면 함께 체크
			if($("#searchUserGroupSubAllChekbox").get(0).checked) $("#selectUserGroupSubAll").get(0).checked = true;
		}
		
		$( treeviewDialogId ).dialog( "open" ); // 사용자그룹등록 조직도 다이얼로그 팝업 나타나기
	};
	
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
						var $td = $("<td style='float: left;' />").html(defenceXSS(data.searchUserGroupList[i].grpNavigation));
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
	var clickNode = function(event){
		var selectUserGroupId = $(event.target).data("grp").grpId;
		var selectUserGroupName = $(event.target).data("grp").grpNm;
		var searchUserGroupNavigation = $(event.target).data("grp").grpNavigation; // 그룹 네비게이션
		
		$(selectIdId).val(selectUserGroupId); // 그룹ID
		$(selectNmId).val(selectUserGroupName); // 그룹명
		$(selectNavigationId).html(defenceXSS(searchUserGroupNavigation)); // 그룹 네비게이션
		
		$("a", "#ugTwdgDiv").css("background", "#FFFFFF");
		$(event.target).css("background", "#FFD700"); // check 된 css 적용
	};
	
	// 트리 다시 불러오기
	function reloadTreeview(grpId) {
		if("${corporation}" == grpId || "${unclassified}" == grpId) grpId = "";
		
		var $parent = $(treeviewUlId).parent("li");
		$(treeviewUlId).remove(); // 트리 삭제
		$parent.append("<ul id='" + treeviewUlId.substring(1) + "' class='treeview'></ul>"); // 트리 ul 추가
		
		var url = treeviewUrl;
		if("" != grpId) url = "../user/userGroupListTreeviewSelectedNode.miaps?grpId="+grpId; // 선택한 트리만 열기
		
		treeviewAlink(url, treeviewUlId, clickNode); // ajax treeview
	}
	
	// 그룹 검색 조직도 다이얼로그
	$( treeviewDialogId ).dialog({
		autoOpen: false
		, modal: true
		, maxHeight: 700
		, buttons: {
			"<mink:message code='mink.web.text.select'/>": function() {
				if(insertMode == mode) {
					insertUG(); // 권한그룹에 사용자그룹등록
				}
				else if(searchMode == mode) {
					setSearchUserGroup(); // 그룹 검색 정보를 부모창에 세팅
				}
            }
			, "<mink:message code='mink.web.text.cancel'/>": function() {
				$( this ).dialog( "close" );
            }
		}
		, open: function( event, ui ) {
			reloadTreeview($(selectIdId).val()); // 트리 다시 불러오기
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
	
	//그룹 구성원 등록/수정 조직도 다이얼로그 팝업 나타나기
	$(parentInsertOpenerBtnId).bind("click", showSearchUserGroupTreeviewDialog); //그룹 구성원 등록
	$(parentSearchUserOpenerBtnId).bind("click", showSearchUserGroupTreeviewDialog); // 사용자 그룹검색
	
	//그룹명 검색 다이얼로그 팝업 나타나기
	$(searchNameOpenserBtnId).bind("click", showSearchUserGroupNameDialog);

	treeviewAlink(treeviewUrl, treeviewUlId, clickNode); // ajax treeview
	//$.post(treeviewUrl, {root: 'source'}, function(data){ alert(data); });
});

</script>