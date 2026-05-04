package com.lgy.ess_monitoring.service;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.lgy.ess_monitoring.dao.DashboardDAO;
import com.lgy.ess_monitoring.dto.DashboardSummaryDTO;
import com.lgy.ess_monitoring.dto.EssDeviceDTO;
import com.lgy.ess_monitoring.dto.EssDeviceGroupDTO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class DashboardServiceImpl implements DashboardService {

    @Autowired
    private SqlSession sqlSession;

    // DAO 가져오기
    private DashboardDAO getDao() {
        return sqlSession.getMapper(DashboardDAO.class);
    }

    // 대시보드 요약 정보 조회
    @Override
    public DashboardSummaryDTO getDashboardSummary(
            int memberId,
            String selectedDate,
            Integer groupId,
            Integer deviceId
    ) {
        log.info("getDashboardSummary() memberId={}, selectedDate={}",
                memberId, selectedDate);

        return getDao().getDashboardSummary(memberId, selectedDate, groupId, deviceId);
    }

    // 회원/그룹 기준 장비 목록 조회
    @Override
    public List<EssDeviceDTO> getDevices(int memberId, Integer groupId) {
        log.info("getDevices() memberId={}, groupId={}", memberId, groupId);

        return getDao().getDevices(memberId, groupId);
    }

    // 회원 기준 장비 그룹 목록 조회
    @Override
    public List<EssDeviceGroupDTO> getGroups(int memberId) {
        log.info("getGroups() memberId={}", memberId);

        return getDao().getGroups(memberId);
    }
}