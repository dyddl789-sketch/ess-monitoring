package com.lgy.ess_monitoring.dao;

import java.util.HashMap;

import com.lgy.ess_monitoring.dto.EssMemberDTO;

public interface EssMemberDAO {
	public void join(HashMap<String, String> param);
	public EssMemberDTO login(String member_userid);
}
