package com.lgy.ess_monitoring.dto;

import java.math.BigDecimal;

import lombok.Data;

@Data
public class EssDeviceDTO {

    // ===== ess_device 기본 =====
    private int device_id;                // 장비 ID
    private int member_id;                // 회원 ID
    private Integer group_id;             // 그룹 ID (NULL 가능)

    private String device_name;           // 장비 이름
    private String location;              // 설치 위치
    private double capacity_kw;           // 태양광 용량(kW)

    private String device_type;           // 장비 타입 (HYBRID)
    private String status;                // 상태 (NORMAL, WARNING, ERROR, OFFLINE)
    private String install_date;          // 설치일

    private BigDecimal latitude;          // 위도
    private BigDecimal longitude;         // 경도
    private Integer nx;                   // 기상청 격자 X
    private Integer ny;                   // 기상청 격자 Y

    private String is_main;               // 대표 장비 여부 (Y/N)

    // ===== ESS 스펙 =====
    private double ess_capacity_kwh;      // ESS 용량(kWh)
    private Double current_charge_kwh;    // 현재 충전량(kWh)
    private double charge_efficiency;     // 충전 효율(%)
    private double discharge_efficiency;  // 방전 효율(%)
    private double electricity_rate;      // 전기요금(원/kWh)

    // ===== 대시보드용 JOIN =====
    private String group_name;            // 그룹명 (JOIN)
    private Double soc;                   // 최신 SOC (%)
    private String record_time;           // 마지막 수신 시간

}