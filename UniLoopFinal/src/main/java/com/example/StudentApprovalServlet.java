package com.example;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/admin/students")
public class StudentApprovalServlet extends HttpServlet {

    private boolean isStaff(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) return false;
        Object role = session.getAttribute("role");
        return "ADMIN".equals(role) || "MODERATOR".equals(role);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isStaff(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        List<String[]> students = new ArrayList<>();
        String sql = "SELECT id, full_name, email, phone, college_name, department, " +
                "course, academic_year, student_id, campus_location, approval_status, created_at " +
                "FROM users WHERE role = 'STUDENT' AND approval_status = 'PENDING' ORDER BY id ASC";

        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                students.add(new String[] {
                        String.valueOf(rs.getInt("id")),
                        rs.getString("full_name"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getString("college_name"),
                        rs.getString("department"),
                        rs.getString("course"),
                        rs.getString("academic_year"),
                        rs.getString("student_id"),
                        rs.getString("campus_location"),
                        rs.getString("approval_status"),
                        safeTimestamp(rs.getTimestamp("created_at"))
                });
            }

            request.setAttribute("students", students);
            request.getRequestDispatcher("/student-verification.jsp").forward(request, response);
        } catch (SQLException e) {
            // Some existing schemas may not have created_at; add it or remove it from this query.
            throw new ServletException("Could not load student applications. Check the users table schema.", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isStaff(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        request.setCharacterEncoding("UTF-8");
        String idValue = request.getParameter("studentId");
        String action = request.getParameter("action");
        String rejectionReason = request.getParameter("rejectionReason");
        HttpSession session = request.getSession(false);

        if (idValue == null || !idValue.matches("\\d+")
                || !("APPROVED".equals(action) || "REJECTED".equals(action))) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid student or action.");
            return;
        }

        String sql = "UPDATE users SET approval_status = ?, verified_by = ?, " +
                "verified_at = CURRENT_TIMESTAMP, rejection_reason = ? " +
                "WHERE id = ? AND role = 'STUDENT' AND approval_status = 'PENDING'";

        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, action);
            ps.setInt(2, (Integer) session.getAttribute("userId"));
            ps.setString(3, "REJECTED".equals(action)
                    ? (rejectionReason == null ? "" : rejectionReason.trim()) : null);
            ps.setInt(4, Integer.parseInt(idValue));

            if (ps.executeUpdate() == 0) {
                response.sendError(HttpServletResponse.SC_CONFLICT,
                        "Application not found or already reviewed.");
                return;
            }

            response.sendRedirect(request.getContextPath() + "/admin/students?updated=1");
        } catch (SQLException e) {
            throw new ServletException("Could not update student verification status.", e);
        }
    }

    private String safeTimestamp(Timestamp timestamp) {
        return timestamp == null ? "—" : timestamp.toString();
    }
}
