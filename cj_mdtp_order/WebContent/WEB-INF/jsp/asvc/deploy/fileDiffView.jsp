<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="org.springframework.web.bind.annotation.SessionAttributes"%>
<%@ page import="com.thinkm.mink.commons.util.MinkConfig" %>
<%
	/*
	 * 장치 관리 화면 - 목록 및 등록/수정/삭제 (fileDiffView.jsp)
	 * 
	 * @author chlee
	 * @since 2017.10.11
	 */
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<%@ include file="/WEB-INF/jsp/include/wsACommonIncludeDeploy.jsp" %>
<%@ include file="/WEB-INF/jsp/include/wsACommonHeadScript.jsp" %>

<link rel="STYLESHEET" type="text/css" href="${contextPath}/css/layout.deploy.css">
<!-- jsdiff lib -->
<link rel="stylesheet" type="text/css" href="${contextPath}/css/jsdifflib/diffview.css"/>
<script type="text/javascript" src="${contextPath}/js/jsdifflib/diffview.js"></script>
<script type="text/javascript" src="${contextPath}/js/jsdifflib/difflib.js"></script>

<title>MiAPS Hybrid Resource Deploy</title>

<script type="text/javascript">

$(function() {
	hideLoading();
	
	$('.tooltip').tooltipster({ 
		contentAsHTML: true,
		/*theme: 'tooltipster-punk',*/
		iconDesktop: true
	});	// tooltipster html
	
	// 디폴트 정렬조건 표시
	//setOrderByUpDownDeploy("DIR", "DESC"); // ICON-FILE-DIR-SIZE-LOCALDT-REMOTEDT-MODIFY / DESC-ASC
	initEventBind();
	
	$( window ).resize(function() {
		//setDivHeight('deploy-content','deploy-top-buttons');
		changeContentAreaSize();
	});
});
////////////////////////////////
//출처 : http://tonks.tistory.com/79 

/* sortingNumber() : 숫자인 실수만으로 되어있을 때, 적용될 함수 */ 
function sortingNumber( a , b ){  

     if ( typeof a == "number" && typeof b == "number" ) return a - b; 

     // 천단위 쉼표와 공백문자만 삭제하기.  
     var a = ( a + "" ).replace( /[,\s\xA0]+/g , "" ); 
     var b = ( b + "" ).replace( /[,\s\xA0]+/g , "" ); 

     var numA = parseFloat( a ) + ""; 
     var numB = parseFloat( b ) + ""; 

     if ( numA == "NaN" || numB == "NaN" || a != numA || b != numB ) return false; 

     return parseFloat( a ) - parseFloat( b ); 
} 


/* changeForSorting() : 문자열 바꾸기. */
function changeForSorting( first , second ){  

     // 문자열의 복사본 만들기. 
     var a = first.toString().replace( /[\s\xA0]+/g , " " ); 
     var b = second.toString().replace( /[\s\xA0]+/g , " " ); 

     var change = { first : a, second : b }; 

     if ( a.search( /\d/ ) < 0 || b.search( /\d/ ) < 0 || a.length == 0 || b.length == 0 ) return change; 

     var regExp = /(\d),(\d)/g; // 천단위 쉼표를 찾기 위한 정규식. 

     a = a.replace( regExp , "$1" + "$2" ); 
     b = b.replace( regExp , "$1" + "$2" ); 

     var unit = 0; 
     var aNb = a + " " + b; 
     var numbers = aNb.match( /\d+/g ); // 문자열에 들어있는 숫자 찾기 

     for ( var x = 0; x < numbers.length; x++ ){ 

             var length = numbers[ x ].length; 
             if ( unit < length ) unit = length; 
     } 

     var addZero = function( string ){ // 숫자들의 단위 맞추기 

             var match = string.match( /^0+/ ); 

             if ( string.length == unit ) return ( match == null ) ? string : match + string; 

             var zero = "0"; 

             for ( var x = string.length; x < unit; x++ ) string = zero + string; 

             return ( match == null ) ? string : match + string; 
     }; 

     change.first = a.replace( /\d+/g, addZero ); 
     change.second = b.replace( /\d+/g, addZero ); 

     return change; 
} 


/* byLocale() */ 
function byLocale(){ 

     var compare = function( a , b ){ 

             var sorting = sortingNumber( a , b ); 

             if ( typeof sorting == "number" ) return sorting; 

             var change = changeForSorting( a , b ); 

             var a = change.first; 
             var b = change.second; 

             return a.localeCompare( b ); 
     }; 

     var ascendingOrder = function( a , b ){  return compare( a , b );  }; 
     var descendingOrder = function( a , b ){  return compare( b , a );  }; 

     return { ascending : ascendingOrder, descending : descendingOrder }; 
} 


/* replacement() */ 
function replacement( parent ){  
     var tagName = parent.tagName.toLowerCase();
     
     if ( tagName == "table" ) {
    	 parent = parent.tBodies[0]; 
     }
    
     tagName = parent.tagName.toLowerCase();
     
     if ( tagName == "tbody" ) {
    	 var children = parent.rows; 
     }
     else {
    	 var children = parent.getElementsByTagName( "li" ); 
     }
     
     var replace = { 
             order : byLocale(), 
             index : false, 
             array : function(){ 
                     var array = [ ]; 
                     for ( var x = 0; x < children.length; x++ ) array[ x ] = children[ x ]; 
                     return array; 
             }(), 
             checkIndex : function( index ){ 
                     if ( index ) this.index = parseInt( index, 10 ); 
                     var tagName = parent.tagName.toLowerCase();
                     if ( tagName == "tbody" && ! index ) {                    	 
                    	 this.index = 0; 
                     }
             }, 
             getText : function( child ){ 
                     if ( this.index ) child = child.cells[ this.index ]; 
                     return getTextByClone( child ); 
             }, 
             setChildren : function(){ 
                     var array = this.array; 
                     while ( parent.hasChildNodes() ) parent.removeChild( parent.firstChild ); 
                     for ( var x = 0; x < array.length; x++ ) parent.appendChild( array[ x ] ); 
             }, 
             ascending : function( index ){ // 오름차순 
                     this.checkIndex( index ); 
                     var _self = this; 
                     var order = this.order; 
                     var ascending = function( a, b ){ 
                             var a = _self.getText( a ); 
                             var b = _self.getText( b ); 
                             return order.ascending( a, b ); 
                     }; 
                     this.array.sort( ascending ); 
                     this.setChildren(); 
             }, 
             descending : function( index ){ // 내림차순
                     this.checkIndex( index ); 
                     var _self = this; 
                     var order = this.order; 
                     var descending = function( a, b ){ 
                             var a = _self.getText( a ); 
                             var b = _self.getText( b ); 
                             return order.descending( a, b ); 
                     }; 
                     this.array.sort( descending ); 
                     this.setChildren(); 
             } 
     }; 
     return replace; 
} 

function getTextByClone( tag ){  
     var clone = tag.cloneNode( true ); // 태그의 복사본 만들기. 
     var br = clone.getElementsByTagName( "br" ); 
     while ( br[0] ){ 
             var blank = document.createTextNode( " " ); 
             clone.insertBefore( blank , br[0] ); 
             clone.removeChild( br[0] ); 
     } 
     var isBlock = function( tag ){ 
             var display = ""; 
             if ( window.getComputedStyle ) display = window.getComputedStyle ( tag, "" )[ "display" ]; 
             else display = tag.currentStyle[ "display" ]; 
             return ( display == "block" ) ? true : false; 
     }; 
     var children = clone.getElementsByTagName( "*" ); 
     for ( var x = 0; x < children.length; x++){ 
             var child = children[ x ]; 
             if ( ! ("value" in child) && isBlock(child) ) child.innerHTML = child.innerHTML + " "; 
     } 
     
     //img tag면 alt를 사용하도록 한다. 2017.10.20 chlee
     if (children[0] != undefined && "alt" in children[0]) {
    	 var textContent = children[0].getAttribute('alt');
     } else {
    	 var textContent = clone.textContent || clone.innerText;	 
     } 
     return textContent; 
}
////////////////////////////////
</script>
</head>
<body>
	<%-- 파일 비교 다이얼로그 --%>  
	<%@ include file="/WEB-INF/jsp/asvc/deploy/fileDiffDialog.jsp" %>
	<%-- 배포 정보 리스트 다이얼로그 --%>  
	<%@ include file="/WEB-INF/jsp/asvc/deploy/deployListDialog.jsp" %>
	<%-- 배포 정보 등록 다이얼로그 --%>  
	<%@ include file="/WEB-INF/jsp/asvc/deploy/deployRegDialog.jsp" %>
	<%-- 배포 정보 수정 다이얼로그    
	<%@ include file="/WEB-INF/jsp/asvc/deploy/deployModiDialog.jsp" %>
	--%>
	<!-- 본문 -->
	<div id="deploy-container">
		<div id="deploy-header">
	    	<div class="topContent">
				<div class="logoContent">
					<img src="${contextURL}/asvc/images/hybrid_deploy_logo.png" border="0">
					<div style="float: right; padding: 20px 15px 0 0; font: 12px Consoles;">icon by <a target="_blank" href="https://icons8.com">Icons8</a></div>
				</div>
			</div>
	  	</div>
		<div id="deploy-top-buttons">
			<div style="float: left;">
				<span><button class='btn-dash' onclick="javascript:openDeployListDlg()"><img src='${contextURL}/asvc/images/settings-40.png' width='22px' height='22px' alt='setting' style="vertical-align:middle;"><mink:message code="mink.web.text.deploysetting"/></button></span>
				<span><button class='btn-dash' onclick="javascript:fileUpload()"><img src='${contextURL}/asvc/images/ds_upload_to_cloud-48.png' width='22px' height='22px' alt='upload' style="vertical-align:middle;"><mink:message code="mink.web.text.upload"/></button></span>
				<span><button class='btn-dash' onclick="javascript:fileDownload()"><img src='${contextURL}/asvc/images/ds_download_from_cloud-48.png' width='22px' height='22px' alt='download' style="vertical-align:middle;"><mink:message code="mink.web.text.download"/></button></span>
				<span><button class='btn-dash' onclick="javascript:refresh()"><img src='${contextURL}/asvc/images/refresh-40.png' width='22px' height='22px' alt='resource update' style="vertical-align:middle;"><mink:message code="mink.web.text.refresh"/></button></span>
				<span><button class='btn-dash' onclick="javascript:resourceUpdate()"><img src='${contextURL}/asvc/images/run-command.png' width='22px' height='22px' alt='resource update' style="vertical-align:middle;">&nbsp;ResourceUpdate</button></span>
				<span><button class='btn-dash' onclick="javascript:downloadZip()"><img src='${contextURL}/asvc/images/zip-48.png' width='22px' height='22px' alt='download zip' style="vertical-align:middle;">&nbsp;Download ZIP</button></span>
			</div>
			<div style="float: right; padding: 6px 15px 0 0;">
				<span><img src="${contextURL}/asvc/images/website-40.png" width="22px" height="22px" style="vertical-align:middle;">&nbsp;<strong>URL:</strong>&nbsp;<span id="spanUrl"></span></span>
				&nbsp;<span><img src="${contextURL}/asvc/images/folder-internet-40.png" width="22px" height="22px" style="vertical-align:middle;">&nbsp;<strong>Project Path:</strong>&nbsp;<span id="spanProjectPath"></span></span>
				&nbsp;<span><img src="${contextURL}/asvc/images/folder-40.png" width="22px" height="22px" style="vertical-align:middle;">&nbsp;<strong>Local Path:</strong>&nbsp;<span id="spanLocalPath"></span></span>
			</div>
		</div>		
		<div id="deploy-content" style="float:none;">
			<form id="deployFrm" name="deployFrm" method="post" onSubmit="return false;">
				
				<input type="hidden" name="ordColumnNm" value="" />
				<input type="hidden" name="ordAscDesc" value="" />
				
				<input type="hidden" id="serverCnt" name="serverCnt" value=""/>
				<input type="hidden" id="url" name="url" value=""/>
				<input type="hidden" id="url2" name="url2" value=""/>
				<input type="hidden" id="accessId" name="accessId" value=""/>
				<input type="hidden" id="accessPw" name="accessPw" value=""/>
				<input type="hidden" id="localPath" name="localPath" value="" />
				<input type="hidden" id="projectPath" name="projectPath" value="" />
				<input type="hidden" id="uploadUser" name="uploadUser" value="" />
				<input type="hidden" id="json" name="json" value="true"/>
				
				<!-- 목록 화면 -->
				<div id="listDiv">
					<table id="deployTable" class="listTb-deploy" border="0" cellspacing="0" cellpadding="0" width="100%">
						<colgroup>
							<col width="3%" />
							<col width="5%" />
							<col width="18%" />
							<col width="18%" />
							<col width="12%" />							
							<col width="10%" />
							<col width="10%" />
							<col width="10%" />
							<col width="10%" />
							<col width="4%" />
						</colgroup>
						<thead>
							<tr>
								<td><input type="checkbox" name="deviceCheckboxAll" style="width:20px;height:20px;" /></td>
								<td id="order_ICON" class="order_by_column" onclick="orderBy('ICON', 'deployFrm', function(){ tableSort(); });"><mink:message code="mink.web.text.info"/></td>
								<td id="order_FILE" class="order_by_column" onclick="orderBy('FILE', 'deployFrm', function(){ tableSort(); });"><mink:message code="mink.web.text.file"/></td>
								<td id="order_DIR" class="order_by_column" onclick="orderBy('DIR', 'deployFrm', function(){ tableSort(); });"><mink:message code="mink.web.text.dir"/></td>
								<td id="order_SIZE" class="order_by_column" onclick="orderBy('SIZE', 'deployFrm', function(){ tableSort(); });"><mink:message code="mink.web.text.size_byte"/></td>
								<td id="order_LOCALDT" class="order_by_column" onclick="orderBy('LOCALDT', 'deployFrm', function(){ tableSort(); });"><mink:message code="mink.web.text.lfile_date"/></td>
								<td id="order_REMOTEDT" class="order_by_column" onclick="orderBy('REMOTEDT', 'deployFrm', function(){ tableSort(); });"><mink:message code="mink.web.text.sfile_date"/></td>
								<td id="order_MODIFYUSER" class="order_by_column" onclick="orderBy('MODIFYUSER', 'deployFrm', function(){ tableSort(); });"><mink:message code="mink.web.text.finalmodifier"/></td>
								<td id="order_MODIFYDT" class="order_by_column" onclick="orderBy('MODIFYDT', 'deployFrm', function(){ tableSort(); });"><mink:message code="mink.web.text.finalmodifydate"/></td>
								<td>비교</td>
							</tr>
						</thead>
						<tbody id="listTbody">
							<c:if test="${empty diffList}">
								<tr><td colspan="10"><mink:message code='mink.web.text.noexist.result'/></td></tr>
							</c:if>
						</tbody>
					</table>
				</div>
			</form>
		</div>
		<!-- footer -->
		<div id="deploy-footer">
			<%--@ include file="/WEB-INF/jsp/include/footer.jsp" --%>			
		</div>
	</div>
	<!-- 로딩 이미지 -->
	<div id="loading" class="loading"></div><img id="loading_img" alt="loading" src="${contextURL}/asvc/images/loading.gif" />	
</body>
<script type="text/javascript">
function changeContentAreaSize() {
	/* top */
	var mtbH = $("#deploy-top-buttons").css("height");
	//console.log("miaps-top-btn height: " + mtbH);
	if (null == mtbH) { /* 탑버튼영역 없음 */
		$("#deploy-content").css("top", "75px");
	} else {
		var mtbH_val = mtbH.substr(0, mtbH.length - 2); // px제거
		//console.log("mtbH_val: " + mtbH_val);
		var mtbH_Num = Number(mtbH_val) + 75;
		
		$("#deploy-content").css("top", mtbH_Num + "px");
	}
}

function setDivHeight(objSet, objTar) {
	//objSet : 변경할 div id, objTar : height값을 구할 대상 div id
	var objSet = document.getElementById(objSet); 
	var objTarHeight = document.getElementById(objTar).offsetHeight;
	objSet.style.height = objTarHeight + "px";
} 

function setOrderByUpDownDeploy(columnNm, ascDesc) {
	$("#order_ICON").html("<mink:message code='mink.web.text.info'/>");
	$("#order_FILE").html("<mink:message code='mink.web.text.file'/>");
	$("#order_DIR").html("<mink:message code='mink.web.text.dir'/>");
	$("#order_SIZE").html("<mink:message code='mink.web.text.size_byte'/>");
	$("#order_LOCALDT").html("<mink:message code='mink.web.text.lfile_date'/>");
	$("#order_REMOTEDT").html("<mink:message code='mink.web.text.sfile_date'/>");
	$("#order_MODIFYUSER").html("<mink:message code='mink.web.text.finalmodifier'/>");
	$("#order_MODIFYDT").html("<mink:message code='mink.web.text.finalmodifydate'/>");
	
	var title = $("#order_" + columnNm).html();
	var upDown = "";
	if ("ASC" == ascDesc) upDown = "▲";
	if ("DESC" == ascDesc) upDown = "▼";
	
	if (title.indexOf("▲") > -1 || title.indexOf("▼") > -1) {
		title = title.substring(0, title.length -1);
	}
	
	$("#order_" + columnNm).html(title + upDown);
}

//console.log(replace);

function tableSort() {
	var myTable = document.getElementById("deployTable"); 
	var replace = replacement(myTable); 
	var orderColumn = $("#deployFrm").find("input[name='ordColumnNm']").val();
	var orderType = $("#deployFrm").find("input[name='ordAscDesc']").val();

	setOrderByUpDownDeploy(orderColumn, orderType);
	
	console.log("column:"+orderColumn+ ", type:"+orderType);
				
	// orderColumn- 0:체크,1:아이콘,2:파일,3:폴더,4:크기,5:날짜(로컬),6:날짜(서버),7:최종수정자,8:비교
	if (orderColumn == 'ICON') {
		if (orderType == 'DESC') {
			replace.descending(1);					 
		} else {
			replace.ascending(1);
		}
	} else if (orderColumn == 'FILE') {
		if (orderType == 'DESC') {
			replace.descending(2); 
		} else {					
			replace.ascending(2);
		}
	} else if (orderColumn == 'DIR') {
		if (orderType == 'DESC') {
			replace.descending(3); 
		} else {					
			replace.ascending(3);
		}
	} else if (orderColumn == 'SIZE') {
		if (orderType == 'DESC') {
			replace.descending(4); 
		} else {					
			replace.ascending(4);
		}
	} else if (orderColumn == 'LOCALDT') {
		if (orderType == 'DESC') {
			replace.descending(5); 
		} else {					
			replace.ascending(5);
		}
	} else if (orderColumn == 'REMOTEDT') {
		if (orderType == 'DESC') {
			replace.descending(6); 
		} else {					
			replace.ascending(6);
		}
	} else if (orderColumn == 'MODIFYUSER') {
		if (orderType == 'DESC') {
			replace.descending(7); 
		} else {					
			replace.ascending(7);
		}
	} else if (orderColumn == 'MODIFYDT') {
		if (orderType == 'DESC') {
			replace.descending(8); 
		} else {					
			replace.ascending(8);
		}
	}
	
}
/*
function sortTD(index) {
	replace.ascending( index );    
} 
function reverseTD(index) {
	replace.descending( index );    
} 
*/

function callDiffModule(fileNm, dirNm, event) {
	event.preventDefault();
	openFileDiffDlg(fileNm, dirNm);
}

function openDeployListDlg() {
	getDeployList();
}

function fileUpload() {
	if(!confirm("<mink:message code='mink.web.alert.is.upload'/>")) return;
	
    ajaxFileComm('fileUploadView.miaps', $("#deployFrm"), function(data){
    	if (data.msg == undefined) {
    		alert("<mink:message code='mink.web.alert.fail.regist'/>");
    	} else {
    		alert(data.msg);
    		ajaxFileComm('fileDiffView.miaps', $("#deployFrm"), function(data){
    			if (data.msg != null) {
    				alert(data.msg);	
    			} else {
    				renderDiffFileList(data);	
    			}
    		});
    	}
    });
}

function fileDownload() {
	if(!confirm("<mink:message code='mink.web.alert.is.download2'/>")) return;
	
    ajaxFileComm('fileDownloadView.miaps', $("#deployFrm"), function(data){
    	if (data.msg == undefined) {
    		alert("<mink:message code='mink.web.alert.fail.download'/>");
    	} else {
    		alert(data.msg);
    		ajaxFileComm('fileDiffView.miaps', $("#deployFrm"), function(data){
    			if (data.msg != null) {
    				alert(data.msg);	
    			} else {
    				renderDiffFileList(data);	
    			}
    		});
    	}
    });
}

function numberWithCommas(number) {
	return number.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function renderDiffFileList(data) {
	var diffList = data.diffList;
	//console.log(data);
	//console.log(data.diffList);
	$('#listTbody').html("");
	var resultHtml = "";
	
	if(diffList.length == 0) {
		resultHtml = "<tr><td colspan='10' style='text-align:center;'><mink:message code='mink.web.text.noexist.result'/></td></tr>";
	} else {
		
		for(var i=0; i<diffList.length; i++) {
			var dto = diffList[i];

			resultHtml += "<tr id='listTr" + dto.FILENM + "' onclick=\"javascript:clickListTr(this, event)\">";
			resultHtml += "<td><input type='checkbox' style='width:20px;height:20px;' name='chkFiles' value='" + dto.DIRNM + "^" + dto.FILENM + "^" + dto.COMPDATA_LOCAL + "^" + dto.COMPDATA_REMOTE + "' onclick='checkedCheckboxInTr(event)' /></td>";
			
			if ((dto.COMPDATA_LOCAL != null && dto.COMPDATA_LOCAL != "") && 
					((parseInt(dto.COMPDATA_LOCAL) > parseInt(dto.COMPDATA_REMOTE)) || dto.COMPDATA_REMOTE == null || dto.COMPDATA_REMOTE == '')
				) {
				resultHtml += "<td><img src='${contextURL}/asvc/images/ds_upload_to_cloud-48.png' width='24px' height='24px' alt='aaa'></td>";
			} else  if ((dto.COMPDATA_LOCAL != null && dto.COMPDATA_LOCAL != "") && (parseInt(dto.COMPDATA_LOCAL) < parseInt(dto.COMPDATA_REMOTE))) {
				resultHtml += "<td><img src='${contextURL}/asvc/images/ds_up_download_from_cloud-48.png' width='24px' height='24px' alt='bbb'></td>";
			} else if (dto.COMPDATA_LOCAL == null || dto.COMPDATA_LOCAL == "") {
				resultHtml += "<td><img src='${contextURL}/asvc/images/ds_download_from_cloud-48.png' width='24px' height='24px' alt='ccc'></td>";
			} else {
				resultHtml += "<td>-</td>";
			}

			resultHtml += "<td align='left' class='order_by_column'>" + dto.FILENM + "</td>";
			resultHtml += "<td align='left'>" + dto.DIRNM + "</td>";
			resultHtml += "<td align='right'>"+ numberWithCommas(dto.SIZE) + "</td>";
			resultHtml += "<td>" + dto.LOCALDT + "</td>";
			resultHtml += "<td>" + dto.REMOTEDT + "</td>";
			if (typeof dto.UPLOADED_USER === 'undefined' || dto.UPLOADED_USER == '') {
				resultHtml += "<td></td><td></td>";				
			} else {
				resultHtml += "<td>" + dto.UPLOADED_USER + "</td>";
				resultHtml += "<td>" + dto.UPLOADED_DT + "</td>";
			}
			
			if (dto.LOCALDT != null && dto.LOCALDT != "" && dto.REMOTEDT != null && dto.REMOTEDT != "" && dto.LOCALDT != dto.REMOTEDT) {
				resultHtml += "<td><img src='${contextURL}/asvc/images/file_compare-40.png' width='24px' height='24px' onclick=\"javascript:callDiffModule('" + dto.FILENM + "','" + dto.DIRNM + "', event);\"></td>";
			} else {
				resultHtml += "<td></td>";
			}
			
			resultHtml += "</tr>";
		}
		
	}
	
	$('#listTbody').html(resultHtml);
	
	trs = document.getElementById('deployTable').tBodies[0].getElementsByTagName('tr');
}

function resourceUpdate() {
	if(!confirm("<mink:message code='mink.web.alert.is.resourceupdate'/>")) return;
	
	ajaxFileComm('manualResourceUpdateView.miaps', $("#deployFrm"), function(data){
    	if (data.msg == undefined) {
    		alert("<mink:message code='mink.web.alert.fail.resourceupdate'/>");
    	} else {
    		alert(data.msg);
    		
    		// 다시 비교
    		ajaxFileComm('fileDiffView.miaps', $("#deployFrm"), function(data){
    			renderDiffFileList(data);
    		});
    	}
    });
}

function refresh() {
	ajaxFileComm('fileDiffView.miaps', $("#deployFrm"), function(data){
		if (data.msg != null) {
			alert(data.msg);	
		} else {
			renderDiffFileList(data);	
		}
	});
}

<%-- 리스트 항목을 선택하면 체크되도록 한다. shiftkey를 누른채로 선택하면 범위선택이되도록한다. --%>
var lastSelectedRow;
var trs;
function clickListTr(_this, event) {
	event.preventDefault();
	if (event.shiftKey) {
		$(":checkbox:eq(0)", _this).prop("checked", true);		
    	selectRowsBetweenIndexes([lastSelectedRow.rowIndex, _this.rowIndex]);
    	lastSelectedRow = _this;
    } else {
    	lastSelectedRow = _this;
    	if ($(":checkbox:eq(0)", _this).is(":checked") == true) {
    		$(":checkbox:eq(0)", _this).prop("checked", false);		
    	} else {
    		$(":checkbox:eq(0)", _this).prop("checked", true);		
    	}
    }
	checkedTrCss(_this);
}

function selectRowsBetweenIndexes(indexes) {
	
	indexes.sort(function(a, b) {
        return a - b;
    });
    
    for (var i = indexes[0]; i <= indexes[1]; i++) {
    	$(":checkbox:eq(0)", trs[i-1]).prop("checked", true);
    	checkedTrCss($(trs[i-1]));
    }
}

function downloadZip() {
	if(!confirm("<mink:message code='mink.web.alert.fulldownload.zipfile'/>")) {
		return;
	}
	
	//document.deployFrm.action = 'resourceDownloadZip.miaps?';
	//document.deployFrm.submit();
	/*
	 * 2019.10.31 chlee
	 * 위 submit()삭제, 아래 로직으로 다시 구현 - 브라우저에서 다운로드 받는게 아니라 로컬경로에 파일을 직접 다운로드.
	 */
	 ajaxFileComm('resourceDownloadZip.miaps', $('#deployFrm'), function(data) {
		 if (data.msg == undefined) {
			 alert("<mink:message code='mink.web.alert.fail.download'/>");
		 } else {
			 alert(data.msg + "\nPlease check the downloaded file in your local path.");
		 }
	 });
}
</script>	
</html>	
