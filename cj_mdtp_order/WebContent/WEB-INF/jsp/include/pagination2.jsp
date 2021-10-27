<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page session="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="mink" uri="/WEB-INF/tld/mink.tld" %>
<%@ page import = "com.thinkm.mink.commons.util.DateUtil" %>

<script type="text/javascript">

/** 페이징 조건 재설정 후 페이징 html 생성  
 * data : ajax 결과 data
 * pagingDivId : 페이징이 출력될 위치의 div명
 * functionNm : 페이지 클릭 시 불러올 목록을 조회할 함수명
 */
function showPageHtml2(data, pagingDivId, functionNm) {
	
	var search = data.search;
	
	pageCount = parseInt(emptyToZero(search.pageCount));
	startPage = parseInt(emptyToZero(search.startPage));
	endPage = parseInt(emptyToZero(search.endPage));
	pageNum = parseInt(emptyToZero(search.pageNum));
	currentPage = parseInt(emptyToZero(search.currentPage));
	count = parseInt(emptyToZero(search.count));
	pageSize = parseInt(emptyToZero(search.pageSize));
	pageGroupSize = parseInt(emptyToZero(search.pageGroupSize));
	numPageGroup = parseInt(emptyToZero(search.numPageGroup));
	pageGroupCount = parseInt(emptyToZero(search.pageGroupCount));
	number = parseInt(emptyToZero(search.number));
	
	var pageHtml = "<input type=\"hidden\" name=\"currPage\" value=\""+currentPage+"\" />";
	pageHtml += "<div class=\"paginateDivSub\">";
	
	if(count > 0) {
		// 페이징 html 생성
		var beforePageNum = (numPageGroup - 2) * pageGroupSize + 1;
		var afterPageNum = numPageGroup * pageGroupSize + 1;
		
		if(numPageGroup > 1) pageHtml += "<a href=\"javascript:"+functionNm+"('"+beforePageNum+"');\">이전</a>";
		for(var i = startPage; i <= endPage; i++) {
			pageHtml += "<a href=\"javascript:"+functionNm+"('"+i+"');\">";
			if(currentPage == i) {
				pageHtml += "<font color=\"#1c7cfe\"> "+i+" </font>";
			} else {
				pageHtml += "<font color=\"#000000\"> "+i+" </font>";
				
			}
			pageHtml += "</a>";
		}
		if(numPageGroup < pageGroupCount) pageHtml += "<a href=\"javascript:"+functionNm+"('"+afterPageNum+"');\">다음</a>";
	} 
	
	pageHtml += "</div>";
	// html 삽입
	pagingDivId.html(pageHtml);
	
	// TODO: 처음에 중앙정렬되지 않는 문제있음
	// html 중앙정렬
	<%--
	var paginateDivWidth = 0;
	pagingDivId.each(function(){ // .paginateDiv
		paginateDivWidth = (parseInt($(this).width()) / 2);
		$( this ).css("margin-left", -paginateDivWidth); // margin-left의 값을 정렬하려는 div 의 넓이값/2 나누고 - 값을 입력.
	});
	--%>
	
}

</script>
