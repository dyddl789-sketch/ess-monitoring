package com.lgy.ess_monitoring.controller;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.lgy.ess_monitoring.dto.EssMemberDTO;
import com.lgy.ess_monitoring.service.EssMemberService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class EssMemberController {
	
	@Autowired
	private EssMemberService service;
	
	@RequestMapping("/join_view")
	public String join_view() {
		log.info("@# join_view()");
		return "join_view";
	}
	
	@RequestMapping("/join")
    public String join(@RequestParam HashMap<String, String> param) {
        log.info("@# join()");
        service.join(param);
        return "redirect:login_view";
    }
	
	@RequestMapping("/login")
	public String login(@RequestParam("member_userid") String id,
						@RequestParam("member_pw") String pw,
						HttpSession session, 
						Model model){
		
		log.info("id=>" + id);
		log.info("pw=>" + pw);
		
		EssMemberDTO dto = service.login(id);
		
		//아이디 불일치
		if (dto == null) {
			model.addAttribute("msg", "아이디가 존재하지 않습니다.");
			return "login_view";
		}
		
		//비밀번호 불일치
		if (!dto.getMember_pw().equals(pw)) {
			model.addAttribute("msg", "비밀번호가 틀렸습니다");
			return "login_view";
		}
		log.info("@# login dto => " + dto);
		log.info("@# dto member_id => " + dto.getMember_id());
		log.info("@# dto member_userid => " + dto.getMember_userid());
		//로그인 성공
		session.setAttribute("member_id", dto.getMember_id());
	    session.setAttribute("member_name", dto.getMember_name());
		
	    return "login_success";

	}
	
	@RequestMapping("/login_view")
	public String login_view() {
		return "login_view";
	}

	@RequestMapping("/logout")
	public String logout(HttpSession session) {
		
		// 로그인 정보 제거
		session.invalidate();
		return "redirect:login_view";
	}
	
	

	
}








