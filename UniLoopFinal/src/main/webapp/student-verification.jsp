<%@ page contentType="text/html;charset=UTF-8" language="java" %>
  <%@ page import="java.util.List" %>
    <%@ page import="jakarta.servlet.http.HttpServletResponse" %>
      <%! private String esc(String value) { if (value==null) return "—" ; return value.replace("&", "&amp;"
        ).replace("<", "&lt;" ) .replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#39;");
        }
        %>
        <% Object roleObj=session.getAttribute("role"); boolean staff=session.getAttribute("userId") !=null &&
          ("ADMIN".equals(roleObj) || "MODERATOR" .equals(roleObj)); if (!staff) {
          response.sendError(HttpServletResponse.SC_FORBIDDEN); return; } String context=request.getContextPath();
          List<String[]> students = (List<String[]>) request.getAttribute("students");
            %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
              <meta charset="UTF-8">
              <meta name="viewport" content="width=device-width, initial-scale=1">
              <title>UniLoop | Student Verification</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">
            </head>

            <body>
              <header>
                <div>
                  <h1>UniLoop · Student Verification</h1>
                  <p>Review student details before enabling campus access.</p>
                </div>
                <a class="btn back" href="<%= " ADMIN".equals(roleObj) ? context + "/admin/dashboard" : context
                  + "/moderator/dashboard" %>">← Dashboard</a>
              </header>
              <main>
                <div class="topline">
                  <div>
                    <h2>Pending applications</h2>
                    <p class="muted">Only student accounts awaiting review appear here.</p>
                  </div><span class="muted">Reviewer: <%= esc(String.valueOf(session.getAttribute("fullName"))) %>
                      </span>
                </div>
                <% if ("1".equals(request.getParameter("updated"))) { %>
                  <div class="banner">Application status updated successfully.</div>
                  <% } %>
                    <div class="list">
                      <% if (students==null || students.isEmpty()) { %>
                        <div class="empty">
                          <h3>All caught up!</h3>
                          <p>No pending student applications right now.</p>
                        </div>
                        <% } else { for (String[] s : students) { %>
                          <article class="student">
                            <div class="student-head">
                              <div>
                                <h3>
                                  <%= esc(s[1]) %>
                                </h3>
                                <div class="muted">
                                  <%= esc(s[2]) %> · Application #<%= esc(s[0]) %>
                                </div>
                              </div><span class="status">PENDING REVIEW</span>
                            </div>
                            <div class="details">
                              <div class="detail"><small>Contact number</small><strong>
                                  <%= esc(s[3]) %>
                                </strong></div>
                              <div class="detail"><small>College / institution</small><strong>
                                  <%= esc(s[4]) %>
                                </strong></div>
                              <div class="detail"><small>Department</small><strong>
                                  <%= esc(s[5]) %>
                                </strong></div>
                              <div class="detail"><small>Course</small><strong>
                                  <%= esc(s[6]) %>
                                </strong></div>
                              <div class="detail"><small>Academic year</small><strong>
                                  <%= esc(s[7]) %>
                                </strong></div>
                              <div class="detail"><small>Student ID / roll number</small><strong>
                                  <%= esc(s[8]) %>
                                </strong></div>
                              <div class="detail"><small>Campus / area</small><strong>
                                  <%= esc(s[9]) %>
                                </strong></div>
                              <div class="detail"><small>Submitted</small><strong>
                                  <%= esc(s[11]) %>
                                </strong></div>
                            </div>
                            <div class="actions">
                              <form method="post" action="<%= context %>/admin/students"
                                onsubmit="return confirm('Approve this student account?');">
                                <input type="hidden" name="studentId" value="<%= esc(s[0]) %>"><input type="hidden"
                                  name="action" value="APPROVED">
                                <button class="btn approve" type="submit">✓ Approve student</button>
                              </form>
                              <form method="post" action="<%= context %>/admin/students"
                                onsubmit="return confirm('Reject this student application?');">
                                <input type="hidden" name="studentId" value="<%= esc(s[0]) %>"><input type="hidden"
                                  name="action" value="REJECTED">
                                <input type="hidden" name="rejectionReason"
                                  value="Please contact your college administrator for details.">
                                <button class="btn reject" type="submit">✕ Reject application</button>
                              </form>
                            </div>
                          </article>
                          <% } } %>
                    </div>
              </main>
            </body>

            </html>