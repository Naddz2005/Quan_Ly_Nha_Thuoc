const authRepository = require("../repositories/auth.repository");
const { hashPassword, comparePassword } = require("../utils/hash");
const { generateAccessToken } = require("../utils/jwt");

const login = async ({ tenDangNhap, matKhau }) => {
  if (!tenDangNhap || !matKhau) {
    throw new Error("Tên đăng nhập và mật khẩu là bắt buộc");
  }

  const account = await authRepository.findByUsername(tenDangNhap);

  if (!account) {
    throw new Error("Tên đăng nhập hoặc mật khẩu không đúng");
  }

  if (!account.TrangThai) {
    throw new Error("Tài khoản đã bị khóa");
  }

  const isMatch = await comparePassword(matKhau, account.MatKhauHash);
  if (!isMatch) {
    throw new Error("Tên đăng nhập hoặc mật khẩu không đúng");
  }

  // SỬA generateToken -> generateAccessToken
  const token = generateAccessToken({
    maTK: account.MaTK,
    tenDangNhap: account.TenDangNhap,
    maNV: account.MaNV,
  });

  return {
    message: "Đăng nhập thành công",
    token,
    user: {
      maTK: account.MaTK,
      tenDangNhap: account.TenDangNhap,
      maNV: account.MaNV,
      trangThai: account.TrangThai,
    },
  };
};

const register = async (data) => {
  const { tenDangNhap, matKhau, maNV } = data;

  if (!tenDangNhap || !matKhau || !maNV) {
    throw new Error("Tên đăng nhập, mật khẩu và mã nhân viên là bắt buộc");
  }

  const isUsernameExists = await authRepository.existsByUsername(tenDangNhap);
  if (isUsernameExists) {
    throw new Error("Tên đăng nhập đã tồn tại");
  }

  const nhanVien = await authRepository.findNhanVienById(maNV);
  if (!nhanVien) {
    throw new Error("Nhân viên không tồn tại");
  }

  const isNhanVienExists = await authRepository.existsByNhanVien(maNV);
  if (isNhanVienExists) {
    throw new Error("Nhân viên này đã có tài khoản");
  }

  const matKhauHash = await hashPassword(matKhau);

  const createdAccount = await authRepository.createAccount({
    tenDangNhap,
    matKhauHash,
    maNV,
    trangThai: true,
  });

  return {
    message: "Tạo tài khoản thành công",
    account: createdAccount,
  };
};

const getMe = async (user) => {
  const account = await authRepository.findById(user.maTK);

  if (!account) {
    throw new Error("Tài khoản không tồn tại");
  }

  return {
    maTK: account.MaTK,
    tenDangNhap: account.TenDangNhap,
    maNV: account.MaNV,
    trangThai: account.TrangThai,
  };
};

const changePassword = async (user, data) => {
  const { matKhauCu, matKhauMoi } = data;

  if (!user || !user.maTK) {
    throw new Error("Không xác định được người dùng");
  }

  if (!matKhauCu || !matKhauMoi) {
    throw new Error("Mật khẩu cũ và mật khẩu mới là bắt buộc");
  }

  const account = await authRepository.findById(user.maTK);

  if (!account) {
    throw new Error("Không tìm thấy tài khoản");
  }

  const isMatch = await comparePassword(matKhauCu, account.MatKhauHash);

  if (!isMatch) {
    throw new Error("Mật khẩu cũ không đúng");
  }

  const newPasswordHash = await hashPassword(matKhauMoi);

  await authRepository.updatePassword(user.maTK, newPasswordHash);

  return {
    message: "Đổi mật khẩu thành công",
  };
};

module.exports = {
  login,
  register,
  getMe,
  changePassword,
};
