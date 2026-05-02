package com.lgy.ess_monitoring.dao;

import org.apache.ibatis.annotations.Param;

import com.lgy.ess_monitoring.dto.DashboardSummaryDTO;

public interface DashboardDAO {

	DashboardSummaryDTO getDashboardSummary(
		    @Param("memberId") int memberId,
		    @Param("selectedDate") String selectedDate,
		    @Param("groupId") Integer groupId,
		    @Param("deviceId") Integer deviceId
		);
}
