"""Create helper functions."""
from flask import jsonify
from insta485 import model
import insta485


def get_next_url(size, page, lte, logname):
    """Get next url."""
    connection = model.get_db()
    offset = size*page
    cur = connection.execute(
        "SELECT postid "
        "FROM posts "
        "WHERE owner IN ("
        "SELECT username2  FROM following WHERE username1 = ?)"
        "OR owner = ? "
        "AND postid <= ?  "
        "ORDER BY postid DESC "
        "LIMIT ? "
        "OFFSET ?",
        (logname, logname, lte, size, offset)
    )
    count = cur.fetchall()

    if len(count) == 0:
        return ''
    print(count)
    if len(count) < size:
        return ''

    nxt = '/api/v1/posts/?size='
    nxt += str(size)
    nxt += '&page='
    nxt += str(page + 1)
    nxt += '&postid_lte='
    nxt += str(lte)
    return nxt


class InvalidUsage(Exception):
    """Handle exception."""

    status_code = 403

    def __init__(self, message, status_code=None, payload=None):
        """Get like info."""
        Exception.__init__(self)
        self.message = message
        if status_code is not None:
            self.status_code = status_code
        self.payload = payload

    def to_dict(self):
        """Change to dict."""
        riv = dict(self.payload or ())
        riv['message'] = self.message
        riv['status_code'] = self.status_code
        return riv


@insta485.app.errorhandler(InvalidUsage)
def handle_invalid_usage(error):
    """Handle error."""
    response = jsonify(error.to_dict())
    response.status_code = error.status_code
    return response


def http_auth_failed(username, password):
    """See if auth failed."""
    connection = model.get_db()
    cur = connection.execute(
        "SELECT password "
        "FROM users "
        "WHERE username = ?",
        (username, ))
    users = cur.fetchall()
    if len(users) == 0:
        return True

    db_pass = users[0]["password"]
    encrypted_pass = insta485.views.index.encrypt_pass_with_salt(db_pass,
                                                                 password)
    if encrypted_pass != db_pass:
        return True  # if passwords do not match
    return False


def get_like_info(logname, postid):
    """Get like info."""
    connection = model.get_db()
    cur = connection.execute(
        "SELECT likeid FROM likes  "
        "WHERE owner = ? "
        "AND postid = ?",
        (logname, postid)
    )
    like = cur.fetchall()
    likes_this = (len(like) == 1)
    cur = connection.execute(
        "SELECT COUNT(likeid) FROM likes "
        "WHERE postid = ?",
        (postid,)
    )
    num_likes = cur.fetchall()[0]['COUNT(likeid)']
    like_url = f'/api/v1/likes/{like[0]["likeid"]}/' if likes_this else None
    likes = {
        'lognameLikesThis': likes_this,
        'numLikes': num_likes,
        'url': like_url
    }
    return likes
