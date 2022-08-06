package com.usercom.crm.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import java.io.IOException;

@Controller
public class IndexController {
    //跳转到index.jsp主页面
 /*   @RequestMapping("/")
    public String index(){
        System.out.println("2");
        return "index";


    }*/
    @GetMapping("/")
    public String index(ServletRequest request, ServletResponse response) throws IOException {
        /*System.out.println("2");*/
        return "index";


    }
}
