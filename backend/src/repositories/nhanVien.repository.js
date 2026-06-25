const { sql, poolPromise } = require("../config/db");

const findAll = async () => {
  const pool = await poolPromise;

  const result = await pool.request().query(`
    SELECT 
      nv.MaNV,
      nv.HoTen,
      nv.NgaySinh,
      nv.GioiTinh,
      nv.SDT,
      nv.Email,
      nv.DiaChi,
      nv.NgayVaoLam,
      nv.TrangThai,
      nv.MaVaiTro,
      vt.TenVaiTro
    FROM NhanVien nv
    LEFT JOIN VaiTro vt ON nv.MaVaiTro = vt.MaVaiTro
    ORDER BY nv.MaNV ASC
  `);
  return result.recordset;
};

const findById = async (maNV) => {
  const pool = await poolPromise;

  const result = await pool.request().input("maNV", sql.Int, maNV).query(`
        SELECT 
            nv.MaNV,
            nv.HoTen,
            nv.NgaySinh,
            nv.GioiTinh,
            nv.SDT,
            nv.Email,
            nv.DiaChi,
            nv.NgayVaoLam,
            nv.TrangThai,
            nv.MaVaiTro,
            vt.TenVaiTro
        FROM NhanVien nv
        LEFT JOIN VaiTro vt ON nv.MaVaiTro = vt.MaVaiTro
        WHERE nv.MaNV = @maNV
        `);

  return result.recordset[0];
};

const create = async ({
  hoTen,
  ngaySinh,
  gioiTinh,
  sdt,
  email,
  diaChi,
  ngayVaoLam,
  trangThai,
  maVaiTro,
}) => {
  const pool = await poolPromise;

  const result = await pool
    .request()
    .input("hoTen", sql.NVarChar(100), hoTen)
    .input("ngaySinh", sql.Date, ngaySinh || null)
    .input("gioiTinh", sql.NVarChar(10), gioiTinh || null)
    .input("sdt", sql.VarChar(15), sdt || null)
    .input("email", sql.VarChar(100), email || null)
    .input("diaChi", sql.NVarChar(255), diaChi || null)
    .input("ngayVaoLam", sql.Date, ngayVaoLam)
    .input("trangThai", sql.Bit, trangThai)
    .input("maVaiTro", sql.Int, maVaiTro).query(`
      INSERT INTO NhanVien (
        HoTen, NgaySinh, GioiTinh, SDT, Email, DiaChi, NgayVaoLam, TrangThai, MaVaiTro
      )
      OUTPUT 
        INSERTED.MaNV,
        INSERTED.HoTen,
        INSERTED.NgaySinh,
        INSERTED.GioiTinh,
        INSERTED.SDT,
        INSERTED.Email,
        INSERTED.DiaChi,
        INSERTED.NgayVaoLam,
        INSERTED.TrangThai,
        INSERTED.MaVaiTro
      VALUES (
        @hoTen, @ngaySinh, @gioiTinh, @sdt, @email, @diaChi, @ngayVaoLam, @trangThai, @maVaiTro
      )
    `);

  return result.recordset[0];
};
const update = async (
  maNV,
  {
    hoTen,
    ngaySinh,
    gioiTinh,
    sdt,
    email,
    diaChi,
    ngayVaoLam,
    trangThai,
    maVaiTro,
  }
) => {
  const pool = await poolPromise;

  const result = await pool
    .request()
    .input("maNV", sql.Int, maNV)
    .input("hoTen", sql.NVarChar(100), hoTen)
    .input("ngaySinh", sql.Date, ngaySinh || null)
    .input("gioiTinh", sql.NVarChar(10), gioiTinh || null)
    .input("sdt", sql.VarChar(15), sdt || null)
    .input("email", sql.VarChar(100), email || null)
    .input("diaChi", sql.NVarChar(255), diaChi || null)
    .input("ngayVaoLam", sql.Date, ngayVaoLam)
    .input("trangThai", sql.Bit, trangThai)
    .input("maVaiTro", sql.Int, maVaiTro).query(`
      UPDATE NhanVien
      SET 
        HoTen = @hoTen,
        NgaySinh = @ngaySinh,
        GioiTinh = @gioiTinh,
        SDT = @sdt,
        Email = @email,
        DiaChi = @diaChi,
        NgayVaoLam = @ngayVaoLam,
        TrangThai = @trangThai,
        MaVaiTro = @maVaiTro
      WHERE MaNV = @maNV
    `);

  return result.rowsAffected[0] > 0;
};

const updateStatus = async (maNV, trangThai) => {
  const pool = await poolPromise;

  const result = await pool
    .request()
    .input("maNV", sql.Int, maNV)
    .input("trangThai", sql.Bit, trangThai).query(`
      UPDATE NhanVien
      SET TrangThai = @trangThai
      WHERE MaNV = @maNV
    `);

  return result.rowsAffected[0] > 0;
};

const softDelete = async (maNV) => {
  const pool = await poolPromise;

  const result = await pool.request().input("maNV", sql.Int, maNV).query(`
      UPDATE NhanVien
      SET TrangThai = 0
      WHERE MaNV = @maNV
    `);

  return result.rowsAffected[0] > 0;
};

const findVaiTroById = async (maVaiTro) => {
  const pool = await poolPromise;

  const result = await pool.request().input("maVaiTro", sql.Int, maVaiTro)
    .query(`
      SELECT MaVaiTro, TenVaiTro, MoTa
      FROM VaiTro
      WHERE MaVaiTro = @maVaiTro
    `);

  return result.recordset[0];
};

module.exports = {
  findAll,
  findById,
  create,
  update,
  updateStatus,
  softDelete,
  findVaiTroById,
};
