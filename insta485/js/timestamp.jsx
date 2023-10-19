import React from "react";
import moment from "moment";
import PropTypes from "prop-types";

export default function Timestamp({ ts, url }) {
  function setTimestamp(timestamp) {
    return moment(timestamp).fromNow();
  } // setTimestamp()

  function getHREF() {
    return `/posts/${url}/`;
  }

  return <a href={getHREF()}>{setTimestamp(ts)}</a>;
} // Timestamp()

Timestamp.propTypes = {
  ts: PropTypes.string.isRequired,
  url: PropTypes.string.isRequired,
};
