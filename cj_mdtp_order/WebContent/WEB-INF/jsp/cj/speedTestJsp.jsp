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


<script type="text/javascript" src="${contextPath}/cj/jquery/jquery.min.js"></script>
<script type="text/javascript" src="${contextPath}/cj/miaps/js/miaps_hybrid.js"></script>
<script type="text/javascript" src="${contextPath}/cj/miaps/js/miaps_simple_modal.js"></script>

</head>
<body>
	<!-- Just an image -->
	<nav class="navbar navbar-light bg-light">
	  <a class="navbar-brand" href="javascript:window.history.back();">
	    <img src="${contextPath}/cj/resource/img/title_before.png" width="30" height="30" alt="">&nbsp;JSP
	  </a>
	</nav>
  <div class="container" id="img-list">
  	<%-- 목록이 있을 경우 --%>
	<c:forEach var="dto" items="${imgList}" varStatus="status">
	<div class="row">
        <div class="col">
              <div class="card">
                <img
                  src="${contextPath}/cj/resource/img/${dto.imgFileNm}"
                  class="card-img-top"
                  alt="..."
                />
                <div class="card-body">
                  <h5 class="card-title">${dto.title}</h5>
                  <p class="card-text">
                    ${dto.text}
                  </p>
                  <a href="#!" class="btn btn-primary">Detail</a>
                </div>
              </div>
        </div>      
      </div>
      <br/>
	</c:forEach>
  </div>
  
   <script type="text/javascript">
      	var et = (new Date()).getTime();
		miaps.mobile({
			type: 'loadvalue',
			param: ['startdt']
		}, function(data) {
			var obj = miaps.parse(data);
			var res = et - obj.res.startdt;
			showModal(res+"ms", 'ok', null);
		});
	</script>
</body>
</html>