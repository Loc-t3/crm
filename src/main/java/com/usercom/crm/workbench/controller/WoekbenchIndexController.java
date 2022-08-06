package com.usercom.crm.workbench.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class WoekbenchIndexController {
    //跳转至主业务页面
    @RequestMapping("/workbench/index.do")
    public String Index(){
        return "workbench/index";
    }
}
