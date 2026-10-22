
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>

<%!
    private String esc(String s) {
        if (s == null) return "";

        return s.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
%>

<%
    List<String[]> items =
        (List<String[]>) request.getAttribute("items");

    if (items == null) {
        response.sendRedirect(request.getContextPath() + "/items");
        return;
    }

    String requested = request.getParameter("requested");
    String added = request.getParameter("added");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>UniLoop - Campus Community</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/style.css">

    <style>
        .filter-buttons {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-bottom: 20px;
        }

        .filter-buttons .filter-btn {
            width: auto;
            padding: 10px 16px;
            background: #e9ebff;
            color: #252c59;
            border: 1px solid #d8dcf5;
            cursor: pointer;
        }

        .filter-buttons .filter-btn.active {
            background: #424fc2;
            color: white;
        }

        .item[hidden],
        .item-section[hidden] {
            display: none;
        }

        .section-heading {
            margin-top: 28px;
            padding-bottom: 8px;
            border-bottom: 2px solid #e1e4ef;
        }

        .empty-message {
            color: #69718a;
            padding: 12px 0;
        }

        .item-card-image {
            display: block;
            width: 100%;
            max-width: 320px;
            height: 200px;
            object-fit: cover;
            border-radius: 10px;
            margin: 12px 0;
            border: 1px solid #e1e4ef;
        }

        .item-image-placeholder {
            width: 100%;
            max-width: 320px;
            height: 140px;
            display: flex;
            justify-content: center;
            align-items: center;
            margin: 12px 0;
            border: 2px dashed #d1d5db;
            border-radius: 10px;
            background: #f8fafc;
            color: #6b7280;
            font-size: 14px;
        }

        .image-upload-box {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        #imagePreview {
            width: 100%;
            max-width: 300px;
            max-height: 220px;
            object-fit: contain;
            border-radius: 10px;
            margin-top: 10px;
        }
    </style>
</head>

<body>

<header class="site-header">
    <div class="header-info">
        <h1>UniLoop</h1>
        Lost &amp; Found · Borrow &amp; Share · One Campus Community

        <p class="welcome-message">
            Welcome, <%= esc(String.valueOf(session.getAttribute("fullName"))) %>!
        </p>
    </div>

    <form class="logout-form"
          method="post"
          action="<%= request.getContextPath() %>/logout">
        <button type="submit">Logout</button>
    </form>
</header>

<main>

    <% if ("1".equals(requested)) { %>
        <div class="notice">
            Borrow request submitted successfully!
        </div>
    <% } %>

    <% if ("1".equals(added)) { %>
        <div class="notice">
            Item added successfully!
        </div>
    <% } %>

    <!-- Add Item Form -->
    <section class="panel">
        <h2>Report or Share an Item</h2>

        <form method="post"
              action="<%= request.getContextPath() %>/items"
              enctype="multipart/form-data">

            <div class="grid">

                <input type="text"
                       name="itemName"
                       placeholder="Item name"
                       maxlength="100"
                       required>

                <input type="text"
                       name="category"
                       placeholder="Category"
                       maxlength="60"
                       required>

                <select name="itemType" required>
                    <option value="">Select Item Type</option>
                    <option value="LOST">Report Lost Item</option>
                    <option value="FOUND">Report Found Item</option>
                    <option value="BORROW">Offer Item for Borrowing</option>
                    <option value="SHARE">Share an Item</option>
                </select>

                <input type="text"
                       name="location"
                       placeholder="Campus location"
                       maxlength="150">

                <textarea name="description"
                          placeholder="Description"
                          maxlength="500"
                          rows="3"></textarea>

                <div class="image-upload-box">
                    <label for="itemImage">Item Image</label>

                    <input type="file"
                           id="itemImage"
                           name="itemImage"
                           accept="image/jpeg,image/png,image/webp">

                    <small>Upload JPG, PNG or WEBP image. Maximum 5 MB.</small>

                    <img id="imagePreview"
                         src=""
                         alt="Selected item preview"
                         style="display:none;">
                </div>

                <button type="submit" class="add-item-btn">
                    Add Item
                </button>

            </div>
        </form>
    </section>

    <!-- Explore Items -->
    <section class="panel">
        <h2>Explore Campus Items</h2>

        <p>
            Find lost belongings, report found items, or borrow useful resources.
        </p>

        <input type="text"
               id="itemSearch"
               placeholder="Search by item name, category or location..."
               oninput="filterItems()"
               style="margin-bottom:16px;">

        <div class="filter-buttons">
            <button type="button"
                    onclick="showItems('ALL', this)"
                    class="filter-btn active">All Items</button>

            <button type="button"
                    onclick="showItems('LOST', this)"
                    class="filter-btn">Lost Items</button>

            <button type="button"
                    onclick="showItems('FOUND', this)"
                    class="filter-btn">Found Items</button>

            <button type="button"
                    onclick="showItems('BORROW', this)"
                    class="filter-btn">Borrow &amp; Share</button>
        </div>

        <%
            String[] types = {"LOST", "FOUND", "BORROW"};

            String[] headings = {
                "Lost Items",
                "Found Items",
                "Borrow & Share"
            };

            String[] descriptions = {
                "Items students have lost on campus.",
                "Items found and reported by students.",
                "Resources available for students to borrow."
            };

            for (int t = 0; t < types.length; t++) {
                String type = types[t];
                int count = 0;
        %>

        <div class="item-section" data-section="<%= type %>">

            <h3 class="section-heading"><%= headings[t] %></h3>
            <p><%= descriptions[t] %></p>

            <% for (String[] item : items) {
                if (!type.equals(item[3])) {
                    continue;
                }

                count++;

                String searchText =
                    ((item[1] == null ? "" : item[1]) + " " +
                     (item[2] == null ? "" : item[2]) + " " +
                     (item[4] == null ? "" : item[4]) + " " +
                     (item[5] == null ? "" : item[5])).toLowerCase();
            %>

            <article class="item"
                     data-type="<%= esc(item[3]) %>"
                     data-search="<%= esc(searchText) %>">

                <span class="tag"><%= esc(item[3]) %></span>

                <!-- Item Image -->
                <% if (item.length > 6 &&
                       item[6] != null &&
                       !item[6].trim().isEmpty()) { %>

                    <img
                        class="item-card-image"
                        src="<%= request.getContextPath() %>/item-image?name=<%= java.net.URLEncoder.encode(item[6], "UTF-8") %>"
                        alt="<%= esc(item[1]) %>"
                        loading="lazy">

                <% } else { %>

                    <div class="item-image-placeholder">
                        No image available
                    </div>

                <% } %>

                <h3><%= esc(item[1]) %></h3>

                <p>
                    <b>Category:</b>
                    <%= esc(item[2]) %>
                </p>

                <p><%= esc(item[4]) %></p>

                <p class="muted">
                    Location: <%= esc(item[5]) %>
                    | ID: <%= esc(item[0]) %>
                </p>

                <% if ("BORROW".equals(item[3])) { %>

                    <form class="borrow-form"
                          method="post"
                          action="<%= request.getContextPath() %>/items">

                        <input type="hidden"
                               name="action"
                               value="borrow">

                        <input type="hidden"
                               name="itemId"
                               value="<%= esc(item[0]) %>">

                        <label>Your name</label>

                        <input type="text"
                               name="requesterName"
                               placeholder="Enter your name"
                               maxlength="100"
                               required>

                        <button type="submit">
                            Request to Borrow
                        </button>
                    </form>

                <% } %>

            </article>

            <% } %>

            <p class="empty-message"
               data-empty="<%= type %>"
               <%= count > 0 ? "hidden" : "" %>>
                No <%= headings[t].toLowerCase() %> available yet.
            </p>

        </div>

        <% } %>

        <p id="noResults" hidden>
            No matching items found. Try another search.
        </p>

    </section>

</main>

<script>
    const itemImage = document.getElementById("itemImage");
    const imagePreview = document.getElementById("imagePreview");

    itemImage.addEventListener("change", function () {
        const file = this.files[0];

        if (!file) {
            imagePreview.src = "";
            imagePreview.style.display = "none";
            return;
        }

        const allowedTypes = [
            "image/jpeg",
            "image/png",
            "image/webp"
        ];

        if (!allowedTypes.includes(file.type)) {
            alert("Please select a JPG, PNG or WEBP image.");
            this.value = "";
            imagePreview.src = "";
            imagePreview.style.display = "none";
            return;
        }

        if (file.size > 5 * 1024 * 1024) {
            alert("Image size must be 5 MB or less.");
            this.value = "";
            imagePreview.src = "";
            imagePreview.style.display = "none";
            return;
        }

        if (imagePreview.dataset.objectUrl) {
            URL.revokeObjectURL(imagePreview.dataset.objectUrl);
        }

        const previewUrl = URL.createObjectURL(file);
        imagePreview.dataset.objectUrl = previewUrl;
        imagePreview.src = previewUrl;
        imagePreview.style.display = "block";
    });

    let selectedType = "ALL";

    function showItems(type, button) {
        selectedType = type;

        document.querySelectorAll(".filter-btn").forEach(btn => {
            btn.classList.remove("active");
        });

        button.classList.add("active");
        filterItems();
    }

    function filterItems() {
        const searchInput = document.getElementById("itemSearch");
        const query = searchInput.value.trim().toLowerCase();

        let visibleTotal = 0;

        document.querySelectorAll(".item-section").forEach(section => {
            const sectionType = section.dataset.section;
            let sectionVisible = 0;

            section.querySelectorAll(".item").forEach(item => {
                const matchesType =
                    selectedType === "ALL" ||
                    item.dataset.type === selectedType;

                const matchesSearch =
                    (item.dataset.search || "").includes(query);

                const visible = matchesType && matchesSearch;
                item.hidden = !visible;

                if (visible) {
                    sectionVisible++;
                    visibleTotal++;
                }
            });

            section.hidden =
                selectedType !== "ALL" &&
                sectionType !== selectedType;

            const emptyMessage = section.querySelector("[data-empty]");

            if (emptyMessage) {
                emptyMessage.hidden =
                    sectionVisible > 0 || query !== "";
            }
        });

        document.getElementById("noResults").hidden =
            visibleTotal > 0;
    }
</script>

</body>
</html>
