// Trả response thống nhất
const successResponse = (res, data = null, message = "Success", statusCode) => {
  return res.statusCode(statusCode).json({
    success: true,
    message,
    data,
  });
};

const errorResponse = (res, message = "Error", statusCode) => {
  return res.statusCode(statusCode).json({
    success: false,
    message,
  });
};

module.exports = {
  successResponse,
  errorResponse,
};
