package com.lgy.ess_monitoring.service;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.lgy.ess_monitoring.dao.DashboardDAO;
import com.lgy.ess_monitoring.dto.DashboardSummaryDTO;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class DashboardServiceImpl implements DashboardService {

    @Autowired
    private SqlSession sqlSession;


	@Override
	public DashboardSummaryDTO getDashboardSummary(
			int memberId, 
			String selectedDate, 
			Integer groupId,
			Integer deviceId) {
		 DashboardDAO dao = sqlSession.getMapper(DashboardDAO.class);
	     return dao.getDashboardSummary(memberId, selectedDate, groupId, deviceId);
	}
}
