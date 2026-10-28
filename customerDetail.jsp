<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<%@ include file="WEB-INF/sample.jsp" %>
<%
    String pageTitle="고객 상세", active="customers";
    Customer customer=findCustomer(request.getParameter("id"));
    if (customer==null) response.setStatus(404);
%>
<%@ include file="WEB-INF/header.jsp" %>
<% if (customer==null) { %>
<section class="panel error-page"><div class="eyebrow">CUSTOMER NOT FOUND</div><h2>고객을 찾을 수 없습니다.</h2><p>고객 목록에서 확인할 고객을 다시 선택해 주세요.</p><a href="customerList.jsp" class="button primary">고객 목록으로</a></section>
<% } else { Account account=findAccount(customer.accountId); %>
<div class="page-heading">
    <div><div class="eyebrow">CUSTOMER PROFILE</div><h1><%= h(customer.name) %> 고객 정보</h1><p class="subtitle">기본 정보와 연결 계좌를 한곳에서 확인하세요.</p></div>
    <div class="inline-actions no-print"><button id="print-customer" type="button" class="button">고객 정보 인쇄</button><a href="customerList.jsp" class="button">← 고객 목록</a></div>
</div>
<div class="two-column">
    <section class="balance-card"><div class="customer-avatar" aria-hidden="true"><%= h(customer.name.substring(0,1)) %></div><h2 style="font-size:23px;margin-top:16px;color:white"><%= h(customer.name) %></h2><p class="mono" style="margin:6px 0 18px"><%= h(customer.id) %> · 개인 고객</p><span class="badge"><%= h(customer.tier) %> 고객</span><p style="font-size:12px;margin-top:24px">담당자 <%= h(customer.manager) %> · 가입일 <%= h(customer.joined) %></p></section>
    <section class="panel"><div class="panel-head"><h2>기본 정보</h2><span class="badge <%= "정상".equals(customer.state) ? "good" : "확인필요".equals(customer.state) ? "warn" : "neutral" %>"><%= h(customer.state) %></span></div>
        <div class="panel-body"><dl class="detail-grid" style="margin:0">
            <div><dt>휴대전화</dt><dd class="mono"><%= h(customer.phone) %></dd></div><div><dt>이메일</dt><dd class="break-text"><%= h(customer.email) %></dd></div>
            <div><dt>고객 등급</dt><dd><%= h(customer.tier) %></dd></div><div><dt>담당자</dt><dd><%= h(customer.manager) %></dd></div>
            <div><dt>가입일</dt><dd class="mono"><%= h(customer.joined) %></dd></div><div><dt>연결 계좌</dt><dd>1개</dd></div>
        </dl></div>
    </section>
</div>
<% if ("확인필요".equals(customer.state)) { %><div class="alert">연결 계좌가 거래중지 상태인 가상 고객입니다. 계좌 상세에서 상태를 확인해 주세요.</div><% } %>
<section class="panel"><div class="panel-head"><h2>연결 계좌</h2><a class="text-link" href="transactionList.jsp?accountId=<%= h(account.id) %>">고객 거래 내역 보기 ↗</a></div>
    <div class="table-wrap"><table><thead><tr><th>계좌번호</th><th>상품명</th><th>계좌 상태</th><th class="numeric">잔액</th><th>상세</th></tr></thead><tbody>
        <tr><td class="mono"><%= h(account.number) %></td><td><%= h(account.product) %></td><td><span class="badge <%= badge(account.status) %>"><%= h(account.status) %></span></td><td class="numeric"><%= money(account.balance) %>원</td><td><a class="text-link" href="accountDetail.jsp?id=<%= h(account.id) %>">계좌 상세 →</a></td></tr>
    </tbody></table></div>
</section>
<% } %>
<script src="js/customerDetail.js" defer></script>
<%@ include file="WEB-INF/footer.jsp" %>
