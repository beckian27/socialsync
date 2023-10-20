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


@insta485.app.route('/api/v1/posts/')
def api_posts():
    """Return list of posts with optional parameters."""
    logname = http()
    connection = model.get_db()
    cur = connection.execute(
        "SELECT postid "
        "FROM posts "
        "WHERE owner IN ("
        "SELECT username2 FROM following WHERE username1 = ?)"
        "OR owner = ? "
        "ORDER BY postid DESC "
        "LIMIT 1",
        (logname, logname)
    )
    most_rec_postid = cur.fetchall()[0]['postid']

    s_z = flask.request.args.get("size", default=10, type=int)
    lte = flask.request.args.get("postid_lte",
                                 default=most_rec_postid, type=int)
    pge = flask.request.args.get("page", default=0, type=int)

    if pge < 0 or s_z < 0:
        flask.abort(400)

    cur = connection.execute(
        "SELECT postid "
        "FROM posts "
        "WHERE owner IN ("
        "SELECT username2 FROM following WHERE username1 = ?) "
        "OR owner = ? "
        "AND postid <= ? "
        "ORDER BY postid DESC "
        "LIMIT ? "
        "OFFSET ?",
        (logname, logname, lte, s_z, pge * s_z)
    )
    posts = cur.fetchall()

    for post in posts:
        post['url'] = f"/api/v1/posts/{post['postid']}/"

    nexturl = helpers.get_next_url(s_z, pge, lte, logname)

    url = flask.request.path
    print(url, flask.request.full_path)
    if url != flask.request.full_path[:-1:]:
        url = flask.request.full_path

    context = {
        "next": nexturl,
        "results": posts,
        "url": url
    }
    return flask.jsonify(**context)


@insta485.app.route('/api/v1/posts/<int:postid>/')
def get_post(postid):
    """Return individual post info via REST API query."""
    logname = http()
    connection = model.get_db()
    cur = connection.execute(
        "SELECT commentid, owner, text FROM comments "
        "WHERE postid = ?",
        (postid,)
    )
    comments = cur.fetchall()

    for comment in comments:
        comment['lognameOwnsThis'] = (comment['owner'] == logname)
        comment['ownerShowUrl'] = f'/users/{comment["owner"]}/'
        comment['url'] = f'/api/v1/comments/{comment["commentid"]}/'

    likes = helpers.get_like_info(logname, postid)

    cur = connection.execute(
        "SELECT filename, created, owner FROM posts "
        "WHERE postid = ? "
        "LIMIT 1",
        (postid,)
    )
    postinfo = cur.fetchall()
    # sError checking: postid does not exist
    print(postinfo)
    if len(postinfo) == 0:
        raise helpers.InvalidUsage('Not Found', status_code=404)

    owner = postinfo[0]['owner']
    cur = connection.execute(
        "SELECT filename FROM users "
        "WHERE username = ? "
        "LIMIT 1",
        (owner,)
    )
    ownerinfo = cur.fetchall()

    context = {
        'comments': comments,
        'comments_url': f'/api/v1/comments/?postid={postid}',
        'created': postinfo[0]['created'],
        'imgUrl': f'/uploads/{postinfo[0]["filename"]}',
        'likes': likes,
        'owner': owner,
        'ownerImgUrl': f'/uploads/{ownerinfo[0]["filename"]}',
        'ownerShowUrl': f'/users/{owner}/',
        'postShowUrl': f'/posts/{postid}/',
        'postid': postid,
        'url': f'/api/v1/posts/{postid}/'
    }
    return flask.jsonify(**context)


@insta485.app.route('/api/v1/likes/', methods=['POST'])
def create_like():
    """Like the provided post."""
    logname = http()
    postid = flask.request.args.get("postid", type=int)
    connection = model.get_db()
    cur = connection.execute(
        "SELECT likeid FROM likes "
        "WHERE owner = ? "
        "AND postid = ?",
        (logname, postid)
    )
    like = cur.fetchall()
    if like:
        context = {
            'likeid': like[0]['likeid'],
            'url': f'/api/v1/likes/{like[0]["likeid"]}/'
        }
        return flask.jsonify(**context), 200
    connection.execute(
        "INSERT INTO likes(owner, postid) "
        "VALUES (?, ?)",
        (logname, postid)
    )
    cur = connection.execute(
        "SELECT last_insert_rowid()"
    )
    like = cur.fetchall()[0]['last_insert_rowid()']
    context = {
        'likeid': like,
        'url': f'/api/v1/likes/{like}/'
    }
    return flask.jsonify(**context), 201


@insta485.app.route('/api/v1/likes/<int:likeid>/', methods=['DELETE'])
def delete_like(likeid):
    """Delete the provided like."""
    logname = http()
    connection = model.get_db()
    cur = connection.execute(
        "SELECT owner FROM likes "
        "WHERE likeid = ?",
        (likeid,)
    )
    like = cur.fetchall()
    if not like:
        raise helpers.InvalidUsage('Not Found', status_code=404)
    if like[0]['owner'] != logname:
        raise helpers.InvalidUsage('Forbidden', status_code=403)
    connection.execute(
        "DELETE FROM likes "
        "WHERE likeid = ?",
        (likeid,)
    )
    return '', 204


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
