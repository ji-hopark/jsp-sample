<%@ page contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" session="false" trimDirectiveWhitespaces="true" %>
<%@ include file="WEB-INF/sample.jsp" %>
<%
    response.setHeader("Cache-Control", "no-store");
    response.setHeader("X-Content-Type-Options", "nosniff");
    if (!"GET".equals(request.getMethod()) && !"HEAD".equals(request.getMethod())) {
        response.setStatus(405); response.setHeader("Allow", "GET, HEAD");
        out.print("{\"error\":\"GET 요청만 지원합니다.\"}"); return;
    }
    String keyword=request.getParameter("keyword"), category=request.getParameter("category");
    keyword=keyword==null ? "" : keyword.trim().toLowerCase(Locale.ROOT);
    category=category==null ? "" : category;
    if (keyword.length()>100 || !Arrays.asList("", "중요", "안내", "점검").contains(category)) {
        response.setStatus(400); out.print("{\"error\":\"알림 조회 조건을 확인해 주세요.\"}"); return;
    }
    out.print("{\"notices\":[");
    boolean first=true;
    for (Notice notice : notices()) {
        if (!keyword.isEmpty() && !(notice.title+notice.body).toLowerCase(Locale.ROOT).contains(keyword)) continue;
        if (!category.isEmpty() && !category.equals(notice.category)) continue;
        if (!first) out.print(","); first=false;
        out.print("{\"id\":"+json(notice.id)+",\"date\":"+json(notice.date)+",\"category\":"+json(notice.category)
            +",\"title\":"+json(notice.title)+",\"body\":"+json(notice.body)+",\"href\":"+json(notice.href)
            +",\"linkText\":"+json(notice.linkText)+"}");
    }
    out.print("]}");
%>
