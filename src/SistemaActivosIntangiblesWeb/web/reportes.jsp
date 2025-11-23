<%-- 
    Document   : reportes
    Created on : 25 oct 2025, 18:07:51
    Author     : MINEDUCYT
--%>

<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Reportes de Activos</title>
    <meta charset="UTF-8">
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(to bottom right, #0a1f44, #1c1c1c);
            color: #ffffff;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: flex-start;
            min-height: 100vh;
        }

        .container {
            margin-top: 60px;
            background-color: rgba(255, 255, 255, 0.05);
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 0 20px rgba(0,0,0,0.4);
            width: 80%;
            max-width: 600px;
            text-align: center;
        }

        .logo {
            width: 180px;
            margin-bottom: 20px;
        }

        h2 {
            margin-bottom: 30px;
            color: #ffffff;
        }

        .stat {
            font-size: 18px;
            margin: 15px 0;
            color: #cccccc;
        }

        .btn-back {
            margin-top: 30px;
            padding: 10px 20px;
            font-size: 16px;
            background-color: #005fa3;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }

        .btn-back:hover {
            background-color: #003f6b;
        }
    </style>
</head>
<body>
    <div class="container">
        <img src="img/bytecontrol_logo.png" alt="BYTECONTROL" width="200" height="200">
        <h2>Resumen de Activos Registrados</h2>

        <%
            try {
                Class.forName("org.postgresql.Driver");
                Connection con = DriverManager.getConnection(
                    "jdbc:postgresql://localhost:5432/activosdb", "postgres", "Hachi062018#");

                Statement st = con.createStatement();

                ResultSet rs1 = st.executeQuery("SELECT COUNT(*) FROM intangibles");
                rs1.next();
                int totalActivos = rs1.getInt(1);
                rs1.close();

                ResultSet rs2 = st.executeQuery("SELECT SUM(valor) FROM intangibles");
                rs2.next();
                double totalValor = rs2.getDouble(1);
                rs2.close();

                ResultSet rs3 = st.executeQuery("SELECT AVG(vida_util) FROM intangibles");
                rs3.next();
                double promedioVida = rs3.getDouble(1);
                rs3.close();

                st.close();
                con.close();
        %>

        <div class="stat">🔹 Total de activos registrados: <strong><%= totalActivos %></strong></div>
        <div class="stat">💰 Valor acumulado: <strong>$<%= String.format("%.2f", totalValor) %></strong></div>
        <div class="stat">📆 Promedio de vida útil: <strong><%= String.format("%.1f", promedioVida) %></strong> meses</div>

        <%
            } catch (Exception e) {
                out.println("<div class='stat'>Error al generar el reporte</div>");
                e.printStackTrace();
            }
        %>

        <form action="menu.jsp" method="get">
            <input type="submit" value="Volver al menú" class="btn-back">
        </form>
    </div>
</body>
</html>
