package com.lgy.ess_monitoring.service;

import java.util.List;

import com.lgy.ess_monitoring.dto.DashboardSummaryDTO;
import com.lgy.ess_monitoring.dto.EssDeviceDTO;
import com.lgy.ess_monitoring.dto.EssDeviceGroupDTO;

public interface DashboardService {

    // ===============================
    // 대시보드 요약 정보 조회
    // ===============================
    DashboardSummaryDTO getDashboardSummary(
            int memberId,
            String selectedDate,
            Integer groupId,
            Integer deviceId
    );

    // ===============================
    // 회원 + 그룹 기준 장비 목록 조회
    // groupId = null이면 전체 조회
    // ===============================
    List<EssDeviceDTO> getDevices(
            int memberId,
            Integer groupId
    );

    // ===============================
    // 회원 기준 장비 그룹 목록 조회
    // ===============================
    List<EssDeviceGroupDTO> getGroups(int memberId);
}