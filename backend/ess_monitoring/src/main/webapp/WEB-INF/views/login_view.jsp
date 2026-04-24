<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div class="login-box">
    <h2>로그인</h2>

    <!-- 에러 메시지 -->
    <c:if test="${msg != null}">
        <p class="msg">${msg}</p>
    </c:if>

    <form action="login" method="post">
        <input type="text" name="member_userid" placeholder="아이디"><br>
        <input type="password" name="member_pw" placeholder="비밀번호"><br>
        <button type="submit">로그인</button>
    </form>

    <br>

    <a href="join_view">회원가입</a>
</div>
</body>
</html>