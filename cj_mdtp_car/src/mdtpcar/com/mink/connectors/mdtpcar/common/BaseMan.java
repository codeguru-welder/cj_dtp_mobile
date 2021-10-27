package com.mink.connectors.mdtpcar.common;

import com.thinkm.mink.commons.util.ApplicationContextUtil;

public class BaseMan {
	
	public Object getBean(String beanName) {
		Object ob = ApplicationContextUtil.getBean(beanName);
		return ob;
	}
}
