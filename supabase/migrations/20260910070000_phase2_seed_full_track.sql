-- Forge Phase 2 — seed one full track end-to-end (proof-of-concept):
-- HTML, CSS & JavaScript Fundamentals. Expands the existing
-- 'web-fundamentals' track (which already holds the Phase 1 teaser lesson)
-- rather than seeding a second, parallel track.

update public.tracks
set name = 'HTML, CSS & JavaScript Fundamentals',
    description = 'The first steps into building for the web: structure, style, and behavior.'
where slug = 'web-fundamentals';

insert into public.bundle_tracks (bundle_id, track_id)
select b.id, t.id
from public.bundles b, public.tracks t
where b.slug in ('frontend', 'full-stack') and t.slug = 'web-fundamentals'
on conflict do nothing;

-- Module 1: HTML Basics (renamed from the Phase 1 placeholder "Getting Started")

update public.modules
set name = 'HTML Basics', slug = 'html-basics'
where slug = 'getting-started'
  and track_id = (select id from public.tracks where slug = 'web-fundamentals');

insert into public.lessons (module_id, title, slug, order_index)
select m.id, 'Links and Images', 'links-and-images', 1
from public.modules m
where m.track_id = (select id from public.tracks where slug = 'web-fundamentals')
  and m.slug = 'html-basics'
on conflict (module_id, slug) do nothing;

insert into public.sections (lesson_id, title, content, order_index)
select l.id, 'Linking to other pages', $md$A link turns text (or an image) into something clickable. It's the
`<a>` tag, short for "anchor":

```html
<a href="https://example.com">Visit example.com</a>
```

| Attribute | Does what |
|---|---|
| `href` | Where the link goes |
| `target="_blank"` | Opens in a new tab |

### Linking within your own site

Use a relative path to link to another page in the same project:

```html
<a href="/about.html">About us</a>
```
$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id
where m.slug = 'html-basics' and l.slug = 'links-and-images'
on conflict do nothing;

insert into public.sections (lesson_id, title, content, order_index)
select l.id, 'Adding images', $md$Images use `<img>`, a self-closing tag with no content between a
start and end tag:

```html
<img src="cat.jpg" alt="A sleeping cat" />
```

1. `src`: where the image file lives
2. `alt`: describes the image for screen readers, and shows if the image fails to load

Always include `alt` text, even a short one. It's not optional in practice.
$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id
where m.slug = 'html-basics' and l.slug = 'links-and-images'
on conflict do nothing;

-- Module 2: CSS Basics

insert into public.modules (track_id, name, slug, order_index)
select id, 'CSS Basics', 'css-basics', 1
from public.tracks where slug = 'web-fundamentals'
on conflict (track_id, slug) do nothing;

insert into public.lessons (module_id, title, slug, order_index)
select m.id, 'Styling Your First Page', 'styling-your-first-page', 0
from public.modules m
where m.track_id = (select id from public.tracks where slug = 'web-fundamentals')
  and m.slug = 'css-basics'
on conflict (module_id, slug) do nothing;

insert into public.sections (lesson_id, title, content, order_index)
select l.id, 'Selecting what to style', $md$CSS rules follow one shape: a **selector** (what to style) and
**declarations** (how to style it).

```css
p {
  color: #333;
  font-size: 16px;
}
```

| Selector | Targets |
|---|---|
| `p` | Every `<p>` |
| `.card` | Every element with `class="card"` |
| `#header` | The one element with `id="header"` |
$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id
where m.slug = 'css-basics' and l.slug = 'styling-your-first-page'
on conflict do nothing;

insert into public.sections (lesson_id, title, content, order_index)
select l.id, 'The box model', $md$Every element on a page is a box. Four layers, from the inside out:

1. **Content**: the text or image itself
2. **Padding**: space inside the border
3. **Border**: the edge of the box
4. **Margin**: space outside the border, between boxes

```css
.card {
  padding: 16px;
  border: 1px solid #ddd;
  margin: 8px;
}
```
$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id
where m.slug = 'css-basics' and l.slug = 'styling-your-first-page'
on conflict do nothing;

-- Module 3: JavaScript Basics

insert into public.modules (track_id, name, slug, order_index)
select id, 'JavaScript Basics', 'javascript-basics', 2
from public.tracks where slug = 'web-fundamentals'
on conflict (track_id, slug) do nothing;

insert into public.lessons (module_id, title, slug, order_index)
select m.id, 'Variables and Values', 'variables-and-values', 0
from public.modules m
where m.track_id = (select id from public.tracks where slug = 'web-fundamentals')
  and m.slug = 'javascript-basics'
on conflict (module_id, slug) do nothing;

insert into public.sections (lesson_id, title, content, order_index)
select l.id, 'Storing a value', $md$A variable is a named box you can put a value in, using `let` or
`const`:

```js
let streak = 12;
const name = "Ada";
```

| Keyword | Use it when |
|---|---|
| `const` | The value never changes |
| `let` | The value will change later |

Reach for `const` first. Only use `let` when you know you'll reassign it.
$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id
where m.slug = 'javascript-basics' and l.slug = 'variables-and-values'
on conflict do nothing;

insert into public.sections (lesson_id, title, content, order_index)
select l.id, 'The basic data types', $md$Every value in JavaScript has a type. The four you'll use constantly:

| Type | Example |
|---|---|
| String | `"hello"` |
| Number | `12`, `3.5` |
| Boolean | `true`, `false` |
| Array | `[1, 2, 3]` |

```js
let days = 12;
let streakLabel = "day streak";
let isActive = true;
```
$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id
where m.slug = 'javascript-basics' and l.slug = 'variables-and-values'
on conflict do nothing;
