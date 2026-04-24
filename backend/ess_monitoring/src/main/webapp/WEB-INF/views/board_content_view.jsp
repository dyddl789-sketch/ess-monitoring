<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>


	<form method="post" action="${pageContext.request.contextPath}/modify">
		<table width="500" border="1">
		    <input type="hidden" name="boardNo" value="${content_view.board_no}">
			<input type="hidden" name="pageNum" value="${pageMaker.pageNum}">
			<input type="hidden" name="amount" value="${pageMaker.amount}">
			<input type="hidden" name="type" value="${pageMaker.type}">
    		<input type="hidden" name="keyword" value="${pageMaker.keyword}">
			<tr>
				<td>번호</td>
				<td>
					${content_view.board_no}
				</td>
			</tr>
			<tr>
				<td>히트</td>
				<td>
					${content_view.board_hit}
				</td>
			</tr>
			<tr>
				<td>이름</td>
				<td>
					<input type="text" name="member_name" value="${content_view.member_name}" readonly>
				</td>
			</tr>
			<tr>
				<td>제목</td>
				<td>
					<input type="text" name="board_title" value="${content_view.board_title}">
				</td>
			</tr>
			<tr>
				<td>내용</td>
				<td>
					<textarea rows="10" cols="50" name="board_content">${content_view.board_content}</textarea>				</td>
			</tr>
			<tr>
				<td colspan="2">
					<!-- 수정 버튼 작성자 본인에게만 보이게 처리 -->
					<c:if test="${loginMemberId == content_view.member_id}">
						<input type="submit" value="수정">
						&nbsp;&nbsp;
					</c:if>
					
					<!-- 목록보기는 모든 사용자 -->
                	<a href="${pageContext.request.contextPath}/board_list">목록보기</a>
						&nbsp;&nbsp;
						
					<!-- 삭제 버튼도 작성자 본인에게만 보이게 처리 -->
                	<c:if test="${loginMemberId == content_view.member_id}">
            			<a href="${pageContext.request.contextPath}/delete?boardNo=${content_view.board_no}">삭제</a>
        			</c:if>
				</td>
			</tr>
		</table>
	</form>
</body>
</html>












