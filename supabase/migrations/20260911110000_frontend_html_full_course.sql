-- HTML module expanded from 2 lessons to a full 13-lesson course:
-- headings/paragraphs, lists, links, images/media, tables, forms (split
-- into two lessons), semantic HTML, accessibility, div/span, the document
-- head, and embedding content. The old two-lesson "forms" lesson is
-- replaced by two deeper ones.


delete from public.lessons l
using public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'forms';


update public.modules set order_index = 0 where track_id = (select id from public.tracks where slug = 'frontend') and slug = 'html-foundations';


update public.lessons l set order_index = 0
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'structure-and-common-tags';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Headings and paragraphs$md$, 'headings-and-paragraphs', 1, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations'
on conflict (module_id, slug) do update set order_index = excluded.order_index, title = excluded.title, is_free_preview = excluded.is_free_preview, status = excluded.status;


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'headings-and-paragraphs';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Six levels of headings$md$, $md$HTML gives you six heading levels, h1 through h6, used to show the structure of your content, not just to make text bigger.

```html
<h1>Page title</h1>
<h2>A major section</h2>
<h3>A subsection</h3>
<p>Regular paragraph text goes here.</p>
```

Use exactly one h1 per page (the main title), then h2 for major sections, h3 for subsections within those, and so on. Skipping levels (h1 straight to h4) confuses both readers and screen readers navigating by heading.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'headings-and-paragraphs';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$How many h1 tags should a typical page have?$md$, '["As many as you want","Exactly one","At least three","Zero, h1 is deprecated"]'::jsonb, 1, $md$A single h1 represents the page's main title. Using more than one, or skipping straight to lower heading levels, makes the page structure harder to follow.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'headings-and-paragraphs' and s.title = $md$Six levels of headings$md$;


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Try it yourself$md$, $md$Add an h4 subsection under one of the h3 sections, then add a second paragraph.$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'headings-and-paragraphs';


update public.sections s
set sandbox_template = 'static', sandbox_files = jsonb_build_object('/index.html', $md$<h1>Page title</h1>
<h2>A major section</h2>
<h3>A subsection</h3>
<p>Regular paragraph text goes here.</p>
$md$)
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'headings-and-paragraphs' and s.title = $md$Try it yourself$md$;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Lists$md$, 'lists', 2, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations'
on conflict (module_id, slug) do update set order_index = excluded.order_index, title = excluded.title, is_free_preview = excluded.is_free_preview, status = excluded.status;


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'lists';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Ordered and unordered lists$md$, $md$```html
<ul>
  <li>Milk</li>
  <li>Eggs</li>
  <li>Bread</li>
</ul>

<ol>
  <li>Preheat the oven</li>
  <li>Mix the batter</li>
  <li>Bake for 20 minutes</li>
</ol>
```

ul is for a list where order does not matter (unordered). ol is for one where it does (ordered, numbered automatically). Every item, in either type, is an li.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'lists';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$What is the difference between ul and ol?$md$, '["ul is for unordered lists, ol is for ordered (numbered) lists","They are identical","ol is for unordered lists, ul is for ordered lists","ul only works inside a table"]'::jsonb, 0, $md$ul (unordered list) is for items with no required order. ol (ordered list) automatically numbers its items because their order matters.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'lists' and s.title = $md$Ordered and unordered lists$md$;


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Nested lists$md$, $md$Lists can contain other lists, useful for anything with sub-items, like a table of contents or a recipe with sub-steps.

```html
<ul>
  <li>Fruits
    <ul>
      <li>Apple</li>
      <li>Banana</li>
    </ul>
  </li>
  <li>Vegetables</li>
</ul>
```

The nested ul sits inside the li of the item it belongs under.$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'lists';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Try it yourself$md$, $md$Add a third top-level item with its own nested list of two sub-items.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'lists';


update public.sections s
set sandbox_template = 'static', sandbox_files = jsonb_build_object('/index.html', $md$<ul>
  <li>Fruits
    <ul>
      <li>Apple</li>
      <li>Banana</li>
    </ul>
  </li>
  <li>Vegetables</li>
</ul>
$md$)
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'lists' and s.title = $md$Try it yourself$md$;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Links in depth$md$, 'links-in-depth', 3, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations'
on conflict (module_id, slug) do update set order_index = excluded.order_index, title = excluded.title, is_free_preview = excluded.is_free_preview, status = excluded.status;


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'links-in-depth';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Relative vs absolute links$md$, $md$```html
<a href="https://example.com">Absolute link</a>
<a href="/about">Relative link (same site)</a>
<a href="#section-2">Jump to a section on this page</a>
```

An absolute link includes the full address (https://...), used for linking to other websites. A relative link (starting with /) points somewhere on your own site. A link starting with # jumps to an element on the same page with a matching id.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'links-in-depth';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$What does a link starting with # do?$md$, '["Opens a new tab always","Jumps to an element on the same page with a matching id","Downloads a file","Is always broken"]'::jsonb, 1, $md$A # link, like #section-2, scrolls to the element on the same page whose id matches section-2.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'links-in-depth' and s.title = $md$Relative vs absolute links$md$;


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Opening links in a new tab$md$, $md$```html
<a href="https://example.com" target="_blank" rel="noopener noreferrer">Opens in a new tab</a>
```

target="_blank" opens the link in a new tab. rel="noopener noreferrer" is a security best practice that should always come with it, it stops the new tab from being able to control the original page.$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'links-in-depth';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Try it yourself$md$, $md$Add a link back to the top of the page using an anchor link.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'links-in-depth';


update public.sections s
set sandbox_template = 'static', sandbox_files = jsonb_build_object('/index.html', $md$<a href="#bottom">Jump to bottom</a>
<p>Some content in between.</p>
<a href="https://example.com" target="_blank" rel="noopener noreferrer">External link</a>
<p id="bottom">You made it to the bottom.</p>
$md$)
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'links-in-depth' and s.title = $md$Try it yourself$md$;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Images and media$md$, 'images-and-media', 4, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations'
on conflict (module_id, slug) do update set order_index = excluded.order_index, title = excluded.title, is_free_preview = excluded.is_free_preview, status = excluded.status;


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'images-and-media';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Images and why alt text matters$md$, $md$```html
<img src="cat.jpg" alt="An orange cat sleeping on a windowsill" width="400" />
```

alt describes the image in words. It is read aloud by screen readers, shown if the image fails to load, and used by search engines, never skip it. width (and height) help the browser reserve space before the image loads, preventing the page from jumping around.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'images-and-media';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$Why is the alt attribute important on an img tag?$md$, '["It makes the image load faster","It is read by screen readers and shown if the image fails to load","It is required for the image to have a border","It only matters for decorative images"]'::jsonb, 1, $md$alt text is essential for accessibility (screen readers read it aloud) and resilience (it shows if the image cannot load).$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'images-and-media' and s.title = $md$Images and why alt text matters$md$;


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Figures, video, and audio$md$, $md$```html
<figure>
  <img src="chart.png" alt="Sales chart for March" />
  <figcaption>March sales grew 12% over February.</figcaption>
</figure>

<video src="demo.mp4" controls></video>
<audio src="podcast.mp3" controls></audio>
```

figure groups an image with its caption (figcaption). video and audio both take a controls attribute to show play, pause, and volume controls without writing any JavaScript.$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'images-and-media';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Try it yourself$md$, $md$Change the alt text and caption to describe a different image.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'images-and-media';


update public.sections s
set sandbox_template = 'static', sandbox_files = jsonb_build_object('/index.html', $md$<figure>
  <img src="https://placehold.co/300x200" alt="A placeholder image" />
  <figcaption>Edit this caption.</figcaption>
</figure>
$md$)
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'images-and-media' and s.title = $md$Try it yourself$md$;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Tables$md$, 'tables', 5, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations'
on conflict (module_id, slug) do update set order_index = excluded.order_index, title = excluded.title, is_free_preview = excluded.is_free_preview, status = excluded.status;


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'tables';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$When to use a table$md$, $md$Tables are for genuinely tabular data, rows and columns of related facts, like a price list or a schedule. They are not a layout tool, use CSS flexbox or grid for that instead.

```html
<table>
  <thead>
    <tr>
      <th>Track</th>
      <th>Price</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Frontend</td>
      <td>NGN 45,000</td>
    </tr>
    <tr>
      <td>Backend</td>
      <td>NGN 45,000</td>
    </tr>
  </tbody>
</table>
```

thead holds the header row, tbody holds the data rows. th is a header cell, td is a regular data cell.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'tables';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$What should a table be used for?$md$, '["General page layout","Tabular data with real rows and columns of related facts","Making text bold","Adding spacing between sections"]'::jsonb, 1, $md$Tables are for real tabular data. Modern CSS (flexbox and grid) handles page layout, tables should not be used for that.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'tables' and s.title = $md$When to use a table$md$;


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Try it yourself$md$, $md$Add a third column for level (beginner, intermediate, advanced).$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'tables';


update public.sections s
set sandbox_template = 'static', sandbox_files = jsonb_build_object('/index.html', $md$<table border="1" cellpadding="6">
  <thead>
    <tr><th>Track</th><th>Price</th></tr>
  </thead>
  <tbody>
    <tr><td>Frontend</td><td>NGN 45,000</td></tr>
    <tr><td>Backend</td><td>NGN 45,000</td></tr>
  </tbody>
</table>
$md$)
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'tables' and s.title = $md$Try it yourself$md$;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Forms: text inputs and labels$md$, 'form-basics-text-inputs', 6, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations'
on conflict (module_id, slug) do update set order_index = excluded.order_index, title = excluded.title, is_free_preview = excluded.is_free_preview, status = excluded.status;


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'form-basics-text-inputs';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Collecting input from a visitor$md$, $md$Forms are how a page collects information: a login, a search box, a signup, all forms.

```html
<form>
  <label for="email">Email</label>
  <input id="email" type="email" placeholder="you@example.com" />
  <button type="submit">Submit</button>
</form>
```

input has a type attribute that changes how it behaves: email, text, password, number, and more. label connects a piece of text to an input so screen readers and clicks on the label both work correctly.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'form-basics-text-inputs';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$What does the label's for attribute do?$md$, '["Changes the input color","Connects the label to a specific input by id","Submits the form","Adds a placeholder"]'::jsonb, 1, $md$The for attribute matches an input's id, linking the two together so clicking the label focuses the input.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'form-basics-text-inputs' and s.title = $md$Collecting input from a visitor$md$;


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Common text input types$md$, $md$| Type | Use |
|---|---|
| text | Plain text |
| email | Validates a basic email shape |
| password | Hides what is typed |
| number | Numeric input, often with up/down arrows |
| tel | A phone number |
| textarea (its own tag) | Multi-line text |

```html
<textarea rows="4" placeholder="Tell us about yourself"></textarea>
```

textarea is its own tag (not an input type) since it needs to wrap multiple lines.$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'form-basics-text-inputs';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Try it yourself$md$, $md$Add a number input for age.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'form-basics-text-inputs';


update public.sections s
set sandbox_template = 'static', sandbox_files = jsonb_build_object('/index.html', $md$<form>
  <label for="name">Name</label>
  <input id="name" type="text" />
  <label for="email">Email</label>
  <input id="email" type="email" />
  <label for="bio">Bio</label>
  <textarea id="bio" rows="3"></textarea>
  <button type="submit">Submit</button>
</form>
$md$)
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'form-basics-text-inputs' and s.title = $md$Try it yourself$md$;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Forms: choices and validation$md$, 'forms-choices-and-validation', 7, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations'
on conflict (module_id, slug) do update set order_index = excluded.order_index, title = excluded.title, is_free_preview = excluded.is_free_preview, status = excluded.status;


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'forms-choices-and-validation';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Checkboxes, radio buttons, and selects$md$, $md$```html
<label><input type="checkbox" name="terms" /> I agree to the terms</label>

<label><input type="radio" name="plan" value="monthly" /> Monthly</label>
<label><input type="radio" name="plan" value="yearly" /> Yearly</label>

<select>
  <option value="beginner">Beginner</option>
  <option value="advanced">Advanced</option>
</select>
```

Checkboxes let someone pick any number of options. Radio buttons sharing the same name let someone pick only one. A select is a dropdown of choices, also pick-one by default.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'forms-choices-and-validation';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$What makes two radio buttons part of the same group, so only one can be selected?$md$, '["They must be next to each other in the HTML","They share the same name attribute","They must be inside the same div","Radio buttons are always grouped automatically"]'::jsonb, 1, $md$Radio buttons with the same name value are treated as one group, selecting one automatically deselects the others in that group.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'forms-choices-and-validation' and s.title = $md$Checkboxes, radio buttons, and selects$md$;


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Basic validation without JavaScript$md$, $md$```html
<input type="email" required />
<input type="text" minlength="3" maxlength="20" required />
```

required stops the form from submitting if the field is empty. minlength and maxlength enforce a length range. The browser handles all of this natively, no JavaScript needed for basic checks.$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'forms-choices-and-validation';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Try it yourself$md$, $md$Make the checkbox required too, and try submitting without checking it.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'forms-choices-and-validation';


update public.sections s
set sandbox_template = 'static', sandbox_files = jsonb_build_object('/index.html', $md$<form>
  <label><input type="radio" name="plan" value="monthly" checked /> Monthly</label>
  <label><input type="radio" name="plan" value="yearly" /> Yearly</label>
  <label><input type="checkbox" name="terms" /> I agree to the terms</label>
  <button type="submit">Submit</button>
</form>
$md$)
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'forms-choices-and-validation' and s.title = $md$Try it yourself$md$;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Semantic HTML$md$, 'semantic-html', 8, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations'
on conflict (module_id, slug) do update set order_index = excluded.order_index, title = excluded.title, is_free_preview = excluded.is_free_preview, status = excluded.status;


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'semantic-html';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Tags that describe meaning, not just appearance$md$, $md$Semantic tags describe what a section of a page is, not just how it looks. A screen reader, a search engine, and another developer reading your code all benefit from this.

```html
<header>Site logo and nav</header>
<nav>Main navigation links</nav>
<main>
  <article>
    <h1>Blog post title</h1>
    <section>First part of the post</section>
  </article>
  <aside>Related links</aside>
</main>
<footer>Copyright and links</footer>
```

Compare this to a page built entirely out of div tags with class names, technically it can look identical, but none of that meaning is present in the actual markup.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'semantic-html';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$What is the main benefit of semantic tags like header, nav, and main over generic divs?$md$, '["They load faster","They convey meaning to screen readers, search engines, and other developers","They require less CSS","They are required for JavaScript to work"]'::jsonb, 1, $md$Semantic tags carry meaning in the HTML itself, which assistive technology, search engines, and other developers can all make use of, generic divs carry none of that.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'semantic-html' and s.title = $md$Tags that describe meaning, not just appearance$md$;


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Try it yourself$md$, $md$Add a second article inside main, each with its own heading.$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'semantic-html';


update public.sections s
set sandbox_template = 'static', sandbox_files = jsonb_build_object('/index.html', $md$<header>Site logo and nav</header>
<main>
  <article>
    <h2>First post</h2>
    <p>Some content.</p>
  </article>
</main>
<footer>Copyright</footer>
$md$)
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'semantic-html' and s.title = $md$Try it yourself$md$;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Accessibility basics$md$, 'accessibility-basics', 9, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations'
on conflict (module_id, slug) do update set order_index = excluded.order_index, title = excluded.title, is_free_preview = excluded.is_free_preview, status = excluded.status;


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'accessibility-basics';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Building pages everyone can use$md$, $md$Accessibility means a page works for people using a screen reader, navigating by keyboard only, or with low vision. Most of it comes from just using HTML correctly.

- Every image needs meaningful alt text (or alt="" if it is purely decorative)
- Every form input needs a connected label
- Use real buttons (button) for actions, not a div with a click handler
- Use semantic tags (header, nav, main) so screen readers can jump between landmarks
- Make sure interactive elements are reachable and usable with the Tab key alone

Most accessibility wins are just: use the right tag for the job, do not fake it with a div.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'accessibility-basics';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$What is one of the simplest ways to improve accessibility on a page?$md$, '["Adding more animations","Using the correct semantic HTML tag for each purpose instead of generic divs","Making all text the same size","Removing all links"]'::jsonb, 1, $md$Using the right tag (button for buttons, label for inputs, semantic landmarks for structure) gets you most of the way to an accessible page automatically.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'accessibility-basics' and s.title = $md$Building pages everyone can use$md$;


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Try it yourself$md$, $md$Look back at a page you've built so far in this track. Check every image has real alt text and every input has a connected label. Fix any you find.$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'accessibility-basics';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$div, span, and block vs inline$md$, 'div-span-and-block-vs-inline', 10, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations'
on conflict (module_id, slug) do update set order_index = excluded.order_index, title = excluded.title, is_free_preview = excluded.is_free_preview, status = excluded.status;


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'div-span-and-block-vs-inline';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Generic containers$md$, $md$div and span carry no meaning on their own, they exist purely to group things so you can style or script them.

```html
<div class="card">
  <span class="badge">New</span>
  <p>Card content</p>
</div>
```

Use a semantic tag first if one fits (nav, header, article...). Reach for div and span only when nothing more specific applies.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'div-span-and-block-vs-inline';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Block vs inline$md$, $md$| | Block | Inline |
|---|---|---|
| Examples | div, p, h1, ul | span, a, strong, em |
| Takes full width | Yes | No, only as wide as its content |
| Can have width and height set | Yes | Not really |
| Starts on a new line | Yes | No |

div is the generic block-level container, span is the generic inline one. This is why you cannot easily set a width on a span, wrapped inline content flows like text.$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'div-span-and-block-vs-inline';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$What is the key difference between a block element and an inline element?$md$, '["Block elements are always red","Block elements start on a new line and take the full width, inline elements flow with surrounding text","Inline elements cannot contain text","There is no real difference"]'::jsonb, 1, $md$Block-level elements stack vertically and take the full available width by default. Inline elements sit within a line of text and only take up as much space as their content.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'div-span-and-block-vs-inline' and s.title = $md$Block vs inline$md$;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$The document head$md$, 'the-document-head', 11, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations'
on conflict (module_id, slug) do update set order_index = excluded.order_index, title = excluded.title, is_free_preview = excluded.is_free_preview, status = excluded.status;


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'the-document-head';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$What goes in head$md$, $md$```html
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Forge, learn to code</title>
  <meta name="description" content="Interactive coding education." />
  <link rel="icon" href="/favicon.ico" />
</head>
```

charset tells the browser how to read the file's text encoding. viewport is essential for mobile, without it a phone browser assumes a wide desktop layout and zooms out. title shows in the browser tab. meta description is what search engines often show as a page's summary.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'the-document-head';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$What happens if a page is missing the viewport meta tag?$md$, '["Nothing, it is purely decorative","On mobile, the browser tends to render the page as if on a wide desktop screen and zoom out","The page will not load at all","The title will not show in the tab"]'::jsonb, 1, $md$Without a viewport meta tag, mobile browsers typically assume a desktop-width layout and shrink the whole page to fit, ignoring how it would actually look at the phone's real width.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'the-document-head' and s.title = $md$What goes in head$md$;


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Try it yourself$md$, $md$Change the title and description to describe a page of your own choosing.$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'the-document-head';


update public.sections s
set sandbox_template = 'static', sandbox_files = jsonb_build_object('/index.html', $md$<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>My Page</title>
  <meta name="description" content="A page about something I care about." />
</head>
<body>
  <h1>Check the tab title above</h1>
</body>
$md$)
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'the-document-head' and s.title = $md$Try it yourself$md$;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Embedding content$md$, 'embedding-content', 12, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations'
on conflict (module_id, slug) do update set order_index = excluded.order_index, title = excluded.title, is_free_preview = excluded.is_free_preview, status = excluded.status;


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'embedding-content';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Embedding another page or video$md$, $md$```html
<iframe
  src="https://www.youtube.com/embed/dQw4w9WgXcQ"
  width="560"
  height="315"
  title="Embedded video"
></iframe>
```

An iframe embeds another whole page inside yours, most often used for embedding videos, maps, or widgets from another site. Always include a title attribute describing what it is, for accessibility.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'embedding-content';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$What is an iframe most commonly used for?$md$, '["Making text italic","Embedding another page, like a video or map, inside your own page","Creating a table","Styling a button"]'::jsonb, 1, $md$An iframe embeds an entire external page within your own, commonly used for video embeds, maps, and third-party widgets.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'embedding-content' and s.title = $md$Embedding another page or video$md$;


update public.assignments a
set spec = $md$## Personal bio page

Build a single HTML page about yourself, using proper semantic structure.

### Requirements
- A semantic layout: header, main, and footer at minimum
- A heading hierarchy that makes sense (one h1, then h2s for sections)
- An image with real, descriptive alt text
- A table somewhere on the page with real tabular data (for example, a table of your skills and how long you've used them)
- A form with at least 3 different input types, each with a connected label, for visitors to leave you a message
- Loads with no errors$md$
from public.modules m join public.tracks t on t.id = m.track_id
where a.module_id = m.id and t.slug = 'frontend' and m.slug = 'html-foundations';
