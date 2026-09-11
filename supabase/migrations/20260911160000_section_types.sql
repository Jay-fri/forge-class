-- Tags each section with the kind of content block it represents, so the
-- lesson UI can render each distinctly (concept prose, syntax-highlighted
-- code example, an actionable "try it" callout, a quiz-backed check-in,
-- or a warning-styled common mistake) instead of uniform plain text.
-- Matches the block types used by the real course content files in
-- /courses (course-html.md, course-css.md, etc).

alter table public.sections
  add column if not exists section_type text not null default 'concept';

alter table public.sections
  add constraint sections_section_type_check
  check (section_type in ('concept', 'code_example', 'try_it', 'check_in', 'common_mistake'));
