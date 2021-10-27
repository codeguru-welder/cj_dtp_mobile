<%-- 사용자별 권한변경 이력조회 다이얼로그 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="false"%>
<div id="menuAdminUserRoleDialog" title="<mink:message code='mink.web.text.inquiry.changepermission.byuser'/>" class="dlgStyle">
	<div id="menuAdminUserRoleDiv">
	<form id="searchFrm2" name="searchFrm2" method="post" onSubmit="return false;">
		<input type="hidden" name="searchUserNo" />
		
		<!-- 검색 화면 -->
		<div id="searchDiv2" >
			<table border="0" cellspacing="0" cellpadding="0" width="100%">
				<tr> 	
					<td class="search">
						<span id="userInfoSpan2"><!-- 사용자 정보 --></span>
						<span>
							<mink:message code="mink.web.text.userid"/>: <input type="text" name="searchUserId" />
							<button class='btn-dash' onclick="javascript:searchMenuAdminUserRole();"><mink:message code='mink.web.text.search'/></button>
						</span>
					</td>
				</tr>
			</table>
		</div>

		<!-- 목록 화면 -->
		<div id="listDiv2">
			<table id="menuAdminUserRoleListTb" border="0" cellspacing="0" cellpadding="0" width="100%" class="read_listTb">
				<colgroup>
					<col width="12%" />
					<col width="8%" />
					<col width="80%" />
				</colgroup>
				<thead>
					<tr>
						<td><mink:message code="mink.web.text.menu"/></td>
						<td><mink:message code="mink.web.text.permission"/></td>
						<td><mink:message code="mink.web.text.list.history"/></td>
					</tr>
				</thead>
				<tbody id="menuAdminUserRoleListTbody">
					<tr>
						<td colspan="3"><mink:message code='mink.web.text.noexist.result'/></td>
					</tr>
				</tbody>
				<tfoot>
				</tfoot>
			</table>
		</div>
	</form>
	</div>
</div>

<script type="text/javascript">
/*   
 *   
 * 같은 값이 있는 열을 병합함  
 *   
 * 사용법 : $('#테이블 ID').rowspan(0);  
 *   
 */       
$.fn.rowspan = function(colIdx, isStats) {
    return this.each(function(){        
        var that;       
        $('tr', this).each(function(row) {        
            $('td',this).eq(colIdx).filter(':visible').each(function(col) {  
                  
                if ($(this).html() == $(that).html()  
                    && (!isStats   
                            || isStats && $(this).prev().html() == $(that).prev().html()  
                            )  
                    ) {              
                    rowspan = $(that).attr("rowspan") || 1;  
                    rowspan = Number(rowspan)+1;  
  
                    $(that).attr("rowspan",rowspan);  
                      
                    // do your action for the colspan cell here              
                    $(this).hide();  
                      
                    //$(this).remove();   
                    // do your action for the old cell here  
                      
                } else {              
                    that = this;           
                }            
                  
                // set the that if not already set  
                that = (that == null) ? this : that;        
            });       
        });      
    });    
}; 

var emptyTbodyHtml = "<tr><td colspan='3'><mink:message code='mink.web.text.noexist.result'/></td></tr>";

function showMenuAdminUserRoleDialog() {
	$('#searchFrm2').find("input[name='searchUserId']").val("");
	$("#userInfoSpan2").html("");
	$("#menuAdminUserRoleListTbody").html(emptyTbodyHtml);
	
	$("#menuAdminUserRoleDialog").dialog( "open" );
}

function searchMenuAdminUserRole() {
	var searchUserId = document.searchFrm2.searchUserId.value;
	
	<%-- XSS 방어 --%>
	searchUserId = defenceXSS(searchUserId);
	document.searchFrm2.searchUserId.value = searchUserId;
	
	if ($.trim(searchUserId) == '') {
		alert("<mink:message code='mink.web.alert.input.userid'/>");
		document.searchFrm2.searchUserId.focus();
		return;
	}
	
	document.searchFrm2.searchUserNo.value = ''; // 사용자NO 초기화
	ajaxComm('menuRoleAdminUserInfo.miaps?', $('#searchFrm2'), callbackUserInfoList);
}

function callbackUserInfoList(data) {
	var resultList = data.userInfoList;
	
	var html = "<mink:message code='mink.web.alert.noexist.user'/>";
	$("#menuAdminUserRoleListTbody").html(emptyTbodyHtml);
	
	if (resultList.length > 1) {
		html = "<mink:message code='mink.web.alert.select.user'/>";
		var searchUserId = document.searchFrm2.searchUserId.value;
		showMenuAdminUserRoleBySameUserIdDialog(searchUserId, resultList);
	} else {
		if (resultList.length == 1) {
			document.searchFrm2.searchUserNo.value = resultList[0].userNo;
			html = getUserInfoSpan2(resultList, 0);
			searchMenuAdminUserRoleHistory();
		}
	}
	$("#userInfoSpan2").html(" | " + html + " | ");
}

function getUserInfoSpan2(resultList, i) {
	var adminNm = '${commUser}';
	var grpNavigation = '${unclassifiedName}';
	
	var adminYn = '';
	var memberAdminYn = '';
	
	adminYn = resultList[i].adminYn;
	if (resultList[i].userGroupMember != null) memberAdminYn = resultList[i].userGroupMember.adminYn;
	
	if (adminYn == '${ynYes}') adminNm = '${superAdmin}';
	else if (memberAdminYn == '${ynYes}') adminNm = '${subAdmin}';
	
	if (resultList[i].userGroup != null) grpNavigation = resultList[i].userGroup.grpNavigation;
	
	return adminNm + " | " + grpNavigation;
}

function searchMenuAdminUserRoleHistory() {
	if (document.searchFrm2.searchUserNo.value == '') {
		alert("<mink:message code='mink.web.alert.noexist.userinfo'/>");
		document.searchFrm2.searchUserId.focus();
		return;
	}
	
	ajaxComm('menuRoleAdminRoleHistoryList.miaps?', $('#searchFrm2'), callbackMenuAdminUserRoleHistoryList);
}

function callbackMenuAdminUserRoleHistoryList(data) {
	var resultList = data.menuHistoryList;
	var html = "";
	for(var i = 0; i < resultList.length; i++) {
		html += "<tr>";
		html += "<td align='left'>"+nvl(resultList[i].UP_MENU_NM)+" > <br/><b>"+nvl(resultList[i].MENU_NM)+"</b></td>";
		html += "<td>"+nvl(resultList[i].MENU_FUNCTION_NM)+"</td>";
		html += "<td align='left'>"+nvl(resultList[i].ROLE_HISTORY)+"</td>";
		html += "</tr>";
	}
	if (html == '') html = emptyTbodyHtml;
	$("#menuAdminUserRoleListTbody").html(html);
	
	// 구분(첫째열) 열을 병합함
	$('#menuAdminUserRoleListTbody').rowspan(0);
}

$("#menuAdminUserRoleDialog").dialog({
	autoOpen: false,
    resizable: true,
    width: '75%',
    modal: true,
	// add a close listener to prevent adding multiple divs to the document
    close: function(event, ui) {
        // remove div with all data and events
        $(this).dialog( "close" );
    }
});
</script>