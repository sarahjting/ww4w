CREATE TABLE accounts(
  id serial PRIMARY KEY,
  device_id VARCHAR(100) NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  gems INTEGER NOT NULL DEFAULT 0
);
CREATE TABLE waifus(
  mal_id INTEGER UNIQUE NOT NULL,
  name VARCHAR (100) NOT NULL,
  url VARCHAR (200) NOT NULL,
  image_url VARCHAR(200) NOT NULL,
  canon_id INTEGER NOT NULL
);
CREATE TABLE account_waifus(
  account_id INTEGER NOT NULL,
  waifu_id INTEGER NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE tags(
  id SERIAL PRIMARY KEY,
  account_id INTEGER NOT NULL,
  tag VARCHAR(100) NOT NULL,
  UNIQUE(account_id, tag)
);
CREATE TABLE cycles(
  id SERIAL PRIMARY KEY,
  account_id INTEGER NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  ended_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  tag_id INTEGER NOT NULL DEFAULT 0,
  is_ended BOOLEAN NOT NULL DEFAULT FALSE
);
CREATE TABLE canons(
  id SERIAL PRIMARY KEY,
  mal_id INTEGER NOT NULL,
  mal_type VARCHAR(10) NOT NULL,
  title VARCHAR(100) NOT NULL,
  url VARCHAR(200) NOT NULL,
  image_url VARCHAR(200) NOT NULL,
  UNIQUE(mal_type, mal_id)
);
CREATE TABLE account_canons(
  account_id INTEGER NOT NULL,
  canon_id INTEGER NOT NULL,
  PRIMARY KEY(account_id, canon_id)
);