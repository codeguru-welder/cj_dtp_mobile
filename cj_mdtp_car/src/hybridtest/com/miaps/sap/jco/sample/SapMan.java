/**
 * Project : Mobile Office(Mink) Solution
 * 
 * Copyright 2009 by Solution Development Team, thinkM, Inc., All rights reserved.
 * This software is proprietary information
 * of thinkM, Inc. You shall not 
 * disclose such Confidential Information and shall use it 
 * only in accordance with the terms of the license agreement
 * you entered into with thinkM.
 */
package com.miaps.sap.jco.sample;

import java.util.Map;

import org.apache.commons.lang.StringUtils;

import com.thinkm.mink.commons.MinkTotalConstants;
import com.thinkm.mink.commons.util.ApplicationContextUtil;

/**
 * 클라이언트 인터페이스
 * 
 * @version		2015.07.21
 * @author		thinkm(ek)
 */
public class SapMan {
	private static final char FS = MinkTotalConstants.FS;
	private static final char RS = MinkTotalConstants.RS;
	
	@SuppressWarnings("unchecked")
	public String run(Map<String, String> params, Object connection) {
		SapService service = ApplicationContextUtil.getBean("sample.SapService", SapService.class);
		
		try {
			Map<String, Object> result = service.execute(params);
			
			Map<String, Object> tableParameterList = (Map<String, Object>) result.get("tableParameterList");
			Map<String, Object> structure = (Map<String, Object>) result.get("structure");
			Map<String, Object> initialized = (Map<String, Object>) result.get("initialized");
			
			StringBuilder sb = new StringBuilder();
			StringBuilder sb_header = new StringBuilder();
			StringBuilder sb_value = new StringBuilder();
			
			// initialized
			sb_header.append("errCode").append(FS).append("errMsg");
			sb_value.append("S").append(FS).append("응답성공");
			
			int i = 0;
			int size = initialized.size();
			for (String name : initialized.keySet()) {
				if (i == 0) {
					sb_header.append(FS);
					sb_value.append(FS);
				}
				
				Object v = initialized.get(name);
				sb_header.append(name);
				sb_value.append(getValue(v));
				
				if (i != size - 1) {
					sb_header.append(FS);
					sb_value.append(FS);
				}
			}
			
			sb_header.append(RS);
			sb_value.append(RS);
			sb.append(sb_header.toString());
			sb.append(sb_value.toString());
			
			// structure
			for (String name : structure.keySet()) {
				sb.append("{{{+" + name + "+}}}").append(RS);
				// ...
			}
			
			// tableParameterList
			for (String name : tableParameterList.keySet()) {
				sb.append("{{{+" + name + "+}}}").append(RS);
				// ...
			}
			
			return sb.toString();
		} catch (Throwable t) {
			StringBuilder sb = new StringBuilder();
			
			sb.append("errCode").append(FS).append("errMsg").append(RS);
			sb.append("E").append(FS).append(t.getMessage()).append(RS);
			
			return sb.toString();
		}
	}
	
	private String getValue(Object v) {
		return StringUtils.defaultString((String) v);
	}

}
