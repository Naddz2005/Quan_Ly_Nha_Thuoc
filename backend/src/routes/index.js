const express = require("express");
const authRoutes = require("./auth.routes");
const nhanVienRoutes = require("./nhanVien.routes");

const router = express.Router();

router.use("/auth", authRoutes);
router.use("/nhan-vien", nhanVienRoutes);

module.exports = router;
