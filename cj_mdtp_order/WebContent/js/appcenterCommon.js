$(document).ready(function() {
	
	//window.onorientationchange = function() { hideAdBar(); };

	function hideAdBar(){
	    setTimeout("scrollTo(0,1)", 100);
	}
	
	setWebAppIcon();
});

function getContextPath(){
    var offset = window.location.href.indexOf(window.location.host) + location.host.length;
    var ctxPath = window.location.href.substring(offset, location.href.indexOf('/', offset + 1));
    return ctxPath;
}

function getHostContextPath() {
	return window.location.hostname + ":" + location.port + getContextPath();
}

function setWebAppIcon() {
	
	var css = window.document.createElement("link");
    css.rel = "apple-touch-icon-precomposed";
    css.href = "http://" + getHostContextPath() + "/app/images/appCenterIcon.png";
    
//  if(userAgent.match('iphone') || userAgent.match('ipod')) {
//  ;
//} else if(userAgent.match('ipad')) {
//  //css.sizes="72*72";        
//} else if(userAgent.match('android')) {
//  css.rel="shortcut icon";
//  css.href="/mobile/image/favicon.ico";
//} else {
// css.rel="shortcut icon";
// css.href="/mobile/image/favicon.ico";
//}
    document.getElementsByTagName('head').item(0).appendChild(css);
}


// ajax
function ajaxComm(url, frm, fnCallback) {
	$.post(url, $(frm).serialize(), fnCallback, 'json');
}

// 값이 비었다면 원래 값으로 돌려 놓음
function emptyText(inputText) {
	var text = $(inputText).val();
	$(inputText).select(); // text 가 전체 선택된 상태로 만듬(수정하기 편하게끔)
	
	$(inputText).blur(function(){ // 포커스 아웃인 경우
		if(this.value == '') this.value = text; // 값이 비었다면 원래 값으로 돌려 놓음
	});
}

// 값이 비었다면 '0' 으로 반환 
function emptyToZero(num) {
	if(null == num) num = '0';
	else if('' == num) num = '0';
	return num;
}

// 오늘 날짜 반환 'yyyy-mm-dd'
function getToday() {
	var nowday = new Date(); // 현재 날짜와 시간을 가져오는 함수
	var year = nowday.getFullYear() ; // 연도를 가져오는 함수
	var month= nowday.getMonth() + 1 ; // 월을 가져오는 함수
	var date = nowday.getDate(); // 날짜를 가져오는 함수
	
	if(month < 10) month = '0' + month;
	if(date < 10) date = '0' + date;
	
	return year + '-' + month + '-' + date;
}

// 오늘 날짜/시간 반환 'yyyy-mm-dd hh:mm:ss'
function getTodayTime() {
	var nowday = new Date(); // 현재 날짜와 시간을 가져오는 함수
	var year = nowday.getFullYear(); // 연도를 가져오는 함수
	var month = nowday.getMonth() + 1; // 월을 가져오는 함수
	var date = nowday.getDate(); // 날짜를 가져오는 함수
	var hour = nowday.getHours(); // 시를 가져오는 함수
	var minutes = nowday.getMinutes(); // 분을 가져오는 함수
	var seconds = nowday.getSeconds(); // 초를 가져오는 함수
	
	if(month < 10) month = '0' + month;
	if(date < 10) date = '0' + date;
	if(hour < 10) hour = '0' + hour;
	if(minutes < 10) minutes = '0' + minutes;
	if(seconds < 10) seconds = '0' + seconds;
	
	return year + '-' + month + '-' + date + ' ' + hour + ':' + minutes + ':' +seconds;
}

// controller 결과 메시지 출력
function resultMsg(msg) {
	if( msg != null && msg != "" ) alert(msg);
}

// date format(YYYY-MM-DD)으로 String return
function toDateFormatString(str) {
	if( str != null && str != "" && str.length >= 10 ) {
		str = str.substring(10, 0);
	} 
	return str;
}

// 숫자만 입력
// 사용법: onkeypress="return keyPressNum(event)"
function keyPressNum(evt)
{
	var code = evt.which?evt.which:event.keyCode;
	if(code < 48 || code > 57){
		return false;
	}
}

// 빈값 체크
function nvl(str) {
	if( str == null ) str = "";
	return str;
}

// isEmpty 비교해서 "()" 로 셋팅
function setBracket(str) {
	if( str == null ) str = "";
	if( str != "" ) str = "("+str+")";
	return str;
}

// 페이지 하단으로 이동
function goToBottomPage(document, time) {
	//$('html, body').animate({ scrollTop: $(document).height(), duration: 0 }); // 페이지 하단으로 이동
	$('body,html').animate({scrollTop: $(document).offset().top}, time);
	//$('body,html').animate({scrollTop: $(document).offset().top}); // 곧바로 이동
}

// &lt;(<) &#39;(') 등의 HTML 의 특수문자를 태그로 변환
function htmlEscape(value){
	return $('<div/>').html(value).text();
}

// 특수문자 전체 변환
function htmlEscapeAll(document) {
	$(":text, textarea", document).each(function(){
		$(this).val(htmlEscape($(this).val())); // &lt;(<) &#39;(') 등의 HTML 의 특수문자를 태그로 변환
	});
}

// 문자 앞/뒤 공백제거
function trim(str) {
    return str.replace(/(^\s*)|(\s*$)/, ""); // 공백제거 정규식
}
