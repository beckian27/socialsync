import React from "react";
import { createRoot } from "react-dom/client";
import Feed from "./feed";

const root = createRoot(document.getElementById("reactEntry"));

// Create a root
// This method is only called once
// Insert the post component into the DOM
root.render(<Feed />);
