package com.lgy.ess_monitoring.dao;

import com.lgy.ess_monitoring.dto.WeatherDataDTO;

public interface WeatherDataDAO {

    public WeatherDataDTO getLatestWeather(int device_id);

}