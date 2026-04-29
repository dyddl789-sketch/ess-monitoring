package com.lgy.ess_monitoring.dao;

import java.util.ArrayList;

import com.lgy.ess_monitoring.dto.EssMonitoringDTO;

public interface EssMonitoringDAO{
	public ArrayList<EssMonitoringDTO> getData(int memberId);
	public EssMonitoringDTO getLatestMonitoring(int device_id); 
	
	String getDbUser();
    int getTotalCount();
    int getMemberCount(int memberId);
}
