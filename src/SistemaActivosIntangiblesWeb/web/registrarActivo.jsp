<%-- 
    Document   : registrarActivo
    Created on : 25 oct 2025, 17:39:41
    Author     : MINEDUCYT
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Registrar Nuevo Activo Intangible</title>
    <style>
        body {
            background: linear-gradient(to bottom, #0a2a43, #1c4e6e);
            font-family: Arial, sans-serif;
            color: #fff;
            text-align: center;
        }
        h2 {
            margin-top: 30px;
        }
        table {
            margin: auto;
            background-color: #ffffff;
            color: #000;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0,0,0,0.3);
        }
        td {
            padding: 10px;
            text-align: left;
        }
        input[type="text"],
        input[type="number"],
        input[type="date"] {
            width: 100%;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        input[type="submit"] {
            background-color: #00bfa5;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        
        .logo {
            width: 180px;
            margin-bottom: 20px;
        }
        
        input[type="submit"]:hover {
            background-color: #009e88;
        }
        
        a {
            color: #00bfa5;
            text-decoration: none;
            display: inline-block;
            margin-top: 20px;
        }
        a:hover {
            text-decoration: underline;
        }
        .error {
            color: red;
            margin-top: 15px;
        }
    </style>
</head>
<body>
    <img src="img/bytecontrol_logo.png" alt="BYTECONTROL" width="200" height="200">
    <h2>Registrar Nuevo Activo Intangible</h2>

    <form action="RegistrarActivoServlet" method="post">
        <table>
            <tr>
                <td>Nombre:</td>
                <td><input type="text" name="nombre" required></td>
            </tr>
            <tr>
                <td>Descripción:</td>
                <td><input type="text" name="tipo_licencia" required></td>
            </tr>
            <tr>
                <td>Fecha de Adquisición:</td>
                <td><input type="date" name="fecha_adquisicion" required></td>
            </tr>
            <tr>
                <td>Fecha de Vencimiento:</td>
                <td><input type="date" name="fecha_vencimiento" required></td>
            </tr>
            <tr>
                <td>Valor de Compra:</td>
                <td><input type="number" step="0.01" name="valor" required></td>
            </tr>
            <tr>
                <td>Vida Útil (años):</td>
                <td><input type="number" name="vida_util" required></td>
            </tr>
            <tr>
                <td>Departamento:</td>
                <td><input type="text" name="departamento" required></td>
            </tr>
            <tr>
                <td colspan="2" style="text-align:center;">
                    <input type="submit" value="Guardar">
                </td>
            </tr>
        </table>
    </form>

    <a href="menu.jsp">Volver al menú</a>

    <%
        String error = request.getParameter("error");
        if ("campos_vacios".equals(error)) {
    %>
        <p class="error">Por favor, complete todos los campos.</p>
    <%
        } else if ("registro_fallido".equals(error)) {
    %>
        <p class="error">Error al registrar el activo. Intente nuevamente.</p>
    <%
        }
    %>
</body>
</html>




