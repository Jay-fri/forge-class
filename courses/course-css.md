# Forge Course: CSS

*Assumes the HTML course is already complete.*

## Module 1 — What CSS Is

### Lesson 1.1 — What is CSS?
**Concept:** CSS stands for Cascading Style Sheets. If HTML is the skeleton of a page, CSS is the skin, clothes, and makeup — it controls colors, fonts, spacing, and layout, without changing the actual content.

**Code example:**
```html
<p style="color: blue;">This text is blue.</p>
```

**Try it:** Change "blue" to another color name like "red" or "green."

**Check-in:** What does CSS control?
- A) The content of a page
- B) The appearance and layout of a page ✓
- C) The page's database
- D) What links point to

**Common mistake:** Confusing HTML tags with CSS properties — `<p>` is HTML (structure), `color: blue` is CSS (style). They work together but are different things.

### Lesson 1.2 — Connecting CSS to HTML (selectors)
**Concept:** Instead of styling one element at a time with `style=""`, real CSS lives separately and uses **selectors** to target elements — like saying "all paragraphs" or "the element with this specific name."

**Code example:**
```css
p {
  color: blue;
}
```
This one rule styles *every* paragraph on the page.

**Try it:** Write a selector rule that makes all `h1` headings a color of your choice.

**Check-in:** What does the selector `p` target?
- A) One specific paragraph
- B) Every `<p>` element on the page ✓
- C) Every element named "p"
- D) Nothing without more code

**Common mistake:** Forgetting the curly braces `{ }` around the styles — CSS rules always need them, and semicolons `;` after each property.

### Lesson 1.3 — Colors, fonts, and text styling
**Concept:** Common text properties: `color` (text color), `font-size`, `font-family` (which typeface), and `font-weight` (how bold).

**Code example:**
```css
h1 {
  color: darkgreen;
  font-size: 32px;
  font-family: Arial, sans-serif;
}
```

**Try it:** Style your page's `h1` with a custom color, size, and font.

**Check-in:** What does `font-size: 32px` control?
- A) The color of the text
- B) How large the text appears ✓
- C) The font's name
- D) The line spacing

**Common mistake:** Forgetting units on sizes — writing `font-size: 32` instead of `32px` will often be ignored by the browser.

**Assignment 1:** Take your HTML profile page and add a CSS section that changes the color and font of your heading and paragraph text. Pass criteria: at least 3 different CSS properties used correctly.

---

## Module 2 — Layout Fundamentals

### Lesson 2.1 — The box model
**Concept:** Every HTML element is secretly a rectangular box with four layers, from the inside out: **content** → **padding** (space inside the border) → **border** → **margin** (space outside the border, between elements).

**Code example:**
```css
div {
  padding: 16px;
  border: 2px solid black;
  margin: 20px;
}
```

**Try it:** Add padding and a border to a paragraph and see the space appear around the text.

**Check-in:** What's the difference between padding and margin?
- A) No difference
- B) Padding is inside the border, margin is outside it ✓
- C) Padding is for text only
- D) Margin only works on images

**Common mistake:** Confusing padding and margin when trying to add space — if the *content itself* looks cramped, you want padding; if elements are too close to *each other*, you want margin.

### Lesson 2.2 — Flexbox layout
**Concept:** Flexbox arranges items in a row or column and makes spacing/alignment easy. You turn a container into a "flex container," and its children line up automatically.

**Code example:**
```css
.container {
  display: flex;
  gap: 12px;
}
```

**Try it:** Wrap three of your elements in a container and apply `display: flex` to line them up side by side.

**Check-in:** What does `display: flex` do to a container's children?
- A) Hides them
- B) Arranges them in a flexible row or column ✓
- C) Deletes extra spacing
- D) Makes them bold

**Common mistake:** Applying `display: flex` to the wrong element — it affects how a container arranges its *children*, not how the container itself looks.

### Lesson 2.3 — Grid layout
**Concept:** Grid is Flexbox's sibling for two-dimensional layouts — rows *and* columns at once, useful for things like photo galleries or dashboards.

**Code example:**
```css
.gallery {
  display: grid;
  grid-template-columns: 1fr 1fr 1fr;
  gap: 10px;
}
```
This creates 3 equal-width columns.

**Try it:** Change `1fr 1fr 1fr` to `1fr 1fr` and see it become 2 columns instead.

**Check-in:** What does `grid-template-columns: 1fr 1fr 1fr` create?
- A) One column
- B) Three equal-width columns ✓
- C) Three rows
- D) A single box

**Common mistake:** Using Grid when Flexbox would be simpler — Grid shines for full layouts (rows + columns together); Flexbox is usually enough for a single row or column of items.

**Assignment 2:** Rebuild your profile page's list of skills as a flex row of "cards" (small boxes with padding and a border, spaced with `gap`). Pass criteria: uses flexbox correctly, spacing looks intentional.

---

## Module 3 — Responsive Basics

### Lesson 3.1 — Why phones need different styling
**Concept:** A layout that looks great on a laptop screen can break on a phone — three columns squished into a small screen becomes unreadable. Responsive design means adjusting styles based on screen size.

**Concept:** The fix is a **media query** — a CSS rule that only applies under certain conditions, like "screen is narrower than 600px."

**Code example:**
```css
@media (max-width: 600px) {
  .gallery {
    grid-template-columns: 1fr;
  }
}
```
This switches the gallery to a single column on small screens.

**Try it:** Add a media query that changes your heading's font size on small screens.

**Check-in:** What does `@media (max-width: 600px)` mean?
- A) The screen must be exactly 600px
- B) The rule only applies when the screen is 600px wide or narrower ✓
- C) It only works on phones specifically
- D) It disables the layout entirely

**Common mistake:** Writing responsive styles as an afterthought instead of testing on a narrow screen as you go — issues are much easier to catch early.

**Assignment 3 (Capstone):** Take your full HTML profile page and fully style it with CSS: colors, fonts, spacing (box model), a flexbox or grid layout for your skills/interests section, and at least one media query so it adapts on a narrow screen. Pass criteria: page looks intentionally designed, layout doesn't break on a small screen width, uses box model + flex/grid + a media query correctly.

---

## Module 4 — Positioning, States & Polish

### Lesson 4.1 — Positioning
**Concept:** The `position` property controls how an element is placed. `static` (default, normal flow), `relative` (shifted from its normal spot), `absolute` (positioned relative to the nearest positioned ancestor), `fixed` (stays put on scroll), `sticky` (normal until a scroll point, then fixed).

**Code example:**
```css
.badge {
  position: absolute;
  top: 10px;
  right: 10px;
}
```

**Try it:** Position a small "New" badge in the corner of a card element.

**Check-in:** Which position value keeps an element fixed on screen even while scrolling?
- A) `static`
- B) `fixed` ✓
- C) `relative`
- D) `inherit`

**Common mistake:** Using `position: absolute` without a positioned parent (`position: relative` on the parent) — the element ends up positioned relative to the whole page instead of the intended container.

### Lesson 4.2 — Pseudo-classes and pseudo-elements
**Concept:** Pseudo-classes target an element's *state* (like `:hover` when a mouse is over it). Pseudo-elements target a *part* of an element (like `::before` to insert content).

**Code example:**
```css
button:hover {
  background: darkblue;
}
li:nth-child(2) {
  color: red;
}
p::before {
  content: "→ ";
}
```

**Try it:** Add a `:hover` style that changes a button's color when moused over.

**Check-in:** What does `:hover` target?
- A) Every element on the page
- B) An element while the mouse is over it ✓
- C) An element after it's clicked
- D) The page's background only

**Common mistake:** Confusing single colon (`:hover`, a state) with double colon (`::before`, a generated part) — modern CSS distinguishes them, though browsers are often lenient about it.

### Lesson 4.3 — CSS variables
**Concept:** CSS custom properties (variables) let you define a value once and reuse it everywhere — extremely useful for a consistent color palette.

**Code example:**
```css
:root {
  --accent-color: #D9A75C;
}
button {
  background: var(--accent-color);
}
```

**Try it:** Define a variable for your page's main accent color and use it in 2 different places.

**Check-in:** Where are CSS variables typically defined for global use?
- A) Inside every single element
- B) On `:root`, so they're available everywhere ✓
- C) Only in the `<head>`
- D) They can't be reused

**Common mistake:** Forgetting the `--` prefix when defining a variable, or forgetting `var()` when using it — both are required syntax.

### Lesson 4.4 — Transitions and basic animation
**Concept:** `transition` smoothly animates a property change (like a color shift on hover) instead of it happening instantly.

**Code example:**
```css
button {
  background: gray;
  transition: background 0.3s ease;
}
button:hover {
  background: darkblue;
}
```

**Try it:** Add a smooth transition to a card's shadow or scale when hovered.

**Check-in:** What does `transition: background 0.3s ease;` do?
- A) Instantly changes the background
- B) Smoothly animates background color changes over 0.3 seconds ✓
- C) Deletes the background
- D) Only works on hover

**Common mistake:** Putting the `transition` property only on `:hover` instead of the base state — this makes it transition smoothly *in* but snap back instantly when the hover ends.

### Lesson 4.5 — Units in depth
**Concept:** `px` is a fixed size. `%` is relative to the parent. `rem` is relative to the root font size (great for consistent, accessible scaling). `vh`/`vw` are relative to the viewport size — useful for full-screen sections.

**Concept table:**
| Unit | Relative to |
|---|---|
| `px` | Nothing — fixed |
| `%` | Parent element |
| `rem` | Root font size |
| `vh`/`vw` | Viewport height/width |

**Try it:** Change your page's font sizes from `px` to `rem` and see if anything looks different.

**Check-in:** Which unit is best for a section that should always be the full height of the screen?
- A) `px`
- B) `vh` ✓
- C) `%`
- D) `rem`

**Common mistake:** Using `px` for everything out of habit — it works, but `rem` scales better when a user changes their browser's default font size (an accessibility consideration).

### Lesson 4.6 — Specificity and the cascade
**Concept:** When multiple CSS rules target the same element, specificity decides which one "wins." Roughly, in order of increasing power: element selectors → class selectors → ID selectors → inline styles.

**Code example:**
```css
p { color: blue; }
.highlight { color: red; }
```
An element with `class="highlight"` shows red — the class selector is more specific than the plain element selector.

**Try it:** Create two conflicting rules for the same element and predict which one wins before checking.

**Check-in:** Which is generally more specific: a class selector or an element selector?
- A) Element selector
- B) Class selector ✓
- C) They're equal
- D) Depends on the file order only

**Common mistake:** Reaching for `!important` to force a style to win instead of understanding *why* it's losing — `!important` overrides everything and makes future debugging much harder; use it as a last resort, not a first fix.

**Assignment 4:** Take your Module 3 capstone page and add: a hover effect with a transition on at least one element, a CSS variable for your color palette used in at least 3 places, and fix any layout using `rem` instead of `px` for font sizes. Pass criteria: hover transition is smooth, variables are used correctly, sizing uses rem appropriately.
