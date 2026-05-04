/**
 * 현재 필터 상태(날짜, 그룹, 장비)를 서버에 전달할 파라미터 생성
 */
function getSummaryParams() {
    let selectedDate = $('#selectedDate').val();

    // 날짜 없으면 오늘
    if (!selectedDate) {
        selectedDate = new Date().toISOString().split('T')[0];
        $('#selectedDate').val(selectedDate);
    }

    const params = {
        selectedDate: selectedDate
    };

    const groupId = $('#groupSelect').val();
    const deviceId = $('#deviceSelect').val();

    // 값 있을 때만 전달
    if (groupId) params.groupId = groupId;
    if (deviceId) params.deviceId = deviceId;

    return params;
}


/**
 * 상단 카드 데이터 조회
 */
function loadSummary() {
    $.ajax({
        url: contextPath + '/dashboard/summary',
        type: 'GET',
        data: getSummaryParams(),
        dataType: 'json',

        success: function (data) {

            $('#totalDeviceCount').text(data.totalDeviceCount + '대');

            $('#deviceStatusCount').text(
                '정상 ' + data.normalDeviceCount +
                ' · 경고 ' + data.warningDeviceCount +
                ' · 오류 ' + data.errorDeviceCount +
                ' · 오프라인 ' + data.offlineDeviceCount
            );

            $('#todayGenerationKwh').text(
                Number(data.todayGenerationKwh).toFixed(1) + ' kWh'
            );

            $('#averageSoc').text(
                Number(data.averageSoc).toFixed(1) + '%'
            );

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
 * 그룹 선택 시 장비 목록 갱신
 */
function loadDeviceList(callback) {

    const groupId = $('#groupSelect').val();

    $.ajax({
        url: contextPath + '/dashboard/devices',
        type: 'GET',
        data: groupId ? { groupId: groupId } : {},

        success: function (devices) {
            const $deviceSelect = $('#deviceSelect');

            $deviceSelect.empty();
            $deviceSelect.append('<option value="">전체 장비</option>');

            devices.forEach(function (device) {
                $deviceSelect.append(
                    '<option value="' + device.deviceId + '">' +
                    device.deviceName +
                    '</option>'
                );
            });

            if (callback) callback();
        }
    });
}


/**
 * 초기 로딩 + 이벤트
 */
$(document).ready(function () {

    // 날짜 초기화
    let date = $('#selectedDate').val();
    if (!date) {
        $('#selectedDate').val(new Date().toISOString().split('T')[0]);
    }

    // 최초 조회
    loadSummary();


    // 날짜 변경
    $('#selectedDate').on('change', loadSummary);


    // 그룹 변경
    $('#groupSelect').on('change', function () {

        loadDeviceList(function () {
            $('#deviceSelect').val('');
            loadSummary();
        });
    });


    // 장비 변경
    $('#deviceSelect').on('change', loadSummary);


    // 조회 버튼
    $('#refreshBtn').on('click', loadSummary);

});