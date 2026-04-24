<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<html>
<head>
<meta charset="UTF-8">
<title>게시글 작성</title>

<!-- jQuery 불러오기 -->
<script src="${pageContext.request.contextPath}/resources/js/jquery.js"></script>

<script type="text/javascript">
    function fn_submit() {
        var formData = $("#frm").serialize();

        console.log("@# formData => " + formData);

        $.ajax({
              type: "post"
            , url : "${pageContext.request.contextPath}/board_write"
            , data : formData
            , success : function(data) {
                alert("저장완료");
                location.href = "${pageContext.request.contextPath}/board_list";
            }
            , error : function() {
                alert("오류발생");
            }
        });
    }
</script>
</head>

<body>
    <form id="frm">
        <table width="500" border="1">
            <tr>
                <td>제목</td>
                <td>
                    <input type="text" name="board_title" size="50">
                </td>
            </tr>

            <tr>
                <td>내용</td>
                <td>
                    <textarea rows="10" cols="50" name="board_content"></textarea>
                </td>
            </tr>

            <tr>
                <td colspan="2">
                    <input type="button" onclick="fn_submit()" value="입력">
                    &nbsp;&nbsp;
                    <a href="${pageContext.request.contextPath}/board_list">목록보기</a>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>