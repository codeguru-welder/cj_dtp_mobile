package com.mink.connectors.cjlogistics.mapper;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import java.util.List;
import java.util.Map;

@Mapper("cjlogistics.gridMapper")
public interface GridMapper {
    List<Map<String, Object>> selectDataList(Map<String, Object> params);

    void updateDataList(Map<String, Object> paramMap);
}
