import React, { useState, useEffect } from "react";
import PropTypes from "prop-types";
import LikeButton from "./like";
import Comment from "./comment";
import Timestamp from "./timestamp";

// The parameter of this function is an object with a string called url inside it.
// url is a prop for the Post component.
export default function Post({ url }) {
  /* Display image and post owner of a single post */

  const [imgUrl, setImgUrl] = useState("");
  const [owner, setOwner] = useState("");
  const [likes, setLikes] = useState({});
  const [timestamp, setTimestamp] = useState("");
  const [comments, setComments] = useState([]);
  const [ownerImgUrl, setownerImg] = useState("");
  const [pizza, setPizza] = useState(false);

  function getPostID() {
    return url.split("/")[4];
  } // getPostID

  useEffect(() => {
    // Declare a boolean flag that we can use to cancel the API request.
    let ignoreStaleRequest = false;

    // Call REST API to get the post's information
    fetch(url, { credentials: "same-origin" })
      .then((response) => {
        if (!response.ok) throw Error(response.statusText);
        return response.json();
      })
      .then((data) => {
        // If ignoreStaleRequest was set to true, we want to ignore the results of the
        // the request. Otherwise, update the state to trigger a new render.
        if (!ignoreStaleRequest) {
          setImgUrl(data.imgUrl);
          setOwner(data.owner);
          setownerImg(data.ownerImgUrl);
          setLikes(data.likes);
          setTimestamp(data.created);
          setComments(data.comments);
          setPizza(true);
        }
      })
      .catch((error) => console.log(error));

    return () => {
      // This is a cleanup function that runs whenever the Post component
      // unmounts or re-renders. If a Post is about to unmount or re-render, we
      // should avoid updating state.
      ignoreStaleRequest = true;
    };
  }, [url]);

  // Render post image and post owner
  if (pizza) {
    return (
      <div className="post">
        <img src={ownerImgUrl} alt="" />
        <a href={`/users/${owner}/`}> {owner} </a>
        <Timestamp ts={timestamp} url={getPostID()} />
        <LikeButton
          likes={likes}
          setLikes={setLikes}
          imgUrl={imgUrl}
          postID={getPostID()}
        />
        <Comment
          cmts={comments}
          setComments={setComments}
          postID={getPostID()}
        />
      </div>
    );
  }

  return <div className="post"> loading</div>;
}

Post.propTypes = {
  url: PropTypes.string.isRequired,
};
