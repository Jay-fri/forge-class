-- PHP track built out in full. Sandpack has no PHP runtime, so these
-- are read-only code walkthroughs, same treatment as Backend and Python.


update public.lessons l set status = 'published', is_free_preview = true
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'php' and m.slug = 'getting-started' and l.slug = 'what-php-does';


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'php' and m.slug = 'getting-started' and l.slug = 'what-php-does';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Code that runs before the page reaches you$md$, $md$PHP is a server-side language: it runs on the server, builds up the final HTML, and only that finished HTML is sent to the browser. By the time you view a PHP page's source, no PHP code is left, only the HTML it produced.

```php
<?php
echo "Hello, Forge";
?>
```

echo is PHP's way of outputting text, similar to console.log or print. Every PHP snippet starts with <?php and ends with ?>.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'getting-started' and l.slug = 'what-php-does';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$Where does PHP code actually run?$md$, '["In the visitor browser","On the server, before the page is sent to the browser","Only inside a database","In a separate mobile app"]'::jsonb, 1, $md$PHP runs server-side. The browser only ever receives the finished HTML output, never the PHP code itself.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'getting-started' and l.slug = 'what-php-does' and s.title = $md$Code that runs before the page reaches you$md$;


update public.lessons l set status = 'published', is_free_preview = false
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'php' and m.slug = 'getting-started' and l.slug = 'embedding-php-in-html';


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'php' and m.slug = 'getting-started' and l.slug = 'embedding-php-in-html';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Mixing PHP into a page$md$, $md$PHP was built to sit directly inside HTML, switching in and out of PHP mode wherever you need dynamic content.

```php
<!doctype html>
<html>
  <body>
    <h1>Welcome</h1>
    <p>Today is <?php echo date("Y-m-d"); ?></p>
  </body>
</html>
```

Everything outside <?php ... ?> is sent to the browser exactly as written. Everything inside runs on the server first, and its output takes the place of the PHP block.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'getting-started' and l.slug = 'embedding-php-in-html';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$In the example above, what does the browser actually receive for the date line?$md$, '["The literal text <?php echo date(...); ?>","The finished date, already calculated by the server","An error","Nothing, that line is removed"]'::jsonb, 1, $md$The PHP block runs on the server and is replaced by its output, here the current date, before the page is sent to the browser.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'getting-started' and l.slug = 'embedding-php-in-html' and s.title = $md$Mixing PHP into a page$md$;


update public.lessons l set status = 'published', is_free_preview = false
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'php' and m.slug = 'getting-started' and l.slug = 'variables-and-types';


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'php' and m.slug = 'getting-started' and l.slug = 'variables-and-types';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Storing values$md$, $md$```php
<?php
$name = "Ada";
$age = 22;
$isStudent = true;
echo $name . " is " . $age;
?>
```

Every PHP variable starts with a dollar sign. The dot (.) joins, or concatenates, strings together, PHP's equivalent of JavaScript's + for strings.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'getting-started' and l.slug = 'variables-and-types';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$What symbol does every PHP variable name start with?$md$, '["#","@","$","%"]'::jsonb, 2, $md$PHP variables are always prefixed with a dollar sign, like $name.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'getting-started' and l.slug = 'variables-and-types' and s.title = $md$Storing values$md$;


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Three types you will use constantly$md$, $md$| Type | Example | Use |
|---|---|---|
| string | "Ada" | Text |
| int / float | 22 / 3.14 | Whole and decimal numbers |
| bool | true | Yes or no logic |

PHP's booleans, unlike Python's, are lowercase: true and false, matching JavaScript.$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'getting-started' and l.slug = 'variables-and-types';


update public.lessons l set status = 'published', is_free_preview = false
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'php' and m.slug = 'operators-and-control-flow' and l.slug = 'operators';


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'php' and m.slug = 'operators-and-control-flow' and l.slug = 'operators';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Arithmetic and comparison$md$, $md$| Operator | Meaning | Example |
|---|---|---|
| + - * / | Arithmetic | 4 * 3 |
| . | String concatenation | "Hi " . $name |
| == | Loose equal | 5 == "5" is true |
| === | Strict equal | 5 === "5" is false |

Just like JavaScript, PHP has both a loose (==) and strict (===) equality check. Reaching for === first avoids surprises from PHP quietly converting types to compare them.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'operators-and-control-flow' and l.slug = 'operators';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$What is the difference between == and === in PHP?$md$, '["No difference","== checks value only, === checks value and type","=== checks value only, == checks value and type","Both only check type"]'::jsonb, 1, $md$== allows PHP to convert types before comparing, which can cause surprises. === requires both the value and the type to match.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'operators-and-control-flow' and l.slug = 'operators' and s.title = $md$Arithmetic and comparison$md$;


update public.lessons l set status = 'published', is_free_preview = false
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'php' and m.slug = 'operators-and-control-flow' and l.slug = 'if-and-else';


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'php' and m.slug = 'operators-and-control-flow' and l.slug = 'if-and-else';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Branching logic$md$, $md$```php
<?php
$age = 20;

if ($age >= 18) {
    echo "You can vote";
} else {
    echo "Not yet";
}
?>
```

This reads almost identically to JavaScript's if/else, just with $ in front of variable names.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'operators-and-control-flow' and l.slug = 'if-and-else';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Common mistake$md$, $md$**Common mistake:** forgetting the dollar sign on a variable.

```php
if (age >= 18) {
```

PHP treats age without a $ as a constant, not the variable you meant, which raises a warning and almost never does what you expect. Every reference to a variable needs its $.$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'operators-and-control-flow' and l.slug = 'if-and-else';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$What happens if you forget the dollar sign on a variable name in PHP?$md$, '["PHP automatically adds it for you","PHP treats it as a constant instead of your variable, which usually breaks the code","It becomes a string automatically","Nothing changes"]'::jsonb, 1, $md$Without the $, PHP interprets the name as a constant rather than your variable, which is almost never what you intended.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'operators-and-control-flow' and l.slug = 'if-and-else' and s.title = $md$Common mistake$md$;


update public.lessons l set status = 'published', is_free_preview = false
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'php' and m.slug = 'operators-and-control-flow' and l.slug = 'for-and-while-loops';


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'php' and m.slug = 'operators-and-control-flow' and l.slug = 'for-and-while-loops';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$for loops$md$, $md$```php
<?php
for ($i = 1; $i <= 10; $i++) {
    echo $i . "\n";
}
?>
```

PHP's for loop looks exactly like JavaScript's, just with $ on the counter variable.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'operators-and-control-flow' and l.slug = 'for-and-while-loops';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$while loops$md$, $md$```php
<?php
$count = 0;
while ($count < 5) {
    echo $count;
    $count++;
}
?>
```$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'operators-and-control-flow' and l.slug = 'for-and-while-loops';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$What are the three parts inside a PHP for loop's parentheses?$md$, '["Only a condition","A starting point, a condition to keep going, and what happens after each round","Three separate loops","A function call"]'::jsonb, 1, $md$Just like JavaScript, a for loop has a starting point, a continue condition, and an increment step, separated by semicolons.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'operators-and-control-flow' and l.slug = 'for-and-while-loops' and s.title = $md$while loops$md$;


update public.lessons l set status = 'published', is_free_preview = false
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'php' and m.slug = 'functions' and l.slug = 'defining-a-function';


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'php' and m.slug = 'functions' and l.slug = 'defining-a-function';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$The function keyword$md$, $md$```php
<?php
function greet($name) {
    echo "Hello, " . $name . "!";
}

greet("Ada");
greet("Priya");
?>
```

function starts a definition, just like JavaScript's function keyword. Parameters in PHP also use $, since everything variable-like does.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'functions' and l.slug = 'defining-a-function';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$Which keyword defines a function in PHP?$md$, '["def","func","function","method"]'::jsonb, 2, $md$PHP uses the function keyword, the same word JavaScript uses.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'functions' and l.slug = 'defining-a-function' and s.title = $md$The function keyword$md$;


update public.lessons l set status = 'published', is_free_preview = false
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'php' and m.slug = 'functions' and l.slug = 'parameters-and-return-values';


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'php' and m.slug = 'functions' and l.slug = 'parameters-and-return-values';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Sending a value back$md$, $md$```php
<?php
function add($a, $b) {
    return $a + $b;
}

$total = add(4, 7);
echo $total;
?>
```

return works exactly the way it does in JavaScript: it sends a value back out and immediately ends the function.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'functions' and l.slug = 'parameters-and-return-values';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$What does return do in a PHP function?$md$, '["Prints a value to the screen","Sends a value back out of the function and ends it","Starts a loop","Deletes a variable"]'::jsonb, 1, $md$return sends a value back to wherever the function was called, and immediately stops the function from running any further.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'functions' and l.slug = 'parameters-and-return-values' and s.title = $md$Sending a value back$md$;


update public.lessons l set status = 'published', is_free_preview = false
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'php' and m.slug = 'arrays-and-associative-arrays' and l.slug = 'arrays';


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'php' and m.slug = 'arrays-and-associative-arrays' and l.slug = 'arrays';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Ordered lists$md$, $md$```php
<?php
$foods = ["pizza", "jollof rice", "tacos"];
echo $foods[0];
echo count($foods);
?>
```

A PHP array is an ordered list, just like a JavaScript array. count() gives you the number of items, PHP's equivalent of .length.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'arrays-and-associative-arrays' and l.slug = 'arrays';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$What does count($foods) return for a 3-item array?$md$, '["0","2","3","An error"]'::jsonb, 2, $md$count() returns the number of items in an array, so a 3-item array returns 3.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'arrays-and-associative-arrays' and l.slug = 'arrays' and s.title = $md$Ordered lists$md$;


update public.lessons l set status = 'published', is_free_preview = false
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'php' and m.slug = 'arrays-and-associative-arrays' and l.slug = 'associative-arrays';


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'php' and m.slug = 'arrays-and-associative-arrays' and l.slug = 'associative-arrays';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Named keys instead of positions$md$, $md$```php
<?php
$student = [
    "name" => "Ada",
    "age" => 22,
    "track" => "PHP"
];

echo $student["name"];
?>
```

An associative array uses named keys instead of numbered positions, PHP's equivalent of a JavaScript object or a Python dictionary. => connects each key to its value.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'arrays-and-associative-arrays' and l.slug = 'associative-arrays';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$What does => do when building an associative array in PHP?$md$, '["Compares two values","Connects a key to its value","Starts a loop","Ends the array"]'::jsonb, 1, $md$The => arrow connects a key on the left to its value on the right when building an associative array.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'arrays-and-associative-arrays' and l.slug = 'associative-arrays' and s.title = $md$Named keys instead of positions$md$;


update public.lessons l set status = 'published', is_free_preview = false
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'php' and m.slug = 'forms-and-simple-server-logic' and l.slug = 'handling-a-form-submission';


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'php' and m.slug = 'forms-and-simple-server-logic' and l.slug = 'handling-a-form-submission';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Reading submitted data$md$, $md$```html
<form method="post" action="submit.php">
  <input name="email" type="email" />
  <button type="submit">Send</button>
</form>
```

```php
<?php
// submit.php
$email = $_POST["email"];
echo "Thanks, " . $email;
?>
```

When the form is submitted, the browser sends its data to submit.php. PHP makes that data available in the $_POST superglobal array, keyed by each input name attribute.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'forms-and-simple-server-logic' and l.slug = 'handling-a-form-submission';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$In the example above, how does submit.php access the submitted email?$md$, '["$_GET[\"email\"]","$_POST[\"email\"]","$email (automatically)","It cannot access form data"]'::jsonb, 1, $md$Form data sent with method="post" arrives in PHP in the $_POST superglobal, keyed by each input name attribute.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'forms-and-simple-server-logic' and l.slug = 'handling-a-form-submission' and s.title = $md$Reading submitted data$md$;


update public.lessons l set status = 'published', is_free_preview = false
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'php' and m.slug = 'forms-and-simple-server-logic' and l.slug = 'capstone-project';


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'php' and m.slug = 'forms-and-simple-server-logic' and l.slug = 'capstone-project';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Building the contact form handler$md$, $md$You now have everything you need to build a real form handler: variables, control flow, functions, arrays, and reading submitted form data.

The capstone: a contact form handler that reads a name, email, and message from $_POST, checks that none of them are empty, and either shows an error or echoes the submitted values back. This is the same basic pattern behind almost every contact form and signup page on the web.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'php' and m.slug = 'forms-and-simple-server-logic' and l.slug = 'capstone-project';
