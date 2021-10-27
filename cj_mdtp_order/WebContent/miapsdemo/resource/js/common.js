/* 팝업창 호출 (버튼 수, 제목, 내용)*/
var showModal = function (btn_cnt, title, content) {
  var temp = "";
  temp += '<div class="popup">';
  temp += '<p class="head">' + title + "</p>";
  temp += '<div class="wrapper"><div class="txt">' + content + "</div></div>";
  if (btn_cnt === 1) {
    //알림
    temp += '<div class="popup_btn_wrap">';
    temp += '<button type="button" class="popup_cls" >확인</button>';
  } else if (btn_cnt === 2) {
    //컨펌
    temp += '<div class="popup_btn2_wrap">';
    temp += '<button type="button" class="popup_cls" >아니오</button>';
    temp += '<button type="submit" class="popup_yes" >예</button>';
  }
  temp += "</div></div>";
  temp += '<div class="dimmed"></div>';
  $("body").append(temp);
  $(".popup").show();
  $(".dimmed").show();
  /* 팝업 닫기 */
  $(".popup_cls").click(function () {
    $(".popup").remove();
    $(".dimmed").remove();
    var thisfilefullname = document.URL.substring(
      document.URL.lastIndexOf("/") + 1,
      document.URL.length
    );
    if (thisfilefullname == "WF041.html" || thisfilefullname == "WF041_Req.html") {
      popup_cls();
    }
  });
  $(".popup_yes").click(function () {
    $(".popup").remove();
    $(".dimmed").remove();
    popup_yes();
  });
};

/* 토스트 메시지 호출 (메시지)*/
var msgbox_toast = function (message) {
  miaps.mobile(
    {
      type: "toasts",
      param: { msg: message },
    },
    function (data) {}
  );
};

/* 맞춤완성도 달성률 그래프 (퍼센트 숫자)*/
var progress_bar = function (num) {
  $(".progress_wrap .progress_bar").css("width", num + "%");
  $(".progress_wrap .rate")
    .css("left", num + "%")
    .html(num + "%");
};

$(function () {
	/* 아코디언 */
    $(document).on("click",".p_list",
    function(){
        //열려있을 때
        if($(this).hasClass("open")){
            $(this).children('p').css({
                // "text-overflow" : "ellipsis",
                "white-space" : "nowrap"
                // "word-break" : "break-all",
                // "overflow" : "hidden"
            });
            $(this).removeClass("open");
        //닫혀있을 때
        }else{
            $(this).children('p').css({
                // "text-overflow" : "",
                "white-space" : "normal"
                // "word-break" : "break-all",
                // "overflow" : "hidden"
            });
            $(this).addClass("open");
        }
    });
        
  /* 탭 (공통) */
  $(".tab_btn").click(function () {
    $(".tab_btn").removeClass("active");
    $(this).addClass("active");
    var tab_target = $(this).data("target");
    $(".tab_content").hide();
    $("#" + tab_target).show();
  });

  /* 팝업 (공통) */
  $(".popup_op").click(function () {
    var op_target = $(this).data("op");
    $("body").append('<div class="dimmed"></div>');
    $(".dimmed").show();
    $("#" + op_target).show();
  });
  $(".popup_cls").click(function () {
    var cls_target = $(this).data("cls");
    $("#" + cls_target).hide();
    $(".dimmed").remove();
  });

  /* 이메일 선택 팝업 (공통) */
  $(".email_combo").click(function () {
    //선택값이 들어갈 인풋.
    var target_el = $(this).prev('input[type="text"]');
    //팝업 템플릿.
    var temp = "";
    temp += '<div class="popup email" id="email_popup">';
    temp += '<p class="head">이메일 선택</p>';
    temp += '<div class="wrapper">';
    temp += '<ul class="email_list">';
    temp += "<li>naver.com</li>";
    temp += "<li>daum.net</li>";
    temp += "<li>hanmail.com</li>";
    temp += "<li>hotmail.com</li>";
    temp += "<li>nate.com</li>";
    temp += "<li>gmail.com</li>";
    temp += "<li>dreamwiz.com</li>";
    temp += "<li>empal.com</li>";
    temp += "<li>korea.com</li>";
    temp += "</ul></div></div>";
    temp += '<div class="dimmed"></div>';
    //팝업 열기
    $("body").append(temp);
    $("#email_popup").show();
    $(".dimmed").show();
    //이메일 선택시 인풋창에 선택값 넣고 팝업닫음.
    $(".email_list > li").on("click", function () {
      target_el.val($(this).html()).trigger("input");
      $("#email_popup").remove();
      $(".dimmed").remove();
    });
  });

  /* 주소검색 리스트 클릭 */
  $(".srch_addr_rst > li").click(function () {
    $(".srch_addr_rst > li").removeClass("selected");
    $(this).addClass("selected");
  });

  /* 약관동의 페이지 - 전체 체크/해제 */
  $("#agr_all").change(function () {
    if ($(this).is(":checked")) {
      $(".agree_wrap input:checkbox").prop("checked", true).trigger("change");
    } else {
      $(".agree_wrap input:checkbox").prop("checked", false).trigger("change");
    }
  });
  //필수 체크박스 체크 확인 - 버튼 활성화
  $(".agree_wrap input:checkbox").on("change", function () {
    var chk_length = $(".agree_wrap input:checkbox").length;
    var chk_cnt = 0;
    $(".agree_wrap input:checkbox").each(function () {
      if ($(this).is(":checked")) {
        chk_cnt++;
      } else {
        return false;
      }
    });
    if (chk_length === chk_cnt) {
      $("#agr_all").prop("checked", true);
      $("body").find("button.act_btn").prop("disabled", false);
    } else {
      $("#agr_all").prop("checked", false);
      $("body").find("button.act_btn").prop("disabled", true);
    }
  });

  /* 간편 비밀번호 */
  $("#simple_pass").val(""); //리셋
  $(".simple_keypad > button").click(function (e) {
    //e.preventDefault();
    e.stopPropagation();
    var pass_num = $(this).data("num");
    var pass_val = $("#simple_pass").val();
    if ($.isNumeric(pass_num) && pass_val.length < 6) {
      $("#simple_pass").val(pass_val + pass_num);
      pass_val = $("#simple_pass").val();
      pass_color_chk(pass_val.length);
    } else if (pass_num == "del" && pass_val.length > 0) {
      $("#simple_pass").val(pass_val.substr(0, pass_val.length - 1));
      pass_val = $("#simple_pass").val();
      pass_color_chk(pass_val.length);
    }
    console.log($("#simple_pass").val().length + "/" + $("#simple_pass").val());
  });
  //간편 비밀번호 입력 수 표시
  var pass_color_chk = function (num) {
    $(".simple_pass_box > span").css("background-color", "#d7d7d7");
    $(".simple_pass_box > span")
      .slice(0, num)
      .css("background-color", "#0086ff");
    if (num > 0) {
      $(".simple_pass_box").css("border-bottom", "solid 2px #0086ff");
    } else {
      $(".simple_pass_box").css("border-bottom", "solid 2px #d9d9d9");
    }
  };

  /* 필수 항목 입력 감지 - 버튼 활성/비활성화 (공통) - 필수 입력 항목에 'ess'라는 css클래스를 작성 .*/
  var ess_arr = $.makeArray($(".ess")),
    ess_arr_cnt = ess_arr.length;
  //입력창 입력 시 체크
  $(".ess").on("propertychange change keyup paste input", function () {
    chk_input();
  });
  //필수 입력 항목 체크
  function chk_input() {
    var chk_cnt = 0;
    $(ess_arr).each(function () {
      if ($.trim($(this).val()) != "") {
        chk_cnt++;
      }
    });
    // 필수 입력 항목 수와 필수 입력 항목 전체갯수 비교해서 버튼 활성/비활성. 활성/비활성 되는 버튼에 'act_btn' css클래스 필요.
    if (ess_arr_cnt === chk_cnt) {
      $("body").find("button.act_btn").prop("disabled", false);
    } else {
      $("body").find("button.act_btn").prop("disabled", true);
    }
  }

  /* 환경설정 on - off 버튼 */
  $(".onoff_btn").click(function () {
    $(this).hasClass("on") ? $(this).removeClass("on") : $(this).addClass("on");
  });

  /* 서류관리 - 편집모드 */
  $(".edit_btn").click(function () {
    $(this).hide();
    $(".edit_end_btn").show();
    $(".doc_del_btn").show();
    $(".doc_file_wrap").addClass("edit");
    //체크 클릭시 파일영역까지 클릭됨으로 파일 조회 동작을 막음.
    $(".doc_file_wrap.edit .doc_file.on").off("click");
  });
  //편집모드 해제
  $(".edit_end_btn").click(function () {
    $(this).hide();
    $(".edit_btn").show();
    $(".doc_del_btn").hide();
    $(".doc_file_wrap").removeClass("edit");
    $(".doc_file_wrap .doc_file.on").on("click");
    //$(".doc_file_wrap input[type='checkbox']").prop("checked",false); 체크초기화

    //편집모드시 클릭이벤트를 off하기 때문에 재호출.
    show_file_content();
  });
  /* 서류관리 - 서류 팝업 보기 */
  var show_file_content = function () {
    $(".doc_file_wrap .doc_file.on").on("click", function () {
      alert($(this).find(".doc_title").text()); // 얼럿대신 팝업창 작성필요.
    });
  };
  show_file_content();
});
