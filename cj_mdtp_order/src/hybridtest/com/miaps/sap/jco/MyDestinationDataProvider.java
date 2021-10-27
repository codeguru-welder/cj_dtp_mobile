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

import com.sap.conn.jco.ext.DestinationDataEventListener;
import com.sap.conn.jco.ext.DestinationDataProvider;

/**
 * Represents the destination to a specific SAP system. 
 * The destination is maintained via a property file
 * 
 * @version		2015.05.11
 * @author		thinkm(think03)
 */
public class MyDestinationDataProvider implements DestinationDataProvider {
	static String SAP_SERVER = "ABAB_AS_WITH_POOL"; // "SAP_SERVER"
	private DestinationDataEventListener eventListener;
	private Properties ABAP_AS_properties;
	
	public MyDestinationDataProvider() {}
	
	public MyDestinationDataProvider(Properties properties) {
		this.ABAP_AS_properties = properties;
	}
	
	public MyDestinationDataProvider(SapSystem system) {
		Properties properties = new Properties();
		
		String jco_alias_user = system.getJCO_ALIAS_USER();
		String jco_ashost = system.getJCO_ASHOST();
		String jco_auth_type = system.getJCO_AUTH_TYPE();
		String jco_auth_type_configured_user = system.getJCO_AUTH_TYPE_CONFIGURED_USER();
		String jco_auth_type_current_user = system.getJCO_AUTH_TYPE_CURRENT_USER();
		String jco_client = system.getJCO_CLIENT();
		String jco_codepage = system.getJCO_CODEPAGE();
		String jco_cpic_trace = system.getJCO_CPIC_TRACE();
		String jco_dest = system.getJCO_DEST();
		String jco_expiration_period = system.getJCO_EXPIRATION_PERIOD();
		String jco_expiration_time = system.getJCO_EXPIRATION_TIME();
		String jco_getsso2 = system.getJCO_GETSSO2();
		String jco_group = system.getJCO_GROUP();
		String jco_gwhost = system.getJCO_GWHOST();
		String jco_gwserv = system.getJCO_GWSERV();
		String jco_lang = system.getJCO_LANG();
		String jco_lcheck = system.getJCO_LCHECK();
		String jco_max_get_time = system.getJCO_MAX_GET_TIME();
		String jco_mshost = system.getJCO_MSHOST();
		String jco_msserv = system.getJCO_MSSERV();
		String jco_mysapsso2 = system.getJCO_MYSAPSSO2();
		String jco_passwd = system.getJCO_PASSWD();
		String jco_pcs = system.getJCO_PCS();
		String jco_peak_limit = system.getJCO_PEAK_LIMIT();
		String jco_pool_capacity = system.getJCO_POOL_CAPACITY();
		String jco_r3name = system.getJCO_R3NAME();
		String jco_repository_dest = system.getJCO_REPOSITORY_DEST();
		String jco_repository_passwd = system.getJCO_REPOSITORY_PASSWD();
		String jco_repository_snc = system.getJCO_REPOSITORY_SNC();
		String jco_repository_user = system.getJCO_REPOSITORY_USER();
		String jco_saprouter = system.getJCO_SAPROUTER();
		String jco_snc_library = system.getJCO_SNC_LIBRARY();
		String jco_snc_mode = system.getJCO_SNC_MODE();
		String jco_snc_myname = system.getJCO_SNC_MYNAME();
		String jco_snc_partnername = system.getJCO_SNC_PARTNERNAME();
		String jco_snc_qop = system.getJCO_SNC_QOP();
		String jco_sysnr = system.getJCO_SYSNR();
		String jco_tphost = system.getJCO_TPHOST();
		String jco_tpname = system.getJCO_TPNAME();
		String jco_trace = system.getJCO_TRACE();
		String jco_type = system.getJCO_TYPE();
		String jco_use_sapgui = system.getJCO_USE_SAPGUI();
		String jco_user = system.getJCO_USER();
		String jco_user_id = system.getJCO_USER_ID();
		String jco_x509cert = system.getJCO_X509CERT();
		
		if(StringUtils.isNotBlank(jco_alias_user)) 
			properties.setProperty(DestinationDataProvider.JCO_ALIAS_USER, jco_alias_user);
		
		if(StringUtils.isNotBlank(jco_ashost)) 
			properties.setProperty(DestinationDataProvider.JCO_ASHOST, jco_ashost);
		
		if(StringUtils.isNotBlank(jco_auth_type)) 
			properties.setProperty(DestinationDataProvider.JCO_AUTH_TYPE, jco_auth_type);
		
		if(StringUtils.isNotBlank(jco_auth_type_configured_user)) 
			properties.setProperty(DestinationDataProvider.JCO_AUTH_TYPE_CONFIGURED_USER, jco_auth_type_configured_user);
		
		if(StringUtils.isNotBlank(jco_auth_type_current_user)) 
			properties.setProperty(DestinationDataProvider.JCO_AUTH_TYPE_CURRENT_USER, jco_auth_type_current_user);
		
		if(StringUtils.isNotBlank(jco_client)) 
			properties.setProperty(DestinationDataProvider.JCO_CLIENT, jco_client);
		
		if(StringUtils.isNotBlank(jco_codepage)) 
			properties.setProperty(DestinationDataProvider.JCO_CODEPAGE, jco_codepage);
		
		if(StringUtils.isNotBlank(jco_cpic_trace)) 
			properties.setProperty(DestinationDataProvider.JCO_CPIC_TRACE, jco_cpic_trace);
		
		if(StringUtils.isNotBlank(jco_dest)) 
			properties.setProperty(DestinationDataProvider.JCO_DEST, jco_dest);
		
		if(StringUtils.isNotBlank(jco_expiration_period)) 
			properties.setProperty(DestinationDataProvider.JCO_EXPIRATION_PERIOD, jco_expiration_period);
		
		if(StringUtils.isNotBlank(jco_expiration_time)) 
			properties.setProperty(DestinationDataProvider.JCO_EXPIRATION_TIME, jco_expiration_time);
		
		if(StringUtils.isNotBlank(jco_getsso2)) 
			properties.setProperty(DestinationDataProvider.JCO_GETSSO2, jco_getsso2);
		
		if(StringUtils.isNotBlank(jco_group)) 
			properties.setProperty(DestinationDataProvider.JCO_GROUP, jco_group);
		
		if(StringUtils.isNotBlank(jco_gwhost)) 
			properties.setProperty(DestinationDataProvider.JCO_GWHOST, jco_gwhost);
		
		if(StringUtils.isNotBlank(jco_gwserv)) 
			properties.setProperty(DestinationDataProvider.JCO_GWSERV, jco_gwserv);
		
		if(StringUtils.isNotBlank(jco_lang)) 
			properties.setProperty(DestinationDataProvider.JCO_LANG, jco_lang);
		
		if(StringUtils.isNotBlank(jco_lcheck)) 
			properties.setProperty(DestinationDataProvider.JCO_LCHECK, jco_lcheck);
		
		if(StringUtils.isNotBlank(jco_max_get_time)) 
			properties.setProperty(DestinationDataProvider.JCO_MAX_GET_TIME, jco_max_get_time);
		
		if(StringUtils.isNotBlank(jco_mshost)) 
			properties.setProperty(DestinationDataProvider.JCO_MSHOST, jco_mshost);
		
		if(StringUtils.isNotBlank(jco_msserv)) 
			properties.setProperty(DestinationDataProvider.JCO_MSSERV, jco_msserv);
		
		if(StringUtils.isNotBlank(jco_mysapsso2)) 
			properties.setProperty(DestinationDataProvider.JCO_MYSAPSSO2, jco_mysapsso2);
		
		if(StringUtils.isNotBlank(jco_passwd)) 
			properties.setProperty(DestinationDataProvider.JCO_PASSWD, jco_passwd);
		
		if(StringUtils.isNotBlank(jco_pcs)) 
			properties.setProperty(DestinationDataProvider.JCO_PCS, jco_pcs);
		
		if(StringUtils.isNotBlank(jco_peak_limit)) 
			properties.setProperty(DestinationDataProvider.JCO_PEAK_LIMIT, jco_peak_limit);
		
		if(StringUtils.isNotBlank(jco_pool_capacity)) 
			properties.setProperty(DestinationDataProvider.JCO_POOL_CAPACITY, jco_pool_capacity);
		
		if(StringUtils.isNotBlank(jco_r3name)) 
			properties.setProperty(DestinationDataProvider.JCO_R3NAME, jco_r3name);
		
		if(StringUtils.isNotBlank(jco_repository_dest)) 
			properties.setProperty(DestinationDataProvider.JCO_REPOSITORY_DEST, jco_repository_dest);
		
		if(StringUtils.isNotBlank(jco_repository_passwd)) 
			properties.setProperty(DestinationDataProvider.JCO_REPOSITORY_PASSWD, jco_repository_passwd);
		
		if(StringUtils.isNotBlank(jco_repository_snc)) 
			properties.setProperty(DestinationDataProvider.JCO_REPOSITORY_SNC, jco_repository_snc);
		
		if(StringUtils.isNotBlank(jco_repository_user)) 
			properties.setProperty(DestinationDataProvider.JCO_REPOSITORY_USER, jco_repository_user);
		
		if(StringUtils.isNotBlank(jco_saprouter)) 
			properties.setProperty(DestinationDataProvider.JCO_SAPROUTER, jco_saprouter);
		
		if(StringUtils.isNotBlank(jco_snc_library)) 
			properties.setProperty(DestinationDataProvider.JCO_SNC_LIBRARY, jco_snc_library);
		
		if(StringUtils.isNotBlank(jco_snc_mode)) 
			properties.setProperty(DestinationDataProvider.JCO_SNC_MODE, jco_snc_mode);
		
		if(StringUtils.isNotBlank(jco_snc_myname)) 
			properties.setProperty(DestinationDataProvider.JCO_SNC_MYNAME, jco_snc_myname);
		
		if(StringUtils.isNotBlank(jco_snc_partnername)) 
			properties.setProperty(DestinationDataProvider.JCO_SNC_PARTNERNAME, jco_snc_partnername);
		
		if(StringUtils.isNotBlank(jco_snc_qop)) 
			properties.setProperty(DestinationDataProvider.JCO_SNC_QOP, jco_snc_qop);
		
		if(StringUtils.isNotBlank(jco_sysnr)) 
			properties.setProperty(DestinationDataProvider.JCO_SYSNR, jco_sysnr);
		
		if(StringUtils.isNotBlank(jco_tphost)) 
			properties.setProperty(DestinationDataProvider.JCO_TPHOST, jco_tphost);
		
		if(StringUtils.isNotBlank(jco_tpname)) 
			properties.setProperty(DestinationDataProvider.JCO_TPNAME, jco_tpname);
		
		if(StringUtils.isNotBlank(jco_trace)) 
			properties.setProperty(DestinationDataProvider.JCO_TRACE, jco_trace);
		
		if(StringUtils.isNotBlank(jco_type)) 
			properties.setProperty(DestinationDataProvider.JCO_TYPE, jco_type);
		
		if(StringUtils.isNotBlank(jco_use_sapgui)) 
			properties.setProperty(DestinationDataProvider.JCO_USE_SAPGUI, jco_use_sapgui);
		
		if(StringUtils.isNotBlank(jco_user)) 
			properties.setProperty(DestinationDataProvider.JCO_USER, jco_user);
		
		if(StringUtils.isNotBlank(jco_user_id)) 
			properties.setProperty(DestinationDataProvider.JCO_USER_ID, jco_user_id);
		
		if(StringUtils.isNotBlank(jco_x509cert)) 
			properties.setProperty(DestinationDataProvider.JCO_X509CERT, jco_x509cert);
		
		ABAP_AS_properties = properties;
	}
	
	public Properties getDestinationProperties(String destinationName) {
		if (destinationName.equals(SAP_SERVER) && ABAP_AS_properties != null) {
			return ABAP_AS_properties;
		}
		
		return null; // ABAP_AS_properties
		//alternatively throw runtime exception
		//throw new RuntimeException("Destination " + destinationName + " is not available");
	}

	public void setDestinationDataEventListener(DestinationDataEventListener eventListener) {
		this.eventListener = eventListener;
	}

	public boolean supportsEvents() {
		return true; // false
	}
	
	public void changePropertiesForABAP_AS(Properties properties) {
		if (properties == null) {
			if (eventListener != null) {
				eventListener.deleted(SAP_SERVER);
            }
			
			ABAP_AS_properties = null;
		} else {
			if (ABAP_AS_properties == null || ABAP_AS_properties.equals(properties)) {
				ABAP_AS_properties = properties;
				
				if (eventListener != null) {
                    eventListener.updated(SAP_SERVER);
                }
			}
		}
	}

}
