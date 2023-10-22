PRAGMA foreign_keys = ON;
kmnnoon


CREATE TABLE IF NOT EXISTS invitations(
  name VARCHAR(64) NOT NULL,
  creator VARCHAR(40) NOT NULL,
  inviteid INTEGER PRIMARY KEY AUTOINCREMENT,
  created DATETIME DEFAULT CURRENT_TIMESTAMP,
  groupid INTEGER NOT NULL,
  FOREIGN KEY(creator) REFERENCES users(username) ON DELETE CASCADE,
  FOREIGN KEY(groupid) REFERENCES groups(groupid)
  ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS events(
  name VARCHAR(64) NOT NULL,
  inviteid INTEGER PRIMARY KEY AUTOINCREMENT,
  created DATETIME DEFAULT CURRENT_TIMESTAMP,
  groupid INTEGER NOT NULL,
  FOREIGN KEY(groupid) REFERENCES groups(groupid)
  ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS users(
  fullname VARCHAR(40) NOT NULL,
  username VARCHAR(40) NOT NULL,
  filename VARCHAR(64) NOT NULL,
  password VARCHAR(256) NOT NULL,
  created DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY(username)
);

CREATE TABLE IF NOT EXISTS groups(
  groupname VARCHAR(20) NOT NULL,
  groupid INTEGER PRIMARY KEY AUTOINCREMENT,
  created DATETIME DEFAULT CURRENT_TIMESTAMP,
);

CREATE TABLE IF NOT EXISTS memberships(
  groupid INTEGER NOT NULL,
  username VARCHAR(40) NOT NULL,
  created DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY(groupid) REFERENCES groups(groupid) ON DELETE CASCADE,
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
