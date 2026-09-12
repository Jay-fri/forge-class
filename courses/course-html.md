# Forge Course: HTML

## Module 1 — What HTML Is

### Lesson 1.1 — What is HTML?
**Concept:** HTML stands for HyperText Markup Language. It's not a programming language — it's a markup language, meaning it describes the *structure* of a page: what's a heading, what's a paragraph, what's a list. Every website you've ever visited has HTML underneath it.

**Code example:**
```html
<h1>Hello, World</h1>
```
This tells the browser: "this text is a big heading."

**Try it:** Change "Hello, World" to your own name and see it appear.

**Check-in:** What does HTML mainly describe?
- A) How a page looks (colors, fonts)
- B) The structure and content of a page ✓
- C) How a page behaves when clicked
- D) How fast a page loads

**Common mistake:** Typing `<H1>` in uppercase works too (HTML tags aren't case-sensitive), but lowercase is the standard everyone uses — mixing cases makes code harder to read, not broken.

### Lesson 1.2 — What can HTML actually do?
**Concept:** HTML lets you add: text (headings, paragraphs), lists, images, links to other pages, forms (like sign-up boxes), tables, and more. Anything you *see* as content on a page — HTML put it there.

**Code example:**
```html
<h1>My Page</h1>
<p>This is a paragraph of text.</p>
```

**Try it:** Add a second paragraph below the first one.

**Check-in:** Which of these is something HTML can create?
- A) A list of items ✓
- B) A button's click animation
- C) A page's background color
- D) A database

**Common mistake:** Forgetting that HTML alone can't make a page colorful or animated — that's CSS and JavaScript's job. HTML is just structure.

### Lesson 1.3 — What is a tag?
**Concept:** A tag is the smallest building block of HTML. It's a keyword wrapped in angle brackets, like `<p>`. Most tags come in pairs — an opening tag `<p>` and a closing tag `</p>` — with your content sandwiched between them.

**Code example:**
```html
<p>This whole sentence is inside a paragraph tag.</p>
```

**Try it:** Wrap any sentence of your own in `<p>` and `</p>`.

**Check-in:** What's the difference between `<p>` and `</p>`?
- A) No difference
- B) `<p>` opens the tag, `</p>` closes it ✓
- C) `<p>` is for paragraphs, `</p>` is for pages
- D) `</p>` is optional and never needed

**Common mistake:** Forgetting the closing tag. The browser often still displays something, but everything after it can end up nested inside by accident — always close what you open.

### Lesson 1.4 — Examples of tags
**Concept:** Here's a quick reference table of common tags you'll use constantly:

| Tag | What it's for |
|---|---|
| `<h1>` to `<h6>` | Headings, h1 = biggest |
| `<p>` | Paragraph |
| `<a>` | Link |
| `<img>` | Image |
| `<ul>` / `<ol>` | Lists |

**Code example:**
```html
<h1>My Recipe Blog</h1>
<p>Welcome to my blog about cooking.</p>
```

**Try it:** Build a mini page with one heading and two paragraphs.

**Check-in:** Which tag makes the biggest heading?
- A) `<h6>`
- B) `<h1>` ✓
- C) `<p>`
- D) `<big>`

**Common mistake:** Using `<h1>` for every heading on a page because it looks bold — headings should go in size order (h1 → h2 → h3) to describe importance, not just appearance.

**Assignment 1:** Build a simple page with one `<h1>` heading and three `<p>` paragraphs introducing yourself. Pass criteria: valid tags, properly opened and closed, content makes sense.

---

## Module 2 — Structuring Text

### Lesson 2.1 — Headings
**Concept:** Headings (`<h1>` through `<h6>`) create a hierarchy — like a book's chapter and section titles. `<h1>` is the main title of a page, and you should generally only use one per page.

**Code example:**
```html
<h1>My Website</h1>
<h2>About Me</h2>
<h3>My Hobbies</h3>
```

**Try it:** Create a heading structure for a page about your favorite hobby.

**Check-in:** How many `<h1>` tags should a typical page have?
- A) As many as you want
- B) Usually just one ✓
- C) Exactly six
- D) Zero

**Common mistake:** Skipping heading levels (going from h1 straight to h4) — it breaks the logical structure even if it still looks fine visually.

### Lesson 2.2 — Paragraphs and basic text
**Concept:** The `<p>` tag holds regular text. Inside a paragraph, you can also make text **bold** with `<strong>` or *italic* with `<em>`.

**Code example:**
```html
<p>This is <strong>important</strong> and this is <em>emphasized</em>.</p>
```

**Try it:** Write a paragraph about your day, bolding one word and italicizing another.

**Check-in:** Which tag makes text bold?
- A) `<b-text>`
- B) `<strong>` ✓
- C) `<bold>`
- D) `<h1>`

**Common mistake:** Pressing Enter/adding blank lines in your HTML code to create spacing — the browser ignores extra line breaks and spaces. You need actual tags to control layout.

### Lesson 2.3 — Lists
**Concept:** Two types of lists: `<ul>` (unordered, bullet points) and `<ol>` (ordered, numbered). Each item inside goes in an `<li>` tag.

**Code example:**
```html
<ul>
  <li>Milk</li>
  <li>Eggs</li>
  <li>Bread</li>
</ul>
```

**Try it:** Make an `<ol>` numbered list of your top 3 favorite movies.

**Check-in:** What tag goes inside `<ul>` or `<ol>` for each item?
- A) `<item>`
- B) `<li>` ✓
- C) `<list>`
- D) `<p>`

**Common mistake:** Putting text directly inside `<ul>` without wrapping each item in `<li>` — the list won't display correctly.

**Assignment 2:** Build a page with a heading structure (h1 + h2), two paragraphs with at least one bold and one italic word, and a bulleted list of 4 items. Pass criteria: correct tag usage, sensible heading hierarchy.

---

## Module 3 — Links, Images, Structure & Forms

### Lesson 3.1 — Links and images
**Concept:** The `<a>` tag creates a clickable link, using `href` to say where it goes. The `<img>` tag displays a picture, using `src` to say which file.

**Code example:**
```html
<a href="https://example.com">Visit this site</a>
<img src="cat.jpg" alt="A photo of a cat">
```

**Try it:** Add a link to your favorite website and an image (any image URL).

**Check-in:** What does `alt` do on an `<img>` tag?
- A) Makes the image bigger
- B) Describes the image for accessibility and if it fails to load ✓
- C) Adds a border
- D) Nothing important

**Common mistake:** Forgetting `<img>` doesn't need a closing tag like `</img>` — it's self-contained. Writing `</img>` isn't necessary and can confuse things.

### Lesson 3.2 — Basic page structure
**Concept:** Now that tags feel familiar, every real HTML page follows this skeleton: `<html>` wraps everything, `<head>` holds page info (like the title, invisible on the page itself), and `<body>` holds everything visible.

**Code example:**
```html
<!DOCTYPE html>
<html>
  <head>
    <title>My Page</title>
  </head>
  <body>
    <h1>Welcome</h1>
  </body>
</html>
```

**Try it:** Wrap everything you've built so far in this skeleton.

**Check-in:** Where does visible page content go?
- A) `<head>`
- B) `<body>` ✓
- C) `<title>`
- D) `<!DOCTYPE html>`

**Common mistake:** Putting visible content like `<h1>` inside `<head>` by accident — it won't show up on the page at all.

### Lesson 3.3 — Forms basics
**Concept:** Forms collect input from users — like a sign-up box. The `<form>` tag wraps input fields, and `<input>` creates a text box, checkbox, or button depending on its `type`.

**Code example:**
```html
<form>
  <input type="text" placeholder="Your name">
  <input type="submit" value="Send">
</form>
```

**Try it:** Add an email input field to the form above (`type="email"`).

**Check-in:** What attribute controls what kind of input box you get?
- A) `kind`
- B) `type` ✓
- C) `input-style`
- D) `field`

**Common mistake:** Forgetting `placeholder` is just grayed-out hint text — it disappears when the user types and isn't the same as a real default value.

**Assignment 3:** Build a full HTML page (with proper html/head/body structure) containing a heading, a short bio, a list of your skills, a link to a site you like, an image, and a small form with a name field. Pass criteria: correct page structure, all tags properly used.

---

## Module 4 — Capstone

### Capstone Assignment: Personal Profile Page
**Task:** Using everything from Modules 1–3, build a complete personal profile page — a real, working HTML page (no CSS needed yet) with:
- Proper `<html>/<head>/<body>` structure and a `<title>`
- One `<h1>` main heading with your name
- A short bio paragraph with at least one bold word
- A bulleted list of 3+ interests or skills
- At least one image and one link
- A simple contact form with a name and email field

**Pass criteria:** Page structure is valid, all tags open and close correctly, heading hierarchy makes sense, and every required element above is present and working.

---

## Module 5 — Semantic HTML, Tables & Accessibility

### Lesson 5.1 — Semantic HTML
**Concept:** Semantic tags describe *what* content is, not just how it's grouped — `<header>`, `<nav>`, `<section>`, `<article>`, `<footer>` mean something, unlike a plain `<div>`. This helps browsers, search engines, and assistive tech understand your page.

**Code example:**
```html
<header>
  <h1>My Blog</h1>
  <nav>
    <a href="#">Home</a>
    <a href="#">About</a>
  </nav>
</header>
<article>
  <h2>My First Post</h2>
  <p>Post content here.</p>
</article>
<footer>
  <p>© 2026 My Blog</p>
</footer>
```

**Try it:** Rebuild your profile page's structure using semantic tags instead of plain `<div>`s.

**Check-in:** What's the main benefit of semantic tags over `<div>`?
- A) They look different visually
- B) They describe the meaning of content, helping accessibility and search engines ✓
- C) They're faster to load
- D) There's no real benefit

**Common mistake:** Using `<div>` for everything out of habit — a `<div>` is a generic container with no meaning; reach for a semantic tag when one fits.

### Lesson 5.2 — Tables
**Concept:** Tables display data in rows and columns — use them for actual tabular data (like a schedule), not for page layout.

**Code example:**
```html
<table>
  <tr>
    <th>Name</th>
    <th>Track</th>
  </tr>
  <tr>
    <td>Ada</td>
    <td>JavaScript</td>
  </tr>
</table>
```

**Try it:** Build a table showing 3 of your favorite movies and their release years.

**Check-in:** What's the difference between `<th>` and `<td>`?
- A) No difference
- B) `<th>` is a header cell, `<td>` is a regular data cell ✓
- C) `<th>` is for images only
- D) `<td>` is deprecated

**Common mistake:** Using tables for page layout (like positioning a sidebar) — that's CSS's job (Flexbox/Grid); tables are for actual tabular data only.

### Lesson 5.3 — More form inputs and validation
**Concept:** Beyond text inputs: `radio` (pick one), `checkbox` (pick any), `select` (dropdown), `textarea` (multi-line text). Validation attributes like `required` and `type="email"` add built-in checks.

**Code example:**
```html
<select>
  <option value="js">JavaScript</option>
  <option value="py">Python</option>
</select>
<input type="checkbox"> I agree to the terms
<input type="email" required>
```

**Try it:** Build a form with a dropdown, a checkbox, and a required email field.

**Check-in:** What does `required` do on an input?
- A) Nothing without JavaScript
- B) Prevents form submission if the field is left empty ✓
- C) Hides the field
- D) Deletes the field's value

**Common mistake:** Forgetting `<option>` tags need a `value` — without it, the submitted value defaults to the option's visible text, which can cause mismatches with what your code expects.

### Lesson 5.4 — Embedding media & comments
**Concept:** `<video>` and `<audio>` embed media directly. HTML comments (`<!-- like this -->`) let you leave notes in your code that the browser ignores.

**Code example:**
```html
<video src="clip.mp4" controls></video>
<!-- This is a comment, it won't show on the page -->
```

**Try it:** Add a comment above one section of your page explaining what it does.

**Check-in:** Do HTML comments appear on the visible page?
- A) Yes, always
- B) No, they're invisible to visitors but visible in the code ✓
- C) Only in some browsers
- D) Only if styled

**Common mistake:** Using comments to "disable" large chunks of sensitive info thinking it's hidden — comments are still visible to anyone who views the page source, so never put secrets in them.

**Assignment 5:** Rebuild your capstone profile page using semantic tags throughout, add a table showing your skills and proficiency level, and add a form with at least one dropdown and one checkbox. Pass criteria: semantic tags used correctly, table displays properly, form inputs work.

---

## Module 6 — Deploying Your Project (GitHub + Vercel)

### Lesson 6.1 — Pushing your project to GitHub
**Concept:** GitHub stores your code online and is what deployment tools connect to.

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

**Check-in:** What do you need before you can push code to GitHub?
- A) A paid account
- B) A GitHub repository already created and connected as a remote ✓
- C) A live website already running
- D) Nothing else needed

**Common mistake:** Trying to push before creating the repository on GitHub's website first — the remote needs to already exist.

### Lesson 6.2 — Deploying to Vercel
**Concept:** Vercel hosts your HTML page online for free, connected directly to GitHub.

**Try it — numbered steps:**
1. Go to vercel.com, sign up with GitHub
2. Click "Add New Project," select your repository
3. Leave default settings for a plain HTML site
4. Click "Deploy"
5. Get your live URL

**Check-in:** What's the benefit of connecting Vercel to GitHub instead of uploading files manually?
- A) There's no benefit
- B) Every future push automatically redeploys your site ✓
- C) It's required, there's no other way
- D) It makes the page load faster

**Common mistake:** Expecting your live site to update after only saving changes locally — you must commit and push to GitHub first.

**Assignment 6 (Capstone extension):** Push your finished profile page to GitHub and deploy it live on Vercel. Share the live URL. Pass criteria: live URL works and shows the current version.
