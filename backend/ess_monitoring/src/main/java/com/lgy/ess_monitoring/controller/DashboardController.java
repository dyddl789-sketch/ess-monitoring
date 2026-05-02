package com.lgy.ess_monitoring.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lgy.ess_monitoring.dto.DashboardSummaryDTO;
import com.lgy.ess_monitoring.service.DashboardService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/dashboard")
public class DashboardController {

    @Autowired
    private DashboardService dashboardService;
    
    @RequestMapping(value="/summary",
    		method=RequestMethod.GET,
    		produces="application/json; charset=UTF-8")
    @ResponseBody
    public DashboardSummaryDTO getSummary(
    	    String selectedDate,
    	    Integer groupId,
    	    Integer deviceId,
    	    HttpSession session
    ) {
        Integer memberId = (Integer) session.getAttribute("member_id");

        if (memberId == null) {
            return null;
        }

        if (selectedDate == null || selectedDate.isEmpty()) {
            selectedDate = java.time.LocalDate.now().toString();
        }

        log.info("📊 AJAX 요청 - 날짜: {}, memberId: {}", selectedDate, memberId);

        return dashboardService.getDashboardSummary(memberId, selectedDate, groupId, deviceId);
    }
    
    
    //메인화면로딩
    @RequestMapping(value="/main", method=RequestMethod.GET)
    public String dashboardMain(HttpSession session, Model model) {

        Integer memberId = (Integer) session.getAttribute("member_id");

        // 로그인 체크
        if (memberId == null) {
            return "redirect:/login";
        }
        model.addAttribute("selectedDate", java.time.LocalDate.now().toString());

        // 화면만 반환 (데이터는 AJAX로 처리)
        return "dashboard_main";
    }
}