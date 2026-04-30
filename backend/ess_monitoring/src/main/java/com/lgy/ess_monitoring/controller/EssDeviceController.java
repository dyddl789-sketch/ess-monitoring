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
import com.lgy.ess_monitoring.dto.WeatherDataDTO;
import com.lgy.ess_monitoring.service.WeatherDataService;


import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/device") // ⭐ 여기 중요
public class EssDeviceController {

    @Autowired
    private EssDeviceService deviceService;

    @Autowired
    private EssMonitoringService monitoringService;
    
    @Autowired
    private WeatherDataService weatherDataService;
    
    // ===============================
    // 1. 등록 페이지 이동
    // ===============================
    @RequestMapping("/registerForm")
    public String registerForm() {
        return "device/registerForm";
    }

    // ===============================
    // 2. 기기 등록
    // ===============================
    @RequestMapping(value = "/register", method = RequestMethod.POST)
    @ResponseBody
    public String deviceRegister(EssDeviceDTO deviceDTO, HttpSession session) {

        log.info("@# deviceRegister()");
        log.info("@# deviceDTO => {}", deviceDTO);

        Integer member_id = (Integer) session.getAttribute("member_id");

        if (member_id == null) {
            return "login_view";
        }

        deviceDTO.setMember_id(member_id);

        if (deviceDTO.getStatus() == null || deviceDTO.getStatus().equals("")) {
            deviceDTO.setStatus("정상");
        }

        deviceService.inseretDevice(deviceDTO);

        return "success";
    }

    // ===============================
    // 3. 기기 목록 (Ajax)
    // ===============================
    @RequestMapping(value = "/listAjax", method = RequestMethod.GET, produces = "application/json; charset=UTF-8")
    @ResponseBody
    public String deviceList(HttpSession session) throws Exception {

        log.info("@# deviceList()");

        Integer member_id = (Integer) session.getAttribute("member_id");

        ArrayList<EssDeviceDTO> deviceList = new ArrayList<>();

        if (member_id != null) {
            deviceList = deviceService.getDeviceList(member_id);
        }

        ObjectMapper mapper = new ObjectMapper();
        return mapper.writeValueAsString(deviceList);
    }

    // ===============================
    // 4. 기기 삭제
    // ===============================
    @RequestMapping(value = "/delete", method = RequestMethod.POST)
    @ResponseBody
    public String deleteDevice(int device_id, HttpSession session) {

        Integer member_id = (Integer) session.getAttribute("member_id");

        if (member_id == null) {
            return "login_required";
        }

        int result = deviceService.deleteDevice(device_id, member_id);

        return (result == 1) ? "success" : "fail";
    }

 // ===============================
 // 5. 상세 페이지
 // ===============================
 @RequestMapping("/detail")
 public String deviceDetailPage(@RequestParam("device_id") int device_id,
                                HttpSession session,
                                Model model) {

     log.info("@# [deviceDetailPage] device_id => {}", device_id);

     // 1. 로그인 여부 확인
     Integer member_id = (Integer) session.getAttribute("member_id");

     if (member_id == null) {
         return "redirect:/login_view";
     }

     // 2. 기기 상세 정보 조회
     EssDeviceDTO device = deviceService.deviceDetail(device_id);

     // 3. 최신 모니터링 데이터 조회
     EssMonitoringDTO monitor = monitoringService.getLatestMonitoring(device_id);

     // 4. 현재 날씨 1건 조회
     // DB에 없으면 API 호출 → DB 저장 → 다시 조회
     WeatherDataDTO weather = weatherDataService.getOrFetchCurrentWeather(device_id);

     // 5. 시간별 날씨 목록 조회
     // DB에 없으면 API 호출 → DB 저장 → 다시 조회
     List<WeatherDataDTO> weatherList = weatherDataService.getOrFetchWeatherList(device_id);

     log.info("@# device => {}", device);
     log.info("@# monitor => {}", monitor);
     log.info("@# weather => {}", weather);
     log.info("@# weatherList size => {}", weatherList == null ? 0 : weatherList.size());

     // 6. JSP로 데이터 전달
     model.addAttribute("device", device);
     model.addAttribute("monitor", monitor);
     model.addAttribute("weather", weather);
     model.addAttribute("weatherList", weatherList);

     return "device/deviceDetail";
 }

    // ===============================
    // 6. 상세 Ajax (필요시 유지)
    // ===============================
    @RequestMapping(value = "/detailAjax", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public String deviceDetailAjax(@RequestParam("device_id") int device_id) throws Exception {

        EssDeviceDTO dto = deviceService.deviceDetail(device_id);

        ObjectMapper mapper = new ObjectMapper();
        return mapper.writeValueAsString(dto);
    }
    
    
}