<%@ page pageEncoding="EUC-KR" contentType="text/html; charset=EUC-KR" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.FileReader" %>
<%@ page import="java.io.FileWriter" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    // SET CONST VARIABLE
    String FILEPATH = "D:/MiAPS_Server/MiAPS6beta/miaps.updateresource/updateresource.bat"; // *.bat or  *.sh
    final String ENCODING = "EUC-KR";
    
    String execFileNm = request.getParameter("exec");
    if (execFileNm != null && !execFileNm.equals("")) {
    	FILEPATH = execFileNm;
    }

    String methodName = request.getParameter("method");

    if (methodName.equalsIgnoreCase("save")) {
        // Save File
        PrintWriter w = response.getWriter();

        String getFileName = request.getParameter("fileName");
        String getFileData = request.getParameter("fileData");

        if (getFileData.length() == 0) {
            w.println("No File.");
        } else {
            response.setCharacterEncoding(ENCODING);
            response.setContentType("text/html; charset=" + ENCODING);

            try {
                FileWriter fw;
                fw = new FileWriter(getFileName, false);
                fw.write(getFileData);
                fw.close();

                w.println("Save Success");
            } catch (Exception e) {
                w.println("Save Fail");
                w.println(e.getMessage());
            } finally {

            }
        }
    } else if (methodName.equalsIgnoreCase("load")) {
        // Load File
        String getParamName = request.getParameter("fileName");
        PrintWriter w = response.getWriter();
        BufferedReader br = new BufferedReader(new FileReader(getParamName));

        try {

            String line;
            StringBuilder sb = new StringBuilder();
            while ((line = br.readLine()) != null) {
                sb.append(line).append('\n');
            }
            w.println(sb);
        } catch (Exception e) {
            w.println("Load Fail...");
            w.println(e.getMessage());
        } finally {
            try {
                br.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    } else if (methodName.equalsIgnoreCase("update")) {
        // Update Resource
        Process p;

        String getType = request.getParameter("type")
                .equalsIgnoreCase("default") ? "" : request.getParameter("type");
        String getCase = request.getParameter("case")
                .equalsIgnoreCase("none") ? "" : request.getParameter("case");
        BufferedReader br = null;
        BufferedReader err;
        PrintWriter w = response.getWriter();

        String runExec = FILEPATH + " " + getType + " " + getCase;

        w.println("[Update Resource Log]");
        w.println("Run : " + runExec);
        w.println("-------------------------------------------------------------\n");
        long startTime = System.currentTimeMillis();
        try {
            p = Runtime.getRuntime()
                    .exec(runExec);
            br = new BufferedReader(new InputStreamReader(p.getInputStream(), ENCODING));
            String str;
            while ((str = br.readLine()) != null) {
                w.println(str);
            }

            err = new BufferedReader(new InputStreamReader(p.getErrorStream(), ENCODING));
            while (err.ready()) {
                w.println(err.readLine());
            }

        } catch (Exception e) {
            w.println(e.getMessage());
        } finally {
            if (br != null) {
                try {
                    br.close();
                } catch (Exception ignored) {
                }
            }
            w.println("\n-------------------------------------------------------------");
            w.println("[Time Spent] : " + new SimpleDateFormat("s.SSS")
                    .format(System.currentTimeMillis() - startTime) + " sec");
            w.println("[End Log]");
        }
    }
%>