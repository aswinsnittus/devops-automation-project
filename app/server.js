const express = require("express");
const path = require("path");
const app = express();
const PORT = process.env.PORT || 8080;

app.use(express.static(path.join(__dirname, "public")));
app.get("/api/health", (req, res) => res.json({ status: "ok" }));
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));