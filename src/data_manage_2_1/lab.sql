-- ======================================================================================================= --
--                                                  Lab 1                                                  --
-- ======================================================================================================= --

DROP TABLE accounts, prefs, stats, rates, players CASCADE;

CREATE TABLE IF NOT EXISTS accounts (
	id SERIAL PRIMARY KEY,
	username varchar(30) NOT NULL,
	password varchar(30) NOT NULL
);

CREATE TABLE IF NOT EXISTS prefs (
	id SERIAL PRIMARY KEY,
	lang varchar(8) NOT NULL,
	color BIGINT NOT NULL
);

CREATE TABLE IF NOT EXISTS stats (
	id SERIAL PRIMARY KEY,
	playtime INTEGER DEFAULT 0
);

CREATE TABLE IF NOT EXISTS rates (
	id SERIAL PRIMARY KEY,
	bans INTEGER DEFAULT 0,
	unbantime BIGINT DEFAULT 0
);

CREATE TABLE IF NOT EXISTS players (
	id SERIAL PRIMARY KEY,
	account_id INTEGER NOT NULL references accounts(id),
	pref_id INTEGER NOT NULL references prefs(id),
	stat_id INTEGER NOT NULL references stats(id),
	rate_id INTEGER NOT NULL references rates(id)
);

-- ======================================================================================================= --
--                                                  Lab 2                                                  --
-- ======================================================================================================= --

-- ================================================== 1 ================================================== --

TRUNCATE TABLE players, accounts, prefs, stats, rates CASCADE;

WITH
account AS (INSERT INTO accounts (username, password) VALUES ('Player1', 'password1') RETURNING id AS account_id),
pref AS (INSERT INTO prefs (lang, color) VALUES ('ru', 0xffff0000) RETURNING id AS pref_id),
stat AS (INSERT INTO stats (playtime) VALUES (3) RETURNING id AS stat_id),
rate AS (INSERT INTO rates (bans, unbantime) VALUES (2, 1751488992509) RETURNING id AS rate_id)
INSERT INTO players (account_id, pref_id, stat_id, rate_id)
SELECT account_id, pref_id, stat_id, rate_id FROM account, pref, stat, rate;

WITH
account AS (INSERT INTO accounts (username, password) VALUES ('Player2', 'password2') RETURNING id AS account_id),
pref AS (INSERT INTO prefs (lang, color) VALUES ('ru', 0xffccff00) RETURNING id AS pref_id),
stat AS (INSERT INTO stats (playtime) VALUES (42) RETURNING id AS stat_id),
rate AS (INSERT INTO rates (bans, unbantime) VALUES (0, 0) RETURNING id AS rate_id)
INSERT INTO players (account_id, pref_id, stat_id, rate_id)
SELECT account_id, pref_id, stat_id, rate_id FROM account, pref, stat, rate;

WITH
account AS (INSERT INTO accounts (username, password) VALUES ('Player3', 'password3') RETURNING id AS account_id),
pref AS (INSERT INTO prefs (lang, color) VALUES ('ru', 0xff00ff66) RETURNING id AS pref_id),
stat AS (INSERT INTO stats (playtime) VALUES (741) RETURNING id AS stat_id),
rate AS (INSERT INTO rates (bans, unbantime) VALUES (4, 1753796509233) RETURNING id AS rate_id)
INSERT INTO players (account_id, pref_id, stat_id, rate_id)
SELECT account_id, pref_id, stat_id, rate_id FROM account, pref, stat, rate;

WITH
account AS (INSERT INTO accounts (username, password) VALUES ('Player4', 'password4') RETURNING id AS account_id),
pref AS (INSERT INTO prefs (lang, color) VALUES ('ru', 0xff0066ff) RETURNING id AS pref_id),
stat AS (INSERT INTO stats (playtime) VALUES (484) RETURNING id AS stat_id),
rate AS (INSERT INTO rates (bans, unbantime) VALUES (2, 1749498684152) RETURNING id AS rate_id)
INSERT INTO players (account_id, pref_id, stat_id, rate_id)
SELECT account_id, pref_id, stat_id, rate_id FROM account, pref, stat, rate;

WITH
account AS (INSERT INTO accounts (username, password) VALUES ('Player5', 'password5') RETURNING id AS account_id),
pref AS (INSERT INTO prefs (lang, color) VALUES ('ru', 0xffcc00ff) RETURNING id AS pref_id),
stat AS (INSERT INTO stats (playtime) VALUES (36) RETURNING id AS stat_id),
rate AS (INSERT INTO rates (bans, unbantime) VALUES (1, 1748893163073) RETURNING id AS rate_id)
INSERT INTO players (account_id, pref_id, stat_id, rate_id)
SELECT account_id, pref_id, stat_id, rate_id FROM account, pref, stat, rate;

SELECT * FROM players;
SELECT * FROM accounts;
SELECT * FROM prefs;
SELECT * FROM stats;
SELECT * FROM rates;

-- ================================================== 2 ================================================== --

DROP VIEW IF EXISTS players_view CASCADE;
DROP VIEW IF EXISTS bans_view CASCADE;

CREATE VIEW players_view AS
SELECT
    player.id, 
    a.username, a.password,
    p.lang, to_hex(p.color) as color,
    s.playtime,
    r.bans,
    r.unbantime
FROM players player
JOIN accounts a ON player.account_id = a.id
JOIN prefs p ON player.pref_id = p.id
JOIN stats s ON player.stat_id = s.id
JOIN rates r ON player.rate_id = r.id;

CREATE VIEW bans_view AS
SELECT
    p.id, a.username,
    s.playtime, r.bans,
    CASE 
    	WHEN r.unbantime > extract(EPOCH FROM NOW()) * 1000 THEN TRUE 
    	ELSE FALSE 
    END as banned,
    to_timestamp(r.unbantime/1000) as unbantime
FROM players p
JOIN accounts a ON p.account_id = a.id
JOIN stats s ON p.stat_id = s.id
JOIN rates r ON p.rate_id = r.id;


SELECT * FROM players_view;
SELECT * FROM bans_view;


-- ================================================== 3 ================================================== --

DROP VIEW IF EXISTS playtime_view CASCADE;
CREATE VIEW playtime_view AS
(SELECT 'Максимальное значение', playtime, id FROM stats ORDER BY playtime DESC LIMIT 1)
UNION ALL
(SELECT 'Минимальное значение',  playtime, id FROM stats ORDER BY playtime ASC  LIMIT 1)
UNION ALL
(SELECT 'Среднее значение',  AVG(playtime), null FROM stats)
UNION ALL
(SELECT 'Сумма значений',  SUM(playtime), null FROM stats)
;

SELECT * FROM playtime_view;

-- ================================================== 4 ================================================== --

update accounts set username = 'Gamer' where id = 1;
delete from players where id = 1;

-- having
SELECT a.username FROM
	accounts a JOIN 
	players p ON a.id = p.account_id JOIN 
	stats s ON p.stat_id = s.id
	GROUP BY a.id, a.username
	HAVING SUM(s.playtime) > 100
;

EXPLAIN (FORMAT JSON) select * from rates where rates.unbantime > 0; 
EXPLAIN (FORMAT JSON) SELECT a.username FROM
	accounts a JOIN 
	players p ON a.id = p.account_id JOIN 
	stats s ON p.stat_id = s.id
	GROUP BY a.id, a.username
	HAVING SUM(s.playtime) > 100
;

-- ======================================================================================================= --
--                                                  Lab 3                                                  --
-- ======================================================================================================= --

-- ================================================== 1 ================================================== --

DROP FUNCTION IF EXISTS save_stats(integer,integer);

CREATE OR REPLACE FUNCTION save_stats(sid INTEGER, p INTEGER) RETURNS INTEGER
AS $$
	DECLARE stat_id INTEGER;
	BEGIN
		IF (sid is NULL) THEN
			INSERT INTO stats (playtime) VALUES (p) RETURNING id INTO stat_id;
			RETURN stat_id;
		END IF;
		UPDATE stats SET playtime = p WHERE id = sid;
		RETURN sid;
	END;
$$ LANGUAGE plpgsql;

SELECT * FROM stats;
SELECT save_stats(13, 111);
SELECT save_stats(null, 222);
SELECT * FROM stats;

-- ================================================== 2 ================================================== --

DROP FUNCTION IF EXISTS delete_stats(integer);
CREATE OR REPLACE FUNCTION delete_stats(sid INTEGER) RETURNS VOID
AS $$
BEGIN
	DELETE FROM stats WHERE id = sid;
		EXCEPTION
	WHEN foreign_key_violation THEN
		RAISE EXCEPTION 'Невозможно выполнить удаление, так как есть внешние ссылки.';
END;
$$ LANGUAGE plpgsql;

SELECT save_stats(null, 1512) AS result;
SELECT delete_stats(1)  AS result;


SELECT * FROM stats;

-- ================================================== 3 ================================================== --

DROP FUNCTION IF EXISTS setof_stats(integer);

CREATE OR REPLACE FUNCTION setof_stats(t INTEGER) 
RETURNS setof stats
AS $$
BEGIN
	RETURN QUERY (SELECT * FROM stats WHERE playtime <= t);
END;
$$ LANGUAGE plpgsql;

SELECT setof_stats(10);

-- ================================================== 4 ================================================== --

DROP TYPE IF EXISTS playtime_type;
CREATE TYPE playtime_type AS (
	id BIGINT,
	playtime INTEGER
);

CREATE OR REPLACE FUNCTION filter_playtime(arr playtime_type[],	f INTEGER) RETURNS playtime_type[]
AS $$
BEGIN
	RETURN (SELECT array(SELECT (id, playtime)::playtime_type FROM unnest(arr) WHERE playtime >= f));
END;
$$ LANGUAGE plpgsql;

SELECT filter_playtime(
	array(SELECT (id, playtime)::playtime_type FROM stats), 43
);

SELECT filter_playtime(array(SELECT (id, playtime)::playtime_type FROM stats), 43);

-- ================================================== 5 ================================================== --

DROP TABLE IF EXISTS log_stats CASCADE;

CREATE TABLE IF NOT EXISTS log_stats (
	id SERIAL PRIMARY KEY,
	stat_id INTEGER REFERENCES stats(id),
	change_datetime TIMESTAMP DEFAULT NOW(),
	old_value INTEGER DEFAULT NULL,
	new_value INTEGER DEFAULT NULL
);

DROP FUNCTION IF EXISTS trigger_stats() CASCADE;
CREATE OR REPLACE FUNCTION trigger_stats() RETURNS TRIGGER
AS $$
	DECLARE
		old_val INTEGER;
	BEGIN
		CASE TG_OP
			WHEN 'UPDATE' THEN
				old_val := OLD.playtime;
			WHEN 'INSERT' THEN
				old_val := null;
		END CASE;
		INSERT INTO log_stats (stat_id, old_value, new_value)
		VALUES (NEW.id, old_val, NEW.playtime);
		RETURN NEW;
	END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER commit_stats_change AFTER UPDATE OR INSERT ON stats 
	FOR EACH ROW
		EXECUTE PROCEDURE trigger_stats();

SELECT save_stats(null, 230) AS result;
SELECT * FROM log_stats;

-- ================================================== 6 ================================================== --

CREATE OR REPLACE FUNCTION table_info(table_n VARCHAR, column_n VARCHAR)
RETURNS TABLE (
    description VARCHAR,
    value VARCHAR,
    id INTEGER
) AS $$
BEGIN
    RETURN QUERY EXECUTE 
        '(SELECT $1::VARCHAR, '||column_n||'::VARCHAR, id FROM '||table_n||' ORDER BY '||column_n||' DESC LIMIT 1)
         UNION ALL
         (SELECT $2::VARCHAR, '||column_n||'::VARCHAR, id FROM '||table_n||' ORDER BY '||column_n||' ASC LIMIT 1)'
    USING
        'Максимальное значение',
        'Минимальное значение';
END;
$$ LANGUAGE plpgsql;

SELECT * FROM table_info('stats', 'playtime');
SELECT * FROM table_info('accounts', 'username');


