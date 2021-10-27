<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="false"%>
<%@ page import="java.lang.management.ManagementFactory"%>
<%@ page import="java.lang.management.MemoryMXBean"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%
    pageContext.setAttribute("memoryBean", ManagementFactory.getMemoryMXBean());
    pageContext.setAttribute("poolBeans", ManagementFactory.getMemoryPoolMXBeans());
%>


<style type="text/css">   
   .listTb table{ border-collapse: collapse; }
   .listTb td,th{ padding: 5px; }
   /* th { background-color: navy; color: #fff; font-weight: bold; }*/
   .listTb td { text-align: right; }   
</style>

  
<div id="miapsJvmInfoDialog" title="MiAPS JVM Infomation" class="dlgStyle">
<div class="miaps-popup-top-buttons">
	&nbsp;
	<span><button class='btn-dash' onclick="javascript:openMiapsJvmImageDialog();"><mink:message code="mink.web.text.jvm.description"/></button></span>
	<span><button class='btn-dash' onclick="javascript:$('#miapsJvmInfoDialog').dialog('close');"><mink:message code="mink.web.text.close"/></button></span>
</div>

    <h1>TOTAL</h1>
     
    <table class="listTb" border="0" cellspacing="0" cellpadding="0" width="100%">
        <colgroup>
            <col width="20%"/>
            <col width="20%"/>
            <col width="20%"/>
            <col width="20%"/>
            <col width="20%"/>
        </colgroup>
        <thead>
	        <tr>
	            <th>Usage</th>
	            <th>Max</th>
	            <th>Init</th>
	            <th>Used</th>
	            <th>Committed</th>
	        </tr>
        </thead>
        <tbody>
	        <tr>
	            <td style="text-align: left">Heap Memory Usage</td>
	            <td><fmt:formatNumber value="${memoryBean.heapMemoryUsage.max/(1024 * 1024)}"
	                    maxFractionDigits="1" />MB</td>
	            <td><fmt:formatNumber value="${memoryBean.heapMemoryUsage.init/(1024 * 1024)}"
	                    maxFractionDigits="1" />MB</td>
	            <td><fmt:formatNumber value="${memoryBean.heapMemoryUsage.used/(1024 * 1024)}"
	                    maxFractionDigits="1" />MB</td>
	            <td><fmt:formatNumber value="${memoryBean.heapMemoryUsage.committed/(1024 * 1024)}"
	                    maxFractionDigits="1" />MB</td>
        	</tr>
	        <tr>
	            <td style="text-align: left">Non-heap Memory Usage</td>
	            <td><fmt:formatNumber value="${memoryBean.nonHeapMemoryUsage.max/(1024 * 1024)}"
	                    maxFractionDigits="1" />MB</td>
	            <td><fmt:formatNumber value="${memoryBean.nonHeapMemoryUsage.init/(1024 * 1024)}"
	                    maxFractionDigits="1" />MB</td>
	            <td><fmt:formatNumber value="${memoryBean.nonHeapMemoryUsage.used/(1024 * 1024)}"
	                    maxFractionDigits="1" />MB</td>
	            <td><fmt:formatNumber value="${memoryBean.nonHeapMemoryUsage.committed/(1024 * 1024)}"
	                    maxFractionDigits="1" />MB</td>
	        </tr>
        </tbody>
    </table>
 
 	<br/>
    <hr style="border: 1px dashed; color: #bcbcbc;"/>
        
    <h1>Memory Pools</h1>
     
    <c:forEach var="bean" items="${poolBeans}">
        <h2>${bean.name}(${bean.type})</h2>
        <table class="listTb" border="0" cellspacing="0" cellpadding="0" width="100%">
            <colgroup>
                <col width="20%"/>
                <col width="20%"/>
                <col width="20%"/>
                <col width="20%"/>
                <col width="20%"/>
            </colgroup>
            <thead>
            <tr>
                <th>Usage</th>
                <th>Max</th>
                <th>Init</th>
                <th>Used</th>
                <th>Committed</th>
            </tr>
            </thead>
            <tbody>
            <tr>
                <td style="text-align: left">Memory Usage</td>
                <td><fmt:formatNumber value="${bean.usage.max/(1024 * 1024)}"
                        maxFractionDigits="1" />MB</td>
                <td><fmt:formatNumber value="${bean.usage.init/(1024 * 1024)}"
                        maxFractionDigits="1" />MB</td>
                <td><fmt:formatNumber value="${bean.usage.used/(1024 * 1024)}"
                        maxFractionDigits="1" />MB</td>
                <td><fmt:formatNumber value="${bean.usage.committed/(1024 * 1024)}"
                        maxFractionDigits="1" />MB</td>
            </tr>
            <tr>
                <td style="text-align: left">Peak Usage</td>
                <td><fmt:formatNumber value="${bean.peakUsage.max/(1024 * 1024)}"
                        maxFractionDigits="1" />MB</td>
                <td><fmt:formatNumber value="${bean.peakUsage.init/(1024 * 1024)}"
                        maxFractionDigits="1" />MB</td>
                <td><fmt:formatNumber value="${bean.peakUsage.used/(1024 * 1024)}"
                        maxFractionDigits="1" />MB</td>
                <td><fmt:formatNumber value="${bean.peakUsage.committed/(1024 * 1024)}"
                        maxFractionDigits="1" />MB</td>
            </tr>
            <tr>
                <td style="text-align: left">Collection Usage</td>
                <td><fmt:formatNumber value="${bean.collectionUsage.max/(1024 * 1024)}"
                        maxFractionDigits="1" />MB</td>
                <td><fmt:formatNumber value="${bean.collectionUsage.init/(1024 * 1024)}"
                        maxFractionDigits="1" />MB</td>
                <td><fmt:formatNumber value="${bean.collectionUsage.used/(1024 * 1024)}"
                        maxFractionDigits="1" />MB</td>
                <td><fmt:formatNumber value="${bean.collectionUsage.committed/(1024 * 1024)}"
                        maxFractionDigits="1" />MB</td>
            </tr>
            </tbody>
        </table>
    </c:forEach>
</div>

<script type="text/javascript">
function openMiapsJvmInfoDialog() {
	$("#miapsJvmInfoDialog").dialog( "open" );
}

$("#miapsJvmInfoDialog").dialog({
	autoOpen: false,
    resizable: false,
    width: 'auto',
    height: 900,
    modal: true,
	// add a close listener to prevent adding multiple divs to the document
    close: function(event, ui) {
        // remove div with all data and events
        $(this).dialog( "close" );
    }
});
</script>