--  多图层自相交检查
CREATE OR REPLACE FUNCTION public.pg_selfintersectionbylayers(checkuniqueid text,displayname text,relationlayers text[],fieldname text)
    RETURNS SETOF RECORD  AS $$
DECLARE
    number_relationlayer integer := array_length(relationlayers, 1);
    ii integer :=1;
BEGIN
    FOR  ii IN 1..number_relationlayer LOOP
        if( to_regclass(relationlayers[ii]) is not null ) then
            RETURN QUERY EXECUTE
            'SELECT '||checkuniqueid||' , '||displayname||','''||relationlayers[ii]||''' as layer  from '||relationlayers[ii]||'  where not ST_IsValid('||fieldname||') ';
        end if;

    END LOOP;
END;
$$ language 'plpgsql';