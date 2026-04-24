package com.lgy.ess_monitoring.service;

import java.util.HashMap;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.lgy.ess_monitoring.dao.EssMemberDAO;
import com.lgy.ess_monitoring.dto.EssMemberDTO;

@Service
public class EssMemberServiceImpl implements EssMemberService{

	@Autowired
	private SqlSession sqlSession;
	
	@Override
	public void join(HashMap<String, String> param) {
		EssMemberDAO dao = sqlSession.getMapper(EssMemberDAO.class);
		dao.join(param);
	}

	@Override
	public EssMemberDTO login(String member_userid) {
		
		EssMemberDAO dao = sqlSession.getMapper(EssMemberDAO.class);

		return dao.login(member_userid);
	}
	
}
