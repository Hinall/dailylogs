select count(t1.build_id)  from
	 public.shp_building_footprint t1
	join public.tbl_tagged_buildings t2  ON t2.building_id = t1.build_id
    JOIN public.tbl_tagged_properties t3 ON t3.building_id = t2.building_id
    where   t3.property_no not in (select property_no from  public.tbl_outstanding_amount) and  t3.property_no=''
	limit 10
	
	select building_id ,property_no,* from public.tbl_tagged_properties where building_id='Z3-W45-00050'
	
	select count(building_id)  from public.tbl_tagged_properties t1   where  property_no not in  
	(select t1.property_no from  public.tbl_outstanding_amount t2 join  public.tbl_tagged_properties on t2.property_no=t1.property_no)
	
	
	select count(building_id)   from public.tbl_tagged_properties   where  property_no!=''and property_no not in  
	(select t1.property_no from  public.tbl_outstanding_amount t1 join  public.tbl_tagged_properties t2 on t2.property_no=t1.property_no
	join   public.shp_building_footprint t3 on t3.build_id=t2.building_id) limit 100
	
		
	select count(build_id)   from public.shp_building_footprint t3 left join public.tbl_tagged_properties t4 on t4.building_id=t3.build_id   where  property_no=''or property_no not in 
	(select t1.property_no from  public.tbl_outstanding_amount t1  join public.tbl_tagged_properties t2 on t2.property_no=t1.property_no
	 inner join   public.shp_building_footprint t3 on t3.build_id=t2.building_id) limit 100
	 
	 SELECT COUNT(t3.build_id)
FROM public.shp_building_footprint t3
LEFT JOIN public.tbl_tagged_properties t4 ON t4.building_id = t3.build_id
WHERE t4.property_no ='' OR t4.property_no NOT EXISTS (
    SELECT t1.property_no
    FROM public.tbl_outstanding_amount t1
    JOIN public.tbl_tagged_properties t2 ON t2.property_no = t1.property_no
    JOIN public.shp_building_footprint t3 ON t3.build_id = t2.building_id
    WHERE t2.building_id = t4.building_id
);

SELECT COUNT(t3.build_id)
FROM public.shp_building_footprint t3
LEFT JOIN public.tbl_tagged_properties t4 ON t4.building_id = t3.build_id
WHERE t4.property_no NOT EXISTS (
    SELECT 1
    FROM public.tbl_outstanding_amount t1
    JOIN public.tbl_tagged_properties t2 ON t2.property_no = t1.property_no
    JOIN public.shp_building_footprint t3 ON t3.build_id = t2.building_id
    WHERE t2.building_id = t4.building_id
);

SELECT COUNT(t3.build_id)
FROM public.shp_building_footprint t3
LEFT JOIN public.tbl_tagged_properties t4 ON t4.building_id = t3.build_id
WHERE NOT EXISTS (
    SELECT 1
    FROM public.tbl_outstanding_amount t1
    JOIN public.tbl_tagged_properties t2 ON t2.property_no = t1.property_no
    WHERE t2.building_id = t4.building_id
);

SELECT t3.build_id
FROM public.shp_building_footprint t3
LEFT JOIN public.tbl_tagged_properties t4 ON t4.building_id = t3.build_id
WHERE t4.property_no IS NOT NULL 
AND NOT EXISTS (
    SELECT t1.property_no
    FROM public.tbl_outstanding_amount t1
    JOIN public.tbl_tagged_properties t2 ON t2.property_no = t1.property_no
    WHERE t2.building_id = t4.building_id
)limit 10;

select count(*) from  public.shp_building_footprint

	 --248301
	 --null + exclude=153801,154125
	 --null=?,153801,153787*,63372  | !133473
	 --exclude=154122,125624,188996