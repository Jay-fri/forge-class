-- Backend track built out in full. Sandpack has no Node runtime (only
-- static/vanilla/react/vue/angular templates), so unlike the browser-based
-- tracks, sections here are read-only code walkthroughs rather than live
-- editable sandboxes, with a note pointing students at running things
-- locally, or in the assignment's own environment.


update public.lessons l
set status = 'published', is_free_preview = true
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'backend' and m.slug = 'getting-started-with-nodejs' and l.slug = 'what-a-server-is';


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'backend' and m.slug = 'getting-started-with-nodejs' and l.slug = 'what-a-server-is';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$What happens when a browser asks for something$md$, $md$A server is just a program that waits for requests and sends back responses. When you type a URL into your browser, the browser asks a server somewhere for that page, and the server answers.

```
Browser: "Can I have the homepage?"
Server: "Here it is." (sends back HTML)
```

Everything you have built so far has run entirely in the browser. A server is code that runs somewhere else, waiting to be asked for something.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'getting-started-with-nodejs' and l.slug = 'what-a-server-is';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id,
  $md$What is a server, in the simplest sense?$md$,
  '["A type of database","A program that waits for requests and sends back responses","A JavaScript framework","A web browser"]'::jsonb,
  1,
  $md$At its core, a server just listens for incoming requests and responds to them. Everything else, databases, frameworks, auth, is built on top of that basic idea.$md$,
  0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'getting-started-with-nodejs' and l.slug = 'what-a-server-is' and s.title = 'What happens when a browser asks for something';


update public.lessons l
set status = 'published', is_free_preview = false
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'backend' and m.slug = 'getting-started-with-nodejs' and l.slug = 'running-a-basic-node-script';


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'backend' and m.slug = 'getting-started-with-nodejs' and l.slug = 'running-a-basic-node-script';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$JavaScript outside the browser$md$, $md$Node.js runs JavaScript outside the browser, on a server (or your own computer). The language is the same JavaScript you already know, the difference is what it can do: no document, no window, but it can read files, start a server, and talk to a database.

```js
// hello.js
console.log("Hello from Node");
```

Running `node hello.js` in a terminal executes this file directly, no browser involved.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'getting-started-with-nodejs' and l.slug = 'running-a-basic-node-script';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id,
  $md$What is the main difference between JavaScript in the browser and in Node.js?$md$,
  '["They are completely different languages","Node has no console.log","Node runs outside the browser and can do things like read files or start a server, but has no document or window","Node only works with React"]'::jsonb,
  2,
  $md$Node.js runs the same JavaScript language, just in a different environment: no browser DOM, but access to the file system, networking, and more.$md$,
  0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'getting-started-with-nodejs' and l.slug = 'running-a-basic-node-script' and s.title = 'JavaScript outside the browser';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Try it yourself$md$, $md$This track's code will not run in an embedded browser sandbox the way earlier tracks did, since Node needs a real server environment, not a browser. If you have Node installed, save the snippet above as hello.js and run node hello.js in a terminal. Otherwise, keep reading, the assignments give you a real place to run this kind of code.$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'getting-started-with-nodejs' and l.slug = 'running-a-basic-node-script';


update public.lessons l
set status = 'published', is_free_preview = false
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'backend' and m.slug = 'express-basics' and l.slug = 'routes';


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'backend' and m.slug = 'express-basics' and l.slug = 'routes';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Defining routes$md$, $md$Express is a small framework that makes building a server much less tedious. A route matches a URL and an HTTP method to a function that handles it.

```js
const express = require("express");
const app = express();

app.get("/", (req, res) => {
  res.send("Welcome home");
});

app.get("/about", (req, res) => {
  res.send("About this app");
});

app.listen(3000);
```

Each app.get(path, handler) says: when a GET request comes in for this path, run this function. res.send() is how you respond.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'express-basics' and l.slug = 'routes';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id,
  $md$In the example above, what happens when someone visits /about?$md$,
  '["The server crashes","The about route handler runs and sends back \"About this app\"","Nothing, only / is defined","It redirects to the homepage"]'::jsonb,
  1,
  $md$Express matches the incoming request path against your defined routes and runs the matching handler, here sending back the about text.$md$,
  0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'express-basics' and l.slug = 'routes' and s.title = 'Defining routes';


update public.lessons l
set status = 'published', is_free_preview = false
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'backend' and m.slug = 'express-basics' and l.slug = 'handling-requests-and-responses';


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'backend' and m.slug = 'express-basics' and l.slug = 'handling-requests-and-responses';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Reading what came in, shaping what goes out$md$, $md$A request carries information: the URL, any data sent with it, and more. A response is what you send back, and it does not have to be plain text.

```js
app.get("/greet/:name", (req, res) => {
  res.json({ message: `Hello, ${req.params.name}!` });
});
```

:name in the path is a route parameter. Visiting /greet/Ada makes req.params.name equal "Ada". res.json() sends back a JSON response instead of plain text, which is what most real APIs do.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'express-basics' and l.slug = 'handling-requests-and-responses';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id,
  $md$In the route /greet/:name, what does :name represent?$md$,
  '["A fixed word that must literally be name","A route parameter that captures whatever value is in that part of the URL","A CSS class","An error message"]'::jsonb,
  1,
  $md$A colon before a segment in an Express route marks it as a parameter, capturing whatever value appears there into req.params.$md$,
  0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'express-basics' and l.slug = 'handling-requests-and-responses' and s.title = 'Reading what came in, shaping what goes out';


update public.lessons l
set status = 'published', is_free_preview = false
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'backend' and m.slug = 'working-with-data' and l.slug = 'database-basics';


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'backend' and m.slug = 'working-with-data' and l.slug = 'database-basics';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Connecting to a real database$md$, $md$So far, any data your code holds disappears the moment it stops running. A database persists data between runs, and between different requests from different people.

```js
import { createClient } from "@supabase/supabase-js";

const supabase = createClient(SUPABASE_URL, SUPABASE_KEY);

const { data, error } = await supabase.from("todos").select("*");
```

This connects to a Supabase project, a hosted Postgres database, and asks for every row in a todos table. data holds the results, error holds anything that went wrong.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'working-with-data' and l.slug = 'database-basics';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id,
  $md$Why does a server need a database instead of just storing data in a variable?$md$,
  '["Variables are slower than databases","A variable value disappears when the server restarts or the request finishes, a database persists it","Databases are required by law","Variables cannot hold text"]'::jsonb,
  1,
  $md$Data held only in memory, a variable, is lost as soon as the process restarts. A database stores it durably, available across restarts and to every request.$md$,
  0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'working-with-data' and l.slug = 'database-basics' and s.title = 'Connecting to a real database';


update public.lessons l
set status = 'published', is_free_preview = false
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'backend' and m.slug = 'working-with-data' and l.slug = 'basic-crud';


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'backend' and m.slug = 'working-with-data' and l.slug = 'basic-crud';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Create, read, update, delete$md$, $md$Almost every feature in a real app is some combination of four operations, together called CRUD.

| Operation | What it does | Example |
|---|---|---|
| Create | Add a new row | supabase.from("todos").insert({ text: "Learn CRUD" }) |
| Read | Fetch rows | supabase.from("todos").select("*") |
| Update | Change an existing row | supabase.from("todos").update({ done: true }).eq("id", id) |
| Delete | Remove a row | supabase.from("todos").delete().eq("id", id) |

Nearly every route you build in a real API maps to one of these four operations on some table.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'working-with-data' and l.slug = 'basic-crud';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id,
  $md$Which CRUD operation would you use to mark a todo as done?$md$,
  '["Create","Read","Update","Delete"]'::jsonb,
  2,
  $md$Marking an existing todo as done changes a field on a row that already exists, which is an update.$md$,
  0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'working-with-data' and l.slug = 'basic-crud' and s.title = 'Create, read, update, delete';


update public.lessons l
set status = 'published', is_free_preview = false
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'backend' and m.slug = 'authentication-basics' and l.slug = 'what-auth-is';


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'backend' and m.slug = 'authentication-basics' and l.slug = 'what-auth-is';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Proving who you are$md$, $md$Authentication answers one question: who is making this request? Without it, anyone could pretend to be anyone.

A common pattern: a user logs in with an email and password, the server verifies it, and gives back a token. The user includes that token on every future request, proving who they are without having to log in again each time.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'authentication-basics' and l.slug = 'what-auth-is';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id,
  $md$What is the main purpose of authentication?$md$,
  '["Making the app look nicer","Verifying who is making a request","Speeding up the database","Formatting responses as JSON"]'::jsonb,
  1,
  $md$Authentication is specifically about verifying identity, confirming who is making a request before deciding what they are allowed to do.$md$,
  0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'authentication-basics' and l.slug = 'what-auth-is' and s.title = 'Proving who you are';


update public.lessons l
set status = 'published', is_free_preview = false
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'backend' and m.slug = 'authentication-basics' and l.slug = 'a-simple-login-flow';


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'backend' and m.slug = 'authentication-basics' and l.slug = 'a-simple-login-flow';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$The shape of a login, end to end$md$, $md$A basic login flow, whether you build it yourself or use a service like Supabase Auth, follows the same shape:

1. The user submits an email and password
2. The server checks the password against what is stored, never as plain text, always hashed
3. If it matches, the server issues a token
4. The user's browser stores that token and sends it with future requests
5. The server checks the token on any route that needs to know who is asking

Forge itself uses this exact pattern under the hood, via Supabase Auth.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'authentication-basics' and l.slug = 'a-simple-login-flow';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id,
  $md$Why is a password never stored as plain text?$md$,
  '["Plain text takes up more space","If the database is ever exposed, plain text passwords are immediately usable by an attacker","Databases cannot store text","It would make login slower"]'::jsonb,
  1,
  $md$Passwords are stored hashed, scrambled in a one-way way, specifically so that even if a database is exposed, the original passwords are not directly readable.$md$,
  0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'authentication-basics' and l.slug = 'a-simple-login-flow' and s.title = 'The shape of a login, end to end';


update public.lessons l
set status = 'published', is_free_preview = false
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'backend' and m.slug = 'building-a-small-api' and l.slug = 'capstone-a-working-rest-api';


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'backend' and m.slug = 'building-a-small-api' and l.slug = 'capstone-a-working-rest-api';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Putting it all together$md$, $md$A REST API is just a server with a consistent set of routes and conventions: predictable URLs, the right HTTP method for the right action, and JSON responses.

```
GET    /todos        -> list all todos
POST   /todos        -> create a new todo
PATCH  /todos/:id    -> update a todo
DELETE /todos/:id    -> delete a todo
```

Each route maps directly to one of the CRUD operations from earlier in this track, now exposed over HTTP so a frontend, or anyone, can use them.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'building-a-small-api' and l.slug = 'capstone-a-working-rest-api';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id,
  $md$Which HTTP method would you typically use to delete a resource in a REST API?$md$,
  '["GET","POST","DELETE","PATCH"]'::jsonb,
  2,
  $md$REST conventions map DELETE to removing a resource, GET to reading, POST to creating, and PATCH or PUT to updating.$md$,
  0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'building-a-small-api' and l.slug = 'capstone-a-working-rest-api' and s.title = 'Putting it all together';
