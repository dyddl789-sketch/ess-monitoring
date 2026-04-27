package com.lgy.ess_monitoring.service;

import java.util.HashMap;

import com.lgy.ess_monitoring.dto.EssMemberDTO;

public interface EssMemberService {
    // 회원가입
    public void join(HashMap<String, String> param);

    // 로그인
    public EssMemberDTO login(HashMap<String, String> param);

    // 아이디 중복 체크
    public int idCheck(String member_userid);

    // 이메일 중복 체크
    public int emailCheck(String email);
}
