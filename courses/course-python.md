# Forge Course: Python

## Module 1 — Getting Started

### Lesson 1.1 — What is Python?
**Concept:** Python is a programming language known for being readable and beginner-friendly. It's used for websites, data analysis, automation, and more. Unlike JavaScript, it doesn't run in a browser — it runs directly on a computer.

**Check-in:** Where does Python typically run?
- A) Only inside a web browser
- B) Directly on a computer/server ✓
- C) Only on phones
- D) It doesn't run anywhere, it's just for writing

**Common mistake:** Assuming Python and JavaScript are interchangeable because both are "beginner languages" — they have different syntax and different typical uses.

### Lesson 1.2 — Running your first line of Python
**Concept:** Python code can be run instantly in an online editor or a local install — no complicated setup needed to get started.

**Code example:**
```python
print("Hello, Forge")
```

**Try it:** Change the text and run it again.

**Check-in:** What does `print()` do in Python?
- A) Prints a physical document
- B) Displays a message ✓
- C) Deletes a variable
- D) Saves a file

**Common mistake:** Forgetting Python is case-sensitive — `Print("hi")` (capital P) causes a `NameError` because Python only recognizes lowercase `print`.

### Lesson 1.3 — Variables and basic types
**Concept:** Like JavaScript, Python variables are labeled boxes — but you don't need `let` or `const`, just a name and a value.

**Code example:**
```python
name = "Ada"
age = 22
is_student = True
print(name, age, is_student)
```

**Try it:** Create your own variables for your name, age, and favorite food.

**Check-in:** What's Python's boolean value for "true" written as?
- A) `true`
- B) `True` (capital T) ✓
- C) `TRUE`
- D) `1`

**Common mistake:** Writing `true` lowercase like in JavaScript — Python requires `True`/`False` with a capital letter.

**Assignment 1 — Profile print:** Create variables for your name, age, and a one-line bio, then print a formatted introduction using them. Pass criteria: uses at least 3 variables of different types, output is readable, no errors.

---

## Module 2 — Operators & Control Flow

### Lesson 2.1 — Operators
**Concept:** Arithmetic (`+ - * /`) and comparison (`== > <`) operators work much like JavaScript's, with one difference: Python uses `==` for comparison, not `===`.

**Code example:**
```python
print(5 + 3)
print(10 > 7)
print("cat" == "cat")
```

**Try it:** Try `//` (integer division) and `%` (remainder) with two numbers.

**Check-in:** What does Python use to compare equality?
- A) `=`
- B) `==` ✓
- C) `===`
- D) `equals()`

**Common mistake:** Using `=` (assignment) when checking equality — `if age = 18` is actually a syntax error in Python (unlike JavaScript, which lets it slip through silently), so Python will at least stop you here.

### Lesson 2.2 — Conditionals
**Concept:** Python uses `if / elif / else` — note "elif," not "else if."

**Code example:**
```python
age = 20
if age >= 18:
    print("You can vote")
else:
    print("Not yet")
```

**Try it:** Add an `elif` branch for exactly age 18.

**Check-in:** What keyword does Python use instead of "else if"?
- A) `elseif`
- B) `elif` ✓
- C) `else_if`
- D) `orif`

**Common mistake:** Forgetting the colon `:` at the end of the `if` line, or mixing tabs and spaces for indentation — Python uses indentation (not curly braces) to know what's inside the if block, so it's strict about this.

### Lesson 2.3 — Loops
**Concept:** `for` loops iterate over a range or list; `while` loops run until a condition is false.

**Code example:**
```python
for i in range(1, 6):
    print(i)
```

**Try it:** Change `range(1, 6)` to count 1 to 10.

**Check-in:** What does `range(1, 6)` produce?
- A) The numbers 1 through 6 (inclusive)
- B) The numbers 1 through 5 ✓
- C) The number 6 only
- D) An error

**Common mistake:** Expecting `range(1, 6)` to include 6 — Python's range stops *before* the second number.

**Assignment 2 — FizzBuzz:** Print numbers 1–20; for multiples of 3 print "Fizz", multiples of 5 print "Buzz", multiples of both print "FizzBuzz". Pass criteria: correct output for all 20 numbers, uses a loop and conditionals.

---

## Module 3 — Functions

### Lesson 3.1 — Defining functions
**Concept:** Functions are defined with `def`, and use indentation (not curly braces) to show what's inside them.

**Code example:**
```python
def greet(name):
    print("Hello, " + name)

greet("Ada")
```

**Try it:** Call `greet()` with your own name.

**Check-in:** What keyword starts a function definition in Python?
- A) `function`
- B) `def` ✓
- C) `func`
- D) `define`

**Common mistake:** Forgetting the colon `:` after the function signature, or misaligning the indentation of the function body.

### Lesson 3.2 — Parameters, return values, default arguments
**Concept:** Like JS, functions can take parameters and give back a value with `return`. Python also lets you set default values for parameters.

**Code example:**
```python
def add(a, b=10):
    return a + b

print(add(5))
print(add(5, 20))
```

**Try it:** Give your own function a default parameter value.

**Check-in:** In `def add(a, b=10):`, what happens if you call `add(5)` with only one argument?
- A) It errors
- B) `b` uses its default value of 10 ✓
- C) `b` becomes 0
- D) `a` is ignored

**Common mistake:** Putting a parameter without a default *after* one with a default (`def add(a=10, b):`) — Python doesn't allow this and will throw a syntax error.

**Assignment 3 — Simple calculator:** Write functions `add`, `subtract`, `multiply`, `divide`, each taking two numbers and returning the result. Pass criteria: all four return correct results, `divide` handles division by zero without crashing (hint: check for zero before dividing).

---

## Module 4 — Lists & Dictionaries

### Lesson 4.1 — Lists and common methods
**Concept:** A Python list is like a JavaScript array — an ordered collection. Common methods: `.append()` (add to the end), list comprehensions (a compact way to transform/filter).

**Code example:**
```python
foods = ["rice", "beans", "yam"]
foods.append("plantain")
print(foods)
```

**Try it:** Use a list comprehension to get only foods longer than 4 letters: `[f for f in foods if len(f) > 4]`.

**Check-in:** What does `.append()` do?
- A) Removes the last item
- B) Adds an item to the end of a list ✓
- C) Sorts the list
- D) Empties the list

**Common mistake:** Confusing `.append()` (Python) with `.push()` (JavaScript) if switching between languages — same idea, different method name.

### Lesson 4.2 — Dictionaries
**Concept:** A dictionary is Python's key-value structure — the equivalent of a JavaScript object.

**Code example:**
```python
student = {
    "name": "Ada",
    "age": 22,
    "track": "Python"
}
print(student["name"])
```

**Try it:** Add a `"streak"` key and print it.

**Check-in:** How do you access a value in a Python dictionary?
- A) `dict.key`
- B) `dict["key"]` ✓
- C) `dict->key`
- D) `dict(key)`

**Common mistake:** Using a key that doesn't exist — `student["email"]` throws a `KeyError` if "email" was never added.

**Assignment 4 — Contact book:** Build a list of dictionaries representing contacts (`{name, phone}`), write functions to add a contact, find one by name, and remove one. Pass criteria: all three functions work correctly on a sample list.

---

## Module 5 — Files & Capstone Project

### Lesson 5.1 — Reading and writing a text file
**Concept:** Python can read from and write to files on your computer, letting programs remember data even after they stop running.

**Code example:**
```python
with open("notes.txt", "w") as file:
    file.write("Hello from Python")

with open("notes.txt", "r") as file:
    print(file.read())
```

**Try it:** Write your name to a file, then read it back and print it.

**Check-in:** What does the `"w"` mode do when opening a file?
- A) Reads the file
- B) Writes to the file (overwriting existing content) ✓
- C) Deletes the file
- D) Renames the file

**Common mistake:** Opening a file in `"w"` mode when you meant to read it — this erases the file's existing content immediately.

**Capstone Assignment — Command-line to-do list:** Build a working command-line to-do list program using everything from this course: a list of dictionaries for todos, functions to add/complete/remove them, a loop that keeps asking the user what to do next, and saving the list to a file so it persists. Pass criteria: the program runs without crashing, all actions (add/complete/remove/view) work correctly, and data saves to a file. This is the assignment that unlocks this track's certificate.

---

## Module 6 — Rounding Out Python

### Lesson 6.1 — Tuples and sets
**Concept:** A tuple is like a list but unchangeable once created — good for fixed groups of values. A set holds only unique values, automatically removing duplicates.

**Code example:**
```python
coordinates = (10, 20)
unique_tracks = {"Python", "JavaScript", "Python"}
print(coordinates)
print(unique_tracks)
```

**Try it:** Create a set from a list that has duplicate values and see them disappear.

**Check-in:** What happens to duplicate values in a set?
- A) They're kept
- B) They're automatically removed ✓
- C) They cause an error
- D) They get sorted

**Common mistake:** Trying to change a tuple's value after creating it (`coordinates[0] = 5`) — tuples are immutable, this throws a `TypeError`.

### Lesson 6.2 — String methods and f-strings in depth
**Concept:** Strings have many built-in methods: `.upper()`, `.lower()`, `.strip()` (remove whitespace), `.split()` (break into a list). F-strings (`f"..."`) are the modern way to insert variables into strings.

**Code example:**
```python
name = "  Ada  "
clean_name = name.strip()
print(f"Hello, {clean_name.upper()}!")
```

**Try it:** Use `.split()` to break a sentence into a list of words.

**Check-in:** What does `.strip()` remove?
- A) All letters
- B) Whitespace from the beginning and end ✓
- C) Numbers only
- D) The whole string

**Common mistake:** Forgetting `.strip()` when reading user input — leftover whitespace can make two strings that "look" equal fail an equality check.

### Lesson 6.3 — List comprehensions in depth
**Concept:** Beyond the basic filter shown earlier, comprehensions can also transform every item, not just filter them.

**Code example:**
```python
numbers = [1, 2, 3, 4]
doubled = [n * 2 for n in numbers]
evens_only = [n for n in numbers if n % 2 == 0]
print(doubled, evens_only)
```

**Try it:** Write a comprehension that squares every number in a list.

**Check-in:** What does `[n * 2 for n in numbers]` produce?
- A) The original list unchanged
- B) A new list with every number doubled ✓
- C) A single number
- D) An error

**Common mistake:** Writing an overly complex comprehension that's hard to read — if it's getting long or has nested logic, a regular `for` loop is often clearer.

### Lesson 6.4 — Error handling with try/except
**Concept:** `try/except` catches errors so your program doesn't crash — similar to try/catch in JavaScript.

**Code example:**
```python
try:
    number = int(input("Enter a number: "))
    print(10 / number)
except ValueError:
    print("That's not a valid number")
except ZeroDivisionError:
    print("Can't divide by zero")
```

**Try it:** Add a try/except around code that might fail, and test it with bad input.

**Check-in:** What does `except ValueError:` specifically catch?
- A) Every possible error
- B) Errors related to an invalid value (like text where a number was expected) ✓
- C) Only division errors
- D) Nothing, it's optional syntax

**Common mistake:** Using a bare `except:` that catches every possible error — this can hide real bugs; catching specific error types is safer and clearer.

### Lesson 6.5 — Modules and the standard library
**Concept:** Python comes with many built-in modules you can `import` for extra functionality — no installation needed.

**Code example:**
```python
import random
import datetime

print(random.randint(1, 10))
print(datetime.date.today())
```

**Try it:** Use the `random` module to pick a random item from a list.

**Check-in:** What do you need to do before using a module like `random`?
- A) Nothing
- B) Import it with `import random` ✓
- C) Install it separately (it's built-in, no install needed)
- D) Rewrite it yourself

**Common mistake:** Trying to use a module's function without importing it first — Python doesn't know what `random.randint` means without the `import` line.

### Lesson 6.6 — Basic classes
**Concept:** Like other languages, Python classes are templates for creating objects with shared structure and behavior.

**Code example:**
```python
class Student:
    def __init__(self, name, track):
        self.name = name
        self.track = track

    def introduce(self):
        print(f"Hi, I'm {self.name}, learning {self.track}")

student1 = Student("Ada", "Python")
student1.introduce()
```

**Try it:** Add a second method to the class, like `graduate()`.

**Check-in:** What does `__init__` do in a Python class?
- A) Runs every time a method is called
- B) Runs once, when a new object is created ✓
- C) Deletes the object
- D) It's optional and rarely used

**Common mistake:** Forgetting `self` as the first parameter in every method — Python requires it explicitly (unlike some other languages where "this" is implicit).

### Lesson 6.7 — Working with JSON
**Concept:** Python's `json` module converts between Python dictionaries and JSON text — useful for saving structured data or talking to APIs.

**Code example:**
```python
import json

student = {"name": "Ada", "age": 22}
json_text = json.dumps(student)
print(json_text)

back_to_dict = json.loads(json_text)
print(back_to_dict["name"])
```

**Try it:** Save a dictionary to a JSON string, then load it back and print a value from it.

**Check-in:** What does `json.dumps()` do?
- A) Deletes a dictionary
- B) Converts a Python dictionary into a JSON string ✓
- C) Converts JSON into a dictionary
- D) Sends data to a server

**Common mistake:** Confusing `dumps`/`loads` (string versions) with `dump`/`load` (file versions) — easy to mix up, and using the wrong one against a file vs. a string causes errors.

### Lesson 6.8 — Virtual environments and pip
**Concept:** `pip` installs external packages Python doesn't include by default. A virtual environment keeps each project's packages separate, so projects don't interfere with each other.

**Try it — numbered steps:**
1. Create a virtual environment: `python -m venv env`
2. Activate it: `source env/bin/activate` (Mac/Linux) or `env\Scripts\activate` (Windows)
3. Install a package: `pip install requests`
4. Confirm it installed: `pip list`

**Check-in:** Why use a virtual environment instead of installing packages globally?
- A) It's required by Python, there's no other option
- B) It keeps each project's packages separate and avoids conflicts ✓
- C) It makes code run faster
- D) It's only needed for large projects

**Common mistake:** Forgetting to activate the virtual environment before installing packages — they'll install globally instead of into the project's isolated environment.

**Assignment 6:** Refactor your Module 5 capstone to-do program to use a `Todo` class instead of plain dictionaries, wrap file operations in try/except for error handling, and save/load the todo list using the `json` module instead of plain text. Pass criteria: class works correctly, errors are handled gracefully, data saves/loads correctly as JSON.

---

## Module 7 — Sharing Your Project on GitHub

### Lesson 7.1 — Pushing your project to GitHub
**Concept:** GitHub stores your code online with version history — useful for showing your work and collaborating, even for a command-line Python project that isn't web-hosted.

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

**Check-in:** Why push a command-line Python project to GitHub if it's not a website?
- A) There's no reason to
- B) It shows your work publicly and tracks your code's history ✓
- C) It's required to run the program
- D) It automatically hosts the program online

**Common mistake:** Only pushing once at the very end — committing and pushing regularly as you build gives you a real history to look back on, and protects your work if something goes wrong locally.

**Assignment 7:** Push your finished capstone project to GitHub with a clear README explaining what it does and how to run it. Pass criteria: repository is public, README is clear, code runs as described.
