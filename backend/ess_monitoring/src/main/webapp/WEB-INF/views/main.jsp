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

<body>

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
            <%-- 날씨 데이터가 없으면 기본 제목 표시 --%>
            <c:when test="${empty weatherList}">
                내 지역 날씨 예보
            </c:when>

            <%-- 날씨 데이터가 있으면 첫 번째 데이터의 city 표시 --%>
            <c:otherwise>
                ${weatherList[0].city} 날씨 예보
            </c:otherwise>
        </c:choose>
    </h3>

    <div class="weather-summary">
        <c:choose>
            <%-- Controller에서 weatherList가 비어 있으면 안내 문구 출력 --%>
            <c:when test="${empty weatherList}">
                <span>날씨 데이터가 없습니다.</span>
            </c:when>

            <%-- 날씨 데이터가 있으면 시간대별 예보 출력 --%>
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

<script>
const ctx = "${pageContext.request.contextPath}";

function goLogin() {
    location.href = ctx + "/login_view";
}

function goJoin() {
    location.href = ctx + "/join_view";
}

function checkLogin(callback) {
    const isLogin = "${sessionScope.member_id}" !== "";

    if (!isLogin) {
        alert("로그인이 필요합니다.");
        location.href = ctx + "/login_view";
        return;
    }

    callback();
}

function scrollContent() {
    $("#contentArea")[0].scrollIntoView({behavior:"smooth"});
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

// 기기 등록
function loadRegister() {
	renderTemp(
    		"🔧 ESS 기기 등록",
            "<form id='deviceForm'>" +

            "<table class='fake-table'>" +

            "<tr>" +
            "<th>항목</th>" +
            "<th>입력</th>" +
            "</tr>" +

            "<tr>" +
            "<td>기기 이름</td>" +
            "<td><input type='text' name='device_name' id='device_name' placeholder='예: SOLAR_BUSAN_ESS_01'></td>" +
            "</tr>" +

            "<tr>" +
            "<td>설치 위치</td>" +
            "<td><input type='text' name='location' id='location' placeholder='예: 부산 사상구'></td>" +
            "</tr>" +

            "<tr>" +
            "<td>장비 용량</td>" +
            "<td><input type='text' name='capacity_kw' id='capacity_kw' placeholder='예: 100'> kW</td>" +
            "</tr>" +

            "<tr>" +
            "<td>장비 종류</td>" +
            "<td>" +
            "<select name='device_type' id='device_type'>" +
            "<option value=''>선택</option>" +
            "<option value='태양광ESS'>태양광ESS</option>" +
            "<option value='배터리'>배터리</option>" +
            "<option value='인버터'>인버터</option>" +
            "<option value='PCS'>PCS</option>" +
            "<option value='BMS'>BMS</option>" +
            "</select>" +
            "</td>" +
            "</tr>" +

            "<tr>" +
            "<td>현재 상태</td>" +
            "<td>" +
            "<select name='status' id='status'>" +
            "<option value='정상'>정상</option>" +
            "<option value='점검'>점검</option>" +
            "<option value='오류'>오류</option>" +
            "</select>" +
            "</td>" +
            "</tr>" +

            "<tr>" +
            "<td>설치 날짜</td>" +
            "<td><input type='date' name='install_date' id='install_date'></td>" +
            "</tr>" +

            "<tr>" +
            "<td colspan='2'>" +
            "<button type='button' onclick='fn_device_register()'>등록</button> " +
            "<button type='button' onclick='$(\"#deviceForm\")[0].reset()'>초기화</button>" +
            "</td>" +
            "</tr>" +

            "</table>" +
            "</form>"
    );
}

function fn_device_register() {
    console.log("@# fn_device_register() 실행");

    var device_name = $("#device_name").val();
    var location = $("#location").val();
    var capacity_kw = $("#capacity_kw").val();
    var device_type = $("#device_type").val();
    var status = $("#status").val();
    var install_date = $("#install_date").val();

    console.log("@# device_name =>", device_name);
    console.log("@# location =>", location);
    console.log("@# capacity_kw =>", capacity_kw);
    console.log("@# device_type =>", device_type);
    console.log("@# status =>", status);
    console.log("@# install_date =>", install_date);

    if (device_name == "") {
        alert("기기 이름을 입력하세요.");
        $("#device_name").focus();
        return;
    }

    if (capacity_kw == "") {
        alert("장비 용량을 입력하세요.");
        $("#capacity_kw").focus();
        return;
    }

    if (device_type == "") {
        alert("장비 종류를 선택하세요.");
        $("#device_type").focus();
        return;
    }

    var formData = $("#deviceForm").serialize();
    console.log("@# formData =>", formData);

    $.ajax({
        type: "post",
        url: ctx + "/device_register_ajax",
        data: formData,
        success: function(result) {
            console.log("@# result =>", result);

            if (result == "success") {
                alert("기기 등록이 완료되었습니다.");

                $("#deviceForm")[0].reset();

                var countText = $("#deviceCount").text();
                var count = parseInt(countText.replace("대", ""));

                if (isNaN(count)) {
                    count = 0;
                }

                $("#deviceCount").text((count + 1) + "대");
                
                //등록 후 바로 기기 목록으로 이동
                loadDeviceList();

            } else if (result == "login_required") {
                alert("로그인이 필요합니다.");
                location.href = ctx + "/login_view";

            } else {
                alert("기기 등록에 실패했습니다.");
            }
        },
        error: function(xhr, status, error) {
            console.log("@# xhr =>", xhr);
            console.log("@# status =>", status);
            console.log("@# error =>", error);
            alert("서버 오류가 발생했습니다.");
        }
    });
    
    
}

function loadDeviceList() {
    console.log("@# loadDeviceList() 실행");

    $.ajax({
        url: ctx + "/device_list_ajax",
        type: "get",
        dataType : "json",
        success: function(list) {
            console.log("@# device list =>", list);

            var html = "";

            html += "<p>등록된 ESS 장비를 확인하는 영역입니다.</p>";

            html += "<table class='fake-table'>";
            html += "<tr>";
            html += "<th>번호</th>";
            html += "<th>기기명</th>";
            html += "<th>위치</th>";
//             html += "<th>용량</th>";
//             html += "<th>종류</th>";
//             html += "<th>상태</th>";
//             html += "<th>설치일</th>";
            html += "<th>관리</th>";
            html += "</tr>";
			
            
            
            if (list == null || list.length == 0) {
                html += "<tr>";
                html += "<td colspan='8'>등록된 기기가 없습니다.</td>";
                html += "</tr>";
            } else {
                for (var i = 0; i < list.length; i++) {
                    var device = list[i];

                    var badgeClass = "green";

                    if (device.status == "점검") {
                        badgeClass = "yellow";
                    } else if (device.status == "오류") {
                        badgeClass = "red";
                    }

                    html += "<tr>";
                    html += "<td>" + device.device_id + "</td>";
                    html += "<td>" + device.device_name + "</td>";
                    html += "<td>" + device.location + "</td>";
//                     html += "<td>" + device.capacity_kw + " kW</td>";
//                     html += "<td>" + device.device_type + "</td>";
//                     html += "<td><span class='badge " + badgeClass + "'>" + device.status + "</span></td>";
//                     html += "<td>" + device.install_date + "</td>";
                    html += "<td>";
                    // 삭제 버튼
                    // 클릭하면 JavaScript deleteDevice() 함수로 device_id를 넘긴다.
                    html += "<button type='button' onclick='deleteDevice(" + device.device_id + ")'>삭제</button>";
                    //상세보기 버튼
                    // 클릭하면 JavaScript loadDeviceDetail() 함수로 device_id를 넘긴다.

                    html += "<button type='button' onclick='detailDevice(" + device.device_id + ")'>상세보기</button>";
                    html += "</td>";
                    html += "</tr>";
                }
            }

            html += "</table>";

            renderTemp("🗂 기기 목록", html);
        },
        error: function(xhr, status, error) {
            console.log("@# xhr =>", xhr);
            console.log("@# status =>", status);
            console.log("@# error =>", error);

            renderTemp(
                "🗂 기기 목록",
                "<p>기기 목록을 불러오는 중 오류가 발생했습니다.</p>"
            );
        }
    });
}
// 기기 삭제
function deleteDevice(device_id) {
    console.log("@# deleteDevice() 실행");

    // 삭제 대상 기기 번호 확인
    console.log("@# device_id =>", device_id);

    /*
     * 삭제는 되돌리기 어려운 작업이므로 confirm으로 한 번 더 확인한다.
     * 취소를 누르면 함수 종료
     */
    if (!confirm("해당 기기를 삭제하시겠습니까?")) {
        return;
    }

    /*
     * AJAX로 서버에 삭제 요청
     *
     * 요청 주소:
     * POST /device_delete_ajax
     *
     * 보내는 데이터:
     * device_id=삭제할기기번호
     */
    $.ajax({
        url: ctx + "/device_delete_ajax",
        type: "post",
        data: {
            device_id: device_id
        },

        /*
         * 서버 응답이 정상적으로 왔을 때 실행
         *
         * result 값 예상:
         * success        = 삭제 성공
         * login_required = 로그인 필요
         * fail           = 삭제 실패
         */
        success: function(result) {
            console.log("@# delete result =>", result);

            if (result == "success") {
                alert("기기가 삭제되었습니다.");

                /*
                 * 화면 상단의 등록 기기 수를 1 감소시킨다.
                 * 예: 3대 -> 2대
                 */
                var countText = $("#deviceCount").text();

                // "3대"에서 "대"를 제거하고 숫자로 변환
                var count = parseInt(countText.replace("대", ""));

                // 숫자로 변환 실패 시 0으로 처리
                if (isNaN(count)) {
                    count = 0;
                }

                // 0보다 클 때만 1 감소
                if (count > 0) {
                    $("#deviceCount").text((count - 1) + "대");
                } else {
                    $("#deviceCount").text("0대");
                }

                /*
                 * 삭제 후 목록을 다시 불러온다.
                 * DB에서 삭제된 최신 목록으로 화면 갱신
                 */
                loadDeviceList();

            } else if (result == "login_required") {
                alert("로그인이 필요합니다.");

                // 로그인 페이지로 이동
                location.href = ctx + "/login_view";

            } else {
                alert("삭제에 실패했습니다.");
            }
        },

        /*
         * 서버 오류, 매핑 오류, 500 오류 등이 발생하면 실행
         */
        error: function(xhr, status, error) {
            console.log("@# xhr.status =>", xhr.status);
            console.log("@# xhr.responseText =>", xhr.responseText);
            console.log("@# status =>", status);
            console.log("@# error =>", error);

            alert("삭제 중 서버 오류가 발생했습니다.");
        }
    });
}


//목록에서 상세보기 클릭 시 작동 
function detailDevice(device_id){
	console.log("@# detailDevice()");
	console.log("@# device_id"+device_id);
	
	$.ajax({
		
		// 컨트롤러의 Ajax 상세조회 주소
		url : ctx + "/device_detail_ajax",
		// 상세조회는 데이터를 가져오는 것이므로 get 사용
        type: "get",
        // 서버로 보낼 데이터, Controller에서 @RequestParam("device_id")로 받는다.
        data: {
            device_id: device_id
        },
     	// 서버에서 JSON 형태로 응답받는다.
        dataType: "json",
     	// Ajax 요청 성공 시 실행
        // device에는 서버가 보내준 기기 상세정보 1건이 들어온다.
        success: function(device) {
            console.log("@# device detail =>", device);

            // 조회 결과가 없을 경우
            if (device == null) {
                renderTemp(
                    "🗂 기기 상세",
                    "<p>기기 상세 정보를 찾을 수 없습니다.</p>"
                );
                return;
            }
        // 화면에 출력할 html 문자열 생성
        var html = "";
        html += "<p>선택한 ESS 장비의 상세 정보를 확인합니다.</p>";

        html += "<table class='fake-table'>";

        // 테이블 제목 행
        html += "<tr>";
        html += "<th>항목</th>";
        html += "<th>내용</th>";
        html += "</tr>";

        // 기기 번호
        html += "<tr>";
        html += "<td>기기 번호</td>";
        html += "<td>" + device.device_id + "</td>";
        html += "</tr>";

        // 기기명
        html += "<tr>";
        html += "<td>기기명</td>";
        html += "<td>" + device.device_name + "</td>";
        html += "</tr>";

        // 위치
        html += "<tr>";
        html += "<td>위치</td>";
        html += "<td>" + device.location + "</td>";
        html += "</tr>";

        // 용량
        html += "<tr>";
        html += "<td>용량</td>";
        html += "<td>" + device.capacity_kw + " kW</td>";
        html += "</tr>";

        // 종류
        html += "<tr>";
        html += "<td>종류</td>";
        html += "<td>" + device.device_type + "</td>";
        html += "</tr>";

        // 상태
        html += "<tr>";
        html += "<td>상태</td>";
        html += "<td>" + device.status + "</span></td>";
        html += "</tr>";

        // 설치일
        html += "<tr>";
        html += "<td>설치일</td>";
        html += "<td>" + device.install_date + "</td>";
        html += "</tr>";

        html += "</table>";

        // 버튼 영역
        html += "<div style='margin-top: 15px;'>";

        // 다시 Ajax로 기기 목록을 불러온다.
        html += "<button type='button' onclick='loadDeviceList()'>목록으로</button> ";

        // 다음 단계에서 만들 실시간 모니터링 상세 함수
		html += "<button type='button' onclick='loadMonitoringDetail(" + device.device_id + ")'>실시간 모니터링 보기</button>";
        html += "</div>";

        // renderTemp()를 이용해서 메인 화면의 내용 영역을 교체한다.
        renderTemp("🗂 기기 상세", html);
    },

    // Ajax 요청 실패 시 실행
    error: function(xhr, status, error) {
        console.log("@# xhr =>", xhr);
        console.log("@# status =>", status);
        console.log("@# error =>", error);

        renderTemp(
            "🗂 기기 상세",
            "<p>기기 상세 정보를 불러오는 중 오류가 발생했습니다.</p>"
        );
    }
  });
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
        "<tr><td>회원명</td><td>${sessionScope.member_name}</td></tr>" +
        "<tr><td>회원유형</td><td>${sessionScope.user_type}</td></tr>" +
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

    $("#contentArea")[0].scrollIntoView({behavior: "smooth"});
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
</script>

</body>
</html>