-- Forge Phase 1 — seed bundles + one free-preview teaser lesson.
-- Placeholder copy/pricing — instructor edits both from the admin dashboard.

insert into public.bundles (name, slug, description, price, currency) values
  ('Frontend', 'frontend', 'HTML, CSS, JavaScript, and React — everything you need to build real, responsive interfaces.', 45000, 'NGN'),
  ('Backend', 'backend', 'Servers, databases, and APIs — learn to build the systems that power real applications.', 45000, 'NGN'),
  ('Full Stack', 'full-stack', 'Frontend and Backend combined — go from a blank page to a deployed, working product.', 75000, 'NGN'),
  ('Python', 'python', 'Learn Python from first principles — syntax, logic, and real small projects.', 30000, 'NGN'),
  ('JavaScript', 'javascript', 'The language of the web, from fundamentals to real interactive projects.', 30000, 'NGN'),
  ('PHP', 'php', 'Server-side fundamentals with PHP — build and ship a real dynamic website.', 30000, 'NGN')
on conflict (slug) do nothing;

insert into public.tracks (bundle_id, name, slug, level, description, order_index)
values (null, 'Web Fundamentals', 'web-fundamentals', 'beginner', 'The first steps into building for the web.', 0)
on conflict (slug) do nothing;

insert into public.lessons (track_id, title, slug, order_index, is_free_preview)
select id, 'Your First Web Page', 'your-first-web-page', 0, true
from public.tracks where slug = 'web-fundamentals'
on conflict (track_id, slug) do nothing;

insert into public.sections (lesson_id, title, content, order_index)
select l.id, 'What HTML actually does', $md$Every website you've ever used is built on the same three layers:

| Layer | Job |
|---|---|
| **HTML** | The content and structure — what's on the page |
| **CSS** | The look — colors, spacing, layout |
| **JavaScript** | The behavior — what happens when you click, type, scroll |

This lesson is just about HTML: the skeleton every page is built on.

### A page, from nothing

Every HTML page follows the same shape:

1. `<!doctype html>` — tells the browser "this is HTML"
2. `<html>` — wraps the whole page
3. `<head>` — info about the page (title, etc.) — not shown on screen
4. `<body>` — everything visible: text, images, buttons

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
and see it update live — no setup required. That's what every lesson
in Forge looks like.
$md$, 0
from public.lessons l
join public.tracks t on t.id = l.track_id
where t.slug = 'web-fundamentals' and l.slug = 'your-first-web-page'
on conflict do nothing;
