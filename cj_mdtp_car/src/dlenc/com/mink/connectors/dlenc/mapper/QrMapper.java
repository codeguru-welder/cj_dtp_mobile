package com.mink.connectors.dlenc.mapper;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import java.util.List;
import java.util.Map;

@Mapper("qrMapper")
public interface QrMapper {

    void insertQrCode(Map<String, String> params);

    List<Map<String, Object>> selectQrList(Map<String, String> params);
}
