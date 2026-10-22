<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <% if (session.getAttribute("userId")==null || !"MODERATOR".equals(session.getAttribute("role"))) {
        response.sendError(403); return; } String context=request.getContextPath(); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <title>UniLoop | Moderator Dashboard</title>
           <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">
        </head>

        <body>
            <header>
                <div>
                    <h1>UniLoop Moderator</h1>
                    <p>Welcome, <%= session.getAttribute("fullName") %>. Review campus applications and requests.</p>
                </div>
                <form method="post" action="<%= context %>/logout"><button class="logout" type="submit">Logout
                        ↗</button></form>
            </header>
            <main>
                <div class="eyebrow">CAMPUS OPERATIONS</div>
                <h2 class="section-title">Moderation workspace</h2>
                <p class="muted">Student verification and existing request review tools.</p>
                <div class="cards">
                    <section class="card">
                        <div class="icon">✓</div>
                        <h2>Student verification</h2>
                        <p>Check college and student details, then approve or reject pending applications.</p><a
                            class="btn" href="<%= context %>/admin/students">Review applications →</a>
                    </section>
                    <section class="card">
                        <div class="icon">↗</div>
                        <h2>Borrow requests</h2>
                        <p>Review borrowing requests and update pending statuses.</p><a class="btn"
                            href="<%= context %>/admin/requests">Review requests →</a>
                    </section>
                    <section class="card">
                        <div class="icon">▦</div>
                        <h2>Campus items</h2>
                        <p>View the current Lost, Found and Borrow listings.</p><a class="btn"
                            href="<%= context %>/items">View items →</a>
                    </section>
                </div>
                
            </main>
        </body>

        </html>