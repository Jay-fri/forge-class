-- Python track built out in full. Sandpack has no Python runtime, so
-- these are read-only code walkthroughs, same treatment as Backend.


update public.lessons l set status = 'published', is_free_preview = true
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'python' and m.slug = 'getting-started' and l.slug = 'what-python-is';


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'python' and m.slug = 'getting-started' and l.slug = 'what-python-is';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$A readable, popular first language$md$, $md$Python is one of the most popular programming languages in the world, known for reading almost like plain English. It is used for web backends, data analysis, automation scripts, and more.

```python
print("Hello, Forge")
```

No semicolons, no curly braces, just indentation to show what belongs together. That is the whole syntax philosophy: less punctuation, more readability.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'getting-started' and l.slug = 'what-python-is';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$What is Python particularly known for?$md$, '["Being the fastest language ever created","Reading almost like plain English","Only working in the browser","Requiring semicolons on every line"]'::jsonb, 1, $md$Python's design goal is readability, using indentation and plain keywords instead of heavy punctuation.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'getting-started' and l.slug = 'what-python-is' and s.title = $md$A readable, popular first language$md$;


update public.lessons l set status = 'published', is_free_preview = false
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'python' and m.slug = 'getting-started' and l.slug = 'running-python-code';


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'python' and m.slug = 'getting-started' and l.slug = 'running-python-code';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$No install required to start$md$, $md$Just like the JavaScript console, you can run Python instantly in an online REPL, a page where you type code and see it run immediately, no local install required to get started.

```python
name = "Ada"
print(f"Hello, {name}")
```

This prints Hello, Ada. The f before the string turns it into an f-string, letting you drop variables straight into text with curly braces.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'getting-started' and l.slug = 'running-python-code';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$What does the f before a string do in Python?$md$, '["Formats the string as a file","Turns it into an f-string, letting you embed variables with curly braces","Makes the string uppercase","Nothing, it is optional punctuation"]'::jsonb, 1, $md$An f-string lets you embed variables and expressions directly inside a string using curly braces, without manually joining pieces together.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'getting-started' and l.slug = 'running-python-code' and s.title = $md$No install required to start$md$;


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Try it yourself$md$, $md$If you have Python installed, or are using an online REPL, run the snippet above with your own name.$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'getting-started' and l.slug = 'running-python-code';


update public.lessons l set status = 'published', is_free_preview = false
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'python' and m.slug = 'getting-started' and l.slug = 'variables-and-types';


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'python' and m.slug = 'getting-started' and l.slug = 'variables-and-types';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Storing values$md$, $md$```python
name = "Ada"
age = 22
is_student = True
print(name, age, is_student)
```

Python variables do not need a keyword like let, you just assign directly. Python is dynamically typed: a variable's type is decided by whatever value you give it.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'getting-started' and l.slug = 'variables-and-types';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Three types you will use constantly$md$, $md$| Type | Example | Use |
|---|---|---|
| str | "Ada" | Text |
| int / float | 22 / 3.14 | Whole and decimal numbers |
| bool | True | Yes or no logic |

Notice Python's booleans are capitalized: True and False, not lowercase like JavaScript.$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'getting-started' and l.slug = 'variables-and-types';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$How are Python's boolean values written?$md$, '["true and false","True and False","TRUE and FALSE","1 and 0 only"]'::jsonb, 1, $md$Python capitalizes its boolean literals: True and False.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'getting-started' and l.slug = 'variables-and-types' and s.title = $md$Three types you will use constantly$md$;


update public.lessons l set status = 'published', is_free_preview = false
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'python' and m.slug = 'operators-and-control-flow' and l.slug = 'operators';


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'python' and m.slug = 'operators-and-control-flow' and l.slug = 'operators';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Arithmetic operators$md$, $md$| Operator | Meaning | Example | Result |
|---|---|---|---|
| + | Add | 2 + 3 | 5 |
| - | Subtract | 5 - 2 | 3 |
| * | Multiply | 4 * 3 | 12 |
| / | Divide | 10 / 2 | 5.0 |
| // | Floor divide | 10 // 3 | 3 |

Regular division (/) always returns a float in Python, even when the numbers divide evenly. Floor division (//) rounds down to a whole number.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'operators-and-control-flow' and l.slug = 'operators';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$What does 10 // 3 return in Python?$md$, '["3.33","3","4","10"]'::jsonb, 1, $md$// is floor division: it divides and rounds down to the nearest whole number, so 10 // 3 is 3.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'operators-and-control-flow' and l.slug = 'operators' and s.title = $md$Arithmetic operators$md$;


update public.lessons l set status = 'published', is_free_preview = false
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'python' and m.slug = 'operators-and-control-flow' and l.slug = 'if-elif-and-else';


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'python' and m.slug = 'operators-and-control-flow' and l.slug = 'if-elif-and-else';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Branching logic$md$, $md$```python
age = 20

if age >= 18:
    print("You can vote")
elif age >= 16:
    print("Almost there")
else:
    print("Not yet")
```

Python uses indentation, not curly braces, to show what belongs to each block. elif is Python's word for "else if", checked only when the first condition is false.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'operators-and-control-flow' and l.slug = 'if-elif-and-else';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$What does elif mean in Python?$md$, '["It is a typo for if","Else if, checked when the previous condition was false","It always runs regardless of conditions","It ends the if statement"]'::jsonb, 1, $md$elif is short for else if, letting you check another condition only if the earlier ones were false.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'operators-and-control-flow' and l.slug = 'if-elif-and-else' and s.title = $md$Branching logic$md$;


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Common mistake$md$, $md$**Common mistake:** forgetting the colon at the end of an if line, or mixing tabs and spaces for indentation.

```python
if age >= 18
    print("You can vote")
```

This raises SyntaxError: expected ':'. Every if, elif, else, for, and while line needs a colon at the end, and Python is strict about consistent indentation underneath it.$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'operators-and-control-flow' and l.slug = 'if-elif-and-else';


update public.lessons l set status = 'published', is_free_preview = false
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'python' and m.slug = 'operators-and-control-flow' and l.slug = 'for-and-while-loops';


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'python' and m.slug = 'operators-and-control-flow' and l.slug = 'for-and-while-loops';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$for loops$md$, $md$```python
for i in range(1, 11):
    print(i)
```

range(1, 11) produces the numbers 1 through 10, the end number is never included. A for loop in Python steps through a sequence directly, rather than manually managing a counter.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'operators-and-control-flow' and l.slug = 'for-and-while-loops';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$while loops$md$, $md$```python
count = 0
while count < 5:
    print(count)
    count += 1
```

A while loop keeps running as long as its condition is true. Just like in JavaScript, forgetting to update the condition, here count += 1, causes an infinite loop.$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'operators-and-control-flow' and l.slug = 'for-and-while-loops';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$What does range(1, 11) produce?$md$, '["The numbers 1 through 11, inclusive","The numbers 1 through 10","The number 11 only","An error"]'::jsonb, 1, $md$range's end value is exclusive, so range(1, 11) produces 1 through 10.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'operators-and-control-flow' and l.slug = 'for-and-while-loops' and s.title = $md$while loops$md$;


update public.lessons l set status = 'published', is_free_preview = false
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'python' and m.slug = 'functions' and l.slug = 'defining-a-function';


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'python' and m.slug = 'functions' and l.slug = 'defining-a-function';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$The def keyword$md$, $md$```python
def greet(name):
    print(f"Hello, {name}!")

greet("Ada")
greet("Priya")
```

def starts a function definition. Just like the if statement, the function's body is whatever is indented underneath it.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'functions' and l.slug = 'defining-a-function';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$Which keyword starts a function definition in Python?$md$, '["function","def","func","define"]'::jsonb, 1, $md$Python uses def to define a function, followed by its name and parameters.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'functions' and l.slug = 'defining-a-function' and s.title = $md$The def keyword$md$;


update public.lessons l set status = 'published', is_free_preview = false
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'python' and m.slug = 'functions' and l.slug = 'parameters-and-return-values';


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'python' and m.slug = 'functions' and l.slug = 'parameters-and-return-values';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Sending a value back$md$, $md$```python
def add(a, b):
    return a + b

total = add(4, 7)
print(total)
```

return sends a value back out of the function, exactly like in JavaScript. Without it, calling add(4, 7) would run but give you back None, Python's version of nothing.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'functions' and l.slug = 'parameters-and-return-values';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$What does a Python function return if it has no return statement?$md$, '["0","An empty string","None","It causes an error"]'::jsonb, 2, $md$A function without an explicit return statement returns None, Python representation of no value.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'functions' and l.slug = 'parameters-and-return-values' and s.title = $md$Sending a value back$md$;


update public.lessons l set status = 'published', is_free_preview = false
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'python' and m.slug = 'functions' and l.slug = 'default-arguments';


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'python' and m.slug = 'functions' and l.slug = 'default-arguments';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Making a parameter optional$md$, $md$```python
def greet(name, greeting="Hello"):
    print(f"{greeting}, {name}!")

greet("Ada")
greet("Priya", "Hi")
```

Giving a parameter a default value makes it optional. Call greet("Ada") and it uses "Hello", or override it by passing a second argument.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'functions' and l.slug = 'default-arguments';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$In the example above, what does greet("Ada") print?$md$, '["Hello, Ada!","Ada, Hello!","An error, because greeting was not provided","Hi, Ada!"]'::jsonb, 0, $md$Since greeting was not provided, Python falls back to its default value, Hello.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'functions' and l.slug = 'default-arguments' and s.title = $md$Making a parameter optional$md$;


update public.lessons l set status = 'published', is_free_preview = false
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'python' and m.slug = 'lists-and-dictionaries' and l.slug = 'lists';


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'python' and m.slug = 'lists-and-dictionaries' and l.slug = 'lists';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Python's ordered collection$md$, $md$```python
foods = ["pizza", "jollof rice", "tacos"]
print(foods[0])
print(len(foods))
```

A list is Python's ordered collection, the equivalent of a JavaScript array. Items are numbered from 0, just like arrays.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'lists-and-dictionaries' and l.slug = 'lists';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$What does len(foods) return for a 3-item list?$md$, '["0","2","3","An error"]'::jsonb, 2, $md$len() returns the number of items in a list, so a 3-item list returns 3.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'lists-and-dictionaries' and l.slug = 'lists' and s.title = $md$Python's ordered collection$md$;


update public.lessons l set status = 'published', is_free_preview = false
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'python' and m.slug = 'lists-and-dictionaries' and l.slug = 'dictionaries';


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'python' and m.slug = 'lists-and-dictionaries' and l.slug = 'dictionaries';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Key-value pairs$md$, $md$```python
student = {
    "name": "Ada",
    "age": 22,
    "track": "Python"
}

print(student["name"])
```

A dictionary stores key-value pairs, Python's equivalent of a JavaScript object. Use square brackets with the key name to read a value, not a dot.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'lists-and-dictionaries' and l.slug = 'dictionaries';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$How do you read a value out of a dictionary called student with a key called age?$md$, '["student.age","student[age]","student[\"age\"]","get(student, age)"]'::jsonb, 2, $md$Dictionary access in Python uses square brackets with the key as a string, like student["age"].$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'lists-and-dictionaries' and l.slug = 'dictionaries' and s.title = $md$Key-value pairs$md$;


update public.lessons l set status = 'published', is_free_preview = false
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'python' and m.slug = 'lists-and-dictionaries' and l.slug = 'common-list-and-dictionary-methods';


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'python' and m.slug = 'lists-and-dictionaries' and l.slug = 'common-list-and-dictionary-methods';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Methods you will use constantly$md$, $md$| Method | What it does |
|---|---|
| list.append(x) | Adds x to the end of a list |
| [x for x in list if ...] | A list comprehension, builds a new filtered list |
| dict.get(key) | Reads a value, returning None instead of an error if missing |
| dict.keys() | Returns all the keys in a dictionary |

```python
foods = ["pizza", "tacos"]
foods.append("suya")

long_names = [food for food in foods if len(food) > 5]
print(long_names)
```$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'lists-and-dictionaries' and l.slug = 'common-list-and-dictionary-methods';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$What does a list comprehension like [food for food in foods if len(food) > 5] produce?$md$, '["A single value","A new list containing only the items that pass the condition","The original list, unchanged","An error"]'::jsonb, 1, $md$A list comprehension builds a brand new list containing only the items that satisfy the condition, similar to JavaScript's filter.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'lists-and-dictionaries' and l.slug = 'common-list-and-dictionary-methods' and s.title = $md$Methods you will use constantly$md$;


update public.lessons l set status = 'published', is_free_preview = false
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'python' and m.slug = 'files-and-simple-projects' and l.slug = 'reading-and-writing-a-text-file';


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'python' and m.slug = 'files-and-simple-projects' and l.slug = 'reading-and-writing-a-text-file';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Persisting data between runs$md$, $md$```python
with open("notes.txt", "w") as f:
    f.write("Learn Python\n")

with open("notes.txt", "r") as f:
    print(f.read())
```

open(..., "w") opens a file for writing, creating it if needed. "r" opens it for reading. The with block automatically closes the file when it is done, even if something goes wrong partway through.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'files-and-simple-projects' and l.slug = 'reading-and-writing-a-text-file';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$What does the with block do when working with files?$md$, '["Nothing, it is optional decoration","Automatically closes the file when the block finishes, even on an error","Encrypts the file","Opens the file in a browser"]'::jsonb, 1, $md$A with block guarantees the file gets closed properly once the block finishes, which matters especially if an error happens partway through.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'files-and-simple-projects' and l.slug = 'reading-and-writing-a-text-file' and s.title = $md$Persisting data between runs$md$;


update public.lessons l set status = 'published', is_free_preview = false
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'python' and m.slug = 'files-and-simple-projects' and l.slug = 'capstone-project';


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'python' and m.slug = 'files-and-simple-projects' and l.slug = 'capstone-project';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Choosing your capstone$md$, $md$You now have everything you need for a complete small program: variables, control flow, functions, lists and dictionaries, and reading and writing files.

Two good options for the capstone:

- A command-line todo list that saves its todos to a text file, so they are still there next time you run it
- A number-guessing game where the computer picks a random number and you guess until you get it right

Either one uses every skill from this track in one real, complete program.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'files-and-simple-projects' and l.slug = 'capstone-project';
