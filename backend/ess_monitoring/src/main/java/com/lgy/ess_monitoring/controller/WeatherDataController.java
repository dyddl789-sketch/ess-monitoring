package com.lgy.ess_monitoring.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lgy.ess_monitoring.dto.WeatherDataDTO;
import com.lgy.ess_monitoring.service.WeatherDataService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class WeatherDataController {

    @Autowired
    private WeatherDataService weatherDataService;

    // 현재 날씨 조회
    // DB에 있으면 DB 사용, 없으면 API 호출 후 저장
    @ResponseBody
    @RequestMapping(
        value = "/weather/current",
        method = RequestMethod.GET,
        produces = "application/json; charset=UTF-8"
    )
    public WeatherDataDTO currentWeather(int device_id) {

        log.info("@# /weather/current 호출 device_id => {}", device_id);

        return weatherDataService.getOrFetchCurrentWeather(device_id);
    }

    // 시간별 날씨 조회
    // DB에 있으면 DB 사용, 없으면 API 호출 후 저장
    @ResponseBody
    @RequestMapping(
        value = "/weather/list",
        method = RequestMethod.GET,
        produces = "application/json; charset=UTF-8"
    )
    public List<WeatherDataDTO> weatherList(int device_id) {

        log.info("@# /weather/list 호출 device_id => {}", device_id);

        return weatherDataService.getOrFetchWeatherList(device_id);
    }
}