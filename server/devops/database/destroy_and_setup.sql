DROP DATABASE IF EXISTS insanichess_db;
DROP USER IF EXISTS insanichess_admin;

CREATE USER insanichess_admin WITH LOGIN SUPERUSER INHERIT CREATEDB CREATEROLE NOREPLICATION PASSWORD 'demo_pass';
CREATE DATABASE insanichess_db WITH OWNER = insanichess_admin ENCODING = 'UTF8' CONNECTION LIMIT = -1;

\c insanichess_db;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE ic_users (
  id UUID NOT NULL DEFAULT uuid_generate_v4() PRIMARY KEY,
  username TEXT NOT NULL,
  email TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
) WITH ( OIDS = FALSE );
ALTER TABLE ic_users OWNER TO insanichess_admin;

CREATE TABLE ic_games (
  id UUID NOT NULL DEFAULT uuid_generate_v4() PRIMARY KEY,
  player_white UUID NOT NULL,
  player_black UUID NOT NULL,
  time_control_initial INT NOT NULL,
  time_control_increment INT NOT NULL,
  times_per_move INT[] NOT NULL,
  game_status INT NOT NULL,
  moves TEXT[] NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  CONSTRAINT ic_game_user_white FOREIGN KEY (player_white) REFERENCES ic_users(id),
  CONSTRAINT ic_game_user_black FOREIGN KEY (player_black) REFERENCES ic_users(id)
) WITH ( OIDS = FALSE );
ALTER TABLE ic_games OWNER TO insanichess_admin;
