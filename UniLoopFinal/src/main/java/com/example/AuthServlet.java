package com.example;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;
import java.util.Locale;
import java.util.regex.Pattern;

import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/auth")
public class AuthServlet extends HttpServlet {

    private static final Pattern PHONE_PATTERN =
            Pattern.compile("^[0-9+()\\-\\s]{7,25}$");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if ("1".equals(request.getParameter("register"))) {
            request.setAttribute("openRegister", Boolean.TRUE);
        }
        request.getRequestDispatcher("/auth.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = trim(request.getParameter("action"));
        String email = trim(request.getParameter("email")).toLowerCase(Locale.ROOT);
        String password = request.getParameter("password");

        if (email.isBlank() || password == null || password.isBlank()) {
            forwardError(request, response, "Email and password are required.", "register".equals(action));
            return;
        }

        if (email.length() > 150 || password.length() > 72) {
            forwardError(request, response, "Email or password is too long.", "register".equals(action));
            return;
        }

        if ("register".equals(action)) {
            register(request, response, email, password);
        } else if ("login".equals(action)) {
            login(request, response, email, password);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action.");
        }
    }

    private void register(HttpServletRequest request, HttpServletResponse response,
                          String email, String password)
            throws ServletException, IOException {

        String fullName = trim(request.getParameter("fullName"));
        String phone = trim(request.getParameter("phone"));
        String college = trim(request.getParameter("collegeName"));
        String department = trim(request.getParameter("department"));
        String course = trim(request.getParameter("course"));
        String academicYear = trim(request.getParameter("academicYear"));
        String studentId = trim(request.getParameter("studentId"));
        String campusLocation = trim(request.getParameter("campusLocation"));

        if (fullName.isBlank() || fullName.length() > 100
                || password.length() < 8
                || phone.isBlank() || !PHONE_PATTERN.matcher(phone).matches()
                || college.isBlank() || college.length() > 180
                || department.isBlank() || department.length() > 120
                || course.isBlank() || course.length() > 120
                || academicYear.isBlank() || academicYear.length() > 40
                || studentId.isBlank() || studentId.length() > 80
                || campusLocation.isBlank() || campusLocation.length() > 180) {
            forwardError(request, response,
                    "Please complete every student field correctly. Password must be at least 8 characters.",
                    true);
            return;
        }

        String sql = "INSERT INTO users " +
                "(full_name, email, password_hash, role, phone, college_name, department, " +
                "course, academic_year, student_id, campus_location, approval_status) " +
                "VALUES (?, ?, ?, 'STUDENT', ?, ?, ?, ?, ?, ?, ?, 'PENDING')";

        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, fullName);
            ps.setString(2, email);
            ps.setString(3, BCrypt.hashpw(password, BCrypt.gensalt()));
            ps.setString(4, phone);
            ps.setString(5, college);
            ps.setString(6, department);
            ps.setString(7, course);
            ps.setString(8, academicYear);
            ps.setString(9, studentId);
            ps.setString(10, campusLocation);
            ps.executeUpdate();

            request.setAttribute("success",
                    "Application submitted successfully. You can log in after Admin or Moderator approval.");
            request.setAttribute("openRegister", Boolean.TRUE);
            request.getRequestDispatcher("/auth.jsp").forward(request, response);

        } catch (SQLException e) {
            if ("23000".equals(e.getSQLState())) {
                forwardError(request, response,
                        "This email is already registered. Check your details or contact the campus administrator.",
                        true);
            } else {
                throw new ServletException("Registration failed. Confirm the database migration has been run.", e);
            }
        }
    }

    private void login(HttpServletRequest request, HttpServletResponse response,
                       String email, String password)
            throws ServletException, IOException {

        String sql = "SELECT id, full_name, password_hash, role, approval_status " +
                "FROM users WHERE email = ?";

        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next() || !BCrypt.checkpw(password, rs.getString("password_hash"))) {
                    forwardError(request, response, "Incorrect email or password.", false);
                    return;
                }

                String role = rs.getString("role");
                String status = rs.getString("approval_status");

                // Approval applies to student accounts. Admin/Moderator accounts remain usable.
                if ("STUDENT".equals(role) && !"APPROVED".equals(status)) {
                    if ("REJECTED".equals(status)) {
                        forwardError(request, response,
                                "Your student application was not approved. Please contact your college administrator.",
                                false);
                    } else {
                        forwardError(request, response,
                                "Your account is awaiting Admin or Moderator verification. Please try again after approval.",
                                false);
                    }
                    return;
                }

                HttpSession session = request.getSession(true);
                request.changeSessionId();
                session.setAttribute("userId", rs.getInt("id"));
                session.setAttribute("fullName", rs.getString("full_name"));
                session.setAttribute("role", role);

                if ("ADMIN".equals(role)) {
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                } else if ("MODERATOR".equals(role)) {
                    response.sendRedirect(request.getContextPath() + "/moderator/dashboard");
                } else {
                    response.sendRedirect(request.getContextPath() + "/items");
                }
            }
        } catch (SQLException e) {
            throw new ServletException("Login failed.", e);
        }
    }

    private static String trim(String value) {
        return value == null ? "" : value.trim();
    }

    private void forwardError(HttpServletRequest request, HttpServletResponse response,
                              String message, boolean openRegister)
            throws ServletException, IOException {
        request.setAttribute("error", message);
        request.setAttribute("openRegister", openRegister);
        request.getRequestDispatcher("/auth.jsp").forward(request, response);
    }
}
