<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Shortlist Candidates</title>
</head>
<body>

<%
    // Database connection details
    String url = "jdbc:mysql://localhost:3305/beyondbias";
    String user = "root";
    String password = "root@bv1";

    Connection connection = null;
    PreparedStatement preparedStatement = null;

    try {
        // Establish the database connection
        Class.forName("com.mysql.jdbc.Driver");
        connection = DriverManager.getConnection(url, user, password);

        // Check if any candidates were selected for shortlisting
        String[] selectedCandidates = request.getParameterValues("selectedCandidates");
        if (selectedCandidates != null && selectedCandidates.length > 0) {
            // SQL query to insert selected candidates into the shortlisted table
            String insertSql = "INSERT INTO shortlisted (name, jobid, email) SELECT name, jobid, email FROM application WHERE email IN (";
            
            // Appending placeholders for email in the query
            for (int i = 0; i < selectedCandidates.length; i++) {
                insertSql += "?";
                if (i < selectedCandidates.length - 1) {
                    insertSql += ",";
                }
            }
            insertSql += ")";
            
            preparedStatement = connection.prepareStatement(insertSql);
            
            // Set email parameters
            for (int i = 0; i < selectedCandidates.length; i++) {
                preparedStatement.setString(i + 1, selectedCandidates[i]);
            }

            // Execute the insert query
            preparedStatement.executeUpdate();
        }

        // Redirect back to the employer view applications page
        response.sendRedirect("view_shortlisted.jsp");

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        // Close the database resources
        if (preparedStatement != null) {
            try {
                preparedStatement.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
%>

</body>
</html>