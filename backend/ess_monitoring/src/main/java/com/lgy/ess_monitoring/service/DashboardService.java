package com.lgy.ess_monitoring.service;

import com.lgy.ess_monitoring.dto.DashboardSummaryDTO;

public interface DashboardService {

	DashboardSummaryDTO getDashboardSummary(
		    int memberId,
		    String selectedDate,
		    Integer groupId,
		    Integer deviceId
		);
}