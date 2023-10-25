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
            "SELECT event_name, event_id, start, end, "
            "host_name, group_id, image_name, confirmed, voting_required "
            "FROM events "
            "WHERE group_id = ?",
            (group['group_id'],)
        )
        results = cur.fetchall()
        for result in results:
            events['items'].append(result)
    
    return flask.jsonify(**events)


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
            "SELECT event_name, invite_id, avail_times, "
            "host_name, group_id, image_name "
            "FROM invites "
            "WHERE group_id = ?",
            (group['group_id'],)
        )
        results = cur.fetchall()
        for result in results:
            events['items'].append(result)
    
    return flask.jsonify(**events)


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


@insta485.app.route('/api/v1/friends/<username>/')
def delete_like(username):
    connection = model.get_db()
    cur = connection.execute(
        "SELECT username FROM friendships "
        "WHERE friend1 = ? ",
        (username,)
    )
    
    results = cur.fetchall()
    friends = []
    for friend in results:
        friends.appends(friend['friend1'])
        
    connection = model.get_db()
    cur = connection.execute(
        "SELECT username FROM friendships "
        "WHERE friend2 = ? ",
        (username,)
    )
    
    results = cur.fetchall()
    for friend in results:
        friends.appends(friend['friend2'])
        
    friends = {'friends': friends}
    return flask.jsonify(**friends)


@insta485.app.route('/api/v1/comments/', methods=['POST'])
def comments_postid():
    """Post a comment."""
    logname = http()
    postid = flask.request.args.get('postid', type=int)
    text = flask.request.get_json()['text']
    connection = model.get_db()
    connection.execute(
        "INSERT INTO comments(owner, postid, text) "
        "VALUES (?, ?, ?)",
        (logname, postid, text)
    )
    cur = connection.execute(
        "SELECT last_insert_rowid()"
    )
    commentid = cur.fetchall()[0]['last_insert_rowid()']
    cur = connection.execute(
        "SELECT owner, commentid, text FROM comments "
        "WHERE commentid = ?",
        (commentid,)
    )
    comment = cur.fetchall()
    context = {
        'commentid': commentid,
        'lognameOwnsThis': True,
        'ownerShowUrl': f'/users/{logname}/',
        'url': f'/api/v1/comments/{commentid}/',
        'owner': comment[0]['owner'],
        'text': comment[0]['text']
    }
    return flask.jsonify(**context), 201


@insta485.app.route('/api/v1/comments/<int:commentid>/', methods=['DELETE'])
def comments_commentid(commentid):
    """Delete the provided comment."""
    logname = http()

    connection = model.get_db()
    cur = connection.execute(
        "SELECT owner FROM comments "
        "WHERE commentid = ?",
        (commentid,)
    )
    comment = cur.fetchall()
    if not comment:
        raise helpers.InvalidUsage('Not Found', status_code=404)
    if comment[0]['owner'] != logname:
        raise helpers.InvalidUsage('Forbidden', status_code=403)

    connection.execute(
        "DELETE FROM comments "
        "WHERE commentid = ?",
        (commentid,)
    )

    return '', 204


# Helper functions
def http():
    """Delete the provided comment."""
    logname = password = None
    if 'username' in flask.session:
        logname = flask.session['username']
    else:
        if flask.request.authorization:
            logname = flask.request.authorization.get('username')
            password = flask.request.authorization.get('password')
        if helpers.http_auth_failed(logname, password):
            raise helpers.InvalidUsage('Forbidden', status_code=403)
    return logname
