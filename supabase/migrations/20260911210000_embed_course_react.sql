-- Embeds courses/course-react.md verbatim as the Frontend track's
-- React portion, replacing the earlier self-authored single 'intro-to-react'
-- module with the real course's own 6-module structure (renumbered here in
-- learning order: Module 0 Setup, then 1-5, matching the file's own note
-- that Module 0 is meant to come first despite its file position). Content
-- preserved as-written. Inserted as draft; published after structural
-- verification against the source file.


delete from public.modules m
using public.tracks t
where m.track_id = t.id and t.slug = 'frontend' and m.slug = 'intro-to-react';


insert into public.modules (track_id, name, slug, order_index)
select t.id, $md$Setting Up Your React Project$md$, 'setting-up-your-react-project', 12
from public.tracks t where t.slug = 'frontend'
on conflict (track_id, slug) do update set order_index = excluded.order_index, name = excluded.name;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Installing Node.js$md$, 'installing-nodejs', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'setting-up-your-react-project'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$React projects need Node.js installed on your computer — it's the tool that runs the build process and dev server, even though your final app runs in the browser.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'setting-up-your-react-project' and l.slug = 'installing-nodejs';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$**Try it — numbered steps:**
1. Go to nodejs.org and download the LTS (Long Term Support) version
2. Run the installer
3. Open your terminal and type `node -v` to confirm it installed — you should see a version number$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'setting-up-your-react-project' and l.slug = 'installing-nodejs';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'setting-up-your-react-project' and l.slug = 'installing-nodejs';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does typing node -v do?$md$, $md$["Creates a new React project","Confirms Node is installed and shows its version","Deletes Node","Opens the browser"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'setting-up-your-react-project' and l.slug = 'installing-nodejs' and s.order_index = 2;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Installing Node but not restarting the terminal afterward — the terminal sometimes needs a fresh restart to recognize the new install.$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'setting-up-your-react-project' and l.slug = 'installing-nodejs';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Creating a React project with Vite$md$, 'creating-a-react-project-with-vite', 1, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'setting-up-your-react-project'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Vite is a fast, modern tool for creating and running React projects — it sets up everything you need in one command.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'setting-up-your-react-project' and l.slug = 'creating-a-react-project-with-vite';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$**Try it — numbered steps:**
1. Open your terminal, navigate to a folder where you want your project
2. Run: `npm create vite@latest my-app -- --template react`
3. Move into the folder: `cd my-app`
4. Install packages: `npm install`
5. Start the dev server: `npm run dev`
6. Open the URL it gives you (usually `localhost:5173`) in your browser$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'setting-up-your-react-project' and l.slug = 'creating-a-react-project-with-vite';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'setting-up-your-react-project' and l.slug = 'creating-a-react-project-with-vite';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does npm install do?$md$, $md$["Starts the app","Downloads all the packages your project needs","Deletes the project","Creates a GitHub repo"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'setting-up-your-react-project' and l.slug = 'creating-a-react-project-with-vite' and s.order_index = 2;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Skipping npm install after creating a project or pulling one from GitHub — the project won't run until all its packages are actually downloaded.$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'setting-up-your-react-project' and l.slug = 'creating-a-react-project-with-vite';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Installing additional packages$md$, 'installing-additional-packages', 2, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'setting-up-your-react-project'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Beyond the starter template, you'll often need extra packages (like a routing library). You install these with `npm install <package-name>`.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'setting-up-your-react-project' and l.slug = 'installing-additional-packages';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```bash
npm install react-router-dom
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'setting-up-your-react-project' and l.slug = 'installing-additional-packages';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Install `react-router-dom` in your project — you'll use it in Module 3.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'setting-up-your-react-project' and l.slug = 'installing-additional-packages';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'setting-up-your-react-project' and l.slug = 'installing-additional-packages';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$Where do installed packages get listed?$md$, $md$["Nowhere, they're invisible","In your project's package.json file","Only in your browser","In a separate app"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'setting-up-your-react-project' and l.slug = 'installing-additional-packages' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Manually editing package.json to add a package name without actually running npm install — the package won't really be downloaded, just listed.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'setting-up-your-react-project' and l.slug = 'installing-additional-packages';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Assignment 0$md$, $md$Set up a brand-new React + Vite project from scratch, following the steps above, and get the default starter page running in your browser.

**Pass criteria:** dev server runs without errors, default page loads.$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'setting-up-your-react-project';


insert into public.modules (track_id, name, slug, order_index)
select t.id, $md$Why React Exists$md$, 'why-react-exists', 13
from public.tracks t where t.slug = 'frontend'
on conflict (track_id, slug) do update set order_index = excluded.order_index, name = excluded.name;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$The problem React solves$md$, 'the-problem-react-solves', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'why-react-exists'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$In plain JavaScript, updating the page means manually finding elements and changing them one by one (`document.querySelector`, `.textContent`, etc.). As an app grows, this gets messy fast. React lets you describe *what the page should look like* for a given state, and it handles updating things for you.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'why-react-exists' and l.slug = 'the-problem-react-solves';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'why-react-exists' and l.slug = 'the-problem-react-solves';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What problem does React mainly solve?$md$, $md$["Making CSS easier","Managing complex, changing UI without manual DOM updates","Replacing HTML entirely","Making websites load faster automatically"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'why-react-exists' and l.slug = 'the-problem-react-solves' and s.order_index = 1;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Assuming React replaces JavaScript — it's built *with* JavaScript, using everything from the JS course (functions, arrays, objects).$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'why-react-exists' and l.slug = 'the-problem-react-solves';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$What is a component?$md$, 'what-is-a-component', 1, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'why-react-exists'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$A component is a reusable, self-contained piece of UI — like a button, a card, or an entire page — built as a JavaScript function that returns what should appear on screen.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'why-react-exists' and l.slug = 'what-is-a-component';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'why-react-exists' and l.slug = 'what-is-a-component';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What is a React component, at its core?$md$, $md$["A CSS file","A function that returns UI","A database table","An HTML tag"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'why-react-exists' and l.slug = 'what-is-a-component' and s.order_index = 1;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Trying to build one giant component for an entire app — breaking things into small, focused components (a card, a button, a list item) makes code far easier to manage.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'why-react-exists' and l.slug = 'what-is-a-component';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Your first component and JSX$md$, 'your-first-component-and-jsx', 2, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'why-react-exists'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$JSX is HTML-like syntax you write directly inside JavaScript. It looks like HTML but is actually JavaScript under the hood.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'why-react-exists' and l.slug = 'your-first-component-and-jsx';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```jsx
function Greeting() {
  return <h1>Hello, Forge</h1>;
}
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'why-react-exists' and l.slug = 'your-first-component-and-jsx';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Create a component called `Welcome` that returns a paragraph with your name.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'why-react-exists' and l.slug = 'your-first-component-and-jsx';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'why-react-exists' and l.slug = 'your-first-component-and-jsx';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does a component return?$md$, $md$["A string only","JSX describing what should appear","A CSS class","Nothing"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'why-react-exists' and l.slug = 'your-first-component-and-jsx' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Forgetting a component can only return *one* top-level element — wrap multiple elements in a single parent `<div>` (or a React Fragment `<>...</>`).$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'why-react-exists' and l.slug = 'your-first-component-and-jsx';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Assignment 1$md$, $md$Create three simple components (`Header`, `Bio`, `Footer`), each returning a small piece of JSX, and render all three together.

**Pass criteria:** each is a valid function component, all three appear on screen.$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'why-react-exists';


insert into public.modules (track_id, name, slug, order_index)
select t.id, $md$Props & State$md$, 'props-and-state', 14
from public.tracks t where t.slug = 'frontend'
on conflict (track_id, slug) do update set order_index = excluded.order_index, name = excluded.name;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Props$md$, 'props', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'props-and-state'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Props (short for "properties") pass data *into* a component from outside — like function parameters, but for components.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'props-and-state' and l.slug = 'props';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```jsx
function Greeting(props) {
  return <h1>Hello, {props.name}</h1>;
}
// used as: <Greeting name="Ada" />
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'props-and-state' and l.slug = 'props';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Give your `Welcome` component from Lesson 1.3 a `name` prop instead of a hardcoded name.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'props-and-state' and l.slug = 'props';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'props-and-state' and l.slug = 'props';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$How do you pass data into a component?$md$, $md$["Global variables","Props, like <Component propName=\"value\" />","Console.log","You can't"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'props-and-state' and l.slug = 'props' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Trying to change a prop's value inside the component — props are read-only from the component's perspective; they're controlled by whoever renders it.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'props-and-state' and l.slug = 'props';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$State$md$, 'state', 1, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'props-and-state'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$State is data a component remembers and can update on its own — like a counter that changes when clicked. `useState` is the tool for this.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'props-and-state' and l.slug = 'state';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```jsx
import { useState } from "react";

function Counter() {
  const [count, setCount] = useState(0);
  return <p>Count: {count}</p>;
}
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'props-and-state' and l.slug = 'state';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Change the starting value inside `useState(0)` to a different number.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'props-and-state' and l.slug = 'state';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'props-and-state' and l.slug = 'state';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does useState(0) return?$md$, $md$["Just the number 0","A pair: the current value and a function to update it","A component","An error"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'props-and-state' and l.slug = 'state' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Trying to update state by directly changing the variable (`count = count + 1`) instead of using the setter function (`setCount(count + 1)`) — React won't notice the change and the screen won't update.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'props-and-state' and l.slug = 'state';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Handling events$md$, 'handling-events', 2, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'props-and-state'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$React uses event props like `onClick` and `onChange`, similar to `addEventListener` but written directly on the element.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'props-and-state' and l.slug = 'handling-events';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```jsx
function Counter() {
  const [count, setCount] = useState(0);
  return (
    <div>
      <p>Count: {count}</p>
      <button onClick={() => setCount(count + 1)}>Add</button>
    </div>
  );
}
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'props-and-state' and l.slug = 'handling-events';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Add a second button that decreases the count.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'props-and-state' and l.slug = 'handling-events';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'props-and-state' and l.slug = 'handling-events';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does onClick={() => setCount(count + 1)} do?$md$, $md$["Runs immediately when the page loads","Runs when the button is clicked, increasing count","Changes the button's color","Deletes the button"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'props-and-state' and l.slug = 'handling-events' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Writing `onClick={setCount(count + 1)}` without the arrow function — this runs it immediately on render instead of waiting for the click.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'props-and-state' and l.slug = 'handling-events';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Assignment 2$md$, $md$Build a working counter component with increase, decrease, and reset buttons.

**Pass criteria:** state updates correctly, all three buttons work.$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'props-and-state';


insert into public.modules (track_id, name, slug, order_index)
select t.id, $md$Lists & Capstone$md$, 'lists-and-capstone', 15
from public.tracks t where t.slug = 'frontend'
on conflict (track_id, slug) do update set order_index = excluded.order_index, name = excluded.name;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Rendering lists$md$, 'rendering-lists', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'lists-and-capstone'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$To display an array of data as UI, use `.map()` to turn each item into a piece of JSX. Each item needs a unique `key` prop so React can track it.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'lists-and-capstone' and l.slug = 'rendering-lists';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```jsx
function TodoList({ todos }) {
  return (
    <ul>
      {todos.map(todo => (
        <li key={todo.id}>{todo.text}</li>
      ))}
    </ul>
  );
}
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'lists-and-capstone' and l.slug = 'rendering-lists';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Render a list of your own favorite foods as an array of objects.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'lists-and-capstone' and l.slug = 'rendering-lists';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'lists-and-capstone' and l.slug = 'rendering-lists';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$Why does each list item need a key prop?$md$, $md$["It's just decoration","It helps React track which items changed, added, or removed","It sets the item's color","It's required for CSS"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'lists-and-capstone' and l.slug = 'rendering-lists' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Using the array index as the key when items can be reordered or removed — this can cause React to mix up which item is which; a stable unique ID is safer.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'lists-and-capstone' and l.slug = 'rendering-lists';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Capstone Assignment — Multi-component todo app$md$, $md$Build a working todo list app using components, props, state, and events together: a form to add a todo (state + event), a list rendered from an array (`.map()`), and the ability to mark items done and remove them.

**Pass criteria:** adding, completing, and removing todos all work correctly; components are sensibly broken up rather than one giant file. This is the assignment that unlocks this track's certificate.$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'lists-and-capstone';


insert into public.modules (track_id, name, slug, order_index)
select t.id, $md$Filling the Gaps (useEffect, forms, composition, routing, data, hooks)$md$, 'filling-the-gaps', 16
from public.tracks t where t.slug = 'frontend'
on conflict (track_id, slug) do update set order_index = excluded.order_index, name = excluded.name;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$useEffect and side effects$md$, 'useeffect-and-side-effects', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'filling-the-gaps'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Sometimes a component needs to *do* something beyond just rendering — like fetching data when it first appears. `useEffect` runs code in response to a component rendering or specific values changing.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'filling-the-gaps' and l.slug = 'useeffect-and-side-effects';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```jsx
import { useEffect, useState } from "react";

function Clock() {
  const [time, setTime] = useState(new Date());

  useEffect(() => {
    const timer = setInterval(() => setTime(new Date()), 1000);
    return () => clearInterval(timer);
  }, []);

  return <p>{time.toLocaleTimeString()}</p>;
}
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'filling-the-gaps' and l.slug = 'useeffect-and-side-effects';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Build a component that logs a message once when it first appears, using `useEffect` with an empty array `[]`.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'filling-the-gaps' and l.slug = 'useeffect-and-side-effects';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'filling-the-gaps' and l.slug = 'useeffect-and-side-effects';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does the empty array [] as useEffect's second argument mean?$md$, $md$["Run on every render","Run only once, when the component first appears","Never run","Run only on click"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'filling-the-gaps' and l.slug = 'useeffect-and-side-effects' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Forgetting the dependency array entirely — this makes the effect run after *every* render, which can cause performance problems or infinite loops.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'filling-the-gaps' and l.slug = 'useeffect-and-side-effects';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Conditional rendering$md$, 'conditional-rendering', 1, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'filling-the-gaps'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$You can show different UI based on a condition, using regular JavaScript inside JSX — if/else logic, ternaries, or `&&`.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'filling-the-gaps' and l.slug = 'conditional-rendering';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```jsx
function Greeting({ isLoggedIn }) {
  return (
    <div>
      {isLoggedIn ? <p>Welcome back!</p> : <p>Please log in.</p>}
    </div>
  );
}
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'filling-the-gaps' and l.slug = 'conditional-rendering';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Show a "Loading..." message only when a `loading` prop is true, using `&&`.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'filling-the-gaps' and l.slug = 'conditional-rendering';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'filling-the-gaps' and l.slug = 'conditional-rendering';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does {isLoggedIn ? <p>A</p> : <p>B</p>} do?$md$, $md$["Always shows both","Shows A if isLoggedIn is true, B if false","Causes an error","Shows nothing"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'filling-the-gaps' and l.slug = 'conditional-rendering' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Using `{isLoggedIn && <p>Welcome</p>}` when isLoggedIn might be `0` instead of `false` — React can render a stray "0" on the screen in that edge case.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'filling-the-gaps' and l.slug = 'conditional-rendering';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Forms in React (controlled inputs)$md$, 'forms-in-react-controlled-inputs', 2, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'filling-the-gaps'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$A "controlled input" means React state is the source of truth for a form field's value, not the DOM itself.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'filling-the-gaps' and l.slug = 'forms-in-react-controlled-inputs';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```jsx
function NameForm() {
  const [name, setName] = useState("");
  return (
    <input value={name} onChange={(e) => setName(e.target.value)} />
  );
}
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'filling-the-gaps' and l.slug = 'forms-in-react-controlled-inputs';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Build a small form with a controlled text input and a submit button that logs the value.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'filling-the-gaps' and l.slug = 'forms-in-react-controlled-inputs';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'filling-the-gaps' and l.slug = 'forms-in-react-controlled-inputs';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What makes an input "controlled" in React?$md$, $md$["It has a border","Its value comes from state, updated via onChange","It's read-only","It has a placeholder"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'filling-the-gaps' and l.slug = 'forms-in-react-controlled-inputs' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Setting `value` without an `onChange` handler — this makes the input impossible to type into, since React keeps resetting it to the unchanging state value.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'filling-the-gaps' and l.slug = 'forms-in-react-controlled-inputs';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Component composition$md$, 'component-composition', 3, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'filling-the-gaps'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Instead of one giant component, you can nest components inside each other and pass content via `children` — useful for reusable wrappers like a Card.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'filling-the-gaps' and l.slug = 'component-composition';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```jsx
function Card({ children }) {
  return <div className="card">{children}</div>;
}
// used as: <Card><p>Some content</p></Card>
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'filling-the-gaps' and l.slug = 'component-composition';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Build a `Card` component and use it to wrap two different pieces of content in your app.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'filling-the-gaps' and l.slug = 'component-composition';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'filling-the-gaps' and l.slug = 'component-composition';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does children represent in a component?$md$, $md$["A special CSS class","Whatever content is nested between the component's opening and closing tags","The component's parent","An error"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'filling-the-gaps' and l.slug = 'component-composition' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Forgetting children is just a prop like any other — it needs to be explicitly used inside the component (`{children}`) or nothing will render.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'filling-the-gaps' and l.slug = 'component-composition';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Basic routing with React Router$md$, 'basic-routing-with-react-router', 4, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'filling-the-gaps'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Real apps have multiple pages. React Router lets you show different components based on the URL, without a full page reload.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'filling-the-gaps' and l.slug = 'basic-routing-with-react-router';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```jsx
import { BrowserRouter, Routes, Route } from "react-router-dom";

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/about" element={<About />} />
      </Routes>
    </BrowserRouter>
  );
}
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'filling-the-gaps' and l.slug = 'basic-routing-with-react-router';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Add a third route for a "Contact" page.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'filling-the-gaps' and l.slug = 'basic-routing-with-react-router';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'filling-the-gaps' and l.slug = 'basic-routing-with-react-router';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does the path prop on <Route> control?$md$, $md$["The component's styling","Which URL shows that component","The component's props","Nothing important"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'filling-the-gaps' and l.slug = 'basic-routing-with-react-router' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Forgetting to wrap everything in `<BrowserRouter>` — routes won't work at all without it.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'filling-the-gaps' and l.slug = 'basic-routing-with-react-router';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Fetching data from an API$md$, 'fetching-data-from-an-api', 5, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'filling-the-gaps'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Combining `useEffect` and `useState`, you can load data from an API when a component appears.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'filling-the-gaps' and l.slug = 'fetching-data-from-an-api';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```jsx
function Students() {
  const [students, setStudents] = useState([]);

  useEffect(() => {
    fetch("/api/students")
      .then(res => res.json())
      .then(data => setStudents(data));
  }, []);

  return <ul>{students.map(s => <li key={s.id}>{s.name}</li>)}</ul>;
}
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'filling-the-gaps' and l.slug = 'fetching-data-from-an-api';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Fetch data from any public test API and render the results as a list.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'filling-the-gaps' and l.slug = 'fetching-data-from-an-api';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'filling-the-gaps' and l.slug = 'fetching-data-from-an-api';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$Why is fetch combined with useEffect here instead of called directly in the component body?$md$, $md$["It's not necessary, just a style choice","Calling fetch directly in the render would trigger it on every single render, causing infinite requests","fetch only works inside useEffect","It's faster this way"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'filling-the-gaps' and l.slug = 'fetching-data-from-an-api' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Forgetting the empty dependency array [] on the useEffect — without it, the fetch runs on every render, hammering the API.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'filling-the-gaps' and l.slug = 'fetching-data-from-an-api';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Custom hooks (intro)$md$, 'custom-hooks-intro', 6, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'filling-the-gaps'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$When you find yourself repeating the same useState/useEffect logic in multiple components, you can extract it into your own reusable hook — a function starting with `use`.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'filling-the-gaps' and l.slug = 'custom-hooks-intro';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```jsx
function useWindowWidth() {
  const [width, setWidth] = useState(window.innerWidth);
  useEffect(() => {
    const handler = () => setWidth(window.innerWidth);
    window.addEventListener("resize", handler);
    return () => window.removeEventListener("resize", handler);
  }, []);
  return width;
}
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'filling-the-gaps' and l.slug = 'custom-hooks-intro';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Use `useWindowWidth()` inside a component and display the current width.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'filling-the-gaps' and l.slug = 'custom-hooks-intro';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'filling-the-gaps' and l.slug = 'custom-hooks-intro';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What must a custom hook's name start with?$md$, $md$["Any name works","use","hook","A capital letter only"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'filling-the-gaps' and l.slug = 'custom-hooks-intro' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Not starting a custom hook's name with `use` — React relies on this naming convention to correctly apply its rules of hooks.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'filling-the-gaps' and l.slug = 'custom-hooks-intro';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Context API (intro)$md$, 'context-api-intro', 7, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'filling-the-gaps'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Passing props down through many layers of components ("prop drilling") gets messy. Context lets you share a value (like a logged-in user) with any component that needs it, without passing it through every layer manually.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'filling-the-gaps' and l.slug = 'context-api-intro';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```jsx
const UserContext = createContext(null);

function App() {
  return (
    <UserContext.Provider value={{ name: "Ada" }}>
      <Profile />
    </UserContext.Provider>
  );
}

function Profile() {
  const user = useContext(UserContext);
  return <p>{user.name}</p>;
}
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'filling-the-gaps' and l.slug = 'context-api-intro';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Create a Context for a theme (light/dark) and read it from a nested component.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'filling-the-gaps' and l.slug = 'context-api-intro';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'filling-the-gaps' and l.slug = 'context-api-intro';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What problem does Context mainly solve?$md$, $md$["Making components render faster","Avoiding passing the same prop through many layers of components","Replacing useState entirely","Styling components"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'filling-the-gaps' and l.slug = 'context-api-intro' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Reaching for Context for every piece of state — it's best for genuinely global data (logged-in user, theme), not for state that only one or two components actually need.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'filling-the-gaps' and l.slug = 'context-api-intro';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Assignment 4$md$, $md$Extend your Module 3 capstone todo app: add a route so it has a separate "Stats" page (routing), fetch the initial todos from a fake API endpoint instead of hardcoding them (data fetching), and use a controlled input for adding new todos (forms).

**Pass criteria:** routing works, data loads from a fetch call, form input is properly controlled.$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'filling-the-gaps';


insert into public.modules (track_id, name, slug, order_index)
select t.id, $md$Deploying Your Project (GitHub + Vercel)$md$, 'react-deploying-your-project', 17
from public.tracks t where t.slug = 'frontend'
on conflict (track_id, slug) do update set order_index = excluded.order_index, name = excluded.name;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$What GitHub is and why you need it$md$, 'what-github-is-and-why-you-need-it', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'react-deploying-your-project'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$GitHub stores your code online with version history, and it's how deployment tools like Vercel know what to actually deploy — Vercel connects directly to a GitHub repository.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'react-deploying-your-project' and l.slug = 'what-github-is-and-why-you-need-it';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$**Try it — numbered steps:**
1. Create a free account at github.com if you don't have one
2. Create a new repository
3. From your project folder, run:
```bash
git init
git add .
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/your-username/your-repo.git
git push -u origin main
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'react-deploying-your-project' and l.slug = 'what-github-is-and-why-you-need-it';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'react-deploying-your-project' and l.slug = 'what-github-is-and-why-you-need-it';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What is GitHub mainly used for here?$md$, $md$["Running your app","Storing your code online so deployment tools can access it","Styling your app","Writing your code for you"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'react-deploying-your-project' and l.slug = 'what-github-is-and-why-you-need-it' and s.order_index = 2;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Forgetting to run `git add .` before `git commit` — nothing gets committed if it was never staged first.$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'react-deploying-your-project' and l.slug = 'what-github-is-and-why-you-need-it';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Deploying to Vercel$md$, 'deploying-to-vercel', 1, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'react-deploying-your-project'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Vercel is a free hosting platform built specifically for projects like React apps — it connects to your GitHub repo and automatically builds and deploys your site.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'react-deploying-your-project' and l.slug = 'deploying-to-vercel';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$**Try it — numbered steps:**
1. Go to vercel.com and sign up (you can sign up directly with your GitHub account)
2. Click "Add New Project"
3. Select your GitHub repository
4. Vercel auto-detects it's a Vite/React project — leave the default settings
5. Click "Deploy"
6. After a minute, you'll get a live URL your project is running on$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'react-deploying-your-project' and l.slug = 'deploying-to-vercel';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'react-deploying-your-project' and l.slug = 'deploying-to-vercel';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does Vercel need in order to deploy your project?$md$, $md$["A payment method","Access to your GitHub repository","A separate server you set up yourself","Nothing, it deploys automatically with no setup"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'react-deploying-your-project' and l.slug = 'deploying-to-vercel' and s.order_index = 2;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Making changes locally and expecting the live site to update — you need to `git push` your changes to GitHub for Vercel to pick them up and redeploy automatically.$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'react-deploying-your-project' and l.slug = 'deploying-to-vercel';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Assignment 5 (Capstone extension)$md$, $md$Push your Module 4 project to GitHub and deploy it live on Vercel. Share the live URL.

**Pass criteria:** the live URL works and reflects the current version of the project.$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'react-deploying-your-project';

-- Verified structurally against the source file before publishing.
update public.lessons l set status = 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'frontend'
  and m.slug in ('setting-up-your-react-project', 'why-react-exists', 'props-and-state', 'lists-and-capstone', 'filling-the-gaps', 'react-deploying-your-project');
