<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<%@ include file="WEB-INF/sample.jsp" %>
<%
    String pageTitle="대시보드", active="dashboard";
    List<Account> allAccounts=accounts();
    List<Entry> allEntries=entries();
    long totalBalance=0, deposits=0, withdrawals=0;
    int activeCount=0;
    for (Account account : allAccounts) { totalBalance+=account.balance; if ("정상".equals(account.status)) activeCount++; }
    for (Entry entry : allEntries) { if ("입금".equals(entry.type)) deposits+=entry.amount; else withdrawals+=entry.amount; }
%>
<%@ include file="WEB-INF/header.jsp" %>
<div class="page-heading">
    <div><div class="eyebrow">OVERVIEW</div><h1>한눈에 보는 계좌 현황</h1><p class="subtitle">관리 중인 계좌와 최근 거래를 확인하세요.</p></div>
    <button class="button" id="export-overview" type="button">잔액 현황 내려받기 ↓</button>
</div>
<div class="stats">
    <section class="stat featured"><div class="stat-label">전체 계좌 잔액 <span class="stat-icon" aria-hidden="true">₩</span></div><div class="stat-value"><%= money(totalBalance) %><small>원</small></div><p class="stat-foot">전체 <%= allAccounts.size() %>개 계좌 기준</p></section>
    <section class="stat"><div class="stat-label">관리 계좌 <span class="stat-icon" aria-hidden="true">▤</span></div><div class="stat-value"><%= allAccounts.size() %><small>개</small></div><p class="stat-foot">정상 <%= activeCount %>개 · 거래중지 1개 · 해지 1개</p></section>
    <section class="stat"><div class="stat-label">최근 거래 <span class="stat-icon" aria-hidden="true">⇄</span></div><div class="stat-value"><%= allEntries.size() %><small>건</small></div><p class="stat-foot">2026.10.19 – 2026.10.28 표본 거래</p></section>
</div>
<div class="two-column">
    <section class="panel">
        <div class="panel-head"><div><h2>계좌별 잔액</h2><p class="panel-sub">관리 계좌의 잔액을 비교합니다.</p></div><span class="secondary">단위: 만 원</span></div>
        <div class="panel-body"><div class="chart" role="img" aria-label="계좌별 잔액: 김민준 1,258만 원, 이서연 824만 원, 박지호 1,800만 원, 최수빈 35만 원, 정도윤 3,000만 원, 한유진 0원">
            <% for (Account account : allAccounts) { %>
            <div class="chart-col" data-owner="<%= h(account.owner) %>" data-number="<%= h(account.number) %>" data-balance="<%= account.balance %>"><span class="chart-value"><%= money(account.balance/10000) %></span><div class="bar" style="height:<%= Math.max(1, account.balance*100/30000000L) %>%"></div><span><%= h(account.owner) %></span></div>
            <% } %>
        </div></div>
    </section>
    <section class="panel">
        <div class="panel-head"><h2>주요 계좌</h2><a href="accountList.jsp" class="text-link">전체 보기 ↗</a></div>
        <div class="panel-body" style="padding-top:5px;padding-bottom:5px">
            <% for (int i=0;i<3;i++) { Account account=allAccounts.get(i); %>
            <a class="account-item" href="accountDetail.jsp?id=<%= h(account.id) %>"><span class="account-symbol" aria-hidden="true">▤</span><div><strong><%= h(account.owner) %></strong><div class="secondary"><%= h(account.product) %></div></div><span class="amount"><%= money(account.balance) %>원 <span style="color:#a4b29f">›</span></span></a>
            <% } %>
        </div>
    </section>
</div>
<section class="panel">
    <div class="panel-head"><div><h2>최근 거래 내역</h2><p class="panel-sub">가장 최근 발생한 5건의 표본 거래입니다.</p></div><a href="transactionList.jsp" class="text-link">전체 거래 보기 ↗</a></div>
    <div class="table-wrap"><table><thead><tr><th>거래일</th><th>계좌 / 예금주</th><th>거래 내용</th><th>구분</th><th class="numeric">거래 금액</th></tr></thead><tbody>
        <% for (int i=0;i<5;i++) { Entry entry=allEntries.get(i); Account account=findAccount(entry.accountId); %>
        <tr><td class="mono"><%= h(entry.date) %></td><td><a class="text-link" href="accountDetail.jsp?id=<%= h(account.id) %>"><%= h(account.owner) %></a><div class="secondary mono"><%= h(account.number) %></div></td><td><%= h(entry.name) %></td><td><span class="badge <%= "입금".equals(entry.type) ? "good" : "neutral" %>"><%= h(entry.type) %></span></td><td class="numeric <%= "입금".equals(entry.type) ? "deposit" : "withdrawal" %>"><%= "입금".equals(entry.type) ? "+" : "−" %><%= money(entry.amount) %>원</td></tr>
        <% } %>
    </tbody></table></div>
</section>
<script type="module" src="js/index.js"></script>
<%@ include file="WEB-INF/footer.jsp" %>
