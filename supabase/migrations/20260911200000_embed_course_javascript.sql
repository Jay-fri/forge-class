-- Embeds courses/course-javascript.md verbatim as the standalone
-- JavaScript track's full content, replacing the earlier self-authored
-- 5-module/24-lesson content with the real course's own 9-module
-- structure. Frontend's "JavaScript fundamentals" module already absorbs
-- this track's content inline (see Learn.tsx's absorption logic) so no
-- separate authoring/duplication is needed for the Frontend reuse.
-- Content preserved as-written. Inserted as draft; published after
-- structural verification against the source file.


delete from public.modules m
using public.tracks t
where m.track_id = t.id and t.slug = 'javascript-fundamentals';


insert into public.modules (track_id, name, slug, order_index)
select t.id, $md$Getting Started$md$, 'getting-started', 0
from public.tracks t where t.slug = 'javascript-fundamentals'
on conflict (track_id, slug) do update set order_index = excluded.order_index, name = excluded.name;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$What JavaScript actually does$md$, 'what-javascript-actually-does', 0, true, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'getting-started'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$On a webpage, HTML is structure, CSS is style, and JavaScript is **behavior** — it's what makes a button actually do something when clicked, or a page update without reloading.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'getting-started' and l.slug = 'what-javascript-actually-does';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'getting-started' and l.slug = 'what-javascript-actually-does';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$Which of these is JavaScript's job?$md$, $md$["Defining what a paragraph is","Making text blue","Responding to a button click","Setting page margins"]$md$::jsonb, 2, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'getting-started' and l.slug = 'what-javascript-actually-does' and s.order_index = 1;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Assuming JavaScript controls how things *look* by default — that's CSS's job. JavaScript can change CSS, but its core purpose is behavior and logic.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'getting-started' and l.slug = 'what-javascript-actually-does';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Running your first line of code$md$, 'running-your-first-line-of-code', 1, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'getting-started'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Every browser has a built-in console you can use instantly — no setup needed.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'getting-started' and l.slug = 'running-your-first-line-of-code';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$**Try it — numbered steps:**
1. Open your browser
2. Right-click anywhere on a page → Inspect
3. Click the "Console" tab
4. Type the code below and press Enter$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'getting-started' and l.slug = 'running-your-first-line-of-code';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```js
console.log("Hello, Forge");
```$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'getting-started' and l.slug = 'running-your-first-line-of-code';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'getting-started' and l.slug = 'running-your-first-line-of-code';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does console.log() do?$md$, $md$["Deletes the console","Prints a message you can see","Creates a new webpage","Saves a file"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'getting-started' and l.slug = 'running-your-first-line-of-code' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Forgetting the closing quote mark — `console.log("Hello)` throws a `SyntaxError: missing ) after argument list`, which just means the browser got confused about where your text ends.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'getting-started' and l.slug = 'running-your-first-line-of-code';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Variables and data types$md$, 'variables-and-data-types', 2, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'getting-started'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$A variable is a labeled box that holds a value you can reuse. Three common types:

| Type | Example | Use |
|---|---|---|
| String | `"Ada"` | Text |
| Number | `22` | Counting, math |
| Boolean | `true` | Yes/no logic |$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'getting-started' and l.slug = 'variables-and-data-types';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```js
let name = "Ada";
let age = 22;
let isStudent = true;
console.log(name, age, isStudent);
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'getting-started' and l.slug = 'variables-and-data-types';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Create your own variables for your name, age, and favorite language.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'getting-started' and l.slug = 'variables-and-data-types';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'getting-started' and l.slug = 'variables-and-data-types';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What data type is true?$md$, $md$["String","Number","Boolean","Variable"]$md$::jsonb, 2, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'getting-started' and l.slug = 'variables-and-data-types' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Wrapping numbers in quotes by accident — `let age = "22"` makes it a string, not a number, which breaks math later.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'getting-started' and l.slug = 'variables-and-data-types';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Assignment 1 — Profile card$md$, $md$Create variables for your name, age, and a one-line bio, then log a formatted introduction using them.

**Pass criteria:** uses at least 3 variables of different types, output is readable, no console errors.$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'getting-started';


insert into public.modules (track_id, name, slug, order_index)
select t.id, $md$Operators & Control Flow$md$, 'operators-and-control-flow', 1
from public.tracks t where t.slug = 'javascript-fundamentals'
on conflict (track_id, slug) do update set order_index = excluded.order_index, name = excluded.name;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Operators$md$, 'operators', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'operators-and-control-flow'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Arithmetic operators do math (`+ - * /`). Comparison operators compare values and return true/false (`=== > <`).$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'operators-and-control-flow' and l.slug = 'operators';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```js
console.log(5 + 3);
console.log(10 > 7);
console.log("cat" === "cat");
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'operators-and-control-flow' and l.slug = 'operators';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Try `%` (modulo — remainder after division) with two numbers of your choice.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'operators-and-control-flow' and l.slug = 'operators';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'operators-and-control-flow' and l.slug = 'operators';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does 10 > 7 return?$md$, $md$["3","true","false","An error"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'operators-and-control-flow' and l.slug = 'operators' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Using `=` (assignment) when you mean `===` (comparison) — `if (age = 18)` silently sets age to 18 instead of checking it.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'operators-and-control-flow' and l.slug = 'operators';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Conditionals$md$, 'conditionals', 1, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'operators-and-control-flow'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$if/else lets code make decisions — run one block of code if something's true, another if it's false.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'operators-and-control-flow' and l.slug = 'conditionals';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```js
let age = 20;
if (age >= 18) {
  console.log("You can vote");
} else {
  console.log("Not yet");
}
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'operators-and-control-flow' and l.slug = 'conditionals';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Write an if/else that checks if a number is even or odd.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'operators-and-control-flow' and l.slug = 'conditionals';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'operators-and-control-flow' and l.slug = 'conditionals';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does the else block run?$md$, $md$["Always","Only when the if condition is false","Only when there's an error","Never"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'operators-and-control-flow' and l.slug = 'conditionals' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Using `=` instead of `===` inside the condition (see Lesson 2.1) — this is the single most common beginner JS bug.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'operators-and-control-flow' and l.slug = 'conditionals';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Loops$md$, 'loops', 2, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'operators-and-control-flow'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Loops repeat code without copy-pasting it. `for` loops run a set number of times; `while` loops run until a condition becomes false.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'operators-and-control-flow' and l.slug = 'loops';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```js
for (let i = 1; i <= 5; i++) {
  console.log(i);
}
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'operators-and-control-flow' and l.slug = 'loops';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Change the loop to count from 1 to 10 instead.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'operators-and-control-flow' and l.slug = 'loops';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'operators-and-control-flow' and l.slug = 'loops';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does i++ do inside a for loop?$md$, $md$["Resets i to 0","Increases i by 1 each time","Stops the loop","Prints i"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'operators-and-control-flow' and l.slug = 'loops' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Forgetting to increase the loop variable (`i++`) — this creates an infinite loop that freezes the page, because the condition never becomes false.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'operators-and-control-flow' and l.slug = 'loops';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Assignment 2 — FizzBuzz$md$, $md$Print numbers 1–20; for multiples of 3 print "Fizz", multiples of 5 print "Buzz", multiples of both print "FizzBuzz".

**Pass criteria:** correct output for all 20 numbers, uses a loop and conditionals.$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'operators-and-control-flow';


insert into public.modules (track_id, name, slug, order_index)
select t.id, $md$Functions$md$, 'functions', 2
from public.tracks t where t.slug = 'javascript-fundamentals'
on conflict (track_id, slug) do update set order_index = excluded.order_index, name = excluded.name;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Writing your first function$md$, 'writing-your-first-function', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'functions'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$A function is a reusable block of code you define once and run whenever you need it.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'functions' and l.slug = 'writing-your-first-function';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```js
function greet(name) {
  console.log("Hello, " + name);
}
greet("Ada");
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'functions' and l.slug = 'writing-your-first-function';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Call `greet()` with your own name.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'functions' and l.slug = 'writing-your-first-function';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'functions' and l.slug = 'writing-your-first-function';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What do you need to do to actually run a function after defining it?$md$, $md$["Nothing, it runs automatically","Call it by name with parentheses","Refresh the page","Use console.log on it"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'functions' and l.slug = 'writing-your-first-function' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Defining a function but forgetting to *call* it — the code inside never runs on its own.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'functions' and l.slug = 'writing-your-first-function';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Parameters, return values, and scope$md$, 'parameters-return-values-and-scope', 1, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'functions'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Think of a function like a machine: parameters go in, a `return` value comes out. Variables created *inside* a function only exist inside it — that's called scope.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'functions' and l.slug = 'parameters-return-values-and-scope';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```js
function add(a, b) {
  return a + b;
}
let total = add(4, 7);
console.log(total);
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'functions' and l.slug = 'parameters-return-values-and-scope';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Write a function that returns the larger of two numbers.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'functions' and l.slug = 'parameters-return-values-and-scope';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'functions' and l.slug = 'parameters-return-values-and-scope';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What happens to a variable created inside a function once the function finishes?$md$, $md$["It becomes global","It disappears — it only existed inside that function","It gets printed automatically","It becomes a parameter"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'functions' and l.slug = 'parameters-return-values-and-scope' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Forgetting `return` and expecting a value back — without it, the function gives back `undefined` even if it `console.log`'d something internally.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'functions' and l.slug = 'parameters-return-values-and-scope';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Arrow functions$md$, 'arrow-functions', 2, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'functions'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Arrow functions are a shorter way to write the same thing.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'functions' and l.slug = 'arrow-functions';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```js
const add = (a, b) => {
  return a + b;
};
```
Same as the `function add(a, b) {...}` version from before.$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'functions' and l.slug = 'arrow-functions';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Rewrite your Lesson 3.2 function as an arrow function.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'functions' and l.slug = 'arrow-functions';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'functions' and l.slug = 'arrow-functions';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What symbol is unique to arrow function syntax?$md$, $md$["{}","=>","()",";"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'functions' and l.slug = 'arrow-functions' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Forgetting the parentheses around parameters when there's more than one — `a, b => ...` is invalid; it needs `(a, b) => ...`.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'functions' and l.slug = 'arrow-functions';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Assignment 3 — Simple calculator$md$, $md$Write functions `add`, `subtract`, `multiply`, `divide`, each taking two numbers and returning the result.

**Pass criteria:** all four return correct results, `divide` handles division by zero without crashing.$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'functions';


insert into public.modules (track_id, name, slug, order_index)
select t.id, $md$Arrays & Objects$md$, 'arrays-and-objects', 3
from public.tracks t where t.slug = 'javascript-fundamentals'
on conflict (track_id, slug) do update set order_index = excluded.order_index, name = excluded.name;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Arrays and common methods$md$, 'arrays-and-common-methods', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'arrays-and-objects'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$An array is an ordered list of values. Common methods: `push` (add to the end), `map` (transform every item), `filter` (keep only matching items).$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'arrays-and-objects' and l.slug = 'arrays-and-common-methods';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```js
let foods = ["rice", "beans", "yam"];
foods.push("plantain");
console.log(foods);
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'arrays-and-objects' and l.slug = 'arrays-and-common-methods';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Use `.filter()` to keep only foods longer than 4 letters.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'arrays-and-objects' and l.slug = 'arrays-and-common-methods';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'arrays-and-objects' and l.slug = 'arrays-and-common-methods';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does .push() do to an array?$md$, $md$["Removes the last item","Adds an item to the end","Sorts the array","Empties the array"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'arrays-and-objects' and l.slug = 'arrays-and-common-methods' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Forgetting arrays are zero-indexed — `foods[0]` is the *first* item, not `foods[1]`.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'arrays-and-objects' and l.slug = 'arrays-and-common-methods';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Objects$md$, 'objects', 1, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'arrays-and-objects'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$An object stores related data as key-value pairs — useful for modeling a single "thing" with multiple properties, like a student.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'arrays-and-objects' and l.slug = 'objects';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```js
let student = {
  name: "Ada",
  age: 22,
  track: "JavaScript"
};
console.log(student.name);
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'arrays-and-objects' and l.slug = 'objects';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Add a `streak` property to the object and log it.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'arrays-and-objects' and l.slug = 'objects';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'arrays-and-objects' and l.slug = 'objects';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$How do you access a property on an object?$md$, $md$["object[0]","object.propertyName","object->propertyName","object(propertyName)"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'arrays-and-objects' and l.slug = 'objects' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Confusing array index access (`array[0]`) with object property access (`object.name`) — they use different syntax.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'arrays-and-objects' and l.slug = 'objects';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Arrays of objects$md$, 'arrays-of-objects', 2, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'arrays-and-objects'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$This is the pattern used in almost every real app — a list of structured items, like a list of students, each with their own name/age/track.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'arrays-and-objects' and l.slug = 'arrays-of-objects';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```js
let students = [
  { name: "Ada", track: "JavaScript" },
  { name: "Femi", track: "Python" }
];
let jsStudents = students.filter(s => s.track === "JavaScript");
console.log(jsStudents);
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'arrays-and-objects' and l.slug = 'arrays-of-objects';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Add a third student and filter for a different track.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'arrays-and-objects' and l.slug = 'arrays-of-objects';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'arrays-and-objects' and l.slug = 'arrays-of-objects';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does students.filter(s => s.track === "JavaScript") return?$md$, $md$["The whole array unchanged","Only the student objects where track is \"JavaScript\"","Just the word \"JavaScript\"","An error"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'arrays-and-objects' and l.slug = 'arrays-of-objects' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Forgetting `filter` returns a *new* array rather than changing the original — you need to save the result to a variable to use it.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'arrays-and-objects' and l.slug = 'arrays-of-objects';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Assignment 4 — Todo list logic$md$, $md$Build an array of todo objects (`{ text, done }`), write functions to add a todo, mark one done, and filter out completed ones — console output only, no UI yet.

**Pass criteria:** all three functions work correctly on a sample array.$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'arrays-and-objects';


insert into public.modules (track_id, name, slug, order_index)
select t.id, $md$DOM & Events (Capstone)$md$, 'dom-and-events', 4
from public.tracks t where t.slug = 'javascript-fundamentals'
on conflict (track_id, slug) do update set order_index = excluded.order_index, name = excluded.name;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$What the DOM is$md$, 'what-the-dom-is', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'dom-and-events'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$The DOM (Document Object Model) is how JavaScript "sees" your HTML page — as a tree of elements it can read and change.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'dom-and-events' and l.slug = 'what-the-dom-is';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'dom-and-events' and l.slug = 'what-the-dom-is';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does the DOM let JavaScript do?$md$, $md$["Style pages directly (CSS's job)","Read and change page elements","Send emails","Store files"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'dom-and-events' and l.slug = 'what-the-dom-is' and s.order_index = 1;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Thinking the DOM is the same as your HTML source code — it's a live, changeable representation the browser builds from it.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'dom-and-events' and l.slug = 'what-the-dom-is';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Selecting and changing elements$md$, 'selecting-and-changing-elements', 1, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'dom-and-events'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$`document.querySelector()` finds an element on the page; you can then read or change it, like its text.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'dom-and-events' and l.slug = 'selecting-and-changing-elements';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```js
let heading = document.querySelector("h1");
heading.textContent = "Updated!";
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'dom-and-events' and l.slug = 'selecting-and-changing-elements';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Select a paragraph on a page and change its text.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'dom-and-events' and l.slug = 'selecting-and-changing-elements';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'dom-and-events' and l.slug = 'selecting-and-changing-elements';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does .textContent let you do?$md$, $md$["Change an element's color","Read or change an element's text","Delete an element","Add a new element"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'dom-and-events' and l.slug = 'selecting-and-changing-elements' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Using a selector that doesn't match anything on the page — `document.querySelector()` then returns `null`, and trying to change `.textContent` on `null` throws an error.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'dom-and-events' and l.slug = 'selecting-and-changing-elements';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Event listeners$md$, 'event-listeners', 2, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'dom-and-events'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Event listeners run code in response to something happening, like a click.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'dom-and-events' and l.slug = 'event-listeners';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```js
let button = document.querySelector("button");
button.addEventListener("click", () => {
  console.log("Clicked!");
});
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'dom-and-events' and l.slug = 'event-listeners';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Make a button that changes a heading's text when clicked.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'dom-and-events' and l.slug = 'event-listeners';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'dom-and-events' and l.slug = 'event-listeners';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What's the second argument to addEventListener?$md$, $md$["The element itself","A function to run when the event happens","The event's name","A CSS class"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'dom-and-events' and l.slug = 'event-listeners' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Writing `button.addEventListener("click", doSomething())` with parentheses — this calls the function immediately instead of passing it to run *later*, on click.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'dom-and-events' and l.slug = 'event-listeners';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Capstone Assignment — Working todo list in the browser$md$, $md$Build a real todo list with HTML + the JS from Module 4 — add a todo via an input + button, mark items done, remove items.

**Pass criteria:** add/complete/remove all work without errors; this is a portfolio-worthy first project and the assignment that unlocks this track's certificate.$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'dom-and-events';


insert into public.modules (track_id, name, slug, order_index)
select t.id, $md$Modern JavaScript Essentials$md$, 'modern-javascript-essentials', 5
from public.tracks t where t.slug = 'javascript-fundamentals'
on conflict (track_id, slug) do update set order_index = excluded.order_index, name = excluded.name;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Template literals in depth$md$, 'template-literals-in-depth', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'modern-javascript-essentials'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Template literals (backticks) let you embed variables and expressions directly inside a string, and even write multi-line strings — much cleaner than joining strings with `+`.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'modern-javascript-essentials' and l.slug = 'template-literals-in-depth';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```js
let name = "Ada";
let age = 22;
console.log(`${name} is ${age} years old`);
console.log(`Next year: ${age + 1}`);
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'modern-javascript-essentials' and l.slug = 'template-literals-in-depth';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Build a sentence using a template literal that includes a calculation inside `${}`.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'modern-javascript-essentials' and l.slug = 'template-literals-in-depth';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'modern-javascript-essentials' and l.slug = 'template-literals-in-depth';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What symbol wraps a template literal?$md$, $md$["Double quotes \"","Backticks `","Single quotes '","Curly braces only"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'modern-javascript-essentials' and l.slug = 'template-literals-in-depth' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Using regular quotes instead of backticks and expecting `${}` to work — `${}` only works inside backtick strings.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'modern-javascript-essentials' and l.slug = 'template-literals-in-depth';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Destructuring$md$, 'destructuring', 1, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'modern-javascript-essentials'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Destructuring lets you pull values out of arrays or objects into their own variables in one line.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'modern-javascript-essentials' and l.slug = 'destructuring';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```js
let student = { name: "Ada", age: 22 };
let { name, age } = student;
console.log(name, age);

let [first, second] = ["red", "blue"];
console.log(first, second);
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'modern-javascript-essentials' and l.slug = 'destructuring';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Destructure a `track` and `streak` value out of an object you create.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'modern-javascript-essentials' and l.slug = 'destructuring';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'modern-javascript-essentials' and l.slug = 'destructuring';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does let { name, age } = student; do?$md$, $md$["Deletes name and age from student","Creates variables name and age from the object's matching properties","Creates one variable called nameage","Causes an error"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'modern-javascript-essentials' and l.slug = 'destructuring' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Misspelling a property name during destructuring — `let { naem } = student` creates a variable called `naem` with the value `undefined`, silently, no error thrown.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'modern-javascript-essentials' and l.slug = 'destructuring';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Spread and rest operators$md$, 'spread-and-rest-operators', 2, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'modern-javascript-essentials'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$The `...` syntax has two uses: "spreading" an array/object out (copying/combining), or "resting" multiple arguments into one array.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'modern-javascript-essentials' and l.slug = 'spread-and-rest-operators';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```js
let a = [1, 2, 3];
let b = [...a, 4, 5];
console.log(b);

function sumAll(...numbers) {
  return numbers.reduce((total, n) => total + n, 0);
}
console.log(sumAll(1, 2, 3, 4));
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'modern-javascript-essentials' and l.slug = 'spread-and-rest-operators';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Use spread to combine two arrays of your own into one.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'modern-javascript-essentials' and l.slug = 'spread-and-rest-operators';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'modern-javascript-essentials' and l.slug = 'spread-and-rest-operators';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does [...a, 4, 5] create?$md$, $md$["A nested array containing a","A new array with all of a's items plus 4 and 5","An error","The number 45"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'modern-javascript-essentials' and l.slug = 'spread-and-rest-operators' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Confusing spread (expanding values out) with rest (gathering values in) — same `...` syntax, opposite purpose, depending on where it's used.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'modern-javascript-essentials' and l.slug = 'spread-and-rest-operators';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$More array methods$md$, 'more-array-methods', 3, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'modern-javascript-essentials'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Beyond `map`/`filter`: `.reduce()` combines all items into one value, `.find()` returns the first match, `.sort()` orders items, `.some()`/`.every()` test conditions across the array.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'modern-javascript-essentials' and l.slug = 'more-array-methods';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```js
let numbers = [3, 1, 4, 1, 5];
let total = numbers.reduce((sum, n) => sum + n, 0);
let hasBigNumber = numbers.some(n => n > 4);
console.log(total, hasBigNumber);
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'modern-javascript-essentials' and l.slug = 'more-array-methods';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Use `.find()` to get the first number greater than 3 from an array.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'modern-javascript-essentials' and l.slug = 'more-array-methods';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'modern-javascript-essentials' and l.slug = 'more-array-methods';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does .reduce() do?$md$, $md$["Removes items from an array","Combines all items into a single value","Sorts the array","Doubles every item"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'modern-javascript-essentials' and l.slug = 'more-array-methods' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Forgetting `.reduce()`'s second argument (the starting value) — without it, the first array item becomes the starting point, which can cause subtle bugs.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'modern-javascript-essentials' and l.slug = 'more-array-methods';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Assignment 6$md$, $md$Rewrite your Module 4 todo-list functions using destructuring, spread, and at least one of reduce/find/some.

**Pass criteria:** functions still work correctly, uses at least 3 of the techniques above.$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'modern-javascript-essentials';


insert into public.modules (track_id, name, slug, order_index)
select t.id, $md$Closures, Async JavaScript & Errors$md$, 'closures-async-javascript-and-errors', 6
from public.tracks t where t.slug = 'javascript-fundamentals'
on conflict (track_id, slug) do update set order_index = excluded.order_index, name = excluded.name;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Closures$md$, 'closures', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'closures-async-javascript-and-errors'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$A closure is a function that "remembers" variables from where it was created, even after that outer function has finished running.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'closures-async-javascript-and-errors' and l.slug = 'closures';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```js
function makeCounter() {
  let count = 0;
  return function () {
    count++;
    return count;
  };
}
let counter = makeCounter();
console.log(counter());
console.log(counter());
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'closures-async-javascript-and-errors' and l.slug = 'closures';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Run the code above twice and notice the count keeps increasing — it "remembers" between calls.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'closures-async-javascript-and-errors' and l.slug = 'closures';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'closures-async-javascript-and-errors' and l.slug = 'closures';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does the inner function in a closure remember?$md$, $md$["Nothing, each call starts fresh","Variables from the outer function where it was created","Only global variables","The page's HTML"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'closures-async-javascript-and-errors' and l.slug = 'closures' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Expecting `count` to reset to 0 every time `counter()` is called — closures specifically remember state between calls, that's the whole point.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'closures-async-javascript-and-errors' and l.slug = 'closures';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Asynchronous JavaScript: Promises$md$, 'asynchronous-javascript-promises', 1, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'closures-async-javascript-and-errors'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Some operations (like fetching data) take time. A Promise represents a value that will be available *later* — either successfully (`resolved`) or with an error (`rejected`).$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'closures-async-javascript-and-errors' and l.slug = 'asynchronous-javascript-promises';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```js
function delayedGreeting() {
  return new Promise((resolve) => {
    setTimeout(() => resolve("Hello later!"), 1000);
  });
}
delayedGreeting().then(message => console.log(message));
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'closures-async-javascript-and-errors' and l.slug = 'asynchronous-javascript-promises';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Chain a second `.then()` after the first to log another message.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'closures-async-javascript-and-errors' and l.slug = 'asynchronous-javascript-promises';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'closures-async-javascript-and-errors' and l.slug = 'asynchronous-javascript-promises';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does .then() do on a Promise?$md$, $md$["Runs immediately, ignoring the delay","Runs once the Promise resolves","Cancels the Promise","Creates a new variable"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'closures-async-javascript-and-errors' and l.slug = 'asynchronous-javascript-promises' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Forgetting that code after a Promise call keeps running immediately — `console.log("done")` right after `delayedGreeting()` runs *before* the promise resolves, not after.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'closures-async-javascript-and-errors' and l.slug = 'asynchronous-javascript-promises';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$async/await$md$, 'async-await', 2, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'closures-async-javascript-and-errors'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$`async`/`await` is a cleaner way to write Promise-based code — it lets asynchronous code read almost like normal step-by-step code.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'closures-async-javascript-and-errors' and l.slug = 'async-await';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```js
async function getGreeting() {
  let message = await delayedGreeting();
  console.log(message);
}
getGreeting();
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'closures-async-javascript-and-errors' and l.slug = 'async-await';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Rewrite your Lesson 7.2 `.then()` chain using `async`/`await` instead.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'closures-async-javascript-and-errors' and l.slug = 'async-await';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'closures-async-javascript-and-errors' and l.slug = 'async-await';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does await do inside an async function?$md$, $md$["Skips the Promise entirely","Pauses that function until the Promise resolves","Deletes the Promise","Makes the code run faster"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'closures-async-javascript-and-errors' and l.slug = 'async-await' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Using `await` outside of a function marked `async` — this is a syntax error; `await` only works inside `async` functions.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'closures-async-javascript-and-errors' and l.slug = 'async-await';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Fetching real data with the Fetch API$md$, 'fetching-real-data-with-the-fetch-api', 3, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'closures-async-javascript-and-errors'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$`fetch()` is the built-in way to request data from a server, and it returns a Promise.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'closures-async-javascript-and-errors' and l.slug = 'fetching-real-data-with-the-fetch-api';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```js
async function getStudents() {
  let response = await fetch("/api/students");
  let data = await response.json();
  console.log(data);
}
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'closures-async-javascript-and-errors' and l.slug = 'fetching-real-data-with-the-fetch-api';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Fetch data from any public test API and log the result.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'closures-async-javascript-and-errors' and l.slug = 'fetching-real-data-with-the-fetch-api';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'closures-async-javascript-and-errors' and l.slug = 'fetching-real-data-with-the-fetch-api';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$Why is there a second await response.json()?$md$, $md$["It's optional","Converting the raw response into usable data also takes time and returns a Promise","It's a typo","fetch() doesn't work without it"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'closures-async-javascript-and-errors' and l.slug = 'fetching-real-data-with-the-fetch-api' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Forgetting the first `await` on `fetch()` itself — without it, `response` is a Promise object, not the actual response, and trying to call `.json()` on it directly breaks.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'closures-async-javascript-and-errors' and l.slug = 'fetching-real-data-with-the-fetch-api';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Error handling with try/catch$md$, 'error-handling-with-try-catch', 4, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'closures-async-javascript-and-errors'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$`try/catch` lets you handle errors gracefully instead of crashing the whole program.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'closures-async-javascript-and-errors' and l.slug = 'error-handling-with-try-catch';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```js
async function getStudents() {
  try {
    let response = await fetch("/api/students");
    let data = await response.json();
    console.log(data);
  } catch (error) {
    console.log("Something went wrong:", error.message);
  }
}
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'closures-async-javascript-and-errors' and l.slug = 'error-handling-with-try-catch';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Deliberately fetch a URL that doesn't exist and see the catch block run.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'closures-async-javascript-and-errors' and l.slug = 'error-handling-with-try-catch';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'closures-async-javascript-and-errors' and l.slug = 'error-handling-with-try-catch';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does the catch block run?$md$, $md$["Always, no matter what","Only if something inside try throws an error","Before the try block","Never, it's optional decoration"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'closures-async-javascript-and-errors' and l.slug = 'error-handling-with-try-catch' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Wrapping code in `try/catch` but doing nothing useful in `catch` (or leaving it empty) — silently swallowing errors makes bugs much harder to find later.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'closures-async-javascript-and-errors' and l.slug = 'error-handling-with-try-catch';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Assignment 7$md$, $md$Rewrite your Module 4 fetch-based logic (or write a new small feature) using async/await with proper try/catch error handling, and use a closure somewhere meaningfully (e.g. a counter or a simple cache).

**Pass criteria:** async/await used correctly, errors are actually handled, closure behaves correctly.$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'closures-async-javascript-and-errors';


insert into public.modules (track_id, name, slug, order_index)
select t.id, $md$Modules, JSON & Basic OOP$md$, 'modules-json-and-basic-oop', 7
from public.tracks t where t.slug = 'javascript-fundamentals'
on conflict (track_id, slug) do update set order_index = excluded.order_index, name = excluded.name;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$ES Modules$md$, 'es-modules', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'modules-json-and-basic-oop'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$As projects grow, you split code across multiple files. `export` shares something from a file; `import` brings it into another file.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'modules-json-and-basic-oop' and l.slug = 'es-modules';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```js
// math.js
export function add(a, b) {
  return a + b;
}

// app.js
import { add } from "./math.js";
console.log(add(2, 3));
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'modules-json-and-basic-oop' and l.slug = 'es-modules';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Split one of your earlier functions into its own file and import it.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'modules-json-and-basic-oop' and l.slug = 'es-modules';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'modules-json-and-basic-oop' and l.slug = 'es-modules';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does export do to a function?$md$, $md$["Deletes it","Makes it available to import in other files","Runs it immediately","Converts it to a string"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'modules-json-and-basic-oop' and l.slug = 'es-modules' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Forgetting the file extension or exact path in an import statement — `import { add } from "./math"` (missing `.js`) can fail depending on your setup.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'modules-json-and-basic-oop' and l.slug = 'es-modules';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Working with JSON$md$, 'working-with-json', 1, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'modules-json-and-basic-oop'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$JSON (JavaScript Object Notation) is a text format for representing data — it's what most APIs send and receive. `JSON.stringify()` turns a JS object into a JSON string; `JSON.parse()` does the reverse.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'modules-json-and-basic-oop' and l.slug = 'working-with-json';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```js
let student = { name: "Ada", age: 22 };
let jsonString = JSON.stringify(student);
console.log(jsonString);

let backToObject = JSON.parse(jsonString);
console.log(backToObject.name);
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'modules-json-and-basic-oop' and l.slug = 'working-with-json';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Stringify an object, then parse it back and confirm it matches the original.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'modules-json-and-basic-oop' and l.slug = 'working-with-json';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'modules-json-and-basic-oop' and l.slug = 'working-with-json';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does JSON.parse() do?$md$, $md$["Turns an object into text","Turns JSON text back into a usable JS object","Deletes JSON data","Sends data to a server"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'modules-json-and-basic-oop' and l.slug = 'working-with-json' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Trying to access a property directly on a JSON string before parsing it — `jsonString.name` gives `undefined` since it's still just text, not an object yet.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'modules-json-and-basic-oop' and l.slug = 'working-with-json';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Basic classes$md$, 'basic-classes', 2, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'modules-json-and-basic-oop'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$A class is a template for creating objects with shared structure and behavior — useful when you need many similar objects (like many students).$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'modules-json-and-basic-oop' and l.slug = 'basic-classes';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```js
class Student {
  constructor(name, track) {
    this.name = name;
    this.track = track;
  }
  introduce() {
    console.log(`Hi, I'm ${this.name}, learning ${this.track}`);
  }
}
let student1 = new Student("Ada", "JavaScript");
student1.introduce();
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'modules-json-and-basic-oop' and l.slug = 'basic-classes';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Add a second method to the class, like `graduate()` that logs a completion message.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'modules-json-and-basic-oop' and l.slug = 'basic-classes';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'modules-json-and-basic-oop' and l.slug = 'basic-classes';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does the constructor method do?$md$, $md$["Runs every time a method is called","Runs once, when a new object is created with new","Deletes the object","Nothing, it's optional decoration"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'modules-json-and-basic-oop' and l.slug = 'basic-classes' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Forgetting the `new` keyword when creating an instance (`let s = Student(...)` instead of `new Student(...)`) — this causes an error since classes must be constructed with `new`.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'modules-json-and-basic-oop' and l.slug = 'basic-classes';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Assignment 8$md$, $md$Refactor your Module 5 capstone todo app to use a `Todo` class instead of plain objects, split your code across at least two files using import/export, and use JSON.stringify/parse to save/load the todo list from browser localStorage.

**Pass criteria:** class works correctly, modules import/export properly, todos persist across a page refresh.$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'modules-json-and-basic-oop';


insert into public.modules (track_id, name, slug, order_index)
select t.id, $md$Deploying Your Project (GitHub + Vercel)$md$, 'deploying-your-project', 8
from public.tracks t where t.slug = 'javascript-fundamentals'
on conflict (track_id, slug) do update set order_index = excluded.order_index, name = excluded.name;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Pushing your project to GitHub$md$, 'pushing-your-project-to-github', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'deploying-your-project'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$GitHub stores your code online and is what deployment tools connect to.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'deploying-your-project' and l.slug = 'pushing-your-project-to-github';


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
where t.slug = 'javascript-fundamentals' and m.slug = 'deploying-your-project' and l.slug = 'pushing-your-project-to-github';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'deploying-your-project' and l.slug = 'pushing-your-project-to-github';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does git push do?$md$, $md$["Deletes your local code","Uploads your committed code to GitHub","Runs your code","Installs packages"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'deploying-your-project' and l.slug = 'pushing-your-project-to-github' and s.order_index = 2;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Forgetting to `git add` and `git commit` new changes before pushing — `git push` only sends what's already been committed.$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'deploying-your-project' and l.slug = 'pushing-your-project-to-github';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Deploying to Vercel$md$, 'deploying-to-vercel', 1, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'deploying-your-project'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Vercel is a free hosting platform that connects directly to your GitHub repo and automatically deploys your site whenever you push changes.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'deploying-your-project' and l.slug = 'deploying-to-vercel';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$**Try it — numbered steps:**
1. Go to vercel.com and sign up (can use your GitHub account directly)
2. Click "Add New Project" and select your repository
3. Leave the default settings for a plain HTML/JS project
4. Click "Deploy"
5. You'll get a live URL in about a minute$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'deploying-your-project' and l.slug = 'deploying-to-vercel';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'deploying-your-project' and l.slug = 'deploying-to-vercel';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What happens when you push new changes to GitHub after deploying?$md$, $md$["Nothing, you have to redeploy manually every time","Vercel automatically rebuilds and redeploys your site","The live site breaks","You need a new Vercel account"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'deploying-your-project' and l.slug = 'deploying-to-vercel' and s.order_index = 2;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Testing changes only in your local files and forgetting to push to GitHub — the live Vercel site only reflects what's actually been pushed.$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'deploying-your-project' and l.slug = 'deploying-to-vercel';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Assignment 9 (Capstone extension)$md$, $md$Push your final todo app project to GitHub and deploy it live on Vercel. Share the live URL.

**Pass criteria:** live URL works and matches the current version of the project.$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'deploying-your-project';

-- Verified structurally against the source file before publishing.
update public.lessons l set status = 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'javascript-fundamentals';
