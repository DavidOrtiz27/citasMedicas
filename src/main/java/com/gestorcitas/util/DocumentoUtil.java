package com.gestorcitas.util;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import com.gestorcitas.modelo.Cita;
import com.gestorcitas.modelo.Doctor;
import com.gestorcitas.modelo.Paciente;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;

public class DocumentoUtil {
    
    public static void generarComprobanteCita(Cita cita, HttpServletResponse response) throws IOException, DocumentException {
        Document document = new Document();
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=comprobante_cita.pdf");
        
        PdfWriter.getInstance(document, response.getOutputStream());
        document.open();
        
        // Título
        com.itextpdf.text.Font titleFont = new com.itextpdf.text.Font(com.itextpdf.text.Font.FontFamily.HELVETICA, 18, com.itextpdf.text.Font.BOLD);
        Paragraph title = new Paragraph("Comprobante de Cita Médica", titleFont);
        title.setAlignment(Element.ALIGN_CENTER);
        title.setSpacingAfter(20);
        document.add(title);
        
        // Información de la cita
        PdfPTable table = new PdfPTable(2);
        table.setWidthPercentage(100);
        
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
        
        agregarFilaTabla(table, "Fecha y Hora:", sdf.format(cita.getFecha()));
        agregarFilaTabla(table, "Doctor:", cita.getDoctor().getNombres() + " " + cita.getDoctor().getApellidos());
        agregarFilaTabla(table, "Especialidad:", cita.getDoctor().getEspecialidad().getNombre());
        agregarFilaTabla(table, "Paciente:", cita.getPaciente().getNombres() + " " + cita.getPaciente().getApellidos());
        agregarFilaTabla(table, "DNI:", cita.getPaciente().getDni());
        agregarFilaTabla(table, "Estado:", cita.getEstado());
        
        document.add(table);
        
        // Pie de página
        Paragraph footer = new Paragraph("Este documento es un comprobante oficial de su cita médica.", 
                new com.itextpdf.text.Font(com.itextpdf.text.Font.FontFamily.HELVETICA, 10, com.itextpdf.text.Font.ITALIC));
        footer.setAlignment(Element.ALIGN_CENTER);
        footer.setSpacingBefore(20);
        document.add(footer);
        
        document.close();
    }
    
    public static void generarReporteCitas(List<Cita> citas, HttpServletResponse response) throws IOException {
        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("Citas");
        
        // Crear estilos
        CellStyle headerStyle = workbook.createCellStyle();
        headerStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
        headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        Font headerFont = workbook.createFont();
        headerFont.setBold(true);
        headerStyle.setFont(headerFont);
        
        // Crear encabezados
        Row headerRow = sheet.createRow(0);
        String[] headers = {"Fecha", "Hora", "Doctor", "Especialidad", "Paciente", "DNI", "Estado"};
        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(headerStyle);
        }
        
        // Llenar datos
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
        
        int rowNum = 1;
        for (Cita cita : citas) {
            Row row = sheet.createRow(rowNum++);
            row.createCell(0).setCellValue(sdf.format(cita.getFecha()));
            row.createCell(1).setCellValue(timeFormat.format(cita.getFecha()));
            row.createCell(2).setCellValue(cita.getDoctor().getNombres() + " " + cita.getDoctor().getApellidos());
            row.createCell(3).setCellValue(cita.getDoctor().getEspecialidad().getNombre());
            row.createCell(4).setCellValue(cita.getPaciente().getNombres() + " " + cita.getPaciente().getApellidos());
            row.createCell(5).setCellValue(cita.getPaciente().getDni());
            row.createCell(6).setCellValue(cita.getEstado());
        }
        
        // Ajustar ancho de columnas
        for (int i = 0; i < headers.length; i++) {
            sheet.autoSizeColumn(i);
        }
        
        // Configurar respuesta
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=reporte_citas.xlsx");
        
        workbook.write(response.getOutputStream());
        workbook.close();
    }
    
    private static void agregarFilaTabla(PdfPTable table, String label, String value) {
        com.itextpdf.text.Font labelFont = new com.itextpdf.text.Font(com.itextpdf.text.Font.FontFamily.HELVETICA, 12, com.itextpdf.text.Font.BOLD);
        com.itextpdf.text.Font valueFont = new com.itextpdf.text.Font(com.itextpdf.text.Font.FontFamily.HELVETICA, 12, com.itextpdf.text.Font.NORMAL);
        
        com.itextpdf.text.Phrase labelPhrase = new com.itextpdf.text.Phrase(label, labelFont);
        com.itextpdf.text.Phrase valuePhrase = new com.itextpdf.text.Phrase(value, valueFont);
        
        table.addCell(labelPhrase);
        table.addCell(valuePhrase);
    }
    
    public static File generarExcelCitas(List<Cita> citas, String rutaArchivo) throws IOException {
        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("Citas");
            
            // Crear estilo para el encabezado
            CellStyle headerStyle = workbook.createCellStyle();
            headerStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
            headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            Font headerFont = workbook.createFont();
            headerFont.setBold(true);
            headerStyle.setFont(headerFont);
            
            // Crear encabezados
            Row headerRow = sheet.createRow(0);
            String[] columnas = {"ID", "Fecha", "Hora", "Doctor", "Paciente", "Estado"};
            for (int i = 0; i < columnas.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(columnas[i]);
                cell.setCellStyle(headerStyle);
            }
            
            // Llenar datos
            int rowNum = 1;
            for (Cita cita : citas) {
                Row row = sheet.createRow(rowNum++);
                row.createCell(0).setCellValue(cita.getId());
                row.createCell(1).setCellValue(cita.getFecha().toString());
                row.createCell(2).setCellValue(cita.getHora());
                
                Doctor doctor = cita.getDoctor();
                String nombreDoctor = doctor.getNombres() + " " + doctor.getApellidos();
                row.createCell(3).setCellValue(nombreDoctor);
                
                Paciente paciente = cita.getPaciente();
                String nombrePaciente = paciente.getNombres() + " " + paciente.getApellidos();
                row.createCell(4).setCellValue(nombrePaciente);
                
                row.createCell(5).setCellValue(cita.getEstado());
            }
            
            // Ajustar ancho de columnas
            for (int i = 0; i < columnas.length; i++) {
                sheet.autoSizeColumn(i);
            }
            
            // Guardar archivo
            try (FileOutputStream fileOut = new FileOutputStream(rutaArchivo)) {
                workbook.write(fileOut);
            }
            
            return new File(rutaArchivo);
        }
    }
    
    public static File generarExcelDoctores(List<Doctor> doctores, String rutaArchivo) throws IOException {
        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("Doctores");
            
            // Crear estilo para el encabezado
            CellStyle headerStyle = workbook.createCellStyle();
            headerStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
            headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            Font headerFont = workbook.createFont();
            headerFont.setBold(true);
            headerStyle.setFont(headerFont);
            
            // Crear encabezados
            Row headerRow = sheet.createRow(0);
            String[] columnas = {"ID", "Nombres", "Apellidos", "Especialidad", "Email", "Teléfono"};
            for (int i = 0; i < columnas.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(columnas[i]);
                cell.setCellStyle(headerStyle);
            }
            
            // Llenar datos
            int rowNum = 1;
            for (Doctor doctor : doctores) {
                Row row = sheet.createRow(rowNum++);
                row.createCell(0).setCellValue(doctor.getId());
                row.createCell(1).setCellValue(doctor.getNombres());
                row.createCell(2).setCellValue(doctor.getApellidos());
                row.createCell(3).setCellValue(doctor.getEspecialidad().getNombre());
                row.createCell(4).setCellValue(doctor.getEmail());
                row.createCell(5).setCellValue(doctor.getTelefono());
            }
            
            // Ajustar ancho de columnas
            for (int i = 0; i < columnas.length; i++) {
                sheet.autoSizeColumn(i);
            }
            
            // Guardar archivo
            try (FileOutputStream fileOut = new FileOutputStream(rutaArchivo)) {
                workbook.write(fileOut);
            }
            
            return new File(rutaArchivo);
        }
    }
} 