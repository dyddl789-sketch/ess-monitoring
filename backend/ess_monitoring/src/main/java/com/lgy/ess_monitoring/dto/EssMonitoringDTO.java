package com.lgy.ess_monitoring.dto;

import java.math.BigDecimal;
import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class EssMonitoringDTO {

    private int monitor_id;        // PK
    private int device_id;         // 장비 ID (FK)

    private BigDecimal voltage;    // 전압 (V)
    private BigDecimal current_a;  // 전류 (A)
    private BigDecimal soc;        // 충전율 (%)
    private BigDecimal power_output; // 출력 전력 (kW)

    private Timestamp record_time; // 측정 시간
}