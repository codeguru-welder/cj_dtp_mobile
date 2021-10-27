package com.mink.connectors.cjlogistics.grid;

import com.mink.connectors.cjlogistics.mapper.GridMapper;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;

@Service("cjlogistics.GridService")
public class GridService {

    @Resource(name = "cjlogistics.gridMapper")
    private GridMapper gridMapper;

    public List<Map<String, Object>> selectDataList(Map<String, Object> params) {
        return gridMapper.selectDataList(params);
    }

    public void updateDataList(Map<String, Object> paramMap) {
        gridMapper.updateDataList(paramMap);
    }
}
