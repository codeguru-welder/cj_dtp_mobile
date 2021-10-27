package com.mink.connectors.dlenc.mapper;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import java.util.List;
import java.util.Map;

@Mapper("equipMapper")
public interface EquipMapper {

    List<Map<String, Object>> selectLocationCode(Map<String, Object> params);

    List<Map<String, Object>> selectEquipType(Map<String, Object> params);

    List<Map<String, Object>> selectEquipStd(Map<String, Object> params);

    List<Map<String, Object>> selectEquipPlan(Map<String, Object> params);

    List<Map<String, Object>> selectLocWork(Map<String, String> params);

    List<Map<String, Object>> selectLocWorkDtl(Map<String, String> params);

    void insertLocWorkDtl(Map<String, Object> params);

    void insertLocWork(Map<String, String> params);

    void deleteLocWorkDtl(Map<String, String> params);
}
