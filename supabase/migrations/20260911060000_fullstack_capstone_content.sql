-- Full Stack capstone module built out. The two "foundations" modules
-- stay pointers to the Frontend and Backend tracks (published instead of
-- draft); this fills in the final capstone lesson that ties them together.


update public.lessons l set status = 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'full-stack' and m.slug = 'frontend-foundations' and l.slug = 'this-module-draws-on-the-frontend-track';


update public.lessons l set status = 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'full-stack' and m.slug = 'backend-foundations' and l.slug = 'this-module-draws-on-the-backend-track';


update public.lessons l set status = 'published'
from public.modules m join public.tracks t on t.id = m.track_id
where l.module_id = m.id and t.slug = 'full-stack' and m.slug = 'final-capstone' and l.slug = 'combining-frontend-and-backend-into-one-product';


delete from public.sections s
using public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where s.lesson_id = l.id and t.slug = 'full-stack' and m.slug = 'final-capstone' and l.slug = 'combining-frontend-and-backend-into-one-product';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$From two tracks to one product$md$, $md$Everything up to this point has been building blocks: HTML, CSS, JavaScript, and React from the Frontend track, servers, databases, and APIs from the Backend track. This capstone is where they become one real, working product.

The shape of a full-stack app is always the same three pieces talking to each other:

```
Frontend (React)  <-->  API (Express)  <-->  Database (Supabase)
```

The frontend never touches the database directly. It asks the API for what it needs, the API talks to the database, and the response flows back up.$md$, 0
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'full-stack' and m.slug = 'final-capstone' and l.slug = 'combining-frontend-and-backend-into-one-product';


insert into public.section_quizzes (section_id, question, options, correct_index, explanation, order_index)
select s.id, $md$In a typical full-stack app, which piece talks directly to the database?$md$, '["The frontend","The API/backend","Both equally","Neither, the browser connects directly"]'::jsonb, 1, $md$The backend/API is the only piece that should talk to the database directly. The frontend goes through the API, never around it.$md$, 0
from public.sections s join public.lessons l on l.id = s.lesson_id join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'full-stack' and m.slug = 'final-capstone' and l.slug = 'combining-frontend-and-backend-into-one-product' and s.title = 'From two tracks to one product';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$A suggested build order$md$, $md$Building all three pieces at once is a common way to get stuck. A more reliable order:

1. Build the database table (a todos table: text, done, created_at)
2. Build the API on top of it, and test every route with a tool like curl or Postman before touching the frontend at all
3. Build the frontend against a working API you have already confirmed is correct

By the time you write frontend code, you already know the backend works. Bugs are much easier to find when you are only debugging one layer at a time.$md$, 1
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'full-stack' and m.slug = 'final-capstone' and l.slug = 'combining-frontend-and-backend-into-one-product';


insert into public.sections (lesson_id, title, content, order_index)
select l.id, $md$Ready for the capstone$md$, $md$The assignment on this module is the flagship project of the entire curriculum: a real, persisted, full-stack todo app. Treat it like a real product, not a school exercise. Take your time, and use Ask AI if you get stuck on any single piece.$md$, 2
from public.lessons l join public.modules m on m.id = l.module_id join public.tracks t on t.id = m.track_id
where t.slug = 'full-stack' and m.slug = 'final-capstone' and l.slug = 'combining-frontend-and-backend-into-one-product';
