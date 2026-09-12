# Forge Course: React

*Assumes the JavaScript course is already complete.*

## Module 1 — Why React Exists

### Lesson 1.1 — The problem React solves
**Concept:** In plain JavaScript, updating the page means manually finding elements and changing them one by one (`document.querySelector`, `.textContent`, etc.). As an app grows, this gets messy fast. React lets you describe *what the page should look like* for a given state, and it handles updating things for you.

**Check-in:** What problem does React mainly solve?
- A) Making CSS easier
- B) Managing complex, changing UI without manual DOM updates ✓
- C) Replacing HTML entirely
- D) Making websites load faster automatically

**Common mistake:** Assuming React replaces JavaScript — it's built *with* JavaScript, using everything from the JS course (functions, arrays, objects).

### Lesson 1.2 — What is a component?
**Concept:** A component is a reusable, self-contained piece of UI — like a button, a card, or an entire page — built as a JavaScript function that returns what should appear on screen.

**Check-in:** What is a React component, at its core?
- A) A CSS file
- B) A function that returns UI ✓
- C) A database table
- D) An HTML tag

**Common mistake:** Trying to build one giant component for an entire app — breaking things into small, focused components (a card, a button, a list item) makes code far easier to manage.

### Lesson 1.3 — Your first component and JSX
**Concept:** JSX is HTML-like syntax you write directly inside JavaScript. It looks like HTML but is actually JavaScript under the hood.

**Code example:**
```jsx
function Greeting() {
  return <h1>Hello, Forge</h1>;
}
```

**Try it:** Create a component called `Welcome` that returns a paragraph with your name.

**Check-in:** What does a component return?
- A) A string only
- B) JSX describing what should appear ✓
- C) A CSS class
- D) Nothing

**Common mistake:** Forgetting a component can only return *one* top-level element — wrap multiple elements in a single parent `<div>` (or a React Fragment `<>...</>`).

**Assignment 1:** Create three simple components (`Header`, `Bio`, `Footer`), each returning a small piece of JSX, and render all three together. Pass criteria: each is a valid function component, all three appear on screen.

---

## Module 2 — Props & State

### Lesson 2.1 — Props
**Concept:** Props (short for "properties") pass data *into* a component from outside — like function parameters, but for components.

**Code example:**
```jsx
function Greeting(props) {
  return <h1>Hello, {props.name}</h1>;
}
// used as: <Greeting name="Ada" />
```

**Try it:** Give your `Welcome` component from Lesson 1.3 a `name` prop instead of a hardcoded name.

**Check-in:** How do you pass data into a component?
- A) Global variables
- B) Props, like `<Component propName="value" />` ✓
- C) Console.log
- D) You can't

**Common mistake:** Trying to change a prop's value inside the component — props are read-only from the component's perspective; they're controlled by whoever renders it.

### Lesson 2.2 — State
**Concept:** State is data a component remembers and can update on its own — like a counter that changes when clicked. `useState` is the tool for this.

**Code example:**
```jsx
import { useState } from "react";

function Counter() {
  const [count, setCount] = useState(0);
  return <p>Count: {count}</p>;
}
```

**Try it:** Change the starting value inside `useState(0)` to a different number.

**Check-in:** What does `useState(0)` return?
- A) Just the number 0
- B) A pair: the current value and a function to update it ✓
- C) A component
- D) An error

**Common mistake:** Trying to update state by directly changing the variable (`count = count + 1`) instead of using the setter function (`setCount(count + 1)`) — React won't notice the change and the screen won't update.

### Lesson 2.3 — Handling events
**Concept:** React uses event props like `onClick` and `onChange`, similar to `addEventListener` but written directly on the element.

**Code example:**
```jsx
function Counter() {
  const [count, setCount] = useState(0);
  return (
    <div>
      <p>Count: {count}</p>
      <button onClick={() => setCount(count + 1)}>Add</button>
    </div>
  );
}
```

**Try it:** Add a second button that decreases the count.

**Check-in:** What does `onClick={() => setCount(count + 1)}` do?
- A) Runs immediately when the page loads
- B) Runs when the button is clicked, increasing count ✓
- C) Changes the button's color
- D) Deletes the button

**Common mistake:** Writing `onClick={setCount(count + 1)}` without the arrow function — this runs it immediately on render instead of waiting for the click.

**Assignment 2:** Build a working counter component with increase, decrease, and reset buttons. Pass criteria: state updates correctly, all three buttons work.

---

## Module 3 — Lists & Capstone

### Lesson 3.1 — Rendering lists
**Concept:** To display an array of data as UI, use `.map()` to turn each item into a piece of JSX. Each item needs a unique `key` prop so React can track it.

**Code example:**
```jsx
function TodoList({ todos }) {
  return (
    <ul>
      {todos.map(todo => (
        <li key={todo.id}>{todo.text}</li>
      ))}
    </ul>
  );
}
```

**Try it:** Render a list of your own favorite foods as an array of objects.

**Check-in:** Why does each list item need a `key` prop?
- A) It's just decoration
- B) It helps React track which items changed, added, or removed ✓
- C) It sets the item's color
- D) It's required for CSS

**Common mistake:** Using the array index as the key when items can be reordered or removed — this can cause React to mix up which item is which; a stable unique ID is safer.

**Capstone Assignment — Multi-component todo app:** Build a working todo list app using components, props, state, and events together: a form to add a todo (state + event), a list rendered from an array (`.map()`), and the ability to mark items done and remove them. Pass criteria: adding, completing, and removing todos all work correctly; components are sensibly broken up rather than one giant file. This is the assignment that unlocks this track's certificate.

---

## Module 0 — Setting Up Your React Project

*(Do this module first, before Module 1 — it's placed here so the numbered modules above stay easy to reference.)*

### Lesson 0.1 — Installing Node.js
**Concept:** React projects need Node.js installed on your computer — it's the tool that runs the build process and dev server, even though your final app runs in the browser.

**Try it — numbered steps:**
1. Go to nodejs.org and download the LTS (Long Term Support) version
2. Run the installer
3. Open your terminal and type `node -v` to confirm it installed — you should see a version number

**Check-in:** What does typing `node -v` do?
- A) Creates a new React project
- B) Confirms Node is installed and shows its version ✓
- C) Deletes Node
- D) Opens the browser

**Common mistake:** Installing Node but not restarting the terminal afterward — the terminal sometimes needs a fresh restart to recognize the new install.

### Lesson 0.2 — Creating a React project with Vite
**Concept:** Vite is a fast, modern tool for creating and running React projects — it sets up everything you need in one command.

**Try it — numbered steps:**
1. Open your terminal, navigate to a folder where you want your project
2. Run: `npm create vite@latest my-app -- --template react`
3. Move into the folder: `cd my-app`
4. Install packages: `npm install`
5. Start the dev server: `npm run dev`
6. Open the URL it gives you (usually `localhost:5173`) in your browser

**Check-in:** What does `npm install` do?
- A) Starts the app
- B) Downloads all the packages your project needs ✓
- C) Deletes the project
- D) Creates a GitHub repo

**Common mistake:** Skipping `npm install` after creating a project or pulling one from GitHub — the project won't run until all its packages are actually downloaded.

### Lesson 0.3 — Installing additional packages
**Concept:** Beyond the starter template, you'll often need extra packages (like a routing library). You install these with `npm install <package-name>`.

**Code example:**
```bash
npm install react-router-dom
```

**Try it:** Install `react-router-dom` in your project — you'll use it in Module 3.

**Check-in:** Where do installed packages get listed?
- A) Nowhere, they're invisible
- B) In your project's `package.json` file ✓
- C) Only in your browser
- D) In a separate app

**Common mistake:** Manually editing `package.json` to add a package name without actually running `npm install` — the package won't really be downloaded, just listed.

**Assignment 0:** Set up a brand-new React + Vite project from scratch, following the steps above, and get the default starter page running in your browser. Pass criteria: dev server runs without errors, default page loads.

---

## Module 4 — Filling the Gaps (useEffect, forms, composition, routing, data, hooks)

### Lesson 4.1 — useEffect and side effects
**Concept:** Sometimes a component needs to *do* something beyond just rendering — like fetching data when it first appears. `useEffect` runs code in response to a component rendering or specific values changing.

**Code example:**
```jsx
import { useEffect, useState } from "react";

function Clock() {
  const [time, setTime] = useState(new Date());

  useEffect(() => {
    const timer = setInterval(() => setTime(new Date()), 1000);
    return () => clearInterval(timer);
  }, []);

  return <p>{time.toLocaleTimeString()}</p>;
}
```

**Try it:** Build a component that logs a message once when it first appears, using `useEffect` with an empty array `[]`.

**Check-in:** What does the empty array `[]` as useEffect's second argument mean?
- A) Run on every render
- B) Run only once, when the component first appears ✓
- C) Never run
- D) Run only on click

**Common mistake:** Forgetting the dependency array entirely — this makes the effect run after *every* render, which can cause performance problems or infinite loops.

### Lesson 4.2 — Conditional rendering
**Concept:** You can show different UI based on a condition, using regular JavaScript inside JSX — if/else logic, ternaries, or `&&`.

**Code example:**
```jsx
function Greeting({ isLoggedIn }) {
  return (
    <div>
      {isLoggedIn ? <p>Welcome back!</p> : <p>Please log in.</p>}
    </div>
  );
}
```

**Try it:** Show a "Loading..." message only when a `loading` prop is true, using `&&`.

**Check-in:** What does `{isLoggedIn ? <p>A</p> : <p>B</p>}` do?
- A) Always shows both
- B) Shows A if isLoggedIn is true, B if false ✓
- C) Causes an error
- D) Shows nothing

**Common mistake:** Using `{isLoggedIn && <p>Welcome</p>}` when `isLoggedIn` might be `0` instead of `false` — React can render a stray "0" on the screen in that edge case.

### Lesson 4.3 — Forms in React (controlled inputs)
**Concept:** A "controlled input" means React state is the source of truth for a form field's value, not the DOM itself.

**Code example:**
```jsx
function NameForm() {
  const [name, setName] = useState("");
  return (
    <input value={name} onChange={(e) => setName(e.target.value)} />
  );
}
```

**Try it:** Build a small form with a controlled text input and a submit button that logs the value.

**Check-in:** What makes an input "controlled" in React?
- A) It has a border
- B) Its value comes from state, updated via onChange ✓
- C) It's read-only
- D) It has a placeholder

**Common mistake:** Setting `value` without an `onChange` handler — this makes the input impossible to type into, since React keeps resetting it to the unchanging state value.

### Lesson 4.4 — Component composition
**Concept:** Instead of one giant component, you can nest components inside each other and pass content via `children` — useful for reusable wrappers like a Card.

**Code example:**
```jsx
function Card({ children }) {
  return <div className="card">{children}</div>;
}
// used as: <Card><p>Some content</p></Card>
```

**Try it:** Build a `Card` component and use it to wrap two different pieces of content in your app.

**Check-in:** What does `children` represent in a component?
- A) A special CSS class
- B) Whatever content is nested between the component's opening and closing tags ✓
- C) The component's parent
- D) An error

**Common mistake:** Forgetting `children` is just a prop like any other — it needs to be explicitly used inside the component (`{children}`) or nothing will render.

### Lesson 4.5 — Basic routing with React Router
**Concept:** Real apps have multiple pages. React Router lets you show different components based on the URL, without a full page reload.

**Code example:**
```jsx
import { BrowserRouter, Routes, Route } from "react-router-dom";

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/about" element={<About />} />
      </Routes>
    </BrowserRouter>
  );
}
```

**Try it:** Add a third route for a "Contact" page.

**Check-in:** What does the `path` prop on `<Route>` control?
- A) The component's styling
- B) Which URL shows that component ✓
- C) The component's props
- D) Nothing important

**Common mistake:** Forgetting to wrap everything in `<BrowserRouter>` — routes won't work at all without it.

### Lesson 4.6 — Fetching data from an API
**Concept:** Combining `useEffect` and `useState`, you can load data from an API when a component appears.

**Code example:**
```jsx
function Students() {
  const [students, setStudents] = useState([]);

  useEffect(() => {
    fetch("/api/students")
      .then(res => res.json())
      .then(data => setStudents(data));
  }, []);

  return <ul>{students.map(s => <li key={s.id}>{s.name}</li>)}</ul>;
}
```

**Try it:** Fetch data from any public test API and render the results as a list.

**Check-in:** Why is `fetch` combined with `useEffect` here instead of called directly in the component body?
- A) It's not necessary, just a style choice
- B) Calling fetch directly in the render would trigger it on every single render, causing infinite requests ✓
- C) fetch only works inside useEffect
- D) It's faster this way

**Common mistake:** Forgetting the empty dependency array `[]` on the useEffect — without it, the fetch runs on every render, hammering the API.

### Lesson 4.7 — Custom hooks (intro)
**Concept:** When you find yourself repeating the same `useState`/`useEffect` logic in multiple components, you can extract it into your own reusable hook — a function starting with `use`.

**Code example:**
```jsx
function useWindowWidth() {
  const [width, setWidth] = useState(window.innerWidth);
  useEffect(() => {
    const handler = () => setWidth(window.innerWidth);
    window.addEventListener("resize", handler);
    return () => window.removeEventListener("resize", handler);
  }, []);
  return width;
}
```

**Try it:** Use `useWindowWidth()` inside a component and display the current width.

**Check-in:** What must a custom hook's name start with?
- A) Any name works
- B) `use` ✓
- C) `hook`
- D) A capital letter only

**Common mistake:** Not starting a custom hook's name with `use` — React relies on this naming convention to correctly apply its rules of hooks.

### Lesson 4.8 — Context API (intro)
**Concept:** Passing props down through many layers of components ("prop drilling") gets messy. Context lets you share a value (like a logged-in user) with any component that needs it, without passing it through every layer manually.

**Code example:**
```jsx
const UserContext = createContext(null);

function App() {
  return (
    <UserContext.Provider value={{ name: "Ada" }}>
      <Profile />
    </UserContext.Provider>
  );
}

function Profile() {
  const user = useContext(UserContext);
  return <p>{user.name}</p>;
}
```

**Try it:** Create a Context for a theme (light/dark) and read it from a nested component.

**Check-in:** What problem does Context mainly solve?
- A) Making components render faster
- B) Avoiding passing the same prop through many layers of components ✓
- C) Replacing useState entirely
- D) Styling components

**Common mistake:** Reaching for Context for every piece of state — it's best for genuinely global data (logged-in user, theme), not for state that only one or two components actually need.

**Assignment 4:** Extend your Module 3 capstone todo app: add a route so it has a separate "Stats" page (routing), fetch the initial todos from a fake API endpoint instead of hardcoding them (data fetching), and use a controlled input for adding new todos (forms). Pass criteria: routing works, data loads from a fetch call, form input is properly controlled.

---

## Module 5 — Deploying Your Project (GitHub + Vercel)

### Lesson 5.1 — What GitHub is and why you need it
**Concept:** GitHub stores your code online with version history, and it's how deployment tools like Vercel know what to actually deploy — Vercel connects directly to a GitHub repository.

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

**Check-in:** What is GitHub mainly used for here?
- A) Running your app
- B) Storing your code online so deployment tools can access it ✓
- C) Styling your app
- D) Writing your code for you

**Common mistake:** Forgetting to run `git add .` before `git commit` — nothing gets committed if it was never staged first.

### Lesson 5.2 — Deploying to Vercel
**Concept:** Vercel is a free hosting platform built specifically for projects like React apps — it connects to your GitHub repo and automatically builds and deploys your site.

**Try it — numbered steps:**
1. Go to vercel.com and sign up (you can sign up directly with your GitHub account)
2. Click "Add New Project"
3. Select your GitHub repository
4. Vercel auto-detects it's a Vite/React project — leave the default settings
5. Click "Deploy"
6. After a minute, you'll get a live URL your project is running on

**Check-in:** What does Vercel need in order to deploy your project?
- A) A payment method
- B) Access to your GitHub repository ✓
- C) A separate server you set up yourself
- D) Nothing, it deploys automatically with no setup

**Common mistake:** Making changes locally and expecting the live site to update — you need to `git push` your changes to GitHub for Vercel to pick them up and redeploy automatically.

**Assignment 5 (Capstone extension):** Push your Module 4 project to GitHub and deploy it live on Vercel. Share the live URL. Pass criteria: the live URL works and reflects the current version of the project.
