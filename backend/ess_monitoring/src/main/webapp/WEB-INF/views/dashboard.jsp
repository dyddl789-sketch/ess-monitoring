<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/main.css">
<meta charset="UTF-8">
<title>ESS Dashboard</title>
</head>
<body>

<%@ include file="/WEB-INF/views/header.jsp" %>

<!-- 🔥 DASHBOARD TITLE -->
<section class="dashboard-title container">
    <h2>⚡ ESS 모니터링 대시보드</h2>
    <p>${sessionScope.member_name}님의 ESS 장비 상태를 확인하세요</p>
</section>

<!-- 🔥 SUMMARY CARD -->
<section class="summary container">

    <div class="card">
        <h3>등록 장비</h3>
        <p>3대</p>
    </div>

    <div class="card">
        <h3>정상 상태</h3>
        <p>2대</p>
    </div>

    <div class="card">
        <h3>경고</h3>
        <p>1대</p>
    </div>

</section>

<!-- 🔥 DEVICE LIST -->
<section class="device-list container">

    <h3>📊 ESS 장비 목록</h3>

    <table class="table">

        <thead>
            <tr>
                <th>장비명</th>
                <th>위치</th>
                <th>용량(kW)</th>
                <th>상태</th>
                <th>설치일</th>
            </tr>
        </thead>

        <tbody>

            <!-- 예시 데이터 (나중에 DB로 변경) -->
            <tr>
                <td>ESS-001</td>
                <td>서울 공장</td>
                <td>100</td>
                <td>정상</td>
                <td>2024-01-10</td>
            </tr>

            <tr>
                <td>ESS-002</td>
                <td>부산 창고</td>
                <td>80</td>
                <td>경고</td>
                <td>2024-02-15</td>
            </tr>

        </tbody>

    </table>

</section>

<!-- 🔥 MONITORING SECTION -->
<section class="monitoring container">

    <h3>📈 실시간 모니터링</h3>

    <div class="monitor-grid">

        <div class="monitor-box">
            <h4>전압</h4>
            <p>220 V</p>
        </div>

        <div class="monitor-box">
            <h4>전류</h4>
            <p>15 A</p>
        </div>

        <div class="monitor-box">
            <h4>SOC</h4>
            <p>78 %</p>
        </div>

        <div class="monitor-box">
            <h4>출력</h4>
            <p>3.2 kW</p>
        </div>

    </div>

</section>

<!-- 🔥 ENERGY LOG -->
<section class="energy container">

    <h3>⚡ 에너지 사용량</h3>

    <table class="table">

        <thead>
            <tr>
                <th>날짜</th>
                <th>일간(kWh)</th>
                <th>월간(kWh)</th>
                <th>비용(원)</th>
            </tr>
        </thead>

        <tbody>

            <tr>
                <td>2026-04-22</td>
                <td>120</td>
                <td>3200</td>
                <td>45,000</td>
            </tr>

            <tr>
                <td>2026-04-21</td>
                <td>110</td>
                <td>3080</td>
                <td>42,000</td>
            </tr>

        </tbody>

    </table>

</section>

<!-- 🔥 ALERT -->
<section class="alert container">

    <h3>🚨 알림</h3>

    <ul>
        <li>⚠ ESS-002 과전류 경고 발생</li>
        <li>✔ ESS-001 정상 상태 유지</li>
    </ul>

</section>

</body>
</html>