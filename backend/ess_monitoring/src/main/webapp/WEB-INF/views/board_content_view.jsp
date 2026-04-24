<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<table width="500" border="1">
		<form method="post" action="modify">
			<input type="hidden" name="pageNum" value="${pageMaker.pageNum}">
			<input type="hidden" name="amount" value="${pageMaker.amount}">
<%-- 			<input type="hidden" name="boardNo" value="${content_view.boardNo}"> --%>
			<input type="hidden" name="boardNo" value="${pageMaker.boardNo}">
			<tr>
				<td>번호</td>
				<td>
					${content_view.boardNo}
				</td>
			</tr>
			<tr>
				<td>히트</td>
				<td>
					${content_view.boardHit}
				</td>
			</tr>
			<tr>
				<td>이름</td>
				<td>
					<input type="text" name="boardName" value="${content_view.boardName}">
				</td>
			</tr>
			<tr>
				<td>제목</td>
				<td>
					<input type="text" name="boardTitle" value="${content_view.boardTitle}">
				</td>
			</tr>
			<tr>
				<td>내용</td>
				<td>
					<input type="text" name="boardContent" value="${content_view.boardContent}">
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<input type="submit" value="수정">
<!-- 					&nbsp;&nbsp;<a href="list">목록보기</a> -->
				<!-- formaction="list" : name 으로 설정된 값들을 가지고 이동 -->
<!-- 					&nbsp;&nbsp;<input type="submit" value="목록보기" formaction="list"> -->
					&nbsp;&nbsp;<input type="submit" value="목록보기" formaction="list">
<%-- 					&nbsp;&nbsp;<a href="delete?boardNo=${content_view.boardNo}">삭제</a> --%>
					&nbsp;&nbsp;<input type="submit" value="삭제" formaction="delete">
				</td>
			</tr>
		</form>
	</table>
</body>
</html>












