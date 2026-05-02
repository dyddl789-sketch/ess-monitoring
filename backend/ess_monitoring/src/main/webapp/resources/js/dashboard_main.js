function getSummaryParams() {
    let selectedDate = $('#selectedDate').val();

    if (!selectedDate) {
        selectedDate = new Date().toISOString().split('T')[0];
        $('#selectedDate').val(selectedDate);
    }

    const params = {
        selectedDate: selectedDate
    };

    const groupId = $('#groupSelect').val();
    const deviceId = $('#deviceSelect').val();

    if (groupId) {
        params.groupId = groupId;
    }

    if (deviceId) {
        params.deviceId = deviceId;
    }

    return params;
}

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

$(document).ready(function () {

    let date = $('#selectedDate').val();

    if (!date) {
        const today = new Date().toISOString().split('T')[0];
        $('#selectedDate').val(today);
    }

    loadSummary();

    $('#selectedDate').on('change', function () {
        loadSummary();
    });

    $('#groupSelect').on('change', function () {
        // 그룹 변경 시 개별 장비 선택 초기화
        $('#deviceSelect').val('');

        loadSummary();
    });

    $('#deviceSelect').on('change', function () {
        loadSummary();
    });

    $('#refreshBtn').on('click', function () {
        loadSummary();
    });
});