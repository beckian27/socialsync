import React, { useState, useEffect } from "react";
import InfiniteScroll from "react-infinite-scroll-component";
import Post from "./post";

export default function Feed() {
  const [next, setNext] = useState("/api/v1/posts/");
  const [posts, setPosts] = useState([]);
  const [flag, setFlag] = useState(false);
  const [finalRender, setFinalRender] = useState(true);

  useEffect(() => {
    let ignoreStaleRequest = false;
    fetch(next, { credentials: "same-origin" })
      .then((response) => response.json())
      .then((data) => {
        if (!ignoreStaleRequest) {
          setNext(data.next);
          if (data.next === "") {
            setFlag(false);
          }
          data.results.forEach((url) => {
            setPosts((prev) => [
              ...prev,
              <div key={url.url}>
                <Post url={url.url} />
              </div>,
            ]);
          }); // forEach
        } // if
      })
      .catch(() => setFinalRender(false)); // fetch

    return () => {
      // This is a cleanup function that runs whenever the Post component
      // unmounts or re-renders. If a Post is about to unmount or re-render, we
      // should avoid updating state.
      ignoreStaleRequest = true;
    };
  }, [flag, next]); // useEffect()

  // function reRender(){
  //     setFlag(!flag)
  //

  return (
    <div id="feed">
      <div>{posts}</div>
      <InfiniteScroll
        dataLength={10} // This is important field to render the next data
        next={() => {
          setFlag(!flag);
        }}
        hasMore={next !== "" || finalRender}
        loader={<h4>Loading...</h4>}
        endMessage={
          <p style={{ textAlign: "center" }}>
            <b>All done!</b>
          </p>
        }
      />
    </div>
  );
}
