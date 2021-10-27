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

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.sap.conn.jco.JCoContext;
import com.sap.conn.jco.JCoDestination;
import com.sap.conn.jco.JCoDestinationManager;
import com.sap.conn.jco.JCoException;
import com.sap.conn.jco.JCoFunction;
import com.sap.conn.jco.JCoRepository;

/**
 * JCoConnection allows to get and execute SAP functions. The constructor expect a
 * SapSystem and will save the connection data to a file. The connection will
 * also be automatically be established.
 * 
 * @version		2015.05.11
 * @author		thinkm(think03)
 */
public class JCoConnection {
	private Logger log = LoggerFactory.getLogger(getClass());
	
	static String SAP_SERVER = "ABAB_AS_WITH_POOL"; // ABAP_AS // ABAP_AS_WITHOUT_POOL // ABAB_AS_WITH_POOL
	private JCoRepository repos;
	private JCoDestination dest;

	public JCoConnection(SapSystem system) {
		MyDestinationDataProvider myProvider = new MyDestinationDataProvider(system);
		
		if (!com.sap.conn.jco.ext.Environment.isDestinationDataProviderRegistered()) {
			com.sap.conn.jco.ext.Environment.registerDestinationDataProvider(myProvider);
		}
		
		try {
			dest = JCoDestinationManager.getDestination(SAP_SERVER);
//			System.out.println("Attributes:");
//			System.out.println(dest.getAttributes());
			repos = dest.getRepository();
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}
	
	public JCoConnection(Properties properties) {
		MyDestinationDataProvider myProvider = new MyDestinationDataProvider();
		
		myProvider.changePropertiesForABAP_AS(properties);
		
		if (!com.sap.conn.jco.ext.Environment.isDestinationDataProviderRegistered()) {
			com.sap.conn.jco.ext.Environment.registerDestinationDataProvider(myProvider);
		}
		
		try {
			dest = JCoDestinationManager.getDestination(SAP_SERVER);
//			System.out.println("Attributes:");
//			System.out.println(dest.getAttributes());
			repos = dest.getRepository();
			repos.clear(); // clear the cache
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}
	
	/**
	 * Method getFunction read a SAP Function and return it to the caller. The
	 * caller can then set parameters (import, export, tables) on this function
	 * and call later the method execute.
	 * 
	 * getFunction translates the JCo checked exceptions into a non-checked
	 * exceptions
	 */
	public JCoFunction getFunction(String functionStr) {
		JCoFunction function = null;
		try {
			repos.clear(); // clear the cache
			function = repos.getFunction(functionStr);
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException(
					"Problem retrieving JCO.Function object.");
		}
		if (function == null) {
			throw new RuntimeException("Not possible to receive function. ");
		}

		return function;
	}

	/**
	 * Method execute will call a function. The Caller of this function has
	 * already set all required parameters of the function
	 * @throws Exception 
	 */
	public void execute(JCoFunction function) throws Exception {
		try {
			JCoContext.begin(dest);
			function.execute(dest);
		} catch (JCoException e) {
			log.error(e.getMessage(), e);
			throw e;
		} finally {
			try {
				JCoContext.end(dest);
			} catch (JCoException e) {
				e.printStackTrace();
			}
		}
	}

}

