<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>로그인 - ESS-M.S</title>
    <link rel="stylesheet" href="css/1.main.css">
    <style>
        /* 새 창 전용 추가 스타일 */
        body { 
            background-color: #f4f7f9; 
            display: flex; 
            justify-content: center; 
            align-items: center; 
            height: 100vh; 
            margin: 0;
        }
        .login-container { width: 100%; padding: 20px; }
    </style>
</head>
<body>

    <div class="login-container">
        <div class="login-box">
            <h1 class="logo" style="text-align:center; margin-bottom:20px; font-size:1.8rem;">ESS-M.S</h1>
            <h2 style="text-align:center; margin-bottom:25px;">로그인</h2>
            
            <div class="login-type-tabs">
                <button type="button" class="tab-btn active" onclick="selectType('user')">개인용</button>
                <button type="button" class="tab-btn" onclick="selectType('business')">기업용</button>
            </div>

            <form onsubmit="handleLoginSubmit(event)">
                <div class="form-group">
                    <label>아이디</label>
                    <input type="text" id="userId" placeholder="아이디를 입력하세요" required>
                </div>
                <div class="form-group">
                    <label>비밀번호</label>
                    <input type="password" id="userPw" placeholder="비밀번호를 입력하세요" required>
                </div>
                
                <div class="login-options">
                    <label><input type="checkbox"> 아이디 저장</label>
                    <a href="#" class="find-pw">비밀번호 찾기</a>
                </div>

                <button type="submit" class="btn login-submit">로그인</button>
            </form>

            <div class="login-footer">
                <p>아직 계정이 없으신가요? <a href="5.consent.html" target="_blank" onclick="window.close();">회원가입</a></p>
            </div>
        </div>
    </div>

    <script>
        // 1. 탭 전환 기능
        function selectType(type) {
            const tabs = document.querySelectorAll('.tab-btn');
            tabs.forEach(tab => tab.classList.remove('active'));
            
            if(type === 'user') {
                tabs[0].classList.add('active');
                console.log("개인용 로그인 모드");
            } else {
                tabs[1].classList.add('active');
                console.log("기업용 로그인 모드");
            }
        }

        // 2. 로그인 처리 기능 (selectType 밖으로 분리)
        function handleLoginSubmit(event) {
            // 폼 제출 시 페이지가 새로고침되는 것을 방지
            event.preventDefault(); 
            
            // 실제 서비스에서는 입력값을 검증하지만, 여기서는 가상 성공 처리
            localStorage.setItem('isLoggedIn', 'true');
            localStorage.setItem('userName', '홍길동'); // 테스트용 이름 저장
            
            alert("로그인 되었습니다!");
            
            // 부모 창(1.main.html 등)이 존재하면 새로고침하여 로그인 상태 반영
            if (window.opener && !window.opener.closed) {
                window.opener.location.reload();
            }
            
            // 현재 로그인 팝업 창 닫기
            window.close();
        }
    </script>
</body>
</html>
