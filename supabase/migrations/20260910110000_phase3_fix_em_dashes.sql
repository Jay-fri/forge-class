-- Replace em dashes in Phase 3 quiz explanation copy, same cleanup as the
-- Phase 1 pass over bundle/lesson content.

update public.section_quizzes
set explanation = '<body> holds everything visible: text, images, buttons. <head> holds page info that isn''t shown.'
where explanation like '%<body> holds everything visible —%';

update public.section_quizzes
set explanation = 'Reach for const first, only use let when you know the value will be reassigned.'
where explanation like '%Reach for const first —%';
