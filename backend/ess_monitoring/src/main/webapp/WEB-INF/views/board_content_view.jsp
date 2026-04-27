<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>문의 상세 - ESS-M.S</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/main.css">

<style>
.container { width: 80%; margin: 0 auto; }
.sub-hero {
    background-color: #2c3e50;
    color: white;
    padding: 60px 0;
    text-align: center;
}
.detail-section { padding: 50px 0; }
.detail-box {
    border-top: 2px solid #333;
    background: #fff;
}
.detail-title {
    padding: 20px;
    border-bottom: 1px solid #ddd;
}
.detail-title h2 { margin: 0 0 10px; }
.detail-meta {
    color: #666;
    font-size: 0.95rem;
}
.detail-content {
    min-height: 250px;
    padding: 30px 20px;
    border-bottom: 1px solid #ddd;
    line-height: 1.8;
    white-space: pre-wrap;
}
.btn-area {
    margin-top: 25px;
    display: flex;
    gap: 8px;
    justify-content: flex-end;
}
.btn {
    padding: 9px 15px;
    background:#007bff;
    color:white;
    border:none;
    border-radius:5px;
    cursor:pointer;
    text-decoration:none;
}
.btn-gray { background:#6c757d; }
.btn-red { background:#dc3545; }
</style>
</head>

<body>

<%@ include file="/WEB-INF/views/header.jsp" %>

<section class="sub-hero">
    <div class="container">
        <h2>문의 상세</h2>
        <p>등록된 문의 내용을 확인합니다.</p>
    </div>
</section>

<main class="container detail-section">

    <div class="detail-box">
        <div class="detail-title">
            <h2>${content_view.board_title}</h2>
            <div class="detail-meta">
                작성자: ${content_view.member_name}
                |
                작성일:
                <fmt:formatDate value="${content_view.created_at}" pattern="yyyy-MM-dd HH:mm"/>
                |
                조회수: ${content_view.board_hit}
            </div>
        </div>

        <div class="detail-content">${content_view.board_content}</div>
    </div>

    <div class="btn-area">
        <a class="btn btn-gray"
           href="${pageContext.request.contextPath}/board_list?pageNum=${empty pageMaker.pageNum ? 1 : pageMaker.pageNum}&amount=${empty pageMaker.amount ? 10 : pageMaker.amount}&type=${pageMaker.type}&keyword=${pageMaker.keyword}">
            목록
        </a>

        <c:if test="${loginMemberId == content_view.member_id}">
            <button type="button" class="btn" onclick="showModifyForm()">수정</button>

            <form action="${pageContext.request.contextPath}/delete" method="post" style="display:inline;"
                  onsubmit="return confirm('정말 삭제하시겠습니까?');">
                <input type="hidden" name="board_no" value="${content_view.board_no}">
                <input type="hidden" name="pageNum" value="${empty pageMaker.pageNum ? 1 : pageMaker.pageNum}">
                <input type="hidden" name="amount" value="${empty pageMaker.amount ? 10 : pageMaker.amount}">
                <input type="hidden" name="type" value="${pageMaker.type}">
                <input type="hidden" name="keyword" value="${pageMaker.keyword}">
                <button type="submit" class="btn btn-red">삭제</button>
            </form>
        </c:if>
    </div>

    <c:if test="${loginMemberId == content_view.member_id}">
        <div id="modifyForm" style="display:none; margin-top:30px;">
            <form action="${pageContext.request.contextPath}/modify" method="post">
                <input type="hidden" name="board_no" value="${content_view.board_no}">
                <input type="hidden" name="pageNum" value="${empty pageMaker.pageNum ? 1 : pageMaker.pageNum}">
                <input type="hidden" name="amount" value="${empty pageMaker.amount ? 10 : pageMaker.amount}">
                <input type="hidden" name="type" value="${pageMaker.type}">
                <input type="hidden" name="keyword" value="${pageMaker.keyword}">

                <div style="margin-bottom:15px;">
                    <label>제목</label>
                    <input type="text" name="board_title" value="${content_view.board_title}"
                           style="width:100%; padding:12px; border:1px solid #ddd; border-radius:5px;">
                </div>

                <div style="margin-bottom:15px;">
                    <label>내용</label>
                    <textarea name="board_content" rows="10"
                              style="width:100%; padding:12px; border:1px solid #ddd; border-radius:5px;">${content_view.board_content}</textarea>
                </div>

                <div style="text-align:right;">
                    <button type="submit" class="btn">수정 완료</button>
                </div>
            </form>
        </div>
    </c:if>

</main>

<%@ include file="/WEB-INF/views/footer.jsp" %>

<script>
function showModifyForm() {
    var box = document.getElementById("modifyForm");
    box.style.display = box.style.display === "none" ? "block" : "none";
}
</script>

</body>
</html>