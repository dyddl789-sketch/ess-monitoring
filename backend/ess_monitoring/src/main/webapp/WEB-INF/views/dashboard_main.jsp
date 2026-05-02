<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/dashboard_main.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/sidebar.css">
</head>
<body>
<div class="layout">
<%@ include file="/WEB-INF/views/sidebar.jsp" %>
  <main class="main">

    <div class="header">
      <h2>대시보드</h2>
      <div class="user-box">(주)에너지코리아 ▼</div>
    </div>

    <div class="filter-box">
		<select id="groupSelect">
		  <option value="">전체 그룹</option>
		  <option value="1">서울공장 ESS</option>
		  <option value="2">인천물류센터 ESS</option>
		</select>
		
		<select id="deviceSelect">
		  <option value="">전체 장비</option>
		  <option value="3">서울공장 1호기</option>
		  <option value="4">서울공장 2호기</option>
		  <option value="5">인천물류센터 1호기</option>
		</select>

      <input type="date" id="selectedDate" value="${selectedDate}">
      <button type="button" id="refreshBtn">조회</button>
    </div>

    <section class="card-grid">
		<div class="card">
		    <div class="card-title">총 장비 수</div>
		    <div class="card-value" id="totalDeviceCount">-</div>
		    <div class="card-sub" id="deviceStatusCount">-</div>
		</div>
		
		<div class="card">
		    <div class="card-title">오늘 예상 발전량</div>
		    <div class="card-value" id="todayGenerationKwh">-</div>
		    <div class="card-sub">어제 대비 ▲ 12.5%</div>
		</div>
		
		<div class="card">
		    <div class="card-title">현재 평균 SOC</div>
		    <div class="card-value" id="averageSoc">-</div>
		    <div class="card-sub">어제 대비 ▲ 4.1%</div>
		</div>
		
		<div class="card">
		    <div class="card-title">오늘 예상 절감 금액</div>
		    <div class="card-value" id="todaySavedCost">-</div>
		    <div class="card-sub">어제 대비 ▲ 8.3%</div>
		</div>
    </section>

    <section class="content-grid">

      <div class="card">
        <div class="section-title">그룹별 오늘 예상 발전량 (kWh)</div>

        <div class="bar-chart">
          <div class="bar-item">
            <div class="bar-value">156.5</div>
            <div class="bar" style="height:156px;"></div>
            <div>서울공장</div>
          </div>

          <div class="bar-item">
            <div class="bar-value">68.3</div>
            <div class="bar" style="height:68px;"></div>
            <div>부산물류센터</div>
          </div>

          <div class="bar-item">
            <div class="bar-value">24.8</div>
            <div class="bar" style="height:25px;"></div>
            <div>대구지점</div>
          </div>

          <div class="bar-item">
            <div class="bar-value">6.8</div>
            <div class="bar" style="height:10px;"></div>
            <div>전주사무소</div>
          </div>
        </div>
      </div>

		<div class="card">
		  <div class="section-title">장비별 현재 상태</div>
		
		  <table>
		    <thead>
		      <tr>
		        <th>장비명</th>
		        <th>그룹</th>
		        <th>SOC</th>
		        <th>상태</th>
		      </tr>
		    </thead>
		
		    <tbody>
		
		      <c:choose>
		
		        
		        <c:when test="${empty deviceList}">
		          <tr>
		            <td colspan="4">등록된 장비가 없습니다.</td>
		          </tr>
		        </c:when>
		
		        
		        <c:otherwise>
		
		          <c:forEach var="device" items="${deviceList}">
		
		            <tr>
		              <%-- 장비명 (클릭 → 상세페이지 이동) --%>
		              <td>
		                <a href="${pageContext.request.contextPath}/device/detail?device_id=${device.device_id}">
		                  ${device.device_name}
		                </a>
		              </td>
		
		              <%-- 그룹명 --%>
		              <td>
		                <c:choose>
		                  <c:when test="${empty device.group_name}">
		                    -
		                  </c:when>
		                  <c:otherwise>
		                    ${device.group_name}
		                  </c:otherwise>
		                </c:choose>
		              </td>
		
		              <%-- SOC --%>
		              <td>
		                <c:choose>
		                  <c:when test="${empty device.soc}">
		                    -
		                  </c:when>
		                  <c:otherwise>
		                    ${device.soc}%
		                  </c:otherwise>
		                </c:choose>
		              </td>
		
		              <%-- 상태 --%>
		              <td>
		                <c:choose>
		
		                  <c:when test="${device.status eq 'NORMAL'}">
		                    <span class="status-normal">정상</span>
		                  </c:when>
		
		                  <c:when test="${device.status eq 'WARNING'}">
		                    <span class="status-warning">경고</span>
		                  </c:when>
		
		                  <c:when test="${device.status eq 'ERROR'}">
		                    <span class="status-danger">에러</span>
		                  </c:when>
		
		                  <c:when test="${device.status eq 'OFFLINE'}">
		                    <span class="status-offline">오프라인</span>
		                  </c:when>
		
		                  <c:otherwise>
		                    -
		                  </c:otherwise>
		
		                </c:choose>
		              </td>
		
		            </tr>
		
		          </c:forEach>
		
		        </c:otherwise>
		
		      </c:choose>
		
		    </tbody>
		  </table>
		</div>

    </section>

    <section class="bottom-grid">

      <div class="card">
        <div class="section-title">최근 알림</div>
        <ul class="alert-list">
          <li><span class="badge">경고</span> 부산센터 ESS 2호기 SOC가 50% 미만입니다. <span style="float:right;">09:15</span></li>
          <li><span class="badge">정보</span> 서울공장 ESS 1호기 충전이 완료되었습니다. <span style="float:right;">08:45</span></li>
          <li><span class="badge">정보</span> 대구지점 ESS 1호기 일일 리포트가 생성되었습니다. <span style="float:right;">08:00</span></li>
          <li><span class="badge">경고</span> 전주사무소 ESS 1호기 통신 상태가 불안정합니다. <span style="float:right;">07:30</span></li>
        </ul>
      </div>

      <div class="card">
        <div class="section-title">오늘 날씨 (서울)</div>

        <div class="weather-main">
          <div class="weather-icon">☀️</div>
          <div>
            <div class="weather-temp">23.6℃</div>
            <div>맑음</div>
          </div>

          <div class="weather-detail">
            <div>강수확률 10%</div>
            <div>습도 42%</div>
            <div>풍속 2.1m/s</div>
            <div>일출 05:25 · 일몰 19:45</div>
          </div>
        </div>

        <div class="forecast">
          <div class="forecast-item">
            <div>내일</div>
            <div>☀️</div>
            <div>24℃ / 15℃</div>
            <div>맑음</div>
          </div>

          <div class="forecast-item">
            <div>모레</div>
            <div>🌤️</div>
            <div>22℃ / 14℃</div>
            <div>구름많음</div>
          </div>

          <div class="forecast-item">
            <div>05-23</div>
            <div>🌧️</div>
            <div>20℃ / 13℃</div>
            <div>비</div>
          </div>
        </div>

      </div>

    </section>

  </main>
</div>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script>
    const contextPath = '${pageContext.request.contextPath}';
</script>
<script src="${pageContext.request.contextPath}/resources/js/dashboard_main.js"></script>
</body>
</html>