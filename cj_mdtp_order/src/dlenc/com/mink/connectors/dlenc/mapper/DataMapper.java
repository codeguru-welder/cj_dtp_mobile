package com.mink.connectors.dlenc.mapper;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import java.util.List;
import java.util.Map;

@Mapper("dataMapper")
public interface DataMapper {

    List<Map<String, Object>> selectDataList(Map<String, Object> params);

    void updateDataList(Map<String, Object> paramMap);
}
