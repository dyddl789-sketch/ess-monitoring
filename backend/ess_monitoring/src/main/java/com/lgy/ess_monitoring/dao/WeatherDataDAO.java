package com.lgy.ess_monitoring.dao;

import java.util.List;

import com.lgy.ess_monitoring.dto.WeatherDataDTO;

public interface WeatherDataDAO {

	// 기존: 특정 기기의 가장 최신 날씨 1건 조회
    public WeatherDataDTO getLatestWeather(int device_id);

    // 기존 또는 새로 추가: 날씨 데이터 저장
    public void insertWeatherData(WeatherDataDTO dto);

    // 추가: 특정 기기의 예보 목록 조회
    // 상세화면의 날씨 카드/표에서 사용할 데이터
    public List<WeatherDataDTO> getWeatherList(int device_id);

    // 추가: 현재 화면 상단에 보여줄 대표 날씨 1건 조회
    // 지금 시간 이후 가장 가까운 예보 1건을 가져오는 용도
    public WeatherDataDTO getCurrentWeather(int device_id);
}