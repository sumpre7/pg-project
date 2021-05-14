--  多图层组合图斑检查
CREATE OR REPLACE FUNCTION public.pg_multipartbylayers(checkuniqueid text,displayname text,relationlayers text[],fieldname text)
    RETURNS SETOF RECORD  AS $$
DECLARE
    number_relationlayer integer := array_length(relationlayers, 1);
    ii integer :=1;
BEGIN
    FOR  ii IN 1..number_relationlayer LOOP
        if( to_regclass(relationlayers[ii]) is not null ) then
             RETURN QUERY EXECUTE
        'SELECT '||checkuniqueid||' , '||displayname||','''||relationlayers[ii]||''' as layer from (SELECT '||checkuniqueid||' , '||displayname||',multicount,SUM(CASE WHEN '||checkuniqueid||' is null THEN 0 ELSE 1 END) AS mcount from
        (SELECT '||checkuniqueid||', '||displayname||', cardinality((ST_Dump('||fieldname||')).path) as multicount FROM '||relationlayers[ii]||'
        )t GROUP BY '||checkuniqueid||' ,'||displayname||',multicount )t1 where t1.multicount >1  or t1.mcount >1 ';
        end if;

    END LOOP;
END;
$$ language 'plpgsql';