-- Embeds courses/course-python.md verbatim as the standalone Python
-- track's full content, replacing the earlier self-authored 5-module/
-- 22-lesson content with the real course's own 7-module structure.
-- Content preserved as-written. Inserted as draft; published after
-- structural verification against the source file.


delete from public.modules m
using public.tracks t
where m.track_id = t.id and t.slug = 'python';


insert into public.modules (track_id, name, slug, order_index)
select t.id, $md$Getting Started$md$, 'getting-started', 0
from public.tracks t where t.slug = 'python'
on conflict (track_id, slug) do update set order_index = excluded.order_index, name = excluded.name;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$What is Python?$md$, 'what-is-python', 0, true, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'getting-started'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Python is a programming language known for being readable and beginner-friendly. It's used for websites, data analysis, automation, and more. Unlike JavaScript, it doesn't run in a browser — it runs directly on a computer.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'getting-started' and l.slug = 'what-is-python';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'getting-started' and l.slug = 'what-is-python';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$Where does Python typically run?$md$, $md$["Only inside a web browser","Directly on a computer/server","Only on phones","It doesn't run anywhere, it's just for writing"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'getting-started' and l.slug = 'what-is-python' and s.order_index = 1;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Assuming Python and JavaScript are interchangeable because both are "beginner languages" — they have different syntax and different typical uses.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'getting-started' and l.slug = 'what-is-python';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Running your first line of Python$md$, 'running-your-first-line-of-python', 1, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'getting-started'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Python code can be run instantly in an online editor or a local install — no complicated setup needed to get started.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'getting-started' and l.slug = 'running-your-first-line-of-python';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```python
print("Hello, Forge")
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'getting-started' and l.slug = 'running-your-first-line-of-python';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Change the text and run it again.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'getting-started' and l.slug = 'running-your-first-line-of-python';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'getting-started' and l.slug = 'running-your-first-line-of-python';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does print() do in Python?$md$, $md$["Prints a physical document","Displays a message","Deletes a variable","Saves a file"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'getting-started' and l.slug = 'running-your-first-line-of-python' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Forgetting Python is case-sensitive — `Print("hi")` (capital P) causes a `NameError` because Python only recognizes lowercase `print`.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'getting-started' and l.slug = 'running-your-first-line-of-python';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Variables and basic types$md$, 'variables-and-basic-types', 2, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'getting-started'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Like JavaScript, Python variables are labeled boxes — but you don't need `let` or `const`, just a name and a value.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'getting-started' and l.slug = 'variables-and-basic-types';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```python
name = "Ada"
age = 22
is_student = True
print(name, age, is_student)
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'getting-started' and l.slug = 'variables-and-basic-types';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Create your own variables for your name, age, and favorite food.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'getting-started' and l.slug = 'variables-and-basic-types';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'getting-started' and l.slug = 'variables-and-basic-types';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What is Python's boolean value for "true" written as?$md$, $md$["true","True (capital T)","TRUE","1"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'getting-started' and l.slug = 'variables-and-basic-types' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Writing `true` lowercase like in JavaScript — Python requires `True`/`False` with a capital letter.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'getting-started' and l.slug = 'variables-and-basic-types';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Assignment 1 — Profile print$md$, $md$Create variables for your name, age, and a one-line bio, then print a formatted introduction using them.

**Pass criteria:** uses at least 3 variables of different types, output is readable, no errors.$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'getting-started';


insert into public.modules (track_id, name, slug, order_index)
select t.id, $md$Operators & Control Flow$md$, 'operators-and-control-flow', 1
from public.tracks t where t.slug = 'python'
on conflict (track_id, slug) do update set order_index = excluded.order_index, name = excluded.name;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Operators$md$, 'operators', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'operators-and-control-flow'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Arithmetic (`+ - * /`) and comparison (`== > <`) operators work much like JavaScript's, with one difference: Python uses `==` for comparison, not `===`.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'operators-and-control-flow' and l.slug = 'operators';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```python
print(5 + 3)
print(10 > 7)
print("cat" == "cat")
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'operators-and-control-flow' and l.slug = 'operators';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Try `//` (integer division) and `%` (remainder) with two numbers.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'operators-and-control-flow' and l.slug = 'operators';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'operators-and-control-flow' and l.slug = 'operators';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does Python use to compare equality?$md$, $md$["=","==","===","equals()"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'operators-and-control-flow' and l.slug = 'operators' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Using `=` (assignment) when checking equality — `if age = 18` is actually a syntax error in Python (unlike JavaScript, which lets it slip through silently), so Python will at least stop you here.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'operators-and-control-flow' and l.slug = 'operators';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Conditionals$md$, 'conditionals', 1, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'operators-and-control-flow'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Python uses `if / elif / else` — note "elif," not "else if."$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'operators-and-control-flow' and l.slug = 'conditionals';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```python
age = 20
if age >= 18:
    print("You can vote")
else:
    print("Not yet")
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'operators-and-control-flow' and l.slug = 'conditionals';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Add an `elif` branch for exactly age 18.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'operators-and-control-flow' and l.slug = 'conditionals';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'operators-and-control-flow' and l.slug = 'conditionals';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What keyword does Python use instead of "else if"?$md$, $md$["elseif","elif","else_if","orif"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'operators-and-control-flow' and l.slug = 'conditionals' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Forgetting the colon `:` at the end of the if line, or mixing tabs and spaces for indentation — Python uses indentation (not curly braces) to know what's inside the if block, so it's strict about this.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'operators-and-control-flow' and l.slug = 'conditionals';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Loops$md$, 'loops', 2, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'operators-and-control-flow'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$`for` loops iterate over a range or list; `while` loops run until a condition is false.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'operators-and-control-flow' and l.slug = 'loops';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```python
for i in range(1, 6):
    print(i)
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'operators-and-control-flow' and l.slug = 'loops';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Change `range(1, 6)` to count 1 to 10.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'operators-and-control-flow' and l.slug = 'loops';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'operators-and-control-flow' and l.slug = 'loops';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does range(1, 6) produce?$md$, $md$["The numbers 1 through 6 (inclusive)","The numbers 1 through 5","The number 6 only","An error"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'operators-and-control-flow' and l.slug = 'loops' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Expecting `range(1, 6)` to include 6 — Python's range stops *before* the second number.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'operators-and-control-flow' and l.slug = 'loops';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Assignment 2 — FizzBuzz$md$, $md$Print numbers 1–20; for multiples of 3 print "Fizz", multiples of 5 print "Buzz", multiples of both print "FizzBuzz".

**Pass criteria:** correct output for all 20 numbers, uses a loop and conditionals.$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'operators-and-control-flow';


insert into public.modules (track_id, name, slug, order_index)
select t.id, $md$Functions$md$, 'functions', 2
from public.tracks t where t.slug = 'python'
on conflict (track_id, slug) do update set order_index = excluded.order_index, name = excluded.name;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Defining functions$md$, 'defining-functions', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'functions'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Functions are defined with `def`, and use indentation (not curly braces) to show what's inside them.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'functions' and l.slug = 'defining-functions';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```python
def greet(name):
    print("Hello, " + name)

greet("Ada")
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'functions' and l.slug = 'defining-functions';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Call `greet()` with your own name.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'functions' and l.slug = 'defining-functions';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'functions' and l.slug = 'defining-functions';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What keyword starts a function definition in Python?$md$, $md$["function","def","func","define"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'functions' and l.slug = 'defining-functions' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Forgetting the colon `:` after the function signature, or misaligning the indentation of the function body.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'functions' and l.slug = 'defining-functions';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Parameters, return values, default arguments$md$, 'parameters-return-values-default-arguments', 1, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'functions'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Like JS, functions can take parameters and give back a value with `return`. Python also lets you set default values for parameters.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'functions' and l.slug = 'parameters-return-values-default-arguments';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```python
def add(a, b=10):
    return a + b

print(add(5))
print(add(5, 20))
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'functions' and l.slug = 'parameters-return-values-default-arguments';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Give your own function a default parameter value.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'functions' and l.slug = 'parameters-return-values-default-arguments';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'functions' and l.slug = 'parameters-return-values-default-arguments';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$In def add(a, b=10):, what happens if you call add(5) with only one argument?$md$, $md$["It errors","b uses its default value of 10","b becomes 0","a is ignored"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'functions' and l.slug = 'parameters-return-values-default-arguments' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Putting a parameter without a default *after* one with a default (`def add(a=10, b):`) — Python doesn't allow this and will throw a syntax error.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'functions' and l.slug = 'parameters-return-values-default-arguments';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Assignment 3 — Simple calculator$md$, $md$Write functions `add`, `subtract`, `multiply`, `divide`, each taking two numbers and returning the result.

**Pass criteria:** all four return correct results, `divide` handles division by zero without crashing (hint: check for zero before dividing).$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'functions';


insert into public.modules (track_id, name, slug, order_index)
select t.id, $md$Lists & Dictionaries$md$, 'lists-and-dictionaries', 3
from public.tracks t where t.slug = 'python'
on conflict (track_id, slug) do update set order_index = excluded.order_index, name = excluded.name;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Lists and common methods$md$, 'lists-and-common-methods', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'lists-and-dictionaries'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$A Python list is like a JavaScript array — an ordered collection. Common methods: `.append()` (add to the end), list comprehensions (a compact way to transform/filter).$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'lists-and-dictionaries' and l.slug = 'lists-and-common-methods';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```python
foods = ["rice", "beans", "yam"]
foods.append("plantain")
print(foods)
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'lists-and-dictionaries' and l.slug = 'lists-and-common-methods';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Use a list comprehension to get only foods longer than 4 letters: `[f for f in foods if len(f) > 4]`.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'lists-and-dictionaries' and l.slug = 'lists-and-common-methods';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'lists-and-dictionaries' and l.slug = 'lists-and-common-methods';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does .append() do?$md$, $md$["Removes the last item","Adds an item to the end of a list","Sorts the list","Empties the list"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'lists-and-dictionaries' and l.slug = 'lists-and-common-methods' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Confusing `.append()` (Python) with `.push()` (JavaScript) if switching between languages — same idea, different method name.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'lists-and-dictionaries' and l.slug = 'lists-and-common-methods';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Dictionaries$md$, 'dictionaries', 1, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'lists-and-dictionaries'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$A dictionary is Python's key-value structure — the equivalent of a JavaScript object.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'lists-and-dictionaries' and l.slug = 'dictionaries';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```python
student = {
    "name": "Ada",
    "age": 22,
    "track": "Python"
}
print(student["name"])
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'lists-and-dictionaries' and l.slug = 'dictionaries';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Add a `"streak"` key and print it.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'lists-and-dictionaries' and l.slug = 'dictionaries';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'lists-and-dictionaries' and l.slug = 'dictionaries';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$How do you access a value in a Python dictionary?$md$, $md$["dict.key","dict[\"key\"]","dict->key","dict(key)"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'lists-and-dictionaries' and l.slug = 'dictionaries' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Using a key that doesn't exist — `student["email"]` throws a `KeyError` if "email" was never added.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'lists-and-dictionaries' and l.slug = 'dictionaries';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Assignment 4 — Contact book$md$, $md$Build a list of dictionaries representing contacts (`{name, phone}`), write functions to add a contact, find one by name, and remove one.

**Pass criteria:** all three functions work correctly on a sample list.$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'lists-and-dictionaries';


insert into public.modules (track_id, name, slug, order_index)
select t.id, $md$Files & Capstone Project$md$, 'files-and-capstone-project', 4
from public.tracks t where t.slug = 'python'
on conflict (track_id, slug) do update set order_index = excluded.order_index, name = excluded.name;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Reading and writing a text file$md$, 'reading-and-writing-a-text-file', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'files-and-capstone-project'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Python can read from and write to files on your computer, letting programs remember data even after they stop running.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'files-and-capstone-project' and l.slug = 'reading-and-writing-a-text-file';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```python
with open("notes.txt", "w") as file:
    file.write("Hello from Python")

with open("notes.txt", "r") as file:
    print(file.read())
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'files-and-capstone-project' and l.slug = 'reading-and-writing-a-text-file';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Write your name to a file, then read it back and print it.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'files-and-capstone-project' and l.slug = 'reading-and-writing-a-text-file';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'files-and-capstone-project' and l.slug = 'reading-and-writing-a-text-file';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does the "w" mode do when opening a file?$md$, $md$["Reads the file","Writes to the file (overwriting existing content)","Deletes the file","Renames the file"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'files-and-capstone-project' and l.slug = 'reading-and-writing-a-text-file' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Opening a file in "w" mode when you meant to read it — this erases the file's existing content immediately.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'files-and-capstone-project' and l.slug = 'reading-and-writing-a-text-file';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Capstone Assignment — Command-line to-do list$md$, $md$Build a working command-line to-do list program using everything from this course: a list of dictionaries for todos, functions to add/complete/remove them, a loop that keeps asking the user what to do next, and saving the list to a file so it persists.

**Pass criteria:** the program runs without crashing, all actions (add/complete/remove/view) work correctly, and data saves to a file. This is the assignment that unlocks this track's certificate.$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'files-and-capstone-project';


insert into public.modules (track_id, name, slug, order_index)
select t.id, $md$Rounding Out Python$md$, 'rounding-out-python', 5
from public.tracks t where t.slug = 'python'
on conflict (track_id, slug) do update set order_index = excluded.order_index, name = excluded.name;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Tuples and sets$md$, 'tuples-and-sets', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'rounding-out-python'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$A tuple is like a list but unchangeable once created — good for fixed groups of values. A set holds only unique values, automatically removing duplicates.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'rounding-out-python' and l.slug = 'tuples-and-sets';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```python
coordinates = (10, 20)
unique_tracks = {"Python", "JavaScript", "Python"}
print(coordinates)
print(unique_tracks)
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'rounding-out-python' and l.slug = 'tuples-and-sets';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Create a set from a list that has duplicate values and see them disappear.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'rounding-out-python' and l.slug = 'tuples-and-sets';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'rounding-out-python' and l.slug = 'tuples-and-sets';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What happens to duplicate values in a set?$md$, $md$["They're kept","They're automatically removed","They cause an error","They get sorted"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'rounding-out-python' and l.slug = 'tuples-and-sets' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Trying to change a tuple's value after creating it (`coordinates[0] = 5`) — tuples are immutable, this throws a `TypeError`.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'rounding-out-python' and l.slug = 'tuples-and-sets';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$String methods and f-strings in depth$md$, 'string-methods-and-f-strings-in-depth', 1, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'rounding-out-python'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Strings have many built-in methods: `.upper()`, `.lower()`, `.strip()` (remove whitespace), `.split()` (break into a list). F-strings (`f"..."`) are the modern way to insert variables into strings.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'rounding-out-python' and l.slug = 'string-methods-and-f-strings-in-depth';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```python
name = "  Ada  "
clean_name = name.strip()
print(f"Hello, {clean_name.upper()}!")
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'rounding-out-python' and l.slug = 'string-methods-and-f-strings-in-depth';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Use `.split()` to break a sentence into a list of words.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'rounding-out-python' and l.slug = 'string-methods-and-f-strings-in-depth';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'rounding-out-python' and l.slug = 'string-methods-and-f-strings-in-depth';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does .strip() remove?$md$, $md$["All letters","Whitespace from the beginning and end","Numbers only","The whole string"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'rounding-out-python' and l.slug = 'string-methods-and-f-strings-in-depth' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Forgetting `.strip()` when reading user input — leftover whitespace can make two strings that "look" equal fail an equality check.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'rounding-out-python' and l.slug = 'string-methods-and-f-strings-in-depth';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$List comprehensions in depth$md$, 'list-comprehensions-in-depth', 2, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'rounding-out-python'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Beyond the basic filter shown earlier, comprehensions can also transform every item, not just filter them.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'rounding-out-python' and l.slug = 'list-comprehensions-in-depth';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```python
numbers = [1, 2, 3, 4]
doubled = [n * 2 for n in numbers]
evens_only = [n for n in numbers if n % 2 == 0]
print(doubled, evens_only)
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'rounding-out-python' and l.slug = 'list-comprehensions-in-depth';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Write a comprehension that squares every number in a list.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'rounding-out-python' and l.slug = 'list-comprehensions-in-depth';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'rounding-out-python' and l.slug = 'list-comprehensions-in-depth';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does [n * 2 for n in numbers] produce?$md$, $md$["The original list unchanged","A new list with every number doubled","A single number","An error"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'rounding-out-python' and l.slug = 'list-comprehensions-in-depth' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Writing an overly complex comprehension that's hard to read — if it's getting long or has nested logic, a regular `for` loop is often clearer.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'rounding-out-python' and l.slug = 'list-comprehensions-in-depth';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Error handling with try/except$md$, 'error-handling-with-try-except', 3, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'rounding-out-python'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$`try/except` catches errors so your program doesn't crash — similar to try/catch in JavaScript.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'rounding-out-python' and l.slug = 'error-handling-with-try-except';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```python
try:
    number = int(input("Enter a number: "))
    print(10 / number)
except ValueError:
    print("That's not a valid number")
except ZeroDivisionError:
    print("Can't divide by zero")
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'rounding-out-python' and l.slug = 'error-handling-with-try-except';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Add a try/except around code that might fail, and test it with bad input.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'rounding-out-python' and l.slug = 'error-handling-with-try-except';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'rounding-out-python' and l.slug = 'error-handling-with-try-except';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does except ValueError: specifically catch?$md$, $md$["Every possible error","Errors related to an invalid value (like text where a number was expected)","Only division errors","Nothing, it's optional syntax"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'rounding-out-python' and l.slug = 'error-handling-with-try-except' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Using a bare `except:` that catches every possible error — this can hide real bugs; catching specific error types is safer and clearer.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'rounding-out-python' and l.slug = 'error-handling-with-try-except';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Modules and the standard library$md$, 'modules-and-the-standard-library', 4, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'rounding-out-python'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Python comes with many built-in modules you can `import` for extra functionality — no installation needed.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'rounding-out-python' and l.slug = 'modules-and-the-standard-library';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```python
import random
import datetime

print(random.randint(1, 10))
print(datetime.date.today())
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'rounding-out-python' and l.slug = 'modules-and-the-standard-library';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Use the `random` module to pick a random item from a list.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'rounding-out-python' and l.slug = 'modules-and-the-standard-library';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'rounding-out-python' and l.slug = 'modules-and-the-standard-library';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What do you need to do before using a module like random?$md$, $md$["Nothing","Import it with import random","Install it separately (it's built-in, no install needed)","Rewrite it yourself"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'rounding-out-python' and l.slug = 'modules-and-the-standard-library' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Trying to use a module's function without importing it first — Python doesn't know what `random.randint` means without the `import` line.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'rounding-out-python' and l.slug = 'modules-and-the-standard-library';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Basic classes$md$, 'basic-classes', 5, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'rounding-out-python'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Like other languages, Python classes are templates for creating objects with shared structure and behavior.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'rounding-out-python' and l.slug = 'basic-classes';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```python
class Student:
    def __init__(self, name, track):
        self.name = name
        self.track = track

    def introduce(self):
        print(f"Hi, I'm {self.name}, learning {self.track}")

student1 = Student("Ada", "Python")
student1.introduce()
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'rounding-out-python' and l.slug = 'basic-classes';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Add a second method to the class, like `graduate()`.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'rounding-out-python' and l.slug = 'basic-classes';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'rounding-out-python' and l.slug = 'basic-classes';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does __init__ do in a Python class?$md$, $md$["Runs every time a method is called","Runs once, when a new object is created","Deletes the object","It's optional and rarely used"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'rounding-out-python' and l.slug = 'basic-classes' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Forgetting `self` as the first parameter in every method — Python requires it explicitly (unlike some other languages where "this" is implicit).$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'rounding-out-python' and l.slug = 'basic-classes';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Working with JSON$md$, 'working-with-json', 6, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'rounding-out-python'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Python's `json` module converts between Python dictionaries and JSON text — useful for saving structured data or talking to APIs.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'rounding-out-python' and l.slug = 'working-with-json';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```python
import json

student = {"name": "Ada", "age": 22}
json_text = json.dumps(student)
print(json_text)

back_to_dict = json.loads(json_text)
print(back_to_dict["name"])
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'rounding-out-python' and l.slug = 'working-with-json';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Save a dictionary to a JSON string, then load it back and print a value from it.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'rounding-out-python' and l.slug = 'working-with-json';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'rounding-out-python' and l.slug = 'working-with-json';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does json.dumps() do?$md$, $md$["Deletes a dictionary","Converts a Python dictionary into a JSON string","Converts JSON into a dictionary","Sends data to a server"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'rounding-out-python' and l.slug = 'working-with-json' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Confusing `dumps`/`loads` (string versions) with `dump`/`load` (file versions) — easy to mix up, and using the wrong one against a file vs. a string causes errors.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'rounding-out-python' and l.slug = 'working-with-json';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Virtual environments and pip$md$, 'virtual-environments-and-pip', 7, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'rounding-out-python'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$`pip` installs external packages Python doesn't include by default. A virtual environment keeps each project's packages separate, so projects don't interfere with each other.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'rounding-out-python' and l.slug = 'virtual-environments-and-pip';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$**Try it — numbered steps:**
1. Create a virtual environment: `python -m venv env`
2. Activate it: `source env/bin/activate` (Mac/Linux) or `env\Scripts\activate` (Windows)
3. Install a package: `pip install requests`
4. Confirm it installed: `pip list`$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'rounding-out-python' and l.slug = 'virtual-environments-and-pip';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'rounding-out-python' and l.slug = 'virtual-environments-and-pip';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$Why use a virtual environment instead of installing packages globally?$md$, $md$["It's required by Python, there's no other option","It keeps each project's packages separate and avoids conflicts","It makes code run faster","It's only needed for large projects"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'rounding-out-python' and l.slug = 'virtual-environments-and-pip' and s.order_index = 2;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Forgetting to activate the virtual environment before installing packages — they'll install globally instead of into the project's isolated environment.$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'rounding-out-python' and l.slug = 'virtual-environments-and-pip';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Assignment 6$md$, $md$Refactor your Module 5 capstone to-do program to use a `Todo` class instead of plain dictionaries, wrap file operations in try/except for error handling, and save/load the todo list using the `json` module instead of plain text.

**Pass criteria:** class works correctly, errors are handled gracefully, data saves/loads correctly as JSON.$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'rounding-out-python';


insert into public.modules (track_id, name, slug, order_index)
select t.id, $md$Sharing Your Project on GitHub$md$, 'sharing-your-project-on-github', 6
from public.tracks t where t.slug = 'python'
on conflict (track_id, slug) do update set order_index = excluded.order_index, name = excluded.name;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Pushing your project to GitHub$md$, 'pushing-your-project-to-github', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'sharing-your-project-on-github'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$GitHub stores your code online with version history — useful for showing your work and collaborating, even for a command-line Python project that isn't web-hosted.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'sharing-your-project-on-github' and l.slug = 'pushing-your-project-to-github';


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
where t.slug = 'python' and m.slug = 'sharing-your-project-on-github' and l.slug = 'pushing-your-project-to-github';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'sharing-your-project-on-github' and l.slug = 'pushing-your-project-to-github';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$Why push a command-line Python project to GitHub if it's not a website?$md$, $md$["There's no reason to","It shows your work publicly and tracks your code's history","It's required to run the program","It automatically hosts the program online"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'sharing-your-project-on-github' and l.slug = 'pushing-your-project-to-github' and s.order_index = 2;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Only pushing once at the very end — committing and pushing regularly as you build gives you a real history to look back on, and protects your work if something goes wrong locally.$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'sharing-your-project-on-github' and l.slug = 'pushing-your-project-to-github';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Assignment 7$md$, $md$Push your finished capstone project to GitHub with a clear README explaining what it does and how to run it.

**Pass criteria:** repository is public, README is clear, code runs as described.$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'sharing-your-project-on-github';

-- Verified structurally against the source file before publishing.
update public.lessons l set status = 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'python';
