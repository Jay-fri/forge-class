-- Embeds courses/course-css.md verbatim as the Frontend track's CSS
-- portion, replacing the earlier self-authored 'css-foundations' module
-- with the real course content's own 4-module structure. Content
-- preserved as-written. Inserted as draft; published after structural
-- verification against the source file.


delete from public.modules m
using public.tracks t
where m.track_id = t.id and t.slug = 'frontend' and m.slug = 'css-foundations';


update public.modules m set order_index = m.order_index + 3
from public.tracks t
where m.track_id = t.id and t.slug = 'frontend'
  and m.slug in ('javascript-fundamentals-recap', 'putting-pages-together', 'intro-to-react');


insert into public.modules (track_id, name, slug, order_index)
select t.id, $md$What CSS Is$md$, 'what-css-is', 6
from public.tracks t where t.slug = 'frontend'
on conflict (track_id, slug) do update set order_index = excluded.order_index, name = excluded.name;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$What is CSS?$md$, 'what-is-css', 0, true, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'what-css-is'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$CSS stands for Cascading Style Sheets. If HTML is the skeleton of a page, CSS is the skin, clothes, and makeup — it controls colors, fonts, spacing, and layout, without changing the actual content.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'what-css-is' and l.slug = 'what-is-css';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```html
<p style="color: blue;">This text is blue.</p>
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'what-css-is' and l.slug = 'what-is-css';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Change "blue" to another color name like "red" or "green."$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'what-css-is' and l.slug = 'what-is-css';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'what-css-is' and l.slug = 'what-is-css';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does CSS control?$md$, $md$["The content of a page","The appearance and layout of a page","The page's database","What links point to"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'what-css-is' and l.slug = 'what-is-css' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Confusing HTML tags with CSS properties — `<p>` is HTML (structure), `color: blue` is CSS (style). They work together but are different things.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'what-css-is' and l.slug = 'what-is-css';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Connecting CSS to HTML (selectors)$md$, 'connecting-css-to-html-selectors', 1, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'what-css-is'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Instead of styling one element at a time with `style=""`, real CSS lives separately and uses **selectors** to target elements — like saying "all paragraphs" or "the element with this specific name."$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'what-css-is' and l.slug = 'connecting-css-to-html-selectors';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```css
p {
  color: blue;
}
```
This one rule styles *every* paragraph on the page.$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'what-css-is' and l.slug = 'connecting-css-to-html-selectors';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Write a selector rule that makes all `h1` headings a color of your choice.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'what-css-is' and l.slug = 'connecting-css-to-html-selectors';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'what-css-is' and l.slug = 'connecting-css-to-html-selectors';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does the selector p target?$md$, $md$["One specific paragraph","Every <p> element on the page","Every element named \"p\"","Nothing without more code"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'what-css-is' and l.slug = 'connecting-css-to-html-selectors' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Forgetting the curly braces `{ }` around the styles — CSS rules always need them, and semicolons `;` after each property.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'what-css-is' and l.slug = 'connecting-css-to-html-selectors';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Colors, fonts, and text styling$md$, 'colors-fonts-and-text-styling', 2, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'what-css-is'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Common text properties: `color` (text color), `font-size`, `font-family` (which typeface), and `font-weight` (how bold).$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'what-css-is' and l.slug = 'colors-fonts-and-text-styling';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```css
h1 {
  color: darkgreen;
  font-size: 32px;
  font-family: Arial, sans-serif;
}
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'what-css-is' and l.slug = 'colors-fonts-and-text-styling';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Style your page's `h1` with a custom color, size, and font.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'what-css-is' and l.slug = 'colors-fonts-and-text-styling';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'what-css-is' and l.slug = 'colors-fonts-and-text-styling';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does font-size: 32px control?$md$, $md$["The color of the text","How large the text appears","The font's name","The line spacing"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'what-css-is' and l.slug = 'colors-fonts-and-text-styling' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Forgetting units on sizes — writing `font-size: 32` instead of `32px` will often be ignored by the browser.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'what-css-is' and l.slug = 'colors-fonts-and-text-styling';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Assignment 1$md$, $md$Take your HTML profile page and add a CSS section that changes the color and font of your heading and paragraph text.

**Pass criteria:** at least 3 different CSS properties used correctly.$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'what-css-is';


insert into public.modules (track_id, name, slug, order_index)
select t.id, $md$Layout Fundamentals$md$, 'layout-fundamentals', 7
from public.tracks t where t.slug = 'frontend'
on conflict (track_id, slug) do update set order_index = excluded.order_index, name = excluded.name;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$The box model$md$, 'the-box-model', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'layout-fundamentals'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Every HTML element is secretly a rectangular box with four layers, from the inside out: **content** → **padding** (space inside the border) → **border** → **margin** (space outside the border, between elements).$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'layout-fundamentals' and l.slug = 'the-box-model';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```css
div {
  padding: 16px;
  border: 2px solid black;
  margin: 20px;
}
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'layout-fundamentals' and l.slug = 'the-box-model';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Add padding and a border to a paragraph and see the space appear around the text.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'layout-fundamentals' and l.slug = 'the-box-model';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'layout-fundamentals' and l.slug = 'the-box-model';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What's the difference between padding and margin?$md$, $md$["No difference","Padding is inside the border, margin is outside it","Padding is for text only","Margin only works on images"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'layout-fundamentals' and l.slug = 'the-box-model' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Confusing padding and margin when trying to add space — if the *content itself* looks cramped, you want padding; if elements are too close to *each other*, you want margin.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'layout-fundamentals' and l.slug = 'the-box-model';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Flexbox layout$md$, 'flexbox-layout', 1, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'layout-fundamentals'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Flexbox arranges items in a row or column and makes spacing/alignment easy. You turn a container into a "flex container," and its children line up automatically.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'layout-fundamentals' and l.slug = 'flexbox-layout';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```css
.container {
  display: flex;
  gap: 12px;
}
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'layout-fundamentals' and l.slug = 'flexbox-layout';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Wrap three of your elements in a container and apply `display: flex` to line them up side by side.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'layout-fundamentals' and l.slug = 'flexbox-layout';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'layout-fundamentals' and l.slug = 'flexbox-layout';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does display: flex do to a container's children?$md$, $md$["Hides them","Arranges them in a flexible row or column","Deletes extra spacing","Makes them bold"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'layout-fundamentals' and l.slug = 'flexbox-layout' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Applying `display: flex` to the wrong element — it affects how a container arranges its *children*, not how the container itself looks.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'layout-fundamentals' and l.slug = 'flexbox-layout';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Grid layout$md$, 'grid-layout', 2, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'layout-fundamentals'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Grid is Flexbox's sibling for two-dimensional layouts — rows *and* columns at once, useful for things like photo galleries or dashboards.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'layout-fundamentals' and l.slug = 'grid-layout';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```css
.gallery {
  display: grid;
  grid-template-columns: 1fr 1fr 1fr;
  gap: 10px;
}
```
This creates 3 equal-width columns.$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'layout-fundamentals' and l.slug = 'grid-layout';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Change `1fr 1fr 1fr` to `1fr 1fr` and see it become 2 columns instead.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'layout-fundamentals' and l.slug = 'grid-layout';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'layout-fundamentals' and l.slug = 'grid-layout';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does grid-template-columns: 1fr 1fr 1fr create?$md$, $md$["One column","Three equal-width columns","Three rows","A single box"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'layout-fundamentals' and l.slug = 'grid-layout' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Using Grid when Flexbox would be simpler — Grid shines for full layouts (rows + columns together); Flexbox is usually enough for a single row or column of items.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'layout-fundamentals' and l.slug = 'grid-layout';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Assignment 2$md$, $md$Rebuild your profile page's list of skills as a flex row of "cards" (small boxes with padding and a border, spaced with `gap`).

**Pass criteria:** uses flexbox correctly, spacing looks intentional.$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'layout-fundamentals';


insert into public.modules (track_id, name, slug, order_index)
select t.id, $md$Responsive Basics$md$, 'responsive-basics', 8
from public.tracks t where t.slug = 'frontend'
on conflict (track_id, slug) do update set order_index = excluded.order_index, name = excluded.name;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Why phones need different styling$md$, 'why-phones-need-different-styling', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'responsive-basics'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$A layout that looks great on a laptop screen can break on a phone — three columns squished into a small screen becomes unreadable. Responsive design means adjusting styles based on screen size.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'responsive-basics' and l.slug = 'why-phones-need-different-styling';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$The fix is a **media query** — a CSS rule that only applies under certain conditions, like "screen is narrower than 600px."$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'responsive-basics' and l.slug = 'why-phones-need-different-styling';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```css
@media (max-width: 600px) {
  .gallery {
    grid-template-columns: 1fr;
  }
}
```
This switches the gallery to a single column on small screens.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'responsive-basics' and l.slug = 'why-phones-need-different-styling';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Add a media query that changes your heading's font size on small screens.$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'responsive-basics' and l.slug = 'why-phones-need-different-styling';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'responsive-basics' and l.slug = 'why-phones-need-different-styling';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does @media (max-width: 600px) mean?$md$, $md$["The screen must be exactly 600px","The rule only applies when the screen is 600px wide or narrower","It only works on phones specifically","It disables the layout entirely"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'responsive-basics' and l.slug = 'why-phones-need-different-styling' and s.order_index = 4;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Writing responsive styles as an afterthought instead of testing on a narrow screen as you go — issues are much easier to catch early.$md$, 5
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'responsive-basics' and l.slug = 'why-phones-need-different-styling';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Assignment 3 (Capstone)$md$, $md$Take your full HTML profile page and fully style it with CSS: colors, fonts, spacing (box model), a flexbox or grid layout for your skills/interests section, and at least one media query so it adapts on a narrow screen.

**Pass criteria:** page looks intentionally designed, layout doesn't break on a small screen width, uses box model + flex/grid + a media query correctly.$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'responsive-basics';


insert into public.modules (track_id, name, slug, order_index)
select t.id, $md$Positioning, States & Polish$md$, 'positioning-states-and-polish', 9
from public.tracks t where t.slug = 'frontend'
on conflict (track_id, slug) do update set order_index = excluded.order_index, name = excluded.name;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Positioning$md$, 'positioning', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'positioning-states-and-polish'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$The `position` property controls how an element is placed. `static` (default, normal flow), `relative` (shifted from its normal spot), `absolute` (positioned relative to the nearest positioned ancestor), `fixed` (stays put on scroll), `sticky` (normal until a scroll point, then fixed).$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'positioning-states-and-polish' and l.slug = 'positioning';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```css
.badge {
  position: absolute;
  top: 10px;
  right: 10px;
}
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'positioning-states-and-polish' and l.slug = 'positioning';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Position a small "New" badge in the corner of a card element.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'positioning-states-and-polish' and l.slug = 'positioning';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'positioning-states-and-polish' and l.slug = 'positioning';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$Which position value keeps an element fixed on screen even while scrolling?$md$, $md$["static","fixed","relative","inherit"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'positioning-states-and-polish' and l.slug = 'positioning' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Using `position: absolute` without a positioned parent (`position: relative` on the parent) — the element ends up positioned relative to the whole page instead of the intended container.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'positioning-states-and-polish' and l.slug = 'positioning';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Pseudo-classes and pseudo-elements$md$, 'pseudo-classes-and-pseudo-elements', 1, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'positioning-states-and-polish'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Pseudo-classes target an element's *state* (like `:hover` when a mouse is over it). Pseudo-elements target a *part* of an element (like `::before` to insert content).$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'positioning-states-and-polish' and l.slug = 'pseudo-classes-and-pseudo-elements';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```css
button:hover {
  background: darkblue;
}
li:nth-child(2) {
  color: red;
}
p::before {
  content: "→ ";
}
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'positioning-states-and-polish' and l.slug = 'pseudo-classes-and-pseudo-elements';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Add a `:hover` style that changes a button's color when moused over.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'positioning-states-and-polish' and l.slug = 'pseudo-classes-and-pseudo-elements';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'positioning-states-and-polish' and l.slug = 'pseudo-classes-and-pseudo-elements';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does :hover target?$md$, $md$["Every element on the page","An element while the mouse is over it","An element after it's clicked","The page's background only"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'positioning-states-and-polish' and l.slug = 'pseudo-classes-and-pseudo-elements' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Confusing single colon (`:hover`, a state) with double colon (`::before`, a generated part) — modern CSS distinguishes them, though browsers are often lenient about it.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'positioning-states-and-polish' and l.slug = 'pseudo-classes-and-pseudo-elements';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$CSS variables$md$, 'css-variables', 2, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'positioning-states-and-polish'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$CSS custom properties (variables) let you define a value once and reuse it everywhere — extremely useful for a consistent color palette.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'positioning-states-and-polish' and l.slug = 'css-variables';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```css
:root {
  --accent-color: #D9A75C;
}
button {
  background: var(--accent-color);
}
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'positioning-states-and-polish' and l.slug = 'css-variables';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Define a variable for your page's main accent color and use it in 2 different places.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'positioning-states-and-polish' and l.slug = 'css-variables';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'positioning-states-and-polish' and l.slug = 'css-variables';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$Where are CSS variables typically defined for global use?$md$, $md$["Inside every single element","On :root, so they're available everywhere","Only in the <head>","They can't be reused"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'positioning-states-and-polish' and l.slug = 'css-variables' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Forgetting the `--` prefix when defining a variable, or forgetting `var()` when using it — both are required syntax.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'positioning-states-and-polish' and l.slug = 'css-variables';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Transitions and basic animation$md$, 'transitions-and-basic-animation', 3, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'positioning-states-and-polish'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$`transition` smoothly animates a property change (like a color shift on hover) instead of it happening instantly.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'positioning-states-and-polish' and l.slug = 'transitions-and-basic-animation';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```css
button {
  background: gray;
  transition: background 0.3s ease;
}
button:hover {
  background: darkblue;
}
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'positioning-states-and-polish' and l.slug = 'transitions-and-basic-animation';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Add a smooth transition to a card's shadow or scale when hovered.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'positioning-states-and-polish' and l.slug = 'transitions-and-basic-animation';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'positioning-states-and-polish' and l.slug = 'transitions-and-basic-animation';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does transition: background 0.3s ease; do?$md$, $md$["Instantly changes the background","Smoothly animates background color changes over 0.3 seconds","Deletes the background","Only works on hover"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'positioning-states-and-polish' and l.slug = 'transitions-and-basic-animation' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Putting the `transition` property only on `:hover` instead of the base state — this makes it transition smoothly *in* but snap back instantly when the hover ends.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'positioning-states-and-polish' and l.slug = 'transitions-and-basic-animation';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Units in depth$md$, 'units-in-depth', 4, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'positioning-states-and-polish'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$`px` is a fixed size. `%` is relative to the parent. `rem` is relative to the root font size (great for consistent, accessible scaling). `vh`/`vw` are relative to the viewport size — useful for full-screen sections.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'positioning-states-and-polish' and l.slug = 'units-in-depth';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$**Concept table:**

| Unit | Relative to |
|---|---|
| `px` | Nothing — fixed |
| `%` | Parent element |
| `rem` | Root font size |
| `vh`/`vw` | Viewport height/width |$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'positioning-states-and-polish' and l.slug = 'units-in-depth';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Change your page's font sizes from `px` to `rem` and see if anything looks different.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'positioning-states-and-polish' and l.slug = 'units-in-depth';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'positioning-states-and-polish' and l.slug = 'units-in-depth';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$Which unit is best for a section that should always be the full height of the screen?$md$, $md$["px","vh","%","rem"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'positioning-states-and-polish' and l.slug = 'units-in-depth' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Using `px` for everything out of habit — it works, but `rem` scales better when a user changes their browser's default font size (an accessibility consideration).$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'positioning-states-and-polish' and l.slug = 'units-in-depth';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Specificity and the cascade$md$, 'specificity-and-the-cascade', 5, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'positioning-states-and-polish'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$When multiple CSS rules target the same element, specificity decides which one "wins." Roughly, in order of increasing power: element selectors → class selectors → ID selectors → inline styles.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'positioning-states-and-polish' and l.slug = 'specificity-and-the-cascade';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```css
p { color: blue; }
.highlight { color: red; }
```
An element with `class="highlight"` shows red — the class selector is more specific than the plain element selector.$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'positioning-states-and-polish' and l.slug = 'specificity-and-the-cascade';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Create two conflicting rules for the same element and predict which one wins before checking.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'positioning-states-and-polish' and l.slug = 'specificity-and-the-cascade';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'positioning-states-and-polish' and l.slug = 'specificity-and-the-cascade';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$Which is generally more specific: a class selector or an element selector?$md$, $md$["Element selector","Class selector","They're equal","Depends on the file order only"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'positioning-states-and-polish' and l.slug = 'specificity-and-the-cascade' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Reaching for `!important` to force a style to win instead of understanding *why* it's losing — `!important` overrides everything and makes future debugging much harder; use it as a last resort, not a first fix.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'positioning-states-and-polish' and l.slug = 'specificity-and-the-cascade';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Assignment 4$md$, $md$Take your Module 3 capstone page and add: a hover effect with a transition on at least one element, a CSS variable for your color palette used in at least 3 places, and fix any layout using `rem` instead of `px` for font sizes.

**Pass criteria:** hover transition is smooth, variables are used correctly, sizing uses rem appropriately.$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'positioning-states-and-polish';

-- Verified structurally against the source file before publishing.
update public.lessons l set status = 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'frontend'
  and m.slug in ('what-css-is', 'layout-fundamentals', 'responsive-basics', 'positioning-states-and-polish');
