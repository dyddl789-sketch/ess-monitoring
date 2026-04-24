<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<script>
	    if (window.opener) {
	        window.opener.location.href = '/ess_monitoring/list';
	        window.close();
	    } else {
	        location.href = '/ess_monitoring/list';
	    }
	</script>
</body>
</html>