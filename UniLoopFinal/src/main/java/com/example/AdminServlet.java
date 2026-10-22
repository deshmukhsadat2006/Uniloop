
package com.example;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/admin/requests")
public class AdminServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        List<String[]> requests = new ArrayList<>();

        String sql = "SELECT br.id, br.requester_name, i.item_name, " +
                     "br.request_status, br.created_at " +
                     "FROM borrow_requests br " +
                     "JOIN items i ON br.item_id = i.id " +
                     "ORDER BY br.id DESC";

        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                requests.add(new String[] {
                    String.valueOf(rs.getInt("id")),
                    rs.getString("requester_name"),
                    rs.getString("item_name"),
                    rs.getString("request_status"),
                    String.valueOf(rs.getTimestamp("created_at"))
                });
            }

            request.setAttribute("requests", requests);
            request.getRequestDispatcher("/admin-requests.jsp")
                   .forward(request, response);

        } catch (SQLException e) {
            throw new ServletException(
                "Could not load borrow requests.", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String idValue = request.getParameter("requestId");
        String action = request.getParameter("action");

        if (idValue == null || !idValue.matches("\\d+")
                || !("APPROVED".equals(action)
                || "REJECTED".equals(action))) {
            response.sendError(400, "Invalid request or action.");
            return;
        }

        String sql = "UPDATE borrow_requests " +
                     "SET request_status = ? " +
                     "WHERE id = ? AND request_status = 'PENDING'";

        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, action);
            ps.setInt(2, Integer.parseInt(idValue));

            int updated = ps.executeUpdate();

            if (updated == 0) {
                response.sendError(
                    409, "Request not found or already processed.");
                return;
            }

            response.sendRedirect(
                request.getContextPath() + "/admin/requests?updated=1");

        } catch (SQLException e) {
            throw new ServletException(
                "Could not update borrow request.", e);
        }
    }
}
