/*
 * accordian jquery로 구현 
 * 
 * @author swcho
 * @since 2014.03.06
*/

//-- accordion 함수 --//
function init_accordion_setting(num) {

  //-- 디폴트 오픈 어코디언 번호 (0번부터 시작) --//
  var accShowNo = num;

  //모든 어코디언을 대상으로 한다.
  $('div#leftMenu').each(function() {
	  // 첫 번째 어코디언 항목을 표시
	  $(this).find('li').removeClass('active');
	  $(this).find('a', '.has-sub li:eq('+accShowNo+')').end().find('ul:eq('+accShowNo+')').show().parent("li").addClass('active');
  });
  
  $('#leftMenu > ul > li > a').click(function() {
	  $('#leftMenu li').removeClass('active');
	  $(this).closest('li').addClass('active');	
	  var checkElement = $(this).next();
	  if((checkElement.is('ul')) && (checkElement.is(':visible'))) {
	    $(this).closest('li').removeClass('active');
	    checkElement.slideUp('normal');
	  }
	  if((checkElement.is('ul')) && (!checkElement.is(':visible'))) {
	    $('#leftMenu ul ul:visible').slideUp('normal');
	    checkElement.slideDown('normal');
	  }
	  if($(this).closest('li').find('ul').children().length == 0) {
	    return true;
	  } else {
	    return false;	
	  }
	});
  
}

// myMenu(ex) - user:1^device:2^app:3^push:4
function init_accordion(type, myMenu) {
	
	if (false == isNaN(type)) { /* 숫자라면 기존 하던 방식 대로 처리 한다. */
		init_accordion_setting(type);
		return;
	}

	if (myMenu == null || myMenu == 'home') {
		init_accordion_setting(0);	// home
	}
	
	if (myMenu != null) {	
		var menuArray = myMenu.split("^");
		
		for (i = 0; i < menuArray.length; i++) {
			var menu = menuArray[i].split(":");
			if (type == menu[0]) {
				init_accordion_setting(menu[1]);			
				break;
			}
		}
	}
}

//메뉴 네비게이션명 세팅 - 사용예: set_topMenuTile('app', '앱 관리 > 앱 현황');
function set_topMenuTile(type, title) {
	// 네비게이션명 세팅
	$("#topMenuTile").html(title);
	
	// 네비게이션에 마우스포인터 손가락모양
	$("#topMenuTile").css("cursor", "pointer");
	// 네비게이션 클릭시 메뉴열림
	var titleArray = title.split(">");
	var detailTitle = $.trim(titleArray[1]); // 상세메뉴명
	$("#topMenuTile").click(function() {
		$("#leftMenu").find(".icon_" + type).parent("a").each(function(i, a){
			if($(a).parent("li").find("ul:eq(0)").is(':visible') == false) $(a).click(); // 메뉴열림(닫혀있는 경우)
			$(a).parent("li").find("a:contains('"+detailTitle+"')").focus(); // 상세메뉴포커스
		});
	});
}
