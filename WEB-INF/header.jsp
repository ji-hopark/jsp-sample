<%@ page pageEncoding="UTF-8" %>
<%-- 각 화면에서 sample.jsp를 먼저 정적 include합니다. --%>
<!doctype html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="color-scheme" content="light">
    <link rel="icon" href="data:image/svg+xml,%3Csvg xmlns=%27http://www.w3.org/2000/svg%27 viewBox=%270 0 32 32%27%3E%3Crect width=%2732%27 height=%2732%27 rx=%277%27 fill=%27%23182c25%27/%3E%3Ctext x=%2716%27 y=%2723%27 text-anchor=%27middle%27 font-family=%27sans-serif%27 font-size=%2722%27 fill=%27%23d9f59b%27%3EN%3C/text%3E%3C/svg%3E">
    <title><%= h(pageTitle) %> · NOVA Business</title>
    <link rel="stylesheet" href="css/common.css">
</head>
<body>
<a href="#main" class="button skip-link">본문 바로가기</a>
<aside class="sidebar">
    <a class="brand" href="index.jsp" aria-label="NOVA 대시보드">NOVA<i>.</i></a>
    <div class="brand-sub">BUSINESS BANKING</div>
    <div class="nav-label">WORKSPACE</div>
    <nav aria-label="주 메뉴">
        <a class="nav-link <%= "dashboard".equals(active) ? "active" : "" %>" <%= "dashboard".equals(active) ? "aria-current=\"page\"" : "" %> href="index.jsp"><span aria-hidden="true">▦</span><span>대시보드</span></a>
        <a class="nav-link <%= "accounts".equals(active) ? "active" : "" %>" <%= "accounts".equals(active) ? "aria-current=\"page\"" : "" %> href="accountList.jsp"><span aria-hidden="true">▤</span><span>계좌 관리</span></a>
        <a class="nav-link <%= "transactions".equals(active) ? "active" : "" %>" <%= "transactions".equals(active) ? "aria-current=\"page\"" : "" %> href="transactionList.jsp"><span aria-hidden="true">⇄</span><span>거래 내역</span></a>
        <a class="nav-link <%= "customers".equals(active) ? "active" : "" %>" <%= "customers".equals(active) ? "aria-current=\"page\"" : "" %> href="customerList.jsp"><span aria-hidden="true">♙</span><span>고객 관리</span></a>
        <a class="nav-link <%= "transfers".equals(active) ? "active" : "" %>" <%= "transfers".equals(active) ? "aria-current=\"page\"" : "" %> href="transferList.jsp"><span aria-hidden="true">↗</span><span>이체 내역</span></a>
        <a class="nav-link <%= "notifications".equals(active) ? "active" : "" %>" <%= "notifications".equals(active) ? "aria-current=\"page\"" : "" %> href="notificationList.jsp"><span aria-hidden="true">♧</span><span>업무 알림</span></a>
    </nav>
    <div class="sidebar-note"><strong>JSP Sample Workspace</strong>가상 데이터로 살펴보는<br>계좌 관리 업무 화면</div>
</aside>
<div class="workspace">
    <header class="topbar">
        <div class="breadcrumb">워크스페이스 &nbsp; / &nbsp; <b><%= h(pageTitle) %></b></div>
        <div class="profile"><span class="demo-pill">SAMPLE</span><span class="avatar" aria-hidden="true">김</span><span class="profile-name">김관리 <span style="color:var(--muted)">님</span></span></div>
    </header>
    <main id="main">
