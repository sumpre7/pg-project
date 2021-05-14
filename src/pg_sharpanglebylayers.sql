--  多图层尖锐角检查
CREATE OR REPLACE FUNCTION public.pg_sharpanglebylayers(checkuniqueid text,displayname text,relationlayers text[],fieldname text,radian float)
    RETURNS SETOF RECORD  AS $$
DECLARE
    number_relationlayer integer := array_length(relationlayers, 1);
    ii integer :=1;
BEGIN
    FOR  ii IN 1..number_relationlayer LOOP
            if( to_regclass(relationlayers[ii]) is not null ) then
                RETURN QUERY EXECUTE
                'select '||checkuniqueid||','||displayname||' ,'''||relationlayers[ii]||''' as layer , diit_sharp_angle( '||fieldname||' , '||radian||' )
                from '||relationlayers[ii]||'
                where pg_sharp_angle( '||fieldname||' , '||radian||' ) is not null';
                end if;

        END LOOP;
END;
$$ language 'plpgsql';