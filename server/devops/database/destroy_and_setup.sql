DROP DATABASE IF EXISTS insanichess_db;
DROP USER IF EXISTS insanichess_admin;

CREATE USER insanichess_admin WITH LOGIN SUPERUSER INHERIT CREATEDB CREATEROLE NOREPLICATION PASSWORD 'demo_pass';
CREATE DATABASE insanichess_db WITH OWNER = insanichess_admin ENCODING = 'UTF8' CONNECTION LIMIT = -1;

\c insanichess_db;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE ic_users (
  id UUID UNIQUE NOT NULL DEFAULT uuid_generate_v4() PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  hashed_password TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
) WITH ( OIDS = FALSE );
ALTER TABLE ic_users OWNER TO insanichess_admin;

CREATE TABLE ic_players (
  id UUID UNIQUE NOT NULL DEFAULT uuid_generate_v4() PRIMARY KEY,
  username TEXT UNIQUE NOT NULL,
  ic_user UUID UNIQUE NOT NULL,
  CONSTRAINT ic_player_user FOREIGN KEY (ic_user) REFERENCES ic_users(id)
) WITH ( OIDS = FALSE);
ALTER TABLE ic_players OWNER TO insanichess_admin;

CREATE TABLE ic_user_settings (
  id UUID UNIQUE NOT NULL DEFAULT uuid_generate_v4() PRIMARY KEY,
  ic_user UUID UNIQUE NOT NULL,
  show_legal_moves BOOLEAN DEFAULT TRUE NOT NULL,
  zoom_out_button_left BOOLEAN DEFAULT TRUE NOT NULL,
  otb_rotate_chessboard BOOLEAN DEFAULT FALSE NOT NULL,
  otb_mirror_top_pieces BOOLEAN DEFAULT FALSE NOT NULL,
  otb_allow_undo BOOLEAN DEFAULT TRUE NOT NULL,
  otb_promote_queen BOOLEAN DEFAULT FALSE NOT NULL,
  otb_auto_zoom_out INT DEFAULT 0 NOT NULL,
  live_allow_undo BOOLEAN DEFAULT TRUE NOT NULL,
  live_promote_queen BOOLEAN DEFAULT FALSE NOT NULL,
  live_auto_zoom_out INT DEFAULT 0 NOT NULL,
  CONSTRAINT ic_settings_user FOREIGN KEY (ic_user) REFERENCES ic_users(id) ON DELETE CASCADE
) WITH ( OIDS = FALSE );
ALTER TABLE ic_user_settings OWNER TO insanichess_admin;

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
  CONSTRAINT ic_game_player_white FOREIGN KEY (player_white) REFERENCES ic_players(id),
  CONSTRAINT ic_game_player_black FOREIGN KEY (player_black) REFERENCES ic_players(id)
) WITH ( OIDS = FALSE );
ALTER TABLE ic_games OWNER TO insanichess_admin;

CREATE TABLE ic_logs (
  id SERIAL PRIMARY KEY,
  log_level TEXT NOT NULL,
  log_location TEXT NOT NULL,
  log_message TEXT NOT NULL,
  log_at TIMESTAMP DEFAULT NOW()
) WITH ( OIDS = FALSE );
ALTER TABLE ic_logs OWNER TO insanichess_admin;
