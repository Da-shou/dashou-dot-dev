'use strict';

const sqlite3 = require('sqlite3').verbose();
const path = require('node:path');

const db = new sqlite3.Database(path.join(__dirname,"../database/blogdata.db"), sqlite3.OPEN_READWRITE, (err) => {
	if (err) console.error(err.message); 
	else console.log("✅ Successfully connected to the database !");
});

let posts;
db.all("SELECT id_post, title, content FROM post", (err, rows) => {
	if (err) throw err; 	
	posts = rows;	
});

exports.list = function(_, res){
  res.render('posts', { title: 'Posts', posts: posts });
};
