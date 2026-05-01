<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<aside class="sidebar">
  <div class="logo">ESS 모니터링 시스템</div>

  <a href="${pageContext.request.contextPath}/main" class="menu-item active">대시보드</a>

  <div class="menu-title">장비 관리</div>
  <div class="sub-menu">
    <a href="${pageContext.request.contextPath}/devices">장비 목록</a>
    <a href="${pageContext.request.contextPath}/devices/register">장비 등록</a>
    <a href="${pageContext.request.contextPath}/device-groups">그룹 관리</a>
    <a href="${pageContext.request.contextPath}/devices/csv">CSV 일괄 등록</a>
  </div>

  <div class="menu-title">운영</div>
  <a href="${pageContext.request.contextPath}/monitoring" class="menu-item">모니터링</a>
  <a href="${pageContext.request.contextPath}/energy-logs" class="menu-item">에너지 로그</a>
  <a href="${pageContext.request.contextPath}/alerts" class="menu-item">알림</a>
  <a href="${pageContext.request.contextPath}/board" class="menu-item">게시판</a>
  <a href="${pageContext.request.contextPath}/settings" class="menu-item">설정</a>
</aside>