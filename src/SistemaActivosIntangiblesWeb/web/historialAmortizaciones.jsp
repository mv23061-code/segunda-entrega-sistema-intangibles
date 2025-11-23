<%-- 
    Document   : historialAmortizaciones
    Created on : 26 oct 2025, 13:56:20
    Author     : MINEDUCYT
--%>

<%@ page import="java.sql.*, java.util.Calendar" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Amortizaciones del Mes Actual</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f5f5f5;
        }
        .header-container {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 20px 40px;
            background-color: #003f6b;
            margin-bottom: 20px;
        }
        .logo {
            width: 220px;
            height: auto;
        }
        .title {
            flex-grow: 1;
            text-align: center;
            font-size: 28px;
            color: white;
            margin: 0;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        th, td {
            border: 1px solid #ccc;
            padding: 8px;
            text-align: center;
        }
        th {
            background-color: #003f6b;
            color: white;
        }
        .boton {
            margin-top: 20px;
            padding: 10px 20px;
            background-color: #00bfa5;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            text-decoration: none;
            display: inline-block;
        }
        .boton:hover {
            background-color: #009e8a;
        }
    </style>
</head>
<body>

<div class="header-container">
    <!-- Logo alineado a la izquierda -->
    <img src="img/bytecontrol_logo.png" alt="BYTECONTROL" class="logo">
    
    <!-- Texto centrado horizontalmente -->
    <h1 class="title">Amortizaciones del Mes Actual</h1>
    
    <!-- Espacio vacío para equilibrar el diseño -->
    <div style="width: 220px;"></div>
</div>

<table>
    <tr>
        <th>ID Activo</th>
        <th>Nombre</th>
        <th>Fecha</th>
        <th>Monto</th>
        <th>Estado</th>
    </tr>

<%
    Calendar cal = Calendar.getInstance();
    int mesActual = cal.get(Calendar.MONTH) + 1;
    int anioActual = cal.get(Calendar.YEAR);

    Class.forName("org.postgresql.Driver");
    Connection con = DriverManager.getConnection(
        "jdbc:postgresql://localhost:5432/activosdb", "postgres", "Hachi062018#");

    PreparedStatement ps = con.prepareStatement(
        "SELECT a.id_intangible, i.nombre, a.fecha, a.monto, a.estado " +
        "FROM amortizaciones a JOIN intangibles i ON a.id_intangible = i.id " +
        "WHERE EXTRACT(MONTH FROM a.fecha) = ? AND EXTRACT(YEAR FROM a.fecha) = ? " +
        "ORDER BY a.fecha DESC");

    ps.setInt(1, mesActual);
    ps.setInt(2, anioActual);
    ResultSet rs = ps.executeQuery();

    boolean hayRegistros = false;
    while (rs.next()) {
        hayRegistros = true;
%>
    <tr>
        <td><%= rs.getInt("id_intangible") %></td>
        <td><%= rs.getString("nombre") %></td>
        <td><%= rs.getDate("fecha") %></td>
        <td>$<%= rs.getDouble("monto") %></td>
        <td><%= rs.getString("estado") %></td>
    </tr>
<%
    }

    if (!hayRegistros) {
%>
    <tr>
        <td colspan="5" style="color:red;">No hay amortizaciones registradas para este mes.</td>
    </tr>
<%
    }

    rs.close();
    ps.close();
    con.close();
%>
</table>

<div style="text-align: center; margin-top: 30px;">
    <a href="menu.jsp" class="boton">Volver al menú</a>
</div>

</body>
</html>