<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<link rel="stylesheet" href="${contextPath}/cj/bootstrap/css/bootstrap4.min.css">
<link rel="stylesheet" href="${contextPath}/cj/miaps/css/miaps.css">
<link rel="stylesheet" href="${contextPath}/cj/resource/css/empty-skeleton.css">

<script type="text/javascript" src="${contextPath}/cj/jquery/jquery.min.js"></script>
<script type="text/javascript" src="${contextPath}/cj/miaps/js/miaps_hybrid.js"></script>
<script type="text/javascript" src="${contextPath}/cj/miaps/js/miaps_simple_modal.js"></script>
<script type="text/javascript" src="${contextPath}/cj/handlebars/handlebars-4.0.11.js"></script>
<script type="text/javascript" src="${contextPath}/cj/polyfill/polyfill.js"></script>

</head>
<body>
   <!-- Just an image -->
	<nav class="navbar navbar-light bg-light">
	  <a class="navbar-brand" href="javascript:window.history.back();">
	    <img src="${contextPath}/cj/resource/img/title_before.png" width="30" height="30" alt="">&nbsp;SPA Multi
	  </a>
	</nav>
  <div class="container" id="img-list">
  	<div class="row">
        <div class="col">
              <div class="card">
               <div class="skeleton-screen"></div>
                <div class="card-body">
                  <h5 class="card-title"><div class="skeleton_title"></div></h5>
                  <p class="card-text">
                    <div class="skeleton_detail_content"></div>
                  </p>
                  <a href="#!" class="btn btn-secondary">Detail</a>
                </div>
              </div>
        </div>      
      </div>
      <br/>
      <div class="row">
        <div class="col">
              <div class="card">
               <div class="skeleton-screen"></div>
                <div class="card-body">
                  <h5 class="card-title"><div class="skeleton_title"></div></h5>
                  <p class="card-text">
                    <div class="skeleton_detail_content"></div>
                  </p>
                  <a href="#!" class="btn btn-secondary">Detail</a>
                </div>
              </div>
        </div>      
      </div>
  </div>

 <script type="text/javascript">
 	var callback = {
 		drawCard : function(data) {
 			var obj = miaps.parse(data);
 			
			if (obj.code == 200) {
				var source = $('#list-template').html();
				var template = Handlebars.compile(source);
				var resobjdata = { datas: obj.imgList };
				var html = template(resobjdata);
				
				if($("img").length == 1) {
					$("#img-list").html("");					
				}
				$("#img-list").append(html);
			} else {
				//생성된 HTML을 DOM에 주입
				$("#img-list").html("");
				$("#img-list").append("에러가 발생했습니다.");
			}
 		}
 	}
 	window._cb = callback;
 	
 	Promise.all([ 
	  	$.post("getImageList.miaps", {
		  		"type":"none",
				"startRow":"1",
				"endRow":"4"
			},	_cb.drawCard),
	  	
	  	$.post("getImageList.miaps", {
	  		"type":"none",
			"startRow":"5",
			"endRow":"8"
		},	_cb.drawCard),
	  	
	  	$.post("getImageList.miaps", {
	  		"type":"none",
			"startRow":"9",
			"endRow":"12"
		},	_cb.drawCard),
	  	
	  	$.post("getImageList.miaps", {
	  		"type":"none",
			"startRow":"13",
			"endRow":"16"
		},	_cb.drawCard),
	  	
	  	$.post("getImageList.miaps", {
	  		"type":"none",
			"startRow":"17",
			"endRow":"20"
		},	_cb.drawCard),
	  	
	  	$.post("getImageList.miaps", {
	  		"type":"none",
			"startRow":"1",
			"endRow":"2"
		},	_cb.drawCard)
		
  	]).then(function(result) {		
		var et = (new Date()).getTime();
		miaps.mobile({
			type: 'loadvalue',
			param: ['startdt']
		}, function(data) {
			var obj = miaps.parse(data);
			var res = et - obj.res.startdt;
			showModal(res+"ms", 'ok', null);
		});
		
	}).catch(function(error) {
		alert(error);
		console.log(error);
	});
  	
  </script>
  <script type="text/x-handlebars-template" id="list-template">
    {{#datas}}
      <div class="row">
        <div class="col">
              <div class="card">
                <img
                  src="${contextPath}/cj/resource/img/{{imgFileNm}}"
                  class="card-img-top"
                  alt="..."
                />
                <div class="card-body">
                  <h5 class="card-title">{{title}}</h5>
                  <p class="card-text">
                    {{text}}
                  </p>
                  <a href="#!" class="btn btn-primary">Detail</a>
                </div>
              </div>
        </div>      
      </div>
      <br/>
    {{/datas}}
  </script>
</body>
</html>