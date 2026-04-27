<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ESS Main</title>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/main.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<style>
.container { width: 80%; margin: 0 auto; }
.hero {
    background: linear-gradient(135deg, #0f766e, #0f172a);
    color: white;
    padding: 60px 0;
    margin-bottom: 25px;
}
.hero-content { width: 80%; margin: 0 auto; }
.hero h2 { font-size: 2rem; margin-bottom: 10px; }
.summary-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 15px;
    margin: 25px 0;
}
.summary-card {
    background: white;
    border: 1px solid #ddd;
    border-radius: 12px;
    padding: 18px;
    box-shadow: 0 3px 10px rgba(0,0,0,0.06);
}
.summary-card h4 { margin: 0 0 10px; color: #555; }
.summary-card strong { font-size: 1.6rem; }
.status-normal { color: #16a34a; }
.status-warning { color: #f59e0b; }
.status-danger { color: #dc2626; }

.menu-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 15px;
    margin: 25px 0;
}
.service-card {
    background: #fff;
    padding: 20px;
    border: 1px solid #ddd;
    border-radius: 14px;
    cursor: pointer;
    transition: 0.2s;
}
.service-card:hover {
    transform: translateY(-3px);
    box-shadow: 0 5px 14px rgba(0,0,0,0.1);
}
.service-card h3 { margin-top: 0; }

#contentArea {
    margin-top: 20px;
    padding: 25px;
    border: 1px solid #ddd;
    border-radius: 14px;
    min-height: 260px;
    background: #fff;
}
.panel-title {
    display: flex;
    justify-content: space-between;
    align-items: center;
}
.fake-table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 15px;
}
.fake-table th, .fake-table td {
    border-bottom: 1px solid #eee;
    padding: 10px;
    text-align: left;
}
.badge {
    padding: 4px 8px;
    border-radius: 10px;
    font-size: 0.8rem;
}
.badge.green { background: #dcfce7; color: #166534; }
.badge.yellow { background: #fef3c7; color: #92400e; }
.badge.red { background: #fee2e2; color: #991b1b; }

@media (max-width: 900px) {
    .summary-grid, .menu-grid { grid-template-columns: repeat(2, 1fr); }
}
@media (max-width: 600px) {
    .summary-grid, .menu-grid { grid-template-columns: 1fr; }
}

.site-header {
    background: #ffffff;
    border-bottom: 1px solid #e5e7eb;
    position: sticky;
    top: 0;
    z-index: 1000;
}

.header-inner {
    display: flex;
    justify-content: space-between;
    align-items: center;
    height: 70px;
}

.logo {
    margin: 0;
    font-size: 1.6rem;
}

.logo a {
    text-decoration: none;
    color: #0f766e;
    font-weight: bold;
}

.header-menu {
    display: flex;
    gap: 24px;
    list-style: none;
    margin: 0;
    padding: 0;
    align-items: center;
}

.header-menu a {
    text-decoration: none;
    color: #111827;
    font-weight: 500;
}

.header-menu a:hover {
    color: #0f766e;
}

.user-label {
    color: #0f766e;
    font-weight: bold;
}

.weather-section {
    margin-top: 20px;
    margin-bottom: 25px;
}

.weather-summary {
    background: #f0fdfa;
    border: 1px solid #99f6e4;
    border-radius: 14px;
    padding: 16px 18px;
    display: flex;
    flex-wrap: wrap;
    gap: 12px;
}

.weather-item {
    background: white;
    border: 1px solid #ccfbf1;
    border-radius: 999px;
    padding: 8px 12px;
    font-size: 0.95rem;
    color: #0f172a;
    box-shadow: 0 2px 6px rgba(0,0,0,0.04);
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
        <h2>ESS 실시간 에너지 관리 플랫폼</h2>
        <p>기기 등록부터 배터리 상태, 발전량, 알림 이력까지 한 화면에서 관리합니다.</p>
    </div>
</section>

<section class="container">
    <c:if test="${empty sessionScope.member_id}">
        <div class="service-card">
            <h3>👋 방문을 환영합니다</h3>
            <p>로그인하면 기기 등록, 모니터링, 알림 관리 기능을 사용할 수 있습니다.</p>
            <button onclick="goLogin()">로그인</button>
            <button onclick="goJoin()">회원가입</button>
        </div>
    </c:if>

    <c:if test="${not empty sessionScope.member_id}">
        <h3>${sessionScope.member_name}님 환영합니다</h3>
        <p>현재 회원 유형: ${sessionScope.user_type}</p>
    </c:if>
</section>

<section class="weather-section container">
    <h3>
        ☀️
        <c:choose>
            <c:when test="${empty weatherList}">
                내 지역 날씨 예보
            </c:when>
            <c:otherwise>
                ${weatherList[0].city} 날씨 예보
            </c:otherwise>
        </c:choose>
    </h3>

    <div class="weather-summary">
        <c:choose>
            <c:when test="${empty weatherList}">
                <span>날씨 데이터가 없습니다.</span>
            </c:when>
            <c:otherwise>
                <c:forEach var="weather" items="${weatherList}">
                    <span class="weather-item">
                        ${weather.fcstTime}
                        ${weather.weatherIcon}
                        ${weather.skyStatus}
                        ${weather.temperature}
                    </span>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</section>

<section class="container">
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
</section>

<section class="container">
    <div class="menu-grid">
        <div class="service-card" id="btnRegister">
            <h3>🔧 기기 등록</h3>
            <p>ESS 장비와 그룹을 등록합니다.</p>
        </div>

        <div class="service-card" id="btnDeviceList">
            <h3>🗂 기기 목록</h3>
            <p>등록된 장비의 상태를 확인합니다.</p>
        </div>

        <div class="service-card" id="btnMonitor">
            <h3>📊 실시간 모니터링</h3>
            <p>SOC, 전압, 전류, 온도 데이터를 확인합니다.</p>
        </div>

        <div class="service-card" id="btnAlert">
            <h3>🚨 알림/이상 이력</h3>
            <p>장비 이상, 경고, 장애 이력을 확인합니다.</p>
        </div>

        <div class="service-card" id="btnEnergy">
            <h3>⚡ 에너지 분석</h3>
            <p>충전량, 방전량, 사용량을 분석합니다.</p>
        </div>

        <div class="service-card" id="btnBoard">
            <h3>💬 문의게시판</h3>
            <p>문의 및 유지보수 요청을 작성합니다.</p>
        </div>

        <div class="service-card" id="btnMyPage">
            <h3>👤 마이페이지</h3>
            <p>회원 정보와 등록 장비를 관리합니다.</p>
        </div>

        <div class="service-card" id="btnGuide">
            <h3>📘 이용 가이드</h3>
            <p>ESS-M.S 사용 방법을 확인합니다.</p>
        </div>
    </div>
</section>

<div class="container">
    <div id="contentArea">
        <div class="panel-title">
            <h3>ESS-M.S 작업 영역</h3>
        </div>
        <p>위 메뉴를 선택하면 이 영역만 변경됩니다.</p>

        <table class="fake-table">
            <tr>
                <th>구분</th>
                <th>설명</th>
                <th>상태</th>
            </tr>
            <tr>
                <td>기기 등록</td>
                <td>ESS 장비 등록 및 그룹 연결</td>
                <td><span class="badge yellow">로그인 필요</span></td>
            </tr>
            <tr>
                <td>모니터링</td>
                <td>실시간 센서 데이터 확인</td>
                <td><span class="badge green">준비됨</span></td>
            </tr>
            <tr>
                <td>알림</td>
                <td>이상 상태 및 장애 이력 확인</td>
                <td><span class="badge green">준비됨</span></td>
            </tr>
        </table>
    </div>
</div>

<script src="${pageContext.request.contextPath}/resources/js/main.js"></script>

<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>