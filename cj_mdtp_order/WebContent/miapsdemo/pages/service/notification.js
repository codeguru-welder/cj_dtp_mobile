require(
        [
            'jquery'
                    , 'miaps'
                    , 'utils'
                    , 'sqlUtil'
                    , 'layerUtil'
                    , 'i18n!js/nls/acrew_resources'
                    , 'handlebars'
                    , 'dateUtil'
                    , 'templateUtil'
                    , 'common'
        ]
        , function ($, miaps, utils, sqlUtil, layerUtil, resource, handlebars) {
        	pageHistory.current_require_url = 'js/account/notification';
            miaps.cursor(null, 'wait', true);

            var sessionInfo = miaps.parse(utils.sessions.get( common_key.userSession ));

            $(document).ready(function () {
                var callback = {
                	cbSelectPushList: function (data) {

	                    var json = miaps.parse(data);
	
	                    if (window._debug) {
	                        console.log(' ** cbSelectPushList ** ');
	                        console.log(json);                            
	                    }
	                        
	                    if (json != null && json.code == '200') {
	                        var pushList = json.res;
	
	                        var temp = [];
	                        for (var idx in pushList) {
	
	                            var key = pushList[idx].col4;
	                            var key2 = pushList[idx].col7;
	                            var pushItem = miaps.parse(pushList[idx].col8);

	                            //IOS 이면 col8 사용 안함  
								if (miaps.MobilePlatform.iPhone() || miaps.MobilePlatform.iPad()) {
									temp.push({"id": key+"|"+key2, "title": "알림", "value": pushList[idx].col2 , "date": dateUtil.toDateString(key, dateUtil.FORMAT_YYYMMDD_DOT)});
								}
								else {
									//title 없을경우 기본 값 사용
									if(pushItem.ttl	== ""){
										pushItem.ttl = "알림"
									}
									temp.push({"id": key+"|"+key2, "title": pushItem.ttl, "value": pushItem.msg, "date": dateUtil.toDateString(key, dateUtil.FORMAT_YYYMMDD_DOT)});
								}
	                        }
	                    } else {
	                        utils.alertToastMsg(resource.t("msg_common_readFail", "title_notification"));
	                    }
	                            
	                    var dataObj = {"notificationList": temp};
	                    dataObj.resource = { 'msg_common_noDataResult' : resource.msg_common_noDataResult };
	                    //핸들바 탬플릿을 가져온다.
	                    var source = $("#notification-list-template").html();
	                    //핸들바 템플릿을 pre컴파일한다.
	                    var template = handlebars.compile(source);
	                    //핸들바 템플릿에 데이터를 바인딩해서 HTML을 생성한다.
	                    var appendHtml = template(dataObj);
	                    //생성된 HTML을 DOM에 주입
	                    $(".noti_list_wrap").html(appendHtml);
	                            
	                    setEvent();
	                        
	                    // 데이터 조회 후 miaps.cursor(null, 'default'); 수행
                        
                    }, //cbSelectPushList
                    cbDeletePushList: function (data) {
                        var json = miaps.parse(data);

                        if (window._debug) {
                            console.log(' ** cbDeletePushList ** ');
                            console.log(json);                            
                        }

                        if (json == null || !json.hasOwnProperty('code')) {
                            utils.alertToastMsg(resource.t("msg_common_deleteFail", "title_notification"));
                        } else {

                            if (json.code == '200') {                                
                                getPushList();
                            } else {
                                utils.alertToastMsg(resource.t("msg_common_deleteFail", "title_notification"));
                            }
                        }
                    }
                };

                window._cb = callback;
                init();
            });

            function init() {
                //schedule mainMenu include.
                goPage("sidebar", "#main_menu");
                miaps.cursor(null, 'default');
                getPushList();             
            }

            function getPushList() {
                var push_db_file_nm = 'sqlite.' + 'MIAPS_CM.sqlit';
                // 푸시 리스트
                var query_select = 'SELECT * FROM MIAPS_CM ORDER BY col4 DESC';
                miaps.querySvc('select', push_db_file_nm, query_select, '_cb.cbSelectPushList', _cb.cbSelectPushList);
            }


            function setEvent() {
                //notification - list accordion
                $(".noti_list_wrap .title_box").bind("click", function () {
                    var flg = $(this).next("div.detail").is(":visible");
                    if (flg) {
                        $(this).children(".btn_acod").removeClass("open");
                        $(this).next("div.detail").slideUp("fast");
                    } else {
                        $(this).children(".btn_acod").addClass("open");
                        $(this).next("div.detail").slideDown("fast");
                    }
                });

                //notification - all check
                var all_flg = false;
                $(".edit_btn_box .all_btn").unbind();
                $(".edit_btn_box .all_btn").bind("click", function () {
                    var target = $(this).data("value");
                    if (!all_flg) {
                        $("." + target + " .chkbox").children("input:checkbox").prop("checked", true);
                        all_flg = true;
                    } else {
                        $("." + target + " .chkbox").children("input:checkbox").prop("checked", false);
                        all_flg = false;
                    }
                });

                //삭제 클릭
                $(".del_btn").unbind();
                $(".del_btn").on("click", function () {
                    var param = [];
                    var param2 = [];

                    $("input:checkbox").each(function () {
                        var timeId = "";
                        var pid = "";
                        if (this.checked) {
                            var id = $(this).attr("id").split("|");
                            param.push(id[0]);
                            param2.push(id[1]);                            
                        }
                    });//each

                    param = param.map(function (s) {
                        return "'" + s + "'";
                    });
                    param2 = param2.map(function (s) {
                        return "'" + s + "'";
                    });

                    var query = "DELETE FROM MIAPS_CM WHERE col4 in ("+param.toString()+") AND col7 in ("+param2.toString()+")";
                    miaps.querySvc('execute', 'sqlite.MIAPS_CM.sqlit', query, '_cb.cbDeletePushList', _cb.cbDeletePushList);

                });

                //service info page  - meal info accordion
               $( "li .more_icon" ).unbind();
               $( "li .more_icon" ).click( function () {
                    var target = $(this).parent().next("li");
                    if ($(target).is(":visible")) {  
                        $(this).removeClass("open");
                        $(target).slideUp("fast");
                    } else {
                        $(this).addClass("open");
                        $(target).slideDown("fast");
                    }
                });
            }
            /*//////////////////////////////////////////////////////	 이동		/////////////////////////////////////////////////////////////*/

            /*//////////////////////////////////////////////////////	 모바일		/////////////////////////////////////////////////////////////*/

            /*//////////////////////////////////////////////////////	 통신		/////////////////////////////////////////////////////////////*/

        }//func
)//require