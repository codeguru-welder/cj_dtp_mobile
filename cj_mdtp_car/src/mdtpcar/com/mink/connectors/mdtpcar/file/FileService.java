package com.mink.connectors.mdtpcar.file;

import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import javax.imageio.ImageIO;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.thinkm.mink.commons.MinkTotalConstants;
import com.thinkm.mink.commons.util.MinkConfig;
import com.thinkm.mink.commons.util.MinkContextParam;

@Service("project.FileService")
public class FileService {

	private Logger logger = LoggerFactory.getLogger(getClass());
	private String tempFileDir = null;
	
	public String saveObject(Map<String, String> paramMap) throws Exception {
		Map<String, Object> returnMap = new HashMap<String, Object>();
		String pBase64 = paramMap.get("p_base64").trim(); // ex) data:image/png;base64,iVBORw0KG.....
	
		StringBuilder errorResult = new StringBuilder();
		
		if (pBase64 == null || "".equals(pBase64)) {
			errorResult.append("{\"code\":\"-1\", \"msg\":\"").append("p_base64값이 없습니다.").append("\"}");
			return errorResult.toString();
		}		
		
		String ext = "jpg";
		if (pBase64.startsWith("data:image")) {
			ext = pBase64.substring(11, pBase64.indexOf(";base64,"));
			pBase64 = pBase64.substring(pBase64.indexOf(";base64,") + 8);
		}
		
		this.tempFileDir = getTempDir();  // MiAPS FileUpload Temp Dir (mink.home/UploadedFiles)
		
		String tempFileNm = "" + UUID.randomUUID();
		//String tempFileNm = userNo;
		String filePath = tempFileDir + File.separator + tempFileNm + "." + ext;
		
		File file = null;
		
		ByteArrayInputStream bis = null;
		BufferedImage bufferedImage = null;
		boolean bException = false;
		
		
        try {
        	
        	File dir = new File(tempFileDir); 
			if (!dir.exists()) {
			    dir.mkdir();
			}
			
			file = new File(filePath);
			if (file.exists()) {
                file.delete();
            }
			
			byte[] bData = Base64.decodeBase64(pBase64);
			//byte[] bData = DatatypeConverter.parseBase64Binary(pBase64);
			
		    bis = new ByteArrayInputStream(bData);
		    bufferedImage = ImageIO.read(bis);

		    ImageIO.write(bufferedImage, ext, new File(filePath));
		    
        } catch (Exception e) {
        	bException = true;
        	errorResult.append("{\"code\":\"-1\", \"msg\":\"").append(e.getMessage()).append("\"}");
        	
        	e.printStackTrace();
        	
        } finally {
            if (bufferedImage != null) {
            	bufferedImage.flush();
            	bufferedImage = null;
            }
            if (bis != null) {
            	bis.close();
            	bis = null;
            }
        }
		
        if (logger.isDebugEnabled()) {
        	logger.debug("---temp_filePath: " + filePath);
        }
        
        if(bException) {
        	return errorResult.toString();
        	
        } else {
        	errorResult.append("{\"code\":\"200\", \"msg\":\"").append(filePath.replaceAll("\\\\", "\\\\\\\\")).append("\"}");
			return errorResult.toString();        	
        }
	}
	
	private String getTempDir() {
		String tempFileDir = MinkConfig.getConfig().get(MinkTotalConstants.FILE_UPLOAD_TEMP_DIR, MinkTotalConstants.CONFIG_DEFAULT_VALUE);
		
		if (StringUtils.isBlank(tempFileDir) || MinkTotalConstants.CONFIG_DEFAULT_VALUE.equalsIgnoreCase(tempFileDir)) {
			tempFileDir = MinkContextParam.MINK_HOME + File.separator + "UploadedFiles";
		}

		//tempFileDir = tempFileDir.replaceAll("\\\\", "/");
		//tempFileDir = tempFileDir + (tempFileDir.endsWith("/") ? "" : "/") + UUID.randomUUID();
		return tempFileDir;
	}
}