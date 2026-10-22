<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.util.List" %>

        <%! private String esc(String s) { if (s==null || "null" .equals(s)) return "—" ; return s.replace("&", "&amp;"
            ) .replace("<", "&lt;" ) .replace(">", "&gt;")
            .replace("\"", "&quot;")
            .replace("'", "&#39;");
            }
            %>

            <% List<String[]> charges =
                (List<String[]>) request.getAttribute("charges");

                    if (charges == null) {
                    response.sendRedirect(request.getContextPath() + "/charges");
                    return;
                    }
                    %>

                    <!DOCTYPE html>
                    <html lang="en">

                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1">
                        <title>UniLoop | My Charges</title>

                        <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">
                    </head>

                    <body>
                        <header>
                            <h1>My Borrowing Charges</h1>
                            <p>Rent estimates and late-return charges</p>
                            <a href="<%= request.getContextPath() %>/items">
                                Back to items
                            </a>
                        </header>

                        <main>
                            <section class="panel">
                                <h2>Charge history</h2>

                                <p class="note">
                                    Estimated rent is calculated using the daily rate and requested
                                    duration. Actual late fees depend on the configured return policy.
                                    Online payment processing is not connected by this page.
                                </p>

                                <div class="table-wrap">
                                    <table>
                                        <thead>
                                            <tr>
                                                <th>Item</th>
                                                <th>Days</th>
                                                <th>Rate/day</th>
                                                <th>Estimated rent</th>
                                                <th>Paid</th>
                                                <th>Late fee</th>
                                                <th>Status</th>
                                                <th>Due</th>
                                                <th>Returned</th>
                                            </tr>
                                        </thead>

                                        <tbody>
                                            <% if (charges.isEmpty()) { %>
                                                <tr>
                                                    <td colspan="9">No borrowing charges yet.</td>
                                                </tr>
                                                <% } else { for (String[] c : charges) { %>
                                                    <tr>
                                                        <td>
                                                            <%= esc(c[1]) %>
                                                        </td>
                                                        <td>
                                                            <%= esc(c[2]) %>
                                                        </td>
                                                        <td>₹<%= esc(c[3]) %>
                                                        </td>
                                                        <td>₹<%= esc(c[4]) %>
                                                        </td>
                                                        <td>₹<%= esc(c[5]) %>
                                                        </td>
                                                        <td>₹<%= esc(c[6]) %>
                                                        </td>
                                                        <td>
                                                            <%= esc(c[7]) %>
                                                        </td>
                                                        <td>
                                                            <%= esc(c[8]) %>
                                                        </td>
                                                        <td>
                                                            <%= esc(c[9]) %>
                                                        </td>
                                                    </tr>
                                                    <% } } %>
                                        </tbody>
                                    </table>
                                </div>
                            </section>
                        </main>
                    </body>

                    </html>