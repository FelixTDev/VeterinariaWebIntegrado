DROP DATABASE IF EXISTS veterinaria_db;

CREATE DATABASE veterinaria_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE veterinaria_db;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS detalle_comprobante;
DROP TABLE IF EXISTS comprobante;
DROP TABLE IF EXISTS auditoria;
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

CREATE TABLE rol (
    id_rol INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(30) NOT NULL,
    descripcion VARCHAR(120),
    estado ENUM('ACTIVO', 'INACTIVO') NOT NULL DEFAULT 'ACTIVO',
    UNIQUE KEY uk_rol_nombre (nombre)
) ENGINE=InnoDB;

CREATE TABLE usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    id_rol INT NOT NULL,
    nombres VARCHAR(80) NOT NULL,
    apellidos VARCHAR(80) NOT NULL,
    dni VARCHAR(15) NOT NULL,
    telefono VARCHAR(20),
    correo VARCHAR(120),
    username VARCHAR(40) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    estado ENUM('ACTIVO', 'INACTIVO', 'BLOQUEADO') NOT NULL DEFAULT 'ACTIVO',
    fecha_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_usuario_dni (dni),
    UNIQUE KEY uk_usuario_username (username),
    UNIQUE KEY uk_usuario_correo (correo),
    CONSTRAINT fk_usuario_rol
        FOREIGN KEY (id_rol) REFERENCES rol(id_rol)
) ENGINE=InnoDB;

CREATE TABLE cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombres VARCHAR(80) NOT NULL,
    apellidos VARCHAR(80) NOT NULL,
    dni VARCHAR(15) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    correo VARCHAR(120),
    direccion VARCHAR(180) NOT NULL,
    estado ENUM('ACTIVO', 'INACTIVO') NOT NULL DEFAULT 'ACTIVO',
    fecha_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_cliente_dni (dni),
    UNIQUE KEY uk_cliente_correo (correo)
) ENGINE=InnoDB;

CREATE TABLE especie (
    id_especie INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(120),
    estado ENUM('ACTIVO', 'INACTIVO') NOT NULL DEFAULT 'ACTIVO',
    UNIQUE KEY uk_especie_nombre (nombre)
) ENGINE=InnoDB;

CREATE TABLE mascota (
    id_mascota INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_especie INT NOT NULL,
    nombre VARCHAR(80) NOT NULL,
    raza VARCHAR(80),
    sexo ENUM('MACHO', 'HEMBRA', 'NO_DEFINIDO') NOT NULL DEFAULT 'NO_DEFINIDO',
    color VARCHAR(50),
    fecha_nacimiento DATE,
    peso DECIMAL(6,2),
    observaciones VARCHAR(255),
    estado ENUM('ACTIVO', 'INACTIVO', 'FALLECIDO') NOT NULL DEFAULT 'ACTIVO',
    fecha_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_mascota_cliente
        FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    CONSTRAINT fk_mascota_especie
        FOREIGN KEY (id_especie) REFERENCES especie(id_especie),
    CONSTRAINT chk_mascota_peso
        CHECK (peso IS NULL OR peso >= 0)
) ENGINE=InnoDB;

CREATE TABLE tipo_producto (
    id_tipo_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(120),
    estado ENUM('ACTIVO', 'INACTIVO') NOT NULL DEFAULT 'ACTIVO',
    UNIQUE KEY uk_tipo_producto_nombre (nombre)
) ENGINE=InnoDB;

CREATE TABLE producto (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    id_tipo_producto INT NOT NULL,
    codigo VARCHAR(30) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(180),
    stock INT NOT NULL DEFAULT 0,
    stock_minimo INT NOT NULL DEFAULT 0,
    precio_compra DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    precio_venta DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    fecha_vencimiento DATE,
    requiere_receta TINYINT(1) NOT NULL DEFAULT 0,
    estado ENUM('ACTIVO', 'INACTIVO') NOT NULL DEFAULT 'ACTIVO',
    fecha_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_producto_codigo (codigo),
    CONSTRAINT fk_producto_tipo
        FOREIGN KEY (id_tipo_producto) REFERENCES tipo_producto(id_tipo_producto),
    CONSTRAINT chk_producto_stock
        CHECK (stock >= 0),
    CONSTRAINT chk_producto_stock_minimo
        CHECK (stock_minimo >= 0),
    CONSTRAINT chk_producto_precios
        CHECK (precio_compra >= 0 AND precio_venta >= 0)
) ENGINE=InnoDB;

CREATE TABLE movimiento_inventario (
    id_movimiento INT AUTO_INCREMENT PRIMARY KEY,
    id_producto INT NOT NULL,
    id_usuario INT NOT NULL,
    tipo_movimiento ENUM('ENTRADA', 'SALIDA', 'AJUSTE', 'ANULACION') NOT NULL,
    motivo VARCHAR(150) NOT NULL,
    cantidad INT NOT NULL,
    stock_anterior INT NOT NULL,
    stock_nuevo INT NOT NULL,
    fecha_movimiento DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    referencia VARCHAR(80),
    CONSTRAINT fk_movimiento_producto
        FOREIGN KEY (id_producto) REFERENCES producto(id_producto),
    CONSTRAINT fk_movimiento_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
    CONSTRAINT chk_movimiento_cantidad
        CHECK (cantidad > 0),
    CONSTRAINT chk_movimiento_stock
        CHECK (stock_anterior >= 0 AND stock_nuevo >= 0)
) ENGINE=InnoDB;

CREATE TABLE cita (
    id_cita INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_mascota INT NOT NULL,
    id_veterinario INT,
    fecha_cita DATE NOT NULL,
    hora_cita TIME NOT NULL,
    motivo VARCHAR(180) NOT NULL,
    observaciones VARCHAR(255),
    estado ENUM('PENDIENTE', 'CONFIRMADA', 'ATENDIDA', 'CANCELADA', 'NO_ASISTIO') NOT NULL DEFAULT 'PENDIENTE',
    fecha_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_cita_cliente
        FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    CONSTRAINT fk_cita_mascota
        FOREIGN KEY (id_mascota) REFERENCES mascota(id_mascota),
    CONSTRAINT fk_cita_veterinario
        FOREIGN KEY (id_veterinario) REFERENCES usuario(id_usuario)
) ENGINE=InnoDB;

CREATE TABLE atencion_clinica (
    id_atencion INT AUTO_INCREMENT PRIMARY KEY,
    id_cita INT NOT NULL,
    id_mascota INT NOT NULL,
    id_veterinario INT NOT NULL,
    peso DECIMAL(6,2),
    temperatura DECIMAL(4,1),
    sintomas TEXT,
    diagnostico TEXT NOT NULL,
    tratamiento TEXT,
    observaciones TEXT,
    fecha_atencion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado ENUM('REGISTRADA', 'ANULADA') NOT NULL DEFAULT 'REGISTRADA',
    CONSTRAINT fk_atencion_cita
        FOREIGN KEY (id_cita) REFERENCES cita(id_cita),
    CONSTRAINT fk_atencion_mascota
        FOREIGN KEY (id_mascota) REFERENCES mascota(id_mascota),
    CONSTRAINT fk_atencion_veterinario
        FOREIGN KEY (id_veterinario) REFERENCES usuario(id_usuario),
    UNIQUE KEY uk_atencion_cita (id_cita),
    CONSTRAINT chk_atencion_peso
        CHECK (peso IS NULL OR peso >= 0)
) ENGINE=InnoDB;

CREATE TABLE auditoria (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT,
    modulo VARCHAR(60) NOT NULL,
    accion VARCHAR(40) NOT NULL,
    descripcion VARCHAR(255) NOT NULL,
    fecha_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_auditoria_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
) ENGINE=InnoDB;

CREATE TABLE detalle_atencion_producto (
    id_detalle_atencion INT AUTO_INCREMENT PRIMARY KEY,
    id_atencion INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    dosis VARCHAR(80),
    indicaciones VARCHAR(180),
    precio_unitario DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    subtotal DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    CONSTRAINT fk_detalle_atencion
        FOREIGN KEY (id_atencion) REFERENCES atencion_clinica(id_atencion),
    CONSTRAINT fk_detalle_atencion_producto
        FOREIGN KEY (id_producto) REFERENCES producto(id_producto),
    CONSTRAINT chk_detalle_atencion_cantidad
        CHECK (cantidad > 0),
    CONSTRAINT chk_detalle_atencion_montos
        CHECK (precio_unitario >= 0 AND subtotal >= 0)
) ENGINE=InnoDB;

CREATE TABLE comprobante (
    id_comprobante INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_mascota INT,
    id_usuario INT NOT NULL,
    id_atencion INT,
    numero_comprobante VARCHAR(30) NOT NULL,
    tipo_comprobante ENUM('BOLETA', 'FACTURA', 'RECIBO') NOT NULL DEFAULT 'BOLETA',
    fecha_emision DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    subtotal DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    impuesto DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    total DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    metodo_pago ENUM('EFECTIVO', 'TARJETA', 'YAPE', 'PLIN', 'TRANSFERENCIA') NOT NULL DEFAULT 'EFECTIVO',
    estado ENUM('EMITIDO', 'PAGADO', 'ANULADO') NOT NULL DEFAULT 'EMITIDO',
    observaciones VARCHAR(255),
    UNIQUE KEY uk_comprobante_numero (numero_comprobante),
    CONSTRAINT fk_comprobante_cliente
        FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    CONSTRAINT fk_comprobante_mascota
        FOREIGN KEY (id_mascota) REFERENCES mascota(id_mascota),
    CONSTRAINT fk_comprobante_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
    CONSTRAINT fk_comprobante_atencion
        FOREIGN KEY (id_atencion) REFERENCES atencion_clinica(id_atencion),
    CONSTRAINT chk_comprobante_totales
        CHECK (subtotal >= 0 AND impuesto >= 0 AND total >= 0)
) ENGINE=InnoDB;

CREATE TABLE detalle_comprobante (
    id_detalle_comprobante INT AUTO_INCREMENT PRIMARY KEY,
    id_comprobante INT NOT NULL,
    tipo_item ENUM('PRODUCTO', 'SERVICIO') NOT NULL,
    id_producto INT,
    descripcion VARCHAR(180) NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    subtotal DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    CONSTRAINT fk_detalle_comprobante
        FOREIGN KEY (id_comprobante) REFERENCES comprobante(id_comprobante),
    CONSTRAINT fk_detalle_comprobante_producto
        FOREIGN KEY (id_producto) REFERENCES producto(id_producto),
    CONSTRAINT chk_detalle_comprobante_cantidad
        CHECK (cantidad > 0),
    CONSTRAINT chk_detalle_comprobante_montos
        CHECK (precio_unitario >= 0 AND subtotal >= 0)
) ENGINE=InnoDB;

CREATE INDEX idx_mascota_cliente ON mascota(id_cliente);
CREATE INDEX idx_mascota_nombre ON mascota(nombre);
CREATE INDEX idx_producto_nombre ON producto(nombre);
CREATE INDEX idx_producto_vencimiento ON producto(fecha_vencimiento);
CREATE INDEX idx_cita_fecha_estado ON cita(fecha_cita, estado);
CREATE INDEX idx_cita_mascota ON cita(id_mascota);
CREATE INDEX idx_atencion_mascota_fecha ON atencion_clinica(id_mascota, fecha_atencion);
CREATE INDEX idx_comprobante_fecha_estado ON comprobante(fecha_emision, estado);

INSERT INTO rol (nombre, descripcion) VALUES
('ADMINISTRADOR', 'Acceso total al sistema'),
('VETERINARIO', 'Gestion clinica y atencion medica'),
('RECEPCIONISTA', 'Registro de clientes, mascotas, citas y cobros');

INSERT INTO usuario (
    id_rol,
    nombres,
    apellidos,
    dni,
    telefono,
    correo,
    username,
    password_hash,
    estado
) VALUES
(1, 'Admin', 'Sistema', '00000000', '999999999', 'admin@veterinaria.com', 'admin', 'admin123', 'ACTIVO'),
(2, 'Luis', 'Quispe', '12345678', '987654321', 'lquispe@veterinaria.com', 'lquispe', 'vet123', 'ACTIVO'),
(3, 'Ana', 'Torres', '87654321', '912345678', 'atorres@veterinaria.com', 'atorres', 'recep123', 'ACTIVO');

INSERT INTO especie (nombre, descripcion) VALUES
('Perro', 'Caninos domesticos'),
('Gato', 'Felinos domesticos'),
('Conejo', 'Lagomorfos domesticos'),
('Ave', 'Aves domesticas'),
('Hamster', 'Roedores domesticos');

INSERT INTO tipo_producto (nombre, descripcion) VALUES
('Medicamento', 'Medicamentos de uso veterinario'),
('Vacuna', 'Vacunas veterinarias'),
('Inyeccion', 'Inyectables y aplicacion clinica'),
('Antiparasitario', 'Control interno y externo de parasitos'),
('Accesorio', 'Productos complementarios');

INSERT INTO cliente (
    nombres,
    apellidos,
    dni,
    telefono,
    correo,
    direccion,
    estado
) VALUES
('Carlos', 'Ramirez', '45879632', '987111222', 'carlos.ramirez@mail.com', 'Av. Los Olivos 145', 'ACTIVO'),
('Maria', 'Paredes', '74125896', '965444333', 'maria.paredes@mail.com', 'Jr. Las Flores 258', 'ACTIVO');

INSERT INTO mascota (
    id_cliente,
    id_especie,
    nombre,
    raza,
    sexo,
    color,
    fecha_nacimiento,
    peso,
    observaciones,
    estado
) VALUES
(1, 1, 'Firulais', 'Labrador', 'MACHO', 'Dorado', '2022-03-15', 18.50, 'Mascota amigable', 'ACTIVO'),
(2, 2, 'Mishi', 'Siames', 'HEMBRA', 'Blanco', '2023-07-10', 4.20, 'Control de vacunas al dia', 'ACTIVO');

INSERT INTO producto (
    id_tipo_producto,
    codigo,
    nombre,
    descripcion,
    stock,
    stock_minimo,
    precio_compra,
    precio_venta,
    fecha_vencimiento,
    requiere_receta,
    estado
) VALUES
(2, 'VAC-001', 'Vacuna Antirrabica', 'Vacuna preventiva para caninos y felinos', 25, 5, 18.00, 35.00, '2027-01-31', 0, 'ACTIVO'),
(3, 'INY-001', 'Ivermectina Inyectable', 'Inyectable antiparasitario', 15, 4, 10.00, 22.00, '2026-12-15', 1, 'ACTIVO'),
(1, 'MED-001', 'Amoxicilina Vet', 'Antibiotico de uso veterinario', 20, 5, 12.50, 28.00, '2027-05-20', 1, 'ACTIVO'),
(4, 'ANT-001', 'Pipeta Antipulgas', 'Control de pulgas y garrapatas', 30, 8, 14.00, 30.00, '2027-08-01', 0, 'ACTIVO');

INSERT INTO cita (
    id_cliente,
    id_mascota,
    id_veterinario,
    fecha_cita,
    hora_cita,
    motivo,
    observaciones,
    estado
) VALUES
(1, 1, 2, '2026-06-15', '10:00:00', 'Vacunacion general', 'Primera visita del mes', 'CONFIRMADA'),
(2, 2, 2, '2026-06-16', '16:30:00', 'Revision digestiva', 'Presenta falta de apetito', 'PENDIENTE');

INSERT INTO movimiento_inventario (
    id_producto,
    id_usuario,
    tipo_movimiento,
    motivo,
    cantidad,
    stock_anterior,
    stock_nuevo,
    referencia
) VALUES
(1, 1, 'ENTRADA', 'Carga inicial de inventario', 25, 0, 25, 'INIT-VAC-001'),
(2, 1, 'ENTRADA', 'Carga inicial de inventario', 15, 0, 15, 'INIT-INY-001'),
(3, 1, 'ENTRADA', 'Carga inicial de inventario', 20, 0, 20, 'INIT-MED-001'),
(4, 1, 'ENTRADA', 'Carga inicial de inventario', 30, 0, 30, 'INIT-ANT-001');

