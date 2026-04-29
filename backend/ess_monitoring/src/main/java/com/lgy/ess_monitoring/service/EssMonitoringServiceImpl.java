package com.lgy.ess_monitoring.service;

import java.util.ArrayList;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.lgy.ess_monitoring.dao.EssMonitoringDAO;
import com.lgy.ess_monitoring.dto.EssMonitoringDTO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class EssMonitoringServiceImpl implements EssMonitoringService {

    @Autowired
    private SqlSession sqlSession;

    @Override
    public ArrayList<EssMonitoringDTO> getData(int memberId) {
        log.info("@# [EssMonitoringServiceImpl] getData()");
        log.info("@# [EssMonitoringServiceImpl] memberId => {}", memberId);

        EssMonitoringDAO dao = sqlSession.getMapper(EssMonitoringDAO.class);
        ArrayList<EssMonitoringDTO> list = dao.getData(memberId);

        log.info("@# [EssMonitoringServiceImpl] list size => {}", list.size());

        return list;
    }

    @Override
    public EssMonitoringDTO getLatestMonitoring(int device_id) {
        log.info("@# [EssMonitoringServiceImpl] getLatestMonitoring() 시작");
        log.info("@# [EssMonitoringServiceImpl] device_id => {}", device_id);

        EssMonitoringDAO dao = sqlSession.getMapper(EssMonitoringDAO.class);
        EssMonitoringDTO dto = dao.getLatestMonitoring(device_id);

        log.info("@# [EssMonitoringServiceImpl] 조회 결과 dto => {}", dto);
        log.info("@# [EssMonitoringServiceImpl] getLatestMonitoring() 종료");

        return dto;
    }

    @Override
    public String getDbUser() {
        log.info("@# [EssMonitoringServiceImpl] getDbUser()");

        EssMonitoringDAO dao = sqlSession.getMapper(EssMonitoringDAO.class);
        return dao.getDbUser();
    }

    @Override
    public int getTotalCount() {
        log.info("@# [EssMonitoringServiceImpl] getTotalCount()");

        EssMonitoringDAO dao = sqlSession.getMapper(EssMonitoringDAO.class);
        return dao.getTotalCount();
    }

    @Override
    public int getMemberCount(int memberId) {
        log.info("@# [EssMonitoringServiceImpl] getMemberCount()");
        log.info("@# [EssMonitoringServiceImpl] memberId => {}", memberId);

        EssMonitoringDAO dao = sqlSession.getMapper(EssMonitoringDAO.class);
        return dao.getMemberCount(memberId);
    }
}