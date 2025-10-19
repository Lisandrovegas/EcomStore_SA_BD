
-- 1. CREACIÓN DE TABLAS


CREATE TABLE CATEGORIA (
    categoria_id     NUMBER(10)    PRIMARY KEY,
    nombre           NVARCHAR2(100) NOT NULL,
    descripcion      NVARCHAR2(400)
);


CREATE TABLE PROVEEDOR (
    proveedor_id     NUMBER(10)    PRIMARY KEY,
    nombre           NVARCHAR2(100) NOT NULL,
    telefono         NVARCHAR2(50),
    email            NVARCHAR2(100) NOT NULL,
    pais             NVARCHAR2(50)
);


CREATE TABLE PRODUCTO (
    producto_id      NUMBER(10)    PRIMARY KEY,
    sku              NVARCHAR2(50)  NOT NULL,
    nombre           NVARCHAR2(200) NOT NULL,
    descripcion      NVARCHAR2(400),
    precio           NUMBER(10,2)   NOT NULL,
    categoria_id     NUMBER(10)     NOT NULL,
    proveedor_id     NUMBER(10)     NOT NULL
);


CREATE TABLE CLIENTE (
    cliente_id       NUMBER(10)     PRIMARY KEY,
    nombre           NVARCHAR2(100) NOT NULL,
    apellido         NVARCHAR2(100) NOT NULL,
    email            NVARCHAR2(150) NOT NULL,
    telefono         NVARCHAR2(20),
    fecha_registro   DATE           NOT NULL
);

CREATE TABLE DIRECCION (
    direccion_id     NUMBER(10)     PRIMARY KEY,
    cliente_id       NUMBER(10)     NOT NULL,
    direccion        NVARCHAR2(200) NOT NULL,
    ciudad           NVARCHAR2(100) NOT NULL,
    region           NVARCHAR2(100),
    pais             NVARCHAR2(100) NOT NULL,
    codigo_postal    NVARCHAR2(10),
    tipo             NVARCHAR2(20)  NOT NULL
);

CREATE TABLE PEDIDO (
    pedido_id        NUMBER(10)     PRIMARY KEY,
    cliente_id       NUMBER(10)     NOT NULL,
    direccion_envio_id NUMBER(10)   NOT NULL,
    fecha_pedido     DATE           NOT NULL,
    estado           NVARCHAR2(30)  NOT NULL,
    total_estimado   NUMBER(12,2)   NOT NULL
);


CREATE TABLE DETALLE_PEDIDO (
    detalle_id       NUMBER(10)     PRIMARY KEY,
    pedido_id        NUMBER(10)     NOT NULL,
    producto_id      NUMBER(10)     NOT NULL,
    cantidad         NUMBER(10)     NOT NULL,
    precio_unitario  NUMBER(10,2)   NOT NULL,
    subtotal         NUMBER(12,2)   NOT NULL
);


CREATE TABLE FACTURA (
    factura_id       NUMBER(10)     PRIMARY KEY,
    pedido_id        NUMBER(10)     NOT NULL,
    fecha_factura    DATE           NOT NULL,
    total            NUMBER(12,2)   NOT NULL,
    metodo_pago      NVARCHAR2(50)  NOT NULL,
    estado           NVARCHAR2(30)  NOT NULL
);


CREATE TABLE PAGO (
    pago_id          NUMBER(10)     PRIMARY KEY,
    factura_id       NUMBER(10)     NOT NULL,
    monto            NUMBER(12,2)   NOT NULL,
    fecha_pago       DATE           NOT NULL,
    metodo           NVARCHAR2(50)  NOT NULL,
    estado           NVARCHAR2(30)  NOT NULL
);


CREATE TABLE ENVIO (
    envio_id         NUMBER(10)     PRIMARY KEY,
    pedido_id        NUMBER(10)     NOT NULL,
    empresa_envio    NVARCHAR2(100) NOT NULL,
    numero_guia      NVARCHAR2(50)  NOT NULL,
    fecha_envio      DATE           NOT NULL,
    fecha_entrega    DATE,
    estado_envio     NVARCHAR2(30)  NOT NULL
);

CREATE TABLE HISTORIAL_PEDIDO (
    historial_id     NUMBER(10)     PRIMARY KEY,
    pedido_id        NUMBER(10)     NOT NULL,
    estado_anterior  NVARCHAR2(30),
    estado_nuevo     NVARCHAR2(30)  NOT NULL,
    fecha_cambio     DATE           NOT NULL
);


CREATE TABLE INVENTARIO (
    inventario_id    NUMBER(10)     PRIMARY KEY,
    producto_id      NUMBER(10)     NOT NULL,
    cantidad         NUMBER(10)     NOT NULL,
    ubicacion        NVARCHAR2(100)
);

CREATE TABLE ROL (
    rol_id           NUMBER(10)     PRIMARY KEY,
    nombre_rol       NVARCHAR2(50)  NOT NULL,
    descripcion      NVARCHAR2(200)
);

CREATE TABLE USUARIO (
    usuario_id       NUMBER(10)     PRIMARY KEY,
    rol_id           NUMBER(10)     NOT NULL,
    nombre_usuario   NVARCHAR2(50)  NOT NULL,
    contrasena       NVARCHAR2(100) NOT NULL,
    email            NVARCHAR2(100) NOT NULL,
    estado           NVARCHAR2(20)  NOT NULL
);


CREATE TABLE ALMACEN (
    almacen_id       NUMBER(10)     PRIMARY KEY,
    nombre           NVARCHAR2(100) NOT NULL,
    ubicacion        NVARCHAR2(200) NOT NULL
);


-- 2. CLAVES FORÁNEAS (RELACIONES)


-- PRODUCTO pertenece a una CATEGORÍA
ALTER TABLE PRODUCTO
ADD CONSTRAINT FK_PRODUCTO_CATEGORIA
FOREIGN KEY (categoria_id)
REFERENCES CATEGORIA (categoria_id);


-- PRODUCTO tiene un PROVEEDOR
ALTER TABLE PRODUCTO
ADD CONSTRAINT FK_PRODUCTO_PROVEEDOR
FOREIGN KEY (proveedor_id)
REFERENCES PROVEEDOR (proveedor_id);


-- DIRECCION pertenece a un CLIENTE
ALTER TABLE DIRECCION
ADD CONSTRAINT FK_DIRECCION_CLIENTE
FOREIGN KEY (cliente_id)
REFERENCES CLIENTE (cliente_id);

-- PEDIDO pertenece a un CLIENTE
ALTER TABLE PEDIDO
ADD CONSTRAINT FK_PEDIDO_CLIENTE
FOREIGN KEY (cliente_id)
REFERENCES CLIENTE (cliente_id);

-- PEDIDO usa una DIRECCIÓN
ALTER TABLE PEDIDO
ADD CONSTRAINT FK_PEDIDO_DIRECCION
FOREIGN KEY (direccion_envio_id)
REFERENCES DIRECCION (direccion_id);


-- DETALLE_PEDIDO pertenece a un PEDIDO
ALTER TABLE DETALLE_PEDIDO
ADD CONSTRAINT FK_DETALLE_PEDIDO_PEDIDO
FOREIGN KEY (pedido_id)
REFERENCES PEDIDO (pedido_id);


-- DETALLE_PEDIDO contiene un PRODUCTO
ALTER TABLE DETALLE_PEDIDO
ADD CONSTRAINT FK_DETALLE_PEDIDO_PRODUCTO
FOREIGN KEY (producto_id)
REFERENCES PRODUCTO (producto_id);


-- FACTURA pertenece a un PEDIDO
ALTER TABLE FACTURA
ADD CONSTRAINT FK_FACTURA_PEDIDO
FOREIGN KEY (pedido_id)
REFERENCES PEDIDO (pedido_id);

-- PAGO pertenece a una FACTURA
ALTER TABLE PAGO
ADD CONSTRAINT FK_PAGO_FACTURA
FOREIGN KEY (factura_id)
REFERENCES FACTURA (factura_id);

-- ENVIO pertenece a un PEDIDO
ALTER TABLE ENVIO
ADD CONSTRAINT FK_ENVIO_PEDIDO
FOREIGN KEY (pedido_id)
REFERENCES PEDIDO (pedido_id);


-- HISTORIAL_PEDIDO pertenece a un PEDIDO
ALTER TABLE HISTORIAL_PEDIDO
ADD CONSTRAINT FK_HISTORIAL_PEDIDO
FOREIGN KEY (pedido_id)
REFERENCES PEDIDO (pedido_id);


-- INVENTARIO depende de PRODUCTO
ALTER TABLE INVENTARIO
ADD CONSTRAINT FK_INVENTARIO_PRODUCTO
FOREIGN KEY (producto_id)
REFERENCES PRODUCTO (producto_id);

-- USUARIO pertenece a un ROL
ALTER TABLE USUARIO
ADD CONSTRAINT FK_USUARIO_ROL
FOREIGN KEY (rol_id)
REFERENCES ROL (rol_id);


-- 3. COMENTARIOS OPCIONALES

COMMENT ON TABLE PRODUCTO IS 'Contiene los productos tecnológicos vendidos por EcomStore';
COMMENT ON TABLE CLIENTE IS 'Registro de clientes que realizan compras en la plataforma';
COMMENT ON TABLE PEDIDO IS 'Pedidos realizados por los clientes, con su estado y total estimado';
COMMENT ON TABLE FACTURA IS 'Facturas emitidas por cada pedido realizado';
COMMENT ON TABLE ENVIO IS 'Información de envío de los pedidos a los clientes';
COMMENT ON TABLE INVENTARIO IS 'Control de stock de productos en almacén';
COMMENT ON TABLE USUARIO IS 'Usuarios con acceso al sistema (administradores y operadores)';


COMMIT;

-- 5. INSERCIÓN DE DATOS (DML - INSERT)

-- Categorías
INSERT INTO CATEGORIA VALUES (1, 'Laptops', 'Equipos portátiles de última generación');
INSERT INTO CATEGORIA VALUES (2, 'Smartphones', 'Teléfonos inteligentes con diferentes sistemas operativos');
INSERT INTO CATEGORIA VALUES (3, 'Accesorios', 'Periféricos y componentes electrónicos');

-- Proveedores
INSERT INTO PROVEEDOR VALUES (1, 'TechWorld', '987654321', 'ventas@techworld.com', 'Perú');
INSERT INTO PROVEEDOR VALUES (2, 'DigitalPro', '999112233', 'contacto@digitalpro.com', 'México');

-- Productos
INSERT INTO PRODUCTO VALUES (1, 'LTP001', 'Laptop Lenovo ThinkPad', '14 pulgadas, 16GB RAM, 512GB SSD', 3500.00, 1, 1);
INSERT INTO PRODUCTO VALUES (2, 'SMT002', 'iPhone 15 Pro', '256GB, Titanio azul', 6200.00, 2, 2);
INSERT INTO PRODUCTO VALUES (3, 'ACC003', 'Mouse Logitech', 'Inalámbrico con batería recargable', 120.00, 3, 1);
INSERT INTO PRODUCTO VALUES (3, 'ACC003', 'Mouse Logitech', 'Inalámbrico con batería recargable', 120.00, 3, 1);


-- Clientes
INSERT INTO CLIENTE VALUES (1, 'Carlos', 'Rojas', 'carlosr@gmail.com', '987456123', SYSDATE);
INSERT INTO CLIENTE VALUES (2, 'Ana', 'Mendoza', 'anam@gmail.com', '985621478', SYSDATE);
INSERT INTO CLIENTE VALUES (3, 'Jose', 'Saveedra', 'Josesav@gmail.com', '985689747', SYSDATE);

-- Direcciones
INSERT INTO DIRECCION VALUES (1, 1, 'Av. Primavera 123', 'Piura', 'Piura', 'Perú', '15074', 'Casa');
INSERT INTO DIRECCION VALUES (2, 2, 'Jr. Arequipa 678', 'Cusco', 'Cusco', 'Perú', '08002', 'Oficina');
INSERT INTO DIRECCION VALUES (3, 3, 'Jr. Junin 564', 'Piura', 'Piura', 'Perú', '13569', 'Casa');


-- Pedidos
INSERT INTO PEDIDO VALUES (1, 1, 1, SYSDATE, 'Pendiente', 3620.00);
INSERT INTO PEDIDO VALUES (2, 2, 2, SYSDATE, 'Entregado', 6200.00);
INSERT INTO PEDIDO VALUES (3, 3, 3, SYSDATE, 'Entregado',  2520.00);

-- Detalle de pedido
INSERT INTO DETALLE_PEDIDO VALUES (1, 1, 1, 1, 3500.00, 3500.00);
INSERT INTO DETALLE_PEDIDO VALUES (2, 1, 3, 1, 120.00, 120.00);
INSERT INTO DETALLE_PEDIDO VALUES (3, 2, 2, 1, 6200.00, 6200.00);

-- Facturas
INSERT INTO FACTURA VALUES (1, 1, SYSDATE, 3620.00, 'Tarjeta', 'Emitida');
INSERT INTO FACTURA VALUES (2, 2, SYSDATE, 6200.00, 'Efectivo', 'Pagada');

-- Pagos
INSERT INTO PAGO VALUES (1, 1, 3620.00, SYSDATE, 'Tarjeta', 'Completado');
INSERT INTO PAGO VALUES (2, 2, 6200.00, SYSDATE, 'Efectivo', 'Completado');

-- Envíos
INSERT INTO ENVIO VALUES (1, 1, 'Servientrega', 'GUIA001', SYSDATE, NULL, 'Pendiente');
INSERT INTO ENVIO VALUES (2, 2, 'Olva Courier', 'GUIA002', SYSDATE - 3, SYSDATE, 'Entregado');


-- Historial de pedidos
INSERT INTO HISTORIAL_PEDIDO VALUES (1, 1, 'Pendiente', 'Pagado', SYSDATE);
INSERT INTO HISTORIAL_PEDIDO VALUES (2, 2, 'Pendiente', 'Entregado', SYSDATE);


-- Inventario
INSERT INTO INVENTARIO VALUES (1, 1, 8, 'Almacén Central');
INSERT INTO INVENTARIO VALUES (2, 2, 5, 'Almacén Sur');
INSERT INTO INVENTARIO VALUES (3, 3, 20, 'Almacén Central');


-- Roles y usuarios del sistema
INSERT INTO ROL VALUES (1, 'Administrador', 'Gestiona usuarios y seguridad del sistema');
INSERT INTO ROL VALUES (2, 'Vendedor', 'Procesa pedidos y atención al cliente');

INSERT INTO USUARIO VALUES (1, 1, 'admin01', 'admin123', 'admin@ecomstore.com', 'Activo');
INSERT INTO USUARIO VALUES (2, 2, 'vendedor01', 'venta123', 'ventas@ecomstore.com', 'Activo');

-- Almacén
INSERT INTO ALMACEN VALUES (1, 'Central', 'Av. La Marina 890, Piura');
INSERT INTO ALMACEN VALUES (2, 'Norte', 'Av. Sanche  Cerro 560, Piura');

COMMIT;



-- Actualizar estado de un pedido
UPDATE PEDIDO
SET estado = 'Pagado'
WHERE pedido_id = 1;

-- Modificar cantidad en inventario
UPDATE INVENTARIO
SET cantidad = cantidad - 1
WHERE producto_id = 1;

-- Eliminar un registro de historial (ejemplo de control)
DELETE FROM HISTORIAL_PEDIDO
WHERE historial_id = 2;

COMMIT;


-- 7. CONTROL DE TRANSACCIONES (TCL)


-- Simulación de una transacción
SAVEPOINT antes_de_cambio;

UPDATE PRODUCTO
SET precio = precio * 1.05
WHERE categoria_id = 1;

ROLLBACK TO antes_de_cambio;

COMMIT;


-- 9. CONSULTAS SQL (SELECT)


-- Productos más vendidos
SELECT p.nombre, SUM(d.cantidad) AS total_vendido
FROM DETALLE_PEDIDO d
JOIN PRODUCTO p ON d.producto_id = p.producto_id
GROUP BY p.nombre
ORDER BY total_vendido DESC;

-- Pedidos pendientes de entrega
SELECT c.nombre || ' ' || c.apellido AS cliente, p.pedido_id, p.estado, e.estado_envio
FROM PEDIDO p
JOIN CLIENTE c ON p.cliente_id = c.cliente_id
JOIN ENVIO e ON e.pedido_id = p.pedido_id
WHERE e.estado_envio = 'Pendiente';

-- Clientes con más compras
SELECT c.nombre, c.apellido, COUNT(p.pedido_id) AS total_pedidos
FROM CLIENTE c
JOIN PEDIDO p ON c.cliente_id = p.cliente_id
GROUP BY c.nombre, c.apellido
ORDER BY total_pedidos DESC;

-- Productos con bajo stock
SELECT p.nombre, i.cantidad
FROM PRODUCTO p
JOIN INVENTARIO i ON p.producto_id = i.producto_id
WHERE i.cantidad < 10;

-- Total de ingresos por método de pago
SELECT metodo, SUM(monto) AS total_ingresos
FROM PAGO
GROUP BY metodo;

COMMIT;

