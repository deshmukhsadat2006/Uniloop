package com.example;

import java.io.IOException;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebFilter(urlPatterns = {"/items", "/admin/*"})
public class AuthFilter implements Filter {

    @Override
    public void doFilter(
            ServletRequest request,
            ServletResponse response,
            FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);

        boolean loggedIn = session != null
                && session.getAttribute("userId") != null;

        if (!loggedIn) {
            res.sendRedirect(req.getContextPath() + "/auth");
            return;
        }

        String path = req.getServletPath();

        // Admin request management: only ADMIN or MODERATOR.
        if (path.startsWith("/admin/")) {
            Object role = session.getAttribute("role");

            if (role == null ||
                    !(role.equals("ADMIN") || role.equals("MODERATOR"))) {
                res.sendError(HttpServletResponse.SC_FORBIDDEN,
                        "You are not authorized to access this page.");
                return;
            }
        }

        chain.doFilter(request, response);
    }
}
