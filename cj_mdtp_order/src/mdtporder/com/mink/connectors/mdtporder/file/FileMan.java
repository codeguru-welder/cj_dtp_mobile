package com.mink.connectors.mdtporder.file;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.thinkm.mink.commons.util.ApplicationContextUtil;
import com.thinkm.mink.commons.util.MinkConfig;

public class FileMan {

	private Logger log = LoggerFactory.getLogger(getClass());

	// File Service
	private FileService fileService = (FileService) ApplicationContextUtil.getBean("project.FileService");
	
	/**
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public String saveObject(Map<String, String> param, Object connection) throws Exception {

		String  result = null;
		
		try {
			result = fileService.saveObject(param);
			
		} catch (Exception e) {
			String msg = MinkConfig.getConfig().get("execute.status.fail.msg");
			
			log.error(e.getMessage(), e);
			StringBuilder errorResult = new StringBuilder();
			errorResult.append("{\"code\":\"-1\", \"msg\":\"").append(msg).append("\"}");
			return errorResult.toString();
		}
		
		return result;
	}
}

