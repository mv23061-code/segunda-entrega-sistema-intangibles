<%-- 
    Document   : consultarActivo
    Created on : 25 oct 2025, 17:42:18
    Author     : MINEDUCYT
--%>

<%@ page import="java.sql.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Consulta de Activos - ByteControl</title>
    <meta charset="UTF-8">
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #0a1f44 0%, #1c1c1c 100%);
            color: #ffffff;
            min-height: 100vh;
        }
        
        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .header {
            text-align: center;
            margin-bottom: 30px;
            padding: 20px 0;
        }
        
        .logo {
            width: 180px;
            height: auto;
            margin-bottom: 15px;
        }
        
        .page-title {
            font-size: 2.5rem;
            font-weight: 300;
            margin-bottom: 10px;
            color: #ffffff;
            text-shadow: 0 2px 4px rgba(0,0,0,0.3);
        }
        
        .welcome-message {
            font-size: 1.2rem;
            color: #00bfa5;
            margin-bottom: 20px;
            font-style: italic;
        }
        
        .table-wrapper {
            background: rgba(255, 255, 255, 0.05);
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }
        
        .data-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            background: rgba(255, 255, 255, 0.02);
            border-radius: 10px;
            overflow: hidden;
        }
        
        .data-table thead {
            background: linear-gradient(135deg, #003f6b 0%, #005fa3 100%);
        }
        
        .data-table th {
            padding: 16px 12px;
            text-align: center;
            font-weight: 600;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #ffffff;
            border-bottom: 2px solid #00bfa5;
        }
        
        .data-table td {
            padding: 14px 12px;
            text-align: center;
            font-size: 0.9rem;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            transition: all 0.3s ease;
        }
        
        .data-table tbody tr {
            transition: all 0.3s ease;
        }
        
        .data-table tbody tr:hover {
            background: rgba(0, 191, 165, 0.1);
            transform: translateY(-1px);
        }
        
        .data-table tbody tr:nth-child(even) {
            background: rgba(255, 255, 255, 0.02);
        }
        
        .data-table tbody tr:nth-child(even):hover {
            background: rgba(0, 191, 165, 0.15);
        }
        
        .btn {
            padding: 10px 18px;
            border: none;
            border-radius: 8px;
            font-size: 0.85rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            min-width: 80px;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #005fa3 0%, #003f6b 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(0, 95, 163, 0.3);
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0, 95, 163, 0.4);
        }
        
        .btn-danger {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(220, 53, 69, 0.3);
        }
        
        .btn-danger:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(220, 53, 69, 0.4);
        }
        
        .btn-success {
            background: linear-gradient(135deg, #00bfa5 0%, #009e8a 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(0, 191, 165, 0.3);
        }
        
        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0, 191, 165, 0.4);
        }
        
        .global-actions {
            display: flex;
            gap: 20px;
            justify-content: center;
            flex-wrap: wrap;
            margin-top: 40px;
        }
        
        .btn-lg {
            padding: 14px 28px;
            font-size: 1rem;
            min-width: 220px;
        }
        
        .no-data {
            text-align: center;
            padding: 60px 20px;
            color: #b0b0b0;
            font-size: 1.2rem;
        }
        
        .no-data h3 {
            margin-bottom: 10px;
            color: #00bfa5;
        }
        
        .error-message {
            background: rgba(220, 53, 69, 0.1);
            border: 1px solid #dc3545;
            color: #dc3545;
            padding: 20px;
            border-radius: 10px;
            margin: 20px 0;
            text-align: center;
            font-weight: 500;
        }
        
        .actions-container {
            display: flex;
            gap: 8px;
            justify-content: center;
        }
        
        .valor-destacado {
            font-weight: bold;
            color: #00bfa5;
            font-size: 1rem;
        }
        
        .table-footer {
            text-align: center;
            padding: 20px;
            color: #b0b0b0;
            font-size: 0.9rem;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            margin-top: 20px;
        }
        
        /* Scroll personalizado para la tabla */
        .table-scroll {
            overflow-x: auto;
            border-radius: 10px;
        }
        
        .table-scroll::-webkit-scrollbar {
            height: 8px;
        }
        
        .table-scroll::-webkit-scrollbar-track {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 4px;
        }
        
        .table-scroll::-webkit-scrollbar-thumb {
            background: #00bfa5;
            border-radius: 4px;
        }
        
        .table-scroll::-webkit-scrollbar-thumb:hover {
            background: #009e8a;
        }
        
        /* Responsive */
        @media (max-width: 1200px) {
            .container {
                padding: 15px;
            }
            
            .table-wrapper {
                padding: 15px;
            }
            
            .data-table {
                font-size: 0.8rem;
            }
            
            .data-table th,
            .data-table td {
                padding: 12px 8px;
            }
        }
        
        @media (max-width: 768px) {
            .page-title {
                font-size: 2rem;
            }
            
            .global-actions {
                flex-direction: column;
                align-items: center;
            }
            
            .btn-lg {
                width: 100%;
                max-width: 300px;
            }
            
            .actions-container {
                flex-direction: column;
                gap: 5px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Header Section -->
        <div class="header">
            <img src="img/bytecontrol_logo.png" alt="BYTECONTROL" class="logo">
            <h1 class="page-title">Listado de Activos Registrados</h1>
            <p class="welcome-message">Sistema de gestión de activos intangibles</p>
        </div>

        <%
            try {
                Class.forName("org.postgresql.Driver");
                Connection con = DriverManager.getConnection(
                    "jdbc:postgresql://localhost:5432/activosdb", "postgres", "Hachi062018#");

                String sql =
                    "SELECT i.id, i.nombre, i.tipo_licencia, i.valor, i.fecha_adquisicion, i.fecha_vencimiento, i.vida_util, i.departamento, " +
                    "       CASE WHEN i.vida_util > 0 THEN ROUND(CAST(i.valor AS numeric) / CAST(i.vida_util AS numeric), 2) ELSE 0 END AS amortizacion_mensual, " +
                    "       COALESCE(a.acumulada, 0) AS amortizacion_acumulada, " +
                    "       CASE " +
                    "           WHEN (CAST(i.valor AS numeric) - COALESCE(a.acumulada, 0)) < 0 THEN 0 " +
                    "           ELSE ROUND(CAST(i.valor AS numeric) - COALESCE(a.acumulada, 0), 2) " +
                    "       END AS valor_en_libros " +
                    "FROM intangibles i " +
                    "LEFT JOIN ( " +
                    "    SELECT id_intangible, SUM(CAST(monto AS numeric)) AS acumulada " +
                    "    FROM amortizaciones " +
                    "    GROUP BY id_intangible " +
                    ") a ON a.id_intangible = i.id " +
                    "ORDER BY i.id";

                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery();

                boolean hayDatos = false;
        %>
                <div class="table-wrapper">
                    <div class="table-scroll">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Nombre</th>
                                    <th>Tipo de Licencia</th>
                                    <th>Valor ($)</th>
                                    <th>Fecha Adquisición</th>
                                    <th>Fecha Vencimiento</th>
                                    <th>Vida Útil</th>
                                    <th>Departamento</th>
                                    <th>Amort. Mensual</th>
                                    <th>Amort. Acumulada</th>
                                    <th>Valor en Libros</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
        <%
                while(rs.next()) {
                    hayDatos = true;
                    int id = rs.getInt("id");
                    String nombre = rs.getString("nombre");
                    String tipoLicencia = rs.getString("tipo_licencia");
                    double valor = rs.getDouble("valor");
                    Date fechaAdquisicion = rs.getDate("fecha_adquisicion");
                    Date fechaVencimiento = rs.getDate("fecha_vencimiento");
                    int vidaUtil = rs.getInt("vida_util");
                    String departamento = rs.getString("departamento");
                    if (departamento != null && "disño".equalsIgnoreCase(departamento.trim())) {
                        departamento = "Diseño";
                    }
                    double amortizacionMensual = rs.getDouble("amortizacion_mensual");
                    double amortizacionAcumulada = rs.getDouble("amortizacion_acumulada");
                    double valorEnLibros = rs.getDouble("valor_en_libros");
        %>
                                <tr>
                                    <td><strong>#<%= id %></strong></td>
                                    <td><%= nombre %></td>
                                    <td><%= tipoLicencia %></td>
                                    <td>$<%= String.format("%.2f", valor) %></td>
                                    <td><%= fechaAdquisicion %></td>
                                    <td><%= fechaVencimiento %></td>
                                    <td><%= vidaUtil %> meses</td>
                                    <td><%= departamento %></td>
                                    <td>$<%= String.format("%.2f", amortizacionMensual) %></td>
                                    <td>$<%= String.format("%.2f", amortizacionAcumulada) %></td>
                                    <td class="valor-destacado">$<%= String.format("%.2f", valorEnLibros) %></td>
                                    <td>
                                        <div class="actions-container">
                                            <form action="EditarActivoServlet" method="post">
                                                <input type="hidden" name="id" value="<%= id %>">
                                                <button type="submit" class="btn btn-primary" title="Editar activo">
                                                    ✏️ Editar
                                                </button>
                                            </form>
                                            <form action="EliminarActivoServlet" method="get">
                                                <input type="hidden" name="id" value="<%= id %>">
                                                <button type="submit" class="btn btn-danger" 
                                                        onclick="return confirm('¿Está seguro de eliminar el activo: <%= nombre %>?')"
                                                        title="Eliminar activo">
                                                    🗑️ Eliminar
                                                </button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
        <%
                }
                
                if (!hayDatos) {
        %>
                                <tr>
                                    <td colspan="12">
                                        <div class="no-data">
                                            <h3>No hay activos registrados</h3>
                                            <p>Comience agregando nuevos activos intangibles al sistema</p>
                                        </div>
                                    </td>
                                </tr>
        <%
                }
        %>
                            </tbody>
                        </table>
                    </div>
                    <div class="table-footer">
                        Total de registros mostrados: <%= hayDatos ? "Varios" : "0" %>
                    </div>
                </div>
        <%
                rs.close();
                ps.close();
                con.close();

            } catch(Exception e) {
        %>
                <div class="error-message">
                    <strong>Error en el sistema:</strong> <%= e.getMessage() %>
                </div>
        <%
            }
        %>

        <!-- Global Actions -->
        <div class="global-actions">
            <form action="GenerarReporteServlet" method="post">
                <button type="submit" class="btn btn-success btn-lg">
                    📊 Generar Reporte PDF
                </button>
            </form>
            <form action="RegistrarAmortizacionServlet" method="post">
                <button type="submit" class="btn btn-primary btn-lg">
                    💰 Registrar Amortización
                </button>
            </form>
            <a href="menu.jsp" class="btn btn-primary btn-lg">
                ← Volver al Menú
            </a>
        </div>
    </div>

    <script>
        // Confirmación mejorada para eliminar
        document.addEventListener('DOMContentLoaded', function() {
            const deleteButtons = document.querySelectorAll('form[action="EliminarActivoServlet"] button');
            deleteButtons.forEach(button => {
                button.addEventListener('click', function(e) {
                    const activoNombre = this.closest('tr').querySelector('td:nth-child(2)').textContent;
                    if (!confirm(`¿Está completamente seguro de eliminar el activo:\n"${activoNombre}"?\n\nEsta acción no se puede deshacer.`)) {
                        e.preventDefault();
                    }
                });
            });
        });
    </script>
</body>
</html>