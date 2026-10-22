<%@ page import="jakarta.servlet.http.HttpServletResponse" %>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <% String role=(String) session.getAttribute("role"); if (session.getAttribute("userId")==null ||
            !"ADMIN".equals(role)) { response.sendError(HttpServletResponse.SC_FORBIDDEN); return; } String
            context=request.getContextPath(); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1">
                <title>UniLoop | Admin Dashboard</title>
               <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">
            </head>

            <body>
                <header>
                    <div>
                        <h1>UniLoop Admin</h1>
                        <p>Welcome back, <%= session.getAttribute("fullName") %>. Manage your campus community.</p>
                    </div>
                    <form method="post" action="<%= context %>/logout"><button class="logout" type="submit">Logout
                            ↗</button></form>
                </header>
                <main>
                    <div class="eyebrow">CONTROL CENTER</div>
                    <h2 class="section-title">Platform management</h2>
                    <p class="muted">Review student access and manage the existing campus workflows.</p>
                    <div class="cards">
                        <section class="card">
                            <div class="icon">✓</div>
                            <h2>Student verification</h2>
                            <p>Review student ID, college, department, course and contact information. Approve or reject
                                applications.</p><a class="btn" href="<%= context %>/admin/students">Review applications
                                →</a>
                        </section>
                        <section class="card">
                            <div class="icon">↗</div>
                            <h2>Borrow requests</h2>
                            <p>Review incoming borrowing requests and update pending request statuses.</p><a class="btn"
                                href="<%= context %>/admin/requests">Manage requests →</a>
                        </section>
                        <section class="card">
                            <div class="icon">▦</div>
                            <h2>Campus items</h2>
                            <p>Open the existing item listing for Borrow, Lost and Found records.</p><a class="btn"
                                href="<%= context %>/items">View items →</a>
                        </section>
                    </div>
                    <div class="note"><strong>Next upgrade stage:</strong> database-driven analytics, share listings,
                        charges and late-return tracking will be added after the registration and approval workflow is
                        connected and tested.</div>
                </main>
            </body>

            </html>