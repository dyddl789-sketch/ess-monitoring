package com.lgy.ess_monitoring.dto;

import java.math.BigDecimal;
import java.sql.Timestamp;

import lombok.Data;

@Data
public class WeatherDataDTO {

    private int weatherId;
    private int deviceId;

    private String fcstDate;
    private String fcstTime;

    private String skyStatus;
    private String rainType;
    private int rainProb;

    private BigDecimal temperature;
    private int humidity;
    private BigDecimal windSpeed;
    private BigDecimal solarRadiation;

    private String essStatus;

    private Timestamp createdAt;

    private String sunrise;
    private String sunset;

    private String baseDate;
    private String baseTime;
}