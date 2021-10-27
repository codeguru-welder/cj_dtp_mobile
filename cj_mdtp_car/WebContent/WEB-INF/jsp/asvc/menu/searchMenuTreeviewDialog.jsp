<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page session="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="mink" uri="/WEB-INF/tld/mink.tld" %>

<!-- 상위 메뉴 수정 treeview dialog -->
<div>
<div id="searchMenuTreeviewDialog" title="<mink:message code='mink.web.text.info.menu'/>" class="dlgStyle">
	
	<div>
		<mink:message code="mink.web.text.menuname"/>
		<input type="text" id="searchMenuName" class="width50" />
		<span><button id="searchMenuNameDialogOpenerButton" class='btn-dash'><mink:message code="mink.web.text.search"/></button></span>
	</div>
	
	<div id="mnTwdgDiv">
		<ul class="twNodeStyle">
			<li class="outerBulletStyle">
				<a id="searchMenuClickRoot" href="#">root</a>
				<ul id="searchMenuTreeviewUl" class="treeview"></ul>
			</li>
		</ul>
	</div>
	
	<hr style="height:1;">
	
	<div class="dialogTitle"><mink:message code="mink.web.text.modify.uppermenu"/></div>
	
	<div class="hiddenHrDivSmall"></div>
	
	<div id="selectMenuNavigation">
		root
	</div>
	<!-- 
	<div class="hiddenHrDivSmall"></div>
	 -->
	<div>
		<input type="hidden" id="selectMenuId" />
		<input type="hidden" id="selectMenuName" value="root" />
	</div>
	
</div>

<div id="searchMenuNameDialog" title="<mink:message code='mink.web.text.search.menuname'/>"  class="dlgStyle">
	<table class="listTb" border="1" cellspacing="0" cellpadding="0" width="100%">
		<thead>
			<tr>
				<th class="subSearch"><mink:message code="mink.web.text.list.search"/></th>
			</tr>
		</thead>
		<tbody id="searchMenuNameDialogTbody">
			<tr>
				<td>
					<mink:message code="mink.web.text.navi.menu"/>
				</td>
			</tr>
		</tbody>
		<tfoot id="searchMenuNameDialogTfoot">
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
/** 상위메뉴수정 **/
$(function(){
	// 부모창
	var parentUpdateUpGrpOpenerBtnId = "#editMenuUpGrpSearchMenuTreeviewDialogOpenerButtonUpdate";
	var mode = $(":hidden[name='mode']", "#searchFrm").val();
	// 서버
	var loginUserUserNo = "${loginUser.userNo}";
	//
	// 현재창
	/** URL **/
	var treeviewUrl = "menuAdminListTreeview.miaps?";
	var searchNameUrl = "menuNameSearch.miaps?";
	var selectedTwUrl = "menuAdminListTreeviewSelectedNode.miaps?";
	if("app" == mode) {
		treeviewUrl = "menuAppListTreeview.miaps?packageNm=${searchPackageNm}";
		searchNameUrl = "menuNameSearch.miaps?packageNm=${searchPackageNm}";
		selectedTwUrl = "menuAppListTreeviewSelectedNode.miaps?packageNm=${searchPackageNm}&";
	}
	/***/
	var treeviewUlId = "#searchMenuTreeviewUl";
	var treeviewDialogId = "#searchMenuTreeviewDialog";
	// 
	var searchNameDialogId = "#searchMenuNameDialog";
	var searchNameOpenserBtnId = "#searchMenuNameDialogOpenerButton";
	var searchNameId = "#searchMenuName";
	//
	var selectNavigationId = "#selectMenuNavigation";
	var selectIdId = "#selectMenuId";
	var selectNmId = "#selectMenuName";
	
	// root 선택
	$("#searchMenuClickRoot").bind("click", function(){
		$(selectNavigationId).html("${corporationName}");
		$(selectIdId).val("${corporation}");
		$(selectNmId).val("root");
		
		$("a", "#mnTwdgDiv").css("background", "#FFFFFF");
		$(this).css("background", "#FFD700"); // check 된 css 적용
	});
	
	// 상위메뉴그룹수정
	var updateUpGrpMenu = function() {
		var menuId = "${menu.menuId}";
		var upMenuId = $(selectIdId).val(); // 검색 그룹ID
		var updNo = loginUserUserNo;
		var packageNm = "${searchPackageNm}";
		
		// 선택 그룹ID와 부모창 그룹ID를 포함한 하위그룹ID 를 비교해서, 같은 ID가 있으면 검증실패(상위그룹이 될 수 없음)
		var answer = false;
		$.ajaxSetup({async:false}); // 비동기 옵션 끄기(ajax 동기화)
		$.post('menuContainParentFindChildren.miaps?', { menuId: menuId, mode: mode }, function(data){
			if(0 < data.menuList.length) {
				for(var j = 0; j < data.menuList.length; j++) {
					if(upMenuId == data.menuList[j].menuId) {
						answer = true;
						alert("<mink:message code='mink.web.message20'/>");
						break;
					}
				}
			}
		}, 'json');
		$.ajaxSetup({async:true}); // 비동기 옵션 켜기
		
		if(answer) return;
		
		// 선택창
		if(!confirm("<mink:message code='mink.web.alert.is.modify'/>")) return;
		$.post('menuUpdateUpMenuId.miaps?', { menuId: menuId, upMenuId: upMenuId, updNo: updNo, mode: mode, packageNm: packageNm }, function(data){
			resultMsg(data.msg);
			//goDetail(packageNm); // 바로 검색
			goList();
		}, 'json');
	};
	
	// 메뉴그룹명 검색 선택 후 그룹 조직도 다이얼로그로 돌아가기
	var setSelectMenu = function(event) {
		searchMenuNavigation = event.data.menu.grpNavigation; // 최상위 메뉴그룹명을 네비게이션에 추가
		
		$(selectIdId).val(event.data.menu.menuId); // 선택 그룹ID
		$(selectNmId).val(event.data.menu.menuNm); // 선택 메뉴그룹명
		$(selectNavigationId).html(searchMenuNavigation); // 선택 그룹 네비게이션
		
		$( searchNameDialogId ).dialog( "close" ); // 메뉴그룹명 검색 다이얼로그 닫기
		
		reloadTreeview($(selectIdId).val()); // 트리 다시 불러오기
	};
	
	// 상위메뉴그룹수정 조직도 다이얼로그 팝업 나타나기
	var showSearchMenuTreeviewDialog = function(event) {
		$(selectNavigationId).html("${menu.grpNavigation}");
		$(selectIdId).val("${menu.menuId}");
		$(selectNmId).val("${menu.menuNm}");
		
		$( treeviewDialogId ).dialog( "open" ); // 메뉴그룹등록 조직도 다이얼로그 팝업 나타나기
	};
	
	// 메뉴그룹명 검색 다이얼로그 팝업 나타나기
	var showSearchMenuNameDialog = function() {
		var selectMenuName = $(searchNameId).val();
		
		if('' != selectMenuName) {
			$.post(searchNameUrl, { menuNm: selectMenuName, mode: mode }, function(data){
				if(0 < data.menuList.length) {
					$(searchNameDialogId+"Tbody").html("");
					for(var i = 0; i < data.menuList.length; i++) {
						searchMenuNavigation = data.menuList[i].grpNavigation; // 최상위 메뉴그룹명을 네비게이션에 추가
						var $td = $("<td style='float: left;' />").html(searchMenuNavigation);
						var $tr = $("<tr />").bind("click", {menu: data.menuList[i]}, setSelectMenu);
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
				
				$( searchNameDialogId ).dialog( "open" ); // 메뉴그룹명 검색 다이얼로그 팝업 나타나기
			}, 'json');
		}
	};

	//노드 선택 이벤트
	var clickNode = function(event){
		var selectMenuId = $(event.target).data("grp").grpId;
		var selectMenuName = $(event.target).data("grp").grpNm;
		var selectMenuNavigation = $(event.target).data("grp").grpNavigation; // 메뉴그룹 네비게이션
		
		$(selectIdId).val(selectMenuId); // 그룹ID
		$(selectNmId).val(selectMenuName); // 메뉴그룹명
		$(selectNavigationId).html(selectMenuNavigation); // 메뉴그룹 네비게이션
		
		$("a", "#mnTwdgDiv").css("background", "#FFFFFF");
		$(event.target).css("background", "#FFD700"); // check 된 css 적용
	};

	// 트리 다시 불러오기
	function reloadTreeview(menuId) {
		if("root" == menuId) menuId = "";
		
		var $parent = $(treeviewUlId).parent("li");
		$(treeviewUlId).remove(); // 트리 삭제
		$parent.append("<ul id='" + treeviewUlId.substring(1) + "' class='treeview'></ul>"); // 트리 ul 추가
		
		var url = treeviewUrl;
		if("" != menuId) url = selectedTwUrl + "menuId="+menuId; // 선택한 트리만 열기
		
		treeviewAlink(url, treeviewUlId, clickNode); // ajax treeview
	}
	
	// 메뉴그룹 검색 조직도 다이얼로그
	$( treeviewDialogId ).dialog({
		autoOpen: false
		, modal: true
		, maxHeight: 700
		, buttons: {
			"<mink:message code='mink.web.text.select'/>": function() {
				updateUpGrpMenu(); // 상위메뉴그룹수정
            }
			, "<mink:message code='mink.web.text.cancel'/>": function() {
				$( this ).dialog( "close" );
            }
		}
		, open: function( event, ui ) {
			reloadTreeview($(selectIdId).val()); // 트리 다시 불러오기
		}
	});
	
	// 메뉴그룹명 검색 다이얼로그 팝업
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

	// 메뉴그룹명 엔터 검색
	$(searchNameId).on("keypress", function(e){
		if (e.which == 13) {
			showSearchMenuNameDialog();
			return false;
		}
	});
	
	// 상위메뉴그룹 수정 조직도 다이얼로그 팝업 나타나기
	$(parentUpdateUpGrpOpenerBtnId).bind("click", showSearchMenuTreeviewDialog);
	
	// 메뉴그룹명 검색 다이얼로그 팝업 나타나기
	$(searchNameOpenserBtnId).bind("click", showSearchMenuNameDialog);

	treeviewAlink(treeviewUrl, treeviewUlId, clickNode); // ajax treeview
	//$.post(treeviewUrl, {root: 'source'}, function(data){ alert(data); });
});

</script>