package com.mink.connectors.hybridtest.login;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.mink.connectors.hybridtest.common.BaseMan;
import com.thinkm.mink.commons.util.MinkConfig;

public class PatternLoginMan extends BaseMan {

	private Logger log = LoggerFactory.getLogger(getClass());

	/**
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public String login(Map<String, String> param, Object connection) throws Exception {

		String  result = null;
		
		try {
			result = ((PatternLoginService) getBean("project.PatternLoginService")).login(param);
			
		} catch (Exception e) {
			String msg = MinkConfig.getConfig().get("execute.status.fail.msg");
			
			log.error(e.getMessage(), e);
			StringBuilder errorResult = new StringBuilder();
			errorResult.append("{\"code\":\"-1\", \"msg\":\"").append(msg).append("\"}");
			return errorResult.toString();
			
		} finally {
		}
		
		return result;
	}
}

