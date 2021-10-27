package com.mink.connectors.mdtporder.mapper;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import java.util.List;
import java.util.Map;

@Mapper("mdtp.gridMapper")
public interface GridMapper {
    List<Map<String, Object>> selectDataList(Map<String, Object> params);

    void updateDataList(Map<String, Object> paramMap);
}
