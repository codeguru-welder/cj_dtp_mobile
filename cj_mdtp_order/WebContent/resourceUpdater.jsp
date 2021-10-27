<%@ page language="java" pageEncoding="EUC-KR" contentType="text/html; charset=EUC-KR" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.FilenameFilter" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%
	// CONST VARIABLE
    // Edit File Path and Extension
    String FILEPATH = "C:/workspace/com.miaps.update.resource/jar"; // default
    String EXEC_FILENM = "updateresource.sh";	// default
	final String EXTENSION = "properties";
    
	String OS = System.getProperty("os.name").toLowerCase();
	if (OS.indexOf("win") >= 0) {
		EXEC_FILENM = "updateresource.bat";
	}
	
	String reqFilePath = request.getParameter("filePath");
	if (reqFilePath != null && !reqFilePath.equals("")) {
		FILEPATH = reqFilePath;
	}
	String reqExecFileNm = request.getParameter("execFileNm");
	if (reqExecFileNm != null && !reqExecFileNm.equals("")) {
		EXEC_FILENM = reqExecFileNm;
	}
	
%>

 <%
    // Resource Update Select Start
    String urlParam = request.getParameter("param");
    //String currentFilePath = request.getRealPath(request.getServletPath());
    // Resource Update Select End

    // Get Properties File List Start
    String fileTmp = FILEPATH;
    /*if (currentFilePath.startsWith("/")) {
        // Local Dev Env
        int lastSlash = currentFilePath.lastIndexOf("/");
        fileTmp = currentFilePath.substring(0, lastSlash);
    } else {
        // Miaps Beta 6 Server Env
        // General Windows Environment(like C: or D: Drive)
        fileTmp = FILEPATH;
    }*/

    // Find File List
    File path = new File(fileTmp + "/");
    String[] fileList = path.list(new FilenameFilter() {
        @Override
        public boolean accept(File dir, String name) {
            return name.endsWith(EXTENSION);
        }
    });
    // Lambda cannot be used because jdk is not 1.8
    // String[] fileList = path.list((dir, name) -> name.endsWith(EXTENSION));

    String fileStatus;
    List<Map<String, Object>> resList = new ArrayList<>();
    if (fileList != null) {
        int idx = 0;
        if (fileList.length > 0) {
            for (String fn : fileList) {
                Map<String, Object> fileMap = new HashMap<>();
                String fileAbPath = fileTmp + "/" + fn;
                fileMap.put("fileName", fn);
                fileMap.put("fileTmp", fileAbPath);
                // TODO: type(before extension word)
                String[] tmp = fn.split("\\.");
                fileMap.put("fileType", tmp[tmp.length - 2]
                        .equalsIgnoreCase("resource") ? "default" : tmp[tmp.length - 2]);
                resList.add(fileMap);
                idx++;
            }
        }
        fileStatus = "'." + EXTENSION + "' File Count : " + idx;
    } else {
        fileStatus = "No File!";
    }
    // Get Properties File List End
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no" name="viewport"/>
    <meta content="text/html; charset=UTF-8" http-equiv="Content-Type">

    <title>Resource Update Controller</title>
    <link rel="STYLESHEET" type="text/css" href="css/admincenter.css">
    <link rel="STYLESHEET" type="text/css" href="css/include.css">
    <link rel="STYLESHEET" type="text/css" href="js/tooltipster/tooltipster.css" />
	<link rel="STYLESHEET" type="text/css" href="js/tooltipster/themes/tooltipster-light.css" />
	<link rel="STYLESHEET" type="text/css" href="js/tooltipster/themes/tooltipster-shadow.css" />
     
	<style>
		body {
			margin: 0px;
		}
		.main_container {
			width:100%;
			height:100%;
			margin: 0px;
			min-width: 1024px;
		}
		.main_title {
			width:100%;
			height:70px;
			border: 0px solid #bcbcbc;
			background-color: #eef1f5;
			vertical-align: middle;
			float:left;
			border-bottom: 1px solid #bcbcbc;
		}
		.main_subtitle {
			width:100%;
			height:36px;
			border: 0px solid #bcbcbc;
			border-bottom: 1px solid #bcbcbc;
			vertical-align: middle;
			float:left;		
			font-weight: bold;
    		font-family: 'Arial', sans-serif;
    		font-size: 20px;
    		color: #44484cde;	
    		padding: 8px 0px 0px 10px;
		}
		.main_button_area {
			width:100%;
			height:40px;
			float:left;
			padding: 6px 12px 6px 12px;
			border: 0px;
			border-bottom: 1px solid #bcbcbc;	
			background-color: #fff;
		}
		.main_contents_area {
			width:100%;
			border: 0px solid #bcbcbc;
			float:left;
			border-bottom: 1px solid #bcbcbc;	
			background-color: #fff;
		}
		select {
			width: 300px;
			padding: .5em .5em;
			font-family: console;			
			border: dotted 1px #dedede;
			border-radius: 0px;			
		}
		textarea {
			width: 99%;
            resize: none;
            background-color: #FFF !important;
            margin: 10px 5px 10px 10px;
            overflow:visible;
            font-family: console, arial;  
   			font-size: 15px;
        }        
	</style>
</head>
<body>
<!-- 본문 -->
<div class="main_container">
	<div class="main_title">
    	<img src="asvc/images/hybrid_UpdateResouce_logo.png" border="0" style="padding: 15px 0px 0px 10px;">
		<div style="float: right; padding: 20px 15px 0 0; font: 12px Consoles;">icon by <a target="_blank" href="https://icons8.com">Icons8</a></div>
  	</div>
  	<div class="main_subtitle">
  		<div style="float: left; width: 200px;">Update Resource</div>
  		<div style="float: right; padding: 6px 20px 0 0; font-size:15px;">
  			<img src='asvc/images/folder-internet-40.png' width='22px' height='22px' alt='setting' style="vertical-align:middle;">&nbsp;
  				<span style="cursor: help;" class="tooltip" title="Req. parameter 'filePath'">Project Path:</span> <%=FILEPATH %>
  			&nbsp;<img src='asvc/images/run-command.png' width='22px' height='22px' alt='setting' style="vertical-align:middle;">&nbsp;
  				<span style="cursor: help;" class="tooltip" title="Req. parameter 'execFileNm'">Exec File: </span> <%=EXEC_FILENM %>
  		</div>
  	</div>
	<div class="main_button_area">
		<div style="float: left; width: 630px;">
			<label for="updateSelect">
                <select class="" id="updateSelect">
                    <c:forEach items="<%=resList%>" var="item" varStatus="i">
                        <option value="${item.fileName}">${item.fileName}</option>
                    </c:forEach>
                </select>
            </label>
		    <input type="radio" name="caseRd" value="zip"><span style="cursor: help;" class="tooltip" title="updateresource.zip파일을 생성 합니다.">Zip</span>
		    <input type="radio" name="caseRd" value="sync"><span style="cursor: help;" class="tooltip" title="프로젝트_dist폴더 기준으로 프로젝트 폴더의 파일을 동기화합니다.">Sync</span>
		    <input type="radio" name="caseRd" value="none" checked><span>None</span>
		</div>
		<div style="float: right; padding: 6px 20px 0 0;">
			<span><button id="uptBtn" class='btn-dash'><img src='asvc/images/run-command.png' width='22px' height='22px' alt='setting' style="vertical-align:middle;">&nbsp;UpdateResouce</button></span>
			<span><button id="copyBtn" class='btn-dash'><img src='asvc/images/copy-to-clipboard-40.png' width='22px' height='22px' alt='upload' style="vertical-align:middle;">&nbsp;CopyToClipBoard</button></span>
		</div>
	</div>		
	<div class="main_contents_area" id="up-log" style="height: 200px;">
		 <textarea id="uptRes" rows="10" disabled>Click Update Button&#8599;</textarea>
	</div>
	<div class="main_subtitle">
		<div style="float: left; width: 200px;">Properties File Edit</div>
		<div style="float: right; padding: 6px 20px 0 0; font-size:15px;">
			<div id="abPath" class="card-body pt-1">Loaded File Absolute Path :</div>
		</div>
  	</div>
	<div class="main_button_area">
		<div style="float: left;">
            <label for="prop-select">
                <select id="prop-select" class="form-control">
                    <c:forEach items="<%=resList%>" var="item" varStatus="i">
                        <option value="${item.fileTmp}">${item.fileName}</option>
                    </c:forEach>
                </select>
            </label>
		</div>
		<div style="float: right; padding: 6px 20px 0 0;">
			<span><button id="loadBtn" class="btn-dash"><img src='asvc/images/show-property-48.png' width='22px' height='22px' alt='setting' style="vertical-align:middle;">&nbsp;Load Properties</button></span>
			<span><button id="saveBtn" class="btn-dash"><img src='asvc/images/save-40.png' width='22px' height='22px' alt='upload' style="vertical-align:middle;">&nbsp;Save Properties</button></span>			
		</div>
	</div>
	<div class="main_contents_area">		
		  <textarea id="prop-text" rows="20" style="resize:vertical;" disabled></textarea>
	</div>
</div>
</body>

<script type="text/javascript" src="js/jquery/jquery-1.10.2.js"></script>
<script type="text/javascript" src="js/tooltipster/jquery.tooltipster.min.js"></script>
<script type="text/javascript">
	$(function() {
    	initBtn();
 	});
  
  /**
   * Ajax Callback Function
   */
	window._cb = {
    	cbSave: function () {
      		alert("File Save Success")
    	},
		cbUpdate: function (data) {
			data = data.replace('/<br>/gi', '')
			$('#uptRes').val(stringTrim(data))
		  	$('#uptBtn').attr('disabled', false)
		  	$('#copyBtn').attr('disabled', false)
		},
		cbLoad: function (data) {
		  	var ta = $('#prop-text')
		  	ta.attr("disabled", false)
		  	ta.val(stringTrim(data))
		}
  	}

  	function initBtn() {
    	/**
    	 *Update Resource Button Function
    	 */
    	$('#uptBtn').on('click', function () {
			$('#uptBtn').attr('disabled', true)
			$('#copyBtn').attr('disabled', true)
			$('#uptRes').val("Please Waiting...")
			
			var exec = '<%=FILEPATH%>' + '/' + '<%=EXEC_FILENM%>';
			
			sendData({
        		"method": "update",
        		"type": $('#updateSelect').val(),
    			"case": $('input[name="caseRd"]:checked').val(),
    			"exec": exec
      		},_cb.cbUpdate);
		});
    	
	    /**
	     * Load Properties Button Function
	     */
	    $('#loadBtn').on('click', function () {
	      $('#prop-text').val("")
	
	      var selectedFilePath = $('#prop-select').val()
	      $('#abPath').text("Loaded File Absolute Path : \n" + selectedFilePath)
	      sendData({
	            "method": "load",
	            "fileName": selectedFilePath
	          },_cb.cbLoad)
	    })
	
	    /**
	     * Save Properties Button Function
	     */
	    $('#saveBtn').on('click', function () {
	      var selFile = $('#prop-select')
	      var yn = confirm(
	          'Do you want to save "' + $('#prop-select option:selected').text() + '"?')
	      if (yn === true) {
	        sendData(
	            {
	              "method": "save",
	              "fileName": selFile.val(),
	              "fileData": stringTrim($('#prop-text').val())
	            },
	            _cb.cbSave
	        )
	      }
    })

    $('#copyBtn').on('click', function () {
      var logText = $('#uptRes')
      logText.attr('disabled', false)
      logText.select()
      document.execCommand("copy")
      logText.attr('disabled', true)
      alert("Log Copied")
    })
  }

  function sendData(param, cbFunc) {
    $.ajax({
      type: 'post',
      url: './resourceController.jsp',
      data: param,
      success: function (data) {
        if (cbFunc != null) {
          cbFunc(data)
        }
      },
      error: function (error) {
        alert("Send Fail\n" + error)
      }
    })
  }

  function stringTrim(data) {
    // Modify the issue where the first letter in the file appears as "?"
    if (/^\?/.exec(data)) {
      data = data.replace("?", "")
    }
    // trim last \n char
    if (data.endsWith("\n")) {
      while (data.length !== 0) {
        if (data.endsWith("\n")) {
          data = data.substring(0, data.length - 1);
        } else {
          break;
        }
      }
    }
    return data
  }
</script>

</html>