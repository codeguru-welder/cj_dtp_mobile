package com.mink.connectors.hybridtest.receivedata;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.mink.connectors.hybridtest.common.BaseMan;
import com.thinkm.mink.commons.util.MinkConfig;

public class ReceiveDataMan extends BaseMan {

	private Logger log = LoggerFactory.getLogger(getClass());
	
	/* Connector에서 HttpServletRequest, HttpServletResponse객체를 사용하는 방법 추가 */
	private HttpServletRequest req = null;
	private HttpServletResponse res = null;

	public void setHttpServletRequest(HttpServletRequest request) {
		this.req = request;
	}
	
    public void setHttpServletResponse(HttpServletResponse response) {
    	this.res = response;
    }
    /*여기까지*/

	/**
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public String receiveData(Map<String, String> param, Object connection) throws Exception {

		String  result = null;
		
		try {
			result = ((ReceiveDataService) getBean("project.ReceiveDataService")).receiveData(param);
			
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

