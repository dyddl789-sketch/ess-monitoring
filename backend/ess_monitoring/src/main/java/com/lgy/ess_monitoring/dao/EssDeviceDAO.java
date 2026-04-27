package com.lgy.ess_monitoring.dao;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Param;

import com.lgy.ess_monitoring.dto.EssDeviceDTO;

public interface EssDeviceDAO {
	
	//기기 등록
	public void insertDevice(EssDeviceDTO deviceDTO);
	
	// 로그인한 회원의 기기 목록 조회
    public ArrayList<EssDeviceDTO> getDeviceList(int member_id);

    // 로그인한 회원의 기기 수 조회
    public int getDeviceCount(int member_id);
    
    //기기 삭제
    public int deleteDevice(@Param("device_id")int device_id, @Param("member_id")int member_id);
}
