-- SQLite3-based, maybe can do PgSQL in the future if it gets serious.

---------------
-- SERVERS ---
-------------
CREATE TABLE servers (
	server_id TEXT PRIMARY KEY, -- TEXT because Discord API IDs are very long
	modules TEXT, 				-- module1,module2,...,moduleN
	logChannel TEXT
);

CREATE TABLE servers_roles (	-- a fluid one-to-many so we don't have to alter the db
	server_id TEXT,				-- key from server table
	role_spec TEXT,				-- nsfw, no_nsfw, admin, etc
	role_id TEXT,				-- ID of the role in Discord
	UNIQUE(server_id, role_spec) ON CONFLICT REPLACE
);

CREATE INDEX servers_roles_id ON servers_roles (server_id);


-----------------------
-- MEDKIT SETTINGS ---
---------------------
CREATE TABLE settings (			-- A SQL KV for simplicity. (pg: hstore?)
	key TEXT PRIMARY KEY,
	value TEXT
);

-- Setup the default settings
INSERT INTO settings (key, value) VALUES 
	('status_game', 'DM me `help`'),
	('status_state', 'online'),
	('globalLogChannel','');

----------------
-- TIMEOUTS ---
--------------

CREATE TABLE timeouts (
	server_id TEXT,
	user_id TEXT,
	mod_user_id TEXT,
	end_time INT,
	start_time INT,
	duration INT,
	reason TEXT,
	UNIQUE(server_id, user_id) ON CONFLICT REPLACE
);

-----------------------
-- CUSTOM COMMANDS ---
---------------------

CREATE TABLE custom_commands (
	server_id TEXT,
	command TEXT,
	response TEXT,
	UNIQUE(server_id, command) ON CONFLICT REPLACE
);