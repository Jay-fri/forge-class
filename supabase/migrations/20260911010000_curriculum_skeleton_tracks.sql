-- Outline-level skeleton for tracks 2-6 (Python, PHP, Frontend, Backend, Full
-- Stack) per forge-curriculum.md. These are drafts, not published: title and a
-- one-line note per lesson so the structure exists in the curriculum editor
-- for an instructor to expand later, matching the doc's own framing that
-- full lesson-by-lesson depth for every track is future work. Only
-- JavaScript Fundamentals (previous migration) is built out in full.


insert into public.tracks (name, slug, level, description, order_index)
values ('Python', 'python', 'beginner', $md$Python from first principles: syntax, logic, and small real projects, building toward a working command-line program.$md$, 2)
on conflict (slug) do nothing;

insert into public.bundle_tracks (bundle_id, track_id)
select b.id, t.id from public.bundles b, public.tracks t
where b.slug = 'python' and t.slug = 'python'
on conflict do nothing;


insert into public.modules (track_id, name, slug, order_index)
select id, 'Getting started', 'getting-started', 0
from public.tracks where slug = 'python'
on conflict (track_id, slug) do nothing;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$What Python is$md$, 'what-python-is', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'getting-started'
on conflict (module_id, slug) do nothing;

insert into public.sections (lesson_id, content, order_index)
select l.id, $md$What Python is used for and why it is a popular first language.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'getting-started' and l.slug = 'what-python-is';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Running Python code$md$, 'running-python-code', 1, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'getting-started'
on conflict (module_id, slug) do nothing;

insert into public.sections (lesson_id, content, order_index)
select l.id, $md$Running code in a REPL or online editor, no local install required to start.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'getting-started' and l.slug = 'running-python-code';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Variables and types$md$, 'variables-and-types', 2, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'getting-started'
on conflict (module_id, slug) do nothing;

insert into public.sections (lesson_id, content, order_index)
select l.id, $md$Variables and Python core types: strings, numbers, and booleans.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'getting-started' and l.slug = 'variables-and-types';


insert into public.modules (track_id, name, slug, order_index)
select id, 'Operators and control flow', 'operators-and-control-flow', 1
from public.tracks where slug = 'python'
on conflict (track_id, slug) do nothing;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Operators$md$, 'operators', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'operators-and-control-flow'
on conflict (module_id, slug) do nothing;

insert into public.sections (lesson_id, content, order_index)
select l.id, $md$Arithmetic and comparison operators in Python.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'operators-and-control-flow' and l.slug = 'operators';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$if, elif, and else$md$, 'if-elif-and-else', 1, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'operators-and-control-flow'
on conflict (module_id, slug) do nothing;

insert into public.sections (lesson_id, content, order_index)
select l.id, $md$Branching logic with if, elif, and else.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'operators-and-control-flow' and l.slug = 'if-elif-and-else';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$for and while loops$md$, 'for-and-while-loops', 2, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'operators-and-control-flow'
on conflict (module_id, slug) do nothing;

insert into public.sections (lesson_id, content, order_index)
select l.id, $md$Repeating code with for loops and while loops.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'operators-and-control-flow' and l.slug = 'for-and-while-loops';


insert into public.modules (track_id, name, slug, order_index)
select id, 'Functions', 'functions', 2
from public.tracks where slug = 'python'
on conflict (track_id, slug) do nothing;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Defining a function$md$, 'defining-a-function', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'functions'
on conflict (module_id, slug) do nothing;

insert into public.sections (lesson_id, content, order_index)
select l.id, $md$Writing a function with def, and calling it.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'functions' and l.slug = 'defining-a-function';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Parameters and return values$md$, 'parameters-and-return-values', 1, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'functions'
on conflict (module_id, slug) do nothing;

insert into public.sections (lesson_id, content, order_index)
select l.id, $md$Passing values in and getting values back out.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'functions' and l.slug = 'parameters-and-return-values';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Default arguments$md$, 'default-arguments', 2, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'functions'
on conflict (module_id, slug) do nothing;

insert into public.sections (lesson_id, content, order_index)
select l.id, $md$Giving a parameter a default value so it is optional when calling the function.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'functions' and l.slug = 'default-arguments';


insert into public.modules (track_id, name, slug, order_index)
select id, 'Lists and dictionaries', 'lists-and-dictionaries', 3
from public.tracks where slug = 'python'
on conflict (track_id, slug) do nothing;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Lists$md$, 'lists', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'lists-and-dictionaries'
on conflict (module_id, slug) do nothing;

insert into public.sections (lesson_id, content, order_index)
select l.id, $md$Python lists: ordered collections and common list methods.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'lists-and-dictionaries' and l.slug = 'lists';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Dictionaries$md$, 'dictionaries', 1, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'lists-and-dictionaries'
on conflict (module_id, slug) do nothing;

insert into public.sections (lesson_id, content, order_index)
select l.id, $md$Python dictionaries: key-value pairs, the equivalent of a JavaScript object.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'lists-and-dictionaries' and l.slug = 'dictionaries';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Common list and dictionary methods$md$, 'common-list-and-dictionary-methods', 2, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'lists-and-dictionaries'
on conflict (module_id, slug) do nothing;

insert into public.sections (lesson_id, content, order_index)
select l.id, $md$The methods you reach for constantly when working with real data.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'lists-and-dictionaries' and l.slug = 'common-list-and-dictionary-methods';


insert into public.modules (track_id, name, slug, order_index)
select id, 'Files and simple projects', 'files-and-simple-projects', 4
from public.tracks where slug = 'python'
on conflict (track_id, slug) do nothing;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Reading and writing a text file$md$, 'reading-and-writing-a-text-file', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'files-and-simple-projects'
on conflict (module_id, slug) do nothing;

insert into public.sections (lesson_id, content, order_index)
select l.id, $md$Persisting data between runs by reading and writing a plain text file.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'files-and-simple-projects' and l.slug = 'reading-and-writing-a-text-file';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Capstone project$md$, 'capstone-project', 1, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'files-and-simple-projects'
on conflict (module_id, slug) do nothing;

insert into public.sections (lesson_id, content, order_index)
select l.id, $md$Putting it all together in a small, complete command-line program.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'files-and-simple-projects' and l.slug = 'capstone-project';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Profile print$md$, $md$## Profile print

Create variables for your name, age, and a one-line bio, then print a formatted introduction using them.

### Requirements
- Uses at least 3 variables of different types
- Output reads like a real introduction
- Runs with no errors$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'getting-started';


insert into public.assignments (module_id, title, spec)
select m.id, $md$FizzBuzz$md$, $md$## FizzBuzz

Print the numbers 1 through 20. Print Fizz for multiples of 3, Buzz for multiples of 5, and FizzBuzz for multiples of both.

### Requirements
- Correct output for all 20 numbers
- Uses a loop and conditionals, not 20 separate print statements$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'operators-and-control-flow';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Simple calculator$md$, $md$## Simple calculator

Write functions add, subtract, multiply, and divide, each taking two numbers and returning the result.

### Requirements
- All four functions return the correct result
- divide handles division by zero without crashing$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'functions';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Data manipulation$md$, $md$## Data manipulation

Build a list of dictionaries representing students, each with a name and a track. Write functions to add a student, find all students on a given track, and remove a student by name.

### Requirements
- All three functions work correctly against a sample list$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'lists-and-dictionaries';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Capstone: command-line project$md$, $md$## Capstone: command-line project

Build a small, complete command-line program: either a todo list that saves to a text file, or a number-guessing game.

### Requirements
- Runs from start to finish without crashing
- Uses functions, conditionals, and at least one loop
- The todo list option should persist data in a text file between runs$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'files-and-simple-projects';


insert into public.tracks (name, slug, level, description, order_index)
values ('PHP', 'php', 'beginner', $md$Server-side fundamentals with PHP: variables, logic, and functions, building toward handling a real form submission.$md$, 3)
on conflict (slug) do nothing;

insert into public.bundle_tracks (bundle_id, track_id)
select b.id, t.id from public.bundles b, public.tracks t
where b.slug = 'php' and t.slug = 'php'
on conflict do nothing;


insert into public.modules (track_id, name, slug, order_index)
select id, 'Getting started', 'getting-started', 0
from public.tracks where slug = 'php'
on conflict (track_id, slug) do nothing;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$What PHP does$md$, 'what-php-does', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'getting-started'
on conflict (module_id, slug) do nothing;

insert into public.sections (lesson_id, content, order_index)
select l.id, $md$What server-side code is and where PHP fits in.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'getting-started' and l.slug = 'what-php-does';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Embedding PHP in HTML$md$, 'embedding-php-in-html', 1, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'getting-started'
on conflict (module_id, slug) do nothing;

insert into public.sections (lesson_id, content, order_index)
select l.id, $md$Mixing PHP tags into an HTML page.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'getting-started' and l.slug = 'embedding-php-in-html';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Variables and types$md$, 'variables-and-types', 2, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'getting-started'
on conflict (module_id, slug) do nothing;

insert into public.sections (lesson_id, content, order_index)
select l.id, $md$Variables and PHP core types.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'getting-started' and l.slug = 'variables-and-types';


insert into public.modules (track_id, name, slug, order_index)
select id, 'Operators and control flow', 'operators-and-control-flow', 1
from public.tracks where slug = 'php'
on conflict (track_id, slug) do nothing;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Operators$md$, 'operators', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'operators-and-control-flow'
on conflict (module_id, slug) do nothing;

insert into public.sections (lesson_id, content, order_index)
select l.id, $md$Arithmetic and comparison operators in PHP.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'operators-and-control-flow' and l.slug = 'operators';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$if and else$md$, 'if-and-else', 1, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'operators-and-control-flow'
on conflict (module_id, slug) do nothing;

insert into public.sections (lesson_id, content, order_index)
select l.id, $md$Branching logic with if and else.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'operators-and-control-flow' and l.slug = 'if-and-else';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$for and while loops$md$, 'for-and-while-loops', 2, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'operators-and-control-flow'
on conflict (module_id, slug) do nothing;

insert into public.sections (lesson_id, content, order_index)
select l.id, $md$Repeating code with for loops and while loops.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'operators-and-control-flow' and l.slug = 'for-and-while-loops';


insert into public.modules (track_id, name, slug, order_index)
select id, 'Functions', 'functions', 2
from public.tracks where slug = 'php'
on conflict (track_id, slug) do nothing;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Defining a function$md$, 'defining-a-function', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'functions'
on conflict (module_id, slug) do nothing;

insert into public.sections (lesson_id, content, order_index)
select l.id, $md$Writing a function and calling it.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'functions' and l.slug = 'defining-a-function';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Parameters and return values$md$, 'parameters-and-return-values', 1, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'functions'
on conflict (module_id, slug) do nothing;

insert into public.sections (lesson_id, content, order_index)
select l.id, $md$Passing values in and getting values back out.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'functions' and l.slug = 'parameters-and-return-values';


insert into public.modules (track_id, name, slug, order_index)
select id, 'Arrays and associative arrays', 'arrays-and-associative-arrays', 3
from public.tracks where slug = 'php'
on conflict (track_id, slug) do nothing;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Arrays$md$, 'arrays', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'arrays-and-associative-arrays'
on conflict (module_id, slug) do nothing;

insert into public.sections (lesson_id, content, order_index)
select l.id, $md$Ordered lists of values in PHP.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'arrays-and-associative-arrays' and l.slug = 'arrays';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Associative arrays$md$, 'associative-arrays', 1, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'arrays-and-associative-arrays'
on conflict (module_id, slug) do nothing;

insert into public.sections (lesson_id, content, order_index)
select l.id, $md$Key-value pairs, PHP version of an object or dictionary.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'arrays-and-associative-arrays' and l.slug = 'associative-arrays';


insert into public.modules (track_id, name, slug, order_index)
select id, 'Forms and simple server logic', 'forms-and-simple-server-logic', 4
from public.tracks where slug = 'php'
on conflict (track_id, slug) do nothing;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Handling a form submission$md$, 'handling-a-form-submission', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'forms-and-simple-server-logic'
on conflict (module_id, slug) do nothing;

insert into public.sections (lesson_id, content, order_index)
select l.id, $md$Reading submitted form data on the server.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'forms-and-simple-server-logic' and l.slug = 'handling-a-form-submission';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Capstone project$md$, 'capstone-project', 1, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'forms-and-simple-server-logic'
on conflict (module_id, slug) do nothing;

insert into public.sections (lesson_id, content, order_index)
select l.id, $md$Putting it all together in a real form-handling script.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'forms-and-simple-server-logic' and l.slug = 'capstone-project';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Profile print$md$, $md$## Profile print

Create variables for your name, age, and a one-line bio, then echo a formatted introduction using them.

### Requirements
- Uses at least 3 variables of different types
- Output reads like a real introduction
- Runs with no errors$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'getting-started';


insert into public.assignments (module_id, title, spec)
select m.id, $md$FizzBuzz$md$, $md$## FizzBuzz

Print the numbers 1 through 20. Print Fizz for multiples of 3, Buzz for multiples of 5, and FizzBuzz for multiples of both.

### Requirements
- Correct output for all 20 numbers
- Uses a loop and conditionals$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'operators-and-control-flow';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Simple calculator$md$, $md$## Simple calculator

Write functions add, subtract, multiply, and divide, each taking two numbers and returning the result.

### Requirements
- All four functions return the correct result
- divide handles division by zero without crashing$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'functions';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Data manipulation$md$, $md$## Data manipulation

Build an associative array of students, each with a name and a track. Write functions to add a student, find all students on a given track, and remove a student by name.

### Requirements
- All three functions work correctly against sample data$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'arrays-and-associative-arrays';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Capstone: contact form handler$md$, $md$## Capstone: contact form handler

Build a simple contact form handler. It should accept a name, email, and message, validate that all three are filled in, and echo the submitted values back if the submission is valid.

### Requirements
- Rejects a submission with any empty field, showing a clear message
- Echoes the name, email, and message back when the submission is valid
- Runs with no errors$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'forms-and-simple-server-logic';


insert into public.tracks (name, slug, level, description, order_index)
values ('Frontend', 'frontend', 'beginner', $md$HTML, CSS, JavaScript, and an introduction to React: everything you need to build and ship a real interactive site.$md$, 4)
on conflict (slug) do nothing;

insert into public.bundle_tracks (bundle_id, track_id)
select b.id, t.id from public.bundles b, public.tracks t
where b.slug = 'frontend' and t.slug = 'frontend'
on conflict do nothing;


insert into public.modules (track_id, name, slug, order_index)
select id, 'HTML foundations', 'html-foundations', 0
from public.tracks where slug = 'frontend'
on conflict (track_id, slug) do nothing;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Structure and common tags$md$, 'structure-and-common-tags', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations'
on conflict (module_id, slug) do nothing;

insert into public.sections (lesson_id, content, order_index)
select l.id, $md$The tags every page is built from.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'structure-and-common-tags';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Forms$md$, 'forms', 1, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations'
on conflict (module_id, slug) do nothing;

insert into public.sections (lesson_id, content, order_index)
select l.id, $md$Collecting input from a visitor with HTML forms.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'html-foundations' and l.slug = 'forms';


insert into public.modules (track_id, name, slug, order_index)
select id, 'CSS foundations', 'css-foundations', 1
from public.tracks where slug = 'frontend'
on conflict (track_id, slug) do nothing;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Selectors and the box model$md$, 'selectors-and-the-box-model', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations'
on conflict (module_id, slug) do nothing;

insert into public.sections (lesson_id, content, order_index)
select l.id, $md$Targeting elements and how spacing actually works.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'selectors-and-the-box-model';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Flexbox and grid$md$, 'flexbox-and-grid', 1, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations'
on conflict (module_id, slug) do nothing;

insert into public.sections (lesson_id, content, order_index)
select l.id, $md$The two layout systems behind almost every modern page.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'flexbox-and-grid';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Responsive basics$md$, 'responsive-basics', 2, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations'
on conflict (module_id, slug) do nothing;

insert into public.sections (lesson_id, content, order_index)
select l.id, $md$Making a layout work from phone width up to desktop.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'css-foundations' and l.slug = 'responsive-basics';


insert into public.modules (track_id, name, slug, order_index)
select id, 'JavaScript fundamentals', 'javascript-fundamentals-recap', 2
from public.tracks where slug = 'frontend'
on conflict (track_id, slug) do nothing;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$This module reuses the JavaScript Fundamentals track$md$, 'this-module-reuses-the-javascript-fundamentals-track', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'javascript-fundamentals-recap'
on conflict (module_id, slug) do nothing;

insert into public.sections (lesson_id, content, order_index)
select l.id, $md$Complete the standalone JavaScript Fundamentals track to finish this module: same content, no need to repeat it here.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'javascript-fundamentals-recap' and l.slug = 'this-module-reuses-the-javascript-fundamentals-track';


insert into public.modules (track_id, name, slug, order_index)
select id, 'Putting pages together', 'putting-pages-together', 3
from public.tracks where slug = 'frontend'
on conflict (track_id, slug) do nothing;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Combining HTML, CSS, and JavaScript$md$, 'combining-html-css-and-javascript', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'putting-pages-together'
on conflict (module_id, slug) do nothing;

insert into public.sections (lesson_id, content, order_index)
select l.id, $md$Building one real interactive page from all three layers together.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'putting-pages-together' and l.slug = 'combining-html-css-and-javascript';


insert into public.modules (track_id, name, slug, order_index)
select id, 'Intro to React', 'intro-to-react', 4
from public.tracks where slug = 'frontend'
on conflict (track_id, slug) do nothing;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Components and props$md$, 'components-and-props', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'intro-to-react'
on conflict (module_id, slug) do nothing;

insert into public.sections (lesson_id, content, order_index)
select l.id, $md$Breaking a page into reusable pieces and passing data into them.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'intro-to-react' and l.slug = 'components-and-props';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$State$md$, 'state', 1, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'intro-to-react'
on conflict (module_id, slug) do nothing;

insert into public.sections (lesson_id, content, order_index)
select l.id, $md$Giving a component memory that can change over time.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'intro-to-react' and l.slug = 'state';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Building a small multi-component app$md$, 'building-a-small-multi-component-app', 2, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'intro-to-react'
on conflict (module_id, slug) do nothing;

insert into public.sections (lesson_id, content, order_index)
select l.id, $md$Combining components and state into one working app.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'intro-to-react' and l.slug = 'building-a-small-multi-component-app';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Capstone: personal portfolio$md$, $md$## Capstone: personal portfolio

Build a small multi-page personal portfolio site using HTML, CSS, and JavaScript, with at least one interactive piece built in React.

### Requirements
- At least two pages or sections, for example home and projects
- A responsive layout that works on a phone-sized screen
- At least one real interactive element: a toggle, a filter, a form, anything that responds to a click
- Runs with no console errors$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'frontend' and m.slug = 'intro-to-react';


insert into public.tracks (name, slug, level, description, order_index)
values ('Backend', 'backend', 'intermediate', $md$Servers, databases, and APIs: learn to build the systems that power real applications.$md$, 5)
on conflict (slug) do nothing;

insert into public.bundle_tracks (bundle_id, track_id)
select b.id, t.id from public.bundles b, public.tracks t
where b.slug = 'backend' and t.slug = 'backend'
on conflict do nothing;


insert into public.modules (track_id, name, slug, order_index)
select id, 'Getting started with Node.js', 'getting-started-with-nodejs', 0
from public.tracks where slug = 'backend'
on conflict (track_id, slug) do nothing;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$What a server is$md$, 'what-a-server-is', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'getting-started-with-nodejs'
on conflict (module_id, slug) do nothing;

insert into public.sections (lesson_id, content, order_index)
select l.id, $md$What a server actually does when a browser asks it for something.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'getting-started-with-nodejs' and l.slug = 'what-a-server-is';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Running a basic Node script$md$, 'running-a-basic-node-script', 1, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'getting-started-with-nodejs'
on conflict (module_id, slug) do nothing;

insert into public.sections (lesson_id, content, order_index)
select l.id, $md$Running your first Node.js script outside the browser.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'getting-started-with-nodejs' and l.slug = 'running-a-basic-node-script';


insert into public.modules (track_id, name, slug, order_index)
select id, 'Express basics', 'express-basics', 1
from public.tracks where slug = 'backend'
on conflict (track_id, slug) do nothing;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Routes$md$, 'routes', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'express-basics'
on conflict (module_id, slug) do nothing;

insert into public.sections (lesson_id, content, order_index)
select l.id, $md$Defining routes that respond to different URLs.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'express-basics' and l.slug = 'routes';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Handling requests and responses$md$, 'handling-requests-and-responses', 1, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'express-basics'
on conflict (module_id, slug) do nothing;

insert into public.sections (lesson_id, content, order_index)
select l.id, $md$Reading what a request sent and shaping what you send back.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'express-basics' and l.slug = 'handling-requests-and-responses';


insert into public.modules (track_id, name, slug, order_index)
select id, 'Working with data', 'working-with-data', 2
from public.tracks where slug = 'backend'
on conflict (track_id, slug) do nothing;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Database basics$md$, 'database-basics', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'working-with-data'
on conflict (module_id, slug) do nothing;

insert into public.sections (lesson_id, content, order_index)
select l.id, $md$Connecting your server to a real database.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'working-with-data' and l.slug = 'database-basics';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Basic CRUD$md$, 'basic-crud', 1, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'working-with-data'
on conflict (module_id, slug) do nothing;

insert into public.sections (lesson_id, content, order_index)
select l.id, $md$Create, read, update, and delete: the four operations behind almost every feature.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'working-with-data' and l.slug = 'basic-crud';


insert into public.modules (track_id, name, slug, order_index)
select id, 'Authentication basics', 'authentication-basics', 3
from public.tracks where slug = 'backend'
on conflict (track_id, slug) do nothing;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$What auth is$md$, 'what-auth-is', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'authentication-basics'
on conflict (module_id, slug) do nothing;

insert into public.sections (lesson_id, content, order_index)
select l.id, $md$What authentication actually verifies, and why it matters.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'authentication-basics' and l.slug = 'what-auth-is';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$A simple login flow$md$, 'a-simple-login-flow', 1, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'authentication-basics'
on conflict (module_id, slug) do nothing;

insert into public.sections (lesson_id, content, order_index)
select l.id, $md$The shape of a basic login flow, end to end.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'authentication-basics' and l.slug = 'a-simple-login-flow';


insert into public.modules (track_id, name, slug, order_index)
select id, 'Building a small API', 'building-a-small-api', 4
from public.tracks where slug = 'backend'
on conflict (track_id, slug) do nothing;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Capstone: a working REST API$md$, 'capstone-a-working-rest-api', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'building-a-small-api'
on conflict (module_id, slug) do nothing;

insert into public.sections (lesson_id, content, order_index)
select l.id, $md$Putting routes, data, and auth together into one real API.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'building-a-small-api' and l.slug = 'capstone-a-working-rest-api';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Hello world server$md$, $md$## Hello world server

Write a basic Node.js script that starts a server and responds with a simple message when visited.

### Requirements
- The server starts with no errors
- Visiting it in a browser shows your message$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'getting-started-with-nodejs';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Working routes$md$, $md$## Working routes

Build an Express app with at least three routes that each respond correctly.

### Requirements
- At least 3 distinct routes
- Each one returns the correct response for its purpose$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'express-basics';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Database-backed feature$md$, $md$## Database-backed feature

Connect your app to a database and build one small feature backed by real data, for example a list of items that can be created and read back.

### Requirements
- Data persists in the database, not just in memory
- Create and read both work correctly$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'working-with-data';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Capstone: working REST API$md$, $md$## Capstone: working REST API

Build a small REST API with a handful of endpoints, for example create, read, update, and delete for one resource, and test it with a real client such as Postman, curl, or a small script.

### Requirements
- All endpoints work correctly
- Tested and confirmed working via a real client, not just assumed
- Basic error handling for invalid input$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'backend' and m.slug = 'building-a-small-api';


insert into public.tracks (name, slug, level, description, order_index)
values ('Full Stack', 'full-stack', 'advanced', $md$Frontend and Backend combined: go from a blank page to a deployed, working product.$md$, 6)
on conflict (slug) do nothing;

insert into public.bundle_tracks (bundle_id, track_id)
select b.id, t.id from public.bundles b, public.tracks t
where b.slug = 'full-stack' and t.slug = 'full-stack'
on conflict do nothing;


insert into public.modules (track_id, name, slug, order_index)
select id, 'Frontend foundations', 'frontend-foundations', 0
from public.tracks where slug = 'full-stack'
on conflict (track_id, slug) do nothing;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$This module draws on the Frontend track$md$, 'this-module-draws-on-the-frontend-track', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'full-stack' and m.slug = 'frontend-foundations'
on conflict (module_id, slug) do nothing;

insert into public.sections (lesson_id, content, order_index)
select l.id, $md$Covers the same ground as the standalone Frontend track: HTML, CSS, JavaScript, and an introduction to React.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'full-stack' and m.slug = 'frontend-foundations' and l.slug = 'this-module-draws-on-the-frontend-track';


insert into public.modules (track_id, name, slug, order_index)
select id, 'Backend foundations', 'backend-foundations', 1
from public.tracks where slug = 'full-stack'
on conflict (track_id, slug) do nothing;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$This module draws on the Backend track$md$, 'this-module-draws-on-the-backend-track', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'full-stack' and m.slug = 'backend-foundations'
on conflict (module_id, slug) do nothing;

insert into public.sections (lesson_id, content, order_index)
select l.id, $md$Covers the same ground as the standalone Backend track: servers, databases, and APIs.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'full-stack' and m.slug = 'backend-foundations' and l.slug = 'this-module-draws-on-the-backend-track';


insert into public.modules (track_id, name, slug, order_index)
select id, 'Final capstone', 'final-capstone', 2
from public.tracks where slug = 'full-stack'
on conflict (track_id, slug) do nothing;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Combining frontend and backend into one product$md$, 'combining-frontend-and-backend-into-one-product', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'full-stack' and m.slug = 'final-capstone'
on conflict (module_id, slug) do nothing;

insert into public.sections (lesson_id, content, order_index)
select l.id, $md$Bringing everything together into a single, real, deployed application.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'full-stack' and m.slug = 'final-capstone' and l.slug = 'combining-frontend-and-backend-into-one-product';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Capstone: full-stack todo app$md$, $md$## Capstone: full-stack todo app

This is the flagship project of the whole curriculum. Build a complete todo app: a real backend that persists data in a database, a REST API in front of it, and a polished frontend that talks to that API.

### Requirements
- Todos persist in a real database, surviving a server restart
- A working API the frontend actually calls, no hardcoded fake data
- A frontend that lets you add, complete, and remove todos, and reflects the current state after a refresh
- Runs with no console errors, on either the frontend or the server

This is the strongest portfolio piece in the curriculum. Treat it like a real, shippable product, not just an exercise.$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'full-stack' and m.slug = 'final-capstone';
