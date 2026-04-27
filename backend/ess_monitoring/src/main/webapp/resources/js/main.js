/**
 * main.js
 */

// ===== 기본 값 =====
var body = document.body;

var ctx = body.getAttribute("data-context-path") || "";
var isLogin = body.getAttribute("data-login") === "true";
var memberName = body.getAttribute("data-member-name") || "";
var userType = body.getAttribute("data-user-type") || "";

function goLogin() {
    location.href = ctx + "/login_view";
}

function goJoin() {
    location.href = ctx + "/join_view";
}

function checkLogin(callback) {
    if (!isLogin) {
        alert("로그인이 필요합니다.");
        location.href = ctx + "/login_view";
        return;
    }

    callback();
}

function scrollContent() {
    var contentArea = document.getElementById("contentArea");

    if (contentArea) {
        contentArea.scrollIntoView({ behavior: "smooth" });
    }
}

function renderTemp(title, html) {
    $("#contentArea").html(
        "<div class='panel-title'><h3>" + title + "</h3></div>" + html
    );

    scrollContent();
}

function ajaxLoad(url, fallbackTitle, fallbackHtml) {
    $.ajax({
        url: ctx + url,
        type: "get",
        success: function(data) {
            $("#contentArea").html(data);
            scrollContent();
        },
        error: function() {
            renderTemp(fallbackTitle, fallbackHtml);
        }
    });
}

function loadRegister() {
    ajaxLoad(
        "/device/registerForm",
        "🔧 기기 등록",
        "<p>아직 <strong>/device/registerForm</strong> 화면이 없어서 임시 화면을 표시합니다.</p>" +
        "<table class='fake-table'>" +
        "<tr><th>입력 항목</th><th>설명</th></tr>" +
        "<tr><td>기기명</td><td>ESS 장비 이름</td></tr>" +
        "<tr><td>설치 주소</td><td>회원 주소 또는 실제 설치 위치</td></tr>" +
        "<tr><td>기기 상태</td><td>정상 / 점검 / 고장</td></tr>" +
        "</table>"
    );
}

function loadDeviceList() {
    renderTemp(
        "🗂 기기 목록",
        "<p>등록된 ESS 장비를 확인하는 영역입니다.</p>" +
        "<table class='fake-table'>" +
        "<tr><th>기기명</th><th>그룹</th><th>상태</th><th>최근 수신</th></tr>" +
        "<tr><td>등록된 기기 없음</td><td>-</td><td><span class='badge yellow'>대기</span></td><td>-</td></tr>" +
        "</table>"
    );
}

function loadMonitor() {
    ajaxLoad(
        "/monitoring/list",
        "📊 실시간 모니터링",
        "<p>아직 <strong>/monitoring/list</strong> 화면이 없어서 임시 화면을 표시합니다.</p>" +
        "<div class='summary-grid'>" +
        "<div class='summary-card'><h4>SOC</h4><strong>--%</strong></div>" +
        "<div class='summary-card'><h4>전압</h4><strong>-- V</strong></div>" +
        "<div class='summary-card'><h4>전류</h4><strong>-- A</strong></div>" +
        "<div class='summary-card'><h4>온도</h4><strong>-- ℃</strong></div>" +
        "</div>"
    );
}

function loadAlert() {
    renderTemp(
        "🚨 알림/이상 이력",
        "<p>온도 이상, 전압 이상, 통신 장애 등의 이력을 확인하는 영역입니다.</p>" +
        "<table class='fake-table'>" +
        "<tr><th>발생일시</th><th>기기</th><th>알림유형</th><th>상태</th></tr>" +
        "<tr><td>-</td><td>-</td><td>미확인 알림 없음</td><td><span class='badge green'>정상</span></td></tr>" +
        "</table>"
    );
}

function loadEnergy() {
    renderTemp(
        "⚡ 에너지 분석",
        "<p>충전량, 방전량, 전력 사용 패턴을 분석하는 영역입니다.</p>" +
        "<div class='summary-grid'>" +
        "<div class='summary-card'><h4>오늘 충전량</h4><strong>-- kWh</strong></div>" +
        "<div class='summary-card'><h4>오늘 방전량</h4><strong>-- kWh</strong></div>" +
        "<div class='summary-card'><h4>피크 사용량</h4><strong>-- kW</strong></div>" +
        "<div class='summary-card'><h4>절감 추정</h4><strong>-- 원</strong></div>" +
        "</div>"
    );
}

function loadBoard() {
    location.href = ctx + "/board_list";
}

function loadMyPage() {
    renderTemp(
        "👤 마이페이지",
        "<p>회원 정보와 등록된 ESS 장비를 관리하는 영역입니다.</p>" +
        "<table class='fake-table'>" +
        "<tr><th>항목</th><th>내용</th></tr>" +
        "<tr><td>회원명</td><td>" + memberName + "</td></tr>" +
        "<tr><td>회원유형</td><td>" + userType + "</td></tr>" +
        "</table>"
    );
}

function loadGuide() {
    renderTemp(
        "📘 이용 가이드",
        "<ol>" +
        "<li>회원가입 후 로그인합니다.</li>" +
        "<li>기기 등록 메뉴에서 ESS 장비를 등록합니다.</li>" +
        "<li>모니터링 메뉴에서 실시간 데이터를 확인합니다.</li>" +
        "<li>알림 메뉴에서 이상 상태를 확인합니다.</li>" +
        "</ol>"
    );
}

function showServiceIntro() {
    $("#contentArea").html(
        "<div class='panel-title'><h3>서비스 소개</h3></div>" +
        "<p>ESS-M.S는 ESS 장비 등록, 실시간 모니터링, 이상 알림, 에너지 분석을 제공하는 통합 관리 시스템입니다.</p>" +
        "<table class='fake-table'>" +
        "<tr><th>기능</th><th>설명</th></tr>" +
        "<tr><td>기기 등록</td><td>회원 계정 기준으로 ESS 장비를 등록하고 관리합니다.</td></tr>" +
        "<tr><td>실시간 모니터링</td><td>전압, 전류, 온도, SOC 데이터를 확인합니다.</td></tr>" +
        "<tr><td>알림 관리</td><td>이상 상태와 장애 이력을 확인합니다.</td></tr>" +
        "<tr><td>에너지 분석</td><td>충전량, 방전량, 사용량 데이터를 분석합니다.</td></tr>" +
        "</table>"
    );

    scrollContent();
}

$(document).on("click", "#btnRegister", function () {
    checkLogin(loadRegister);
});

$(document).on("click", "#btnDeviceList", function () {
    checkLogin(loadDeviceList);
});

$(document).on("click", "#btnMonitor", function () {
    checkLogin(loadMonitor);
});

$(document).on("click", "#btnAlert", function () {
    checkLogin(loadAlert);
});

$(document).on("click", "#btnEnergy", function () {
    checkLogin(loadEnergy);
});

$(document).on("click", "#btnBoard", function () {
    loadBoard();
});

$(document).on("click", "#btnMyPage", function () {
    checkLogin(loadMyPage);
});

$(document).on("click", "#btnGuide", function () {
    loadGuide();
});