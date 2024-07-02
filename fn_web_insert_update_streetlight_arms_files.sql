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
    _smart_asse integer;
    _pole_type text;
    _arrangemen text;
    _bracket_ty text;
    _pole_heigh double precision;
    _date_of_in TIMESTAMP WITH TIME ZONE;
    _cost double precision;
    _pole_owner text;
    _maintained text;
    _last_paint TIMESTAMP WITH TIME ZONE;
    _number_of_ text;
    _number_of1 text;
    _ploe_light text;
    _geom text;
    _fitting_ty text;
    _fitting_wa double precision;
    
    _street_arm_id integer;
    _position text;
    _status boolean;
    _width integer;
    _status_on_off text;
    
    jsonObject JSON;
    pole_arms_json JSON;
    i JSON;
    sql_query text;
	 _street_arm_ids integer[]:= '{}';
	 _temp integer;
	 _delete_id integer;
    
BEGIN
    RAISE NOTICE 'start';

    jsonObject := CAST(jsonarray AS JSON);
    RAISE NOTICE 'value of jsonObject: %', jsonObject;
    
    pole_arms_json := jsonObject -> 'pole_arms';
    RAISE NOTICE 'value of pole_arms: %', pole_arms_json;
    
    _gid        := (jsonObject ->> 'gid')::integer;
    _pole_id    := jsonObject ->> 'pole_id';
    _smart_asse := (jsonObject ->> 'smart_asse')::integer;
    _pole_type  := jsonObject ->> 'pole_type';
    _arrangemen := jsonObject ->> 'arrangemen';
    _bracket_ty := jsonObject ->> 'bracket_ty';
    _pole_heigh := (jsonObject ->> 'pole_heigh')::double precision;
    _date_of_in := jsonObject ->> 'date_of_in';
    _cost       := (jsonObject ->> 'cost')::double precision;
    _pole_owner := jsonObject ->> 'pole_owner';
    _maintained := jsonObject ->> 'maintained';
    _last_paint := jsonObject ->> 'last_paint';
    _number_of_ := jsonObject ->> 'number_of_';
    _number_of1 := jsonObject ->> 'number_of1';
    _ploe_light := jsonObject ->> 'ploe_light';
    _geom       := jsonObject ->> 'geom';
    _fitting_ty := jsonObject ->> 'fitting_type';
    _fitting_wa := (jsonObject ->> 'fitting_wa')::double precision;

    IF _gid IS NOT NULL THEN
          RAISE NOTICE 'parent update';
        UPDATE public.shp_street_lights
        SET 
            pole_id     = _pole_id,
            smart_asse  = _smart_asse,
            pole_type   = _pole_type,
            fitting_ty  = _fitting_ty,
            arrangemen  = _arrangemen,
            bracket_ty  = _bracket_ty,
            pole_heigh  = _pole_heigh,
            fitting_wa  = _fitting_wa,
            date_of_in  = _date_of_in,
            cost        = _cost,
            pole_owner  = _pole_owner,
            maintained  = _maintained,
            last_paint  = _last_paint,
            number_of_  = _number_of_,
            number_of1  = _number_of1,
            ploe_light  = _ploe_light,
            geom        = _geom
        WHERE gid = _gid;

       sql_query := 'SELECT json_build_object(''responseCode'', 200, ''responseMessage'', ''shp_street_lights data updated successfully'', ''status'', ''success'')::text as data';
        RAISE NOTICE 'parent update';
		
		delete from tbl_web_street_arms where gid=_gid;
		RAISE NOTICE 'child items deleted';
        
		FOR i IN SELECT * FROM json_array_elements(pole_arms_json)
        LOOP
            _street_arm_id := (i ->> 'street_arm_id')::integer;
            _position      := i ->> 'position';
            _width         := (i ->> 'width')::integer;
            _status        := (i ->> 'status')::boolean;
            _status_on_off := i ->> 'status_on_off';

            IF _street_arm_id IS NOT NULL THEN
				RAISE NOTICE '_street_arm_id:%',_street_arm_id;
			    RAISE NOTICE 'child update';
			   
                UPDATE public.tbl_web_street_arms
                SET 
                    --gid = _gid,
                    position = _position,
                    width = _width,
                    status = _status,
                    status_ON_OFF = _status_on_off
                WHERE street_arm_id = _street_arm_id;
--                 sql_query := 'SELECT json_build_object(''responseCode'', 200, ''responseMessage'', ''tbl_web_street_arms data updated successfully'', ''status'', ''success'')::text as data';
            	  RAISE NOTICE 'child update';
			ELSE
				
						
				RAISE NOTICE 'child insert';
                INSERT INTO public.tbl_web_street_arms (
                    gid, position, width, status, status_on_off
                ) VALUES (
                    _gid, _position, _width, _status, _status_on_off
                );
				
				
				RAISE NOTICE 'child insert';
                 
			END IF;
        END LOOP;
		 sql_query := 'SELECT json_build_object(''responseCode'', 200, ''responseMessage'', ''tbl_web_street_arms data updated successfully'', ''status'', ''success'')::text as data';
    ELSE
        RAISE NOTICE 'new data insert in parent';
        INSERT INTO public.shp_street_lights (
            pole_id, smart_asse, pole_type, fitting_ty, arrangemen, bracket_ty, pole_heigh, fitting_wa, date_of_in, cost, pole_owner, maintained, last_paint, number_of_, number_of1, ploe_light, geom
        ) VALUES (
            _pole_id, _smart_asse, _pole_type, _fitting_ty, _arrangemen, _bracket_ty, _pole_heigh, _fitting_wa, _date_of_in, _cost, _pole_owner, _maintained, _last_paint, _number_of_, _number_of1, _ploe_light, _geom
        )
        RETURNING gid INTO _gid;

       sql_query := 'SELECT json_build_object(''responseCode'', 200, ''responseMessage'', ''data inserted in shp_street_lights'', ''status'', ''success'')::text as data';
         RAISE NOTICE 'new data insert in parent';
        FOR i IN SELECT * FROM json_array_elements(pole_arms_json)
        LOOP
            _position      := i ->> 'position';
            _width         := (i ->> 'width')::integer;
            _status        := (i ->> 'status')::boolean;
            _status_on_off := i ->> 'status_on_off';
			 RAISE NOTICE 'new data insert in parent';
            INSERT INTO public.tbl_web_street_arms (
                gid, position, width, status, status_on_off
            ) VALUES (
                _gid, _position, _width, _status, _status_on_off
            );

--             sql_query := 'SELECT json_build_object(''responseCode'', 200, ''responseMessage'', ''tbl_web_street_arms data inserted successfully'', ''status'', ''success'')::text as data';
        	 RAISE NOTICE 'new data insert in parent';
		END LOOP;
    END IF;		 

    RETURN QUERY EXECUTE sql_query;

EXCEPTION
    WHEN OTHERS THEN
        DECLARE
            p_errormessage VARCHAR(4000);
            p_errorstate VARCHAR(4000);
            p_errorline VARCHAR(4000);
        BEGIN
            p_errormessage := SQLERRM;
            p_errorstate := SQLSTATE;
            GET STACKED DIAGNOSTICS p_errorline = PG_EXCEPTION_CONTEXT;

            INSERT INTO tbl_error_log (
                error_name, error_callstack, error_method, created_on
            ) VALUES (
                p_errorline, p_errormessage || 'fn_web_insert_update_streetlight_arms', p_errorstate, timezone('Asia/Kolkata'::text, now())
            );

            sql_query := 'SELECT json_build_object(''responseCode'', 201, ''responseMessage'', ''failed'')::text as data';
            RETURN QUERY EXECUTE sql_query;
        END;
END;
$BODY$;
