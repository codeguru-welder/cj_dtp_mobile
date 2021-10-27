package com.mink.connectors.hybridtest.http;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.mink.connectors.hybridtest.common.MiapsDao;
import com.thinkm.mink.asvc.dao.CommonDao;
import com.thinkm.mink.commons.httpclient.MinkPoolableHttpClient;
import com.thinkm.mink.commons.util.ApplicationContextUtil;
import com.thinkm.mink.commons.util.DateUtil;
import com.thinkm.mink.commons.util.MiapsResultStrUtil;


@Service("project.HttpLoginService")
public class HttpService {

	private Logger log = LoggerFactory.getLogger(getClass());
	
	// use ibatis
	@Resource(name="project.MiapsDao")
	private MiapsDao miapsDao;
	
	/**
	 * @param paramMap
	 * @return
	 * @throws Exception 
	 */
	@SuppressWarnings({ "deprecation" })
	public String httpLogin(Map<String, String> paramMap) throws Exception {

		if (log.isDebugEnabled()) {
			log.debug("params : " + paramMap);
		}
		
		StringBuilder resultSb = new StringBuilder();
		
		String pUserID = paramMap.get("uid");
		String pUserPassword = paramMap.get("upw");
		
		Map<String, String> map = new HashMap<String, String>();
		map.put("id", pUserID);
		map.put("pw", pUserPassword);
		
		if((pUserID == null || pUserID.length() == 0)){				
			MiapsResultStrUtil.makeCmResultSb(resultSb, "E", "아이디를 확인 하세요.");
			return resultSb.toString();
		}
		
		if(pUserPassword == null || pUserPassword.length() == 0){
			MiapsResultStrUtil.makeCmResultSb(resultSb, "E", "패스워드를 확인 하세요.");
			return resultSb.toString();
		}
		
		/* 1. Project Server에서 유저 체크*/
		String url = "http://192.168.0.2:9999/project/login.do";
		String method = MinkPoolableHttpClient.POST;
		String char_set = "UTF-8";
		int responseCode = -1;
		String responseString = null;
		MinkPoolableHttpClient hc = null;
		
		try {
			hc = new MinkPoolableHttpClient(url, method, map, char_set, true);

			responseCode = hc.execute();
			if (responseCode != 200) {
				StringBuilder errorResult = new StringBuilder();
				MiapsResultStrUtil.makeCmResultSb(errorResult, "E", "로그인에 실패 했습니다.");
				return errorResult.toString();
			}
			
			/* 결과 취득 */
			responseString = hc.getResponseBodyAsString(); 
		
			/* 1.1 회원검증 */
			/* responseString이 userId */
		
		} catch (Exception e) {
			
		} finally {
			if (hc != null) {
				hc.release();
			}
		}
		
		/* 2. MiAPS DB에 유저 추가 (MiAPS DB에 없을 경우에만) 
		 * : newUserNo를 취득하여 insert하는 것은 MiAPS가 여러 DB를 지원하기 때문에 각 DB별로 시퀀스 취득하는 법이 달라서 공통으로 처리하기 위함 입니다.
		 * : 각 프로젝트에서 사용할 때는 newUserNo를 취득하지 마시고 프로젝트별 DB에 맞게 시퀀스를 취득하여 바로 insert하도록 하는 것이 좋습니다. 
		 */
		if (responseString != null && responseString.length() > 0) {
			/* primaryKey(sequence) setting */
			CommonDao commonDao = (CommonDao) ApplicationContextUtil.getBean("admincenter.commonDao");
			Long newUserNo = commonDao.getPrimaryKey("miaps_user");
			String regDt = DateUtil.format("yyyyMMddHHmmss");
		
			Map<String, Object> userMap = new HashMap<String, Object>();
			userMap.put("userNo", newUserNo);
			userMap.put("userId", responseString);
			userMap.put("regDt", regDt);
						
			miapsDao.insert("MiapsUser.insertMiapsUser", userMap);
		}
		
		/* 3. MiAPS 응답 문자열로 변환 */		
		/* 3.1. 공통 응답 메시지 작성
		 *   errCode[FS]errMsg[RS]
		 *   S[FS]OK[RS]
		 */
		MiapsResultStrUtil.makeCmResultSb(resultSb, "S", "OK");
		
		/* 결로 응답 메시지 로그에 기록 */
		if (log.isDebugEnabled()) {
			log.debug("result == " + resultSb.toString());
			/* [응답데이터]
			   errCode[FS]errMsg[RS]
			   S[FS]OK[RS]
			 */
		}
		
		return resultSb.toString();
	}
}