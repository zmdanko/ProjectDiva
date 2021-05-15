package com.zybe.controller;

import org.apache.tomcat.util.http.fileupload.IOUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.URLEncoder;

@RestController
public class DownloaderContorller {
    @GetMapping("download/{platform}")
    public void download(@PathVariable("platform") String platform, HttpServletResponse response) throws IOException {
        String path="",filename = "";
        switch (platform) {
            case "Android32":
                path = "D:\\develop\\ProjectDiva\\DELPHI\\ProjectDiva\\Android\\Debug\\ProjectDiva\\bin\\";
                filename ="ProjectDiva.apk";
                break;
            case "Win64":
                path = "D:\\develop\\ProjectDiva\\DELPHI\\ProjectDiva\\Win64\\Debug\\";
                filename = "ProjectDiva.exe";
                break;
        }

        response.setHeader("content-disposition", "attachment;filename=" + URLEncoder.encode(filename, "utf-8"));
        response.setContentLength((int) new File(path+filename).length());
        FileInputStream fileInputStream = new FileInputStream(path+filename);
        IOUtils.copy(fileInputStream, response.getOutputStream());

        fileInputStream.close();
    }
}
