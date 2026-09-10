-- Replace em dashes in seeded copy with cleaner punctuation.

update public.bundles set description = 'HTML, CSS, JavaScript, and React: everything you need to build real, responsive interfaces.'
  where slug = 'frontend';
update public.bundles set description = 'Servers, databases, and APIs: learn to build the systems that power real applications.'
  where slug = 'backend';
update public.bundles set description = 'Frontend and Backend combined: go from a blank page to a deployed, working product.'
  where slug = 'full-stack';
update public.bundles set description = 'Learn Python from first principles: syntax, logic, and real small projects.'
  where slug = 'python';
update public.bundles set description = 'Server-side fundamentals with PHP: build and ship a real dynamic website.'
  where slug = 'php';

update public.bundles set audience = 'For anyone who wants the complete picture: frontend and backend, start to finish.'
  where slug = 'full-stack';

update public.sections s
set content = $md$Every website you've ever used is built on the same three layers:

| Layer | Job |
|---|---|
| **HTML** | The content and structure: what's on the page |
| **CSS** | The look: colors, spacing, layout |
| **JavaScript** | The behavior: what happens when you click, type, scroll |

This lesson is just about HTML: the skeleton every page is built on.

### A page, from nothing

Every HTML page follows the same shape:

1. `<!doctype html>`: tells the browser "this is HTML"
2. `<html>`: wraps the whole page
3. `<head>`: info about the page (title, etc.), not shown on screen
4. `<body>`: everything visible, including text, images, buttons

```html
<!doctype html>
<html>
  <head>
    <title>My First Page</title>
  </head>
  <body>
    <h1>Hello, world</h1>
    <p>This is my first web page.</p>
  </body>
</html>
```

### Try it yourself

In the full lesson, you'll edit code like this directly in the browser
and see it update live, no setup required. That's what every lesson
in Forge looks like.
$md$
from public.lessons l
join public.tracks t on t.id = l.track_id
where s.lesson_id = l.id and t.slug = 'web-fundamentals' and l.slug = 'your-first-web-page';
