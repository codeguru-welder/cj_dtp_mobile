package com.mink.connectors.mdtporder.mapper;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("GetUserMapper")
public interface GetUserMapper {

	List<Map<String, Object>> selectGetUser(Map<String, String> params) throws Exception;
	List<Map<String, Object>> selectUserList(Map<String, String> params) throws Exception;
	
}
