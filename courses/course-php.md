# Forge Course: PHP

## Module 1 — Getting Started

### Lesson 1.1 — What is PHP?
**Concept:** PHP is a language that runs on the **server**, not in the browser like JavaScript. It builds the HTML page *before* it's sent to the visitor — that's why PHP is common for things like processing forms and connecting to databases.

**Check-in:** Where does PHP code run?
- A) In the visitor's browser
- B) On the server, before the page is sent ✓
- C) Nowhere, it's just for styling
- D) Only inside a database

**Common mistake:** Expecting PHP to run instantly like JavaScript in a browser console — PHP needs a server environment to run.

### Lesson 1.2 — Running your first PHP, embedding in HTML
**Concept:** PHP code is wrapped in `<?php ?>` tags and can be mixed directly inside an HTML file.

**Code example:**
```php
<!DOCTYPE html>
<html>
<body>
  <?php echo "Hello, Forge"; ?>
</body>
</html>
```

**Try it:** Change the text inside `echo` to your own message.

**Check-in:** What does `echo` do in PHP?
- A) Deletes a variable
- B) Outputs text to the page ✓
- C) Repeats a sound
- D) Starts a loop

**Common mistake:** Forgetting the semicolon `;` at the end of a PHP line — PHP requires it after every statement.

### Lesson 1.3 — Variables and basic types
**Concept:** PHP variables always start with a `$` sign.

**Code example:**
```php
<?php
$name = "Ada";
$age = 22;
$isStudent = true;
echo $name . " " . $age;
?>
```

**Try it:** Create your own variables for your name, age, and favorite subject.

**Check-in:** What symbol must every PHP variable start with?
- A) `#`
- B) `$` ✓
- C) `&`
- D) `@`

**Common mistake:** Forgetting the `$` when using a variable later in the code — `echo name;` (without `$`) causes an error since PHP thinks you mean something else entirely.

**Assignment 1 — Profile echo:** Create variables for your name, age, and a one-line bio, then echo a formatted introduction using them. Pass criteria: uses at least 3 variables, output is readable, no errors.

---

## Module 2 — Operators & Control Flow

### Lesson 2.1 — Operators
**Concept:** Arithmetic (`+ - * /`) and comparison (`== > <`) work similarly to other languages. PHP also uses `.` (a dot) to join strings together, called concatenation.

**Code example:**
```php
<?php
echo "Hello " . "World";
echo 5 + 3;
?>
```

**Try it:** Concatenate your own first and last name into one string.

**Check-in:** What does `.` do between two strings in PHP?
- A) Multiplies them
- B) Joins them together ✓
- C) Compares them
- D) Nothing, it's a typo

**Common mistake:** Using `+` to join strings like in some other languages — in PHP, `+` is for math; `.` is for joining text.

### Lesson 2.2 — Conditionals
**Concept:** PHP uses `if / elseif / else` (note: "elseif" as one word, unlike Python's "elif").

**Code example:**
```php
<?php
$age = 20;
if ($age >= 18) {
    echo "You can vote";
} else {
    echo "Not yet";
}
?>
```

**Try it:** Add an `elseif` branch for exactly age 18.

**Check-in:** What keyword does PHP use for an additional condition?
- A) `elif`
- B) `elseif` ✓
- C) `else if only`
- D) `orif`

**Common mistake:** Forgetting the `$` on the variable inside the condition (`if (age >= 18)`) — this causes an "undefined constant" error since PHP thinks `age` is something else without the `$`.

### Lesson 2.3 — Loops
**Concept:** `for` and `while` loops work much like JavaScript's.

**Code example:**
```php
<?php
for ($i = 1; $i <= 5; $i++) {
    echo $i . " ";
}
?>
```

**Try it:** Change the loop to count 1 to 10.

**Check-in:** What does `$i++` do?
- A) Resets `$i` to 0
- B) Increases `$i` by 1 each time ✓
- C) Stops the loop
- D) Prints `$i`

**Common mistake:** Forgetting `$` on the loop variable anywhere in the loop — every use of a PHP variable needs the `$`, every time.

**Assignment 2 — FizzBuzz:** Print numbers 1–20; for multiples of 3 print "Fizz", multiples of 5 print "Buzz", multiples of both print "FizzBuzz". Pass criteria: correct output for all 20 numbers, uses a loop and conditionals.

---

## Module 3 — Functions

### Lesson 3.1 — Defining functions
**Concept:** Functions are defined with the `function` keyword.

**Code example:**
```php
<?php
function greet($name) {
    echo "Hello, " . $name;
}
greet("Ada");
?>
```

**Try it:** Call `greet()` with your own name.

**Check-in:** What keyword starts a function definition in PHP?
- A) `def`
- B) `function` ✓
- C) `func`
- D) `define`

**Common mistake:** Forgetting the `$` on parameter names, both when defining and using them inside the function.

### Lesson 3.2 — Parameters and return values
**Concept:** Functions can take parameters and give back a value with `return`, just like other languages.

**Code example:**
```php
<?php
function add($a, $b) {
    return $a + $b;
}
$total = add(4, 7);
echo $total;
?>
```

**Try it:** Write a function that returns the larger of two numbers.

**Check-in:** What does `return` do inside a function?
- A) Prints the value immediately
- B) Sends a value back to wherever the function was called ✓
- C) Ends the whole program
- D) Deletes the function

**Common mistake:** Using `echo` inside a function instead of `return` when you actually need the value for further use elsewhere — `echo` just displays it, it doesn't hand it back to your code.

**Assignment 3 — Simple calculator:** Write functions `add`, `subtract`, `multiply`, `divide`, each taking two numbers and returning the result. Pass criteria: all four return correct results, `divide` handles division by zero without crashing.

---

## Module 4 — Arrays & Associative Arrays

### Lesson 4.1 — Arrays
**Concept:** A PHP array is an ordered list, similar to JavaScript's.

**Code example:**
```php
<?php
$foods = ["rice", "beans", "yam"];
$foods[] = "plantain";
print_r($foods);
?>
```

**Try it:** Add two more items to the array.

**Check-in:** What does `$foods[] = "plantain"` do?
- A) Removes an item
- B) Adds "plantain" to the end of the array ✓
- C) Replaces the whole array
- D) Causes an error

**Common mistake:** Forgetting `print_r()` is needed to actually see the *contents* of an array — `echo $foods` alone doesn't display it properly.

### Lesson 4.2 — Associative arrays
**Concept:** An associative array is PHP's key-value structure — the equivalent of a JavaScript object or Python dictionary.

**Code example:**
```php
<?php
$student = [
    "name" => "Ada",
    "age" => 22
];
echo $student["name"];
?>
```

**Try it:** Add a `"track"` key and echo it.

**Check-in:** What symbol connects a key to its value in a PHP associative array?
- A) `:`
- B) `=>` ✓
- C) `=`
- D) `->`

**Common mistake:** Using `:` (like JavaScript objects use) instead of `=>` — PHP associative arrays specifically require the arrow syntax.

**Assignment 4 — Contact list:** Build an array of associative arrays representing contacts (`["name" => ..., "phone" => ...]`), write functions to add, find by name, and remove a contact. Pass criteria: all three functions work correctly.

---

## Module 5 — Forms & Capstone

### Lesson 5.1 — Handling a form submission
**Concept:** When an HTML form submits, PHP can read the submitted values using the `$_POST` superglobal array.

**Code example:**
```html
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
```

**Try it:** Add an email field to the form and read it in PHP too.

**Check-in:** What does `$_POST` contain?
- A) All the PHP functions available
- B) The data submitted by a form using the POST method ✓
- C) A list of all users
- D) Nothing unless you configure a database

**Common mistake:** Mismatching the form input's `name` attribute with the key used in `$_POST` — they must match exactly, or the value won't be found.

**Capstone Assignment — Contact form handler:** Build an HTML contact form (name, email, message) and a PHP script that reads the submitted values, checks that none are empty (basic validation), and echoes a confirmation message showing what was submitted. Pass criteria: form submits correctly, PHP correctly reads all fields, empty-field validation works, confirmation message displays the submitted data. This is the assignment that unlocks this track's certificate.

---

## Module 6 — Rounding Out PHP

### Lesson 6.1 — String functions
**Concept:** PHP has many built-in string functions: `strtoupper()`, `strtolower()`, `trim()` (remove whitespace), `str_replace()`.

**Code example:**
```php
<?php
$name = "  Ada  ";
$clean = trim($name);
echo strtoupper($clean);
?>
```

**Try it:** Use `str_replace()` to replace a word in a sentence.

**Check-in:** What does `trim()` do?
- A) Deletes the whole string
- B) Removes whitespace from the beginning and end ✓
- C) Converts to uppercase
- D) Splits a string

**Common mistake:** Forgetting PHP string functions generally return a *new* string rather than changing the original — you need to save the result to a variable.

### Lesson 6.2 — Error handling with try/catch
**Concept:** Like other languages, PHP supports try/catch for handling errors gracefully.

**Code example:**
```php
<?php
try {
    $result = 10 / 0;
} catch (DivisionByZeroError $e) {
    echo "Can't divide by zero: " . $e->getMessage();
}
?>
```

**Try it:** Wrap risky code (like reading a file that might not exist) in a try/catch.

**Check-in:** What does `$e->getMessage()` give you?
- A) The line number only
- B) A description of what went wrong ✓
- C) Nothing useful
- D) The entire program's code

**Common mistake:** Catching an error but not doing anything useful with it — at minimum, log or display something so the failure isn't silent.

### Lesson 6.3 — Sessions and cookies
**Concept:** HTTP is stateless — the server doesn't automatically remember who you are between requests. Sessions let a server remember a logged-in user across multiple page visits.

**Code example:**
```php
<?php
session_start();
$_SESSION["username"] = "Ada";
echo $_SESSION["username"];
?>
```

**Try it:** Start a session, store a value, and read it back on a "reload."

**Check-in:** What must you call before using `$_SESSION`?
- A) Nothing
- B) `session_start()` ✓
- C) `session_create()`
- D) `import session`

**Common mistake:** Forgetting `session_start()` must be called before any HTML output — it needs to run first on every page that uses sessions.

### Lesson 6.4 — Including other PHP files
**Concept:** `include` or `require` lets you reuse code across multiple files — like a shared header or a set of functions.

**Code example:**
```php
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
```

**Try it:** Move one of your earlier functions into its own file and `require` it.

**Check-in:** What's the difference between `include` and `require`?
- A) No difference
- B) `require` stops the script with an error if the file is missing; `include` just warns and continues ✓
- C) `include` is faster
- D) `require` is deprecated

**Common mistake:** Using `include` for something essential (like a database connection file) — if it's missing, the script keeps running broken instead of stopping clearly; `require` is safer for critical files.

### Lesson 6.5 — Basic database connection (PDO)
**Concept:** PDO is PHP's standard way to connect to a database like MySQL and run queries safely.

**Code example:**
```php
<?php
$pdo = new PDO("mysql:host=localhost;dbname=forge", "username", "password");
$stmt = $pdo->prepare("SELECT * FROM students WHERE track = ?");
$stmt->execute(["PHP"]);
$results = $stmt->fetchAll();
print_r($results);
?>
```

**Try it:** Research and write (without necessarily running) a prepared statement to insert a new row.

**Check-in:** Why use a "prepared statement" (with `?` placeholders) instead of directly inserting variables into the SQL string?
- A) It's just a style preference
- B) It protects against SQL injection attacks ✓
- C) It's faster
- D) It's required by PHP syntax

**Common mistake:** Building SQL queries by directly concatenating user input into the string (`"SELECT * WHERE name = '" . $name . "'"`) — this is a serious security vulnerability; always use prepared statements with placeholders.

### Lesson 6.6 — Basic OOP in PHP
**Concept:** PHP supports classes and objects, similar to other languages.

**Code example:**
```php
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
```

**Try it:** Add a second method to the class.

**Check-in:** What does `__construct` do?
- A) Runs on every method call
- B) Runs once, when a new object is created with `new` ✓
- C) Deletes the object
- D) It's optional and rarely used

**Common mistake:** Forgetting `$this->` when accessing a class property from inside a method — without it, PHP looks for a regular variable instead of the object's property.

**Assignment 6:** Refactor your Module 5 capstone contact form handler to use a `ContactSubmission` class instead of loose variables, wrap the form processing in try/catch, and move the validation logic into its own included file. Pass criteria: class works correctly, errors are handled, code is split across files sensibly.

---

## Module 7 — Sharing Your Project on GitHub

### Lesson 7.1 — Pushing your project to GitHub
**Concept:** GitHub stores your code online with version history — useful for showing your work publicly.

**Try it — numbered steps:**
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
```

**Check-in:** What's the benefit of pushing your PHP project to GitHub, even without live hosting set up?
- A) None
- B) It shows your work publicly and preserves its history ✓
- C) It automatically hosts your PHP site
- D) It replaces the need for a server entirely

**Common mistake:** Committing sensitive info like real database passwords directly into the code that gets pushed — always keep credentials out of version control (use environment variables or a gitignored config file instead).

**Assignment 7:** Push your finished capstone project to GitHub with a clear README explaining what it does and how to set it up. Pass criteria: repository is public, README is clear, no sensitive credentials are committed.
