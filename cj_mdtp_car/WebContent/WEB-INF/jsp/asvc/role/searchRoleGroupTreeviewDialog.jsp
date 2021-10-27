<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page session="false"%>

<!-- 상위 권한 그룹 수정 treeview dialog -->
<div>
<div id="searchRoleGroupTreeviewDialog" title="<mink:message code='mink.web.text.info.permission'/>" class="dlgStyle">
	
	<div>
		<mink:message code="mink.web.text.permissionname"/>
		<input type="text" id="searchRoleGroupName" class="width50" />
		<span><button id="searchRoleGroupNameDialogOpenerButton" class='btn-dash'><mink:message code="mink.web.text.search"/></button></span>
	</div>
	
	<div id="rgTwdgDiv">
		<ul class="twNodeStyle">
			<li class="outerBulletStyle">
				<a id="searchRoleGroupClickRoot" href="#">root</a>
				<ul id="searchRoleGroupTreeviewUl" class="treeview"></ul>
			</li>
		</ul>
	</div>
	
	<hr style="height:1;">
	
	<div class="dialogTitle"><mink:message code="mink.web.text.modify.upperpermission"/></div>
	
	<div class="hiddenHrDivSmall"></div>
	
	<div id="selectRoleGroupNavigation">
		root
	</div>
	<!-- 
	<div class="hiddenHrDivSmall"></div>
	 -->
	<div>
		<input type="hidden" id="selectRoleGroupId" />
		<input type="hidden" id="selectRoleGroupName" value="root" />
	</div>
	
</div>

<div id="searchRoleGroupNameDialog" title="<mink:message code='mink.web.text.search.permissionname'/>" class="dlgStyle">
	<table class="listTb" border="1" cellspacing="0" cellpadding="0" width="100%">
		<thead>
			<tr>
				<th class="subSearch"><mink:message code="mink.web.text.list.search"/></th>
			</tr>
		</thead>
		<tbody id="searchRoleGroupNameDialogTbody">
			<tr>
				<td>
					<mink:message code="mink.web.text.navi.permissiongroup"/>
				</td>
			</tr>
		</tbody>
		<tfoot id="searchRoleGroupNameDialogTfoot">
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
/** 상위권한수정 **/
$(function(){
	// 부모창
	var parentUpdateUpGrpOpenerBtnId = "#editRoleGroupUpGrpSearchRoleGroupTreeviewDialogOpenerButtonUpdate";
	// 서버
	var loginUserUserNo = "${loginUser.userNo}";
	//
	// 현재창
	/** URL **/
	var treeviewUrl = "roleGroupListTreeview.miaps?";
	var searchNameUrl = "roleGroupNameSearch.miaps?";
	/***/
	var treeviewUlId = "#searchRoleGroupTreeviewUl";
	var treeviewDialogId = "#searchRoleGroupTreeviewDialog";
	// 
	var searchNameDialogId = "#searchRoleGroupNameDialog";
	var searchNameOpenserBtnId = "#searchRoleGroupNameDialogOpenerButton";
	var searchNameId = "#searchRoleGroupName";
	//
	var selectNavigationId = "#selectRoleGroupNavigation";
	var selectIdId = "#selectRoleGroupId";
	var selectNmId = "#selectRoleGroupName";
	
	// root 선택
	$("#searchRoleGroupClickRoot").bind("click", function(){
		$(selectNavigationId).html("${corporationName}");
		$(selectIdId).val("${corporation}");
		$(selectNmId).val("root");
		
		$("a", "#rgTwdgDiv").css("background", "#FFFFFF");
		$(this).css("background", "#FFD700"); // check 된 css 적용
	});
	
	// 상위권한그룹수정
	var updateUpGrpRoleGroup = function() {
		var roleGrpId = "${roleGroup.roleGrpId}";
		var upRoleGrpId = $(selectIdId).val(); // 검색 그룹ID
		var updNo = loginUserUserNo;
		
		// 선택 그룹ID와 부모창 그룹ID를 포함한 하위그룹ID 를 비교해서, 같은 ID가 있으면 검증실패(상위그룹이 될 수 없음)
		var answer = false;
		$.ajaxSetup({async:false}); // 비동기 옵션 끄기(ajax 동기화)
		$.post('roleGroupContainParentFindChildren.miaps?', { roleGrpId: roleGrpId }, function(data){
			if(0 < data.roleGroupList.length) {
				for(var j = 0; j < data.roleGroupList.length; j++) {
					if(upRoleGrpId == data.roleGroupList[j].roleGrpId) {
						answer = true;
						alert("<mink:message code='mink.alert.access.fail1'/>" + "\n" + "<mink:message code='mink.alert.access.fail2'/>");
						break;
					}
				}
			}
		}, 'json');
		$.ajaxSetup({async:true}); // 비동기 옵션 켜기
		
		if(answer) return;
		
		// 선택창
		if(!confirm("<mink:message code='mink.web.alert.is.modify'/>")) return;
		$.post('roleGroupUpdateUpGrpId.miaps?', {roleGrpId: roleGrpId, upRoleGrpId: upRoleGrpId, updNo: updNo}, function(data){
			resultMsg(data.msg);
			goList(); // 목록/검색
		}, 'json');
	};
	
	// 권한그룹명 검색 선택 후 그룹 조직도 다이얼로그로 돌아가기
	var setSelectRoleGroup = function(event) {
		searchRoleGroupNavigation = event.data.roleGroup.grpNavigation; // 최상위 권한그룹명을 네비게이션에 추가
		
		$(selectIdId).val(event.data.roleGroup.roleGrpId); // 선택 그룹ID
		$(selectNmId).val(event.data.roleGroup.roleGrpNm); // 선택 권한그룹명
		$(selectNavigationId).html(defenceXSS(searchRoleGroupNavigation)); // 선택 그룹 네비게이션
		
		$( searchNameDialogId ).dialog( "close" ); // 그룹명 검색 다이얼로그 닫기
		
		reloadTreeview($(selectIdId).val()); // 트리 다시 불러오기
	};
	
	// 상위권한그룹수정 조직도 다이얼로그 팝업 나타나기
	var showSearchRoleGroupTreeviewDialog = function(event) {
		$(selectNavigationId).html("<c:out value='${roleGroup.grpNavigation}'/>");
		$(selectIdId).val("${roleGroup.roleGrpId}");
		$(selectNmId).val("<c:out value='${roleGroup.roleGrpNm}'/>");
		
		$( treeviewDialogId ).dialog( "open" ); // 권한그룹등록 조직도 다이얼로그 팝업 나타나기
	};
	
	// 권한그룹명 검색 다이얼로그 팝업 나타나기
	var showSearchRoleGroupNameDialog = function() {
		var selectRoleGroupName = $(searchNameId).val();
		
		if('' != selectRoleGroupName) {
			$.post(searchNameUrl, {roleGrpNm: selectRoleGroupName}, function(data){
				if(0 < data.roleGroupList.length) {
					$(searchNameDialogId+"Tbody").html("");
					for(var i = 0; i < data.roleGroupList.length; i++) {
						searchRoleGroupNavigation = data.roleGroupList[i].grpNavigation; // 최상위 권한그룹명을 네비게이션에 추가
						var $td = $("<td style='float: left;' />").html(defenceXSS(searchRoleGroupNavigation));
						var $tr = $("<tr />").bind("click", {roleGroup: data.roleGroupList[i]}, setSelectRoleGroup);
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
				
				$( searchNameDialogId ).dialog( "open" ); // 권한그룹명 검색 다이얼로그 팝업 나타나기
			}, 'json');
		}
	};
	
	//노드 선택 이벤트
	var clickNode = function(event){
		var selectRoleGroupId = $(event.target).data("grp").grpId;
		var selectRoleGroupName = $(event.target).data("grp").grpNm;
		var selectRoleGroupNavigation = $(event.target).data("grp").grpNavigation; // 권한그룹 네비게이션
		
		$(selectIdId).val(selectRoleGroupId); // 그룹ID
		$(selectNmId).val(selectRoleGroupName); // 권한그룹명
		$(selectNavigationId).html(defenceXSS(selectRoleGroupNavigation)); // 권한그룹 네비게이션
		
		$("a", "#rgTwdgDiv").css("background", "#FFFFFF");
		$(event.target).css("background", "#FFD700"); // check 된 css 적용
	};

	// 트리 다시 불러오기
	function reloadTreeview(roleGrpId) {
		if("root" == roleGrpId) roleGrpId = "";
		
		var $parent = $(treeviewUlId).parent("li");
		$(treeviewUlId).remove(); // 트리 삭제
		$parent.append("<ul id='" + treeviewUlId.substring(1) + "' class='treeview'></ul>"); // 트리 ul 추가
		
		var url = treeviewUrl;
		if("" != roleGrpId) url = "roleGroupListTreeviewSelectedNode.miaps?roleGrpId="+roleGrpId; // 선택한 트리만 열기
		
		treeviewAlink(url, treeviewUlId, clickNode); // ajax treeview
	}
	
	// 권한그룹 검색 조직도 다이얼로그
	$( treeviewDialogId ).dialog({
		autoOpen: false
		, modal: true
		, maxHeight: 700
		, buttons: {
			"<mink:message code='mink.web.text.select'/>": function() {
				updateUpGrpRoleGroup(); // 상위권한그룹수정
            }
			, "<mink:message code='mink.web.text.cancel'/>": function() {
				$( this ).dialog( "close" );
            }
		}
		, open: function( event, ui ) {
			reloadTreeview($(selectIdId).val()); // 트리 다시 불러오기
		}
	});
	
	// 권한그룹명 검색 다이얼로그 팝업
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
	
	// 권한그룹명 엔터 검색
	$(searchNameId).on("keypress", function(e){
		if (e.which == 13) {
			showSearchRoleGroupNameDialog();
			return false;
		}
	});
	
	// 상위권한그룹 수정 조직도 다이얼로그 팝업 나타나기
	$(parentUpdateUpGrpOpenerBtnId).bind("click", showSearchRoleGroupTreeviewDialog); //권한그룹 구성원 등록
	
	// 권한그룹명 검색 다이얼로그 팝업 나타나기
	$(searchNameOpenserBtnId).bind("click", showSearchRoleGroupNameDialog);

	treeviewAlink(treeviewUrl, treeviewUlId, clickNode); // ajax treeview
	//$.post(treeviewUrl, {root: 'source'}, function(data){ alert(data); });
});

</script>