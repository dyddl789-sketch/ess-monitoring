package com.lgy.ess_monitoring.service;

import java.util.ArrayList;

import com.lgy.ess_monitoring.dto.EssMonitoringDTO;

public interface EssMonitoringService {
    public ArrayList<EssMonitoringDTO> getData(int memberId);
}
