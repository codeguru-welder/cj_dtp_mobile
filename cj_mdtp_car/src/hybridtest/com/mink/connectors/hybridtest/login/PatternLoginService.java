package com.mink.connectors.hybridtest.login;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service("project.PatternLoginService")
public class PatternLoginService {

	private Logger log = LoggerFactory.getLogger(getClass());
	
	private static String JVAL_CONTENTS = "{\"code\":\"%d\", \"msg\":\"%s\"";
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
		String pUserPattern = paramMap.get("pt");
		
		if((pUserID == null || pUserID.length() == 0)){				
			resultSb.append(String.format(JVAL_CONTENTS, -1, "아이디 정보가 없습니다.")).append(JVAL_END);
			return resultSb.toString();
		}
		
		if(pUserPattern == null || pUserPattern.length() == 0){
			resultSb.append(String.format(JVAL_CONTENTS, -1, "패턴 정보가 없습니다.")).append(JVAL_END);
			return resultSb.toString();
		}
		
		if ("miaps".equals(pUserID) && "12357".equals(pUserPattern)) {
			resultSb.append(String.format(JVAL_CONTENTS, 0, "OK")).append(JVAL_END);
		} else {
			resultSb.append(String.format(JVAL_CONTENTS, -1, "ID또는 패턴을 확인 해 주세요.")).append(JVAL_END);
		}
		
		return resultSb.toString();
	}
}