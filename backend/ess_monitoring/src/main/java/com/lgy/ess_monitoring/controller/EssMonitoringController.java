package com.lgy.ess_monitoring.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.lgy.ess_monitoring.dto.EssMonitoringDTO;
import com.lgy.ess_monitoring.service.EssMonitoringService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class EssMonitoringController {
	
	@Autowired
	private EssMonitoringService service;
	
	@RequestMapping("/list")
	public String list(HttpSession session, Model model) {
	log.info("@# list()");

	//1. 로그인 체크
	Integer memberId = (Integer)session.getAttribute("member_id");
	log.info("@#session member_id=>"+memberId);
	
	if (memberId == null) {
        return "redirect:login_view";
    }

    // 2. 로그인한 회원 데이터 조회
    ArrayList<EssMonitoringDTO> list = service.getData(memberId);
	log.info("@# list size => " + list.size());

    // 3. JSP로 전달
    model.addAttribute("list", list);

    return "list";
	
}
}
