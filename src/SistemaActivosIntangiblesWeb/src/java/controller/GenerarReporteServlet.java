/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.*;
import java.sql.*;
import java.text.DecimalFormat;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;

@WebServlet("/GenerarReporteServlet")
public class GenerarReporteServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("GenerarReporteServlet: Iniciando generación de reporte...");
        
        // Configurar respuesta como PDF
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "inline; filename=reporte_activos_intangibles.pdf");
        
        Document documento = new Document(PageSize.A4.rotate()); // Horizontal para mejor visualización

        try {
            PdfWriter.getInstance(documento, response.getOutputStream());
            documento.open();

            // Agregar logo y encabezado
            agregarEncabezado(documento, request);
            
            // Generar tabla de datos
            generarTablaActivos(documento);

            // Pie de página
            agregarPiePagina(documento);

        } catch (Exception e) {
            e.printStackTrace();
            try {
                documento.add(new Paragraph("Error al generar el reporte. Contacte al administrador del sistema."));
            } catch (DocumentException de) {
                de.printStackTrace();
            }
        } finally {
            if (documento.isOpen()) {
                documento.close();
            }
        }
    }
    
    private void agregarEncabezado(Document documento, HttpServletRequest request) throws DocumentException {
        try {
            // Logo
            String rutaLogo = request.getServletContext().getRealPath("/img/bytecontrol_logo.png");
        File logoFile = new File(rutaLogo);
        if (logoFile.exists()) {
            Image logo = Image.getInstance(rutaLogo);
            logo.scaleToFit(240, 120); // ↑ Más grande: 240x120
            logo.setAlignment(Image.ALIGN_LEFT);
            documento.add(logo);
            }
        } catch (Exception e) {
            System.out.println("Logo no disponible: " + e.getMessage());
        }

        // Título principal
        Paragraph titulo = new Paragraph("REPORTE DE ACTIVOS INTANGIBLES", 
                FontFactory.getFont(FontFactory.HELVETICA_BOLD, 20, BaseColor.DARK_GRAY));
        titulo.setAlignment(Element.ALIGN_CENTER);
        titulo.setSpacingAfter(10f);
        documento.add(titulo);

        // Fecha de generación
        Paragraph fechaReporte = new Paragraph("Generado el: " + new java.util.Date(),
                FontFactory.getFont(FontFactory.HELVETICA, 10, BaseColor.GRAY));
        fechaReporte.setAlignment(Element.ALIGN_CENTER);
        fechaReporte.setSpacingAfter(20f);
        documento.add(fechaReporte);
    }
    
    private void generarTablaActivos(Document documento) throws DocumentException {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            // Conexión a la base de datos
            Class.forName("org.postgresql.Driver");
            con = DriverManager.getConnection(
                "jdbc:postgresql://localhost:5432/activosdb", "postgres", "Hachi062018#");

            String sql = 
                "SELECT i.id, i.nombre, i.tipo_licencia, i.valor, i.fecha_adquisicion, i.vida_util, i.departamento, " +
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
                "ORDER BY i.departamento, i.nombre";

            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            // Crear tabla
            PdfPTable tabla = crearTabla();
            
            boolean hayDatos = false;
            DecimalFormat df = new DecimalFormat("#,##0.00");
            double totalValor = 0;
            double totalAmortAcumulada = 0;
            double totalValorLibros = 0;

            while (rs.next()) {
                hayDatos = true;
                
                // Obtener datos
                String nombre = rs.getString("nombre");
                String tipo = rs.getString("tipo_licencia");
                double valor = rs.getDouble("valor");
                Date fechaAdq = rs.getDate("fecha_adquisicion");
                int vidaUtil = rs.getInt("vida_util");
                String departamento = rs.getString("departamento");
                double amortizacionMensual = rs.getDouble("amortizacion_mensual");
                double amortizacionAcumulada = rs.getDouble("amortizacion_acumulada");
                double valorEnLibros = rs.getDouble("valor_en_libros");
                
                // Acumular totales
                totalValor += valor;
                totalAmortAcumulada += amortizacionAcumulada;
                totalValorLibros += valorEnLibros;
                
                // Agregar fila a la tabla
                agregarFilaTabla(tabla, nombre, tipo, valor, fechaAdq, vidaUtil, 
                               amortizacionMensual, amortizacionAcumulada, valorEnLibros, 
                               departamento, df);
            }

            if (hayDatos) {
                documento.add(tabla);
                // Agregar resumen
                agregarResumen(documento, totalValor, totalAmortAcumulada, totalValorLibros, df);
            } else {
                Paragraph noData = new Paragraph("No hay activos intangibles registrados en el sistema.",
                        FontFactory.getFont(FontFactory.HELVETICA, 12, BaseColor.RED));
                noData.setAlignment(Element.ALIGN_CENTER);
                noData.setSpacingBefore(50f);
                documento.add(noData);
            }

        } catch (Exception e) {
            e.printStackTrace();
            documento.add(new Paragraph("Error accediendo a la base de datos: " + e.getMessage()));
        } finally {
            // Cerrar recursos
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (con != null) con.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
    
    private PdfPTable crearTabla() {
        // Crear tabla con 9 columnas
        PdfPTable tabla = new PdfPTable(9);
        tabla.setWidthPercentage(100);
        tabla.setSpacingBefore(15f);
        tabla.setSpacingAfter(20f);
        
        
        try {
            float[] widths = {3.0f, 2.5f, 1.5f, 1.8f, 1.2f, 1.8f, 1.8f, 1.8f, 2.0f};
            tabla.setWidths(widths);
        } catch (DocumentException e) {
            System.out.println("Usando anchos automáticos para la tabla");
        }

        // Encabezados de tabla
        Font headerFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 9, BaseColor.WHITE);
        BaseColor headerBg = new BaseColor(0, 63, 107); // Azul corporativo
        
        String[] headers = {
            "Nombre", "Tipo", "Valor", "Fecha Adquisición", 
            "Vida Útil", "Amort. Mensual", "Amort. Acumulada", 
            "Valor en Libros", "Departamento"
        };

        for (String header : headers) {
            PdfPCell cell = new PdfPCell(new Phrase(header, headerFont));
            cell.setBackgroundColor(headerBg);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setPadding(5);
            tabla.addCell(cell);
        }
        
        return tabla;
    }
    
    private void agregarFilaTabla(PdfPTable tabla, String nombre, String tipo, double valor, 
                                Date fechaAdq, int vidaUtil, double amortMensual, 
                                double amortAcumulada, double valorLibros, String departamento, 
                                DecimalFormat df) {
        
        Font dataFont = FontFactory.getFont(FontFactory.HELVETICA, 8);
        Font boldFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 8);
        
        // Nombre
        tabla.addCell(new Phrase(nombre, dataFont));
        
        // Tipo
        tabla.addCell(new Phrase(tipo, dataFont));
        
        // Valor
        tabla.addCell(new Phrase("$" + df.format(valor), dataFont));
        
        // Fecha Adquisición
        tabla.addCell(new Phrase(fechaAdq.toString(), dataFont));
        
        // Vida Útil
        tabla.addCell(new Phrase(vidaUtil + " meses", dataFont));
        
        // Amortización Mensual
        tabla.addCell(new Phrase("$" + df.format(amortMensual), dataFont));
        
        // Amortización Acumulada
        tabla.addCell(new Phrase("$" + df.format(amortAcumulada), dataFont));
        
        // Valor en Libros (destacado)
        PdfPCell valorLibrosCell = new PdfPCell(new Phrase("$" + df.format(valorLibros), 
            valorLibros > 0 ? boldFont : dataFont));
        if (valorLibros > 0) {
            valorLibrosCell.setBackgroundColor(new BaseColor(220, 255, 220)); // Verde claro para valores positivos
        }
        valorLibrosCell.setHorizontalAlignment(Element.ALIGN_CENTER);
        tabla.addCell(valorLibrosCell);
        
        // Departamento
        String deptoFormateado = departamento != null && "disño".equalsIgnoreCase(departamento.trim()) 
                               ? "Diseño" : departamento;
        tabla.addCell(new Phrase(deptoFormateado, dataFont));
    }
    
    private void agregarResumen(Document documento, double totalValor, double totalAmortAcumulada, 
                              double totalValorLibros, DecimalFormat df) throws DocumentException {
        
        // Tabla de resumen
        PdfPTable tablaResumen = new PdfPTable(2);
        tablaResumen.setWidthPercentage(50);
        tablaResumen.setHorizontalAlignment(Element.ALIGN_CENTER);
        tablaResumen.setSpacingBefore(25f);
        
        BaseColor resumenBg = new BaseColor(240, 240, 240);
        Font resumenFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10);
        Font valorFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10, BaseColor.DARK_GRAY);
        
        // Filas del resumen
        agregarFilaResumen(tablaResumen, "Valor Total de Activos:", "$" + df.format(totalValor), 
                          resumenBg, resumenFont, valorFont);
        agregarFilaResumen(tablaResumen, "Amortización Total Acumulada:", "$" + df.format(totalAmortAcumulada), 
                          resumenBg, resumenFont, valorFont);
        agregarFilaResumen(tablaResumen, "Valor Total en Libros:", "$" + df.format(totalValorLibros), 
                          new BaseColor(200, 230, 200), resumenFont, valorFont);
        
        documento.add(tablaResumen);
    }
    
    private void agregarFilaResumen(PdfPTable tabla, String concepto, String valor, 
                                  BaseColor bgColor, Font fontConcepto, Font fontValor) {
        
        PdfPCell cellConcepto = new PdfPCell(new Phrase(concepto, fontConcepto));
        cellConcepto.setBackgroundColor(bgColor);
        cellConcepto.setBorderWidth(1);
        cellConcepto.setPadding(8);
        cellConcepto.setHorizontalAlignment(Element.ALIGN_LEFT);
        tabla.addCell(cellConcepto);
        
        PdfPCell cellValor = new PdfPCell(new Phrase(valor, fontValor));
        cellValor.setBorderWidth(1);
        cellValor.setPadding(8);
        cellValor.setHorizontalAlignment(Element.ALIGN_RIGHT);
        tabla.addCell(cellValor);
    }
    
    private void agregarPiePagina(Document documento) throws DocumentException {
        Paragraph piePagina = new Paragraph("ByteControl - Sistema de Gestión de Activos Intangibles\n" +
                                          "Reporte generado automáticamente",
                FontFactory.getFont(FontFactory.HELVETICA_OBLIQUE, 8, BaseColor.GRAY));
        piePagina.setAlignment(Element.ALIGN_CENTER);
        piePagina.setSpacingBefore(25f);
        documento.add(piePagina);
    }
}