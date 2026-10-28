<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<%@ include file="WEB-INF/sample.jsp" %>
<%
    String pageTitle="거래 내역", active="transactions";
    String accountId=request.getParameter("accountId"), type=request.getParameter("type");
    String from=request.getParameter("from"), to=request.getParameter("to");
    accountId=accountId==null ? "" : accountId;
    type=type==null ? "" : type;
    from=from==null ? "2026-10-01" : from;
    to=to==null ? "2026-10-28" : to;
    String filterError=null;
    LocalDate fromDate=null, toDate=null;
    try {
        if (!from.isEmpty()) fromDate=LocalDate.parse(from);
        if (!to.isEmpty()) toDate=LocalDate.parse(to);
        if (fromDate!=null && toDate!=null && fromDate.isAfter(toDate)) filterError="시작일은 종료일보다 늦을 수 없습니다.";
    } catch (java.time.format.DateTimeParseException exception) { filterError="조회 날짜를 올바르게 입력해 주세요."; }
    if (!("".equals(type) || "입금".equals(type) || "출금".equals(type))) filterError="거래 구분을 확인해 주세요.";
    if (!accountId.isEmpty() && findAccount(accountId)==null) filterError="존재하지 않는 계좌입니다.";
    List<Entry> filtered=new ArrayList<Entry>();
    long deposits=0, withdrawals=0;
    if (filterError==null) {
        for (Entry entry : entries()) {
            LocalDate date=LocalDate.parse(entry.date);
            if (!accountId.isEmpty() && !accountId.equals(entry.accountId)) continue;
            if (!type.isEmpty() && !type.equals(entry.type)) continue;
            if (fromDate!=null && date.isBefore(fromDate)) continue;
            if (toDate!=null && date.isAfter(toDate)) continue;
            filtered.add(entry);
            if ("입금".equals(entry.type)) deposits+=entry.amount; else withdrawals+=entry.amount;
        }
    } else response.setStatus(400);
%>
<%@ include file="WEB-INF/header.jsp" %>
<div class="page-heading"><div><div class="eyebrow">TRANSACTIONS</div><h1>거래 내역</h1><p class="subtitle">계좌와 기간을 선택해 입출금 내역을 조회하세요.</p></div><button type="button" class="button" id="export-transactions" <%= filtered.isEmpty() ? "disabled" : "" %>>조회 결과 내려받기 ↓</button></div>
<% if (filterError!=null) { %><div class="alert" role="alert"><%= h(filterError) %></div><% } %>
<div class="stats">
    <section class="stat"><div class="stat-label">조회 거래 <span class="stat-icon" aria-hidden="true">⇄</span></div><div class="stat-value"><%= filtered.size() %><small>건</small></div><p class="stat-foot">선택한 조건에 해당하는 거래</p></section>
    <section class="stat featured"><div class="stat-label">입금 합계 <span class="stat-icon" aria-hidden="true">↙</span></div><div class="stat-value"><%= money(deposits) %><small>원</small></div><p class="stat-foot">조회 결과의 입금 금액 합계</p></section>
    <section class="stat"><div class="stat-label">출금 합계 <span class="stat-icon" aria-hidden="true">↗</span></div><div class="stat-value"><%= money(withdrawals) %><small>원</small></div><p class="stat-foot">조회 결과의 출금 금액 합계</p></section>
</div>
<section class="panel">
    <form id="transaction-form" class="filters" action="transactionList.jsp" method="get" role="search">
        <div class="field"><label for="accountId">계좌 선택</label><select id="accountId" name="accountId"><option value="">전체 계좌</option><% for (Account account : accounts()) { %><option value="<%= h(account.id) %>" <%= account.id.equals(accountId) ? "selected" : "" %>><%= h(account.owner) %> · <%= h(account.number) %></option><% } %></select></div>
        <div class="field"><label for="from">시작일</label><input type="date" id="from" name="from" value="<%= h(from) %>"></div>
        <div class="field"><label for="to">종료일</label><input type="date" id="to" name="to" value="<%= h(to) %>"></div>
        <div class="field"><label for="type">거래 구분</label><select id="type" name="type"><option value="">전체</option><option value="입금" <%= "입금".equals(type) ? "selected" : "" %>>입금</option><option value="출금" <%= "출금".equals(type) ? "selected" : "" %>>출금</option></select></div>
        <button class="button primary" type="submit">조회</button><a class="button" href="transactionList.jsp">초기화</a>
    </form>
    <div class="table-wrap"><table><thead><tr><th>거래일</th><th>계좌 / 예금주</th><th>거래 내용</th><th>구분</th><th class="numeric">거래 금액</th><th class="numeric">거래 후 잔액</th></tr></thead><tbody>
    <% if (filtered.isEmpty()) { %><tr><td class="empty" colspan="6"><%= filterError==null ? "조회 조건에 맞는 거래가 없습니다." : "조회 조건을 수정한 후 다시 조회해 주세요." %></td></tr><% } %>
    <% for (Entry entry : filtered) { Account account=findAccount(entry.accountId); %>
    <tr><td class="mono"><%= h(entry.date) %></td><td><a class="text-link" href="accountDetail.jsp?id=<%= h(account.id) %>"><%= h(account.owner) %></a><div class="secondary mono"><%= h(account.number) %></div></td><td><%= h(entry.name) %></td><td><span class="badge <%= "입금".equals(entry.type) ? "good" : "neutral" %>"><%= h(entry.type) %></span></td><td class="numeric <%= "입금".equals(entry.type) ? "deposit" : "withdrawal" %>"><%= "입금".equals(entry.type) ? "+" : "−" %><%= money(entry.amount) %>원</td><td class="numeric"><%= money(entry.balance) %>원</td></tr>
    <% } %>
    </tbody></table></div>
    <div class="table-foot"><span>총 <%= filtered.size() %>건</span><span>거래일 최신순 · 전체 결과 표시</span></div>
</section>
<script type="module" src="js/transactionList.js"></script>
<%@ include file="WEB-INF/footer.jsp" %>
