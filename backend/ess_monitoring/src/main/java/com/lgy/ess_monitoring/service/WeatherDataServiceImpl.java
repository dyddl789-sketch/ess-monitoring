package com.lgy.ess_monitoring.service;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.lgy.ess_monitoring.dao.WeatherDataDAO;
import com.lgy.ess_monitoring.dto.WeatherDataDTO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class WeatherDataServiceImpl implements WeatherDataService {

    @Autowired
    private SqlSession sqlSession;

    @Override
    public WeatherDataDTO getLatestWeather(int device_id) {

        log.info("@# [WeatherDataServiceImpl] getLatestWeather() 시작");
        log.info("@# [WeatherDataServiceImpl] device_id => {}", device_id);

        WeatherDataDAO dao = sqlSession.getMapper(WeatherDataDAO.class);

        WeatherDataDTO dto = dao.getLatestWeather(device_id);

        log.info("@# [WeatherDataServiceImpl] weather dto => {}", dto);
        log.info("@# [WeatherDataServiceImpl] getLatestWeather() 종료");

        return dto;
    }
}