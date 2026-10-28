<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<%@ include file="WEB-INF/sample.jsp" %>
<% String pageTitle="업무 알림", active="notifications"; %>
<%@ include file="WEB-INF/header.jsp" %>
<div class="page-heading"><div><div class="eyebrow">NOTIFICATIONS</div><h1>업무 알림</h1><p class="subtitle">업무 안내와 확인이 필요한 항목을 살펴보세요.</p></div><button id="read-all" type="button" class="button" disabled>조회한 알림 모두 읽음</button></div>
<div class="stats">
    <section class="stat featured"><div class="stat-label">조회한 알림 <span class="stat-icon" aria-hidden="true">♧</span></div><div class="stat-value"><span id="notice-total">—</span><small>건</small></div><p class="stat-foot">검색어와 분류에 해당하는 알림</p></section>
    <section class="stat"><div class="stat-label">읽지 않은 알림 <span class="stat-icon" aria-hidden="true">•</span></div><div class="stat-value"><span id="notice-unread">—</span><small>건</small></div><p class="stat-foot">조회한 알림 중 미확인 항목</p></section>
    <section class="stat"><div class="stat-label">중요 알림 <span class="stat-icon" aria-hidden="true">!</span></div><div class="stat-value"><span id="notice-important">—</span><small>건</small></div><p class="stat-foot">조회한 알림 중 중요 분류</p></section>
</div>
<section class="panel">
    <form id="notification-form" class="filters" action="notificationList.jsp" method="get" role="search">
        <div class="field wide"><label for="keyword">알림 검색</label><input id="keyword" name="keyword" maxlength="100" placeholder="제목 또는 내용 검색" value="<%= h(request.getParameter("keyword")) %>"></div>
        <div class="field"><label for="category">알림 분류</label><select id="category" name="category"><option value="">전체 분류</option>
            <% for (String value : Arrays.asList("중요", "안내", "점검")) { %><option value="<%= h(value) %>" <%= value.equals(request.getParameter("category")) ? "selected" : "" %>><%= h(value) %></option><% } %>
        </select></div>
        <div class="field"><label for="read-state">읽음 상태</label><select id="read-state" name="readState"><option value="">전체 알림</option><option value="unread">읽지 않음</option><option value="read">읽음</option></select></div>
        <button class="button primary" type="submit">알림 조회</button><button class="button" type="reset">초기화</button>
    </form>
    <div id="notification-items" class="notification-items" aria-label="알림 목록"><p class="empty">알림을 불러오는 중입니다.</p></div>
    <div class="table-foot"><span id="notification-count" role="status" aria-live="polite">조회 중</span><span>읽음 표시는 현재 탭에서 유지됩니다.</span></div>
</section>
<noscript><div class="alert">업무 알림 조회에는 JavaScript가 필요합니다.</div></noscript>
<script type="module" src="js/notificationList.js"></script>
<%@ include file="WEB-INF/footer.jsp" %>
