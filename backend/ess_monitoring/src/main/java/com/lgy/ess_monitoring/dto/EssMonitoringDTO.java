package com.lgy.ess_monitoring.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class EssMonitoringDTO {
	private int ess_id;        // PK
	private int member_id;     // 회원번호 (FK)
    private String device_name;// 장비명
    private double voltage;    // 전압
    private double current_val;// 전류
    private double soc;        // 충전율
    private String status;     // 상태
    private String measured_at;// 측정시간
}
