```sql
/*==========================================================
    1. TẠO DATABASE
==========================================================*/
IF DB_ID('QuanLyNhaThuoc') IS NOT NULL
BEGIN
    ALTER DATABASE QuanLyNhaThuoc SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE QuanLyNhaThuoc;
END
GO

CREATE DATABASE QuanLyNhaThuoc;
GO

USE QuanLyNhaThuoc;
GO

/*==========================================================
    2. XÓA BẢNG NẾU ĐÃ TỒN TẠI (để chạy lại script dễ)
==========================================================*/
IF OBJECT_ID('ChiTietHoaDon', 'U') IS NOT NULL DROP TABLE ChiTietHoaDon;
IF OBJECT_ID('HoaDon', 'U') IS NOT NULL DROP TABLE HoaDon;
IF OBJECT_ID('LoThuoc', 'U') IS NOT NULL DROP TABLE LoThuoc;
IF OBJECT_ID('ChiTietPhieuNhap', 'U') IS NOT NULL DROP TABLE ChiTietPhieuNhap;
IF OBJECT_ID('PhieuNhap', 'U') IS NOT NULL DROP TABLE PhieuNhap;
IF OBJECT_ID('KhachHang', 'U') IS NOT NULL DROP TABLE KhachHang;
IF OBJECT_ID('NhaCungCap', 'U') IS NOT NULL DROP TABLE NhaCungCap;
IF OBJECT_ID('Thuoc', 'U') IS NOT NULL DROP TABLE Thuoc;
IF OBJECT_ID('DonViTinh', 'U') IS NOT NULL DROP TABLE DonViTinh;
IF OBJECT_ID('LoaiThuoc', 'U') IS NOT NULL DROP TABLE LoaiThuoc;
IF OBJECT_ID('TaiKhoan', 'U') IS NOT NULL DROP TABLE TaiKhoan;
IF OBJECT_ID('NhanVien', 'U') IS NOT NULL DROP TABLE NhanVien;
IF OBJECT_ID('VaiTro', 'U') IS NOT NULL DROP TABLE VaiTro;
GO

/*==========================================================
    3. TẠO BẢNG VAI TRÒ
==========================================================*/
CREATE TABLE VaiTro
(
    MaVaiTro INT IDENTITY(1,1) PRIMARY KEY,
    TenVaiTro NVARCHAR(50) NOT NULL UNIQUE,
    MoTa NVARCHAR(255) NULL
);
GO

/*==========================================================
    4. TẠO BẢNG NHÂN VIÊN
==========================================================*/
CREATE TABLE NhanVien
(
    MaNV INT IDENTITY(1,1) PRIMARY KEY,
    HoTen NVARCHAR(100) NOT NULL,
    NgaySinh DATE NULL,
    GioiTinh NVARCHAR(10) NULL,
    SDT VARCHAR(15) NULL,
    Email VARCHAR(100) NULL,
    DiaChi NVARCHAR(255) NULL,
    NgayVaoLam DATE NOT NULL DEFAULT GETDATE(),
    TrangThai BIT NOT NULL DEFAULT 1,
    MaVaiTro INT NOT NULL,

    CONSTRAINT FK_NhanVien_VaiTro
        FOREIGN KEY (MaVaiTro) REFERENCES VaiTro(MaVaiTro),

    CONSTRAINT CK_NhanVien_GioiTinh
        CHECK (GioiTinh IN (N'Nam', N'Nữ', N'Khác') OR GioiTinh IS NULL),

    CONSTRAINT UQ_NhanVien_SDT UNIQUE (SDT),
    CONSTRAINT UQ_NhanVien_Email UNIQUE (Email)
);
GO

/*==========================================================
    5. TẠO BẢNG TÀI KHOẢN
==========================================================*/
CREATE TABLE TaiKhoan
(
    MaTK INT IDENTITY(1,1) PRIMARY KEY,
    TenDangNhap VARCHAR(50) NOT NULL,
    MatKhauHash VARCHAR(255) NOT NULL,
    TrangThai BIT NOT NULL DEFAULT 1,
    LanDangNhapCuoi DATETIME NULL,
    MaNV INT NOT NULL UNIQUE,

    CONSTRAINT FK_TaiKhoan_NhanVien
        FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV),

    CONSTRAINT UQ_TaiKhoan_TenDangNhap UNIQUE (TenDangNhap)
);
GO

/*==========================================================
    6. TẠO BẢNG LOẠI THUỐC
==========================================================*/
CREATE TABLE LoaiThuoc
(
    MaLoaiThuoc INT IDENTITY(1,1) PRIMARY KEY,
    TenLoaiThuoc NVARCHAR(100) NOT NULL UNIQUE,
    MoTa NVARCHAR(255) NULL
);
GO

/*==========================================================
    7. TẠO BẢNG ĐƠN VỊ TÍNH
==========================================================*/
CREATE TABLE DonViTinh
(
    MaDVT INT IDENTITY(1,1) PRIMARY KEY,
    TenDVT NVARCHAR(50) NOT NULL UNIQUE
);
GO

/*==========================================================
    8. TẠO BẢNG THUỐC
==========================================================*/
CREATE TABLE Thuoc
(
    MaThuoc INT IDENTITY(1,1) PRIMARY KEY,
    TenThuoc NVARCHAR(150) NOT NULL,
    MaLoaiThuoc INT NOT NULL,
    MaDVT INT NOT NULL,
    HamLuong NVARCHAR(100) NULL,
    CongDung NVARCHAR(500) NULL,
    GiaNhapGanNhat DECIMAL(18,2) NOT NULL DEFAULT 0,
    GiaBan DECIMAL(18,2) NOT NULL DEFAULT 0,
    SoLuongTon INT NOT NULL DEFAULT 0,
    NguongCanhBaoTon INT NOT NULL DEFAULT 0,
    CanKeDon BIT NOT NULL DEFAULT 0,
    TrangThai BIT NOT NULL DEFAULT 1,
    MoTa NVARCHAR(500) NULL,

    CONSTRAINT FK_Thuoc_LoaiThuoc
        FOREIGN KEY (MaLoaiThuoc) REFERENCES LoaiThuoc(MaLoaiThuoc),

    CONSTRAINT FK_Thuoc_DonViTinh
        FOREIGN KEY (MaDVT) REFERENCES DonViTinh(MaDVT),

    CONSTRAINT CK_Thuoc_GiaNhap CHECK (GiaNhapGanNhat >= 0),
    CONSTRAINT CK_Thuoc_GiaBan CHECK (GiaBan >= 0),
    CONSTRAINT CK_Thuoc_SoLuongTon CHECK (SoLuongTon >= 0),
    CONSTRAINT CK_Thuoc_NguongCanhBaoTon CHECK (NguongCanhBaoTon >= 0)
);
GO

/*==========================================================
    9. TẠO BẢNG NHÀ CUNG CẤP
==========================================================*/
CREATE TABLE NhaCungCap
(
    MaNCC INT IDENTITY(1,1) PRIMARY KEY,
    TenNCC NVARCHAR(150) NOT NULL,
    SDT VARCHAR(15) NULL,
    Email VARCHAR(100) NULL,
    DiaChi NVARCHAR(255) NULL,
    TrangThai BIT NOT NULL DEFAULT 1,

    CONSTRAINT UQ_NhaCungCap_SDT UNIQUE (SDT),
    CONSTRAINT UQ_NhaCungCap_Email UNIQUE (Email)
);
GO

/*==========================================================
    10. TẠO BẢNG KHÁCH HÀNG
==========================================================*/
CREATE TABLE KhachHang
(
    MaKH INT IDENTITY(1,1) PRIMARY KEY,
    HoTen NVARCHAR(100) NOT NULL,
    SDT VARCHAR(15) NULL,
    DiaChi NVARCHAR(255) NULL,
    DiemTichLuy INT NOT NULL DEFAULT 0,
    NgayTao DATETIME NOT NULL DEFAULT GETDATE(),

    CONSTRAINT CK_KhachHang_Diem CHECK (DiemTichLuy >= 0),
    CONSTRAINT UQ_KhachHang_SDT UNIQUE (SDT)
);
GO

/*==========================================================
    11. TẠO BẢNG PHIẾU NHẬP
==========================================================*/
CREATE TABLE PhieuNhap
(
    MaPhieuNhap INT IDENTITY(1,1) PRIMARY KEY,
    NgayNhap DATETIME NOT NULL DEFAULT GETDATE(),
    MaNCC INT NOT NULL,
    MaNV INT NOT NULL,
    TongTien DECIMAL(18,2) NOT NULL DEFAULT 0,
    GhiChu NVARCHAR(255) NULL,

    CONSTRAINT FK_PhieuNhap_NhaCungCap
        FOREIGN KEY (MaNCC) REFERENCES NhaCungCap(MaNCC),

    CONSTRAINT FK_PhieuNhap_NhanVien
        FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV),

    CONSTRAINT CK_PhieuNhap_TongTien CHECK (TongTien >= 0)
);
GO

/*==========================================================
    12. TẠO BẢNG CHI TIẾT PHIẾU NHẬP
==========================================================*/
CREATE TABLE ChiTietPhieuNhap
(
    MaPhieuNhap INT NOT NULL,
    MaThuoc INT NOT NULL,
    SoLuong INT NOT NULL,
    DonGiaNhap DECIMAL(18,2) NOT NULL,
    ThanhTien DECIMAL(18,2) NOT NULL,

    CONSTRAINT PK_ChiTietPhieuNhap PRIMARY KEY (MaPhieuNhap, MaThuoc),

    CONSTRAINT FK_CTPN_PhieuNhap
        FOREIGN KEY (MaPhieuNhap) REFERENCES PhieuNhap(MaPhieuNhap),

    CONSTRAINT FK_CTPN_Thuoc
        FOREIGN KEY (MaThuoc) REFERENCES Thuoc(MaThuoc),

    CONSTRAINT CK_CTPN_SoLuong CHECK (SoLuong > 0),
    CONSTRAINT CK_CTPN_DonGiaNhap CHECK (DonGiaNhap >= 0),
    CONSTRAINT CK_CTPN_ThanhTien CHECK (ThanhTien >= 0)
);
GO

/*==========================================================
    13. TẠO BẢNG LÔ THUỐC
==========================================================*/
CREATE TABLE LoThuoc
(
    MaLoThuoc INT IDENTITY(1,1) PRIMARY KEY,
    MaThuoc INT NOT NULL,
    MaPhieuNhap INT NOT NULL,
    SoLo NVARCHAR(50) NOT NULL,
    NgaySanXuat DATE NULL,
    HanSuDung DATE NOT NULL,
    SoLuongNhap INT NOT NULL,
    SoLuongCon INT NOT NULL,
    DonGiaNhap DECIMAL(18,2) NOT NULL,

    CONSTRAINT FK_LoThuoc_Thuoc
        FOREIGN KEY (MaThuoc) REFERENCES Thuoc(MaThuoc),

    CONSTRAINT FK_LoThuoc_PhieuNhap
        FOREIGN KEY (MaPhieuNhap) REFERENCES PhieuNhap(MaPhieuNhap),

    CONSTRAINT CK_LoThuoc_SoLuongNhap CHECK (SoLuongNhap > 0),
    CONSTRAINT CK_LoThuoc_SoLuongCon CHECK (SoLuongCon >= 0),
    CONSTRAINT CK_LoThuoc_DonGiaNhap CHECK (DonGiaNhap >= 0),
    CONSTRAINT CK_LoThuoc_HanSuDung CHECK (HanSuDung >= GETDATE())
);
GO

/*==========================================================
    14. TẠO BẢNG HÓA ĐƠN
==========================================================*/
CREATE TABLE HoaDon
(
    MaHoaDon INT IDENTITY(1,1) PRIMARY KEY,
    NgayLap DATETIME NOT NULL DEFAULT GETDATE(),
    MaNV INT NOT NULL,
    MaKH INT NULL,
    TongTien DECIMAL(18,2) NOT NULL DEFAULT 0,
    GiamGia DECIMAL(18,2) NOT NULL DEFAULT 0,
    ThanhToan DECIMAL(18,2) NOT NULL DEFAULT 0,
    TrangThai NVARCHAR(30) NOT NULL DEFAULT N'Đã thanh toán',
    GhiChu NVARCHAR(255) NULL,

    CONSTRAINT FK_HoaDon_NhanVien
        FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV),

    CONSTRAINT FK_HoaDon_KhachHang
        FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH),

    CONSTRAINT CK_HoaDon_TongTien CHECK (TongTien >= 0),
    CONSTRAINT CK_HoaDon_GiamGia CHECK (GiamGia >= 0),
    CONSTRAINT CK_HoaDon_ThanhToan CHECK (ThanhToan >= 0),
    CONSTRAINT CK_HoaDon_TrangThai CHECK (TrangThai IN (N'Đã thanh toán', N'Chưa thanh toán', N'Đã hủy'))
);
GO

/*==========================================================
    15. TẠO BẢNG CHI TIẾT HÓA ĐƠN
==========================================================*/
CREATE TABLE ChiTietHoaDon
(
    MaHoaDon INT NOT NULL,
    MaThuoc INT NOT NULL,
    SoLuong INT NOT NULL,
    DonGiaBan DECIMAL(18,2) NOT NULL,
    ThanhTien DECIMAL(18,2) NOT NULL,

    CONSTRAINT PK_ChiTietHoaDon PRIMARY KEY (MaHoaDon, MaThuoc),

    CONSTRAINT FK_CTHD_HoaDon
        FOREIGN KEY (MaHoaDon) REFERENCES HoaDon(MaHoaDon),

    CONSTRAINT FK_CTHD_Thuoc
        FOREIGN KEY (MaThuoc) REFERENCES Thuoc(MaThuoc),

    CONSTRAINT CK_CTHD_SoLuong CHECK (SoLuong > 0),
    CONSTRAINT CK_CTHD_DonGiaBan CHECK (DonGiaBan >= 0),
    CONSTRAINT CK_CTHD_ThanhTien CHECK (ThanhTien >= 0)
);
GO

/*==========================================================
    16. DỮ LIỆU MẪU
==========================================================*/

/*-------------------------
    Vai trò
-------------------------*/
INSERT INTO VaiTro(TenVaiTro, MoTa)
VALUES
(N'Admin', N'Quản trị hệ thống'),
(N'Nhân viên', N'Nhân viên bán thuốc');
GO

/*-------------------------
    Nhân viên
-------------------------*/
INSERT INTO NhanVien(HoTen, NgaySinh, GioiTinh, SDT, Email, DiaChi, NgayVaoLam, TrangThai, MaVaiTro)
VALUES
(N'Nguyễn Văn Admin', '1990-01-01', N'Nam', '0900000001', 'admin@nhathuoc.com', N'Hà Nội', '2024-01-01', 1, 1),
(N'Trần Thị Nhân Viên', '1998-05-10', N'Nữ', '0900000002', 'nhanvien@nhathuoc.com', N'Hà Nội', '2024-02-01', 1, 2);
GO

/*-------------------------
    Tài khoản
    Lưu ý: mật khẩu ở đây chỉ là demo, chưa băm thật
-------------------------*/
INSERT INTO TaiKhoan(TenDangNhap, MatKhauHash, TrangThai, MaNV)
VALUES
('admin', '123456', 1, 1),
('nhanvien1', '123456', 1, 2);
GO

/*-------------------------
    Loại thuốc
-------------------------*/
INSERT INTO LoaiThuoc(TenLoaiThuoc, MoTa)
VALUES
(N'Giảm đau - hạ sốt', N'Thuốc giảm đau, hạ sốt'),
(N'Kháng sinh', N'Thuốc kháng sinh'),
(N'Tiêu hóa', N'Thuốc hỗ trợ tiêu hóa'),
(N'Vitamin', N'Thuốc bổ sung vitamin');
GO

/*-------------------------
    Đơn vị tính
-------------------------*/
INSERT INTO DonViTinh(TenDVT)
VALUES
(N'Viên'),
(N'Hộp'),
(N'Chai'),
(N'Vỉ');
GO

/*-------------------------
    Thuốc
-------------------------*/
INSERT INTO Thuoc
(
    TenThuoc, MaLoaiThuoc, MaDVT, HamLuong, CongDung,
    GiaNhapGanNhat, GiaBan, SoLuongTon, NguongCanhBaoTon,
    CanKeDon, TrangThai, MoTa
)
VALUES
(N'Paracetamol', 1, 1, N'500mg', N'Giảm đau, hạ sốt', 2000, 3000, 100, 10, 0, 1, N'Thuốc thông dụng'),
(N'Amoxicillin', 2, 1, N'500mg', N'Kháng sinh', 4000, 6000, 80, 10, 1, 1, N'Dùng theo chỉ định'),
(N'Men tiêu hóa Bio', 3, 2, N'--', N'Hỗ trợ tiêu hóa', 25000, 35000, 40, 5, 0, 1, N'Bổ sung lợi khuẩn'),
(N'Vitamin C', 4, 2, N'1000mg', N'Bổ sung vitamin C', 30000, 45000, 60, 5, 0, 1, N'Tăng đề kháng');
GO

/*-------------------------
    Nhà cung cấp
-------------------------*/
INSERT INTO NhaCungCap(TenNCC, SDT, Email, DiaChi, TrangThai)
VALUES
(N'Công ty Dược A', '0911111111', 'duoca@gmail.com', N'Hà Nội', 1),
(N'Công ty Dược B', '0922222222', 'duocb@gmail.com', N'Hồ Chí Minh', 1);
GO

/*-------------------------
    Khách hàng
-------------------------*/
INSERT INTO KhachHang(HoTen, SDT, DiaChi, DiemTichLuy)
VALUES
(N'Lê Văn A', '0933333333', N'Hà Nội', 0),
(N'Phạm Thị B', '0944444444', N'Hà Nội', 10);
GO

/*-------------------------
    Phiếu nhập
-------------------------*/
INSERT INTO PhieuNhap(NgayNhap, MaNCC, MaNV, TongTien, GhiChu)
VALUES
(GETDATE(), 1, 1, 680000, N'Nhập hàng đợt 1'),
(GETDATE(), 2, 1, 900000, N'Nhập hàng đợt 2');
GO

/*-------------------------
    Chi tiết phiếu nhập
-------------------------*/
INSERT INTO ChiTietPhieuNhap(MaPhieuNhap, MaThuoc, SoLuong, DonGiaNhap, ThanhTien)
VALUES
(1, 1, 100, 2000, 200000),
(1, 2, 80, 4000, 320000),
(1, 3, 20, 8000, 160000),
(2, 4, 30, 30000, 900000);
GO

/*-------------------------
    Lô thuốc
-------------------------*/
INSERT INTO LoThuoc
(
    MaThuoc, MaPhieuNhap, SoLo, NgaySanXuat, HanSuDung,
    SoLuongNhap, SoLuongCon, DonGiaNhap
)
VALUES
(1, 1, N'LO-PARA-001', '2026-01-01', '2027-12-31', 100, 100, 2000),
(2, 1, N'LO-AMOX-001', '2026-02-01', '2027-10-31', 80, 80, 4000),
(3, 1, N'LO-BIO-001',  '2026-03-01', '2027-09-30', 20, 20, 8000),
(4, 2, N'LO-VITC-001', '2026-01-15', '2028-01-15', 30, 30, 30000);
GO

/*-------------------------
    Hóa đơn
-------------------------*/
INSERT INTO HoaDon(NgayLap, MaNV, MaKH, TongTien, GiamGia, ThanhToan, TrangThai, GhiChu)
VALUES
(GETDATE(), 2, 1, 12000, 0, 12000, N'Đã thanh toán', N'Khách mua lẻ'),
(GETDATE(), 2, 2, 45000, 5000, 40000, N'Đã thanh toán', N'Khách quen');
GO

/*-------------------------
    Chi tiết hóa đơn
-------------------------*/
INSERT INTO ChiTietHoaDon(MaHoaDon, MaThuoc, SoLuong, DonGiaBan, ThanhTien)
VALUES
(1, 1, 4, 3000, 12000),
(2, 4, 1, 45000, 45000);
GO

/*==========================================================
    17. KIỂM TRA DỮ LIỆU
==========================================================*/
SELECT * FROM VaiTro;
SELECT * FROM NhanVien;
SELECT * FROM TaiKhoan;
SELECT * FROM LoaiThuoc;
SELECT * FROM DonViTinh;
SELECT * FROM Thuoc;
SELECT * FROM NhaCungCap;
SELECT * FROM KhachHang;
SELECT * FROM PhieuNhap;
SELECT * FROM ChiTietPhieuNhap;
SELECT * FROM LoThuoc;
SELECT * FROM HoaDon;
SELECT * FROM ChiTietHoaDon;
GO
```
