# Forge Course: Backend (Node.js, Express, Data, Auth, API)

*Assumes JavaScript fundamentals are already known.*

## Module 1 — Getting Started with Node.js

### Lesson 1.1 — What a server is
**Concept:** When you visit a website, your browser (the "client") sends a request to a computer somewhere else (the "server"), which sends back a response — usually a webpage or data. A server is just a program that listens for requests and responds.

**Check-in:** What is a server's basic job?
- A) Display webpages directly on your screen
- B) Listen for requests and send back responses ✓
- C) Store your browser history
- D) Style webpages

**Common mistake:** Thinking "server" means a physical machine only — in practice it usually just means a running program, even on a regular computer.

### Lesson 1.2 — Why JavaScript can run outside the browser
**Concept:** Node.js is a way to run JavaScript *outside* a browser — directly on a computer or server. This is what lets JavaScript build servers, not just interactive webpages.

**Check-in:** What does Node.js let you do?
- A) Run JavaScript in the browser only
- B) Run JavaScript outside the browser, e.g. on a server ✓
- C) Write CSS faster
- D) Replace HTML

**Common mistake:** Assuming Node.js is a different language from JavaScript — it's the same JavaScript you already know, just running in a different environment.

### Lesson 1.3 — Running your first Node script
**Concept:** A Node script is just a `.js` file run directly on your computer instead of in a browser.

**Code example:**
```js
// hello.js
console.log("Hello from Node");
```
Run it with: `node hello.js`

**Try it:** Create a Node script that logs your name and the current module number.

**Check-in:** How do you run a Node script called `app.js` from the terminal?
- A) `run app.js`
- B) `node app.js` ✓
- C) `open app.js`
- D) `js app.js`

**Common mistake:** Trying to use browser-only things like `document` or `window` in a Node script — Node doesn't have a webpage to work with, so these don't exist there.

**Assignment 1:** Write a Node script that defines a few variables about yourself and logs a formatted introduction — same idea as the JavaScript course's first assignment, but run with `node` instead of a browser console. Pass criteria: runs without errors from the terminal.

---

## Module 2 — Express Basics

### Lesson 2.1 — What Express is and why
**Concept:** Writing a raw Node server involves a lot of manual, repetitive setup. Express is a tool (a "framework") that makes building a server dramatically simpler — handling requests, routes, and responses with much less code.

**Check-in:** Why do developers commonly use Express instead of raw Node for servers?
- A) It's required, raw Node can't make servers
- B) It removes a lot of repetitive manual setup ✓
- C) It replaces JavaScript
- D) It's only for small projects

**Common mistake:** Thinking Express is a completely separate thing from Node — Express is built *on top of* Node, not instead of it.

### Lesson 2.2 — Setting up a basic Express server
**Concept:** A basic Express server listens on a port and responds to requests.

**Code example:**
```js
const express = require("express");
const app = express();

app.get("/", (req, res) => {
  res.send("Hello from Express");
});

app.listen(3000, () => {
  console.log("Server running on port 3000");
});
```

**Try it:** Change the message and the port number, then restart and check it works.

**Check-in:** What does `app.listen(3000, ...)` do?
- A) Sends a message
- B) Starts the server listening for requests on port 3000 ✓
- C) Deletes the server
- D) Connects to a database

**Common mistake:** Forgetting to restart the server after changing code — unlike a browser refreshing a page, a running Node server doesn't automatically pick up file changes unless you use a tool for that (like nodemon).

### Lesson 2.3 — Routes, requests, and responses
**Concept:** A route defines what happens for a specific URL path and HTTP method (like GET or POST). `req` holds info about the incoming request; `res` is how you respond.

**Code example:**
```js
app.get("/about", (req, res) => {
  res.send("This is the about page");
});

app.post("/submit", (req, res) => {
  res.send("Form received");
});
```

**Try it:** Add a new GET route for `/contact` that sends back a simple message.

**Check-in:** What's the difference between `app.get()` and `app.post()`?
- A) No difference
- B) They handle different types of requests (retrieving vs. submitting data) ✓
- C) `post` is faster
- D) `get` only works locally

**Common mistake:** Defining two routes for the exact same path and method — only the first one Express finds will actually run; the second is silently ignored.

**Assignment 2:** Build an Express server with at least 3 different GET routes, each returning a different message. Pass criteria: server starts without errors, all 3 routes respond correctly when visited.

---

## Module 3 — Working with Data

### Lesson 3.1 — What a database is
**Concept:** A database stores data permanently, so it survives even after your server restarts — unlike variables in your code, which reset every time. Think of it as a very organized, searchable filing cabinet.

**Check-in:** Why can't you just store data in a regular JavaScript variable on the server?
- A) You can, and it works fine forever
- B) Variables reset when the server restarts, losing the data ✓
- C) Variables are too slow
- D) Variables can't hold text

**Common mistake:** Storing important data only in memory (a variable) during development and being surprised it's gone after a restart — this is exactly why databases exist.

### Lesson 3.2 — Basic Supabase/Postgres setup and connection
**Concept:** Supabase gives you a real Postgres database with an easy-to-use client library, so your Express server can read and write data without managing a database server yourself.

**Code example:**
```js
const { createClient } = require("@supabase/supabase-js");
const supabase = createClient(process.env.SUPABASE_URL, process.env.SUPABASE_KEY);
```

**Try it:** Set up a Supabase project and connect to it from a Node script (just the connection, no queries yet).

**Check-in:** Why are the Supabase URL and key stored in environment variables instead of typed directly in the code?
- A) It's just a style preference
- B) Keeps sensitive credentials out of code that might be shared or committed ✓
- C) It makes the code run faster
- D) Environment variables are required by Express

**Common mistake:** Committing real database credentials directly into code that gets shared or pushed to GitHub — always use environment variables for secrets.

### Lesson 3.3 — Basic CRUD from an Express route
**Concept:** CRUD = Create, Read, Update, Delete — the four basic things you do with stored data.

**Code example:**
```js
app.get("/students", async (req, res) => {
  const { data, error } = await supabase.from("students").select("*");
  res.json(data);
});

app.post("/students", async (req, res) => {
  const { data, error } = await supabase.from("students").insert(req.body);
  res.json(data);
});
```

**Try it:** Add a route that deletes a student by ID.

**Check-in:** Which CRUD operation does `supabase.from("students").select("*")` perform?
- A) Create
- B) Read ✓
- C) Update
- D) Delete

**Common mistake:** Forgetting `async`/`await` when calling Supabase — database calls take time, and without awaiting them, your code moves on before the data actually arrives.

**Assignment 3:** Build Express routes for full CRUD on a simple table (e.g. "notes": get all, create one, update one, delete one). Pass criteria: all four operations work correctly against a real Supabase table.

---

## Module 4 — Authentication Basics

### Lesson 4.1 — What authentication is and why it matters
**Concept:** Authentication answers "who is this user?" — without it, anyone could access or change anyone else's data. It's different from authorization, which answers "what is this user allowed to do?"

**Check-in:** What question does authentication answer?
- A) What is this user allowed to do?
- B) Who is this user? ✓
- C) How fast is the server?
- D) What database is being used?

**Common mistake:** Confusing authentication (who you are) with authorization (what you're allowed to do) — they're related but different problems.

### Lesson 4.2 — A simple login flow, conceptually
**Concept:** A basic login flow: the user submits an email/password → the server checks it against stored data → if it matches, the server gives back some proof (like a token) the user includes in future requests to prove who they are.

**Check-in:** After a successful login, what does the server typically give back to the user?
- A) The database password
- B) A token proving who they are for future requests ✓
- C) Nothing, login is a one-time check
- D) The full user table

**Common mistake:** Thinking login only matters once — without a token or session, the server would have to ask for the password again on every single request.

### Lesson 4.3 — Storing and checking a password securely
**Concept:** Never store a plain password in the database — always store a *hashed* version (scrambled in a one-way way), and compare hashes when checking a login attempt.

**Code example:**
```js
const bcrypt = require("bcrypt");

const hashed = await bcrypt.hash(plainPassword, 10);
// later, when checking login:
const matches = await bcrypt.compare(attemptedPassword, hashed);
```

**Try it:** Hash a test password and confirm `bcrypt.compare` correctly returns true for the right password and false for a wrong one.

**Check-in:** Why is a password hashed instead of stored as plain text?
- A) It makes login faster
- B) So even if the database is exposed, the real password isn't directly readable ✓
- C) It's required by Express
- D) It makes the password shorter

**Common mistake:** Storing plain-text passwords "just for now during development" — this habit is exactly how real breaches happen; always hash from day one.

**Assignment 4:** Build a signup route that hashes and stores a password, and a login route that checks a submitted password against the stored hash. Pass criteria: correct passwords succeed, incorrect ones are rejected, password is never stored in plain text.

---

## Module 5 — Building a Small API (Capstone)

### Lesson 5.1 — Putting it all together
**Concept:** A real API combines everything from this course: routes (Module 2), a real database (Module 3), and protected routes that require login (Module 4).

**Code example:**
```js
app.get("/my-notes", requireAuth, async (req, res) => {
  const { data } = await supabase
    .from("notes")
    .select("*")
    .eq("user_id", req.user.id);
  res.json(data);
});
```
This route only works if `requireAuth` confirms the user is logged in — a "protected route."

**Try it:** Sketch out which routes your API needs and which ones should require login.

**Check-in:** What makes a route "protected"?
- A) It has a longer URL
- B) It checks the user is authenticated before running ✓
- C) It's written in a separate file
- D) It uses GET instead of POST

**Common mistake:** Forgetting to protect a route that should require login — always double-check which routes handle sensitive or user-specific data.

### Lesson 5.2 — Testing your API with a client
**Concept:** You can test API routes without building a frontend yet — using the browser (for GET routes), or a tool like curl or Postman (for any method, including POST/PUT/DELETE).

**Code example:**
```bash
curl -X POST http://localhost:3000/students \
  -H "Content-Type: application/json" \
  -d '{"name": "Ada"}'
```

**Try it:** Test one of your GET routes in the browser, and one of your POST routes with curl or Postman.

**Check-in:** Why test an API with curl/Postman instead of only a browser?
- A) Browsers can't send any requests at all
- B) Browsers can't easily send POST/PUT/DELETE requests with a body the way these tools can ✓
- C) It's required by Express
- D) It's faster to build a whole frontend first

**Common mistake:** Only ever testing the "happy path" (correct input) — also test what happens with missing fields or bad data, since real users will eventually send both.

**Capstone Assignment — Small working REST API:** Build a complete small API with: at least one public route, at least one protected route (requires login), full CRUD on one resource backed by a real Supabase table, and password hashing for signup/login. Test every route with curl or Postman and document what each one does. Pass criteria: all routes work correctly, protected routes correctly reject requests without valid login, passwords are hashed. This is the assignment that unlocks this track's certificate.

---

## Module 6 — Rounding Out the Backend

### Lesson 6.1 — Middleware
**Concept:** Middleware is a function that runs *between* a request arriving and your route handling it — useful for things like logging, checking authentication, or parsing data, without repeating that logic in every route.

**Code example:**
```js
function logger(req, res, next) {
  console.log(`${req.method} ${req.url}`);
  next();
}
app.use(logger);
```

**Try it:** Write a middleware that logs the current time on every request.

**Check-in:** What does calling `next()` inside a middleware do?
- A) Ends the request with no response
- B) Passes control to the next middleware or route handler ✓
- C) Restarts the server
- D) Deletes the request

**Common mistake:** Forgetting to call `next()` inside a middleware — the request hangs forever, since nothing tells Express to continue to the next step.

### Lesson 6.2 — Environment variables and config in depth
**Concept:** Beyond just database keys, real apps typically store all environment-specific settings (API keys, ports, feature flags) in environment variables loaded from a `.env` file — kept out of version control.

**Code example:**
```js
require("dotenv").config();
const port = process.env.PORT || 3000;
```
`.env` file (never committed to GitHub):
```
PORT=3000
SUPABASE_URL=your-url-here
```

**Try it:** Move a hardcoded value in your project into a `.env` file and read it with `process.env`.

**Check-in:** Why should a `.env` file be excluded from GitHub (via `.gitignore`)?
- A) It's not important
- B) It typically contains secrets that shouldn't be public ✓
- C) GitHub doesn't allow .env files
- D) It makes the app slower

**Common mistake:** Committing a `.env` file to a public GitHub repo — this exposes real secrets; always add `.env` to `.gitignore`.

### Lesson 6.3 — Centralized error handling
**Concept:** Instead of repeating error-handling code in every route, Express lets you define one central error-handling middleware that catches errors from anywhere in the app.

**Code example:**
```js
app.use((err, req, res, next) => {
  console.error(err);
  res.status(500).json({ error: "Something went wrong" });
});
```

**Try it:** Trigger an intentional error in a route and confirm the central handler catches it.

**Check-in:** What's different about an error-handling middleware's function signature?
- A) Nothing, it's the same as regular middleware
- B) It takes 4 arguments instead of 3, starting with the error ✓
- C) It must be async
- D) It can't use `res`

**Common mistake:** Putting the error-handling middleware anywhere other than *last*, after all other routes — Express matches middleware in order, so it must come after everything else to catch errors from them.

### Lesson 6.4 — Input validation
**Concept:** Never trust data coming from a request — validate it before using it (checking required fields exist, checking types, etc.), to avoid crashes or bad data getting saved.

**Code example:**
```js
app.post("/students", (req, res) => {
  const { name } = req.body;
  if (!name || typeof name !== "string") {
    return res.status(400).json({ error: "A valid name is required" });
  }
  // proceed knowing name is valid
});
```

**Try it:** Add validation to one of your Module 3 CRUD routes, checking a required field exists before proceeding.

**Check-in:** What status code is conventionally used for a bad/invalid request?
- A) 200
- B) 400 ✓
- C) 500
- D) 404

**Common mistake:** Trusting `req.body` fields exist without checking — accessing a property that's missing doesn't crash immediately in JS, but using it further down (like calling `.toUpperCase()` on `undefined`) will.

### Lesson 6.5 — CORS
**Concept:** CORS (Cross-Origin Resource Sharing) is a browser security rule that blocks a frontend on one domain from calling an API on a different domain, unless the API explicitly allows it.

**Code example:**
```js
const cors = require("cors");
app.use(cors());
```

**Try it:** Add the `cors` middleware to your Express app and confirm a frontend on a different port can now successfully call it.

**Check-in:** What problem does CORS middleware solve?
- A) It speeds up requests
- B) It allows a frontend on a different origin to call your API ✓
- C) It replaces authentication
- D) It's unrelated to APIs

**Common mistake:** Enabling `cors()` with no restrictions in a real production app — for anything sensitive, it's safer to explicitly allow only your actual frontend's domain rather than allowing all origins.

**Assignment 6:** Add a logging middleware, centralized error handling, input validation on at least 2 routes, and CORS support to your Module 5 capstone API. Pass criteria: all additions work correctly, invalid requests are properly rejected with clear error messages.

---

## Module 7 — Deploying Your Project (GitHub + Vercel)

### Lesson 7.1 — Pushing your project to GitHub
**Concept:** GitHub stores your code online and is what Vercel connects to for deployment.

**Try it — numbered steps:**
1. Create a free account at github.com
2. Create a new repository
3. From your project folder:
```bash
git init
git add .
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/your-username/your-repo.git
git push -u origin main
```
4. Make sure your `.env` file is listed in `.gitignore` before pushing — never commit real secrets

**Check-in:** What must be true before pushing a backend project to a public GitHub repo?
- A) Nothing special
- B) Sensitive files like `.env` must be excluded via `.gitignore` ✓
- C) The server must already be deployed
- D) All tests must pass first

**Common mistake:** Realizing secrets were committed *after* pushing — simply deleting the file afterward doesn't remove it from the repo's history; the secret should be rotated (changed) immediately if this happens.

### Lesson 7.2 — Deploying an Express API to Vercel
**Concept:** Vercel can host Node/Express backends as serverless functions, connected directly to your GitHub repo.

**Try it — numbered steps:**
1. Go to vercel.com, sign up with GitHub
2. Click "Add New Project," select your repository
3. In the project settings, add your environment variables (SUPABASE_URL, SUPABASE_KEY, etc.) directly in Vercel's dashboard — never in the code
4. Click "Deploy"
5. Test your live API routes using the URL Vercel gives you

**Check-in:** Where should real environment variable values go when deploying to Vercel?
- A) Directly in your code
- B) In Vercel's project settings/dashboard, not in the code ✓
- C) In a public GitHub file
- D) They're not needed once deployed

**Common mistake:** Forgetting to add environment variables in Vercel's dashboard — the deployed app will fail to connect to Supabase or anything else relying on them, even though it worked locally with a `.env` file.

**Assignment 7 (Capstone extension):** Deploy your finished API to Vercel with environment variables properly configured, and confirm your protected and public routes both work correctly on the live URL. Pass criteria: live API responds correctly, protected routes still require authentication, no secrets are exposed in the codebase.
