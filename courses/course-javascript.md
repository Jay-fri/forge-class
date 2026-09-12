# Forge Course: JavaScript

## Module 1 — Getting Started

### Lesson 1.1 — What JavaScript actually does
**Concept:** On a webpage, HTML is structure, CSS is style, and JavaScript is **behavior** — it's what makes a button actually do something when clicked, or a page update without reloading.

**Check-in:** Which of these is JavaScript's job?
- A) Defining what a paragraph is
- B) Making text blue
- C) Responding to a button click ✓
- D) Setting page margins

**Common mistake:** Assuming JavaScript controls how things *look* by default — that's CSS's job. JavaScript can change CSS, but its core purpose is behavior and logic.

### Lesson 1.2 — Running your first line of code
**Concept:** Every browser has a built-in console you can use instantly — no setup needed.

**Try it — numbered steps:**
1. Open your browser
2. Right-click anywhere on a page → Inspect
3. Click the "Console" tab
4. Type the code below and press Enter

**Code example:**
```js
console.log("Hello, Forge");
```

**Check-in:** What does `console.log()` do?
- A) Deletes the console
- B) Prints a message you can see ✓
- C) Creates a new webpage
- D) Saves a file

**Common mistake:** Forgetting the closing quote mark — `console.log("Hello)` throws a `SyntaxError: missing ) after argument list`, which just means the browser got confused about where your text ends.

### Lesson 1.3 — Variables and data types
**Concept:** A variable is a labeled box that holds a value you can reuse. Three common types:

| Type | Example | Use |
|---|---|---|
| String | `"Ada"` | Text |
| Number | `22` | Counting, math |
| Boolean | `true` | Yes/no logic |

**Code example:**
```js
let name = "Ada";
let age = 22;
let isStudent = true;
console.log(name, age, isStudent);
```

**Try it:** Create your own variables for your name, age, and favorite language.

**Check-in:** What data type is `true`?
- A) String
- B) Number
- C) Boolean ✓
- D) Variable

**Common mistake:** Wrapping numbers in quotes by accident — `let age = "22"` makes it a string, not a number, which breaks math later.

**Assignment 1 — Profile card:** Create variables for your name, age, and a one-line bio, then log a formatted introduction using them. Pass criteria: uses at least 3 variables of different types, output is readable, no console errors.

---

## Module 2 — Operators & Control Flow

### Lesson 2.1 — Operators
**Concept:** Arithmetic operators do math (`+ - * /`). Comparison operators compare values and return true/false (`=== > <`).

**Code example:**
```js
console.log(5 + 3);
console.log(10 > 7);
console.log("cat" === "cat");
```

**Try it:** Try `%` (modulo — remainder after division) with two numbers of your choice.

**Check-in:** What does `10 > 7` return?
- A) 3
- B) `true` ✓
- C) `false`
- D) An error

**Common mistake:** Using `=` (assignment) when you mean `===` (comparison) — `if (age = 18)` silently sets age to 18 instead of checking it.

### Lesson 2.2 — Conditionals
**Concept:** `if/else` lets code make decisions — run one block of code if something's true, another if it's false.

**Code example:**
```js
let age = 20;
if (age >= 18) {
  console.log("You can vote");
} else {
  console.log("Not yet");
}
```

**Try it:** Write an if/else that checks if a number is even or odd.

**Check-in:** What does the `else` block run?
- A) Always
- B) Only when the `if` condition is false ✓
- C) Only when there's an error
- D) Never

**Common mistake:** Using `=` instead of `===` inside the condition (see Lesson 2.1) — this is the single most common beginner JS bug.

### Lesson 2.3 — Loops
**Concept:** Loops repeat code without copy-pasting it. `for` loops run a set number of times; `while` loops run until a condition becomes false.

**Code example:**
```js
for (let i = 1; i <= 5; i++) {
  console.log(i);
}
```

**Try it:** Change the loop to count from 1 to 10 instead.

**Check-in:** What does `i++` do inside a for loop?
- A) Resets i to 0
- B) Increases i by 1 each time ✓
- C) Stops the loop
- D) Prints i

**Common mistake:** Forgetting to increase the loop variable (`i++`) — this creates an infinite loop that freezes the page, because the condition never becomes false.

**Assignment 2 — FizzBuzz:** Print numbers 1–20; for multiples of 3 print "Fizz", multiples of 5 print "Buzz", multiples of both print "FizzBuzz". Pass criteria: correct output for all 20 numbers, uses a loop and conditionals.

---

## Module 3 — Functions

### Lesson 3.1 — Writing your first function
**Concept:** A function is a reusable block of code you define once and run whenever you need it.

**Code example:**
```js
function greet(name) {
  console.log("Hello, " + name);
}
greet("Ada");
```

**Try it:** Call `greet()` with your own name.

**Check-in:** What do you need to do to actually run a function after defining it?
- A) Nothing, it runs automatically
- B) Call it by name with parentheses ✓
- C) Refresh the page
- D) Use `console.log` on it

**Common mistake:** Defining a function but forgetting to *call* it — the code inside never runs on its own.

### Lesson 3.2 — Parameters, return values, and scope
**Concept:** Think of a function like a machine: parameters go in, a `return` value comes out. Variables created *inside* a function only exist inside it — that's called scope.

**Code example:**
```js
function add(a, b) {
  return a + b;
}
let total = add(4, 7);
console.log(total);
```

**Try it:** Write a function that returns the larger of two numbers.

**Check-in:** What happens to a variable created inside a function once the function finishes?
- A) It becomes global
- B) It disappears — it only existed inside that function ✓
- C) It gets printed automatically
- D) It becomes a parameter

**Common mistake:** Forgetting `return` and expecting a value back — without it, the function gives back `undefined` even if it `console.log`'d something internally.

### Lesson 3.3 — Arrow functions
**Concept:** Arrow functions are a shorter way to write the same thing.

**Code example:**
```js
const add = (a, b) => {
  return a + b;
};
```
Same as the `function add(a, b) {...}` version from before.

**Try it:** Rewrite your Lesson 3.2 function as an arrow function.

**Check-in:** What symbol is unique to arrow function syntax?
- A) `{}`
- B) `=>` ✓
- C) `()`
- D) `;`

**Common mistake:** Forgetting the parentheses around parameters when there's more than one — `a, b => ...` is invalid; it needs `(a, b) => ...`.

**Assignment 3 — Simple calculator:** Write functions `add`, `subtract`, `multiply`, `divide`, each taking two numbers and returning the result. Pass criteria: all four return correct results, `divide` handles division by zero without crashing.

---

## Module 4 — Arrays & Objects

### Lesson 4.1 — Arrays and common methods
**Concept:** An array is an ordered list of values. Common methods: `push` (add to the end), `map` (transform every item), `filter` (keep only matching items).

**Code example:**
```js
let foods = ["rice", "beans", "yam"];
foods.push("plantain");
console.log(foods);
```

**Try it:** Use `.filter()` to keep only foods longer than 4 letters.

**Check-in:** What does `.push()` do to an array?
- A) Removes the last item
- B) Adds an item to the end ✓
- C) Sorts the array
- D) Empties the array

**Common mistake:** Forgetting arrays are zero-indexed — `foods[0]` is the *first* item, not `foods[1]`.

### Lesson 4.2 — Objects
**Concept:** An object stores related data as key-value pairs — useful for modeling a single "thing" with multiple properties, like a student.

**Code example:**
```js
let student = {
  name: "Ada",
  age: 22,
  track: "JavaScript"
};
console.log(student.name);
```

**Try it:** Add a `streak` property to the object and log it.

**Check-in:** How do you access a property on an object?
- A) `object[0]`
- B) `object.propertyName` ✓
- C) `object->propertyName`
- D) `object(propertyName)`

**Common mistake:** Confusing array index access (`array[0]`) with object property access (`object.name`) — they use different syntax.

### Lesson 4.3 — Arrays of objects
**Concept:** This is the pattern used in almost every real app — a list of structured items, like a list of students, each with their own name/age/track.

**Code example:**
```js
let students = [
  { name: "Ada", track: "JavaScript" },
  { name: "Femi", track: "Python" }
];
let jsStudents = students.filter(s => s.track === "JavaScript");
console.log(jsStudents);
```

**Try it:** Add a third student and filter for a different track.

**Check-in:** What does `students.filter(s => s.track === "JavaScript")` return?
- A) The whole array unchanged
- B) Only the student objects where track is "JavaScript" ✓
- C) Just the word "JavaScript"
- D) An error

**Common mistake:** Forgetting `filter` returns a *new* array rather than changing the original — you need to save the result to a variable to use it.

**Assignment 4 — Todo list logic:** Build an array of todo objects (`{ text, done }`), write functions to add a todo, mark one done, and filter out completed ones — console output only, no UI yet. Pass criteria: all three functions work correctly on a sample array.

---

## Module 5 — DOM & Events (Capstone)

### Lesson 5.1 — What the DOM is
**Concept:** The DOM (Document Object Model) is how JavaScript "sees" your HTML page — as a tree of elements it can read and change.

**Check-in:** What does the DOM let JavaScript do?
- A) Style pages directly (CSS's job)
- B) Read and change page elements ✓
- C) Send emails
- D) Store files

**Common mistake:** Thinking the DOM is the same as your HTML source code — it's a live, changeable representation the browser builds from it.

### Lesson 5.2 — Selecting and changing elements
**Concept:** `document.querySelector()` finds an element on the page; you can then read or change it, like its text.

**Code example:**
```js
let heading = document.querySelector("h1");
heading.textContent = "Updated!";
```

**Try it:** Select a paragraph on a page and change its text.

**Check-in:** What does `.textContent` let you do?
- A) Change an element's color
- B) Read or change an element's text ✓
- C) Delete an element
- D) Add a new element

**Common mistake:** Using a selector that doesn't match anything on the page — `document.querySelector()` then returns `null`, and trying to change `.textContent` on `null` throws an error.

### Lesson 5.3 — Event listeners
**Concept:** Event listeners run code in response to something happening, like a click.

**Code example:**
```js
let button = document.querySelector("button");
button.addEventListener("click", () => {
  console.log("Clicked!");
});
```

**Try it:** Make a button that changes a heading's text when clicked.

**Check-in:** What's the second argument to `addEventListener`?
- A) The element itself
- B) A function to run when the event happens ✓
- C) The event's name
- D) A CSS class

**Common mistake:** Writing `button.addEventListener("click", doSomething())` with parentheses — this calls the function immediately instead of passing it to run *later*, on click.

**Capstone Assignment — Working todo list in the browser:** Build a real todo list with HTML + the JS from Module 4 — add a todo via an input + button, mark items done, remove items. Pass criteria: add/complete/remove all work without errors; this is a portfolio-worthy first project and the assignment that unlocks this track's certificate.

---

## Module 6 — Modern JavaScript Essentials

### Lesson 6.1 — Template literals in depth
**Concept:** Template literals (backticks) let you embed variables and expressions directly inside a string, and even write multi-line strings — much cleaner than joining strings with `+`.

**Code example:**
```js
let name = "Ada";
let age = 22;
console.log(`${name} is ${age} years old`);
console.log(`Next year: ${age + 1}`);
```

**Try it:** Build a sentence using a template literal that includes a calculation inside `${}`.

**Check-in:** What symbol wraps a template literal?
- A) Double quotes `"`
- B) Backticks `` ` `` ✓
- C) Single quotes `'`
- D) Curly braces only

**Common mistake:** Using regular quotes instead of backticks and expecting `${}` to work — `${}` only works inside backtick strings.

### Lesson 6.2 — Destructuring
**Concept:** Destructuring lets you pull values out of arrays or objects into their own variables in one line.

**Code example:**
```js
let student = { name: "Ada", age: 22 };
let { name, age } = student;
console.log(name, age);

let [first, second] = ["red", "blue"];
console.log(first, second);
```

**Try it:** Destructure a `track` and `streak` value out of an object you create.

**Check-in:** What does `let { name, age } = student;` do?
- A) Deletes name and age from student
- B) Creates variables `name` and `age` from the object's matching properties ✓
- C) Creates one variable called `nameage`
- D) Causes an error

**Common mistake:** Misspelling a property name during destructuring — `let { naem } = student` creates a variable called `naem` with the value `undefined`, silently, no error thrown.

### Lesson 6.3 — Spread and rest operators
**Concept:** The `...` syntax has two uses: "spreading" an array/object out (copying/combining), or "resting" multiple arguments into one array.

**Code example:**
```js
let a = [1, 2, 3];
let b = [...a, 4, 5];
console.log(b);

function sumAll(...numbers) {
  return numbers.reduce((total, n) => total + n, 0);
}
console.log(sumAll(1, 2, 3, 4));
```

**Try it:** Use spread to combine two arrays of your own into one.

**Check-in:** What does `[...a, 4, 5]` create?
- A) A nested array containing `a`
- B) A new array with all of `a`'s items plus 4 and 5 ✓
- C) An error
- D) The number 45

**Common mistake:** Confusing spread (expanding values out) with rest (gathering values in) — same `...` syntax, opposite purpose, depending on where it's used.

### Lesson 6.4 — More array methods
**Concept:** Beyond `map`/`filter`: `.reduce()` combines all items into one value, `.find()` returns the first match, `.sort()` orders items, `.some()`/`.every()` test conditions across the array.

**Code example:**
```js
let numbers = [3, 1, 4, 1, 5];
let total = numbers.reduce((sum, n) => sum + n, 0);
let hasBigNumber = numbers.some(n => n > 4);
console.log(total, hasBigNumber);
```

**Try it:** Use `.find()` to get the first number greater than 3 from an array.

**Check-in:** What does `.reduce()` do?
- A) Removes items from an array
- B) Combines all items into a single value ✓
- C) Sorts the array
- D) Doubles every item

**Common mistake:** Forgetting `.reduce()`'s second argument (the starting value) — without it, the first array item becomes the starting point, which can cause subtle bugs.

**Assignment 6:** Rewrite your Module 4 todo-list functions using destructuring, spread, and at least one of reduce/find/some. Pass criteria: functions still work correctly, uses at least 3 of the techniques above.

---

## Module 7 — Closures, Async JavaScript & Errors

### Lesson 7.1 — Closures
**Concept:** A closure is a function that "remembers" variables from where it was created, even after that outer function has finished running.

**Code example:**
```js
function makeCounter() {
  let count = 0;
  return function () {
    count++;
    return count;
  };
}
let counter = makeCounter();
console.log(counter());
console.log(counter());
```

**Try it:** Run the code above twice and notice the count keeps increasing — it "remembers" between calls.

**Check-in:** What does the inner function in a closure remember?
- A) Nothing, each call starts fresh
- B) Variables from the outer function where it was created ✓
- C) Only global variables
- D) The page's HTML

**Common mistake:** Expecting `count` to reset to 0 every time `counter()` is called — closures specifically remember state between calls, that's the whole point.

### Lesson 7.2 — Asynchronous JavaScript: Promises
**Concept:** Some operations (like fetching data) take time. A Promise represents a value that will be available *later* — either successfully (`resolved`) or with an error (`rejected`).

**Code example:**
```js
function delayedGreeting() {
  return new Promise((resolve) => {
    setTimeout(() => resolve("Hello later!"), 1000);
  });
}
delayedGreeting().then(message => console.log(message));
```

**Try it:** Chain a second `.then()` after the first to log another message.

**Check-in:** What does `.then()` do on a Promise?
- A) Runs immediately, ignoring the delay
- B) Runs once the Promise resolves ✓
- C) Cancels the Promise
- D) Creates a new variable

**Common mistake:** Forgetting that code after a Promise call keeps running immediately — `console.log("done")` right after `delayedGreeting()` runs *before* the promise resolves, not after.

### Lesson 7.3 — async/await
**Concept:** `async`/`await` is a cleaner way to write Promise-based code — it lets asynchronous code read almost like normal step-by-step code.

**Code example:**
```js
async function getGreeting() {
  let message = await delayedGreeting();
  console.log(message);
}
getGreeting();
```

**Try it:** Rewrite your Lesson 7.2 `.then()` chain using `async`/`await` instead.

**Check-in:** What does `await` do inside an async function?
- A) Skips the Promise entirely
- B) Pauses that function until the Promise resolves ✓
- C) Deletes the Promise
- D) Makes the code run faster

**Common mistake:** Using `await` outside of a function marked `async` — this is a syntax error; `await` only works inside `async` functions.

### Lesson 7.4 — Fetching real data with the Fetch API
**Concept:** `fetch()` is the built-in way to request data from a server, and it returns a Promise.

**Code example:**
```js
async function getStudents() {
  let response = await fetch("/api/students");
  let data = await response.json();
  console.log(data);
}
```

**Try it:** Fetch data from any public test API and log the result.

**Check-in:** Why is there a second `await response.json()`?
- A) It's optional
- B) Converting the raw response into usable data also takes time and returns a Promise ✓
- C) It's a typo
- D) fetch() doesn't work without it

**Common mistake:** Forgetting the first `await` on `fetch()` itself — without it, `response` is a Promise object, not the actual response, and trying to call `.json()` on it directly breaks.

### Lesson 7.5 — Error handling with try/catch
**Concept:** `try/catch` lets you handle errors gracefully instead of crashing the whole program.

**Code example:**
```js
async function getStudents() {
  try {
    let response = await fetch("/api/students");
    let data = await response.json();
    console.log(data);
  } catch (error) {
    console.log("Something went wrong:", error.message);
  }
}
```

**Try it:** Deliberately fetch a URL that doesn't exist and see the catch block run.

**Check-in:** What does the `catch` block run?
- A) Always, no matter what
- B) Only if something inside `try` throws an error ✓
- C) Before the try block
- D) Never, it's optional decoration

**Common mistake:** Wrapping code in `try/catch` but doing nothing useful in `catch` (or leaving it empty) — silently swallowing errors makes bugs much harder to find later.

**Assignment 7:** Rewrite your Module 4 fetch-based logic (or write a new small feature) using async/await with proper try/catch error handling, and use a closure somewhere meaningfully (e.g. a counter or a simple cache). Pass criteria: async/await used correctly, errors are actually handled, closure behaves correctly.

---

## Module 8 — Modules, JSON & Basic OOP

### Lesson 8.1 — ES Modules
**Concept:** As projects grow, you split code across multiple files. `export` shares something from a file; `import` brings it into another file.

**Code example:**
```js
// math.js
export function add(a, b) {
  return a + b;
}

// app.js
import { add } from "./math.js";
console.log(add(2, 3));
```

**Try it:** Split one of your earlier functions into its own file and import it.

**Check-in:** What does `export` do to a function?
- A) Deletes it
- B) Makes it available to import in other files ✓
- C) Runs it immediately
- D) Converts it to a string

**Common mistake:** Forgetting the file extension or exact path in an import statement — `import { add } from "./math"` (missing `.js`) can fail depending on your setup.

### Lesson 8.2 — Working with JSON
**Concept:** JSON (JavaScript Object Notation) is a text format for representing data — it's what most APIs send and receive. `JSON.stringify()` turns a JS object into a JSON string; `JSON.parse()` does the reverse.

**Code example:**
```js
let student = { name: "Ada", age: 22 };
let jsonString = JSON.stringify(student);
console.log(jsonString);

let backToObject = JSON.parse(jsonString);
console.log(backToObject.name);
```

**Try it:** Stringify an object, then parse it back and confirm it matches the original.

**Check-in:** What does `JSON.parse()` do?
- A) Turns an object into text
- B) Turns JSON text back into a usable JS object ✓
- C) Deletes JSON data
- D) Sends data to a server

**Common mistake:** Trying to access a property directly on a JSON string before parsing it — `jsonString.name` gives `undefined` since it's still just text, not an object yet.

### Lesson 8.3 — Basic classes
**Concept:** A class is a template for creating objects with shared structure and behavior — useful when you need many similar objects (like many students).

**Code example:**
```js
class Student {
  constructor(name, track) {
    this.name = name;
    this.track = track;
  }
  introduce() {
    console.log(`Hi, I'm ${this.name}, learning ${this.track}`);
  }
}
let student1 = new Student("Ada", "JavaScript");
student1.introduce();
```

**Try it:** Add a second method to the class, like `graduate()` that logs a completion message.

**Check-in:** What does the `constructor` method do?
- A) Runs every time a method is called
- B) Runs once, when a new object is created with `new` ✓
- C) Deletes the object
- D) Nothing, it's optional decoration

**Common mistake:** Forgetting the `new` keyword when creating an instance (`let s = Student(...)` instead of `new Student(...)`) — this causes an error since classes must be constructed with `new`.

**Assignment 8:** Refactor your Module 5 capstone todo app to use a `Todo` class instead of plain objects, split your code across at least two files using import/export, and use JSON.stringify/parse to save/load the todo list from browser localStorage. Pass criteria: class works correctly, modules import/export properly, todos persist across a page refresh.

---

## Module 9 — Deploying Your Project (GitHub + Vercel)

### Lesson 9.1 — Pushing your project to GitHub
**Concept:** GitHub stores your code online and is what deployment tools connect to.

**Try it — numbered steps:**
1. Create a free account at github.com if you don't have one
2. Create a new repository
3. From your project folder, run:
```bash
git init
git add .
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/your-username/your-repo.git
git push -u origin main
```

**Check-in:** What does `git push` do?
- A) Deletes your local code
- B) Uploads your committed code to GitHub ✓
- C) Runs your code
- D) Installs packages

**Common mistake:** Forgetting to `git add` and `git commit` new changes before pushing — `git push` only sends what's already been committed.

### Lesson 9.2 — Deploying to Vercel
**Concept:** Vercel is a free hosting platform that connects directly to your GitHub repo and automatically deploys your site whenever you push changes.

**Try it — numbered steps:**
1. Go to vercel.com and sign up (can use your GitHub account directly)
2. Click "Add New Project" and select your repository
3. Leave the default settings for a plain HTML/JS project
4. Click "Deploy"
5. You'll get a live URL in about a minute

**Check-in:** What happens when you push new changes to GitHub after deploying?
- A) Nothing, you have to redeploy manually every time
- B) Vercel automatically rebuilds and redeploys your site ✓
- C) The live site breaks
- D) You need a new Vercel account

**Common mistake:** Testing changes only in your local files and forgetting to push to GitHub — the live Vercel site only reflects what's actually been pushed.

**Assignment 9 (Capstone extension):** Push your final todo app project to GitHub and deploy it live on Vercel. Share the live URL. Pass criteria: live URL works and matches the current version of the project.
