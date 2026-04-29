package com.lgy.ess_monitoring.service;

import com.lgy.ess_monitoring.dto.WeatherDataDTO;

public interface WeatherDataService {

    public WeatherDataDTO getLatestWeather(int device_id);

}