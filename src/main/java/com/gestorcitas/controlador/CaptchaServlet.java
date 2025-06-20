package com.gestorcitas.controlador;

import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics2D;
import java.awt.RenderingHints;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.util.Random;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "CaptchaServlet", urlPatterns = {"/captcha", "/publico/captcha"})
public class CaptchaServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final int WIDTH = 150;
    private static final int HEIGHT = 50;
    private static final String CHARS = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
    private static final Random RANDOM = new Random();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // Asegurar que la sesión existe y no se reinicia
            HttpSession session = request.getSession(false);
            if (session == null) {
                session = request.getSession(true);
            }
            
            // Generar código CAPTCHA
            String captchaCode = generateCaptchaCode();
            
            // Log para depuración
            System.out.println("Nuevo CAPTCHA generado: [" + captchaCode + "]");
            System.out.println("ID de sesión: " + session.getId());
            
            // Guardar código en la sesión
            session.setAttribute("captcha", captchaCode);
            
            // Log para verificar que se guardó en sesión
            String captchaGuardado = (String) session.getAttribute("captcha");
            System.out.println("CAPTCHA guardado en sesión: [" + captchaGuardado + "]");
            
            // Generar imagen
            BufferedImage image = generateCaptchaImage(captchaCode);
            
            // Enviar imagen como respuesta
            response.setContentType("image/png");
            response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
            response.setHeader("Pragma", "no-cache");
            response.setDateHeader("Expires", 0);
            response.setHeader("Access-Control-Allow-Origin", "*");
            
            // Escribir la imagen en la respuesta
            try (var out = response.getOutputStream()) {
                ImageIO.write(image, "png", out);
                out.flush();
            }
            
            System.out.println("Imagen CAPTCHA enviada correctamente");
        } catch (Exception e) {
            System.err.println("Error al generar CAPTCHA: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error al generar CAPTCHA");
        }
    }
    
    private String generateCaptchaCode() {
        StringBuilder code = new StringBuilder();
        for (int i = 0; i < 6; i++) {
            code.append(CHARS.charAt(RANDOM.nextInt(CHARS.length())));
        }
        return code.toString();
    }
    
    private BufferedImage generateCaptchaImage(String code) {
        BufferedImage image = new BufferedImage(WIDTH, HEIGHT, BufferedImage.TYPE_INT_RGB);
        Graphics2D g2d = image.createGraphics();
        
        // Configurar calidad de renderizado
        g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        g2d.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING, RenderingHints.VALUE_TEXT_ANTIALIAS_ON);
        
        // Fondo
        g2d.setColor(new Color(240, 240, 240));
        g2d.fillRect(0, 0, WIDTH, HEIGHT);
        
        // Líneas de fondo
        g2d.setColor(new Color(200, 200, 200));
        for (int i = 0; i < 10; i++) {
            int x1 = RANDOM.nextInt(WIDTH);
            int y1 = RANDOM.nextInt(HEIGHT);
            int x2 = RANDOM.nextInt(WIDTH);
            int y2 = RANDOM.nextInt(HEIGHT);
            g2d.drawLine(x1, y1, x2, y2);
        }
        
        // Texto
        g2d.setFont(new Font("Arial", Font.BOLD, 30));
        for (int i = 0; i < code.length(); i++) {
            g2d.setColor(new Color(RANDOM.nextInt(100), RANDOM.nextInt(100), RANDOM.nextInt(100)));
            int x = 20 + (i * 20);
            int y = 35 + RANDOM.nextInt(10);
            g2d.drawString(String.valueOf(code.charAt(i)), x, y);
        }
        
        g2d.dispose();
        return image;
    }
} 