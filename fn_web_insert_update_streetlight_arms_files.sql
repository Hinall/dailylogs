
CREATE OR REPLACE FUNCTION public.fn_web_insert_update_streetlight_arms(
	jsonarray text)
    RETURNS TABLE(data text) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE

	_gid integer;
	_pole_id text;
	_smart_asse text;
	_pole_type text;
	_arrangemen text;
	_bracket_ty text;
	_pole_heigh  double precision;
	_date_of_in text;
	_cost  double precision;
	_pole_owner text;
	_maintained text;
	_last_paint text;
	_number_of_ text;
	_number_of1 text;
	_ploe_light text;
	_geom text;
	_fitting_wa double precision,
	
	_street_arm_id integer;
	_position text;
	_status Boolean;
	_width integer;
	_status_ON_OFF text;
	_street_light_arms_data text;
	
	jsonObject JSON;
	pole_arms_json JSON
	json JSON;
	sql_query text;
	i json;
			
	BEGIN

-- 		select * from public.tbl_web_street_arms limit 10;
-- 		select * from public.shp_street_lights limit 10;
--      select * from tbl_error_log order by created_on desc limit 10
--      SELECT * FROM fn_web_insert_streetlight_arms('{"street_arm_id":12,"position":"left","status":"false","width":"4","status_ON_OFF":"ON"}');

		jsonObject := cast(jsonArray AS JSON) :: JSON;
		RAISE NOTICE 'value of a%',jsonObject ;
		
		pole_arms_json := jsonObject ->> 'pole_arms';
		RAISE NOTICE 'value of a:%',_gid ;
		
					_gid       := jsonObject ->> 'gid';
				_pole_id       := jsonObject ->> 'pole_id';
				_smart_asse    := jsonObject ->> 'smart_asse';
				_pole_type     := jsonObject ->> '_pole_type';
				_arrangemen    := jsonObject ->> 'arrangemen';
				_bracket_ty    := jsonObject ->> 'bracket_ty';
				_pole_heigh    := jsonObject ->> 'pole_heigh';
				_date_of_in    := jsonObject ->> 'date_of_in';
				_cost          := jsonObject ->> 'cost';
				_maintained    := jsonObject ->> 'maintained';
				_last_paint    := jsonObject ->> 'last_paint';
				_number_of_    := jsonObject ->> 'number_of_';
				_number_of1    := jsonObject ->> 'number_of1';
				_ploe_light    := jsonObject ->> 'ploe_light';
				_geom          := jsonObject ->> 'geom';
				_fitting_wa    := jsonObject ->> 'fitting_wa';
		
		IF _gid NOT NULL
		then --> update parent
			   	
				UPDATE public.shp_street_lights
	  			SET  
				pole_id     =_pole_id, 
				smart_asse  =_smart_asse, 
				pole_type   =_pole_type, 
				fitting_ty  =_fitting_ty, 
				arrangemen	=_arrangemen ,
				bracket_ty	=_bracket_ty, 
				pole_heigh	=_pole_heigh ,
				fitting_wa	=_fitting_wa ,
				date_of_in	=_date_of_in ,
				cost		=_cost, 
				pole_owner	=_pole_owner ,
				maintained	=_maintained ,
				last_paint	=_last_paint?, 
				number_of_	=_number_of_ ,
				number_of1	=_number_of1?, 
				ploe_light	=_ploe_light ,
				geom		=_geom
				WHERE gid=_gid;
				sql_query := 'SELECT json_build_object(''responseCode'',200,''responseMessage'',''shp_street_lights data updated successfully'',''status'',''success'')::text as data;';
				
				FOR i IN SELECT * FROM json_array_elements(pole_arms_json)
			    LOOP
			   			RAISE NOTICE 'output from space %', i->>'type';
							_street_arm_id            := i ->> 'street_arm_id';
							_street_light_arms_data   := i ->> 'data';
							_position                 := i ->> 'position';
							_width                    := i ->> 'width';
							_status_ON_OFF            := i ->> 'status_ON_OFF';
					
						IF _street_arm_id NOT NULL -->update child
						then

								UPDATE public.tbl_web_street_arms
								SET street_arm_id=_street_arm_id,
								gid=_gid,
								"position"=_position,
								width=_width, 
								status=_status, 
								"status_ON_OFF"=_status_ON_OFF
								 WHERE street_arm_id = _street_arm_id; 
								RAISE NOTICE 'update end' ;
								sql_query := 'SELECT json_build_object(''responseCode'',200,''responseMessage'',''tbl_web_street_arms data updated successfully'',''status'',''success'')::text as data;';

						ELSE -->insert data in child_tbl

								INSERT INTO public.tbl_web_street_arms(
										gid, "position", width, status, "status_ON_OFF")
								VALUES (_gid, _position,_width, _status, _status_ON_OFF);
								sql_query := 'SELECT json_build_object(''responseCode'',200,''responseMessage'',''tbl_web_street_arms data inserted successfully'',''status'',''success'')::text as data;';

						END IF;
			   
			   END LOOP;

		ELSE  -->insert parent
		
				 INSERT INTO public.shp_street_lights 
				 		(pole_id, smart_asse, pole_type, fitting_ty, arrangemen, bracket_ty, pole_heigh, fitting_wa, date_of_in, cost, pole_owner, maintained, last_paint, number_of_, number_of1, ploe_light, geom)
				 VALUES (_pole_id,_smart_asse, _pole_type, _fitting_ty, _arrangemen, _bracket_ty, _pole_heigh, _fitting_wa, _date_of_in, _cost, _pole_owner, _maintained, _last_paint, _number_of_, _number_of1, _ploe_light, _geom);
				 sql_query := 'SELECT json_build_object(''responseCode'',200,''responseMessage'',''data inserted in shp_street_lights'',''status'',''success'')::text as data;';
			 		
				 select gid from public.shp_street_lights where pole_id=pole_id;
					
			 	 FOR i IN SELECT * FROM json_array_elements(pole_arms_json)
				 LOOP --> insert child
							
							RAISE NOTICE 'output from space %', i->>'type';
							_street_arm_id            := i ->> 'street_arm_id';
							_street_light_arms_data   := i ->> 'data';
							_position                 := i ->> 'position';
							_width                    := i ->> 'width';
							_status_ON_OFF            := i ->> 'status_ON_OFF';
							
				 		INSERT INTO public.tbl_web_street_arms(
								gid, "position", width, status, "status_ON_OFF")
						VALUES (_gid, _position,_width, _status, _status_ON_OFF);
						
				 END LOOP;
				 sql_query := 'SELECT json_build_object(''responseCode'',200,''responseMessage'',''tbl_web_street_arms data inserted successfully'',''status'',''success'')::text as data;';
				 
		
		END IF;
	
		RETURN QUERY EXECUTE sql_query;
			EXCEPTION WHEN OTHERS 
		THEN
			DECLARE p_errormessage VARCHAR(4000);
			DECLARE p_errorstate VARCHAR(4000);
			DECLARE p_errorline VARCHAR(4000);
			BEGIN									
				p_errormessage:= SQLERRM;
				p_errorstate:= SQLSTATE;
				GET STACKED DIAGNOSTICS p_errorline = PG_EXCEPTION_CONTEXT;

				INSERT INTO tbl_error_log
				(
					error_name,error_callstack,error_method,created_on
				)		
				SELECT p_errorline,p_errormessage||'fn_web_insert_update_streetlight_arms',p_errorstate,timezone('Asia/Kolkata'::text, now());
				sql_query := 'SELECT json_build_object(''responseCode'',201,''responseMessage'',''failed'')::text as data';																					 
				RETURN QUERY EXECUTE sql_query;
			END;
			

	END;
$BODY$;

ALTER FUNCTION public.fn_web_insert_re_instegration_data(text)
    OWNER TO postgres;
