alter table public.bundles
  add column audience text;

update public.bundles set audience = case slug
  when 'frontend' then 'For beginners who want to build the visual, interactive part of any website or app.'
  when 'backend' then 'For beginners who want to build the logic, data, and APIs behind an app.'
  when 'full-stack' then 'For anyone who wants the complete picture — frontend and backend, start to finish.'
  when 'python' then 'For first-time programmers who want a clean, readable language to start with.'
  when 'javascript' then 'For anyone starting out who wants the one language that runs everywhere on the web.'
  when 'php' then 'For beginners who want a fast, practical path to a working dynamic website.'
end
where slug in ('frontend', 'backend', 'full-stack', 'python', 'javascript', 'php');
