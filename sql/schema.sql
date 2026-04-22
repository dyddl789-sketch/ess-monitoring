CREATE TABLE `member` (
  `member_id` int PRIMARY KEY AUTO_INCREMENT,
  `member_name` varchar(30),
  `member_userid` varchar(30) UNIQUE,
  `member_pw` varchar(100),
  `user_type` varchar(20),
  `phone` varchar(20),
  `email` varchar(50),
  `join_date` datetime
);

CREATE TABLE `ess_device` (
  `device_id` int PRIMARY KEY AUTO_INCREMENT,
  `member_id` int,
  `device_name` varchar(50),
  `location` varchar(100),
  `capacity_kw` decimal(10,2),
  `device_type` varchar(20),
  `status` varchar(20),
  `install_date` date
);

CREATE TABLE `monitoring` (
  `monitor_id` int PRIMARY KEY AUTO_INCREMENT,
  `device_id` int,
  `voltage` decimal(10,2),
  `current` decimal(10,2),
  `soc` decimal(5,2),
  `power_output` decimal(10,2),
  `record_time` datetime
);

CREATE TABLE `energy_log` (
  `log_id` int PRIMARY KEY AUTO_INCREMENT,
  `device_id` int,
  `daily_kwh` decimal(10,2),
  `monthly_kwh` decimal(10,2),
  `cost` decimal(10,2),
  `log_date` date
);

CREATE TABLE `alert` (
  `alert_id` int PRIMARY KEY AUTO_INCREMENT,
  `device_id` int,
  `alert_type` varchar(30),
  `alert_level` varchar(20),
  `message` varchar(200),
  `status` varchar(20),
  `created_at` datetime
);

ALTER TABLE `ess_device` ADD FOREIGN KEY (`member_id`) REFERENCES `member` (`member_id`);

ALTER TABLE `monitoring` ADD FOREIGN KEY (`device_id`) REFERENCES `ess_device` (`device_id`);

ALTER TABLE `energy_log` ADD FOREIGN KEY (`device_id`) REFERENCES `ess_device` (`device_id`);

ALTER TABLE `alert` ADD FOREIGN KEY (`device_id`) REFERENCES `ess_device` (`device_id`);
