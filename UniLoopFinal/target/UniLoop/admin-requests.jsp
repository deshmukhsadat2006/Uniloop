
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>

<%!
    private String esc(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
%>

<%
    List<String[]> requests =
        (List<String[]>) request.getAttribute("requests");

    if (requests == null) {
        response.sendRedirect(
            request.getContextPath() + "/admin/requests");
        return;
    }

    String updated = request.getParameter("updated");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>UniLoop - Moderator Dashboard</title>

   <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">
</head>

<body>
<header>
    <h1>UniLoop</h1>
    Moderator Dashboard · Borrow Requests
</header>

<main>
    <section class="panel">
        <h2>Borrow Requests</h2>
        <p>Review requests and update their status.</p>

        <% if ("1".equals(updated)) { %>
            <p class="notice">Request status updated successfully!</p>
        <% } %>

        <p>
            Total requests: <b><%= requests.size() %></b>
        </p>

        <% if (requests.isEmpty()) { %>
            <p>No borrow requests yet.</p>
        <% } else {
            for (String[] r : requests) { %>

                <article class="request">
                    <span class="status"><%= esc(r[3]) %></span>

                    <h3><%= esc(r[2]) %></h3>

                    <p>
                        <b>Requested by:</b>
                        <%= esc(r[1]) %>
                    </p>

                    <p class="muted">
                        Request ID: <%= esc(r[0]) %>
                    </p>

                    <p class="muted">
                        Submitted: <%= esc(r[4]) %>
                    </p>

                    <% if ("PENDING".equals(r[3])) { %>
                        <div class="actions">
                            <form method="post"
                                  action="<%= request.getContextPath() %>/admin/requests"
                                  onsubmit="return confirm('Approve this request?');">
                                <input type="hidden"
                                       name="requestId"
                                       value="<%= esc(r[0]) %>">
                                <input type="hidden"
                                       name="action"
                                       value="APPROVED">
                                <button class="approve" type="submit">
                                    Approve
                                </button>
                            </form>

                            <form method="post"
                                  action="<%= request.getContextPath() %>/admin/requests"
                                  onsubmit="return confirm('Reject this request?');">
                                <input type="hidden"
                                       name="requestId"
                                       value="<%= esc(r[0]) %>">
                                <input type="hidden"
                                       name="action"
                                       value="REJECTED">
                                <button class="reject" type="submit">
                                    Reject
                                </button>
                            </form>
                        </div>
                    <% } %>
                </article>

        <%  }
           } %>

        <p style="margin-top: 24px;">
            <a href="<%= request.getContextPath() %>/items">
                ← Back to UniLoop
            </a>
        </p>
    </section>
</main>
</body>
</html>
