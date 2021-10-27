<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page session="false"%>

<!-- start paging -->
<script type="text/javascript">
var pageCount = parseInt(emptyToZero('${search.pageCount}'));
var startPage = parseInt(emptyToZero('${search.startPage}'));
var endPage = parseInt(emptyToZero('${search.endPage}'));
var pageNum = parseInt(emptyToZero('${search.pageNum}'));
var currentPage = parseInt(emptyToZero('${search.currentPage}'));
var count = parseInt(emptyToZero('${search.count}'));
var pageSize = parseInt(emptyToZero('${search.pageSize}'));
var pageGroupSize = parseInt(emptyToZero('${search.pageGroupSize}'));
var numPageGroup = parseInt(emptyToZero('${search.numPageGroup}'));
var pageGroupCount = parseInt(emptyToZero('${search.pageGroupCount}'));
var number = parseInt(emptyToZero('${search.number}'));

// 페이징 html 생성
function showPageHtml() {
	var pageHtml = "";
	
	if(count < 1) return pageHtml;
	
	// 페이징 html 생성
	var beforePageNum = (numPageGroup - 2) * pageGroupSize + 1;
	var afterPageNum = numPageGroup * pageGroupSize + 1;
	
	if(numPageGroup > 1) pageHtml += "<a href=\"javascript:goList('"+beforePageNum+"');\">이전</a>";
	for(var i = startPage; i <= endPage; i++) {
		pageHtml += "<a href=\"javascript:goList('"+i+"');\">";
		if(currentPage == i) {
			pageHtml += "<font color=\"#1c7cfe\"> "+i+" </font>";
		} else {
			pageHtml += i;
			
		}
		pageHtml += "</a>";
	}
	if(numPageGroup < pageGroupCount) pageHtml += "<a href=\"javascript:goList('"+afterPageNum+"');\">다음</a>";
	
	// html 삽입
	$(".paginateDivSub").html(pageHtml);
	
	<%--
	// html 중앙정렬
	var paginateDivWidth = 0;
	$( ".paginateDivSub" ).parent("div").each(function(){ // .paginateDiv
		paginateDivWidth = (parseInt($(this).width()) / 2);
		$( this ).css("margin-left", -paginateDivWidth); // margin-left의 값을 정렬하려는 div 의 넓이값/2 나누고 - 값을 입력.
	});
	--%>
}
</script>
<!-- end paging -->