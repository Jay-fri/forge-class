-- Removes the original Phase 1/3 demo track ("HTML, CSS & JavaScript
-- Fundamentals") now that JavaScript Fundamentals is a real, fully-built
-- track and Frontend covers HTML/CSS/React. Cascades through modules,
-- lessons, sections, quizzes, progress, badges, and bookmarks tied to it.
-- Confirmed with the product owner before running given real completed
-- progress existed against this track.

delete from public.tracks where slug = 'web-fundamentals';
