package com.lgy.ess_monitoring.dto;

import lombok.Data;

@Data
public class EssDeviceDTO {
	private int device_id;          // 장비 고유 ID
    private int member_id;          // 장비 소유 회원 ID
    
//    int는 null을 못 담고 기본값이 0이 되기 때문에,
//    나중에 없는 그룹인데 group_id = 0으로 들어가서 외래키 오류가 날 수 있다.
    private Integer group_id;       // 그룹 ID, null 가능
    
    private String device_name;     // 장비 이름
    private String location;        // 설치 위치
    private double capacity_kw;     // 장비 용량
    
    private String device_type;     // 장비 종류
    private String status;          // 현재 상태
    private String install_date;    // 설치 날짜
	
}
