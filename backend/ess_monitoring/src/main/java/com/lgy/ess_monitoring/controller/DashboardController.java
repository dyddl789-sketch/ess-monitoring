package com.lgy.ess_monitoring.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lgy.ess_monitoring.dto.DashboardSummaryDTO;
import com.lgy.ess_monitoring.dto.EssDeviceDTO;
import com.lgy.ess_monitoring.dto.EssDeviceGroupDTO;
import com.lgy.ess_monitoring.service.DashboardService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/dashboard")
public class DashboardController {

    @Autowired
    private DashboardService dashboardService;
    
    //요약출력
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
    
    
    @RequestMapping(value="/devices", method=RequestMethod.GET)
    @ResponseBody
    public List<EssDeviceDTO> getDevicesByGroup(
            Integer groupId,
            HttpSession session
    ) {
        Integer memberId = (Integer) session.getAttribute("member_id");

        return dashboardService.getDevices(memberId, groupId);
    }
    
    @RequestMapping(value="/main", method=RequestMethod.GET)
    public String dashboardMain(HttpSession session, Model model) {

        Integer memberId = (Integer) session.getAttribute("member_id");

        log.info("🔥 session memberId = {}", memberId);

        if (memberId == null) {
            return "redirect:/login";
        }

        List<EssDeviceGroupDTO> groupList = dashboardService.getGroups(memberId);
        List<EssDeviceDTO> deviceList = dashboardService.getDevices(memberId, null);

        log.info("🔥 groupList size = {}", groupList.size());
        log.info("🔥 deviceList size = {}", deviceList.size());
        log.info("🔥 groupList = {}", groupList);
        log.info("🔥 deviceList = {}", deviceList);

        model.addAttribute("selectedDate", java.time.LocalDate.now().toString());
        model.addAttribute("groupList", groupList);
        model.addAttribute("deviceList", deviceList);

        return "dashboard_main";
    }
}