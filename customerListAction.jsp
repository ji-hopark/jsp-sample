<%@ page contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" session="false" trimDirectiveWhitespaces="true" %>
<%@ include file="WEB-INF/sample.jsp" %>
<%
    response.setHeader("Cache-Control", "no-store");
    response.setHeader("X-Content-Type-Options", "nosniff");
    if (!"GET".equals(request.getMethod()) && !"HEAD".equals(request.getMethod())) {
        response.setStatus(405); response.setHeader("Allow", "GET, HEAD");
        out.print("{\"error\":\"GET 요청만 지원합니다.\"}"); return;
    }
    String keyword=request.getParameter("keyword"), tier=request.getParameter("tier"), state=request.getParameter("state");
    keyword=keyword==null ? "" : keyword.trim().toLowerCase(Locale.ROOT);
    tier=tier==null ? "" : tier; state=state==null ? "" : state;
    if (keyword.length()>100 || !Arrays.asList("", "일반", "우수", "프리미엄").contains(tier)
            || !Arrays.asList("", "정상", "확인필요", "휴면").contains(state)) {
        response.setStatus(400); out.print("{\"error\":\"고객 조회 조건을 확인해 주세요.\"}"); return;
    }
    out.print("{\"customers\":[");
    boolean first=true;
    for (Customer customer : customers()) {
        if (!keyword.isEmpty() && !(customer.name+customer.id).toLowerCase(Locale.ROOT).contains(keyword)) continue;
        if (!tier.isEmpty() && !tier.equals(customer.tier)) continue;
        if (!state.isEmpty() && !state.equals(customer.state)) continue;
        if (!first) out.print(","); first=false;
        out.print("{\"id\":"+json(customer.id)+",\"name\":"+json(customer.name)+",\"tier\":"+json(customer.tier)
            +",\"phone\":"+json(customer.phone)+",\"manager\":"+json(customer.manager)+",\"state\":"+json(customer.state)+"}");
    }
    out.print("]}");
%>
