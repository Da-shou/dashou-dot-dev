BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "category" (
	"id_category"	INTEGER NOT NULL,
	"name"	VARCHAR(64) NOT NULL,
	PRIMARY KEY("id_category" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "comment" (
	"id_comment"	INTEGER NOT NULL,
	"author"	VARCHAR(32) NOT NULL,
	"content"	VARCHAR(512) NOT NULL,
	"timestamp"	TIMESTAMP NOT NULL,
	"id_post"	INT NOT NULL,
	PRIMARY KEY("id_comment" AUTOINCREMENT),
	CONSTRAINT "fk_comment_post" FOREIGN KEY("id_post") REFERENCES "post"("id_post") ON DELETE NO ACTION ON UPDATE NO ACTION
);
CREATE TABLE IF NOT EXISTS "post" (
	"id_post"	INTEGER NOT NULL,
	"title"	TEXT NOT NULL,
	"content"	LONGTEXT NOT NULL,
	"timestamp"	TIMESTAMP NOT NULL,
	"id_category"	INT NOT NULL,
	PRIMARY KEY("id_post" AUTOINCREMENT),
	CONSTRAINT "fk_post_category" FOREIGN KEY("id_category") REFERENCES "category"("id_category") ON DELETE NO ACTION ON UPDATE NO ACTION
);
CREATE TABLE IF NOT EXISTS "post_has_tag" (
	"id_post"	INTEGER NOT NULL,
	"id_tag"	INTEGER NOT NULL,
	PRIMARY KEY("id_tag","id_post"),
	CONSTRAINT "fk_post_has_tag_post" FOREIGN KEY("id_post") REFERENCES "post"("id_post") ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT "fk_post_has_tag_tag" FOREIGN KEY("id_tag") REFERENCES "tag"("id_tag") ON DELETE NO ACTION ON UPDATE NO ACTION
);
CREATE TABLE IF NOT EXISTS "tag" (
	"id_tag"	INTEGER NOT NULL,
	"name"	VARCHAR(32) NOT NULL,
	PRIMARY KEY("id_tag" AUTOINCREMENT)
);
INSERT INTO "category" ("id_category","name") VALUES (1,'Programming'),
 (2,'Music'),
 (3,'');
INSERT INTO "post" ("id_post","title","content","timestamp","id_category") VALUES (1,'My first post','Welcome to my first blog post. If you can see this text, your''re pretty early !','2025-11-13 14:47:40',1);
INSERT INTO "post_has_tag" ("id_post","id_tag") VALUES (1,3),
 (1,4);
INSERT INTO "tag" ("id_tag","name") VALUES (1,'html'),
 (2,'css'),
 (3,'c'),
 (4,'glfw'),
 (5,'cpp');
CREATE INDEX IF NOT EXISTS "fk_comment_post_idx" ON "comment" (
	"id_post"
);
CREATE INDEX IF NOT EXISTS "fk_post_category_idx" ON "post" (
	"id_category"
);
CREATE INDEX IF NOT EXISTS "fk_post_has_tag_post_idx" ON "post_has_tag" (
	"id_post"
);
CREATE INDEX IF NOT EXISTS "fk_post_has_tag_tag_idx" ON "post_has_tag" (
	"id_tag"
);
COMMIT;
