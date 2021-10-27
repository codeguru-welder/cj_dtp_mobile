package com.mink.connectors.dlenc.login;

import com.mink.connectors.dlenc.common.CommonUtil;
import com.mink.connectors.dlenc.common.MiapsDao;
import com.mink.connectors.dlenc.mapper.ProjectMapper;
import com.thinkm.mink.asvc.dto.EmailAccount;
import com.thinkm.mink.asvc.dto.User;
import com.thinkm.mink.asvc.dto.UserGroup;
import com.thinkm.mink.asvc.service.EmailAccountService;
import com.thinkm.mink.asvc.service.UserService;
import com.thinkm.mink.commons.MinkTotalConstants;
import com.thinkm.mink.commons.util.ApplicationContextUtil;
import com.thinkm.mink.commons.util.MessageUtil;
import com.thinkm.mink.commons.util.MinkConfig;
import com.thinkm.mink.commons.util.MinkUtil;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service("project.LoginService")
public class LoginService {

    private static String JVAL_CONTENTS = "{\"code\":%d, \"msg\":\"%s\"";

    //@Resource(name="project.ProjectDao")
    //private ProjectDao projectDao;
    private static String JVAL_END = "}";
    private Logger log = LoggerFactory.getLogger(getClass());
    // use MyBatis
    @Resource(name = "projectMapper")
    private ProjectMapper projectDao;
    // use ibatis
    @Resource(name = "project.MiapsDao")
    private MiapsDao miapsDao;
    @Resource(name = "admincenter.userService")
    private UserService userService; // 사용자 Service

    public String loginDlEnc(Map<String, String> paramMap) throws Exception {
        StringBuilder resultSb = new StringBuilder();

        // 로그인ID 중복 일 경우 중복된 유저들의 그룹네비게이션 저장용
        List<UserGroup> grpNaviList = new ArrayList<>();
        User user = new User();
        User login = null;

        String pUserID = paramMap.get("userId");
        String pUserPassword = paramMap.get("userPw");

        user.setUserId(pUserID);
        user.setUserPw(pUserPassword);

        String errCode = "";
        String errorMsg = "";
        List<User> userList = userService.selectAdmincenterUserInfo(user, grpNaviList);
        String userId = (StringUtils.isBlank(user.getUserId()) ? "ID" : user.getUserId());
        if (null == userList || userList.size() < 1) {
            errorMsg = MessageUtil.getMessage("mink.message.login.fail");
            errCode = "ERR_USER_NOT_EXIST";
        } else if (1 < userList.size()) {
            errorMsg = userId + MessageUtil.getMessage("mink.alert.selectyourgroup");
            errCode = "ERR_USER_DUPLICATION";
        } else {
            login = userList.get(0); // mink 로그인 사용자
            if (MinkTotalConstants.YN_YES.equals(login.getDeleteYn())) {
                errorMsg = userId + MessageUtil.getMessage("mink.alert.deleted");
                errCode = "ERR_USER_DELETED";
            }

            String dbPwd = login.getUserPw();
            String userPwd = user.getUserPw();
            int passCnt = login.getPassCnt() == null ? 0 : login.getPassCnt();

            if (StringUtils.isNotBlank(dbPwd)) {
                // Check Password Fail Count
                if (passCnt >= 5) {
                    errorMsg = MessageUtil.getMessage("mink.message.login.fail.passcnt_over");
                    errCode = "ERR_PASSCNT_OVER";
                } else {
                    // Encrypt Password
                    String usrEncPwd =
                        MinkConfig.getConfig().getLoginPasswordEncryptorObject().encrypt(userPwd);

                    if (!usrEncPwd.equals(dbPwd)) {
                        if ("".equals(errorMsg)) {
                            errorMsg = MessageUtil.getMessage("mink.message.login.fail");
                            errCode = "ERR_INVALID_PW";
                        }
                        // 사용자 비밀번호 틀린 횟수 +1 증가
                        this.userService.updateAdmincenterUserPwCntPlus1(login);
                    }
                }
            }
        }

        // Set Return Value
        if (StringUtils.isBlank(errorMsg) && login != null && login.getUserNo() != null) {
            // 로그인 성공 한 유저는 pass_cnt 0으로 초기화
            this.userService.updateAdmincenterUserPwCntInit(login);
            Map<String, Object> resultMap = new LinkedHashMap<>();
            user.setUserPw("");

            resultMap.put("user", user);
            resultMap.put("code", 200);
            resultSb.append(CommonUtil.convertJson(resultMap));
        } else {
            user.setUserPw("");

            Map<String, Object> resultMap = new LinkedHashMap<>();
            resultMap.put("msg", errorMsg);
            resultMap.put("errCode", errCode);
            resultMap.put("user", user);

            resultSb.append(CommonUtil.convertJson(resultMap));
        }

        return resultSb.toString();
    }

    /**
     * @param paramMap
     * @return
     * @throws Exception
     */
    public String login(Map<String, String> paramMap) throws Exception {

        if (log.isDebugEnabled()) {
            log.debug("params : " + paramMap);
        }

        StringBuilder resultSb = new StringBuilder();

        String pUserID = paramMap.get("userId");
        String pUserPassword = paramMap.get("userPw");

        Map<String, String> map = new HashMap<String, String>();
        map.put("id", pUserID);
        map.put("pw", pUserPassword);

        if ((pUserID == null || pUserID.length() == 0)) {
            resultSb.append(String.format(JVAL_CONTENTS, -1, "아이디를 확인 하세요.")).append(JVAL_END);
            return resultSb.toString();
        }

        if (pUserPassword == null || pUserPassword.length() == 0) {
            resultSb.append(String.format(JVAL_CONTENTS, -1, "패스워드를 확인 하세요.")).append(JVAL_END);
            return resultSb.toString();
        }

        /* 1. Project DB(기간계) 에서 유저 체크*/
        //iBatis
        //Map<String, String> resUserMap = (Map<String, String>) projectDao.select("ProjectUser.selectUser", map);

        //MyBatis
        Map<String, String> resUserMap = (Map<String, String>) projectDao.selectUser(map);

        /* 2. MiAPS DB에 유저 추가  */
        if (resUserMap != null && resUserMap.size() > 0) {

            UserService userSvc = (UserService) ApplicationContextUtil
                .getBean("admincenter.userService");
            Map<String, Object> resMap = userSvc
                .insertMiapsUserInfo(null, pUserID, null, "miaps@thinkm.co.kr");
            /* USER_NO, ERR_CD, ERR_MSG */
            Long userNo = MinkUtil.nullToLong(resMap.get("USER_NO").toString());
            int errCd = MinkUtil.nullToInt(resMap.get("ERR_CD").toString());

            /* 3. json 응답 문자열로 변환 */
            if (errCd < 0) {
                /* 3.1. 공통 응답 메시지 작성
                 *   errCode[FS]errMsg[RS]
                 *   errCd[FS]resMap.get("ERR_MSG")[RS]
                 */
                resultSb
                    .append(String.format(JVAL_CONTENTS, errCd, resMap.get("ERR_MSG").toString()))
                    .append(JVAL_END);

            } else {
                /* 3.2. 응답 테이블 데이터 작성
                 * 테이블명:userInfo, 응답데이터 resUserMap
                 */
                Map<String, String> dataMap = new HashMap<String, String>();
                dataMap.put("userId", pUserID);
                dataMap.put("userPw", "");
                dataMap.put("userNo", MinkUtil.nullToString(userNo));
                dataMap.put("groupId", "");
                Map<String, Object> resultMap = new LinkedHashMap<String, Object>();
                resultMap.put("Login", dataMap);

                /* 메일 계정이 있으면 메일정보 추가 */
                boolean bEmail = true;
                if (bEmail) {
                    EmailAccountService eaSvc = (EmailAccountService) ApplicationContextUtil
                        .getBean("admincenter.emailAccountService");
                    EmailAccount ea = new EmailAccount();
                    ea.setUserNo(userNo);                    // 위에서 유저 등록 후 발급된 userNo
                    ea.setMsAddress("miaps@thinkm.co.kr");    // email address
                    ea.setMsLogin(MinkUtil.nullToString(userNo));    // mail server login id
                    ea.setMsPassword("miapsadmin");            // mail server login password
                    ea.setPush("Y");                        // 메일관련 푸시 수신여부
                    ea.setDefaultMail("Y");                    // 유저 기본 메일 설정 여부
                    ea.setMailserverId(
                        "gmail-ssl");        // 어드민센터: 설정 > 메일서버설정에 등록된 메일서버이름 중 한 개 (기본값 'gmail-ssl')
                    Map<String, Object> resEmailMap = eaSvc.insertMiapsUserEmailInfo(ea);
                    resultMap.put("Email", resEmailMap);    // 이메일 등록 결과 리턴 테이블에 추가
                }

                String jsonResult = CommonUtil.convertJson(resultMap);
                resultSb
                    .append(String.format(JVAL_CONTENTS, errCd, resMap.get("ERR_MSG").toString()))
                    .append(",\"res\":").append(jsonResult).append(JVAL_END);
            }
        } else {
            resultSb.append(String.format(JVAL_CONTENTS, -1, "로그인에 실패 했습니다.")).append(JVAL_END);
        }

        return resultSb.toString();
        //StringBuffer a = new StringBuffer();
        //a.append(String.format(JVAL_CONTENTS, -1, "패스워드를 확인 하세요.\n꼭 확인하세요")).append(JVAL_END); // \n테스트 코드
        //return a.toString();
    }

    public String getwelfareLists(Map<String, String> paramMap) throws Exception {

        if (log.isDebugEnabled()) {
            log.debug("params : " + paramMap);
        }

        StringBuilder resultSb = new StringBuilder();

        String pid = paramMap.get("id");

        Map<String, String> map = new HashMap<String, String>();
        map.put("id", pid);

        //MyBatis
        List<Map<String, Object>> resDataMap = (List<Map<String, Object>>) projectDao
            .selectwelfare(map);

        /* 2. MiAPS DB에 유저 추가  */
        if (resDataMap != null && resDataMap.size() > 0) {
            int errCd = 200;
            String jsonResult = CommonUtil.convertJson(resDataMap);
            resultSb.append(String.format(JVAL_CONTENTS, errCd, "성공")).append(",\"res\":")
                .append(jsonResult).append(JVAL_END);
        } else {
            resultSb.append(String.format(JVAL_CONTENTS, -1, "실패")).append(JVAL_END);
        }

//		Thread.sleep(500);

        return resultSb.toString();
        //StringBuffer a = new StringBuffer();
        //a.append(String.format(JVAL_CONTENTS, -1, "패스워드를 확인 하세요.\n꼭 확인하세요")).append(JVAL_END); // \n테스트 코드
        //return a.toString();
    }

    public String getwelfare_req_Lists(Map<String, String> paramMap) throws Exception {

        if (log.isDebugEnabled()) {
            log.debug("params : " + paramMap);
        }

        StringBuilder resultSb = new StringBuilder();

        String pid = paramMap.get("id");

        Map<String, String> map = new HashMap<String, String>();
        map.put("id", pid);
//		
        //MyBatis
        List<Map<String, Object>> resDataMap = (List<Map<String, Object>>) projectDao
            .select_req_welfare(map);

//		/* 2. MiAPS DB에 유저 추가  */
        if (resDataMap != null && resDataMap.size() > 0) {
            int errCd = 200;
            String jsonResult = CommonUtil.convertJson(resDataMap);
            resultSb.append(String.format(JVAL_CONTENTS, errCd, "성공")).append(",\"res\":")
                .append(jsonResult).append(JVAL_END);
        } else {
            resultSb.append(String.format(JVAL_CONTENTS, -1, "실패")).append(JVAL_END);
        }

//		Thread.sleep(500);

        return resultSb.toString();
        //StringBuffer a = new StringBuffer();
        //a.append(String.format(JVAL_CONTENTS, -1, "패스워드를 확인 하세요.\n꼭 확인하세요")).append(JVAL_END); // \n테스트 코드
        //return a.toString();
    }

    public String insert_getwelfare_req_Lists(Map<String, String> paramMap) throws Exception {

        if (log.isDebugEnabled()) {
            log.debug("params : " + paramMap);
        }

        StringBuilder resultSb = new StringBuilder();

        String pid = paramMap.get("userid");
        String ptitle = paramMap.get("reqtitle");
        String pdate = paramMap.get("reqdate");

        Map<String, String> map = new HashMap<String, String>();
        map.put("id", pid);
        map.put("title", ptitle);
        map.put("date", pdate);
//		
        //MyBatis
        String resCode = (String) projectDao.insert_req_welfare(map);

        //MyBatis
        List<Map<String, Object>> resDataMap = (List<Map<String, Object>>) projectDao
            .select_req_welfare(map);

//		/* 2. MiAPS DB에 유저 추가  */
        if (resDataMap != null && resDataMap.size() > 0) {
            int errCd = 200;
            String jsonResult = CommonUtil.convertJson(resDataMap);
            resultSb.append(String.format(JVAL_CONTENTS, errCd, "성공")).append(",\"res\":")
                .append(jsonResult).append(JVAL_END);
        } else {
            resultSb.append(String.format(JVAL_CONTENTS, -1, "실패")).append(JVAL_END);
        }

//		Thread.sleep(500);

        return resultSb.toString();
    }
}