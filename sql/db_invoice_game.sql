-- CREATE DATABASE
CREATE DATABASE db_invoicegame;
USE db_invoicegame;

-- TABLE CUSTOMER
CREATE TABLE customer (
    id_game BIGINT PRIMARY KEY,
    username_game VARCHAR(100) NOT NULL
);

-- TABLE ADMIN
CREATE TABLE admin (
    id_admin INT AUTO_INCREMENT PRIMARY KEY,
    username_admin VARCHAR(50) NOT NULL,
    password_admin VARCHAR(255) NOT NULL
);
ALTER TABLE transaksi
ADD id_admin INT;

ALTER TABLE transaksi
ADD CONSTRAINT fk_transaksi_admin
FOREIGN KEY (id_admin) REFERENCES admin(id_admin);
UPDATE transaksi
SET id_admin = 1;


-- TABLE TRANSAKSI
CREATE TABLE transaksi (
    id_transaksi VARCHAR(25) PRIMARY KEY,
    id_game BIGINT,
    metode_pembayaran VARCHAR(20),
    waktu TIME,
    biaya_admin INT DEFAULT 2000,
    total_bayar INT,
    status VARCHAR(20),
    FOREIGN KEY (id_game) REFERENCES customer(id_game)
);

-- TABLE PRODUK TOP UP
CREATE TABLE produk_topup (
    id_product INT PRIMARY KEY,
    jumlah_diamond VARCHAR(20),
    harga_satuan INT
);

-- TABLE DETAIL TRANSAKSI
CREATE TABLE detail_transaksi (
    id_transaksi VARCHAR(25),
    id_product INT,
    jumlah_beli INT,
    PRIMARY KEY (id_transaksi, id_product),
    FOREIGN KEY (id_transaksi) REFERENCES transaksi(id_transaksi),
    FOREIGN KEY (id_product) REFERENCES produk_topup(id_product)
);

-- INSERT DATA CUSTOMER
INSERT INTO customer VALUES
(217978152, 'PlayerML01'),
(123456789, 'PlayerML02'),
(136872592, 'PlayerML03'),
(872318371, 'PlayerML04'),
(231781273, 'PlayerML05'),
(276453890, 'PlayerML06');

-- INSERT DATA ADMIN
INSERT INTO admin (username_admin, password_admin)
VALUES ('admin1', 'admin123');

-- INSERT DATA PRODUK TOP UP
INSERT INTO produk_topup VALUES
(1000001, '250 Diamond', 27500),
(1000002, '2000 Diamond', 250000),
(1000003, '500+5 Diamond', 83000),
(1000004, '300 Diamond', 35000),
(1000005, '400+3 Diamond', 65000),
(1000006, '50+6 Diamond', 15000);

-- INSERT DATA TRANSAKSI
INSERT INTO transaksi VALUES
('ASJDBNJAVHK128WF', 217978152, 'GOPAY', '19:02', 2000, 29500, 'SELESAI'),
('LSACBQLHFU3Q74B', 123456789, 'DANA', '15:00', 2000, 252000, 'SELESAI'),
('AGSTF288IGSSYTFZ', 136872592, 'GOPAY', '12:10', 2000, 85000, 'SELESAI'),
('DVASUHFWDAVU9Z1E', 872318371, 'KREDIT', '14:24', 2000, 72000, 'SELESAI'),
('WHDBSJADBAVJDSA', 231781273, 'QRIS', '22:15', 2000, 197000, 'SELESAI'),
('ASWY73YSGGOSU11', 276453890, 'GOPAY', '13:25', 2000, 62000, 'SELESAI');

-- INSERT DETAIL TRANSAKSI
INSERT INTO detail_transaksi VALUES
('ASJDBNJAVHK128WF', 1000001, 1),
('LSACBQLHFU3Q74B', 1000002, 3),
('AGSTF288IGSSYTFZ', 1000003, 1),
('DVASUHFWDAVU9Z1E', 1000004, 2),
('WHDBSJADBAVJDSA', 1000005, 3),
('ASWY73YSGGOSU11', 1000006, 4);

-- DDL 
CREATE TABLE metode_pembayaran (
    id_metode INT PRIMARY KEY,
    nama_metode VARCHAR(20) NOT NULL
);

-- DML 
INSERT INTO metode_pembayaran VALUES
(1, 'GOPAY'),
(2, 'DANA'),
(3, 'QRIS');

-- TCL

START TRANSACTION;
INSERT INTO transaksi 
VALUES ('TRX999', 217978152, 'GOPAY', '20:30', 2000, 50000, 'SELESAI');
COMMIT;

-- AGRESI DAN HAVING

SELECT metode_pembayaran, COUNT(*) AS total_transaksi
FROM transaksi
GROUP BY metode_pembayaran
HAVING COUNT(*) >= 2;


-- GROUP BY 
SELECT metode_pembayaran, COUNT(*) AS total_transaksi
FROM transaksi
GROUP BY metode_pembayaran
HAVING COUNT(*) >= 2;

-- JOIN

SELECT 
    c.username_game,
    t.id_transaksi,
    p.jumlah_diamond,
    d.jumlah_beli,
    t.total_bayar
FROM transaksi t
JOIN customer c ON t.id_game = c.id_game
JOIN detail_transaksi d ON t.id_transaksi = d.id_transaksi
JOIN produk_topup p ON d.id_product = p.id_product;



-- PRIMARY KEY & FOREIGN KEY

-- TABEL: customer
-- Primary Key: id_game

-- TABEL: admin
-- Primary Key: id_admin

-- TABEL: produk_topup
-- Primary Key: id_product

-- TABEL: transaksi
-- Primary Key: id_transaksi
-- Foreign Key: id_game → referensi ke customer(id_game)

-- TABEL: detail_transaksi
-- Primary Key (Composite / Gabungan): (id_transaksi, id_product)
-- Foreign Key:
--   id_transaksi → referensi ke transaksi(id_transaksi)
--   id_product   → referensi ke produk_topup(id_product)

-- TABEL: metode_pembayaran
-- Primary Key: id_metode


-- RELASI ANTAR TABEL

-- RELASI: One to Many (1 : N)
-- PK: customer.id_game
-- FK: transaksi.id_game
-- Keterangan:
-- Satu customer (player game) dapat melakukan banyak transaksi top up,
-- tetapi satu transaksi hanya dimiliki oleh satu customer.

-- RELASI: One to Many (1 : N)
-- PK: transaksi.id_transaksi
-- FK: detail_transaksi.id_transaksi
-- Keterangan:
-- Satu transaksi dapat memiliki lebih dari satu detail produk yang dibeli.

-- RELASI: One to Many (1 : N)
-- PK: produk_topup.id_product
-- FK: detail_transaksi.id_product
-- Keterangan:
-- Satu produk top up dapat muncul di banyak transaksi yang berbeda.

-- RELASI: Many to Many (M : N)
-- Keterangan:
-- Satu transaksi dapat membeli banyak produk
-- Satu produk dapat dibeli pada banyak transaksi
-- Relasi M : N ini dipecah menggunakan tabel detail_transaksi
