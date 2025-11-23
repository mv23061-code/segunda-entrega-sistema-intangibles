/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/RegistrarAmortizacionServlet")
public class RegistrarAmortizacionServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Connection con = null;
        PreparedStatement ps = null;
        Statement st = null;
        ResultSet rs = null;

        try {
            Class.forName("org.postgresql.Driver");
            con = DriverManager.getConnection(
                "jdbc:postgresql://localhost:5432/activosdb", "postgres", "Hachi062018#");

            // 1. Obtener todos los intangibles
            st = con.createStatement();
            rs = st.executeQuery("SELECT id, valor, vida_util FROM intangibles");

            // 2. Insertar amortización mensual para cada activo
            String sql = "INSERT INTO amortizaciones (id_intangible, fecha, monto, estado) VALUES (?, CURRENT_DATE, ?, ?)";
            ps = con.prepareStatement(sql);

            while (rs.next()) {
                int idIntangible = rs.getInt("id");
                double valor = rs.getDouble("valor");
                int vidaUtil = rs.getInt("vida_util");

                // Evitar división por cero
                if (vidaUtil > 0) {
                    double montoMensual = valor / vidaUtil;

                    ps.setInt(1, idIntangible);
                    ps.setDouble(2, montoMensual);
                    ps.setString(3, "registrada");
                    ps.executeUpdate();
                }
            }

            // 3. Redirigir con mensaje de éxito
            response.sendRedirect("historialAmortizaciones.jsp?ok=Amortización%20registrada%20correctamente");

        } catch (Exception e) {
            // Redirigir con mensaje de error
            response.sendRedirect("consultarActivo.jsp?error=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignore) {}
            try { if (st != null) st.close(); } catch (Exception ignore) {}
            try { if (ps != null) ps.close(); } catch (Exception ignore) {}
            try { if (con != null) con.close(); } catch (Exception ignore) {}
        }
    }
}
