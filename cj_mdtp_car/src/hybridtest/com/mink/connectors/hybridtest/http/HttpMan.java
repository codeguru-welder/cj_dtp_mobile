package com.mink.connectors.hybridtest.http;

import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.mink.connectors.hybridtest.common.BaseMan;
import com.mink.connectors.hybridtest.login.LoginService;
import com.thinkm.mink.commons.util.MiapsResultStrUtil;
import com.thinkm.mink.commons.util.MinkConfig;

public class HttpMan extends BaseMan {

	private Logger log = LoggerFactory.getLogger(getClass());

	/**
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public String httpLogin(Map<String, String> param, Object connection) throws Exception {

		String  result = null;
		
		try {
			result = ((HttpService) getBean("project.HttpLoginService")).httpLogin(param);
		} catch (Exception e) {
			String msg = MinkConfig.getConfig().get("common.login.fail.msg");
			
			if(StringUtils.defaultString(e.getMessage()).startsWith("[miaps]")) {
				msg = e.getMessage().substring(7);
			}
			
			log.error(e.getMessage(), e);
			StringBuilder errorResult = new StringBuilder();
			MiapsResultStrUtil.makeCmResultSb(errorResult, "E", msg);
			
			return errorResult.toString();
		} finally {
		}
		
		return result;
	}

}

