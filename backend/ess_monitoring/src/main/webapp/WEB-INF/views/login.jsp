<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<script>
function openLoginWindow() {
    const width = 450;  // 새 창 너비
    const height = 620; // 새 창 높이
    
    // 모니터 중앙 좌표 계산
    const left = (window.screen.width / 2) - (width / 2);
    const top = (window.screen.height / 2) - (height / 2);
    // 4.login.html 파일을 새 창으로 띄움
    window.open(
        '/ess_monitoring/login_view', 
        'ESS_Login', 
        `width=${width}, height=${height}, left=${left}, top=${top}, resizable=no, scrollbars=no`
    );
   
}
</script>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<form action="login" method="post">
		아 이 디 : <input type="text" name="member_userid"><br>
		비 밀 번 호 : <input type="password" name="member_pw"><br>
	<button type="button" onclick="openLoginWindow()">로그인</button></form>
</body>
</html>