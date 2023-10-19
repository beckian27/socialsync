import React from "react";
import PropTypes from "prop-types";

export default function LikeButton({ likes, setLikes, imgUrl, postID }) {
  let { lognameLikesThis, numLikes, url } = likes;

  function doubleClickLike(e) {
    if (!likes.lognameLikesThis) {
      e.preventDefault();
      fetch(`/api/v1/likes/?postid=${postID}`, {
        method: "POST",
        credentials: "same-origin",
      })
        .then((response) => {
          if (!response.ok) throw Error(response.statusText);
          return response.json();
        })
        .then((data) => {
          setLikes({ numLikes, url: data.url, lognameLikesThis });
        });
      numLikes += 1;
      lognameLikesThis = true;
    } // if
  } // doubleClickLike()

  function onLike() {
    // DELETE
    if (likes.lognameLikesThis) {
      fetch(url, { credentials: "same-origin", method: "DELETE" });
      numLikes -= 1;
      url = null;
    } // if

    // POST
    else {
      fetch(`/api/v1/likes/?postid=${postID}`, {
        method: "POST",
        credentials: "same-origin",
      })
        .then((response) => {
          if (!response.ok) throw Error(response.statusText);
          return response.json();
        })
        .then((data) => {
          setLikes({ numLikes, url: data.url, lognameLikesThis });
        });
      if (numLikes === undefined) {
        numLikes = 0;
      }
      numLikes += 1;
    } // else
    lognameLikesThis = !lognameLikesThis;
    setLikes({
      lognameLikesThis,
      numLikes,
      url,
    });
  } // onLike()

  return (
    <div>
      <img onDoubleClick={doubleClickLike} src={imgUrl} alt="post_image" />
      <br />
      {likes.numLikes} {likes.numLikes === 1 ? "like" : "likes"} <br />
      <button type="submit" className="like-unlike-button" onClick={onLike}>
        {likes.lognameLikesThis ? "unlike" : "like"}
      </button>
    </div>
  );
}

LikeButton.propTypes = {
  likes: PropTypes.shape({
    lognameLikesThis: PropTypes.bool.isRequired,
    numLikes: PropTypes.number.isRequired,
    url: PropTypes.string,
  }).isRequired,
  setLikes: PropTypes.func.isRequired,
  imgUrl: PropTypes.string.isRequired,
  postID: PropTypes.string.isRequired,
};
