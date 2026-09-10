-- Forge Phase 3 — demo content proving the interactive sandbox + quiz
-- checks actually work end to end, on top of the existing seeded track.

update public.sections s
set sandbox_template = 'vanilla',
    sandbox_files = jsonb_build_object(
      '/index.html', $html$<h1>Hello, world</h1>
<p>Edit this and watch the preview update.</p>
$html$
    )
from public.lessons l join public.modules m on m.id = l.module_id
where s.lesson_id = l.id and m.slug = 'html-basics' and l.slug = 'your-first-web-page'
  and s.title = 'What HTML actually does';

insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id,
  'Which tag holds everything visible on the page?',
  '["<head>", "<body>", "<html>", "<title>"]'::jsonb,
  1,
  '<body> holds everything visible — text, images, buttons. <head> holds page info that isn''t shown.',
  0
from public.sections s
join public.lessons l on l.id = s.lesson_id
join public.modules m on m.id = l.module_id
where m.slug = 'html-basics' and l.slug = 'your-first-web-page' and s.title = 'What HTML actually does';

insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id,
  'Which keyword should you reach for first when declaring a variable?',
  '["var", "let", "const", "function"]'::jsonb,
  2,
  'Reach for const first — only use let when you know the value will be reassigned.',
  0
from public.sections s
join public.lessons l on l.id = s.lesson_id
join public.modules m on m.id = l.module_id
where m.slug = 'javascript-basics' and l.slug = 'variables-and-values' and s.title = 'Storing a value';
