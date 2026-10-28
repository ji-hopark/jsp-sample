<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<%@ include file="WEB-INF/sample.jsp" %>
<% String pageTitle="이체 내역", active="transfers"; %>
<%@ include file="WEB-INF/header.jsp" %>
<div class="page-heading"><div><div class="eyebrow">TRANSFERS</div><h1>이체 내역</h1><p class="subtitle">완료·예약·실패 이체를 조회하고 상세 사유를 확인하세요.</p></div><span class="badge good">조회 전용</span></div>
<div class="stats">
    <section class="stat featured"><div class="stat-label">완료 이체 금액 <span class="stat-icon" aria-hidden="true">↗</span></div><div class="stat-value"><span id="transfer-amount">—</span><small>원</small></div><p class="stat-foot">조회 결과 중 완료된 이체 합계</p></section>
    <section class="stat"><div class="stat-label">예약 이체 <span class="stat-icon" aria-hidden="true">◷</span></div><div class="stat-value"><span id="transfer-scheduled">—</span><small>건</small></div><p class="stat-foot">조회 결과 중 예약 상태</p></section>
    <section class="stat"><div class="stat-label">실패 이체 <span class="stat-icon" aria-hidden="true">!</span></div><div class="stat-value"><span id="transfer-failed">—</span><small>건</small></div><p class="stat-foot">상세에서 실패 사유 확인</p></section>
</div>
<section class="panel">
    <div class="panel-head"><div><h2>이체 조회</h2><p class="panel-sub">가상 이체 내역입니다. 실제 이체는 실행되지 않습니다.</p></div></div>
    <form id="transfer-form" class="filters" action="transferList.jsp" method="get" role="search">
        <div class="field wide"><label for="keyword">이체 검색</label><input id="keyword" name="keyword" maxlength="100" placeholder="받는 분, 예금주 또는 이체번호" value="<%= h(request.getParameter("keyword")) %>"></div>
        <div class="field"><label for="accountId">출금 계좌</label><select id="accountId" name="accountId"><option value="">전체 계좌</option>
            <% for (Account account : accounts()) { %><option value="<%= h(account.id) %>" <%= account.id.equals(request.getParameter("accountId")) ? "selected" : "" %>><%= h(account.owner) %> · <%= h(account.number) %></option><% } %>
        </select></div>
        <div class="field"><label for="status">이체 상태</label><select id="status" name="status"><option value="">전체 상태</option>
            <% for (String value : Arrays.asList("완료", "예약", "실패")) { %><option value="<%= h(value) %>" <%= value.equals(request.getParameter("status")) ? "selected" : "" %>><%= h(value) %></option><% } %>
        </select></div>
        <button class="button primary" type="submit">이체 조회</button><button class="button" type="reset">초기화</button>
    </form>
    <div class="table-wrap"><table aria-label="이체 검색 결과"><thead><tr><th>이체일 / 번호</th><th>출금 계좌</th><th>받는 분</th><th class="numeric">이체 금액</th><th>상태</th><th>상세</th></tr></thead><tbody id="transfer-rows"><tr><td class="empty" colspan="6">이체 내역을 불러오는 중입니다.</td></tr></tbody></table></div>
    <div class="table-foot"><span id="transfer-count" role="status" aria-live="polite">조회 중</span><span>예약일 포함 최신순 · 가상 이체</span></div>
</section>
<noscript><div class="alert">이체 내역 조회에는 JavaScript가 필요합니다.</div></noscript>
<script type="module" src="js/transferList.js"></script>
<%@ include file="WEB-INF/footer.jsp" %>
