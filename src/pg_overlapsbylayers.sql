--  传入图层名及待检查和容差精度的空间字段  包含返回面积 来判断
-- SELECT * FROM diit_overlapsbylayers1('checkuniqueid','bsm','{xzq,xzq1,xzq2}','the_geom',0.001) t
-- (checkuniqueid INT,referenceCheckentityCheckuniqueid INT,bsm NUMERIC,refbsm varchar,layer TEXT,reflayer TEXT);
CREATE OR REPLACE FUNCTION public.diit_overlapsbylayers(checkuniqueid text,displayname text,relationlayers text[],fieldname text,tolerance float)
    RETURNS SETOF RECORD  AS $$
DECLARE
    number_relationlayer integer := array_length(relationlayers, 1);
    relationlayer_index integer := 1;
    ii integer :=1;
    num integer :=1;
BEGIN
    FOR  ii IN 1..number_relationlayer-1 LOOP
            relationlayer_index = num;
            WHILE relationlayer_index <= number_relationlayer LOOP
                    relationlayer_index = relationlayer_index + 1;
                    RETURN QUERY EXECUTE
                    'select a.'||checkuniqueid||',b.'||checkuniqueid||' as referenceCheckentityCheckuniqueid ,
					 a.'||displayname||' as bsm  , b.'||displayname||' as refbsm ,
				  	'''||relationlayers[num]||''' as layer , '''||relationlayers[relationlayer_index]||''' as reflayer
						from '||relationlayers[num]||' a inner join '||relationlayers[relationlayer_index]||' b on  st_isvalid(a.'||fieldname||') and st_isvalid(b.'||fieldname||') and
						st_intersects(a.'||fieldname||',b.'||fieldname||')
					and ST_Area(st_intersection(a.'||fieldname||',b.'||fieldname||')) > '||tolerance||'';
                    relationlayer_index = relationlayer_index + 1;
                END LOOP;
            num = num +1;
        END LOOP;
END;
$$ language 'plpgsql';