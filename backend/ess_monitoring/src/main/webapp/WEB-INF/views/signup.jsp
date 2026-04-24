<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입 - ESS-M.S</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/main.css">
    <style>
        /* 회원가입 페이지 전용 스타일 */
        .signup-page-bg {
            background-color: #f4f7f9;
            padding: 60px 0;
            min-height: calc(100vh - 70px); /* 헤더 제외 높이 */
        }
        .signup-container-wide {
            max-width: 600px;
            margin: 0 auto;
            background: #fff;
            padding: 50px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.08);
        }
        .signup-header {
            text-align: center;
            margin-bottom: 40px;
        }
        .signup-header h2 {
            font-size: 2rem;
            color: #2c3e50;
        }
    </style>
</head>
<body>

<%@ include file="/WEB-INF/views/header.jsp" %>

    <main class="signup-page-bg">
        <div class="signup-container-wide">
            <div class="signup-header">
                <h2>회원가입</h2>
                <p>ESS-M.S의 스마트한 에너지 관리를 시작해보세요.</p>
            </div>

            <form action="#" method="post">
                <div class="login-type-tabs" style="margin-bottom: 30px;">
                    <button type="button" class="tab-btn active" onclick="selectType('user')">개인 회원가입</button>
                    <button type="button" class="tab-btn" onclick="selectType('business')">기업 회원가입</button>
                </div>

                <div class="form-group">
                    <label>아이디</label>
                    <input type="text" placeholder="아이디를 입력하세요" required>
                </div>
                
                <div class="form-group">
                    <label>비밀번호</label>
                    <input type="password" placeholder="영문, 숫자 포함 8자 이상" required>
                </div>

                <div class="form-group">
                    <label>비밀번호 확인</label>
                    <input type="password" placeholder="비밀번호를 다시 입력하세요" required>
                </div>

                <div class="form-group">
                    <label>이름 / 담당자명</label>
                    <input type="text" placeholder="실명을 입력하세요" required>
                </div>

                <div class="form-group">
                    <label>이메일 주소</label>
                    <input type="email" placeholder="example@ess-ms.com" required>
                </div>

                <div class="form-group">
                    <label for="location">설치 지역</label>
                    <select name="location" id="location" required style="width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 5px; background-color: #fff;">
                        <option value="" disabled selected>지역을 선택해 주세요</option>
                        <option value="경기도">1. 경기도</option>
                        <option value="강원도">2. 강원도</option>
                        <option value="충청북도">3. 충청북도</option>
                        <option value="충청남도">4. 충청남도</option>
                        <option value="전라북도">5. 전라북도</option>
                        <option value="전라남도">6. 전라남도</option>
                        <option value="경상북도">7. 경상북도</option>
                        <option value="경상남도">8. 경상남도</option>
                        <option value="제주도">9. 제주도</option>
                    </select>
                </div>

                <div id="business-info" style="display:none;">
                    <div class="form-group">
                        <label>기업명 (상호명)</label>
                        <input type="text" placeholder="회사명을 입력하세요">
                    </div>
                    <div class="form-group">
                        <label>사업자 등록번호</label>
                        <input type="text" placeholder="000-00-00000">
                    </div>
                </div>

                <button type="submit" class="btn login-submit" style="margin-top:20px; padding: 15px;">회원가입 완료</button>
            </form>

            <div class="login-footer">
                <p>이미 계정이 있으신가요? <a href="javascript:void(0)" onclick="openLoginWindow()">로그인하기</a></p>
            </div>
        </div>
    </main>

    <script>
        function openLoginWindow() {
            const width = 450;
            const height = 620;
            const left = (window.screen.width / 2) - (width / 2);
            const top = (window.screen.height / 2) - (height / 2);
            window.open('4.login.html', 'ESS_Login', `width=${width}, height=${height}, left=${left}, top=${top}, resizable=no, scrollbars=no`);
        }

        function selectType(type) {
            const tabs = document.querySelectorAll('.tab-btn');
            const bizInfo = document.getElementById('business-info');
            tabs.forEach(tab => tab.classList.remove('active'));
            if(type === 'user') {
                tabs[0].classList.add('active');
                bizInfo.style.display = 'none';
            } else {
                tabs[1].classList.add('active');
                bizInfo.style.display = 'block';
            }
        }
    </script>

    <!-- 로그인 체크기능 -->
    <script>
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
</script>


<!-- 페이지 맨 아래 회사 정보, 주소, 연락처 공간 -->
    <footer>
    <div class="container footer-content">
        <div class="footer-info">
            <h2 class="footer-logo">ESS-M.S</h2>
            <p>스마트 에너지 모니터링 시스템 전문 기업</p>
            <address>
                부산광역시 범내골 kh 학원 <br>
                대표전화: 051-123-4567 | 이메일: info@ess-ms.com
            </address>
            <p class="copyright">&copy; 2026 ESS-Monitoring System. All Rights Reserved.</p>
        </div>
        
        <div class="footer-links">
            <h4>Quick Links</h4>
            <ul>
                <li><a href="1.main.html">홈</a></li>
                <li><a href="3.serviceInfo.html">서비스 소개</a></li>
                <li><a href="${pageContext.request.contextPath}/board_list">문의게시판</a></li>
                <li><a href="6.newsupdate.html">최신 정보</a></li>
            </ul>
        </div>

        <div class="footer-sns">
            <h4>Follow Us</h4>
            <div class="sns-icons">
                <span>Blog</span>
                <span>LinkedIn</span>
                <span>Youtube</span>
            </div>
        </div>
    </div>
</footer>

</body>
</html>