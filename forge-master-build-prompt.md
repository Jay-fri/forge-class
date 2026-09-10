# Forge — Master Build Prompt (Phase by Phase)

## Product summary
Forge is an interactive coding education platform — like W3Schools, but simple, beautiful, and built for actual learning. Students read short lessons, run real code inline, ask an embedded AI when stuck, submit assignments, and track streaks/progress. Instructors (Joshua) grade submissions from a separate dashboard. Runs cohort-based, not self-paced.

## A note to Claude Code, before anything else
Joshua is trusting you with the design of this entire app — not just the landing page. Every screen, not only the hero, needs to hit a genuinely premium bar: real visuals instead of generic placeholders (screenshots/mockups where a product would actually show one, not blank icons or stock illustration), a custom icon set, smooth considered animation, and layouts that feel deliberately designed rather than assembled from default components. Treat "exceptional UI/UX designer" as the standard for the whole build, every phase, not a one-time instruction for Phase 1. Use the Relume component library (MCP tool available in this workspace) and real design research (Dribbble, Mobbin, Land-book, Awwwards) as inputs throughout — not just once at the start — and check them again whenever a new screen type comes up. If a screen ever risks looking generic, stop and look for better reference before shipping it.

## Brand reference (already decided — do not deviate without asking)
- **Name:** Forge
- **Mark:** abstract diamond/spark, single line weight, no fill except inner spark
- **Palette:** background `#0E1210`, surface `#171C19`, border `#232A24`, accent/action (gold) `#D9A75C`, success/completion (moss green) `#8FAE7A`, text primary `#F1F0EA`, text secondary `#9BA79B`
- **Type:** headings in Source Serif 4 (stand-in for Tiempos), body/UI in Hanken Grotesk (stand-in for Styrene), code in JetBrains Mono
- **Icons:** must be a custom-built icon set — no default icon libraries in the final product
- **Voice:** simple, minimal text per screen, no walls of text
- **Content standard:** every lesson must lean on arrows, tables, diagrams, flows, and numbered steps wherever they make something clearer — especially installation/setup instructions. Prose-only explanations are the fallback, not the default.
- **UI feel:** beautiful, highly interactive, smooth animated transitions throughout (section reveals, progress updates, streak moments, navigation). Text sizes generous and comfortable to read — never small or dense. The overall feel should be approachable and easy the way a well-designed kids' learning app is approachable — friendly shapes, warmth, clarity — without being literally gamified, cartoonish, or juvenile. Confidence-inspiring for a beginner, not intimidating like a raw dev tool.

## Interaction & navigation design (specific, not generic)
- **Color usage is split deliberately, not decorative**: gold = primary actions and momentum (Continue button, streak flame, Ask AI trigger); moss green = completion only (checkmarks, finished lessons, passed assignments). Don't blur this — two distinct "reward" colors is what makes progress *feel* rewarding.
- **Primary action button** (Continue/Next/Submit) stays fixed at the bottom of the screen on mobile, thumb-reachable — never top-right
- **Bottom tab navigation**, max 4–5 items (e.g. Home / Learn / Practice / Progress / Ask AI) — no hamburger menu as primary navigation
- **Lesson-card → lesson-view transition** should feel like the card expanding into the full view (shared-element/layout animation), not a hard page cut
- **Within a lesson**, support swipe left/right between sections in addition to a tap-to-continue button
- **Popups, two tiers — don't conflate them**: toast/banner (slides from top, auto-dismisses, non-blocking) for streak milestones and minor confirmations; true blocking modal only for things needing a decision (cohort-ending warning, admin announcements). Overusing blocking modals trains students to dismiss without reading.
- **Admin/instructor messages** shown to students should look human: small avatar/initials + "From Joshua" label, pinned at the top of the home feed — not buried in a notification bell
- **Completion animation** (lesson/track/certificate): restrained, not a confetti explosion and not an instant cut — checkmark draws itself in (SVG path animation), card gently scales/fades, a few subtle particles in gold/moss green, then a smooth transition into the certificate preview

## Access model (no payment gateway for v1)
- Landing page shows all course bundles with what's covered in each, designed to be interactive and genuinely sell the value — not a plain list
- Course bundles (v1): **Frontend**, **Backend**, **Full Stack**, **Python** (standalone), **JavaScript** (full/standalone), **PHP**
- On signup, the student picks the bundle they want, sees its price (editable anytime from the instructor's admin dashboard), and submits
- Account is created in a **pending approval** state — no access to lesson content yet
- Pending screen displays a WhatsApp number and instructions: message it to arrange payment
- Instructor manually approves the account (and grants access to the paid bundle) from the admin dashboard once payment is confirmed
- Instructor can change a student's bundle/access at any time (e.g. upgrading Python-only to Full Stack) from the same dashboard
- On upgrade: existing progress, streaks, badges, and submissions on tracks the student already had access to are preserved — the upgrade only adds newly unlocked tracks, nothing resets
- Automated payment (Flutterwave) stays a future option — see Phase 11 — this manual flow is the actual v1 plan

## Stack (aligned with Joshua's existing tooling)
- Frontend: React + Vite + TypeScript, PWA-enabled, mobile-first responsive
- Version control: GitHub
- Backend/DB/auth/storage: Supabase
- AI: Gemini API, model `gemini-3.1-flash-lite` specifically (Gemini 2.0 Flash is shut down as of June 2026 — do not use it or any 2.0 model ID) — embedded Q&A + "explain differently" per lesson section
- Code execution/preview: Sandpack (in-browser, no server execution needed for front-end lessons)
- Hosting: Vercel
- Payments (later phase): Flutterwave, if/when subscription tiers are added

---

## Phase 0 — Foundation
- Repo scaffold, design tokens (colors/type/spacing as CSS variables from brand reference above)
- Supabase schema v1: users (with role + approval status + assigned bundle), bundles (name, price, description), cohorts (start date, end date, per-cohort content-drop setting: weekly vs. all-at-once, status), tracks, lessons, sections, user_progress, streaks
- Cohort membership: each student belongs to a cohort per bundle; supports late-join with instructor-set waitlist/allow/late-fee decision per student
- Base routing/navigation shell (mobile-first, collapsible sidebar)
- Auth: sign up/log in (student role vs instructor role)

## Phase 1 — Landing page, bundles & approval flow
- Interactive landing page: showcases each bundle (Frontend/Backend/Full Stack/Python/JavaScript/PHP), what's covered, who it's for — this is the first impression, treat it like a real product marketing page, not a placeholder
- Hero section must include a realistic code-editor/IDE screenshot mockup (window chrome, file tabs, file tree, syntax-highlighted code) as the primary visual — this is the bar for "premium AI product" feel, not a generic illustration or stock photo. Joshua has a reference image to attach directly when starting this phase in Claude Code.
- Use the Relume component library (MCP tool available in this workspace) as a starting structural reference for the hero/landing sections — adapt fully to Forge's brand system, never leave it unstyled/default
- Signup flow: student picks a bundle, sees its price (pulled live from admin-editable bundle data), submits
- Pending-approval screen: clear messaging + WhatsApp number/link to arrange payment, shown until instructor approves
- Instructor bundle management (admin): create/edit bundles and prices, approve/reject pending signups, change a student's assigned bundle at any time
- Pending-approval screen includes one real, locked-teaser lesson preview students can explore while waiting — keeps them engaged instead of going cold during the wait
- On approval: WhatsApp group invite is sent automatically (not at signup) — access to full content and the group both unlock together
- Post-approval, first thing the student sees: a short screen-recorded video (Joshua's own recording) showing how the app works, before they land on lesson content

## Phase 2 — Curriculum structure
- Data model: Track → Module → Lesson → Section (supports HTML/CSS/JS/React/Python/backend/PHP, multiple levels: beginner/intermediate/advanced per track)
- Admin-only content entry flow (instructor can add/edit tracks, lessons, sections — even a simple internal form counts for v1)
- Seed 1 full track end-to-end (e.g. HTML/CSS/JS fundamentals) as the proof-of-concept track before building out the rest

## Phase 3 — Lesson experience
- Lesson page: short text sections, inline Sandpack code editor + live preview per relevant section
- Per-section audio is paused for now — see "Deferred / future" section at the end of this doc. Do not build it in this phase.
- "Ask AI" — Gemini-powered, context-aware to the current lesson/section, distinguishes between "explain differently" (rephrase current section) and open Q&A; also auto-explains code errors in plain language when a student's code breaks, rather than showing raw error output
- AI response formatting is a hard requirement, not a nice-to-have: responses must be genuinely explanatory (not terse one-liners), and any code in a response renders in a proper syntax-highlighted code block — distinct background, monospace (JetBrains Mono), color-coded syntax matching the brand palette — never plain unformatted text mixed into a paragraph. Long explanations should use short paragraphs, numbered steps, or inline emphasis where it aids scanning, matching the "content standard" in the brand reference above.
- Embedded quizzes/checks within lessons (not just at the end) — stronger for actual retention than passive reading alone
- Daily per-student cap on Gemini Q&A usage, to bound API cost
- Lightweight "this was confusing" / "found a typo" control on every section, feeding the admin Content Feedback queue
- Custom icon set applied throughout (replace any placeholder icons)

## Phase 4 — Progress & motivation
- Per-lesson and per-track completion tracking
- "Continue learning" — resumes exactly where the student left off, surfaced on home screen
- Streaks (daily activity tracking, streak-freeze consideration for missed days)
- Badges/achievements for milestones (first lesson, track completion, streak milestones)
- Certificate generation (simple downloadable/shareable image or PDF) on track completion
- Bookmarks/notes — student can save a section or leave a personal note on it

## Phase 5 — Assignments & submissions
- Instructor can attach an assignment to any lesson/module (spec + optional starter code)
- Student submits: code snippet, file upload, or link (e.g. deployed project), with optional written explanation
- Submission status states: submitted → in review → graded (with feedback text + score/pass-fail)
- Student sees assignment history and feedback in their own dashboard

## Phase 6 — Instructor dashboard
Home screen opens on what needs action right now (pending approvals count, pending grading count, inactive-student alerts) — not vanity metrics. Same design system as the student app, just denser — never a bolted-on generic admin template. Structure:
1. **Home** — pending approvals, pending grading, inactive-student alerts, quick stats
2. **Approvals** — search/select students, assign bundle + cohort, approve in as few taps as possible (bundle pre-filled from their signup); bulk approve once volume grows
3. **Cohorts** — create/manage cohorts per bundle (start/end dates, weekly-drip vs. all-at-once toggle per cohort), late-join decisions (waitlist / allow with note / optional late fee) per student
4. **Students** — roster, filters, individual profile (progress, streak, bundle/cohort history, submissions)
5. **Bundles & Pricing** — CRUD with live landing-page preview before saving
6. **Curriculum** — draft → publish content editor (never live-edit content under active students)
7. **Grading** — inbox-style: submission, lesson context, and feedback box together, with a "next" action to move straight to the next item
8. **Content Feedback** — student-reported confusing sections/typos, tied to the exact section
9. **Analytics** — completion rates, drop-off points, time-to-approval, grading turnaround, inactive students
10. **Audit Log** — every approval, bundle change, and content edit, with who/when
11. **Team/Roles** — owner vs. grader permissions, for when a TA is added later

## Phase 7 — Community / class group
- Per-lesson or per-track question thread (students can ask, instructor and peers can answer)
- Option to link out to an external group (WhatsApp/Discord) if in-app threading is out of scope for v1 — decide before building

## Phase 8 — Search, discovery, and home
- Search across all lesson content
- Home screen: continue learning, streak status, recommended next lesson, recent badges
- Track catalog view — browse all tracks/levels before enrolling

## Phase 9 — Notifications & engagement
- Push/in-app notifications: streak reminders, new feedback on submission, new content added
- In-app pop-up warnings as a student's cohort nears its end date, with access locking after end; email version deferred until a domain exists (see infra notes)
- Re-engagement nudges for inactive students

## Phase 10 — Mobile & responsiveness pass
- Full audit of every screen at phone width (this is a primary use case, not an afterthought)
- PWA install prompt, offline-friendly lesson caching where feasible

## Phase 11 — Automated payments (optional upgrade, not required for launch)
- Replace/supplement the manual WhatsApp approval flow with Flutterwave-based checkout, if and when wanted
- Access gating tied to payment status instead of manual approval
- Manual approval flow (Phase 1) should keep working as a fallback either way

## Phase 12 — Polish & launch
- Full custom icon set audit (zero default icons remaining)
- Micro-interactions pass (section reveal, streak animation, submission feedback moment)
- Motion/animation audit against the "UI feel" standard above — every key transition should feel smooth and considered, not instant/jarring
- Text-size audit — nothing should read as small or dense on any screen, mobile included
- Empty states, error states, loading states for every screen
- Final QA across devices

## Deferred / future (do not build now — keep for later)
- **Per-section audio** (TTS-generated, play button beside each section) — paused for now. When resumed: Google Cloud TTS free tier is ~4M characters/month for Standard/WaveNet voices, ~1M/month for higher-quality Neural2/Studio voices, resets monthly; generate once per section and cache in storage rather than regenerating per play
- **Placement/skip-ahead**: let students who already know material jump ahead instead of forcing lesson 1 for everyone
- **Shareable student portfolio page**: public-ish page showing a student's certificates/badges/completed tracks
- **Practice playground**: a freeform code sandbox outside of lessons
- **Anonymous option for community questions**: reduces the friction of asking "beginner" questions in the group
- **No refund policy** — decided, applies as-is at launch (not deferred, just noted here as a standing policy)

## Infra notes (from this session, keep in mind)
- Supabase free tier: watch storage (1GB) as the real ceiling — audio caching (once resumed) and file-upload assignment submissions will hit this before the database does
- No domain yet, so no reliable outbound email — rely on WhatsApp + in-app notifications as the real channels until a domain exists; don't build email reminders before then
- Gemini pay-as-you-go budget set at ₦3,000 to start on `gemini-3.1-flash-lite` — at this model's pricing that comfortably covers roughly 1,800+ Ask AI interactions; the per-student daily cap (Phase 3) is mainly to prevent one runaway user, not because the model is expensive

---

## Working notes for Claude Code sessions
- Build and verify one phase fully before starting the next — don't parallelize phases
- Every UI screen must be checked against the brand reference above before being marked done
- Flag any point where a default/generic component (icon, button shape, card style) was used as a placeholder, so it isn't missed in Phase 12
- **Design research is required, not optional**: before building any new screen type, look at real current design references online (Dribbble, Mobbin for real mobile app screenshots, Land-book, Awwwards) rather than generating purely from training-data defaults — this is what actually produces distinctive, current-feeling UI instead of generic output
- Where possible, work from an approved mockup (produced in chat with Joshua beforehand) rather than designing blind from text instructions alone — mockup-then-build is safer than describe-and-hope for anything visually important
- Reference apps for feel, not literal copying: onboarding/motivation moments should feel like Duolingo's momentum; dashboard density/calm should feel like Linear; the Ask AI chat should feel like a clean, modern messaging app — use these as a bar to check against, not a template to trace
