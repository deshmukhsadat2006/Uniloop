<%@ page contentType="text/html;charset=UTF-8" language="java" %>
  <%! private String esc(String value) { if (value==null) return "" ; return value.replace("&", "&amp;"
    ).replace("<", "&lt;" ) .replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#39;");
    }
    %>
    <% boolean openRegister=Boolean.TRUE.equals(request.getAttribute("openRegister")); String
      context=request.getContextPath(); %>
      <!DOCTYPE html>
      <html lang="en">

      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>UniLoop | Student Access</title>
       <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">
      </head>

      <body>
        <header class="top">
          <div class="brand">Uni<span>Loop</span></div>
          <div class="tag">Your campus. Shared smarter.</div>
        </header>
        <div class="shell">
          <aside class="intro">
            <div>
              <span class="pill">CAMPUS COMMUNITY PLATFORM</span>
              <h1>Borrow more.<br>Waste less.</h1>
              <p>Find useful campus items, share what you own, and help your college community stay connected.</p>
              <div class="features">
                <div class="feature">↗ Borrow &amp; share essentials</div>
                <div class="feature">⌖ College-aware listings</div>
                <div class="feature">✓ Student verification</div>
                <div class="feature">◎ Lost &amp; Found campus-wide</div>
              </div>
            </div>
            <p class="hint">Student accounts become active after an Admin or Moderator verifies the submitted details.
            </p>
          </aside>
          <main class="panel">
            <h2>Welcome to UniLoop</h2>
            <p class="sub">Sign in to your campus community or submit a student application.</p>
            <% if (request.getAttribute("error") !=null) { %>
              <div class="notice error">
                <%= esc(String.valueOf(request.getAttribute("error"))) %>
              </div>
              <% } %>
                <% if (request.getAttribute("success") !=null) { %>
                  <div class="notice success">
                    <%= esc(String.valueOf(request.getAttribute("success"))) %>
                  </div>
                  <% } %>
                    <div class="tabs">
                      <button type="button" id="loginTab" class="<%= openRegister ? "" : " active" %>"
                        onclick="showForm('login')">Login</button>
                      <button type="button" id="registerTab" class="<%= openRegister ? " active" : "" %>"
                        onclick="showForm('register')">Student Registration</button>
                    </div>
                    <form id="loginForm" method="post" action="<%= context %>/auth" <%=openRegister ? "hidden" : "" %>>
                      <input type="hidden" name="action" value="login">
                      <div class="field"><label for="loginEmail">Email address</label><input id="loginEmail"
                          type="email" name="email" maxlength="150" placeholder="you@example.com"
                          autocomplete="username" required></div>
                      <div class="field"><label for="loginPassword">Password</label><input id="loginPassword"
                          type="password" name="password" maxlength="72" placeholder="Your password"
                          autocomplete="current-password" required></div>
                          <br>
                      <button class="primary" type="submit">Sign in to UniLoop →</button>
                      <p class="hint">New student? Choose Student Registration above. Access is enabled after
                        verification.</p>
                    </form>
                    <form id="registerForm" method="post" action="<%= context %>/auth" <%=openRegister ? "" : "hidden"
                      %>>
                      <input type="hidden" name="action" value="register">
                      <div class="field"><label for="fullName">Full name</label><input id="fullName" name="fullName"
                          maxlength="100" placeholder="As shown on student ID" required></div>
                      <div class="grid">
                        <div class="field"><label for="registerEmail">College email / email</label><input
                            id="registerEmail" type="email" name="email" maxlength="150" placeholder="you@example.com"
                            required></div>
                        <div class="field"><label for="phone">Contact number</label><input id="phone" name="phone"
                            maxlength="25" inputmode="tel" placeholder="+91 98765 43210" required></div>
                      </div>
                      <div class="field"><label for="collegeName">College / institution name</label><input
                          id="collegeName" name="collegeName" maxlength="180" placeholder="Your college name" required>
                      </div>
                      <div class="grid">
                        <div class="field"><label for="department">Department</label><input id="department"
                            name="department" maxlength="120" placeholder="Computer Engineering" required></div>
                        <div class="field"><label for="course">Course / program</label><input id="course" name="course"
                            maxlength="120" placeholder="B.E. / B.Tech / Diploma" required></div>
                      </div>
                      <div class="grid">
                        <div class="field"><label for="academicYear">Academic year</label>
                          <select id="academicYear" name="academicYear" required>
                            <option value="">Select year</option>
                            <option>First Year</option>
                            <option>Second Year</option>
                            <option>Third Year</option>
                            <option>Final Year</option>
                            <option>Postgraduate</option>
                            <option>Other</option>
                          </select>
                        </div>
                        <div class="field"><label for="studentId">Student ID / roll number</label><input id="studentId"
                            name="studentId" maxlength="80" placeholder="College-issued ID" required></div>
                      </div>
                      <div class="field"><label for="campusLocation">Campus / area location</label><input
                          id="campusLocation" name="campusLocation" maxlength="180"
                          placeholder="Campus name, building or area" required></div>
                      <div class="field"><label for="registerPassword">Create password (minimum 8
                          characters)</label><input id="registerPassword" type="password" name="password" minlength="8"
                          maxlength="72" autocomplete="new-password" required></div>
                      <div class="divider"></div>
                      <p class="hint">Your details will be reviewed by an Admin or Moderator. You cannot sign in to
                        student features until your application is approved.</p>
                      <button class="primary" type="submit">Submit for verification →</button>
                    </form>
                    <div class="footer">UniLoop · Borrow, Share &amp; Find on Campus</div>
          </main>
        </div>
        <script>
          function showForm(mode) {
            const login = mode === "login";
            document.getElementById("loginForm").hidden = !login;
            document.getElementById("registerForm").hidden = login;
            document.getElementById("loginTab").classList.toggle("active", login);
            document.getElementById("registerTab").classList.toggle("active", !login);
          }
        </script>
      </body>

      </html>