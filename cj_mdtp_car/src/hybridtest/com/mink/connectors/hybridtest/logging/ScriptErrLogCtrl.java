package com.mink.connectors.hybridtest.logging;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.mink.connectors.hybridtest.common.BaseMan;

public class ScriptErrLogCtrl extends BaseMan {

	private Logger log = LoggerFactory.getLogger(ScriptErrLogCtrl.class);

	private HttpServletRequest req = null;
	private HttpServletResponse res = null;

	public void setHttpServletRequest(HttpServletRequest request) {
		this.req = request;
	}
	
    public void setHttpServletResponse(HttpServletResponse response) {
    	this.res = response;
    }

    public void logging(Map<String, String> params, Object connection) throws Exception {
    	((ScriptErrLogService) getBean("scriptErrLogService")).logging(params);
	}
}

