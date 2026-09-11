-- JavaScript Fundamentals track, built out in full per forge-curriculum.md's
-- worked example: 5 modules, 15 lessons, one assignment per module. This is
-- the flagship complete track the curriculum doc calls for; tracks 2-6 are
-- seeded at outline/skeleton depth in a companion migration.

insert into public.tracks (name, slug, level, description, order_index)
values (
  'JavaScript Fundamentals',
  'javascript-fundamentals',
  'beginner',
  $md$Variables, logic, functions, and the DOM: everything you need to go from zero to a real working project in the browser.$md$,
  1
)
on conflict (slug) do nothing;

insert into public.bundle_tracks (bundle_id, track_id)
select b.id, t.id
from public.bundles b, public.tracks t
where b.slug = 'javascript' and t.slug = 'javascript-fundamentals'
on conflict do nothing;


-- ── Module: Getting started ────────────────────────────────────────────

insert into public.modules (track_id, name, slug, order_index)
select id, 'Getting started', 'getting-started', 0
from public.tracks where slug = 'javascript-fundamentals'
on conflict (track_id, slug) do nothing;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$What JavaScript actually does$md$, 'what-javascript-actually-does', 0, true, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'getting-started'
on conflict (module_id, slug) do nothing;


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$The three layers of a webpage$md$, $md$Every webpage you use is built from three layers working together.

| Layer | Job |
|---|---|
| HTML | The structure: what's on the page |
| CSS | The look: colors, spacing, layout |
| JavaScript | The behavior: what happens when you click, type, or scroll |

This track is about the third layer. By the end, you'll be able to make a page respond to what a person does, not just sit there looking pretty.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'getting-started' and l.slug = 'what-javascript-actually-does';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$No setup required$md$, $md$JavaScript runs inside the browser you already have open. Every browser ships with a console built in, a small sandbox where you can type JavaScript and see it run immediately.

That means you don't need to install anything to start. The next lesson shows you exactly where to find it.$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'getting-started' and l.slug = 'what-javascript-actually-does';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id,
  $md$Which of these does JavaScript control?$md$,
  '["Structure","Appearance","Behavior","All three"]'::jsonb,
  2,
  $md$HTML handles structure, CSS handles appearance, and JavaScript handles behavior: what happens when someone interacts with the page.$md$,
  0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'getting-started' and l.slug = 'what-javascript-actually-does' and s.title = 'No setup required';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Running your first line of code$md$, 'running-your-first-line-of-code', 1, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'getting-started'
on conflict (module_id, slug) do nothing;


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Open your browser console$md$, $md$You don't need an editor for this, just your browser.

1. Open your browser (Chrome, Edge, and Firefox all work)
2. Right-click anywhere on a page and choose Inspect
3. Click the Console tab in the panel that opens
4. Click inside the console, type the code below, and press Enter

```js
console.log("Hello, Forge");
```

You should see "Hello, Forge" printed right back at you. `console.log` is how JavaScript talks back to you while you're building something. You'll use it constantly, not just here.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'getting-started' and l.slug = 'running-your-first-line-of-code';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Common mistake$md$, $md$**Common mistake:** forgetting the closing quote mark.

```js
console.log("Hello, Forge);
```

This throws `Uncaught SyntaxError: Invalid or unexpected token`. JavaScript doesn't know where your text ends, so it gives up on the whole line. Whenever you see a SyntaxError, check that your quotes, brackets, and parentheses are all closed in pairs.$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'getting-started' and l.slug = 'running-your-first-line-of-code';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id,
  $md$What does console.log do?$md$,
  '["Deletes a variable","Prints a value so you can see it","Creates a new webpage","Saves your code"]'::jsonb,
  1,
  $md$console.log prints whatever you give it to the console, which is the main way you check what your code is actually doing while you write it.$md$,
  0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'getting-started' and l.slug = 'running-your-first-line-of-code' and s.title = 'Common mistake';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Variables and data types$md$, 'variables-and-data-types', 2, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'getting-started'
on conflict (module_id, slug) do nothing;


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$What a variable is$md$, $md$A variable is a labeled box that holds a value so you can use it again later, instead of retyping it every time.

```js
let name = "Ada";
let age = 22;
let isStudent = true;
console.log(name, age, isStudent);
```

`let` creates the box, the name after it is the label, and whatever comes after `=` is what goes inside.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'getting-started' and l.slug = 'variables-and-data-types';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Three data types you will use constantly$md$, $md$| Type | Example | Use |
|---|---|---|
| String | `"Ada"` | Text |
| Number | `22` | Counting, math |
| Boolean | `true` | Yes or no logic |

Strings always sit inside quotes, either `"double"` or `'single'`, it doesn't matter which as long as you're consistent. Numbers and booleans never use quotes.$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'getting-started' and l.slug = 'variables-and-data-types';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id,
  $md$What data type is true?$md$,
  '["String","Number","Boolean","Variable"]'::jsonb,
  2,
  $md$true and false are booleans, JavaScript built-in way of representing yes/no or on/off logic.$md$,
  0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'getting-started' and l.slug = 'variables-and-data-types' and s.title = 'Three data types you will use constantly';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Try it yourself$md$, $md$Edit the variables below with your own name, age, and favorite language, then check the preview. This uses a template literal (the backtick strings with ${} inside) to drop your variables into some text.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'getting-started' and l.slug = 'variables-and-data-types';


update public.sections s
set sandbox_template = 'vanilla',
    sandbox_files = jsonb_build_object(
      '/index.html', $md$<!doctype html>
<html>
  <body></body>
</html>
$md$,
      '/index.js', $md$let name = "Type your name";
let age = 0;
let favoriteLanguage = "JavaScript";

document.body.innerHTML = `
  <h1>${name}</h1>
  <p>Age: ${age}</p>
  <p>Favorite language: ${favoriteLanguage}</p>
`;
$md$
    )
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'javascript-fundamentals' and m.slug = 'getting-started' and l.slug = 'variables-and-data-types'
  and s.title = 'Try it yourself';


insert into public.assignments (module_id, title, spec, starter_code, starter_template)
select m.id, $md$Profile card$md$, $md$## Profile card

Create variables for your name, age, and a one-line bio, then log a formatted introduction using them.

### Requirements
- Use at least 3 variables of different types (string, number, boolean, any combination as long as there are 3 or more and more than one type)
- Log a readable introduction to the console using those variables
- No errors in the console

### Example output
```
Hi, I'm Ada. I'm 22 years old and still learning, but I already shipped my first project.
```

Your output doesn't need to match this exactly, it just needs to read like a real introduction built from your variables.$md$, null, null
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'getting-started';


-- ── Module: Operators and control flow ────────────────────────────────────────────

insert into public.modules (track_id, name, slug, order_index)
select id, 'Operators and control flow', 'operators-and-control-flow', 1
from public.tracks where slug = 'javascript-fundamentals'
on conflict (track_id, slug) do nothing;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Arithmetic and comparison operators$md$, 'arithmetic-and-comparison-operators', 0, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'operators-and-control-flow'
on conflict (module_id, slug) do nothing;


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Doing math$md$, $md$JavaScript's arithmetic operators work the way you'd expect from a calculator.

| Operator | Meaning | Example | Result |
|---|---|---|---|
| `+` | Add | `2 + 3` | `5` |
| `-` | Subtract | `5 - 2` | `3` |
| `*` | Multiply | `4 * 3` | `12` |
| `/` | Divide | `10 / 2` | `5` |

```js
let total = 4 * 3;
console.log(total);
```$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'operators-and-control-flow' and l.slug = 'arithmetic-and-comparison-operators';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Comparing values$md$, $md$Comparison operators check a relationship between two values and give you back `true` or `false`.

| Operator | Meaning |
|---|---|
| `===` | Equal to |
| `!==` | Not equal to |
| `>` | Greater than |
| `<` | Less than |

```js
console.log(5 === 5);
console.log(5 === "5");
```

The second line prints `false`. `===` checks both value and type, a number is never equal to a string that merely looks the same.$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'operators-and-control-flow' and l.slug = 'arithmetic-and-comparison-operators';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id,
  $md$What does 5 === "5" return?$md$,
  '["true","false","5","an error"]'::jsonb,
  1,
  $md$=== checks type as well as value. 5 is a number and "5" is a string, so they are not strictly equal.$md$,
  0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'operators-and-control-flow' and l.slug = 'arithmetic-and-comparison-operators' and s.title = 'Comparing values';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Try it yourself$md$, $md$Change the values of `a` and `b` and watch every result update.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'operators-and-control-flow' and l.slug = 'arithmetic-and-comparison-operators';


update public.sections s
set sandbox_template = 'vanilla',
    sandbox_files = jsonb_build_object(
      '/index.html', $md$<!doctype html>
<html>
  <body></body>
</html>
$md$,
      '/index.js', $md$const a = 8;
const b = 3;

document.body.innerHTML = `
  <p>${a} + ${b} = ${a + b}</p>
  <p>${a} - ${b} = ${a - b}</p>
  <p>${a} * ${b} = ${a * b}</p>
  <p>${a} > ${b}: ${a > b}</p>
`;
$md$
    )
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'javascript-fundamentals' and m.slug = 'operators-and-control-flow' and l.slug = 'arithmetic-and-comparison-operators'
  and s.title = 'Try it yourself';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Conditionals$md$, 'conditionals', 1, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'operators-and-control-flow'
on conflict (module_id, slug) do nothing;


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$if and else$md$, $md$An `if` statement runs some code only when a condition is true.

```js
let age = 20;

if (age >= 18) {
  console.log("You can vote");
} else {
  console.log("Not yet");
}
```

JavaScript checks the condition inside the parentheses. If it's true, the first block runs. If it's false, it skips straight to `else`.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'operators-and-control-flow' and l.slug = 'conditionals';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Common mistake$md$, $md$**Common mistake:** writing `=` instead of `===`.

```js
if (age = 18) {
  console.log("You're 18");
}
```

A single `=` assigns a value instead of comparing one, so `age` silently becomes `18` and the condition is almost always treated as true, no matter what age actually was. Always use `===` when you're checking, and save a single `=` for assigning.$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'operators-and-control-flow' and l.slug = 'conditionals';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id,
  $md$What is the difference between = and ===?$md$,
  '["No difference","= assigns a value, === compares two values","=== assigns a value, = compares two values","Both compare values"]'::jsonb,
  1,
  $md$A single = sets a variable value. === checks whether two values are equal without changing anything.$md$,
  0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'operators-and-control-flow' and l.slug = 'conditionals' and s.title = 'Common mistake';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Try it yourself$md$, $md$Change `age` above and watch the message switch between the two outcomes.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'operators-and-control-flow' and l.slug = 'conditionals';


update public.sections s
set sandbox_template = 'vanilla',
    sandbox_files = jsonb_build_object(
      '/index.html', $md$<!doctype html>
<html>
  <body></body>
</html>
$md$,
      '/index.js', $md$let age = 16;

let message = age >= 18 ? "You can vote" : "Not yet";

document.body.innerHTML = `<p>${message}</p>`;
$md$
    )
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'javascript-fundamentals' and m.slug = 'operators-and-control-flow' and l.slug = 'conditionals'
  and s.title = 'Try it yourself';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Loops$md$, 'loops', 2, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'operators-and-control-flow'
on conflict (module_id, slug) do nothing;


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Repeating code with for$md$, $md$A `for` loop repeats a block of code a set number of times.

```js
for (let i = 1; i <= 10; i++) {
  console.log(i);
}
```

The three parts inside the parentheses are: start (`let i = 1`), the condition to keep going (`i <= 10`), and what happens after each round (`i++`, which means add one).$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'operators-and-control-flow' and l.slug = 'loops';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Common mistake$md$, $md$**Common mistake:** forgetting to update the counter.

```js
for (let i = 1; i <= 10; ) {
  console.log(i);
}
```

Without `i++`, `i` never changes, the condition `i <= 10` is always true, and the loop runs forever. This is called an infinite loop, and it will freeze your browser tab. If a page suddenly stops responding while you're testing a loop, this is usually why.$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'operators-and-control-flow' and l.slug = 'loops';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id,
  $md$What causes an infinite loop in a for loop?$md$,
  '["Starting i at 0","Using <= instead of <","Forgetting to update the counter each round","Using console.log inside the loop"]'::jsonb,
  2,
  $md$If the counter never changes, the loop condition never becomes false, so it repeats forever.$md$,
  0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'operators-and-control-flow' and l.slug = 'loops' and s.title = 'Common mistake';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Try it yourself$md$, $md$Change the loop to count to 20 instead of 10, or to count by 2s.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'operators-and-control-flow' and l.slug = 'loops';


update public.sections s
set sandbox_template = 'vanilla',
    sandbox_files = jsonb_build_object(
      '/index.html', $md$<!doctype html>
<html>
  <body></body>
</html>
$md$,
      '/index.js', $md$let output = "";
for (let i = 1; i <= 10; i++) {
  output += `${i} `;
}
document.body.innerHTML = `<p>${output}</p>`;
$md$
    )
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'javascript-fundamentals' and m.slug = 'operators-and-control-flow' and l.slug = 'loops'
  and s.title = 'Try it yourself';


insert into public.assignments (module_id, title, spec, starter_code, starter_template)
select m.id, $md$FizzBuzz$md$, $md$## FizzBuzz

Print the numbers 1 through 20. For multiples of 3, print "Fizz" instead of the number. For multiples of 5, print "Buzz". For multiples of both 3 and 5, print "FizzBuzz".

### Requirements
- Correct output for all 20 numbers
- Uses a loop and conditionals, not 20 separate console.log calls

### Example (first few lines)
```
1
2
Fizz
4
Buzz
```$md$, jsonb_build_object(
      '/index.js', $md$for (let i = 1; i <= 20; i++) {
  // your code here
}
$md$
    ), 'vanilla'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'operators-and-control-flow';


-- ── Module: Functions ────────────────────────────────────────────

insert into public.modules (track_id, name, slug, order_index)
select id, 'Functions', 'functions', 2
from public.tracks where slug = 'javascript-fundamentals'
on conflict (track_id, slug) do nothing;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Writing your first function$md$, 'writing-your-first-function', 0, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'functions'
on conflict (module_id, slug) do nothing;


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$A function is a reusable block of code$md$, $md$A function is a named, reusable block of code. You write it once and run it as many times as you want.

```js
function greet(name) {
  console.log(`Hello, ${name}!`);
}

greet("Ada");
greet("Priya");
```

`name` here is a parameter, a placeholder for whatever value gets passed in when the function is called.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'functions' and l.slug = 'writing-your-first-function';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id,
  $md$What is a parameter?$md$,
  '["A fixed value that never changes","A placeholder for a value passed into a function","The result a function gives back","A type of loop"]'::jsonb,
  1,
  $md$A parameter is a named placeholder inside a function parentheses. The actual value comes from whatever is passed in when the function is called.$md$,
  0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'functions' and l.slug = 'writing-your-first-function' and s.title = 'A function is a reusable block of code';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Try it yourself$md$, $md$Change the name being passed to `greet`, or write a second function of your own.$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'functions' and l.slug = 'writing-your-first-function';


update public.sections s
set sandbox_template = 'vanilla',
    sandbox_files = jsonb_build_object(
      '/index.html', $md$<!doctype html>
<html>
  <body></body>
</html>
$md$,
      '/index.js', $md$function greet(name) {
  return `Hello, ${name}!`;
}

document.body.innerHTML = `<p>${greet("your name here")}</p>`;
$md$
    )
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'javascript-fundamentals' and m.slug = 'functions' and l.slug = 'writing-your-first-function'
  and s.title = 'Try it yourself';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Parameters, return values, and scope$md$, 'parameters-return-values-and-scope', 1, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'functions'
on conflict (module_id, slug) do nothing;


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$A function as a machine$md$, $md$Think of a function as a small machine: input goes in, something happens, output comes out.

```js
function add(a, b) {
  return a + b;
}

let total = add(4, 7);
console.log(total);
```

`return` is what sends a value back out of the function. Without it, calling `add(4, 7)` would run the code but give you back `undefined`, nothing to actually use.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'functions' and l.slug = 'parameters-return-values-and-scope';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Scope$md$, $md$A variable created inside a function only exists inside that function, this is called scope.

```js
function double(n) {
  let result = n * 2;
  return result;
}

console.log(result); // Error: result is not defined
```

`result` was created inside `double`, so it disappears once the function finishes. If you need a value outside the function, you have to `return` it.$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'functions' and l.slug = 'parameters-return-values-and-scope';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id,
  $md$Why does console.log(result) fail in the example above?$md$,
  '["result was never given a value","result only exists inside the double function","console.log does not work with numbers","There is a typo in the code"]'::jsonb,
  1,
  $md$Variables declared inside a function are scoped to that function. Once the function finishes running, those variables are gone.$md$,
  0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'functions' and l.slug = 'parameters-return-values-and-scope' and s.title = 'Scope';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Arrow functions$md$, 'arrow-functions', 2, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'functions'
on conflict (module_id, slug) do nothing;


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$A shorter way to write functions$md$, $md$Arrow functions are a shorter way to write the same thing.

| Regular function | Arrow function |
|---|---|
| `function greet(name) { return "Hi, " + name; }` | `const greet = (name) => "Hi, " + name;` |

```js
function add(a, b) {
  return a + b;
}

const add2 = (a, b) => a + b;

console.log(add(2, 3), add2(2, 3));
```

Both versions do exactly the same thing. When an arrow function body is a single expression, you can skip both the curly braces and the word `return`, it returns automatically.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'functions' and l.slug = 'arrow-functions';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Try it yourself$md$, $md$Rewrite `multiply` as a regular function using the `function` keyword instead, then check that it still works.$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'functions' and l.slug = 'arrow-functions';


update public.sections s
set sandbox_template = 'vanilla',
    sandbox_files = jsonb_build_object(
      '/index.html', $md$<!doctype html>
<html>
  <body></body>
</html>
$md$,
      '/index.js', $md$const add = (a, b) => a + b;
const multiply = (a, b) => a * b;

document.body.innerHTML = `
  <p>Sum: ${add(6, 4)}</p>
  <p>Product: ${multiply(6, 4)}</p>
`;
$md$
    )
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'javascript-fundamentals' and m.slug = 'functions' and l.slug = 'arrow-functions'
  and s.title = 'Try it yourself';


insert into public.assignments (module_id, title, spec, starter_code, starter_template)
select m.id, $md$Simple calculator$md$, $md$## Simple calculator

Write four functions: `add`, `subtract`, `multiply`, and `divide`. Each one takes two numbers and returns the result.

### Requirements
- All four functions return the correct result
- `divide` handles division by zero without crashing, for example returning a message like "Cannot divide by zero" instead of letting the app break

### Example
```js
add(4, 2); // 6
divide(4, 0); // "Cannot divide by zero"
```$md$, jsonb_build_object(
      '/index.js', $md$function add(a, b) {
  // your code here
}

function subtract(a, b) {
  // your code here
}

function multiply(a, b) {
  // your code here
}

function divide(a, b) {
  // your code here
}
$md$
    ), 'vanilla'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'functions';


-- ── Module: Arrays and objects ────────────────────────────────────────────

insert into public.modules (track_id, name, slug, order_index)
select id, 'Arrays and objects', 'arrays-and-objects', 3
from public.tracks where slug = 'javascript-fundamentals'
on conflict (track_id, slug) do nothing;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Arrays and common methods$md$, 'arrays-and-common-methods', 0, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'arrays-and-objects'
on conflict (module_id, slug) do nothing;


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$What an array is$md$, $md$An array is an ordered list of values.

```js
let foods = ["pizza", "jollof rice", "tacos"];
console.log(foods[0]);
console.log(foods.length);
```

Items are numbered starting from 0, so `foods[0]` is the first item, not the second.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'arrays-and-objects' and l.slug = 'arrays-and-common-methods';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Three methods you will use constantly$md$, $md$| Method | What it does |
|---|---|
| `.push(x)` | Adds x to the end of the array |
| `.map(fn)` | Builds a new array by running fn on every item |
| `.filter(fn)` | Builds a new array with only the items where fn returns true |

```js
let foods = ["pizza", "jollof rice", "tacos"];
foods.push("suya");

let shouted = foods.map((food) => food.toUpperCase());
console.log(shouted);
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'arrays-and-objects' and l.slug = 'arrays-and-common-methods';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id,
  $md$What does the .filter() method return?$md$,
  '["A single value","A new array with only the items that pass a test","The original array, unchanged","The length of the array"]'::jsonb,
  1,
  $md$.filter() builds a brand new array containing only the items where the function you gave it returned true, the original array is left untouched.$md$,
  0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'arrays-and-objects' and l.slug = 'arrays-and-common-methods' and s.title = 'Three methods you will use constantly';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Try it yourself$md$, $md$Add your own favorite food to the list, then change the filter to a different condition.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'arrays-and-objects' and l.slug = 'arrays-and-common-methods';


update public.sections s
set sandbox_template = 'vanilla',
    sandbox_files = jsonb_build_object(
      '/index.html', $md$<!doctype html>
<html>
  <body></body>
</html>
$md$,
      '/index.js', $md$let foods = ["pizza", "jollof rice", "tacos"];
foods.push("suya");

let longNames = foods.filter((food) => food.length > 5);

document.body.innerHTML = `
  <p>All foods: ${foods.join(", ")}</p>
  <p>Long names: ${longNames.join(", ")}</p>
`;
$md$
    )
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'javascript-fundamentals' and m.slug = 'arrays-and-objects' and l.slug = 'arrays-and-common-methods'
  and s.title = 'Try it yourself';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Objects$md$, 'objects', 1, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'arrays-and-objects'
on conflict (module_id, slug) do nothing;


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Grouping related values$md$, $md$An object groups related values together under named keys, instead of numbered positions like an array.

```js
let student = {
  name: "Ada",
  age: 22,
  track: "JavaScript"
};

console.log(student.name);
console.log(student.track);
```

Use a dot followed by the key name to read a value out of an object.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'arrays-and-objects' and l.slug = 'objects';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id,
  $md$How do you read a value out of an object called student with a key called age?$md$,
  '["student[0]","student.age","student->age","get(student, age)"]'::jsonb,
  1,
  $md$Dot notation, object.key, is the standard way to read a named value out of an object.$md$,
  0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'arrays-and-objects' and l.slug = 'objects' and s.title = 'Grouping related values';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Try it yourself$md$, $md$Fill in your own details, then add a fourth key to the object, maybe favoriteLanguage, and display it too.$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'arrays-and-objects' and l.slug = 'objects';


update public.sections s
set sandbox_template = 'vanilla',
    sandbox_files = jsonb_build_object(
      '/index.html', $md$<!doctype html>
<html>
  <body></body>
</html>
$md$,
      '/index.js', $md$let student = {
  name: "Your name",
  age: 0,
  track: "JavaScript"
};

document.body.innerHTML = `
  <p>${student.name} is ${student.age} and studying ${student.track}</p>
`;
$md$
    )
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'javascript-fundamentals' and m.slug = 'arrays-and-objects' and l.slug = 'objects'
  and s.title = 'Try it yourself';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Arrays of objects$md$, 'arrays-of-objects', 2, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'arrays-and-objects'
on conflict (module_id, slug) do nothing;


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$The pattern behind almost every real app$md$, $md$Arrays and objects combine constantly in real apps: a list of students, a list of products, a list of messages. Each item in the array is its own object.

```js
let students = [
  { name: "Ada", track: "JavaScript" },
  { name: "Priya", track: "Python" },
  { name: "Tunde", track: "JavaScript" }
];

let jsStudents = students.filter((s) => s.track === "JavaScript");
console.log(jsStudents);
```

This single pattern, an array of objects filtered or mapped by one of their properties, is behind almost every list you will ever build.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'arrays-and-objects' and l.slug = 'arrays-of-objects';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id,
  $md$In the example above, what does students.filter((s) => s.track === "JavaScript") return?$md$,
  '["The number of JavaScript students","A new array containing only the student objects on the JavaScript track","The name of the first JavaScript student","An error, because track is not a valid key"]'::jsonb,
  1,
  $md$filter always returns a new array, here containing just the student objects whose track property equals "JavaScript".$md$,
  0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'arrays-and-objects' and l.slug = 'arrays-of-objects' and s.title = 'The pattern behind almost every real app';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Try it yourself$md$, $md$Add a fourth student to the list, then change the filter to find students in a different track.$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'arrays-and-objects' and l.slug = 'arrays-of-objects';


update public.sections s
set sandbox_template = 'vanilla',
    sandbox_files = jsonb_build_object(
      '/index.html', $md$<!doctype html>
<html>
  <body></body>
</html>
$md$,
      '/index.js', $md$let students = [
  { name: "Ada", track: "JavaScript" },
  { name: "Priya", track: "Python" },
  { name: "Tunde", track: "JavaScript" }
];

let jsStudents = students.filter((s) => s.track === "JavaScript");

document.body.innerHTML = `<p>JS students: ${jsStudents.map((s) => s.name).join(", ")}</p>`;
$md$
    )
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'javascript-fundamentals' and m.slug = 'arrays-and-objects' and l.slug = 'arrays-of-objects'
  and s.title = 'Try it yourself';


insert into public.assignments (module_id, title, spec, starter_code, starter_template)
select m.id, $md$Todo list logic$md$, $md$## Todo list logic

Build an array of todo objects, each shaped like { text: "...", done: false }. Then write three functions:

- addTodo(todos, text), returns a new array with a new todo added
- completeTodo(todos, index), returns a new array with the todo at that index marked done
- getActiveTodos(todos), returns only the todos that are not done

### Requirements
- All three functions work correctly against a sample array
- Console output only, no UI needed yet, that comes in the next module$md$, jsonb_build_object(
      '/index.js', $md$let todos = [
  { text: "Learn functions", done: true },
  { text: "Learn arrays", done: false }
];

function addTodo(todos, text) {
  // your code here
}

function completeTodo(todos, index) {
  // your code here
}

function getActiveTodos(todos) {
  // your code here
}

console.log(getActiveTodos(todos));
$md$
    ), 'vanilla'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'arrays-and-objects';


-- ── Module: DOM and events ────────────────────────────────────────────

insert into public.modules (track_id, name, slug, order_index)
select id, 'DOM and events', 'dom-and-events', 4
from public.tracks where slug = 'javascript-fundamentals'
on conflict (track_id, slug) do nothing;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$What the DOM is$md$, 'what-the-dom-is', 0, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'dom-and-events'
on conflict (module_id, slug) do nothing;


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$A tree JavaScript can read and change$md$, $md$The DOM (Document Object Model) is how JavaScript sees your HTML: as a tree of elements it can read and change.

```
document
  └── html
        └── body
              ├── h1
              └── ul
                    ├── li
                    └── li
```

Every tag in your HTML becomes a node JavaScript can find and modify while the page is running, without reloading it.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'dom-and-events' and l.slug = 'what-the-dom-is';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id,
  $md$What does the DOM represent?$md$,
  '["A database of user information","A tree structure representing the HTML elements on a page","A type of CSS layout","A JavaScript function"]'::jsonb,
  1,
  $md$The DOM is the browser live, tree-shaped representation of your HTML, which JavaScript can read from and write to.$md$,
  0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'dom-and-events' and l.slug = 'what-the-dom-is' and s.title = 'A tree JavaScript can read and change';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Selecting and changing elements$md$, 'selecting-and-changing-elements', 1, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'dom-and-events'
on conflict (module_id, slug) do nothing;


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Finding an element to change it$md$, $md$document.querySelector finds an element on the page so you can change it.

```html
<h1 id="title">Original title</h1>
```

```js
const title = document.querySelector("#title");
title.textContent = "Changed by JavaScript";
```

`#title` matches the element with id="title", the same selector syntax as CSS. `.textContent` reads or writes the text inside it.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'dom-and-events' and l.slug = 'selecting-and-changing-elements';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Try it yourself$md$, $md$Change the text being assigned to title.textContent and watch the preview update instantly.$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'dom-and-events' and l.slug = 'selecting-and-changing-elements';


update public.sections s
set sandbox_template = 'vanilla',
    sandbox_files = jsonb_build_object(
      '/index.html', $md$<!doctype html>
<html>
  <body>
    <h1 id="title">Original title</h1>
  </body>
</html>
$md$,
      '/index.js', $md$const title = document.querySelector("#title");
title.textContent = "Changed by JavaScript";
$md$
    )
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'javascript-fundamentals' and m.slug = 'dom-and-events' and l.slug = 'selecting-and-changing-elements'
  and s.title = 'Try it yourself';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Event listeners$md$, 'event-listeners', 2, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'dom-and-events'
on conflict (module_id, slug) do nothing;


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Waiting for something to happen$md$, $md$An event listener waits for something to happen, a click, a keypress, a scroll, and runs code in response.

```html
<button id="btn">Click me</button>
<p id="output"></p>
```

```js
const button = document.querySelector("#btn");
const output = document.querySelector("#output");

button.addEventListener("click", () => {
  output.textContent = "Button clicked!";
});
```

Nothing runs until the click actually happens, the function you pass in is saved and waits.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'dom-and-events' and l.slug = 'event-listeners';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id,
  $md$What does addEventListener's second argument do?$md$,
  '["Selects the element to watch","Runs immediately when the page loads","Runs every time the specified event happens","Deletes the element after one use"]'::jsonb,
  2,
  $md$The function passed as the second argument is stored and executed every time the specified event, like a click, occurs on that element.$md$,
  0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'dom-and-events' and l.slug = 'event-listeners' and s.title = 'Waiting for something to happen';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Try it yourself$md$, $md$Change the message that appears after the click, or add a counter that increases by one every time the button is pressed.$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'dom-and-events' and l.slug = 'event-listeners';


update public.sections s
set sandbox_template = 'vanilla',
    sandbox_files = jsonb_build_object(
      '/index.html', $md$<!doctype html>
<html>
  <body>
    <button id="btn">Click me</button>
    <p id="output">Nothing yet</p>
  </body>
</html>
$md$,
      '/index.js', $md$const button = document.querySelector("#btn");
const output = document.querySelector("#output");

button.addEventListener("click", () => {
  output.textContent = "Button clicked!";
});
$md$
    )
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'javascript-fundamentals' and m.slug = 'dom-and-events' and l.slug = 'event-listeners'
  and s.title = 'Try it yourself';


insert into public.assignments (module_id, title, spec, starter_code, starter_template)
select m.id, $md$Capstone: Working todo list$md$, $md$## Capstone: Working todo list

Build a real todo list in the browser, combining everything from this track.

### Requirements
- An input and an Add button that adds a new todo to the list when clicked
- Each todo can be marked done (for example a checkbox, or a click that toggles a style)
- Each todo can be removed from the list
- No console errors

This is a portfolio-worthy project: a real, interactive page that responds to what someone does, built entirely by you. Finishing this assignment and completing every section in the track earns your certificate on the Progress page.$md$, jsonb_build_object(
      '/index.html', $md$<!doctype html>
<html>
  <body>
    <h1>Todo list</h1>
    <input id="todo-input" placeholder="Add a todo" />
    <button id="add-btn">Add</button>
    <ul id="todo-list"></ul>
  </body>
</html>
$md$,
      '/index.js', $md$const input = document.querySelector("#todo-input");
const addBtn = document.querySelector("#add-btn");
const list = document.querySelector("#todo-list");

// your code here: add a todo when the button is clicked,
// let each todo be marked done and removed
$md$
    ), 'vanilla'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'javascript-fundamentals' and m.slug = 'dom-and-events';
