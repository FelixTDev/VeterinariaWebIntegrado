CREATE DATABASE IF NOT EXISTS veterinaria_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE veterinaria_db;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS auditoria;
DROP TABLE IF EXISTS detalle_comprobante;
DROP TABLE IF EXISTS comprobante;
DROP TABLE IF EXISTS detalle_atencion_producto;
DROP TABLE IF EXISTS atencion_clinica;
DROP TABLE IF EXISTS cita;
DROP TABLE IF EXISTS movimiento_inventario;
DROP TABLE IF EXISTS producto;
DROP TABLE IF EXISTS mascota;
DROP TABLE IF EXISTS cliente;
DROP TABLE IF EXISTS usuario;
DROP TABLE IF EXISTS rol;
DROP TABLE IF EXISTS especie;
DROP TABLE IF EXISTS tipo_producto;

SET FOREIGN_KEY_CHECKS = 1;

SOURCE ../bd_veterinaria_mysql.sql;

CREATE TABLE auditoria (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT,
    modulo VARCHAR(50) NOT NULL,
    accion VARCHAR(50) NOT NULL,
    descripcion VARCHAR(255) NOT NULL,
    fecha_evento DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_auditoria_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
) ENGINE=InnoDB;
