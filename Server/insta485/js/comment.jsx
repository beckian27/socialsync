import React, { useState } from "react";
import PropTypes from "prop-types";

export default function Comment({ cmts, setComments, postID }) {
  const [answer, setAnswer] = useState("");
  const [, setError] = useState(null);
  const [status, setStatus] = useState("typing");

  function handleDeleteComment(url) {
    fetch(url, { method: "DELETE", credentials: "same-origin" });
    cmts.forEach((comment) => {
      if (url === comment.url) {
        cmts.splice(cmts.indexOf(comment), 1);
        setComments(cmts);
      } // if
    }); // forEach
    setStatus("success");
  } // handleDeleteComment()

  function renderComments() {
    return (
      <div>
        {cmts.map((comment) => (
          <div key={comment.commentid}>
            <div>
              <a href={`/users/${comment.owner}/`}>
                <b> {comment.owner}: </b>
              </a>
              <span className="comment-text"> {comment.text} </span>
              {comment.lognameOwnsThis ? (
                <button
                  type="submit"
                  className="delete-comment-button"
                  onClick={() => handleDeleteComment(comment.url)}
                >
                  {" "}
                  Delete Comment{" "}
                </button>
              ) : (
                <b />
              )}
            </div>
          </div>
        ))}
      </div>
    );
  } // renderComments()

  async function handleNewComment(e) {
    e.preventDefault();
    setStatus("submitting");
    try {
      setStatus("success");
    } catch (err) {
      setStatus("typing");
      setError(err);
    } // catch
  } // handleNewComment()

  function handleTextareaChange(e) {
    setAnswer(e.target.value);
  } // handleTextareaChange()

  function handleKeyDown(e) {
    if (e.key === "Enter") {
      e.preventDefault();
      fetch(`/api/v1/comments/?postid=${postID}`, {
        method: "POST",
        headers: {
          Accept: "application/json",
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ text: answer }),
        credentials: "same-origin",
      })
        .then((response) => {
          if (!response.ok) throw Error(response.statusText);
          return response.json();
        })
        .then((data) => {
          setComments([...cmts, data]);
        });
      setAnswer("");
      setStatus("success");
    } // if
  } // handleKeyDown()

  // render new comment if its made
  if (status === "success") {
    setStatus("typing");
    return (
      <div>
        <div>{renderComments}</div>
        <form id="new_comment" onSubmit={handleNewComment}>
          <textarea
            value={answer}
            onChange={handleTextareaChange}
            disabled={status === "submitting"}
            placeholder="Add comment..."
            onKeyDown={handleKeyDown}
          />
        </form>
      </div>
    );
  } // if

  return (
    <div key="commentlol">
      <div>{renderComments(cmts)}</div>
      <form className="comment-form" onSubmit={handleNewComment}>
        <input
          type="text"
          value={answer}
          onChange={handleTextareaChange}
          disabled={status === "submitting"}
          placeholder="Add comment..."
          onKeyDown={handleKeyDown}
        />
      </form>
    </div>
  );
}

Comment.propTypes = {
  cmts: PropTypes.arrayOf(PropTypes.shape).isRequired,
  setComments: PropTypes.func.isRequired,
  postID: PropTypes.string.isRequired,
};
