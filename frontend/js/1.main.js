
    // 페이지 로드 시 실행
    window.onload = function() {
        checkLoginStatus();
    };

    function checkLoginStatus() {
        const isLoggedIn = localStorage.getItem('isLoggedIn'); // 로그인 상태 확인
        const authMenu = document.getElementById('auth-menu');

        if (isLoggedIn === 'true') {
            const userName = localStorage.getItem('userName') || '사용자';
            // 로그인 상태일 때: '님' 표기 및 로그아웃 버튼 표시
            authMenu.innerHTML = `
                <span style="margin-right:15px; color:#333; font-weight:bold;">${userName}님</span>
                <a href="javascript:void(0)" class="login-btn" style="background:#6c757d;" onclick="handleLogout()">로그아웃</a>
            `;
        }
    }

    function handleLogout() {
        if(confirm("로그아웃 하시겠습니까?")) {
            localStorage.removeItem('isLoggedIn');
            localStorage.removeItem('userName');
            alert("로그아웃 되었습니다.");
            location.reload(); // 페이지 새로고침하여 메뉴 갱신
        }
    }

    // 기존에 만든 로그인 창 열기 함수
    function openLoginWindow() {
        const width = 450; const height = 620;
        const left = (window.screen.width / 2) - (width / 2);
        const top = (window.screen.height / 2) - (height / 2);
        window.open('4.login.html', 'ESS_Login', `width=${width}, height=${height}, left=${left}, top=${top}, resizable=no, scrollbars=no`);
    }
