-- Embeds courses/course-html.md verbatim as the Frontend track's HTML
-- portion, replacing the earlier self-authored 'html-foundations' module
-- with the real, reviewed course content's own 6-module structure. Content
-- preserved as-written; only structural mapping (module/lesson/section
-- boundaries, section_type tags, quiz options, assignment specs) is new.
-- Inserted as draft; a follow-up statement flips it to published once
-- rendering is verified.


delete from public.modules m
using public.tracks t
where m.track_id = t.id and t.slug = 'frontend' and m.slug = 'html-foundations';


update public.modules m set order_index = m.order_index + 5
from public.tracks t
where m.track_id = t.id and t.slug = 'frontend'
  and m.slug in ('css-foundations', 'javascript-fundamentals-recap', 'putting-pages-together', 'intro-to-react');


insert into public.modules (track_id, name, slug, order_index)
select t.id, $md$What HTML Is$md$, 'what-html-is', 0
from public.tracks t where t.slug = 'frontend'
on conflict (track_id, slug) do update set order_index = excluded.order_index, name = excluded.name;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$What is HTML?$md$, 'what-is-html', 0, true, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'what-html-is'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$HTML stands for HyperText Markup Language. It's not a programming language — it's a markup language, meaning it describes the *structure* of a page: what's a heading, what's a paragraph, what's a list. Every website you've ever visited has HTML underneath it.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'what-html-is' and l.slug = 'what-is-html';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```html
<h1>Hello, World</h1>
```
This tells the browser: "this text is a big heading."$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'what-html-is' and l.slug = 'what-is-html';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Change "Hello, World" to your own name and see it appear.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'what-html-is' and l.slug = 'what-is-html';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'what-html-is' and l.slug = 'what-is-html';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does HTML mainly describe?$md$, $md$["How a page looks (colors, fonts)","The structure and content of a page","How a page behaves when clicked","How fast a page loads"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'what-html-is' and l.slug = 'what-is-html' and s.section_type = 'check_in';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Typing `<H1>` in uppercase works too (HTML tags aren't case-sensitive), but lowercase is the standard everyone uses — mixing cases makes code harder to read, not broken.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'what-html-is' and l.slug = 'what-is-html';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$What can HTML actually do?$md$, 'what-can-html-actually-do', 1, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'what-html-is'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$HTML lets you add: text (headings, paragraphs), lists, images, links to other pages, forms (like sign-up boxes), tables, and more. Anything you *see* as content on a page — HTML put it there.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'what-html-is' and l.slug = 'what-can-html-actually-do';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```html
<h1>My Page</h1>
<p>This is a paragraph of text.</p>
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'what-html-is' and l.slug = 'what-can-html-actually-do';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Add a second paragraph below the first one.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'what-html-is' and l.slug = 'what-can-html-actually-do';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'what-html-is' and l.slug = 'what-can-html-actually-do';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$Which of these is something HTML can create?$md$, $md$["A list of items","A button's click animation","A page's background color","A database"]$md$::jsonb, 0, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'what-html-is' and l.slug = 'what-can-html-actually-do' and s.section_type = 'check_in';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Forgetting that HTML alone can't make a page colorful or animated — that's CSS and JavaScript's job. HTML is just structure.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'what-html-is' and l.slug = 'what-can-html-actually-do';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$What is a tag?$md$, 'what-is-a-tag', 2, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'what-html-is'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$A tag is the smallest building block of HTML. It's a keyword wrapped in angle brackets, like `<p>`. Most tags come in pairs — an opening tag `<p>` and a closing tag `</p>` — with your content sandwiched between them.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'what-html-is' and l.slug = 'what-is-a-tag';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```html
<p>This whole sentence is inside a paragraph tag.</p>
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'what-html-is' and l.slug = 'what-is-a-tag';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Wrap any sentence of your own in `<p>` and `</p>`.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'what-html-is' and l.slug = 'what-is-a-tag';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'what-html-is' and l.slug = 'what-is-a-tag';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What's the difference between <p> and </p>?$md$, $md$["No difference","<p> opens the tag, </p> closes it","<p> is for paragraphs, </p> is for pages","</p> is optional and never needed"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'what-html-is' and l.slug = 'what-is-a-tag' and s.section_type = 'check_in';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Forgetting the closing tag. The browser often still displays something, but everything after it can end up nested inside by accident — always close what you open.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'what-html-is' and l.slug = 'what-is-a-tag';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Examples of tags$md$, 'examples-of-tags', 3, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'what-html-is'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Here's a quick reference table of common tags you'll use constantly:

| Tag | What it's for |
|---|---|
| `<h1>` to `<h6>` | Headings, h1 = biggest |
| `<p>` | Paragraph |
| `<a>` | Link |
| `<img>` | Image |
| `<ul>` / `<ol>` | Lists |$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'what-html-is' and l.slug = 'examples-of-tags';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```html
<h1>My Recipe Blog</h1>
<p>Welcome to my blog about cooking.</p>
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'what-html-is' and l.slug = 'examples-of-tags';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Build a mini page with one heading and two paragraphs.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'what-html-is' and l.slug = 'examples-of-tags';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'what-html-is' and l.slug = 'examples-of-tags';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$Which tag makes the biggest heading?$md$, $md$["<h6>","<h1>","<p>","<big>"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'what-html-is' and l.slug = 'examples-of-tags' and s.section_type = 'check_in';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Using `<h1>` for every heading on a page because it looks bold — headings should go in size order (h1 → h2 → h3) to describe importance, not just appearance.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'what-html-is' and l.slug = 'examples-of-tags';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Assignment 1$md$, $md$Build a simple page with one `<h1>` heading and three `<p>` paragraphs introducing yourself.

**Pass criteria:** valid tags, properly opened and closed, content makes sense.$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'what-html-is';


insert into public.modules (track_id, name, slug, order_index)
select t.id, $md$Structuring Text$md$, 'structuring-text', 1
from public.tracks t where t.slug = 'frontend'
on conflict (track_id, slug) do update set order_index = excluded.order_index, name = excluded.name;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Headings$md$, 'headings', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'structuring-text'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Headings (`<h1>` through `<h6>`) create a hierarchy — like a book's chapter and section titles. `<h1>` is the main title of a page, and you should generally only use one per page.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'structuring-text' and l.slug = 'headings';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```html
<h1>My Website</h1>
<h2>About Me</h2>
<h3>My Hobbies</h3>
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'structuring-text' and l.slug = 'headings';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Create a heading structure for a page about your favorite hobby.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'structuring-text' and l.slug = 'headings';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'structuring-text' and l.slug = 'headings';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$How many <h1> tags should a typical page have?$md$, $md$["As many as you want","Usually just one","Exactly six","Zero"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'structuring-text' and l.slug = 'headings' and s.section_type = 'check_in';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Skipping heading levels (going from h1 straight to h4) — it breaks the logical structure even if it still looks fine visually.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'structuring-text' and l.slug = 'headings';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Paragraphs and basic text$md$, 'paragraphs-and-basic-text', 1, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'structuring-text'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$The `<p>` tag holds regular text. Inside a paragraph, you can also make text **bold** with `<strong>` or *italic* with `<em>`.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'structuring-text' and l.slug = 'paragraphs-and-basic-text';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```html
<p>This is <strong>important</strong> and this is <em>emphasized</em>.</p>
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'structuring-text' and l.slug = 'paragraphs-and-basic-text';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Write a paragraph about your day, bolding one word and italicizing another.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'structuring-text' and l.slug = 'paragraphs-and-basic-text';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'structuring-text' and l.slug = 'paragraphs-and-basic-text';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$Which tag makes text bold?$md$, $md$["<b-text>","<strong>","<bold>","<h1>"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'structuring-text' and l.slug = 'paragraphs-and-basic-text' and s.section_type = 'check_in';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Pressing Enter/adding blank lines in your HTML code to create spacing — the browser ignores extra line breaks and spaces. You need actual tags to control layout.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'structuring-text' and l.slug = 'paragraphs-and-basic-text';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Lists$md$, 'lists', 2, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'structuring-text'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Two types of lists: `<ul>` (unordered, bullet points) and `<ol>` (ordered, numbered). Each item inside goes in an `<li>` tag.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'structuring-text' and l.slug = 'lists';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```html
<ul>
  <li>Milk</li>
  <li>Eggs</li>
  <li>Bread</li>
</ul>
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'structuring-text' and l.slug = 'lists';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Make an `<ol>` numbered list of your top 3 favorite movies.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'structuring-text' and l.slug = 'lists';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'structuring-text' and l.slug = 'lists';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What tag goes inside <ul> or <ol> for each item?$md$, $md$["<item>","<li>","<list>","<p>"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'structuring-text' and l.slug = 'lists' and s.section_type = 'check_in';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Putting text directly inside `<ul>` without wrapping each item in `<li>` — the list won't display correctly.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'structuring-text' and l.slug = 'lists';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Assignment 2$md$, $md$Build a page with a heading structure (h1 + h2), two paragraphs with at least one bold and one italic word, and a bulleted list of 4 items.

**Pass criteria:** correct tag usage, sensible heading hierarchy.$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'structuring-text';


insert into public.modules (track_id, name, slug, order_index)
select t.id, $md$Links, Images, Structure & Forms$md$, 'links-images-structure-and-forms', 2
from public.tracks t where t.slug = 'frontend'
on conflict (track_id, slug) do update set order_index = excluded.order_index, name = excluded.name;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Links and images$md$, 'links-and-images', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'links-images-structure-and-forms'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$The `<a>` tag creates a clickable link, using `href` to say where it goes. The `<img>` tag displays a picture, using `src` to say which file.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'links-images-structure-and-forms' and l.slug = 'links-and-images';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```html
<a href="https://example.com">Visit this site</a>
<img src="cat.jpg" alt="A photo of a cat">
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'links-images-structure-and-forms' and l.slug = 'links-and-images';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Add a link to your favorite website and an image (any image URL).$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'links-images-structure-and-forms' and l.slug = 'links-and-images';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'links-images-structure-and-forms' and l.slug = 'links-and-images';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does alt do on an <img> tag?$md$, $md$["Makes the image bigger","Describes the image for accessibility and if it fails to load","Adds a border","Nothing important"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'links-images-structure-and-forms' and l.slug = 'links-and-images' and s.section_type = 'check_in';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Forgetting `<img>` doesn't need a closing tag like `</img>` — it's self-contained. Writing `</img>` isn't necessary and can confuse things.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'links-images-structure-and-forms' and l.slug = 'links-and-images';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Basic page structure$md$, 'basic-page-structure', 1, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'links-images-structure-and-forms'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Now that tags feel familiar, every real HTML page follows this skeleton: `<html>` wraps everything, `<head>` holds page info (like the title, invisible on the page itself), and `<body>` holds everything visible.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'links-images-structure-and-forms' and l.slug = 'basic-page-structure';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```html
<!DOCTYPE html>
<html>
  <head>
    <title>My Page</title>
  </head>
  <body>
    <h1>Welcome</h1>
  </body>
</html>
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'links-images-structure-and-forms' and l.slug = 'basic-page-structure';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Wrap everything you've built so far in this skeleton.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'links-images-structure-and-forms' and l.slug = 'basic-page-structure';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'links-images-structure-and-forms' and l.slug = 'basic-page-structure';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$Where does visible page content go?$md$, $md$["<head>","<body>","<title>","<!DOCTYPE html>"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'links-images-structure-and-forms' and l.slug = 'basic-page-structure' and s.section_type = 'check_in';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Putting visible content like `<h1>` inside `<head>` by accident — it won't show up on the page at all.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'links-images-structure-and-forms' and l.slug = 'basic-page-structure';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Forms basics$md$, 'forms-basics', 2, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'links-images-structure-and-forms'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Forms collect input from users — like a sign-up box. The `<form>` tag wraps input fields, and `<input>` creates a text box, checkbox, or button depending on its `type`.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'links-images-structure-and-forms' and l.slug = 'forms-basics';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```html
<form>
  <input type="text" placeholder="Your name">
  <input type="submit" value="Send">
</form>
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'links-images-structure-and-forms' and l.slug = 'forms-basics';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Add an email input field to the form above (`type="email"`).$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'links-images-structure-and-forms' and l.slug = 'forms-basics';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'links-images-structure-and-forms' and l.slug = 'forms-basics';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What attribute controls what kind of input box you get?$md$, $md$["kind","type","input-style","field"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'links-images-structure-and-forms' and l.slug = 'forms-basics' and s.section_type = 'check_in';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Forgetting `placeholder` is just grayed-out hint text — it disappears when the user types and isn't the same as a real default value.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'links-images-structure-and-forms' and l.slug = 'forms-basics';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Assignment 3$md$, $md$Build a full HTML page (with proper html/head/body structure) containing a heading, a short bio, a list of your skills, a link to a site you like, an image, and a small form with a name field.

**Pass criteria:** correct page structure, all tags properly used.$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'links-images-structure-and-forms';


insert into public.modules (track_id, name, slug, order_index)
select t.id, $md$Capstone$md$, 'capstone', 3
from public.tracks t where t.slug = 'frontend'
on conflict (track_id, slug) do update set order_index = excluded.order_index, name = excluded.name;


insert into public.assignments (module_id, title, spec)
select m.id, $md$Capstone Assignment: Personal Profile Page$md$, $md$Using everything from Modules 1–3, build a complete personal profile page — a real, working HTML page (no CSS needed yet) with:
- Proper `<html>/<head>/<body>` structure and a `<title>`
- One `<h1>` main heading with your name
- A short bio paragraph with at least one bold word
- A bulleted list of 3+ interests or skills
- At least one image and one link
- A simple contact form with a name and email field

**Pass criteria:** Page structure is valid, all tags open and close correctly, heading hierarchy makes sense, and every required element above is present and working.$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'capstone';


insert into public.modules (track_id, name, slug, order_index)
select t.id, $md$Semantic HTML, Tables & Accessibility$md$, 'semantic-html-tables-and-accessibility', 4
from public.tracks t where t.slug = 'frontend'
on conflict (track_id, slug) do update set order_index = excluded.order_index, name = excluded.name;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Semantic HTML$md$, 'semantic-html', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'semantic-html-tables-and-accessibility'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Semantic tags describe *what* content is, not just how it's grouped — `<header>`, `<nav>`, `<section>`, `<article>`, `<footer>` mean something, unlike a plain `<div>`. This helps browsers, search engines, and assistive tech understand your page.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'semantic-html-tables-and-accessibility' and l.slug = 'semantic-html';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```html
<header>
  <h1>My Blog</h1>
  <nav>
    <a href="#">Home</a>
    <a href="#">About</a>
  </nav>
</header>
<article>
  <h2>My First Post</h2>
  <p>Post content here.</p>
</article>
<footer>
  <p>© 2026 My Blog</p>
</footer>
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'semantic-html-tables-and-accessibility' and l.slug = 'semantic-html';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Rebuild your profile page's structure using semantic tags instead of plain `<div>`s.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'semantic-html-tables-and-accessibility' and l.slug = 'semantic-html';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'semantic-html-tables-and-accessibility' and l.slug = 'semantic-html';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What's the main benefit of semantic tags over <div>?$md$, $md$["They look different visually","They describe the meaning of content, helping accessibility and search engines","They're faster to load","There's no real benefit"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'semantic-html-tables-and-accessibility' and l.slug = 'semantic-html' and s.section_type = 'check_in';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Using `<div>` for everything out of habit — a `<div>` is a generic container with no meaning; reach for a semantic tag when one fits.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'semantic-html-tables-and-accessibility' and l.slug = 'semantic-html';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Tables$md$, 'tables', 1, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'semantic-html-tables-and-accessibility'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Tables display data in rows and columns — use them for actual tabular data (like a schedule), not for page layout.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'semantic-html-tables-and-accessibility' and l.slug = 'tables';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```html
<table>
  <tr>
    <th>Name</th>
    <th>Track</th>
  </tr>
  <tr>
    <td>Ada</td>
    <td>JavaScript</td>
  </tr>
</table>
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'semantic-html-tables-and-accessibility' and l.slug = 'tables';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Build a table showing 3 of your favorite movies and their release years.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'semantic-html-tables-and-accessibility' and l.slug = 'tables';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'semantic-html-tables-and-accessibility' and l.slug = 'tables';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What's the difference between <th> and <td>?$md$, $md$["No difference","<th> is a header cell, <td> is a regular data cell","<th> is for images only","<td> is deprecated"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'semantic-html-tables-and-accessibility' and l.slug = 'tables' and s.section_type = 'check_in';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Using tables for page layout (like positioning a sidebar) — that's CSS's job (Flexbox/Grid); tables are for actual tabular data only.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'semantic-html-tables-and-accessibility' and l.slug = 'tables';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$More form inputs and validation$md$, 'more-form-inputs-and-validation', 2, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'semantic-html-tables-and-accessibility'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Beyond text inputs: `radio` (pick one), `checkbox` (pick any), `select` (dropdown), `textarea` (multi-line text). Validation attributes like `required` and `type="email"` add built-in checks.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'semantic-html-tables-and-accessibility' and l.slug = 'more-form-inputs-and-validation';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```html
<select>
  <option value="js">JavaScript</option>
  <option value="py">Python</option>
</select>
<input type="checkbox"> I agree to the terms
<input type="email" required>
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'semantic-html-tables-and-accessibility' and l.slug = 'more-form-inputs-and-validation';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Build a form with a dropdown, a checkbox, and a required email field.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'semantic-html-tables-and-accessibility' and l.slug = 'more-form-inputs-and-validation';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'semantic-html-tables-and-accessibility' and l.slug = 'more-form-inputs-and-validation';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does required do on an input?$md$, $md$["Nothing without JavaScript","Prevents form submission if the field is left empty","Hides the field","Deletes the field's value"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'semantic-html-tables-and-accessibility' and l.slug = 'more-form-inputs-and-validation' and s.section_type = 'check_in';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Forgetting `<option>` tags need a `value` — without it, the submitted value defaults to the option's visible text, which can cause mismatches with what your code expects.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'semantic-html-tables-and-accessibility' and l.slug = 'more-form-inputs-and-validation';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Embedding media & comments$md$, 'embedding-media-and-comments', 3, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'semantic-html-tables-and-accessibility'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$`<video>` and `<audio>` embed media directly. HTML comments (`<!-- like this -->`) let you leave notes in your code that the browser ignores.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'semantic-html-tables-and-accessibility' and l.slug = 'embedding-media-and-comments';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```html
<video src="clip.mp4" controls></video>
<!-- This is a comment, it won't show on the page -->
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'semantic-html-tables-and-accessibility' and l.slug = 'embedding-media-and-comments';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Add a comment above one section of your page explaining what it does.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'semantic-html-tables-and-accessibility' and l.slug = 'embedding-media-and-comments';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'semantic-html-tables-and-accessibility' and l.slug = 'embedding-media-and-comments';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$Do HTML comments appear on the visible page?$md$, $md$["Yes, always","No, they're invisible to visitors but visible in the code","Only in some browsers","Only if styled"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'semantic-html-tables-and-accessibility' and l.slug = 'embedding-media-and-comments' and s.section_type = 'check_in';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Using comments to "disable" large chunks of sensitive info thinking it's hidden — comments are still visible to anyone who views the page source, so never put secrets in them.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'semantic-html-tables-and-accessibility' and l.slug = 'embedding-media-and-comments';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Assignment 5$md$, $md$Rebuild your capstone profile page using semantic tags throughout, add a table showing your skills and proficiency level, and add a form with at least one dropdown and one checkbox.

**Pass criteria:** semantic tags used correctly, table displays properly, form inputs work.$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'semantic-html-tables-and-accessibility';


insert into public.modules (track_id, name, slug, order_index)
select t.id, $md$Deploying Your Project (GitHub + Vercel)$md$, 'deploying-your-project', 5
from public.tracks t where t.slug = 'frontend'
on conflict (track_id, slug) do update set order_index = excluded.order_index, name = excluded.name;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Pushing your project to GitHub$md$, 'pushing-your-project-to-github', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'deploying-your-project'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$GitHub stores your code online and is what deployment tools connect to.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'deploying-your-project' and l.slug = 'pushing-your-project-to-github';


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
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'deploying-your-project' and l.slug = 'pushing-your-project-to-github';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'deploying-your-project' and l.slug = 'pushing-your-project-to-github';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What do you need before you can push code to GitHub?$md$, $md$["A paid account","A GitHub repository already created and connected as a remote","A live website already running","Nothing else needed"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'deploying-your-project' and l.slug = 'pushing-your-project-to-github' and s.section_type = 'check_in';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Trying to push before creating the repository on GitHub's website first — the remote needs to already exist.$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'deploying-your-project' and l.slug = 'pushing-your-project-to-github';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Deploying to Vercel$md$, 'deploying-to-vercel', 1, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'deploying-your-project'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Vercel hosts your HTML page online for free, connected directly to GitHub.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'deploying-your-project' and l.slug = 'deploying-to-vercel';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$**Try it — numbered steps:**
1. Go to vercel.com, sign up with GitHub
2. Click "Add New Project," select your repository
3. Leave default settings for a plain HTML site
4. Click "Deploy"
5. Get your live URL$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'deploying-your-project' and l.slug = 'deploying-to-vercel';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'deploying-your-project' and l.slug = 'deploying-to-vercel';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What's the benefit of connecting Vercel to GitHub instead of uploading files manually?$md$, $md$["There's no benefit","Every future push automatically redeploys your site","It's required, there's no other way","It makes the page load faster"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'deploying-your-project' and l.slug = 'deploying-to-vercel' and s.section_type = 'check_in';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Expecting your live site to update after only saving changes locally — you must commit and push to GitHub first.$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'deploying-your-project' and l.slug = 'deploying-to-vercel';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Assignment 6 (Capstone extension)$md$, $md$Push your finished profile page to GitHub and deploy it live on Vercel. Share the live URL.

**Pass criteria:** live URL works and shows the current version.$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'deploying-your-project';

-- Verified rendering structurally against the source file (lesson/section
-- counts, section_type ordering, quiz option/correct-index fidelity) before
-- publishing, per the draft -> publish flow.
update public.lessons l set status = 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'frontend'
  and m.slug in ('what-html-is', 'structuring-text', 'links-images-structure-and-forms', 'capstone', 'semantic-html-tables-and-accessibility', 'deploying-your-project');
