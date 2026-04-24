package com.lgy.ess_monitoring.service;

import java.util.ArrayList;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.lgy.ess_monitoring.dao.EssMonitoringDAO;
import com.lgy.ess_monitoring.dto.EssMonitoringDTO;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class EssMonitoringServiceImpl implements EssMonitoringService {

	@Autowired
	private SqlSession sqlSession;
	
	@Override
	public ArrayList<EssMonitoringDTO> getData(int memberId) {
		EssMonitoringDAO dao = sqlSession.getMapper(EssMonitoringDAO.class);
		
		log.info("@# service memberId => " + memberId);
	    log.info("@# DB USER => " + dao.getDbUser());
	    log.info("@# TOTAL COUNT => " + dao.getTotalCount());
	    log.info("@# MEMBER COUNT(" + memberId + ") => " + dao.getMemberCount(memberId));	    
	    
		ArrayList<EssMonitoringDTO> list = dao.getData(memberId);
        log.info("@# service list => " + list);
        log.info("@# service list size => " + list.size());
        
		return list;
	}

}
