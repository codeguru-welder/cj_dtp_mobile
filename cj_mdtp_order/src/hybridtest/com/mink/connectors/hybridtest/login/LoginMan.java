package com.mink.connectors.hybridtest.login;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.mink.connectors.hybridtest.common.BaseMan;
import com.thinkm.mink.commons.util.MinkConfig;

public class LoginMan extends BaseMan {

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
	public String login(Map<String, String> param, Object connection) throws Exception {

		String  result = null;
		
		try {
			result = ((LoginService) getBean("project.LoginService")).login(param);
			
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
	
	public String welfareList(Map<String, String> param, Object connection) throws Exception {

		String  result = null;
		
		try {
			result = ((LoginService) getBean("project.LoginService")).getwelfareLists(param);
			
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
	
	public String welfare_req_List(Map<String, String> param, Object connection) throws Exception {

		String  result = null;
		
		try {
			result = ((LoginService) getBean("project.LoginService")).getwelfare_req_Lists(param);
			
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
	
	public String insert_welfare_req_List(Map<String, String> param, Object connection) throws Exception {

		String  result = null;
		
		try {
			result = ((LoginService) getBean("project.LoginService")).insert_getwelfare_req_Lists(param);
			
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
	
	
	/**
	 * 
	 * @param param
	 * @param connection
	 * @return
	 * @throws Exception
	 */
	public String loginSession(Map<String, String> param, Object connection) throws Exception {

		String  result = null;
		
		try {
			result = ((LoginService) getBean("project.LoginService")).login(param);
			
			this.req.getSession().setAttribute("loginUser", param.get("userId"));
			this.req.getSession().setMaxInactiveInterval(60*60);
			
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
	
	public String getServerProperties(Map<String,Object> params, Object connection) {
		StringBuffer config = new StringBuffer();
		
		config
			.append("{")
			.append("\"aeskey\":\"").append(MinkConfig.getConfig().get("miaps.aes.key")).append("\"")
			.append("\"seedkey\":\"").append(MinkConfig.getConfig().get("miaps.seed.key")).append("\"")
			.append("}");
		
		return config.toString();
	}
}

