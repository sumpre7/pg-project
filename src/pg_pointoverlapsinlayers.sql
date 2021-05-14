--  多图层自相交检查
CREATE OR REPLACE FUNCTION public.pg_pointoverlapsinlayers(checkuniqueid text,displayname text,relationlayers text[],fieldname text)
    RETURNS SETOF RECORD  AS $$
DECLARE
    number_relationlayer integer := array_length(relationlayers, 1);
    ii integer :=1;
BEGIN
    FOR  ii IN 1..number_relationlayer LOOP
        if( to_regclass(relationlayers[ii]) is not null ) then
            RETURN QUERY EXECUTE
            'select a.'||checkuniqueid||',b.'||checkuniqueid||' as referenceCheckentityCheckuniqueid ,
            a.'||displayname||' as zcqcbsm  , b.'||displayname||' as refzcqcbsm ,
            '''||relationlayers[ii]||''' as layer , '''||relationlayers[ii]||''' as reflayer
            from '||relationlayers[ii]||' a inner join '||relationlayers[ii]||' b on  st_isvalid(a.'||fieldname||') and st_isvalid(b.'||fieldname||') and
            a.fid < b.fid and st_intersects(a.'||fieldname||',b.'||fieldname||') ';
        end if;

    END LOOP;
END;
$$ language 'plpgsql';