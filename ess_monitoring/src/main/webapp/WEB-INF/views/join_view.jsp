<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회 원 가 입</title>
</head>
<body>
	<h3>회 원 가 입</h3>
	
	<form action="join" method="post">
		이름 : <input type="text" name="member_name"><br><br>
        아이디 : <input type="text" name="member_userid"><br><br>
        비밀번호 : <input type="password" name="member_pw"><br><br>
        연락처 : <input type="text" name="phone"><br><br>
        이메일 : <input type="text" name="email"><br><br>
        <input type="submit" value="회원가입">
	</form>
</body>
</html>