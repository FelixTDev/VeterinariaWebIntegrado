package com.veterinaria.util;

import com.veterinaria.exception.AppException;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public final class Database {
    private static final Properties PROPERTIES = new Properties();

    static {
        try (InputStream input = Database.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (input == null) {
                throw new AppException("No se encontró db.properties.");
            }
            PROPERTIES.load(input);
            Class.forName(PROPERTIES.getProperty("db.driver"));
        } catch (IOException | ClassNotFoundException ex) {
            throw new ExceptionInInitializerError(ex);
        }
    }

    private Database() {
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(
                PROPERTIES.getProperty("db.url"),
                PROPERTIES.getProperty("db.user"),
                PROPERTIES.getProperty("db.password")
        );
    }
}
