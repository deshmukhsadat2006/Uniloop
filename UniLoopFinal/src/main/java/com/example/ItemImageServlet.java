
package com.example;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@WebServlet("/item-image")
public class ItemImageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");

        if (name == null ||
            !name.matches("[a-fA-F0-9-]+\\.(jpg|png|webp)")) {
            response.sendError(400, "Invalid image name.");
            return;
        }

        Path directory = Paths.get(
            System.getProperty("user.home"),
            "UniLoopUploads"
        ).toAbsolutePath().normalize();

        Path image = directory.resolve(name).normalize();

        if (!image.startsWith(directory) ||
            !Files.isRegularFile(image)) {
            response.sendError(404, "Image not found.");
            return;
        }

        String lower = name.toLowerCase();

        if (lower.endsWith(".jpg")) {
            response.setContentType("image/jpeg");
        } else if (lower.endsWith(".png")) {
            response.setContentType("image/png");
        } else {
            response.setContentType("image/webp");
        }

        response.setContentLengthLong(Files.size(image));

        try (var output = response.getOutputStream()) {
            Files.copy(image, output);
        }
    }
}
