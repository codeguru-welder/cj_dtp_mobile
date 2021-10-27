define(['template7'], function (Template7) {
	var miaps_bankList = window.miaps_bankList = {
	/**
	* @param {function} callback
	* @returns {HTMLElement} 액션 시트 블록을 감싸는 HTML 개체. 이 개체에 setContent, show, hide 함수가 붙어 있다.
	*/
	showActionsheet: function (callback) {

	    var resultHtml = $.ajax({
			type: "GET",
			url: "/miapsdemo/resource/js/bankList_template.html",
			async: false
		}).responseText;
	
		var _layerTemp = Template7.compile(resultHtml);
		
		//테스트 data 시작
		var testdata = {
			"bank":[
				{"title": "우리은행"			, "image": "/miapsdemo/resource/img/logo/bank_woori.png"},
				{"title": "국민은행"			, "image": "/miapsdemo/resource/img/logo/bank_kbstar.png"},
				{"title": "기업은행"			, "image": "/miapsdemo/resource/img/logo/bank_ibk.png"},
				{"title": "농협은행"			, "image": "/miapsdemo/resource/img/logo/bank_nonghyup.png"},
				{"title": "신한은행"			, "image": "/miapsdemo/resource/img/logo/bank_shinhan.png"},
				{"title": "하나은행"			, "image": "/miapsdemo/resource/img/logo/bank_kebhana.png"},
				{"title": "한국씨티은행"		, "image": "/miapsdemo/resource/img/logo/bank_citi.png"},
				{"title": "SC제일은행"			, "image": "/miapsdemo/resource/img/logo/bank_sc.png"},
				{"title": "경남은행"			, "image": "/miapsdemo/resource/img/logo/bank_kn.png"},
				{"title": "광주은행"			, "image": "/miapsdemo/resource/img/logo/bank_kj.png"},
				{"title": "대구은행"			, "image": "/miapsdemo/resource/img/logo/bank_dgb.png"},
				{"title": "도이치은행"			, "image": "/miapsdemo/resource/img/logo/bank_db.png"},
				{"title": "부산은행"			, "image": "/miapsdemo/resource/img/logo/bank_busan.png"},
				{"title": "비엔피파리바은행"		, "image": "/miapsdemo/resource/img/logo/bank_cardif.png"},
				{"title": "산림조합"			, "image": "/miapsdemo/resource/img/logo/bank_nfcf.png"},
				{"title": "KDB산업은행"		, "image": "/miapsdemo/resource/img/logo/bank_kdb.png"},
				{"title": "새마을금고"			, "image": "/miapsdemo/resource/img/logo/bank_kfcc.png"},
				{"title": "수출입은행"			, "image": "/miapsdemo/resource/img/logo/bank_koreaexim.png"},
				{"title": "수협은행"			, "image": "/miapsdemo/resource/img/logo/bank_suhyup.png"},
				{"title": "신협은행"			, "image": "/miapsdemo/resource/img/logo/bank_cu.png"},
				{"title": "우체국"			, "image": "/miapsdemo/resource/img/logo/bank_epost.png"}, 
				{"title": "저축은행중앙회"		, "image": "/miapsdemo/resource/img/logo/bank_fsb.png"},
				{"title": "전북은행"			, "image": "/miapsdemo/resource/img/logo/bank_jb.png"},
				{"title": "제주은행"			, "image": "/miapsdemo/resource/img/logo/bank_jeju.png"},
				{"title": "중국건설은행"		, "image": "/miapsdemo/resource/img/logo/bank_ccb.png"},
				{"title": "중국공상은행"		, "image": "/miapsdemo/resource/img/logo/bank_icbc.png"},
				{"title": "중국은행"			, "image": "/miapsdemo/resource/img/logo/bank_china.png"},
				{"title": "지역농축협"			, "image": "/miapsdemo/resource/img/logo/bank_areanh.png"},
				{"title": "카카오뱅크"			, "image": "/miapsdemo/resource/img/logo/bank_kakao.png"},
				{"title": "케이뱅크"			, "image": "/miapsdemo/resource/img/logo/bank_kbank.png"},
				{"title": "BOA(뱅크오브아메리카)"	, "image": "/miapsdemo/resource/img/logo/bank_boa.png"},
				{"title": "HSBC은행"			, "image": "/miapsdemo/resource/img/logo/bank_hsbc.png"},
				{"title": "JP모건체이스은행"		, "image": "/miapsdemo/resource/img/logo/bank_jpmorgan.png"},
				{"title": "지방세입"			, "image": "/miapsdemo/resource/img/logo/bank_korgo.png"},
				{"title": "국세납부"			, "image": "/miapsdemo/resource/img/logo/bank_korgo.png"}
			],
			"stock":[
				{"title": "NH투자증권"			, "image": "/miapsdemo/resource/img/logo/bank_nhqv.png"},
				{"title": "교보증권"			, "image": "/miapsdemo/resource/img/logo/bank_iprovest.png"},
				{"title": "대신증권"			, "image": "/miapsdemo/resource/img/logo/bank_daishin.png"},
				{"title": "메리츠증권"			, "image": "/miapsdemo/resource/img/logo/bank_meritz.png"},
				{"title": "미래에셋대우"		, "image": "/miapsdemo/resource/img/logo/bank_miraeasset.png"},
				{"title": "부국증권"			, "image": "/miapsdemo/resource/img/logo/bank_bookook.png"},
				{"title": "삼성증권"			, "image": "/miapsdemo/resource/img/logo/bank_samsungpop.png"},
				{"title": "신영증권"			, "image": "/miapsdemo/resource/img/logo/bank_shinyoung.png"},
				{"title": "신한금융투자"		, "image": "/miapsdemo/resource/img/logo/bank_shinhaninvest.png"},
				{"title": "아이엠투자증권"		, "image": "/miapsdemo/resource/img/logo/bank_im.png"},
				{"title": "유안타증권"			, "image": "/miapsdemo/resource/img/logo/bank_myasset.png"},
				{"title": "유진투자증권"		, "image": "/miapsdemo/resource/img/logo/bank_eugenefn.png"},
				{"title": "이베스트투자증권"		, "image": "/miapsdemo/resource/img/logo/bank_ebestsec.png"},
				{"title": "카카오페이증권"		, "image": "/miapsdemo/resource/img/logo/bank_kakaosec.png"},
				{"title": "케이프투자증권"		, "image": "/miapsdemo/resource/img/logo/bank_capefn.png"},
				{"title": "키움증권"			, "image": "/miapsdemo/resource/img/logo/bank_kiwoom.png"},
				{"title": "하나금융투자"		, "image": "/miapsdemo/resource/img/logo/bank_hanaw.png"},
				{"title": "하이투자증권"		, "image": "/miapsdemo/resource/img/logo/bank_hiid.png"},
				{"title": "한국투자증권"		, "image": "/miapsdemo/resource/img/logo/bank_truefriend.png"},
				{"title": "한국포스증권"		, "image": "/miapsdemo/resource/img/logo/bank_foss.png"},
				{"title": "한화투자증권"		, "image": "/miapsdemo/resource/img/logo/bank_hanwhawm.png"},
				{"title": "현대차증권"			, "image": "/miapsdemo/resource/img/logo/bank_hmsec.png"},
				{"title": "BNK증권"			, "image": "/miapsdemo/resource/img/logo/bank_bnkfn.png"},
				{"title": "DB금융투자"			, "image": "/miapsdemo/resource/img/logo/bank_dbfi.png"},
				{"title": "IBK투자증권"		, "image": "/miapsdemo/resource/img/logo/bank_ibks.png"},
				{"title": "KB증권"			, "image": "/miapsdemo/resource/img/logo/bank_kbsec.png"},
				{"title": "KTB 투자증권"		, "image": "/miapsdemo/resource/img/logo/bank_ktb.png"},
				{"title": "SK증권"			, "image": "/miapsdemo/resource/img/logo/bank_sks.png"}
			]
		}
		
		//테스트 data 끝
		
		// 로드한 template의 {{}}값은  JSON으로 Argument에 작성
		var data = {"result":[]};
		data.result = testdata.bank;
		
		var _html = _layerTemp(data);
		var temp, $temp = $(_html);
		var actionsheet;
	
		var temp = $temp[0];
		if ($temp.parent().length === 0) {
			$temp.appendTo(document.body);
		}
		
		temp.init = function(){
			// .layer-contents 하위 요소의 html
			var content = $temp.find('.bankList-wrap');
			
			// 액션시트 화면 구성
			actionsheet = asFn.actionSheet(content, {
				title:'Bank List',
				close: function(){
					temp.hide();
				}
			});
		}
		
		var leftTabMid, rightTabMid;
		
		temp.show = function () {
			actionsheet.show();
			
			// 첫 로드때만 실행
			if(!leftTabMid == true){
				var tab1 = $('.bankList-wrap #tabLabel1');
				// 탭과 강조라인 중앙정렬 해주기 (tab1의 왼쪽위치 + tab1의 너비/2 + 하이라이트 라인의 너비/2)
				leftTabMid = tab1.offset().left + tab1.width()/2 - $('.bankList-wrap .highlight_line').css('width').replace('px', '')/2;
			
				var tab2 = $('.bankList-wrap #tabLabel2');
				// 탭과 강조라인 중앙정렬 해주기 (tab1의 왼쪽위치 + tab1의 너비/2 + 하이라이트 라인의 너비/2)
				rightTabMid = tab2.offset().left + tab2.width()/2 - $('.bankList-wrap .highlight_line').css('width').replace('px', '')/2;
				
				$('.bankList-wrap .highlight_line').css('left', leftTabMid);
			}
		}
	
		temp.hide = function () {
			$('.dimmed').remove();
			actionsheet.hide();
		}
		
		// template안의 요소 변경할때
		temp.setTemplate = function(){
			var itemTemplet = ''
          	+ '{{#each result}}                                    '
			+ '	<div class="bankItemGrid" id={{title}}>            '
			+ '		<img class="bankImage" src={{image}}>		'
			+ '		<div class="title">                            '
			+ '			{{title}}                                  '
			+ '		</div>                                         '
			+ '	</div>                                             '
			+ '{{/each}}                                           ';
			
			_layerTemp = Template7.compile(itemTemplet);
			var _html = _layerTemp(data);
			$('.bankList-wrap div[id="itemTemplet"]').html(_html);
		}
		
		// template별 구성함수 시작
		
		// html()함수로 새로 구성된 요소의 이벤트를 실행시키려면 event delegate을 시켜야함
		$(".bankList-wrap").on('click', '.bankItemGrid', function(){	
			alert($(this).attr('id'));
			temp.hide();
		});
		
		$('.bankList-wrap input[type="radio"]').on('change', function () {
			var tapId = $('.bankList-wrap :radio[name="tab"]:checked').attr('id');
			if(tapId == 'tab1'){
				data.result = testdata.bank;
				// 탭 하이라이트 애니메이션
				$('.bankList-wrap .highlight_line').stop().animate({left: leftTabMid}, 'fast');
			}else if(tapId == 'tab2'){
				data.result = testdata.stock;
				// 탭 하이라이트 애니메이션
				$('.bankList-wrap .highlight_line').stop().animate({left: rightTabMid}, 'fast');
			}
			
			temp.setTemplate();
		});
		
		// template별 구성함수 끝
		temp.init();
		
		return temp;
	}
};
	return miaps_bankList;
});