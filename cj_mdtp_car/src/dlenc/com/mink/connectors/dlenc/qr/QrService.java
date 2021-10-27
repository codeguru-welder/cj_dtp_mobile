package com.mink.connectors.dlenc.qr;

import com.mink.connectors.dlenc.mapper.QrMapper;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;

@Service("dlenc.QrService")
public class QrService {

    @Resource(name = "qrMapper")
    private QrMapper qrMapper;

    public List<Map<String, Object>> selectQrList(Map<String, String> params) {
        return qrMapper.selectQrList(params);
    }

    public void insertQrCode(Map<String, String> params) {
        qrMapper.insertQrCode(params);
    }
}
