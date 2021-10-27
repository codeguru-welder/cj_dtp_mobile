package com.mink.connectors.mdtpcar.mapper;

import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("loggingMapper")
public interface LoggingMapper {

	int insertLog(Map<String, Object> params) throws Exception;
	int insertScriptErrLog(Map<String, Object> params) throws Exception;
	
}
