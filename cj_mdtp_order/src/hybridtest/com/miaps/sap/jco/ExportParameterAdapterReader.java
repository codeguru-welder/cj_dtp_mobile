package com.miaps.sap.jco;

import com.sap.conn.jco.JCoParameterList;

public class ExportParameterAdapterReader {
	protected JCoParameterList epl = null;
	
	public ExportParameterAdapterReader(JCoParameterList epl) {
		this.epl = epl;
	}
	
	public Object getValue(String name) {
		return epl.getValue(name);
	}
	
}
