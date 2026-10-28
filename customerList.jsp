<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<%@ include file="WEB-INF/sample.jsp" %>
<% String pageTitle="고객 관리", active="customers"; %>
<%@ include file="WEB-INF/header.jsp" %>
<div class="page-heading">
    <div><div class="eyebrow">CUSTOMERS</div><h1>고객 관리</h1><p class="subtitle">고객 기본 정보와 연결 계좌를 확인하세요.</p></div>
    <span class="date-label">2026.10.28 기준 · 가상 고객</span>
</div>
<div class="stats">
    <section class="stat featured"><div class="stat-label">전체 고객 <span class="stat-icon" aria-hidden="true">♙</span></div><div class="stat-value">6<small>명</small></div><p class="stat-foot">전체 가상 고객 기준</p></section>
    <section class="stat"><div class="stat-label">우대 고객 <span class="stat-icon" aria-hidden="true">☆</span></div><div class="stat-value">3<small>명</small></div><p class="stat-foot">우수 2명 · 프리미엄 1명</p></section>
    <section class="stat"><div class="stat-label">확인필요 고객 <span class="stat-icon" aria-hidden="true">!</span></div><div class="stat-value">1<small>명</small></div><p class="stat-foot">고객 상세에서 연결 계좌 확인</p></section>
</div>
<section class="panel">
    <div class="panel-head"><div><h2>고객 목록</h2><p class="panel-sub">이름 또는 고객번호로 검색할 수 있습니다.</p></div><span class="badge good">조회 전용</span></div>
    <form id="customer-form" class="filters" action="customerList.jsp" method="get" role="search">
        <div class="field wide"><label for="keyword">고객 검색</label><input id="keyword" name="keyword" maxlength="100" placeholder="고객명 또는 고객번호" value="<%= h(request.getParameter("keyword")) %>"></div>
        <div class="field"><label for="tier">고객 등급</label><select id="tier" name="tier">
            <option value="">전체 등급</option>
            <% for (String value : Arrays.asList("일반", "우수", "프리미엄")) { %><option value="<%= h(value) %>" <%= value.equals(request.getParameter("tier")) ? "selected" : "" %>><%= h(value) %></option><% } %>
        </select></div>
        <div class="field"><label for="state">고객 상태</label><select id="state" name="state">
            <option value="">전체 상태</option>
            <% for (String value : Arrays.asList("정상", "확인필요", "휴면")) { %><option value="<%= h(value) %>" <%= value.equals(request.getParameter("state")) ? "selected" : "" %>><%= h(value) %></option><% } %>
        </select></div>
        <button class="button primary" type="submit">고객 조회</button><button class="button" type="reset">초기화</button>
    </form>
    <div class="table-wrap"><table aria-label="고객 검색 결과"><thead><tr><th>고객</th><th>등급</th><th>연락처</th><th>담당자</th><th>상태</th><th>상세</th></tr></thead><tbody id="customer-rows"><tr><td class="empty" colspan="6">고객을 불러오는 중입니다.</td></tr></tbody></table></div>
    <div class="table-foot"><span id="customer-count" role="status" aria-live="polite">조회 중</span><span>가상 고객 · 연락처 마스킹</span></div>
</section>
<noscript><div class="alert">고객 검색에는 JavaScript가 필요합니다.</div></noscript>
<script type="module" src="js/customerList.js"></script>
<%@ include file="WEB-INF/footer.jsp" %>
