--  传入图层名及待检查和容差精度的空间字段  包含返回面积 来判断
-- SELECT * FROM diit_pointoverlapsbylayers('checkuniqueid','zcqcbsm','{xzq,cbgstj}','the_geom') t
-- (checkuniqueid INT,referenceCheckentityCheckuniqueid INT,zcqcbsm NUMERIC,refzcqcbsm varchar,layer TEXT,reflayer TEXT);
--  传入图层名及待检查和容差精度的空间字段  包含返回面积 来判断
CREATE OR REPLACE FUNCTION public.pg_pointoverlapsbylayers(checkuniqueid text,displayname text,relationlayers text[],fieldname text)
    RETURNS SETOF RECORD  AS $$
DECLARE
    number_relationlayer integer := array_length(relationlayers, 1);
    relationlayer_index integer := 1;
    ii integer :=1;
BEGIN
    FOR  ii IN 1..number_relationlayer LOOP
            relationlayer_index = 1;
            WHILE  relationlayer_index <= number_relationlayer LOOP
                    relationlayer_index = relationlayer_index + 1;
                    if( to_regclass(relationlayers[ii]) is not null and  to_regclass(relationlayers[relationlayer_index]) is not null and ii != relationlayer_index  ) then
                        RETURN QUERY EXECUTE
                        'select a.'||checkuniqueid||',b.'||checkuniqueid||' as referenceCheckentityCheckuniqueid ,
                        a.'||displayname||' as zcqcbsm  , b.'||displayname||' as refzcqcbsm ,
                        '''||relationlayers[ii]||''' as layer , '''||relationlayers[relationlayer_index]||''' as reflayer
                        from '||relationlayers[ii]||' a inner join '||relationlayers[relationlayer_index]||' b on  st_isvalid(a.'||fieldname||') and st_isvalid(b.'||fieldname||') and
                        st_intersects(a.'||fieldname||',b.'||fieldname||')
                        ';
                     end if;

            END LOOP;
        END LOOP;
END;
$$ language 'plpgsql';