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

    // 랜딩 페이지
    @RequestMapping("/main")
    public String main() {
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