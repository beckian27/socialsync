PRAGMA foreign_keys = ON;


INSERT INTO users(username, fullname, filename, password)
VALUES 
    ('awdeorio', 'Andrew DeOrio', 'e1a7c5c32973862ee15173b0259e3efdb6a391af.jpg', 'sha512$a45ffdcc71884853a2cba9e6bc55e812$c739cef1aec45c6e345c8463136dc1ae2fe19963106cf748baf87c7102937aa96928aa1db7fe1d8da6bd343428ff3167f4500c8a61095fb771957b4367868fb8'),
    ('jflinn', 'Jason Flinn', '505083b8b56c97429a728b68f31b0b2a089e5113.jpg', 'sha512$a45ffdcc71884853a2cba9e6bc55e812$c739cef1aec45c6e345c8463136dc1ae2fe19963106cf748baf87c7102937aa96928aa1db7fe1d8da6bd343428ff3167f4500c8a61095fb771957b4367868fb8'),
    ('michjc', 'Michael Cafarella', '5ecde7677b83304132cb2871516ea50032ff7a4f.jpg', 'sha512$a45ffdcc71884853a2cba9e6bc55e812$c739cef1aec45c6e345c8463136dc1ae2fe19963106cf748baf87c7102937aa96928aa1db7fe1d8da6bd343428ff3167f4500c8a61095fb771957b4367868fb8'),
    ('jag', 'H.V. Jagadish', '73ab33bd357c3fd42292487b825880958c595655.jpg', 'sha512$a45ffdcc71884853a2cba9e6bc55e812$c739cef1aec45c6e345c8463136dc1ae2fe19963106cf748baf87c7102937aa96928aa1db7fe1d8da6bd343428ff3167f4500c8a61095fb771957b4367868fb8');

INSERT INTO groups(groupname)
VALUES
('theboys'),
('M'),
('luther house');

INSERT INTO memberships(username, groupid)
VALUES
    ('awdeorio', 1),
    ('michjc', 1),
    ('jflinn', 1),
    ('awdeorio', 2),
    ('michjc', 2),
    ('awdeorio', 3);

INSERT INTO friendships(friend1, friend2)
VALUES
    ('awdeorio', 'jflinn'),
    ('awdeorio', 'michjc'),
    ('jflinn', 'awdeorio'),
    ('jflinn', 'michjc'),
    ('michjc', 'awdeorio'),
    ('michjc', 'jag'),
    ('jag', 'michjc');

INSERT INTO events(event_name, host_name, group_id, image_name) VALUES
    ('moms house', 'awdeorio', 1, 'michaela'),
    ('allens house', 'ur mom', 2, 'josh');
