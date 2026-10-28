<%@ page contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" session="false" trimDirectiveWhitespaces="true" %>
<%@ include file="WEB-INF/sample.jsp" %>
<%
    response.setHeader("Cache-Control", "no-store");
    response.setHeader("X-Content-Type-Options", "nosniff");
    if (!"GET".equals(request.getMethod()) && !"HEAD".equals(request.getMethod())) {
        response.setStatus(405); response.setHeader("Allow", "GET, HEAD");
        out.print("{\"error\":\"GET 요청만 지원합니다.\"}"); return;
    }
    String keyword=request.getParameter("keyword"), status=request.getParameter("status"), accountId=request.getParameter("accountId");
    keyword=keyword==null ? "" : keyword.trim().toLowerCase(Locale.ROOT);
    status=status==null ? "" : status; accountId=accountId==null ? "" : accountId;
    if (keyword.length()>100 || !Arrays.asList("", "완료", "예약", "실패").contains(status)
            || (!accountId.isEmpty() && findAccount(accountId)==null)) {
        response.setStatus(400); out.print("{\"error\":\"이체 조회 조건을 확인해 주세요.\"}"); return;
    }
    out.print("{\"transfers\":[");
    boolean first=true;
    for (Transfer transfer : transfers()) {
        Account account=findAccount(transfer.accountId);
        if (!keyword.isEmpty() && !(transfer.id+transfer.recipient+account.owner).toLowerCase(Locale.ROOT).contains(keyword)) continue;
        if (!status.isEmpty() && !status.equals(transfer.status)) continue;
        if (!accountId.isEmpty() && !accountId.equals(account.id)) continue;
        if (!first) out.print(","); first=false;
        out.print("{\"id\":"+json(transfer.id)+",\"date\":"+json(transfer.date)+",\"accountId\":"+json(account.id)
            +",\"owner\":"+json(account.owner)+",\"number\":"+json(account.number)+",\"recipient\":"+json(transfer.recipient)
            +",\"bank\":"+json(transfer.bank)+",\"destination\":"+json(transfer.destination)+",\"amount\":"+transfer.amount
            +",\"status\":"+json(transfer.status)+",\"memo\":"+json(transfer.memo)+"}");
    }
    out.print("]}");
%>
