package com.lgy.ess_monitoring.controller;

import java.util.HashMap;

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

    // =========================
    // 1. 랜딩 페이지 (비로그인 가능)
    // =========================
    @RequestMapping("/main")
    public String main() {
        return "main";
    }

    // =========================
    // 2. 로그인 화면
    // =========================
    @RequestMapping("/login_view")
    public String login_view() {
        return "login_view";
    }

    // =========================
    // 3. 로그인 처리
    // =========================
    @RequestMapping("/login")
    public String login(@RequestParam("member_userid") String id,
                        @RequestParam("member_pw") String pw,
                        HttpSession session,
                        Model model) {

        HashMap<String, String> param = new HashMap<>();
        param.put("member_userid", id);
        param.put("member_pw", pw);

        EssMemberDTO dto = service.login(param);

        // 로그인 실패
        if (dto == null) {
            model.addAttribute("msg", "아이디 또는 비밀번호가 틀렸습니다.");
            return "login_view";
        }

        // 로그인 성공 → session 저장
        session.setAttribute("member_id", dto.getMember_id());
        session.setAttribute("member_name", dto.getMember_name());

        // 로그인 후 이동 (보호 페이지)
        return "redirect:/main";
    }

//    // =========================
//    // 4. 로그인 후 메인 (보호 페이지)
//    // =========================
//    @RequestMapping("/dashboard")
//    public String dashboard(HttpSession session) {
//
//        // 로그인 체크
//        if (session.getAttribute("member_id") == null) {
//            return "redirect:/login_view";
//        }
//
//        return "dashboard";
//    }

    // =========================
    // 5. 회원가입 화면
    // =========================
    @RequestMapping("/join_view")
    public String join_view() {
        return "join_view";
    }

    // =========================
    // 6. 회원가입 처리
    // =========================
    @RequestMapping("/join")
    public String join(@RequestParam HashMap<String, String> param) {

        service.join(param);

        return "redirect:/login_view";
    }

    // =========================
    // 7. 로그아웃
    // =========================
    @RequestMapping("/logout")
    public String logout(HttpSession session) {

        session.invalidate();

        return "redirect:/main";
    }
    // 8. 회원가입
    @RequestMapping("/signup")
    public String signup() {
        return "signup"; 
        // /WEB-INF/views/signup.jsp
    }
    
}








