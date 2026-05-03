/**
 * 현재 필터 상태(날짜, 그룹, 장비)를 서버에 전달할 파라미터 생성
 */
function getSummaryParams() {
    let selectedDate = $('#selectedDate').val();

    // 날짜가 없으면 오늘 날짜로 자동 세팅
    if (!selectedDate) {
        selectedDate = new Date().toISOString().split('T')[0];
        $('#selectedDate').val(selectedDate);
    }

    const params = {
        selectedDate: selectedDate
    };

    // 그룹 선택값 (없으면 전체)
    const groupId = $('#groupSelect').val();

    // 장비 선택값 (없으면 전체)
    const deviceId = $('#deviceSelect').val();

    // 값이 있을 때만 서버로 전달 (빈값 방지)
    if (groupId) {
        params.groupId = groupId;
    }

    if (deviceId) {
        params.deviceId = deviceId;
    }

    return params;
}


/**
 * 상단 카드 4개 데이터 조회 및 화면 갱신
 */
function loadSummary() {
    $.ajax({
        url: contextPath + '/dashboard/summary',
        type: 'GET',
        data: getSummaryParams(),
        dataType: 'json',
        accepts: {
            json: 'application/json'
        },
        success: function (data) {

            // 총 장비 수
            $('#totalDeviceCount').text(data.totalDeviceCount + '대');

            // 장비 상태 요약
            $('#deviceStatusCount').text(
                '정상 ' + data.normalDeviceCount +
                ' · 경고 ' + data.warningDeviceCount +
                ' · 오류 ' + data.errorDeviceCount +
                ' · 오프라인 ' + data.offlineDeviceCount
            );

            // 오늘 예상 발전량
            $('#todayGenerationKwh').text(
                Number(data.todayGenerationKwh).toFixed(1) + ' kWh'
            );

            // 평균 SOC
            $('#averageSoc').text(
                Number(data.averageSoc).toFixed(1) + '%'
            );

            // 절감 금액
            $('#todaySavedCost').text(
                Number(data.todaySavedCost).toLocaleString() + '원'
            );
        },
        error: function () {
            alert('대시보드 요약 정보를 불러오지 못했습니다.');
        }
    });
}


/**
 * 그룹 선택 시 → 해당 그룹의 장비 목록 조회 후 셀렉트박스 갱신
 */
function loadDeviceList(callback) {

    const groupId = $('#groupSelect').val();

    $.ajax({
        url: contextPath + '/dashboard/devices',
        type: 'GET',

        // groupId 있을 때만 전달 (전체일 경우 제외)
        data: groupId ? { groupId: groupId } : {},

        success: function (devices) {
            const $deviceSelect = $('#deviceSelect');

            // 기존 옵션 제거
            $deviceSelect.empty();

            // 기본 옵션 (전체 장비)
            $deviceSelect.append('<option value="">전체 장비</option>');

            // 장비 목록 추가
            devices.forEach(function (device) {
                $deviceSelect.append(
                    '<option value="' + device.device_id + '">' +
                    device.device_name +
                    '</option>'
                );
            });

            // 필요 시 콜백 실행 (장비 목록 로딩 후 처리)
            if (callback) callback();
        }
    });
}


/**
 * 초기 로딩 및 이벤트 바인딩
 */
$(document).ready(function () {

    // 1️ 날짜 초기화 (없으면 오늘 날짜)
    let date = $('#selectedDate').val();

    if (!date) {
        const today = new Date().toISOString().split('T')[0];
        $('#selectedDate').val(today);
    }

    // 2️ 최초 카드 로딩
    loadSummary();


    /**
     * 날짜 변경 시 → 카드 갱신
     */
    $('#selectedDate').on('change', function () {
        loadSummary();
    });


    /**
     * 그룹 변경 시
     * 1. 장비 목록 갱신
     * 2. 장비 선택 초기화
     * 3. 카드 갱신
     */
    $('#groupSelect').on('change', function () {

        loadDeviceList(function () {
            $('#deviceSelect').val('');  // 장비 선택 초기화
            loadSummary();              // 카드 갱신
        });
    });


    /**
     * 장비 선택 시 → 카드 갱신
     */
    $('#deviceSelect').on('change', function () {
        loadSummary();
    });


    /**
     * 조회 버튼 클릭 시 → 카드 갱신
     */
    $('#refreshBtn').on('click', function () {
        loadSummary();
    });

});