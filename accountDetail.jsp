<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<%@ include file="WEB-INF/sample.jsp" %>
<%
    String pageTitle="계좌 상세", active="accounts";
    Account account=findAccount(request.getParameter("id"));
    if (account==null) response.setStatus(404);
%>
<%@ include file="WEB-INF/header.jsp" %>
<% if (account==null) { %>
<section class="panel error-page"><div class="eyebrow">ACCOUNT NOT FOUND</div><h2>계좌를 찾을 수 없습니다.</h2><p>계좌 목록에서 확인할 계좌를 다시 선택해 주세요.</p><a href="accountList.jsp" class="button primary">계좌 목록으로</a></section>
<% } else {
    List<Entry> accountEntries=new ArrayList<Entry>();
    for (Entry entry : entries()) if (account.id.equals(entry.accountId)) accountEntries.add(entry);
%>
<div class="page-heading"><div><div class="eyebrow">ACCOUNT DETAIL</div><h1><%= h(account.owner) %>님의 계좌</h1><p class="subtitle">계좌의 기본 정보와 최근 거래를 확인하세요.</p></div><a href="accountList.jsp" class="button">← 계좌 목록</a></div>
<div class="two-column">
    <section class="balance-card"><div style="display:flex;justify-content:space-between;gap:10px"><span style="font-size:12px"><%= h(account.product) %></span><span class="badge"><%= h(account.status) %></span></div><p class="mono" style="margin-top:24px"><%= h(account.number) %></p><div class="stat-value"><%= money(account.balance) %><small>원</small></div><p style="font-size:11px;color:#9cb3a3;margin-top:18px">2026.10.28 기준 잔액 · 가상 계좌</p><div class="inline-actions"><button type="button" class="button" id="copy-account" data-number="<%= h(account.number) %>">계좌번호 복사</button><span id="copy-status" role="status" aria-live="polite"></span></div></section>
    <section class="panel"><div class="panel-head"><h2>계좌 기본 정보</h2></div><div class="panel-body"><dl class="detail-grid" style="margin:0"><div><dt>예금주</dt><dd><%= h(account.owner) %></dd></div><div><dt>계좌 상태</dt><dd><span class="badge <%= badge(account.status) %>"><%= h(account.status) %></span></dd></div><div><dt>개설일</dt><dd class="mono"><%= h(account.opened) %></dd></div><div><dt>통화</dt><dd>KRW · 대한민국 원</dd></div></dl></div></section>
</div>
<p class="related-link"><a class="text-link" href="customerDetail.jsp?id=<%= h(customerForAccount(account.id).id) %>">예금주 고객 정보 보기 ↗</a></p>
<section class="panel"><div class="panel-head"><div><h2>최근 거래</h2><p class="panel-sub">해당 계좌의 표본 거래 <%= accountEntries.size() %>건</p></div><a class="text-link" href="transactionList.jsp?accountId=<%= h(account.id) %>">거래 내역에서 보기 ↗</a></div>
    <div class="table-wrap"><table><thead><tr><th>거래일</th><th>거래 내용</th><th>구분</th><th class="numeric">거래 금액</th><th class="numeric">거래 후 잔액</th></tr></thead><tbody>
    <% if (accountEntries.isEmpty()) { %><tr><td class="empty" colspan="5">표시할 거래 내역이 없습니다.</td></tr><% } %>
    <% for (Entry entry : accountEntries) { %>
    <tr><td class="mono"><%= h(entry.date) %></td><td><%= h(entry.name) %></td><td><span class="badge <%= "입금".equals(entry.type) ? "good" : "neutral" %>"><%= h(entry.type) %></span></td><td class="numeric <%= "입금".equals(entry.type) ? "deposit" : "withdrawal" %>"><%= "입금".equals(entry.type) ? "+" : "−" %><%= money(entry.amount) %>원</td><td class="numeric"><%= money(entry.balance) %>원</td></tr>
    <% } %>
    </tbody></table></div>
</section>
<% } %>
<script src="js/accountDetail.js" defer></script>
<%@ include file="WEB-INF/footer.jsp" %>
