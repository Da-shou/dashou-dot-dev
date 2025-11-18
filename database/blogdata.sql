BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "category" (
	"id_category"	INTEGER NOT NULL,
	"name"	TEXT NOT NULL,
	PRIMARY KEY("id_category" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "comment" (
	"id_comment"	INTEGER NOT NULL,
	"author"	TEXT NOT NULL DEFAULT 'Author',
	"content"	TEXT NOT NULL DEFAULT 'Content',
	"timestamp"	TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
	"id_post"	INT NOT NULL,
	PRIMARY KEY("id_comment" AUTOINCREMENT),
	CONSTRAINT "fk_comment_post" FOREIGN KEY("id_post") REFERENCES "post"("id_post") ON DELETE NO ACTION ON UPDATE NO ACTION
);
CREATE TABLE IF NOT EXISTS "post" (
	"id_post"	INTEGER NOT NULL,
	"title"	TEXT NOT NULL DEFAULT 'Default title',
	"content"	TEXT NOT NULL DEFAULT 'Default description',
	"timestamp"	TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
	"id_category"	INTEGER NOT NULL DEFAULT 1,
	"abstract"	TEXT NOT NULL DEFAULT 'Default abstract',
	"thumbnail"	TEXT,
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
	"name"	TEXT NOT NULL,
	PRIMARY KEY("id_tag" AUTOINCREMENT)
);
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
