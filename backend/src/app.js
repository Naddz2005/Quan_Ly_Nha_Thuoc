const express = require("express");
const routes = require("./routes/index");

console.log("routes =", routes);
console.log("typeof routes =", typeof routes);

const app = express();

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use("/api", routes);

module.exports = app;
