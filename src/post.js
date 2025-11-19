'use strict';

const sqlite3 = require('sqlite3').verbose();

let marked;
(async () => {
        marked = await import('marked');
})();

const path = require('node:path');

const db = new sqlite3.Database(path.join(__dirname, "../database/blogdata.db"), sqlite3.OPEN_READWRITE, (err) => {
        if (err) console.error(err.message);
        else console.log("✅ Successfully connected to the database !");
});

const max_abstract_length = 250;

const check_post_query = `
    SELECT id_post AS id FROM post WHERE id_post = ?;
`;

const get_post_list_query = `
        SELECT p.id_post AS id, p.id_category, p.title, p.abstract, p.thumbnail, p.timestamp, c.name AS category
        FROM post AS p
        LEFT JOIN category as c
        ON p.id_category = c.id_category
        `;

const get_post_details_query = `
        SELECT p.title, p.content, p.timestamp, c.name AS category
        FROM post AS p
        LEFT JOIN category as c
        ON p.id_category = c.id_category
        WHERE id_post = ? LIMIT 1`;

const get_tags_for_post_query = `
        SELECT t.*
        FROM tag AS t
        INNER JOIN post_has_tag AS pt ON t.id_tag = pt.id_tag
        WHERE pt.id_post = ?;
        `;

function getPostDetail(id) {
    return new Promise((resolve, reject) => {
        // Getting the details of a post
        db.get(get_post_details_query, [id],
            (err, post) => {
                if (err) reject(err);
                else if (post) {
                    resolve(post);
                } else {
                    reject("Invalid request");
                }
            });
    });
}

function getPostsList() {
    return new Promise((resolve, reject) => {
        const posts = db.all(get_post_list_query, (err, rows) => {
            if (err) reject(err);
            const posts = rows;

            rows.forEach(post => {
                if (post.abstract.length > max_abstract_length) {
                    post.abstract = post.abstract.substring(0, max_abstract_length + 1) + "...";
                }
            });

            resolve(posts);
        });
    });
}

function getPostTags(id) {
    return new Promise((resolve, reject) => {
        db.all(get_tags_for_post_query, [id],
            (err, rows) => {
                if (err) reject(err);
                else if (rows) {
                    const tags = [];
                    rows.forEach((tag) => {
                        tags.push(tag);
                    });
                    resolve(tags);
                } else {
                    reject("Invalid request");
                }
            });
    });
}

exports.list = async function(_, res) {
        const posts = await getPostsList();
        const tags_per_posts = [];

        for (const post of posts) {
            tags_per_posts.push(await getPostTags(post.id));
        }

        res.render('posts/posts.ejs', {
                title: `Browse ${posts.length} posts...`,
                posts: posts,
                tags: tags_per_posts
        });
};

exports.display_post = async function (req, res) {
    const id = req.params.id;
    const num = Number(id);

    if (Number.isNaN(num) || !Number.isFinite(num)) {
        return res.status(400).send('Invalid request');
    }

    const post = await getPostDetail(id);
    const tags = await getPostTags(id);

    marked.use({
        gfm: true,
        pedantic: false,
    });

    post.content = marked.parse(post.content);
    // Getting the tags for the post.

    res.render('posts/display_post.ejs', {
        title: post.title,
        post: post,
        tags: tags,
    });
};
