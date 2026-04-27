<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<header class="site-header">
    <div class="container header-inner">

        <h1 class="logo">
            <a href="${pageContext.request.contextPath}/main">ESS-M.S</a>
        </h1>

        <nav>
            <ul class="header-menu">

                <li>
                    <a href="${pageContext.request.contextPath}/main">홈</a>
                </li>

                <li>
                    <a href="javascript:void(0);" onclick="showServiceIntro()">서비스 소개</a>
                </li>

                <li>
                    <a href="${pageContext.request.contextPath}/board_list">문의게시판</a>
                </li>

                <c:choose>
                    <c:when test="${empty sessionScope.member_id}">
                        <li>
                            <a href="${pageContext.request.contextPath}/login_view">로그인</a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/join_view">회원가입</a>
                        </li>
                    </c:when>

                    <c:otherwise>
                        <li>
                            <span class="user-label">${sessionScope.member_name}님</span>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/logout">로그아웃</a>
                        </li>
                    </c:otherwise>
                </c:choose>

            </ul>
        </nav>

    </div>
</header>