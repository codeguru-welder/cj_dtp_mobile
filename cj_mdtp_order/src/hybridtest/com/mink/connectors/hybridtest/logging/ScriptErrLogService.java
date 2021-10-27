package com.mink.connectors.hybridtest.logging;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.mink.connectors.hybridtest.mapper.LoggingMapper;
import com.thinkm.mink.commons.MinkTotalConstants;

@Service("scriptErrLogService")
public class ScriptErrLogService {

	private Logger log = LoggerFactory.getLogger(ScriptErrLogService.class);

	// use MyBatis
	@Resource(name="loggingMapper")
	private LoggingMapper loggingMapper;
	
	private HttpServletRequest req = null;
	private HttpServletResponse res = null;

	public void setHttpServletRequest(HttpServletRequest request) {
		this.req = request;
	}
	
    public void setHttpServletResponse(HttpServletResponse response) {
    	this.res = response;
    }

    private String digit(int i) {
		return (i < 10 ? "0" : "")  + i;
	}
    
	public void logging(Map<String, String> params) throws Exception {
		try {
			Map<String, Object> logMap = new HashMap<String, Object>();
			
			Calendar c = Calendar.getInstance();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmsss");
			String d = sdf.format(new Date());
			
			String userId = params.get("userid");
			String deviceId = params.get("deviceid");
			String reqTime = d;
			String packageNm = params.get("packagenm");
			String model = params.get("md");
			String os = params.get("os");					
			String platformCd = params.get("platformcd");
			if (StringUtils.isNotBlank(platformCd)) {
				if (MinkTotalConstants.PLATFORM_IOS.equals(platformCd)) {	// iphone
					platformCd = "IPHONE";
				} else if (MinkTotalConstants.PLATFORM_IOS_TBL.equals(platformCd)) { // ipad
					platformCd = "IPAD";
				} else if (MinkTotalConstants.PLATFORM_ANDROID.equals(platformCd)) { // andriod phone
					platformCd = "APHONE";
				} else if (MinkTotalConstants.PLATFORM_ANDROID_TBL.equals(platformCd)) { // android tablet
					platformCd = "APAD";
				}
			} else {
				platformCd = "None";
			}
			
			String reqVersion = params.get("versionnm");
			if (StringUtils.isNotBlank(reqVersion)) {
				reqVersion = params.get("versionnm");
			} else {
				reqVersion = params.get("version");
			}
			
			String data = params.get("err");
			if (data.length() > 4000) {
				data = data.substring(0, 4000);
			}
			
			logMap.put("logTm", c.getTimeInMillis());		
			logMap.put("logYear", c.get(Calendar.YEAR));
			logMap.put("logMonth", digit(c.get(Calendar.MONTH) + 1));
			logMap.put("logDay", digit(c.get(Calendar.DATE)));
			logMap.put("deviceId", deviceId);
			logMap.put("userId", userId);			
			logMap.put("reqParams", data);
			logMap.put("reqTime", reqTime);
			logMap.put("reqVersion", reqVersion);
			logMap.put("packageNm", packageNm);
			logMap.put("platform", platformCd);
			logMap.put("model", model);
			logMap.put("os", os);
			
			loggingMapper.insertScriptErrLog(logMap);
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}

