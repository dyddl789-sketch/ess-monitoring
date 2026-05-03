package com.lgy.ess_monitoring.service;

import java.util.List;

import com.lgy.ess_monitoring.dto.DashboardSummaryDTO;
import com.lgy.ess_monitoring.dto.EssDeviceDTO;
import com.lgy.ess_monitoring.dto.EssDeviceGroupDTO;

public interface DashboardService {

	DashboardSummaryDTO getDashboardSummary(
		    int memberId,
		    String selectedDate,
		    Integer groupId,
		    Integer deviceId
		);

	List<EssDeviceDTO> getDevices(int memberId, Integer groupId);

	List<EssDeviceGroupDTO> getGroups(int memberId);
}