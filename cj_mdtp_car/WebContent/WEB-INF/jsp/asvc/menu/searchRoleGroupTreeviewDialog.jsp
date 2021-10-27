<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page session="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="mink" uri="/WEB-INF/tld/mink.tld" %>

<!-- 메뉴 구성원인 권한 그룹 등록 treeview dialog -->
<div id="searchRoleGroupTreeviewDialog" title="<mink:message code='mink.web.text.info.permission'/>"  class="dlgStyle">
<div class="miaps-popup-top-buttons">
	&nbsp;
	<span><button id="searchRoleGroupTreeviewSelectedButton" class='btn-dash'><mink:message code="mink.web.text.save"/></button></span>
	<span><button class='btn-dash' onclick="javascript:$('#searchRoleGroupTreeviewDialog').dialog('close');"><mink:message code="mink.web.text.cancel"/></button></span>
</div>		
	<div style="border-bottom: 1px solid #dedede; padding-bottom: 10px;">
		<mink:message code="mink.web.text.permissionname"/>
		<input type="text" id="searchRoleGroupName" class="width50" />
		<span><button id="searchRoleGroupNameDialogOpenerButton" class='btn-dash'><mink:message code="mink.web.text.search"/></button></span>
	</div>
	
	<div id="rgTwdgDiv">
		<ul class="twNodeStyle">
			<li class="outerBulletStyle">
				<span>root</span>
				<ul id="searchRoleGroupTreeviewUl" class="treeview"></ul>
			</li>
		</ul>
	</div>
	
	<hr style="height:1;">
	
	<div class="dialogTitle"><mink:message code="mink.web.text.regist.menumember.permissiongroup"/></div>
	
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
	<!-- 
	<div class="hiddenHrDivSmall"></div>
	 -->
	<div style="display: none;">
		<label><input type="checkbox" id="selectRoleGroupSubAll" value="${ynYes}" />${subGroupContainText}</label><!-- subGroupContainText: 하위포함 -->
	</div>
	
</div>

<div id="searchRoleGroupNameDialog" title="<mink:message code='mink.web.text.search.permissionname'/>" class="dlgStyle">
<div class="miaps-popup-top-buttons">
	&nbsp;
	<span><button id="searchRoleGroupNameCancelButton" class='btn-dash'><mink:message code="mink.web.text.cancel"/></button></span>
</div>	
	<table class="listTb" border="0" cellspacing="0" cellpadding="0" width="100%">
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
					<mink:message code="mink.text.noexist.result"/>
				</td>
			</tr>
		</tfoot>
	</table>
</div>

<script type="text/javascript">
/** 메뉴 등록 **/
$(function(){
	var roleTp = 'RG'; // roleTp: 권한 그룹
	// 부모창
	var parentInsertOpenerBtnId = "#insertRoleGroupDialogOpenerButton";
	// 서버
	var loginUserNo = "${loginUser.userNo}";
	var menuId = "${menu.menuId}"; // 메뉴ID
	var packageNm = "${menu.packageNm}"; // 앱패키지명
	//
	var ynYes = "${ynYes}";
	var ynNo = "${ynNo}";
	//
	// 현재창
	/** URL **/
	var treeviewUrl = "../role/roleGroupListTreeview.miaps?";
	var searchNameUrl = "../role/roleGroupNameSearch.miaps?";
	var vaildationCountUrl = "menuRole${mode}Count.miaps?";
	var insertMenuRoleUrl = "menuRole${mode}Insert.miaps?";
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
	var selectSubAllId = "#selectRoleGroupSubAll";
	
	// 메뉴에 권한그룹등록
	var insertRG = function() {
		var $frm = $("<form method='post' />");
		var roleId = $(selectIdId).val();
		var includeSubYn = "";
		if($(selectSubAllId).get(0).checked) includeSubYn = ynYes;
		else includeSubYn = ynNo;
		var regNo = loginUserNo;
		
		$frm.append($("<input type='hidden' name='menuId' />").val(menuId));
		$frm.append($("<input type='hidden' name='roleTp' />").val(roleTp));
		//$frm.append($("<input type='hidden' name='roleId' />").val(roleId));
		$frm.append($("<input type='hidden' name='roleIdList' />").val(roleId));
		$frm.append($("<input type='hidden' name='includeSubYn' />").val(includeSubYn));
		$frm.append($("<input type='hidden' name='regNo' />").val(regNo));
		
		// 검증
		if('' == roleId || 'root' == roleId) {
			alert("<mink:message code='mink.web.alert.select.permissiongroup'/>");
			return;
		}
		
		// 서버검증
		// ajax
		var anwser = false;
		$.ajaxSetup({async:false}); // 비동기 옵션 끄기(ajax 동기화)
		$.post(vaildationCountUrl, $frm.serialize(), function(data){
			if(0 < data.count) anwser = true;
		}, 'json');
		$.ajaxSetup({async:true}); // 비동기 옵션 켜기
		if(anwser) {
			alert("<mink:message code='mink.alert.already.permissiongroup'/>");
			return;
		}
		//
		
		// 알림말
		var alertText = "'" + $(selectNavigationId).text() + "'" + " <mink:message code='mink.web.alert.is.regist.permission'/>";
		if(!confirm(alertText)) return;
		// ajax
		$.post(insertMenuRoleUrl, $frm.serialize(), function(data){
			resultMsg(data.msg);
			
			//goDetail(packageNm); // 바로 검색
			goList();
		}, 'json');
		//
	};
	
	// 권한그룹명 검색 선택 후 그룹 조직도 다이얼로그로 돌아가기
	var setSelectRoleGroup = function(event) {
		searchRoleGroupNavigation = event.data.roleGroup.grpNavigation; // 최상위 권한그룹명을 네비게이션에 추가
		
		$(selectIdId).val(event.data.roleGroup.roleGrpId); // 선택 그룹ID
		$(selectNmId).val(event.data.roleGroup.roleGrpNm); // 선택 권한그룹명
		$(selectNavigationId).html(searchRoleGroupNavigation); // 선택 그룹 네비게이션
		
		$( searchNameDialogId ).dialog( "close" ); // 권한그룹명 검색 다이얼로그 닫기
		
		reloadTreeview($(selectIdId).val()); // 트리 다시 불러오기
	};
	
	// 메뉴 권한그룹등록 조직도 다이얼로그 팝업 나타나기
	var showSearchRoleGroupTreeviewDialog = function(event) {
		$(selectNavigationId).html("root");
		$(selectIdId).val("root");
		$(selectNmId).val("root");
		
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
						var $td = $("<td style='float: left;' />").html(searchRoleGroupNavigation);
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
		$(selectNavigationId).html(selectRoleGroupNavigation); // 권한그룹 네비게이션
		
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
		if("" != roleGrpId) url = "../role/roleGroupListTreeviewSelectedNode.miaps?roleGrpId="+roleGrpId; // 선택한 트리만 열기
		
		treeviewAlink(url, treeviewUlId, clickNode); // ajax treeview
	}
	
	var cancelSearchNameDlg = function() {
		$("#searchRoleGroupNameDialog").dialog( "close" );
		$( treeviewDialogId ).find(":input:visible").first().focus();
	};
	
	// 권한그룹 검색 조직도 다이얼로그
	$( treeviewDialogId ).dialog({
		autoOpen: false
		, modal: true
		, maxHeight: 700
		/*, buttons: {
			"선택": function() {
				insertRG(); // 메뉴에 권한그룹등록
            }
			, "취소": function() {
				$( this ).dialog( "close" );
            }
		}*/
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
		/*, buttons: {
			"취소": function() {
				$( this ).dialog( "close" );
				$( treeviewDialogId ).find(":input:visible").first().focus();
            }
		}*/
	});

	// 권한그룹명 엔터 검색
	$(searchNameId).on("keypress", function(e){
		if (e.which == 13) {
			showSearchRoleGroupNameDialog();
			return false;
		}
	});
	
	//권한그룹 구성원 등록/수정 조직도 다이얼로그 팝업 나타나기
	$(parentInsertOpenerBtnId).bind("click", showSearchRoleGroupTreeviewDialog); //권한그룹 구성원 등록
	
	//권한그룹명 검색 다이얼로그 팝업 나타나기
	$(searchNameOpenserBtnId).bind("click", showSearchRoleGroupNameDialog);

	treeviewAlink(treeviewUrl, treeviewUlId, clickNode); // ajax treeview
	//$.post(treeviewUrl, {root: 'source'}, function(data){ alert(data); });
	
	$("#searchRoleGroupTreeviewSelectedButton").bind("click", insertRG);
	$("#searchRoleGroupNameCancelButton").bind("click", cancelSearchNameDlg);
});

</script>