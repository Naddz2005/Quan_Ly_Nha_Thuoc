const nhanVienRepository = require("../repositories/nhanVien.repository");

const getAll = async () => {
  return await nhanVienRepository.findAll();
};

const getById = async (maNV) => {
  if (!maNV || isNaN(maNV)) {
    throw new Error("Ma nhan vien khong hop le");
  }
  const nhanVien = nhanVienRepository.findById(maNV);

  if (!nhanVien) {
    throw new Error("Nhan vien khong ton tai");
  }
  return nhanVien;
};

const create = async (data) => {
  const {
    hoTen,
    ngaySinh,
    gioiTinh,
    sdt,
    email,
    diaChi,
    ngayVaoLam,
    maVaiTro,
  } = data;
  if (!hoTen || !ngayVaoLam || !maVaiTro) {
    throw new Error("Họ tên, ngày vào làm và mã vai trò là bắt buộc");
  }

  const vaiTro = await nhanVienRepository.findVaiTroById(Number(maVaiTro));
  if (!vaiTro) {
    throw new Error("Vai trò không tồn tại");
  }

  const createdNhanVien = await nhanVienRepository.create({
    hoTen,
    ngaySinh,
    gioiTinh,
    sdt,
    email,
    diaChi,
    ngayVaoLam,
    trangThai: true,
    maVaiTro: Number(maVaiTro),
  });

  return {
    message: "Thêm nhân viên thành công",
    nhanVien: createdNhanVien,
  };
};
const update = async (maNV, data) => {
  if (!maNV || isNaN(maNV)) {
    throw new Error("Mã nhân viên không hợp lệ");
  }

  const existingNhanVien = await nhanVienRepository.findById(Number(maNV));
  if (!existingNhanVien) {
    throw new Error("Nhân viên không tồn tại");
  }

  const {
    hoTen,
    ngaySinh,
    gioiTinh,
    sdt,
    email,
    diaChi,
    ngayVaoLam,
    trangThai,
    maVaiTro,
  } = data;

  if (!hoTen || !ngayVaoLam || maVaiTro === undefined || maVaiTro === null) {
    throw new Error("Họ tên, ngày vào làm và mã vai trò là bắt buộc");
  }

  const vaiTro = await nhanVienRepository.findVaiTroById(Number(maVaiTro));
  if (!vaiTro) {
    throw new Error("Vai trò không tồn tại");
  }

  const updated = await nhanVienRepository.update(Number(maNV), {
    hoTen,
    ngaySinh,
    gioiTinh,
    sdt,
    email,
    diaChi,
    ngayVaoLam,
    trangThai: trangThai === undefined ? existingNhanVien.TrangThai : trangThai,
    maVaiTro: Number(maVaiTro),
  });

  if (!updated) {
    throw new Error("Cập nhật nhân viên thất bại");
  }

  return {
    message: "Cập nhật nhân viên thành công",
  };
};

const updateStatus = async (maNV, trangThai) => {
  if (!maNV || isNaN(maNV)) {
    throw new Error("Mã nhân viên không hợp lệ");
  }

  if (trangThai === undefined || trangThai === null) {
    throw new Error("Trạng thái là bắt buộc");
  }

  const existingNhanVien = await nhanVienRepository.findById(Number(maNV));
  if (!existingNhanVien) {
    throw new Error("Nhân viên không tồn tại");
  }

  const updated = await nhanVienRepository.updateStatus(
    Number(maNV),
    trangThai
  );

  if (!updated) {
    throw new Error("Cập nhật trạng thái thất bại");
  }

  return {
    message: "Cập nhật trạng thái nhân viên thành công",
  };
};

const remove = async (maNV) => {
  if (!maNV || isNaN(maNV)) {
    throw new Error("Mã nhân viên không hợp lệ");
  }

  const existingNhanVien = await nhanVienRepository.findById(Number(maNV));
  if (!existingNhanVien) {
    throw new Error("Nhân viên không tồn tại");
  }

  const deleted = await nhanVienRepository.softDelete(Number(maNV));

  if (!deleted) {
    throw new Error("Xóa nhân viên thất bại");
  }

  return {
    message: "Xóa mềm nhân viên thành công",
  };
};

module.exports = {
  getAll,
  getById,
  create,
  update,
  updateStatus,
  remove,
};
