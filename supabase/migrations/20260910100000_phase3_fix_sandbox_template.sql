-- The demo sandbox is plain HTML/CSS with no JS entry point — Sandpack's
-- "vanilla" template expects one and was silently merging in its own
-- default files. "static" is the right template for a plain HTML preview.

update public.sections set sandbox_template = 'static' where sandbox_files is not null;
