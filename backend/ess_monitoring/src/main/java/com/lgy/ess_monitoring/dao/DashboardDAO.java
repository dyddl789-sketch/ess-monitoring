package com.lgy.ess_monitoring.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.lgy.ess_monitoring.dto.DashboardSummaryDTO;
import com.lgy.ess_monitoring.dto.EssDeviceDTO;
import com.lgy.ess_monitoring.dto.EssDeviceGroupDTO;

public interface DashboardDAO {

	DashboardSummaryDTO getDashboardSummary(
		    @Param("memberId") int memberId,
		    @Param("selectedDate") String selectedDate,
		    @Param("groupId") Integer groupId,
		    @Param("deviceId") Integer deviceId
		);

	List<EssDeviceDTO> getDevices(
		    @Param("memberId") int memberId,
		    @Param("groupId") Integer groupId
		);

	List<EssDeviceGroupDTO> getGroups(@Param("memberId") int memberId);
}
