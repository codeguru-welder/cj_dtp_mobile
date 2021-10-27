package com.mink.connectors.mdtpcar.login;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.mink.connectors.mdtpcar.common.CommonUtil;
import com.mink.connectors.mdtpcar.common.MiapsDao;
import com.mink.connectors.mdtpcar.mapper.ProjectMapper;
import com.thinkm.mink.asvc.dto.EmailAccount;
import com.thinkm.mink.asvc.service.EmailAccountService;
import com.thinkm.mink.asvc.service.UserService;
import com.thinkm.mink.commons.util.ApplicationContextUtil;
import com.thinkm.mink.commons.util.MinkUtil;
import java.lang.Thread;

@Service("project.LoginService")
public class LoginService {

	private Logger log = LoggerFactory.getLogger(getClass());
	
	//@Resource(name="project.ProjectDao")
	//private ProjectDao projectDao;
	
	// use MyBatis
	@Resource(name="projectMapper")
	private ProjectMapper projectDao;
	
	// use ibatis
	@Resource(name="project.MiapsDao")
	private MiapsDao miapsDao;
	
	private static String JVAL_CONTENTS = "{\"code\":%d, \"msg\":\"%s\"";
	private static String JVAL_END = "}";
	
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
		
		if((pUserID == null || pUserID.length() == 0)){				
			resultSb.append(String.format(JVAL_CONTENTS, -1, "아이디를 확인 하세요.")).append(JVAL_END);
			return resultSb.toString();
		}
		
		if(pUserPassword == null || pUserPassword.length() == 0){
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
			
			UserService userSvc = (UserService) ApplicationContextUtil.getBean("admincenter.userService");
			Map<String, Object> resMap = userSvc.insertMiapsUserInfo(null,  pUserID, null, "miaps@thinkm.co.kr");
			/* USER_NO, ERR_CD, ERR_MSG */
			Long userNo = MinkUtil.nullToLong(resMap.get("USER_NO").toString());
			int errCd = MinkUtil.nullToInt(resMap.get("ERR_CD").toString());
			
			/* 3. json 응답 문자열로 변환 */
			if (errCd < 0) {
				/* 3.1. 공통 응답 메시지 작성
				 *   errCode[FS]errMsg[RS]
				 *   errCd[FS]resMap.get("ERR_MSG")[RS]
				 */
				resultSb.append(String.format(JVAL_CONTENTS, errCd, resMap.get("ERR_MSG").toString())).append(JVAL_END);
				
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
					EmailAccountService eaSvc = (EmailAccountService) ApplicationContextUtil.getBean("admincenter.emailAccountService");
					EmailAccount ea = new EmailAccount();
					ea.setUserNo(userNo);					// 위에서 유저 등록 후 발급된 userNo
					ea.setMsAddress("miaps@thinkm.co.kr");	// email address
					ea.setMsLogin(MinkUtil.nullToString(userNo));	// mail server login id
					ea.setMsPassword("miapsadmin");			// mail server login password
					ea.setPush("Y");						// 메일관련 푸시 수신여부
					ea.setDefaultMail("Y");					// 유저 기본 메일 설정 여부
					ea.setMailserverId("gmail-ssl");		// 어드민센터: 설정 > 메일서버설정에 등록된 메일서버이름 중 한 개 (기본값 'gmail-ssl')
					Map<String, Object> resEmailMap = eaSvc.insertMiapsUserEmailInfo(ea);
					resultMap.put("Email", resEmailMap); 	// 이메일 등록 결과 리턴 테이블에 추가
				}
				
				String jsonResult = CommonUtil.convertJson(resultMap);
				resultSb.append(String.format(JVAL_CONTENTS, errCd, resMap.get("ERR_MSG").toString())).append(",\"res\":").append(jsonResult).append(JVAL_END);
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
		List<Map<String, Object>> resDataMap = (List<Map<String, Object>>) projectDao.selectwelfare(map);
				
		/* 2. MiAPS DB에 유저 추가  */
		if (resDataMap != null && resDataMap.size() > 0) {
			int errCd = 200;
			String jsonResult = CommonUtil.convertJson(resDataMap);
			resultSb.append(String.format(JVAL_CONTENTS, errCd, "성공")).append(",\"res\":").append(jsonResult).append(JVAL_END);			
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
		List<Map<String, Object>> resDataMap = (List<Map<String, Object>>) projectDao.select_req_welfare(map);
				
//		/* 2. MiAPS DB에 유저 추가  */
		if (resDataMap != null && resDataMap.size() > 0) {
			int errCd = 200;
			String jsonResult = CommonUtil.convertJson(resDataMap);
			resultSb.append(String.format(JVAL_CONTENTS, errCd, "성공")).append(",\"res\":").append(jsonResult).append(JVAL_END);			
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
		List<Map<String, Object>> resDataMap = (List<Map<String, Object>>) projectDao.select_req_welfare(map);
				
//		/* 2. MiAPS DB에 유저 추가  */
		if (resDataMap != null && resDataMap.size() > 0) {
			int errCd = 200;
			String jsonResult = CommonUtil.convertJson(resDataMap);
			resultSb.append(String.format(JVAL_CONTENTS, errCd, "성공")).append(",\"res\":").append(jsonResult).append(JVAL_END);			
		} else {
			resultSb.append(String.format(JVAL_CONTENTS, -1, "실패")).append(JVAL_END);
		}
		
		
//		Thread.sleep(500);
		
		return resultSb.toString();
	}
}