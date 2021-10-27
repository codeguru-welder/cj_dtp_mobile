package com.mink.connectors.dlenc.data;

import com.mink.connectors.dlenc.mapper.DataMapper;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;

@Service("dlenc.DataService")
public class DataService {

    @Resource(name = "dataMapper")
    private DataMapper dataMapper;

    public List<Map<String, Object>> selectDataList(Map<String, Object> params) {
        return dataMapper.selectDataList(params);
    }

    public void updateDataList(Map<String, Object> paramMap) {
        dataMapper.updateDataList(paramMap);
    }
}
