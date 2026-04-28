package com.lgy.ess_monitoring.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.lgy.ess_monitoring.dto.EssMemberDTO;
import com.lgy.ess_monitoring.dto.WeatherDTO;
import com.lgy.ess_monitoring.service.EssDeviceService;
import com.lgy.ess_monitoring.service.EssMemberService;
import com.lgy.ess_monitoring.service.WeatherService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class EssMemberController {

    @Autowired
    private EssMemberService service;
    
    @Autowired
    private WeatherService weatherService;
    
    @Autowired
    private EssDeviceService deviceService;

    // 랜딩 페이지
    @RequestMapping("/main")
    public String main(HttpSession session, Model model) {
    	
    	log.info("@# main");
    	
    	String address = (String) session.getAttribute("member_address");
        log.info("@# main memberAddress => " + address);
        
        Integer member_id = (Integer)session.getAttribute("member_id");
        log.info("@# member_id => " + member_id);
        
        if (member_id != null) {
            int deviceCount = deviceService.getDeviceCount(member_id);
            log.info("@# deviceCount => " + deviceCount);
            model.addAttribute("deviceCount", deviceCount);
        }else {
            model.addAttribute("deviceCount", 0);
		}
        
        //회원 주소 기준 날씨 api 호출
        List<WeatherDTO> weatherList = weatherService.forecastByAddress(address);

        // API 오류 등으로 null이 올 경우를 대비한 방어 코드
        if (weatherList == null) {
            log.info("@# weatherList is null");
            weatherList = new ArrayList<>();
        }

        // 메인 화면에는 너무 많은 데이터가 필요 없으므로 5개만 표시
        if (weatherList.size() > 5) {
            weatherList = weatherList.subList(0, 5);
        }

        // JSP에서 ${weatherList}로 사용할 수 있게 전달
        model.addAttribute("weatherList", weatherList);

        // JSP에서 제목 표시 등에 사용할 수 있게 주소도 전달
        model.addAttribute("address", address);
        log.info("@# main return 직전");
        return "main";
    }

    // 로그인 화면
    @RequestMapping("/login_view")
    public String login_view() {
        return "login_view";
    }

    // 로그인 처리
    @RequestMapping("/login")
    public String login(@RequestParam("member_userid") String id,
                        @RequestParam("member_pw") String pw,
                        HttpSession session,
                        Model model) {

        HashMap<String, String> param = new HashMap<>();
        param.put("member_userid", id);
        param.put("member_pw", pw);

        EssMemberDTO dto = service.login(param);

        if (dto == null) {
            model.addAttribute("msg", "아이디 또는 비밀번호가 틀렸습니다.");
            return "login_view";
        }

        session.setAttribute("loginMember", dto);
        session.setAttribute("member_id", dto.getMember_id());
        session.setAttribute("member_name", dto.getMember_name());
        session.setAttribute("member_userid", dto.getMember_userid());
        session.setAttribute("user_type", dto.getUser_type());
        session.setAttribute("member_address", dto.getAddress());

        return "redirect:/main";
    }

    // 회원가입 화면
    @RequestMapping("/join_view")
    public String join_view() {
        return "join_view";
    }

    // 회원가입 처리
    @RequestMapping("/join")
    public String join(@RequestParam HashMap<String, String> param,
                       Model model) {

        String member_name = param.get("member_name");
        String member_userid = param.get("member_userid");
        String member_pw = param.get("member_pw");
        String user_type = param.get("user_type");
        String email = param.get("email");

        if (member_name == null || member_name.trim().equals("")) {
            model.addAttribute("msg", "이름을 입력해주세요.");
            return "join_view";
        }

        if (member_userid == null || member_userid.trim().equals("")) {
            model.addAttribute("msg", "아이디를 입력해주세요.");
            return "join_view";
        }

        if (member_pw == null || member_pw.trim().equals("")) {
            model.addAttribute("msg", "비밀번호를 입력해주세요.");
            return "join_view";
        }

        if (user_type == null || user_type.trim().equals("")) {
            model.addAttribute("msg", "회원 유형을 선택해주세요.");
            return "join_view";
        }

        int idCount = service.idCheck(member_userid);
        if (idCount > 0) {
            model.addAttribute("msg", "이미 사용 중인 아이디입니다.");
            return "join_view";
        }

        if (email != null && !email.trim().equals("")) {
            int emailCount = service.emailCheck(email);

            if (emailCount > 0) {
                model.addAttribute("msg", "이미 사용 중인 이메일입니다.");
                return "join_view";
            }
        }

        service.join(param);

        return "redirect:/login_view";
    }

    // 로그아웃
    @RequestMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/main";
    }

    // signup.jsp를 따로 쓸 경우
    @RequestMapping("/signup")
    public String signup() {
        return "signup";
    }
}