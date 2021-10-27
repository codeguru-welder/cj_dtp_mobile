<%-- 메뉴추가 수정 다이얼로그 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="false"%>
<div id="menuAddModiDialog" title="<mink:message code='mink.web.text.add.menu'/>" class="dlgStyle">
	<div id="saveMenuDiv">	<!-- style="display: none;" -->
		<div class="miaps-popup-top-buttons">
			&nbsp;
			<span><button name="btnAddModi" class='btn-dash' onclick="javascript:saveMenu();"><mink:message code="mink.web.text.regist"/></button></span>
			<span><button class='btn-dash' onclick="javascript:;"><mink:message code="mink.web.text.cancel"/></button></span>
		</div>	<!-- miaps-top-buttons -->
		<table class="detailTb" border="0" cellspacing="0" cellpadding="0" width="100%">
			<!-- <thead>
				<tr class="search">
					<th id="saveMenuDivTitleTh" colspan="2" class="subSearch">메뉴수정</th>
				</tr>
			</thead> -->
			<tbody>
				<tr>
					<th><mink:message code="mink.web.text.menuname"/></th>
					<td>
						<input type="hidden" name="packageNm" value="${menu.packageNm}" />
						<input type="hidden" name="menuId" value="${menu.menuId}" />
						<input type="hidden" name="upMenuId" value="${menu.upMenuId}" />
						<input type="hidden" name="orderSeq" value="${menu.orderSeq}" />
						<input type="hidden" name="regNo" value="${loginUser.userNo}" />
						<input type="hidden" name="updNo" value="${loginUser.userNo}" />
						<input type="text" name="menuNm" value="${menu.menuNm}" />
					</td>
				</tr>
				<tr>
					<th><mink:message code="mink.web.text.description.menu"/></th>
					<td>
						<input type="text" name="menuDesc" value="${menu.menuDesc}" />
					</td>
				</tr>
				<tr>
					<th>URL</th>
					<td>
						<input type="text" name="menuUrl" value="${menu.menuUrl}" />
					</td>
				</tr>
		</table>
	</div>	<!-- saveMenuDiv -->
</div>

<script type="text/javascript">
	$("#menuAddModiDialog").dialog({
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
</script>