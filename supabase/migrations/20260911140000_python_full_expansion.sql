-- Python expanded from 14 to 22 lessons across the same 5 modules:
-- comments/style, break/continue, *args/**kwargs, scope, tuples/sets,
-- slicing, working with JSON, and try/except error handling.


update public.lessons l set order_index = 0
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'python' and m.slug = 'getting-started' and l.slug = 'what-python-is';


update public.lessons l set order_index = 1
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'python' and m.slug = 'getting-started' and l.slug = 'running-python-code';


update public.lessons l set order_index = 2
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'python' and m.slug = 'getting-started' and l.slug = 'variables-and-types';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Comments and code style$md$, 'comments-and-code-style', 3, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'getting-started'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'python' and m.slug = 'getting-started' and l.slug = 'comments-and-code-style';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Writing comments$md$, $md$```python
# This is a comment, Python ignores everything after the #
name = "Ada"  # you can also comment at the end of a line
```

Comments explain the why behind code, not the what, the code itself already shows what it does. Python also has a style guide called PEP 8: use snake_case for variable names (my_variable, not myVariable), and keep lines reasonably short.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'getting-started' and l.slug = 'comments-and-code-style';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$What symbol starts a comment in Python?$md$, '["//","#","<!--","/*"]'::jsonb, 1, $md$Python comments start with a # character, everything after it on that line is ignored.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'getting-started' and l.slug = 'comments-and-code-style' and s.title = $md$Writing comments$md$;


update public.lessons l set order_index = 0
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'python' and m.slug = 'operators-and-control-flow' and l.slug = 'operators';


update public.lessons l set order_index = 1
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'python' and m.slug = 'operators-and-control-flow' and l.slug = 'if-elif-and-else';


update public.lessons l set order_index = 2
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'python' and m.slug = 'operators-and-control-flow' and l.slug = 'for-and-while-loops';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$break, continue, and nested loops$md$, 'break-continue-and-nested-loops', 3, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'operators-and-control-flow'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'python' and m.slug = 'operators-and-control-flow' and l.slug = 'break-continue-and-nested-loops';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Controlling a loop from the inside$md$, $md$```python
for i in range(1, 11):
    if i == 5:
        break
    print(i)
```

break stops the loop entirely. continue skips just the current round and moves to the next.

```python
for i in range(1, 11):
    if i % 2 == 0:
        continue
    print(i)
```

This prints only odd numbers, skipping even ones without stopping the loop.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'operators-and-control-flow' and l.slug = 'break-continue-and-nested-loops';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$What is the difference between break and continue?$md$, '["They do the same thing","break stops the loop entirely, continue skips to the next round","continue stops the loop, break skips a round","Neither works inside a for loop"]'::jsonb, 1, $md$break exits the loop completely. continue skips the rest of the current iteration and moves on to the next one.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'operators-and-control-flow' and l.slug = 'break-continue-and-nested-loops' and s.title = $md$Controlling a loop from the inside$md$;


update public.lessons l set order_index = 0
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'python' and m.slug = 'functions' and l.slug = 'defining-a-function';


update public.lessons l set order_index = 1
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'python' and m.slug = 'functions' and l.slug = 'parameters-and-return-values';


update public.lessons l set order_index = 2
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'python' and m.slug = 'functions' and l.slug = 'default-arguments';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$args and kwargs$md$, 'args-and-kwargs', 3, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'functions'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'python' and m.slug = 'functions' and l.slug = 'args-and-kwargs';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Accepting any number of arguments$md$, $md$```python
def add_all(*numbers):
    return sum(numbers)

print(add_all(1, 2, 3, 4))
```

*numbers collects any number of positional arguments into a tuple. **kwargs does the same for keyword arguments, collecting them into a dictionary.

```python
def describe(**details):
    for key, value in details.items():
        print(f"{key}: {value}")

describe(name="Ada", age=22)
```$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'functions' and l.slug = 'args-and-kwargs';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$What does *args collect a function arguments into?$md$, '["A dictionary","A tuple","A single string","Nothing, it causes an error"]'::jsonb, 1, $md$*args collects any number of positional arguments into a tuple that the function can then loop over or process.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'functions' and l.slug = 'args-and-kwargs' and s.title = $md$Accepting any number of arguments$md$;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Scope in Python$md$, 'scope-in-python', 4, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'functions'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'python' and m.slug = 'functions' and l.slug = 'scope-in-python';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Local vs global$md$, $md$```python
count = 0

def increment():
    count = count + 1  # this creates a NEW local count, does not change the outer one
    return count

print(increment())
print(count)  # still 0
```

A variable assigned inside a function is local to that function by default, even if a variable with the same name exists outside. To actually change an outer variable you would need the global keyword, though relying on that is usually a sign to restructure the code instead.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'functions' and l.slug = 'scope-in-python';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$By default, does assigning to a variable inside a function change a variable with the same name outside it?$md$, '["Yes, always","No, it creates a new local variable instead","Only for numbers","Only if you use let"]'::jsonb, 1, $md$Python treats an assignment inside a function as creating a new local variable by default, it does not automatically modify an outer variable of the same name.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'functions' and l.slug = 'scope-in-python' and s.title = $md$Local vs global$md$;


update public.lessons l set order_index = 0
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'python' and m.slug = 'lists-and-dictionaries' and l.slug = 'lists';


update public.lessons l set order_index = 1
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'python' and m.slug = 'lists-and-dictionaries' and l.slug = 'dictionaries';


update public.lessons l set order_index = 2
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'python' and m.slug = 'lists-and-dictionaries' and l.slug = 'common-list-and-dictionary-methods';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Tuples and sets$md$, 'tuples-and-sets', 3, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'lists-and-dictionaries'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'python' and m.slug = 'lists-and-dictionaries' and l.slug = 'tuples-and-sets';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Tuples: lists that cannot change$md$, $md$```python
point = (10, 20)
print(point[0])
```

A tuple looks like a list but cannot be changed after creation (immutable). Use one when a value should not be modified, like fixed coordinates.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'lists-and-dictionaries' and l.slug = 'tuples-and-sets';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Sets: unique, unordered values$md$, $md$```python
unique_numbers = {1, 2, 2, 3}
print(unique_numbers)  # {1, 2, 3}, duplicates removed automatically
```

A set automatically removes duplicates and has no guaranteed order. Useful for checking membership quickly or removing duplicates from a list.$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'lists-and-dictionaries' and l.slug = 'tuples-and-sets';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$What happens to duplicate values when you put them in a set?$md$, '["An error occurs","They are automatically removed, a set only keeps unique values","They are doubled","Sets do not allow numbers"]'::jsonb, 1, $md$A set only ever stores unique values, adding a duplicate has no effect since it is already present.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'lists-and-dictionaries' and l.slug = 'tuples-and-sets' and s.title = $md$Sets: unique, unordered values$md$;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Slicing$md$, 'slicing', 4, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'lists-and-dictionaries'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'python' and m.slug = 'lists-and-dictionaries' and l.slug = 'slicing';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Grabbing part of a list$md$, $md$```python
fruits = ["apple", "banana", "cherry", "date"]
print(fruits[1:3])   # ['banana', 'cherry']
print(fruits[:2])    # ['apple', 'banana']
print(fruits[-1])    # 'date', last item
```

list[start:end] grabs a slice from start up to (not including) end. Leaving start or end empty means from the beginning or to the very end. Negative indexes count from the end.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'lists-and-dictionaries' and l.slug = 'slicing';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$What does fruits[1:3] return for a 4-item list?$md$, '["Every item","Items at index 1 and 2, not including index 3","Only item at index 3","An error"]'::jsonb, 1, $md$Slicing with [1:3] includes the start index and excludes the end index, so it returns items at positions 1 and 2.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'lists-and-dictionaries' and l.slug = 'slicing' and s.title = $md$Grabbing part of a list$md$;


update public.lessons l set order_index = 0
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'python' and m.slug = 'files-and-simple-projects' and l.slug = 'reading-and-writing-a-text-file';


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Working with JSON$md$, 'working-with-json', 1, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'files-and-simple-projects'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'python' and m.slug = 'files-and-simple-projects' and l.slug = 'working-with-json';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Reading and writing structured data$md$, $md$```python
import json

data = {"name": "Ada", "age": 22}

with open("data.json", "w") as f:
    json.dump(data, f)

with open("data.json", "r") as f:
    loaded = json.load(f)
    print(loaded["name"])
```

JSON is a text format for structured data, the same format Forge's own AI features and APIs use. json.dump writes a Python dictionary as JSON text, json.load reads it back into a real dictionary.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'files-and-simple-projects' and l.slug = 'working-with-json';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$What does json.dump do?$md$, '["Deletes a JSON file","Writes a Python object out as JSON text","Reads JSON from a file","Only works with lists"]'::jsonb, 1, $md$json.dump serializes a Python object (like a dict) into JSON text and writes it to a file.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'files-and-simple-projects' and l.slug = 'working-with-json' and s.title = $md$Reading and writing structured data$md$;


insert into public.lessons (module_id, title, slug, order_index, is_free_preview, status)
select m.id, $md$Handling errors with try/except$md$, 'handling-errors-with-try-except', 2, false, 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'files-and-simple-projects'
on conflict (module_id, slug) do update set order_index = excluded.order_index;


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'python' and m.slug = 'files-and-simple-projects' and l.slug = 'handling-errors-with-try-except';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Catching problems instead of crashing$md$, $md$```python
try:
    number = int(input("Enter a number: "))
    print(10 / number)
except ValueError:
    print("That was not a valid number")
except ZeroDivisionError:
    print("Cannot divide by zero")
```

try wraps code that might fail. Each except catches a specific kind of error and handles it gracefully instead of letting the whole program crash. This is essential for anything reading user input, since you can never fully trust what someone types in.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'files-and-simple-projects' and l.slug = 'handling-errors-with-try-except';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$What is the purpose of a try/except block?$md$, '["To make code run faster","To catch and handle errors gracefully instead of crashing the whole program","To skip running a function","To define a new variable type"]'::jsonb, 1, $md$try/except lets you catch specific errors as they happen and respond to them, rather than letting an uncaught error crash the entire program.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'python' and m.slug = 'files-and-simple-projects' and l.slug = 'handling-errors-with-try-except' and s.title = $md$Catching problems instead of crashing$md$;


update public.lessons l set order_index = 3
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'python' and m.slug = 'files-and-simple-projects' and l.slug = 'capstone-project';
