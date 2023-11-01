"""REST API for posts."""
import flask
import insta485
from insta485 import model
from insta485 import helpers


@insta485.app.route('/api/v1/')
def return_api():
    """Return REST API options."""
    context = {
      "comments": "/api/v1/comments/",
      "likes": "/api/v1/likes/",
      "posts": "/api/v1/posts/",
      "url": "/api/v1/"
    }
    return flask.jsonify(**context)


@insta485.app.route('/api/v1/events/<username>/')
def get_myEvents(username):
    connection = model.get_db()

    cur = connection.execute(
        "SELECT group_id "
        "FROM memberships "
        "WHERE username = ?",
        (username,)
    )
    
    groups = cur.fetchall()
    events = {'items':[]}
    for group in groups:
        cur = connection.execute(
            "SELECT event_name, event_id, time, "
            "host_name, group_id, image_name, confirmed, voting_required "
            "FROM events "
            "WHERE group_id = ?",
            (group['group_id'],)
        )
        results = cur.fetchall()
        for result in results:
            events['items'].append(result)
    
    return events


@insta485.app.route('/api/v1/invitations/<username>/')
def get_invites(username):
    connection = model.get_db()
    cur = connection.execute(
        "SELECT group_id "
        "FROM memberships "
        "WHERE username = ?",
        (username,)
    )
    
    groups = cur.fetchall()
    events = {'items':[]}
    for group in groups:
        cur = connection.execute(
            "SELECT event_name, invite_id, avail_time, "
            "host_name, group_id, image_name "
            "FROM invites "
            "WHERE group_id = ?",
            (group['group_id'],)
        )
        results = cur.fetchall()
        for result in results:
            events['items'].append(result)
                
    return events


@insta485.app.route('/api/v1/groups/<username>/')
def get_groups(username):
    connection = model.get_db()
    cur = connection.execute(
        "SELECT group_id FROM memberships "
        "WHERE username = ? ",
        (username,)
    )
    
    groups = {'items': cur.fetchall()}
    
    
    
    
    return flask.jsonify(**groups)
    
@insta485.app.route('/api/v1/groupinfo/<group_id>/')
def get_group_info(group_id):
    connection = model.get_db()
    cur = connection.execute(
        "SELECT group_name FROM groups "
        "WHERE group_id = ? ",
        (group_id,)
    )
    
    info = {'items': {'group_name': cur.fetchone()['group_name']}}
    
    cur = connection.execute(
        "SELECT username FROM memberships "
        "WHERE group_id = ?",
        (group_id,)
    )
    info['items']['members'] = []
    
    members = cur.fetchall()
    for member in members:
        info['items']['members'].append(member['username'])

    return flask.jsonify(**info)


@insta485.app.route('/api/v1/friends/<username>/')
def get_friends(username):
    connection = model.get_db()
    cur = connection.execute(
        "SELECT friend2 FROM friendships "
        "WHERE friend1 = ? ",
        (username,)
    )
    
    results = cur.fetchall()
    friends = {'items': []}
    for friend in results:
        friends['items'].append({'fullname': friend['friend2']})
        
    connection = model.get_db()
    cur = connection.execute(
        "SELECT friend1 FROM friendships "
        "WHERE friend2 = ? ",
        (username,)
    )
    
    results = cur.fetchall()
    for friend in results:
        friends['items'].append({'fullname': friend['friend1']})
        
    return friends


@insta485.app.route('/api/v1/create_user/', methods=['POST'])
def create_user():
    # could do an error check if we're feeling fancy
    username = flask.request.args.get('username')
    password = flask.request.args.get('password')
    fullname = flask.request.args.get('fullname')
    filename = flask.request.args.get('filename')

    connection = model.get_db()
    connection.execute(
        "INSERT INTO users(username, password, fullname, filename) "
        "VALUES (?, ?, ?, ?)",
        (username, password, fullname, filename)
    )


@insta485.app.route('/api/v1/add_friend/<username>/', methods=['POST'])
def add_friend(username):
    friendname = flask.request.args.get('friendname')
    connection = model.get_db()
    cur = connection.execute(
        "INSERT INTO friendships(friend1, friend2) "
        "VALUES (?, ?)",
        (username, friendname)
    )


@insta485.app.route('/api/v1/join_group/', methods=['POST'])
def join_group():
    username = flask.request.args.get('username')
    group_id = flask.request.args.get('group_id')

    connection = model.get_db()
    cur = connection.execute(
        "INSERT INTO memberships(friend1, friend2) "
        "VALUES (?, ?)",
        (username, group_id)
    )

@insta485.app.route('/api/v1/respond/', methods=['POST'])
def submit_response():
    username = flask.request.args.get('username')
    invite_id = flask.request.args.get('invite_id')
    times = flask.request.args.get('times')

    connection = model.get_db()
    cur = connection.execute(
        "INSERT INTO responses(invite_id, username, times) "
        "VALUES (?, ?, ?)",
        (invite_id, username, times)
    )
    
    cur = connection.execute(
        "SELECT group_size FROM invites "
        "WHERE invite_id = ?",
        (invite_id,)
    )
    group_size = cur.fetchone()['group_size']
    
    cur = connection.execute(
        "SELECT invite_id FROM responses "
        "WHERE invite_id = ?",
        (invite_id,)
    )
    responses = cur.fetchall()
    if len(responses) == group_size:
        calculate_time(invite_id)
        
        
def calculate_time(invite_id):
    connection = model.get_db()
    cur = connection.execute(
        "SELECT username, times FROM responses "
        "WHERE invite_id = ?",
        (invite_id,)
    )
    responses = cur.fetchall()
    
    for response in responses:
        response['times'] = strToDates(response['times'])
        
    
    return
    
def strToDates(times):
    result = []
    times = times.split('|')
    for time in times:
        time

@insta485.app.route('/api/v1/create_invite/', methods=['POST'])
def comments_commentid():
    event_name = flask.request.args.get('event_name')
    avail_time = flask.request.args.get('avail_time')
    host_name = flask.request.args.get('host_name')
    group_id = flask.request.args.get('group_id')
    image_name = flask.request.args.get('image_name')

    connection = model.get_db()
    cur = connection.execute(
        "SELECT FROM memberships "
        "WHERE group_id = ?",
        (group_id,)
    )
    count = cur.fetchall()
    group_size = len(count)
    
    cur = connection.execute(
        "INSERT INTO invites(event_name, avail_time, host_name, group_id, group_size, image_name) "
        "VALUES(?, ?, ?, ?, ?, ?)",
        (event_name, avail_time, host_name, group_id, group_size, image_name)
    )
    
