const express = require("express");
const authController = require("../controllers/auth.controller");
const authMiddleware = require("../middlewares/auth.middleware");

console.log("authController =", authController);
console.log("authController.login =", authController.login);
console.log("authController.register =", authController.register);
console.log("authController.me =", authController.me);
console.log("authController.changePassword =", authController.changePassword);
console.log("authMiddleware =", authMiddleware);

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
