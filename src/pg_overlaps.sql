--  传入图层名及待检查和容差精度的空间字段  包含返回面积 来判断
CREATE OR REPLACE FUNCTION public.pg_overlaps(layername text,fieldname text,tolerance float)
RETURNS SETOF RECORD  AS $$
BEGIN
	RETURN  QUERY EXECUTE
	'select a.fid as aid,b.fid as bid
  from '||layername||' a inner join '||layername||' b on  st_isvalid(a.'||fieldname||') and st_isvalid(b.'||fieldname||') and
  st_intersects(a.'||fieldname||',b.'||fieldname||')
		 where a.fid < b.fid
and ST_Area(ST_SnapToGrid(st_intersection(a.'||fieldname||',b.'||fieldname||'),'||tolerance||')) >0 ';
	return ;
END;
$$ language 'plpgsql';