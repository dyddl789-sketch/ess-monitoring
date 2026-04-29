/*
 * package com.lgy.ess_monitoring.controller;
 * 
 * import org.springframework.stereotype.Controller; import
 * org.springframework.web.bind.annotation.GetMapping; import
 * org.springframework.web.bind.annotation.RequestMapping;
 * 
 * import com.lgy.ess_monitoring.service.WeatherDataService;
 * 
 * @Controller
 * 
 * @RequestMapping("/weather-data") public class WeatherDataController {
 * 
 * private final WeatherDataService weatherDataService;
 * 
 * public WeatherDataController(WeatherDataService weatherDataService) {
 * this.weatherDataService = weatherDataService; }
 * 
 * @GetMapping("/fetch") public String fetchWeatherData() {
 * weatherDataService.fetchAndSaveWeatherAllDevices();
 * 
 * return "redirect:/device/list"; } }
 */