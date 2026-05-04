package com.lgy.ess_monitoring.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.lgy.ess_monitoring.dto.DashboardSummaryDTO;
import com.lgy.ess_monitoring.dto.EssDeviceDTO;
import com.lgy.ess_monitoring.dto.EssDeviceGroupDTO;

public interface DashboardDAO {

    // 대시보드 요약 조회
    DashboardSummaryDTO getDashboardSummary(
            @Param("memberId") int memberId,
            @Param("selectedDate") String selectedDate,
            @Param("groupId") Integer groupId,
            @Param("deviceId") Integer deviceId
    );

    // 회원/그룹 기준 장비 목록 조회
    List<EssDeviceDTO> getDevices(
            @Param("memberId") int memberId,
            @Param("groupId") Integer groupId
    );

    // 회원 기준 장비 그룹 목록 조회
    List<EssDeviceGroupDTO> getGroups(
            @Param("memberId") int memberId
    );
}