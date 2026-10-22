
package com.example;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;

@WebServlet("/items")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 5 * 1024 * 1024,
    maxRequestSize = 6 * 1024 * 1024
)
public class ItemServlet extends HttpServlet {

    private static final List<String> ITEM_TYPES =
        Arrays.asList("LOST", "FOUND", "BORROW", "SHARE");

    private Path getUploadDirectory() {
        return Paths.get(
            System.getProperty("user.home"),
            "UniLoopUploads"
        ).toAbsolutePath().normalize();
    }

    // Display items
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        List<String[]> items = new ArrayList<>();

        String sql =
            "SELECT id, item_name, category, item_type, " +
            "description, location, image_path " +
            "FROM items ORDER BY id DESC";

        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                items.add(new String[] {
                    String.valueOf(rs.getInt("id")),
                    rs.getString("item_name"),
                    rs.getString("category"),
                    rs.getString("item_type"),
                    rs.getString("description"),
                    rs.getString("location"),
                    rs.getString("image_path")
                });
            }

            request.setAttribute("items", items);

            request.getRequestDispatcher("/index.jsp")
                   .forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Could not load items.", e);
        }
    }

    // Add item with optional image
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("userId") == null) {

            response.sendRedirect(
                request.getContextPath() + "/auth"
            );
            return;
        }

        // Existing borrow request functionality
        if ("borrow".equals(request.getParameter("action"))) {
            handleBorrowRequest(request, response);
            return;
        }

        String name = trim(request.getParameter("itemName"));
        String category = trim(request.getParameter("category"));
        String type = trim(request.getParameter("itemType"));
        String description = trim(request.getParameter("description"));
        String location = trim(request.getParameter("location"));

        if (name.isEmpty() || name.length() > 100 ||
            category.isEmpty() || category.length() > 60 ||
            !ITEM_TYPES.contains(type) ||
            description.length() > 1000 ||
            location.length() > 150) {

            response.sendError(400, "Enter valid item details.");
            return;
        }

        Part imagePart = request.getPart("itemImage");

        String imageName = null;
        Path savedImage = null;

        // Save image only when user selects one
        if (imagePart != null && imagePart.getSize() > 0) {

            if (imagePart.getSize() > 5L * 1024 * 1024) {
                response.sendError(
                    400, "Image must be 5 MB or less."
                );
                return;
            }

            String contentType = imagePart.getContentType();
            String extension;

            if ("image/jpeg".equalsIgnoreCase(contentType)) {
                extension = ".jpg";
            } else if ("image/png".equalsIgnoreCase(contentType)) {
                extension = ".png";
            } else if ("image/webp".equalsIgnoreCase(contentType)) {
                extension = ".webp";
            } else {
                response.sendError(
                    400, "Only JPG, PNG or WEBP images are allowed."
                );
                return;
            }

            imageName = UUID.randomUUID().toString() + extension;

            Path uploadDir = getUploadDirectory();
            Files.createDirectories(uploadDir);

            savedImage = uploadDir.resolve(imageName).normalize();

            if (!savedImage.startsWith(uploadDir)) {
                response.sendError(400, "Invalid image path.");
                return;
            }

            try (InputStream input = imagePart.getInputStream()) {
                Files.copy(input, savedImage);
            } catch (IOException e) {
                throw new ServletException(
                    "Could not save uploaded image.", e
                );
            }
        }

        // Save item details and image filename in MySQL
        String sql =
            "INSERT INTO items " +
            "(item_name, category, item_type, description, " +
            "location, image_path) " +
            "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, name);
            ps.setString(2, category);
            ps.setString(3, type);
            ps.setString(4, description);
            ps.setString(5, location);
            ps.setString(6, imageName);

            ps.executeUpdate();

            response.sendRedirect(
                request.getContextPath() + "/items?added=1"
            );

        } catch (SQLException e) {

            // Delete image if the database insert fails
            if (savedImage != null) {
                try {
                    Files.deleteIfExists(savedImage);
                } catch (IOException deleteError) {
                    e.addSuppressed(deleteError);
                }
            }

            throw new ServletException(
                "Could not save item in database.", e
            );
        }
    }

    // Existing borrow request functionality
    private void handleBorrowRequest(HttpServletRequest request,
                                     HttpServletResponse response)
            throws ServletException, IOException {

        String itemId = trim(request.getParameter("itemId"));
        String requesterName =
            trim(request.getParameter("requesterName"));

        if (!itemId.matches("\\d+") ||
            requesterName.isEmpty() ||
            requesterName.length() > 100) {

            response.sendError(
                400, "Enter a valid item and name."
            );
            return;
        }

        String sql =
            "INSERT INTO borrow_requests " +
            "(item_id, requester_name) " +
            "SELECT id, ? FROM items " +
            "WHERE id = ? AND item_type = 'BORROW'";

        try (Connection con = DB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, requesterName);
            ps.setInt(2, Integer.parseInt(itemId));

            int inserted = ps.executeUpdate();

            if (inserted == 0) {
                response.sendError(
                    400, "Borrowable item not found."
                );
                return;
            }

            response.sendRedirect(
                request.getContextPath() + "/items?requested=1"
            );

        } catch (SQLException e) {
            throw new ServletException(
                "Could not submit borrow request.", e
            );
        }
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }
}
