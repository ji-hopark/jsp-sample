<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<%@ include file="WEB-INF/sample.jsp" %>
<% String pageTitle="계좌 관리", active="accounts"; %>
<%@ include file="WEB-INF/header.jsp" %>
<div class="page-heading"><div><div class="eyebrow">ACCOUNTS</div><h1>계좌 관리</h1><p class="subtitle">계좌를 조회하고 상세 정보를 확인하세요.</p></div><a href="transactionList.jsp" class="button">거래 내역 보기 ↗</a></div>
<section class="panel">
    <div class="panel-head"><div><h2>계좌 목록</h2><p class="panel-sub">예금주 또는 계좌번호로 검색할 수 있습니다.</p></div><span class="badge good">조회 전용</span></div>
    <form id="search-form" class="filters" action="accountList.jsp" method="get" role="search">
        <div class="field wide"><label for="keyword">검색어</label><input id="keyword" name="keyword" maxlength="100" placeholder="예금주 또는 계좌번호 입력" value="<%= h(request.getParameter("keyword")) %>"></div>
        <div class="field">
            <label for="status">계좌 상태</label>
            <select id="status" name="status">
                <option value="">전체 상태</option>
                <option value="정상" <%= "정상".equals(request.getParameter("status")) ? "selected" : "" %>>정상</option>
                <option value="거래중지" <%= "거래중지".equals(request.getParameter("status")) ? "selected" : "" %>>거래중지</option>
                <option value="해지" <%= "해지".equals(request.getParameter("status")) ? "selected" : "" %>>해지</option>
            </select>
        </div>
        <button class="button primary" type="submit">계좌 조회</button><button class="button" type="reset">초기화</button>
    </form>
    <div class="table-wrap"><table aria-label="계좌 검색 결과"><thead><tr><th>계좌번호</th><th>예금주</th><th>상품명</th><th>상태</th><th class="numeric">잔액</th><th>상세</th></tr></thead><tbody id="account-rows"><tr><td class="empty" colspan="6">계좌를 불러오는 중입니다.</td></tr></tbody></table></div>
    <div class="table-foot"><span id="result-count" role="status" aria-live="polite">조회 중</span><span>가상 데이터 · 전체 결과 표시</span></div>
</section>
<noscript><div class="alert">계좌 검색에는 JavaScript가 필요합니다. 대시보드의 주요 계좌 링크에서 상세 화면을 확인할 수 있습니다.</div></noscript>
<script src="js/accountList.js" defer></script>
<%@ include file="WEB-INF/footer.jsp" %>
