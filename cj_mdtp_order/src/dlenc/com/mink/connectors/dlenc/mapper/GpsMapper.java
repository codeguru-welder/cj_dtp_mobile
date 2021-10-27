package com.mink.connectors.dlenc.mapper;

import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("gpsMapper")
public interface GpsMapper {
	int insertGpsInfo(Map<String, String>params ) throws Exception;
}
