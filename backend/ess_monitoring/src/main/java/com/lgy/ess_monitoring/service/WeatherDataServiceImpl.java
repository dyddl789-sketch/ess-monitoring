package com.lgy.ess_monitoring.service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.math.BigDecimal;
import java.net.URL;
import java.net.URLEncoder;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.math.RoundingMode;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.lgy.ess_monitoring.dao.WeatherDataDAO;
import com.lgy.ess_monitoring.dto.EssDeviceDTO;
import com.lgy.ess_monitoring.dto.WeatherDataDTO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class WeatherDataServiceImpl implements WeatherDataService {

    @Autowired
    private SqlSession sqlSession;

    @Autowired
    private EssDeviceService deviceService;

    // ===============================
    // 하늘 상태 코드 변환
    // SKY 1: 맑음, 3: 구름많음, 4: 흐림
    // ===============================
    private String convertSky(String value) {
        if ("1".equals(value)) return "맑음";
        if ("3".equals(value)) return "구름많음";
        if ("4".equals(value)) return "흐림";
        return value;
    }

    // ===============================
    // 강수 형태 코드 변환
    // PTY 0: 없음, 1: 비, 2: 비/눈, 3: 눈, 4: 소나기
    // ===============================
    private String convertPty(String value) {
        if ("0".equals(value)) return "없음";
        if ("1".equals(value)) return "비";
        if ("2".equals(value)) return "비/눈";
        if ("3".equals(value)) return "눈";
        if ("4".equals(value)) return "소나기";
        return value;
    }

    // ===============================
    // 기상청 단기예보 base_time 계산
    // 발표 시각: 0200, 0500, 0800, 1100, 1400, 1700, 2000, 2300
    // 발표 직후 데이터가 늦게 열릴 수 있어서 10분 여유
    // ===============================
    private String getBaseTime() {
        LocalTime now = LocalTime.now();

        int hour = now.getHour();
        int minute = now.getMinute();

        if (hour < 2 || (hour == 2 && minute < 10)) return "2300";
        if (hour < 5 || (hour == 5 && minute < 10)) return "0200";
        if (hour < 8 || (hour == 8 && minute < 10)) return "0500";
        if (hour < 11 || (hour == 11 && minute < 10)) return "0800";
        if (hour < 14 || (hour == 14 && minute < 10)) return "1100";
        if (hour < 17 || (hour == 17 && minute < 10)) return "1400";
        if (hour < 20 || (hour == 20 && minute < 10)) return "1700";
        if (hour < 23 || (hour == 23 && minute < 10)) return "2000";

        return "2300";
    }

    // ===============================
    // 기상청 단기예보 base_date 계산
    // 새벽 2시 이전에 2300 발표 데이터를 쓰는 경우 전날 날짜 사용
    // ===============================
    private String getBaseDate(String baseTime) {
        LocalDate today = LocalDate.now();

        if ("2300".equals(baseTime) && LocalTime.now().getHour() < 2) {
            today = today.minusDays(1);
        }

        return today.format(DateTimeFormatter.ofPattern("yyyyMMdd"));
    }

    // ===============================
    // 1. 현재 시간 이후 가장 가까운 예보 1건 조회
    // ===============================
    @Override
    public WeatherDataDTO getCurrentWeather(int device_id) {

        log.info("@# [WeatherDataServiceImpl] getCurrentWeather() 시작");
        log.info("@# device_id => {}", device_id);

        WeatherDataDAO dao = sqlSession.getMapper(WeatherDataDAO.class);

        WeatherDataDTO dto = dao.getCurrentWeather(device_id);

        log.info("@# current weather dto => {}", dto);
        log.info("@# [WeatherDataServiceImpl] getCurrentWeather() 종료");

        return dto;
    }

    // ===============================
    // 2. 현재 시간 이후 시간별 예보 목록 조회
    // ===============================
    @Override
    public List<WeatherDataDTO> getWeatherList(int device_id) {

        log.info("@# [WeatherDataServiceImpl] getWeatherList() 시작");
        log.info("@# device_id => {}", device_id);

        WeatherDataDAO dao = sqlSession.getMapper(WeatherDataDAO.class);

        List<WeatherDataDTO> list = dao.getWeatherList(device_id);

        log.info("@# weather list size => {}", list == null ? 0 : list.size());
        log.info("@# [WeatherDataServiceImpl] getWeatherList() 종료");

        return list;
    }

    // ===============================
    // 3. 기상청 API 호출 후 WeatherDataDTO 리스트 생성
    // DB 저장은 하지 않고 API → DTO 변환까지만 담당
    // ===============================
    @Override
    public List<WeatherDataDTO> fetchWeatherByDeviceId(int device_id) {

        log.info("@# [WeatherDataServiceImpl] fetchWeatherByDeviceId() 시작");
        log.info("@# device_id => {}", device_id);

        List<WeatherDataDTO> resultList = new ArrayList<>();

        try {
            // 1. device_id로 기기 정보 조회
            EssDeviceDTO device = deviceService.deviceDetail(device_id);

            if (device == null) {
                log.warn("@# 기기 정보 없음 device_id => {}", device_id);
                return resultList;
            }

            // 2. 기기별 기상청 격자 좌표 조회
            // EssDeviceDTO 필드명이 weather_nx, weather_ny 기준일 때 사용
            String nx = String.valueOf(device.getNx());
            String ny = String.valueOf(device.getNy());

            // 3. 좌표가 없으면 API 호출하지 않음
            if ("0".equals(nx) || "0".equals(ny)) {
            	log.warn("@# 기상청 좌표 없음 device_id => " + device_id
            	        + ", nx => " + nx
            	        + ", ny => " + ny);
                return resultList;
            }

            // 4. 기상청 API 키
            // 나중에는 properties 파일로 분리하는 것을 추천
            String serviceKey = "0158e6e63feeaa94d850ceb2717eb35dd38ef7e913623ad5170645f214bc880e";

            // 5. 기상청 발표 기준 날짜/시간 계산
            String baseTime = getBaseTime();
            String baseDate = getBaseDate(baseTime);

            // 6. API 요청 URL 생성
            StringBuilder urlBuilder = new StringBuilder(
                "http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst"
            );

            urlBuilder.append("?serviceKey=").append(serviceKey);
            urlBuilder.append("&pageNo=1");
            urlBuilder.append("&numOfRows=1000");
            urlBuilder.append("&dataType=JSON");
            urlBuilder.append("&base_date=").append(baseDate);
            urlBuilder.append("&base_time=").append(baseTime);
            urlBuilder.append("&nx=").append(nx);
            urlBuilder.append("&ny=").append(ny);

            log.info("@# 기상청 요청 URL => {}", urlBuilder.toString());

            // 7. API 호출
            URL url = new URL(urlBuilder.toString());

            BufferedReader br = new BufferedReader(
                new InputStreamReader(url.openStream(), "UTF-8")
            );

            StringBuilder sb = new StringBuilder();
            String line;

            while ((line = br.readLine()) != null) {
                sb.append(line);
            }

            br.close();

            log.info("@# 기상청 응답 수신 완료");

            // 8. JSON 파싱
            ObjectMapper mapper = new ObjectMapper();

            JsonNode root = mapper.readTree(sb.toString());

            String resultCode = root.path("response")
                                    .path("header")
                                    .path("resultCode")
                                    .asText();

            if (!"00".equals(resultCode)) {
                String resultMsg = root.path("response")
                                       .path("header")
                                       .path("resultMsg")
                                       .asText();

                log.warn("@# 기상청 API 비정상 응답 resultCode => {}, resultMsg => {}", resultCode, resultMsg);
                return resultList;
            }

            JsonNode items = root.path("response")
                                 .path("body")
                                 .path("items")
                                 .path("item");

            // 9. 같은 예보일자 + 예보시간끼리 하나의 DTO로 묶기
            Map<String, WeatherDataDTO> map = new LinkedHashMap<>();

            for (JsonNode item : items) {
                String category = item.path("category").asText();
                String fcstDate = item.path("fcstDate").asText();
                String fcstTime = item.path("fcstTime").asText();
                String value = item.path("fcstValue").asText();

                String key = fcstDate + "_" + fcstTime;

                map.putIfAbsent(key, new WeatherDataDTO());

                WeatherDataDTO dto = map.get(key);

                dto.setDeviceId(device_id);
                dto.setBaseDate(baseDate);
                dto.setBaseTime(baseTime);
                dto.setFcstDate(fcstDate);
                dto.setFcstTime(fcstTime);
                //화면용
                dto.setDisplayTime(formatForecastLabel(fcstDate, fcstTime));

                // 10. 필요한 카테고리만 저장
                switch (category) {
                    case "TMP":
                        dto.setTemperature(new BigDecimal(value));
                        break;

                    case "SKY":
                        dto.setSkyStatus(convertSky(value));
                        break;

                    case "PTY":
                        dto.setRainType(convertPty(value));
                        break;

                    case "POP":
                    	if (value != null && !value.isEmpty()) {
                    	    dto.setRainProb(Integer.parseInt(value));
                    	}
                        break;

                    case "REH":
                        if (value != null && !value.trim().isEmpty()) {
                        	dto.setHumidity(Integer.parseInt(value));
                        }
                        break;

                    case "WSD":
                        dto.setWindSpeed(new BigDecimal(value));
                        break;
                }
            }

            resultList.addAll(map.values());
            
         // 실제 일출/일몰 API 호출
            String latitude = String.valueOf(device.getLatitude());
            String longitude = String.valueOf(device.getLongitude());
            
            String[] sunTimes = getSunRiseSet(baseDate, latitude, longitude);
            String sunrise = sunTimes[0];
            String sunset = sunTimes[1];
            
            for (WeatherDataDTO dto : resultList) {
//                applyDummySunTime(dto); 기상청 API로 못 채우는 컬럼 더미/계산값 세팅
                dto.setSunrise(sunrise);
                dto.setSunset(sunset);
                dto.setSolarRadiation(estimateSolarRadiation(dto));
                dto.setEssStatus(analyzeEssStatus(dto));
            }
            
            log.info("@# 변환된 WeatherDataDTO 개수 => {}", resultList.size());

        } catch (Exception e) {
            log.error("@# fetchWeatherByDeviceId 오류", e);
        }

        log.info("@# [WeatherDataServiceImpl] fetchWeatherByDeviceId() 종료");

        return resultList;
    }

    // ===============================
    // 4. 기상청 API 호출 후 DB 저장
    // insertWeatherData는 Mapper에서
    // ON DUPLICATE KEY UPDATE 방식으로 처리
    // ===============================
    @Override
    public void fetchAndSaveWeatherByDeviceId(int device_id) {

        log.info("@# [WeatherDataServiceImpl] fetchAndSaveWeatherByDeviceId() 시작");
        log.info("@# device_id => {}", device_id);

        WeatherDataDAO dao = sqlSession.getMapper(WeatherDataDAO.class);

        // 1. API 호출 후 DTO 리스트 생성
        List<WeatherDataDTO> weatherList = fetchWeatherByDeviceId(device_id);

        log.info("@# 저장 대상 weatherList size => {}", weatherList.size());

        // 2. DB 저장
        for (WeatherDataDTO dto : weatherList) {
            dao.insertWeatherData(dto);
            log.info("@# 날씨 저장 완료 => {}", dto);
        }

        log.info("@# [WeatherDataServiceImpl] fetchAndSaveWeatherByDeviceId() 종료");
    }

    // ===============================
    // 5. 현재 날씨 조회
    // DB에 없으면 API 호출 → 저장 → 다시 조회
    // 상세화면 Controller에서 사용할 핵심 메서드
    // ===============================
    @Override
    public WeatherDataDTO getOrFetchCurrentWeather(int device_id) {

        log.info("@# [WeatherDataServiceImpl] getOrFetchCurrentWeather() 시작");
        log.info("@# device_id => {}", device_id);

        WeatherDataDAO dao = sqlSession.getMapper(WeatherDataDAO.class);

        // 1. 먼저 DB 조회
        WeatherDataDTO weather = dao.getCurrentWeather(device_id);

        // 2. DB에 없으면 API 호출 후 저장
        if (weather == null) {
            log.info("@# 현재 날씨 DB 데이터 없음 → API 호출 후 저장");

            fetchAndSaveWeatherByDeviceId(device_id);

            // 3. 저장 후 다시 조회
            weather = dao.getCurrentWeather(device_id);
        }
        
        // ✅ DB에서 조회한 데이터에 화면용 시간 적용
        if (weather != null) {
            weather.setDisplayTime(
                formatForecastLabel(weather.getFcstDate(), weather.getFcstTime())
            );
        }
        
        log.info("@# 최종 current weather => {}", weather);
        log.info("@# [WeatherDataServiceImpl] getOrFetchCurrentWeather() 종료");
        
        return weather;
    }

    // ===============================
    // 6. 시간별 날씨 목록 조회
    // DB에 없으면 API 호출 → 저장 → 다시 조회
    // 상세화면 시간별 예보에 사용
    // ===============================
    @Override
    public List<WeatherDataDTO> getOrFetchWeatherList(int device_id) {

        log.info("@# [WeatherDataServiceImpl] getOrFetchWeatherList() 시작");
        log.info("@# device_id => {}", device_id);

        WeatherDataDAO dao = sqlSession.getMapper(WeatherDataDAO.class);

        // 1. 먼저 DB 조회
        List<WeatherDataDTO> weatherList = dao.getWeatherList(device_id);
        // 2. DB에 없으면 API 호출 후 저장
        if (weatherList == null || weatherList.isEmpty()) {
            log.info("@# 시간별 날씨 DB 데이터 없음 → API 호출 후 저장");

            fetchAndSaveWeatherByDeviceId(device_id);

            // 3. 저장 후 다시 조회
            weatherList = dao.getWeatherList(device_id);
        }

        applyDisplayTime(weatherList);
        log.info("@# 최종 weatherList size => {}", weatherList == null ? 0 : weatherList.size());
        log.info("@# [WeatherDataServiceImpl] getOrFetchWeatherList() 종료");

        return weatherList;
    }
    
    
 // ===============================
 // 실제 일출/일몰 조회
 // 한국천문연구원 출몰시각 API 사용
 // ===============================
	 private String[] getSunRiseSet(String locdate, String latitude, String longitude) {
	
	     try {
	         String serviceKey = "0158e6e63feeaa94d850ceb2717eb35dd38ef7e913623ad5170645f214bc880e";
	
	         StringBuilder urlBuilder = new StringBuilder(
	             "http://apis.data.go.kr/B090041/openapi/service/RiseSetInfoService/getLCRiseSetInfo"
	         );
	
	         urlBuilder.append("?serviceKey=").append(URLEncoder.encode(serviceKey, "UTF-8"));
	         urlBuilder.append("&locdate=").append(locdate);
	         urlBuilder.append("&latitude=").append(latitude);
	         urlBuilder.append("&longitude=").append(longitude);
	
	         URL url = new URL(urlBuilder.toString());
	
	         BufferedReader br = new BufferedReader(
	             new InputStreamReader(url.openStream(), "UTF-8")
	         );
	
	         StringBuilder sb = new StringBuilder();
	         String line;
	
	         while ((line = br.readLine()) != null) {
	             sb.append(line);
	         }
	
	         br.close();
	
	         String xml = sb.toString();
	
	         String sunrise = parseXmlValue(xml, "sunrise");
	         String sunset = parseXmlValue(xml, "sunset");
	         log.info("@# 일출 원본값 => {}", sunrise);
	         log.info("@# 일몰 원본값 => {}", sunset);
	         String formattedSunrise = formatSunTime(sunrise);
	         String formattedSunset = formatSunTime(sunset);
	         log.info("@# 일출 변환값 => {}", formattedSunrise);
	         log.info("@# 일몰 변환값 => {}", formattedSunset);
	         
	         return new String[] {
	        		 formattedSunrise, 
	        		 formattedSunset
	         };
	
	     } catch (Exception e) {
	         log.error("@# 일출/일몰 API 호출 오류", e);
	
	         // 실패 시 임시 기본값
	         return new String[] {"06:00", "18:30"};
	     }
	 }
	 
	 
		//XML 태그 값 추출
		private String parseXmlValue(String xml, String tagName) {
		  try {
		      String startTag = "<" + tagName + ">";
		      String endTag = "</" + tagName + ">";
		
		      int start = xml.indexOf(startTag);
		      int end = xml.indexOf(endTag);
		
		      if (start == -1 || end == -1) {
		          return null;
		      }
		
		      return xml.substring(start + startTag.length(), end).trim();
		
		  } catch (Exception e) {
		      return null;
		  }
		}
		
		
		//0605 → 06:05
		private String formatSunTime(String time) {
		  if (time != null && time.length() == 4) {
		      return time.substring(0, 2) + ":" + time.substring(2, 4);
		  }
		
		  return time;
		}   
 
 
 
    
    
    //시간 포맷
    private String formatForecastLabel(String fcstDate, String fcstTime) {
        try {
            LocalDate today = LocalDate.now();
            LocalDate target = LocalDate.parse(fcstDate, DateTimeFormatter.ofPattern("yyyyMMdd"));

            int hour = Integer.parseInt(fcstTime.substring(0, 2));

            // 오늘
            if (target.equals(today)) {
                return "오늘 " + hour + "시";
            }

            // 내일
            if (target.equals(today.plusDays(1))) {
                return "내일 " + hour + "시";
            }

            // 그 외 날짜
            return target.format(DateTimeFormatter.ofPattern("MM/dd")) + " " + hour + "시";

        } catch (Exception e) {
            return fcstTime;
        }
    }
    
    private void applyDisplayTime(List<WeatherDataDTO> list) {
        if (list == null || list.isEmpty()) {
            return;
        }
        for (WeatherDataDTO dto : list) {
            dto.setDisplayTime(
                formatForecastLabel(dto.getFcstDate(), dto.getFcstTime())
            );
        }
    }
    
    
// // 더미 일출/일몰 세팅
//    private void applyDummySunTime(WeatherDataDTO dto) {
//        if (dto == null) return;
//
//        dto.setSunrise("06:00");
//        dto.setSunset("18:30");
//    }

    // 야간 여부 판단
    private boolean isNight(WeatherDataDTO dto) {
        try {
            if (dto == null ||
                dto.getFcstTime() == null ||
                dto.getSunrise() == null ||
                dto.getSunset() == null) {
                return false;
            }

            int fcst = Integer.parseInt(dto.getFcstTime()); // 1500
            int sunrise = Integer.parseInt(dto.getSunrise().replace(":", "")); // 06:00 → 0600
            int sunset = Integer.parseInt(dto.getSunset().replace(":", ""));   // 18:30 → 1830

            return fcst < sunrise || fcst >= sunset;

        } catch (Exception e) {
            return false;
        }
    }

    // 일사량 추정
    private BigDecimal estimateSolarRadiation(WeatherDataDTO dto) {
        if (dto == null) return BigDecimal.ZERO;

        if (isNight(dto)) {
            return BigDecimal.ZERO;
        }

        BigDecimal base = new BigDecimal("700");

        if ("구름많음".equals(dto.getSkyStatus())) {
            base = base.multiply(new BigDecimal("0.55"));
        } else if ("흐림".equals(dto.getSkyStatus())) {
            base = base.multiply(new BigDecimal("0.25"));
        }

        if (dto.getRainType() != null && !"없음".equals(dto.getRainType())) {
            base = base.multiply(new BigDecimal("0.30"));
        }

        if (dto.getRainProb() != null) {
            BigDecimal rainFactor = BigDecimal.ONE.subtract(
                new BigDecimal(dto.getRainProb())
                    .divide(new BigDecimal("100"), 2, RoundingMode.HALF_UP)
            );

            if (rainFactor.compareTo(new BigDecimal("0.20")) < 0) {
                rainFactor = new BigDecimal("0.20");
            }

            base = base.multiply(rainFactor);
        }

        return base.setScale(2, RoundingMode.HALF_UP);
    }

    // ESS 상태 분석
    private String analyzeEssStatus(WeatherDataDTO dto) {
        if (dto == null) return "분석불가";

        if (isNight(dto)) {
            return "야간 발전 없음";
        }

        if (dto.getRainType() != null && !"없음".equals(dto.getRainType())) {
            return "발전량 저하 예상";
        }

        if ("흐림".equals(dto.getSkyStatus())) {
            return "발전 효율 낮음";
        }

        if ("구름많음".equals(dto.getSkyStatus())) {
            return "발전 효율 보통";
        }

        if (dto.getWindSpeed() != null &&
            dto.getWindSpeed().compareTo(new BigDecimal("10")) >= 0) {
            return "강풍 주의";
        }

        if (dto.getTemperature() != null &&
            dto.getTemperature().compareTo(new BigDecimal("35")) >= 0) {
            return "고온 주의";
        }

        return "발전 조건 양호";
    }
    
}