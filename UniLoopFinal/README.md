# UniLoop – College Community Web Application

**A step-by-step beginner's guide to setting up, building, and running the UniLoop web application using Java Servlets, JSP, MySQL, Apache Maven, and Apache Tomcat 10 in Visual Studio Code.**

---

## 🛠️ Step-by-Step Setup & Development Guide

### 1. Install Java Development Kit (JDK)

Before running the UniLoop project, make sure Java is installed on your computer.

1. Open Command Prompt or the VS Code terminal.
2. Run the following command:

   ```cmd
   java -version
   ```

3. If Java is not installed, download JDK 17 or JDK 21 from [Eclipse Temurin](https://adoptium.net/) or [Oracle Java](https://www.oracle.com/java/technologies/downloads/).
4. After installation, restart the terminal and verify the installation.

### 2. Install Apache Maven

Apache Maven is used to manage project dependencies and build the Java web application.

1. Check whether Maven is installed:

   ```cmd
   mvn -version
   ```

2. If Maven is not installed, download the Binary ZIP Archive from the [official Apache Maven website](https://maven.apache.org/download.cgi).
3. Extract the downloaded ZIP file.
4. Add the Maven `bin` directory to the Windows `Path` environment variable.
5. Restart the terminal and verify Maven:

   ```cmd
   mvn -version
   ```

### 3. Install Required VS Code Extensions

Open Visual Studio Code and install the following extensions using `Ctrl + Shift + X`.

1. **Extension Pack for Java** – Provides Java development and debugging support.
2. **Community Server Connectors** – Helps manage supported application servers from VS Code.
3. **Extension Pack for SQL Server / MySQL extension** – Optional database tools, depending on your MySQL workflow.

### 4. Install MySQL and Apache Tomcat

**MySQL setup**

1. Download and install MySQL Server from the [official MySQL website](https://dev.mysql.com/downloads/).
2. Install MySQL Workbench if you want a graphical interface to manage databases.
3. Start the MySQL service and verify that you can connect to the server.

**Apache Tomcat setup**

1. Download Apache Tomcat 10 from the [official Tomcat website](https://tomcat.apache.org/download-10.cgi).
2. Extract the downloaded archive into a suitable folder.
3. Keep the Tomcat installation directory accessible for deployment.

### 5. Download and Open the UniLoop Project

1. Clone the UniLoop repository from GitHub, if it is hosted there:

   ```bash
   git clone <repository-url>
   cd UniLoop
   ```

2. If the project is already available on your computer, open its existing folder instead.
3. In VS Code, select **File → Open Folder**.
4. Choose the UniLoop project directory.

### 6. Understand the Project Structure

A typical Java Servlet and JSP project may use the following structure. The actual UniLoop structure can differ.

```text
UniLoop/
├── src/
│   └── main/
│       ├── java/
│       │   └── com/example/
│       │       └── [Servlet files]
│       └── webapp/
│           ├── index.jsp
│           ├── login.jsp
│           ├── register.jsp
│           ├── css/
│           ├── js/
│           └── WEB-INF/
│               └── web.xml
├── database/
│   └── [SQL files]
├── pom.xml
└── README.md
```

- **Java files:** Handle server-side logic and request processing.
- **JSP files:** Display dynamic web pages.
- **CSS and JavaScript:** Control the appearance and browser-side interactions.
- **Database files:** Store SQL scripts for creating tables and inserting data.
- **pom.xml:** Defines Maven dependencies and build configuration.

### 7. Set Up the UniLoop Database

1. Open MySQL Workbench or your preferred MySQL client.
2. Create the database using the actual database name required by UniLoop.

   ```sql
   CREATE DATABASE uniloop;
   USE uniloop;
   ```

3. If the project contains SQL scripts in a `database/` folder, import and execute those scripts.
4. If no SQL file exists, create the required tables according to the project's database design.
5. Verify that the database and tables have been created successfully.

**Note:** Use the database name and table definitions from the actual UniLoop source code if they differ from these examples.

### 8. Configure the MySQL Database Connection

1. Locate the database connection code or configuration file in the Java project.
2. Update the JDBC URL, database username, and password according to your MySQL setup.

   Example JDBC URL:

   ```java
   String url = "jdbc:mysql://localhost:3306/uniloop";
   String username = "root";
   String password = "your_mysql_password";
   ```

3. Ensure that the MySQL JDBC driver dependency is included in `pom.xml`.
4. Verify that the application can establish a connection to MySQL.

**Important:** Replace the example credentials with your own local configuration. Do not upload real database passwords to a public GitHub repository.

### 9. Build the UniLoop Project Using Maven

1. Open the integrated terminal in VS Code using `Ctrl + ~`.
2. Navigate to the directory containing `pom.xml`.
3. Run the following command:

   ```bash
   mvn clean package
   ```

4. Wait for Maven to download dependencies, compile the Java files, and package the application.
5. If the build succeeds, Maven will generate a `.war` file inside the `target/` directory.

If errors occur, check the Maven output and resolve compilation or dependency issues before deploying.

### 10. Configure Apache Tomcat 10

1. Open VS Code and locate the **SERVERS** section if your installed server extension provides it.
2. Create a new server and select the compatible Apache Tomcat 10 installation.
3. Configure the Tomcat installation directory.
4. Alternatively, you can deploy the generated WAR file directly through the Tomcat installation's `webapps/` directory.

**Compatibility note:** Tomcat 10 uses Jakarta Servlet APIs. Ensure that the project uses compatible `jakarta.servlet` dependencies and the correct Tomcat version.

### 11. Deploy UniLoop on Tomcat

1. Build the project using Maven:

   ```bash
   mvn clean package
   ```

2. Locate the generated WAR file inside `target/`.
3. Copy the WAR file into Tomcat's `webapps/` directory, or use the deployment feature in your server extension.
4. Start Tomcat.
5. Wait for Tomcat to deploy the application and check the server logs for errors.

The application context path generally matches the WAR filename, unless configured otherwise.

### 12. Run UniLoop in the Browser

1. Start the MySQL service.
2. Start Apache Tomcat.
3. Open your browser.
4. Visit the application's URL using the correct port and context path.

   ```text
   http://localhost:8080/UniLoop/
   ```

5. If the application uses a different WAR filename or context path, update the URL accordingly.
6. Test the available UniLoop pages and features.

### 13. Test the Application

After starting UniLoop, check the features implemented in your project.

- Verify that the home page loads correctly.
- Test registration and login if authentication is implemented.
- Check whether database operations work correctly.
- Verify form submissions and server responses.
- Check that CSS, JavaScript, and other resources load properly.
- Review the Tomcat logs if any page or database operation fails.

### 14. Rebuild and Apply Code Changes

Whenever you modify the Java, JSP, configuration, or other project files:

1. Save your changes.
2. Rebuild the application:

   ```bash
   mvn clean package
   ```

3. Redeploy the updated WAR file if required.
4. Restart or reload the application when necessary.
5. Refresh the browser to check the updated output.

**Tip:** JSP and static resources may update without a full rebuild in some development setups, but Java changes generally require recompilation and redeployment.

---

## Subject Details

- **Class:** SE (COMP) – Div A
- **Academic Year:** 2026–2027
- **Subject:** Full Stack Java Programming (FSJP)
- **Project Name:** UniLoop
- **Project Type:** Course Project

## Platform, Libraries and Frameworks Used

1. Java Development Kit (JDK)
2. Java Servlets (Jakarta Servlet)
3. JavaServer Pages (JSP)
4. Apache Maven
5. Apache Tomcat 10
6. MySQL Database
7. JDBC for database connectivity
8. HTML, CSS, and JavaScript
9. Visual Studio Code
10. Git and GitHub for version control, if used

## Dataset Used

The application uses data stored in the MySQL database according to the features implemented in UniLoop. Any sample or test records are used for development and testing purposes. No external dataset is assumed.

## References

- [Java Documentation](https://docs.oracle.com/en/java/)
- [Jakarta Servlet Specification](https://jakarta.ee/specifications/servlet/)
- [Apache Maven Documentation](https://maven.apache.org/guides/)
- [Apache Tomcat 10 Documentation](https://tomcat.apache.org/tomcat-10.1-doc/)
- [MySQL Documentation](https://dev.mysql.com/doc/)
- [Visual Studio Code Documentation](https://code.visualstudio.com/docs)
- [GitHub Documentation](https://docs.github.com/)
