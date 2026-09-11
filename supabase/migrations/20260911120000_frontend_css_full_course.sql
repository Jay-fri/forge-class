-- CSS module expanded from 3 lessons to a full 12-lesson course:
-- selectors, box model, colors/units, typography, flexbox, grid,
-- positioning, pseudo-classes/elements, transitions/animations, custom
-- properties, responsive basics, and a common-layout-patterns capstone
-- lesson. Old combined "selectors-and-the-box-model" and
-- "flexbox-and-grid" lessons are split into their own dedicated lessons.


delete from public.lessons l
using public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug in ('selectors-and-the-box-model', 'flexbox-and-grid');


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Selectors in depth$md$, 'selectors-in-depth', 0, true, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations'
on conflict (module_id, slug) do update set order_index = excluded.order_index, title = excluded.title, is_free_preview = excluded.is_free_preview, status = excluded.status;


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'selectors-in-depth';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Targeting elements with selectors$md$, $md$CSS selectors decide which elements a style applies to.

```css
h1 {
  color: darkorange;
}

.card {
  border: 1px solid gray;
}

#header {
  background: black;
}
```

A tag name (h1) targets every element of that type. A dot (.card) targets a class, which can be reused on many elements. A hash (#header) targets one specific element by its unique id.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'selectors-in-depth';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$Which selector targets every element with class="card"?$md$, '[".card","#card","card","*card"]'::jsonb, 0, $md$A dot prefix, like .card, selects every element that has that class.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'selectors-in-depth' and s.title = $md$Targeting elements with selectors$md$;


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Combinators: targeting relationships between elements$md$, $md$```css
nav a {
  color: white;
}

.card > p {
  margin: 0;
}

h2 + p {
  font-weight: bold;
}
```

A space (nav a) selects any a anywhere inside a nav, no matter how deeply nested. A greater-than sign (.card > p) selects only direct children. A plus sign (h2 + p) selects a p immediately after an h2.$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'selectors-in-depth';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$What does the selector .card > p target?$md$, '["Any p anywhere inside .card, however deeply nested","Only p elements that are direct children of .card","Every p on the page","A p right before .card"]'::jsonb, 1, $md$The > combinator restricts the match to direct children only, not any descendant at any depth.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'selectors-in-depth' and s.title = $md$Combinators: targeting relationships between elements$md$;


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Try it yourself$md$, $md$Change the nav a rule to only target links directly inside the nav, using the > combinator instead of a space.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'selectors-in-depth';


update public.sections s
set sandbox_template = 'static', sandbox_files = jsonb_build_object('/index.html', $md$<style>
  nav a {
    color: blue;
  }
  .card > p {
    font-weight: bold;
  }
</style>
<nav><a href="#">Home</a></nav>
<div class="card"><p>Direct child paragraph</p></div>
$md$)
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'selectors-in-depth' and s.title = $md$Try it yourself$md$;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$The box model$md$, 'the-box-model', 1, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations'
on conflict (module_id, slug) do update set order_index = excluded.order_index, title = excluded.title, is_free_preview = excluded.is_free_preview, status = excluded.status;


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'the-box-model';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Content, padding, border, and margin$md$, $md$Every element on a page is a box, and every box has the same four layers, from the inside out: content, padding, border, and margin.

```css
.box {
  padding: 16px;
  border: 2px solid black;
  margin: 24px;
}
```

Padding is space inside the border, margin is space outside it. Mixing these two up is one of the most common sources of layout confusion when you are starting out.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'the-box-model';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$box-sizing: the setting that changes everything$md$, $md$```css
* {
  box-sizing: border-box;
}

.box {
  width: 200px;
  padding: 20px;
  border: 2px solid black;
}
```

By default, width only sets the content area, so padding and border make the box bigger than 200px. box-sizing: border-box changes width to include padding and border, so the box is always exactly 200px wide. Almost every real project sets this globally.$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'the-box-model';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$With box-sizing: border-box, what does the width property include?$md$, '["Only the content","Content, padding, and border, all together","Only the margin","Nothing, width is ignored"]'::jsonb, 1, $md$border-box makes width represent the total visible box, content plus padding plus border, which is usually what you actually want.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'the-box-model' and s.title = $md$box-sizing: the setting that changes everything$md$;


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Common mistake$md$, $md$**Common mistake:** reaching for margin when you actually want padding, or the other way around.

If you want more breathing room inside a box, between its border and its content, that is padding. If you want more space between one box and the next, that is margin. When a background color looks like it is not filling the whole box the way you expected, check whether you used padding or margin.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'the-box-model';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Try it yourself$md$, $md$Change the padding, margin, and border values and watch how the box size and spacing change.$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'the-box-model';


update public.sections s
set sandbox_template = 'static', sandbox_files = jsonb_build_object('/index.html', $md$<style>
  .box {
    box-sizing: border-box;
    width: 200px;
    padding: 16px;
    border: 2px solid black;
    margin: 24px;
    background: lightyellow;
  }
</style>
<div class="box">Edit my padding, border, and margin</div>
$md$)
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'the-box-model' and s.title = $md$Try it yourself$md$;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Colors and units$md$, 'colors-and-units', 2, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations'
on conflict (module_id, slug) do update set order_index = excluded.order_index, title = excluded.title, is_free_preview = excluded.is_free_preview, status = excluded.status;


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'colors-and-units';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Ways to write a color$md$, $md$```css
.a { color: darkorange; }
.b { color: #d9a75c; }
.c { color: rgb(217, 167, 92); }
.d { color: hsl(35, 60%, 61%); }
```

Named colors (darkorange) are readable but limited. Hex (#d9a75c) is the most common in real projects. rgb() is the same color as three numbers. hsl() (hue, saturation, lightness) is often the easiest to reason about, adjusting lightness alone lightens or darkens a color predictably.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'colors-and-units';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$Which color format makes it easiest to just lighten or darken a color?$md$, '["Named colors","Hex","rgb()","hsl(), by adjusting the lightness value"]'::jsonb, 3, $md$hsl() separates hue, saturation, and lightness, so changing just the lightness percentage predictably lightens or darkens a color.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'colors-and-units' and s.title = $md$Ways to write a color$md$;


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Sizing units: px, %, em, and rem$md$, $md$| Unit | What it means |
|---|---|
| px | An absolute pixel value, does not scale |
| % | Relative to the parent element |
| em | Relative to the current element's font size |
| rem | Relative to the root (html) font size |

```css
html { font-size: 16px; }
.text { font-size: 1.2rem; } /* 19.2px, always relative to the root */
```

rem is usually the safest choice for font sizes and spacing, since it stays consistent no matter how deeply nested an element is, unlike em which compounds with each nested level.$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'colors-and-units';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$Why is rem often preferred over em for font sizes?$md$, '["rem is faster for the browser to calculate","rem is always relative to the root font size, so it does not compound when nested, unlike em","em does not work in modern browsers","There is no real difference"]'::jsonb, 1, $md$em is relative to its own element, so nested elements using em can compound unexpectedly. rem always refers back to the root, staying predictable.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'colors-and-units' and s.title = $md$Sizing units: px, %, em, and rem$md$;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Typography$md$, 'typography', 3, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations'
on conflict (module_id, slug) do update set order_index = excluded.order_index, title = excluded.title, is_free_preview = excluded.is_free_preview, status = excluded.status;


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'typography';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Fonts, weight, and line height$md$, $md$```css
body {
  font-family: "Inter", system-ui, sans-serif;
  font-size: 1rem;
  line-height: 1.6;
}

h1 {
  font-weight: 700;
}
```

font-family takes a list of fallbacks, the browser uses the first one it has available. line-height controls the vertical space a line of text takes up, 1.5 to 1.7 is a comfortable range for body text, tighter than that starts to feel cramped.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'typography';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$What does line-height control?$md$, '["The width of the text container","The font color","The vertical spacing of each line of text","Whether text is bold"]'::jsonb, 2, $md$line-height sets how much vertical space each line of text occupies, directly affecting how readable a paragraph feels.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'typography' and s.title = $md$Fonts, weight, and line height$md$;


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Try it yourself$md$, $md$Change the line-height to 1.2 and see how much more cramped the paragraph feels, then change it back.$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'typography';


update public.sections s
set sandbox_template = 'static', sandbox_files = jsonb_build_object('/index.html', $md$<style>
  body {
    font-family: system-ui, sans-serif;
    line-height: 1.6;
  }
</style>
<p>This is a paragraph long enough to show how line height changes readability across several lines of wrapped text.</p>
$md$)
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'typography' and s.title = $md$Try it yourself$md$;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Flexbox$md$, 'flexbox', 4, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations'
on conflict (module_id, slug) do update set order_index = excluded.order_index, title = excluded.title, is_free_preview = excluded.is_free_preview, status = excluded.status;


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'flexbox';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Laying things out in a row or column$md$, $md$Flexbox arranges items along a single line, a row or a column, and makes spacing them out easy.

```css
.row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 12px;
}
```

display: flex turns on flexbox for a container. justify-content controls spacing along the main direction, align-items controls alignment across it, and gap adds space between items without needing margins on each one.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'flexbox';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$What does justify-content control in a flex container?$md$, '["The text color of items","Spacing and alignment along the main axis (usually horizontal)","The number of items allowed","The border radius of items"]'::jsonb, 1, $md$justify-content controls how items are distributed along the main axis of the flex container.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'flexbox' and s.title = $md$Laying things out in a row or column$md$;


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$flex-direction and wrapping$md$, $md$```css
.column {
  display: flex;
  flex-direction: column;
}

.wrapping-row {
  display: flex;
  flex-wrap: wrap;
}
```

flex-direction: column stacks items vertically instead of the default row. flex-wrap: wrap lets items drop to a new line instead of squeezing or overflowing when there is not enough room.$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'flexbox';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Try it yourself$md$, $md$Change justify-content to center, then to flex-end, and see how the items reposition.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'flexbox';


update public.sections s
set sandbox_template = 'static', sandbox_files = jsonb_build_object('/index.html', $md$<style>
  .row {
    display: flex;
    justify-content: space-between;
    gap: 12px;
  }
  .row div {
    background: lightblue;
    padding: 16px;
  }
</style>
<div class="row">
  <div>1</div>
  <div>2</div>
  <div>3</div>
</div>
$md$)
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'flexbox' and s.title = $md$Try it yourself$md$;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$CSS grid$md$, 'css-grid', 5, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations'
on conflict (module_id, slug) do update set order_index = excluded.order_index, title = excluded.title, is_free_preview = excluded.is_free_preview, status = excluded.status;


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'css-grid';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Laying things out in two dimensions$md$, $md$CSS grid is for layouts that need both rows and columns at once, like a photo gallery or a dashboard.

```css
.gallery {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 12px;
}
```

repeat(3, 1fr) creates three equal-width columns. gap adds space between every item without needing margins on each one.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'css-grid';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$When would grid usually be a better fit than flexbox?$md$, '["When you only need a single row of buttons","When you need a two-dimensional layout, like rows and columns of cards","When you are centering one piece of text","Grid and flexbox are never used differently"]'::jsonb, 1, $md$Flexbox is built for one dimension at a time, a row or a column. Grid is built for controlling rows and columns together.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'css-grid' and s.title = $md$Laying things out in two dimensions$md$;


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Named areas and sizing columns$md$, $md$```css
.layout {
  display: grid;
  grid-template-columns: 200px 1fr;
  grid-template-areas: "sidebar content";
}

.sidebar { grid-area: sidebar; }
.content { grid-area: content; }
```

grid-template-columns: 200px 1fr makes a fixed-width sidebar and a content area that takes up the rest of the space. Named grid areas make a layout easy to read at a glance.$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'css-grid';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Try it yourself$md$, $md$Change grid-template-columns to 2 columns, or add more cards to the gallery.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'css-grid';


update public.sections s
set sandbox_template = 'static', sandbox_files = jsonb_build_object('/index.html', $md$<style>
  .gallery {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 12px;
  }
  .gallery div {
    background: lightgreen;
    padding: 20px;
    text-align: center;
  }
</style>
<div class="gallery">
  <div>1</div>
  <div>2</div>
  <div>3</div>
</div>
$md$)
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'css-grid' and s.title = $md$Try it yourself$md$;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Positioning$md$, 'positioning', 6, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations'
on conflict (module_id, slug) do update set order_index = excluded.order_index, title = excluded.title, is_free_preview = excluded.is_free_preview, status = excluded.status;


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'positioning';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$static, relative, absolute, and fixed$md$, $md$```css
.relative-box {
  position: relative;
  top: 10px;
}

.absolute-box {
  position: absolute;
  top: 0;
  right: 0;
}

.fixed-box {
  position: fixed;
  bottom: 16px;
  right: 16px;
}
```

static is the default, no special positioning. relative shifts an element from where it would normally sit, while still reserving that original space. absolute removes it from the normal flow entirely, positioning it against its nearest positioned ancestor. fixed positions it relative to the browser window, staying in place even while scrolling.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'positioning';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$What does position: absolute position an element relative to?$md$, '["Always the browser window","Its nearest ancestor that has a position other than static","The element own original position","The center of the page, always"]'::jsonb, 1, $md$An absolutely positioned element is placed relative to its closest ancestor with a non-static position (often position: relative), not the whole page.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'positioning' and s.title = $md$static, relative, absolute, and fixed$md$;


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$sticky positioning$md$, $md$```css
.sticky-header {
  position: sticky;
  top: 0;
}
```

sticky acts like static until the page scrolls past it, then it sticks in place, like a table header that stays visible while you scroll through rows.$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'positioning';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Pseudo-classes and pseudo-elements$md$, 'pseudo-classes-and-elements', 7, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations'
on conflict (module_id, slug) do update set order_index = excluded.order_index, title = excluded.title, is_free_preview = excluded.is_free_preview, status = excluded.status;


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'pseudo-classes-and-elements';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Styling states with pseudo-classes$md$, $md$```css
button:hover {
  opacity: 0.9;
}

input:focus {
  border-color: blue;
}

li:nth-child(2) {
  font-weight: bold;
}
```

A pseudo-class, starting with a single colon, targets an element in a particular state or position: hover (mouse over it), focus (currently selected), or nth-child (its position among siblings).$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'pseudo-classes-and-elements';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$What does the :hover pseudo-class target?$md$, '["Every element on the page","An element while the mouse is over it","An element that has been clicked once","The first element in a list"]'::jsonb, 1, $md$:hover applies its styles only while the pointer is currently over that element.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'pseudo-classes-and-elements' and s.title = $md$Styling states with pseudo-classes$md$;


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Adding content with pseudo-elements$md$, $md$```css
.quote::before {
  content: "\201C";
}

.quote::after {
  content: "\201D";
}
```

A pseudo-element, starting with a double colon, targets a specific part of an element rather than a state. ::before and ::after insert generated content immediately before or after an element's actual content, often used for decorative quotes, icons, or small flourishes.$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'pseudo-classes-and-elements';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$What is the difference between a pseudo-class and a pseudo-element?$md$, '["There is no difference, they are the same thing","A pseudo-class targets a state or position (like :hover), a pseudo-element targets a specific part of an element (like ::before)","Pseudo-elements only work on images","Pseudo-classes require JavaScript"]'::jsonb, 1, $md$Pseudo-classes (single colon) select elements based on state or position. Pseudo-elements (double colon) let you style or insert content at a specific part of an element.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'pseudo-classes-and-elements' and s.title = $md$Adding content with pseudo-elements$md$;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Transitions and animations$md$, 'transitions-and-animations', 8, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations'
on conflict (module_id, slug) do update set order_index = excluded.order_index, title = excluded.title, is_free_preview = excluded.is_free_preview, status = excluded.status;


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'transitions-and-animations';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Smoothing a change with transition$md$, $md$```css
.button {
  background: darkorange;
  transition: background 0.2s ease;
}

.button:hover {
  background: orangered;
}
```

Without transition, a hover color change happens instantly. transition tells the browser to animate the change smoothly over the given duration instead of snapping.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'transitions-and-animations';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$What does the transition property do?$md$, '["Deletes an element after a delay","Smoothly animates a property change over a duration, instead of it happening instantly","Changes an element to a different HTML tag","Only works on background-color"]'::jsonb, 1, $md$transition animates the change of a CSS property over time, so a hover effect (for example) eases in instead of snapping instantly.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'transitions-and-animations' and s.title = $md$Smoothing a change with transition$md$;


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Custom animations with @keyframes$md$, $md$```css
@keyframes fade-in {
  from { opacity: 0; }
  to { opacity: 1; }
}

.card {
  animation: fade-in 0.4s ease;
}
```

@keyframes defines a named sequence of steps an animation moves through. animation then applies that sequence to an element, here fading it in over 0.4 seconds when it appears.$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'transitions-and-animations';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$CSS custom properties$md$, 'css-custom-properties', 9, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations'
on conflict (module_id, slug) do update set order_index = excluded.order_index, title = excluded.title, is_free_preview = excluded.is_free_preview, status = excluded.status;


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'css-custom-properties';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Reusable values with variables$md$, $md$```css
:root {
  --accent-color: #d9a75c;
  --spacing: 16px;
}

.button {
  background: var(--accent-color);
  padding: var(--spacing);
}
```

A custom property (CSS variable) starts with two dashes and is usually defined on :root so it is available everywhere. var() reads it back. Change the value once, and everywhere that uses it updates, exactly the same idea as a variable in JavaScript.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'css-custom-properties';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$What is the main benefit of a CSS custom property like --accent-color?$md$, '["It makes the page load faster","Changing its value in one place updates every rule that uses it","It only works in one specific browser","It replaces the need for any other CSS"]'::jsonb, 1, $md$A custom property centralizes a value, so updating it in :root immediately updates every rule across the whole stylesheet that references it with var().$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'css-custom-properties' and s.title = $md$Reusable values with variables$md$;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Responsive basics$md$, 'responsive-basics', 10, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations'
on conflict (module_id, slug) do update set order_index = excluded.order_index, title = excluded.title, is_free_preview = excluded.is_free_preview, status = excluded.status;


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'responsive-basics';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Making a layout work on any screen$md$, $md$A responsive layout adjusts itself for different screen sizes instead of looking broken on a phone.

```css
.gallery {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 12px;
}

@media (max-width: 600px) {
  .gallery {
    grid-template-columns: 1fr;
  }
}
```

A media query, @media (max-width: 600px), applies its styles only when the screen is at or below that width, so you can redesign a layout for phones without touching the desktop version.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'responsive-basics';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$What does @media (max-width: 600px) do?$md$, '["Deletes the element on small screens","Applies its styles only when the screen is 600px wide or narrower","Sets a fixed width of 600px on every screen","Only works in one specific browser"]'::jsonb, 1, $md$A max-width media query applies its rules only below that width, letting a layout adapt for phones without affecting wider screens.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'responsive-basics' and s.title = $md$Making a layout work on any screen$md$;


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Try it yourself$md$, $md$Change the breakpoint to 900px, or make it 2 columns on medium screens instead of jumping straight to 1.$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'responsive-basics';


update public.sections s
set sandbox_template = 'static', sandbox_files = jsonb_build_object('/index.html', $md$<style>
  .gallery {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 12px;
  }
  .gallery div {
    background: lightgreen;
    padding: 20px;
    text-align: center;
  }
  @media (max-width: 600px) {
    .gallery {
      grid-template-columns: 1fr;
    }
  }
</style>
<div class="gallery">
  <div>1</div>
  <div>2</div>
  <div>3</div>
</div>
$md$)
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'responsive-basics' and s.title = $md$Try it yourself$md$;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Common layout patterns$md$, 'common-layout-patterns', 11, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations'
on conflict (module_id, slug) do update set order_index = excluded.order_index, title = excluded.title, is_free_preview = excluded.is_free_preview, status = excluded.status;


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'common-layout-patterns';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Centering a box, the modern way$md$, $md$```css
.center {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
}
```

Centering used to be a famous CSS headache. With flexbox, centering both horizontally and vertically is just two lines.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'common-layout-patterns';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$What two flexbox properties center content both horizontally and vertically?$md$, '["margin and padding","justify-content and align-items","width and height","color and background"]'::jsonb, 1, $md$On a flex container, justify-content centers along the main axis and align-items centers across it, together centering content in both directions.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'common-layout-patterns' and s.title = $md$Centering a box, the modern way$md$;


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$A card grid, put together$md$, $md$```css
.cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
  gap: 16px;
}
```

auto-fit with minmax(220px, 1fr) is a common real-world pattern: as many columns as fit at a minimum of 220px each, automatically reflowing as the screen resizes, no media query needed for this part.$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'common-layout-patterns';
