'use strict';

// Dependencies
const express = require("express");
const path = require("node:path");

const about = require("./src/about");
const post = require("./src/post");
const site = require("./src/site");

const app = express();
const port = 23979;

module.exports = app;

// Configuring the view engine
app.set("view engine", "ejs");
app.set("views", path.join(__dirname, "src/views"));

// Making static content available
app.use(express.static(path.join(__dirname, "src/public")));

app.get("/", site.index);

// Post list endpoint
app.get("/posts", post.list);

// Post list endpoint
app.get("/post/:id", post.display_post);

// Post about endpoint
app.get("/about", about.index)

app.listen(port, () => {
  console.log(`🚀 dashou-dot-dev started and listening on port ${port} !`);
});