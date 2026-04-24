package com.lgy.ess_monitoring.dao;

import java.lang.reflect.Array;
import java.util.ArrayList;

import org.apache.ibatis.annotations.Param;

import com.lgy.ess_monitoring.dto.EssMonitoringDTO;

public interface EssMonitoringDAO{
	public ArrayList<EssMonitoringDTO> getData(int memberId);
	String getDbUser();
    int getTotalCount();
    int getMemberCount(int memberId);
}
