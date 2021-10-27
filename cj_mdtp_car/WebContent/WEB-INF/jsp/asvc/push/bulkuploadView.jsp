<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" 
%><%@ page import="org.springframework.web.bind.annotation.SessionAttributes"
%><%@ page import="com.thinkm.mink.commons.util.MinkConfig" 
%><%@ page import="java.util.*" 
%><%
	/*
	 * 푸시 데이터 대량 등록(json, bulkuploadView.jsp)
	 * 
	 * @author mingun.park@gmail.com
	 */
	Object showView = request.getAttribute("showView");
	if (showView == null) {
		showView = request.getParameter("showView");
	}

	boolean b = (showView instanceof String ? "true".equalsIgnoreCase((String) showView) : (Boolean) showView);
	if (false == b) {
		String msg = (String) request.getAttribute("errorMsg");
		if (msg == null) {
			msg = "";
		}
		out.print(msg);
		return;
	}
%><%
%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<%@ include file="/WEB-INF/jsp/include/wsACommonInclude.jsp" %>
<%@ include file="/WEB-INF/jsp/include/wsACommonHeadScript.jsp" %>
<title><mink:message code="mink.label.page_title"/></title>


<script type="text/javascript">
$(function() {
	//accordion 선택 페이지를 유지하기위한 설정값 셋팅 ex) home:0 user:1, device:2, app:3, push:4, board:5, monitoring:6, setting:7
	init_accordion('push', '${loginUser.menuListString}');
	$("#topMenuTile").html("<mink:message code='mink.web.text.pushmanage_pushbatchregsitJ'/>");
	
	init();
	
	if( '${errorMsg}' != null && '${errorMsg}' != "" ) alert("${errorMsg}");
	
});

function goInsert() {
	if( $("#data").val() == "" ) {
		alert("<mink:message code='mink.web.alert.push.select.pushjsonfile'/>");
		$("#data").focus();
		return;
	}
	document.apiFileFrm.action = "pushBulkuploadView.miaps?";
	document.apiFileFrm.submit();
}
</script>

</head>
<body>
	<div id="miaps-container">
		<div id="miaps-header">
	    	<%@ include file="/WEB-INF/jsp/include/header.jsp" %>
	  	</div>
	  	<div id="miaps-sidebar">
			<%@ include file="/WEB-INF/jsp/include/left.jsp" %>
		</div>
		<div id="miaps-top-buttons">
			<span><button class='btn-dash' onclick="javascript:goInsert();"><mink:message code="mink.web.text.save"/></button></span>
		</div>
		<div id="miaps-content">
			<!-- 본문 -->
			<!-- 검색 및 목록 시작 -->
			<div class="searchDivFrm">
				<form id="apiFileFrm" name="apiFileFrm" method="post" enctype="multipart/form-data" onSubmit="return false;">
					<input type="hidden" name="regNo" value="${loginUser.userNo}" />
					<div style="padding-top: 1px;">
						<h3>
							<span style="margin-left: 2%"><mink:message code="mink.web.text.push.regist.batchpushJ"/></span>
						</h3>
					</div>
					<div>
						<ul>
							<li><b style="color: blue"><mink:message code="mink.web.text.push.uploadtype"/></b>: JSON &amp; XML<br/>
								<table class="subDetailTb" border="0" cellspacing="0" cellpadding="0">
									<tr><td align="center">JSON</td><td align="center">XML</td></tr>
									<tr>
										<td>
											<pre>
												
[
  {
    pushData: {
      pushMsg: "<mink:message code="mink.web.text.push.string.pushmessage"/>",
      msgTp: "<mink:message code="mink.web.text.push.messagetype"/>",
      imgUrl: "<mink:message code="mink.web.text.push.imageurl"/>",
      reservedDt: "<mink:message code="mink.web.text.push.reserveddate"/>",
    },

    pushTask: [
      {
        taskId: "<mink:message code="mink.web.text.push.biznumber"/>",
        taskParam: "<mink:message code="mink.web.text.push.addparam.bybiz
        "/>"
      }
    ],

    pushTarget: [
      {
        targetTp: "<mink:message code="mink.web.text.push.targettype"/>",
        targetId: "<mink:message code="mink.web.text.push.target"/>",
        includeSubYn: "<mink:message code="mink.web.text.push.include.user.undergroup.yn"/>",
        targetParam: "<mink:message code="mink.web.text.push.addparam.bytarget"/>"
     }
    ]
  }
]
													</pre>
												</td>
												<td><pre>
												
&lt;?xml version="1.0" encoding="UTF-8"?>
&lt;miaps-push>
  &lt;push-item>
    &lt;push-data>
      &lt;push-msg><mink:message code="mink.web.text.string.pushmessage"/>&lt;/push-msg>
      &lt;msg-tp><mink:message code="mink.web.text.push.messagetype"/>&lt;/msg-tp>
      &lt;img-url><mink:message code="mink.web.text.push.imageurl"/>&lt;/img-url>
      &lt;reserved-dt><mink:message code="mink.web.text.push.reserveddate"/>&lt;/reserved-dt>
    &lt;/push-data>
      &lt;push-task>
        &lt;task-id><mink:message code="mink.web.text.push.biznumber"/>&lt;/task-id>
        &lt;task-param><mink:message code="mink.web.text.push.addparam.bybiz"/>&lt;/task-param>
      &lt;/push-task>
      &lt;push-target>
        &lt;target-tp><mink:message code="mink.web.text.push.targettype"/>&lt;/target-tp>
        &lt;target-id><mink:message code="mink.web.text.target"/>&lt;/target-id>
        &lt;include-sub-yn><mink:message code="mink.web.text.is.include.undergroup"/>&lt;/include-sub-yn>
        &lt;target-param><mink:message code="mink.web.text.push.addparam.bytarget"/>&lt;/target-param>
    &lt;/push-target>
  &lt;/push-item>
&lt;/miaps-push>
											</pre>
										</td>
									</tr>
							</table><br/>
						</li>
						<li><mink:message code="mink.web.text.push.nosupport.tasktargetparam"/></li>
						<li><mink:message code="mink.web.text.push.send.specificttime"/></li>
						<li><b><mink:message code="mink.web.text.push.messagetype"/></b><mink:message code="mink.web.text.push.forandroid"/>
							<ul>
							<li><mink:message code="mink.web.text.push.texttype"/></li>
							<li><mink:message code="mink.web.text.push.btexttype"/></li>
							<li><mink:message code="mink.web.text.push.inboxtype"/></li>
							</ul>
						</li>
						<li><mink:message code="mink.web.text.push.imgurltype"/></li>
						<li><b><mink:message code="mink.web.text.push.targettype"/></b>:
							<ul>
								<li><mink:message code="mink.web.text.push.ugtype"/></li>
								<li><mink:message code="mink.web.text.push.untype"/></li>
								<li><mink:message code="mink.web.text.push.udtype"/></li>
								<li><mink:message code="mink.web.text.push.ddtype"/></li>
							</ul>
						</li>
					</ul>
				</div>
				<hr/>
				<div>
					<ul>
						<li><b style="color: blue"><mink:message code="mink.web.text.push.regist.bulkapi"/></b> - ${contextURL}/asvc/push/pushBulkupload.miaps
							<ol>
								<li><mink:message code="mink.web.text.push.formtype"/></li>
								<li><mink:message code="mink.web.text.push.message1"/></li>
								<li><mink:message code="mink.web.text.push.message2"/></li>
							</ol>
						</li>
						<br/>
						<li><b style="color: blue"><mink:message code="mink.web.text.push.regist.quickapi"/></b><mink:message code="mink.web.text.push.message3"/>
							<ol>
								<li><mink:message code="mink.web.text.push.message4"/></li>
								<li><mink:message code="mink.web.text.push.message5"/></li>
								<li><mink:message code="mink.web.text.push.message6"/></li>
								<li><mink:message code="mink.web.text.push.message7"/></li>
								<li><mink:message code="mink.web.text.push.message8"/></li>
								<li><mink:message code="mink.web.text.push.message9"/></li>
							</ol>
						</li>
					</ul>
				</div>

				<table class="read_listTb" border="0" cellspacing="0" cellpadding="0" width="100%">
					<colgroup>
						<col width="90%" />
						<col width="10%" />
					</colgroup>
					<thead>
						<tr>
							<td colspan="2"><mink:message code="mink.web.text.fileupload"/></td>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td align="left">
								<input type="file" id="data" name="data" size="100%" />
								<input type="hidden" name="showView" value="true"/>
							</td>
						</tr>
					</tbody>
				</table>

				<table class="read_listTb" border="0" cellspacing="0" cellpadding="0" width="100%">
					<colgroup>
						<col width="30%" />
						<col width="10%" />
						<col width="5%" />
						<col width="30%" />
						<col width="15%" />
					</colgroup>
					<thead>
						<tr><td colspan="5"><mink:message code="mink.web.text.fileuploadresult"/></td></tr>
						<tr>
							<td><mink:message code="mink.web.text.pushmessage2"/></td>
							<td><mink:message code="mink.web.text.push.reserveddate"/></td>
							<td><mink:message code="mink.web.text.bizid"/></td>
							<td><mink:message code="mink.web.text.push.receivetarget"/></td>
							<td><mink:message code="mink.web.text.result"/></td>
						</tr>
					</thead>
					<tbody>
						<%
							List<Object> results = (List<Object>) request.getAttribute("results");
							if (results == null) {
						%>
						<tr><td colspan="5"><mink:message code="mink.web.alert.push.noexist.uploadmessage"/></td></tr>
						<%
							} else {
								HashMap<String, Object> savedData = null;
						
								Map<String, Object> pushDataMap = new HashMap<String, Object>();
								List<Map<String, Object>> pushTaskList = new ArrayList<Map<String, Object>>();
								List<Map<String, Object>> pushTargetList = new ArrayList<Map<String, Object>>();
								Map<String, Object> pushDataStMap = new HashMap<String, Object>();
						
								String resultMsg = null;
								String pushMsg = null;
								String reservedDt = null;
								StringBuilder taskList = null;
								StringBuilder targetList = null;
						
								for (Object o: results) {
									taskList = null;
									targetList = null;
									savedData = (HashMap<String, Object>) o;
						
									pushDataMap = (Map<String, Object>) savedData.get("pushDataMap");
									pushTaskList = (List<Map<String, Object>>) savedData.get("pushTaskList");
									pushTargetList = (List<Map<String, Object>>) savedData.get("pushTargetList");
									pushDataStMap = (Map<String, Object>) savedData.get("pushDataStMap");
						
									resultMsg = (String) savedData.get("resultMsg");
									pushMsg = "(" + pushDataMap.get("pushId") + ") " + pushDataMap.get("pushMsg");
									reservedDt = (String) pushDataMap.get("reservedDt");
						
									for (Map<String, Object> task: pushTaskList) {
										if (taskList == null) {
											taskList = new StringBuilder("" + task.get("taskId"));
										} else {
											taskList.append(", ").append("" + task.get("taskId"));
										}
									}
						
									for (Map<String, Object> target: pushTargetList) {
										String tp = (String) target.get("targetTp");
										String id = (String) target.get("targetId");
										String sub = (String) target.get("includeSubYn");
										String targetString = tp + ":" + id + (sub == null || sub.length() <= 0 ? "" : ":" + sub);
										if (targetList == null) {
											targetList = new StringBuilder(targetString);
										} else {
											targetList.append("<br/>").append(targetString);
										}
									}
						%>
						<tr>
							<td align="left"><%=pushMsg%></td>
							<td><%=reservedDt%></td>
							<td><%=taskList.toString()%></td>
							<td align="left"><%=targetList.toString()%></td>
							<td align="left"><%=resultMsg%></td>
						</tr>
						<%
								}
						%><%
							}
						%>
				</tbody>
			</table>
		</form>
	</div>
</div>
<!-- footer -->
<div id="miaps-footer">
	<%@ include file="/WEB-INF/jsp/include/footer.jsp" %>
</div>	
</div>
</body>
</html>
