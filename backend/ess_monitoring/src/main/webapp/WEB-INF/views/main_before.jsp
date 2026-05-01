<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ESS Main</title>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/main.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=4c85272f51538d1512f6a5f19d0c8e2a&libraries=services"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<style>
/* ========================= */
/* 기본 설정 */
/* ========================= */

* {
    box-sizing: border-box;
}

body {
    margin: 0;
    background: #f4f7fb;
    color: #0f172a;
    font-family: 'Malgun Gothic', Arial, sans-serif;
}

button {
    font-family: inherit;
}

.container {
    width: 1000px;
    max-width: calc(100% - 40px);
    margin: 0 auto;
}

/* ========================= */
/* Hero 영역 */
/* ========================= */

.hero {
    position: relative;
    min-height: 430px;
    margin-bottom: 0;
    padding: 0;
    color: white;
    background:
        linear-gradient(
            90deg,
            rgba(15, 118, 110, 0.78) 0%,
            rgba(15, 23, 42, 0.72) 58%,
            rgba(15, 23, 42, 0.62) 100%
        ),
        url('${pageContext.request.contextPath}/resources/img/solar-main.jpg') center/cover no-repeat;
    display: flex;
    align-items: center;
}

.hero::after {
    content: "";
    position: absolute;
    inset: 0;
    background:
        radial-gradient(circle at 18% 35%, rgba(20, 184, 166, 0.25), transparent 28%),
        radial-gradient(circle at 80% 20%, rgba(14, 165, 233, 0.20), transparent 26%);
    pointer-events: none;
}

.hero-content {
    position: relative;
    z-index: 2;
    width: 1000px;
    max-width: calc(100% - 40px);
    margin: 0 auto;
    padding-bottom: 60px;
}

.hero-badge {
    display: inline-block;
    padding: 8px 16px;
    margin-bottom: 22px;
    border-radius: 999px;
    background: rgba(255, 255, 255, 0.12);
    border: 1px solid rgba(255, 255, 255, 0.28);
    font-size: 13px;
    font-weight: 700;
    color: #d1fae5;
}

.hero h2 {
    margin: 0 0 18px;
    font-size: 2.9rem;
    line-height: 1.18;
    font-weight: 900;
    letter-spacing: -1.5px;
}

.hero p {
    margin: 0 0 28px;
    font-size: 1.05rem;
    line-height: 1.8;
    color: #e5e7eb;
}

.hero-buttons {
    display: flex;
    gap: 12px;
}

.hero-btn {
    border: none;
    border-radius: 10px;
    padding: 13px 24px;
    background: #06b6d4;
    color: white;
    font-weight: 800;
    cursor: pointer;
    box-shadow: 0 10px 20px rgba(6, 182, 212, 0.25);
    transition: 0.2s;
}

.hero-btn.secondary {
    background: rgba(255, 255, 255, 0.12);
    border: 1px solid rgba(255, 255, 255, 0.42);
    box-shadow: none;
}

.hero-btn:hover {
    transform: translateY(-2px);
}

/* ========================= */
/* 운영 현황 요약 */
/* ========================= */

.summary-overlap {
    position: relative;
    z-index: 5;
    margin-top: -70px;
}

.summary-panel {
    background: rgba(255, 255, 255, 0.96);
    border: 1px solid #e2e8f0;
    border-radius: 22px;
    padding: 24px;
    box-shadow: 0 18px 36px rgba(15, 23, 42, 0.16);
}

.summary-panel-head {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 18px;
}

.summary-panel-title {
    font-size: 1.25rem;
    font-weight: 900;
    color: #0f172a;
}

.summary-panel-sub {
    font-size: 0.85rem;
    color: #64748b;
}

.summary-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 15px;
}

.summary-card {
    background: #ffffff;
    border: 1px solid #dbe4f0;
    border-radius: 16px;
    padding: 20px;
    box-shadow: 0 6px 18px rgba(15, 23, 42, 0.05);
}

.summary-card h4 {
    margin: 0 0 12px;
    color: #475569;
    font-size: 0.92rem;
}

.summary-card strong {
    display: block;
    font-size: 1.8rem;
    line-height: 1.1;
    margin-bottom: 10px;
    color: #0f172a;
}

.summary-card p {
    margin: 0;
    color: #64748b;
    font-size: 0.86rem;
}

.status-normal {
    color: #16a34a !important;
}

.status-warning {
    color: #f59e0b !important;
}

.status-danger {
    color: #dc2626 !important;
}

/* ========================= */
/* 환영 문구 */
/* ========================= */

.welcome-area {
    margin-top: 24px;
    margin-bottom: 18px;
}

.welcome-area h3 {
    margin: 0 0 6px;
    font-size: 1.1rem;
}

.welcome-area p {
    margin: 0;
    color: #475569;
}

.login-card {
    background: #ffffff;
    border: 1px solid #e2e8f0;
    border-radius: 18px;
    padding: 20px;
    box-shadow: 0 8px 20px rgba(15, 23, 42, 0.06);
}

.login-card button {
    border: none;
    border-radius: 8px;
    padding: 9px 14px;
    margin-right: 6px;
    background: #0f766e;
    color: white;
    cursor: pointer;
}

/* ========================= */
/* 날씨 + 빠른 실행 */
/* ========================= */

.dashboard-main-grid {
    display: grid;
    grid-template-columns: 1.15fr 0.85fr;
    gap: 22px;
    align-items: start;
    margin-top: 26px;
    margin-bottom: 28px;
}

.dashboard-card {
    background: #ffffff;
    border-radius: 22px;
    border: 1px solid #e2e8f0;
    box-shadow: 0 10px 22px rgba(15, 23, 42, 0.07);
    padding: 20px;
}

.dashboard-card-head {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 14px;
}

.dashboard-card-title {
    font-size: 19px;
    font-weight: 900;
    color: #0f172a;
}

.dashboard-card-sub {
    font-size: 12px;
    color: #64748b;
}

/* ========================= */
/* 날씨 카드 */
/* ========================= */

.weather-dashboard-layout {
    display: grid;
    grid-template-columns: 170px 1fr;
    gap: 12px;
    align-items: stretch;
}

.weather-dashboard-main {
    border-radius: 18px;
    padding: 16px 14px;
    background: linear-gradient(180deg, #ecfeff 0%, #f8fdff 100%);
    border: 1px solid #bae6fd;
    min-height: 150px;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
}

.weather-dashboard-city {
    font-size: 15px;
    font-weight: 800;
    color: #0f172a;
}

.weather-dashboard-condition {
    margin-top: 6px;
    font-size: 13px;
    font-weight: 700;
    color: #0369a1;
}

.weather-dashboard-big {
    font-size: 34px;
    font-weight: 900;
    color: #0f172a;
    line-height: 1;
    margin: 10px 0 4px;
}

.weather-dashboard-info {
    font-size: 11.5px;
    color: #64748b;
    line-height: 1.45;
}

.weather-dashboard-grid {
    display: grid;
    grid-template-columns: repeat(5, minmax(0, 1fr));
    gap: 8px;
}

.weather-dashboard-item {
    border-radius: 14px;
    padding: 11px 6px;
    background: linear-gradient(180deg, #ffffff 0%, #f8fafc 100%);
    border: 1px solid #e2e8f0;
    box-shadow: 0 6px 16px rgba(15, 23, 42, 0.04);
    min-height: 150px;
    display: flex;
    flex-direction: column;
    justify-content: center;
    gap: 7px;
    align-items: center;
    text-align: center;
}

.weather-dashboard-time {
    font-size: 12px;
    font-weight: 800;
    color: #334155;
}

.weather-dashboard-icon {
    font-size: 23px;
    line-height: 1;
}

.weather-dashboard-status {
    font-size: 12px;
    color: #475569;
    font-weight: 700;
}

.weather-dashboard-temp {
    font-size: 19px;
    font-weight: 900;
    color: #0f172a;
}

.weather-dashboard-empty {
    grid-column: 1 / -1;
    border-radius: 16px;
    padding: 24px;
    background: #ffffff;
    border: 1px dashed #93c5fd;
    color: #64748b;
    text-align: center;
}

/* ========================= */
/* 빠른 실행: 무조건 2열 2행 */
/* ========================= */

.force-quick-grid {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 12px;
    width: 100%;
}

.force-quick-card {
    min-width: 0;
    min-height: 112px;
    padding: 15px;
    border-radius: 15px;
    border: 1px solid #dbeafe;
    background: linear-gradient(180deg, #ffffff 0%, #f8fbff 100%);
    box-shadow: 0 6px 16px rgba(15, 23, 42, 0.04);
    cursor: pointer;
    transition: all 0.2s ease;

    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: flex-start;
}

.force-quick-card:hover {
    transform: translateY(-2px);
    border-color: #7dd3fc;
    box-shadow: 0 12px 20px rgba(14, 165, 233, 0.10);
}

.force-quick-icon {
    font-size: 20px;
    margin-bottom: 8px;
    line-height: 1;
}

.force-quick-title {
    font-size: 16px;
    font-weight: 900;
    color: #0f172a;
    margin-bottom: 6px;
    line-height: 1.3;
}

.force-quick-desc {
    font-size: 13px;
    line-height: 1.45;
    color: #64748b;
}

/* ========================= */
/* 작업 영역 */
/* ========================= */

#contentArea {
    margin-top: 28px;
    margin-bottom: 50px;
    padding: 28px;
    border: 1px solid #e2e8f0;
    border-radius: 22px;
    min-height: 180px;
    background: #fff;
    box-shadow: 0 10px 22px rgba(15, 23, 42, 0.07);
}

.panel-title {
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.panel-title h3 {
    margin-top: 0;
}

.fake-table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 15px;
    background: white;
    font-size: 14px;
}

.fake-table th,
.fake-table td {
    border-bottom: 1px solid #eee;
    padding: 10px;
    text-align: left;
}

.fake-table th {
    background: #f8fafc;
    color: #334155;
    font-weight: 800;
}

.fake-table button {
    border: none;
    border-radius: 8px;
    padding: 7px 11px;
    margin: 0 2px;
    background: #0f172a;
    color: white;
    cursor: pointer;
    font-size: 13px;
}

.badge {
    padding: 4px 8px;
    border-radius: 10px;
    font-size: 0.8rem;
}

.badge.green {
    background: #dcfce7;
    color: #166534;
}

.badge.yellow {
    background: #fef3c7;
    color: #92400e;
}

.badge.red {
    background: #fee2e2;
    color: #991b1b;
}

/* ========================= */
/* 반응형 */
/* ========================= */

@media (max-width: 1100px) {
    .dashboard-main-grid {
        grid-template-columns: 1fr;
    }

    .weather-dashboard-layout {
        grid-template-columns: 1fr;
    }

    .summary-grid {
        grid-template-columns: repeat(2, 1fr);
    }
}

@media (max-width: 700px) {
    .hero {
        min-height: 390px;
    }

    .hero h2 {
        font-size: 2rem;
    }

    .hero-buttons {
        flex-direction: column;
        align-items: flex-start;
    }

    .summary-grid,
    .weather-dashboard-grid,
    .force-quick-grid {
        grid-template-columns: 1fr;
    }

    .summary-overlap {
        margin-top: -40px;
    }
}
/* ========================= */
/* 1단계: KESCO 스타일 네이비 섹션 */
/* ========================= */

body {
    background: #020617;
}

.hero {
    min-height: 560px;
    background:
        linear-gradient(
            90deg,
            rgba(2, 6, 23, 0.96) 0%,
            rgba(15, 23, 42, 0.86) 52%,
            rgba(15, 23, 42, 0.55) 100%
        ),
        url('${pageContext.request.contextPath}/resources/img/solar-main.jpg') center/cover no-repeat;
}

.hero-badge {
    background: rgba(37, 99, 235, 0.16);
    border-color: rgba(147, 197, 253, 0.35);
    color: #bfdbfe;
}

.hero-btn {
    background: #2563eb;
    box-shadow: 0 12px 24px rgba(37, 99, 235, 0.28);
}

.hero-btn.secondary {
    background: rgba(15, 23, 42, 0.45);
    border: 1px solid rgba(148, 163, 184, 0.45);
}

.summary-panel {
    background: #0f172a;
    border-color: #1e293b;
    color: #e2e8f0;
}

.summary-panel-title,
.summary-card strong {
    color: #f8fafc;
}

.summary-panel-sub,
.summary-card h4,
.summary-card p {
    color: #94a3b8;
}

.summary-card {
    background: #111c31;
    border-color: #263449;
}

.facility-section {
    background: #020617;
    padding: 70px 0;
    color: #fff;
}

.facility-container {
    width: 1000px;
    max-width: calc(100% - 40px);
    margin: 0 auto;
}

.facility-container h2 {
    margin: 0 0 24px;
    font-size: 32px;
    font-weight: 900;
    color: #f8fafc;
}

.facility-grid {
    display: grid;
    grid-template-columns: 1.7fr 1fr;
    gap: 24px;
}

.facility-main-card {
    min-height: 300px;
    padding: 34px;
    border-radius: 14px;
    background: #0f2a50;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    border: 1px solid #1e3a5f;
}

.facility-label {
    font-weight: 800;
    color: #bfdbfe;
}

.facility-main-card h3 {
    margin: 14px 0;
    font-size: 26px;
    line-height: 1.55;
    color: #ffffff;
}

.facility-desc {
    color: #cbd5e1;
    line-height: 1.7;
}

.facility-main-card button {
    width: fit-content;
    border: none;
    background: transparent;
    color: #fff;
    font-weight: 900;
    cursor: pointer;
    font-size: 16px;
}

.facility-side-wrap {
    display: grid;
    gap: 24px;
}

.facility-side-card {
    min-height: 138px;
    padding: 30px;
    border-radius: 14px;
    cursor: pointer;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    transition: 0.2s;
}

.facility-side-card:hover {
    transform: translateY(-3px);
}

.facility-side-card h3 {
    margin: 0;
    font-size: 24px;
    color: #fff;
}

.facility-side-card span {
    align-self: flex-end;
    font-weight: 900;
    color: #dbeafe;
}

.facility-side-card.blue {
    background: #1d4ed8;
}

.facility-side-card.navy {
    background: #132f55;
    border: 1px solid #24466f;
}

#contentArea {
    background: #0f172a;
    border-color: #1e293b;
    color: #e2e8f0;
}

.fake-table {
    background: #0f172a;
}

.fake-table th {
    background: #111c31;
    color: #cbd5e1;
}

.fake-table td {
    color: #e2e8f0;
    border-bottom-color: #1e293b;
}

@media (max-width: 900px) {
    .facility-grid {
        grid-template-columns: 1fr;
    }
}
.main-guide-head {
    margin-bottom: 26px;
}

.main-guide-head span {
    display: inline-block;
    margin-bottom: 10px;
    color: #60a5fa;
    font-size: 13px;
    font-weight: 900;
    letter-spacing: 1px;
}

.main-guide-head h3 {
    margin: 0 0 10px;
    font-size: 28px;
    color: #f8fafc;
}

.main-guide-head p {
    margin: 0;
    color: #94a3b8;
    line-height: 1.7;
}

.main-guide-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 18px;
}

.main-guide-card {
    min-height: 180px;
    padding: 24px;
    border-radius: 16px;
    background: #111c31;
    border: 1px solid #263449;
    cursor: pointer;
    transition: 0.2s;
}

.main-guide-card:hover {
    transform: translateY(-4px);
    border-color: #3b82f6;
}

.main-guide-icon {
    width: 42px;
    height: 42px;
    margin-bottom: 18px;
    border-radius: 12px;
    background: #1d4ed8;
    color: #fff;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 22px;
    font-weight: 900;
}

.main-guide-card h4 {
    margin: 0 0 10px;
    color: #f8fafc;
    font-size: 19px;
}

.main-guide-card p {
    margin: 0;
    color: #94a3b8;
    line-height: 1.6;
    font-size: 14px;
}

@media (max-width: 900px) {
    .main-guide-grid {
        grid-template-columns: 1fr;
    }
}
/* ========================= */
/* KESCO 스타일 Header */
/* ========================= */

.site-header {
    position: relative;
    z-index: 100;
    background: #061526;
    color: #fff;
    border-bottom: 1px solid rgba(255,255,255,0.12);
}

.header-wrap {
    width: 1280px;
    max-width: calc(100% - 40px);
    margin: 0 auto;
}

.header-top {
    height: 70px;
    border-bottom: 1px solid rgba(255,255,255,0.12);
}

.header-top .header-wrap {
    height: 70px;
    display: flex;
    align-items: center;
    justify-content: space-between;
}

.logo {
    margin: 0;
}

.logo a {
    display: flex;
    align-items: center;
    gap: 10px;
    color: #fff;
    text-decoration: none;
    font-size: 24px;
    font-weight: 900;
}

.logo-mark {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 48px;
    height: 32px;
    border-radius: 8px;
    background: #0072ce;
    color: #fff;
    font-size: 14px;
}

.header-util {
    display: flex;
    align-items: center;
    gap: 18px;
    font-size: 14px;
}

.header-util a,
.header-util span {
    color: #cbd5e1;
    text-decoration: none;
    font-weight: 700;
}

.mobile-menu-btn {
    display: none;
    border: 0;
    background: transparent;
    color: white;
    font-size: 26px;
    cursor: pointer;
}

.header-nav {
    height: 52px;
    background: #061526;
}

.gnb {
    height: 52px;
    display: flex;
    align-items: center;
    justify-content: center;
    list-style: none;
    margin: 0;
    padding: 0;
}

.gnb > li {
    position: relative;
}

.gnb > li > a {
    display: flex;
    align-items: center;
    height: 52px;
    padding: 0 44px;
    color: #dbeafe;
    text-decoration: none;
    font-size: 17px;
    font-weight: 900;
}

.gnb > li > a:hover {
    background: #0066d9;
    color: #fff;
}

.sub-menu {
    display: none;
    position: absolute;
    top: 52px;
    left: 0;
    min-width: 180px;
    background: #0f2742;
    list-style: none;
    margin: 0;
    padding: 10px 0;
    border: 1px solid rgba(255,255,255,0.12);
}

.has-sub:hover .sub-menu {
    display: block;
}

.sub-menu a {
    display: block;
    padding: 12px 18px;
    color: #cbd5e1;
    text-decoration: none;
    font-weight: 700;
}

.sub-menu a:hover {
    background: #0066d9;
    color: white;
}

/* ========================= */
/* 본문 전체 컨텐츠화 */
/* ========================= */

.main-content-wrap {
    width: 1280px;
    max-width: calc(100% - 40px);
    margin: 0 auto;
}

#contentArea {
    width: 100%;
    margin: 0;
    padding: 70px 0;
    border: 0;
    border-radius: 0;
    background: transparent;
    box-shadow: none;
    color: #e2e8f0;
}

.content-section {
    padding: 40px;
    border-radius: 22px;
    background: #0f172a;
    border: 1px solid #1e293b;
}

.section-title span {
    color: #60a5fa;
    font-size: 13px;
    font-weight: 900;
}

.section-title h3 {
    margin: 8px 0 10px;
    color: #f8fafc;
    font-size: 30px;
}

.section-title p {
    margin: 0 0 24px;
    color: #94a3b8;
}

.empty-box {
    padding: 40px;
    border-radius: 16px;
    background: #111c31;
    border: 1px dashed #334155;
    color: #94a3b8;
    text-align: center;
}

/* 반응형 헤더 */
@media (max-width: 900px) {
    .mobile-menu-btn {
        display: block;
    }

    .header-nav {
        display: none;
        height: auto;
    }

    .header-nav.active {
        display: block;
    }

    .gnb {
        height: auto;
        flex-direction: column;
        align-items: stretch;
    }

    .gnb > li > a {
        height: 48px;
        padding: 0 20px;
        justify-content: flex-start;
    }

    .sub-menu {
        position: static;
        display: block;
        background: #081b30;
        border: 0;
        padding: 0;
    }

    .sub-menu a {
        padding-left: 36px;
    }

    .header-util a {
        display: none;
    }
}
</style>
</head>

<body
    data-context-path="${pageContext.request.contextPath}"
    data-login="${not empty sessionScope.member_id}"
    data-member-name="${sessionScope.member_name}"
    data-user-type="${sessionScope.user_type}">

<%@ include file="/WEB-INF/views/header.jsp" %>

<section class="hero">
    <div class="hero-content">
        <div class="hero-badge">Solar ESS Monitoring Platform</div>

        <h2>
            실시간 ESS 모니터링을<br>
            더 직관적이고 안정적으로
        </h2>

        <p>
            태양광 ESS 장비의 상태, 전압, 전류, SOC, 알림 이력을<br>
            한눈에 확인하고 빠르게 관리할 수 있는 통합 대시보드입니다.
        </p>

        <div class="hero-buttons">
            <button type="button" class="hero-btn" onclick="checkLogin(function(){ moveView('register', loadRegister); })">
                기기 등록
            </button>

            <button type="button" class="hero-btn secondary" onclick="checkLogin(function(){ moveView('deviceList', loadDeviceList); })">
                등록 기기 보기
            </button>
        </div>
    </div>
</section>

<section class="container summary-overlap">
    <div class="summary-panel">
        <div class="summary-panel-head">
            <div class="summary-panel-title">운영 현황 요약</div>
            <div class="summary-panel-sub">회원 대표 기기 기준</div>
        </div>

        <div class="summary-grid">
            <div class="summary-card">
                <h4>등록 기기</h4>
                <strong id="deviceCount">
                    <c:choose>
                        <c:when test="${empty deviceCount}">
                            0대
                        </c:when>
                        <c:otherwise>
                            ${deviceCount}대
                        </c:otherwise>
                    </c:choose>
                </strong>
                <p>ESS 장비 등록 후 표시</p>
            </div>

            <div class="summary-card">
                <h4>운영상태</h4>
                <strong class="status-normal">정상</strong>
                <p>최근 알림 기준</p>
            </div>

            <div class="summary-card">
                <h4>평균 SOC</h4>
                <strong>--%</strong>
                <p>모니터링 연동 후 표시</p>
            </div>

            <div class="summary-card">
                <h4>미확인 알림</h4>
                <strong class="status-warning">0건</strong>
                <p>알림 이력 연동 후 표시</p>
            </div>
        </div>
    </div>
</section>

<section class="facility-section">
    <div class="facility-container">
        <h2>시설관리</h2>

        <div class="facility-grid">
            <div class="facility-main-card">
                <div>
                    <p class="facility-label">통합관리 서비스</p>
                    <h3>
                        ESS 시설관리에 필요한 서비스를<br>
                        쉽게 찾아보세요!
                    </h3>
                    <p class="facility-desc">
                        등록부터 운영, 점검, 상세 모니터링까지 필요한 기능을 하나로 묶은
                        ESS 통합 관리 서비스를 경험해보세요.
                    </p>
                </div>

                <button type="button" onclick="checkLogin(function(){ moveView('register', loadRegister); })">
                    등록하기 ↗
                </button>
            </div>

            <div class="facility-side-wrap">
                <div class="facility-side-card blue"
                     onclick="checkLogin(function(){ moveView('deviceList', loadDeviceList); })">
                    <h3>ESS 관리</h3>
                    <span>바로가기 →</span>
                </div>

                <div class="facility-side-card navy"
                     onclick="checkLogin(function(){ moveView('deviceList', loadDeviceList); })">
                    <h3>상세 모니터링</h3>
                    <span>기기 선택 후 확인 →</span>
                </div>
            </div>
        </div>
    </div>
</section>
<%-- <section class="container welcome-area">
    <c:if test="${empty sessionScope.member_id}">
        <div class="login-card">
            <h3>👋 방문을 환영합니다</h3>
            <p>로그인하면 기기 등록, 모니터링, 알림 관리 기능을 사용할 수 있습니다.</p>
            <br>
            <button type="button" onclick="goLogin()">로그인</button>
            <button type="button" onclick="goJoin()">회원가입</button>
        </div>
    </c:if>

    <c:if test="${not empty sessionScope.member_id}">
        <h3>${sessionScope.member_name}님 환영합니다</h3>
        <p>현재 회원 유형: ${sessionScope.user_type}</p>
    </c:if>
</section> --%>

<%-- <section class="container dashboard-main-grid">

    <!-- 날씨 박스 -->
    <div class="dashboard-card weather-dashboard-card">
        <div class="dashboard-card-head">
            <div class="dashboard-card-title">
                ☀
                <c:choose>
                    <c:when test="${empty weatherList}">
                        내 지역 날씨 예보
                    </c:when>
                    <c:otherwise>
                        ${weatherList[0].city} 날씨 예보
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="dashboard-card-sub">
                회원 대표지역 기준 · 단기예보 API 연동
            </div>
        </div>

        <div class="weather-dashboard-layout">
            <div class="weather-dashboard-main">
                <c:choose>
                    <c:when test="${empty weatherList}">
                        <div>
                            <div class="weather-dashboard-city">내 지역</div>
                            <div class="weather-dashboard-condition">날씨 데이터 없음</div>
                            <div class="weather-dashboard-big">--℃</div>
                        </div>

                        <div class="weather-dashboard-info">
                            날씨 데이터가 조회되지 않았습니다.<br>
                            API 응답 또는 회원 대표지역을 확인하세요.
                        </div>
                    </c:when>

                    <c:otherwise>
                        <div>
                            <div class="weather-dashboard-city">${weatherList[0].city}</div>
                            <div class="weather-dashboard-condition">
                                ${weatherList[0].weatherIcon}
                                ${weatherList[0].skyStatus}
                            </div>
                            <div class="weather-dashboard-big">${weatherList[0].temperature}</div>
                        </div>

                        <div class="weather-dashboard-info">
                            현재 시간 이후 예보를 기준으로<br>
                            ESS 운전환경을 함께 확인합니다.
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="weather-dashboard-grid">
                <c:choose>
                    <c:when test="${empty weatherList}">
                        <div class="weather-dashboard-empty">
                            날씨 데이터가 없습니다.
                        </div>
                    </c:when>

                    <c:otherwise>
                        <c:forEach var="weather" items="${weatherList}">
                            <div class="weather-dashboard-item">
                                <div class="weather-dashboard-time">${weather.fcstTime}</div>
                                <div class="weather-dashboard-icon">${weather.weatherIcon}</div>
                                <div class="weather-dashboard-status">${weather.skyStatus}</div>
                                <div class="weather-dashboard-temp">${weather.temperature}</div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- 빠른 실행: 2열 2행 고정 -->
    <div class="dashboard-card quick-dashboard-card">
        <div class="dashboard-card-head">
            <div class="dashboard-card-title">빠른 실행</div>
            <div class="dashboard-card-sub">자주 사용하는 메뉴</div>
        </div>

        <div class="force-quick-grid">
            <div class="force-quick-card" id="btnDeviceList">
                <div class="force-quick-icon">🗂</div>
                <div class="force-quick-title">기기 목록</div>
                <div class="force-quick-desc">등록된 장비 목록과 상세 정보를 확인합니다.</div>
            </div>

            <div class="force-quick-card" id="btnMonitor">
                <div class="force-quick-icon">📊</div>
                <div class="force-quick-title">실시간 모니터링</div>
                <div class="force-quick-desc">SOC, 전압, 전류, 온도 데이터를 확인합니다.</div>
            </div>

            <div class="force-quick-card" id="btnAlert">
                <div class="force-quick-icon">🚨</div>
                <div class="force-quick-title">알림/이상 이력</div>
                <div class="force-quick-desc">이상 경고와 장애 발생 이력을 확인합니다.</div>
            </div>

            <div class="force-quick-card" id="btnMyPage">
                <div class="force-quick-icon">👤</div>
                <div class="force-quick-title">마이페이지</div>
                <div class="force-quick-desc">회원 정보와 등록 장비를 관리합니다.</div>
            </div>
        </div>
    </div>

</section> --%>

<div class="main-content-wrap">
    <div id="contentArea">
        <section class="content-section">
            <div class="main-guide-head">
                <span>ESS-M.S GUIDE</span>
                <h3>ESS 운영을 시작해보세요</h3>
                <p>
                    ESS 등록 후 관리 화면에서 기기 상태, 모니터링 정보,
                    날씨 기반 분석 결과를 확인할 수 있습니다.
                </p>
            </div>

            <div class="main-guide-grid">
                <div class="main-guide-card" onclick="checkLogin(function(){ moveView('register', loadRegister); })">
                    <div class="main-guide-icon">＋</div>
                    <h4>ESS 등록</h4>
                    <p>설치 위치와 장비 정보를 입력해 새로운 ESS를 등록합니다.</p>
                </div>

                <div class="main-guide-card" onclick="checkLogin(function(){ moveView('deviceList', loadDeviceList); })">
                    <div class="main-guide-icon">▣</div>
                    <h4>ESS 관리</h4>
                    <p>등록된 ESS 목록을 확인하고 상세 모니터링으로 이동합니다.</p>
                </div>

                <div class="main-guide-card" onclick="checkLogin(function(){ moveView('deviceList', loadDeviceList); })">
                    <div class="main-guide-icon">↗</div>
                    <h4>상세 모니터링</h4>
                    <p>기기별 상태와 날씨 기반 발전 영향 정보를 확인합니다.</p>
                </div>
            </div>
        </section>
    </div>
</div>

<script src="${pageContext.request.contextPath}/resources/js/main.js"></script>

<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>