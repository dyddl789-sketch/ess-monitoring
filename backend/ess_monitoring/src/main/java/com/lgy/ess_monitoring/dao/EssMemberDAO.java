package com.lgy.ess_monitoring.dao;

import java.util.HashMap;

import com.lgy.ess_monitoring.dto.EssMemberDTO;

public interface EssMemberDAO {
	public void join(HashMap<String, String> param);
	//mapper에서 이렇게 사용하고 있기때문에 HashMap사용
	//where member_userid = #{member_userid}
	//and member_pw = #{member_pw}
	public EssMemberDTO login(HashMap<String, String> param);
}
