<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<!DOCTYPE html>
<html lang="ko">
<head>

<meta charset="UTF-8">
<title>문의 상세 - ESS-M.S</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/main.css">
<!-- Ajax 사용을 위한 jQuery 로드 -->
<script src="${pageContext.request.contextPath}/resources/js/jquery.js"></script>
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

/* ============================= */
/* 관리자 답변 댓글 영역 */
/* ============================= */

/* 관리자 답변 전체 영역 */
.comment-area {
    margin-top: 40px;
    padding-top: 28px;
    border-top: 1px solid #e5e7eb;
}

/* 관리자 답변 제목 */
.comment-area h3 {
    margin-bottom: 16px;
    font-size: 22px;
    font-weight: 700;
    color: #111827;
}

/* 답변이 없을 때 안내 박스 */
.comment-empty {
    padding: 18px;
    border-radius: 10px;
    background: #f8fafc;
    color: #64748b;
    font-size: 14px;
    border: 1px solid #e2e8f0;
}

/* 댓글 1개 박스 */
.comment-box {
    margin-bottom: 14px;
    padding: 18px;
    border-radius: 12px;
    background: #f8fafc;
    border: 1px solid #e2e8f0;
}

/* 댓글 상단: 작성자 / 작성일 */
.comment-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 10px;
    font-size: 14px;
}

/* 댓글 작성자 */
.comment-header strong {
    color: #0369a1;
    font-weight: 700;
}

/* 댓글 작성일 */
.comment-header span {
    color: #64748b;
    font-size: 13px;
}

/* 댓글 내용 */
.comment-content {
    font-size: 15px;
    line-height: 1.7;
    color: #1f2937;
    white-space: pre-wrap;
}

/* 관리자 답변 작성 박스 */
.comment-write-box {
    margin-top: 24px;
    padding: 20px;
    border-radius: 12px;
    background: #f1f5f9;
    border: 1px solid #cbd5e1;
}

/* 관리자 답변 작성 제목 */
.comment-write-box h4 {
    margin: 0 0 12px 0;
    font-size: 17px;
    font-weight: 700;
    color: #111827;
}

/* 답변 입력창 */
.comment-write-box textarea {
    width: 100%;
    min-height: 110px;
    padding: 12px;
    resize: vertical;
    border-radius: 8px;
    border: 1px solid #cbd5e1;
    font-size: 14px;
    box-sizing: border-box;
}

/* 답변 등록 버튼 */
.comment-write-box button {
    margin-top: 10px;
    padding: 9px 16px;
    border: none;
    border-radius: 8px;
    background: #0369a1;
    color: #ffffff;
    font-weight: 600;
    cursor: pointer;
}

/* 답변 등록 버튼 hover */
.comment-write-box button:hover {
    background: #075985;
}

/* 댓글 수정/삭제 버튼 영역 */
.comment-btn-area {
    margin-top: 12px;
    display: flex;
    justify-content: flex-end;
    gap: 6px;
}

/* 댓글 수정/삭제 기본 버튼 */
.comment-btn-area button,
.comment-edit-btn-area button {
    padding: 6px 10px;
    border: none;
    border-radius: 6px;
    background: #0369a1;
    color: #ffffff;
    font-size: 13px;
    font-weight: 600;
    cursor: pointer;
}

/* 회색 버튼 */
.btn-gray-small {
    background: #6b7280 !important;
}

/* 빨간 삭제 버튼 */
.btn-red-small {
    background: #dc2626 !important;
}

/* 댓글 수정 입력 박스 */
.comment-edit-box {
    margin-top: 12px;
}

/* 댓글 수정 textarea */
.comment-edit-box textarea {
    width: 100%;
    min-height: 90px;
    padding: 12px;
    resize: vertical;
    border-radius: 8px;
    border: 1px solid #cbd5e1;
    font-size: 14px;
    box-sizing: border-box;
}

/* 수정 완료 / 취소 버튼 영역 */
.comment-edit-btn-area {
    margin-top: 8px;
    display: flex;
    justify-content: flex-end;
    gap: 6px;
}
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
	    <!-- ============================= -->
    <!-- 관리자 답변 댓글 영역 시작 -->
    <!-- ============================= -->
    <div class="comment-area">

        <!-- 관리자 답변 영역 제목 -->
        <h3>관리자 답변</h3>

        <!-- 댓글 목록 출력 -->
        <c:choose>

            <%-- 댓글이 없을 때 --%>
            <c:when test="${empty commentList}">
                <div class="comment-empty">
                    등록된 관리자 답변이 없습니다.
                </div>
            </c:when>

            <%-- 댓글이 있을 때 --%>
            <c:otherwise>
                <c:forEach var="comment" items="${commentList}">
    <div class="comment-box" id="commentBox_${comment.comment_id}">

        <!-- 댓글 작성자 / 작성일 -->
        <div class="comment-header">
            <strong>${comment.member_name}</strong>
            <span>${comment.created_at}</span>
        </div>

        <!-- 댓글 내용 출력 영역 -->
        <div class="comment-content" id="commentText_${comment.comment_id}">
            ${comment.comment_content}
        </div>

        <!-- 댓글 수정 입력 영역: 처음에는 숨김 -->
        <div class="comment-edit-box" id="commentEditBox_${comment.comment_id}" style="display:none;">
            <textarea id="commentEditContent_${comment.comment_id}" rows="4">${comment.comment_content}</textarea>

            <div class="comment-edit-btn-area">
                <button type="button" onclick="modifyComment(${comment.comment_id})">수정 완료</button>
                <button type="button" class="btn-gray-small" onclick="cancelModifyComment(${comment.comment_id})">취소</button>
            </div>
        </div>

        <!-- 관리자일 때만 수정/삭제 버튼 표시 -->
        <c:if test="${user_type eq 'ADMIN' or user_type eq '관리자'}">
            <div class="comment-btn-area">
                <button type="button" onclick="showModifyComment(${comment.comment_id})">수정</button>
                <button type="button" class="btn-red-small" onclick="deleteComment(${comment.comment_id})">삭제</button>
            </div>
        </c:if>

    </div>
</c:forEach>
            </c:otherwise>

        </c:choose>

        <!--
            관리자 답변 작성 영역

            조건:
            - user_type이 ADMIN 또는 관리자일 때만 보임
            - 일반 회원은 답변 작성 폼 자체가 보이지 않음
        -->
        <c:if test="${user_type eq 'ADMIN' or user_type eq '관리자'}">
            <div class="comment-write-box">

                <h4>관리자 답변 작성</h4>

                <!-- 현재 게시글 번호 -->
                <input type="hidden" id="comment_board_no" value="${content_view.board_no}">

                <!-- 관리자 답변 내용 -->
                <textarea id="comment_content"
                          rows="4"
                          placeholder="문의에 대한 답변을 입력하세요."></textarea>

                <!-- 답변 등록 버튼 -->
                <button type="button" onclick="writeComment()">답변 등록</button>

            </div>
        </c:if>

    </div>
    <!-- ============================= -->
    <!-- 관리자 답변 댓글 영역 끝 -->
    <!-- ============================= -->
</main>

<%@ include file="/WEB-INF/views/footer.jsp" %>

<script>
/**
 * 수정 폼 열기/닫기
 * - 게시글 작성자 본인일 때만 수정 버튼이 보임
 */
function showModifyForm() {
    var box = document.getElementById("modifyForm");
    box.style.display = box.style.display === "none" ? "block" : "none";
}

/**
 * 관리자 답변 등록
 *
 * 흐름:
 * 1. 현재 게시글 번호 가져오기
 * 2. 답변 내용 가져오기
 * 3. 빈 값 체크
 * 4. Ajax로 /comment_write 요청
 * 5. 성공 시 페이지 새로고침
 */
function writeComment() {
    // 현재 게시글 번호
    const board_no = $("#comment_board_no").val();

    // 관리자 답변 내용
    const comment_content = $("#comment_content").val();

    console.log("@# board_no =>", board_no);
    console.log("@# comment_content =>", comment_content);

    // 답변 내용 빈 값 체크
    if (comment_content.trim() === "") {
        alert("답변 내용을 입력하세요.");
        $("#comment_content").focus();
        return;
    }

    $.ajax({
        type: "post",
        url: "${pageContext.request.contextPath}/comment_write",
        data: {
            board_no: board_no,
            comment_content: comment_content
        },
        success: function(result) {
            console.log("@# comment write result =>", result);

            if (result === "success") {
                alert("답변이 등록되었습니다.");
                location.reload();

            } else if (result === "login_required") {
                alert("로그인이 필요합니다.");
                location.href = "${pageContext.request.contextPath}/login_view";

            } else if (result === "not_admin") {
                alert("관리자만 답변을 등록할 수 있습니다.");

            } else if (result === "empty") {
                alert("답변 내용을 입력하세요.");

            } else {
                alert("답변 등록에 실패했습니다.");
            }
        },
        error: function(xhr, status, error) {
            console.log("@# xhr.status =>", xhr.status);
            console.log("@# xhr.responseText =>", xhr.responseText);
            console.log("@# status =>", status);
            console.log("@# error =>", error);

            alert("서버 오류가 발생했습니다.");
        }
    });
}

/**
 * 관리자 답변 수정 폼 열기
 *
 * commentText 영역은 숨기고,
 * commentEditBox 영역을 보여준다.
 */
function showModifyComment(comment_id) {
    console.log("@# showModifyComment comment_id =>", comment_id);

    $("#commentText_" + comment_id).hide();
    $("#commentEditBox_" + comment_id).show();
}

/**
 * 관리자 답변 수정 취소
 *
 * 수정 입력창을 닫고,
 * 기존 댓글 내용을 다시 보여준다.
 */
function cancelModifyComment(comment_id) {
    console.log("@# cancelModifyComment comment_id =>", comment_id);

    $("#commentEditBox_" + comment_id).hide();
    $("#commentText_" + comment_id).show();
}

/**
 * 관리자 답변 수정 처리
 *
 * 흐름:
 * 1. 수정 textarea 값 가져오기
 * 2. 빈 값 체크
 * 3. Ajax로 /comment_modify 요청
 * 4. 성공 시 새로고침
 */
function modifyComment(comment_id) {
    const comment_content = $("#commentEditContent_" + comment_id).val();

    console.log("@# modify comment_id =>", comment_id);
    console.log("@# modify comment_content =>", comment_content);

    if (comment_content.trim() === "") {
        alert("수정할 답변 내용을 입력하세요.");
        $("#commentEditContent_" + comment_id).focus();
        return;
    }

    $.ajax({
        type: "post",
        url: "${pageContext.request.contextPath}/comment_modify",
        data: {
            comment_id: comment_id,
            comment_content: comment_content
        },
        success: function(result) {
            console.log("@# comment modify result =>", result);

            if (result === "success") {
                alert("답변이 수정되었습니다.");
                location.reload();

            } else if (result === "login_required") {
                alert("로그인이 필요합니다.");
                location.href = "${pageContext.request.contextPath}/login_view";

            } else if (result === "not_admin") {
                alert("관리자만 답변을 수정할 수 있습니다.");

            } else if (result === "empty") {
                alert("수정할 답변 내용을 입력하세요.");

            } else {
                alert("답변 수정에 실패했습니다.");
            }
        },
        error: function(xhr, status, error) {
            console.log("@# xhr.status =>", xhr.status);
            console.log("@# xhr.responseText =>", xhr.responseText);
            console.log("@# status =>", status);
            console.log("@# error =>", error);

            alert("답변 수정 중 서버 오류가 발생했습니다.");
        }
    });
}

/**
 * 관리자 답변 삭제 처리
 *
 * 흐름:
 * 1. 삭제 확인
 * 2. Ajax로 /comment_delete 요청
 * 3. 성공 시 새로고침
 */
function deleteComment(comment_id) {
    console.log("@# delete comment_id =>", comment_id);

    if (!confirm("관리자 답변을 삭제하시겠습니까?")) {
        return;
    }

    $.ajax({
        type: "post",
        url: "${pageContext.request.contextPath}/comment_delete",
        data: {
            comment_id: comment_id
        },
        success: function(result) {
            console.log("@# comment delete result =>", result);

            if (result === "success") {
                alert("답변이 삭제되었습니다.");
                location.reload();

            } else if (result === "login_required") {
                alert("로그인이 필요합니다.");
                location.href = "${pageContext.request.contextPath}/login_view";

            } else if (result === "not_admin") {
                alert("관리자만 답변을 삭제할 수 있습니다.");

            } else {
                alert("답변 삭제에 실패했습니다.");
            }
        },
        error: function(xhr, status, error) {
            console.log("@# xhr.status =>", xhr.status);
            console.log("@# xhr.responseText =>", xhr.responseText);
            console.log("@# status =>", status);
            console.log("@# error =>", error);

            alert("답변 삭제 중 서버 오류가 발생했습니다.");
        }
    });
}
</script>
</body>
</html>