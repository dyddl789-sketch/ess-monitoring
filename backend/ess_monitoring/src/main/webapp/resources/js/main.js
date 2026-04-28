const ctx = document.body.dataset.contextPath || "";
const isLogin = document.body.dataset.login === "true";
const memberName = document.body.dataset.memberName || "";
const userType = document.body.dataset.userType || "";

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
    const contentArea = $("#contentArea")[0];

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

    const deviceName = $("#device_name").val();
    const location = $("#location").val();
    const capacityKw = $("#capacity_kw").val();
    const deviceType = $("#device_type").val();
    const status = $("#status").val();
    const installDate = $("#install_date").val();

    console.log("@# device_name =>", deviceName);
    console.log("@# location =>", location);
    console.log("@# capacity_kw =>", capacityKw);
    console.log("@# device_type =>", deviceType);
    console.log("@# status =>", status);
    console.log("@# install_date =>", installDate);

    if (deviceName === "") {
        alert("기기 이름을 입력하세요.");
        $("#device_name").focus();
        return;
    }

    if (capacityKw === "") {
        alert("장비 용량을 입력하세요.");
        $("#capacity_kw").focus();
        return;
    }

    if (deviceType === "") {
        alert("장비 종류를 선택하세요.");
        $("#device_type").focus();
        return;
    }

    const formData = $("#deviceForm").serialize();

    console.log("@# formData =>", formData);

    $.ajax({
        type: "post",
        url: ctx + "/device_register_ajax",
        data: formData,
        success: function(result) {
            console.log("@# result =>", result);

            if (result === "success") {
                alert("기기 등록이 완료되었습니다.");

                $("#deviceForm")[0].reset();

                let countText = $("#deviceCount").text();
                let count = parseInt(countText.replace("대", "").trim(), 10);

                if (isNaN(count)) {
                    count = 0;
                }

                $("#deviceCount").text((count + 1) + "대");

                // 등록 후 바로 기기 목록으로 이동
                loadDeviceList();

            } else if (result === "login_required") {
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
        dataType: "json",
        success: function(list) {
            console.log("@# device list =>", list);

            let html = "";

            html += "<p>등록된 ESS 장비를 확인하는 영역입니다.</p>";

            html += "<table class='fake-table'>";
            html += "<tr>";
            html += "<th>번호</th>";
            html += "<th>기기명</th>";
            html += "<th>위치</th>";
            html += "<th>관리</th>";
            html += "</tr>";

            if (list == null || list.length === 0) {
                html += "<tr>";
                html += "<td colspan='4'>등록된 기기가 없습니다.</td>";
                html += "</tr>";
            } else {
                for (let i = 0; i < list.length; i++) {
                    const device = list[i];

                    let badgeClass = "green";

                    if (device.status === "점검") {
                        badgeClass = "yellow";
                    } else if (device.status === "오류") {
                        badgeClass = "red";
                    }

                    html += "<tr>";
                    html += "<td>" + device.device_id + "</td>";
                    html += "<td>" + device.device_name + "</td>";
                    html += "<td>" + device.location + "</td>";
                    html += "<td>";
                    html += "<button type='button' onclick='deleteDevice(" + device.device_id + ")'>삭제</button> ";
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
    console.log("@# device_id =>", device_id);

    if (!confirm("해당 기기를 삭제하시겠습니까?")) {
        return;
    }

    $.ajax({
        url: ctx + "/device_delete_ajax",
        type: "post",
        data: {
            device_id: device_id
        },
        success: function(result) {
            console.log("@# delete result =>", result);

            if (result === "success") {
                alert("기기가 삭제되었습니다.");

                let countText = $("#deviceCount").text();
                let count = parseInt(countText.replace("대", "").trim(), 10);

                if (isNaN(count)) {
                    count = 0;
                }

                if (count > 0) {
                    $("#deviceCount").text((count - 1) + "대");
                } else {
                    $("#deviceCount").text("0대");
                }

                loadDeviceList();

            } else if (result === "login_required") {
                alert("로그인이 필요합니다.");
                location.href = ctx + "/login_view";

            } else {
                alert("삭제에 실패했습니다.");
            }
        },
        error: function(xhr, status, error) {
            console.log("@# xhr.status =>", xhr.status);
            console.log("@# xhr.responseText =>", xhr.responseText);
            console.log("@# status =>", status);
            console.log("@# error =>", error);

            alert("삭제 중 서버 오류가 발생했습니다.");
        }
    });
}

// 목록에서 상세보기 클릭 시 작동
function detailDevice(device_id) {
    console.log("@# detailDevice()");
    console.log("@# device_id =>", device_id);

    $.ajax({
        url: ctx + "/device_detail_ajax",
        type: "get",
        data: {
            device_id: device_id
        },
        dataType: "json",
        success: function(device) {
            console.log("@# device detail =>", device);

            if (device == null) {
                renderTemp(
                    "🗂 기기 상세",
                    "<p>기기 상세 정보를 찾을 수 없습니다.</p>"
                );
                return;
            }

            let html = "";

            html += "<p>선택한 ESS 장비의 상세 정보를 확인합니다.</p>";

            html += "<table class='fake-table'>";

            html += "<tr>";
            html += "<th>항목</th>";
            html += "<th>내용</th>";
            html += "</tr>";

            html += "<tr>";
            html += "<td>기기 번호</td>";
            html += "<td>" + device.device_id + "</td>";
            html += "</tr>";

            html += "<tr>";
            html += "<td>기기명</td>";
            html += "<td>" + device.device_name + "</td>";
            html += "</tr>";

            html += "<tr>";
            html += "<td>위치</td>";
            html += "<td>" + device.location + "</td>";
            html += "</tr>";

            html += "<tr>";
            html += "<td>용량</td>";
            html += "<td>" + device.capacity_kw + " kW</td>";
            html += "</tr>";

            html += "<tr>";
            html += "<td>종류</td>";
            html += "<td>" + device.device_type + "</td>";
            html += "</tr>";

            html += "<tr>";
            html += "<td>상태</td>";
            html += "<td>" + device.status + "</td>";
            html += "</tr>";

            html += "<tr>";
            html += "<td>설치일</td>";
            html += "<td>" + device.install_date + "</td>";
            html += "</tr>";

            html += "</table>";

            html += "<div style='margin-top: 15px;'>";
            html += "<button type='button' onclick='loadDeviceList()'>목록으로</button> ";
            html += "<button type='button' onclick='loadMonitoringDetail(" + device.device_id + ")'>실시간 모니터링 보기</button>";
            html += "</div>";

            renderTemp("🗂 기기 상세", html);
        },
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

function loadMonitoringDetail(device_id) {
    renderTemp(
        "📊 실시간 모니터링",
        "<p>선택한 기기 번호: <strong>" + device_id + "</strong></p>" +
        "<div class='summary-grid'>" +
        "<div class='summary-card'><h4>SOC</h4><strong>--%</strong></div>" +
        "<div class='summary-card'><h4>전압</h4><strong>-- V</strong></div>" +
        "<div class='summary-card'><h4>전류</h4><strong>-- A</strong></div>" +
        "<div class='summary-card'><h4>온도</h4><strong>-- ℃</strong></div>" +
        "</div>"
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

$(document).on("click", "#btnRegister", function() {
    checkLogin(loadRegister);
});

$(document).on("click", "#btnDeviceList", function() {
    checkLogin(loadDeviceList);
});

$(document).on("click", "#btnMonitor", function() {
    checkLogin(loadMonitor);
});

$(document).on("click", "#btnAlert", function() {
    checkLogin(loadAlert);
});

$(document).on("click", "#btnEnergy", function() {
    checkLogin(loadEnergy);
});

$(document).on("click", "#btnBoard", function() {
    loadBoard();
});

$(document).on("click", "#btnMyPage", function() {
    checkLogin(loadMyPage);
});

$(document).on("click", "#btnGuide", function() {
    loadGuide();
});