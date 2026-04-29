package com.lgy.ess_monitoring.controller;

import java.util.ArrayList;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.lgy.ess_monitoring.dto.EssDeviceDTO;
import com.lgy.ess_monitoring.service.EssDeviceService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class EssDeviceController {
	
	@Autowired
	private EssDeviceService deviceService;
	
	// 기기 등록
	@RequestMapping(value = "/device_register_ajax", method = RequestMethod.POST)
	@ResponseBody
	public String deviceRegister(EssDeviceDTO deviceDTO, HttpSession session) {
		log.info("@# deviceRegister()");
        log.info("@# 화면에서 넘어온 deviceDTO => " + deviceDTO);
        
        Integer member_id = (Integer)session.getAttribute("member_id");
        log.info("@# session member_id => " + member_id);

        if (member_id == null) {
			log.info("@# 로그인 X");
			return "login_view";
		}
        
        // 회원 ID는 화면에서 받지 않고 세션에서 넣는다.
        deviceDTO.setMember_id(member_id);
        
        // 개인 회원이면 group_id는 null로 들어가도 됨
        // 기업/그룹 기능을 아직 안 만들었다면 화면에서 group_id를 받지 않아도 됨

        // 상태값이 비어 있으면 기본값 정상으로 세팅
        if (deviceDTO.getStatus() == null || deviceDTO.getStatus().equals("")) {
            deviceDTO.setStatus("정상");
        }

        log.info("@# 저장 직전 deviceDTO => " + deviceDTO);

        deviceService.inseretDevice(deviceDTO);

        log.info("@# 기기 등록 완료");

        return "success";
	}
	
	@RequestMapping(value = "/device_list_ajax",
					method = RequestMethod.GET,
					produces = "application/json; charset=UTF-8"
					)
	@ResponseBody
	public String deviceList(HttpSession session) throws Exception {
	    log.info("@# deviceList()");

	    Integer member_id = (Integer) session.getAttribute("member_id");
	    log.info("@# session member_id => " + member_id);

	    ArrayList<EssDeviceDTO> deviceList = new ArrayList<EssDeviceDTO>();

	    if (member_id == null) {
	        log.info("@# 로그인 세션 없음");
	    } else {
	        deviceList = deviceService.getDeviceList(member_id);
	    }

	    log.info("@# deviceList size => " + deviceList.size());

	    ObjectMapper mapper = new ObjectMapper();
	    String json = mapper.writeValueAsString(deviceList);

	    log.info("@# deviceList json => " + json);

	    return json;
	}
	
	@RequestMapping(value = "/device_delete_ajax", method = RequestMethod.POST)
	@ResponseBody
	public String deleteDevice(int device_id, HttpSession session) {
	    log.info("@# deleteDevice()");
	    log.info("@# device_id => " + device_id);

	    Integer member_id = (Integer) session.getAttribute("member_id");
	    log.info("@# session member_id => " + member_id);

	    if (member_id == null) {
	        log.info("@# 로그인 세션 없음");
	        return "login_required";
	    }

	    int result = deviceService.deleteDevice(device_id, member_id);

	    log.info("@# delete result => " + result);

	    if (result == 1) {
	        return "success";
	    } else {
	        return "fail";
	    }
	}
	
	@ResponseBody
	@RequestMapping(value = "/device_detail_ajax", produces = "application/json; charset=UTF-8")
	public String deviceDetailAjax(@RequestParam("device_id") int device_id, HttpSession session) {
		log.info("@# deviceDetailAjax()");
	    log.info("@# device_id => " + device_id);

	    Integer member_id = (Integer) session.getAttribute("member_id");
	    log.info("@# session member_id => " + member_id);

	    if (member_id == null) {
	        log.info("@# 로그인 정보 없음");
	        return "{}";
	    }

	    EssDeviceDTO dto = deviceService.deviceDetail(device_id);

	    log.info("@# device detail dto => " + dto);

	    ObjectMapper mapper = new ObjectMapper();

	    String json = "";

	    try {
	        json = mapper.writeValueAsString(dto);
	    } catch (Exception e) {
	        log.error("@# device detail json 변환 오류 => " + e.getMessage());
	        json = "{}";
	    }

	    log.info("@# device detail json => " + json);

	    return json;
	}
	
	// 대표 디바이스 설정
	@ResponseBody
	@RequestMapping("/set_main_device")
	public String setMainDevice(@RequestParam("device_id") int device_id,
	                            HttpSession session) {

	    log.info("@# set_main_device()");
	    log.info("@# device_id => " + device_id);

	    Integer member_id = (Integer) session.getAttribute("member_id");
	    log.info("@# member_id => " + member_id);

	    // 로그인 안 된 상태
	    if (member_id == null) {
	        return "login_required";
	    }

	    // 대표 디바이스 설정
	    deviceService.setMainDevice(member_id, device_id);

	    return "success";
	}
}



















