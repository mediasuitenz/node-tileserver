CREATE OR REPLACE FUNCTION escape_json (text) RETURNS text AS $$
SELECT replace($1, '"', '\"'); $$ LANGUAGE SQL IMMUTABLE;
 
 
CREATE OR REPLACE FUNCTION public.hstore2json(text) RETURNS text AS $$
SELECT escape_json($1) $$ LANGUAGE SQL IMMUTABLE;


CREATE OR REPLACE FUNCTION public.hstore2json(KEY text, value text) RETURNS text AS $$
SELECT '"' || hstore2json($1) || '": "' || hstore2json($2) || '"'; $$ LANGUAGE SQL IMMUTABLE;
 
 
CREATE OR REPLACE FUNCTION public.hstore2json(hstore) RETURNS text AS $$
SELECT '{' || array_to_string(array_agg(hstore2json(item.KEY, item.value)), ', ') || '}'
FROM each($1) item; $$ LANGUAGE SQL IMMUTABLE;
 
 
CREATE OR REPLACE FUNCTION public.hstore2json(text[]) RETURNS text AS $$
SELECT hstore2json(hstore($1)); $$ LANGUAGE SQL IMMUTABLE;

 
SELECT hstore2json(hstore(array[array['a', 'b'], array['c', 'd']])) two_dimensional_array_to_hstore_to_json,
hstore2json(array[array['a', 'b'], array['c', 'd']]) two_dimensional_array_to_to_json,
hstore2json(hstore(array['a', '"b"'], array['c', 'd'])) multi_array_to_hstore_to_json,
hstore2json(hstore(array['a', 'b', 'c', 'd'])) array_to_hstore_to_json,
hstore2json(array['a', 'b', 'c', 'd']) array_to_to_json;