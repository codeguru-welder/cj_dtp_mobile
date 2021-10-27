
var miaps_timepicker = window.miaps_timepicker = {
	/**
	* @param {function} callback
	* @returns {HTMLElement} 액션 시트 블록을 감싸는 HTML 개체. 이 개체에 setContent, show, hide 함수가 붙어 있다.
	*/
	showActionsheet: function (callback) {

	    var resultHtml = $.ajax({
			type: "GET",
			url: "/miapsdemo/resource/js/timepicker_template.html",
			async: false
		}).responseText;
	
		var _layerTemp = Template7.compile(resultHtml);
		
		// 로드한 template의 {{}}값은  JSON으로 Argument에 작성
		var _html = _layerTemp();
		var temp, $temp = $(_html);
		var actionsheet;
		var nowTime, halfdaySwiper, hoursSwiper, minutesSwiper;
	
		var temp = $temp[0];
		if ($temp.parent().length === 0) {
			$temp.appendTo(document.body);
		}
		
		temp.init = function(){
			// .layer-contents 하위 요소의 html
			var content = $temp.find('.time-wrap');
			
			// 액션시트 화면 구성
			actionsheet = asFn.actionSheet(content, {
				title:'Time Picker',
				close: function(){
					temp.hide();
				},
				no: function(){
					temp.hide();
				},
				yes: function(){
					var halfdayTxt, hourTxt, minuteTxt;
					if(halfdaySwiper.activeIndex == 0) halfdayTxt = '오전';
					else halfdayTxt = '오후';
					
					hourTxt = (hoursSwiper.realIndex + 1) + '시';
					minuteTxt = minutesSwiper.realIndex + '분';
					
					alert(halfdayTxt + ' ' + hourTxt + ' ' + minuteTxt);
					
					temp.hide();
				}
			});
		}
		
		temp.show = function () {
			actionsheet.show();
			
			// 액션시트의 첫 show 이후에 한번만 실행되면 됨
			if(!nowTime == true){
				// swiper 기본 설정
				var defaultOpt = {
					direction: 'vertical',			// 슬라이드 방향
					slidesPerView: 3,				// 한번에 보여지는 슬라이드 수
					freeMode: true,					// 슬라이드의 고정 위치 없애기
					freeModeSticky: true,			// 드래그했을때 슬라이드에 맞게 위치조정
					freeModeMomentumRatio: 0.25,	// 드래그했을때 움직이는 운동량값 (높을수록 빠름)
					slideToClickedSlide: true,		// 이전 또는 다음 슬라이드 터치로 슬라이드 이동
					centeredSlides: true,			// 텍스트 중앙정렬
					resistanceRatio: 0				// 슬라이드 가장자리의 드래그 저향률
				};
				
				var nowHalfday;
				nowTime = new Date();
				
				// 0: 오전, 1: 오후
				if(nowTime.getHours() < 12) nowHalfday = '0';
				else nowHalfday = '1';
				
				// 오전오후 슬라이드
				halfdaySwiper = new Swiper(
					'.swiper-container.halfday', 
					Object.assign({}, defaultOpt, {
						initialSlide: nowHalfday		// 초기 설정값
					})
				);
				
				// 시 슬라이드
				hoursSwiper = new Swiper(
					'.swiper-container.hours', 
					Object.assign({}, defaultOpt, { 
						loop: true,							// 연속 슬라이드 모드
						loopAdditionalSlides: 11,			// 루프 생성 후에 복제될 추가 슬라이드 수 (0부터 시작, 최대값 : 기존 슬라이드 수)
						initialSlide: nowTime.getHours()-1	// 초기 설정값
					})
				);
				
				// 분 슬라이드
				minutesSwiper = new Swiper(
				  	'.swiper-container.minutes',
				  	Object.assign({}, defaultOpt, {
						loop: true,							// 연속 슬라이드 모드
						loopAdditionalSlides: 20,			// 루프 생성 후에 복제될 추가 슬라이드 수 (0부터 시작, 최대값 : 기존 슬라이드 수)
						initialSlide: nowTime.getMinutes()	// 초기 설정값
					})
				);
			}
			
			// 시, 분 입력기능 off
			inputOnOff(false);
		}
	
		temp.hide = function () {
			$('.dimmed').remove();
			actionsheet.hide();
		}
		
		// template별 구성함수 시작
		
		// 시, 분  입력기능 활성화
		$('.time-wrap .input-wrap.mid').on('click', function(){
			$("body").scrollTop($(document).height());
			
			$('.swiper-container.hours .input-wrap.mid').val(hoursSwiper.realIndex + 1);
			$('.swiper-container.minutes .input-wrap.mid').val(minutesSwiper.realIndex);
			
			inputOnOff(true);
			slideOnOff(false);
		});
		
		// 시, 분  입력부분 focusout일때 입력 비활성화
		$(".time-wrap .input-wrap.mid").on('focusout', function() {
			slideOnOff(true);
			inputOnOff(false);
		});
		
		// 키패드에서 엔터 눌렀을때
		$(".swiper-container.hours .input-wrap.mid").keydown(function(key) {
			if(key.keyCode == 13) $(".swiper-container.hours .input-wrap.mid").blur();
		});
		
		// 키패드에서 엔터 눌렀을때
		$(".swiper-container.minutes .input-wrap.mid").keydown(function(key) {
			if(key.keyCode == 13) $(".swiper-container.minutes .input-wrap.mid").blur();
		});
		
		// 시의 값이 입력될때 입력값 검사
		$(".swiper-container.hours .input-wrap.mid").on("propertychange change keyup paste input", function() {
			$("body").scrollTop($(document).height());
			$(this).val($(this).val().replace(/\D/g,''));

			if($(this).val() == '' || $(this).val() == '0') return;
			else if($(this).val() == '00') $(this).val('12');
			else if(parseInt($(this).val()) > 12){
				$(this).val(hoursSwiper.realIndex + 1);
				// miaps toasts 기능을 이용할 경우 IOS에서 키패드가 내려갔다 올라오면서 화면스크롤이 최상단으로 이동해서 액션시트가 가려짐
				miaps.mobile({
					type : 'toasts',
					param: {msg: '입력한 값이 바르지 않습니다.'}
				});
			}
			
			hoursSwiperChange();
		});
		
		// 분의 값이 변경될때 입력값 검사
		$(".swiper-container.minutes .input-wrap.mid").on("propertychange change keyup paste input", function() {
			$("body").scrollTop($(document).height());
			$(this).val($(this).val().replace(/\D/g,''));
			
			if($(this).val() == '') return;
			else if($(this).val() == '00' || $(this).val() == '60') $(this).val('0');
			else if(parseInt($(this).val()) > 59){
				$(this).val(minutesSwiper.realIndex);
				// miaps toasts 기능을 이용할 경우 IOS에서 키패드가 내려갔다 올라오면서 화면스크롤이 최상단으로 이동해서 액션시트가 가려짐
				miaps.mobile({
					type : 'toasts',
					param: {msg: '입력한 값이 바르지 않습니다.'}
				});
			}
			
			minutesSwiperChange();
		});
		
		// 입력된 값으로 슬라이드 변경
		function hoursSwiperChange(){
			slideOnOff(true);
			var hourInt = parseInt($('.swiper-container.hours .input-wrap.mid').val());
			hoursSwiper.slideToLoop(hourInt-1, 0.0001);
			slideOnOff(false);
		}
		
		// 입력된 값으로 슬라이드 변경
		function minutesSwiperChange(){
			slideOnOff(true);
			var minuteInt = parseInt($('.swiper-container.minutes .input-wrap.mid').val());
			minutesSwiper.slideToLoop(minuteInt, 0.0001);
			slideOnOff(false);
		}
		
		// 시, 분 입력기능 on off 
		function inputOnOff(flag){
			if(flag == true){
				$('.time-wrap .input-wrap.mid').css('opacity', '1');
				$('.time-wrap .input-wrap.up, .time-wrap .input-wrap.down').css('z-index', '10');
			}else{
				$('.time-wrap .input-wrap.mid').css('opacity', '0');
				$('.time-wrap .input-wrap.up, .time-wrap .input-wrap.down').css('z-index', '-1');
			}
		}
		
		// swiper의 슬라이드기능 on off
		function slideOnOff(flag){
			hoursSwiper.allowTouchMove = flag;
			hoursSwiper.allowSlideNext = flag;
			hoursSwiper.allowSlidePrev = flag;
			minutesSwiper.allowTouchMove = flag;
			minutesSwiper.allowSlideNext = flag;
			minutesSwiper.allowSlidePrev = flag;
		}

		// template별 구성함수 끝
		temp.init();
		
		return temp;
	}
}