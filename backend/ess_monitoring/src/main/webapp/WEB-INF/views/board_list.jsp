<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
<meta charset="UTF-8">
<title>게시판 목록</title>
<style type="text/css">
    .div_page ul {
        display: flex;
        list-style: none;
        gap: 8px;
        padding: 0;
    }

    table {
        border-collapse: collapse;
        width: 900px;
        margin: 20px auto;
    }

    th, td {
        border: 1px solid #ccc;
        padding: 10px;
        text-align: center;
    }

    th {
        background-color: #f5f5f5;
    }

    .search_wrap {
        width: 900px;
        margin: 20px auto;
        text-align: center;
    }

    .div_page {
        width: 900px;
        margin: 20px auto;
        text-align: center;
    }
</style>
</head>
<body>

    <table>
        <tr>
            <th>번호</th>
            <th>작성자</th>
            <th>제목</th>
            <th>작성일</th>
            <th>조회수</th>
        </tr>

        <!-- 조회 결과 -->
        <c:forEach var="dto" items="${list}">
            <tr>
                <td>${dto.board_no}</td>
                <td>${dto.member_name}</td>
                <td>
                    <a class="move_link" href="${dto.board_no}">
                        ${dto.board_title}
                    </a>
                </td>
                <td>${dto.created_at}</td>
                <td>${dto.board_hit}</td>
            </tr>
        </c:forEach>

        <tr>
            <td colspan="5">
                <a href="${pageContext.request.contextPath}/board_write_view">글작성</a>
            </td>
        </tr>
    </table>

    <div class="search_wrap">
        <form method="get" id="searchForm">
            <select name="type">
                <option value="" <c:out value="${empty pageMaker.cri.type ? 'selected' : ''}"/>>--</option>
                <option value="T" <c:out value="${pageMaker.cri.type eq 'T' ? 'selected' : ''}"/>>제목</option>
                <option value="C" <c:out value="${pageMaker.cri.type eq 'C' ? 'selected' : ''}"/>>내용</option>
                <option value="W" <c:out value="${pageMaker.cri.type eq 'W' ? 'selected' : ''}"/>>작성자</option>
                <option value="TC" <c:out value="${pageMaker.cri.type eq 'TC' ? 'selected' : ''}"/>>제목 OR 내용</option>
                <option value="TW" <c:out value="${pageMaker.cri.type eq 'TW' ? 'selected' : ''}"/>>제목 OR 작성자</option>
                <option value="TWC" <c:out value="${pageMaker.cri.type eq 'TWC' ? 'selected' : ''}"/>>제목 OR 내용 OR 작성자</option>
            </select>

            <input type="text" name="keyword" value='<c:out value="${pageMaker.cri.keyword}"/>'>
            <button type="submit">Search</button>
        </form>
    </div>

    <div class="div_page">
        <ul>
            <c:if test="${pageMaker.prev}">
                <li class="paginate_button">
                    <a href="${pageMaker.startPage - 1}">[Previous]</a>
                </li>
            </c:if>

            <c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
                <li class="paginate_button" ${pageMaker.cri.pageNum == num ? "style='background-color:yellow'" : ""}>
                    <a href="${num}">[${num}]</a>
                </li>
            </c:forEach>

            <c:if test="${pageMaker.next}">
                <li class="paginate_button">
                    <a href="${pageMaker.endPage + 1}">[Next]</a>
                </li>
            </c:if>
        </ul>
    </div>

    <form id="actionForm" method="get">
        <input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum}">
        <input type="hidden" name="amount" value="${pageMaker.cri.amount}">
        <input type="hidden" name="type" value="${pageMaker.cri.type}">
        <input type="hidden" name="keyword" value="${pageMaker.cri.keyword}">
    </form>

</body>
</html>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script>
    var actionForm = $("#actionForm");

    // 페이지 번호 처리
    $(".paginate_button a").on("click", function(e) {
        e.preventDefault();

        var bno = actionForm.find("input[name='boardNo']").val();

        if (bno != "") {
            actionForm.find("input[name='boardNo']").remove();
        }

        actionForm.find("input[name='pageNum']").val($(this).attr("href"));
        actionForm.attr("action", "${pageContext.request.contextPath}/board_list").submit();
    });

    // 게시글 상세보기 처리
    $(".move_link").on("click", function(e) {
        e.preventDefault();

        var targetBno = $(this).attr("href");

        var bno = actionForm.find("input[name='boardNo']").val();

        if (bno != "") {
            actionForm.find("input[name='boardNo']").remove();
        }

        actionForm.append("<input type='hidden' name='boardNo' value='" + targetBno + "'>");
        actionForm.attr("action", "${pageContext.request.contextPath}/board_content_view").submit();
    });

    // 검색 처리
    var searchForm = $("#searchForm");

    $("#searchForm button").on("click", function() {
    	searchForm.attr("action", "${pageContext.request.contextPath}/board_list");
    });
</script>