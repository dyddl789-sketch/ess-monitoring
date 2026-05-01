package com.lgy.ess_monitoring.controller;

import java.util.ArrayList;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.lgy.ess_monitoring.dto.DashboardSummaryDTO;
import com.lgy.ess_monitoring.dto.EssDeviceDTO;
import com.lgy.ess_monitoring.service.DashboardService;
import com.lgy.ess_monitoring.service.EssDeviceService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/dashboard")
public class DashboardController {

    @Autowired
    private DashboardService dashboardService;
    @Autowired
    private EssDeviceService deviceService;
    
    
    @RequestMapping(value="/main", method=RequestMethod.GET)
    public String dashboardMain(HttpSession session, Model model) {

        Integer memberId = (Integer) session.getAttribute("member_id");

        log.info("🔹 로그인 memberId = {}", memberId);

        if (memberId == null) {
            log.warn("❗ 로그인 정보 없음 → 로그인 페이지로 이동");
            return "redirect:/login";
        }

        DashboardSummaryDTO summary = dashboardService.getDashboardSummary(memberId);

        log.info("🔹 summary 객체 = {}", summary);

        if (summary != null) {
            log.info("총 장비 수 = {}", summary.getTotalDeviceCount());
            log.info("정상 장비 수 = {}", summary.getNormalDeviceCount());
            log.info("경고 장비 수 = {}", summary.getWarningDeviceCount());
            log.info("오류 장비 수 = {}", summary.getErrorDeviceCount());
            log.info("오프라인 장비 수 = {}", summary.getOfflineDeviceCount());

            log.info("오늘 발전량 = {}", summary.getTodayGenerationKwh());
            log.info("평균 SOC = {}", summary.getAverageSoc());
            log.info("절감 금액 = {}", summary.getTodaySavedCost());
        } else {
            log.warn("❗ summary가 null 입니다 (DB 조회 실패 가능성)");
        }

        model.addAttribute("summary", summary);
        
     //  장비 상태 리스트 추가
        ArrayList<EssDeviceDTO> deviceList = deviceService.getDashboardDeviceStatusList(memberId);

        model.addAttribute("deviceList", deviceList);

        return "dashboard_main";
    }
}