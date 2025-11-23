/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/RegistrarActivoServlet")
public class RegistrarActivoServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Obtener parámetros del formulario
        String nombre = request.getParameter("nombre");
        String tipoLicencia = request.getParameter("tipo_licencia");
        String valorStr = request.getParameter("valor");
        String fechaStr = request.getParameter("fecha_adquisicion");
        String fechaVencimientoStr = request.getParameter("fecha_vencimiento");
        String vidaUtilStr = request.getParameter("vida_util");
        String departamento = request.getParameter("departamento");

        // Validar que ningún campo esté vacío
        if (nombre == null || tipoLicencia == null || valorStr == null || fechaStr == null ||
            fechaVencimientoStr == null || vidaUtilStr == null || departamento == null ||
            nombre.isEmpty() || tipoLicencia.isEmpty() || valorStr.isEmpty() ||
            fechaStr.isEmpty() || fechaVencimientoStr.isEmpty() || vidaUtilStr.isEmpty() || departamento.isEmpty()) {

            response.sendRedirect("registrarActivo.jsp?error=campos_vacios");
            return;
        }

        try {
            // Conversión segura de tipos
            double valor = Double.parseDouble(valorStr);
            int vidaUtil = Integer.parseInt(vidaUtilStr);
            Date fechaAdquisicion = Date.valueOf(fechaStr);       // formato yyyy-MM-dd
            Date fechaVencimiento = Date.valueOf(fechaVencimientoStr); // formato yyyy-MM-dd

            // Conexión a la base de datos
            Class.forName("org.postgresql.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:postgresql://localhost:5432/activosdb", "postgres", "Hachi062018#");

            // Insertar el activo
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO intangibles (nombre, tipo_licencia, valor, fecha_adquisicion, fecha_vencimiento, vida_util, departamento) VALUES (?, ?, ?, ?, ?, ?, ?)");
            ps.setString(1, nombre);
            ps.setString(2, tipoLicencia);
            ps.setDouble(3, valor);
            ps.setDate(4, fechaAdquisicion);
            ps.setDate(5, fechaVencimiento);
            ps.setInt(6, vidaUtil);
            ps.setString(7, departamento);

            ps.executeUpdate();

            ps.close();
            con.close();

            // Redirigir al menú si todo sale bien
            response.sendRedirect("menu.jsp");

        } catch (Exception e) {
            e.printStackTrace();
    response.setContentType("text/html;charset=UTF-8");
    response.getWriter().println("<p style='color:red;'>Error técnico: " + e.getMessage() + "</p>");
        }
    }
}
