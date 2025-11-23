<%-- 
    Document   : login
    Created on : 25 oct 2025, 17:24:40
    Author     : MINEDUCYT
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Inicio de Sesión</title>
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

        label {
            font-size: 18px;
            color: #cccccc;
        }

        input[type="text"],
        input[type="password"] {
            width: 80%;
            padding: 10px;
            margin: 10px 0;
            border-radius: 6px;
            border: none;
            font-size: 16px;
        }

        input[type="submit"],
        input[type="reset"] {
            padding: 10px 20px;
            font-size: 16px;
            background-color: #005fa3;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            margin: 10px;
        }

        input[type="submit"]:hover,
        input[type="reset"]:hover {
            background-color: #003f6b;
        }
    </style>
</head>
<body>
    <div class="container">
        <img src="img/bytecontrol_logo.png" alt="BYTECONTROL" width="200" height="200">
        <h2>Inicio de Sesión</h2>
        <form action="LoginServlet" method="post">
            <label for="usuario">Usuario:</label><br>
            <input type="text" name="usuario" id="usuario" required><br><br>

            <label for="clave">Contraseña:</label><br>
            <input type="password" name="clave" id="clave" required><br><br>

            <input type="submit" value="Ingresar">
            <input type="reset" value="Cancelar">
        </form>
    </div>
</body>
</html>


