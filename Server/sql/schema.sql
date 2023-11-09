PRAGMA foreign_keys = ON;


CREATE TABLE IF NOT EXISTS invites(
  event_name VARCHAR(64) NOT NULL,
  avail_time VARCHAR(512) NOT NULL,
  host_name VARCHAR(40) NOT NULL,
  invite_id INTEGER PRIMARY KEY AUTOINCREMENT,
  created DATETIME DEFAULT CURRENT_TIMESTAMP,
  group_id INTEGER NOT NULL,
  group_size INTEGER NOT NULL,
  image_name VARCHAR(64) NOT NULL,
  duration INTEGER NOT NULL,
  FOREIGN KEY(host_name) REFERENCES users(username) ON DELETE CASCADE,
  FOREIGN KEY(group_id) REFERENCES groups(group_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS events(
  event_name VARCHAR(64) NOT NULL,
  event_id INTEGER PRIMARY KEY AUTOINCREMENT,
  time VARCHAR(128) NOT NULL,
  host_name VARCHAR(40),
  group_id INTEGER NOT NULL,
  image_name VARCHAR(100),
  confirmed INTEGER DEFAULT 0,
  attendees VARCHAR(256) NOT NULL,
  voting_required INTEGER DEFAULT 0,
  FOREIGN KEY(group_id) REFERENCES groups(group_id)
  ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS users(
  fullname VARCHAR(40) NOT NULL,
  username VARCHAR(40) PRIMARY KEY NOT NULL,
  filename VARCHAR(64) NOT NULL,
  password VARCHAR(256) NOT NULL,
  created DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS groups(
  group_name VARCHAR(40) NOT NULL,
  group_id INTEGER PRIMARY KEY AUTOINCREMENT,
  created DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS memberships(
  group_id INTEGER NOT NULL,
  username VARCHAR(40) NOT NULL,
  created DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY(group_id) REFERENCES groups(group_id) ON DELETE CASCADE,
  FOREIGN KEY(username) REFERENCES users(username)
  ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS friendships(
  friend1 VARCHAR(40) NOT NULL,
  friend2 VARCHAR(40) NOT NULL,
  FOREIGN KEY(friend1) REFERENCES users(username) ON DELETE CASCADE,
  FOREIGN KEY(friend2) REFERENCES users(username)
  ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS responses(
  invite_id INTEGER NOT NULL,
  username VARCHAR(40) NOT NULL,
  times VARCHAR(512) NOT NULL,
  FOREIGN KEY(invite_id) REFERENCES invites(invite_id) ON DELETE CASCADE,
  FOREIGN KEY(username) REFERENCES users(username) ON DELETE CASCADE
);
