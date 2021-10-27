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

import com.sap.conn.jco.JCoField;
import com.sap.conn.jco.JCoFieldIterator;
import com.sap.conn.jco.JCoTable;

/**
 * TableAdapter is used to simplify the reading of the values of the Jco tables
 * 
 * @version		2015.05.11
 * @author		thinkm(think03)
 */
public class TableAdapterReader {
	protected JCoTable table;
	private JCoFieldIterator metaFi = null;
	private JCoField metaField = null;

	public TableAdapterReader(JCoTable table) {
		this.table = table;
		this.metaFi = table.getFieldIterator();
	}
	
	public String get(String s) {
		return table.getValue(s).toString();
	}

	public Boolean getBoolean(String s) {
		String value = table.getValue(s).toString();
		return value.equals("X");
	}

	public String getMessage() {
		return table.getString("MESSAGE");
	}

	public int size() {
		return table.getNumRows();
	}

	public boolean next() {
		return table.nextRow();
	}
	
	public Object getValue(String fieldName) {
		return table.getValue(fieldName);
	}
	
	public String getType(String fieldName) {
		return table.getClassNameOfValue(fieldName);
	}
	
	public boolean hasMetaNext() {
		return metaFi.hasNextField();
	}
	
	public void metaNext() {
		this.metaField = metaFi.nextField();
	}
	
	public String getMetaName() {
		return metaField.getName();
	}
	
	public String getMetaType() {
		return metaField.getTypeAsString();
	}
	
}
