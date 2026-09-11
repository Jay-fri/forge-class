-- Embeds courses/course-php.md verbatim as the standalone PHP track's
-- full content, replacing the earlier self-authored 5-module/24-lesson
-- content with the real course's own 7-module structure. Content
-- preserved as-written. Inserted as draft; published after structural
-- verification against the source file.


delete from public.modules m
using public.tracks t
where m.track_id = t.id and t.slug = 'php';


insert into public.modules (track_id, name, slug, order_index)
select t.id, $md$Getting Started$md$, 'getting-started', 0
from public.tracks t where t.slug = 'php'
on conflict (track_id, slug) do update set order_index = excluded.order_index, name = excluded.name;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$What is PHP?$md$, 'what-is-php', 0, true, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'getting-started'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$PHP is a language that runs on the **server**, not in the browser like JavaScript. It builds the HTML page *before* it's sent to the visitor — that's why PHP is common for things like processing forms and connecting to databases.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'getting-started' and l.slug = 'what-is-php';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'getting-started' and l.slug = 'what-is-php';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$Where does PHP code run?$md$, $md$["In the visitor's browser","On the server, before the page is sent","Nowhere, it's just for styling","Only inside a database"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'getting-started' and l.slug = 'what-is-php' and s.order_index = 1;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Expecting PHP to run instantly like JavaScript in a browser console — PHP needs a server environment to run.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'getting-started' and l.slug = 'what-is-php';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Running your first PHP, embedding in HTML$md$, 'running-your-first-php-embedding-in-html', 1, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'getting-started'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$PHP code is wrapped in `<?php ?>` tags and can be mixed directly inside an HTML file.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'getting-started' and l.slug = 'running-your-first-php-embedding-in-html';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```php
<!DOCTYPE html>
<html>
<body>
  <?php echo "Hello, Forge"; ?>
</body>
</html>
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'getting-started' and l.slug = 'running-your-first-php-embedding-in-html';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Change the text inside `echo` to your own message.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'getting-started' and l.slug = 'running-your-first-php-embedding-in-html';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'getting-started' and l.slug = 'running-your-first-php-embedding-in-html';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does echo do in PHP?$md$, $md$["Deletes a variable","Outputs text to the page","Repeats a sound","Starts a loop"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'getting-started' and l.slug = 'running-your-first-php-embedding-in-html' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Forgetting the semicolon `;` at the end of a PHP line — PHP requires it after every statement.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'getting-started' and l.slug = 'running-your-first-php-embedding-in-html';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Variables and basic types$md$, 'variables-and-basic-types', 2, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'getting-started'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$PHP variables always start with a `$` sign.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'getting-started' and l.slug = 'variables-and-basic-types';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```php
<?php
$name = "Ada";
$age = 22;
$isStudent = true;
echo $name . " " . $age;
?>
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'getting-started' and l.slug = 'variables-and-basic-types';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Create your own variables for your name, age, and favorite subject.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'getting-started' and l.slug = 'variables-and-basic-types';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'getting-started' and l.slug = 'variables-and-basic-types';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What symbol must every PHP variable start with?$md$, $md$["#","$","&","@"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'getting-started' and l.slug = 'variables-and-basic-types' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Forgetting the `$` when using a variable later in the code — `echo name;` (without `$`) causes an error since PHP thinks you mean something else entirely.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'getting-started' and l.slug = 'variables-and-basic-types';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Assignment 1 — Profile echo$md$, $md$Create variables for your name, age, and a one-line bio, then echo a formatted introduction using them.

**Pass criteria:** uses at least 3 variables, output is readable, no errors.$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'getting-started';


insert into public.modules (track_id, name, slug, order_index)
select t.id, $md$Operators & Control Flow$md$, 'operators-and-control-flow', 1
from public.tracks t where t.slug = 'php'
on conflict (track_id, slug) do update set order_index = excluded.order_index, name = excluded.name;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Operators$md$, 'operators', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'operators-and-control-flow'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Arithmetic (`+ - * /`) and comparison (`== > <`) work similarly to other languages. PHP also uses `.` (a dot) to join strings together, called concatenation.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'operators-and-control-flow' and l.slug = 'operators';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```php
<?php
echo "Hello " . "World";
echo 5 + 3;
?>
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'operators-and-control-flow' and l.slug = 'operators';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Concatenate your own first and last name into one string.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'operators-and-control-flow' and l.slug = 'operators';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'operators-and-control-flow' and l.slug = 'operators';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does . do between two strings in PHP?$md$, $md$["Multiplies them","Joins them together","Compares them","Nothing, it's a typo"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'operators-and-control-flow' and l.slug = 'operators' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Using `+` to join strings like in some other languages — in PHP, `+` is for math; `.` is for joining text.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'operators-and-control-flow' and l.slug = 'operators';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Conditionals$md$, 'conditionals', 1, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'operators-and-control-flow'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$PHP uses `if / elseif / else` (note: "elseif" as one word, unlike Python's "elif").$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'operators-and-control-flow' and l.slug = 'conditionals';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```php
<?php
$age = 20;
if ($age >= 18) {
    echo "You can vote";
} else {
    echo "Not yet";
}
?>
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'operators-and-control-flow' and l.slug = 'conditionals';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Add an `elseif` branch for exactly age 18.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'operators-and-control-flow' and l.slug = 'conditionals';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'operators-and-control-flow' and l.slug = 'conditionals';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What keyword does PHP use for an additional condition?$md$, $md$["elif","elseif","else if only","orif"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'operators-and-control-flow' and l.slug = 'conditionals' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Forgetting the `$` on the variable inside the condition (`if (age >= 18)`) — this causes an "undefined constant" error since PHP thinks `age` is something else without the `$`.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'operators-and-control-flow' and l.slug = 'conditionals';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Loops$md$, 'loops', 2, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'operators-and-control-flow'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$`for` and `while` loops work much like JavaScript's.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'operators-and-control-flow' and l.slug = 'loops';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```php
<?php
for ($i = 1; $i <= 5; $i++) {
    echo $i . " ";
}
?>
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'operators-and-control-flow' and l.slug = 'loops';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Change the loop to count 1 to 10.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'operators-and-control-flow' and l.slug = 'loops';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'operators-and-control-flow' and l.slug = 'loops';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does $i++ do?$md$, $md$["Resets $i to 0","Increases $i by 1 each time","Stops the loop","Prints $i"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'operators-and-control-flow' and l.slug = 'loops' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Forgetting `$` on the loop variable anywhere in the loop — every use of a PHP variable needs the `$`, every time.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'operators-and-control-flow' and l.slug = 'loops';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Assignment 2 — FizzBuzz$md$, $md$Print numbers 1–20; for multiples of 3 print "Fizz", multiples of 5 print "Buzz", multiples of both print "FizzBuzz".

**Pass criteria:** correct output for all 20 numbers, uses a loop and conditionals.$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'operators-and-control-flow';


insert into public.modules (track_id, name, slug, order_index)
select t.id, $md$Functions$md$, 'functions', 2
from public.tracks t where t.slug = 'php'
on conflict (track_id, slug) do update set order_index = excluded.order_index, name = excluded.name;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Defining functions$md$, 'defining-functions', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'functions'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Functions are defined with the `function` keyword.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'functions' and l.slug = 'defining-functions';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```php
<?php
function greet($name) {
    echo "Hello, " . $name;
}
greet("Ada");
?>
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'functions' and l.slug = 'defining-functions';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Call `greet()` with your own name.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'functions' and l.slug = 'defining-functions';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'functions' and l.slug = 'defining-functions';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What keyword starts a function definition in PHP?$md$, $md$["def","function","func","define"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'functions' and l.slug = 'defining-functions' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Forgetting the `$` on parameter names, both when defining and using them inside the function.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'functions' and l.slug = 'defining-functions';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Parameters and return values$md$, 'parameters-and-return-values', 1, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'functions'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Functions can take parameters and give back a value with `return`, just like other languages.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'functions' and l.slug = 'parameters-and-return-values';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```php
<?php
function add($a, $b) {
    return $a + $b;
}
$total = add(4, 7);
echo $total;
?>
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'functions' and l.slug = 'parameters-and-return-values';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Write a function that returns the larger of two numbers.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'functions' and l.slug = 'parameters-and-return-values';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'functions' and l.slug = 'parameters-and-return-values';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does return do inside a function?$md$, $md$["Prints the value immediately","Sends a value back to wherever the function was called","Ends the whole program","Deletes the function"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'functions' and l.slug = 'parameters-and-return-values' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Using `echo` inside a function instead of `return` when you actually need the value for further use elsewhere — `echo` just displays it, it doesn't hand it back to your code.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'functions' and l.slug = 'parameters-and-return-values';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Assignment 3 — Simple calculator$md$, $md$Write functions `add`, `subtract`, `multiply`, `divide`, each taking two numbers and returning the result.

**Pass criteria:** all four return correct results, `divide` handles division by zero without crashing.$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'functions';


insert into public.modules (track_id, name, slug, order_index)
select t.id, $md$Arrays & Associative Arrays$md$, 'arrays-and-associative-arrays', 3
from public.tracks t where t.slug = 'php'
on conflict (track_id, slug) do update set order_index = excluded.order_index, name = excluded.name;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Arrays$md$, 'arrays', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'arrays-and-associative-arrays'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$A PHP array is an ordered list, similar to JavaScript's.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'arrays-and-associative-arrays' and l.slug = 'arrays';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```php
<?php
$foods = ["rice", "beans", "yam"];
$foods[] = "plantain";
print_r($foods);
?>
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'arrays-and-associative-arrays' and l.slug = 'arrays';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Add two more items to the array.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'arrays-and-associative-arrays' and l.slug = 'arrays';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'arrays-and-associative-arrays' and l.slug = 'arrays';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does $foods[] = "plantain" do?$md$, $md$["Removes an item","Adds \"plantain\" to the end of the array","Replaces the whole array","Causes an error"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'arrays-and-associative-arrays' and l.slug = 'arrays' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Forgetting `print_r()` is needed to actually see the *contents* of an array — `echo $foods` alone doesn't display it properly.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'arrays-and-associative-arrays' and l.slug = 'arrays';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Associative arrays$md$, 'associative-arrays', 1, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'arrays-and-associative-arrays'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$An associative array is PHP's key-value structure — the equivalent of a JavaScript object or Python dictionary.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'arrays-and-associative-arrays' and l.slug = 'associative-arrays';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```php
<?php
$student = [
    "name" => "Ada",
    "age" => 22
];
echo $student["name"];
?>
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'arrays-and-associative-arrays' and l.slug = 'associative-arrays';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Add a `"track"` key and echo it.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'arrays-and-associative-arrays' and l.slug = 'associative-arrays';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'arrays-and-associative-arrays' and l.slug = 'associative-arrays';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What symbol connects a key to its value in a PHP associative array?$md$, $md$[":","=>","=","->"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'arrays-and-associative-arrays' and l.slug = 'associative-arrays' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Using `:` (like JavaScript objects use) instead of `=>` — PHP associative arrays specifically require the arrow syntax.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'arrays-and-associative-arrays' and l.slug = 'associative-arrays';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Assignment 4 — Contact list$md$, $md$Build an array of associative arrays representing contacts (`["name" => ..., "phone" => ...]`), write functions to add, find by name, and remove a contact.

**Pass criteria:** all three functions work correctly.$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'arrays-and-associative-arrays';


insert into public.modules (track_id, name, slug, order_index)
select t.id, $md$Forms & Capstone$md$, 'forms-and-capstone', 4
from public.tracks t where t.slug = 'php'
on conflict (track_id, slug) do update set order_index = excluded.order_index, name = excluded.name;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Handling a form submission$md$, 'handling-a-form-submission', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'forms-and-capstone'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$When an HTML form submits, PHP can read the submitted values using the `$_POST` superglobal array.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'forms-and-capstone' and l.slug = 'handling-a-form-submission';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```html
<form method="POST" action="process.php">
  <input type="text" name="username">
  <input type="submit">
</form>
```
```php
<?php
// inside process.php
$username = $_POST["username"];
echo "Hello, " . $username;
?>
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'forms-and-capstone' and l.slug = 'handling-a-form-submission';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Add an email field to the form and read it in PHP too.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'forms-and-capstone' and l.slug = 'handling-a-form-submission';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'forms-and-capstone' and l.slug = 'handling-a-form-submission';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does $_POST contain?$md$, $md$["All the PHP functions available","The data submitted by a form using the POST method","A list of all users","Nothing unless you configure a database"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'forms-and-capstone' and l.slug = 'handling-a-form-submission' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Mismatching the form input's `name` attribute with the key used in `$_POST` — they must match exactly, or the value won't be found.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'forms-and-capstone' and l.slug = 'handling-a-form-submission';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Capstone Assignment — Contact form handler$md$, $md$Build an HTML contact form (name, email, message) and a PHP script that reads the submitted values, checks that none are empty (basic validation), and echoes a confirmation message showing what was submitted.

**Pass criteria:** form submits correctly, PHP correctly reads all fields, empty-field validation works, confirmation message displays the submitted data. This is the assignment that unlocks this track's certificate.$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'forms-and-capstone';


insert into public.modules (track_id, name, slug, order_index)
select t.id, $md$Rounding Out PHP$md$, 'rounding-out-php', 5
from public.tracks t where t.slug = 'php'
on conflict (track_id, slug) do update set order_index = excluded.order_index, name = excluded.name;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$String functions$md$, 'string-functions', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'rounding-out-php'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$PHP has many built-in string functions: `strtoupper()`, `strtolower()`, `trim()` (remove whitespace), `str_replace()`.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'rounding-out-php' and l.slug = 'string-functions';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```php
<?php
$name = "  Ada  ";
$clean = trim($name);
echo strtoupper($clean);
?>
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'rounding-out-php' and l.slug = 'string-functions';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Use `str_replace()` to replace a word in a sentence.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'rounding-out-php' and l.slug = 'string-functions';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'rounding-out-php' and l.slug = 'string-functions';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does trim() do?$md$, $md$["Deletes the whole string","Removes whitespace from the beginning and end","Converts to uppercase","Splits a string"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'rounding-out-php' and l.slug = 'string-functions' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Forgetting PHP string functions generally return a *new* string rather than changing the original — you need to save the result to a variable.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'rounding-out-php' and l.slug = 'string-functions';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Error handling with try/catch$md$, 'error-handling-with-try-catch', 1, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'rounding-out-php'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$Like other languages, PHP supports try/catch for handling errors gracefully.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'rounding-out-php' and l.slug = 'error-handling-with-try-catch';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```php
<?php
try {
    $result = 10 / 0;
} catch (DivisionByZeroError $e) {
    echo "Can't divide by zero: " . $e->getMessage();
}
?>
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'rounding-out-php' and l.slug = 'error-handling-with-try-catch';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Wrap risky code (like reading a file that might not exist) in a try/catch.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'rounding-out-php' and l.slug = 'error-handling-with-try-catch';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'rounding-out-php' and l.slug = 'error-handling-with-try-catch';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does $e->getMessage() give you?$md$, $md$["The line number only","A description of what went wrong","Nothing useful","The entire program's code"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'rounding-out-php' and l.slug = 'error-handling-with-try-catch' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Catching an error but not doing anything useful with it — at minimum, log or display something so the failure isn't silent.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'rounding-out-php' and l.slug = 'error-handling-with-try-catch';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Sessions and cookies$md$, 'sessions-and-cookies', 2, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'rounding-out-php'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$HTTP is stateless — the server doesn't automatically remember who you are between requests. Sessions let a server remember a logged-in user across multiple page visits.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'rounding-out-php' and l.slug = 'sessions-and-cookies';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```php
<?php
session_start();
$_SESSION["username"] = "Ada";
echo $_SESSION["username"];
?>
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'rounding-out-php' and l.slug = 'sessions-and-cookies';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Start a session, store a value, and read it back on a "reload."$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'rounding-out-php' and l.slug = 'sessions-and-cookies';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'rounding-out-php' and l.slug = 'sessions-and-cookies';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What must you call before using $_SESSION?$md$, $md$["Nothing","session_start()","session_create()","import session"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'rounding-out-php' and l.slug = 'sessions-and-cookies' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Forgetting `session_start()` must be called before any HTML output — it needs to run first on every page that uses sessions.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'rounding-out-php' and l.slug = 'sessions-and-cookies';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Including other PHP files$md$, 'including-other-php-files', 3, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'rounding-out-php'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$`include` or `require` lets you reuse code across multiple files — like a shared header or a set of functions.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'rounding-out-php' and l.slug = 'including-other-php-files';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```php
<?php
// functions.php
function greet($name) {
    return "Hello, " . $name;
}
```
```php
<?php
require "functions.php";
echo greet("Ada");
?>
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'rounding-out-php' and l.slug = 'including-other-php-files';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Move one of your earlier functions into its own file and `require` it.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'rounding-out-php' and l.slug = 'including-other-php-files';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'rounding-out-php' and l.slug = 'including-other-php-files';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What's the difference between include and require?$md$, $md$["No difference","require stops the script with an error if the file is missing; include just warns and continues","include is faster","require is deprecated"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'rounding-out-php' and l.slug = 'including-other-php-files' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Using `include` for something essential (like a database connection file) — if it's missing, the script keeps running broken instead of stopping clearly; `require` is safer for critical files.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'rounding-out-php' and l.slug = 'including-other-php-files';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Basic database connection (PDO)$md$, 'basic-database-connection-pdo', 4, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'rounding-out-php'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$PDO is PHP's standard way to connect to a database like MySQL and run queries safely.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'rounding-out-php' and l.slug = 'basic-database-connection-pdo';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```php
<?php
$pdo = new PDO("mysql:host=localhost;dbname=forge", "username", "password");
$stmt = $pdo->prepare("SELECT * FROM students WHERE track = ?");
$stmt->execute(["PHP"]);
$results = $stmt->fetchAll();
print_r($results);
?>
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'rounding-out-php' and l.slug = 'basic-database-connection-pdo';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Research and write (without necessarily running) a prepared statement to insert a new row.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'rounding-out-php' and l.slug = 'basic-database-connection-pdo';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'rounding-out-php' and l.slug = 'basic-database-connection-pdo';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$Why use a "prepared statement" (with ? placeholders) instead of directly inserting variables into the SQL string?$md$, $md$["It's just a style preference","It protects against SQL injection attacks","It's faster","It's required by PHP syntax"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'rounding-out-php' and l.slug = 'basic-database-connection-pdo' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Building SQL queries by directly concatenating user input into the string (`"SELECT * WHERE name = '" . $name . "'"`) — this is a serious security vulnerability; always use prepared statements with placeholders.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'rounding-out-php' and l.slug = 'basic-database-connection-pdo';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Basic OOP in PHP$md$, 'basic-oop-in-php', 5, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'rounding-out-php'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$PHP supports classes and objects, similar to other languages.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'rounding-out-php' and l.slug = 'basic-oop-in-php';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'code_example', $md$```php
<?php
class Student {
    public $name;
    public $track;

    public function __construct($name, $track) {
        $this->name = $name;
        $this->track = $track;
    }

    public function introduce() {
        echo "Hi, I'm " . $this->name . ", learning " . $this->track;
    }
}

$student1 = new Student("Ada", "PHP");
$student1->introduce();
?>
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'rounding-out-php' and l.slug = 'basic-oop-in-php';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'try_it', $md$Add a second method to the class.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'rounding-out-php' and l.slug = 'basic-oop-in-php';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'rounding-out-php' and l.slug = 'basic-oop-in-php';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What does __construct do?$md$, $md$["Runs on every method call","Runs once, when a new object is created with new","Deletes the object","It's optional and rarely used"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'rounding-out-php' and l.slug = 'basic-oop-in-php' and s.order_index = 3;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Forgetting `$this->` when accessing a class property from inside a method — without it, PHP looks for a regular variable instead of the object's property.$md$, 4
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'rounding-out-php' and l.slug = 'basic-oop-in-php';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Assignment 6$md$, $md$Refactor your Module 5 capstone contact form handler to use a `ContactSubmission` class instead of loose variables, wrap the form processing in try/catch, and move the validation logic into its own included file.

**Pass criteria:** class works correctly, errors are handled, code is split across files sensibly.$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'rounding-out-php';


insert into public.modules (track_id, name, slug, order_index)
select t.id, $md$Sharing Your Project on GitHub$md$, 'sharing-your-project-on-github', 6
from public.tracks t where t.slug = 'php'
on conflict (track_id, slug) do update set order_index = excluded.order_index, name = excluded.name;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Pushing your project to GitHub$md$, 'pushing-your-project-to-github', 0, false, 'draft'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'sharing-your-project-on-github'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'concept', $md$GitHub stores your code online with version history — useful for showing your work publicly.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'sharing-your-project-on-github' and l.slug = 'pushing-your-project-to-github';


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
where t.slug = 'php' and m.slug = 'sharing-your-project-on-github' and l.slug = 'pushing-your-project-to-github';


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'check_in', $md$$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'sharing-your-project-on-github' and l.slug = 'pushing-your-project-to-github';


insert into public.section_quizzes (section_id, question, options, correct_index, order_index)
select s.id, $md$What's the benefit of pushing your PHP project to GitHub, even without live hosting set up?$md$, $md$["None","It shows your work publicly and preserves its history","It automatically hosts your PHP site","It replaces the need for a server entirely"]$md$::jsonb, 1, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'sharing-your-project-on-github' and l.slug = 'pushing-your-project-to-github' and s.order_index = 2;


insert into public.sections (lesson_id, section_type, content, order_index)
select l.id, 'common_mistake', $md$Committing sensitive info like real database passwords directly into the code that gets pushed — always keep credentials out of version control (use environment variables or a gitignored config file instead).$md$, 3
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'sharing-your-project-on-github' and l.slug = 'pushing-your-project-to-github';


insert into public.assignments (module_id, title, spec)
select m.id, $md$Assignment 7$md$, $md$Push your finished capstone project to GitHub with a clear README explaining what it does and how to set it up.

**Pass criteria:** repository is public, README is clear, no sensitive credentials are committed.$md$
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'sharing-your-project-on-github';

-- Verified structurally against the source file before publishing.
update public.lessons l set status = 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'php';
