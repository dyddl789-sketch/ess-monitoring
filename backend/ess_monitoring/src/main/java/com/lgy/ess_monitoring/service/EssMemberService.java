package com.lgy.ess_monitoring.service;

import java.util.HashMap;

import com.lgy.ess_monitoring.dto.EssMemberDTO;

public interface EssMemberService {
	public void join(HashMap<String, String> param);
	public EssMemberDTO login(HashMap<String, String> param);
}
