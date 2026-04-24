<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- JSTL 사용 (로그인 상태 분기용) -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<header>
    <div class="container">

        <!--  로고 -->
        <h1 class="logo">ESS-M.S</h1>

        <!--  상단 메뉴 -->
        <nav>
            <ul>

                <!--  공통 메뉴 (항상 보임) -->
                <li><a href="${pageContext.request.contextPath}/main">홈</a></li>
                <li><a href="#">서비스 소개</a></li>
                <li><a href="${pageContext.request.contextPath}/board_list">문의게시판</a></li>

                <!--  로그인 상태에 따라 변경되는 영역 -->
                <c:choose>

                    <%--  로그인 안 된 상태  --%>
                    <c:when test="${empty sessionScope.member_id}">
                        <li>
                            <a href="${pageContext.request.contextPath}/login_view">로그인</a>
                        </li>
                    </c:when>

                    <%--  로그인 된 상태  --%>
                    <c:otherwise>
                        <li>
                            <%--  사용자이름표시  --%>
                            <span>${sessionScope.member_name}님</span>
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