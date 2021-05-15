package com.zybe;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

@SpringBootApplication
@EnableDiscoveryClient
public class DownloaderApplication {
    public static void main(String[] args){
        SpringApplication.run(DownloaderApplication.class, args);
}}
