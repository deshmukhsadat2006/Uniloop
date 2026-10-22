
package com.example;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/charges")
public class ChargesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/auth");
            return;
        }

        List<String[]> charges = new ArrayList<>();

        /*
         * Planned columns:
         * days_requested, daily_rate, estimated_charge,
         * amount_paid, late_fee, due_at, returned_at
         *
         * Run the matching SQL migration before enabling this query.
         */

        String sql =
            "SELECT br.id, i.item_name, br.days_requested, " +
            "br.daily_rate, br.estimated_charge, br.amount_paid, " +
            "br.late_fee, br.request_status, br.due_at, br.returned_at " +
            "FROM borrow_requests br " +
            "JOIN items i ON i.id = br.item_id " +
            "WHERE br.requester_id = ? ORDER BY br.id DESC";

        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, (Integer) session.getAttribute("userId"));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    charges.add(new String[]{
                        String.valueOf(rs.getInt("id")),
                        rs.getString("item_name"),
                        String.valueOf(rs.getInt("days_requested")),
                        String.valueOf(rs.getBigDecimal("daily_rate")),
                        String.valueOf(rs.getBigDecimal("estimated_charge")),
                        String.valueOf(rs.getBigDecimal("amount_paid")),
                        String.valueOf(rs.getBigDecimal("late_fee")),
                        rs.getString("request_status"),
                        String.valueOf(rs.getTimestamp("due_at")),
                        String.valueOf(rs.getTimestamp("returned_at"))
                    });
                }
            }

            request.setAttribute("charges", charges);
            request.getRequestDispatcher("/charges.jsp")
                   .forward(request, response);

        } catch (SQLException e) {
            throw new ServletException(
                "Charges database fields are not configured yet.", e
            );
        }
    }
}
