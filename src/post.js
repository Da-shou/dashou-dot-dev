'use strict';

const sqlite3 = require('sqlite3').verbose();
const path = require('node:path');
const marked = require('marked');

<<<<<<< Updated upstream
const db = new sqlite3.Database(path.join(__dirname, "../database/blogdata.db"), sqlite3.OPEN_READWRITE, (err) => {
    if (err) console.error(err.message);
    else console.log("✅ Successfully connected to the database !");
=======
<<<<<<< Updated upstream
const db = new sqlite3.Database(path.join(__dirname,"../database/blogdata.db"), sqlite3.OPEN_READWRITE, (err) => {
	if (err) console.error(err.message); 
	else console.log("✅ Successfully connected to the database !");
=======
const db = new sqlite3.Database(path.join(__dirname, "../database/blogdata.db"), sqlite3.OPEN_READWRITE, (err) => {
        if (err) console.error(err.message);
        else console.log("✅ Successfully connected to the database !");
>>>>>>> Stashed changes
>>>>>>> Stashed changes
});

const max_abstract_length = 250;

<<<<<<< Updated upstream
exports.list = function (_, res) {
    db.all("SELECT id_post AS id, title AS title, abstract, thumbnail, timestamp FROM post", (err, rows) => {
        if (err) throw err;
        const posts = rows;
=======
<<<<<<< Updated upstream
exports.list = function(_, res){
	db.all("SELECT id_post AS id, title AS title, abstract, thumbnail, timestamp FROM post", (err, rows) => {
		if (err) throw err;	
		const posts = rows;
=======
exports.list = function(_, res) {
        db.all("SELECT id_post AS id, title AS title, abstract, thumbnail, timestamp FROM post", (err, rows) => {
                if (err) throw err;
                const posts = rows;
>>>>>>> Stashed changes
>>>>>>> Stashed changes

                rows.forEach(post => {
                        if (post.abstract.length > max_abstract_length) {
                                post.abstract = post.abstract.substring(0, max_abstract_length + 1) + "...";
                        }
                });

<<<<<<< Updated upstream
        res.render('posts/posts.ejs', {title: `Browse ${posts.length} posts...`, posts: posts});
    });
=======
<<<<<<< Updated upstream
  		res.render('posts/posts.ejs', { title: `Browse ${posts.length} posts...`, posts: posts });
	});
>>>>>>> Stashed changes
};

exports.display_post = function (req, res) {
    const id = req.params.id
    db.get(`SELECT title, content, id_category, timestamp
            FROM post
            WHERE id_post = ${id}
            LIMIT 1`, (err, post) => {
        if (err) throw err;

<<<<<<< Updated upstream
        if (post) {
            const id_cat = post.id_category;
            db.get(`SELECT name
                    from category
                    WHERE category.id_category = ${id_cat}
                    LIMIT 1`, (err, cat) => {
                if (err) throw err;
                res.render('posts/display_post.ejs', {title: post.title, category: cat.name, post: post});
            });
        }
    });
}
=======
            if (post) {
                const id_cat = post.id_category;
                db.get(`SELECT name from category WHERE category.id_category = ${id_cat} LIMIT 1`, (err, cat) => {
                    if (err) throw err;
                    res.render('posts/display_post.ejs', { title: post.title, category: cat.name, post: post });
                });
            }
        });
}
=======
                res.render('posts/posts.ejs', {
                        title: `Browse ${posts.length} posts...`,
                        posts: posts
                });
        });
};

exports.display_post = function(req, res) {
        const id = req.params.id;
        db.get(`SELECT title, content, id_category, timestamp FROM post WHERE id_post = ${id} LIMIT 1`, (err, post) => {
                if (err) throw err;
                post.content = marked.parse(post.content);

                if (post) {
                        const id_cat = post.id_category;
                        db.get(`SELECT name from category WHERE category.id_category = ${id_cat} LIMIT 1`, (err, cat) => {
                                if (err) throw err;
                                res.render('posts/display_post.ejs', {
                                        title: post.title,
                                        category: cat.name,
                                        post: post
                                });
                        });
                }
        });
};

>>>>>>> Stashed changes
>>>>>>> Stashed changes
