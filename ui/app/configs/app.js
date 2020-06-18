import defaults from "../../config/defaults";
const config = require("../../config/" +
  (process.env.APP_ENV || process.env.NODE_ENV || "development"));

export default { ...defaults, ...config, env: process.env.NODE_ENV };
