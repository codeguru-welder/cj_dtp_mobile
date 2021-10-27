package com.mink.connectors.hybridtest.mapper;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("projectMapper")
public interface ProjectMapper {

	Map<String, String> selectUser(Map user) throws Exception;
	List<Map<String, Object>> getSpeedTestList(int limit) throws Exception;
	
	List<Map<String, Object>> getUserList(Map<String, String> params) throws Exception;
	Map<String, Object> getUserTotalCnt() throws Exception;
	
	List<Map<String, Object>> selectwelfare(Map<String, String> params) throws Exception;
	List<Map<String, Object>> select_req_welfare(Map<String, String> params) throws Exception;
	Object insert_req_welfare(Map<String, String>params ) throws Exception;
	
	List<Map<String, Object>> getAllUser();
}
