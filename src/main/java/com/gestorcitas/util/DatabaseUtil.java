package com.gestorcitas.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.TimeUnit;

public class DatabaseUtil {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/gestor_citas";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "";
    private static final int MAX_CONNECTIONS = 10;
    private static final int CONNECTION_TIMEOUT = 5; // segundos
    private static final int MAX_RETRIES = 3;
    
    private static List<Connection> connectionPool = new ArrayList<>();
    private static List<Connection> usedConnections = new ArrayList<>();

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            // Inicializar el pool de conexiones
            for (int i = 0; i < MAX_CONNECTIONS; i++) {
                try {
                    connectionPool.add(createConnection());
                } catch (SQLException e) {
                    throw new RuntimeException("Error al crear conexión inicial", e);
                }
            }
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Error al cargar el driver de MySQL", e);
        }
    }

    private static Connection createConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }

    public static synchronized Connection getConnection() throws SQLException {
        int retries = 0;
        while (retries < MAX_RETRIES) {
            if (connectionPool.isEmpty()) {
                if (usedConnections.size() < MAX_CONNECTIONS) {
                    try {
                        connectionPool.add(createConnection());
                    } catch (SQLException e) {
                        retries++;
                        if (retries == MAX_RETRIES) {
                            throw new SQLException("No se pudo crear una nueva conexión después de " + MAX_RETRIES + " intentos", e);
                        }
                        try {
                            TimeUnit.SECONDS.sleep(1); // Esperar 1 segundo antes de reintentar
                        } catch (InterruptedException ie) {
                            Thread.currentThread().interrupt();
                            throw new SQLException("Interrumpido mientras se esperaba para crear conexión", ie);
                        }
                        continue;
                    }
                } else {
                    throw new SQLException("No hay conexiones disponibles en el pool");
                }
            }

            Connection connection = connectionPool.remove(connectionPool.size() - 1);
            try {
                if (!connection.isValid(CONNECTION_TIMEOUT)) {
                    connection.close();
                    connection = createConnection();
                }
                usedConnections.add(connection);
                return connection;
            } catch (SQLException e) {
                retries++;
                if (retries == MAX_RETRIES) {
                    throw new SQLException("No se pudo obtener una conexión válida después de " + MAX_RETRIES + " intentos", e);
                }
            }
        }
        throw new SQLException("No se pudo obtener una conexión después de varios intentos");
    }

    public static synchronized void releaseConnection(Connection connection) {
        if (connection != null) {
            try {
                if (!connection.isClosed() && connection.isValid(CONNECTION_TIMEOUT)) {
                    usedConnections.remove(connection);
                    connectionPool.add(connection);
                } else {
                    connection.close();
                }
            } catch (SQLException e) {
                try {
                    connection.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }
    }

    public static void closeAllConnections() {
        for (Connection connection : usedConnections) {
            try {
                if (connection != null && !connection.isClosed()) {
                    connection.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        for (Connection connection : connectionPool) {
            try {
                if (connection != null && !connection.isClosed()) {
                    connection.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        connectionPool.clear();
        usedConnections.clear();
    }
} 