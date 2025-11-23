<%-- 
    Document   : menu
    Created on : 25 oct 2025, 17:38:30
    Author     : MINEDUCYT
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Menú Principal</title>
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
            max-width: 500px;
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

        form {
            margin: 15px 0;
        }

        input[type="submit"] {
            padding: 10px 20px;
            font-size: 16px;
            background-color: #005fa3;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }

        input[type="submit"]:hover {
            background-color: #003f6b;
        }
    </style>
</head>
<body>
    <div class="container">
        <img src="img/bytecontrol_logo.png" alt="BYTECONTROL" width="200" height="200">
        <h2>Menú Principal</h2>

        <form action="registrarActivo.jsp" method="get">
            <input type="submit" value="Registrar Activo">
        </form>

        <form action="consultarActivo.jsp" method="get">
            <input type="submit" value="Consultar Activo">
        </form>

        <form action="reportes.jsp" method="get">
            <input type="submit" value="Reportes">
        </form>

        <form action="login.jsp" method="get">
            <input type="submit" value="Cerrar Sesión">
        </form>
    </div>
</body>
</html>
