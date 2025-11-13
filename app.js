// Dependencies
const express = require("express");
const path = require("node:path");

const post = require("./src/post");
const site = require("./src/site");

const app = express();
const port = 23979;

module.exports = app;

// Configuring the view engine
app.set("view engine", "ejs");
app.set("views", path.join(__dirname, "src/views"));

// Making CSS available
app.use(express.static(path.join(__dirname, "src/public")));

app.get("/", site.index);

// Post list endpoint
app.get("/posts", post.list);

app.listen(port, () => {
  console.log(`🚀 dashou-dot-dev started and listening on port ${port}`);
});
