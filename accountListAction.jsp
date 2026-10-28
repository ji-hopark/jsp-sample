<%@ page contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" session="false" trimDirectiveWhitespaces="true" %>
<%@ include file="WEB-INF/sample.jsp" %>
<%
    response.setHeader("Cache-Control", "no-store");
    response.setHeader("X-Content-Type-Options", "nosniff");
    if (!"GET".equals(request.getMethod()) && !"HEAD".equals(request.getMethod())) {
        response.setStatus(405);
        response.setHeader("Allow", "GET, HEAD");
        out.print("{\"error\":\"GET 요청만 지원합니다.\"}");
        return;
    }
    String keyword=request.getParameter("keyword"), status=request.getParameter("status");
    keyword=keyword==null ? "" : keyword.trim().toLowerCase(Locale.ROOT);
    status=status==null ? "" : status;
    if (keyword.length()>100 || !("".equals(status) || "정상".equals(status) || "거래중지".equals(status) || "해지".equals(status))) {
        response.setStatus(400);
        out.print("{\"error\":\"검색 조건을 확인해 주세요.\"}");
        return;
    }
    out.print("{\"accounts\":[");
    boolean first=true;
    for (Account account : accounts()) {
        if (!keyword.isEmpty() && !account.owner.toLowerCase(Locale.ROOT).contains(keyword) && !account.number.contains(keyword)) continue;
        if (!status.isEmpty() && !account.status.equals(status)) continue;
        if (!first) out.print(",");
        first=false;
        out.print("{\"id\":"+json(account.id)+",\"number\":"+json(account.number)+",\"owner\":"+json(account.owner)
            +",\"product\":"+json(account.product)+",\"status\":"+json(account.status)+",\"balance\":"+account.balance+"}");
    }
    out.print("]}");
%>
