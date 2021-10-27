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

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

import com.sap.conn.jco.ext.DestinationDataProvider;

/**
 * SAP 접속정보 properties VO
 * 참고: salesportal.sap.{mink.runmode}.properties
 * 
 * @version		2015.05.11
 * @author		thinkm(think03)
 */
public class SapSystem implements java.lang.Cloneable {
	private final String JCO_ALIAS_USER;
	private final String JCO_ASHOST;
	private final String JCO_AUTH_TYPE;
	private final String JCO_AUTH_TYPE_CONFIGURED_USER;
	private final String JCO_AUTH_TYPE_CURRENT_USER;
	private final String JCO_CLIENT;
	private final String JCO_CODEPAGE;
	private final String JCO_CPIC_TRACE;
	private final String JCO_DEST;
	private final String JCO_EXPIRATION_PERIOD;
	private final String JCO_EXPIRATION_TIME;
	private final String JCO_GETSSO2;
	private final String JCO_GROUP;
	private final String JCO_GWHOST;
	private final String JCO_GWSERV;
	private final String JCO_LANG;
	private final String JCO_LCHECK;
	private final String JCO_MAX_GET_TIME;
	private final String JCO_MSHOST;
	private final String JCO_MSSERV;
	private final String JCO_MYSAPSSO2;
	private final String JCO_PASSWD;
	private final String JCO_PCS;
	private final String JCO_PEAK_LIMIT;
	private final String JCO_POOL_CAPACITY;
	private final String JCO_R3NAME;
	private final String JCO_REPOSITORY_DEST;
	private final String JCO_REPOSITORY_PASSWD;
	private final String JCO_REPOSITORY_SNC;
	private final String JCO_REPOSITORY_USER;
	private final String JCO_SAPROUTER;
	private final String JCO_SNC_LIBRARY;
	private final String JCO_SNC_MODE;
	private final String JCO_SNC_MYNAME;
	private final String JCO_SNC_PARTNERNAME;
	private final String JCO_SNC_QOP;
	private final String JCO_SYSNR;
	private final String JCO_TPHOST;
	private final String JCO_TPNAME;
	private final String JCO_TRACE;
	private final String JCO_TYPE;
	private final String JCO_USE_SAPGUI;
	private final String JCO_USER;
	private final String JCO_USER_ID;
	private final String JCO_X509CERT;
	
	/**
	 * Constructor
	 * 
	 * @param jco_alias_user
	 * @param jco_ashost
	 * @param jco_auth_type
	 * @param jco_auth_type_configured_user
	 * @param jco_auth_type_current_user
	 * @param jco_client
	 * @param jco_codepage
	 * @param jco_cpic_trace
	 * @param jco_dest
	 * @param jco_expiration_period
	 * @param jco_expiration_time
	 * @param jco_getsso2
	 * @param jco_group
	 * @param jco_gwhost
	 * @param jco_gwserv
	 * @param jco_lang
	 * @param jco_lcheck
	 * @param jco_max_get_time
	 * @param jco_mshost
	 * @param jco_msserv
	 * @param jco_mysapsso2
	 * @param jco_passwd
	 * @param jco_pcs
	 * @param jco_peak_limit
	 * @param jco_pool_capacity
	 * @param jco_r3name
	 * @param jco_repository_dest
	 * @param jco_repository_passwd
	 * @param jco_repository_snc
	 * @param jco_repository_user
	 * @param jco_saprouter
	 * @param jco_snc_library
	 * @param jco_snc_mode
	 * @param jco_snc_myname
	 * @param jco_snc_partnername
	 * @param jco_snc_qop
	 * @param jco_sysnr
	 * @param jco_tphost
	 * @param jco_tpname
	 * @param jco_trace
	 * @param jco_type
	 * @param jco_use_sapgui
	 * @param jco_user
	 * @param jco_user_id
	 * @param jco_x509cert
	 */
	public SapSystem(String jco_alias_user,
						String jco_ashost,
						String jco_auth_type,
						String jco_auth_type_configured_user,
						String jco_auth_type_current_user,
						String jco_client,
						String jco_codepage,
						String jco_cpic_trace,
						String jco_dest,
						String jco_expiration_period,
						String jco_expiration_time,
						String jco_getsso2,
						String jco_group,
						String jco_gwhost,
						String jco_gwserv,
						String jco_lang,
						String jco_lcheck,
						String jco_max_get_time,
						String jco_mshost,
						String jco_msserv,
						String jco_mysapsso2,
						String jco_passwd,
						String jco_pcs,
						String jco_peak_limit,
						String jco_pool_capacity,
						String jco_r3name,
						String jco_repository_dest,
						String jco_repository_passwd,
						String jco_repository_snc,
						String jco_repository_user,
						String jco_saprouter,
						String jco_snc_library,
						String jco_snc_mode,
						String jco_snc_myname,
						String jco_snc_partnername,
						String jco_snc_qop,
						String jco_sysnr,
						String jco_tphost,
						String jco_tpname,
						String jco_trace,
						String jco_type,
						String jco_use_sapgui,
						String jco_user,
						String jco_user_id,
						String jco_x509cert) {
		
		this.JCO_ALIAS_USER = jco_alias_user;
		this.JCO_ASHOST = jco_ashost;
		this.JCO_AUTH_TYPE = jco_auth_type;
		this.JCO_AUTH_TYPE_CONFIGURED_USER = jco_auth_type_configured_user;
		this.JCO_AUTH_TYPE_CURRENT_USER = jco_auth_type_current_user;
		this.JCO_CLIENT = jco_client;
		this.JCO_CODEPAGE = jco_codepage;
		this.JCO_CPIC_TRACE = jco_cpic_trace;
		this.JCO_DEST = jco_dest;
		this.JCO_EXPIRATION_PERIOD = jco_expiration_period;
		this.JCO_EXPIRATION_TIME = jco_expiration_time;
		this.JCO_GETSSO2 = jco_getsso2;
		this.JCO_GROUP = jco_group;
		this.JCO_GWHOST = jco_gwhost;
		this.JCO_GWSERV = jco_gwserv;
		this.JCO_LANG = jco_lang;
		this.JCO_LCHECK = jco_lcheck;
		this.JCO_MAX_GET_TIME = jco_max_get_time;
		this.JCO_MSHOST = jco_mshost;
		this.JCO_MSSERV = jco_msserv;
		this.JCO_MYSAPSSO2 = jco_mysapsso2;
		this.JCO_PASSWD = jco_passwd;
		this.JCO_PCS = jco_pcs;
		this.JCO_PEAK_LIMIT = jco_peak_limit;
		this.JCO_POOL_CAPACITY = jco_pool_capacity;
		this.JCO_R3NAME = jco_r3name;
		this.JCO_REPOSITORY_DEST = jco_repository_dest;
		this.JCO_REPOSITORY_PASSWD = jco_repository_passwd;
		this.JCO_REPOSITORY_SNC = jco_repository_snc;
		this.JCO_REPOSITORY_USER = jco_repository_user;
		this.JCO_SAPROUTER = jco_saprouter;
		this.JCO_SNC_LIBRARY = jco_snc_library;
		this.JCO_SNC_MODE = jco_snc_mode;
		this.JCO_SNC_MYNAME = jco_snc_myname;
		this.JCO_SNC_PARTNERNAME = jco_snc_partnername;
		this.JCO_SNC_QOP = jco_snc_qop;
		this.JCO_SYSNR = jco_sysnr;
		this.JCO_TPHOST = jco_tphost;
		this.JCO_TPNAME = jco_tpname;
		this.JCO_TRACE = jco_trace;
		this.JCO_TYPE = jco_type;
		this.JCO_USE_SAPGUI = jco_use_sapgui;
		this.JCO_USER = jco_user;
		this.JCO_USER_ID = jco_user_id;
		this.JCO_X509CERT = jco_x509cert;
	}
	
	/**
	 * Constructor
	 * 
	 * @param jco_client
	 * @param jco_group
	 * @param jco_lang
	 * @param jco_mshost
	 * @param jco_msserv
	 * @param jco_passwd
	 * @param jco_r3name
	 * @param jco_user
	 */
	public SapSystem(String jco_client,
			String jco_group,
			String jco_lang,
			String jco_mshost,
			String jco_msserv,
			String jco_passwd,
			String jco_r3name,
			String jco_user) {
		
		this.JCO_ALIAS_USER = null;
		this.JCO_ASHOST = null;
		this.JCO_AUTH_TYPE = null;
		this.JCO_AUTH_TYPE_CONFIGURED_USER = null;
		this.JCO_AUTH_TYPE_CURRENT_USER = null;
		this.JCO_CLIENT = jco_client;
		this.JCO_CODEPAGE = null;
		this.JCO_CPIC_TRACE = null;
		this.JCO_DEST = null;
		this.JCO_EXPIRATION_PERIOD = null;
		this.JCO_EXPIRATION_TIME = null;
		this.JCO_GETSSO2 = null;
		this.JCO_GROUP = jco_group;
		this.JCO_GWHOST = null;
		this.JCO_GWSERV = null;
		this.JCO_LANG = jco_lang;
		this.JCO_LCHECK = null;
		this.JCO_MAX_GET_TIME = null;
		this.JCO_MSHOST = jco_mshost;
		this.JCO_MSSERV = jco_msserv;
		this.JCO_MYSAPSSO2 = null;
		this.JCO_PASSWD = jco_passwd;
		this.JCO_PCS = null;
		this.JCO_PEAK_LIMIT = null;
		this.JCO_POOL_CAPACITY = null;
		this.JCO_R3NAME = jco_r3name;
		this.JCO_REPOSITORY_DEST = null;
		this.JCO_REPOSITORY_PASSWD = null;
		this.JCO_REPOSITORY_SNC = null;
		this.JCO_REPOSITORY_USER = null;
		this.JCO_SAPROUTER = null;
		this.JCO_SNC_LIBRARY = null;
		this.JCO_SNC_MODE = null;
		this.JCO_SNC_MYNAME = null;
		this.JCO_SNC_PARTNERNAME = null;
		this.JCO_SNC_QOP = null;
		this.JCO_SYSNR = null;
		this.JCO_TPHOST = null;
		this.JCO_TPNAME = null;
		this.JCO_TRACE = null;
		this.JCO_TYPE = null;
		this.JCO_USE_SAPGUI = null;
		this.JCO_USER = jco_user;
		this.JCO_USER_ID = null;
		this.JCO_X509CERT = null;
	}
	
	/**
	 * Constructor
	 * 
	 * @param jco_ashost
	 * @param jco_client
	 * @param jco_lang
	 * @param jco_passwd
	 * @param jco_sysnr
	 * @param jco_user
	 */
	public SapSystem(String jco_ashost,
						String jco_client,
						String jco_lang,
						String jco_passwd,
						String jco_sysnr,
						String jco_user) {
		
		this.JCO_ALIAS_USER = null;
		this.JCO_ASHOST = jco_ashost;
		this.JCO_AUTH_TYPE = null;
		this.JCO_AUTH_TYPE_CONFIGURED_USER = null;
		this.JCO_AUTH_TYPE_CURRENT_USER = null;
		this.JCO_CLIENT = jco_client;
		this.JCO_CODEPAGE = null;
		this.JCO_CPIC_TRACE = null;
		this.JCO_DEST = null;
		this.JCO_EXPIRATION_PERIOD = null;
		this.JCO_EXPIRATION_TIME = null;
		this.JCO_GETSSO2 = null;
		this.JCO_GROUP = null;
		this.JCO_GWHOST = null;
		this.JCO_GWSERV = null;
		this.JCO_LANG = jco_lang;
		this.JCO_LCHECK = null;
		this.JCO_MAX_GET_TIME = null;
		this.JCO_MSHOST = null;
		this.JCO_MSSERV = null;
		this.JCO_MYSAPSSO2 = null;
		this.JCO_PASSWD = jco_passwd;
		this.JCO_PCS = null;
		this.JCO_PEAK_LIMIT = null;
		this.JCO_POOL_CAPACITY = null;
		this.JCO_R3NAME = null;
		this.JCO_REPOSITORY_DEST = null;
		this.JCO_REPOSITORY_PASSWD = null;
		this.JCO_REPOSITORY_SNC = null;
		this.JCO_REPOSITORY_USER = null;
		this.JCO_SAPROUTER = null;
		this.JCO_SNC_LIBRARY = null;
		this.JCO_SNC_MODE = null;
		this.JCO_SNC_MYNAME = null;
		this.JCO_SNC_PARTNERNAME = null;
		this.JCO_SNC_QOP = null;
		this.JCO_SYSNR = jco_sysnr;
		this.JCO_TPHOST = null;
		this.JCO_TPNAME = null;
		this.JCO_TRACE = null;
		this.JCO_TYPE = null;
		this.JCO_USE_SAPGUI = null;
		this.JCO_USER = jco_user;
		this.JCO_USER_ID = null;
		this.JCO_X509CERT = null;
	}
	
	/**
	 * Constructor
	 * 
	 * @param properties
	 */
	public SapSystem(Properties properties) {
		this.JCO_ALIAS_USER = properties.getProperty("JCO_ALIAS_USER");
		this.JCO_ASHOST = properties.getProperty("JCO_ASHOST");
		this.JCO_AUTH_TYPE = properties.getProperty("JCO_AUTH_TYPE");
		this.JCO_AUTH_TYPE_CONFIGURED_USER = properties.getProperty("JCO_AUTH_TYPE_CONFIGURED_USER");
		this.JCO_AUTH_TYPE_CURRENT_USER = properties.getProperty("JCO_AUTH_TYPE_CURRENT_USER");
		this.JCO_CLIENT = properties.getProperty("JCO_CLIENT");
		this.JCO_CODEPAGE = properties.getProperty("JCO_CODEPAGE");
		this.JCO_CPIC_TRACE = properties.getProperty("JCO_CPIC_TRACE");
		this.JCO_DEST = properties.getProperty("JCO_DEST");
		this.JCO_EXPIRATION_PERIOD = properties.getProperty("JCO_EXPIRATION_PERIOD");
		this.JCO_EXPIRATION_TIME = properties.getProperty("JCO_EXPIRATION_TIME");
		this.JCO_GETSSO2 = properties.getProperty("JCO_GETSSO2");
		this.JCO_GROUP = properties.getProperty("JCO_GROUP");
		this.JCO_GWHOST = properties.getProperty("JCO_GWHOST");
		this.JCO_GWSERV = properties.getProperty("JCO_GWSERV");
		this.JCO_LANG = properties.getProperty("JCO_LANG");
		this.JCO_LCHECK = properties.getProperty("JCO_LCHECK");
		this.JCO_MAX_GET_TIME = properties.getProperty("JCO_MAX_GET_TIME");
		this.JCO_MSHOST = properties.getProperty("JCO_MSHOST");
		this.JCO_MSSERV = properties.getProperty("JCO_MSSERV");
		this.JCO_MYSAPSSO2 = properties.getProperty("JCO_MYSAPSSO2");
		this.JCO_PASSWD = properties.getProperty("JCO_PASSWD");
		this.JCO_PCS = properties.getProperty("JCO_PCS");
		this.JCO_PEAK_LIMIT = properties.getProperty("JCO_PEAK_LIMIT");
		this.JCO_POOL_CAPACITY = properties.getProperty("JCO_POOL_CAPACITY");
		this.JCO_R3NAME = properties.getProperty("JCO_R3NAME");
		this.JCO_REPOSITORY_DEST = properties.getProperty("JCO_REPOSITORY_DEST");
		this.JCO_REPOSITORY_PASSWD = properties.getProperty("JCO_REPOSITORY_PASSWD");
		this.JCO_REPOSITORY_SNC = properties.getProperty("JCO_REPOSITORY_SNC");
		this.JCO_REPOSITORY_USER = properties.getProperty("JCO_REPOSITORY_USER");
		this.JCO_SAPROUTER = properties.getProperty("JCO_SAPROUTER");
		this.JCO_SNC_LIBRARY = properties.getProperty("JCO_SNC_LIBRARY");
		this.JCO_SNC_MODE = properties.getProperty("JCO_SNC_MODE");
		this.JCO_SNC_MYNAME = properties.getProperty("JCO_SNC_MYNAME");
		this.JCO_SNC_PARTNERNAME = properties.getProperty("JCO_SNC_PARTNERNAME");
		this.JCO_SNC_QOP = properties.getProperty("JCO_SNC_QOP");
		this.JCO_SYSNR = properties.getProperty("JCO_SYSNR");
		this.JCO_TPHOST = properties.getProperty("JCO_TPHOST");
		this.JCO_TPNAME = properties.getProperty("JCO_TPNAME");
		this.JCO_TRACE = properties.getProperty("JCO_TRACE");
		this.JCO_TYPE = properties.getProperty("JCO_TYPE");
		this.JCO_USE_SAPGUI = properties.getProperty("JCO_USE_SAPGUI");
		this.JCO_USER = properties.getProperty("JCO_USER");
		this.JCO_USER_ID = properties.getProperty("JCO_USER_ID");
		this.JCO_X509CERT = properties.getProperty("JCO_X509CERT");
	}
	
	public Properties getConnectProperties() {
		Properties properties = new Properties();
		
		if(StringUtils.isNotBlank(JCO_ALIAS_USER)) 
			properties.setProperty(DestinationDataProvider.JCO_ALIAS_USER, JCO_ALIAS_USER);
		
		if(StringUtils.isNotBlank(JCO_ASHOST)) 
			properties.setProperty(DestinationDataProvider.JCO_ASHOST, JCO_ASHOST);
		
		if(StringUtils.isNotBlank(JCO_AUTH_TYPE)) 
			properties.setProperty(DestinationDataProvider.JCO_AUTH_TYPE, JCO_AUTH_TYPE);
		
		if(StringUtils.isNotBlank(JCO_AUTH_TYPE_CONFIGURED_USER)) 
			properties.setProperty(DestinationDataProvider.JCO_AUTH_TYPE_CONFIGURED_USER, JCO_AUTH_TYPE_CONFIGURED_USER);
		
		if(StringUtils.isNotBlank(JCO_AUTH_TYPE_CURRENT_USER)) 
			properties.setProperty(DestinationDataProvider.JCO_AUTH_TYPE_CURRENT_USER, JCO_AUTH_TYPE_CURRENT_USER);
		
		if(StringUtils.isNotBlank(JCO_CLIENT)) 
			properties.setProperty(DestinationDataProvider.JCO_CLIENT, JCO_CLIENT);
		
		if(StringUtils.isNotBlank(JCO_CODEPAGE)) 
			properties.setProperty(DestinationDataProvider.JCO_CODEPAGE, JCO_CODEPAGE);
		
		if(StringUtils.isNotBlank(JCO_CPIC_TRACE)) 
			properties.setProperty(DestinationDataProvider.JCO_CPIC_TRACE, JCO_CPIC_TRACE);
		
		if(StringUtils.isNotBlank(JCO_DEST)) 
			properties.setProperty(DestinationDataProvider.JCO_DEST, JCO_DEST);
		
		if(StringUtils.isNotBlank(JCO_EXPIRATION_PERIOD)) 
			properties.setProperty(DestinationDataProvider.JCO_EXPIRATION_PERIOD, JCO_EXPIRATION_PERIOD);
		
		if(StringUtils.isNotBlank(JCO_EXPIRATION_TIME)) 
			properties.setProperty(DestinationDataProvider.JCO_EXPIRATION_TIME, JCO_EXPIRATION_TIME);
		
		if(StringUtils.isNotBlank(JCO_GETSSO2)) 
			properties.setProperty(DestinationDataProvider.JCO_GETSSO2, JCO_GETSSO2);
		
		if(StringUtils.isNotBlank(JCO_GROUP)) 
			properties.setProperty(DestinationDataProvider.JCO_GROUP, JCO_GROUP);
		
		if(StringUtils.isNotBlank(JCO_GWHOST)) 
			properties.setProperty(DestinationDataProvider.JCO_GWHOST, JCO_GWHOST);
		
		if(StringUtils.isNotBlank(JCO_GWSERV)) 
			properties.setProperty(DestinationDataProvider.JCO_GWSERV, JCO_GWSERV);
		
		if(StringUtils.isNotBlank(JCO_LANG)) 
			properties.setProperty(DestinationDataProvider.JCO_LANG, JCO_LANG);
		
		if(StringUtils.isNotBlank(JCO_LCHECK)) 
			properties.setProperty(DestinationDataProvider.JCO_LCHECK, JCO_LCHECK);
		
		if(StringUtils.isNotBlank(JCO_MAX_GET_TIME)) 
			properties.setProperty(DestinationDataProvider.JCO_MAX_GET_TIME, JCO_MAX_GET_TIME);
		
		if(StringUtils.isNotBlank(JCO_MSHOST)) 
			properties.setProperty(DestinationDataProvider.JCO_MSHOST, JCO_MSHOST);
		
		if(StringUtils.isNotBlank(JCO_MSSERV)) 
			properties.setProperty(DestinationDataProvider.JCO_MSSERV, JCO_MSSERV);
		
		if(StringUtils.isNotBlank(JCO_MYSAPSSO2)) 
			properties.setProperty(DestinationDataProvider.JCO_MYSAPSSO2, JCO_MYSAPSSO2);
		
		if(StringUtils.isNotBlank(JCO_PASSWD)) 
			properties.setProperty(DestinationDataProvider.JCO_PASSWD, JCO_PASSWD);
		
		if(StringUtils.isNotBlank(JCO_PCS)) 
			properties.setProperty(DestinationDataProvider.JCO_PCS, JCO_PCS);
		
		if(StringUtils.isNotBlank(JCO_PEAK_LIMIT)) 
			properties.setProperty(DestinationDataProvider.JCO_PEAK_LIMIT, JCO_PEAK_LIMIT);
		
		if(StringUtils.isNotBlank(JCO_POOL_CAPACITY)) 
			properties.setProperty(DestinationDataProvider.JCO_POOL_CAPACITY, JCO_POOL_CAPACITY);
		
		if(StringUtils.isNotBlank(JCO_R3NAME)) 
			properties.setProperty(DestinationDataProvider.JCO_R3NAME, JCO_R3NAME);
		
		if(StringUtils.isNotBlank(JCO_REPOSITORY_DEST)) 
			properties.setProperty(DestinationDataProvider.JCO_REPOSITORY_DEST, JCO_REPOSITORY_DEST);
		
		if(StringUtils.isNotBlank(JCO_REPOSITORY_PASSWD)) 
			properties.setProperty(DestinationDataProvider.JCO_REPOSITORY_PASSWD, JCO_REPOSITORY_PASSWD);
		
		if(StringUtils.isNotBlank(JCO_REPOSITORY_SNC)) 
			properties.setProperty(DestinationDataProvider.JCO_REPOSITORY_SNC, JCO_REPOSITORY_SNC);
		
		if(StringUtils.isNotBlank(JCO_REPOSITORY_USER)) 
			properties.setProperty(DestinationDataProvider.JCO_REPOSITORY_USER, JCO_REPOSITORY_USER);
		
		if(StringUtils.isNotBlank(JCO_SAPROUTER)) 
			properties.setProperty(DestinationDataProvider.JCO_SAPROUTER, JCO_SAPROUTER);
		
		if(StringUtils.isNotBlank(JCO_SNC_LIBRARY)) 
			properties.setProperty(DestinationDataProvider.JCO_SNC_LIBRARY, JCO_SNC_LIBRARY);
		
		if(StringUtils.isNotBlank(JCO_SNC_MODE)) 
			properties.setProperty(DestinationDataProvider.JCO_SNC_MODE, JCO_SNC_MODE);
		
		if(StringUtils.isNotBlank(JCO_SNC_MYNAME)) 
			properties.setProperty(DestinationDataProvider.JCO_SNC_MYNAME, JCO_SNC_MYNAME);
		
		if(StringUtils.isNotBlank(JCO_SNC_PARTNERNAME)) 
			properties.setProperty(DestinationDataProvider.JCO_SNC_PARTNERNAME, JCO_SNC_PARTNERNAME);
		
		if(StringUtils.isNotBlank(JCO_SNC_QOP)) 
			properties.setProperty(DestinationDataProvider.JCO_SNC_QOP, JCO_SNC_QOP);
		
		if(StringUtils.isNotBlank(JCO_SYSNR)) 
			properties.setProperty(DestinationDataProvider.JCO_SYSNR, JCO_SYSNR);
		
		if(StringUtils.isNotBlank(JCO_TPHOST)) 
			properties.setProperty(DestinationDataProvider.JCO_TPHOST, JCO_TPHOST);
		
		if(StringUtils.isNotBlank(JCO_TPNAME)) 
			properties.setProperty(DestinationDataProvider.JCO_TPNAME, JCO_TPNAME);
		
		if(StringUtils.isNotBlank(JCO_TRACE)) 
			properties.setProperty(DestinationDataProvider.JCO_TRACE, JCO_TRACE);
		
		if(StringUtils.isNotBlank(JCO_TYPE)) 
			properties.setProperty(DestinationDataProvider.JCO_TYPE, JCO_TYPE);
		
		if(StringUtils.isNotBlank(JCO_USE_SAPGUI)) 
			properties.setProperty(DestinationDataProvider.JCO_USE_SAPGUI, JCO_USE_SAPGUI);
		
		if(StringUtils.isNotBlank(JCO_USER)) 
			properties.setProperty(DestinationDataProvider.JCO_USER, JCO_USER);
		
		if(StringUtils.isNotBlank(JCO_USER_ID)) 
			properties.setProperty(DestinationDataProvider.JCO_USER_ID, JCO_USER_ID);
		
		if(StringUtils.isNotBlank(JCO_X509CERT)) 
			properties.setProperty(DestinationDataProvider.JCO_X509CERT, JCO_X509CERT);
		
		return properties;
	}
	
	public String getJCO_ALIAS_USER() {
		return JCO_ALIAS_USER;
	}

	public String getJCO_ASHOST() {
		return JCO_ASHOST;
	}

	public String getJCO_AUTH_TYPE() {
		return JCO_AUTH_TYPE;
	}

	public String getJCO_AUTH_TYPE_CONFIGURED_USER() {
		return JCO_AUTH_TYPE_CONFIGURED_USER;
	}

	public String getJCO_AUTH_TYPE_CURRENT_USER() {
		return JCO_AUTH_TYPE_CURRENT_USER;
	}

	public String getJCO_CLIENT() {
		return JCO_CLIENT;
	}

	public String getJCO_CODEPAGE() {
		return JCO_CODEPAGE;
	}

	public String getJCO_CPIC_TRACE() {
		return JCO_CPIC_TRACE;
	}

	public String getJCO_DEST() {
		return JCO_DEST;
	}

	public String getJCO_EXPIRATION_PERIOD() {
		return JCO_EXPIRATION_PERIOD;
	}

	public String getJCO_EXPIRATION_TIME() {
		return JCO_EXPIRATION_TIME;
	}

	public String getJCO_GETSSO2() {
		return JCO_GETSSO2;
	}

	public String getJCO_GROUP() {
		return JCO_GROUP;
	}

	public String getJCO_GWHOST() {
		return JCO_GWHOST;
	}

	public String getJCO_GWSERV() {
		return JCO_GWSERV;
	}

	public String getJCO_LANG() {
		return JCO_LANG;
	}

	public String getJCO_LCHECK() {
		return JCO_LCHECK;
	}

	public String getJCO_MAX_GET_TIME() {
		return JCO_MAX_GET_TIME;
	}

	public String getJCO_MSHOST() {
		return JCO_MSHOST;
	}

	public String getJCO_MSSERV() {
		return JCO_MSSERV;
	}

	public String getJCO_MYSAPSSO2() {
		return JCO_MYSAPSSO2;
	}

	public String getJCO_PASSWD() {
		return JCO_PASSWD;
	}

	public String getJCO_PCS() {
		return JCO_PCS;
	}

	public String getJCO_PEAK_LIMIT() {
		return JCO_PEAK_LIMIT;
	}

	public String getJCO_POOL_CAPACITY() {
		return JCO_POOL_CAPACITY;
	}

	public String getJCO_R3NAME() {
		return JCO_R3NAME;
	}

	public String getJCO_REPOSITORY_DEST() {
		return JCO_REPOSITORY_DEST;
	}

	public String getJCO_REPOSITORY_PASSWD() {
		return JCO_REPOSITORY_PASSWD;
	}

	public String getJCO_REPOSITORY_SNC() {
		return JCO_REPOSITORY_SNC;
	}

	public String getJCO_REPOSITORY_USER() {
		return JCO_REPOSITORY_USER;
	}

	public String getJCO_SAPROUTER() {
		return JCO_SAPROUTER;
	}

	public String getJCO_SNC_LIBRARY() {
		return JCO_SNC_LIBRARY;
	}

	public String getJCO_SNC_MODE() {
		return JCO_SNC_MODE;
	}

	public String getJCO_SNC_MYNAME() {
		return JCO_SNC_MYNAME;
	}

	public String getJCO_SNC_PARTNERNAME() {
		return JCO_SNC_PARTNERNAME;
	}

	public String getJCO_SNC_QOP() {
		return JCO_SNC_QOP;
	}

	public String getJCO_SYSNR() {
		return JCO_SYSNR;
	}

	public String getJCO_TPHOST() {
		return JCO_TPHOST;
	}

	public String getJCO_TPNAME() {
		return JCO_TPNAME;
	}

	public String getJCO_TRACE() {
		return JCO_TRACE;
	}

	public String getJCO_TYPE() {
		return JCO_TYPE;
	}

	public String getJCO_USE_SAPGUI() {
		return JCO_USE_SAPGUI;
	}

	public String getJCO_USER() {
		return JCO_USER;
	}

	public String getJCO_USER_ID() {
		return JCO_USER_ID;
	}

	public String getJCO_X509CERT() {
		return JCO_X509CERT;
	}

	@Override
	public String toString() {
		return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE);
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		
		result = prime * result + ((JCO_ALIAS_USER == null) ? 0 : JCO_ALIAS_USER.hashCode());
		result = prime * result + ((JCO_ASHOST == null) ? 0 : JCO_ASHOST.hashCode());
		result = prime * result + ((JCO_AUTH_TYPE == null) ? 0 : JCO_AUTH_TYPE.hashCode());
		result = prime * result + ((JCO_AUTH_TYPE_CONFIGURED_USER == null) ? 0 : JCO_AUTH_TYPE_CONFIGURED_USER.hashCode());
		result = prime * result + ((JCO_AUTH_TYPE_CURRENT_USER == null) ? 0 : JCO_AUTH_TYPE_CURRENT_USER.hashCode());
		result = prime * result + ((JCO_CLIENT == null) ? 0 : JCO_CLIENT.hashCode());
		result = prime * result + ((JCO_CODEPAGE == null) ? 0 : JCO_CODEPAGE.hashCode());
		result = prime * result + ((JCO_CPIC_TRACE == null) ? 0 : JCO_CPIC_TRACE.hashCode());
		result = prime * result + ((JCO_DEST == null) ? 0 : JCO_DEST.hashCode());
		result = prime * result + ((JCO_EXPIRATION_PERIOD == null) ? 0 : JCO_EXPIRATION_PERIOD.hashCode());
		result = prime * result + ((JCO_EXPIRATION_TIME == null) ? 0 : JCO_EXPIRATION_TIME.hashCode());
		result = prime * result + ((JCO_GETSSO2 == null) ? 0 : JCO_GETSSO2.hashCode());
		result = prime * result + ((JCO_GROUP == null) ? 0 : JCO_GROUP.hashCode());
		result = prime * result + ((JCO_GWHOST == null) ? 0 : JCO_GWHOST.hashCode());
		result = prime * result + ((JCO_GWSERV == null) ? 0 : JCO_GWSERV.hashCode());
		result = prime * result + ((JCO_LANG == null) ? 0 : JCO_LANG.hashCode());
		result = prime * result + ((JCO_LCHECK == null) ? 0 : JCO_LCHECK.hashCode());
		result = prime * result + ((JCO_MAX_GET_TIME == null) ? 0 : JCO_MAX_GET_TIME.hashCode());
		result = prime * result + ((JCO_MSHOST == null) ? 0 : JCO_MSHOST.hashCode());
		result = prime * result + ((JCO_MSSERV == null) ? 0 : JCO_MSSERV.hashCode());
		result = prime * result + ((JCO_MYSAPSSO2 == null) ? 0 : JCO_MYSAPSSO2.hashCode());
		result = prime * result + ((JCO_PASSWD == null) ? 0 : JCO_PASSWD.hashCode());
		result = prime * result + ((JCO_PCS == null) ? 0 : JCO_PCS.hashCode());
		result = prime * result + ((JCO_PEAK_LIMIT == null) ? 0 : JCO_PEAK_LIMIT.hashCode());
		result = prime * result + ((JCO_POOL_CAPACITY == null) ? 0 : JCO_POOL_CAPACITY.hashCode());
		result = prime * result + ((JCO_R3NAME == null) ? 0 : JCO_R3NAME.hashCode());
		result = prime * result + ((JCO_REPOSITORY_DEST == null) ? 0 : JCO_REPOSITORY_DEST.hashCode());
		result = prime * result + ((JCO_REPOSITORY_PASSWD == null) ? 0 : JCO_REPOSITORY_PASSWD.hashCode());
		result = prime * result + ((JCO_REPOSITORY_SNC == null) ? 0 : JCO_REPOSITORY_SNC.hashCode());
		result = prime * result + ((JCO_REPOSITORY_USER == null) ? 0 : JCO_REPOSITORY_USER.hashCode());
		result = prime * result + ((JCO_SAPROUTER == null) ? 0 : JCO_SAPROUTER.hashCode());
		result = prime * result + ((JCO_SNC_LIBRARY == null) ? 0 : JCO_SNC_LIBRARY.hashCode());
		result = prime * result + ((JCO_SNC_MODE == null) ? 0 : JCO_SNC_MODE.hashCode());
		result = prime * result + ((JCO_SNC_MYNAME == null) ? 0 : JCO_SNC_MYNAME.hashCode());
		result = prime * result + ((JCO_SNC_PARTNERNAME == null) ? 0 : JCO_SNC_PARTNERNAME.hashCode());
		result = prime * result + ((JCO_SNC_QOP == null) ? 0 : JCO_SNC_QOP.hashCode());
		result = prime * result + ((JCO_SYSNR == null) ? 0 : JCO_SYSNR.hashCode());
		result = prime * result + ((JCO_TPHOST == null) ? 0 : JCO_TPHOST.hashCode());
		result = prime * result + ((JCO_TPNAME == null) ? 0 : JCO_TPNAME.hashCode());
		result = prime * result + ((JCO_TRACE == null) ? 0 : JCO_TRACE.hashCode());
		result = prime * result + ((JCO_TYPE == null) ? 0 : JCO_TYPE.hashCode());
		result = prime * result + ((JCO_USE_SAPGUI == null) ? 0 : JCO_USE_SAPGUI.hashCode());
		result = prime * result + ((JCO_USER == null) ? 0 : JCO_USER.hashCode());
		result = prime * result + ((JCO_USER_ID == null) ? 0 : JCO_USER_ID.hashCode());
		result = prime * result + ((JCO_X509CERT == null) ? 0 : JCO_X509CERT.hashCode());
		
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		SapSystem other = (SapSystem) obj;
		if (JCO_ALIAS_USER == null) {
			if (other.JCO_ALIAS_USER != null) 
				return false;
		} else if (!JCO_ALIAS_USER.equals(other.JCO_ALIAS_USER)) 
			return false;
		if (JCO_ASHOST == null) {
			if (other.JCO_ASHOST != null) 
				return false;
		} else if (!JCO_ASHOST.equals(other.JCO_ASHOST)) 
			return false;
		if (JCO_AUTH_TYPE == null) {
			if (other.JCO_AUTH_TYPE != null) 
				return false;
		} else if (!JCO_AUTH_TYPE.equals(other.JCO_AUTH_TYPE)) 
			return false;
		if (JCO_AUTH_TYPE_CONFIGURED_USER == null) {
			if (other.JCO_AUTH_TYPE_CONFIGURED_USER != null) 
				return false;
		} else if (!JCO_AUTH_TYPE_CONFIGURED_USER.equals(other.JCO_AUTH_TYPE_CONFIGURED_USER)) 
			return false;
		if (JCO_AUTH_TYPE_CURRENT_USER == null) {
			if (other.JCO_AUTH_TYPE_CURRENT_USER != null) 
				return false;
		} else if (!JCO_AUTH_TYPE_CURRENT_USER.equals(other.JCO_AUTH_TYPE_CURRENT_USER)) 
			return false;
		if (JCO_CLIENT == null) {
			if (other.JCO_CLIENT != null) 
				return false;
		} else if (!JCO_CLIENT.equals(other.JCO_CLIENT)) 
			return false;
		if (JCO_CODEPAGE == null) {
			if (other.JCO_CODEPAGE != null) 
				return false;
		} else if (!JCO_CODEPAGE.equals(other.JCO_CODEPAGE)) 
			return false;
		if (JCO_CPIC_TRACE == null) {
			if (other.JCO_CPIC_TRACE != null) 
				return false;
		} else if (!JCO_CPIC_TRACE.equals(other.JCO_CPIC_TRACE)) 
			return false;
		if (JCO_DEST == null) {
			if (other.JCO_DEST != null) 
				return false;
		} else if (!JCO_DEST.equals(other.JCO_DEST)) 
			return false;
		if (JCO_EXPIRATION_PERIOD == null) {
			if (other.JCO_EXPIRATION_PERIOD != null) 
				return false;
			} else if (!JCO_EXPIRATION_PERIOD.equals(other.JCO_EXPIRATION_PERIOD)) 
				return false;
		if (JCO_EXPIRATION_TIME == null) {
			if (other.JCO_EXPIRATION_TIME != null) 
				return false;
			} else if (!JCO_EXPIRATION_TIME.equals(other.JCO_EXPIRATION_TIME)) 
				return false;
		if (JCO_GETSSO2 == null) {
			if (other.JCO_GETSSO2 != null) 
				return false;
			} else if (!JCO_GETSSO2.equals(other.JCO_GETSSO2)) 
				return false;
		if (JCO_GROUP == null) {
			if (other.JCO_GROUP != null) 
				return false;
			} else if (!JCO_GROUP.equals(other.JCO_GROUP)) 
				return false;
		if (JCO_GWHOST == null) {
			if (other.JCO_GWHOST != null) 
				return false;
			} else if (!JCO_GWHOST.equals(other.JCO_GWHOST)) 
				return false;
		if (JCO_GWSERV == null) {
			if (other.JCO_GWSERV != null) 
				return false;
			} else if (!JCO_GWSERV.equals(other.JCO_GWSERV)) 
				return false;
		if (JCO_LANG == null) {
			if (other.JCO_LANG != null) 
				return false;
			} else if (!JCO_LANG.equals(other.JCO_LANG)) 
				return false;
		if (JCO_LCHECK == null) {
			if (other.JCO_LCHECK != null) 
				return false;
			} else if (!JCO_LCHECK.equals(other.JCO_LCHECK)) 
				return false;
		if (JCO_MAX_GET_TIME == null) {
			if (other.JCO_MAX_GET_TIME != null) 
				return false;
			} else if (!JCO_MAX_GET_TIME.equals(other.JCO_MAX_GET_TIME)) 
				return false;
		if (JCO_MSHOST == null) {
			if (other.JCO_MSHOST != null) 
				return false;
			} else if (!JCO_MSHOST.equals(other.JCO_MSHOST)) 
				return false;
		if (JCO_MSSERV == null) {
			if (other.JCO_MSSERV != null) 
				return false;
			} else if (!JCO_MSSERV.equals(other.JCO_MSSERV)) 
				return false;
		if (JCO_MYSAPSSO2 == null) {
			if (other.JCO_MYSAPSSO2 != null) 
				return false;
			} else if (!JCO_MYSAPSSO2.equals(other.JCO_MYSAPSSO2)) 
				return false;
		if (JCO_PASSWD == null) {
			if (other.JCO_PASSWD != null) 
				return false;
			} else if (!JCO_PASSWD.equals(other.JCO_PASSWD)) 
				return false;
		if (JCO_PCS == null) {
			if (other.JCO_PCS != null) 
				return false;
			} else if (!JCO_PCS.equals(other.JCO_PCS)) 
				return false;
		if (JCO_PEAK_LIMIT == null) {
			if (other.JCO_PEAK_LIMIT != null) 
				return false;
			} else if (!JCO_PEAK_LIMIT.equals(other.JCO_PEAK_LIMIT)) 
				return false;
		if (JCO_POOL_CAPACITY == null) {
			if (other.JCO_POOL_CAPACITY != null) 
				return false;
			} else if (!JCO_POOL_CAPACITY.equals(other.JCO_POOL_CAPACITY)) 
				return false;
		if (JCO_R3NAME == null) {
			if (other.JCO_R3NAME != null) 
				return false;
			} else if (!JCO_R3NAME.equals(other.JCO_R3NAME)) 
				return false;
		if (JCO_REPOSITORY_DEST == null) {
			if (other.JCO_REPOSITORY_DEST != null) 
				return false;
			} else if (!JCO_REPOSITORY_DEST.equals(other.JCO_REPOSITORY_DEST)) 
				return false;
		if (JCO_REPOSITORY_PASSWD == null) {
			if (other.JCO_REPOSITORY_PASSWD != null) 
				return false;
			} else if (!JCO_REPOSITORY_PASSWD.equals(other.JCO_REPOSITORY_PASSWD)) 
				return false;
		if (JCO_REPOSITORY_SNC == null) {
			if (other.JCO_REPOSITORY_SNC != null) 
				return false;
			} else if (!JCO_REPOSITORY_SNC.equals(other.JCO_REPOSITORY_SNC)) 
				return false;
		if (JCO_REPOSITORY_USER == null) {
			if (other.JCO_REPOSITORY_USER != null) 
				return false;
			} else if (!JCO_REPOSITORY_USER.equals(other.JCO_REPOSITORY_USER)) 
				return false;
		if (JCO_SAPROUTER == null) {
			if (other.JCO_SAPROUTER != null) 
				return false;
			} else if (!JCO_SAPROUTER.equals(other.JCO_SAPROUTER)) 
				return false;
		if (JCO_SNC_LIBRARY == null) {
			if (other.JCO_SNC_LIBRARY != null) 
				return false;
			} else if (!JCO_SNC_LIBRARY.equals(other.JCO_SNC_LIBRARY)) 
				return false;
		if (JCO_SNC_MODE == null) {
			if (other.JCO_SNC_MODE != null) 
				return false;
			} else if (!JCO_SNC_MODE.equals(other.JCO_SNC_MODE)) 
				return false;
		if (JCO_SNC_MYNAME == null) {
			if (other.JCO_SNC_MYNAME != null) 
				return false;
			} else if (!JCO_SNC_MYNAME.equals(other.JCO_SNC_MYNAME)) 
				return false;
		if (JCO_SNC_PARTNERNAME == null) {
			if (other.JCO_SNC_PARTNERNAME != null) 
				return false;
			} else if (!JCO_SNC_PARTNERNAME.equals(other.JCO_SNC_PARTNERNAME)) 
				return false;
		if (JCO_SNC_QOP == null) {
			if (other.JCO_SNC_QOP != null) 
				return false;
			} else if (!JCO_SNC_QOP.equals(other.JCO_SNC_QOP)) 
				return false;
		if (JCO_SYSNR == null) {
			if (other.JCO_SYSNR != null) 
				return false;
			} else if (!JCO_SYSNR.equals(other.JCO_SYSNR)) 
				return false;
		if (JCO_TPHOST == null) {
			if (other.JCO_TPHOST != null) 
				return false;
			} else if (!JCO_TPHOST.equals(other.JCO_TPHOST)) 
				return false;
		if (JCO_TPNAME == null) {
			if (other.JCO_TPNAME != null) 
				return false;
			} else if (!JCO_TPNAME.equals(other.JCO_TPNAME)) 
				return false;
		if (JCO_TRACE == null) {
			if (other.JCO_TRACE != null) 
				return false;
			} else if (!JCO_TRACE.equals(other.JCO_TRACE)) 
				return false;
		if (JCO_TYPE == null) {
			if (other.JCO_TYPE != null) 
				return false;
			} else if (!JCO_TYPE.equals(other.JCO_TYPE)) 
				return false;
		if (JCO_USE_SAPGUI == null) {
			if (other.JCO_USE_SAPGUI != null) 
				return false;
			} else if (!JCO_USE_SAPGUI.equals(other.JCO_USE_SAPGUI)) 
				return false;
		if (JCO_USER == null) {
			if (other.JCO_USER != null) 
				return false;
			} else if (!JCO_USER.equals(other.JCO_USER)) 
				return false;
		if (JCO_USER_ID == null) {
			if (other.JCO_USER_ID != null) 
				return false;
			} else if (!JCO_USER_ID.equals(other.JCO_USER_ID)) 
				return false;
		if (JCO_X509CERT == null) {
			if (other.JCO_X509CERT != null) 
				return false;
			} else if (!JCO_X509CERT.equals(other.JCO_X509CERT)) 
				return false;
		
		return true;
	}

	@Override
	public Object clone() {
		try {
			return super.clone();
		} catch (CloneNotSupportedException e) {
			e.printStackTrace();
		}
		return null;
	}

}

