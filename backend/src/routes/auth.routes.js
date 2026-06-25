const express = require("express");

const authController = require("../controllers/auth.controller");
const authMiddleware = require("../middlewares/auth.middleware");
const nhanVienController = require("../controllers/nhanVien.controller");

const router = express.Router();

// Đăng nhập
router.post("/login", authController.login);

// Tạo tài khoản
router.post("/register", authController.register);

// Lấy thông tin tài khoản hiện tại
router.get("/me", authMiddleware, authController.me);

// Đổi mật khẩu
router.post("/change-password", authMiddleware, authController.changePassword);

module.exports = router;
