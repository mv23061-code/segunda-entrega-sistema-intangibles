<%-- 
    Document   : editarActivo
    Created on : 25 oct 2025, 22:32:17
    Author     : MINEDUCYT
--%>

<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String id = request.getParameter("id");
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String nombre = "", tipo = "", valor = "", fechaCompra = "", fechaExpiracion = "", vidaUtil = "", departamento = "";

    try {
        Class.forName("org.postgresql.Driver");
        con = DriverManager.getConnection("jdbc:postgresql://localhost:5432/activosdb", "postgres", "Hachi062018#");

        ps = con.prepareStatement("SELECT * FROM intangibles WHERE id = ?");
        ps.setInt(1, Integer.parseInt(id));
        rs = ps.executeQuery();

        if (rs.next()) {
            nombre = rs.getString("nombre");
            tipo = rs.getString("tipo_licencia");
            valor = rs.getString("valor");
            fechaCompra = rs.getString("fecha_adquisicion");
            fechaExpiracion = rs.getString("fecha_vencimiento");
            vidaUtil = rs.getString("vida_util");
            departamento = rs.getString("departamento");
        }
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Editar activo</title>
    <meta charset="UTF-8">
    <style>
        body {
            background-color: #0a2a43;
            font-family: Arial, sans-serif;
            color: white;
            text-align: center;
        }
        .formulario {
            background-color: white;
            color: black;
            width: 60%;
            margin: auto;
            padding: 20px;
            border-radius: 10px;
        }
        input, select {
            width: 90%;
            padding: 10px;
            margin: 10px 0;
            border-radius: 5px;
            border: 1px solid #ccc;
        }
        input[type="submit"] {
            background-color: #00bfa5;
            color: white;
            border: none;
            cursor: pointer;
        }
        input[type="submit"]:hover {
            background-color: #009e8c;
        }
    </style>
</head>
<body>
    <img src="img/bytecontrol_logo.png" alt="BYTECONTROL" width="200" height="200">
    <h2>Editar activo</h2>

    <div class="formulario">
        <form action="EditarActivoServlet" method="post">
            <input type="hidden" name="id" value="<%= id %>">

            <label>Nombre del activo:</label><br>
            <input type="text" name="nombre" value="<%= nombre %>" required><br>

            <label>Tipo de licencia:</label><br>
            <input type="text" name="tipo_licencia" value="<%= tipo %>" required><br>

            <label>Valor en dólares:</label><br>
            <input type="number" name="valor" value="<%= valor %>" step="0.01" required><br>

            <label>Fecha de compra:</label><br>
            <input type="date" name="fecha_adquisicion" value="<%= fechaCompra %>" required><br>

            <label>Fecha de expiracion:</label><br>
            <input type="date" name="fecha_vencimiento" value="<%= fechaExpiracion %>" required><br>

            <label>Duracion en meses:</label><br>
            <input type="number" name="vida_util" value="<%= vidaUtil %>" required><br>

            <label>Departamento:</label><br>
            <select name="departamento" required>
                <option value="Creatividad" <%= departamento.equals("Creatividad") ? "selected" : "" %>>Creatividad</option>
                <option value="Ventas" <%= departamento.equals("Ventas") ? "selected" : "" %>>Ventas</option>
                <option value="Soporte" <%= departamento.equals("Soporte") ? "selected" : "" %>>Soporte</option>
                <option value="Administracion" <%= departamento.equals("Administracion") ? "selected" : "" %>>Administracion</option>
            </select><br>

            <input type="submit" value="Actualizar activo">
        </form>
    </div>
</body>
</html>

