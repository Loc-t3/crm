package com.usercom.crm.workbench.controller;

import com.usercom.crm.settings.domain.User;
import com.usercom.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
public class ToIndexController {
   @RequestMapping("/workbench/main/index.do")
    public String ToIndex() {
        return "workbench/main/index";
    }

}
