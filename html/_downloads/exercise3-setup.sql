DROP TABLE IF EXISTS PageRevisions CASCADE;
CREATE TABLE PageRevisions (
  name    TEXT,
  date    TIMESTAMP,
  author  TEXT NOT NULL,
  text    TEXT NOT NULL,

  PRIMARY KEY (name, date)
);

DROP TABLE IF EXISTS DeleteLog CASCADE;
CREATE TABLE DeleteLog (
  page    TEXT,
  date    TIMESTAMP,

  PRIMARY KEY (page, date)
);

COPY PageRevisions FROM stdin;
Earth	1979-10-12	Megadodo	Harmless
Earth	1980-01-01	Ford Perfect	Mostly harmless
The answer	1982-07-23	Deep Thought	42
\.
