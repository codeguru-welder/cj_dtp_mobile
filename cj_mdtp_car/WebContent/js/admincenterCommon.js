var bToggle = "hide";

$(document).ready(function() {
	/* contents영역 리사이즈 */
	var sidebar_display;
	var sidebar_toggle = $.cookie("sidebar_toggle");
	//console.log("get cookie value:" + sidebar_toggle);
	if (sidebar_toggle == null) {
		sidebar_display = $("#miaps-sidebar").css("display");		
	} else {
		sidebar_display = sidebar_toggle;
	}
	$.cookie("sidebar_toggle", sidebar_display, { path: '/', expires: 10 }); // none or block
	
	if ("none" == sidebar_display) {
		$("#miaps-sidebar").css("display", "none");
		bToggle = "hide";
	} else {
		bToggle = "show";
	}
	//console.log("첫번째 bToggle: " + bToggle);
	
	$(window).resize( changeContentAreaSize );
	changeContentAreaSize();
	//////////////////////////////////////////

	//checkbox 전체선택, 전체해제
	clickCheckboxAll();
	
	// Enter 이벤트
	enterEvent();
	searchEnter();
	
	// 달력 달기
	$( ".datepicker" ).datepicker();

	// ajax 시작시 로딩바 실행
	$(window).ajaxStart(function() {
		showLoading();
	});
	// ajax 끝나고 로딩바 숨김
	$(window).ajaxStop(function() {
		hideLoading();
	});
	// ajax 오류시 알림
	$(window).ajaxError(function( event, jqxhr, settings, exception ) {
		//console.log(jqxhr);  
		/* /asvc/common/commonErrorView.jsp 응답내용중에서 화면에 표시할 메시지만 잘라내서 표시한다. */ 
		/* SessionFilter에서 세션만료시도 아래와 같이 리턴된다
		<script>alert('보안을 위하여 다시 로그인해 주시기 바랍니다.'); location.href='"+fullUrl+"';</script>"
		 miaps결과로 리턴되면 jsp대신 호출되어 alert이 표시되지만, ajax로 호출 시 표시되지 않으므로 수정. 2020.07.23 chlee
		 */
		var errmsg = jqxhr.responseText;
		if (errmsg != undefined && errmsg != '') { // java 소스에러가 아닐경우(WAS또는WEB) errmsg가 undefined임. 꼭 체크
			var msgidx = errmsg.indexOf("_errmsg"); // <span class="err-font" id="_errmsg"><mink:message code="mink.web.error.request"/></span>
			if (msgidx > -1) {
				var _msg = errmsg.substring(msgidx + 9, errmsg.indexOf("</span>", msgidx));
				alert(_msg);
				return;
			}
			
			msgidx = errmsg.indexOf("<script>alert"); // <script>alert('보안을 위하여 다시 로그인해 주시기 바랍니다.'); location.href='"+fullUrl+"';</script>"
			if (msgidx > -1) {
				var _commtIdx = errmsg.indexOf("');");
				var _msg = errmsg.substring(15, _commtIdx);
				var _page = errmsg.substring(_commtIdx + 19, errmsg.indexOf("';</script>"));
				
				alert(_msg);
				location.href = _page;
			}
		} else {
			alert('jqxhr: ' + JSON.stringify(jqxhr) + '\nexception: ' + exception);
		}
	});	
});

function sideMenuToggleCallback() {
	
	var tmp_sidebar_display = $("#miaps-sidebar").css("display");
	$.cookie("sidebar_toggle", tmp_sidebar_display); // none or block
	//console.log("set and get cookie value:" + $.cookie("sidebar_toggle"));
	
	if (bToggle == 'show') {
		$("#miaps-top-buttons").css("width", "100%");
		$("#miaps-top-buttons").css("left", "0px");
		
		$("#miaps-content").css("width", "100%");
		$("#miaps-content").css("left", "0px");
		
		bToggle = "hide";
		//console.log("show--->hide");
		
	} else {
		$("#miaps-top-buttons").css("left", "245px");
		$("#miaps-content").css("left", "245px");
		
		bToggle = "show";
		//console.log("hide--->show");
		
		changeContentAreaSize();
	}			
}

function changeContentAreaSize() {
	var innerW = "100%";
	if (bToggle != null && bToggle == "show") {
		//console.log("show - resize");
		innerW = window.innerWidth - 280;
		/* miaps-sidebar를 기본 display:none으로 설정하고 여기서 표시하도록 한다.(사이드바가 없고 일반적인 호출로 페이지를 이동하면(비동기X) 페이지를 다시 불러오는데 이때 사이드바가 표시되었다가 사라지는 현상때문에 이렇게 처리함.) */
		$("#miaps-sidebar").css("display","block");
	} else {
		//console.log("hide - resize");
		$("#miaps-top-buttons").css("left", "0px");
		$("#miaps-content").css("left", "0px");
	}
	
	//if (innerW != "100%") {
	//	$("#miaps-top-buttons").css("width", innerW + 0); /* 버튼탑 영역은 z-index를 설정하여 스크롤되지 않게 하였는데 width사이즈가 작으면 아래의 컨텐츠영역이 스크롤될때 일부분이 보이므로 길이를 추가한다. */
	//} else {
		$("#miaps-top-buttons").css("width", innerW);
	//}
	$("#miaps-content").css("width", innerW);

	
	/* top */
	var mtbH = $("#miaps-top-buttons").css("height");
	//console.log("miaps-top-btn height: " + mtbH);
	if (null == mtbH) { /* 탑버튼영역 없음 */
		$("#miaps-content").css("top", "75px");
	} else {
		var mtbH_val = mtbH.substr(0, mtbH.length - 2); // px제거
		//console.log("mtbH_val: " + mtbH_val);
		var mtbH_Num = Number(mtbH_val) + 75;
		
		$("#miaps-content").css("top", mtbH_Num + "px");
	}
}

// 이벤트 핸들러 세팅
function init() {
	// 처음 실행시 로딩바 숨김
	hideLoading();
}

// 로딩바 실행
function showLoading() {
	$("#loading").show();
	$("#loading_img").show();
}

// 로딩바 숨김
function hideLoading() {
	$("#loading").hide();
	$("#loading_img").hide();
}

// ajax
function ajaxComm(url, frm, fnCallback) {
	$.post(url, $(frm).serialize(), fnCallback, 'json');
}

/* 공통 ajax file
 * url: ajax submit url
 * frm: submit form (include Files)
 * fnCallback: function after ajax
*/
function ajaxFileComm(url, frm, fnCallback) {

	/* ADD FILE TO PARAM AJAX */
	var formData = new FormData();
    $.each($(frm).find("input[type='file']"), function(i, tag) {
        $.each($(tag)[0].files, function(i, file) {
            formData.append(tag.name, file);
        });
    });
    
    /* ADD INFO TO PARAM AJAX */
    var params = $(frm).serializeArray();
    $.each(params, function (i, val) {
        formData.append(val.name, val.value);
    });
    
	$.ajax({
	    url: url,
	    data: formData,
	    cache: false,
	    contentType: false,
	    processData: false,
	    type: 'POST',
	    success: fnCallback
	});
}

// 상세 ajax 세부작업
function fnDetailProcess(dto) {
	fnAjaxInfoMapping(dto); // ajax 로 가져온 data 를 알맞은 위치에 삽입
	showDetail(); // 상세 보이기
}

// 목록 보이기
function showList() {
	if($("#listTbody").find("tr").length < 1) { // 목록이 없을 경우
		$("#listTfoot").show(); // '결과가 없습니다' 보이기
		$("#listTbody").hide();
	} else { // 목록이 있을 경우
		$("#listTfoot").hide(); // '결과가 없습니다' 숨기기
		$("#listTbody").show();
	}
}

// 등록 보이기
function showInsert() {
	if($("#insertDiv").is(":hidden")) {
		$("#insertDiv").show();
		$("#detailDiv").hide(); // 상세 숨기기
	} 
	
	$('#insertFrm')[0].reset();	// form 초기화
	
	//goToBottomPage(document); // 페이지 하단으로 이동
}

// 상세 보이기
function showDetail() {
	$("#detailDiv").show();
	$("#insertDiv").hide(); // 등록 숨기기
	
	//goToBottomPage(document); // 페이지 하단으로 이동
}

// 등록/수정 숨기기
function hiddenInsertDetail() {
	$("#insertDiv").hide(); // 등록 숨기기
	$("#detailDiv").hide(); // 수정 숨기기
	
	$('#app_detail_mask, .app_detail_window').hide();
	//$('#version_detail_mask, .version_detail_window').hide();
}

// 검색 창에서 엔터친 경우, 검색 실행
function searchEnter() {
	$("input:text[name='searchValue']", "#searchFrm").on("keypress", function(event){
		if(event.which == 13){ // 엔터 이벤트
			$(event.target).parent().find("button:contains('검색'):last").trigger("click");
			return false;
		}
	});
}

// 선택한 tr 의 checkbox 에 체크선택
function checkedTrCheckbox(tr) {
	$(tr).parent("tbody").find(":checkbox").prop("checked", false);
	$(tr).find(":checkbox").prop("checked", true);
	
	$(tr).parent("tbody").find("tr").data("isCurrDetailTr", false);
	$(tr).data("isCurrDetailTr", true); // 현재 선택한 상세 tr 저장
	
	checkedTrCss(tr); // 선택한 tr 의 css 변경
}

// 선택한 checkbox 의 tr 에 css 변경(tr click 이벤트 막음)
function checkedCheckboxInTr(event) {
	cancelPropagation(event); // tr click 이벤트 막음
	
	var checkedTr = $(event.target).parent("td").parent("tr").get(0);
	checkedTrCss(checkedTr); // 선택한 tr 의 css 변경
}

// 선택한 checkbox 의 tr 에 css 변경 안 함(tr click 이벤트 막음)
function checkedCheckboxInTr_doNotChangedCSS(event) {
	var checkbox = $(event).get(0);
	if(checkbox.checked) checkbox.checked = false;
	else checkbox.checked = true;

	cancelPropagation(event); // tr click 이벤트 막음
	return;
}

// 선택한 tr 의 checkbox 에 체크선택
function checkboxOfTrToChecked(tr) {
	$(tr).find(":checkbox").prop("checked", true);
	checkedTrCss(tr); // 선택한 tr 의 css 변경
}

// 선택한 tr 의 css 변경
function checkedTrCss(tr) {
	var $allTr = $(tr).parent("tbody").find("tr:visible"); // 모든 rt
	transAllTrCss($allTr);
}

// tr 의 css 변경 // TODO:background color 변경
function transAllTrCss($allTr) {
	$allTr.each(function(i){
		/*if(i%2 == 0) $(this).css("background", "linear-gradient(to bottom, rgba(167,199,220,1) 0%,rgba(133,178,211,1) 100%)"); // 짝수 css 적용
		else $(this).css("background", "linear-gradient(to bottom, rgba(255,255,255,1) 0%,rgba(241,241,241,1) 50%,rgba(225,225,225,1) 51%,rgba(246,246,246,1) 100%)"); // 홀수 css 적용*/
		/*if(i%2 == 0) $(this).css("background-color", "#f2f2f2"); // 짝수 css 적용
		else $(this).css("background-color", "#ffffff"); // 홀수 css 적용*/
		$(this).css("background-color", "#ffffff");
		
		
		if($(this).find(":checkbox").is(':checked')) {
			/*$(this).css("background", "#FFFACD"); // 이미 check 된 css 적용*/
			$(this).css("background", "#b5f1e5"); // 이미 check 된 css 적용
		}
		
		if(true === $(this).data("isCurrDetailTr")) {
			/*$(this).css("background", "#FFD700"); // 선택한 css*/
			$(this).css("background", "#eaef9a"); // 선택한 css
		}
	});
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
	else alert("오류가 발생하였습니다.");
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

//푸시관리 트리뷰
function treeViewCreate() {
	$("#navigation").treeview({  
		animated:"fast"
 });
}

//checkbox 전체선택, 전체해제
function clickCheckboxAll() {
	$("input:checkbox[name*=CheckboxAll]").click(function(){
		var checkboxes = $(this).closest('table').find('tbody').find('tr').find(':eq(0)').find(':checkbox');
		if($(this).is(':checked')) {
	        checkboxes.prop("checked", true);
	        // 전체선택 색상변경
	        $(this).closest('table').find('tbody').find('tr').css("background", "#b5f1e5");
	    } else {
	    	checkboxes.prop("checked", false);
	        // 전체선택해제 색상변경
	        $(this).closest('table').find('tbody').find('tr').each(function(i){
	        	//if(i%2 == 0) $(this).css("background-color", "#f2f2f2"); // 짝수 css 적용
	    		//else $(this).css("background-color", "#ffffff"); // 홀수 css 적용
	        	$(this).css("background-color", "#ffffff");
	    	});
	    }
		
	});
}

// 목록선택시 체크박스 체크
function clickTrCheckedCheckbox(tr) {
	if ($(tr).find(":checkbox:eq(0)").get(0).checked) {
		$(tr).find(":checkbox:eq(0)").get(0).checked = false; // checkbox 해제
		$(tr).css("background", "#ffffff");
	} else {
		$(tr).find(":checkbox:eq(0)").get(0).checked = true; // checkbox 선택
		$(tr).css("background", "#b5f1e5");
	}
}

//Enter 이벤트
function enterEvent() {
	$("input:text", "form[name*=SearchFrm]").on("keypress", function(event){
		if (event.which == 13) {
			$(this).parents("form").find("button:contains('검색'):last").trigger("click");
			return false;
		}
	});

}

// isEmpty 비교해서 "()" 로 셋팅
function setBracket(str) {
	if( str == null ) str = "";
	if( str != "" ) str = "("+str+")";
	return str;
}

// div 숨기기
function hiddenTb(div) {
	$(div).hide(); // 등록 숨기기
	
	
	//$('#app_detail_mask, .app_detail_window').hide();
	$('#version_detail_mask, .version_detail_window').hide();
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

// 디폴트 정렬조건 표시
function setOrderByUpDown(columnNm, ascDesc) {
	var title = $("#order_" + columnNm).html();
	var upDown = "";
	if ("ASC" == ascDesc) upDown = "▲";
	if ("DESC" == ascDesc) upDown = "▼";
	
	$("#order_" + columnNm).html(title + upDown);
}

// 정렬조건 검색
function orderBy(columnNm, frmId, callbackFn) {
	var preColumnNm = $("#" + frmId).find("input[name='ordColumnNm']").val();
	var preAscDesc = $("#" + frmId).find("input[name='ordAscDesc']").val();
	
	var ascDesc = "ASC";
	if (columnNm == preColumnNm) {
		if (ascDesc == preAscDesc) {
			ascDesc = "DESC";
		}
	}
	
	$("#" + frmId).find("input[name='ordColumnNm']").val(columnNm);
	$("#" + frmId).find("input[name='ordAscDesc']").val(ascDesc);
	
	callbackFn(); //goList('1');
}

//yyyyMMddHHmmss ==> yyyy-MM-dd
function getDateFmt(date) {
	var d = nvl(date);
	if (d.length < 14) return d;
	return d.substring(0, 4) + "-" + d.substring(4, 6) + "-" + d.substring(6, 8);
}

//yyyyMMddHHmmss ==> yyyy-MM-dd hh:mm:ss
function getDateTimeFmt(date) {
	var d = nvl(date);
	if (d.length < 14) return d;
	return d.substring(0, 4) + "-" + d.substring(4, 6) + "-" + d.substring(6, 8)
		+ " " + d.substring(8, 10) + ":" + d.substring(10, 12) + ":" + d.substring(12, 14);
}

//이벤트 전파 취소
function cancelPropagation(event) {
	if (event.stopPropagation) {
		event.stopPropagation();
	} else {
		event.cancelBubble = true; // ie v10이하
	}
}

//xss 방어, 스크립트 변환
function defenceXSS(value) {
	var lt = /</g,
	gt = />/g,
	ap = /'/g,
	ic = /"/g;
	if (value == null) {
		return value;
	}
	return value.toString().replace(lt, "&lt;").replace(gt, "&gt;").replace(ap, "&#39;").replace(ic, "&#34;");
}
