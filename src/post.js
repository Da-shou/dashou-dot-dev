'use strict';

const sqlite3 = require('sqlite3').verbose();
const path = require('node:path');

const db = new sqlite3.Database(path.join(__dirname,"../database/blogdata.db"), sqlite3.OPEN_READWRITE, (err) => {
	if (err) console.error(err.message); 
	else console.log("✅ Successfully connected to the database !");
});

const max_abstract_length = 250;

exports.list = function(_, res){
	db.all("SELECT id_post AS id, id_category AS category, title, abstract, content, thumbnail, timestamp FROM post", (err, rows) => {
		if (err) throw err;	
		const posts = rows;

        rows.forEach(post => {
            if (post.abstract.length > max_abstract_length) {
                post.abstract = post.abstract.substring(0, max_abstract_length + 1) + "...";
            }
        })

  		res.render('posts/posts.ejs', { title: `Browse ${posts.length} posts...`, posts: posts });
	});
};
