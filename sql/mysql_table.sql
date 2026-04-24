CREATE TABLE ess_member (
  member_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '회원 고유 번호',

  member_name VARCHAR(30) NOT NULL COMMENT '회원 이름',

  member_userid VARCHAR(30) NOT NULL UNIQUE COMMENT '회원 로그인 아이디',

  member_pw VARCHAR(100) NOT NULL COMMENT '회원 비밀번호',

  user_type VARCHAR(20) NOT NULL COMMENT '회원 유형, 예: 기업, 개인',

  phone VARCHAR(20) COMMENT '회원 전화번호',

  email VARCHAR(50) COMMENT '회원 이메일',

  join_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '회원 가입일'
  

) COMMENT='ESS 모니터링 웹서비스 회원 정보를 저장하는 테이블';

alter table ess_member add column address varchar(100);

CREATE TABLE ess_device (
  device_id INT PRIMARY KEY AUTO_INCREMENT COMMENT 'ESS 장비 고유 번호',

  member_id INT NOT NULL COMMENT '장비를 소유하거나 관리하는 회원 번호',

  device_name VARCHAR(50) NOT NULL COMMENT 'ESS 장비 이름, 예: SOLAR_BUSAN_ESS_01',

  location VARCHAR(100) COMMENT 'ESS 장비 설치 위치',

  capacity_kw DECIMAL(10,2) COMMENT 'ESS 장비 용량, 단위: kW',

  device_type VARCHAR(20) NOT NULL COMMENT '장비 유형, 예: 태양광, 배터리, 풍력',

  status VARCHAR(20) NOT NULL COMMENT '장비 상태, 예: 정상, 주의, 고장, 점검중',

  install_date DATE COMMENT '장비 설치일',

  CONSTRAINT fk_device_member
    FOREIGN KEY (member_id) REFERENCES ess_member(member_id)
    ON DELETE CASCADE

) COMMENT='회원별 ESS 장비 정보를 저장하는 테이블';


CREATE TABLE monitoring (
  monitor_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '모니터링 데이터 고유 번호',

  device_id INT NOT NULL COMMENT '모니터링 대상 ESS 장비 번호',

  voltage DECIMAL(10,2) NOT NULL COMMENT '전압 값, 단위: V',

  current_a DECIMAL(10,2) NOT NULL COMMENT '전류 값, 단위: A',

  soc DECIMAL(5,2) NOT NULL COMMENT '배터리 충전 상태, 단위: %, 0~100 범위',

  power_output DECIMAL(10,2) COMMENT '출력 전력, 단위: kW',

  record_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '모니터링 데이터 기록 시각',

  CONSTRAINT fk_monitoring_device
    FOREIGN KEY (device_id) REFERENCES ess_device(device_id)
    ON DELETE CASCADE,

  CONSTRAINT chk_soc_range
    CHECK (soc BETWEEN 0 AND 100)

) COMMENT='ESS 장비의 실시간 모니터링 데이터를 저장하는 테이블';


CREATE TABLE energy_log (
  log_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '에너지 사용 기록 고유 번호',

  device_id INT NOT NULL COMMENT '에너지 기록 대상 ESS 장비 번호',

  daily_kwh DECIMAL(10,2) COMMENT '일일 전력량, 단위: kWh',

  monthly_kwh DECIMAL(10,2) COMMENT '월간 전력량, 단위: kWh',

  cost DECIMAL(10,2) COMMENT '전력 사용 비용 또는 절감 비용',

  log_date DATE NOT NULL COMMENT '에너지 기록 기준 날짜',

  CONSTRAINT fk_energylog_device
    FOREIGN KEY (device_id) REFERENCES ess_device(device_id)
    ON DELETE CASCADE

) COMMENT='ESS 장비의 일별 및 월별 에너지 사용량을 저장하는 테이블';


CREATE TABLE ess_alert (
  alert_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '알림 고유 번호',

  device_id INT NOT NULL COMMENT '알림이 발생한 ESS 장비 번호',

  alert_type VARCHAR(30) NOT NULL COMMENT '알림 유형, 예: 저전압, 과전류, SOC 부족, 장비고장',

  alert_level VARCHAR(20) NOT NULL COMMENT '알림 등급, 예: 정보, 주의, 경고, 위험',

  message VARCHAR(200) NOT NULL COMMENT '알림 상세 메시지',

  status VARCHAR(20) NOT NULL COMMENT '알림 처리 상태, 예: 미확인, 확인, 처리완료',

  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '알림 발생 시각',

  CONSTRAINT fk_alert_device
    FOREIGN KEY (device_id) REFERENCES ess_device(device_id)
    ON DELETE CASCADE

) COMMENT='ESS 장비 이상 상태 및 경고 알림을 저장하는 테이블';


CREATE TABLE `board` (
  `board_no` INT PRIMARY KEY AUTO_INCREMENT COMMENT '게시글 고유 번호',

  `member_id` INT NOT NULL COMMENT '게시글 작성자 회원 번호',

  `board_title` VARCHAR(100) NOT NULL COMMENT '게시글 제목',

  `board_hit` INT DEFAULT 0 COMMENT '게시글 조회수',

  `board_content` TEXT NOT NULL COMMENT '게시글 내용',

  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '게시글 작성일',

  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '게시글 수정일',

  CONSTRAINT fk_board_member
    FOREIGN KEY (member_id) REFERENCES ess_member(member_id)
    ON DELETE CASCADE

) COMMENT='공지사항 또는 문의 게시글을 저장하는 게시판 테이블';


CREATE TABLE weather_data (
  weather_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '날씨 데이터 고유 번호',

  device_id INT NOT NULL COMMENT '날씨 데이터와 연결되는 ESS 장비 번호',

  fcst_date VARCHAR(8) NOT NULL COMMENT '예보 날짜, 예: 20260424',

  fcst_time VARCHAR(4) NOT NULL COMMENT '예보 시간, 예: 0900, 1200',

  sky_status VARCHAR(20) COMMENT '하늘 상태, 예: 맑음, 구름많음, 흐림',

  rain_type VARCHAR(20) COMMENT '강수 형태, 예: 없음, 비, 비/눈, 눈, 소나기',

  rain_prob INT COMMENT '강수 확률, 단위: %',

  temperature DECIMAL(5,2) COMMENT '기온, 단위: 섭씨',

  humidity INT COMMENT '습도, 단위: %',

  wind_speed DECIMAL(5,2) COMMENT '풍속, 단위: m/s',

  ess_status VARCHAR(30) COMMENT '날씨 기반 ESS 상태 판단 결과, 예: 발전양호, 발전저하, 충전필요',

  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '날씨 데이터 저장 시각',

  CONSTRAINT fk_weather_device
    FOREIGN KEY (device_id) REFERENCES ess_device(device_id)
    ON DELETE CASCADE

) COMMENT='기상청 API 예보 데이터를 저장하는 테이블';