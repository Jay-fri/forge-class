-- Embeds courses/course-backend.md verbatim as the standalone Backend
-- track's full content, replacing the earlier self-authored 5-module/
-- 16-lesson content with the real course's own 7-module structure. Full
-- Stack already links this same track via bundle_tracks, so no separate
-- authoring is needed for that half of the mapping. Content preserved
-- as-written. Inserted as draft; published after structural verification
-- against the source file.


delete from public.modules m
using public.tracks t
where m.track_id = t.id and t.slug = 'backend';


insert into public.modules (track_id, name, slug, order_index)
select t.id, $md$Getting Started with Node.js$md$, 'getting-started-with-nodejs', 0
from public.tracks t where t.slug = 'backend'
on conflict (track_id, slug) do update set order_index = excluded.order_index, name = excluded.name;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$What a server is$md$, 'what-a-server-is', 0, true, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'getting-started-with-nodejs'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$When you visit a website, your browser (the "client") sends a request to a computer somewhere else (the "server"), which sends back a response — usually a webpage or data. A server is just a program that listens for requests and responds.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'getting-started-with-nodejs' and l.slug = 'what-a-server-is';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'getting-started-with-nodejs' and l.slug = 'what-a-server-is';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What is a server's basic job?$md$, $md$["Display webpages directly on your screen","Listen for requests and send back responses","Store your browser history","Style webpages"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'getting-started-with-nodejs' and l.slug = 'what-a-server-is' and s.order_index = 1;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Thinking "server" means a physical machine only — in practice it usually just means a running program, even on a regular computer.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'getting-started-with-nodejs' and l.slug = 'what-a-server-is';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Why JavaScript can run outside the browser$md$, 'why-javascript-can-run-outside-the-browser', 1, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'getting-started-with-nodejs'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Node.js is a way to run JavaScript *outside* a browser — directly on a computer or server. This is what lets JavaScript build servers, not just interactive webpages.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'getting-started-with-nodejs' and l.slug = 'why-javascript-can-run-outside-the-browser';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'getting-started-with-nodejs' and l.slug = 'why-javascript-can-run-outside-the-browser';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does Node.js let you do?$md$, $md$["Run JavaScript in the browser only","Run JavaScript outside the browser, e.g. on a server","Write CSS faster","Replace HTML"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'getting-started-with-nodejs' and l.slug = 'why-javascript-can-run-outside-the-browser' and s.order_index = 1;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Assuming Node.js is a different language from JavaScript — it's the same JavaScript you already know, just running in a different environment.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'getting-started-with-nodejs' and l.slug = 'why-javascript-can-run-outside-the-browser';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Running your first Node script$md$, 'running-your-first-node-script', 2, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'getting-started-with-nodejs'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$A Node script is just a `.js` file run directly on your computer instead of in a browser.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'getting-started-with-nodejs' and l.slug = 'running-your-first-node-script';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```js
// hello.js
console.log("Hello from Node");
```
Run it with: `node hello.js`$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'getting-started-with-nodejs' and l.slug = 'running-your-first-node-script';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Create a Node script that logs your name and the current module number.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'getting-started-with-nodejs' and l.slug = 'running-your-first-node-script';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'getting-started-with-nodejs' and l.slug = 'running-your-first-node-script';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$How do you run a Node script called app.js from the terminal?$md$, $md$["run app.js","node app.js","open app.js","js app.js"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'getting-started-with-nodejs' and l.slug = 'running-your-first-node-script' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Trying to use browser-only things like `document` or `window` in a Node script — Node doesn't have a webpage to work with, so these don't exist there.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'getting-started-with-nodejs' and l.slug = 'running-your-first-node-script';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Assignment 1$md$, $md$Write a Node script that defines a few variables about yourself and logs a formatted introduction — same idea as the JavaScript course's first assignment, but run with `node` instead of a browser console.

**Pass criteria:** runs without errors from the terminal.$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'getting-started-with-nodejs';


insert into public.modules (track_id, name, slug, order_index)
select t.id, $md$Express Basics$md$, 'express-basics', 1
from public.tracks t where t.slug = 'backend'
on conflict (track_id, slug) do update set order_index = excluded.order_index, name = excluded.name;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$What Express is and why$md$, 'what-express-is-and-why', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'express-basics'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Writing a raw Node server involves a lot of manual, repetitive setup. Express is a tool (a "framework") that makes building a server dramatically simpler — handling requests, routes, and responses with much less code.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'express-basics' and l.slug = 'what-express-is-and-why';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'express-basics' and l.slug = 'what-express-is-and-why';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$Why do developers commonly use Express instead of raw Node for servers?$md$, $md$["It's required, raw Node can't make servers","It removes a lot of repetitive manual setup","It replaces JavaScript","It's only for small projects"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'express-basics' and l.slug = 'what-express-is-and-why' and s.order_index = 1;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Thinking Express is a completely separate thing from Node — Express is built *on top of* Node, not instead of it.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'express-basics' and l.slug = 'what-express-is-and-why';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Setting up a basic Express server$md$, 'setting-up-a-basic-express-server', 1, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'express-basics'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$A basic Express server listens on a port and responds to requests.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'express-basics' and l.slug = 'setting-up-a-basic-express-server';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```js
const express = require("express");
const app = express();

app.get("/", (req, res) => {
  res.send("Hello from Express");
});

app.listen(3000, () => {
  console.log("Server running on port 3000");
});
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'express-basics' and l.slug = 'setting-up-a-basic-express-server';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Change the message and the port number, then restart and check it works.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'express-basics' and l.slug = 'setting-up-a-basic-express-server';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'express-basics' and l.slug = 'setting-up-a-basic-express-server';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does app.listen(3000, ...) do?$md$, $md$["Sends a message","Starts the server listening for requests on port 3000","Deletes the server","Connects to a database"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'express-basics' and l.slug = 'setting-up-a-basic-express-server' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Forgetting to restart the server after changing code — unlike a browser refreshing a page, a running Node server doesn't automatically pick up file changes unless you use a tool for that (like nodemon).$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'express-basics' and l.slug = 'setting-up-a-basic-express-server';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Routes, requests, and responses$md$, 'routes-requests-and-responses', 2, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'express-basics'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$A route defines what happens for a specific URL path and HTTP method (like GET or POST). `req` holds info about the incoming request; `res` is how you respond.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'express-basics' and l.slug = 'routes-requests-and-responses';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```js
app.get("/about", (req, res) => {
  res.send("This is the about page");
});

app.post("/submit", (req, res) => {
  res.send("Form received");
});
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'express-basics' and l.slug = 'routes-requests-and-responses';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Add a new GET route for `/contact` that sends back a simple message.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'express-basics' and l.slug = 'routes-requests-and-responses';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'express-basics' and l.slug = 'routes-requests-and-responses';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What's the difference between app.get() and app.post()?$md$, $md$["No difference","They handle different types of requests (retrieving vs. submitting data)","post is faster","get only works locally"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'express-basics' and l.slug = 'routes-requests-and-responses' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Defining two routes for the exact same path and method — only the first one Express finds will actually run; the second is silently ignored.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'express-basics' and l.slug = 'routes-requests-and-responses';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Assignment 2$md$, $md$Build an Express server with at least 3 different GET routes, each returning a different message.

**Pass criteria:** server starts without errors, all 3 routes respond correctly when visited.$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'express-basics';


insert into public.modules (track_id, name, slug, order_index)
select t.id, $md$Working with Data$md$, 'working-with-data', 2
from public.tracks t where t.slug = 'backend'
on conflict (track_id, slug) do update set order_index = excluded.order_index, name = excluded.name;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$What a database is$md$, 'what-a-database-is', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'working-with-data'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$A database stores data permanently, so it survives even after your server restarts — unlike variables in your code, which reset every time. Think of it as a very organized, searchable filing cabinet.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'working-with-data' and l.slug = 'what-a-database-is';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'working-with-data' and l.slug = 'what-a-database-is';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$Why can't you just store data in a regular JavaScript variable on the server?$md$, $md$["You can, and it works fine forever","Variables reset when the server restarts, losing the data","Variables are too slow","Variables can't hold text"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'working-with-data' and l.slug = 'what-a-database-is' and s.order_index = 1;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Storing important data only in memory (a variable) during development and being surprised it's gone after a restart — this is exactly why databases exist.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'working-with-data' and l.slug = 'what-a-database-is';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Basic Supabase/Postgres setup and connection$md$, 'basic-supabase-postgres-setup-and-connection', 1, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'working-with-data'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Supabase gives you a real Postgres database with an easy-to-use client library, so your Express server can read and write data without managing a database server yourself.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'working-with-data' and l.slug = 'basic-supabase-postgres-setup-and-connection';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```js
const { createClient } = require("@supabase/supabase-js");
const supabase = createClient(process.env.SUPABASE_URL, process.env.SUPABASE_KEY);
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'working-with-data' and l.slug = 'basic-supabase-postgres-setup-and-connection';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Set up a Supabase project and connect to it from a Node script (just the connection, no queries yet).$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'working-with-data' and l.slug = 'basic-supabase-postgres-setup-and-connection';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'working-with-data' and l.slug = 'basic-supabase-postgres-setup-and-connection';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$Why are the Supabase URL and key stored in environment variables instead of typed directly in the code?$md$, $md$["It's just a style preference","Keeps sensitive credentials out of code that might be shared or committed","It makes the code run faster","Environment variables are required by Express"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'working-with-data' and l.slug = 'basic-supabase-postgres-setup-and-connection' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Committing real database credentials directly into code that gets shared or pushed to GitHub — always use environment variables for secrets.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'working-with-data' and l.slug = 'basic-supabase-postgres-setup-and-connection';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Basic CRUD from an Express route$md$, 'basic-crud-from-an-express-route', 2, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'working-with-data'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$CRUD = Create, Read, Update, Delete — the four basic things you do with stored data.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'working-with-data' and l.slug = 'basic-crud-from-an-express-route';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```js
app.get("/students", async (req, res) => {
  const { data, error } = await supabase.from("students").select("*");
  res.json(data);
});

app.post("/students", async (req, res) => {
  const { data, error } = await supabase.from("students").insert(req.body);
  res.json(data);
});
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'working-with-data' and l.slug = 'basic-crud-from-an-express-route';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Add a route that deletes a student by ID.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'working-with-data' and l.slug = 'basic-crud-from-an-express-route';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'working-with-data' and l.slug = 'basic-crud-from-an-express-route';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$Which CRUD operation does supabase.from("students").select("*") perform?$md$, $md$["Create","Read","Update","Delete"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'working-with-data' and l.slug = 'basic-crud-from-an-express-route' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Forgetting `async`/`await` when calling Supabase — database calls take time, and without awaiting them, your code moves on before the data actually arrives.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'working-with-data' and l.slug = 'basic-crud-from-an-express-route';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Assignment 3$md$, $md$Build Express routes for full CRUD on a simple table (e.g. "notes": get all, create one, update one, delete one).

**Pass criteria:** all four operations work correctly against a real Supabase table.$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'working-with-data';


insert into public.modules (track_id, name, slug, order_index)
select t.id, $md$Authentication Basics$md$, 'authentication-basics', 3
from public.tracks t where t.slug = 'backend'
on conflict (track_id, slug) do update set order_index = excluded.order_index, name = excluded.name;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$What authentication is and why it matters$md$, 'what-authentication-is-and-why-it-matters', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'authentication-basics'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Authentication answers "who is this user?" — without it, anyone could access or change anyone else's data. It's different from authorization, which answers "what is this user allowed to do?"$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'authentication-basics' and l.slug = 'what-authentication-is-and-why-it-matters';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'authentication-basics' and l.slug = 'what-authentication-is-and-why-it-matters';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What question does authentication answer?$md$, $md$["What is this user allowed to do?","Who is this user?","How fast is the server?","What database is being used?"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'authentication-basics' and l.slug = 'what-authentication-is-and-why-it-matters' and s.order_index = 1;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Confusing authentication (who you are) with authorization (what you're allowed to do) — they're related but different problems.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'authentication-basics' and l.slug = 'what-authentication-is-and-why-it-matters';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$A simple login flow, conceptually$md$, 'a-simple-login-flow-conceptually', 1, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'authentication-basics'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$A basic login flow: the user submits an email/password → the server checks it against stored data → if it matches, the server gives back some proof (like a token) the user includes in future requests to prove who they are.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'authentication-basics' and l.slug = 'a-simple-login-flow-conceptually';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'authentication-basics' and l.slug = 'a-simple-login-flow-conceptually';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$After a successful login, what does the server typically give back to the user?$md$, $md$["The database password","A token proving who they are for future requests","Nothing, login is a one-time check","The full user table"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'authentication-basics' and l.slug = 'a-simple-login-flow-conceptually' and s.order_index = 1;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Thinking login only matters once — without a token or session, the server would have to ask for the password again on every single request.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'authentication-basics' and l.slug = 'a-simple-login-flow-conceptually';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Storing and checking a password securely$md$, 'storing-and-checking-a-password-securely', 2, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'authentication-basics'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Never store a plain password in the database — always store a *hashed* version (scrambled in a one-way way), and compare hashes when checking a login attempt.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'authentication-basics' and l.slug = 'storing-and-checking-a-password-securely';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```js
const bcrypt = require("bcrypt");

const hashed = await bcrypt.hash(plainPassword, 10);
// later, when checking login:
const matches = await bcrypt.compare(attemptedPassword, hashed);
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'authentication-basics' and l.slug = 'storing-and-checking-a-password-securely';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Hash a test password and confirm `bcrypt.compare` correctly returns true for the right password and false for a wrong one.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'authentication-basics' and l.slug = 'storing-and-checking-a-password-securely';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'authentication-basics' and l.slug = 'storing-and-checking-a-password-securely';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$Why is a password hashed instead of stored as plain text?$md$, $md$["It makes login faster","So even if the database is exposed, the real password isn't directly readable","It's required by Express","It makes the password shorter"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'authentication-basics' and l.slug = 'storing-and-checking-a-password-securely' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Storing plain-text passwords "just for now during development" — this habit is exactly how real breaches happen; always hash from day one.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'authentication-basics' and l.slug = 'storing-and-checking-a-password-securely';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Assignment 4$md$, $md$Build a signup route that hashes and stores a password, and a login route that checks a submitted password against the stored hash.

**Pass criteria:** correct passwords succeed, incorrect ones are rejected, password is never stored in plain text.$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'authentication-basics';


insert into public.modules (track_id, name, slug, order_index)
select t.id, $md$Building a Small API (Capstone)$md$, 'building-a-small-api-capstone', 4
from public.tracks t where t.slug = 'backend'
on conflict (track_id, slug) do update set order_index = excluded.order_index, name = excluded.name;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Putting it all together$md$, 'putting-it-all-together', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'building-a-small-api-capstone'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$A real API combines everything from this course: routes (Module 2), a real database (Module 3), and protected routes that require login (Module 4).$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'building-a-small-api-capstone' and l.slug = 'putting-it-all-together';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```js
app.get("/my-notes", requireAuth, async (req, res) => {
  const { data } = await supabase
    .from("notes")
    .select("*")
    .eq("user_id", req.user.id);
  res.json(data);
});
```
This route only works if `requireAuth` confirms the user is logged in — a "protected route."$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'building-a-small-api-capstone' and l.slug = 'putting-it-all-together';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Sketch out which routes your API needs and which ones should require login.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'building-a-small-api-capstone' and l.slug = 'putting-it-all-together';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'building-a-small-api-capstone' and l.slug = 'putting-it-all-together';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What makes a route "protected"?$md$, $md$["It has a longer URL","It checks the user is authenticated before running","It's written in a separate file","It uses GET instead of POST"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'building-a-small-api-capstone' and l.slug = 'putting-it-all-together' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Forgetting to protect a route that should require login — always double-check which routes handle sensitive or user-specific data.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'building-a-small-api-capstone' and l.slug = 'putting-it-all-together';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Testing your API with a client$md$, 'testing-your-api-with-a-client', 1, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'building-a-small-api-capstone'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$You can test API routes without building a frontend yet — using the browser (for GET routes), or a tool like curl or Postman (for any method, including POST/PUT/DELETE).$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'building-a-small-api-capstone' and l.slug = 'testing-your-api-with-a-client';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```bash
curl -X POST http://localhost:3000/students \
  -H "Content-Type: application/json" \
  -d '{"name": "Ada"}'
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'building-a-small-api-capstone' and l.slug = 'testing-your-api-with-a-client';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Test one of your GET routes in the browser, and one of your POST routes with curl or Postman.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'building-a-small-api-capstone' and l.slug = 'testing-your-api-with-a-client';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'building-a-small-api-capstone' and l.slug = 'testing-your-api-with-a-client';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$Why test an API with curl/Postman instead of only a browser?$md$, $md$["Browsers can't send any requests at all","Browsers can't easily send POST/PUT/DELETE requests with a body the way these tools can","It's required by Express","It's faster to build a whole frontend first"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'building-a-small-api-capstone' and l.slug = 'testing-your-api-with-a-client' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Only ever testing the "happy path" (correct input) — also test what happens with missing fields or bad data, since real users will eventually send both.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'building-a-small-api-capstone' and l.slug = 'testing-your-api-with-a-client';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Capstone Assignment — Small working REST API$md$, $md$Build a complete small API with: at least one public route, at least one protected route (requires login), full CRUD on one resource backed by a real Supabase table, and password hashing for signup/login. Test every route with curl or Postman and document what each one does.

**Pass criteria:** all routes work correctly, protected routes correctly reject requests without valid login, passwords are hashed. This is the assignment that unlocks this track's certificate.$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'building-a-small-api-capstone';


insert into public.modules (track_id, name, slug, order_index)
select t.id, $md$Rounding Out the Backend$md$, 'rounding-out-the-backend', 5
from public.tracks t where t.slug = 'backend'
on conflict (track_id, slug) do update set order_index = excluded.order_index, name = excluded.name;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Middleware$md$, 'middleware', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'rounding-out-the-backend'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Middleware is a function that runs *between* a request arriving and your route handling it — useful for things like logging, checking authentication, or parsing data, without repeating that logic in every route.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'rounding-out-the-backend' and l.slug = 'middleware';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```js
function logger(req, res, next) {
  console.log(`${req.method} ${req.url}`);
  next();
}
app.use(logger);
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'rounding-out-the-backend' and l.slug = 'middleware';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Write a middleware that logs the current time on every request.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'rounding-out-the-backend' and l.slug = 'middleware';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'rounding-out-the-backend' and l.slug = 'middleware';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does calling next() inside a middleware do?$md$, $md$["Ends the request with no response","Passes control to the next middleware or route handler","Restarts the server","Deletes the request"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'rounding-out-the-backend' and l.slug = 'middleware' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Forgetting to call `next()` inside a middleware — the request hangs forever, since nothing tells Express to continue to the next step.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'rounding-out-the-backend' and l.slug = 'middleware';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Environment variables and config in depth$md$, 'environment-variables-and-config-in-depth', 1, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'rounding-out-the-backend'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Beyond just database keys, real apps typically store all environment-specific settings (API keys, ports, feature flags) in environment variables loaded from a `.env` file — kept out of version control.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'rounding-out-the-backend' and l.slug = 'environment-variables-and-config-in-depth';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```js
require("dotenv").config();
const port = process.env.PORT || 3000;
```
.env file (never committed to GitHub):
```
PORT=3000
SUPABASE_URL=your-url-here
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'rounding-out-the-backend' and l.slug = 'environment-variables-and-config-in-depth';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Move a hardcoded value in your project into a `.env` file and read it with `process.env`.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'rounding-out-the-backend' and l.slug = 'environment-variables-and-config-in-depth';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'rounding-out-the-backend' and l.slug = 'environment-variables-and-config-in-depth';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$Why should a .env file be excluded from GitHub (via .gitignore)?$md$, $md$["It's not important","It typically contains secrets that shouldn't be public","GitHub doesn't allow .env files","It makes the app slower"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'rounding-out-the-backend' and l.slug = 'environment-variables-and-config-in-depth' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Committing a `.env` file to a public GitHub repo — this exposes real secrets; always add `.env` to `.gitignore`.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'rounding-out-the-backend' and l.slug = 'environment-variables-and-config-in-depth';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Centralized error handling$md$, 'centralized-error-handling', 2, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'rounding-out-the-backend'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Instead of repeating error-handling code in every route, Express lets you define one central error-handling middleware that catches errors from anywhere in the app.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'rounding-out-the-backend' and l.slug = 'centralized-error-handling';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```js
app.use((err, req, res, next) => {
  console.error(err);
  res.status(500).json({ error: "Something went wrong" });
});
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'rounding-out-the-backend' and l.slug = 'centralized-error-handling';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Trigger an intentional error in a route and confirm the central handler catches it.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'rounding-out-the-backend' and l.slug = 'centralized-error-handling';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'rounding-out-the-backend' and l.slug = 'centralized-error-handling';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What's different about an error-handling middleware's function signature?$md$, $md$["Nothing, it's the same as regular middleware","It takes 4 arguments instead of 3, starting with the error","It must be async","It can't use res"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'rounding-out-the-backend' and l.slug = 'centralized-error-handling' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Putting the error-handling middleware anywhere other than *last*, after all other routes — Express matches middleware in order, so it must come after everything else to catch errors from them.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'rounding-out-the-backend' and l.slug = 'centralized-error-handling';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Input validation$md$, 'input-validation', 3, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'rounding-out-the-backend'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Never trust data coming from a request — validate it before using it (checking required fields exist, checking types, etc.), to avoid crashes or bad data getting saved.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'rounding-out-the-backend' and l.slug = 'input-validation';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```js
app.post("/students", (req, res) => {
  const { name } = req.body;
  if (!name || typeof name !== "string") {
    return res.status(400).json({ error: "A valid name is required" });
  }
  // proceed knowing name is valid
});
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'rounding-out-the-backend' and l.slug = 'input-validation';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Add validation to one of your Module 3 CRUD routes, checking a required field exists before proceeding.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'rounding-out-the-backend' and l.slug = 'input-validation';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'rounding-out-the-backend' and l.slug = 'input-validation';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What status code is conventionally used for a bad/invalid request?$md$, $md$["200","400","500","404"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'rounding-out-the-backend' and l.slug = 'input-validation' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Trusting `req.body` fields exist without checking — accessing a property that's missing doesn't crash immediately in JS, but using it further down (like calling `.toUpperCase()` on `undefined`) will.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'rounding-out-the-backend' and l.slug = 'input-validation';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$CORS$md$, 'cors', 4, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'rounding-out-the-backend'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$CORS (Cross-Origin Resource Sharing) is a browser security rule that blocks a frontend on one domain from calling an API on a different domain, unless the API explicitly allows it.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'rounding-out-the-backend' and l.slug = 'cors';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```js
const cors = require("cors");
app.use(cors());
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'rounding-out-the-backend' and l.slug = 'cors';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Add the `cors` middleware to your Express app and confirm a frontend on a different port can now successfully call it.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'rounding-out-the-backend' and l.slug = 'cors';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'rounding-out-the-backend' and l.slug = 'cors';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What problem does CORS middleware solve?$md$, $md$["It speeds up requests","It allows a frontend on a different origin to call your API","It replaces authentication","It's unrelated to APIs"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'rounding-out-the-backend' and l.slug = 'cors' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Enabling `cors()` with no restrictions in a real production app — for anything sensitive, it's safer to explicitly allow only your actual frontend's domain rather than allowing all origins.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'rounding-out-the-backend' and l.slug = 'cors';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Assignment 6$md$, $md$Add a logging middleware, centralized error handling, input validation on at least 2 routes, and CORS support to your Module 5 capstone API.

**Pass criteria:** all additions work correctly, invalid requests are properly rejected with clear error messages.$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'rounding-out-the-backend';


insert into public.modules (track_id, name, slug, order_index)
select t.id, $md$Deploying Your Project (GitHub + Vercel)$md$, 'deploying-your-project', 6
from public.tracks t where t.slug = 'backend'
on conflict (track_id, slug) do update set order_index = excluded.order_index, name = excluded.name;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Pushing your project to GitHub$md$, 'pushing-your-project-to-github', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'deploying-your-project'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$GitHub stores your code online and is what Vercel connects to for deployment.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'deploying-your-project' and l.slug = 'pushing-your-project-to-github';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$**Try it — numbered steps:**
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
4. Make sure your `.env` file is listed in `.gitignore` before pushing — never commit real secrets$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'deploying-your-project' and l.slug = 'pushing-your-project-to-github';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'deploying-your-project' and l.slug = 'pushing-your-project-to-github';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What must be true before pushing a backend project to a public GitHub repo?$md$, $md$["Nothing special","Sensitive files like .env must be excluded via .gitignore","The server must already be deployed","All tests must pass first"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'deploying-your-project' and l.slug = 'pushing-your-project-to-github' and s.order_index = 2;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Realizing secrets were committed *after* pushing — simply deleting the file afterward doesn't remove it from the repo's history; the secret should be rotated (changed) immediately if this happens.$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'deploying-your-project' and l.slug = 'pushing-your-project-to-github';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Deploying an Express API to Vercel$md$, 'deploying-an-express-api-to-vercel', 1, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'deploying-your-project'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Vercel can host Node/Express backends as serverless functions, connected directly to your GitHub repo.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'deploying-your-project' and l.slug = 'deploying-an-express-api-to-vercel';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$**Try it — numbered steps:**
1. Go to vercel.com, sign up with GitHub
2. Click "Add New Project," select your repository
3. In the project settings, add your environment variables (SUPABASE_URL, SUPABASE_KEY, etc.) directly in Vercel's dashboard — never in the code
4. Click "Deploy"
5. Test your live API routes using the URL Vercel gives you$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'deploying-your-project' and l.slug = 'deploying-an-express-api-to-vercel';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'deploying-your-project' and l.slug = 'deploying-an-express-api-to-vercel';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$Where should real environment variable values go when deploying to Vercel?$md$, $md$["Directly in your code","In Vercel's project settings/dashboard, not in the code","In a public GitHub file","They're not needed once deployed"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'deploying-your-project' and l.slug = 'deploying-an-express-api-to-vercel' and s.order_index = 2;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Forgetting to add environment variables in Vercel's dashboard — the deployed app will fail to connect to Supabase or anything else relying on them, even though it worked locally with a `.env` file.$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'deploying-your-project' and l.slug = 'deploying-an-express-api-to-vercel';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Assignment 7 (Capstone extension)$md$, $md$Deploy your finished API to Vercel with environment variables properly configured, and confirm your protected and public routes both work correctly on the live URL.

**Pass criteria:** live API responds correctly, protected routes still require authentication, no secrets are exposed in the codebase.$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'deploying-your-project';

-- Verified structurally against the source file before publishing.
update public.lessons l set status = 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'backend';
