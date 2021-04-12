-- 尖锐角执行规则 （传入 geometey ,尖锐角 （弧度））
create or replace function pg_sharp_angle(geo1 geometry,deg1 float)
returns VARCHAR AS $$
DECLARE
	 degrees1 float := 0.0;
	 res text;
	 py geometry;
	 pt geometry;
	 p0 geometry;
	 p1 geometry;
	 p2 geometry;
BEGIN
    for py in SELECT (ST_DumpRings((ST_Dump(geo1)).geom)).geom LOOP
        p0 = NULL;
        p1 = NULL;
        p2 = NULL;
		for pt in SELECT (ST_DumpPoints(py)).geom LOOP
		 IF p0 is null then
			p0 = pt;
		 ELSIF p1 is null THEN
			p1 = pt;
		 ELSIF p2 is null THEN
			p2 = pt;
			degrees1 = st_angle(p0, p1, p2);
				 IF(degrees1 < deg1 or degrees1 > (6.2831855-deg1)) THEN
						res = st_astext(p1);
						RETURN  res;
					END IF;
		 else
			p0 = p1;
			p1 = p2;
			p2 = pt;
			degrees1 = st_angle(p0, p1, p2);
				 IF(degrees1 < deg1 or degrees1 > (6.2831855-deg1)) THEN
						res = st_astext(p1);
						RETURN  res;
					END IF;
			END if;
		 END LOOP;

	END LOOP;


 RETURN res;
END;
$$ LANGUAGE plpgsql;