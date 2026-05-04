package com.lgy.ess_monitoring.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.lgy.ess_monitoring.dto.EssDeviceDTO;
import com.lgy.ess_monitoring.dto.EssMonitoringDTO;
import com.lgy.ess_monitoring.service.EssDeviceService;
import com.lgy.ess_monitoring.service.EssMonitoringService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/device")
public class EssDeviceController {

    @Autowired
    private EssDeviceService deviceService;

    @Autowired
    private EssMonitoringService monitoringService;

    // 등록 페이지 이동
    @RequestMapping(value = "/registerForm", method = RequestMethod.GET)
    public String registerForm() {
        return "device/registerForm";
    }

    // 기기 등록
    @RequestMapping(value = "/register", method = RequestMethod.POST)
    @ResponseBody
    public String deviceRegister(EssDeviceDTO deviceDto, HttpSession session) {
        log.info("@# deviceRegister()");
        log.info("@# deviceDto => {}", deviceDto);

        Integer memberId = (Integer) session.getAttribute("memberId");

        if (memberId == null) {
            return "login_required";
        }

        deviceDto.setMemberId(memberId);

        if (deviceDto.getStatus() == null || deviceDto.getStatus().isEmpty()) {
            deviceDto.setStatus("NORMAL");
        }

        deviceService.insertDevice(deviceDto);

        return "success";
    }

    // 기기 목록 Ajax
    @RequestMapping(
        value = "/listAjax",
        method = RequestMethod.GET,
        produces = "application/json; charset=UTF-8"
    )
    @ResponseBody
    public String deviceList(HttpSession session) throws Exception {
        log.info("@# deviceList()");

        Integer memberId = (Integer) session.getAttribute("memberId");

        List<EssDeviceDTO> deviceList = new ArrayList<>();

        if (memberId != null) {
            deviceList = deviceService.getDeviceList(memberId);
        }

        ObjectMapper objectMapper = new ObjectMapper();
        return objectMapper.writeValueAsString(deviceList);
    }

    // 기기 삭제
    @RequestMapping(value = "/delete", method = RequestMethod.POST)
    @ResponseBody
    public String deleteDevice(@RequestParam("deviceId") int deviceId,
                               HttpSession session) {
        log.info("@# deleteDevice()");
        log.info("@# deviceId => {}", deviceId);

        Integer memberId = (Integer) session.getAttribute("memberId");

        if (memberId == null) {
            return "login_required";
        }

        int result = deviceService.deleteDevice(deviceId, memberId);

        return (result == 1) ? "success" : "fail";
    }

    // 상세 페이지
    @RequestMapping(value = "/detail", method = RequestMethod.GET)
    public String deviceDetailPage(@RequestParam("deviceId") int deviceId,
                                   HttpSession session,
                                   Model model) {
        log.info("@# deviceDetailPage()");
        log.info("@# deviceId => {}", deviceId);

        Integer memberId = (Integer) session.getAttribute("memberId");

        if (memberId == null) {
            return "redirect:/login_view";
        }

        EssDeviceDTO device = deviceService.deviceDetail(deviceId);
        EssMonitoringDTO monitor = monitoringService.getLatestMonitoring(deviceId);

        model.addAttribute("device", device);
        model.addAttribute("monitor", monitor);

        return "device/deviceDetail";
    }

    // 상세 Ajax
    @RequestMapping(
        value = "/detailAjax",
        method = RequestMethod.GET,
        produces = "application/json; charset=UTF-8"
    )
    @ResponseBody
    public String deviceDetailAjax(@RequestParam("deviceId") int deviceId) throws Exception {
        log.info("@# deviceDetailAjax()");
        log.info("@# deviceId => {}", deviceId);

        EssDeviceDTO deviceDto = deviceService.deviceDetail(deviceId);

        ObjectMapper objectMapper = new ObjectMapper();
        return objectMapper.writeValueAsString(deviceDto);
    }
}