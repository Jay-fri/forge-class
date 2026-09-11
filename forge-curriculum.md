# Forge — Curriculum & Content Plan

This document defines the lesson structure Forge uses for every track, provides one fully-written track (JavaScript Fundamentals) as the working example, and gives module/assignment outlines for the remaining five tracks. Claude Code (or whoever writes lesson content) should follow the template exactly so every track feels consistent, not hand-crafted differently each time.

A note on scope: this is a real, usable starting curriculum, not the entire finished course catalog. Writing complete lesson-by-lesson content for all six tracks in full depth is genuinely months of content work. What's here is enough to launch the first track for real and to expand the rest on a consistent pattern.

---

## The lesson template (use this for every lesson, every track)

Every lesson is broken into short **sections**. Each section is one of these types:

- **Concept**: a short explanation (2-4 sentences max), using arrows/diagrams/numbered steps wherever it helps, never a wall of text
- **Code example**: a real, runnable snippet in the embedded editor, syntax-highlighted, with a one-line caption explaining what it does
- **Try it**: a small variation the student edits and runs themselves (not just reads)
- **Check-in**: a single embedded quiz question testing the concept just taught (per Phase 3's embedded-quiz requirement)
- **Common mistake**: a short callout box showing one realistic error a beginner makes here and what it means (feeds directly into the AI's "explain this error" behavior)

A typical lesson = Concept, Code example, Try it, Check-in. Not every lesson needs every section type: installation/setup lessons lean harder on numbered steps and screenshots/diagrams; concept-only lessons may skip "Try it."

Each **module** ends with an **assignment**: a real task with a clear spec, starter code (if relevant), and a pass/fail or scored rubric the instructor grades against.

---

## Track 1 — JavaScript Fundamentals (fully worked example)

### Module 1: Getting started

**Lesson 1.1 — What JavaScript actually does**
- Concept: JavaScript is what makes a webpage *do* things: HTML is the structure, CSS is the look, JavaScript is the behavior. Use a simple 3-box diagram (HTML, CSS, JS) here.
- Concept: It runs in the browser, and every browser has a built-in console to try it instantly, no setup needed to start.
- Check-in: "Which of these does JavaScript control?" (multiple choice: structure / appearance / behavior / all three)

**Lesson 1.2 — Running your first line of code**
- Numbered steps: 1) Open your browser 2) Right-click anywhere, Inspect 3) Click the "Console" tab 4) Type the code below and press Enter
- Code example:
```js
console.log("Hello, Forge");
```
- Try it: change the text inside the quotes and run it again
- Common mistake: forgetting the closing quote mark, show the error message this produces and what it means

**Lesson 1.3 — Variables and data types**
- Concept: A variable is a labeled box that holds a value you can reuse
- Code example:
```js
let name = "Ada";
let age = 22;
let isStudent = true;
console.log(name, age, isStudent);
```
- Concept: three data types shown above, string (text), number, boolean (true/false), table format:
  | Type | Example | Use |
  |---|---|---|
  | String | `"Ada"` | Text |
  | Number | `22` | Counting, math |
  | Boolean | `true` | Yes/no logic |
- Try it: create your own variables for your name, age, and favorite language
- Check-in: "What data type is `true`?"

**Assignment 1 — Profile card**
- Task: create variables for your name, age, and a one-line bio, then log a formatted introduction using them
- Starter code: none, from scratch
- Pass criteria: uses at least 3 variables of different types, output is readable, no console errors

---

### Module 2: Operators & control flow

**Lessons (same template as above):**
- 2.1 — Arithmetic and comparison operators (`+ - * / ===` etc.), code example + try it
- 2.2 — Conditionals (`if / else`), code example showing an age-check, common mistake: using `=` instead of `===`
- 2.3 — Loops (`for`, `while`), code example counting 1-10, common mistake: infinite loop from a missing increment

**Assignment 2 — FizzBuzz**
- Task: print numbers 1-20; for multiples of 3 print "Fizz", multiples of 5 print "Buzz", multiples of both print "FizzBuzz"
- Starter code: empty `for` loop shell provided
- Pass criteria: correct output for all 20 numbers, uses conditionals and a loop

---

### Module 3: Functions

**Lessons:**
- 3.1 — Writing your first function, code example: a `greet(name)` function
- 3.2 — Parameters, return values, and scope, concept diagram showing a function as a "machine" (input, process, output)
- 3.3 — Arrow functions, code example rewriting 3.1's function as an arrow function, side-by-side comparison table

**Assignment 3 — Simple calculator**
- Task: write functions `add`, `subtract`, `multiply`, `divide`, each taking two numbers and returning the result
- Starter code: four empty function shells
- Pass criteria: all four functions return correct results, divide handles division-by-zero without crashing

---

### Module 4: Arrays & objects

**Lessons:**
- 4.1 — Arrays and common methods (`push`, `map`, `filter`), code example building a list of favorite foods
- 4.2 — Objects, code example modeling a student (`{ name, age, track }`)
- 4.3 — Arrays of objects, the pattern used in almost every real app, code example: a small list of student objects, filtered by track

**Assignment 4 — Todo list logic**
- Task: build an array of todo objects (`{ text, done }`), write functions to add a todo, mark one done, and filter out completed ones, console output only, no UI yet
- Starter code: empty array + function shells
- Pass criteria: all three functions work correctly on a sample array

---

### Module 5: DOM & events (capstone, ties it all together)

**Lessons:**
- 5.1 — What the DOM is (concept diagram: HTML tree structure)
- 5.2 — Selecting and changing elements (`document.querySelector`, `.textContent`)
- 5.3 — Event listeners (`addEventListener('click', ...)`), code example: a button that changes text on click

**Assignment 5 (capstone project) — Working todo list in the browser**
- Task: build a real todo list with HTML + the JS from Module 4, add a todo via an input + button, mark items done, remove items, this is a portfolio-worthy first project
- Starter code: HTML skeleton provided (input, button, empty list container), JS file empty
- Pass criteria: add/complete/remove all work without errors; this assignment triggers the track-completion certificate on passing grade

---

## Tracks 2-6 — module outlines (expand using the template above)

### Track 2 — Python (standalone)
Mirrors the JavaScript track's shape and difficulty curve, adjusted for Python syntax and idioms.
1. **Getting started**: what Python is, running code (REPL or online editor), variables & types
2. **Operators & control flow**: operators, `if/elif/else`, `for`/`while` loops
3. **Functions**: defining functions, parameters/return, default arguments
4. **Lists & dictionaries**: Python's equivalent of arrays/objects, common methods
5. **Files & simple projects (capstone)**: reading/writing a text file, capstone: a simple command-line todo list or number-guessing game
- Assignments mirror the JS track's shape: a profile-print task, a FizzBuzz-style task, a small calculator, a data-manipulation task, and a capstone CLI project

### Track 3 — PHP
1. **Getting started**: what PHP does (server-side), embedding PHP in HTML, variables & types
2. **Operators & control flow**: same shape as JS/Python modules 2
3. **Functions**: same shape
4. **Arrays & associative arrays**: PHP's version of objects/dictionaries
5. **Forms & simple server logic (capstone)**: handling a basic HTML form submission, capstone: a simple contact-form handler that validates and echoes input
- Assignments mirror the same five-module shape as above

### Track 4 — Frontend (HTML, CSS, JS, intro React)
Builds on the JavaScript Fundamentals track above rather than duplicating it.
1. **HTML foundations**: structure, common tags, forms
2. **CSS foundations**: selectors, box model, flexbox/grid, responsive basics
3. **JavaScript fundamentals**: reuse Track 1 in full
4. **Putting pages together**: combining HTML/CSS/JS into a real interactive page (capstone-style project per module here too)
5. **Intro to React**: components, props, state, building a small multi-component app
- Capstone: a small multi-page interactive site (e.g. a personal portfolio with working JS interactivity)

### Track 5 — Backend
1. **Getting started with Node.js**: what a server is, running a basic Node script
2. **Express basics**: routes, handling requests/responses
3. **Working with data**: connecting to a database (Supabase/Postgres basics), basic CRUD
4. **Authentication basics**: what auth is, simple login flow concepts
5. **Building a small API (capstone)**: a working REST API with a few endpoints, tested via a simple client
- Assignments: a "hello world" server, a set of working routes, a small database-backed feature, and the capstone API

### Track 6 — Full Stack
Combines Frontend (Track 4) and Backend (Track 5) modules in sequence, plus one final combined capstone:
- **Final capstone**: a small full-stack app (e.g. a simple todo app with a real backend, persisted data, and a polished frontend), this is the strongest portfolio piece in the whole curriculum and should be treated as the flagship assignment across the platform

---

## Notes for whoever expands this (Claude Code or Joshua)
- Always follow the lesson template: Concept / Code example / Try it / Check-in / Common mistake, don't invent a new structure per track
- Every "Common mistake" box should map to something the Ask AI tutor can recognize and explain in plain language (Phase 3's error-explanation behavior), write these with that in mind
- Assignments should escalate in difficulty within a track but stay achievable, a student who did all prior lessons in the module should be able to complete it without external help
- The Module 5 / capstone assignment in each track is the one that unlocks the track certificate, make sure grading criteria for those specifically are unambiguous, since they gate a real credential
