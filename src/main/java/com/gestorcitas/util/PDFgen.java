package com.gestorcitas.util;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;

import com.gestorcitas.modelo.Cita;
import com.gestorcitas.modelo.Doctor;
import com.gestorcitas.modelo.Paciente;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.FontFactory;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.pdf.PdfWriter;


public class PDFgen {
    
    //Se definen las fuentes con las que se generara el PDF
    private static final Font TITULO = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 16);
    private static final Font SUBTITULO = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 14);
    private static final Font TEXTO_NORMAL = FontFactory.getFont(FontFactory.HELVETICA, 12);
    private static final Font TEXTO_NEGRITA = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12);
    private static final Font TEXTO_PEQUEÑO = FontFactory.getFont(FontFactory.HELVETICA, 10);

    public static byte[] genComprobanteCita(Cita cita) throws DocumentException, IOException {

        Document document = new Document();
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        PdfWriter.getInstance(document, baos);

        Paciente paciente = cita.getPaciente();
        Doctor doctor = cita.getDoctor();

        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");

        document.open();

        Paragraph titulo = new Paragraph("COMPROBANTE DE CITA", TITULO);
        titulo.setAlignment(Element.ALIGN_CENTER);
        titulo.setSpacingBefore(15);
        titulo.setSpacingAfter(15);

        document.add(titulo);

        //Info del paciente
        document.add(new Paragraph("INFORMACION DEL PACIENTE", SUBTITULO));
        document.add(new Paragraph("Nombre: " + paciente.getNombres() + paciente.getApellidos(), TEXTO_NORMAL));
        document.add(new Paragraph("Documento de identidad: " + paciente.getDni(), TEXTO_NORMAL));

        //Info de la cita
        document.add(new Paragraph("INFORMACION DE LA CITA", SUBTITULO));
        document.add(new Paragraph("Medico: " + doctor.getNombres() + doctor.getApellidos(), TEXTO_NORMAL));
        document.add(new Paragraph("Fecha: " + cita.getFecha(), TEXTO_NORMAL));
        document.add(new Paragraph("Hora: " + cita.getHora(), TEXTO_NORMAL));

        document.add(new Paragraph("Fecha de generación: " + sdf.format(new java.util.Date()), TEXTO_PEQUEÑO));


        document.close();

        return baos.toByteArray();


    }


}
