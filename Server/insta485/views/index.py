"""
Insta485 index (main) view.

URLs include:
/
"""
import pathlib
import uuid
import hashlib
import arrow
import flask
from flask import render_template, redirect, url_for
import insta485
from insta485 import model


@insta485.app.route('/', methods=['GET'])
def show_index():
    """Pass pydocstyle."""
    if "username" not in flask.session:
        return flask.redirect(flask.url_for("login_post"))

    # Connect to database
    connection = model.get_db()

    # Query database
    logname = flask.session['username']

    cur = connection.execute(
        "SELECT postid, filename, owner, created "
        "FROM posts "
        "WHERE owner IN ("
        "SELECT username2 FROM following WHERE username1 = ?)"
        "OR owner = ? "
        "ORDER BY postid DESC",
        (logname, logname)
    )

    posts = cur.fetchall()

    for post in posts:
        post['created'] = arrow.get(post['created']).humanize()

        pid = post['postid']
        cur = connection.execute(
            "SELECT COUNT(*) FROM likes "
            "WHERE postid = ? ",
            (pid, )
        )
        likes = cur.fetchall()
        post['likes'] = likes[0]['COUNT(*)']

    for post in posts:
        pid = post['postid']
        cur = connection.execute(
            "SELECT EXISTS("
            "SELECT 1 FROM likes "
            "WHERE postid = ? AND owner = ? )",
            (pid, logname)
        )
        like = cur.fetchall()[0]
        post['liked_by_user'] = like['EXISTS(SELECT 1 FROM likes '
                                     'WHERE postid = ? AND owner = ? )']

    for post in posts:
        post['comments'] = []
        cur = connection.execute(
            "SELECT text, owner FROM comments "
            "WHERE postid = ? ",
            (post['postid'], )
        )
        comments = cur.fetchall()
        for comment in comments:
            post['comments'].append(comment)

    cur = connection.execute(
        "SELECT username, filename "
        "FROM users"
    )

    users = cur.fetchall()
    userdict = {}
    for user in users:
        userdict[user['username']] = user['filename']

    # Add database info to context
    context = {"posts": posts, "users": userdict, "logname": logname}
    return flask.render_template("index.html", **context)


@insta485.app.route('/users/<user_slug>/', methods=["GET"])
def user_profile(user_slug):
    """Pass pydocstyle."""
    if "username" not in flask.session:
        return flask.redirect(flask.url_for("login_post"))

    logname = flask.session['username']
    connection = model.get_db()

    reln = "self"

    if logname != user_slug:
        cur = connection.execute(
            "SELECT EXISTS("
            "SELECT 1 FROM following "
            "WHERE username1 = ? and username2 = ?)",
            (logname, user_slug)
        )
        temp = cur.fetchall()[0]
        if temp["EXISTS(SELECT 1 FROM following "
                "WHERE username1 = ? and username2 = ?)"] == 0:
            reln = "no"
        else:
            reln = "yes"

    cur = connection.execute(
        "SELECT COUNT(*) FROM posts "
        "WHERE owner = ?",
        (user_slug, )
    )
    numposts = cur.fetchall()[0]['COUNT(*)']

    cur = connection.execute(
        "SELECT COUNT(*) FROM following "
        "WHERE username2 = ?",
        (user_slug, )
    )
    numflrs = cur.fetchall()[0]['COUNT(*)']

    cur = connection.execute(
        "SELECT COUNT(*) FROM following "
        "WHERE username1 = ?",
        (user_slug, )
    )
    numflwg = cur.fetchall()[0]['COUNT(*)']

    cur = connection.execute(
        "SELECT filename, postid FROM posts "
        "WHERE owner = ?",
        (user_slug, )
    )
    posts = cur.fetchall()

    cur = connection.execute(
        "SELECT fullname FROM users "
        "WHERE username = ?",
        (user_slug, )
    )
    fullname = cur.fetchall()[0]["fullname"]

    context = {"posts": posts, "reln": reln, "logname": logname,
               "numflwg": numflwg, "numposts": numposts,
               "numflrs": numflrs, "username": user_slug,
               "fullname": fullname}
    return flask.render_template("user.html", **context)


@insta485.app.route('/users/<user_slug>/followers/', methods=["GET"])
def user_followers(user_slug):
    """Pass pydocstyle."""
    if "username" not in flask.session:
        return flask.redirect(flask.url_for("login_post"))

    logname = flask.session["username"]
    connection = model.get_db()
    cur = connection.execute(
        "SELECT username1 FROM following "
        "WHERE username2 = ? ",
        (user_slug, )
    )
    foll = cur.fetchall()
    for user in foll:
        name = user["username1"]
        cur = connection.execute(
            "SELECT filename from users "
            "WHERE username = ? ",
            (name, )
        )
        pic = cur.fetchall()
        user["pic"] = pic[0]["filename"]

        if name == logname:
            reln = 2
        else:
            cur = connection.execute(
                "SELECT EXISTS("
                "SELECT 1 from following "
                "WHERE username1 = ? AND username2 = ?)",
                (logname, name)
            )
            reln = cur.fetchall()[0]['EXISTS(SELECT 1 from following '
                                     'WHERE username1 = ? AND username2 = ?)']
        user["reln"] = reln
    context = {"followers": foll, "logname": logname, "user_slug": user_slug}
    return flask.render_template("followers.html", **context)


@insta485.app.route('/users/<user_slug>/following/', methods=["GET"])
def user_following(user_slug):
    """Pass pydocstyle."""
    if "username" not in flask.session:
        return flask.redirect(flask.url_for("login_post"))

    logname = flask.session["username"]
    connection = model.get_db()
    cur = connection.execute(
        "SELECT username2 FROM following "
        "WHERE username1 = ? ",
        (user_slug, )
    )
    foll = cur.fetchall()
    for uzer in foll:
        name = uzer["username2"]
        cur = connection.execute(
            "SELECT filename from users "
            "WHERE username = ? ",
            (name, )
        )
        pic = cur.fetchall()
        uzer["pic"] = pic[0]["filename"]

        if name == logname:
            reln = 2
        else:
            cur = connection.execute(
                "SELECT EXISTS("
                "SELECT 1 from following "
                "WHERE username1 = ? AND username2 = ?)",
                (logname, name)
            )
            reln = cur.fetchall()[0]
            reln = reln['EXISTS(SELECT 1 from following '
                        'WHERE username1 = ? AND username2 = ?)']
        uzer["reln"] = reln

    context = {"following": foll, "logname": logname, "user_slug": user_slug}
    return flask.render_template("following.html", **context)


@insta485.app.route('/posts/<postid_slug>/', methods=["GET"])
def view_post(postid_slug):
    """Pass pydocstyle."""
    if "username" not in flask.session:
        return flask.redirect(flask.url_for("login_post"))

    logname = flask.session['username']

    # post info
    connection = insta485.model.get_db()
    cur = connection.execute(
        "SELECT owner, filename, created "
        "FROM posts "
        "WHERE postid = ? ",
        (postid_slug,))
    post = cur.fetchall()
    post = post[0]

    # likes
    cur = connection.execute(
        "SELECT COUNT(*) FROM likes "
        "WHERE postid = ? ",
        (postid_slug, ))
    likes = cur.fetchall()
    num_likes = likes[0]["COUNT(*)"]

    # user profile rendering
    cur = connection.execute(
        "SELECT username, filename "
        "FROM users")
    users = cur.fetchall()
    userdict = {}
    for user in users:
        userdict[user['username']] = user['filename']

    cur = connection.execute(
        "SELECT EXISTS("
        "SELECT 1 FROM likes "
        "WHERE postid = ? AND owner = ? )",
        (postid_slug, logname)
    )
    like = cur.fetchall()
    post['liked_by_user'] = like[0]['EXISTS(SELECT 1 FROM likes '
                                    'WHERE postid = ? AND owner = ? )']

    # comments
    post['comments'] = []
    cur = connection.execute(
        "SELECT text, owner, commentid FROM comments "
        "WHERE postid = ? ",
        (postid_slug, )
    )
    comments = cur.fetchall()
    for comment in comments:
        post['comments'].append(comment)

    owner = post["owner"]
    context = {"logname": logname, "owner": owner,
               "post": post, "users": userdict,
               "img_url": "/uploads/" + post["filename"],
               "timestamp": arrow.get(post["created"]).humanize(),
               "postid": postid_slug,
               "owner_img_url": "/uploads/"+userdict[owner],
               "likes": num_likes, "comments": comments}
    return flask.render_template("post.html", **context)


@insta485.app.route('/explore/', methods=["GET"])
def explore():
    """Pass pydocstyle."""
    if "username" not in flask.session:
        return flask.redirect(flask.url_for("login_post"))

    # Connect & query to database
    logname = flask.session['username']

    connection = insta485.model.get_db()
    cur = connection.execute(
        "SELECT username, filename "
        "FROM users "
        "WHERE username NOT IN ("
        "SELECT username2 FROM following WHERE username1 = ?) "
        "AND username != ?",
        (logname, logname))
    not_following = cur.fetchall()

    context = {"not_following": not_following, "logname": logname}
    return flask.render_template("explore.html", **context)


@insta485.app.route('/accounts/logout/', methods=["POST"])
def logout():
    """Pass pydocstyle."""
    flask.session.clear()
    return flask.redirect(url_for("login_post"))


@insta485.app.route('/accounts/create/', methods=['GET'])
def create():
    """Pass pydocstyle."""
    if "username" in flask.session:
        return flask.redirect(flask.url_for("edit"))

    return flask.render_template("accounts/create.html",)


@insta485.app.route('/accounts/delete/')
def delete():
    """Pass pydocstyle."""
    logname = flask.session["username"]
    context = {"logname": logname}
    return flask.render_template("accounts/delete.html", **context)


@insta485.app.route('/accounts/edit/')
def edit():
    """Pass pydocstyle."""
    if 'username' not in flask.session:
        return redirect(url_for('show_index'))
    logname = flask.session['username']

    connection = model.get_db()
    cur = connection.execute(
        "SELECT username, fullname, email, filename FROM users "
        "WHERE username = ?",
        (logname, )
    )
    user = cur.fetchall()
    context = {"user": user[0], "logname": logname}
    return render_template("/accounts/edit.html", **context)


@insta485.app.route('/accounts/password/')
def password():
    """Pass pydocstyle."""
    if "username" not in flask.session:
        return flask.redirect(flask.url_for("login_post"))

    logname = flask.session['username']

    context = {"logname": logname}
    return render_template("/accounts/password.html", **context)


@insta485.app.route('/accounts/login/', methods=['GET'])
def login_post():
    """Pass pydocstyle."""
    # Redirect to home page if already logged in
    if "username" in flask.session:
        return flask.redirect(flask.url_for("show_index"))
    return flask.render_template("accounts/login.html", )


@insta485.app.route('/likes/', methods=["POST"])
def likes_redirect():
    """Pass pydocstyle."""
    if "username" not in flask.session:
        return flask.redirect(flask.url_for("login_post"))

    target = flask.request.args.get('target')
    logname = flask.session['username']
    operation = flask.request.form['operation']
    postid = flask.request.form['postid']

    # Connect & query to database
    connection = insta485.model.get_db()

    cur = connection.execute(
        "SELECT EXISTS("
        "SELECT 1 FROM likes "
        "WHERE postid = ? AND owner = ? )",
        (postid, logname)
    )
    like = cur.fetchall()[0]['EXISTS(SELECT 1 FROM likes '
                             'WHERE postid = ? AND owner = ? )']

    if operation == "like":
        if like == 1:
            flask.abort(409)

        cur = connection.execute(
            "INSERT INTO likes(owner, postid) "
            "VALUES (?, ?)",
            (logname, postid)
        )

    elif operation == "unlike":
        if like == 0:
            flask.abort(409)

        cur = connection.execute(
            "DELETE FROM likes "
            "WHERE owner = ? AND postid = ?",
            (logname, postid)
        )

    if target is None:
        return flask.redirect(flask.url_for("show_index"))
    return flask.redirect(target)


@insta485.app.route('/comments/', methods=["POST"])
def comments_redirect():
    """Pass pydocstyle."""
    if "username" not in flask.session:
        return flask.redirect(flask.url_for("login_post"))

    target = flask.request.args.get('target')
    logname = flask.session['username']
    operation = flask.request.form['operation']

    # Connect & query to database
    connection = insta485.model.get_db()

    if operation == "create":
        text = flask.request.form['text']
        if text is None:
            flask.abort(400)
        postid = flask.request.form['postid']
        connection.execute(
            "INSERT INTO comments(owner, postid, text) "
            "VALUES (?, ?, ?)",
            (logname, postid, text)
        )

    elif operation == "delete":
        commentid = flask.request.form['commentid']
        cur = connection.execute(
            "SELECT * FROM comments "
            "WHERE commentid = ?",
            (commentid)
        )
        temp = cur.fetchall()
        if temp[0]['owner'] != logname:
            flask.abort(403)

        connection.execute(
            "DELETE FROM comments "
            "WHERE commentid = ?",
            (commentid)
        )

    if target is None:
        return flask.redirect(flask.url_for("show_index"))
    return flask.redirect(target)


@insta485.app.route('/posts/', methods=['POST'])
def posts_redirect():
    """Pass pydocstyle."""
    if "username" not in flask.session:
        return flask.redirect(flask.url_for("login_post"))
    # might need to work on error checking file
    logname = flask.session['username']
    operation = flask.request.form['operation']
    connection = model.get_db()
    if operation == 'create':
        fileobj = flask.request.files["file"]
        # Error: user tries to create post w empty file
        if fileobj is None:
            flask.abort(400)
        filename = fileobj.filename
        stem = uuid.uuid4().hex
        suffix = pathlib.Path(filename).suffix.lower()
        uuid_basename = f"{stem}{suffix}"
        path = insta485.app.config["UPLOAD_FOLDER"]/uuid_basename
        fileobj.save(path)

        connection.execute(
            "INSERT INTO posts(filename, owner)"
            "VALUES (?, ?)",
            (uuid_basename, logname)
        )

    # delete post
    elif operation == 'delete':
        postid = flask.request.form['postid']
        cur = connection.execute(
            "SELECT owner, filename FROM posts "
            "WHERE postid = ?",
            (postid, ))
        post = cur.fetchall()[0]
        owner = post["owner"]
        # Error: tries to delete post that logname does not own
        if owner != logname:
            flask.abort(403)

        path = post['filename']
        path = insta485.app.config["UPLOAD_FOLDER"]/path
        file = pathlib.Path(path)
        connection.execute(
            "DELETE FROM posts "
            "WHERE postid = ?",
            (postid, )
        )
        file.unlink()

    target = flask.request.args.get('target')
    if target is None:
        target = "/users/" + logname + "/"
    return flask.redirect(target)


@insta485.app.route('/following/', methods=['POST'])
def following_redirect():
    """Pass pydocstyle."""
    if "username" not in flask.session:
        return flask.redirect(flask.url_for("login_post"))

    logname = flask.session['username']
    username = flask.request.form['username']
    operation = flask.request.form['operation']

    connection = model.get_db()
    cur = connection.execute(
        "SELECT EXISTS("
        "SELECT 1 from following "
        "WHERE username1 = ? AND username2 = ?)",
        (logname, username)
    )
    reln = cur.fetchall()[0]
    reln = reln['EXISTS(SELECT 1 from following '
                'WHERE username1 = ? AND username2 = ?)']

    if operation == 'follow':
        if reln == 1:
            flask.abort(409)
        connection.execute(
            "INSERT INTO following(username1, username2) "
            "VALUES(?, ?)",
            (logname, username)
        )

    elif operation == 'unfollow':
        if reln == 0:
            flask.abort(409)

        connection.execute(
            "DELETE FROM following "
            "WHERE username1 = ? AND username2 = ?",
            (logname, username)
        )

    target = flask.request.args.get('target')
    if target is None:
        return flask.redirect(flask.url_for("show_index"))
    return flask.redirect(target)


@insta485.app.route('/accounts/', methods=['POST'])
def accounts_redirect():
    """Pass pydocstyle."""
    operation = flask.request.form['operation']
    connection = insta485.model.get_db()

    if operation == "create":
        accounts_create(connection)

    elif operation == "delete":
        accounts_delete(connection)

    # login
    elif operation == "login":
        accounts_login(connection)
    # edit account
    elif operation == "edit_account":
        accounts_edit(connection)

    # update pass
    elif operation == "update_password":
        accounts_password(connection)

    target = flask.request.args.get('target')
    if target is None:
        return flask.redirect(flask.url_for("show_index"))
    return flask.redirect(target)


def accounts_create(connection):
    """Pass pydocstyle."""
    name = flask.request.form.get("fullname")
    username = flask.request.form.get("username")
    passwor = flask.request.form.get("password")
    enc_pass = encrypt_pass(passwor)
    email = flask.request.form.get("email")

    # Handling the inputted image
    fileobj = flask.request.files["file"]

    # Error handling
    if (name is None or username is None or passwor is None
       or email is None or fileobj is None):
        flask.abort(400)

    filename = fileobj.filename
    stem = uuid.uuid4().hex
    suffix = pathlib.Path(filename).suffix.lower()
    uuid_basename = f"{stem}{suffix}"
    path = insta485.app.config["UPLOAD_FOLDER"]/uuid_basename
    fileobj.save(path)

    cur = connection.execute(
        "SELECT EXISTS("
        "SELECT 1 FROM users "
        "WHERE username = ? )",
        (username, )
    )
    existing_user = cur.fetchall()
    # If the user already exists
    if existing_user[0]['EXISTS(SELECT 1 FROM users '
                        'WHERE username = ? )'] != 0:
        flask.abort(409)

    # Adding user to database
    cur = connection.execute(
        "INSERT INTO users "
        "(username, fullname, email, filename, password) "
        "VALUES (?, ?, ?, ?, ?) ",
        (username, name, email, uuid_basename, enc_pass))

    flask.session['username'] = username


def accounts_delete(connection):
    """Pass pydocstyle."""
    if "username" not in flask.session:
        flask.abort(403)
    logname = flask.session["username"]

    # need to delete user's saved files too
    connection = insta485.model.get_db()

    cur = connection.execute(
        "SELECT filename FROM posts "
        "WHERE owner = ?",
        (logname, )
    )
    filenames = cur.fetchall()

    for i in filenames:
        path = i["filename"]
        path = insta485.app.config["UPLOAD_FOLDER"]/path
        file = pathlib.Path(path)
        file.unlink()

    # Delete profile picture
    cur = connection.execute(
        "SELECT filename FROM users "
        "WHERE username = ?",
        (logname, )
    )

    profile_pic = cur.fetchall()
    profile_pic = profile_pic[0]["filename"]
    path = insta485.app.config["UPLOAD_FOLDER"]/profile_pic
    profile = pathlib.Path(path)
    profile.unlink()

    connection.execute(
        "DELETE FROM users "
        "WHERE username = ?",
        (logname, )
    )

    flask.session.clear()


def accounts_login(connection):
    """Pass pydocstyle."""
    username = flask.request.form.get("username")
    passwo = flask.request.form.get("password")

    # if username or password fields are blank
    if username is None or passwo is None:
        flask.abort(400)

    # Connect & query to database
    cur = connection.execute(
        "SELECT password "
        "FROM users "
        "WHERE username == ?",
        (username, ))
    users = cur.fetchall()

    if len(users) == 0:
        flask.abort(403)

    db_pass = users[0]["password"]
    encrypted_pass = encrypt_pass_with_salt(db_pass, passwo)
    if encrypted_pass != db_pass:
        flask.abort(403)  # if passwords do not match
    flask.session['username'] = username
    return flask.redirect(flask.url_for("show_index"))


def accounts_edit(connection):
    """Pass pydocstyle."""
    if "username" not in flask.session:
        flask.abort(403)
    logname = flask.session["username"]
    fullname = flask.request.form.get("fullname")
    email = flask.request.form.get("email")
    if fullname is None or email is None:
        flask.abort(400)

    fileobj = flask.request.files["file"]
    if fileobj is not None:         # if user wants to update profile pic
        filename = fileobj.filename
        stem = uuid.uuid4().hex
        suffix = pathlib.Path(filename).suffix.lower()
        uuid_basename = f"{stem}{suffix}"
        path = insta485.app.config["UPLOAD_FOLDER"]/uuid_basename
        fileobj.save(path)  # saving new profile img to filesystem

        cur = connection.execute(
            "SELECT filename FROM users "
            "WHERE username = ?",
            (logname, )
        )
        profile_pic = cur.fetchall()[0]["filename"]
        path = insta485.app.config["UPLOAD_FOLDER"]/profile_pic
        file = pathlib.Path(path)
        cur = connection.execute(
            "UPDATE users "
            "SET filename = ?"
            "WHERE username = ?",
            (uuid_basename, logname)
        )
        file.unlink()

    # update email/fullname
    cur = connection.execute(
        "UPDATE users "
        "SET email = ?, fullname = ? "
        "WHERE username = ?",
        (email, fullname, logname)
    )


def accounts_password(connection):
    """Pass pydocstyle."""
    if "username" not in flask.session:
        flask.abort(403)
    logname = flask.session["username"]
    old_pass = flask.request.form.get("password")
    new_pass1 = flask.request.form.get("new_password1")
    new_pass2 = flask.request.form.get("new_password2")
    if old_pass is None or new_pass1 is None or new_pass2 is None:
        flask.abort(400)
    if new_pass1 != new_pass2:
        flask.abort(401)
    cur = connection.execute(
        "SELECT password FROM users "
        "WHERE username = ?",
        (logname, )
    )
    db_pass = cur.fetchall()[0]["password"]
    if db_pass != encrypt_pass_with_salt(db_pass, old_pass):
        flask.abort(403)

    cur = connection.execute(
        "UPDATE users "
        "SET password = ? "
        "WHERE username = ?",
        (encrypt_pass(new_pass1), logname)
    )


def encrypt_pass(passw):
    """Pass pydocstyle."""
    algorithm = 'sha512'
    salt = uuid.uuid4().hex
    hash_obj = hashlib.new(algorithm)
    password_salted = salt + passw
    hash_obj.update(password_salted.encode('utf-8'))
    password_hash = hash_obj.hexdigest()
    password_db_string = "$".join([algorithm, salt, password_hash])
    encrypt_pw = password_db_string
    return encrypt_pw


def encrypt_pass_with_salt(db_password, input_pass):
    """Pass pydocstyle."""
    algorithm = 'sha512'
    salt = db_password.split('$')[1]
    hash_obj = hashlib.new(algorithm)
    password_salted = salt + input_pass
    hash_obj.update(password_salted.encode('utf-8'))
    password_hash = hash_obj.hexdigest()
    password_db_string = "$".join([algorithm, salt, password_hash])
    encrypt_pw = password_db_string
    return encrypt_pw


@insta485.app.route('/uploads/<path:filename>')
def download_file(filename):
    """Pass pydocstyle."""
    if "username" not in flask.session:
        flask.abort(403)

    return flask.send_from_directory(insta485.app.config['UPLOAD_FOLDER'],
                                     filename, as_attachment=False)


def target_url(target):
    """Pass pydocstyle."""
    if target is None:
        return flask.redirect(flask.url_for("show_index"))
    return flask.redirect(target)
