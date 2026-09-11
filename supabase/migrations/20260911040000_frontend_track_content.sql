-- Frontend track built out in full: HTML foundations, CSS foundations,
-- putting pages together, and intro to React. Module 3 (JavaScript
-- fundamentals) stays a pointer to the standalone track per the curriculum
-- doc ("reuse Track 1 in full"), just published instead of left draft.


update public.lessons l
set status = 'published', is_free_preview = true
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'structure-and-common-tags';


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'structure-and-common-tags';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Every page starts with the same shape$md$, $md$Every HTML page follows the same basic shape, no matter how complex the site eventually gets.

```html
<!doctype html>
<html>
  <head>
    <title>My Page</title>
  </head>
  <body>
    <h1>Hello, world</h1>
    <p>This is a paragraph.</p>
  </body>
</html>
```

`<!doctype html>` tells the browser this is a modern HTML page. `<head>` holds information about the page that is not shown, like the title. `<body>` holds everything a visitor actually sees.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'structure-and-common-tags';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Common tags you will use constantly$md$, $md$| Tag | What it is for |
|---|---|
| `<h1>` to `<h6>` | Headings, biggest to smallest |
| `<p>` | A paragraph of text |
| `<a href="...">` | A link |
| `<img src="...">` | An image |
| `<div>` | A generic container for grouping things |

Tags almost always come in pairs: an opening tag and a closing tag with a slash, like `<p>text</p>`. A few, like `<img>`, are self-closing and do not wrap anything.$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'structure-and-common-tags';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id,
  $md$Which tag is used to add an image to a page?$md$,
  '["<a>","<img>","<picture>","<div>"]'::jsonb,
  1,
  $md$img is the tag for embedding an image, using its src attribute to point at the image file.$md$,
  0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'structure-and-common-tags' and s.title = 'Common tags you will use constantly';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Try it yourself$md$, $md$Change the heading text, add a second paragraph, and add a link to your favorite website.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'structure-and-common-tags';


update public.sections s
set sandbox_template = 'static',
    sandbox_files = jsonb_build_object(
      '/index.html', $md$<h1>Hello, world</h1>
<p>This is a paragraph. Edit me!</p>
<a href="https://example.com">A link</a>
$md$
    )
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'structure-and-common-tags'
  and s.title = 'Try it yourself';


update public.lessons l
set status = 'published', is_free_preview = false
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'forms';


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'forms';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Collecting input from a visitor$md$, $md$Forms are how a page collects information: a login, a search box, a signup, all forms.

```html
<form>
  <label for="email">Email</label>
  <input id="email" type="email" placeholder="you@example.com" />
  <button type="submit">Submit</button>
</form>
```

`<input>` has a type attribute that changes how it behaves: email, text, password, number, and more. `<label>` connects a piece of text to an input so screen readers and clicks on the label both work correctly.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'forms';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id,
  $md$What does the label's for attribute do?$md$,
  '["Changes the input color","Connects the label to a specific input by id","Submits the form","Adds a placeholder"]'::jsonb,
  1,
  $md$The for attribute matches an input's id, linking the two together so clicking the label focuses the input.$md$,
  0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'forms' and s.title = 'Collecting input from a visitor';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Try it yourself$md$, $md$Add a third field to the form, maybe a confirm password field or a checkbox to agree to terms.$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'forms';


update public.sections s
set sandbox_template = 'static',
    sandbox_files = jsonb_build_object(
      '/index.html', $md$<form>
  <label for="name">Name</label>
  <input id="name" type="text" />
  <label for="email">Email</label>
  <input id="email" type="email" />
  <button type="submit">Sign up</button>
</form>
$md$
    )
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'forms'
  and s.title = 'Try it yourself';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Personal bio page$md$, $md$## Personal bio page

Build a single HTML page about yourself: a heading with your name, a paragraph bio, an image (a placeholder is fine), and a form for visitors to leave you a message.

### Requirements
- Uses at least 3 different HTML tags from this module
- Includes a working form with at least 2 inputs
- Loads with no errors$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations'
on conflict do nothing;


update public.lessons l
set status = 'published', is_free_preview = false
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'selectors-and-the-box-model';


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'selectors-and-the-box-model';


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

A tag name (`h1`) targets every element of that type. A dot (`.card`) targets a class, which can be reused on many elements. A hash (`#header`) targets one specific element by its unique id.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'selectors-and-the-box-model';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id,
  $md$Which selector targets every element with class="card"?$md$,
  '[".card","#card","card","*card"]'::jsonb,
  0,
  $md$A dot prefix, like .card, selects every element that has that class.$md$,
  0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'selectors-and-the-box-model' and s.title = 'Targeting elements with selectors';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$The box model$md$, $md$Every element on a page is a box, and every box has the same four layers, from the inside out: content, padding, border, and margin.

```css
.box {
  padding: 16px;
  border: 2px solid black;
  margin: 24px;
}
```

Padding is space inside the border, margin is space outside it. Mixing these two up is one of the most common sources of layout confusion when you are starting out.$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'selectors-and-the-box-model';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Common mistake$md$, $md$**Common mistake:** reaching for margin when you actually want padding, or the other way around.

If you want more breathing room inside a box, between its border and its content, that is padding. If you want more space between one box and the next, that is margin. When a background color looks like it is not filling the whole box the way you expected, check whether you used padding or margin.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'selectors-and-the-box-model';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Try it yourself$md$, $md$Change the padding, margin, and border values and watch how the box's size and spacing change.$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'selectors-and-the-box-model';


update public.sections s
set sandbox_template = 'static',
    sandbox_files = jsonb_build_object(
      '/index.html', $md$<style>
  .box {
    padding: 16px;
    border: 2px solid black;
    margin: 24px;
    background: lightyellow;
  }
</style>
<div class="box">Edit my padding, border, and margin</div>
$md$
    )
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'selectors-and-the-box-model'
  and s.title = 'Try it yourself';


update public.lessons l
set status = 'published', is_free_preview = false
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'flexbox-and-grid';


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'flexbox-and-grid';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Flexbox: laying things out in a row or column$md$, $md$Flexbox arranges items along a single line, a row or a column, and makes spacing them out easy.

```css
.row {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
```

`display: flex` turns on flexbox for a container. `justify-content` controls spacing along the main direction, `align-items` controls alignment across it.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'flexbox-and-grid';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Grid: laying things out in two dimensions$md$, $md$CSS grid is for layouts that need both rows and columns at once, like a photo gallery or a dashboard.

```css
.gallery {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 12px;
}
```

`repeat(3, 1fr)` creates three equal-width columns. `gap` adds space between every item without needing margins on each one.$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'flexbox-and-grid';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id,
  $md$When would grid usually be a better fit than flexbox?$md$,
  '["When you only need a single row of buttons","When you need a two-dimensional layout, like rows and columns of cards","When you are centering one piece of text","Grid and flexbox are never used differently"]'::jsonb,
  1,
  $md$Flexbox is built for one dimension at a time, a row or a column. Grid is built for controlling rows and columns together.$md$,
  0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'flexbox-and-grid' and s.title = 'Grid: laying things out in two dimensions';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Try it yourself$md$, $md$Change grid-template-columns to 2 columns, or add more cards to the gallery.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'flexbox-and-grid';


update public.sections s
set sandbox_template = 'static',
    sandbox_files = jsonb_build_object(
      '/index.html', $md$<style>
  .gallery {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 12px;
  }
  .gallery div {
    background: lightblue;
    padding: 20px;
    text-align: center;
  }
</style>
<div class="gallery">
  <div>1</div>
  <div>2</div>
  <div>3</div>
</div>
$md$
    )
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'flexbox-and-grid'
  and s.title = 'Try it yourself';


update public.lessons l
set status = 'published', is_free_preview = false
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'responsive-basics';


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

A media query, `@media (max-width: 600px)`, applies its styles only when the screen is at or below that width, so you can redesign a layout for phones without touching the desktop version.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'responsive-basics';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id,
  $md$What does @media (max-width: 600px) do?$md$,
  '["Deletes the element on small screens","Applies its styles only when the screen is 600px wide or narrower","Sets a fixed width of 600px on every screen","Only works in one specific browser"]'::jsonb,
  1,
  $md$A max-width media query applies its rules only below that width, letting a layout adapt for phones without affecting wider screens.$md$,
  0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'responsive-basics' and s.title = 'Making a layout work on any screen';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Try it yourself$md$, $md$Change the breakpoint to 900px, or make it 2 columns on medium screens instead of jumping straight to 1.$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'responsive-basics';


update public.sections s
set sandbox_template = 'static',
    sandbox_files = jsonb_build_object(
      '/index.html', $md$<style>
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
$md$
    )
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'responsive-basics'
  and s.title = 'Try it yourself';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Style your bio page$md$, $md$## Style your bio page

Take the bio page you built in the previous module (or build a fresh one) and style it with CSS: at minimum, use flexbox or grid for layout, and a media query so it adapts to a phone-sized screen.

### Requirements
- Uses at least one flexbox or grid layout
- Includes a media query that changes the layout on a narrow screen
- No console errors$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations'
on conflict do nothing;


update public.lessons l
set status = 'published', is_free_preview = false
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'frontend' and m.slug = 'javascript-fundamentals-recap' and l.slug = 'this-module-reuses-the-javascript-fundamentals-track';


update public.lessons l
set status = 'published', is_free_preview = false
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'frontend' and m.slug = 'putting-pages-together' and l.slug = 'combining-html-css-and-javascript';


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'frontend' and m.slug = 'putting-pages-together' and l.slug = 'combining-html-css-and-javascript';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$One real interactive page$md$, $md$A real page usually needs all three layers working together: HTML for structure, CSS for style, and JavaScript for behavior.

```html
<button id="toggle">Show more</button>
<p id="details" style="display: none;">Here are the extra details.</p>
```

```js
const button = document.querySelector("#toggle");
const details = document.querySelector("#details");

button.addEventListener("click", () => {
  details.style.display = details.style.display === "none" ? "block" : "none";
});
```

Notice each layer stays in its lane: HTML describes what exists, CSS describes the starting look, and JavaScript changes things in response to what happens.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'putting-pages-together' and l.slug = 'combining-html-css-and-javascript';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id,
  $md$In the example above, what does clicking the button actually change?$md$,
  '["The button text","The details paragraph display style, toggling it visible or hidden","The page background color","Nothing, the code has a bug"]'::jsonb,
  1,
  $md$The click handler flips the details paragraph display style between none and block each time the button is clicked.$md$,
  0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'putting-pages-together' and l.slug = 'combining-html-css-and-javascript' and s.title = 'One real interactive page';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Try it yourself$md$, $md$Change the button's starting text, or add a second toggle for a different piece of content.$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'putting-pages-together' and l.slug = 'combining-html-css-and-javascript';


update public.sections s
set sandbox_template = 'vanilla',
    sandbox_files = jsonb_build_object(
      '/index.html', $md$<!doctype html>
<html>
  <body>
    <button id="toggle">Show more</button>
    <p id="details" style="display: none;">Here are the extra details.</p>
  </body>
</html>
$md$,
      '/index.js', $md$const button = document.querySelector("#toggle");
const details = document.querySelector("#details");

button.addEventListener("click", () => {
  details.style.display = details.style.display === "none" ? "block" : "none";
});
$md$
    )
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'frontend' and m.slug = 'putting-pages-together' and l.slug = 'combining-html-css-and-javascript'
  and s.title = 'Try it yourself';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Interactive landing page$md$, $md$## Interactive landing page

Build a single landing page (for a fake product, event, or yourself) that uses HTML, CSS, and JavaScript together.

### Requirements
- A styled layout using flexbox or grid
- At least one real interactive element: a toggle, an accordion, a simple form validation, anything that responds to user action
- Works on both a phone-sized and desktop-sized screen
- No console errors$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'putting-pages-together'
on conflict do nothing;


update public.lessons l
set status = 'published', is_free_preview = false
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'frontend' and m.slug = 'intro-to-react' and l.slug = 'components-and-props';


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'frontend' and m.slug = 'intro-to-react' and l.slug = 'components-and-props';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Breaking a page into pieces$md$, $md$React lets you build a page out of small, reusable components instead of one long HTML file.

```jsx
function Greeting(props) {
  return <h1>Hello, {props.name}!</h1>;
}

function App() {
  return (
    <div>
      <Greeting name="Ada" />
      <Greeting name="Priya" />
    </div>
  );
}
```

Greeting is a component: a function that returns some markup. props is how you pass data into it, here name, so the same component can display something different each time it is used.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'intro-to-react' and l.slug = 'components-and-props';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id,
  $md$What are props used for in React?$md$,
  '["Styling a component with CSS","Passing data into a component from outside","Storing a component internal state","Connecting to a database"]'::jsonb,
  1,
  $md$Props are how a parent passes data into a component. The component reads them but does not own or change them directly.$md$,
  0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'intro-to-react' and l.slug = 'components-and-props' and s.title = 'Breaking a page into pieces';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Try it yourself$md$, $md$Add a third Greeting with your own name, then add a second prop, like age, and display it too.$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'intro-to-react' and l.slug = 'components-and-props';


update public.sections s
set sandbox_template = 'react',
    sandbox_files = jsonb_build_object(
      '/App.js', $md$export default function App() {
  return (
    <div>
      <Greeting name="Ada" />
      <Greeting name="Priya" />
    </div>
  );
}

function Greeting(props) {
  return <h1>Hello, {props.name}!</h1>;
}
$md$
    )
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'frontend' and m.slug = 'intro-to-react' and l.slug = 'components-and-props'
  and s.title = 'Try it yourself';


update public.lessons l
set status = 'published', is_free_preview = false
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'frontend' and m.slug = 'intro-to-react' and l.slug = 'state';


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'frontend' and m.slug = 'intro-to-react' and l.slug = 'state';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Giving a component memory$md$, $md$Props come from outside, state is a component's own memory, values it can change over time.

```jsx
import { useState } from "react";

function Counter() {
  const [count, setCount] = useState(0);

  return (
    <button onClick={() => setCount(count + 1)}>
      Clicked {count} times
    </button>
  );
}
```

useState(0) starts the counter at 0. setCount is the only correct way to change it, calling it tells React to re-render the component with the new value.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'intro-to-react' and l.slug = 'state';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id,
  $md$Why can you not just change count directly, like count = count + 1?$md$,
  '["You can, it works exactly the same","React only re-renders when you call the state setter function, like setCount","count is not a real variable","Direct assignment causes a syntax error"]'::jsonb,
  1,
  $md$React needs to know a value changed so it can re-render. Calling the setter function, like setCount, is what tells it to update the screen.$md$,
  0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'intro-to-react' and l.slug = 'state' and s.title = 'Giving a component memory';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Try it yourself$md$, $md$Add a second button that decreases the count, and make sure it cannot go below zero.$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'intro-to-react' and l.slug = 'state';


update public.sections s
set sandbox_template = 'react',
    sandbox_files = jsonb_build_object(
      '/App.js', $md$import { useState } from "react";

export default function App() {
  const [count, setCount] = useState(0);

  return (
    <button onClick={() => setCount(count + 1)}>
      Clicked {count} times
    </button>
  );
}
$md$
    )
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'frontend' and m.slug = 'intro-to-react' and l.slug = 'state'
  and s.title = 'Try it yourself';


update public.lessons l
set status = 'published', is_free_preview = false
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'frontend' and m.slug = 'intro-to-react' and l.slug = 'building-a-small-multi-component-app';


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'frontend' and m.slug = 'intro-to-react' and l.slug = 'building-a-small-multi-component-app';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Combining components and state$md$, $md$Real apps combine several components, with state often living in one place and being shared down through props.

```jsx
import { useState } from "react";

function TodoItem({ text, done, onToggle }) {
  return (
    <li onClick={onToggle} style={{ textDecoration: done ? "line-through" : "none" }}>
      {text}
    </li>
  );
}

function App() {
  const [todos, setTodos] = useState([
    { text: "Learn components", done: true },
    { text: "Learn state", done: false },
  ]);

  function toggle(index) {
    setTodos(todos.map((t, i) => (i === index ? { ...t, done: !t.done } : t)));
  }

  return (
    <ul>
      {todos.map((todo, i) => (
        <TodoItem key={i} text={todo.text} done={todo.done} onToggle={() => toggle(i)} />
      ))}
    </ul>
  );
}
```

The list of todos lives in App's state. Each TodoItem just displays what it is given and calls onToggle when clicked, it does not manage the state itself.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'intro-to-react' and l.slug = 'building-a-small-multi-component-app';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id,
  $md$In the example above, which component actually owns the todos state?$md$,
  '["TodoItem","App","Both own it equally","Neither, it is stored in the browser automatically"]'::jsonb,
  1,
  $md$App holds the todos in its own state and passes each todo down to TodoItem as props. TodoItem just displays what it is given.$md$,
  0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'intro-to-react' and l.slug = 'building-a-small-multi-component-app' and s.title = 'Combining components and state';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Try it yourself$md$, $md$Add a way to add a new todo, using a text input and a button above the list.$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'intro-to-react' and l.slug = 'building-a-small-multi-component-app';


update public.sections s
set sandbox_template = 'react',
    sandbox_files = jsonb_build_object(
      '/App.js', $md$import { useState } from "react";

function TodoItem({ text, done, onToggle }) {
  return (
    <li onClick={onToggle} style={{ textDecoration: done ? "line-through" : "none" }}>
      {text}
    </li>
  );
}

export default function App() {
  const [todos, setTodos] = useState([
    { text: "Learn components", done: true },
    { text: "Learn state", done: false },
  ]);

  function toggle(index) {
    setTodos(todos.map((t, i) => (i === index ? { ...t, done: !t.done } : t)));
  }

  return (
    <ul>
      {todos.map((todo, i) => (
        <TodoItem key={i} text={todo.text} done={todo.done} onToggle={() => toggle(i)} />
      ))}
    </ul>
  );
}
$md$
    )
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'frontend' and m.slug = 'intro-to-react' and l.slug = 'building-a-small-multi-component-app'
  and s.title = 'Try it yourself';
