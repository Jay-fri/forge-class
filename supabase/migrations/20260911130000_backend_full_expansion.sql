-- Backend expanded from 9 to 16 lessons across the same 5 modules:
-- npm/packages, route params/query strings, middleware, error handling
-- and status codes, environment variables/secrets, authorization and
-- roles, and testing an API, on top of the existing lessons.


update public.lessons l set order_index = 0
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'backend' and m.slug = 'getting-started-with-nodejs' and l.slug = 'what-a-server-is';


update public.lessons l set order_index = 1
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'backend' and m.slug = 'getting-started-with-nodejs' and l.slug = 'running-a-basic-node-script';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$npm and packages$md$, 'npm-and-packages', 2, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'getting-started-with-nodejs'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'backend' and m.slug = 'getting-started-with-nodejs' and l.slug = 'npm-and-packages';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$package.json and npm install$md$, $md$Real Node projects almost always depend on other people's code, packages, installed via npm (Node's package manager).

```
npm init -y
npm install express
```

npm init -y creates a package.json file, which tracks your project's name, dependencies, and scripts. npm install express downloads the Express package into a node_modules folder and adds it to package.json's dependencies list.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'getting-started-with-nodejs' and l.slug = 'npm-and-packages';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$What does package.json track?$md$, '["The actual code of your app","Your project name, dependencies, and scripts","A backup of node_modules","Your database schema"]'::jsonb, 1, $md$package.json is the manifest for a Node project: its name, version, dependencies, and any scripts you've defined, not the application code itself.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'getting-started-with-nodejs' and l.slug = 'npm-and-packages' and s.title = $md$package.json and npm install$md$;


update public.lessons l set order_index = 0
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'backend' and m.slug = 'express-basics' and l.slug = 'routes';


update public.lessons l set order_index = 1
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'backend' and m.slug = 'express-basics' and l.slug = 'handling-requests-and-responses';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Route parameters and query strings$md$, 'route-params-and-query-strings', 2, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'express-basics'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'backend' and m.slug = 'express-basics' and l.slug = 'route-params-and-query-strings';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Two ways to pass data in a URL$md$, $md$```js
app.get("/users/:id", (req, res) => {
  res.send(`User ID: ${req.params.id}`);
});

app.get("/search", (req, res) => {
  res.send(`Searching for: ${req.query.q}`);
});
```

Visiting /users/42 makes req.params.id equal "42", a route parameter, part of the URL's path. Visiting /search?q=forge makes req.query.q equal "forge", a query string, the part after the ?. Use params for identifying a specific resource, query strings for optional filters or search terms.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'express-basics' and l.slug = 'route-params-and-query-strings';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$What is the main difference between a route parameter and a query string?$md$, '["There is no difference","A route parameter is part of the URL path (like /users/:id), a query string comes after a ? (like ?q=forge)","Query strings only work with POST requests","Route parameters are always numbers"]'::jsonb, 1, $md$Route parameters are embedded directly in the path structure, query strings are optional key-value pairs appended after a question mark.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'express-basics' and l.slug = 'route-params-and-query-strings' and s.title = $md$Two ways to pass data in a URL$md$;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Middleware$md$, 'middleware', 3, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'express-basics'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'backend' and m.slug = 'express-basics' and l.slug = 'middleware';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Code that runs between the request and the response$md$, $md$Middleware is a function that runs before your route handler, often used for logging, authentication checks, or parsing incoming data.

```js
app.use(express.json());

app.use((req, res, next) => {
  console.log(`${req.method} ${req.path}`);
  next();
});

app.get("/", (req, res) => {
  res.send("Home");
});
```

express.json() is built-in middleware that parses incoming JSON request bodies. The custom logging middleware runs on every request, then calls next() to pass control along to whatever comes next, without next(), the request would hang forever.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'express-basics' and l.slug = 'middleware';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$What happens if a middleware function never calls next()?$md$, '["The request completes normally","The request hangs, nothing further ever runs for it","The server crashes immediately","next() is optional and does nothing"]'::jsonb, 1, $md$Middleware must call next() to pass control to the next function in the chain (another middleware or the route handler). Without it, the request never completes.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'express-basics' and l.slug = 'middleware' and s.title = $md$Code that runs between the request and the response$md$;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Error handling and status codes$md$, 'errors-and-status-codes', 4, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'express-basics'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'backend' and m.slug = 'express-basics' and l.slug = 'errors-and-status-codes';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$HTTP status codes$md$, $md$Every response carries a status code, a number telling the client what happened.

| Code | Meaning |
|---|---|
| 200 | OK, success |
| 201 | Created, a new resource was made |
| 400 | Bad request, the client sent something invalid |
| 401 | Unauthorized, not logged in |
| 403 | Forbidden, logged in but not allowed |
| 404 | Not found |
| 500 | Server error, something broke on the server's side |

```js
app.get("/users/:id", (req, res) => {
  const user = findUser(req.params.id);
  if (!user) {
    return res.status(404).send("User not found");
  }
  res.status(200).json(user);
});
```$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'express-basics' and l.slug = 'errors-and-status-codes';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$What does a 404 status code mean?$md$, '["The server crashed","The request succeeded","The requested resource was not found","The user is not authenticated"]'::jsonb, 2, $md$404 specifically means the requested resource could not be found, distinct from a server error (500) or an auth failure (401).$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'express-basics' and l.slug = 'errors-and-status-codes' and s.title = $md$HTTP status codes$md$;


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Handling errors gracefully$md$, $md$```js
app.get("/risky", (req, res) => {
  try {
    doSomethingThatMightFail();
    res.send("OK");
  } catch (err) {
    console.error(err);
    res.status(500).send("Something went wrong");
  }
});
```

Wrapping risky code in try/catch means an unexpected error returns a proper response instead of crashing the whole server or hanging the request forever.$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'express-basics' and l.slug = 'errors-and-status-codes';


update public.lessons l set order_index = 0
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'backend' and m.slug = 'working-with-data' and l.slug = 'database-basics';


update public.lessons l set order_index = 1
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'backend' and m.slug = 'working-with-data' and l.slug = 'basic-crud';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Environment variables and secrets$md$, 'environment-variables-and-secrets', 2, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'working-with-data'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'backend' and m.slug = 'working-with-data' and l.slug = 'environment-variables-and-secrets';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Keeping secrets out of your code$md$, $md$Things like database passwords and API keys should never be written directly into your code, especially code that goes into version control like Git.

```
# .env file (never committed to Git)
DATABASE_URL=postgres://...
API_KEY=abc123
```

```js
const dbUrl = process.env.DATABASE_URL;
```

process.env reads environment variables, values set outside your code, often loaded from a .env file during development. This is exactly how Forge itself keeps its own Gemini API key and database credentials out of the codebase.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'working-with-data' and l.slug = 'environment-variables-and-secrets';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$Why should secrets like a database password be kept in environment variables instead of directly in the code?$md$, '["Environment variables make the code run faster","So the secret is never committed to version control and exposed publicly","It is required by JavaScript syntax","Environment variables are encrypted automatically"]'::jsonb, 1, $md$Code committed to a repository (especially a public one) is visible to anyone with access. Environment variables keep secrets outside the codebase entirely.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'working-with-data' and l.slug = 'environment-variables-and-secrets' and s.title = $md$Keeping secrets out of your code$md$;


update public.lessons l set order_index = 0
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'backend' and m.slug = 'authentication-basics' and l.slug = 'what-auth-is';


update public.lessons l set order_index = 1
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'backend' and m.slug = 'authentication-basics' and l.slug = 'a-simple-login-flow';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Authorization and roles$md$, 'authorization-and-roles', 2, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'authentication-basics'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'backend' and m.slug = 'authentication-basics' and l.slug = 'authorization-and-roles';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Authentication vs authorization$md$, $md$Authentication answers who are you. Authorization answers what are you allowed to do, a separate question, checked after authentication.

```js
function requireAdmin(req, res, next) {
  if (req.user.role !== "admin") {
    return res.status(403).send("Forbidden");
  }
  next();
}

app.delete("/users/:id", requireAdmin, (req, res) => {
  // only reachable if requireAdmin's check passed
});
```

A logged-in user is authenticated, but that alone does not mean they should be allowed to delete another user's account, that is an authorization check, often based on a role stored on their account.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'authentication-basics' and l.slug = 'authorization-and-roles';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$What is the difference between authentication and authorization?$md$, '["They are the same thing","Authentication verifies who you are, authorization checks what you are allowed to do","Authorization happens before authentication always","Authentication only applies to admins"]'::jsonb, 1, $md$Authentication confirms identity. Authorization is a separate, subsequent check on what that identified user is permitted to do.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'authentication-basics' and l.slug = 'authorization-and-roles' and s.title = $md$Authentication vs authorization$md$;


update public.lessons l set order_index = 1
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'backend' and m.slug = 'building-a-small-api' and l.slug = 'capstone-a-working-rest-api';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Testing your API$md$, 'testing-your-api', 0, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'building-a-small-api'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'backend' and m.slug = 'building-a-small-api' and l.slug = 'testing-your-api';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Why testing matters, and how to do it simply$md$, $md$Before connecting a frontend to your API, confirm it actually works on its own. Two common ways:

```
curl http://localhost:3000/todos
curl -X POST http://localhost:3000/todos -H "Content-Type: application/json" -d '{"text":"Learn testing"}'
```

curl is a command-line tool for making HTTP requests, useful for a quick check. Postman (or Insomnia) is a graphical tool that does the same thing with a friendlier interface, letting you save and organize requests. Either way, test every route before assuming it works.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'building-a-small-api' and l.slug = 'testing-your-api';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$Why should you test API routes with curl or Postman before building the frontend?$md$, '["It is required by law","To confirm the backend actually works correctly before adding another layer (the frontend) on top of it","It makes the server faster","Testing is optional and rarely useful"]'::jsonb, 1, $md$Testing the API directly isolates problems: if a route fails when tested alone, you know the issue is in the backend, not tangled up with frontend code.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'building-a-small-api' and l.slug = 'testing-your-api' and s.title = $md$Why testing matters, and how to do it simply$md$;
