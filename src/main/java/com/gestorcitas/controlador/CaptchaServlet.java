package com.gestorcitas.controlador;

import java.awt.image.BufferedImage;
import java.io.IOException;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.gestorcitas.util.CaptchaUtil;

@WebServlet("/captcha")
public class CaptchaServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Configurar la respuesta
        response.setContentType("image/jpeg");
        response.setHeader("Cache-Control", "no-store");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        // Generar el CAPTCHA
        String captchaText = CaptchaUtil.generateCaptchaText();
        BufferedImage image = CaptchaUtil.generateCaptchaImage(captchaText);

        // Guardar el texto en la sesión
        HttpSession session = request.getSession();
        session.setAttribute("captchaCode", captchaText);

        // Enviar la imagen
        ImageIO.write(image, "jpg", response.getOutputStream());
    }
} 