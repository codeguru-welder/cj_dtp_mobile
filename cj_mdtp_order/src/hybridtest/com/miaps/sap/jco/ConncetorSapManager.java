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
package com.miaps.sap.jco;

import java.util.Properties;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sap.conn.jco.JCoFunction;

/**
 * SAP 커넥션 Manager
 * 
 * @version		2015.05.11
 * @author		thinkm(think03)
 */
@Service("sap.jco.sample.ConncetorSapManager")
public class ConncetorSapManager {
	private JCoConnection connect;
	
	@Autowired
	Properties prop;
	
	public ConncetorSapManager(SapSystem system) {
		connect = new JCoConnection(system);
	}
	
	//public ConncetorSapManager(Properties properties) {
	public ConncetorSapManager() { 
		//SapSystem system = new SapSystem(properties);
		SapSystem system = new SapSystem(prop);
		Properties connectProperties = system.getConnectProperties();
		connect = new JCoConnection(connectProperties);
	}
	
	public ConncetorSapManager(String jco_client, String jco_group, String jco_lang, String jco_mshost, String jco_msserv, String jco_passwd, String jco_r3name, String jco_user) {
		SapSystem system = new SapSystem(jco_client, jco_group, jco_lang, jco_mshost, jco_msserv, jco_passwd, jco_r3name, jco_user);
		connect = new JCoConnection(system);
	}
	
	public ConncetorSapManager(String jco_ashost, String jco_client, String jco_lang, String jco_passwd, String jco_sysnr, String jco_user) {
		SapSystem system = new SapSystem(jco_ashost, jco_client, jco_lang, jco_passwd, jco_sysnr, jco_user);
		connect = new JCoConnection(system);
	}
	
	public JCoFunction getSAPJCoFunction(String functionName) throws Exception {
		return connect.getFunction(functionName);
	}
	
	public void executeJCoFunction(JCoFunction function) throws Exception {
		connect.execute(function);
	}

}// end class
