package com.mink.connectors.hybridtest.main;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class MainService {
	private static final Logger log = LoggerFactory.getLogger(MainService.class);

	public MainService() {}

	public String run(Map<String, String> params, Object connection) throws Exception {
		return executeLegacy();
	}

	private String executeLegacy() {
		InputStream in = null;
		StringBuilder results = new StringBuilder();

		try {
			in = this.getClass().getClassLoader().getResourceAsStream("com/mink/connectors/hybridtest/main/main.json");
			BufferedReader r = new BufferedReader(new InputStreamReader(in, "UTF-8"));
			String line = null;
			while ((line = r.readLine()) != null) {
				results.append(line);
			}
		} catch (Exception e) {
			log.error("Can not execute legacy.", e);
		} finally {
			if (in != null) {
				try { in.close(); } catch (Exception e) {}
			}
		}

		return results.toString();
	}
}
