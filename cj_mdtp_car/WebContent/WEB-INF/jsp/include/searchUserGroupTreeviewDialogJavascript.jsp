<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page session="false"%>
<script type="text/javascript">
// 그룹검색 treeview dialog javascript
function actionSearchUserGroup() {
	// 부모창
	var parentIdId = "#searchUserGroupId";
	var parentNavigationId = "#searchUserGroupNavigationSpan";
	var parentSubAllId = "#searchUserGroupSubAllChekbox";
	var parentOpenerBtnId = "#searchUserGroupTreeviewDialogOpenerButton";
	// 서버
	var loginUserGrpId = "${loginUser.userGroup.grpId}";
	var loginUserAdminYn = "${loginUser.adminYn}";
	//
	var corporation = "${corporation}";
	var corporationName = "${corporationName}";
	var unclassified = "${unclassified}";
	var unclassifiedName = "${unclassifiedName}";
	// 팝업창
	var treeviewUrl = "../user/userGroupListTreeview.miaps?";
	var treeviewUlId = "#searchUserGroupTreeviewUl";
	var treeviewDialogId = "#searchUserGroupTreeviewDialog";
	//
	var searchNameUrl = "../user/userGroupListSearchName.miaps";
	var searchNameDialogId = "#searchUserGroupNameDialog";
	var searchNameOpenserBtnId = "#searchUserGroupNameDialogOpenerButton";
	var searchNameId = "#searchUserGroupName";
	var searchCorporationId = "#searchUserGroupCorporation";
	var searchUnclassifiedId = "#searchUserGroupUnclassified";
	//
	var selectNavigationId = "#selectUserGroupNavigation";
	var selectIdId = "#selectUserGroupId";
	var selectNmId = "#selectUserGroupName";
	var selectLevelId = "#selectUserGroupLevel";
	var selectSubAllId = "#selectUserGroupSubAll";
	//
	// 그룹 검색 정보를 부모창에 세팅
	var setSearchUserGroup = function() {
		var searchUserGroupId = $(selectIdId).val(); // 검색 그룹ID
		var searchUserGroupNavigation = $(selectNavigationId).html(); // 검색 그룹 네비게이션
		if($(selectSubAllId).get(0).checked) {
			// 그룹없음인 경우 하위검색 체크풀기
			if($(selectIdId).val() == unclassified) {
				$(selectSubAllId).get(0).checked = false; // 하위검색 체크풀기
			}
			// 전체검색인 경우 하위검색 체크풀기
			else if($(selectIdId).val() == corporation) {
				$(selectSubAllId).get(0).checked = false; // 하위검색 체크풀기
			}
		}
		
		// 부모창에 세팅
		$(parentIdId).val(searchUserGroupId); // 검색 그룹ID
		$(parentNavigationId).html(searchUserGroupNavigation); // 검색 그룹 네비게이션
		if($(selectSubAllId).get(0).checked) {
			$(parentSubAllId).get(0).checked = true; // 하위검색 체크하기
		}
		else {
			$(parentSubAllId).get(0).checked = false; // 하위검색 체크풀기
		}
		
		$( treeviewDialogId ).dialog( "close" );
	};
	
	// 그룹명 검색 선택 후 그룹 조직도 다이얼로그로 돌아가기
	var setSelectUserGroup = function(event) {
		$(selectIdId).val(event.data.userGroup.grpId); // 선택 그룹ID
		$(selectLevelId).val(event.data.userGroup.grpLevel); // 선택 그룹Level
		$(selectNmId).val(event.data.userGroup.grpNm); // 선택 그룹명
		$(selectNavigationId).html(event.data.userGroup.grpNavigation); // 선택 그룹 네비게이션
		
		$( searchNameDialogId ).dialog( "close" ); // 그룹명 검색 다이얼로그 닫기
		
		reloadTreeview($(selectIdId).val()); // 트리 다시 불러오기
	};
	
	// 회사노드 선택(전체검색)
	var setSelectUserGroupCorporation = function() {
		$(selectIdId).val(corporation); // 전체검색 회사ID
		$(selectNmId).val(corporationName); // 회사명
		$(selectNavigationId).html(corporationName); // 회사 그룹 네비게이션
		
		$("a", "#schUgTwdgDiv").css("background", "#FFFFFF");
		$(searchCorporationId).css("background", "#FFD700"); // check 된 css 적용
	};
	
	// 그룹없음노드 선택
	var setSelectUserGroupUnclassified = function() {
		$(selectIdId).val(unclassified); // 그룹없음ID
		$(selectNmId).val(unclassifiedName); // 그룹없음명
		$(selectNavigationId).html(unclassifiedName); // 그룹 네비게이션
		
		$("a", "#schUgTwdgDiv").css("background", "#FFFFFF");
		$(searchUnclassifiedId).css("background", "#FFD700"); // check 된 css 적용
	};
	
	//노드 선택 이벤트
	var clickNode = function(event){
		var selectUserGroupId = $(event.target).data("grp").grpId;
		var selectUserGroupName = $(event.target).data("grp").grpNm;
		var selectUserGroupLevel = $(event.target).data("grp").grpLevel;
		var searchUserGroupNavigation = $(event.target).data("grp").grpNavigation; // 그룹 네비게이션
		
		$(selectIdId).val(selectUserGroupId); // 그룹ID
		$(selectNmId).val(selectUserGroupName); // 그룹명
		$(selectLevelId).val(selectUserGroupLevel); // 그룹Level
		$(selectNavigationId).html(searchUserGroupNavigation); // 그룹 네비게이션
		
		$("a", "#schUgTwdgDiv").css("background", "#FFFFFF");
		$(event.target).css("background", "#FFD700"); // check 된 css 적용
	};

	// 그룹 검색 조직도 다이얼로그 팝업 나타나기
	var showSearchUserGroupTreeviewDialog = function() {
		$(selectIdId).val( $("#selectUserGroupId").val() ); // 그룹ID
		$(selectNmId).val( $("#selectUserGroupName").val() ); // 그룹명
		$(selectLevelId).val( $("#selectUserGroupLevel").val() ); // 그룹Level
		$(selectNavigationId).html( $("#selectUserGroupNavigation").html() ); // 그룹 네비게이션
		
		// 부모창 하위포함 체크박스 여부
		if($(parentSubAllId).get(0).checked) {
			$(selectSubAllId).get(0).checked = true; // 현재창 하위검색 체크하기
		}
		else {
			$(selectSubAllId).get(0).checked = false; // 현재창 하위검색 체크풀기
		}
		
		$( treeviewDialogId ).dialog( "open" ); // 그룹 검색 조직도 다이얼로그 팝업 나타나기
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
			"<mink:message code='mink.web.text.ok'/>": function() {
				setSearchUserGroup(); // 그룹 검색 정보를 부모창에 세팅
            }
			, "<mink:message code='mink.label.cancel'/>": function() {
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
	$(searchNameId).on("keypress", function(event){
		if (event.which == 13) {
			showSearchUserGroupNameDialog();
			return false;
		}
	});
	
	// 회사노드 선택(전체검색)
	$(searchCorporationId).bind("click", setSelectUserGroupCorporation);
	
	// 그룹없음노드 선택
	$(searchUnclassifiedId).bind("click", setSelectUserGroupUnclassified);
	
	//그룹 검색 조직도 다이얼로그 팝업 나타나기
	$(parentOpenerBtnId).bind("click", showSearchUserGroupTreeviewDialog);
	
	//그룹명 검색 다이얼로그 팝업 나타나기
	$(searchNameOpenserBtnId).bind("click", showSearchUserGroupNameDialog);
	
	treeviewAlink(treeviewUrl, treeviewUlId, clickNode); // ajax treeview
	//$.post(treeviewUrl, {root: 'source'}, function(data){ alert(data); });
}

// 트리 완료 후 선택 node 체크 표시
function completeTreeview(treeview) {
	if( 'searchUserGroupTreeviewUl' == $(treeview, "ul").eq(0).attr("id") ) {
		$("a", "#schUgTwdgDiv").css("background", "#FFFFFF");
		if("${corporation}" == $("#selectUserGroupId").val()) $("#searchUserGroupCorporation").css("background", "#FFD700"); // check 된 css 적용
		else if("${unclassified}" == $("#selectUserGroupId").val() || '' == $("#selectUserGroupId").val()) $("#searchUserGroupUnclassified").css("background", "#FFD700"); // check 된 css 적용
		else {
			$("a", treeview).each(function(idx, a){
				if( $("#selectUserGroupId").val() == $(a).data("grp").grpId ) {
					$(a).css("background", "#FFD700"); // check 된 css 적용
				}
			});
		}
	}
}
</script>