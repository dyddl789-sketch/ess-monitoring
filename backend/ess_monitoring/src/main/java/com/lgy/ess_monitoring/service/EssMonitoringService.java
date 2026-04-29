package com.lgy.ess_monitoring.service;

import java.util.ArrayList;

import com.lgy.ess_monitoring.dto.EssMonitoringDTO;

public interface EssMonitoringService {

    // 로그인한 회원의 모니터링 데이터 조회
    public ArrayList<EssMonitoringDTO> getData(int memberId);

    // 특정 기기의 최신 모니터링 데이터 1건 조회
    public EssMonitoringDTO getLatestMonitoring(int device_id);

    // DB 테스트용
    String getDbUser();

    // 전체 모니터링 데이터 수
    int getTotalCount();

    // 회원별 모니터링 데이터 수
    int getMemberCount(int memberId);
}