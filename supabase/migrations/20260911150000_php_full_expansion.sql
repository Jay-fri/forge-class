-- PHP expanded from 12 to 24 lessons across the same 5 modules:
-- comments/style, switch, break/continue, default args, scope,
-- foreach, array functions, multidimensional arrays, sessions/cookies,
-- includes/requires, PDO database basics, and error handling/validation.


update public.lessons l set order_index = 0
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'php' and m.slug = 'getting-started' and l.slug = 'what-php-does';


update public.lessons l set order_index = 1
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'php' and m.slug = 'getting-started' and l.slug = 'embedding-php-in-html';


update public.lessons l set order_index = 2
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'php' and m.slug = 'getting-started' and l.slug = 'variables-and-types';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Comments and code style$md$, 'comments-and-code-style', 3, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'getting-started'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'php' and m.slug = 'getting-started' and l.slug = 'comments-and-code-style';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Writing comments$md$, $md$```php
<?php
// This is a single-line comment
# This also works as a single-line comment

/*
  This is a
  multi-line comment
*/
$name = "Ada"; // inline comment
```

PHP supports two single-line comment styles (// and #) plus /* */ for multi-line blocks. Most PHP style guides (like PSR-12) recommend snake_case or camelCase for variable names and consistent indentation.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'getting-started' and l.slug = 'comments-and-code-style';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$Which of these is NOT a valid way to start a comment in PHP?$md$, '["//","#","/* */","<!--"]'::jsonb, 3, $md$<!-- is HTML comment syntax, not PHP. PHP comments use //, #, or /* */.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'getting-started' and l.slug = 'comments-and-code-style' and s.title = $md$Writing comments$md$;


update public.lessons l set order_index = 0
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'php' and m.slug = 'operators-and-control-flow' and l.slug = 'operators';


update public.lessons l set order_index = 1
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'php' and m.slug = 'operators-and-control-flow' and l.slug = 'if-and-else';


update public.lessons l set order_index = 2
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'php' and m.slug = 'operators-and-control-flow' and l.slug = 'for-and-while-loops';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$switch statements$md$, 'switch-statements', 3, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'operators-and-control-flow'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'php' and m.slug = 'operators-and-control-flow' and l.slug = 'switch-statements';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Choosing between many options$md$, $md$```php
<?php
$day = "Mon";

switch ($day) {
    case "Mon":
        echo "Start of the week";
        break;
    case "Fri":
        echo "Almost the weekend";
        break;
    default:
        echo "Just a regular day";
}
```

switch compares one value against several possible cases, an alternative to a long chain of if/elseif when checking a single variable against many exact values. Do not forget break, without it PHP falls through into the next case.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'operators-and-control-flow' and l.slug = 'switch-statements';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$What happens if you forget break in a switch case?$md$, '["A syntax error occurs","PHP falls through and keeps executing the next case code too","The whole switch is skipped","Nothing, PHP adds it automatically"]'::jsonb, 1, $md$Without break, execution falls through into the next case code instead of stopping, this is a common source of bugs.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'operators-and-control-flow' and l.slug = 'switch-statements' and s.title = $md$Choosing between many options$md$;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$break, continue, and nested loops$md$, 'break-continue-and-nested-loops', 4, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'operators-and-control-flow'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'php' and m.slug = 'operators-and-control-flow' and l.slug = 'break-continue-and-nested-loops';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Controlling a loop from the inside$md$, $md$```php
<?php
for ($i = 1; $i <= 10; $i++) {
    if ($i == 5) {
        break;
    }
    echo $i;
}
```

break stops the loop entirely, continue skips just the current round.

```php
<?php
for ($i = 1; $i <= 10; $i++) {
    if ($i % 2 == 0) {
        continue;
    }
    echo $i;
}
```

This prints only odd numbers.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'operators-and-control-flow' and l.slug = 'break-continue-and-nested-loops';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$What is the difference between break and continue in PHP?$md$, '["They do the same thing","break stops the loop entirely, continue skips to the next round","continue stops the loop, break skips a round","Neither works inside a for loop"]'::jsonb, 1, $md$break exits the loop completely, continue skips the rest of the current round and moves to the next.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'operators-and-control-flow' and l.slug = 'break-continue-and-nested-loops' and s.title = $md$Controlling a loop from the inside$md$;


update public.lessons l set order_index = 0
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'php' and m.slug = 'functions' and l.slug = 'defining-a-function';


update public.lessons l set order_index = 1
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'php' and m.slug = 'functions' and l.slug = 'parameters-and-return-values';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Default arguments$md$, 'default-arguments', 2, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'functions'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'php' and m.slug = 'functions' and l.slug = 'default-arguments';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Giving parameters a fallback value$md$, $md$```php
<?php
function greet($name = "friend") {
    return "Hello, $name!";
}

echo greet();        // Hello, friend!
echo greet("Ada");   // Hello, Ada!
```

A default value is used automatically when the caller does not pass that argument. Default parameters must come after any required ones.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'functions' and l.slug = 'default-arguments';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$When must a default-valued parameter appear in a function parameter list?$md$, '["Always first","After any required parameters","It can appear anywhere","PHP does not support default parameters"]'::jsonb, 1, $md$Parameters with default values must come after required parameters, since PHP matches arguments positionally.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'functions' and l.slug = 'default-arguments' and s.title = $md$Giving parameters a fallback value$md$;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Variable scope$md$, 'variable-scope', 3, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'functions'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'php' and m.slug = 'functions' and l.slug = 'variable-scope';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Local vs global$md$, $md$```php
<?php
$count = 0;

function increment() {
    $count = $count + 1; // this is a NEW local $count
    return $count;
}

echo increment(); // 1
echo $count;      // still 0
```

Variables inside a function are local by default, separate from same-named variables outside. To use an outer variable inside a function you would need the global keyword, though this is best avoided in favor of passing values in as parameters.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'functions' and l.slug = 'variable-scope';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$By default, can a function see a variable defined outside it with the same name?$md$, '["Yes, automatically","No, it needs the global keyword or the value passed in as a parameter","Only for arrays","Only if declared with var"]'::jsonb, 1, $md$PHP functions have their own local scope by default and cannot see outer variables unless explicitly given access.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'functions' and l.slug = 'variable-scope' and s.title = $md$Local vs global$md$;


update public.lessons l set order_index = 0
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'php' and m.slug = 'arrays-and-associative-arrays' and l.slug = 'arrays';


update public.lessons l set order_index = 1
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'php' and m.slug = 'arrays-and-associative-arrays' and l.slug = 'associative-arrays';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Looping over arrays with foreach$md$, 'looping-over-arrays-with-foreach', 2, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'arrays-and-associative-arrays'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'php' and m.slug = 'arrays-and-associative-arrays' and l.slug = 'looping-over-arrays-with-foreach';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$The foreach loop$md$, $md$```php
<?php
$fruits = ["apple", "banana", "cherry"];
foreach ($fruits as $fruit) {
    echo $fruit . "\n";
}

$prices = ["apple" => 50, "banana" => 20];
foreach ($prices as $name => $price) {
    echo "$name costs $price\n";
}
```

foreach is the standard way to loop over both indexed and associative arrays. For associative arrays, as $key => $value gives you both the key and its value on each round.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'arrays-and-associative-arrays' and l.slug = 'looping-over-arrays-with-foreach';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$In foreach ($prices as $name => $price), what does $name represent?$md$, '["The array itself","The key of the current element","Always 0","The last value in the array"]'::jsonb, 1, $md$The variable before => in a foreach over an associative array holds the current key, the one after holds its value.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'arrays-and-associative-arrays' and l.slug = 'looping-over-arrays-with-foreach' and s.title = $md$The foreach loop$md$;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Common array functions$md$, 'common-array-functions', 3, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'arrays-and-associative-arrays'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'php' and m.slug = 'arrays-and-associative-arrays' and l.slug = 'common-array-functions';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Built-in helpers for arrays$md$, $md$```php
<?php
$numbers = [3, 1, 4, 1, 5];

echo count($numbers);            // 5
sort($numbers);                  // sorts in place, ascending
print_r($numbers);

$doubled = array_map(fn($n) => $n * 2, $numbers);
$evens = array_filter($numbers, fn($n) => $n % 2 == 0);

echo in_array(4, $numbers) ? "yes" : "no";
```

count gives the size, sort reorders in place, array_map transforms every element into a new array, array_filter keeps only elements matching a condition, and in_array checks membership. These four cover most everyday array processing.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'arrays-and-associative-arrays' and l.slug = 'common-array-functions';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$What does array_filter do?$md$, '["Sorts an array","Returns a new array containing only elements that pass a test","Removes all duplicates","Counts array elements"]'::jsonb, 1, $md$array_filter runs each element through a callback and keeps only the ones where it returns true.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'arrays-and-associative-arrays' and l.slug = 'common-array-functions' and s.title = $md$Built-in helpers for arrays$md$;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Multidimensional arrays$md$, 'multidimensional-arrays', 4, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'arrays-and-associative-arrays'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'php' and m.slug = 'arrays-and-associative-arrays' and l.slug = 'multidimensional-arrays';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Arrays inside arrays$md$, $md$```php
<?php
$students = [
    ["name" => "Ada", "score" => 92],
    ["name" => "Grace", "score" => 88],
];

foreach ($students as $student) {
    echo $student["name"] . ": " . $student["score"] . "\n";
}
```

An array can hold other arrays as its values, useful for representing rows of data like students, products, or form entries, each with their own set of fields.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'arrays-and-associative-arrays' and l.slug = 'multidimensional-arrays';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$What does $students[0]["name"] access in the example above?$md$, '["The whole first student array","Grace score","Ada, the name field of the first student","An error, this syntax is invalid"]'::jsonb, 2, $md$$students[0] is the first inner array, and ["name"] then reads its name field, which is Ada.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'arrays-and-associative-arrays' and l.slug = 'multidimensional-arrays' and s.title = $md$Arrays inside arrays$md$;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Sessions and cookies$md$, 'sessions-and-cookies', 1, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'forms-and-simple-server-logic'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'php' and m.slug = 'forms-and-simple-server-logic' and l.slug = 'sessions-and-cookies';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Remembering a visitor between requests$md$, $md$```php
<?php
session_start();
$_SESSION["username"] = "Ada";
echo $_SESSION["username"];
```

HTTP itself has no memory, each request is independent. session_start() lets PHP remember data across a visitor's requests using a session, commonly used for keeping someone logged in.

```php
<?php
setcookie("theme", "dark", time() + 3600); // expires in 1 hour
echo $_COOKIE["theme"] ?? "not set";
```

Cookies are similar but stored in the visitor's browser instead of on the server, often used for longer-lived, less sensitive preferences.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'forms-and-simple-server-logic' and l.slug = 'sessions-and-cookies';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$Why is session_start() needed before using $_SESSION?$md$, '["It is not needed, PHP does this automatically","It starts or resumes the session so PHP knows which visitor the data belongs to","It only affects cookies, not sessions","It deletes old session data"]'::jsonb, 1, $md$session_start() initializes or resumes the session for the current visitor, without it $_SESSION has nothing to attach to.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'forms-and-simple-server-logic' and l.slug = 'sessions-and-cookies' and s.title = $md$Remembering a visitor between requests$md$;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Includes and requires$md$, 'includes-and-requires', 2, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'forms-and-simple-server-logic'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'php' and m.slug = 'forms-and-simple-server-logic' and l.slug = 'includes-and-requires';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Splitting code across files$md$, $md$```php
<?php
// header.php
echo "<header>My Site</header>";
```

```php
<?php
// index.php
include "header.php";
echo "Welcome!";
```

include (and its stricter cousin require) pulls in code from another file, letting you reuse things like a header or a set of helper functions across many pages instead of duplicating them. require stops the script with a fatal error if the file is missing, include only emits a warning and keeps going, which is why require is usually the safer choice for anything essential.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'forms-and-simple-server-logic' and l.slug = 'includes-and-requires';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$What is the key difference between include and require?$md$, '["They are identical","require stops the script with a fatal error if the file is missing, include just warns and continues","include is faster","require only works with HTML files"]'::jsonb, 1, $md$require causes a fatal error and halts the script if the file cannot be found, include only raises a warning and lets the script continue.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'forms-and-simple-server-logic' and l.slug = 'includes-and-requires' and s.title = $md$Splitting code across files$md$;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Connecting to a database with PDO$md$, 'connecting-to-a-database-with-pdo', 3, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'forms-and-simple-server-logic'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'php' and m.slug = 'forms-and-simple-server-logic' and l.slug = 'connecting-to-a-database-with-pdo';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Talking to a real database$md$, $md$```php
<?php
$pdo = new PDO("mysql:host=localhost;dbname=forge", "user", "password");

$stmt = $pdo->prepare("SELECT * FROM users WHERE email = ?");
$stmt->execute([$_POST["email"]]);
$user = $stmt->fetch();
```

PDO (PHP Data Objects) is PHP's standard way to talk to a database. Notice the ? placeholder instead of building the query by joining strings together, that is a prepared statement: the database driver keeps your data and your SQL command separate, so user input can never be interpreted as part of the command itself. This is what actually prevents SQL injection, not just being careful with string escaping.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'forms-and-simple-server-logic' and l.slug = 'connecting-to-a-database-with-pdo';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$Why use a prepared statement with a placeholder instead of building SQL by concatenating strings?$md$, '["It is shorter to type","It keeps user input separate from the SQL command, preventing SQL injection","It makes queries run faster","PDO requires it for SELECT only"]'::jsonb, 1, $md$Prepared statements send the query structure and the data separately to the database, so malicious input can never be interpreted as SQL code, this is the real defense against SQL injection.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'forms-and-simple-server-logic' and l.slug = 'connecting-to-a-database-with-pdo' and s.title = $md$Talking to a real database$md$;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Error handling and validation$md$, 'error-handling-and-validation', 4, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'forms-and-simple-server-logic'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'php' and m.slug = 'forms-and-simple-server-logic' and l.slug = 'error-handling-and-validation';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Validating input and catching errors$md$, $md$```php
<?php
$email = trim($_POST["email"] ?? "");

if (empty($email)) {
    echo "Email is required";
} elseif (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    echo "That does not look like a valid email";
} else {
    echo "Looks good!";
}
```

Never trust data coming from a form, always validate it on the server even if you also validate in the browser. filter_var with FILTER_VALIDATE_EMAIL is a built-in way to check common formats.

```php
<?php
try {
    $result = 10 / 0;
} catch (DivisionByZeroError $e) {
    echo "Error: " . $e->getMessage();
}
```

try/catch lets you catch specific errors and respond gracefully instead of letting the whole script crash.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'forms-and-simple-server-logic' and l.slug = 'error-handling-and-validation';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$Why should form input always be validated on the server, even if it is already validated in the browser?$md$, '["Server validation is optional if browser validation exists","Browser validation can be bypassed entirely, so the server is the only validation you can actually trust","It makes the page load faster","PHP requires it by law"]'::jsonb, 1, $md$Anyone can bypass browser-side validation (disabling JS, using a raw HTTP client), so server-side validation is the only check that actually cannot be skipped.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'forms-and-simple-server-logic' and l.slug = 'error-handling-and-validation' and s.title = $md$Validating input and catching errors$md$;


update public.lessons l set order_index = 5
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'php' and m.slug = 'forms-and-simple-server-logic' and l.slug = 'capstone-project';
