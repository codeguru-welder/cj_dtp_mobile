package com.miaps.sap.jco;

import com.sap.conn.jco.JCoField;
import com.sap.conn.jco.JCoFieldIterator;
import com.sap.conn.jco.JCoRecordFieldIterator;
import com.sap.conn.jco.JCoStructure;

public class StructureAdapterReader {
	protected JCoStructure structure = null;
	private JCoRecordFieldIterator rfi = null;
	private JCoField f = null;
	
	private JCoFieldIterator metaFi = null;
	private JCoField metaField = null;
	
	public StructureAdapterReader(JCoStructure structure) {
		this.structure = structure;
		this.rfi = structure.getRecordFieldIterator();
		this.metaFi = structure.getFieldIterator();
	}
	
	public boolean hasNext() {
		return rfi.hasNextField();
	}
	
	public void next() {
		f = rfi.nextField();
	}
	
	public String getName() {
		return f.getName();
	}
	
	public Object getValue() {
		return f.getValue();
	}
	
	public String getType() {
		return f.getTypeAsString();
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
