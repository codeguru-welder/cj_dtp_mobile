package com.mink.connectors.mdtporder.grid;

import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;

import com.mink.connectors.mdtporder.mapper.GridMapper;

@Service("mdtp.GridService")
public class GridService {

    @Resource(name = "mdtp.gridMapper")
    private GridMapper gridMapper;

    public List<Map<String, Object>> selectDataList(Map<String, Object> params) {
        return gridMapper.selectDataList(params);
    }

    public void updateDataList(Map<String, Object> paramMap) {
        gridMapper.updateDataList(paramMap);
    }
}
