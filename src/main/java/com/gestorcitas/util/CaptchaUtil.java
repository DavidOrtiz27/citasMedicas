package com.gestorcitas.util;

import java.awt.Color;
import java.awt.Font;
import java.awt.FontMetrics;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.util.Random;

public class CaptchaUtil {
    private static final String CHARACTERS = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
    private static final int WIDTH = 125;
    private static final int HEIGHT = 45;
    private static final Random RANDOM = new Random();

    public static String generateCaptchaText() {
        StringBuilder captchaText = new StringBuilder();
        for (int i = 0; i < 5; i++) {
            captchaText.append(CHARACTERS.charAt(RANDOM.nextInt(CHARACTERS.length())));
        }
        return captchaText.toString();
    }

    public static BufferedImage generateCaptchaImage(String captchaText) {
        BufferedImage image = new BufferedImage(WIDTH, HEIGHT, BufferedImage.TYPE_INT_RGB);
        Graphics2D g2d = image.createGraphics();

        // Fondo blanco
        g2d.setColor(Color.WHITE);
        g2d.fillRect(0, 0, WIDTH, HEIGHT);

        // Agregar ruido
        g2d.setColor(Color.LIGHT_GRAY);
        for (int i = 0; i < 50; i++) {
            int x = RANDOM.nextInt(WIDTH);
            int y = RANDOM.nextInt(HEIGHT);
            g2d.drawLine(x, y, x + RANDOM.nextInt(10), y + RANDOM.nextInt(10));
        }

        // Dibujar texto
        g2d.setColor(Color.BLUE);
        g2d.setFont(new Font("Arial", Font.BOLD, 30));
        FontMetrics fm = g2d.getFontMetrics();
        int x = (WIDTH - fm.stringWidth(captchaText)) / 2;
        int y = ((HEIGHT - fm.getHeight()) / 2) + fm.getAscent();
        g2d.drawString(captchaText, x, y);

        g2d.dispose();
        return image;
    }

    public static boolean validateCaptcha(String captchaCode, String userInput) {
        return captchaCode != null && userInput != null && 
               captchaCode.equalsIgnoreCase(userInput);
    }
} 