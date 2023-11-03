PRAGMA foreign_keys = ON;


INSERT INTO users(username, fullname, filename, password)
VALUES 
    ('Ian', 'Ian Beck', 'josh', '6'),
    ('Allen', 'Allen Wang', 'josh', '6'),
    ('Alex', 'Alex Liu', 'josh', '6'),
    ('Maki', 'Maki Barnes', 'farrah', '6');

INSERT INTO groups(group_name)
VALUES
    ('theboys'),
    ('Socialsync'),
    ('luther house');

INSERT INTO memberships(username, group_id)
VALUES
    ('Ian', 1),
    ('Allen', 1),
    ('Alex', 1),
    ('Maki', 1),
    ('Ian', 2),
    ('Allen', 3);

INSERT INTO friendships(friend1, friend2)
VALUES
    ('Ian', 'Maki'),
    ('Alex', 'Allen'),
    ('Ian', 'Alex');

INSERT INTO invites(event_name, avail_time, host_name, group_id, image_name, group_size, duration) VALUES
    ('Lutherween', '10/27/2023 21:30~10/27/2023 23:30|10/28/2023 21:30~10/28/2023 23:30', 'Ian', 1, 'michaela', 4, 3600),
    ('allens house', 'asdf', 'Allen', 2, 'josh', 1, 1);

INSERT INTO events(event_name, host_name, group_id, image_name, time, attendees) VALUES
    ('moms house', 'Allen', 1, 'michaela', '11/5/2023 21:00~11/5/2023 22:00', 'me'),
    ('allens house', 'Ian', 2, 'josh', '11/6/2023 21:00~11/6/2023 23:00', 'joe');

INSERT INTO responses(username, invite_id, times) VALUES
    ('Ian', 1, '10/27/2023 21:30~10/27/2023 23:30|10/28/2023 21:30~10/28/2023 23:30'),
    ('Maki', 1, '10/28/2023 21:30~10/28/2023 23:30'),
    ('Alex', 1, '10/27/2023 21:30~10/27/2023 23:30|10/28/2023 22:30~10/28/2023 23:30'),
    ('Allen', 1, '10/27/2023 23:00~10/27/2023 23:30')
