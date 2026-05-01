package com.lgy.ess_monitoring.dto;

import lombok.Data;

/**
 * 대시보드 요약 정보 DTO
 * - 사용자가 소유한 ESS 장비 상태 및 당일 통계 정보
 */
@Data
public class DashboardSummaryDTO {

    /** 전체 장비 개수 */
    private int totalDeviceCount;

    /** 정상 상태 장비 개수 (NORMAL) */
    private int normalDeviceCount;

    /** 경고 상태 장비 개수 (WARNING) */
    private int warningDeviceCount;

    /** 오류 상태 장비 개수 (ERROR) */
    private int errorDeviceCount;

    /** 오프라인 장비 개수 (OFFLINE) */
    private int offlineDeviceCount;

    /** 오늘 예상 발전량 합계 (kWh) */
    private Double todayGenerationKwh;

    /** 오늘 평균 SOC (%) */
    private Double averageSoc;

    /** 오늘 예상 절감 금액 (원) */
    private Double todaySavedCost;
}