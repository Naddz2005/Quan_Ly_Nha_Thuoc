const express = require("express");
const nhanVienController = require("../controllers/nhanVien.controller");
const authMiddleware = require("../middlewares/auth.middleware");

const router = express.Router();

// Lấy danh sách nhân viên
router.get("/", authMiddleware, nhanVienController.getAll);

// Lấy chi tiết 1 nhân viên
router.get("/:id", authMiddleware, nhanVienController.getById);

// Thêm nhân viên
router.post("/", authMiddleware, nhanVienController.create);

// Cập nhật nhân viên
router.put("/:id", authMiddleware, nhanVienController.update);

// Cập nhật trạng thái nhân viên
router.patch("/:id/status", authMiddleware, nhanVienController.updateStatus);

// Xóa mềm nhân viên
router.delete("/:id", authMiddleware, nhanVienController.remove);

module.exports = router;
