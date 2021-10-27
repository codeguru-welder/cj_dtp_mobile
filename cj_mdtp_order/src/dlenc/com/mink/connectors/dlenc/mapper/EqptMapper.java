package com.mink.connectors.dlenc.mapper;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import java.util.List;
import java.util.Map;

@Mapper("eqptMapper")
public interface EqptMapper {

    List<Map<String, Object>> selectSiteCode(Map<String, Object> params);

    List<Map<String, Object>> selectEqptType(Map<String, Object> params);

    List<Map<String, Object>> selectEqptStd(Map<String, Object> params);

    List<Map<String, Object>> selectEqptPlan(Map<String, Object> params);

    List<Map<String, Object>> selectSiteWork(Map<String, String> params);

    List<Map<String, Object>> selectSiteWorkInfo(Map<String, String> params);

    void insertSiteWorkInfo(Map<String, Object> params);

    void insertSiteWork(Map<String, String> params);

    void deleteSiteWorkInfo(Map<String, String> params);
    
}
