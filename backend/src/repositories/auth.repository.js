const { sql, poolPromise } = require("../config/db");

const findByUsername = async (tenDangNhap) => {
  const pool = await poolPromise;

  const result = await pool
    .request()
    .input("tenDangNhap", sql.NVarChar, tenDangNhap).query(`
      SELECT MaTK, TenDangNhap, MatKhauHash, MaNV, TrangThai
      FROM TaiKhoan
      WHERE TenDangNhap = @tenDangNhap
    `);

  return result.recordset[0] || null;
};

const findById = async (maTK) => {
  const pool = await poolPromise;

  const result = await pool.request().input("maTK", sql.Int, maTK).query(`
      SELECT MaTK, TenDangNhap, MatKhauHash, MaNV, TrangThai
      FROM TaiKhoan
      WHERE MaTK = @maTK
    `);

  return result.recordset[0] || null;
};

const existsByUsername = async (tenDangNhap) => {
  const pool = await poolPromise;

  const result = await pool
    .request()
    .input("tenDangNhap", sql.NVarChar, tenDangNhap).query(`
      SELECT 1 AS value
      FROM TaiKhoan
      WHERE TenDangNhap = @tenDangNhap
    `);

  return result.recordset.length > 0;
};

const existsByNhanVien = async (maNV) => {
  const pool = await poolPromise;

  const result = await pool.request().input("maNV", sql.Int, maNV).query(`
      SELECT 1 AS value
      FROM TaiKhoan
      WHERE MaNV = @maNV
    `);

  return result.recordset.length > 0;
};

const findNhanVienById = async (maNV) => {
  const pool = await poolPromise;

  const result = await pool.request().input("maNV", sql.Int, maNV).query(`
      SELECT MaNV, HoTen
      FROM NhanVien
      WHERE MaNV = @maNV
    `);

  return result.recordset[0] || null;
};

const createAccount = async ({ tenDangNhap, matKhauHash, maNV, trangThai }) => {
  const pool = await poolPromise;

  const result = await pool
    .request()
    .input("tenDangNhap", sql.NVarChar, tenDangNhap)
    .input("matKhauHash", sql.NVarChar, matKhauHash)
    .input("maNV", sql.Int, maNV)
    .input("trangThai", sql.Bit, trangThai).query(`
      INSERT INTO TaiKhoan (TenDangNhap, matKhauHash, MaNV, TrangThai)
      OUTPUT INSERTED.MaTK, INSERTED.TenDangNhap, INSERTED.MaNV, INSERTED.TrangThai
      VALUES (@tenDangNhap, @matKhauHash, @maNV, @trangThai)
    `);

  return result.recordset[0];
};

const updatePassword = async (maTK, newPasswordHash) => {
  const pool = await poolPromise;

  await pool
    .request()
    .input("maTK", sql.Int, maTK)
    .input("matKhau", sql.NVarChar, newPasswordHash).query(`
      UPDATE TaiKhoan
      SET MatKhauHash = @matKhau
      WHERE MaTK = @maTK
    `);
};

module.exports = {
  findByUsername,
  findById,
  existsByUsername,
  existsByNhanVien,
  findNhanVienById,
  createAccount,
  updatePassword,
};
