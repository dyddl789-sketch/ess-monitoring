package com.lgy.ess_monitoring.service;

import java.util.List;

import com.lgy.ess_monitoring.dto.WeatherDataDTO;

public interface WeatherDataService {

    // 특정 기기의 가장 가까운 예보 1건 조회
    public WeatherDataDTO getCurrentWeather(int device_id);

    // 특정 기기의 시간별 예보 목록 조회
    public List<WeatherDataDTO> getWeatherList(int device_id);

    // 기상청 API 호출 후 WeatherDataDTO 리스트로 변환
    // 아직 DB 저장은 하지 않음
    public List<WeatherDataDTO> fetchWeatherByDeviceId(int device_id);

    // 기상청 API 호출 후 weather_data 테이블에 저장
    public void fetchAndSaveWeatherByDeviceId(int device_id);

    // DB에 데이터가 없으면 API 호출 후 저장하고 다시 조회
    public WeatherDataDTO getOrFetchCurrentWeather(int device_id);

    // DB에 데이터가 없으면 API 호출 후 저장하고 시간별 목록 조회
    public List<WeatherDataDTO> getOrFetchWeatherList(int device_id);
}