package com.lgy.ess_monitoring.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/device")
public class DeviceController {
	
    @RequestMapping("/registerForm")
    public String registerForm() {
        return "device/registerForm";
    }
}
