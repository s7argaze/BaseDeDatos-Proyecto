CREATE SCHEMA proyecto;

CREATE TABLE cliente(
RUT VARCHAR(100) PRIMARY KEY,
nombre VARCHAR(100) NOT NULL,
apellido VARCHAR(100) NOT NULL);

CREATE TABLE trabajador(
RUT VARCHAR(100) PRIMARY KEY,
nombre VARCHAR(100) NOT NULL,
apellido VARCHAR(100) NOT NULL,
cargo VARCHAR(30),
sueldo INT CHECK(sueldo >= 400000));

CREATE TABLE mesa(
num_mesa INT PRIMARY KEY,
estado_mesa VARCHAR(100) DEFAULT 'libre' CHECK(estado_mesa IN ('libre','ocupada')));

CREATE TABLE pedido(
id_pedido INT PRIMARY KEY,
valor_pedido INT,
estado_pedido VARCHAR(100) DEFAULT 'no entregado' CHECK(estado_pedido IN ('entregado','no entregado')),
fecha_pedido DATE DEFAULT CURRENT_DATE,
RUT VARCHAR(100) REFERENCES cliente(RUT) ON DELETE RESTRICT ON UPDATE CASCADE);

CREATE TABLE en_local(
id_pedido INT PRIMARY KEY REFERENCES pedido(id_pedido) ON DELETE RESTRICT ON UPDATE CASCADE);

CREATE TABLE fuera_local(
id_pedido INT PRIMARY KEY REFERENCES pedido(id_pedido) ON DELETE RESTRICT ON UPDATE CASCADE,
direccion VARCHAR(100));

CREATE TABLE producto(
id_producto INT PRIMARY KEY,
nombre VARCHAR(100),
valor_producto INT CHECK(valor_producto > 0),
porcentaje_ganancia REAL DEFAULT 35,
tmp_preparacion INT CHECK(tmp_preparacion > 0));

CREATE TABLE boleta(
id_boleta INT PRIMARY KEY,
total INT CHECK(total > 0),
valor_neto INT CHECK(valor_neto > 0),
iva INT CHECK(iva > 0), 
id_pedido INT REFERENCES pedido(id_pedido) ON DELETE RESTRICT ON UPDATE CASCADE,
fecha_venta DATE DEFAULT CURRENT_DATE);

CREATE TABLE ingrediente(
id_ingrediente INT PRIMARY KEY,
nombre VARCHAR(100),
stock REAL NOT NULL CHECK(stock >= 0) DEFAULT 0,
u_m VARCHAR(100) CHECK(u_m IN ('unidad','kg','L')),
fecha_exp DATE,
valor_unitario INT CHECK(valor_unitario > 0));

CREATE TABLE egreso(
id_egreso INT PRIMARY KEY,
fecha_egreso DATE DEFAULT CURRENT_DATE,
descripcion VARCHAR(100),
total INT );

CREATE TABLE compra(
id_egreso INT PRIMARY KEY REFERENCES egreso(id_egreso) ON DELETE RESTRICT ON UPDATE CASCADE);

CREATE TABLE pago_trabajador(
id_egreso INT PRIMARY KEY REFERENCES egreso(id_egreso) ON DELETE RESTRICT ON UPDATE CASCADE);

CREATE TABLE otro_egreso(
id_egreso INT PRIMARY KEY REFERENCES egreso(id_egreso) ON DELETE RESTRICT ON UPDATE CASCADE);

CREATE TABLE proveedor(
id_proveedor INT PRIMARY KEY,
nombre VARCHAR(100) NOT NULL,
empresa VARCHAR(100) NOT NULL,
num_contacto VARCHAR(100) NOT NULL);

CREATE TABLE ocupa(
num_mesa INT REFERENCES mesa(num_mesa) ON DELETE RESTRICT ON UPDATE CASCADE,
id_pedido INT REFERENCES en_local(id_pedido) ON DELETE RESTRICT ON UPDATE CASCADE,
RUT VARCHAR(100) REFERENCES cliente(RUT) ON DELETE RESTRICT ON UPDATE CASCADE,
PRIMARY KEY(num_mesa,id_pedido,RUT));

CREATE TABLE tiene(
id_pedido INT REFERENCES pedido(id_pedido) ON DELETE RESTRICT ON UPDATE CASCADE,
id_producto INT REFERENCES producto(id_producto) ON DELETE RESTRICT ON UPDATE CASCADE,
cantidad_producto INT CHECK(cantidad_producto > 0),
PRIMARY KEY (id_pedido,id_producto));

CREATE TABLE compone(
id_producto INT REFERENCES producto(id_producto) ON DELETE RESTRICT ON UPDATE CASCADE,
id_ingrediente INT REFERENCES ingrediente(id_ingrediente) ON DELETE RESTRICT ON UPDATE CASCADE,
cantidad_ingrediente REAL CHECK(cantidad_ingrediente >= 0),
PRIMARY KEY (id_producto,id_ingrediente));

CREATE TABLE actualiza(
id_ingrediente INT REFERENCES ingrediente(id_ingrediente) ON DELETE RESTRICT ON UPDATE CASCADE,
id_egreso INT REFERENCES compra(id_egreso) ON DELETE RESTRICT ON UPDATE CASCADE,
fecha_actualiza DATE DEFAULT CURRENT_DATE,
cantidad_actualiza INT CHECK(cantidad_actualiza > 0),
fecha_exp DATE,
estado_actualiza VARCHAR(100) DEFAULT 'no actualizado' CHECK(estado_actualiza IN ('actualizado','no actualizado')),
PRIMARY KEY(id_ingrediente,id_egreso));

CREATE TABLE transaccion(
id_proveedor INT REFERENCES proveedor(id_proveedor) ON DELETE RESTRICT ON UPDATE CASCADE,
id_egreso INT REFERENCES compra(id_egreso) ON DELETE RESTRICT ON UPDATE CASCADE,
PRIMARY KEY (id_proveedor,id_egreso));


