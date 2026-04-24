<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
.service-card { padding: 10px; border: 1px solid #ccc; margin: 10px 0; cursor: pointer; }
#contentArea { margin-top: 20px; padding: 15px; border: 1px solid #999; min-height: 200px; }
</style>
</head>

<body>

<%@ include file="/WEB-INF/views/header.jsp" %>

<!-- ================= HERO ================= -->
<section class="hero">
    <div class="hero-content">
        <h2>환경과 사회를 위한 ESS 시스템입니다.</h2>
        <p>실시간 에너지 관리 플랫폼</p>
    </div>
</section>

<!-- ================= WEATHER ================= -->
<section class="weather-section container">
    <h3>☀️ 전국 날씨</h3>
    <div>
        서울 ☀️ 12°C
        부산 ☁️ 15°C
        대구 ☀️ 14°C
        광주 ⛅ 13°C
        제주 🌧️ 18°C
    </div>
</section>

<hr>

<!-- ================= LOGIN INFO ================= -->
<section class="container">

    <c:if test="${empty sessionScope.member_id}">
        <div class="service-card">
            <h3>👋 방문을 환영합니다</h3>
            <p>로그인하면 기기 등록 및 모니터링 기능을 사용할 수 있습니다.</p>
            <button onclick="goLogin()">로그인</button>
        </div>
    </c:if>

    <c:if test="${not empty sessionScope.member_id}">
        <h3>${sessionScope.member_name}님 환영합니다</h3>
        <a href="${pageContext.request.contextPath}/logout">로그아웃</a>
    </c:if>

</section>

<hr>

<!-- ================= MENU ================= -->
<section class="container">

    <div class="service-card" id="btnRegister">
        <h3>🔧 기기 등록</h3>
        <p>기기를 등록합니다</p>
    </div>

    <div class="service-card" id="btnMonitor">
        <h3>📊 모니터링</h3>
        <p>실시간 데이터를 확인합니다</p>
    </div>

</section>

<hr>

<!-- ================= CONTENT AREA ================= -->
<div class="container">
    <h3>작업 영역</h3>

    <div id="contentArea">
        기본 메인 화면입니다.
    </div>
</div>

<!-- ================= SCRIPT ================= -->
<script>

const ctx = "${pageContext.request.contextPath}";

/* 로그인 이동 */
function goLogin() {
    location.href = ctx + "/login_view";
}

/* 로그인 체크 */
function checkLogin(callback) {

    const isLogin = "${sessionScope.member_id}" !== "";

    if (!isLogin) {
        alert("로그인이 필요합니다");
        location.href = ctx + "/login_view";
        return;
    }

    callback();
}

/* 기기 등록 */
function loadRegister() {
    $.ajax({
        url: ctx + "/device/registerForm",
        type: "get",
        success: function(data) {
            $("#contentArea").html(data);
            $("#contentArea")[0].scrollIntoView({behavior:"smooth"});
        }
    });
}

/* 모니터링 */
function loadMonitor() {
    $.ajax({
        url: ctx + "/monitoring/list",
        type: "get",
        success: function(data) {
            $("#contentArea").html(data);
            $("#contentArea")[0].scrollIntoView({behavior:"smooth"});
        }
    });
}

/* 이벤트 바인딩 (실무 방식) */
$(document).on("click", "#btnRegister", function () {
    checkLogin(loadRegister);
});

$(document).on("click", "#btnMonitor", function () {
    checkLogin(loadMonitor);
});

</script>

</body>
</html>