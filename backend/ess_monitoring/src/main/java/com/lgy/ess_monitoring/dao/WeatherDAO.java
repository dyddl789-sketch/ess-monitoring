package com.lgy.ess_monitoring.dao;

import java.util.List;

import com.lgy.ess_monitoring.dto.EssDeviceDTO;
import com.lgy.ess_monitoring.dto.WeatherDataDTO;

public interface WeatherDAO {

    public List<EssDeviceDTO> selectWeatherTargetDevices();

    public int insertWeatherData(WeatherDataDTO dto);

    public WeatherDataDTO selectLatestWeatherByDeviceId(int deviceId);
}